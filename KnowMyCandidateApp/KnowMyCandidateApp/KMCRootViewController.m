#import "KMCRootViewController.h"

#import "KMCAssets.h"
#import "KMCMainViewController.h"
#import "KMCNewUserDetailsViewController.h"
#import "KMCSignInViewController.h"
#import "KMCSignUpViewController.h"
#import "KMCSurveyViewController.h"
#import "Parse/Parse.h"

@interface KMCRootViewController () <
    KMCSurveyViewControllerDelegate,
    PFLogInViewControllerDelegate,
    PFSignUpViewControllerDelegate
>
@end

@implementation KMCRootViewController {
  KMCSignInViewController *_signInVC;
  KMCMainViewController *_mainVC;
  UINavigationController *_surveyNavVC;
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

- (void)setUpMainVC {
  _mainVC = [[KMCMainViewController alloc] initWithNibName:nil bundle:nil];
}

- (void)setUpSignInVC {
  _signInVC = [[KMCSignInViewController alloc] initWithNibName:nil bundle:nil];
  _signInVC.delegate = self;
  _signInVC.signUpController = [[KMCSignUpViewController alloc] initWithNibName:nil bundle:nil];
  _signInVC.signUpController.delegate = self;
}

- (void)setUpSurveyVC {
  KMCNewUserDetailsViewController *detailsVC =
      [[KMCNewUserDetailsViewController alloc] initWithNibName:nil bundle:nil];
  _surveyNavVC = [[UINavigationController alloc] initWithRootViewController:detailsVC];
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

#pragma mark - PFLogInViewControllerDelegate

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
  BOOL hasSurvey = [[PFUser currentUser] objectForKey:kSurveyAnswersKey];
  if (!hasSurvey) {
    [self setUpSurveyVC];
    [self addChildViewController:_surveyNavVC];
  } else {
    [self setUpMainVC];
    [self addChildViewController:_mainVC];
  }
  [_signInVC willMoveToParentViewController:nil];
  [self transitionFromViewController:_signInVC
                    toViewController:hasSurvey ? _mainVC : _surveyNavVC
                            duration:0.2
                             options:UIViewAnimationOptionTransitionFlipFromLeft
                          animations:nil
                          completion:^(BOOL finished) {
    if (hasSurvey) {
      [_mainVC didMoveToParentViewController:self];
    } else {
      [_surveyNavVC didMoveToParentViewController:self];
    }
    [_signInVC removeFromParentViewController];
    _signInVC = nil;
  }];
}

#pragma mark - PFSignUpViewControllerDelegate

- (void)signUpViewController:(PFSignUpViewController *)signUpController
               didSignUpUser:(PFUser *)user {
  [self setUpSurveyVC];
  [self dismissViewControllerAnimated:YES completion:nil];
  [PFUser logInWithUsernameInBackground:user.username
                               password:user.password
                                  block:^(PFUser *user, NSError *error) {
    [self addChildViewController:_surveyNavVC];
    [_signInVC willMoveToParentViewController:nil];
    [self transitionFromViewController:_signInVC
                      toViewController:_surveyNavVC
                              duration:0.2
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:nil
                            completion:^(BOOL finished) {
      [_surveyNavVC didMoveToParentViewController:self];
      [_signInVC removeFromParentViewController];
      _signInVC = nil;
    }];
  }];
}

#pragma mark - KMCSurveyViewControllerDelegate

- (void)didCompleteSurvey {
  [self setUpMainVC];
  [self dismissViewControllerAnimated:YES completion:nil];
  [self addChildViewController:_mainVC];
  [_surveyNavVC willMoveToParentViewController:nil];
  [self transitionFromViewController:_surveyNavVC
                    toViewController:_mainVC
                            duration:0.2
                             options:UIViewAnimationOptionTransitionFlipFromLeft
                          animations:nil
                          completion:^(BOOL finished) {
    [_mainVC didMoveToParentViewController:self];
    [_surveyNavVC removeFromParentViewController];
    _surveyNavVC = nil;
  }];
}

#pragma mark - UIViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

@end
