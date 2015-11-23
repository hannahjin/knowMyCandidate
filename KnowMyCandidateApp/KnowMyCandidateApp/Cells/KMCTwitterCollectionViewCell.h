#import <UIKit/UIKit.h>

@interface KMCTwitterCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, copy) NSString *candidateName;
@property (nonatomic, copy) NSString *twitterID;

@end
