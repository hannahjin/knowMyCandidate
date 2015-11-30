#import "KMCUserProfileViewController.h"

#import "KMCAssets.h"
#import "KMCInfoCollectionViewCell.h"
#import "KMCStandpointsCollectionViewCell.h"
#import "FBSDKCoreKit/FBSDKCoreKit.h"
#import "Parse/Parse.h"

static const CGFloat kProfilePictureSize = 130.f;
static const CGFloat kTopPadding = 25.f;
static const CGFloat kHeaderViewHeight = 205.f;
static const CGFloat kInfoItemHeight = 45.f;
static const CGFloat kSegmentHeight = 30.f;
static const CGFloat kSegmentPadding = 5.f;
static const CGFloat kStandpointItemHeight = 60.f;
static const CGFloat kVerticalPadding = 5.f;

static NSString *const infoReuseIdentifier = @"kInfoCollectionViewCell";
static NSString *const standpointReuseIdentifier = @"kStandpointsCollectionViewCell";

@interface KMCUserProfileViewController () <UICollectionViewDataSource,
    UICollectionViewDelegate
>
@end

@implementation KMCUserProfileViewController {
  UIButton *_logOutButton;
  FBSDKProfilePictureView *_profilePictureView;
  UILabel *_nameLabel;
  NSDictionary *_infoTitleDict;
  NSArray *_infoKeysArray;
  UIView *_headerView;
  UISegmentedControl *_segmentPicker;
  UICollectionView *_standpointsView;
  UICollectionView *_infoView;
  NSDictionary *_issues;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    UITabBarItem *item = [self tabBarItem];
    item.title = @"User";
    item.image = [KMCAssets userTabIcon];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"Log Out"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(didTapLogOut)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];

    _logOutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_logOutButton setTitle:@"Log out" forState:UIControlStateNormal];

    [_logOutButton addTarget:self
                      action:@selector(didTapLogOut)
            forControlEvents:UIControlEventTouchUpInside];

    _infoKeysArray = @[ @"age",
                        @"gender",
                        @"affiliation"
                      ];
    _infoTitleDict = @{ @"age" : @"Age",
                        @"gender" : @"Gender",
                        @"affiliation" : @"Affiliation"
                      };
    [self getIssueDictionary];

    _headerView = [[UIView alloc] init];
    [self setUpProfilePictureAndName];

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

  self.navigationItem.title = @"User";

  [self setUpHeaderView];
  [self.view addSubview:_headerView];

  CGRect frame = _segmentPicker.frame;
  frame.origin.x = kSegmentPadding;
  frame.origin.y = kSegmentPadding + CGRectGetMaxY(_headerView.frame);
  frame.size.height = kSegmentHeight;
  frame.size.width = CGRectGetWidth(self.view.frame) - 2 * kSegmentPadding;
  _segmentPicker.frame = frame;
  [self.view addSubview:_segmentPicker];

  UICollectionViewFlowLayout *layout =
      (UICollectionViewFlowLayout *)_standpointsView.collectionViewLayout;
  layout.itemSize = CGSizeMake(CGRectGetWidth(self.view.frame), kStandpointItemHeight);
  layout.minimumLineSpacing = 0.f;
  [_standpointsView registerClass:[KMCStandpointsCollectionViewCell class]
       forCellWithReuseIdentifier:standpointReuseIdentifier];

  layout = (UICollectionViewFlowLayout *)_infoView.collectionViewLayout;
  layout.itemSize = CGSizeMake(CGRectGetWidth(self.view.frame), kInfoItemHeight);
  layout.minimumLineSpacing = 0.f;
  [_infoView registerClass:[KMCInfoCollectionViewCell class]
    forCellWithReuseIdentifier:infoReuseIdentifier];
  [self.view addSubview:_infoView];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];

  CGRect frame;
  frame.origin.x = 0.f;
  frame.origin.y = CGRectGetMaxY(_segmentPicker.frame) + kSegmentPadding;
  frame.size.width = CGRectGetWidth(self.view.frame);
  frame.size.height = CGRectGetHeight(self.view.frame) -
                      CGRectGetMaxY(_segmentPicker.frame) -
                      kSegmentPadding;
  _standpointsView.frame = frame;
  _infoView.frame = frame;
}

