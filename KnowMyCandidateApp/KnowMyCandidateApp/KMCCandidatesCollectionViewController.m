#import "KMCCandidatesCollectionViewController.h"

#import "KMCAssets.h"

static NSString *const reuseIdentifier = @"kCandidatesCollectionViewCell";

@interface KMCCandidatesCollectionViewController ()
@end

@implementation KMCCandidatesCollectionViewController

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
  self = [super initWithCollectionViewLayout:layout];
  if (self) {
    self.edgesForExtendedLayout = UIRectEdgeNone;

    UITabBarItem *item = [self tabBarItem];
    item.title = @"Candidates";
    item.image = [KMCAssets candidatesTabIcon];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.collectionView.backgroundColor = [UIColor whiteColor];
  self.navigationItem.title = @"Candidates";
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                forIndexPath:indexPath];

  return cell;
}

@end

