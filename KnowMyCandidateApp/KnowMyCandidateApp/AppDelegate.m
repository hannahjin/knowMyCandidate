#import "AppDelegate.h"

#import "KMCSignInViewController.h"
#import "FBSDKCoreKit/FBSDKCoreKit.h"
#import "Parse/Parse.h"
#import "ParseFacebookUtilsV4/PFFacebookUtils.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [Parse setApplicationId:@"K1OX77eW0lBtAm8TSc8HYHzvfe7KkM4qi9vwtCBF"
                clientKey:@"QjT0RO6xMAadjULNT1lwrQnHyIHNMhdEvJV7po3n"];
  [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];

  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  KMCSignInViewController *signInVC =
      [[KMCSignInViewController alloc] initWithNibName:nil bundle:nil];
  self.window.rootViewController = signInVC;
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];

  return [[FBSDKApplicationDelegate sharedInstance] application:application
                                  didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  [FBSDKAppEvents activateApp];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
  return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                        openURL:url
                                              sourceApplication:sourceApplication
                                                     annotation:annotation];
}

@end
