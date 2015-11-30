#import "KMCIssueViewController.h"

#import "KMCAssets.h"
#import "Parse/Parse.h"
#import "XYPieChart.h"


static const CGFloat kHeaderViewHeight = 205.f;
static const CGFloat kSegmentHeight = 30.f;
static const CGFloat kSegmentPadding = 5.f;


@interface KMCIssueViewController () <XYPieChartDelegate, XYPieChartDataSource>

@property (strong, nonatomic) IBOutlet XYPieChart *pieChart;
@property (nonatomic, strong) UIView *pieContainer;
@property (strong, nonatomic) IBOutlet UILabel *percentageLabel;
@property (strong, nonatomic) IBOutlet UILabel *selectedSliceLabel;
@property (strong, nonatomic) IBOutlet UITextField *numOfSlices;
@property (strong, nonatomic) IBOutlet UISegmentedControl *indexOfSlices;
@property (strong, nonatomic) IBOutlet UIButton *downArrow;
@property(nonatomic, strong) NSMutableArray *slices;
@property (nonatomic) BOOL inOut;
@property(nonatomic, strong) NSArray        *sliceColors;


@end

@implementation KMCIssueViewController {

    PFObject *_issueObject;
    UIView *_headerView;
    UISegmentedControl *_segmentPicker;
    NSString *_summary;
    NSString *_topic;
  UIScrollView *_summaryScroll;
  UILabel *_title;
    
}

- (instancetype)initWithIssueObject:(PFObject *)object {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _issueObject = object;
        _headerView = [[UIView alloc] init];
        _summary = _issueObject [@"summary"];
        _topic = _issueObject [@"topic"];
        
        _segmentPicker = [[UISegmentedControl alloc] initWithItems:@[ @"User Opinion", @"Candidate Opinion" ]];
        _segmentPicker.selectedSegmentIndex = 0;
        [_segmentPicker addTarget:self
                           action:@selector(didTapSegmentPicker)
                 forControlEvents:UIControlEventValueChanged];
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    UIView *view = self.view;
    view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = _issueObject[@"keywords"];
    self.inOut = YES;
    [self setUpHeaderView];
    [view addSubview:_headerView];
    
    CGRect frame = _segmentPicker.frame;
    frame.origin.x = kSegmentPadding;
    frame.origin.y = kSegmentPadding + CGRectGetMaxY(_headerView.frame) + 20;
    frame.size.height = kSegmentHeight ;
    frame.size.width = CGRectGetWidth(view.frame) - 2 * kSegmentPadding;
    _segmentPicker.frame = frame;
    [view addSubview:_segmentPicker];

    _title = [[UILabel alloc] initWithFrame:CGRectMake(10, 270, 380, 25)];
    _title.numberOfLines = 1;
    _title.textAlignment = NSTextAlignmentCenter;
    _title.text = _topic;
    [_title setFont:[UIFont boldSystemFontOfSize:18]];
  [_title sizeToFit];
  frame = _title.frame;
  frame.origin.x = CGRectGetMidX(self.view.frame) - CGRectGetWidth(frame) / 2.f;
  frame.origin.y = 280.f;
  _title.frame = frame;
    [view addSubview:_title];
    
    UILabel *summary = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 345, 335)];
    _summaryScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 320, 345, 335)];
  frame = _summaryScroll.frame;
  frame.size.height = CGRectGetHeight(self.view.frame) - CGRectGetMaxY(_title.frame);
  _summaryScroll.frame = frame;
    summary.numberOfLines = 0;
    summary.lineBreakMode = NSLineBreakByWordWrapping;
    summary.font = [summary.font fontWithSize:15];
    summary.text = _summary;
    [summary sizeToFit];
    _summaryScroll.contentSize = CGSizeMake(_summaryScroll.contentSize.width, summary.frame.size.height);
    [_summaryScroll addSubview:summary];
    [view addSubview:_summaryScroll];
    
}

- (void)viewDidLayoutSubviews {
  CGRect frame = _summaryScroll.frame;
  frame.size.height = CGRectGetHeight(self.view.frame) - CGRectGetMaxY(_title.frame) - 70;
  _summaryScroll.frame = frame;
}


