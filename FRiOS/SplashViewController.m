//
//  SplashViewController.m
//  FRiOS
//
//  Created by Anthonio Ez on 11/4/15.
//  Copyright (c) 2015 Anthonio Ez. All rights reserved.
//


#import "AppDelegate.h"
#import "SplashViewController.h"

#import "FeedViewController.h"
#import "ContactViewController.h"
#import "MapViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self performSelector:@selector(startApp) withObject:nil afterDelay:1.5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) startApp
{    
    UIViewController *viewController1 = [[FeedViewController alloc] initWithNibName:@"FeedViewController" bundle:nil];
    
    UIViewController *viewController2 = [[ContactViewController alloc] initWithNibName:@"ContactViewController" bundle:nil];
    
    UIViewController *viewController3 = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController.tabBar setTintColor: [UIColor whiteColor]];
    [tabBarController.tabBar setBarTintColor: [UIColor blackColor]];
    
    tabBarController.viewControllers = @[viewController1, viewController2, viewController3];
    
    [[AppDelegate rootController] pushViewController: tabBarController animated:YES];
}
@end
