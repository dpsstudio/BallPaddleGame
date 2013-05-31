//-----------------------------------------------------------------------------
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
//-----------------------------------------------------------------------------
#import "S3DEngine_EAGLView.h"
#import "S3DEngine_ViewController.h"
#import "S3DEngine_AppDelegate.h"
//-----------------------------------------------------------------------------
#import "S3DEngine_Wrapper.h"
//-----------------------------------------------------------------------------
#define USE_DEPTH_BUFFER                                1
BOOL    USE_GLES2_IF_AVAILABLE                          = YES ;
#define USE_ADMOB                                       1
//-----------------------------------------------------------------------------
#define MOVIEPLAYER_ORIENTATIONS_ALL                    0
#define MOVIEPLAYER_ORIENTATIONS_LANDSCAPE_ALL          1
#define MOVIEPLAYER_ORIENTATIONS_LANDSCAPE_LEFT         2
#define MOVIEPLAYER_ORIENTATIONS_LANDSCAPE_RIGHT        3
#define MOVIEPLAYER_ORIENTATIONS_PORTRAIT_ALL           4
#define MOVIEPLAYER_ORIENTATIONS_PORTRAIT               5
#define MOVIEPLAYER_ORIENTATIONS_PORTRAIT_UPSIDE_DOWN   6
//-----------------------------------------------------------------------------
int     iScreenWidth                                    = 320 ; // FIXME: avoid globals (for the wrapper)
int     iScreenHeight                                   = 480 ; // FIXME: avoid globals (for the wrapper)
int     iMoviePlayerOrientations                        = MOVIEPLAYER_ORIENTATIONS_ALL ;
int     iAntialiasingSamples                            = 0 ;
//-----------------------------------------------------------------------------
// Movie player controller subclass, in order to enable/disable some orientations 
// FIXME: put all movie related stuff in a separate file !!!
// 
@interface S3DMoviePlayerViewController : MPMoviePlayerViewController { }
@end
@implementation S3DMoviePlayerViewController
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    switch ( iMoviePlayerOrientations )
    {
        case MOVIEPLAYER_ORIENTATIONS_LANDSCAPE_ALL        : return ( interfaceOrientation == UIInterfaceOrientationLandscapeLeft       ) || 
                                                                    ( interfaceOrientation == UIInterfaceOrientationLandscapeRight      ) ;
        case MOVIEPLAYER_ORIENTATIONS_LANDSCAPE_LEFT       : return ( interfaceOrientation == UIInterfaceOrientationLandscapeLeft       ) ;
        case MOVIEPLAYER_ORIENTATIONS_LANDSCAPE_RIGHT      : return ( interfaceOrientation == UIInterfaceOrientationLandscapeRight      ) ;
        case MOVIEPLAYER_ORIENTATIONS_PORTRAIT_ALL         : return ( interfaceOrientation == UIInterfaceOrientationPortrait            ) || 
                                                                    ( interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown  ) ;
        case MOVIEPLAYER_ORIENTATIONS_PORTRAIT             : return ( interfaceOrientation == UIInterfaceOrientationPortrait            ) ;
        case MOVIEPLAYER_ORIENTATIONS_PORTRAIT_UPSIDE_DOWN : return ( interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown  ) ;
    }    
    return YES ;
}
@end


//-----------------------------------------------------------------------------
// A class extension to declare private methods
//-----------------------------------------------------------------------------
@interface S3DEngine_EAGLView ()
//-----------------------------------------------------------------------------
@property (nonatomic, retain) EAGLContext  *pEAGLContext;
@property (nonatomic, assign) NSTimer      *pAnimationTimer;
//-----------------------------------------------------------------------------
- (BOOL) createFramebuffer;
- (void) destroyFramebuffer;
//-----------------------------------------------------------------------------
@end
//-----------------------------------------------------------------------------
EAGLContext* CreateBestEAGLContext ( )
{
    EAGLContext *ctx = nil ;
    
    #if (defined __IPHONE_3_0)
    if ( USE_GLES2_IF_AVAILABLE ) ctx = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    #endif

    if (ctx == nil)
    {
        ctx = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    }
    return ctx ;
}
//-----------------------------------------------------------------------------

        
//-----------------------------------------------------------------------------
@implementation S3DEngine_EAGLView
//-----------------------------------------------------------------------------
@synthesize pEAGLContext;
@synthesize pAnimationTimer;
@synthesize iAnimationInterval;
//-----------------------------------------------------------------------------
//  You must implement this
//
+ (Class) layerClass 
{
	return [CAEAGLLayer class];
}

