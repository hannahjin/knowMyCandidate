#import "KMCSurveyCollectionViewCell.h"

#import "KMCAssets.h"

static const CGFloat kLabelHeight = 30.f;
static const CGFloat kLabelWidth = 60.f;
static const CGFloat kSliderPadding = 20.f;
static const CGFloat kScoreSliderOffset = -25.f;
static const CGFloat kWeightLeftPadding = 45.f;
static const CGFloat kWeightSliderOffset = 50.f;
static const CGFloat kVerticalPadding = 20.f;
static const CGFloat kTitlePadding = 30.f;

@implementation KMCSurveyCollectionViewCell {
  UILabel *_questionLabel;
  UILabel *_importanceLabel;
  UILabel *_stronglyDisagreeLabel;
  UILabel *_disagreeLabel;
  UILabel *_neutralLabel;
  UILabel *_agreeLabel;
  UILabel *_stronglyAgreeLabel;
  UILabel *_superLabel;
  UILabel *_notAtAllLabel;
  KMCSlider *_scoreSlider;
  KMCSlider *_weightSlider;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
    self.layer.cornerRadius = 3.f;

    UIView *contentView = self.contentView;
    _questionLabel = [[UILabel alloc] init];
    _questionLabel.font = [KMCAssets questionFont:[KMCAssets mediumFont]];
    _questionLabel.textAlignment = NSTextAlignmentCenter;
    _questionLabel.numberOfLines = 2;
    [contentView addSubview:_questionLabel];

    _scoreSlider = [[KMCSlider alloc] init];
    _scoreSlider.minimumValue = 1.f;
    _scoreSlider.maximumValue = 5.f;
    _scoreSlider.value = 3.f;
    [contentView addSubview:_scoreSlider];
    _scoreSlider.bounds = CGRectMake(0.f,
                                     0.f,
                                     CGRectGetWidth(contentView.bounds) - kSliderPadding,
                                     5.f);
    _scoreSlider.center = CGPointMake(CGRectGetMidX(contentView.bounds),
                                      CGRectGetMidY(contentView.bounds) + kScoreSliderOffset);
    _scoreSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                    UIViewAutoresizingFlexibleTopMargin |
                                    UIViewAutoresizingFlexibleBottomMargin;
    [_scoreSlider addTarget:self
                     action:@selector(didSlideScore)
           forControlEvents:UIControlEventTouchDragInside];

    _score = _scoreSlider.value;

    _importanceLabel = [[UILabel alloc] init];
    _importanceLabel.text = @"Importance";
    _importanceLabel.font = [KMCAssets questionFont:[KMCAssets regularFont]];
    _importanceLabel.textAlignment = NSTextAlignmentLeft;
    [contentView addSubview:_importanceLabel];

    _weightSlider = [[KMCSlider alloc] init];
    _weightSlider.minimumValue = 1.f;
    _weightSlider.maximumValue = 3.f;
    _weightSlider.value = 2.f;
    [contentView addSubview:_weightSlider];
    CGFloat width = 3.f * CGRectGetWidth(_scoreSlider.frame) / 5.f;
    _weightSlider.bounds = CGRectMake(0.f, 0.f, width, 5.f);
    _weightSlider.center = CGPointMake(CGRectGetMidX(contentView.bounds) + kWeightLeftPadding,
                                       CGRectGetMidY(contentView.bounds) + kWeightSliderOffset);
    _weightSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                     UIViewAutoresizingFlexibleTopMargin |
                                     UIViewAutoresizingFlexibleBottomMargin;
    [_weightSlider addTarget:self
                      action:@selector(didSlideWeight)
            forControlEvents:UIControlEventTouchDragInside];

    _weight = _weightSlider.value;

    [self setUpLabels];
  }
  return self;
}

