#import <UIKit/UIKit.h>

extern NSString *const kSurveyAnswersKey;

@protocol KMCSurveyViewControllerDelegate <NSObject>

- (void)didCompleteSurvey;

@end

@interface KMCSurveyViewController : UICollectionViewController

@property (nonatomic, weak) id delegate;

@end