//-----------------------------------------------------------------------------
//  The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
//
- (id)initWithCoder:(NSCoder*)coder 
{
    iViewColorRenderbuffer      = 0 ;
    iViewMSAAColorRenderbuffer  = 0 ;
    iViewFramebuffer            = 0 ;
    iViewMSAAFramebuffer        = 0 ;
    iViewDepthRenderbuffer      = 0 ;
    bOverlayMovieIsPlaying      = NO ;
    bStartupMovieNeedsToBePlayed= NO ;
    bStartupMovieIsPlaying      = NO ;
    bVirtualKeyboardVisible     = NO ;
    bAdMobViewVisible           = NO ;    
    pMoviePlayerViewController  = nil ;
    fContentScale               = 1.0f ;
    fSystemVersion              = [[[UIDevice currentDevice] systemVersion] floatValue] ;

	if ((self = [super initWithCoder:coder])) 
    {
        // Get rendering option
        //
        NSBundle     *bundle = [ NSBundle mainBundle ] ;
        NSDictionary *info   = [ bundle infoDictionary ] ;
        NSString     *value1 = [ info objectForKey: @"S3DOptionForceGLES1"              ] ;
        NSString     *value2 = [ info objectForKey: @"S3DOptionMoviePlayerOrientations" ] ;
        NSString     *value3 = [ info objectForKey: @"S3DOptionContentScaleFactor"      ] ;
        NSString     *value4 = [ info objectForKey: @"S3DOptionMSAASamples"             ] ;

        if ( ( value1 != nil ) && ( [value1 boolValue] == YES ) )
        {
            USE_GLES2_IF_AVAILABLE = NO ;
        }        
        if ( value2 != nil )
        {
            iMoviePlayerOrientations = [value2 intValue] ;
        }
        if ( value3 != nil )
        {
            #if (defined __IPHONE_4_0)
            if  ( fSystemVersion >= 4.0f )
            {
                fContentScale = MIN( [value3 floatValue], [UIScreen mainScreen].scale) ;
            }
            #endif
        }
        if ( value4 != nil )
        {
            #if (defined __IPHONE_4_0)
            if  ( fSystemVersion >= 4.0f )
            {
                iAntialiasingSamples = [value4 intValue] ;
            }
            #endif
        }
        
		// Setup OpenGL ES layer
        //
		CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
		
		eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];

        
        // Create OpenGL ES context
        //
        pEAGLContext = CreateBestEAGLContext ( ) ;
                		
		if ( ! pEAGLContext || ! [EAGLContext setCurrentContext:pEAGLContext] || ![self createFramebuffer]) 
        {
			[self release];
			return nil;
		}
		
        // Get useful paths 
        //
        NSArray    *pPathArray          = NSSearchPathForDirectoriesInDomains ( NSLibraryDirectory, NSUserDomainMask, YES ) ;
        NSString   *pLibraryFolderNS    = [pPathArray objectAtIndex:0] ;
        const char *pLibraryFolderC     = [pLibraryFolderNS cStringUsingEncoding:NSASCIIStringEncoding ] ;
        NSArray    *pPathArray2         = NSSearchPathForDirectoriesInDomains ( NSDocumentDirectory, NSUserDomainMask, YES ) ;
        NSString   *pDocumentsFolderNS  = [pPathArray2 objectAtIndex:0] ;
        const char *pDocumentsFolderC   = [pDocumentsFolderNS cStringUsingEncoding:NSASCIIStringEncoding ] ;
        NSString   *pApplicationPathNS  = [[NSBundle mainBundle] bundlePath] ;
        const char *pApplicationPath    = [pApplicationPathNS cStringUsingEncoding:NSASCIIStringEncoding ] ;
        
        // Init S3DEngine.
        //
        if ( S3DEngine_iPhone_Init ( pLibraryFolderC, pDocumentsFolderC ) )
        {
            // For the moment, use fixed pack name.
            //
            sprintf ( aPackName,        "file://%s/S3DMain.stk",    pApplicationPath ) ;
            sprintf ( aStartupPackName, "file://%s/S3DStartup.stk", pApplicationPath ) ;
            sprintf ( aStartupMovieName,       "%s/Default.m4v",    pApplicationPath ) ;

            // Test if there is a startup pack
            //
            NSString *pStartupPackPath = [[NSString alloc] initWithUTF8String: aStartupPackName + 7 ] ; // Skip "file://"
            bool      bStartupPack     = [[NSFileManager defaultManager ] fileExistsAtPath:pStartupPackPath ] ;

            // Load pack
            //
            if ( S3DEngine_iPhone_LoadPack ( bStartupPack ? aStartupPackName : NULL, aPackName ) )
            {
                // First frame !
                //
                S3DEngine_iPhone_RunOneFrame ( ) ;
                
                // Is there a defaut movie ?
                //
                NSString *pMoviePath = [[NSString alloc] initWithUTF8String: aStartupMovieName ] ;
                
                if ( [[NSFileManager defaultManager ] fileExistsAtPath:pMoviePath ] )
                {
                    // Set the flag
                    //
                    bStartupMovieNeedsToBePlayed = YES ;
                }
                [pMoviePath release] ;
            }                        
        }
        
		iAnimationInterval = kAnimationFrequency ;   
        [self drawView];
	}

	return self;
}

//-----------------------------------------------------------------------------

- (void)playDefaultMovieIfAny
{
    // Is there a defaut movie ?
    //
    if ( bStartupMovieNeedsToBePlayed )
    {
        NSString *pMoviePath = [[NSString alloc] initWithUTF8String: aStartupMovieName ] ;
        
        if ( [[NSFileManager defaultManager ] fileExistsAtPath:pMoviePath ] )
        {
            // Play movie.
            //
            bStartupMovieIsPlaying  = YES ;
            
            NSURL *pMovieURL = [ [NSURL alloc] initFileURLWithPath:pMoviePath ] ;                    
            [self playMovieAtURL:pMovieURL withStreaming:NO ] ;
            
            [pMovieURL release] ;
        }
        
        [pMoviePath release] ;
        
        // Clear flag
        //
        bStartupMovieNeedsToBePlayed = NO ;
    }
}

//-----------------------------------------------------------------------------

