#import "KMCSurveyResultsViewController.h"

#import "KMCSurveyResultsCollectionViewCell.h"
#import "KMCCandidateProfileViewController.h"
#import "KMCAssets.h"
#import "Parse/Parse.h"

static NSString *const reuseIdentifier = @"kSurveyResultsCollectionViewCell";

static const CGFloat kCellHeight = 90.f;
static const CGFloat kCellPadding = 2.f;
static const CGFloat kInterCellPadding = 2.f;

@interface KMCSurveyResultsViewController () <KMCSurveyResultsCollectionViewCellDelegate>
@end

@implementation KMCSurveyResultsViewController {
  NSArray *_candidateResults;
  NSMutableArray *_followArray;
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
  self = [super initWithCollectionViewLayout:layout];

  if (self) {
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(didTapDoneButton)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];

    self.collectionView.backgroundColor = [KMCAssets lightGrayBackgroundColor];
    self.navigationItem.title = @"Your Results";

    _followArray = [[NSMutableArray alloc] init];
  }

  return self;
}


- (void)viewDidLoad {
  [super viewDidLoad];
  PFUser *user = [PFUser currentUser];
  [PFCloud callFunctionInBackground:@"get_survey_candidates"
                     withParameters:@{ @"user" : user.objectId }
                              block:^(id object, NSError *error) {
   if (!error) {
    _candidateResults = object;
    [self.collectionView reloadData];
  }
}];

  [self.collectionView registerClass:[KMCSurveyResultsCollectionViewCell class]
          forCellWithReuseIdentifier:reuseIdentifier];

  // Defining layout attributes.
  UICollectionViewFlowLayout *layout =
      (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
  layout.itemSize = CGSizeMake(self.view.bounds.size.width - (2 * kCellPadding), kCellHeight);
  layout.sectionInset =
      UIEdgeInsetsMake(kInterCellPadding, kCellPadding, kInterCellPadding, kCellPadding);
  layout.minimumLineSpacing = kInterCellPadding;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return [_candidateResults count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  KMCSurveyResultsCollectionViewCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                forIndexPath:indexPath];

  NSDictionary *object = _candidateResults[indexPath.item];
  NSString *firstName = object[@"firstName"];
  NSString *lastName = object[@"lastName"];
  NSString *name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];

  NSString *candidateID = object[@"candidate"];
  cell.delegate = self;
  cell.matchingScore = object[@"score"];
  cell.candidateID = candidateID;
  cell.rank = indexPath.item + 1;
  cell.name = name;
  if ([_followArray containsObject:candidateID]) {
    cell.isFollowing = YES;
  } else {
    cell.isFollowing = NO;
  }

  return cell;
}

//- (void)collectionView:(UICollectionView *)collectionView
//    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//  NSDictionary *object = _candidateResults[indexPath.item];
//  KMCCandidateProfileViewController *vc =
//      [[KMCCandidateProfileViewController alloc] initWithCandidateObject:object];
//  [self.navigationController pushViewController:vc animated:YES];
//}

#pragma mark - Navigation

 - (void)didTapDoneButton {
  [self.delegate didFinishSurveyResults];
}

#pragma mark - KMCSurveyResultsCollectionViewCellDelegate

- (void)didFollowCandidate:(BOOL)didFollow withID:(NSString *)candidateID {
  if (didFollow) {
    [_followArray addObject:candidateID];
  } else {
    [_followArray removeObject:candidateID];
  }
}


@end
