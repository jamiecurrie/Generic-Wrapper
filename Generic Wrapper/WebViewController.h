
@interface WebViewController : UIViewController <UIWebViewDelegate>
@end

#warning configure webview here

// Use resource://<filename> to load local resource from within you html body, make sure you files are in the 'www' folder

// =============
// URLS
// =============

#define WEB_URL @"http://www.google.co.uk/"


// =============
// SETTINGS
// =============

#define LOCAL_MODE false    // use WEB_URL or www folder
#define CAN_SCROLL false    // enable page scrolling
#define BOUNCE false        // iOS style bounce on web pages
#define FIT_PAGE false      // scales page to fit within iPad screen
#define HOST_ONLY true      // can browse away from given host
#define FALLBACK true       // if using a WEB_URL fallback to local content if web page fails
#define INLINE_MEDIA true   // allows inline media playback


// =============
// DETECT TYPES
// =============

#define ADDRESS false       // detect and highlight address
#define PHONE_NO false      // detect and highlight phone numbers
#define CALENDER false      // detect and highlight calender events
#define LINK false          // detect and highlight links


// =============
// UPDATE LOOP
// =============

#define UPDATE false        // turn constant update loop on/off
#define LOOP_TIMER 1        // seconds per loop - if fallback set true this is used for recovery
#define PAGELOAD_TIMEOUT 5  // set how long you want to wait for timeout



