#import "KMCCandidateProfileViewController.h"

#import "KMCAssets.h"
#import "KMCInfoCollectionViewCell.h"
#import "KMCStandpointsCollectionViewCell.h"
#import "Parse/Parse.h"

@import SafariServices;

NSString *const kCandidatesFollowedKey = @"candidatesFollowed";

static NSString *const infoReuseIdentifier = @"kInfoCollectionViewCell";
static NSString *const standpointReuseIdentifier = @"kStandpointsCollectionViewCell";

static const CGFloat kButtonTitleInset = 5.f;
static const CGFloat kHeaderViewHeight = 210.f;
static const CGFloat kInfoItemHeight = 45.f;
static const CGFloat kRightPadding = 20.f;
static const CGFloat kSegmentHeight = 30.f;
static const CGFloat kSegmentPadding = 5.f;
static const CGFloat kStandpointItemHeight = 60.f;
static const CGFloat kTopPadding = 20.f;
static const CGFloat kVerticalPadding = 10.f;

@interface KMCCandidateProfileViewController () <KMCInfoCollectionViewCellDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegate
>
@end

@implementation KMCCandidateProfileViewController {
  NSDictionary *_issues;
  NSDictionary *_infoTitleDict;
  NSArray *_infoKeysArray;
  PFObject *_candidateObject;
  UIView *_headerView;
  UIButton *_followButton;
  UISegmentedControl *_segmentPicker;
  UILabel *_nameLabel;
  UILabel *_experienceLabel;
  UICollectionView *_standpointsView;
  UICollectionView *_infoView;
}

- (instancetype)initWithCandidateObject:(PFObject *)object {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _candidateObject = object;

    // The keys for this are the keys in the Candidate object. This dictionary is a list of
    // fields that we want to display the information for. PLEASE KEEP THE KEYS IN SYNC WITH
    // the attribute names in Parse.
    _infoKeysArray = @[ @"PartyAffiliation",
                        @"Background",
                        @"HomeResidence",
                        @"TotalRaised",
                        @"Birthday",
                        @"Birthplace",
                        @"Religion",
                        @"Height"];
    _infoTitleDict = @{ @"PartyAffiliation" : @"Party Affiliation",
                        @"Background" : @"Background",
                        @"HomeResidence" : @"Residence",
                        @"TotalRaised" : @"Total raised",
                        @"Birthday" : @"Birthday",
                        @"Birthplace" : @"Birthplace",
                        @"Religion" : @"Religion",
                        @"Height" : @"Height",
                      };

    [self getIssueDictionary];

    _headerView = [[UIView alloc] init];

    _followButton = [[UIButton alloc] init];
    PFUser *user = [PFUser currentUser];
    NSArray *candidatesFollowed = [user objectForKey:kCandidatesFollowedKey];
    if ([candidatesFollowed containsObject:_candidateObject.objectId]) {
      [_followButton setTitle:@"Following" forState:UIControlStateNormal];
      [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      _followButton.backgroundColor = [KMCAssets lightBlueColor];
    } else {
      [_followButton setTitle:@"Follow" forState:UIControlStateNormal];
      [_followButton setTitleColor:[KMCAssets lightBlueColor] forState:UIControlStateNormal];
      _followButton.backgroundColor = [UIColor whiteColor];
    }
    _followButton.layer.cornerRadius = 5.f;
    _followButton.layer.borderColor = [KMCAssets lightBlueColor].CGColor;
    _followButton.layer.borderWidth = 2.f;
    _followButton.titleEdgeInsets =
        UIEdgeInsetsMake(0.f, kButtonTitleInset, 0.f, kButtonTitleInset);
    [_followButton addTarget:self
                      action:@selector(didTapFollowButton)
            forControlEvents:UIControlEventTouchUpInside];

    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:18.f weight:0.4f];
    _nameLabel.textColor = [UIColor whiteColor];

    _experienceLabel = [[UILabel alloc] init];
    _experienceLabel.font = [UIFont systemFontOfSize:14.f];
    _experienceLabel.textColor = [UIColor whiteColor];

    _segmentPicker = [[UISegmentedControl alloc] initWithItems:@[ @"Information", @"Standpoints" ]];
    _segmentPicker.selectedSegmentIndex = 0;
    [_segmentPicker addTarget:self
                       action:@selector(didTapSegmentPicker)
             forControlEvents:UIControlEventValueChanged];

    UICollectionViewFlowLayout *standpointsLayout = [[UICollectionViewFlowLayout alloc] init];
    _standpointsView =
        [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:standpointsLayout];
    _standpointsView.dataSource = self;
    _standpointsView.delegate = self;
    _standpointsView.backgroundColor = [UIColor whiteColor];

    UICollectionViewFlowLayout *infoLayout = [[UICollectionViewFlowLayout alloc] init];
    _infoView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:infoLayout];
    _infoView.dataSource = self;
    _infoView.delegate = self;
    _infoView.backgroundColor = [UIColor whiteColor];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  UIView *view = self.view;

  view.backgroundColor = [UIColor whiteColor];

  NSString *firstName = _candidateObject[@"firstName"];
  NSString *lastName = _candidateObject[@"lastName"];
  NSString *name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
  self.navigationItem.title = name;

  [self setUpHeaderView];
  [view addSubview:_headerView];

  CGRect frame = _segmentPicker.frame;
  frame.origin.x = kSegmentPadding;
  frame.origin.y = kSegmentPadding + CGRectGetMaxY(_headerView.frame);
  frame.size.height = kSegmentHeight;
  frame.size.width = CGRectGetWidth(view.frame) - 2 * kSegmentPadding;
  _segmentPicker.frame = frame;
  [view addSubview:_segmentPicker];

  UICollectionViewFlowLayout *layout =
      (UICollectionViewFlowLayout *)_standpointsView.collectionViewLayout;
  layout.itemSize = CGSizeMake(CGRectGetWidth(view.frame), kStandpointItemHeight);
  layout.minimumLineSpacing = 0.f;
  [_standpointsView registerClass:[KMCStandpointsCollectionViewCell class]
       forCellWithReuseIdentifier:standpointReuseIdentifier];

  layout = (UICollectionViewFlowLayout *)_infoView.collectionViewLayout;
  layout.itemSize = CGSizeMake(CGRectGetWidth(view.frame), kInfoItemHeight);
  layout.minimumLineSpacing = 0.f;
  [_infoView registerClass:[KMCInfoCollectionViewCell class]
        forCellWithReuseIdentifier:infoReuseIdentifier];
  [view addSubview:_infoView];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];

  CGRect frame;
  frame.origin.x = 0.f;
  frame.origin.y = CGRectGetMaxY(_segmentPicker.frame) + kSegmentPadding;
  frame.size.width = CGRectGetWidth(self.view.frame);
  CGFloat tabHeight = self.tabBarController.tabBar.frame.size.height;
  frame.size.height = CGRectGetHeight(self.view.frame) -
                      CGRectGetMaxY(_segmentPicker.frame) -
                      kSegmentPadding -
                      tabHeight;
  _standpointsView.frame = frame;
  _infoView.frame = frame;
}

