#import <UIKit/UIKit.h>

@protocol KMCInfoCollectionViewCellDelegate <NSObject>

@optional
- (void)openUrl:(NSURL *)url;

@end

@interface KMCInfoCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id delegate;
@property (nonatomic, copy) NSString *fbLink;
@property (nonatomic, copy) NSString *webLink;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
