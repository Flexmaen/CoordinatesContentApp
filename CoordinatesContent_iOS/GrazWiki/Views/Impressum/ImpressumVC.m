//
//  ImpressumVC.m
//  GrazWiki
//
//  Created by Christian Gottitsch on 21.03.13.
//  Copyright (c) 2013 Christian Gottitsch. All rights reserved.
//

#import "ImpressumVC.h"
#import "AppDelegate.h"

@interface ImpressumVC ()

@property(nonatomic, retain)IBOutlet UIWebView *wvWebView;

@end

@implementation ImpressumVC

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
    // Do any additional setup after loading the view from its nib.
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate]; // init the delegate

    
    /* NavigationBar */
    self.title = @"Impressum";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:105.0/255.0 green:111.0/255.0 blue:125.0/255.0 alpha:1.0];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                   style:UIBarButtonSystemItemEdit target:self action:@selector(menuButtonTriggered:) ];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    // layout and init data for webview
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"impressum_de" ofType:@"html"];
    [self.wvWebView loadData:[NSData dataWithContentsOfFile:filePath] MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:nil];
    [self.wvWebView setBackgroundColor:[UIColor clearColor]];
    [self.wvWebView setOpaque:NO];

    


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/////////////////////////////////////////////////////////////////////////////////////////
#pragma -
#pragma  NavigationBar Actions
/////////////////////////////////////////////////////////////////////////////////////////
-(void)menuButtonTriggered:(NSNotification *)notification{
    NSLog(@"mneuButtonTriggered");
    [appDelegate menuButtonMainViewTriggered];
}

@end