- (void)setUpLabels {
  UIView *contentView = self.contentView;
  _stronglyDisagreeLabel = [[UILabel alloc] init];
  _stronglyDisagreeLabel.text = @"Strongly Disagree";
  _stronglyDisagreeLabel.font = [KMCAssets labelFont:[KMCAssets tinyFont]];
  _stronglyDisagreeLabel.numberOfLines = 2;
  [contentView addSubview:_stronglyDisagreeLabel];

  _disagreeLabel = [[UILabel alloc] init];
  _disagreeLabel.text = @"Disagree";
  _disagreeLabel.font = [KMCAssets labelFont:[KMCAssets tinyFont]];
  _disagreeLabel.numberOfLines = 1;
  _disagreeLabel.textAlignment = NSTextAlignmentCenter;
  [contentView addSubview:_disagreeLabel];

  _neutralLabel = [[UILabel alloc] init];
  _neutralLabel.text = @"Neutral";
  _neutralLabel.font = [KMCAssets labelFont:[KMCAssets tinyFont]];
  _neutralLabel.numberOfLines = 1;
  _neutralLabel.textAlignment = NSTextAlignmentCenter;
  [contentView addSubview:_neutralLabel];

  _agreeLabel = [[UILabel alloc] init];
  _agreeLabel.text = @"Agree";
  _agreeLabel.font = [KMCAssets labelFont:[KMCAssets tinyFont]];
  _agreeLabel.numberOfLines = 1;
  _agreeLabel.textAlignment = NSTextAlignmentCenter;
  [contentView addSubview:_agreeLabel];

  _stronglyAgreeLabel = [[UILabel alloc] init];
  _stronglyAgreeLabel.text = @"Strongly Agree";
  _stronglyAgreeLabel.font = [KMCAssets labelFont:[KMCAssets tinyFont]];
  _stronglyAgreeLabel.numberOfLines = 2;
  _stronglyAgreeLabel.textAlignment = NSTextAlignmentRight;
  [contentView addSubview:_stronglyAgreeLabel];

  CGFloat availableWidth = _scoreSlider.bounds.size.width;
  CGFloat labelPadding = (availableWidth - (5.f * kLabelWidth)) / 4.f;
  CGFloat originX = _scoreSlider.frame.origin.x;
  CGFloat originY = _scoreSlider.frame.origin.y + kVerticalPadding;
  CGRect frame = CGRectMake(originX, originY, kLabelWidth, kLabelHeight);
  _stronglyDisagreeLabel.frame = frame;

  originX = CGRectGetMaxX(_stronglyDisagreeLabel.frame) + labelPadding;
  frame.origin.x = originX;
  _disagreeLabel.frame = frame;

  originX = CGRectGetMaxX(_disagreeLabel.frame) + labelPadding;
  frame.origin.x = originX;
  _neutralLabel.frame = frame;

  originX = CGRectGetMaxX(_neutralLabel.frame) + labelPadding;
  frame.origin.x = originX;
  _agreeLabel.frame = frame;

  originX = CGRectGetMaxX(_agreeLabel.frame) + labelPadding;
  frame.origin.x = originX;
  _stronglyAgreeLabel.frame = frame;

  [_importanceLabel sizeToFit];
  _importanceLabel.center = CGPointMake(CGRectGetMidX(_importanceLabel.bounds) + kSliderPadding,
                                        CGRectGetMidY(contentView.bounds) + kWeightSliderOffset);

  _notAtAllLabel = [[UILabel alloc] init];
  _notAtAllLabel.text = @"Not At All";
  _notAtAllLabel.font = [KMCAssets labelFont:[KMCAssets tinyFont]];
  _notAtAllLabel.numberOfLines = 1;
  _notAtAllLabel.textAlignment = NSTextAlignmentLeft;
  [contentView addSubview:_notAtAllLabel];

  _superLabel = [[UILabel alloc] init];
  _superLabel.text = @"Super";
  _superLabel.font = [KMCAssets labelFont:[KMCAssets tinyFont]];
  _superLabel.numberOfLines = 1;
  _superLabel.textAlignment = NSTextAlignmentRight;
  [contentView addSubview:_superLabel];

  frame = _notAtAllLabel.frame;
  frame.origin.x = _weightSlider.frame.origin.x;
  frame.origin.y = _weightSlider.frame.origin.y + kVerticalPadding;
  frame.size.height = kLabelHeight;
  frame.size.width = kLabelWidth;
  _notAtAllLabel.frame = frame;

  frame = _superLabel.frame;
  frame.origin.x = CGRectGetMaxX(_weightSlider.frame) - kLabelWidth;
  frame.origin.y = _weightSlider.frame.origin.y + kVerticalPadding;
  frame.size.height = kLabelHeight;
  frame.size.width = kLabelWidth;
  _superLabel.frame = frame;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  _questionLabel.text = @"";
}

- (void)setText:(NSString *)text {
  _text = [text copy];
  _questionLabel.text = _text;
  CGFloat availableWidth = CGRectGetWidth(self.contentView.frame) - kTitlePadding;
  CGSize size = [_questionLabel sizeThatFits:CGSizeMake(availableWidth, CGFLOAT_MAX)];
  CGFloat originX = CGRectGetMidX(self.contentView.frame) - size.width / 2.f;
  _questionLabel.frame = CGRectMake(originX, 10.f, size.width, size.height);
}

- (void)setScoreValue:(CGFloat)sliderValue {
  _scoreSlider.value = sliderValue;
}

- (void)setWeightValue:(CGFloat)sliderValue {
  _weightSlider.value = sliderValue;
}

- (void)didSlideScore {
  _score = _scoreSlider.value;
  [self.delegate didChangeScoreValueForCell:self];
}

- (void)didSlideWeight {
  _weight = _weightSlider.value;
  [self.delegate didChangeWeightValueForCell:self];
}

@end
