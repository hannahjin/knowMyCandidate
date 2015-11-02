#import "KMCSurveyCollectionViewCell.h"

static const CGFloat kLabelHeight = 30.f;
static const CGFloat kLabelWidth = 60.f;
static const CGFloat kSliderPadding = 20.f;
static const CGFloat kVerticalPadding = 25.f;

@implementation KMCSurveyCollectionViewCell {
  UILabel *_questionLabel;
  UILabel *_stronglyDisagreeLabel;
  UILabel *_disagreeLabel;
  UILabel *_neutralLabel;
  UILabel *_agreeLabel;
  UILabel *_stronglyAgreeLabel;
  UISlider *_slider;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.9f];
    self.layer.cornerRadius = 5.f;

    UIView *contentView = self.contentView;
    _questionLabel = [[UILabel alloc] init];
    _questionLabel.font = [UIFont systemFontOfSize:16.f weight:2.f];
    _questionLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:_questionLabel];

    _slider = [[UISlider alloc] init];
    _slider.minimumValue = 1.f;
    _slider.maximumValue = 5.f;
    [contentView addSubview:_slider];
    _slider.bounds = CGRectMake(0.f,
                                0.f,
                                CGRectGetWidth(contentView.bounds) - kSliderPadding,
                                5.f);
    _slider.center = CGPointMake(CGRectGetMidX(contentView.bounds),
                                 CGRectGetMidY(contentView.bounds));
    _slider.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                               UIViewAutoresizingFlexibleTopMargin |
                               UIViewAutoresizingFlexibleBottomMargin;
    [_slider addTarget:self
                action:@selector(didSlide)
      forControlEvents:UIControlEventTouchDragInside];

    _sliderValue = _slider.minimumValue;
    [self setUpLabels];
  }
  return self;
}

- (void)setUpLabels {
  UIView *contentView = self.contentView;
  _stronglyDisagreeLabel = [[UILabel alloc] init];
  _stronglyDisagreeLabel.text = @"Strongly Disagree";
  _stronglyDisagreeLabel.font = [UIFont systemFontOfSize:10.f];
  _stronglyDisagreeLabel.numberOfLines = 2;
  [contentView addSubview:_stronglyDisagreeLabel];

  _disagreeLabel = [[UILabel alloc] init];
  _disagreeLabel.text = @"Disagree";
  _disagreeLabel.font = [UIFont systemFontOfSize:10.f];
  _disagreeLabel.numberOfLines = 1;
  _disagreeLabel.textAlignment = NSTextAlignmentCenter;
  [contentView addSubview:_disagreeLabel];

  _neutralLabel = [[UILabel alloc] init];
  _neutralLabel.text = @"Neutral";
  _neutralLabel.font = [UIFont systemFontOfSize:10.f];
  _neutralLabel.numberOfLines = 1;
  _neutralLabel.textAlignment = NSTextAlignmentCenter;
  [contentView addSubview:_neutralLabel];

  _agreeLabel = [[UILabel alloc] init];
  _agreeLabel.text = @"Agree";
  _agreeLabel.font = [UIFont systemFontOfSize:10.f];
  _agreeLabel.numberOfLines = 1;
  _agreeLabel.textAlignment = NSTextAlignmentCenter;
  [contentView addSubview:_agreeLabel];

  _stronglyAgreeLabel = [[UILabel alloc] init];
  _stronglyAgreeLabel.text = @"Strongly Agree";
  _stronglyAgreeLabel.font = [UIFont systemFontOfSize:10.f];
  _stronglyAgreeLabel.numberOfLines = 2;
  _stronglyAgreeLabel.textAlignment = NSTextAlignmentRight;
  [contentView addSubview:_stronglyAgreeLabel];

  CGFloat availableWidth = _slider.bounds.size.width;
  CGFloat labelPadding = (availableWidth - (5.f * kLabelWidth)) / 4.f;
  CGFloat originX = _slider.frame.origin.x;
  CGFloat originY = _slider.frame.origin.y + kVerticalPadding;
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
}

- (void)prepareForReuse {
  [super prepareForReuse];
  _questionLabel.text = @"";
}

- (void)setText:(NSString *)text {
  _text = [text copy];
  _questionLabel.text = _text;
  [_questionLabel sizeToFit];
  CGFloat originX =
      CGRectGetMidX(self.contentView.frame) - CGRectGetWidth(_questionLabel.frame)/2.f;
  _questionLabel.frame = CGRectMake(originX,
                                    10.f,
                                    CGRectGetWidth(_questionLabel.frame),
                                    CGRectGetHeight(_questionLabel.frame));
}

- (void)setSliderValue:(CGFloat)sliderValue {
  _slider.value = sliderValue;
}

- (void)didSlide {
  _sliderValue = _slider.value;
  [self.delegate didChangeSliderValueForCell:self];
}

@end
