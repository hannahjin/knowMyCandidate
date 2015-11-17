#import "KMCIssuesCollectionViewController.h"

#import "KMCAssets.h"
#import "KMCAssets.h"
#import "KMCIssuesCollectionViewCell.h"
#import "KMCIssuesViewController.h"
#import "Parse/Parse.h"

static NSString *const reuseIdentifier = @"kIssuesCollectionViewCell";

static const CGFloat kCellHeight = 180.f;
static const CGFloat kCellWidth = 183.f;
static const CGFloat kCellPadding = 5.f;
static const CGFloat kInterCellPadding = 3.f;

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
    
    // Defining layout attributes.
    UICollectionViewFlowLayout *layout =
    (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(kCellWidth - 2*kCellPadding, kCellHeight-2*kCellPadding);
    layout.sectionInset =
    UIEdgeInsetsMake(kCellPadding, kCellPadding, kCellPadding, kCellPadding);
    //layout.minimumLineSpacing = kInterCellPadding;
    
    [self.collectionView addSubview:_refreshControl];
    [self getIssues];
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
    KMCIssuesViewController *vc =
    [[KMCIssuesViewController alloc] initWithIssueObject:object];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

