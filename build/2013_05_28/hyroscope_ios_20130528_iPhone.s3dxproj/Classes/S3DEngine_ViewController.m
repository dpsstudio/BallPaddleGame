//-----------------------------------------------------------------------------
#import "S3DEngine_ViewController.h"
#import "S3DEngine_EAGLView.h"
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
@implementation S3DEngine_ViewController
//-----------------------------------------------------------------------------


//-----------------------------------------------------------------------------
@synthesize glView;
//-----------------------------------------------------------------------------



/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

//-----------------------------------------------------------------------------

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    if  ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 3.0f )
    {        
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve ;
    }
}


//-----------------------------------------------------------------------------
/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
//-----------------------------------------------------------------------------

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //[glView setNeedsLayout];
}

//-----------------------------------------------------------------------------

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

//-----------------------------------------------------------------------------

- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//-----------------------------------------------------------------------------

- (void)dealloc 
{
    [glView release];
    [super  dealloc];
}

//-----------------------------------------------------------------------------
@end
//-----------------------------------------------------------------------------
