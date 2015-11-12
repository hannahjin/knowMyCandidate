#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "KMCConstants.h"

@interface KMCSlider : UISlider
@end

@interface KMCTextField : UITextField
- (instancetype)initWithCaret:(BOOL)caret;
@end

@interface KMCToolbar : UIToolbar
@end

@interface KMCAssets : NSObject

+ (UIImage *)backArrowIcon;
+ (UIImage *)candidatesTabIcon;
+ (UIImage *)eventsTabIcon;
+ (UIImage *)homeTabIcon;
+ (UIImage *)issuesTabIcon;
+ (UIImage *)signInBackground;
+ (UIImage *)userTabIcon;

+ (UIColor *)democraticPartyColor;
+ (UIColor *)republicanPartyColor;
+ (UIColor *)greenPartyColor;
+ (UIColor *)mainPurpleColor;
+ (UIColor *)lightBlueColor;

+ (UIImage *)pictureForCandidate:(NSString *)name;
+ (UIImage *)backgroundForAffiliation:(KMCPartyAffiliation)party;
+ (UIImage *)cellBackgroundForAffiliation:(KMCPartyAffiliation)party;
+ (UIColor *)partyColorForAffiliation:(KMCPartyAffiliation)party;

+ (UIColor *)colorForStand:(NSString *)stand;

@end
