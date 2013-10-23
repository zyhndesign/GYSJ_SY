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
#import "JSONKit.h"

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
    
    scrllView.scrollEnabled = NO;
    mbXMapview = [[MBXMapView alloc] initWithFrame:CGRectMake(0, 0, 340, 704) mapID:@"zyhndesign.map-sthen0lx"];
    mbXMapview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self generateAnnotations];
    [mbXMapview addAnnotations:[NSArray arrayWithObjects:jpsThumbnailAnnt, nil]];
    mbXMapview.delegate = self;
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

- (void)showMapDetail:(SimpMenuView*)simpleMenuV
{
    _simpleMenuV = simpleMenuV;
    
    if ([[_simpleMenuV._infoDict objectForKey:@"city"] length] == 0)
    {
        jpsThumbnailAnnt.view.hidden = YES;
        return ;
    }
    jpsThumbnailAnnt.view.hidden = NO;
    NSString *googleUrlStr = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false", [_simpleMenuV._infoDict objectForKey:@"city"]];
    googleUrlStr = [googleUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:googleUrlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0f];
    NSURLConnection *connect = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    if (connect)
        backData = [[NSMutableData alloc] init];
    else
        backData = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [backData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *backDict = [backData objectFromJSONDataWithParseOptions:JKParseOptionValidFlags error:nil];
    NSDictionary *posDict = [[[[backDict objectForKey:@"results"] lastObject] objectForKey:@"geometry"] objectForKey:@"location"];
    NSLog(@"%@", posDict);
    CLLocationCoordinate2D location2d;
    location2d.latitude  = [[posDict objectForKey:@"lat"] doubleValue];
    location2d.longitude = [[posDict objectForKey:@"lng"] doubleValue];
    
    jpsThumbnailAnnt.thumbnail.coordinate = location2d;
    
    [jpsThumbnailAnnt annotationViewInMap:mbXMapview];
    
    jpsThumbnailAnnt.view.titleLabel.text  = [_simpleMenuV._infoDict objectForKey:@"name"];
    jpsThumbnailAnnt.view.subtitleLabel.text = [_simpleMenuV._infoDict objectForKey:@"city"];
    
    NSString *proUrlStr = [_simpleMenuV._infoDict objectForKey:@"profile"];
    NSString *proImgeFormat = [[proUrlStr componentsSeparatedByString:@"."] lastObject];
    
    NSString *pathFile = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"ProImage/%@.%@",[_simpleMenuV._infoDict objectForKey:@"id"], proImgeFormat]];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    if ([fileManage fileExistsAtPath:pathFile])
    {
        jpsThumbnailAnnt.view.imageView.image = nil;
        jpsThumbnailAnnt.view.imageView.image = [UIImage imageWithContentsOfFile:pathFile];
    }
    else
    {
        jpsThumbnailAnnt.view.imageView.image = nil;
        jpsThumbnailAnnt.view.imageView.image = [UIImage imageNamed:@"default_event_poster.png"];
    }
    
    [mbXMapview setCenterCoordinate:location2d animated:YES];
    contentView.hidden = YES;
}

- (void)hiddenMapDetail
{
    contentView.hidden = YES;
}

#pragma mark MapKit

- (void)generateAnnotations
{
    // Empire State Building
    JPSThumbnail *empire = [[JPSThumbnail alloc] init];
    empire.image = [UIImage imageNamed:@"empire.jpg"];
    empire.title = @"Empire State Building";
    empire.subtitle = @"NYC Landmark";
    empire.coordinate = CLLocationCoordinate2DMake(40.75, -73.99);
    empire.disclosureBlock = ^{ [self contentShow]; };
    
    jpsThumbnailAnnt = [[JPSThumbnailAnnotation alloc] initWithThumbnail:empire];
  
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapview didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didSelectAnnotationViewInMap:mapview];
    }
}

- (void)mapView:(MKMapView *)mapview didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didDeselectAnnotationViewInMap:mapview];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapview viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation conformsToProtocol:@protocol(JPSThumbnailAnnotationProtocol)]) {
        return [((NSObject<JPSThumbnailAnnotationProtocol> *)annotation) annotationViewInMap:mapview];
    }
    return nil;
}
@end