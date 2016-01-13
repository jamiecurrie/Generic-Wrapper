//
//  ViewController.m
//  Generic Wrapper
//
//  Created by Jamie Currie on 10/12/2015.
//  Copyright © 2015 bigdog agency. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"

@interface WebViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topNaveOffset;
@end

@implementation WebViewController
@synthesize webView, topNaveOffset, navBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Init
    webView.delegate = self;
    webView.scrollView.scrollEnabled = CAN_SCROLL;
    navBar.hidden = true;
    
    // Call local or dev
    if (LOCAL_MODE) {
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"www"] isDirectory:NO]]];
    } else {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:PREVIEW_URL]];
        [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
        [webView loadRequest: request];
    }
}

// PDF only
- (IBAction)backBtnAction:(id)sender {
    [webView goBack];
}

// Use this to set interface on webview
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // iPad-specific interface here
        [self.webView stringByEvaluatingJavaScriptFromString:@"setToPhoneMode(false)"];
    } else {
        // iPhone and iPod touch interface here
        [self.webView stringByEvaluatingJavaScriptFromString:@"setToPhoneMode(true)"];
    }
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"LOADING: %@", [[request URL] absoluteString]);
    
    topNaveOffset.constant = 0; // reset top offset

    // Callback function catcher
    if ([[[request URL] scheme] isEqualToString:(@"callback")]) {
        
        NSString *function = [[request URL] host];
        NSArray *query = [[[request URL] query] componentsSeparatedByString:@"&"];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        
        for (NSString *item in query) {
            NSArray *elts = [item componentsSeparatedByString:@"="];
            [params setValue:elts.lastObject forKey:elts.firstObject];
        }
        
        if ([function isEqualToString:@"FUNCTION_NAME"]) {
            // Add else ifs for each function name you want to catch
        } else {
            NSLog(@"<NOT HANDLED> Function: %@ with Params: %@",function , params);
        }
        
        // Return 'false' to stop browser continuing
        return false;
    }
    
    //Catch pdf request
    else if ([[[[request URL] pathExtension] uppercaseString] isEqualToString:@"PDF"]) {
        navBar.hidden = false;
        topNaveOffset.constant = navBar.frame.size.height;
        
    }
    
    // Return 'true', navigate to requested URL as normal if no condition found
    return true;
}

- (BOOL)prefersStatusBarHidden {
    return true;
}

@end
