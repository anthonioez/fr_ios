//
//  DetailViewController.m
//  FRiOS
//
//  Created by Anthonio Ez on 6/10/14.
//  Copyright (c) 2014 Miciniti. All rights reserved.
//


#import "AppDelegate.h"
#import "DetailViewController.h"

#import "FeedItem.h"
#import "Utils.h"

@interface DetailViewController ()
{
   
}
@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navBar setBackgroundColor: [[UIColor alloc] initWithRed:44/255.0 green:36/255.0 blue:142/255.0 alpha:1.0f]];
    self.navBar.shadowImage = [UIImage new];
    self.navBar.translucent = YES;
    
    UIBarButtonItem *navButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bar_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navItem.leftBarButtonItem = navButtonItem;

    self.webView.alpha = 0.0;
    self.webView.scalesPageToFit = YES;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.opaque = NO;
    
    if(self.item != nil)
    {
        [self.titleLabel setText:self.item.title];
    
        NSString *html = self.item.content;
        
        NSString *style = @""; //"<style type=\"text/css\">img{display: inline; max-width: 100%; width:auto; height: auto;}</style>";
        
        //            html = html.replaceAll("#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})", "#FFF");
        //            html = html.replace("background: white", "");
        
        html = @"";
        html = [html stringByAppendingString: @"<html>"];
        html = [html stringByAppendingFormat: @"<head>%@</head>", style];
        
        html = [html stringByAppendingString: @"<body style=\"\">"];
        
        if(self.item.image != nil && [self.item.image length] > 0)
        {            
            NSString *image = [self.item.image stringByReplacingOccurrencesOfString:@"-150x150" withString:@""];
            
            NSRange range = [self.item.image rangeOfString:@"." options:NSBackwardsSearch];
            if(range.location != NSNotFound)
            {
                image = [NSString stringWithFormat:@"%@%@",
                         [self.item.image substringToIndex: range.location - 8],
                         [self.item.image substringFromIndex: range.location]];
            }
            
            html = [html stringByAppendingString: @"<div style=\"margin: 10px 0px;\" >"];
            html = [html stringByAppendingFormat: @"<img style=\"width: 100%%;\" width=\"100%%\" src=\"%@\" />", image];
            html = [html stringByAppendingString: @"</div>"];
        }
        
        html = [html stringByAppendingString: @"<div style=\"width: 100%%;\" >"];
        html = [html stringByAppendingString: self.item.content];
        html = [html stringByAppendingString: @"</div>"];
        
        html = [html stringByAppendingString: @"</body>"];
        html = [html stringByAppendingString: @"</html>"];
        
        [self.webView loadHTMLString: html baseURL: [[NSURL alloc] initWithString:@"http://www.trattoriacesarino.it"]];
    }
    [self performSelector:@selector(showPage) withObject:nil afterDelay:1.0];

    
    [self.activityIndicator startAnimating];
    
    self.bannerView.adUnitID = ADMOB_BANNER_ID;
    self.bannerView.rootViewController = self;

    GADRequest *request = [GADRequest request];
    request.testDevices = @[ kGADSimulatorID ];

    [self.bannerView loadRequest: request];
}

- (IBAction)onBack:(id)sender
{
    [[AppDelegate rootController] popViewControllerAnimated:TRUE];
}

- (void) showPage
{
    self.webView.alpha = 1.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.webView.alpha = 1.0;
    [self.activityIndicator stopAnimating];

    float scale = 200;
    NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", (int)scale];
    [self.webView stringByEvaluatingJavaScriptFromString:jsString];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.webView.alpha = 1.0;
    [self.activityIndicator stopAnimating];

    NSString *message = [NSString stringWithFormat:@"A problem occurred trying to load this page: %@",
                         error.localizedDescription];
    
    [Utils message:nil :message];
}

-(BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    
    if(navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        [[UIApplication sharedApplication] openURL:url];
        
        return NO;
    }
    
    return YES;
}

- (IBAction)shareWhatsapp:(id)sender
{
    NSURL *whatsappURL = [NSURL URLWithString: @"whatsapp://app"];
    
    NSURL *shareURL = [NSURL URLWithString: [NSString stringWithFormat: @"whatsapp://send?text=%@%%20%@", [self.item.title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [self.item.link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ] ];
    
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL])
    {
        [[UIApplication sharedApplication] openURL: shareURL];
    }
    else
    {
        [Utils message:@"WhatsApp not installed." : nil];
    }
}

- (IBAction)shareFacebook:(id)sender
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText: self.item.title];
        //[controller setInitialText: [NSString stringWithFormat:@"%@\n%@", self.item.title, self.item.link]];
        [controller addURL:[NSURL URLWithString: self.item.link]];
        
        controller.completionHandler = ^(SLComposeViewControllerResult result) {
            switch(result) {
                case SLComposeViewControllerResultCancelled:
                    break;
                case SLComposeViewControllerResultDone:
                    break;
            }
        };
        
        [[AppDelegate rootController] presentViewController:controller animated:YES completion:Nil];
    }
    else
    {
        [self shareUrlFacebook];
    }
}

- (IBAction)shareTwitter:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];

        [controller setInitialText: self.item.title];
        [controller addURL:[NSURL URLWithString: self.item.link]];

        [[AppDelegate rootController] presentViewController:controller animated:YES completion:nil];
    }
    else
    {
        [self shareUrlTwitter];
        
        /*
        NSURL *twitterURL = [NSURL URLWithString: [NSString stringWithFormat: @"twitter://post?message=%@%%20%@", [self.item.title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [self.item.link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ] ];
        
        if ([[UIApplication sharedApplication] canOpenURL: twitterURL])
        {
            [[UIApplication sharedApplication] openURL: twitterURL];
        }
        else
        {
            [self shareUrlTwitter];
        }
        */
    }
}

- (void) shareUrlFacebook
{
    NSURL *sharerUrl = [NSURL URLWithString: [NSString stringWithFormat:@"https://www.facebook.com/sharer/sharer.php?u=%@", self.item.link]];
    [[UIApplication sharedApplication] openURL:sharerUrl];
}


- (void) shareUrlTwitter
{
    NSString *url = [NSString stringWithFormat:@"https://twitter.com/intent/tweet?text=%@&url=%@",
                     [self.item.title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                     [self.item.link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ];
    
    NSURL *sharerUrl = [NSURL URLWithString: url];
    [[UIApplication sharedApplication] openURL:sharerUrl];
}


@end