- (void)drawView 
{
    if ( ! bStartupMovieIsPlaying && ! bStartupMovieNeedsToBePlayed && ! S3DEngine_iPhone_Paused ( ) )
    {
        if ( bOverlayMovieIsPlaying )
        {
            // While an overlay movie is playing, do not update rendering buffers.
            //
            S3DEngine_iPhone_RunOneFrame ( ) ;
        }
        else
        {
            // Yield to system calls (touches, etc.) for one ms 0.002.
            // Source: http://www.71squared.com/2009/04/maingameloop-changes/
            //
            while ( CFRunLoopRunInMode ( kCFRunLoopDefaultMode, 0.002, FALSE ) == kCFRunLoopRunHandledSource ) ;

            // Set GL context
            //
            [EAGLContext setCurrentContext:pEAGLContext];
            

            // Bind framebuffer
            //
            glBindFramebufferOES ( GL_FRAMEBUFFER_OES, ( iViewMSAAFramebuffer > 0 ) ? iViewMSAAFramebuffer : iViewFramebuffer ) ;
            
            // Run one engine frame
            //
            S3DEngine_iPhone_RunOneFrame ( ) ;
            
            
            // Resolve from iViewMSAAFramebuffer to iViewFramebuffer
            //
            #if (defined __IPHONE_4_0)
            if ( iViewMSAAFramebuffer > 0 )
            {
                glDisable ( GL_SCISSOR_TEST ) ;     
                glBindFramebufferOES ( GL_READ_FRAMEBUFFER_APPLE, iViewMSAAFramebuffer ) ;
                glBindFramebufferOES ( GL_DRAW_FRAMEBUFFER_APPLE, iViewFramebuffer ) ;
                glResolveMultisampleFramebufferAPPLE ( ) ;
            }
            #endif
            
            
            // Starting from iOS 4.0, we can improve parallism by discarding the depth buffer
            //
            if ( iViewDepthRenderbuffer ) 
            {
                #if (defined __IPHONE_4_0)
                if  ( fSystemVersion >= 4.0f )
                {
                    if ( iViewMSAAFramebuffer > 0 )
                    {
                        GLenum attachements [ ] = { GL_COLOR_ATTACHMENT0_OES, GL_DEPTH_ATTACHMENT_OES } ;
                        glDiscardFramebufferEXT ( GL_FRAMEBUFFER_OES, 2, attachements ) ;
                    }
                    else 
                    {
                        GLenum attachements [ ] = { GL_DEPTH_ATTACHMENT_OES } ;
                        glDiscardFramebufferEXT ( GL_FRAMEBUFFER_OES, 1, attachements ) ;
                    }
                }
                #endif
            }            
            
            // Swap
            //
            glBindRenderbufferOES ( GL_RENDERBUFFER_OES, iViewColorRenderbuffer ) ;
            [pEAGLContext presentRenderbuffer:GL_RENDERBUFFER_OES];
            
            
            // Enable multitouch
            //
            self.multipleTouchEnabled = S3DEngine_iPhone_IsMultiTouchEnabled ( ) ;
                        
            // Do we need to display/hide the virtual keyboard ? (FIXME: do it only when necessary)
            //
            if ( bVirtualKeyboardVisible && ! S3DEngine_iPhone_IsVirtualKeyboardNeeded ( ) )
            {
                [self hideVirtualKeyboard];
            }
            else if ( ! bVirtualKeyboardVisible && S3DEngine_iPhone_IsVirtualKeyboardNeeded ( ) )
            {
                [self showVirtualKeyboard];
            }
            
            // Do we need to display/hide AdMob ? (FIXME: do it only when necessary)
            //
            if ( bAdMobViewVisible && ! S3DEngine_AdMob_WantVisible ( ) )
            {
                [self hideAdModView];            
            }
            else if ( ! bAdMobViewVisible && S3DEngine_AdMob_WantVisible ( ) )
            {
                [self showAdModView];
            }
        }
        
        if ( S3DEngine_iPhone_Stopped ( ) )
        {
            // Enable idle timer
            //
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO] ;
            
            // Shutdown engine
            //
            S3DEngine_iPhone_Shutdown ( ) ;
            
            // Exit
            //
            exit ( 0 ) ;
        }        
    }
}

//-----------------------------------------------------------------------------

- (void)layoutSubviews 
{
    [self setFrame:[[UIScreen mainScreen] bounds]];
    
    //[self destroyFramebuffer];
    //[self createFramebuffer];
}

//-----------------------------------------------------------------------------

