#import "KMCInfoCollectionViewCell.h"

#import "KMCAssets.h"

static const CGFloat kLabelPadding = 25.f;
static const CGFloat kSidePadding = 20.f;
static const CGSize kImageSize = {24.f, 24.f};

@implementation KMCInfoCollectionViewCell {
  UIButton *_fbLinkButton;
  UIButton *_webLinkButton;
  UILabel *_titleLabel;
  UILabel *_subtitleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:15.f weight:0.9f];
    [self.contentView addSubview:_titleLabel];

    _subtitleLabel = [[UILabel alloc] init];
    _subtitleLabel.font = [UIFont systemFontOfSize:14.f];

    _fbLinkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_fbLinkButton setImage:[KMCAssets facebookIcon] forState:UIControlStateNormal];
    [_fbLinkButton addTarget:self
                      action:@selector(didTapFbButton)
            forControlEvents:UIControlEventTouchUpInside];

    _webLinkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_webLinkButton setImage:[KMCAssets globeIcon] forState:UIControlStateNormal];
    [_webLinkButton addTarget:self
                       action:@selector(didTapWebButton)
             forControlEvents:UIControlEventTouchUpInside];
  }
  return self;
}

- (void)setTitle:(NSString *)title {
  _title = [title copy];
  _titleLabel.text = _title;

  [_titleLabel sizeToFit];
  CGRect frame = _titleLabel.frame;
  frame.origin.x = kSidePadding;
  frame.origin.y = CGRectGetMidY(self.contentView.frame) - CGRectGetHeight(frame) / 2.f;
  _titleLabel.frame = frame;
}

- (void)setSubtitle:(NSString *)subtitle {
  if (!subtitle || [subtitle isEqualToString:@""]) {
    _subtitle = @"N/A";
  } else {
    _subtitle = [subtitle copy];
  }
  _subtitleLabel.text = _subtitle;

  [_fbLinkButton removeFromSuperview];
  [_webLinkButton removeFromSuperview];
  [self.contentView addSubview:_subtitleLabel];

  [_subtitleLabel sizeToFit];
  CGRect frame = _subtitleLabel.frame;
  frame.origin.x = CGRectGetMaxX(_titleLabel.frame) + kLabelPadding;
  frame.origin.y = CGRectGetMidY(self.contentView.frame) - CGRectGetHeight(frame) / 2.f;
  _subtitleLabel.frame = frame;
}

- (void)setFbLink:(NSString *)fbLink {
  _fbLink = [fbLink copy];

  [_subtitleLabel removeFromSuperview];
  [self.contentView addSubview:_fbLinkButton];
  CGRect frame;
  frame.size = kImageSize;
  frame.origin.x = CGRectGetMaxX(_titleLabel.frame) + kLabelPadding;
  frame.origin.y = CGRectGetMidY(self.contentView.frame) - CGRectGetHeight(frame) / 2.f;
  _fbLinkButton.frame = frame;
}

- (void)setWebLink:(NSString *)webLink {
  _webLink = [webLink copy];

  [_subtitleLabel removeFromSuperview];
  [self.contentView addSubview:_webLinkButton];
  CGRect frame;
  frame.size = kImageSize;
  frame.origin.x = CGRectGetMaxX(_fbLinkButton.frame) + kLabelPadding;
  frame.origin.y = CGRectGetMidY(self.contentView.frame) - CGRectGetHeight(frame) / 2.f;
  _webLinkButton.frame = frame;
}

- (void)didTapFbButton {
  NSURL *url = [NSURL URLWithString:_fbLink];
  [self.delegate openUrl:url];
}

- (void)didTapWebButton {
  NSURL *url = [NSURL URLWithString:_webLink];
  [self.delegate openUrl:url];
}

@end
