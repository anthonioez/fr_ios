//
//  MapViewController.h
//  FRiOS
//
//  Created by Anthonio Ez on 8/8/15.
//  Copyright (c) 2015 FRiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface MapViewController : UIViewController<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@end