- (BOOL)createFramebuffer 
{	
    #if (defined __IPHONE_4_0)
    if  ( fSystemVersion >= 4.0f )
    {
        self.contentScaleFactor = fContentScale ;
    }
    #endif
    
	glGenFramebuffersOES  ( 1, &iViewFramebuffer  ) ;
	glGenRenderbuffersOES ( 1, &iViewColorRenderbuffer ) ;
	
	glBindFramebufferOES  ( GL_FRAMEBUFFER_OES,  iViewFramebuffer  ) ;
	glBindRenderbufferOES ( GL_RENDERBUFFER_OES, iViewColorRenderbuffer ) ;
    
	[pEAGLContext renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(id<EAGLDrawable>)self.layer];
    
	glFramebufferRenderbufferOES    ( GL_FRAMEBUFFER_OES,  GL_COLOR_ATTACHMENT0_OES,   GL_RENDERBUFFER_OES, iViewColorRenderbuffer);
	glGetRenderbufferParameterivOES ( GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES,  &iBackingWidth  ) ;
	glGetRenderbufferParameterivOES ( GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &iBackingHeight ) ;
    
    iScreenWidth  = iBackingWidth  ; // FIXME: avoid globals (for the wrapper)
    iScreenHeight = iBackingHeight ; // FIXME: avoid globals (for the wrapper)
    
    #if (defined __IPHONE_4_0)
    if ( iAntialiasingSamples > 1 )
    {
        // Determine how many MSAS samples to use
        //
        GLint                                  iAntialiasingMaxSamples ;
        glGetIntegerv ( GL_MAX_SAMPLES_APPLE, &iAntialiasingMaxSamples ) ;
        
        iAntialiasingSamples = MIN( iAntialiasingSamples, iAntialiasingMaxSamples ) ;
        
        // Create the MSAA framebuffer (offscreen)
        //
        glGenFramebuffersOES ( 1, &iViewMSAAFramebuffer ) ;
        glBindFramebufferOES ( GL_FRAMEBUFFER_OES, iViewMSAAFramebuffer ) ;
        
        // Create the offscreen MSAA color buffer.
        // After rendering, the contents of this will be blitted into iViewFramebuffer.
        //
        glGenRenderbuffersOES ( 1, &iViewMSAAColorRenderbuffer ) ;
        glBindRenderbufferOES ( GL_RENDERBUFFER_OES, iViewMSAAColorRenderbuffer ) ;
        glRenderbufferStorageMultisampleAPPLE ( GL_RENDERBUFFER_OES, iAntialiasingSamples, GL_RGBA8_OES, iBackingWidth, iBackingHeight ) ;
        glFramebufferRenderbufferOES ( GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, iViewMSAAColorRenderbuffer ) ;
        
    }
    #endif
    
    if ( USE_DEPTH_BUFFER ) 
    {
        GLenum eDepthComponentInternalFormat = GL_DEPTH_COMPONENT16_OES ;
        
        #if (defined __IPHONE_3_0)
        if ( USE_GLES2_IF_AVAILABLE && ( [pEAGLContext API] == kEAGLRenderingAPIOpenGLES2 ) )
        {
            eDepthComponentInternalFormat = GL_DEPTH_COMPONENT24_OES ;
        }
        #endif

        glGenRenderbuffersOES ( 1, &iViewDepthRenderbuffer ) ;
        glBindRenderbufferOES ( GL_RENDERBUFFER_OES, iViewDepthRenderbuffer ) ;
        
        #if (defined __IPHONE_4_0)
        if ( iAntialiasingSamples > 1 )
        {
            glRenderbufferStorageMultisampleAPPLE ( GL_RENDERBUFFER_OES, iAntialiasingSamples, eDepthComponentInternalFormat, iBackingWidth, iBackingHeight ) ;
        }
        else 
        #endif
        {
            glRenderbufferStorageOES ( GL_RENDERBUFFER_OES, eDepthComponentInternalFormat, iBackingWidth, iBackingHeight ) ;
        }
        glFramebufferRenderbufferOES ( GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, iViewDepthRenderbuffer ) ;
    }

	if ( glCheckFramebufferStatusOES ( GL_FRAMEBUFFER_OES ) != GL_FRAMEBUFFER_COMPLETE_OES ) 
    {
		NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
		return NO ;
	}
	
	return YES;
}

//-----------------------------------------------------------------------------

- (void)destroyFramebuffer 
{	
	glDeleteFramebuffersOES  ( 1, &iViewFramebuffer  ) ; iViewFramebuffer  = 0 ;
	glDeleteRenderbuffersOES ( 1, &iViewColorRenderbuffer ) ; iViewColorRenderbuffer = 0 ;
	
	if ( iViewDepthRenderbuffer ) 
    {
		glDeleteRenderbuffersOES ( 1, &iViewDepthRenderbuffer ) ; iViewDepthRenderbuffer = 0 ;
	}
}

//-----------------------------------------------------------------------------

- (void)startAnimation 
{
	self.pAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:iAnimationInterval target:self selector:@selector(drawView) userInfo:nil repeats:YES];
}

//-----------------------------------------------------------------------------

- (void)stopAnimation 
{
	self.pAnimationTimer = nil;
}

//-----------------------------------------------------------------------------

- (void)setAnimationTimer:(NSTimer *)newTimer 
{
	[pAnimationTimer invalidate];
	pAnimationTimer = newTimer;
}

//-----------------------------------------------------------------------------

- (void)setAnimationInterval:(NSTimeInterval)interval 
{	
    iAnimationInterval = interval;
    
	if ( pAnimationTimer ) 
    {
		[self stopAnimation];
		[self startAnimation];
	}
}

//-----------------------------------------------------------------------------

- (void)applicationWillStop
{
    // Shutdown S3DEngine.
    //
    S3DEngine_iPhone_Shutdown ( ) ;
}

//-----------------------------------------------------------------------------

- (void)dealloc 
{	
	[self stopAnimation];
	
	if ( [EAGLContext currentContext] == pEAGLContext ) 
    {
		[EAGLContext setCurrentContext:nil];
	}
	
	[pEAGLContext release];	
	[super dealloc];
}

//-----------------------------------------------------------------------------
//  Input handling
//-----------------------------------------------------------------------------

