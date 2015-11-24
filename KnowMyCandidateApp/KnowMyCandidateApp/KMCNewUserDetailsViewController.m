#import "KMCNewUserDetailsViewController.h"

#import "KMCAssets.h"
#import "KMCSurveyViewController.h"
#import "Parse/Parse.h"

NSString *const kNameKey = @"name";
NSString *const kAgeKey = @"age";
NSString *const kGenderKey = @"gender";
NSString *const kAffiliationKey = @"affiliation";

static const CGFloat kBorderWidth = 0.3f;
static const CGFloat kLeftPadding = 30.f;
static const CGFloat kFieldHeight = 44.f;
static const CGFloat kTopPadding = 120.f;
static const CGFloat kVerticalPadding = 20.f;
static const NSInteger kMinimumAge = 18;

@interface KMCNewUserDetailsViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@end

@implementation KMCNewUserDetailsViewController {
  NSArray *_ageModel;
  NSArray *_genderModel;
  NSArray *_partyModel;
  KMCTextField *_ageField;
  KMCTextField *_nameField;
  KMCTextField *_genderField;
  KMCTextField *_partyField;
  UIButton *_nextButton;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.edgesForExtendedLayout = UIRectEdgeNone;

    _nameField = [[KMCTextField alloc] initWithCaret:YES];
    _nameField.placeholder = @"Enter name";
    _nameField.backgroundColor = [UIColor whiteColor];
    _nameField.borderStyle = UITextBorderStyleNone;
    _nameField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _nameField.layer.borderWidth = kBorderWidth;
    _nameField.layer.masksToBounds = YES;

    NSMutableArray *tempAgeModel = [[NSMutableArray alloc] init];
    for (NSInteger i = kMinimumAge; i < 100; i++) {
      tempAgeModel[i - kMinimumAge] = [NSNumber numberWithInteger:i];
    }
    _ageModel = [tempAgeModel copy];
    _genderModel = @[ @"Male", @"Female" ];
    _partyModel = @[ @"Democratic", @"Republican", @"Green Party" ];

    [self setUpAgeField];
    [self setUpGenderField];
    [self setUpPartyField];

    _nextButton = [[UIButton alloc] init];
    [_nextButton setTitle:@"Next" forState:UIControlStateNormal];
    UIFont *newFont = [UIFont systemFontOfSize:20.f weight:0.3f];
    _nextButton.titleLabel.font = newFont;
    [_nextButton addTarget:self
                    action:@selector(didTapNextButton)
          forControlEvents:UIControlEventTouchUpInside];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.navigationItem.title = @"Tell us about yourself!";

  self.view.backgroundColor = [KMCAssets mainPurpleColor];

  CGFloat availableWidth = CGRectGetWidth(self.view.bounds) - (2.f * kLeftPadding);
  CGRect wrapperFrame = CGRectMake(kLeftPadding, kTopPadding, availableWidth, kFieldHeight * 4.f);
  UIView *wrapperView = [[UIView alloc] initWithFrame:wrapperFrame];

  CGRect frame = _nameField.frame;
  frame.origin.x = 0.f;
  frame.origin.y = 0.f;
  frame.size.width = availableWidth;
  frame.size.height = kFieldHeight;
  _nameField.frame = frame;
  [wrapperView addSubview:_nameField];

  frame.origin.y = CGRectGetMaxY(frame);
  _ageField.frame = frame;
  [wrapperView addSubview:_ageField];

  frame.origin.y = CGRectGetMaxY(frame);
  _genderField.frame = frame;
  [wrapperView addSubview:_genderField];

  frame.origin.y = CGRectGetMaxY(frame);
  _partyField.frame = frame;
  [wrapperView addSubview:_partyField];

  wrapperView.layer.cornerRadius = 5.f;
  wrapperView.layer.masksToBounds = YES;
  [self.view addSubview:wrapperView];

  [_nextButton sizeToFit];
  frame = _nextButton.frame;
  frame.origin.y = CGRectGetMaxY(wrapperView.frame) + (2.f * kVerticalPadding);
  frame.origin.x = CGRectGetMidX(self.view.bounds) - (CGRectGetWidth(frame) / 2.f);
  _nextButton.frame = frame;
  [self.view addSubview:_nextButton];
}