- (void)didTapLogOut {
  UIActivityIndicatorView *indicator =
      [[UIActivityIndicatorView alloc]
          initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
  UIBarButtonItem *itemIndicator = [[UIBarButtonItem alloc] initWithCustomView:indicator];
  self.navigationItem.rightBarButtonItem = itemIndicator;
  [indicator startAnimating];
  [PFUser logOutInBackgroundWithBlock:^(NSError *error) {
    if (!error) {
      [[NSNotificationCenter defaultCenter] postNotificationName:@"kPFUserLogOut" object:nil];
    }
  }];
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

- (void)setUpHeaderView {
  CGRect frame = CGRectMake(0.f, 0.f, CGRectGetWidth(self.view.frame), kHeaderViewHeight);
  _headerView.frame = frame;
  _headerView.backgroundColor = [UIColor colorWithWhite:0.9f alpha:0.7f];

  _profilePictureView.layer.cornerRadius = kProfilePictureSize / 2.f;
  _profilePictureView.layer.masksToBounds = YES;

  frame = _profilePictureView.frame;
  frame.origin.x = CGRectGetMidX(self.view.frame) - (CGRectGetWidth(frame)) / 2.f;
  frame.origin.y = kTopPadding;
  frame.size.width = kProfilePictureSize;
  frame.size.height = kProfilePictureSize;
  _profilePictureView.frame = frame;
  [_headerView addSubview:_profilePictureView];

  [_nameLabel sizeToFit];
  frame = _nameLabel.frame;
  frame.origin.x = CGRectGetMidX(self.view.frame) - CGRectGetWidth(frame) / 2.f;
  frame.origin.y = CGRectGetMaxY(_profilePictureView.frame) + kVerticalPadding;
  _nameLabel.frame = frame;
  [_headerView addSubview:_nameLabel];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  if ([collectionView isEqual:_standpointsView]) {
    return [_issues count];
  } else {
    return [_infoTitleDict count];
  }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  if ([collectionView isEqual:_standpointsView]) {
    KMCStandpointsCollectionViewCell *cell =
        (KMCStandpointsCollectionViewCell *)
    [collectionView dequeueReusableCellWithReuseIdentifier:standpointReuseIdentifier
                                              forIndexPath:indexPath];

    NSDictionary *dict = [[PFUser currentUser] objectForKey:@"surveyAnswers"];
    NSString *id = [dict allKeys][indexPath.item];

    cell.issue = _issues[id];
    if (_issues) {
      NSNumber *number = dict[id];
      CGFloat score = [number floatValue];
      if (score >= 0.f && score < 1.f) {
        cell.stand = @"Strongly Disagrees";
      } else if (score < 2.f) {
        cell.stand = @"Disagrees";
      } else if (score <= 3.f) {
        cell.stand = @"Neutral/No opinion";
      } else if (score < 4.f) {
        cell.stand = @"Agrees";
      } else {
        cell.stand = @"Strongly Agrees";
      }
    }

    dict = [[PFUser currentUser] objectForKey:@"surveyAnswerWeights"];
    NSNumber *number = dict[id];
    CGFloat weight = [number floatValue];
    if (weight <= 2.f) {
      cell.isImportant = NO;
    } else {
      cell.isImportant = YES;
    }

    return cell;
  } else {
    KMCInfoCollectionViewCell *cell =
        (KMCInfoCollectionViewCell *)
    [collectionView dequeueReusableCellWithReuseIdentifier:infoReuseIdentifier
                                              forIndexPath:indexPath];

    NSString *key = _infoKeysArray[indexPath.item];
    cell.title = _infoTitleDict[key];
    id value = [[PFUser currentUser] objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
      NSNumber *number = value;
      cell.subtitle = [number stringValue];
    } else {
      cell.subtitle = (NSString *)value;
    }

    return cell;
  }
}

#pragma mark - Helper methods

- (void)setUpProfilePictureAndName {
  CGRect frame = CGRectMake(0.f, 0.f, kProfilePictureSize, kProfilePictureSize);
  _profilePictureView = [[FBSDKProfilePictureView alloc] initWithFrame:frame];
  _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];

  if ([FBSDKAccessToken currentAccessToken]) {
    FBSDKGraphRequest *request =
        [[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                          parameters:@{ @"fields" : @"id,name"}];
    [request startWithCompletionHandler:
        ^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
      if (!error) {
        _profilePictureView.profileID = [result valueForKey:@"id"];
        _nameLabel.text = [result valueForKey:@"name"];
        [self setUpHeaderView];
      }
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

@end
