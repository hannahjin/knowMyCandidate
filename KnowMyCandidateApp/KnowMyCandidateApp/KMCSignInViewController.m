#import "KMCSignInViewController.h"

#import "FBSDKCoreKit/FBSDKCoreKit.h"
#import "FBSDKLoginKit/FBSDKLoginKit.h"
#import "Parse/Parse.h"
#import "ParseFacebookUtilsV4/PFFacebookUtils.h"
//#import "PFTwitterUtils.h"

@interface KMCSignInViewController ()
@end

@implementation KMCSignInViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

  self.fields = PFLogInFieldsSignUpButton |
                PFLogInFieldsFacebook |
                PFLogInFieldsTwitter |
                PFLogInFieldsUsernameAndPassword |
                PFLogInFieldsLogInButton;
  [self.logInView.facebookButton addTarget:self
                                    action:@selector(didTapFbLoginButton)
                          forControlEvents:UIControlEventTouchUpInside];
  [self.logInView.facebookButton addTarget:self
                                    action:@selector(didTapTwtrLoginButton)
                          forControlEvents:UIControlEventTouchUpInside];
  [self.logInView.logInButton addTarget:self
                                 action:@selector(didTapLoginButton)
                       forControlEvents:UIControlEventTouchUpInside];
}

- (void)didTapLoginButton {
  NSString *username = self.logInView.usernameField.text ?: @"";
  NSString *password = self.logInView.passwordField.text ?: @"";

  [PFUser logInWithUsernameInBackground:username
                               password:password
                                  block:^(PFUser *user, NSError *error) {
    if (!user) {
      NSLog(@"Uh oh. The user cancelled the login.");
    } else if (user.isNew) {
      NSLog(@"User signed up and logged in!");
    } else {
      NSLog(@"User logged in!");
    }
  }];
}

- (void)didTapFbLoginButton {
  // Set permissions required from the user's FB account.
  NSArray *permissionsArray = @[ @"user_about_me" ];

  // Login PFUser using Facebook
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
  }];
}

//- (void)didTapTwtrLoginButton {
//  // Login PFUser using Twitter
//  [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
//    if (!user) {
//      NSLog(@"Uh oh. The user cancelled the Twitter login.");
//      return;
//    } else if (user.isNew) {
//      NSLog(@"User signed up and logged in with Twitter!");
//    } else {
//      NSLog(@"User logged in with Twitter!");
//    }
//  }];
//}
@end
