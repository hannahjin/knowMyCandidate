#import "KMCMainViewController.h"

#import "KMCAssets.h"
#import "KMCIssuesViewController.h"
#import "KMCUserProfileViewController.h"

@interface KMCMainViewController ()
@end

@implementation KMCMainViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    KMCIssuesViewController *pollsVC =
        [[KMCIssuesViewController alloc] initWithNibName:nil bundle:nil];
    KMCUserProfileViewController *userVC =
        [[KMCUserProfileViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *userNavVC =
        [[UINavigationController alloc] initWithRootViewController:userVC];
    self.viewControllers = @[ pollsVC, userNavVC ];
    self.selectedViewController = pollsVC;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  self.tabBar.tintColor = [KMCAssets mainPurpleColor];
}

@end
