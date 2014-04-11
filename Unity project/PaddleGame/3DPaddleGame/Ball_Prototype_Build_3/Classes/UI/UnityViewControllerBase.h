#ifndef _TRAMPOLINE_UI_UNITYVIEWCONTROLLERBASE_H_
#define _TRAMPOLINE_UI_UNITYVIEWCONTROLLERBASE_H_

#import <UIKit/UIKit.h>

BOOL        ShouldAutorotateToInterfaceOrientation_DefaultImpl(id self_, SEL _cmd, UIInterfaceOrientation interfaceOrientation);
NSUInteger  SupportedInterfaceOrientations_DefaultImpl(id self_, SEL _cmd);
BOOL        ShouldAutorotate_DefaultImpl(id self_, SEL _cmd);

void        AddOrientationSupportDefaultImpl(Class targetClass);
void        AddShouldAutorotateToImplIfNeeded(Class targetClass, BOOL (*)(id, SEL, UIInterfaceOrientation));


@class UnityView;

// this is base implementation of unity orientation support
// for most of apps it is sufficient to subclass it.
// if you want your own view controller please check the implementation for what needs to be done for unity to work properly
@interface UnityViewControllerBase : UIViewController
{
	UnityView*	_unityView;
}
- (void)assignUnityView:(UnityView*)view;
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation;
@end

#endif
