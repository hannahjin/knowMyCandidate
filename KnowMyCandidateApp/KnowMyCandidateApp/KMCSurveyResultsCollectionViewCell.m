#import "KMCSurveyResultsCollectionViewCell.h"

#import "KMCAssets.h"

static const CGFloat kLeftPadding = 10.f;
static const CGFloat kImageDimension = 80.f;
static const CGFloat kTextLabelPadding = 10.f;
static const CGFloat kScoreWidth = 60.f;
static const CGFloat kScoreFontSize = 36.f;

@implementation KMCSurveyResultsCollectionViewCell {
  UILabel *_nameLabel;
  UILabel *_scoreLabel;
  UIImageView *_pictureView;
}


- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    self.layer.cornerRadius = 3.f;
    UIView *contentView = self.contentView;

    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:18.f weight:0.4f];
    _nameLabel.textColor = [KMCAssets mainPurpleColor];
    [contentView addSubview:_nameLabel];

    _scoreLabel = [[UILabel alloc] init];
    _scoreLabel.font = [KMCAssets scoreFont:kScoreFontSize];
    _scoreLabel.textColor = [KMCAssets mainPurpleColor];
    [contentView addSubview:_scoreLabel];

    _pictureView = [[UIImageView alloc] init];
    [contentView addSubview:_pictureView];
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

- (void)setScore:(NSString *)score {
  _matchingScore = [score copy];
  _scoreLabel.text = _matchingScore;
  [_scoreLabel sizeToFit];
  CGRect frame = _scoreLabel.frame;
  frame.origin.x = CGRectGetWidth(self.contentView.frame) - kScoreWidth;
  frame.origin.y = CGRectGetMidY(self.contentView.frame) - _scoreLabel.frame.size.height / 2.f;
  _scoreLabel.frame = frame;
}

- (void)layoutTextLabels {
  [_nameLabel sizeToFit];
  CGRect frame = _nameLabel.frame;
  CGFloat totalHeight = CGRectGetHeight(_nameLabel.frame);
  frame.origin.x = kLeftPadding + kTextLabelPadding + kImageDimension;
  frame.origin.y = CGRectGetMidY(self.contentView.frame) - (totalHeight / 2.f);
  _nameLabel.frame = frame;
}

@end
