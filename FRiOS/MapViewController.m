//
//  MapViewController.m
//  FRiOS
//
//  Created by Anthonio Ez on 8/8/15.
//  Copyright (c) 2015 FRiOS. All rights reserved.
//

#import "AppDelegate.h"
#import "MapViewController.h"
#import "SMXMLDocument.h"

#import "Utils.h"
#import "MapItem.h"


@interface MapViewController ()
{
    BOOL mapLoading;
    NSMutableArray *mapList;
    
    NSURLConnection *mapConnection;
    NSMutableData *mapData;
}
@end

@implementation MapViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        mapList = [NSMutableArray new];
        
        mapLoading = false;
        mapConnection = nil;
        
        self.title = @"Maps";
        self.tabBarItem.image = [UIImage imageNamed:@"bar_map.png"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
        
    self.bannerView.adUnitID = ADMOB_BANNER_ID;
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest: [GADRequest request]];
}

- (void)viewWillAppear:(BOOL)animated {
    
    if([mapList count] == 0 && !mapLoading)
    {
        [self loadMap];
    }
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self unloadMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) updateMap
{
    mapLoading = false;

    [self.activityIndicator stopAnimating];
    
    if([mapList count] == 0) return;
    
    CLLocationCoordinate2D zoomLocation;
    
    [self.mapView removeAnnotations: [self.mapView annotations]];
    
    for (MapItem *item in mapList)
    {
        zoomLocation.latitude = item.latitude;
        zoomLocation.longitude= item.longitude;
        
        // Add an annotation
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = zoomLocation;
        point.title = item.title;
        point.subtitle = item.desc;
        
        [self.mapView addAnnotation:point];
    }
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(zoomLocation, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    //    [self.mapView setRegion:region animated:YES];
    
}

- (void) unloadMap
{
    mapLoading = false;
    
    if(mapConnection != nil)
    {
        [mapConnection cancel];
        mapConnection = nil;
    }
}

- (void) loadMap
{
    [self unloadMap];
    
    if(![Utils connected])
    {
       [self mapAlert: @"No internet connection!"];
       return;
    }

    mapLoading = true;
    [self.activityIndicator startAnimating];
    
    NSString *url = [NSString stringWithFormat:@"%@?stamp=%ld", APP_URL_MAP, (long)[[NSDate date] timeIntervalSince1970]];
    
    NSLog(@"loader url: %@", url);
    
    mapData = [NSMutableData new];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:APP_TIMEOUT];
    mapConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void) mapAlert: (NSString *) msg
{
    mapLoading = false;
    [self.activityIndicator stopAnimating];
    
    [Utils message:nil :msg];
}

#pragma mark - Connection
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    mapLoading = false;
    [self mapAlert: [error localizedDescription]];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [mapData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    mapLoading = false;

    NSError *error = nil;
    SMXMLDocument *document = [SMXMLDocument documentWithData:mapData error:&error];
    if(error != nil)
    {
        [self mapAlert: @"Unable to parse map locations!"];
        return;
    }
    
    if(![document.name isEqualToString:@"points"])
    {
        [self mapAlert: @"Invalid map data!"];
        return;
    }
    
    [mapList removeAllObjects];
    
    NSArray* points = [document childrenNamed:@"point"];
    
    for (SMXMLElement *point in points)
    {
        NSArray* tags = [point children];
        
        MapItem *item = [MapItem new];
        for(SMXMLElement *tag in tags)
        {
            NSString *name = [tag name];
            NSString *value = [tag value];
            
            NSLog(@"name: %@ value: %@", name, value);
            
            if([name isEqualToString:@"titolo"])
            {
                item.title = value;
            }
            else if([name isEqualToString:@"sottotitolo"])
            {
                item.desc = value;
            }
            else if([name isEqualToString:@"latitudine"])
            {
                item.latitude = [value floatValue];;
            }
            else if([name isEqualToString:@"longitudine"])
            {
                item.longitude = [value floatValue];
            }
        }
        
        if(item.title != nil && item.desc != nil)
        {
            [mapList addObject: item];
        }
    }
    
    [self updateMap];
//    [self performSelectorOnMainThread:@selector(updateMap) withObject:nil waitUntilDone: NO];
}


@end