- (void)setUpHeaderView {
  CGRect frame = CGRectMake(0.f, 0.f, CGRectGetWidth(self.view.frame), kHeaderViewHeight);
  _headerView.frame = frame;
  _headerView.backgroundColor = [KMCAssets partyColorForAffiliation:[self getAffiliation]];

  NSString *firstName = _candidateObject[@"firstName"];
  NSString *lastName = _candidateObject[@"lastName"];
  NSString *name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
  UIImageView *imageView = [[UIImageView alloc] initWithImage:[KMCAssets pictureForCandidate:name]];
  frame = imageView.frame;
  frame.origin.x = CGRectGetMidX(self.view.frame) - (CGRectGetWidth(frame)) / 2.f;
  frame.origin.y = kTopPadding;
  imageView.frame = frame;
  [_headerView addSubview:imageView];

  _nameLabel.text = name;
  [_nameLabel sizeToFit];
  frame = _nameLabel.frame;
  frame.origin.x = CGRectGetMidX(self.view.frame) - CGRectGetWidth(frame) / 2.f;
  frame.origin.y = CGRectGetMaxY(imageView.frame) + kVerticalPadding;
  _nameLabel.frame = frame;
  [_headerView addSubview:_nameLabel];

  _experienceLabel.text = _candidateObject[@"Experience"];
  [_experienceLabel sizeToFit];
  frame = _experienceLabel.frame;
  frame.origin.x = CGRectGetMidX(self.view.frame) - CGRectGetWidth(frame) / 2.f;
  frame.origin.y = CGRectGetMaxY(_nameLabel.frame) + kVerticalPadding / 2.f;
  _experienceLabel.frame = frame;
  [_headerView addSubview:_experienceLabel];

  [_followButton sizeToFit];
  frame = _followButton.frame;
  frame.origin.y = kTopPadding;
  frame.origin.x =
      CGRectGetWidth(self.view.frame) - kRightPadding - CGRectGetWidth(_followButton.frame);
  frame.size.width += 2 * kButtonTitleInset;
  _followButton.frame = frame;
  [_headerView addSubview:_followButton];
}

