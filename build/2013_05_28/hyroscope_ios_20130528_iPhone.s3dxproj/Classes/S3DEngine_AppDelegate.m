//-----------------------------------------------------------------------------
#import "S3DEngine_AppDelegate.h"
#import "S3DEngine_EAGLView.h"
#import "S3DEngine_ViewController.h"
//-----------------------------------------------------------------------------
#import "S3DEngine_Wrapper.h"
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
@implementation S3DEngine_AppDelegate
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
@synthesize window;
@synthesize viewController;
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------

- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context 
{
    [splashView removeFromSuperview] ;
    [splashView release] ;
}

//-----------------------------------------------------------------------------

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
    // Stop iPod music (only available in OS 3.0+)
    //
    /*
    Class MPMusicPlayerControllerClass  = (NSClassFromString( @"MPMusicPlayerController" )) ;
    if  ( MPMusicPlayerControllerClass != nil )
    {
        [[MPMusicPlayerController iPodMusicPlayer] stop] ;
    }
    */

    // Disable idle timer
    //
    [application setIdleTimerDisabled:YES] ;

    // Configure and start the accelerometer
    //
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:kAccelerometerFrequency] ;
    [[UIAccelerometer sharedAccelerometer] setDelegate:self] ;

    // Create the view controller
    //
    [window addSubview:viewController.glView];
    [window makeKeyAndVisible];

    // Configure and start animation
    //
	viewController.glView.iAnimationInterval = kAnimationFrequency ;
	[viewController.glView startAnimation];       

    // Configure ans start slpash view
    //
    CGRect frame = [[UIScreen mainScreen] bounds];
    splashView = [[UIImageView alloc] initWithFrame:frame];
    splashView.image = [UIImage imageNamed: @"Default.png"];
    [window addSubview:splashView];
    [window bringSubviewToFront:splashView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:window cache:YES];
    [UIView setAnimationDelegate:self]; 
    [UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
    splashView.alpha = 0.0;
    [UIView commitAnimations];
    
    // Play default movie if any
    //
    [viewController.glView playDefaultMovieIfAny];
}

//-----------------------------------------------------------------------------

- (void)applicationWillResignActive:(UIApplication *)application 
{
	viewController.glView.iAnimationInterval = 0.5f ;

    S3DEngine_iPhone_Pause ( true ) ;
}

//-----------------------------------------------------------------------------

- (void)applicationDidBecomeActive:(UIApplication *)application 
{
	viewController.glView.iAnimationInterval = kAnimationFrequency ;
    
    S3DEngine_iPhone_Pause ( false ) ;
}

//-----------------------------------------------------------------------------

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Enable idle timer
    //
    [application setIdleTimerDisabled:NO] ;

    [viewController.glView applicationWillStop];
}

//-----------------------------------------------------------------------------

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    NSLog ( @"applicationDidReceiveMemoryWarning\n" ) ;
}

//-----------------------------------------------------------------------------

- (void)dealloc 
{
	[window         release];
	[viewController release];
	[super          dealloc];
}

//-----------------------------------------------------------------------------
// UIAccelerometerDelegate method, called when the device accelerates.
//
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration 
{
    S3DEngine_iPhone_OnDeviceMoved ( acceleration.x, acceleration.y, -acceleration.z ) ;
}

//-----------------------------------------------------------------------------

void ObjectiveC_OpenURL ( const char *_pURL )
{
    NSString *sURL = [ [ [NSString alloc] initWithCString : _pURL ] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ] ;

    [[UIApplication sharedApplication] openURL : [NSURL URLWithString:sURL] ] ;
}

//-----------------------------------------------------------------------------
@end
//-----------------------------------------------------------------------------
