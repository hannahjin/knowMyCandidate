#import "KMCUserProfileViewController.h"

@interface KMCUserProfileViewController ()
@end

@implementation KMCUserProfileViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    UITabBarItem *item = [self tabBarItem];
    item.title = @"User";
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

@end
