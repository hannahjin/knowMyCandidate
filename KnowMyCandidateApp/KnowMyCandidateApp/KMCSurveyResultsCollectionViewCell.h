#import <UIKit/UIKit.h>

#import "KMCConstants.h"

@protocol KMCSurveyResultsCollectionViewCellDelegate <NSObject>

- (void)didFollowCandidate:(BOOL)didFollow withID:(NSString *)candidateID;

@end

@interface KMCSurveyResultsCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id delegate;
@property (nonatomic) NSNumber *matchingScore;
@property (nonatomic, copy) NSString *candidateID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic) NSInteger rank;
@property (nonatomic) BOOL isFollowing;

@end
