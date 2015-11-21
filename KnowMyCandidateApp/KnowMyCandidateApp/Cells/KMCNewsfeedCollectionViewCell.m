#import "KMCNewsfeedCollectionViewCell.h"

#import "KMCAssets.h"

static const CGFloat kBottomPadding = 10.f;
static const CGFloat kLabelPadding = 5.f;
static const CGFloat kImageSidePadding = 10.f;
static const CGFloat kTitleSidePadding = 15.f;
static const CGFloat kTopPadding = 15.f;
static const CGSize kImageSize = {100.f, 100.f};

@implementation KMCNewsfeedCollectionViewCell {
  UILabel *_nameLabel;
  UILabel *_timeLabel;
  UILabel *_titleLabel;
  UILabel *_sourceLabel;
  UILabel *_subtitleLabel;
  UIImageView *_sourceIconView;
  UIImageView *_thumbnailView;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                        UIViewAutoresizingFlexibleHeight;

    self.layer.borderColor = [UIColor colorWithWhite:0.1f alpha:0.1f].CGColor;
    self.layer.borderWidth = 0.3f;

    UIView *contentView = self.contentView;

    self.backgroundView = [[UIView alloc] initWithFrame:self.contentView.frame];
    self.backgroundView.backgroundColor = [UIColor whiteColor];

    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.backgroundColor = [UIColor darkGrayColor];
    _nameLabel.font = [UIFont systemFontOfSize:7.f];
    _nameLabel.layer.borderWidth = 2.f;
    _nameLabel.layer.masksToBounds = YES;
    [contentView addSubview:_nameLabel];

    _sourceLabel = [[UILabel alloc] init];
    _sourceLabel.textColor = [UIColor grayColor];
    _sourceLabel.font = [UIFont systemFontOfSize:12.f];
    [contentView addSubview:_sourceLabel];

    _sourceIconView = [[UIImageView alloc] initWithImage:[KMCAssets newspaperIcon]];
    [contentView addSubview:_sourceIconView];

    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor grayColor];
    _timeLabel.font = [UIFont systemFontOfSize:12.f];
    [contentView addSubview:_timeLabel];

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.numberOfLines = 3;
    _titleLabel.font = [UIFont systemFontOfSize:17.f weight:0.4f];
    [contentView addSubview:_titleLabel];

    _subtitleLabel = [[UILabel alloc] init];
    _subtitleLabel.numberOfLines = 0;
    _subtitleLabel.textColor = [UIColor grayColor];
    _subtitleLabel.font = [UIFont systemFontOfSize:13.f];
    [contentView addSubview:_subtitleLabel];

    _thumbnailView = [[UIImageView alloc] init];
    [contentView addSubview:_thumbnailView];
  }
  return self;
}

- (void)setTimestamp:(NSString *)timestamp {
  _timestamp = [timestamp copy];
  _timeLabel.text = _timestamp;
  [_timeLabel sizeToFit];
}

- (void)setSource:(NSString *)source {
  _source = [source copy];
  _sourceLabel.text = _source;

  [_sourceLabel sizeToFit];
  [_sourceIconView sizeToFit];
}

- (void)setThumbnail:(UIImage *)thumbnail {
  _thumbnail = thumbnail;
  _thumbnailView.image = thumbnail;
  [self setNeedsLayout];
}

- (void)setTitle:(NSString *)title {
  _title = [title copy];
  _titleLabel.text = _title;
}

- (void)setSubtitle:(NSString *)subtitle {
  _subtitle = [subtitle copy];
  _subtitleLabel.text = _subtitle;
}

- (void)setCandidateName:(NSString *)candidateName {
  _candidateName = [candidateName copy];
  _nameLabel.text = _candidateName;

  [_nameLabel sizeToFit];
}

- (void)prepareForReuse {
  [super prepareForReuse];
  _nameLabel.text = @"";
  _sourceLabel.text = @"";
  _timeLabel.text = @"";
  _titleLabel.text = @"";
  _subtitleLabel.text = @"";
  _sourceIconView.image = nil;
  _thumbnailView.image = nil;
}

- (void)layoutSubviews {
  CGRect frame = CGRectZero;
  if (_thumbnail) {
    frame.size = kImageSize;
    frame.origin.x = CGRectGetWidth(self.contentView.frame) - kImageSidePadding - kImageSize.width;
    frame.origin.y = CGRectGetMidY(self.contentView.frame) - kImageSize.height / 2.f;
  }
  _thumbnailView.frame = frame;

  frame = _nameLabel.frame;
  frame.origin.x = CGRectGetMidX(_thumbnailView.frame) - CGRectGetWidth(_nameLabel.frame) / 2.f;
  frame.origin.y = CGRectGetMinY(_thumbnailView.frame) - CGRectGetHeight(frame) - kLabelPadding;
  _nameLabel.frame = frame;

  CGFloat availableWidth =
      CGRectGetWidth(self.contentView.frame) - CGRectGetWidth(_thumbnailView.frame);
  availableWidth -= (kImageSidePadding * 2.f + kTitleSidePadding);
  _titleLabel.preferredMaxLayoutWidth = availableWidth;
  CGSize size = [_titleLabel sizeThatFits:CGSizeMake(availableWidth, CGFLOAT_MAX)];
  frame.size = size;
  frame.origin.x = kTitleSidePadding;
  frame.origin.y = kTopPadding;
  _titleLabel.frame = frame;

  frame = _sourceIconView.frame;
  frame.origin.x = kTitleSidePadding;
  frame.origin.y = CGRectGetHeight(self.contentView.frame) - kBottomPadding - frame.size.height;
  _sourceIconView.frame = frame;

  frame = _sourceLabel.frame;
  frame.origin.x = CGRectGetMaxX(_sourceIconView.frame) + kLabelPadding;
  frame.origin.y = CGRectGetHeight(self.contentView.frame) - kBottomPadding - frame.size.height;
  _sourceLabel.frame = frame;

  frame = _timeLabel.frame;
  frame.origin.x = CGRectGetWidth(self.contentView.frame) - kImageSidePadding - frame.size.width;
  frame.origin.y = CGRectGetHeight(self.contentView.frame) - kBottomPadding - frame.size.height;
  _timeLabel.frame = frame;


  _subtitleLabel.preferredMaxLayoutWidth = availableWidth;
  CGFloat topConstraint =
      CGRectIsEmpty(_titleLabel.frame) ? kTopPadding : CGRectGetMaxY(_titleLabel.frame);
  CGFloat bottomConstraint = CGRectGetMinY(_sourceLabel.frame);
  CGFloat availableHeight = bottomConstraint - topConstraint;
  availableHeight -= (kLabelPadding * 2.f);
  frame = [_subtitleLabel.text boundingRectWithSize:CGSizeMake(availableWidth, availableHeight)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{ NSFontAttributeName:_subtitleLabel.font }
                                            context:nil];
  frame.origin.x = kTitleSidePadding;
  frame.origin.y = topConstraint + kLabelPadding;
  _subtitleLabel.frame = frame;
}

@end
