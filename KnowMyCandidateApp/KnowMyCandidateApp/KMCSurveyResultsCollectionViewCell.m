#import "KMCSurveyResultsCollectionViewCell.h"

#import "KMCAssets.h"
#import "Parse/Parse.h"

static const CGFloat kButtonTitleInset = 5.f;
static const CGFloat kLeftPadding = 10.f;
static const CGFloat kImageDimension = 80.f;
static const CGFloat kRightPadding = 20.f;
static const CGFloat kScoreWidth = 60.f;

@implementation KMCSurveyResultsCollectionViewCell {
  UILabel *_nameLabel;
  UILabel *_scoreLabel;
  UIImageView *_pictureView;
  UILabel *_rankLabel;
  UIButton *_followButton;
}


- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    self.layer.cornerRadius = 3.f;
    UIView *contentView = self.contentView;

    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:18.f weight:0.4f];
    [contentView addSubview:_nameLabel];

    _scoreLabel = [[UILabel alloc] init];
    _scoreLabel.font = [UIFont systemFontOfSize:14.f];
    [contentView addSubview:_scoreLabel];

    _rankLabel = [[UILabel alloc] init];
    [contentView addSubview:_rankLabel];

    _pictureView = [[UIImageView alloc] init];
    [contentView addSubview:_pictureView];

    _followButton = [[UIButton alloc] init];

    _followButton.titleLabel.font = [UIFont systemFontOfSize:14.f];

    _followButton.layer.cornerRadius = 4.f;
    _followButton.layer.borderColor = [KMCAssets lightBlueColor].CGColor;
    _followButton.layer.borderWidth = 1.f;
    _followButton.titleEdgeInsets =
        UIEdgeInsetsMake(0.f, kButtonTitleInset, 0.f, kButtonTitleInset);
    [_followButton addTarget:self
                      action:@selector(didTapFollowButton)
            forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_followButton];
  }
  return self;
}

- (void)setName:(NSString *)name {
  _name = [name copy];
  _nameLabel.text = _name;
  _pictureView.image = [KMCAssets pictureForCandidate:_name];
  CGRect frame;
  frame.origin.x = kLeftPadding + CGRectGetMaxX(_rankLabel.frame);
  frame.origin.y = CGRectGetMidY(self.contentView.frame) - (kImageDimension / 2.f);
  frame.size.height = kImageDimension;
  frame.size.width = kImageDimension;
  _pictureView.frame = frame;

  [self layoutTextLabels];
}

- (void)setMatchingScore:(NSNumber *)matchingScore {
  _matchingScore = [matchingScore copy];
  _scoreLabel.text = [NSString stringWithFormat:@"Score: %.2f", [_matchingScore floatValue]];
  [_scoreLabel sizeToFit];
  CGRect frame = _scoreLabel.frame;
  frame.origin.x = CGRectGetWidth(self.contentView.frame) - kScoreWidth;
  frame.origin.y = CGRectGetMidY(self.contentView.frame) - _scoreLabel.frame.size.height / 2.f;
  _scoreLabel.frame = frame;

  [self layoutTextLabels];
}

- (void)setRank:(NSInteger)rank {
  _rank = rank;
  NSString *string = [NSString stringWithFormat:@"%lu.", _rank];
  _rankLabel.text = string;
  [_rankLabel sizeToFit];
  CGRect frame = _rankLabel.frame;
  frame.origin.x = kLeftPadding;
  frame.origin.y = CGRectGetMidY(self.contentView.frame) - (CGRectGetWidth(frame) / 2.f);
  _rankLabel.frame = frame;
}

- (void)setIsFollowing:(BOOL)isFollowing {
  _isFollowing = isFollowing;

  if (_isFollowing) {
    [_followButton setTitle:@"Following" forState:UIControlStateNormal];
    [_followButton setTitleColor:[KMCAssets lightGrayBackgroundColor]
                        forState:UIControlStateNormal];
    _followButton.backgroundColor = [KMCAssets lightBlueColor];
  } else {
    [_followButton setTitle:@"Follow" forState:UIControlStateNormal];
    [_followButton setTitleColor:[KMCAssets lightBlueColor] forState:UIControlStateNormal];
    _followButton.backgroundColor = [UIColor whiteColor];
  }

  [_followButton sizeToFit];
  CGRect frame = _followButton.frame;
  frame.origin.y = CGRectGetMidY(self.contentView.frame) - frame.size.height / 2.f;
  frame.origin.x =
      CGRectGetWidth(self.contentView.frame) - kRightPadding - CGRectGetWidth(_followButton.frame);
  frame.size.width += 2 * kButtonTitleInset;
  _followButton.frame = frame;
}

- (void)layoutTextLabels {
  [_nameLabel sizeToFit];
  [_scoreLabel sizeToFit];

  CGRect frame = _nameLabel.frame;
  CGFloat totalHeight = CGRectGetHeight(_nameLabel.frame) + CGRectGetHeight(_scoreLabel.frame);
  frame.origin.x = CGRectGetMaxX(_pictureView.frame) + kLeftPadding;
  frame.origin.y = CGRectGetMidY(self.contentView.frame) - (totalHeight / 2.f);
  _nameLabel.frame = frame;

  frame = _scoreLabel.frame;
  frame.origin.x = _nameLabel.frame.origin.x;
  frame.origin.y = CGRectGetMaxY(_nameLabel.frame);
  _scoreLabel.frame = frame;
}

- (void)didTapFollowButton {
  PFUser *user = [PFUser currentUser];
  NSMutableArray *candidatesFollowed = [[user objectForKey:@"candidatesFollowed"] mutableCopy];
  if (!candidatesFollowed) {
    candidatesFollowed = [[NSMutableArray alloc] init];
  }
  _followButton.enabled = NO;

  if ([_followButton.titleLabel.text isEqualToString:@"Follow"]) {
    [candidatesFollowed addObject:_candidateID];
    [user setObject:[candidatesFollowed copy] forKey:@"candidatesFollowed"];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
      [_followButton setTitle:@"Following" forState:UIControlStateNormal];
      [_followButton setTitleColor:[KMCAssets lightGrayBackgroundColor]
                          forState:UIControlStateNormal];
      _followButton.backgroundColor = [KMCAssets lightBlueColor];
      [_followButton sizeToFit];
      CGRect frame = _followButton.frame;
      frame.origin.x =
          CGRectGetWidth(self.contentView.frame) - kRightPadding - CGRectGetWidth(frame);
      frame.size.width += 2 * kButtonTitleInset;
      _followButton.frame = frame;
      _followButton.enabled = YES;
      [self.delegate didFollowCandidate:YES withID:_candidateID];
    }];
  } else {
    [candidatesFollowed removeObject:_candidateID];
    [user setObject:[candidatesFollowed copy] forKey:@"candidatesFollowed"];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
      [_followButton setTitle:@"Follow" forState:UIControlStateNormal];
      [_followButton setTitleColor:[KMCAssets lightBlueColor] forState:UIControlStateNormal];
      _followButton.backgroundColor = [UIColor whiteColor];
      [_followButton sizeToFit];
      CGRect frame = _followButton.frame;
      frame.origin.x =
          CGRectGetWidth(self.contentView.frame) - kRightPadding - CGRectGetWidth(frame);
      frame.size.width += 2 * kButtonTitleInset;
      _followButton.frame = frame;
      _followButton.enabled = YES;
      [self.delegate didFollowCandidate:NO withID:_candidateID];
    }];
  }
}

@end
