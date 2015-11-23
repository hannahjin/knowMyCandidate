#import "KMCMainViewController.h"

#import "KMCAssets.h"
#import "KMCCandidatesCollectionViewController.h"
#import "KMCIssuesCollectionViewController.h"
#import "KMCNewsfeedViewController.h"
#import "KMCUserProfileViewController.h"

@interface KMCMainViewController ()
@end

@implementation KMCMainViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    UICollectionViewFlowLayout *newsfeedLayout = [[UICollectionViewFlowLayout alloc] init];
    KMCNewsfeedViewController *newsfeedVC =
        [[KMCNewsfeedViewController alloc] initWithCollectionViewLayout:newsfeedLayout];
    UINavigationController *newsfeedNavVC =
        [[UINavigationController alloc] initWithRootViewController:newsfeedVC];

    UICollectionViewFlowLayout *issuesLayout = [[UICollectionViewFlowLayout alloc] init];
    KMCIssuesCollectionViewController *issuesVC =
        [[KMCIssuesCollectionViewController alloc] initWithCollectionViewLayout:issuesLayout];
    UINavigationController *issuesNavVC =
        [[UINavigationController alloc] initWithRootViewController:issuesVC];

    UICollectionViewFlowLayout *candidatesLayout = [[UICollectionViewFlowLayout alloc] init];
    KMCCandidatesCollectionViewController *candidatesVC =
        [[KMCCandidatesCollectionViewController alloc]
            initWithCollectionViewLayout:candidatesLayout];
    UINavigationController *candidatesNavVC =
        [[UINavigationController alloc] initWithRootViewController:candidatesVC];

    KMCUserProfileViewController *userVC =
        [[KMCUserProfileViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *userNavVC =
        [[UINavigationController alloc] initWithRootViewController:userVC];

    self.viewControllers = @[ newsfeedNavVC, issuesNavVC, candidatesNavVC, userNavVC ];
    self.selectedViewController = newsfeedNavVC;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  self.tabBar.tintColor = [KMCAssets mainPurpleColor];
}

@end