- (void)didTapSegmentPicker {
  if (_segmentPicker.selectedSegmentIndex == 0) {
    [_standpointsView removeFromSuperview];
    [self.view addSubview:_infoView];
  } else {
    [_infoView removeFromSuperview];
    [self.view addSubview:_standpointsView];
  }
}

- (void)didTapFollowButton {
  PFUser *user = [PFUser currentUser];
  NSMutableArray *candidatesFollowed = [[user objectForKey:kCandidatesFollowedKey] mutableCopy];
  if (!candidatesFollowed) {
    candidatesFollowed = [[NSMutableArray alloc] init];
  }
  _followButton.enabled = NO;

  if ([_followButton.titleLabel.text isEqualToString:@"Follow"]) {
    [candidatesFollowed addObject:_candidateObject.objectId];
    [user setObject:[candidatesFollowed copy] forKey:kCandidatesFollowedKey];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
      [_followButton setTitle:@"Following" forState:UIControlStateNormal];
      [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      _followButton.backgroundColor = [KMCAssets lightBlueColor];
      [_followButton sizeToFit];
      CGRect frame = _followButton.frame;
      frame.origin.x =
          CGRectGetWidth(self.view.frame) - kRightPadding - CGRectGetWidth(_followButton.frame);
      frame.size.width += 2 * kButtonTitleInset;
      _followButton.frame = frame;
      _followButton.enabled = YES;
    }];
  } else {
    [candidatesFollowed removeObject:_candidateObject.objectId];
    [user setObject:[candidatesFollowed copy] forKey:kCandidatesFollowedKey];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
      [_followButton setTitle:@"Follow" forState:UIControlStateNormal];
      [_followButton setTitleColor:[KMCAssets lightBlueColor] forState:UIControlStateNormal];
      _followButton.backgroundColor = [UIColor whiteColor];
      [_followButton sizeToFit];
      CGRect frame = _followButton.frame;
      frame.origin.x =
          CGRectGetWidth(self.view.frame) - kRightPadding - CGRectGetWidth(_followButton.frame);
      frame.size.width += 2 * kButtonTitleInset;
      _followButton.frame = frame;
      _followButton.enabled = YES;
    }];
  }
}

- (void)getIssueDictionary {
  PFQuery *query = [PFQuery queryWithClassName:@"Issue"];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
      NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
      for (PFObject *object in objects) {
        dict[object.objectId] = object[@"topic"];
      }
      _issues = [dict copy];
    }
    [_standpointsView reloadData];
  }];
}

- (KMCPartyAffiliation)getAffiliation {
  NSString *party = _candidateObject[@"PartyAffiliation"];
  if ([party isEqualToString:@"Republican Party"]) {
    return KMCPartyAffiliationRepublican;
  } else if ([party isEqualToString:@"Democratic Party"]) {
    return KMCPartyAffiliationDemocratic;
  } else {
    return KMCPartyAffiliationGreen;
  }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  if ([collectionView isEqual:_standpointsView]) {
    NSArray *array = _candidateObject[@"Issues"];
    return [array count];
  } else {
    return [_infoTitleDict count] + 1;
  }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  if ([collectionView isEqual:_standpointsView]) {
    KMCStandpointsCollectionViewCell *cell =
        (KMCStandpointsCollectionViewCell *)
            [collectionView dequeueReusableCellWithReuseIdentifier:standpointReuseIdentifier
                                                      forIndexPath:indexPath];

    NSArray *array = _candidateObject[@"Issues"];
    NSDictionary *dict = array[indexPath.item];
    NSString *id = [dict allKeys][0];

    cell.issue = _issues[id];
    cell.stand = [dict allValues][0];

    return cell;
  } else {
    KMCInfoCollectionViewCell *cell =
        (KMCInfoCollectionViewCell *)
            [collectionView dequeueReusableCellWithReuseIdentifier:infoReuseIdentifier
                                                      forIndexPath:indexPath];
    cell.delegate = self;

    if (indexPath.item != [_infoTitleDict count]) {
      NSString *key = _infoKeysArray[indexPath.item];
      NSString *value = _candidateObject[key];
      cell.title = _infoTitleDict[key];
      cell.subtitle = value;
    } else {
      // Links cell
      cell.title = @"Links";
      cell.fbLink = _candidateObject[@"FacebookPage"];
      cell.webLink = _candidateObject[@"MainWebsite"];
    }

    return cell;
  }
}

#pragma mark - KMCInfoCollectionViewCollDelegate

- (void)openUrl:(NSURL *)url {
  SFSafariViewController *webVC = [[SFSafariViewController alloc] initWithURL:url];
  [self presentViewController:webVC animated:YES completion:nil];
}

@end
