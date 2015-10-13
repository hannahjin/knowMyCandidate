#import "AppDelegate.h"

#import "KMCSignInViewController.h"
#import <Parse/Parse.h>

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  KMCSignInViewController *signInVC =
      [[KMCSignInViewController alloc] initWithNibName:nil bundle:nil];
  self.window.rootViewController = signInVC;
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  return YES;
}

@end