- (void)setUpAgeField {
  UIPickerView *ageInputView = [[UIPickerView alloc] init];
  ageInputView.delegate = self;
  ageInputView.dataSource = self;
  ageInputView.showsSelectionIndicator = YES;

  _ageField = [[KMCTextField alloc] init];
  _ageField.placeholder = @"Tap to select age";
  _ageField.backgroundColor = [UIColor whiteColor];
  _ageField.borderStyle = UITextBorderStyleNone;
  _ageField.layer.borderColor = [UIColor lightGrayColor].CGColor;
  _ageField.layer.borderWidth = kBorderWidth;
  _ageField.layer.masksToBounds = YES;
  _ageField.inputView = ageInputView;

  KMCToolbar *toolBar = [[KMCToolbar alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 44.f)];
  UIBarButtonItem *barButtonDone =
      [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(didPressDoneForAgeField)];
  barButtonDone.tintColor = [UIColor whiteColor];
  UIBarButtonItem* flexibleSpace =
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                    target:nil
                                                    action:nil];
  toolBar.items = @[ flexibleSpace, barButtonDone ];

  _ageField.inputAccessoryView = toolBar;
}

- (void)setUpGenderField {
  UIPickerView *genderInputView = [[UIPickerView alloc] init];
  genderInputView.delegate = self;
  genderInputView.dataSource = self;
  genderInputView.showsSelectionIndicator = YES;

  _genderField = [[KMCTextField alloc] init];
  _genderField.placeholder = @"Tap to select gender";
  _genderField.backgroundColor = [UIColor whiteColor];
  _genderField.borderStyle = UITextBorderStyleNone;
  _genderField.layer.borderColor = [UIColor lightGrayColor].CGColor;
  _genderField.layer.borderWidth = kBorderWidth;
  _genderField.layer.masksToBounds = YES;
  _genderField.inputView = genderInputView;

  KMCToolbar *toolBar = [[KMCToolbar alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 44.f)];
  UIBarButtonItem *barButtonDone =
      [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(didPressDoneForGenderField)];
  barButtonDone.tintColor = [UIColor whiteColor];
  UIBarButtonItem* flexibleSpace =
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                    target:nil
                                                    action:nil];
  toolBar.items = @[ flexibleSpace, barButtonDone ];

  _genderField.inputAccessoryView = toolBar;
}

- (void)setUpPartyField {
  UIPickerView *partyInputView = [[UIPickerView alloc] init];
  partyInputView.delegate = self;
  partyInputView.dataSource = self;
  partyInputView.showsSelectionIndicator = YES;

  _partyField = [[KMCTextField alloc] init];
  _partyField.placeholder = @"Tap to select party affiliation";
  _partyField.backgroundColor = [UIColor whiteColor];
  _partyField.borderStyle = UITextBorderStyleNone;
  _partyField.layer.borderColor = [UIColor lightGrayColor].CGColor;
  _partyField.layer.borderWidth = kBorderWidth;
  _partyField.layer.masksToBounds = YES;
  _partyField.inputView = partyInputView;

  KMCToolbar *toolBar = [[KMCToolbar alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 44.f)];
  UIBarButtonItem *barButtonDone =
      [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(didPressDoneForPartyField)];
  barButtonDone.tintColor = [UIColor whiteColor];
  UIBarButtonItem* flexibleSpace =
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                    target:nil
                                                    action:nil];
  toolBar.items = @[ flexibleSpace, barButtonDone ];

  _partyField.inputAccessoryView = toolBar;
}

- (void)didPressDoneForAgeField {
  [_ageField resignFirstResponder];
}

- (void)didPressDoneForGenderField {
  [_genderField resignFirstResponder];
}

- (void)didPressDoneForPartyField {
  [_partyField resignFirstResponder];
}

- (void)didTapNextButton {
  PFUser *user = [PFUser currentUser];
  [user setObject:_nameField.text forKey:kNameKey];
  [user setObject:_ageField.text forKey:kAgeKey];
  [user setObject:_genderField.text forKey:kGenderKey];
  [user setObject:_partyField.text forKey:kAffiliationKey];
  [user saveInBackground];

  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  KMCSurveyViewController *surveyVC =
      [[KMCSurveyViewController alloc] initWithCollectionViewLayout:layout];
  surveyVC.delegate = [[[UIApplication sharedApplication] delegate] window].rootViewController;
  [self.navigationController pushViewController:surveyVC animated:YES];
}

#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  if ([pickerView isEqual:_ageField.inputView]) {
    return [_ageModel count];
  } else if ([pickerView isEqual:_genderField.inputView]) {
    return [_genderModel count];
  } else {
    return [_partyModel count];
  }
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
  if ([pickerView isEqual:_ageField.inputView]) {
    NSString *title = [NSString stringWithFormat:@"%@", _ageModel[row]];
    return title;
  } else if ([pickerView isEqual:_genderField.inputView]) {
    return _genderModel[row];
  } else {
    return _partyModel[row];
  }
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
  if ([pickerView isEqual:_ageField.inputView]) {
    _ageField.text = [NSString stringWithFormat:@"%li", row + kMinimumAge];
  } else if ([pickerView isEqual:_genderField.inputView]) {
    _genderField.text = _genderModel[row];
  } else {
    _partyField.text = _partyModel[row];
  }
}

@end