- (void) handleMultiTouch:(NSSet*)touches
{
    if ( S3DEngine_iPhone_IsMultiTouchEnabled ( ) )
    {
        float aTouchesX  [5] = { 0, 0, 0 } ;
        float aTouchesY  [5] = { 0, 0, 0 } ;
        int   aTouchesS  [5] = { 0, 0, 0 } ;
        int   aTouchesTC [5] = { 0, 0, 0 } ;
        int   iTouch     = 0 ;
        
        for ( UITouch *touch in touches )
        {
            CGPoint         p = [touch locationInView:self] ;
            UITouchPhase    s = [touch phase] ;
            
            aTouchesX  [ iTouch ] = 2.0f *                                   p.x   / iBackingWidth  * fContentScale - 1.0f ;
            aTouchesY  [ iTouch ] = 2.0f * (iBackingHeight / fContentScale - p.y ) / iBackingHeight * fContentScale - 1.0f ;
            aTouchesTC [ iTouch ] = [touch tapCount] ;
            
            switch ( s )
            {
            case UITouchPhaseBegan      : aTouchesS[ iTouch ] = 1 ; break ;
            case UITouchPhaseMoved      : aTouchesS[ iTouch ] = 2 ; break ;
            case UITouchPhaseStationary : aTouchesS[ iTouch ] = 3 ; break ;
            case UITouchPhaseEnded      : aTouchesS[ iTouch ] = 4 ; aTouchesTC [ iTouch ] = 0 ; break ;
            case UITouchPhaseCancelled  : aTouchesS[ iTouch ] = 5 ; aTouchesTC [ iTouch ] = 0 ; break ;
            }
            
            if ( ++iTouch > 4 ) break ;
        }
        
        S3DEngine_iPhone_OnTouchesChanged ( aTouchesS[0], aTouchesTC[0], aTouchesX[0], aTouchesY[0],
                                            aTouchesS[1], aTouchesTC[1], aTouchesX[1], aTouchesY[1],
                                            aTouchesS[2], aTouchesTC[2], aTouchesX[2], aTouchesY[2],
                                            aTouchesS[3], aTouchesTC[3], aTouchesX[3], aTouchesY[3],
                                            aTouchesS[4], aTouchesTC[4], aTouchesX[4], aTouchesY[4] ) ;
    }
}

//-----------------------------------------------------------------------------

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    NSSet *touchesForView = [event touchesForView:self] ;
	
	if ( [touchesForView count] == 1 )
    {
        for ( UITouch *touch in touchesForView )
        {
            float x = [touch locationInView:self].x ;
            float y = [touch locationInView:self].y ;
            
            S3DEngine_iPhone_OnMouseMoved           ( 2.0f * x / iBackingWidth * fContentScale - 1.0f, 2.0f * (iBackingHeight / fContentScale - y ) / iBackingHeight * fContentScale - 1.0f ) ;
            S3DEngine_iPhone_OnMouseButtonPressed   ( ) ;
        }
    }
    [self handleMultiTouch:touchesForView] ;
}

//-----------------------------------------------------------------------------

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    NSSet *touchesForView = [event touchesForView:self] ;

    if ( [touchesForView count] == 1 )
    {
        for ( UITouch *touch in touchesForView )
        {
            float x = [touch locationInView:self].x ;
            float y = [touch locationInView:self].y ;
            
            S3DEngine_iPhone_OnMouseMoved           ( 2.0f * x / iBackingWidth * fContentScale - 1.0f, 2.0f * (iBackingHeight / fContentScale - y ) / iBackingHeight * fContentScale - 1.0f ) ;
        }
    }	
    [self handleMultiTouch:touchesForView] ;
}

//-----------------------------------------------------------------------------

- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    NSSet *touchesForView = [event touchesForView:self] ;
	
	if ( [touchesForView count] == 1 )
    {
        for ( UITouch *touch in touchesForView )
        {
            float x = [touch locationInView:self].x ;
            float y = [touch locationInView:self].y ;
            
            S3DEngine_iPhone_OnMouseMoved           ( 2.0f * x / iBackingWidth * fContentScale - 1.0f, 2.0f * (iBackingHeight / fContentScale - y ) / iBackingHeight * fContentScale - 1.0f ) ;
            S3DEngine_iPhone_OnMouseButtonReleased  ( ) ;
        }
    }
    [self handleMultiTouch:touchesForView] ;
}

//-----------------------------------------------------------------------------

- (void) touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event
{
    NSSet *touchesForView = [event touchesForView:self] ;
	
	if ( [touchesForView count] == 1 )
    {
        for ( UITouch *touch in touchesForView )
        {
            float x = [touch locationInView:self].x ;
            float y = [touch locationInView:self].y ;
            
            S3DEngine_iPhone_OnMouseMoved           ( 2.0f * x / iBackingWidth * fContentScale - 1.0f, 2.0f * (iBackingHeight / fContentScale - y ) / iBackingHeight * fContentScale - 1.0f ) ;
            S3DEngine_iPhone_OnMouseButtonReleased  ( ) ;
        }
    }
    [self handleMultiTouch:touchesForView] ;
}

