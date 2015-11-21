#import "KMCIssuesCollectionViewController.h"

#import "KMCAssets.h"
#import "KMCIssuesCollectionViewCell.h"
#import "KMCIssueViewController.h"
#import "Parse/Parse.h"

static NSString *const reuseIdentifier = @"kIssuesCollectionViewCell";

static const CGFloat kCellHeight = 140.f;
static const CGFloat kCellWidth = 180.f;

@interface KMCIssuesCollectionViewController ()
@end

@implementation KMCIssuesCollectionViewController {
  UIRefreshControl *_refreshControl;
  NSArray *_modelArray;
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
  self = [super initWithCollectionViewLayout:layout];
  if (self) {
    self.edgesForExtendedLayout = UIRectEdgeNone;

    UITabBarItem *item = [self tabBarItem];
    item.title = @"Issues";
    item.image = [KMCAssets issuesTabIcon];
      
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self
                        action:@selector(getIssues)
              forControlEvents:UIControlEventValueChanged];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.collectionView.backgroundColor = [UIColor whiteColor];
  
  [self.collectionView registerClass:[KMCIssuesCollectionViewCell class]
            forCellWithReuseIdentifier:reuseIdentifier];

  self.navigationItem.title = @"Issues";
    
  // Defining layout attributes.
  UICollectionViewFlowLayout *layout =
      (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
  layout.itemSize = CGSizeMake(kCellWidth, kCellHeight);
  CGFloat spacing = (CGRectGetWidth(self.view.frame) - 2*kCellWidth) / 3.f;
  layout.sectionInset = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
  layout.minimumLineSpacing = spacing;
  layout.minimumInteritemSpacing = 0.f;

  [self.collectionView addSubview:_refreshControl];
  [self getIssues];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  CGPoint point = self.collectionView.contentOffset;
  CGRect frame = _refreshControl.frame;
  frame.origin.y = point.y * -1;
  _refreshControl.frame = frame;
}

- (void)getIssues {
  [_refreshControl beginRefreshing];
  PFQuery *query = [PFQuery queryWithClassName:@"Issue"];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
      _modelArray = objects;
      [_refreshControl endRefreshing];
      [self.collectionView reloadData];
    }
  }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return [_modelArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  KMCIssuesCollectionViewCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                forIndexPath:indexPath];
  
  PFObject *object = _modelArray[indexPath.item];
  
  cell.issueID = object.objectId;
  cell.issueName = object[@"keywords"];
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  PFObject *object = _modelArray[indexPath.item];
  KMCIssueViewController *vc =
      [[KMCIssueViewController alloc] initWithIssueObject:object];
  [self.navigationController pushViewController:vc animated:YES];
}

@end

