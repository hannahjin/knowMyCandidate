#import <UIKit/UIKit.h>

@class KMCSurveyCollectionViewCell;

@protocol KMCSurveyCollectionViewCellDelegate <NSObject>

- (void)didChangeSliderValueForCell:(KMCSurveyCollectionViewCell *)cell;

@end

@interface KMCSurveyCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *cellID;
@property (nonatomic, copy) NSString *text;
@property (nonatomic) CGFloat sliderValue;
@property (nonatomic, weak) id<KMCSurveyCollectionViewCellDelegate> delegate;

@end
