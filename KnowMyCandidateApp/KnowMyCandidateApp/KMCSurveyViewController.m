#import "KMCSurveyViewController.h"

#import "KMCAssets.h"
#import "KMCSurveyCollectionViewCell.h"
#import "Parse/Parse.h"

NSString *const kSurveyAnswersKey = @"surveyAnswers";
NSString *const kSurveyAnswerWeightsKey = @"surveyAnswerWeights";

static const CGFloat kButtonHeight = 50.f;
static const CGFloat kCellPadding = 10.f;
static const CGFloat kCellHeight = 200.f;

static NSString *const reuseIdentifier = @"kSurveyCollectionViewCell";

@interface KMCSurveyViewController () <KMCSurveyCollectionViewCellDelegate>
@end

@implementation KMCSurveyViewController {
  BOOL _boundsChanged;
  BOOL _requestInFlight;
  NSDictionary *_surveyDictionary;
  UIButton *_submitButton;
  NSMutableDictionary *_scoreValues;
  NSMutableDictionary *_weightValues;
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
  self = [super initWithCollectionViewLayout:layout];
  if (self) {
    self.edgesForExtendedLayout = UIRectEdgeNone;

    _scoreValues = [[NSMutableDictionary alloc] init];
    _weightValues = [[NSMutableDictionary alloc] init];
    [self getSurveyQuestions];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.collectionView.backgroundColor = [KMCAssets lightGrayBackgroundColor];
  self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight |
                                         UIViewAutoresizingFlexibleWidth;
  [self.collectionView registerClass:[KMCSurveyCollectionViewCell class]
          forCellWithReuseIdentifier:reuseIdentifier];

  // Defining layout attributes.
  UICollectionViewFlowLayout *layout =
      (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
  layout.itemSize = CGSizeMake(self.view.bounds.size.width - 2 * kCellPadding, kCellHeight);
  layout.sectionInset = UIEdgeInsetsMake(kCellPadding, kCellPadding, kCellPadding, kCellPadding);

  self.navigationItem.title = @"How do you feel about...";

  // Defining submit button attributes.
  CGFloat width = self.collectionView.frame.size.width;
  CGRect frame = CGRectMake(0.f, 0.f, width, kButtonHeight);

  _submitButton = [[UIButton alloc] initWithFrame:frame];
  [_submitButton addTarget:self
                    action:@selector(didTapSubmitButton)
          forControlEvents:UIControlEventTouchUpInside];
  _submitButton.backgroundColor = [UIColor lightGrayColor];
  _submitButton.titleLabel.font = [KMCAssets titleFont:[KMCAssets largeFont]];
  [_submitButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
  [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [_submitButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin |
   UIViewAutoresizingFlexibleRightMargin];

  _submitButton.layer.cornerRadius = 3.f;
  [self.view addSubview:_submitButton];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];

  if (_boundsChanged) {
    return;
  }
  _boundsChanged = YES;

  CGRect frame = self.collectionView.frame;
  frame.size.height -= kButtonHeight;
  self.collectionView.frame = frame;

  frame = _submitButton.frame;
  frame.origin.y = self.collectionView.frame.size.height;
  _submitButton.frame = frame;
}

- (void)getSurveyQuestions {
  PFQuery *query = [PFQuery queryWithClassName:@"Issue"];
  NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
  _requestInFlight = YES;
  _submitButton.hidden = YES;

  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    for (PFObject *object in objects) {
      temp[object.objectId] = [object objectForKey:@"topic"];
      _scoreValues[object.objectId] = @(3.f);
      _weightValues[object.objectId] = @(2.f);
    }
    _requestInFlight = NO;
    _submitButton.hidden = NO;
    _surveyDictionary = [NSDictionary dictionaryWithDictionary:[temp copy]];

    [self.collectionView reloadData];
  }];
}

- (void)didTapSubmitButton {
  UIView *overlayView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  overlayView.backgroundColor = [UIColor blackColor];
  overlayView.alpha = 0.7f;

  UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] init];
  [indicatorView sizeToFit];
  indicatorView.center = self.navigationController.view.center;
  [overlayView addSubview:indicatorView];
  [indicatorView startAnimating];

  UILabel *textLabel = [[UILabel alloc] init];
  [overlayView addSubview:textLabel];
  textLabel.text = @"Personalizing...";
  textLabel.textColor = [UIColor whiteColor];
  [textLabel sizeToFit];
  CGRect frame = textLabel.frame;
  frame.origin.x = CGRectGetMidX(self.collectionView.frame) - CGRectGetWidth(textLabel.frame) / 2.f;
  frame.origin.y = CGRectGetMaxY(indicatorView.frame) + 10.f;
  textLabel.frame = frame;

  [self.navigationController.view addSubview:overlayView];

  PFUser *user = [PFUser currentUser];
  [user setObject:[_scoreValues copy] forKey:kSurveyAnswersKey];
  [user setObject:[_weightValues copy] forKey:kSurveyAnswerWeightsKey];
  [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    [PFCloud callFunctionInBackground:@"add_user_survey_data_to_polls"
                       withParameters:@{ @"user" : user.objectId }];
    [indicatorView stopAnimating];
    [overlayView removeFromSuperview];
    [self.delegate didCompleteSurvey];
  }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return [[_surveyDictionary allKeys] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  KMCSurveyCollectionViewCell *cell =
      (KMCSurveyCollectionViewCell *)
          [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                    forIndexPath:indexPath];

  cell.delegate = self;

  NSArray *keys = [_surveyDictionary allKeys];
  NSString *issueID = keys[indexPath.item];
  NSString *prompt = [NSString stringWithFormat:@"%lu. %@", indexPath.item + 1, _surveyDictionary[issueID]];
  cell.text = prompt;
  cell.cellID = issueID;
  NSNumber *score = _scoreValues[issueID];
  NSNumber *weight = _weightValues[issueID];
  cell.score = [score doubleValue];
  cell.weight = [weight doubleValue];

  return cell;
}

#pragma mark - KMCSurveyCollectionViewCellDelegate

- (void)didChangeScoreValueForCell:(KMCSurveyCollectionViewCell *)cell {
  NSNumber *number = [NSNumber numberWithDouble:cell.score];
  _scoreValues[cell.cellID] = number;
}

- (void)didChangeWeightValueForCell:(KMCSurveyCollectionViewCell *)cell {
  NSNumber *number = [NSNumber numberWithDouble:cell.weight];
  _weightValues[cell.cellID] = number;
}

@end
