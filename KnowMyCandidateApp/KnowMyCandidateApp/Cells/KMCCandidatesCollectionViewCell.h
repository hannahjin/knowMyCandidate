#import <UIKit/UIKit.h>

#import "KMCConstants.h"

@interface KMCCandidatesCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *candidateID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *experience;
@property (nonatomic) KMCPartyAffiliation affiliation;

@end
