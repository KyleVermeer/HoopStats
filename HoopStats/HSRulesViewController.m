//
//  HSRulesViewController.m
//  HoopStats
//
//  Created by Kyle Vermeer on 3/17/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "HSRulesViewController.h"

@interface HSRulesViewController ()

@end

@implementation HSRulesViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)foulPressed {
    [self loadWebPage:@"http://en.wikipedia.org/wiki/Personal_foul_(basketball)"];
}

- (IBAction)travelPressed {
    [self loadWebPage:@"http://en.wikipedia.org/wiki/Traveling_(basketball)"];
}

- (IBAction)carryPressed:(id)sender {
    [self loadWebPage:@"http://en.wikipedia.org/wiki/Carrying_(basketball)"];
}

-(void)loadWebPage:(NSString*)urlAsString
{
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.frame;
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view = webView;
    NSURL *url = [[NSURL alloc] initWithString:
                  urlAsString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [[self navigationController] pushViewController:vc animated:YES];
}
@end
