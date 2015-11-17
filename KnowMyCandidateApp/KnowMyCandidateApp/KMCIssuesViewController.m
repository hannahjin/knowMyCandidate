#import "KMCIssuesViewController.h"

#import "KMCAssets.h"
#import "PieChartView.h"
#import "Parse/Parse.h"

#define PIE_HEIGHT 260

static NSString *const reuseIdentifier = @"kIssuesCollectionViewController";

@interface KMCIssuesViewController ()
@property (nonatomic,strong) NSMutableArray *valueArray;
@property (nonatomic,strong) NSMutableArray *colorArray;
@property (nonatomic,strong) NSMutableArray *valueArray2;
@property (nonatomic,strong) NSMutableArray *colorArray2;
@property (nonatomic,strong) PieChartView *pieChartView;
@property (nonatomic,strong) UIView *pieContainer;
@property (nonatomic)BOOL inOut;
@property (nonatomic,strong) UILabel *selLabel;
@end

@implementation KMCIssuesViewController{
    PFObject *_issueObject;
    int candidatesFor;
    int candidatesAgainst;
    int candidatesNeutral;
    int usersFor;
    int usersAgainst;
    int usersNeutral;
    int usersTotal;
    int candidatesTotal;
    int toggle;
    NSString *summary;
    NSString *topic;

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
  //self.collectionView.backgroundColor = [UIColor whiteColor];
  self.navigationItem.title = @"Issues";
    
    candidatesFor = [[_issueObject objectForKey: @"candidatesFor"] intValue];
    candidatesAgainst = [[_issueObject objectForKey: @"candidatesAgainst"] intValue];
    candidatesNeutral = [[_issueObject objectForKey: @"candidatesNeutral"] intValue];
    usersFor = [[_issueObject objectForKey: @"usersFor"] intValue];
    usersAgainst = [[_issueObject objectForKey: @"usersAgainst"] intValue];
    usersNeutral = [[_issueObject objectForKey: @"usersNeutral"] intValue];
    usersTotal = usersFor + usersNeutral + usersAgainst;
    candidatesTotal = candidatesFor + candidatesAgainst + candidatesNeutral;
    summary = _issueObject [@"summary"];
    topic= _issueObject [@"topic"];
    
    NSLog(@"%i", usersFor);
    toggle = 0;
     self.inOut = YES;
    self.valueArray2 = [[NSMutableArray alloc] initWithObjects:
                        [NSNumber numberWithInt:candidatesAgainst],
                        [NSNumber numberWithInt:candidatesFor],
                        [NSNumber numberWithInt:candidatesNeutral],
                        nil];
    
    self.valueArray = [[NSMutableArray alloc] initWithObjects:
                       [NSNumber numberWithInt:usersAgainst],
                       [NSNumber numberWithInt:usersFor],
                       [NSNumber numberWithInt:usersNeutral],
                       nil];
    
    self.colorArray2 = [NSMutableArray arrayWithObjects:
                        [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],
                        [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1],
                        [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1],
                        nil];
    self.colorArray = [[NSMutableArray alloc] initWithObjects:
                       [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],
                       [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1],
                       [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1],
                       nil];
    
    //add shadow img
    CGRect pieFrame = CGRectMake((self.view.frame.size.width - PIE_HEIGHT) / 2, 20, PIE_HEIGHT, PIE_HEIGHT);
    
    //UIImage *shadowImg = [UIImage imageNamed:@"shadow.png"];
    //UIImageView *shadowImgView = [[UIImageView alloc]initWithImage:shadowImg];
    //shadowImgView.frame = CGRectMake(0, pieFrame.origin.y + PIE_HEIGHT*0.92, shadowImg.size.width/2, shadowImg.size.height/2);
    //[self.view addSubview:shadowImgView];
    
    self.pieContainer = [[UIView alloc]initWithFrame:pieFrame];
    self.pieChartView = [[PieChartView alloc]initWithFrame:self.pieContainer.bounds withValue:self.valueArray withColor:self.colorArray];
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
    //[self.pieChartView setTitleText:@"Issues"];
    self.title = @"Issues";
    //self.view.backgroundColor = [self colorFromHexRGB:@"f3f3f3"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addTextTitle];
    [self addTextView];
}
-(void)addTextTitle{
    CGRect frame =CGRectMake(10, 360, 355, 25);
    
    UILabel *myTitle = [[UILabel alloc]initWithFrame: frame  ];
    [myTitle setText: topic];
    myTitle.font = [UIFont systemFontOfSize:18.f weight:0.4f];
    myTitle.layer.cornerRadius = 5.0;
    myTitle.layer.borderColor = [self colorFromHexRGB:@"5856D6"].CGColor;
    myTitle.layer.borderWidth = 1.f;
    myTitle.layer.backgroundColor = [UIColor whiteColor].CGColor;
    myTitle.layer.masksToBounds = YES;
    [self.view addSubview:myTitle];
    
}

-(void)addTextView{
    CGRect frame =CGRectMake(10, 395, 355, 150);
    UITextView *myTextView = [[UITextView alloc]initWithFrame: frame  ];
    [myTextView setText: summary];
    myTextView.font = [UIFont systemFontOfSize:14.f];
    myTextView.layer.cornerRadius = 5.0;
    myTextView.layer.borderColor = [self colorFromHexRGB:@"5856D6"].CGColor;
    myTextView.layer.borderWidth = 1.f;
    myTextView.layer.masksToBounds = YES;
    // myTextView.delegate = self;
     [self.view addSubview:myTextView];
     
     }


- (UIColor *) colorFromHexRGB:(NSString *) inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

- (void)selectedFinish:(RotatedView *)rotatedView index:(NSInteger)index percent:(float)per
{
    int check = (int)(per * usersTotal);
    int check2 = (int)(per * candidatesTotal);
    int perc = (int)(per * 100);
    NSString *percentage = [NSString stringWithFormat:@"%d%@",perc,@"%"];
    NSString *text;
    per = per * 100;
    if(toggle == 0){
        if(check == usersNeutral)
            text = @" of our users are neutral";
        else if(check == usersAgainst)
            text = @" of our users are against this issue";
        else if(check == usersFor)
            text = @" of our users support this issue";
    }
    else if(toggle == 1)
    {
        if(check2 == candidatesNeutral)
            text = @" of our users are neutral";
        else if(check2 == candidatesAgainst)
            text = @" of our candidates are against this issue";
        else if(check2 == candidatesFor)
            text = @" of our candidates support this issue";
    }
    else
        text = @"";
    
    self.selLabel.text = [percentage stringByAppendingString:text];
    
}

- (void)onCenterClick:(PieChartView *)pieChartView
{
    if(toggle == 0)
        toggle = 1;
    else
        toggle = 0;
    
    self.inOut = !self.inOut;
    self.pieChartView.delegate = nil;
    [self.pieChartView removeFromSuperview];
    self.pieChartView = [[PieChartView alloc]initWithFrame:self.pieContainer.bounds withValue:self.inOut?self.valueArray:self.valueArray2 withColor:self.inOut?self.colorArray:self.colorArray2];
    self.pieChartView.delegate = self;
    [self.pieContainer addSubview:self.pieChartView];
    [self.pieChartView reloadChart];
    
    if (self.inOut) {
        [self.pieChartView setTitleText:@"Users"];
        
    }else{
        [self.pieChartView setTitleText:@"Candidates"];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.pieChartView reloadChart];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                forIndexPath:indexPath];

  return cell;
}

@end
