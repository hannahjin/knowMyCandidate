#import "KMCUserProfileViewController.h"

#import "KMCAssets.h"
#import "FBSDKCoreKit/FBSDKCoreKit.h"
#import "Parse/Parse.h"

static const CGFloat kProfilePictureSize = 130.f;
static const CGFloat kTopPadding = 25.f;
static const CGFloat kSpacing = 10.f;

@interface KMCUserProfileViewController ()
@end

@implementation KMCUserProfileViewController {
  UIButton *_logOutButton;
  FBSDKProfilePictureView *_profilePictureView;
  UILabel *_nameLabel;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    UITabBarItem *item = [self tabBarItem];
    item.title = @"User";
    item.image = [KMCAssets userTabIcon];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"Log Out"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(didTapLogOut)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setBarTintColor:[KMCAssets mainPurpleColor]];

    _logOutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_logOutButton setTitle:@"Log out" forState:UIControlStateNormal];

    [_logOutButton addTarget:self
                      action:@selector(didTapLogOut)
            forControlEvents:UIControlEventTouchUpInside];

    [self setUpProfilePictureAndName];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _profilePictureView.layer.cornerRadius = kProfilePictureSize / 2.f;
  _profilePictureView.layer.masksToBounds = YES;
  _profilePictureView.layer.borderColor = [UIColor lightGrayColor].CGColor;
  _profilePictureView.layer.borderWidth = 5.f;

  CGRect frame = _profilePictureView.frame;
  frame.origin.x = CGRectGetMidX(self.view.frame) - CGRectGetMidX(frame);
  frame.origin.y = kTopPadding;
  _profilePictureView.frame = frame;

  [_nameLabel sizeToFit];
  frame.origin.x = CGRectGetMidX(self.view.frame) - CGRectGetMidX(_nameLabel.frame);
  frame.origin.y = CGRectGetMaxY(frame) + kSpacing;
  frame.size = _nameLabel.frame.size;
  _nameLabel.frame = frame;

  [self.view addSubview:_logOutButton];
  [self.view addSubview:_profilePictureView];
  [self.view addSubview:_nameLabel];
}

- (void)didTapLogOut {
  [PFUser logOut];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"kPFUserLogOut" object:nil];
}

#pragma mark - Helper methods

- (void)setUpProfilePictureAndName {
  CGRect frame = CGRectMake(0.f, 0.f, kProfilePictureSize, kProfilePictureSize);
  _profilePictureView = [[FBSDKProfilePictureView alloc] initWithFrame:frame];
  _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];

  if ([FBSDKAccessToken currentAccessToken]) {
    FBSDKGraphRequest *request =
        [[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                          parameters:@{ @"fields" : @"id,name"}];
    [request startWithCompletionHandler:
        ^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
      if (!error) {
        _profilePictureView.profileID = [result valueForKey:@"id"];
        _nameLabel.text = [result valueForKey:@"name"];
      }
    }];
  }
}

@end
