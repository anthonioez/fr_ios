//
//  FeedViewController.m
//  FRiOS
//
//  Created by Anthonio Ez on 8/8/15.
//  Copyright (c) 2015 FRiOS. All rights reserved.
//

#import "AppDelegate.h"
#import "FeedViewController.h"
#import "DetailViewController.h"

#import "SMXMLDocument.h"
#import "AsyncImageView.h"

#import "Utils.h"
#import "FeedItem.h"

#import "FeedViewCell.h"

#define FEED_CELL   @"FeedViewCell"

@interface FeedViewController ()
{
    BOOL feedLoading;
    NSMutableArray *feedList;
    
    NSMutableData *feedData;
    NSURLConnection *feedConnection;
}
@end

@implementation FeedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        feedLoading = false;
        feedList = [NSMutableArray new];
        
        self.title = @"News";
        self.tabBarItem.image = [UIImage imageNamed:@"bar_news.png"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.feedTable registerNib:[UINib nibWithNibName:FEED_CELL bundle:nil] forCellReuseIdentifier:FEED_CELL];
    [self.feedTable setDelegate:self];
    [self.feedTable setDataSource:self];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor clearColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self action:@selector(refreshFeed) forControlEvents:UIControlEventValueChanged];
    
    [self.feedTable addSubview: self.refreshControl];
    
    self.bannerView.adUnitID = ADMOB_BANNER_ID;
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest: [GADRequest request]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if([feedList count] == 0 && !feedLoading)
    {
        [self loadFeed];
    }

}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self unloadFeed];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [feedList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedItem *item = [feedList objectAtIndex:indexPath.row];
    FeedViewCell *cell = (FeedViewCell *)[self.feedTable dequeueReusableCellWithIdentifier: FEED_CELL];
    if (cell == nil)
    {
        cell = [[FeedViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FEED_CELL];
        
        //common settings
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        cell.iconImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    else
    {
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget: cell.iconImage];
    }
    
    [cell.titleLabel setText: item.title];
    [cell.infoLabel setText: [NSString stringWithFormat:@"%@ - %@", item.creator, item.date]];

    cell.iconImage.image = [UIImage imageNamed:@"icon.png"];
    cell.iconImage.imageURL = [[NSURL alloc] initWithString: item.image];
    
    return cell;
}

#pragma mark - Table view delegate
// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedItem *selected = [feedList objectAtIndex:indexPath.row];
    
    DetailViewController *viewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    viewController.item = selected;
    [[AppDelegate rootController] pushViewController:viewController animated:YES];
}

- (void) updateFeed
{
    feedLoading = false;
    [self.activityIndicator stopAnimating];
    [self.refreshControl endRefreshing];
    
    [self.feedTable reloadData];
    
}

- (void) refreshFeed
{
    [self loadFeed];
}

- (void) unloadFeed
{
    feedLoading = false;
    [self.activityIndicator stopAnimating];

    if(feedConnection != nil)
    {
        [feedConnection cancel];
        feedConnection = nil;
    }
}

- (void) loadFeed
{
    [self unloadFeed];
    
    if(![Utils connected])
    {
        [self feedAlert: @"No internet connection!"];
        return;
    }

    if(![self.refreshControl isRefreshing])
    {
        [self.activityIndicator startAnimating];
    }

    feedData = nil;
    feedConnection = nil;
    feedLoading = true;
    
    NSString *url = [NSString stringWithFormat:@"%@?stamp=%ld", APP_URL_FEED, (long)[[NSDate date] timeIntervalSince1970]];
    
    NSLog(@"loader url: %@", url);
    
    feedData = [NSMutableData new];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:APP_TIMEOUT];
    feedConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void) feedAlert: (NSString *) msg
{
    feedLoading = false;
    [self.activityIndicator stopAnimating];
    [self.refreshControl endRefreshing];

    [Utils message:nil :msg];
}

#pragma mark - Connection
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self feedAlert: [error localizedDescription]];
    });
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [feedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString* newStr = [[NSString alloc] initWithData:feedData encoding:NSUTF8StringEncoding];
        NSLog(@"data: %@", newStr);

        NSError *error = nil;
        SMXMLDocument *document = [SMXMLDocument documentWithData:feedData error:&error];
        if(error != nil)
        {
            [self feedAlert: @"Unable to parse feed!"];
            return;
        }

        if(![document.name isEqualToString:@"rss"])
        {
            [self feedAlert: @"Invalid feed data!"];
            return;
        }

        NSArray* points = [document childrenNamed:@"channel"];

        if([points count] == 0)
        {
            [self feedAlert: @"No channels found in feed!"];
            return;
        }

        [feedList removeAllObjects];

        SMXMLElement *channel = [points objectAtIndex:0];

        NSArray *channelTags = [channel children];

        for (SMXMLElement *channelTag in channelTags)
        {
            if(![[channelTag name] isEqualToString: @"item"]) continue;

            NSArray *tags = [channelTag children];

            FeedItem *item = [FeedItem new];
            for(SMXMLElement *tag in tags)
            {
                NSString *name = [tag name];
                NSString *value = [tag value];

                //NSLog(@"name: %@ value: %@", name, value);

                if([name isEqualToString:@"title"])
                {
                    item.title = value;
                }
                else if([name isEqualToString:@"link"])
                {
                    item.link = value;
                }
                else if([name isEqualToString:@"pubDate"])
                {
                    NSRange range = [value rangeOfString:@"+" options:NSBackwardsSearch];
                    if(range.location != NSNotFound)
                        item.date = [value substringToIndex: range.location];
                    else
                        item.date = value;

                }
                else if([name isEqualToString:@"creator"] || [name isEqualToString:@"dc:creator"])
                {
                    item.creator = value;
                }
                else if([name isEqualToString:@"encoded"] || [name isEqualToString:@"content:encoded"])
                {
                    item.content = value;
                }
                else if([name isEqualToString:@"enclosure"])
                {
                    NSString *image = [tag attributeNamed:@"url"];

                    item.image = (image != nil) ? [image stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]  : @"";
                }
            }

            if(item.title != nil && item.content != nil)
            {
                [feedList addObject: item];
            }
        }

        [self updateFeed];
    });

}
@end
