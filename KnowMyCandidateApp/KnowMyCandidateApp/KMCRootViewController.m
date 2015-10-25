#import "KMCRootViewController.h"

#import "KMCMainViewController.h"
#import "KMCSignInViewController.h"
#import "KMCSignUpViewController.h"
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
      [self setUpSignInVC];
    } else {
      [self setUpMainVC];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didLogOutUser)
                                                 name:@"kPFUserLogOut"
                                               object:nil];
  }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  if (![PFUser currentUser]) {
    [self addChildViewController:_signInVC];
    [self.view addSubview:_signInVC.view];
    [_signInVC didMoveToParentViewController:self];
  } else {
    [self addChildViewController:_mainVC];
    [self.view addSubview:_mainVC.view];
    [_mainVC didMoveToParentViewController:self];
  }
}

- (void)didLogOutUser {
  [self setUpSignInVC];
  [self addChildViewController:_signInVC];
  [_mainVC willMoveToParentViewController:nil];
  [self transitionFromViewController:_mainVC
                    toViewController:_signInVC
                            duration:0.2
                             options:UIViewAnimationOptionTransitionFlipFromLeft
                          animations:nil
                          completion:^(BOOL finished) {
    [_signInVC didMoveToParentViewController:self];
    [_mainVC removeFromParentViewController];
    _mainVC = nil;
  }];
}

- (void)setUpMainVC {
  _mainVC = [[KMCMainViewController alloc] initWithNibName:nil bundle:nil];
}

- (void)setUpSignInVC {
  _signInVC = [[KMCSignInViewController alloc] initWithNibName:nil bundle:nil];
  _signInVC.delegate = self;
  _signInVC.signUpController = [[KMCSignUpViewController alloc] initWithNibName:nil bundle:nil];
  _signInVC.signUpController.delegate = self;
}

#pragma mark - PFLogInViewControllerDelegate

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
  [self setUpMainVC];
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
    _signInVC = nil;
  }];
}

#pragma mark - PFSignUpViewControllerDelegate

- (void)signUpViewController:(PFSignUpViewController *)signUpController
               didSignUpUser:(PFUser *)user {
  [self setUpMainVC];
  [self dismissViewControllerAnimated:YES completion:nil];
  [PFUser logInWithUsernameInBackground:user.username
                               password:user.password
                                  block:^(PFUser *user, NSError *error) {
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
      _signInVC = nil;
    }];
  }];
}

@end
