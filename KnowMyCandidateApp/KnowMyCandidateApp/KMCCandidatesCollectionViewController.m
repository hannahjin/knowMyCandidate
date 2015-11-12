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

  // Defining layout attributes.
  UICollectionViewFlowLayout *layout =
      (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
  layout.itemSize = CGSizeMake(self.view.bounds.size.width - (2 * kCellPadding), kCellHeight);
  layout.sectionInset =
      UIEdgeInsetsMake(kInterCellPadding, kCellPadding, kInterCellPadding, kCellPadding);
  layout.minimumLineSpacing = kInterCellPadding;

  [self.collectionView addSubview:_refreshControl];
  [self getCandidates];
}

- (void)getCandidates {
  [_refreshControl beginRefreshing];
  PFQuery *query = [PFQuery queryWithClassName:@"Candidate"];
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

  cell.candidateID = object.objectId;
  cell.name = name;
  cell.affiliation = affiliation;
  cell.experience = object[@"Experience"];

  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  PFObject *object = _modelArray[indexPath.item];
  KMCCandidateProfileViewController *vc =
      [[KMCCandidateProfileViewController alloc] initWithCandidateObject:object];
  [self.navigationController pushViewController:vc animated:YES];
}

@end

