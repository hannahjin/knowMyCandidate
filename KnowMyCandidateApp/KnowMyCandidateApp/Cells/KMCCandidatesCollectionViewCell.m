#import "KMCCandidatesCollectionViewCell.h"

#import "KMCAssets.h"

static const CGFloat kLeftPadding = 10.f;
static const CGFloat kImageDimension = 80.f;
static const CGFloat kTextLabelPadding = 10.f;

@implementation KMCCandidatesCollectionViewCell {
  UILabel *_nameLabel;
  UILabel *_experienceLabel;
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
    _nameLabel.textColor = [UIColor whiteColor];
    [contentView addSubview:_nameLabel];

    _experienceLabel = [[UILabel alloc] init];
    _experienceLabel.font = [UIFont systemFontOfSize:14.f];
    _experienceLabel.textColor = [UIColor whiteColor];
    [contentView addSubview:_experienceLabel];
    
    _pictureView = [[UIImageView alloc] init];
    [contentView addSubview:_pictureView];
  }
  return self;
}

- (void)setAffiliation:(KMCPartyAffiliation)affiliation {
  _affiliation = affiliation;
  UIImage *image = [KMCAssets cellBackgroundForAffiliation:affiliation];
  self.backgroundView = [[UIImageView alloc] initWithImage:image];
  self.backgroundView.layer.cornerRadius = 5.f;
  self.backgroundView.layer.masksToBounds = YES;
}

- (void)setHasDroppedOut:(BOOL)hasDroppedOut {
  _hasDroppedOut = hasDroppedOut;
  if (_hasDroppedOut) {
    UIImage *image = [KMCAssets grayCellBackground];
    self.backgroundView = [[UIImageView alloc] initWithImage:image];
    self.backgroundView.layer.cornerRadius = 5.f;
    self.backgroundView.layer.masksToBounds = YES;
  }
}

- (void)setName:(NSString *)name {
  _name = [name copy];
  _nameLabel.text = _name;
  _pictureView.image = [KMCAssets pictureForCandidate:_name];
  [_pictureView sizeToFit];
  CGRect frame = _pictureView.frame;
  frame.origin.x = kLeftPadding;
  frame.origin.y = CGRectGetMidY(self.contentView.frame) - (kImageDimension / 2.f);
  frame.size.height = kImageDimension;
  frame.size.width = kImageDimension;
  _pictureView.frame = frame;

  [self layoutTextLabels];
}

- (void)setExperience:(NSString *)experience {
  _experience = [experience copy];

  NSString *format;
  if (_affiliation == KMCPartyAffiliationDemocratic) {
    format = @"(D) %@";
  } else if (_affiliation == KMCPartyAffiliationRepublican) {
    format = @"(R) %@";
  } else {
    format = @"(G) %@";
  }
  _experienceLabel.text = [NSString stringWithFormat:format, _experience];

  [self layoutTextLabels];
}

- (void)layoutTextLabels {
  [_nameLabel sizeToFit];
  [_experienceLabel sizeToFit];
  CGRect frame = _nameLabel.frame;
  CGFloat totalHeight = CGRectGetHeight(_nameLabel.frame) + CGRectGetHeight(_experienceLabel.frame);
  frame.origin.x = kLeftPadding + kTextLabelPadding + kImageDimension;
  frame.origin.y = CGRectGetMidY(self.contentView.frame) - (totalHeight / 2.f);
  _nameLabel.frame = frame;

  frame = _experienceLabel.frame;
  frame.origin.x = kLeftPadding + kTextLabelPadding + kImageDimension;
  frame.origin.y = CGRectGetMaxY(_nameLabel.frame);
  _experienceLabel.frame = frame;
}

@end
