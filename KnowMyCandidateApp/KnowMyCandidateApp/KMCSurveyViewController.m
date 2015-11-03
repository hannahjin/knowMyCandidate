#import "KMCSurveyViewController.h"

#import "KMCAssets.h"
#import "KMCSurveyCollectionViewCell.h"
#import "Parse/Parse.h"

NSString *const kSurveyAnswersKey = @"surveyAnswers";

static const CGFloat kButtonHeight = 60.f;
static const CGFloat kCellPadding = 10.f;
static const CGFloat kCellHeight = 150.f;

@interface KMCSurveyViewController () <KMCSurveyCollectionViewCellDelegate>
@end

@implementation KMCSurveyViewController {
  BOOL _boundsChanged;
  BOOL _requestInFlight;
  NSDictionary *_surveyDictionary;
  UIButton *_submitButton;
  NSMutableDictionary *_sliderValues;
}

static NSString *const reuseIdentifier = @"kSurveyCollectionViewCell";

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
  self = [super initWithCollectionViewLayout:layout];
  if (self) {
    self.edgesForExtendedLayout = UIRectEdgeNone;

    _sliderValues = [[NSMutableDictionary alloc] init];
    [self getSurveyQuestions];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.collectionView.backgroundColor = [KMCAssets mainPurpleColor];
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
  _submitButton.backgroundColor = [KMCAssets mainPurpleColor];
  _submitButton.titleLabel.font = [UIFont systemFontOfSize:20.f weight:0.3f];
  [_submitButton setTitle:@"Submit" forState:UIControlStateNormal];
  _submitButton.layer.shadowRadius = 2.f;
  _submitButton.layer.shadowOpacity = 0.3f;
  _submitButton.layer.shadowColor = [UIColor blackColor].CGColor;
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
      _sliderValues[object.objectId] = @(3.f);
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
  UIActivityIndicatorView *indicatorView =
      [[UIActivityIndicatorView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  [indicatorView startAnimating];
  [overlayView addSubview:indicatorView];
  [self.navigationController.view addSubview:overlayView];

  PFUser *user = [PFUser currentUser];
  [user setObject:[_sliderValues copy] forKey:kSurveyAnswersKey];
  [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    [indicatorView stopAnimating];
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
  cell.text = _surveyDictionary[issueID];
  cell.cellID = issueID;
  NSNumber *number = _sliderValues[issueID];
  cell.sliderValue = [number doubleValue];

  return cell;
}

#pragma mark - KMCSurveyCollectionViewCellDelegate

- (void)didChangeSliderValueForCell:(KMCSurveyCollectionViewCell *)cell {
  NSNumber *number = [NSNumber numberWithDouble:cell.sliderValue];
  _sliderValues[cell.cellID] = number;
}

@end
