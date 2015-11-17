#import "KMCIssuesCollectionViewCell.h"

#import "KMCAssets.h"

static const CGFloat kLeftPadding = 10.f;
static const CGFloat kImageHeight = 111.f;
static const CGFloat kImageWidth = 157.f;
static const CGFloat kTextLabelPadding = 10.f;

@implementation KMCIssuesCollectionViewCell {
    UITextView *_nameLabel;
    UIImageView *_pictureView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.layer.cornerRadius = 5.f;
        UIView *contentView = self.contentView;
        
        UIImage *issueBackgrond = [UIImage imageNamed:@"Rectangle.png"];
        self.backgroundView = [[UIImageView alloc] initWithImage: issueBackgrond];
        //self.backgroundView.layer.cornerRadius = 5.f;
        //self.backgroundView.layer.masksToBounds = YES;
        
        _nameLabel = [[UITextView alloc] init];
      // _nameLabel.textAlignment = NSTextAlignmentJustified;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:16.f weight:0.4f];
        _nameLabel.textColor = [UIColor blackColor];
        [contentView addSubview:_nameLabel];
        
        _pictureView = [[UIImageView alloc] init];
        [contentView addSubview:_pictureView];
    }
    return self;
}


- (void)setIssueName:(NSString *)issueName {
    _issueName = [issueName copy];
    _nameLabel.text = _issueName;
    _pictureView.image = [KMCAssets pictureForIssues: _issueName];
   
    [_pictureView sizeToFit];
    CGRect frame = _pictureView.frame;
    frame.origin.x = CGRectGetMidX(self.contentView.frame) - (kImageWidth/ 2.f);
    frame.origin.y = kLeftPadding;
    frame.size.height = kImageHeight;
    frame.size.width = kImageWidth;
    _pictureView.frame = frame;
    
    [self layoutTextLabels];
}


- (void)layoutTextLabels {
    [_nameLabel sizeToFit];
    CGRect frame = _nameLabel.frame;
   //CGFloat totalWidth = CGRectGetWidth(_nameLabel.frame);
    frame.origin.x = kLeftPadding;
    frame.origin.y = kImageHeight+kLeftPadding;
    frame.size.height = 40.f;
    frame.size.width = kImageWidth;
    _nameLabel.frame = frame;
    
}

@end
