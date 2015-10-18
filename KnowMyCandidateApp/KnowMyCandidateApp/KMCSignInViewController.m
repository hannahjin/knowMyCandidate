#import "KMCSignInViewController.h"

#import "FBSDKCoreKit/FBSDKCoreKit.h"
#import "FBSDKLoginKit/FBSDKLoginKit.h"
#import "Parse/Parse.h"
#import "ParseFacebookUtilsV4/PFFacebookUtils.h"

@interface KMCSignInViewController ()
@end

@implementation KMCSignInViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.fields = PFLogInFieldsFacebook | PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton;
  [self.logInView.facebookButton addTarget:self
                                    action:@selector(didTapFbLoginButton)
                          forControlEvents:UIControlEventTouchUpInside];
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
    } else {
      NSLog(@"User logged in through Facebook!");
    }
  }];
}

@end
