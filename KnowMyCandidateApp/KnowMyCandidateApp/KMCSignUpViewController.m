#import "KMCSignUpViewController.h"

#import "KMCAssets.h"
#import "Parse/Parse.h"

static const CGFloat kSidePadding = 15.f;
static const NSInteger kErrorCodeNilField = 1;
static const NSInteger kErrorCodeInvalidEmail = 2;
static const NSInteger kErrorCodeUsernameExists = 3;
static const CGFloat kVerticalSpacing = 15.f;

@interface KMCSignUpViewController ()
@end

@implementation KMCSignUpViewController {
  UIView *_fieldView;
  UIButton *_signUpButton;
  UIActivityIndicatorView *_activityView;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  PFSignUpView *signUpView = self.signUpView;

  _fieldView = [[UIView alloc] initWithFrame:CGRectZero];
  [signUpView addSubview:_fieldView];

  _signUpButton = [[UIButton alloc] init];
  [_signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
  UIFont *newFont = [UIFont systemFontOfSize:20.f weight:0.3f];
  _signUpButton.titleLabel.font = newFont;
  [signUpView addSubview:_signUpButton];

  _activityView = [[UIActivityIndicatorView alloc]
                       initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];

  signUpView.frame = [[UIScreen mainScreen] bounds];
  signUpView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  signUpView.backgroundColor = [KMCAssets mainPurpleColor];
  signUpView.logo = nil;
  signUpView.signUpButton.hidden = YES;
  [signUpView.dismissButton setImage:[KMCAssets backArrowIcon] forState:UIControlStateNormal];

  self.fields = PFSignUpFieldsDefault | PFSignUpFieldsAdditional;

  [_signUpButton addTarget:self
                    action:@selector(didTapSignUpButton)
          forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];

  self.signUpView.emailAsUsername = YES;
  PFSignUpView *signUpView = self.signUpView;

  CGFloat fieldHeight = signUpView.usernameField.frame.size.height;
  CGFloat fieldPosition = signUpView.usernameField.frame.origin.y;
  [signUpView.usernameField removeFromSuperview];
  [signUpView.passwordField removeFromSuperview];
  CGRect newFieldFrame = CGRectMake(kSidePadding,
                                    fieldPosition,
                                    self.view.frame.size.width - 2*kSidePadding,
                                    2.f*fieldHeight);

  _fieldView.frame = newFieldFrame;
  [_fieldView addSubview:signUpView.usernameField];
  [_fieldView addSubview:signUpView.passwordField];
  signUpView.usernameField.frame = CGRectMake(0.f,
                                              0.f,
                                              self.view.frame.size.width - 2.f*kSidePadding,
                                              fieldHeight);
  signUpView.passwordField.frame = CGRectMake(0.f,
                                              fieldHeight,
                                              self.view.frame.size.width - 2.f*kSidePadding,
                                              fieldHeight);
  _fieldView.layer.cornerRadius = 5.f;
  _fieldView.layer.masksToBounds = YES;

  newFieldFrame.origin.y += CGRectGetHeight(newFieldFrame) + kVerticalSpacing;
  newFieldFrame.size.height /= 2.f;
  _signUpButton.frame = newFieldFrame;

  newFieldFrame.origin.y += CGRectGetHeight(newFieldFrame);
  _activityView.frame = newFieldFrame;
}

- (void)didTapSignUpButton {
  NSString *username = self.signUpView.usernameField.text ?: @"";
  NSString *password = self.signUpView.passwordField.text ?: @"";

  if (![username length] || ![password length]) {
    [self presentAlertViewForErrorCode:kErrorCodeNilField];
    return;
  }

  [self.signUpView addSubview:_activityView];
  [_activityView startAnimating];
  PFUser *user = [PFUser user];
  user.username = self.signUpView.usernameField.text;
  user.password = self.signUpView.passwordField.text;
  user.email = user.username;

  [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (!error) {
      [self.delegate signUpViewController:self didSignUpUser:user];
    } else {
      if ([error code] == kPFErrorInvalidEmailAddress) {
        [self presentAlertViewForErrorCode:kErrorCodeInvalidEmail];
      } else if ([error code] == kPFErrorUsernameTaken) {
        [self presentAlertViewForErrorCode:kErrorCodeUsernameExists];
      }
    }
    [_activityView stopAnimating];
    [_activityView removeFromSuperview];
  }];
}

- (void)presentAlertViewForErrorCode:(NSInteger)errorCode {
  NSString *title;
  NSString *message;
  if (errorCode == kErrorCodeNilField) {
    title = @"Invalid credentials";
    message = @"Please enter valid username and/or password";
  } else if (errorCode == kErrorCodeUsernameExists) {
    title = @"Account already exists";
    message = @"Please sign up with a new email";
  } else {
    title = @"Invalid username";
    message = @"Please enter a valid email address as your username";
  }

  UIAlertController *alert =
      [UIAlertController alertControllerWithTitle:title
                                          message:message
                                   preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                          style:UIAlertActionStyleDefault
                                                        handler:nil];
  [alert addAction:defaultAction];
  [self presentViewController:alert animated:YES completion:nil];
}

@end
