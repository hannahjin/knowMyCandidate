#import <UIKit/UIKit.h>

@class KMCSurveyCollectionViewCell;

@protocol KMCSurveyCollectionViewCellDelegate <NSObject>

- (void)didChangeScoreValueForCell:(KMCSurveyCollectionViewCell *)cell;
- (void)didChangeWeightValueForCell:(KMCSurveyCollectionViewCell *)cell;

@end

@interface KMCSurveyCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *cellID;
@property (nonatomic, copy) NSString *text;
@property (nonatomic) CGFloat score;
@property (nonatomic) CGFloat weight;
@property (nonatomic, weak) id<KMCSurveyCollectionViewCellDelegate> delegate;

@end
