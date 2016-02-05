//
//  BNRWebViewController.m
//  Nerdfeed
//
//  Created by Sandy House on 2016-02-05.
//  Copyright © 2016 sanzapps. All rights reserved.
//

#import "BNRWebViewController.h"

@interface BNRWebViewController ()

@end

@implementation BNRWebViewController

- (void)loadView
{
    // This Controller's view is a UIWebView
    UIWebView *webView = [[UIWebView alloc] init];
    webView.scalesPageToFit = YES;
    self.view = webView;
}

- (void)setURL:(NSURL *)URL
{
    _URL = URL;
    if (_URL) {
        NSURLRequest *req = [NSURLRequest requestWithURL:_URL];
        [(UIWebView *)self.view loadRequest:req]; 
    }
}

//////////////////////////////////////// delegate methods
- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = @"Courses";   // needs a title to display bar button item

    self.navigationItem.leftBarButtonItem = barButtonItem;  // put on left side of navigation item
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(nonnull UIViewController *)aViewController
  invalidatingBarButtonItem:(nonnull UIBarButtonItem *)barButtonItem
{
    // Remove bar button item
    if (barButtonItem == self.navigationItem.leftBarButtonItem) {
        self.navigationItem.leftBarButtonItem = nil;
    }
}


@end
