#import "KMCSignInViewController.h"

#import "FBSDKCoreKit/FBSDKCoreKit.h"
#import "FBSDKLoginKit/FBSDKLoginKit.h"
#import "KMCAssets.h"
#import "Parse/Parse.h"
#import "ParseFacebookUtilsV4/PFFacebookUtils.h"

static const CGFloat kSidePadding = 15.f;
static const CGFloat kVerticalSpacing = 15.f;

@interface KMCSignInViewController ()
@end

@implementation KMCSignInViewController {
  UIButton *_loginButton;
  UIActivityIndicatorView *_activityView;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _loginButton = [[UIButton alloc] init];
  [_loginButton setTitle:@"Log In" forState:UIControlStateNormal];
  UIFont *newFont = [UIFont systemFontOfSize:20.f weight:0.3f];
  _loginButton.titleLabel.font = newFont;

  _activityView = [[UIActivityIndicatorView alloc]
                       initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
  PFLogInView *logInView = self.logInView;
  logInView.frame = [[UIScreen mainScreen] bounds];
  logInView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  logInView.backgroundColor = [UIColor colorWithPatternImage:[KMCAssets signInBackground]];
  logInView.logo.hidden = YES;
  logInView.logInButton.hidden = YES;

  self.fields = PFLogInFieldsSignUpButton |
                PFLogInFieldsFacebook |
                PFLogInFieldsUsernameAndPassword |
                PFLogInFieldsLogInButton;

  [logInView.facebookButton addTarget:self
                               action:@selector(didTapFbLoginButton)
                     forControlEvents:UIControlEventTouchUpInside];
  [_loginButton addTarget:self
                   action:@selector(didTapLoginButton)
         forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  PFLogInView *logInView = self.logInView;
  logInView.usernameField.placeholder = @"Email";

  CGFloat fieldHeight = logInView.usernameField.frame.size.height;
  CGFloat fieldPosition = logInView.usernameField.frame.origin.y;

  [logInView.usernameField removeFromSuperview];
  [logInView.passwordField removeFromSuperview];
  CGRect newFieldFrame = CGRectMake(kSidePadding,
                                    fieldPosition,
                                    self.view.frame.size.width - 2*kSidePadding,
                                    2*fieldHeight);

  UIView *fieldView = [[UIView alloc] initWithFrame:newFieldFrame];
  [fieldView addSubview:logInView.usernameField];
  [fieldView addSubview:logInView.passwordField];
  logInView.usernameField.frame = CGRectMake(0.f,
                                             0.f,
                                             self.view.frame.size.width - 2*kSidePadding,
                                             fieldHeight);
  logInView.passwordField.frame = CGRectMake(0.f,
                                             fieldHeight,
                                             self.view.frame.size.width - 2*kSidePadding,
                                             fieldHeight);
  fieldView.layer.cornerRadius = 5.f;
  fieldView.layer.masksToBounds = YES;
  [logInView addSubview:fieldView];

  newFieldFrame.origin.y += CGRectGetHeight(newFieldFrame) + kVerticalSpacing;
  newFieldFrame.size.height /= 2.f;
  _loginButton.frame = newFieldFrame;
  [logInView addSubview:_loginButton];

  newFieldFrame.origin.y += CGRectGetHeight(newFieldFrame);
  _activityView.frame = newFieldFrame;
  _activityView.hidden = YES;
  [logInView addSubview:_activityView];
}

- (void)didTapLoginButton {
  NSString *username = self.logInView.usernameField.text ?: @"";
  NSString *password = self.logInView.passwordField.text ?: @"";

  if (![username length] || ![password length]) {
    [self presentAlertViewForInvalidLogin];
    return;
  }

  _loginButton.enabled = NO;
  _activityView.hidden = NO;
  [_activityView startAnimating];
  [PFUser logInWithUsernameInBackground:username
                               password:password
                                  block:^(PFUser *user, NSError *error) {
    if (!user) {
      NSLog(@"Uh oh. The user cancelled the login.");
      [self presentAlertViewForInvalidLogin];
    } else if (user.isNew) {
      NSLog(@"User signed up and logged in!");
      [self.delegate logInViewController:self didLogInUser:user];
    } else {
      NSLog(@"User logged in!");
      [self.delegate logInViewController:self didLogInUser:user];
    }
    _loginButton.enabled = YES;
    [_activityView stopAnimating];
    _activityView.hidden = YES;
  }];
}

- (void)didTapFbLoginButton {
  // Set permissions required from the user's FB account.
  NSArray *permissionsArray = @[ @"user_about_me" ];

  _loginButton.enabled = NO;
  _activityView.hidden = NO;
  [_activityView startAnimating];
  [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray
                                                  block:^(PFUser *user, NSError *error) {
    if (!user) {
      NSLog(@"Uh oh. The user cancelled the Facebook login.");
    } else if (user.isNew) {
      NSLog(@"User signed up and logged in through Facebook!");
      [self.delegate logInViewController:self didLogInUser:user];
    } else {
      NSLog(@"User logged in through Facebook!");
      [self.delegate logInViewController:self didLogInUser:user];
    }
    _loginButton.enabled = YES;
    _activityView.hidden = YES;
    [_activityView stopAnimating];
  }];
}

#pragma mark - Helper methods

- (void)presentAlertViewForInvalidLogin {
  UIAlertController *alert =
      [UIAlertController alertControllerWithTitle:@"Invalid credentials"
                                          message:@"Please enter valid username and/or password"
                                   preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                          style:UIAlertActionStyleDefault
                                                        handler:nil];
  [alert addAction:defaultAction];
  [self presentViewController:alert animated:YES completion:nil];
}

@end
