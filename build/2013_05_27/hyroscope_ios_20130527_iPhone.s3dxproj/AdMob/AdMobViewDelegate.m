/**
 * AdMobViewDelegate.m
 * AdMob iPhone SDK publisher code.
 */

#import "AdMobView.h"
#import "AdMobViewDelegate.h"

@implementation AdMobViewDelegate

// The designated initializer.  Override if you create the controller programmatically 
// and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Custom initialization
		self.title = @"Programmatic Ad";
	}
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	// get the window frame here.
	CGRect appFrame = [UIScreen mainScreen].applicationFrame;
	
	UIView *view = [[UIView alloc] initWithFrame:appFrame];
	// making flexible because this will end up in a navigation controller.
	view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	self.view = view;
	
	[view release];
	
	// Request an ad
	adMobAd = [AdMobView requestAdWithDelegate:self]; // start a new ad request
	[adMobAd retain]; // this will be released when it loads (or fails to load)
	
}

- (void)dealloc 
{
  [autoslider invalidate];
  [adMobAd release];
  [super dealloc];
}

// Request a new ad. If a new ad is successfully loaded, it will be animated into location.
- (void)refreshAd:(NSTimer *)timer 
{
  [adMobAd requestFreshAd];
}

- (void)setPublisherId:(NSString *)_publisherId
{		
    customPublisherId = [[NSString alloc] initWithString:_publisherId];
}

- (void)setUseTestAd:(BOOL)_use
{
    customUseTestAd = _use;
}

- (void)setBackColorR:(float)_value { customBackColorR = _value; }
- (void)setBackColorG:(float)_value { customBackColorG = _value; }
- (void)setBackColorB:(float)_value { customBackColorB = _value; }
- (void)setBackColorA:(float)_value { customBackColorA = _value; }
- (void)setTextColorR:(float)_value { customTextColorR = _value; }
- (void)setTextColorG:(float)_value { customTextColorG = _value; }
- (void)setTextColorB:(float)_value { customTextColorB = _value; }
- (void)setTextColorA:(float)_value { customTextColorA = _value; }

#pragma mark -
#pragma mark AdMobDelegate methods

//DEPRECATED - (BOOL)useTestAd 
//DEPRECATED {
//DEPRECATED   return customUseTestAd;
//DEPRECATED }

//DEPRECATED - (NSString *)publisherId 
//DEPRECATED {
//DEPRECATED   return customPublisherId;
//DEPRECATED }

//DEPRECATED - (UIColor *)adBackgroundColor {
//DEPRECATED   return [UIColor colorWithRed:customBackColorR green:customBackColorG blue:customBackColorB alpha:customBackColorA]; // this should be prefilled; if not, provide a UIColor
//DEPRECATED }

//DEPRECATED - (UIColor *)adTextColor {
//DEPRECATED   return [UIColor colorWithRed:customTextColorR green:customTextColorG blue:customTextColorB alpha:customTextColorA]; // this should be prefilled; if not, provide a UIColor
//DEPRECATED }

//DEPRECATED - (BOOL)mayAskForLocation {
//DEPRECATED   return YES; // this should be prefilled; if not, see AdMobProtocolDelegate.h for instructions
//DEPRECATED }

// Sent when an ad request loaded an ad; this is a good opportunity to attach
// the ad view to the hierachy.
- (void)didReceiveAd:(AdMobView *)adView 
{
    NSLog(@"AdMob: Did receive ad");
    [adView setHidden:NO] ;
    
    // get the view frame
    // CGRect frame = self.view.frame;
    // put the ad at the bottom of the screen
    // adMobAd.frame = CGRectMake(0, frame.size.height - 48, frame.size.width, 48);
    // [self.view addSubview:adMobAd];
    
    
    [autoslider invalidate];
    autoslider = [NSTimer scheduledTimerWithTimeInterval:AD_REFRESH_PERIOD target:self selector:@selector(refreshAd:) userInfo:nil repeats:YES];
}

- (void)didReceiveRefreshedAd:(AdMobView *)adView
{
    
}

// Sent when an ad request failed to load an ad
- (void)didFailToReceiveAd:(AdMobView *)adView 
{
    NSLog(@"AdMob: Did fail to receive ad");
    //[adMobAd removeFromSuperview];  // Not necessary since never added to a view, but doesn't hurt and is good practice
    [adMobAd release];
    adMobAd = nil;
}

- (void)didFailToReceiveRefreshedAd:(AdMobView *)adView
{
    
}

- (NSArray *)testDevices 
{
	if ( customUseTestAd )
	{
		return [NSArray arrayWithObjects:
				ADMOB_SIMULATOR_ID,                             // Simulator
				[UIDevice currentDevice].uniqueIdentifier,		// Current device
				nil];
	}
	else 
	{
		return [NSArray arrayWithObjects:nil];
	}
}

- (NSString *)testAdActionForAd:(AdMobView *)adView
{
    return @"url" ;
}

- (NSString *)publisherIdForAd:(AdMobView *)adView
{
	return customPublisherId;	
}

- (UIViewController *)currentViewControllerForAd:(AdMobView *)adView
{
	return self;
}

- (UIColor *)adBackgroundColorForAd:(AdMobView *)adView
{
	return [UIColor colorWithRed:customBackColorR green:customBackColorG blue:customBackColorB alpha:customBackColorA]; // this should be prefilled; if not, provide a UIColor
}

- (UIColor *)primaryTextColorForAd:(AdMobView *)adView
{
	return [UIColor colorWithRed:customTextColorR green:customTextColorG blue:customTextColorB alpha:customTextColorA]; // this should be prefilled; if not, provide a UIColor
}

- (UIColor *)secondaryTextColorForAd:(AdMobView *)adView
{
	return [UIColor colorWithRed:customTextColorR green:customTextColorG blue:customTextColorB alpha:customTextColorA]; // this should be prefilled; if not, provide a UIColor
}

@end