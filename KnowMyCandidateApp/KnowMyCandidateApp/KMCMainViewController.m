#import "KMCMainViewController.h"

#import "KMCPollsViewController.h"
#import "KMCUserProfileViewController.h"

@interface KMCMainViewController ()
@end

@implementation KMCMainViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    KMCPollsViewController *pollsVC =
        [[KMCPollsViewController alloc] initWithNibName:nil bundle:nil];
    KMCUserProfileViewController *userVC =
        [[KMCUserProfileViewController alloc] initWithNibName:nil bundle:nil];
    self.viewControllers = @[ pollsVC, userVC ];
    self.selectedViewController = pollsVC;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  self.tabBar.tintColor =
      [UIColor colorWithRed:88.0/255.0 green:86.0/255.0 blue:214.0/255.0 alpha:1.0];
}

@end
