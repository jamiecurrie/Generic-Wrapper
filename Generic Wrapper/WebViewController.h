
@interface WebViewController : UIViewController <UIWebViewDelegate>
@end

// CONFIG

#warning Add online url here
#define WEB_URL @"http://www.pretveggiepopup-uat.co.uk.gridhosted.co.uk/"

#warning Set webview settings here
#define LOCAL_MODE false
#define CAN_SCROLL false
#define BOUNCE false
#define FIT_PAGE true
#define HOST_ONLY true // can browse away from given host
