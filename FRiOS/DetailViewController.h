//
//  DetailViewController.h
//  FRiOS
//
//  Created by Anthonio Ez on 6/10/14.
//  Copyright (c) 2014 Miciniti. All rights reserved.
//

#import "FeedItem.h"

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import <Twitter/Twitter.h>

#import <GoogleMobileAds/GoogleMobileAds.h>

@interface DetailViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;


@property FeedItem *item;

- (IBAction)shareWhatsapp:(id)sender;
- (IBAction)shareFacebook:(id)sender;
- (IBAction)shareTwitter:(id)sender;

@end
