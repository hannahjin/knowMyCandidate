#import "KMCStandpointsCollectionViewCell.h"

#import "KMCAssets.h"

static const CGFloat kIssueTextMaxWidth = 200.f;
static const CGFloat kStandTextMaxWidth = 100.f;
static const CGFloat kSidePadding = 20.f;

@implementation KMCStandpointsCollectionViewCell {
  UILabel *_issueLabel;
  UILabel *_standLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.layer.borderColor = [UIColor colorWithWhite:0.1f alpha:0.1f].CGColor;
    self.layer.borderWidth = 0.3f;

    _issueLabel = [[UILabel alloc] init];
    _issueLabel.numberOfLines = 2;
    _issueLabel.font = [UIFont systemFontOfSize:14.f];
    [self.contentView addSubview:_issueLabel];

    _standLabel = [[UILabel alloc] init];
    _standLabel.numberOfLines = 2;
    _standLabel.font = [UIFont systemFontOfSize:15.f weight:0.9f];
    [self.contentView addSubview:_standLabel];
  }
  return self;
}

- (void)setIssue:(NSString *)issue {
  _issue = [issue copy];
  _issueLabel.text = _issue;

  CGSize size =
      [_issueLabel sizeThatFits:CGSizeMake(kIssueTextMaxWidth, CGRectGetHeight(self.frame))];
  CGRect frame = _issueLabel.frame;
  frame.origin.x = kSidePadding;
  frame.origin.y = CGRectGetMidY(self.contentView.frame) - size.height / 2.f;
  frame.size = size;
  _issueLabel.frame = frame;
}

- (void)setStand:(NSString *)stand {
  _stand = [stand copy];
  _standLabel.text = _stand;

  CGSize size =
      [_standLabel sizeThatFits:CGSizeMake(kStandTextMaxWidth, CGRectGetHeight(self.frame))];
  CGRect frame = _standLabel.frame;
  frame.origin.x = CGRectGetWidth(self.frame) - kStandTextMaxWidth - kSidePadding;
  frame.origin.y = CGRectGetMidY(self.contentView.frame) - size.height / 2.f;
  frame.size = size;
  _standLabel.frame = frame;
  _standLabel.textColor = [KMCAssets colorForStand:_stand];
}

@end
