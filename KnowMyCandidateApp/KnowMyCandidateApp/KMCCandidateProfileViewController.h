#import <UIKit/UIKit.h>

extern NSString *const kCandidatesFollowedKey;

@class PFObject;

@interface KMCCandidateProfileViewController : UIViewController

- (instancetype)initWithCandidateObject:(PFObject *)object;

@end
