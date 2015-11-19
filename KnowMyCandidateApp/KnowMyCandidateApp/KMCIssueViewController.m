#import "KMCIssueViewController.h"

#import "KMCAssets.h"
#import "Parse/Parse.h"
#import "PieChartView.h"

#define PIE_HEIGHT 260

@interface KMCIssueViewController () <PieChartDelegate>

@property (nonatomic, strong) NSMutableArray *valueArray;
@property (nonatomic, strong) NSMutableArray *colorArray;
@property (nonatomic, strong) NSMutableArray *valueArrayAlt;
@property (nonatomic, strong) NSMutableArray *colorArrayAlt;
@property (nonatomic, strong) PieChartView *pieChartView;
@property (nonatomic, strong) UIView *pieContainer;
@property (nonatomic) BOOL inOut;
@property (nonatomic, strong) UILabel *selLabel;

@end

@implementation KMCIssueViewController {
  PFObject *_issueObject;
  int _candidatesFor;
  int _candidatesAgainst;
  int _candidatesNeutral;
  int _usersFor;
  int _usersAgainst;
  int _usersNeutral;
  int _usersTotal;
  int _candidatesTotal;
  int _toggle;
  NSString *_summary;
  NSString *_topic;
}

- (instancetype)initWithIssueObject:(PFObject *)object {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _issueObject = object;

  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.navigationItem.title = _issueObject[@"keywords"];

  _candidatesFor = [[_issueObject objectForKey:@"candidatesFor"] intValue];
  _candidatesAgainst = [[_issueObject objectForKey:@"candidatesAgainst"] intValue];
  _candidatesNeutral = [[_issueObject objectForKey:@"candidatesNeutral"] intValue];
  _usersFor = [[_issueObject objectForKey:@"usersFor"] intValue];
  _usersAgainst = [[_issueObject objectForKey:@"usersAgainst"] intValue];
  _usersNeutral = [[_issueObject objectForKey:@"usersNeutral"] intValue];
  _usersTotal = _usersFor + _usersNeutral + _usersAgainst;
  _candidatesTotal = _candidatesFor + _candidatesAgainst + _candidatesNeutral;
  _summary = _issueObject [@"summary"];
  _topic = _issueObject [@"topic"];
  
  _toggle = 0;
  self.inOut = YES;
  self.valueArrayAlt = [[NSMutableArray alloc] initWithObjects:
                          [NSNumber numberWithInt:_candidatesAgainst],
                          [NSNumber numberWithInt:_candidatesFor],
                          [NSNumber numberWithInt:_candidatesNeutral],
                          nil];
  
  self.valueArray = [[NSMutableArray alloc] initWithObjects:
                     [NSNumber numberWithInt:_usersAgainst],
                     [NSNumber numberWithInt:_usersFor],
                     [NSNumber numberWithInt:_usersNeutral],
                     nil];
  
  self.colorArrayAlt = [NSMutableArray arrayWithObjects:
                          [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],
                          [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1],
                          [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1],
                          nil];
  self.colorArray = [[NSMutableArray alloc] initWithObjects:
                     [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],
                     [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1],
                     [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1],
                     nil];

  CGRect pieFrame = CGRectMake((self.view.frame.size.width - PIE_HEIGHT) / 2, 20, PIE_HEIGHT, PIE_HEIGHT);
  
  self.pieContainer = [[UIView alloc]initWithFrame:pieFrame];
  self.pieChartView = [[PieChartView alloc]initWithFrame:self.pieContainer.bounds withValue:self.valueArray withColor:self.colorArray];
  if (self.inOut) {
    [self.pieChartView setTitleText:@"Users"];
  } else {
    [self.pieChartView setTitleText:@"Candidates"];
  }
  self.pieChartView.delegate = self;
  [self.pieContainer addSubview:self.pieChartView];
  [self.view addSubview:self.pieContainer];
  
  //add selected view
  UIImageView *selView = [[UIImageView alloc]init];
  selView.image = [UIImage imageNamed:@"select.png"];
  selView.frame = CGRectMake((self.view.frame.size.width - selView.image.size.width/2)/2 , self.pieContainer.frame.origin.y + self.pieContainer.frame.size.height+10, selView.image.size.width/2 , selView.image.size.height/2);
  [self.view addSubview:selView];
  
  self.selLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 24, selView.image.size.width/2, 21)];
  self.selLabel.backgroundColor = [UIColor clearColor];
  self.selLabel.textAlignment = NSTextAlignmentCenter;
  self.selLabel.font = [UIFont systemFontOfSize:12];
  self.selLabel.textColor = [UIColor whiteColor];
  [selView addSubview:self.selLabel];
  self.view.backgroundColor = [UIColor whiteColor];
  [self addTextTitle];
  [self addTextView];
}

