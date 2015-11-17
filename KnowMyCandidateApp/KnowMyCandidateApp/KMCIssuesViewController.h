#import <UIKit/UIKit.h>
#import "PieChartView.h"


@class PFObject;

@interface KMCIssuesViewController : UIViewController<PieChartDelegate>

- (instancetype)initWithIssueObject:(PFObject *)object;

@end