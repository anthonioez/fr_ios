//
//  FeedViewController.h
//  FRiOS
//
//  Created by Anthonio Ez on 8/8/15.
//  Copyright (c) 2015 FRiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface FeedViewController : UIViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *feedTable;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property UIRefreshControl *refreshControl;

@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;
@end
