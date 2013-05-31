//-----------------------------------------------------------------------------
#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
//-----------------------------------------------------------------------------
#import <MediaPlayer/MPMoviePlayerController.h>
#import <MediaPlayer/MPMoviePlayerViewController.h>
//-----------------------------------------------------------------------------
#import "AdMobView.h"
#import "AdMobViewDelegate.h"
//-----------------------------------------------------------------------------
#define kAccelerometerFrequency (1.0 /  30.0)
#define kAnimationFrequency     (1.0 / 120.0)
//-----------------------------------------------------------------------------


//-----------------------------------------------------------------------------
@interface S3DEngine_EAGLView : UIView <UITextFieldDelegate>
//-----------------------------------------------------------------------------
{	
@private

	GLint                           iBackingWidth               ;
	GLint                           iBackingHeight              ;
	float                           fContentScale               ;
	
	EAGLContext                    *pEAGLContext                ;
	
    GLuint                          iViewFramebuffer            ;
    GLuint                          iViewMSAAFramebuffer        ;	

	GLuint                          iViewColorRenderbuffer      ;
	GLuint                          iViewMSAAColorRenderbuffer  ;
	GLuint                          iViewDepthRenderbuffer      ;

    float                           fSystemVersion              ;
	NSTimer                        *pAnimationTimer             ;
	NSTimeInterval                  iAnimationInterval          ;
    char                            aPackName                   [ 512 ] ;
    char                            aStartupPackName            [ 512 ] ;
    char                            aStartupMovieName           [ 512 ] ;
    BOOL                            bStartupMovieNeedsToBePlayed;
    BOOL                            bStartupMovieIsPlaying      ;
    BOOL                            bOverlayMovieIsPlaying      ;
    MPMoviePlayerViewController    *pMoviePlayerViewController  ;
    
    UITextField                    *virtualKeyboardTextField    ;
    BOOL                            bVirtualKeyboardVisible     ;
    
    BOOL                            bAdMobViewVisible           ;
    AdMobView                      *pAdMobView                  ;
    AdMobViewDelegate              *pAdMobViewDelegate          ;
}

//-----------------------------------------------------------------------------

@property NSTimeInterval iAnimationInterval;

- (void)startAnimation;
- (void)stopAnimation;
- (void)applicationWillStop;
- (void)drawView;
- (void)playMovieAtURL:(NSURL*)theURL withStreaming:(BOOL)liveStream;
- (void)showVirtualKeyboard;
- (void)hideVirtualKeyboard;
- (void)showAdModView;
- (void)hideAdModView;
- (void)playDefaultMovieIfAny;

//-----------------------------------------------------------------------------
@end
//-----------------------------------------------------------------------------
