#import <UIKit/UIKit.h>

@interface KMCNewsfeedCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, copy) NSString *candidateName;

@end
