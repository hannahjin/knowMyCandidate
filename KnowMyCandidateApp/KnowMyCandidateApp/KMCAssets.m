#import "KMCAssets.h"

@implementation KMCSlider

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
  CGRect bounds = self.bounds;
  bounds = CGRectInset(bounds, -10, -10);
  return CGRectContainsPoint(bounds, point);
}

@end

@implementation KMCTextField {
  BOOL _showCaret;
}

- (instancetype)initWithCaret:(BOOL)caret {
  self = [super init];
  if (self) {
    _showCaret = caret;
  }
  return self;
}

- (CGRect)caretRectForPosition:(UITextPosition *)position {
  if (_showCaret) {
    return [super caretRectForPosition:position];
  }
  return CGRectZero;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
  return CGRectInset(bounds, 10.f, 0.f);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
  return CGRectInset(bounds, 10.f, 0.f);
}

@end

@implementation KMCToolbar

- (void)drawRect:(CGRect)rect {
}

- (void)applyTranslucentBackground {
  self.backgroundColor = [UIColor clearColor];
  self.opaque = NO;
  self.translucent = YES;
}

- (instancetype)initWithFrame:(CGRect) frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self applyTranslucentBackground];
  }
  return self;
}

@end

@implementation KMCAssets

+ (UIImage *)backArrowIcon {
  return [UIImage imageNamed:@"BackArrow.png"];
}

+ (UIImage *)candidatesTabIcon {
  return [UIImage imageNamed:@"CandidatesTabIcon.png"];
}

+ (UIImage *)eventsTabIcon {
  return [UIImage imageNamed:@"EventsTabIcon.png"];
}

+ (UIImage *)facebookIcon {
  return [UIImage imageNamed:@"Facebook.png"];
}

+ (UIImage *)globeIcon {
  return [UIImage imageNamed:@"GlobeIcon.png"];
}

+ (UIImage *)homeTabIcon {
  return [UIImage imageNamed:@"HomeTabIcon.png"];
}

+ (UIImage *)issuesTabIcon {
  return [UIImage imageNamed:@"IssuesTabIcon.png"];
}

+ (UIImage *)newspaperIcon {
  return [UIImage imageNamed:@"NewspaperIcon.png"];
}

+ (UIImage *)signInBackground {
  return [UIImage imageNamed:@"SignInBackground.png"];
}

+ (UIImage *)twitterIcon {
  return [UIImage imageNamed:@"TwitterIcon.png"];
}

+ (UIImage *)userTabIcon {
  return [UIImage imageNamed:@"UserTabIcon.png"];
}

#pragma mark - UIColor

+ (UIColor *)democraticPartyColor {
  return [UIColor colorWithRed:36.0/255.0 green:77.0/255.0 blue:125.0/255.0 alpha:1.0];
}

+ (UIColor *)republicanPartyColor {
  return [UIColor colorWithRed:187.0/255.0 green:17.0/255.0 blue:38.0/255.0 alpha:1.0];
}

+ (UIColor *)greenPartyColor {
  return [UIColor colorWithRed:36.0/255.0 green:170.0/255.0 blue:95.0/255.0 alpha:1.0];
}

+ (UIColor *)mainPurpleColor {
  return [UIColor colorWithRed:88.0/255.0 green:86.0/255.0 blue:214.0/255.0 alpha:1.0];
}

+ (UIColor *)lightBlueColor {
  return [UIColor colorWithRed:0.0/255.0 green:204.0/255.0 blue:255.0/255.0 alpha:1.0];
}

+ (UIColor *)lightGrayBackgroundColor {
  return [UIColor colorWithWhite:0.95f alpha:1.0f];
}

#pragma mark - UIFont

+ (UIFont *)labelFont:(CGFloat)size {
  return [UIFont fontWithName:@"OpenSans" size:size];
}

+ (UIFont *)buttonFont:(CGFloat)size {
  return [UIFont fontWithName:@"BebasNeue" size:size];
}

+ (UIFont *)titleFont:(CGFloat)size {
  return [UIFont fontWithName:@"BebasNeueBook" size:size];
}

+ (UIFont *)questionFont:(CGFloat)size {
  return [UIFont fontWithName:@"MyriadPro" size:size];
}

+ (UIFont *)scoreFont:(CGFloat)size {
  return [UIFont fontWithName:@"MyriadPro-Semibold" size:size];
}

+ (UIFont *)dateFont:(CGFloat)size {
  return [UIFont fontWithName:@"OpenSans" size:size];
}

+ (UIFont *)nameFont:(CGFloat)size {
  return [UIFont fontWithName:@"OpenSans" size:size];
}

#pragma mark - Font Size

+ (CGFloat)tinyFont {
  return 10.0f;
}

+ (CGFloat)xSmallFont {
  return 14.0f;
}

+ (CGFloat)smallFont {
  return 16.0f;
}

+ (CGFloat)regularFont {
  return 18.0f;
}

+ (CGFloat)mediumFont {
  return 20.0f;
}

+ (CGFloat)largeFont {
  return 24.0f;
}

+ (CGFloat)xLargeFont {
  return 30.0f;
}

#pragma mark - Candidates

+ (UIImage *)pictureForCandidate:(NSString *)name {
  NSString *string = [name stringByReplacingOccurrencesOfString:@" " withString:@"_"];
  return [UIImage imageNamed:string];
}

+ (UIImage *)backgroundForAffiliation:(KMCPartyAffiliation)party {
  switch (party) {
    case KMCPartyAffiliationDemocratic:
      return [UIImage imageNamed:@"DemocratBackground.png"];
    case KMCPartyAffiliationRepublican:
      return [UIImage imageNamed:@"RepublicanBackground.png"];
    default:
      return nil;
  }
}

+ (UIImage *)cellBackgroundForAffiliation:(KMCPartyAffiliation)party {
  switch (party) {
    case KMCPartyAffiliationDemocratic:
      return [UIImage imageNamed:@"DemocratCellBackground.png"];
    case KMCPartyAffiliationRepublican:
      return [UIImage imageNamed:@"RepublicanCellBackground.png"];
    default:
      return nil;
  }
}

+ (UIColor *)partyColorForAffiliation:(KMCPartyAffiliation)party {
  switch (party) {
    case KMCPartyAffiliationDemocratic:
      return [self democraticPartyColor];
    case KMCPartyAffiliationRepublican:
      return [self republicanPartyColor];
    case KMCPartyAffiliationGreen:
      return [self greenPartyColor];
  }
}

#pragma mark - Issues

+ (UIImage *)pictureForIssues:(NSString *)name {
  NSString *string = [name stringByReplacingOccurrencesOfString:@" " withString:@"_"];
  return [UIImage imageNamed:string];
}

+ (UIColor *)colorForStand:(NSString *)stand {
  if ([stand isEqualToString:@"Strongly Disagrees"]) {
    return [UIColor redColor];
  } else if ([stand isEqualToString:@"Disagrees"]) {
    return [UIColor orangeColor];
  } else if ([stand isEqualToString:@"Neutral/No opinion"]) {
    return [UIColor grayColor];
  } else if ([stand isEqualToString:@"Agrees"]) {
    return [UIColor colorWithRed:2.0/255.0 green:204.0/255.0 blue:191.0/255.0 alpha:1.0];
  } else {
    return [UIColor colorWithRed:0.0 green:163.0/255.0 blue:0.0 alpha:1.0];
  }
}

@end