//-----------------------------------------------------------------------------
// Plays a movie file with the built-in media player
//
// Supported Formats : .mov, .mp4, .mpv, and .3gp using one of the following compression standards:
// - H.264 Baseline Profile Level 3.0 video, up to 640 x 480 at 30 fps. Note that B frames are not supported in the Baseline profile.
// - MPEG-4 Part 2 video (Simple Profile)
//
-(void)playMovieAtURL:(NSURL*)theURL withStreaming:(BOOL)liveStream
{
    //NSLog( @"Playing movie !!!!!!!" ) ;
    
    if  ( fSystemVersion < 3.199 ) // Deal with floating point precision errors
    {
        MPMoviePlayerController* theMoviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:theURL];
 
        theMoviePlayer.scalingMode = MPMovieScalingModeAspectFill;
 
        // Register for the playback finished notification.
        //
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification     object:theMoviePlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieKeyWindowChanged:) name:UIWindowDidBecomeKeyNotification               object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieScalingCallback:)  name:MPMoviePlayerScalingModeDidChangeNotification  object:theMoviePlayer];
 
        // Movie playback is asynchronous, so this method returns immediately.
        //
        [theMoviePlayer play];
    }
    else
    {
        pMoviePlayerViewController = [[S3DMoviePlayerViewController alloc] initWithContentURL:theURL];

        pMoviePlayerViewController.moviePlayer.scalingMode                = MPMovieScalingModeAspectFill;
        pMoviePlayerViewController.moviePlayer.useApplicationAudioSession = NO; // To mimic the same behavior than with previous OS
        pMoviePlayerViewController.moviePlayer.movieSourceType            = ( liveStream == YES ) ? MPMovieSourceTypeStreaming : MPMovieSourceTypeUnknown ;
        pMoviePlayerViewController.modalTransitionStyle                   = UIModalTransitionStyleCrossDissolve ;
        
        // Setup movie player view background color to black
        //
        [pMoviePlayerViewController.view setBackgroundColor:UIColor.blackColor];            
        
        // Use a modal mode in order to have an autorotating controller.
        //
        [[(S3DEngine_AppDelegate *)[UIApplication sharedApplication].delegate viewController] presentModalViewController:pMoviePlayerViewController animated:NO];
        //[pMoviePlayerViewController presentMoviePlayerViewControllerAnimated:pMoviePlayerViewController]; // <-- For non modal movie player
        //[self addSubview:pMoviePlayerViewController.view];                                                // <-- For non modal movie player
        
        
        // Register for the playback finished notification.
        //
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification     object:pMoviePlayerViewController.moviePlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieFinishedCallback:) name:MPMoviePlayerDidExitFullscreenNotification     object:pMoviePlayerViewController.moviePlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieKeyWindowChanged:) name:UIWindowDidBecomeKeyNotification               object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieScalingCallback:)  name:MPMoviePlayerScalingModeDidChangeNotification  object:pMoviePlayerViewController.moviePlayer];        
        
        // Movie playback is asynchronous, so this method returns immediately.
        //
        [pMoviePlayerViewController.moviePlayer play];
    }
    
    bOverlayMovieIsPlaying = YES ;
}

//-----------------------------------------------------------------------------
// When the movie is done, release the controller.
//
-(void)myMovieFinishedCallback:(NSNotification*)notification
{
    //NSLog( @"Stopping movie !!!!!!!" ) ;

    if  ( fSystemVersion < 3.199 ) // Deal with floating point precision errors
    {        
        MPMoviePlayerController* theMoviePlayer = [notification object];
     
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification       object:theMoviePlayer];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeKeyNotification                 object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerScalingModeDidChangeNotification    object:theMoviePlayer];
     
        // Release the movie instance created in playMovieAtURL:
        //
        [theMoviePlayer stop];
        [theMoviePlayer release];
    }
    else 
    {
        //MPMoviePlayerViewController* theMoviePlayerViewController = [notification object];
        MPMoviePlayerController* theMoviePlayer = [notification object];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification       object:theMoviePlayer];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerDidExitFullscreenNotification       object:theMoviePlayer];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeKeyNotification                 object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerScalingModeDidChangeNotification    object:theMoviePlayer];

        [theMoviePlayer stop];
        
        // Release the movie instance created in playMovieAtURL:
        //
        //[pMoviePlayerViewController dismissModalViewControllerAnimated:NO];       // <-- Not needed in our case ???
        //[pMoviePlayerViewController dismissMoviePlayerViewControllerAnimated];    // <-- For non modal movie player
        //[pMoviePlayerViewController.view removeFromSuperview];                    // <-- For non modal movie player
        [pMoviePlayerViewController release];
        pMoviePlayerViewController  = nil ;
        
        // Need to force a layout 
        //
        [self setNeedsLayout];
    }
    
    // Unpause engine.
    //
    if ( S3DEngine_iPhone_Paused ( ) )
    {
        S3DEngine_iPhone_Pause      ( false ) ;
    }
    S3DEngine_OnOverlayMovieStopped ( ) ;
    bStartupMovieIsPlaying          = NO ;
    bOverlayMovieIsPlaying          = NO ;
}

//-----------------------------------------------------------------------------
// ...
//
-(void)myMovieScalingCallback:(NSNotification*)notification
{
    
}

//-----------------------------------------------------------------------------
// When the movie player becomes key window, add extra overlay view if needed
//
-(void)myMovieKeyWindowChanged:(NSNotification*)notification
{
/*
    UIWindow *window = [notification object] ;
    UIButton *label  = [[UIButton alloc] initWithFrame:CGRectZero];
    label.transform  = CGAffineTransformMakeRotation(M_PI/2.0);
    [label setBackgroundColor:[UIColor redColor]];
    label.frame      = CGRectMake(0,0,48,48);
    [window addSubview:label];
*/
}

//-----------------------------------------------------------------------------
//  Movie playback (called from C)
//-----------------------------------------------------------------------------