- (void)setUpHeaderView {
    CGRect frame = CGRectMake(0.f, 0.f, CGRectGetWidth(self.view.frame), kHeaderViewHeight);
    _headerView.frame = frame;
    _headerView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *agreeView = [[UIImageView alloc]init];
    agreeView.image = [UIImage imageNamed:@"agree.png"];
    agreeView.frame = CGRectMake(10,10,15,15);
    [_headerView addSubview:agreeView];
    
    UILabel *agreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 10, 60, 15)];
    agreeLabel.numberOfLines = 1;
    agreeLabel.text = @"Agree";
    [agreeLabel setFont:[UIFont boldSystemFontOfSize:11]];
    agreeLabel.textColor = [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1];
    [_headerView addSubview:agreeLabel];
    
    UIImageView *disagreeView = [[UIImageView alloc]init];
    disagreeView.image = [UIImage imageNamed:@"disagree.png"];
    disagreeView.frame = CGRectMake(10,25,15,15);
    [_headerView addSubview:disagreeView];
    
    UILabel *disagreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 25, 60, 15)];
    disagreeLabel.numberOfLines = 1;
    disagreeLabel.text = @"Disagree";
    [disagreeLabel setFont:[UIFont boldSystemFontOfSize:11]];
    disagreeLabel.textColor = [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1];
    [_headerView addSubview:disagreeLabel];
    
    UIImageView *neutralView = [[UIImageView alloc]init];
    neutralView.image = [UIImage imageNamed:@"neutral.png"];
    neutralView.frame = CGRectMake(10,40,15,15);
    [_headerView addSubview:neutralView];
    
    UILabel *neutralLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 40, 60, 15)];
    neutralLabel.numberOfLines = 1;
    neutralLabel.text = @"Neutral";
    [neutralLabel setFont:[UIFont boldSystemFontOfSize:11]];
    neutralLabel.textColor = [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1];
    [_headerView addSubview:neutralLabel];
    
    
    
    self.slices = [NSMutableArray arrayWithCapacity:3];
    
    int _usersFor = [[_issueObject objectForKey:@"usersFor"] intValue];
    int _usersAgainst = [[_issueObject objectForKey:@"usersAgainst"] intValue];
    int _usersNeutral = [[_issueObject objectForKey:@"usersNeutral"] intValue];
    
    NSNumber *uFor = [NSNumber numberWithInt: _usersFor];
    NSNumber *uAgainst = [NSNumber numberWithInt: _usersAgainst];
    NSNumber *uNeutral = [NSNumber numberWithInt: _usersNeutral];
    
    int _candidatesFor = [[_issueObject objectForKey:@"candidatesFor"] intValue];
    int _candidatesAgainst = [[_issueObject objectForKey:@"candidatesAgainst"] intValue];
    int _candidatesNeutral = [[_issueObject objectForKey:@"candidatesNeutral"] intValue];
    
    NSNumber *cFor = [NSNumber numberWithInt: _candidatesFor];
    NSNumber *cAgainst = [NSNumber numberWithInt: _candidatesAgainst];
    NSNumber *cNeutral = [NSNumber numberWithInt: _candidatesNeutral];
    
    if(self.inOut == YES)
    {
        [_slices addObject:uFor];
        [_slices addObject:uAgainst];
        [_slices addObject:uNeutral];
    }
    else
    {
        [_slices addObject:cFor];
        [_slices addObject:cAgainst];
        [_slices addObject:cNeutral];
    }
    CGRect pieFrame = CGRectMake(55, 5, 300, 200);
    
    self.pieChart = [[XYPieChart alloc]initWithFrame:pieFrame];
    
    // other chart setups
    
    [self.pieChart setDataSource:self];
    [self.pieChart setStartPieAngle:M_PI_2];
    //[self.pieChart setAnimationSpeed:1.0];
    [self.pieChart setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:18]];
    [self.pieChart setLabelRadius:70];
    [self.pieChart setShowPercentage:YES];
    //[self.pieChart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    [self.pieChart setPieCenter:CGPointMake(135, 110)];
    //[self.pieChart setUserInteractionEnabled:NO];
    [self.pieChart setLabelShadowColor:[UIColor blackColor]];
    
    UIImageView *centerView = [[UIImageView alloc]init];
    centerView.image = [UIImage imageNamed:@"center.png"];
    centerView.frame = CGRectMake(115,90,40,40);
    
    UILabel *percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    percentLabel.numberOfLines = 1;
    percentLabel.text = @"%";
    [percentLabel setFont:[UIFont boldSystemFontOfSize:20]];
    percentLabel.textAlignment = NSTextAlignmentCenter;
    [centerView addSubview:percentLabel];
    
    [_pieChart addSubview:centerView];
    
    
    [self.percentageLabel.layer setCornerRadius:90];
    
    self.sliceColors =[NSMutableArray arrayWithObjects:
                       [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1],
                       [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1],
                       [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],
                       nil];
    
    //rotate up arrow
    self.downArrow.transform = CGAffineTransformMakeRotation(M_PI);
    
    [_headerView addSubview:self.pieChart];

    
    
    
}

- (void)didTapSegmentPicker {
    self.inOut = !self.inOut;
    [self.pieChart removeFromSuperview];
    [self setUpHeaderView];
    [self.pieChart reloadData];
}



- (void)viewDidUnload
{
    [self setPieChart:nil];
    [self setPercentageLabel:nil];
    [self setSelectedSliceLabel:nil];
    [self setIndexOfSlices:nil];
    [self setNumOfSlices:nil];
    [self setDownArrow:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.pieChart reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return self.slices.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.slices objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}





@end
