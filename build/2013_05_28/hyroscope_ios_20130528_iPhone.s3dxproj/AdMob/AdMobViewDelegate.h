/**
 * AdMobViewDelegate.h
 * AdMob iPhone SDK publisher code.
 */

#define AD_REFRESH_PERIOD 60.0 // display fresh ads once per minute

#import <UIKit/UIKit.h>
#import "AdMobDelegateProtocol.h";

@class AdMobView;

@interface AdMobViewDelegate : UIViewController <AdMobDelegate> 
{
    AdMobView *adMobAd;   // the actual ad; self.view is the location where the ad will be placed
    NSTimer   *autoslider; // timer to slide in fresh ads
    
    NSString  *customPublisherId;
    BOOL       customUseTestAd;
    float      customBackColorR;
    float      customBackColorG;
    float      customBackColorB;
    float      customBackColorA;
    float      customTextColorR;
    float      customTextColorG;
    float      customTextColorB;
    float      customTextColorA;
     
} 

- (void)setPublisherId:(NSString *)_publisherId;
- (void)setUseTestAd:(BOOL)_use;
- (void)setBackColorR:(float)_value;
- (void)setBackColorG:(float)_value;
- (void)setBackColorB:(float)_value;
- (void)setBackColorA:(float)_value;
- (void)setTextColorR:(float)_value;
- (void)setTextColorG:(float)_value;
- (void)setTextColorB:(float)_value;
- (void)setTextColorA:(float)_value;

@end