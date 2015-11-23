#import "KMCIssuesCollectionViewCell.h"

#import "KMCAssets.h"

static const CGFloat kTextPadding = 10.f;

@implementation KMCIssuesCollectionViewCell {
  UILabel *_nameLabel;
  UIImageView *_pictureView;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = [UIColor whiteColor];

    UIView *contentView = self.contentView;
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont boldSystemFontOfSize:18.f];
    _nameLabel.numberOfLines = 2;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = [UIColor whiteColor];
    
    _pictureView = [[UIImageView alloc] init];
    [contentView addSubview:_pictureView];

    UIView *overlayView = [[UIView alloc] initWithFrame:self.contentView.frame];
    overlayView.layer.backgroundColor = [UIColor blackColor].CGColor;
    overlayView.layer.opacity = 0.5f;
    [_pictureView addSubview:overlayView];

    [_pictureView addSubview:_nameLabel];
  }
  return self;
}

- (void)setIssueName:(NSString *)issueName {
  _issueName = [issueName copy];
  _nameLabel.text = _issueName;
  _pictureView.image = [KMCAssets pictureForIssues:_issueName];

  _pictureView.frame = self.contentView.frame;
  
  [self layoutTextLabels];
}

- (void)layoutTextLabels {
  CGSize size = self.contentView.frame.size;
  size.width -= kTextPadding;
  size = [_nameLabel sizeThatFits:size];
  CGRect frame = _nameLabel.frame;
  frame.origin.x = CGRectGetMidX(_pictureView.frame) - size.width / 2.f;
  frame.origin.y = CGRectGetMidY(_pictureView.frame) - size.height / 2.f;
  frame.size = size;
  _nameLabel.frame = frame;
}

@end
