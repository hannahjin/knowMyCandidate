#import "KMCSurveyResultsCollectionViewCell.h"

#import "KMCAssets.h"
#import "Parse/Parse.h"

NSString *const kCandidatesFollowedKey = @"candidatesFollowed";

static const CGFloat kLeftPadding = 10.f;
static const CGFloat kImageDimension = 80.f;
static const CGFloat kTextLabelPadding = 10.f;
static const CGFloat kScoreWidth = 60.f;
static const CGFloat kScoreFontSize = 36.f;
static const CGFloat kRightPadding = 20.f;
static const CGFloat kButtonTitleInset = 5.f;

@implementation KMCSurveyResultsCollectionViewCell {
  UILabel *_nameLabel;
  UILabel *_partyLabel;
  UILabel *_scoreLabel;
  UIColor *_partyColor;
  UIButton *_followButton;
  UIImageView *_pictureView;
}


- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    self.layer.cornerRadius = 3.f;
    UIView *contentView = self.contentView;

    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:18.f weight:0.25f];
    [contentView addSubview:_nameLabel];

    _partyLabel = [[UILabel alloc] init];
    _partyLabel.font = [UIFont systemFontOfSize:14.f];
    _partyLabel.textColor = [UIColor blackColor];
    [contentView addSubview:_partyLabel];

    _scoreLabel = [[UILabel alloc] init];
    _scoreLabel.font = [KMCAssets scoreFont:kScoreFontSize];
    _scoreLabel.textColor = [KMCAssets mainPurpleColor];
    [contentView addSubview:_scoreLabel];

    _pictureView = [[UIImageView alloc] init];
    [contentView addSubview:_pictureView];


    _followButton = [[UIButton alloc] init];
    PFUser *user = [PFUser currentUser];
    NSArray *candidatesFollowed = [user objectForKey:kCandidatesFollowedKey];
    if ([candidatesFollowed containsObject:_candidateID]) {
      [_followButton setTitle:@"Following" forState:UIControlStateNormal];
      [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      _followButton.backgroundColor = [KMCAssets lightBlueColor];
    } else {
      [_followButton setTitle:@"Follow" forState:UIControlStateNormal];
      [_followButton setTitleColor:[KMCAssets lightBlueColor] forState:UIControlStateNormal];
      _followButton.backgroundColor = [UIColor whiteColor];
    }
    _followButton.layer.cornerRadius = 5.f;
    _followButton.layer.borderColor = [KMCAssets lightBlueColor].CGColor;
    _followButton.layer.borderWidth = 2.f;
    _followButton.titleEdgeInsets =
    UIEdgeInsetsMake(0.f, kButtonTitleInset, 0.f, kButtonTitleInset);
    [_followButton addTarget:self
                      action:@selector(didTapFollowButton)
            forControlEvents:UIControlEventTouchUpInside];

    self.backgroundColor = [UIColor whiteColor];
    self.backgroundView.layer.cornerRadius = 5.f;
    self.backgroundView.layer.masksToBounds = YES;
  }
  return self;
}

- (void)setName:(NSString *)name {
  _name = [name copy];
  _nameLabel.text = _name;
  _pictureView.image = [KMCAssets pictureForCandidate:_name];
  CGRect frame;
  frame.origin.x = kLeftPadding;
  frame.origin.y = CGRectGetMidY(self.contentView.frame) - (kImageDimension / 2.f);
  frame.size.height = kImageDimension;
  frame.size.width = kImageDimension;
  _pictureView.frame = frame;

  [self layoutTextLabels];
}

- (void)setPartyAffilation:(KMCPartyAffiliation)affiliation {
  _affiliation = affiliation;
  if (_affiliation == KMCPartyAffiliationDemocratic) {
    _partyLabel.text = @"Democratic";
    _partyColor = [KMCAssets democraticPartyColor];
  } else if (_affiliation == KMCPartyAffiliationRepublican) {
    _partyLabel.text = @"Republican";
    _partyColor = [KMCAssets republicanPartyColor];
  } else {
    _partyLabel.text = @"Green";
    _partyColor = [KMCAssets greenPartyColor];
  }

  [self layoutTextLabels];
}

- (void)setScore:(NSString *)score {
  _matchingScore = [score copy];
  _scoreLabel.text = [_matchingScore stringValue];
  [_scoreLabel setTextColor:[UIColor blackColor]];
  [_scoreLabel sizeToFit];
  CGRect frame = _scoreLabel.frame;
  frame.origin.x = CGRectGetWidth(self.contentView.frame) - kScoreWidth;
  frame.origin.y = CGRectGetMidY(self.contentView.frame) - _scoreLabel.frame.size.height / 2.f;
  _scoreLabel.frame = frame;
}

- (void)layoutTextLabels {
  [_nameLabel setTextColor:_partyColor];
  NSLog(@"%@", _partyColor);
  [_nameLabel sizeToFit];
  [_partyLabel sizeToFit];
  CGRect frame = _nameLabel.frame;
  CGFloat totalHeight = CGRectGetHeight(_nameLabel.frame);
  frame.origin.x = kLeftPadding + kTextLabelPadding + kImageDimension;
  frame.origin.y = CGRectGetMidY(self.contentView.frame) - (totalHeight / 2.f);
  _nameLabel.frame = frame;

  frame = _partyLabel.frame;
  frame.origin.x = kLeftPadding + kTextLabelPadding + kImageDimension;
  frame.origin.y = CGRectGetMaxY(_nameLabel.frame);
  _partyLabel.frame = frame;
}

- (void)didTapFollowButton {
  PFUser *user = [PFUser currentUser];
  NSMutableArray *candidatesFollowed = [[user objectForKey:kCandidatesFollowedKey] mutableCopy];
  if (!candidatesFollowed) {
    candidatesFollowed = [[NSMutableArray alloc] init];
  }
  _followButton.enabled = NO;

  if ([_followButton.titleLabel.text isEqualToString:@"Follow"]) {
    [candidatesFollowed addObject:_candidateID];
    [user setObject:[candidatesFollowed copy] forKey:kCandidatesFollowedKey];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
      [_followButton setTitle:@"Following" forState:UIControlStateNormal];
      [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      _followButton.backgroundColor = [KMCAssets lightBlueColor];
      [_followButton sizeToFit];
      CGRect frame = _followButton.frame;
      frame.origin.x =
        CGRectGetWidth(self.frame) - kRightPadding - CGRectGetWidth(_followButton.frame);
      frame.size.width += 2 * kButtonTitleInset;
      _followButton.frame = frame;
      _followButton.enabled = YES;
    }];
  } else {
    [candidatesFollowed removeObject:_candidateID];
    [user setObject:[candidatesFollowed copy] forKey:kCandidatesFollowedKey];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
      [_followButton setTitle:@"Follow" forState:UIControlStateNormal];
      [_followButton setTitleColor:[KMCAssets lightBlueColor] forState:UIControlStateNormal];
      _followButton.backgroundColor = [UIColor whiteColor];
      [_followButton sizeToFit];
      CGRect frame = _followButton.frame;
      frame.origin.x =
        CGRectGetWidth(self.frame) - kRightPadding - CGRectGetWidth(_followButton.frame);
      frame.size.width += 2 * kButtonTitleInset;
      _followButton.frame = frame;
      _followButton.enabled = YES;
    }];
  }
}

@end
