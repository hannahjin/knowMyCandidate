#import <UIKit/UIKit.h>

@class PFObject;

@interface KMCIssueViewController : UIViewController

- (instancetype)initWithIssueObject:(PFObject *)object;

@end