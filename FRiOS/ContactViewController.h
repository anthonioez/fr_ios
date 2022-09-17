//
//  ContactViewController.h
//  FRiOS
//
//  Created by Anthonio Ez on 8/8/15.
//  Copyright (c) 2015 FRiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface ContactViewController : UIViewController<MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextView *messageText;

@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

- (IBAction)onCall:(id)sender;
- (IBAction)onSend:(id)sender;

@end
