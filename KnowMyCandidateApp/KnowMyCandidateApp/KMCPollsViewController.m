#import "KMCPollsViewController.h"

@interface KMCPollsViewController ()
@end

@implementation KMCPollsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    UITabBarItem *item = [self tabBarItem];
    item.title = @"Polls";
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

@end
