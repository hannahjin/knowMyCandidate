#import "KMCNewsfeedViewController.h"

#import "KMCAssets.h"
#import "KMCNewsfeedCollectionViewCell.h"
#import "KMCTwitterCollectionViewCell.h"
#import "Parse/Parse.h"

@import SafariServices;

@interface KMCNewsfeedViewController () <UICollectionViewDelegateFlowLayout>
@end

@implementation KMCNewsfeedViewController {
  UIRefreshControl *_refreshControl;
  NSArray *_newsfeedItems;
  NSMutableDictionary *_newsfeedPictures;
}

static NSString *const newsfeedReuseIdentifier = @"kNewsfeedCollectionViewCell";
static NSString *const twitterReuseIdentifier = @"kTwitterCollectionViewCell";

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
  self = [super initWithCollectionViewLayout:layout];
  if (self) {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;

    UITabBarItem *item = [self tabBarItem];
    item.title = @"Newsfeed";
    item.image = [KMCAssets homeTabIcon];

    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self
                        action:@selector(getNewsfeedItems)
              forControlEvents:UIControlEventValueChanged];

    _newsfeedPictures = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.collectionView registerClass:[KMCNewsfeedCollectionViewCell class]
          forCellWithReuseIdentifier:newsfeedReuseIdentifier];
  [self.collectionView registerClass:[KMCTwitterCollectionViewCell class]
          forCellWithReuseIdentifier:twitterReuseIdentifier];

  self.collectionView.alwaysBounceVertical = YES;
  self.collectionView.backgroundColor = [UIColor whiteColor];
  self.navigationItem.title = @"Newsfeed";

  UICollectionViewFlowLayout *layout =
      (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
  layout.minimumInteritemSpacing = 0.f;
  layout.minimumLineSpacing = 0.f;

  [self.collectionView addSubview:_refreshControl];
  [self getNewsfeedItems];
}

- (void)getNewsfeedItems {
  [_refreshControl beginRefreshing];
  [PFCloud callFunctionInBackground:@"get_newsfeed"
                     withParameters:@{ @"user" : [PFUser currentUser].objectId }
                              block:^(id object, NSError *error) {
    if (!error) {
      _newsfeedItems = object;
      [_newsfeedPictures removeAllObjects];
      [self.collectionView reloadData];
      [_refreshControl endRefreshing];
    }
  }];
}

- (void)scrollToTop {
  [self.collectionView setContentOffset:CGPointZero animated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return [_newsfeedItems count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  NSDictionary *dict = _newsfeedItems[indexPath.item];
  NSString *source = dict[@"source"];

  NSDate *date = dict[@"date"];
  NSTimeInterval timeInterval = [date timeIntervalSinceNow];
  NSString *timestamp = [self formatTimeInterval:timeInterval];

  if (![source isEqualToString:@"Twitter"]) {
    KMCNewsfeedCollectionViewCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:newsfeedReuseIdentifier
                                                  forIndexPath:indexPath];

    cell.source = source;
    cell.title = dict[@"title"];
    cell.subtitle = dict[@"summary"];
    cell.candidateName = dict[@"candidateID"];
    cell.timestamp = timestamp;

    NSNumber *number = [NSNumber numberWithInteger:indexPath.item];
    if (_newsfeedPictures[number]) {
      cell.thumbnail = _newsfeedPictures[number];
    } else {
      dispatch_queue_t queue = dispatch_queue_create("com.KMC.imageExtract", NULL);
      dispatch_async(queue, ^{
        PFFile *file = dict[@"thumbnail"];
        NSData *data = [file getData];
        UIImage *image = [UIImage imageWithData:data];

        dispatch_async(dispatch_get_main_queue(), ^{
          NSNumber *number = [NSNumber numberWithInteger:indexPath.item];
          _newsfeedPictures[number] = image;
          cell.thumbnail = image;
        });
      });
    }

    return cell;
  } else {
    KMCTwitterCollectionViewCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:twitterReuseIdentifier
                                                  forIndexPath:indexPath];
    cell.summary = dict[@"summary"];
    cell.candidateName = dict[@"candidateID"];
    cell.timestamp = timestamp;
    cell.twitterID = dict[@"twitterUsername"];

    NSNumber *number = [NSNumber numberWithInteger:indexPath.item];
    if (_newsfeedPictures[number]) {
      cell.thumbnail = _newsfeedPictures[number];
    } else {
      dispatch_queue_t queue = dispatch_queue_create("com.KMC.imageExtract", NULL);
      dispatch_async(queue, ^{
        PFFile *file = dict[@"thumbnail"];
        NSData *data = [file getData];
        UIImage *image = [UIImage imageWithData:data];

        dispatch_async(dispatch_get_main_queue(), ^{
          NSNumber *number = [NSNumber numberWithInteger:indexPath.item];
          _newsfeedPictures[number] = image;
          cell.thumbnail = image;
        });
      });
    }

    return cell;
  }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  NSDictionary *dict = _newsfeedItems[indexPath.item];
  NSString *source = dict[@"source"];
  NSString *summary = dict[@"summary"];

  if ([source isEqualToString:@"Twitter"]) {
    // Keep in sync with metrics from KMCTwitterCollectionViewCell.
    CGFloat width = CGRectGetWidth(self.collectionView.frame) - 75.f;
    UIFont *font = [UIFont systemFontOfSize:13.f];
    CGRect frame = [summary boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{ NSFontAttributeName : font }
                                         context:nil];
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), 65.f + frame.size.height);
  } else {
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), 170.f);
  }
}

- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  NSDictionary *dict = _newsfeedItems[indexPath.item];
  NSString *string = dict[@"url"];
  NSURL *url = [NSURL URLWithString:string];
  SFSafariViewController *webVC = [[SFSafariViewController alloc] initWithURL:url];
  [self presentViewController:webVC animated:YES completion:nil];
}

- (NSString *)formatTimeInterval:(NSTimeInterval)timeInterval {
  NSInteger interval = timeInterval * -1;
  NSString *toAppend = @"s";
  if (interval >= 60 && interval < 3600) {
    interval /= 60;
    toAppend = @"m";
  } else if (interval >= 3600 && interval < 86400) {
    interval /= 3600;
    toAppend = @"h";
  } else {
    interval /= 86400;
    toAppend = @"d";
  }

  return [NSString stringWithFormat:@"%li%@", interval, toAppend];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  [self.collectionView sendSubviewToBack:_refreshControl];
}

@end
