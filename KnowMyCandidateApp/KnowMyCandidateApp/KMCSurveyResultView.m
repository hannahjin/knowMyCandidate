#import "KMCSurveyResultView.h"
#import "KMCAssets.h"

#import "Parse/Parse.h"

//static const CGFloat kButtonTitleInset = 5.f;
//static const CGFloat kHeaderViewHeight = 210.f;
//static const CGFloat kInfoItemHeight = 45.f;
//static const CGFloat kRightPadding = 20.f;
//static const CGFloat kSegmentHeight = 30.f;
//static const CGFloat kSegmentPadding = 5.f;
//static const CGFloat kStandpointItemHeight = 60.f;
//static const CGFloat kTopPadding = 20.f;
//static const CGFloat kVerticalPadding = 10.f;

@implementation KMCSurveyResultView {
  NSDictionary *_issues;
  NSArray *_infoKeysArray;
  UIView *_headerView;
  UIButton *_followButton;
  UISegmentedControl *_segmentPicker;
  UILabel *_nameLabel;
  UILabel *_experienceLabel;
}

- (instancetype)initWithFrame:(CGRect)frame candidateObject:(NSDictionary *)jsonObject{
  self = [super initWithFrame:frame];

  if (self) {
    NSLog(@"%@", jsonObject);
    _infoKeysArray = @[ @"candidate",
                        @"firstName",
                        @"lastName",
                        @"issues",
                        @"score"];

    _headerView = [[UIView alloc] init];

    _followButton = [[UIButton alloc] init];
    PFUser *user = [PFUser currentUser];
    NSArray *candidatesFollowed = [user objectForKey:@"candidatesFollowed"];
//    if ([candidatesFollowed containsObject:_candidateObject.objectId]) {
//      [_followButton setTitle:@"Following" forState:UIControlStateNormal];
//      [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//      _followButton.backgroundColor = [KMCAssets lightBlueColor];
//    } else {
//      [_followButton setTitle:@"Follow" forState:UIControlStateNormal];
//      [_followButton setTitleColor:[KMCAssets lightBlueColor] forState:UIControlStateNormal];
//      _followButton.backgroundColor = [UIColor whiteColor];
//    }
//    _followButton.layer.cornerRadius = 5.f;
//    _followButton.layer.borderColor = [KMCAssets lightBlueColor].CGColor;
//    _followButton.layer.borderWidth = 2.f;
//    _followButton.titleEdgeInsets =
//    UIEdgeInsetsMake(0.f, kButtonTitleInset, 0.f, kButtonTitleInset);
//    [_followButton addTarget:self
//                      action:@selector(didTapFollowButton)
//            forControlEvents:UIControlEventTouchUpInside];

    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:18.f weight:0.4f];
    _nameLabel.textColor = [UIColor whiteColor];

    _experienceLabel = [[UILabel alloc] init];
    _experienceLabel.font = [UIFont systemFontOfSize:14.f];
    _experienceLabel.textColor = [UIColor whiteColor];

//    _segmentPicker = [[UISegmentedControl alloc] initWithItems:@[ @"Information", @"Standpoints" ]];
//    _segmentPicker.selectedSegmentIndex = 0;
//    [_segmentPicker addTarget:self
//                       action:@selector(didTapSegmentPicker)
//             forControlEvents:UIControlEventValueChanged];


  }

  return self;
}

- (void)layoutSubviews {

}

@end
