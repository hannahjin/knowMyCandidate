#import <UIKit/UIKit.h>

#import "KMCConstants.h"

@interface KMCSurveyResultsCollectionViewCell : UICollectionViewCell

@property (nonatomic) NSNumber *matchingScore;
@property (nonatomic, copy) NSString *candidateID;
@property (nonatomic, copy) NSString *name;

@end
