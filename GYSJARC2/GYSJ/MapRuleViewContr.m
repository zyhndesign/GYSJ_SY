#import "MapRuleViewContr.h"
#import "FilterMenuViewContr.h"
#import "LocalSQL.h"
#import "DataHandle.h"
#import "MenuViewContr.h"
#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SubMenuView.h"
#import "AllVarible.h"
#import "ContentViewContr.h"

#import "MBXMapKit.h"

UIView *AllDrawLineView;

@interface MapRuleViewContr ()

@end

@implementation MapRuleViewContr
@synthesize bgImageV;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentShow)];
    [contentView addGestureRecognizer:tapGesture];
    
    //  contentView.hidden = YES;
    [scrllView setContentSize:CGSizeMake(1400, 704)];
    scrllView.scrollEnabled = NO;
    mbXMapview = [[MBXMapView alloc] initWithFrame:CGRectMake(0, 0, 1400, 704) mapID:@"zyhndesign.map-sthen0lx"];
    [scrllView addSubview:mbXMapview];
    
    
    self.view.layer.shadowOffset = CGSizeMake(0, 0);
    self.view.layer.shadowRadius = 2;
    self.view.layer.shadowOpacity = 0.4;
    
    titleLabel.textColor  = LabelBgColor;
    detailTextV.textColor = LabelBgColor;

    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [bgImageV removeFromSuperview];
    bgImageV = nil;
    
    [scrllView removeFromSuperview];
    scrllView = nil;
    
    [contentView removeFromSuperview];
    contentView = nil;
    
    [titleLabel removeFromSuperview];
    titleLabel = nil;
    
    [detailTextV removeFromSuperview];
    detailTextV = nil;
    
    [briefImageV removeFromSuperview];
    briefImageV = nil;
}

#pragma mark - Event
- (void)contentShow
{
    if ([[_simpleMenuV._infoDict objectForKey:@"id"] length] > 0)
    {
        ContentViewContr *contentViewContr = [[ContentViewContr alloc] initWithSimMenuV:_simpleMenuV];
        contentViewContr.modalPresentationStyle = UIModalPresentationPageSheet;
        [RootViewContr presentViewController:contentViewContr animated:YES completion:nil];
    }
}

- (void)updateMapImage
{
    NSString *proUrlStr = [_simpleMenuV._infoDict objectForKey:@"profile"];
    NSString *proImgeFormat = [[proUrlStr componentsSeparatedByString:@"."] lastObject];
    
    NSString *pathFile = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"ProImage/%@.%@",[_simpleMenuV._infoDict objectForKey:@"id"], proImgeFormat]];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    if ([briefImageV.image isEqual:[UIImage imageWithContentsOfFile:pathFile]])
    {
        return;
    }
    if ([fileManage fileExistsAtPath:pathFile])
    {
        briefImageV.image = nil;
        briefImageV.image = [UIImage imageWithContentsOfFile:pathFile];
    }
    else
    {
        briefImageV.image = nil;
        briefImageV.image = [UIImage imageNamed:@"default_event_poster.png"];
    }
}



////  47 94 原点的在contentview上的中心位置

- (void)showMapDetail:(SimpMenuView*)simpleMenuV
{

    _simpleMenuV = simpleMenuV;
    NSString *coordStr = [simpleMenuV._infoDict objectForKey:@"coordinate"];
    NSArray *coordAry  = [coordStr componentsSeparatedByString:@","];
    if (coordAry.count == 2)
    {
        pointX = [[coordAry objectAtIndex:0] floatValue];
        pointY = [[coordAry lastObject] floatValue];
    }
    if (pointX < 0 || pointY < 0)
    {
        contentView.hidden = YES;
        return;
    }
    
    contentView.hidden = NO;
    
    titleLabel.text    = [simpleMenuV._infoDict objectForKey:@"city"];
    detailTextV.text   = [simpleMenuV._infoDict objectForKey:@"name"];
    
    [self moveContentView];
    
    NSString *proUrlStr = [_simpleMenuV._infoDict objectForKey:@"profile"];
    NSString *proImgeFormat = [[proUrlStr componentsSeparatedByString:@"."] lastObject];
    
    NSString *pathFile = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"ProImage/%@.%@",[_simpleMenuV._infoDict objectForKey:@"id"], proImgeFormat]];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    if ([fileManage fileExistsAtPath:pathFile])
    {
        briefImageV.image = nil;
        briefImageV.image = [UIImage imageWithContentsOfFile:pathFile];
    }
    else
    {
        briefImageV.image = nil;
        briefImageV.image = [UIImage imageNamed:@"default_event_poster.png"];
    }
}

- (void)moveContentView
{
    CLLocationCoordinate2D location2d;
    location2d.latitude  = (double)((int)pointX%90);
    location2d.longitude = (double)((int)pointY%90);
    [mbXMapview  setCenterCoordinate:location2d animated:NO];
    [contentView setCenter:CGPointMake(400, 200)];
    [contentView setFrame:CGRectMake((int)pointX%180, (int)pointY%90, contentView.frame.size.width, contentView.frame.size.height)];
    return;
    
    float positionX = pointX - 46;
    float positionY = pointY - 94;
    [contentView setFrame:CGRectMake(positionX, positionY, contentView.frame.size.width, contentView.frame.size.height)];
    if (positionX - 100 > 0 && positionX < 1400 - 360)
        [scrllView setContentOffset:CGPointMake(positionX - 100, 0) animated:YES];
    else if(positionX >= 1400 - 360)
        [scrllView setContentOffset:CGPointMake(1400 - 360, 0) animated:YES];
    else
        [scrllView setContentOffset:CGPointZero animated:YES];
}

- (void)hiddenMapDetail
{
    contentView.hidden = YES;
}
@end