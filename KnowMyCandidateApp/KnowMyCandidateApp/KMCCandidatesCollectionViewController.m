#import "KMCCandidatesCollectionViewController.h"

#import "KMCAssets.h"
#import "KMCCandidatesCollectionViewCell.h"
#import "KMCCandidateProfileViewController.h"
#import "Parse/Parse.h"

static NSString *const reuseIdentifier = @"kCandidatesCollectionViewCell";

static const CGFloat kCellHeight = 90.f;
static const CGFloat kCellPadding = 2.f;
static const CGFloat kInterCellPadding = 2.f;

@interface KMCCandidatesCollectionViewController ()
@end

@implementation KMCCandidatesCollectionViewController {
  UIRefreshControl *_refreshControl;
  NSArray *_modelArray; // of PFObject.
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
  self = [super initWithCollectionViewLayout:layout];
  if (self) {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = YES;

    UITabBarItem *item = [self tabBarItem];
    item.title = @"Candidates";
    item.image = [KMCAssets candidatesTabIcon];

    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self
                        action:@selector(getCandidates)
              forControlEvents:UIControlEventValueChanged];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.collectionView.backgroundColor = [UIColor whiteColor];
  self.navigationItem.title = @"Candidates";

  [self.collectionView registerClass:[KMCCandidatesCollectionViewCell class]
          forCellWithReuseIdentifier:reuseIdentifier];

  self.collectionView.alwaysBounceVertical = YES;

  // Defining layout attributes.
  UICollectionViewFlowLayout *layout =
      (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
  layout.itemSize = CGSizeMake(self.view.bounds.size.width - (2 * kCellPadding), kCellHeight);
  layout.sectionInset =
      UIEdgeInsetsMake(kInterCellPadding, kCellPadding, kInterCellPadding, kCellPadding);
  layout.minimumLineSpacing = kInterCellPadding;

  _refreshControl.frame = self.collectionView.frame;
  [self.collectionView addSubview:_refreshControl];
  [self getCandidates];
}

- (void)getCandidates {
  [_refreshControl beginRefreshing];
  PFQuery *query = [PFQuery queryWithClassName:@"Candidate"];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
      _modelArray = objects;
      PFUser *user = [PFUser currentUser];
      NSArray *candidatesFollowed = [user objectForKey:kCandidatesFollowedKey];
      NSString *affiliation = [user objectForKey:@"affiliation"];
      _modelArray = [_modelArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        PFObject *object1 = (PFObject *)obj1;
        PFObject *object2 = (PFObject *)obj2;
        NSNumber *checkObject1 = [object1 objectForKey:@"hasDroppedOut"];
        NSNumber *checkObject2 = [object2 objectForKey:@"hasDroppedOut"];
        NSString *party1 = [object1 objectForKey:@"PartyAffiliation"];
        NSString *party2 = [object2 objectForKey:@"PartyAffiliation"];

        // Sort by candidates followed by user.
        if ([candidatesFollowed containsObject:object1.objectId]) {
          return NSOrderedAscending;
        } else if ([candidatesFollowed containsObject:object2.objectId]) {
          return NSOrderedDescending;
        }

        // If candidate has dropped out.
        if ([checkObject1 boolValue]) {
          return NSOrderedDescending;
        } else if ([checkObject2 boolValue]) {
          return NSOrderedAscending;
        }

        // Sort by party affiliation of user.
        if ([party1 containsString:affiliation]) {
          return NSOrderedAscending;
        } else if ([party2 containsString:affiliation]) {
          return NSOrderedDescending;
        }

        return NSOrderedSame;
      }];
      [_refreshControl endRefreshing];
      [self.collectionView reloadData];
    }
  }];
}

- (void)scrollToTop {
  [self.collectionView setContentOffset:CGPointZero animated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return [_modelArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  KMCCandidatesCollectionViewCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                forIndexPath:indexPath];

  PFObject *object = _modelArray[indexPath.item];
  NSString *firstName = object[@"firstName"];
  NSString *lastName = object[@"lastName"];
  NSString *name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];

  NSString *party = object[@"PartyAffiliation"];
  KMCPartyAffiliation affiliation;
  if ([party isEqualToString:@"Republican Party"]) {
    affiliation = KMCPartyAffiliationRepublican;
  } else if ([party isEqualToString:@"Democratic Party"]) {
    affiliation = KMCPartyAffiliationDemocratic;
  } else {
    affiliation = KMCPartyAffiliationGreen;
  }

  NSNumber *number = [object objectForKey:@"hasDroppedOut"];

  cell.candidateID = object.objectId;
  cell.name = name;
  cell.affiliation = affiliation;
  cell.experience = object[@"Experience"];
  cell.hasDroppedOut = [number boolValue];

  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  PFObject *object = _modelArray[indexPath.item];
  KMCCandidateProfileViewController *vc =
      [[KMCCandidateProfileViewController alloc] initWithCandidateObject:object];
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  [self.collectionView sendSubviewToBack:_refreshControl];
}

@end

