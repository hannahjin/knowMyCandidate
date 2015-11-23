#import <UIKit/UIKit.h>

@protocol KMCSurveyResultsViewControllerDelegate <NSObject>

- (void)didFinishSurveyResults;

@end

@interface KMCSurveyResultsViewController : UICollectionViewController

@property (nonatomic, weak) id delegate;

@end
