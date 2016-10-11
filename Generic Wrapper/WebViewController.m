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
@property (strong, nonatomic) IBOutlet NSTimer *loop;

@end

@implementation WebViewController {
    Boolean webReached;
    Boolean localLoaded;
    Boolean requestInProgress;
}

@synthesize webView, topNaveOffset, navBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Init
    webView.delegate = self;
    navBar.hidden = true;
    [self setWebviewSettings];
    
    // Call local or dev
    [self upadatePage];
    
    if (UPDATE) {
        _loop = [NSTimer scheduledTimerWithTimeInterval:LOOP_TIMER target:self selector:@selector(upadatePage) userInfo:nil repeats:YES];
    }
}

- (void) setWebviewSettings {
    
    webView.scrollView.scrollEnabled = CAN_SCROLL;
    webView.scrollView.bounces = BOUNCE;
    webView.scalesPageToFit = FIT_PAGE;
    webView.allowsInlineMediaPlayback = INLINE_MEDIA;
    
    if (ADDRESS)
        [webView setDataDetectorTypes:UIDataDetectorTypeAddress];
    
    if (PHONE_NO)
        [webView setDataDetectorTypes:UIDataDetectorTypePhoneNumber];
    
    if (CALENDER)
        [webView setDataDetectorTypes:UIDataDetectorTypeCalendarEvent];
    
    if (LINK)
        [webView setDataDetectorTypes:UIDataDetectorTypeLink];
    
}

// PDF only
- (IBAction)backBtnAction:(id)sender {
    [webView goBack];
}

// Use this to set interface on webview
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    requestInProgress = false;
    
    NSString *currentHost = [self.webView.request.URL host];
    NSString *setHost = [[NSURL URLWithString:WEB_URL] host];
    
    if ([currentHost isEqualToString:setHost]) {
        NSLog(@"✅ Succesful web request");
        webReached = true;
    } else {
        localLoaded = false;
        
        if (FALLBACK) {
            _loop = [NSTimer scheduledTimerWithTimeInterval:LOOP_TIMER target:self selector:@selector(upadatePage) userInfo:nil repeats:YES];
        }
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // iPad-specific interface here
        [self.webView stringByEvaluatingJavaScriptFromString:@"setToPhoneMode(false)"];
    } else {
        // iPhone and iPod touch interface here
        [self.webView stringByEvaluatingJavaScriptFromString:@"setToPhoneMode(true)"];
    }
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSLog(@"🌎 WEB: %@", [[request URL] absoluteString]);
    NSLog(@"Request in progress: %s", (requestInProgress ? "true" : "false"));
    [_loop invalidate];
    
    NSString *host = [[request URL] host];
    NSString *setHost = [[NSURL URLWithString:WEB_URL] host];
    topNaveOffset.constant = 0; // reset top offset
    
    // Callback function catcher
    if ([host isEqualToString:(@"callback")]) {
        
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
            NSLog(@"⚠️ <NOT HANDLED> Function: %@ with Params: %@",function , params);
        }
        
        // Return 'false' to stop browser continuing
        return false;
    }
    
    // if host only set stop browsing away from site
    else if (![host isEqualToString:setHost] && HOST_ONLY && host != nil) {
        NSLog(@"⚠️ HOST_ONLY set true redirect blocked");
        return false;
    }
    
    //Catch pdf request
    else if ([[[[request URL] pathExtension] uppercaseString] isEqualToString:@"PDF"]) {
        navBar.hidden = false;
        topNaveOffset.constant = navBar.frame.size.height;
    } else {
        navBar.hidden = true;
    }
    
    // Return 'true', navigate to requested URL as normal if no condition found
    requestInProgress = true;
    return true;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    requestInProgress = false;
    
    NSLog(@"❗️ Can't connect to WEB_URL with errorCode: %li", (long)error.code);
    webReached = false;
    
    if (FALLBACK && error.code != -999) {
        NSLog(@"⚠️ Switching to fallback");
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"www"] isDirectory:NO]]];
        localLoaded = true;
    }
}

- (void) upadatePage {
    NSLog(@"🔄 Updating...");
    
    // Call local or dev
    if (LOCAL_MODE) {
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"www"] isDirectory:NO]]];
    } else {
        if (webReached) {
            [webView reload];
        } else {
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:WEB_URL]
                                                                   cachePolicy: NSURLRequestUseProtocolCachePolicy
                                                               timeoutInterval:PAGELOAD_TIMEOUT];
            
            [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
            [webView loadRequest: request];
        }
    }
}

- (BOOL)prefersStatusBarHidden {
    return true;
}

@end
