#import "KMCTwitterCollectionViewCell.h"

#import "KMCAssets.h"

static const CGFloat kBottomPadding = 10.f;
static const CGFloat kInterItemPadding = 5.f;
static const CGFloat kSidePadding = 10.f;
static const CGFloat kTopPadding = 10.f;
static const CGSize kImageSize = {50.f, 50.f};

@implementation KMCTwitterCollectionViewCell {
  UILabel *_usernameLabel;
  UILabel *_nameLabel;
  UILabel *_timeLabel;
  UILabel *_summaryLabel;
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
    _nameLabel.font = [UIFont systemFontOfSize:13.f weight:0.4f];
    [contentView addSubview:_nameLabel];

    _usernameLabel = [[UILabel alloc] init];
    _usernameLabel.textColor = [UIColor grayColor];
    _usernameLabel.font = [UIFont systemFontOfSize:13.f];
    [contentView addSubview:_usernameLabel];

    _sourceIconView = [[UIImageView alloc] initWithImage:[KMCAssets twitterIcon]];
    [_sourceIconView sizeToFit];
    [contentView addSubview:_sourceIconView];

    _summaryLabel = [[UILabel alloc] init];
    _summaryLabel.numberOfLines = 0;
    _summaryLabel.font = [UIFont systemFontOfSize:13.f];
    [contentView addSubview:_summaryLabel];

    _thumbnailView = [[UIImageView alloc] init];
    _thumbnailView.layer.cornerRadius = 5.f;
    _thumbnailView.layer.masksToBounds = YES;
    [contentView addSubview:_thumbnailView];

    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor grayColor];
    _timeLabel.font = [UIFont systemFontOfSize:12.f];
    [contentView addSubview:_timeLabel];
  }
  return self;
}

- (void)setThumbnail:(UIImage *)thumbnail {
  _thumbnail = thumbnail;
  _thumbnailView.image = thumbnail;
  [self setNeedsLayout];
}

- (void)setTimestamp:(NSString *)timestamp {
  _timestamp = [timestamp copy];
  _timeLabel.text = _timestamp;
  [_timeLabel sizeToFit];
}

- (void)setCandidateName:(NSString *)candidateName {
  _candidateName = [candidateName copy];
  _nameLabel.text = _candidateName;
  [_nameLabel sizeToFit];
}

- (void)setTwitterID:(NSString *)twitterID {
  _twitterID = [NSString stringWithFormat:@"@%@", [twitterID copy]];
  _usernameLabel.text = _twitterID;
  [_usernameLabel sizeToFit];
}

- (void)setSummary:(NSString *)summary {
  _summary = [summary copy];
  _summaryLabel.text = _summary;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  CGRect frame = CGRectZero;
  if (_thumbnail) {
    frame.size = kImageSize;
    frame.origin.x = kSidePadding;
    frame.origin.y = kTopPadding;
  }
  _thumbnailView.frame = frame;

  frame = _timeLabel.frame;
  frame.origin.x = CGRectGetWidth(self.contentView.frame) - kSidePadding - frame.size.width;
  frame.origin.y = CGRectGetHeight(self.contentView.frame) - kBottomPadding - frame.size.height;
  _timeLabel.frame = frame;

  frame = _sourceIconView.frame;
  frame.origin.x = CGRectGetMinX(_timeLabel.frame) - CGRectGetWidth(frame) - kInterItemPadding;
  frame.origin.y = CGRectGetHeight(self.contentView.frame) - kBottomPadding - frame.size.height;
  _sourceIconView.frame = frame;

  frame = _nameLabel.frame;
  frame.origin.x = CGRectGetMaxX(_thumbnailView.frame) + 2.f * kInterItemPadding;
  frame.origin.y = kTopPadding;
  _nameLabel.frame = frame;

  frame = _usernameLabel.frame;
  frame.origin.x = CGRectGetMaxX(_nameLabel.frame) + kInterItemPadding;
  frame.origin.y = kTopPadding;
  _usernameLabel.frame = frame;

  CGFloat availableWidth =
      CGRectGetWidth(self.contentView.frame) - CGRectGetMinX(_nameLabel.frame);
  availableWidth -= (kInterItemPadding + kSidePadding);
  CGFloat topConstraint = CGRectGetMaxY(_nameLabel.frame);
  CGFloat bottomConstraint = CGRectGetMinY(_sourceIconView.frame);
  CGFloat availableHeight = bottomConstraint - topConstraint;
  availableHeight -= (2.f * kInterItemPadding);
  frame = [_summaryLabel.text boundingRectWithSize:CGSizeMake(availableWidth, availableHeight)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{ NSFontAttributeName:_summaryLabel.font }
                                           context:nil];
  frame.origin.x = CGRectGetMinX(_nameLabel.frame);
  frame.origin.y = CGRectGetMaxY(_nameLabel.frame) + kInterItemPadding;
  _summaryLabel.frame = frame;
}

@end
