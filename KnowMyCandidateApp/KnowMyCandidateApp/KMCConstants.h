#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, KMCPartyAffiliation) {
  KMCPartyAffiliationDemocratic = 1 << 0,
  KMCPartyAffiliationRepublican = 1 << 1,
  KMCPartyAffiliationGreen = 1 << 2,
};

@interface KMCConstants : NSObject

@end