bool ObjectiveC_PlayMovie ( const char *_pURL )
{
    bool bOK = false ;
    
    if ( _pURL && *_pURL )
    {
        // Ignore "file://" prefix if local file
        //
        BOOL bLocalFile = FALSE ;
        
        if ( strncmp ( _pURL, "file://", 7 ) == 0 )
        {
            _pURL += 7 ;
            bLocalFile = YES ;
        }
        
        // Compute full URL string
        //
        NSString *pMovieURLString = nil ;
        
        if ( bLocalFile )
        {
            if ( *_pURL == '/' ) // Already an absolute path
            {
                pMovieURLString = [[NSString alloc] initWithUTF8String:_pURL ] ;
            }
            else 
            {
                NSString   *pApplicationPathNS  = [[NSBundle mainBundle] bundlePath] ;
                const char *pApplicationPath    = [pApplicationPathNS cStringUsingEncoding:NSASCIIStringEncoding ] ;
                char        aMovieFullURL       [ 1024 ] ;
                sprintf   ( aMovieFullURL,      "%s/%s", pApplicationPath, _pURL ) ; 
                
                pMovieURLString = [[NSString alloc] initWithUTF8String:aMovieFullURL ] ;
            }            
        }            
        else
        {
            pMovieURLString = [[NSString alloc] initWithUTF8String:_pURL ] ;
        }
        
        // Is there a movie at the specified URL ?
        //
        if ( ( ! bLocalFile ) || [[NSFileManager defaultManager ] fileExistsAtPath:pMovieURLString ] )
        {
            // Play movie.
            //
            NSURL *pMovieURL = bLocalFile ? [ [NSURL alloc] initFileURLWithPath:pMovieURLString ] : [ [NSURL alloc] initWithString:pMovieURLString ] ;
            [[(S3DEngine_AppDelegate *)[UIApplication sharedApplication].delegate viewController].glView playMovieAtURL:pMovieURL withStreaming:NO/* TODO: !bLocalFile*/ ] ;
            [pMovieURL release] ;
            bOK = true ;
        }

        [pMovieURLString release] ;
    }
    
    return bOK ;
}

//-----------------------------------------------------------------------------

void ObjectiveC_StopMovie ( )
{
    // TODO...
}

//-----------------------------------------------------------------------------

void ObjectiveC_LogMessage ( const char *_pMsg )
{
    NSLog ( @"%s", _pMsg ) ;
}

//-----------------------------------------------------------------------------
//  Virtual keyboard handling
//-----------------------------------------------------------------------------

-(void)myVirtualKeyboardTextFieldDidChangeCallback:(NSNotification*)aNotification
{
    NSString   *pNSText   = [virtualKeyboardTextField text] ;
    const char *pCText    = [pNSText UTF8String] ;

    S3DEngine_OnVirtualKeyboardTextChanged ( pCText ) ;
}

//-----------------------------------------------------------------------------

-(void)showVirtualKeyboard
{
    // Setup virtual keyboard if not already done.
    //
    if ( virtualKeyboardTextField == nil )
    {
        virtualKeyboardTextField = [[UITextField alloc] initWithFrame:CGRectMake ( 0, 0, 20, 20 )] ;
        [self addSubview:virtualKeyboardTextField];
        [virtualKeyboardTextField release];
        [virtualKeyboardTextField setReturnKeyType:UIReturnKeyDone];
        [virtualKeyboardTextField setHidden:YES];
        [virtualKeyboardTextField setDelegate:self];
        [virtualKeyboardTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
		[virtualKeyboardTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [virtualKeyboardTextField setText:[NSString stringWithUTF8String:S3DEngine_GetVirtualKeyboardText ( )]];

        // Register notifications.
        //
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myVirtualKeyboardTextFieldDidChangeCallback:) name:UITextFieldTextDidChangeNotification object:virtualKeyboardTextField];
    }

    // Setup orientation and give input to the virtual keyboard.
    //
    if ( virtualKeyboardTextField != nil )
    {
        bVirtualKeyboardVisible = [virtualKeyboardTextField becomeFirstResponder];
    }
}

//-----------------------------------------------------------------------------

-(void)hideVirtualKeyboard
{
    if ( virtualKeyboardTextField != nil )
    {
        [virtualKeyboardTextField resignFirstResponder]; 
        [virtualKeyboardTextField removeFromSuperview ]; 
        virtualKeyboardTextField = nil;
    }
    
    bVirtualKeyboardVisible = NO ;
}

//-----------------------------------------------------------------------------
//  AdMob support
//-----------------------------------------------------------------------------
#define degreesToRadians(x) (M_PI * x / 180.0)
//-----------------------------------------------------------------------------

