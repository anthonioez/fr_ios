//
//  ContactViewController.m
//  FRiOS
//
//  Created by Anthonio Ez on 8/8/15.
//  Copyright (c) 2015 FRiOS. All rights reserved.
//

#import "AppDelegate.h"
#import "ContactViewController.h"

@interface ContactViewController ()
{
    UITapGestureRecognizer *tapGesture;
}
@end

@implementation ContactViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        self.title = @"Info";
        //set the image icon for the tab
        self.tabBarItem.image = [UIImage imageNamed:@"bar_info.png"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navBar.shadowImage = [UIImage new];
    self.navBar.translucent = YES;
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    
    
    [self.nameText addTarget:self.emailText  action:@selector(becomeFirstResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.emailText addTarget:self.messageText  action:@selector(becomeFirstResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
   
    
    
    [self roundButton: self.callButton.layer];
    [self roundButton: self.sendButton.layer];
    
    [self roundBorder: self.nameText.layer];
    [self roundBorder: self.emailText.layer];
    [self roundBorder: self.messageText.layer];
    
    
    self.bannerView.adUnitID = ADMOB_BANNER_ID;
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest: [GADRequest request]];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view addGestureRecognizer:tapGesture];
    [self.scrollView addGestureRecognizer:tapGesture];
 
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view removeGestureRecognizer:tapGesture];
    [self.scrollView removeGestureRecognizer:tapGesture];
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) roundButton:(CALayer *)l
{
    [l setMasksToBounds:YES];
    [l setCornerRadius: 5.0f];
    [l setBorderWidth:1.0f];
    [l setBorderColor:[[UIColor lightGrayColor] CGColor]];
}

- (void) roundBorder:(CALayer *)l
{
    [l setMasksToBounds:YES];
    [l setCornerRadius: 5.0f];
    [l setBorderWidth:1.0f];
    [l setBorderColor:[[UIColor lightGrayColor] CGColor]];
}



-(void)hideKeyboard
{
    [self.nameText resignFirstResponder];
    [self.emailText resignFirstResponder];
    [self.messageText resignFirstResponder];
}

- (IBAction)onCall:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [NSString stringWithFormat:@"tel:%@", APP_PHONE]]];    
}

- (IBAction)onSend:(id)sender
{
    NSString *name = [self.nameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *email = [self.emailText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *message = [self.messageText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

                       
    if ([name length] == 0)
    {
       [self message:@"Please enter your name!"];
       
       [self.nameText becomeFirstResponder];
       return;
    }
    
    if (![self isValidEmail: email])
    {
       [self message: @"Please enter your email address!"];
       
       [self.emailText becomeFirstResponder];
       return;
    }

    if ([message length] == 0)
    {
       [self message:@"Please enter your message!"];
       
       [self.messageText becomeFirstResponder];
       return;
    }

                       
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    if (mailComposer != nil && [MFMailComposeViewController canSendMail])
    {
        NSString *msg = @"";
        msg = [msg stringByAppendingFormat: @"Name : %@\n", name];
        msg = [msg stringByAppendingFormat: @"Email : %@\n", email];
        msg = [msg stringByAppendingFormat: @"Message : %@\n", message];
        
        mailComposer.mailComposeDelegate = self;
        [mailComposer setToRecipients: [NSArray arrayWithObject:APP_EMAIL]];  
        [mailComposer setSubject: @"Colorificio Splendor iOS"];
        [mailComposer setMessageBody: msg isHTML:NO];
        
        [self.parentViewController presentViewController:mailComposer animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Your device cannot send mail"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    [self.messageText setText:@""];
}

-(BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
                       
- (void) message:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alertView show];
}

@end
