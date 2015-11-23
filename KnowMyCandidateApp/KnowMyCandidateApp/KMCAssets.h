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
+ (UIImage *)facebookIcon;
+ (UIImage *)globeIcon;
+ (UIImage *)homeTabIcon;
+ (UIImage *)issuesTabIcon;
+ (UIImage *)newspaperIcon;
+ (UIImage *)signInBackground;
+ (UIImage *)twitterIcon;
+ (UIImage *)userTabIcon;

+ (UIColor *)democraticPartyColor;
+ (UIColor *)republicanPartyColor;
+ (UIColor *)greenPartyColor;
+ (UIColor *)mainPurpleColor;
+ (UIColor *)lightBlueColor;
+ (UIColor *)lightGrayBackgroundColor;

+ (UIFont *)labelFont:(CGFloat)size;
+ (UIFont *)buttonFont:(CGFloat)size;
+ (UIFont *)titleFont:(CGFloat)size;
+ (UIFont *)questionFont:(CGFloat)size;
+ (UIFont *)scoreFont:(CGFloat)size;
+ (UIFont *)dateFont:(CGFloat)size;
+ (UIFont *)nameFont:(CGFloat)size;

+ (CGFloat)tinyFont;
+ (CGFloat)xSmallFont;
+ (CGFloat)smallFont;
+ (CGFloat)regularFont;
+ (CGFloat)mediumFont;
+ (CGFloat)largeFont;
+ (CGFloat)xLargeFont;


+ (UIImage *)pictureForCandidate:(NSString *)name;
+ (UIImage *)backgroundForAffiliation:(KMCPartyAffiliation)party;
+ (UIImage *)cellBackgroundForAffiliation:(KMCPartyAffiliation)party;
+ (UIColor *)partyColorForAffiliation:(KMCPartyAffiliation)party;

+ (UIImage *)pictureForIssues:(NSString *)name;
+ (UIColor *)colorForStand:(NSString *)stand;

@end