- (void)showAdModView
{
#if USE_ADMOB
    if ( bAdMobViewVisible  == NO  && 
         pAdMobViewDelegate == nil && 
         pAdMobView         == nil )
    {
        bAdMobViewVisible = YES ;
        
        UIInterfaceOrientation orientation = UIInterfaceOrientationLandscapeLeft ;

        switch ( S3DEngine_iPhone_GetViewportRotation ( ) )
        {
            case 0 : orientation = UIInterfaceOrientationPortrait           ; break ;
            case 1 : orientation = UIInterfaceOrientationLandscapeLeft      ; break ;
            case 2 : orientation = UIInterfaceOrientationPortraitUpsideDown ; break ;
            case 3 : orientation = UIInterfaceOrientationLandscapeRight     ; break ;
        }    

        // Create the AdMob view delegate
        //
        pAdMobViewDelegate = [AdMobViewDelegate alloc];
        
        if ( pAdMobViewDelegate )
        {
            // Initialize the AdMob view delegate
            //
            [pAdMobViewDelegate  setPublisherId:[[NSString alloc] initWithUTF8String:S3DEngine_AdMob_GetPublisherId()]];
            [pAdMobViewDelegate  setUseTestAd:S3DEngine_AdMob_GetUseTestAd()];
            [pAdMobViewDelegate  setBackColorR:S3DEngine_AdMob_GetAdMobBackColorR ( )];
            [pAdMobViewDelegate  setBackColorG:S3DEngine_AdMob_GetAdMobBackColorG ( )];
            [pAdMobViewDelegate  setBackColorB:S3DEngine_AdMob_GetAdMobBackColorB ( )];
            [pAdMobViewDelegate  setBackColorA:S3DEngine_AdMob_GetAdMobBackColorA ( )];
            [pAdMobViewDelegate  setTextColorR:S3DEngine_AdMob_GetAdMobTextColorR ( )];
            [pAdMobViewDelegate  setTextColorG:S3DEngine_AdMob_GetAdMobTextColorG ( )];
            [pAdMobViewDelegate  setTextColorB:S3DEngine_AdMob_GetAdMobTextColorB ( )];
            [pAdMobViewDelegate  setTextColorA:S3DEngine_AdMob_GetAdMobTextColorA ( )];


            // Query for an Ad
            //
            pAdMobView = [AdMobView requestAdWithDelegate:pAdMobViewDelegate];
                    
            // Setup the view frame and transform, depending on the UI orientation
            //
            switch ( orientation )
            {
                case UIInterfaceOrientationLandscapeLeft : 
                {
                    //CGAffineTransform xform = CGAffineTransformMakeRotation ( degreesToRadians ( -90.0f ) ) ;
                    //pAdMobView.frame        = CGRectMake( iBackingWidth / fContentScale - 48, 0.0f, 48.0f, iBackingHeight / fContentScale ) ; 
                    //pAdMobView.transform    = xform ;
                    
                    CGAffineTransform xform = CGAffineTransformMakeTranslation ( 0.5f * ( iBackingWidth / fContentScale - 48.0f ), 0.5f * ( iBackingHeight / fContentScale - 48.0f ) ) ;//0.5f * iBackingHeight / fContentScale ) ;
                    pAdMobView.transform    = CGAffineTransformRotate ( xform, degreesToRadians ( -90.0f ) ) ;
                }
                break ;
                    
                case UIInterfaceOrientationLandscapeRight :
                {
                    //CGAffineTransform xform = CGAffineTransformMakeRotation ( degreesToRadians ( 90.0f ) ) ;
                    //pAdMobView.frame        = CGRectMake( 0.0f, 0.0f, 48.0f, iBackingHeight / fContentScale ) ; 
                    //pAdMobView.transform    = xform ;
                    
                    CGAffineTransform xform = CGAffineTransformMakeTranslation ( -0.5f * ( iBackingWidth / fContentScale - 48.0f ), 0.5f * ( iBackingHeight / fContentScale - 48.0f ) ) ;//0.5f * iBackingHeight / fContentScale ) ;
                    pAdMobView.transform    = CGAffineTransformRotate ( xform, degreesToRadians ( 90.0f ) ) ;
                }
                break ;
                    
                case UIInterfaceOrientationPortraitUpsideDown :
                {
                    //CGAffineTransform xform = CGAffineTransformMakeRotation ( degreesToRadians ( 180.0f ) ) ;
                    //pAdMobView.frame        = CGRectMake( 0.0f, 0.0f, iBackingWidth / fContentScale, 48.0f ) ; 
                    //pAdMobView.transform    = xform ;

                    CGAffineTransform xform = CGAffineTransformMakeRotation ( degreesToRadians ( 180.0f ) ) ;
                    pAdMobView.transform    = xform ;
                }
                break ;
                    
                default :
                {
                    //pAdMobView.frame        = CGRectMake( 0.0f, iBackingHeight / fContentScale - 48, iBackingWidth / fContentScale, 48.0f ) ; 
                    
                    CGAffineTransform xform = CGAffineTransformMakeTranslation ( 0.0f, iBackingHeight / fContentScale - 48.0f ) ;
                    pAdMobView.transform    = xform ;
                }
                break ;
            }            
            
            pAdMobView.clipsToBounds = YES ;
			
			[pAdMobView retain] ;
            [pAdMobView setHidden:YES] ;
            
            [self addSubview:pAdMobView] ;
        }    
    }
#endif
}

//-----------------------------------------------------------------------------

- (void)hideAdModView
{
#if USE_ADMOB
    if ( pAdMobViewDelegate != nil )
    {
        [pAdMobViewDelegate release ] ;
        pAdMobViewDelegate = nil;
    }
    if ( pAdMobView != nil )
    {
        [pAdMobView removeFromSuperview ] ; 
        [pAdMobView release ] ;
        pAdMobView = nil;
    }
    
    bAdMobViewVisible = NO ;
#endif
}


//-----------------------------------------------------------------------------
@end
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
@implementation S3DEngine_EAGLView (UITextFieldDelegate)
//-----------------------------------------------------------------------------

- (BOOL)textFieldShouldReturn:(UITextField *)_textField 
{
    S3DEngine_OnVirtualKeyboardValidate ( ) ;
	return YES;
}

//-----------------------------------------------------------------------------
@end
//-----------------------------------------------------------------------------