- (void)addTextTitle {
  CGRect frame = CGRectMake(10, 360, 355, 25);
  
  UILabel *myTitle = [[UILabel alloc]initWithFrame: frame  ];
  [myTitle setText: _topic];
  myTitle.font = [UIFont systemFontOfSize:18.f weight:0.4f];
  myTitle.layer.cornerRadius = 5.0;
  myTitle.layer.borderColor = [self colorFromHexRGB:@"5856D6"].CGColor;
  myTitle.layer.borderWidth = 1.f;
  myTitle.layer.backgroundColor = [UIColor whiteColor].CGColor;
  myTitle.layer.masksToBounds = YES;
  [self.view addSubview:myTitle];
}

- (void)addTextView {
  CGRect frame = CGRectMake(10, 395, 355, 150);
  UITextView *myTextView = [[UITextView alloc]initWithFrame: frame  ];
  [myTextView setText: _summary];
  myTextView.font = [UIFont systemFontOfSize:14.f];
  myTextView.layer.cornerRadius = 5.0;
  myTextView.layer.borderColor = [self colorFromHexRGB:@"5856D6"].CGColor;
  myTextView.layer.borderWidth = 1.f;
  myTextView.layer.masksToBounds = YES;
  [self.view addSubview:myTextView];
}


- (UIColor *)colorFromHexRGB:(NSString *)inColorString {
  UIColor *result = nil;
  unsigned int colorCode = 0;
  unsigned char redByte, greenByte, blueByte;
  
  if (nil != inColorString) {
    NSScanner *scanner = [NSScanner scannerWithString:inColorString];
    (void) [scanner scanHexInt:&colorCode]; // ignore error
  }
  redByte = (unsigned char) (colorCode >> 16);
  greenByte = (unsigned char) (colorCode >> 8);
  blueByte = (unsigned char) (colorCode); // masks off high bits
  result = [UIColor
            colorWithRed:(float)redByte / 0xff
            green:(float)greenByte/ 0xff
            blue:(float)blueByte / 0xff
            alpha:1.0];
  return result;
}

- (void)selectedFinish:(RotatedView *)rotatedView index:(NSInteger)index percent:(float)per {
  int check = (int)(per * _usersTotal);
  int check2 = (int)(per * _candidatesTotal);
  int perc = (int)(per * 100);
  NSString *percentage = [NSString stringWithFormat:@"%d%@", perc, @"%"];
  NSString *text;
  per = per * 100;

  if (_toggle == 0) {
    if (check == _usersNeutral)
        text = @" of our users are neutral";
    else if (check == _usersAgainst)
        text = @" of our users disagree";
    else if (check == _usersFor)
        text = @" of our users agree";
  } else if (_toggle == 1) {
    if (check2 == _candidatesNeutral)
        text = @" of our candidates are neutral";
    else if (check2 == _candidatesAgainst)
        text = @" of our candidates are disagree";
    else if (check2 == _candidatesFor)
        text = @" of our candidates agree";
  } else {
    text = @"";
  }
  
  self.selLabel.text = [percentage stringByAppendingString:text];
}

- (void)onCenterClick:(PieChartView *)pieChartView {
  if (_toggle == 0) {
    _toggle = 1;
  } else {
    _toggle = 0;
  }

  self.inOut = !self.inOut;
  [self.pieChartView removeFromSuperview];
  self.pieChartView =
      [[PieChartView alloc] initWithFrame:self.pieContainer.bounds
                                withValue:self.inOut? self.valueArray : self.valueArrayAlt
                                withColor:self.inOut? self.colorArray: self.colorArrayAlt];
  self.pieChartView.delegate = self;
  [self.pieContainer addSubview:self.pieChartView];
  [self.pieChartView reloadChart];
  
  if (self.inOut) {
    [self.pieChartView setTitleText:@"Users"];
  } else {
    [self.pieChartView setTitleText:@"Candidates"];
  }
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  [self.pieChartView reloadChart];
}

@end
