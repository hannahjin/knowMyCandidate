#import "KMCAssets.h"

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

+ (UIImage *)homeTabIcon {
  return [UIImage imageNamed:@"HomeTabIcon.png"];
}

+ (UIImage *)issuesTabIcon {
  return [UIImage imageNamed:@"IssuesTabIcon.png"];
}

+ (UIImage *)signInBackground {
  return [UIImage imageNamed:@"SignInBackground.png"];
}

+ (UIImage *)userTabIcon {
  return [UIImage imageNamed:@"UserTabIcon.png"];
}

#pragma mark - UIColor

+ (UIColor *)mainPurpleColor {
  return [UIColor colorWithRed:88.0/255.0 green:86.0/255.0 blue:214.0/255.0 alpha:1.0];
}

@end
