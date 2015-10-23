#import "KMCRootViewController.h"

#import "KMCMainViewController.h"
#import "KMCSignInViewController.h"
#import "Parse/Parse.h"

@interface KMCRootViewController () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
@end

@implementation KMCRootViewController {
  KMCSignInViewController *_signInVC;
  KMCMainViewController *_mainVC;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    if (![PFUser currentUser]) {
      _signInVC = [[KMCSignInViewController alloc] initWithNibName:nil bundle:nil];
      _signInVC.delegate = self;
      _signInVC.signUpController.delegate = self;
    }
    _mainVC = [[KMCMainViewController alloc] initWithNibName:nil bundle:nil];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  CGRect frame = self.view.frame;
  if (![PFUser currentUser]) {
    [self addChildViewController:_signInVC];
    _signInVC.view.frame = frame;
    [self.view addSubview:_signInVC.view];
    [_signInVC didMoveToParentViewController:self];
  } else {
    [self addChildViewController:_mainVC];
    _mainVC.view.frame = frame;
    [self.view addSubview:_mainVC.view];
    [_mainVC didMoveToParentViewController:self];
  }
}

#pragma mark - PFLogInViewControllerDelegate

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
  [self addChildViewController:_mainVC];
  [_signInVC willMoveToParentViewController:nil];

  [self transitionFromViewController:_signInVC
                    toViewController:_mainVC
                            duration:0.2
                             options:UIViewAnimationOptionTransitionFlipFromLeft
                          animations:nil
                          completion:^(BOOL finished) {
    [_mainVC didMoveToParentViewController:self];
    [_signInVC removeFromParentViewController];
  }];
}

#pragma mark - PFSignUpViewControllerDelegate

- (void)signUpViewController:(PFSignUpViewController *)signUpController
               didSignUpUser:(PFUser *)user {
  [self dismissViewControllerAnimated:YES completion:NULL];
  [PFUser logInWithUsernameInBackground:user.username
                               password:user.password
                                  block:^(PFUser *user, NSError *error) {
    [self transitionFromViewController:_signInVC
                      toViewController:_mainVC
                              duration:0.2
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:nil
                            completion:^(BOOL finished) {
                              [_mainVC didMoveToParentViewController:self];
                              [_signInVC removeFromParentViewController];
                            }];
  }];
}

@end
