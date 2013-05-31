//-----------------------------------------------------------------------------
#ifndef __S3DEngine_Wrapper_h__
#define __S3DEngine_Wrapper_h__
//-----------------------------------------------------------------------------

extern bool         S3DEngine_iPhone_Init                           ( const char *_pLibraryFolder, const char *_pDocumentsFolder ) ;
extern void         S3DEngine_iPhone_Shutdown                       ( ) ;
extern bool         S3DEngine_iPhone_LoadPack                       ( const char *_pStartupPackPath, const char *_pPackPath ) ;
extern void         S3DEngine_iPhone_Pause                          ( bool _bPause ) ;
extern bool         S3DEngine_iPhone_RunOneFrame                    ( ) ;
extern bool         S3DEngine_iPhone_Stopped                        ( ) ;
extern bool         S3DEngine_iPhone_Paused                         ( ) ;
extern void         S3DEngine_iPhone_OnMouseMoved                   ( float _x, float _y ) ;
extern void         S3DEngine_iPhone_OnMouseButtonPressed           ( ) ;
extern void         S3DEngine_iPhone_OnMouseButtonReleased          ( ) ;
extern void         S3DEngine_iPhone_OnDeviceMoved                  ( float _x, float _y, float _z ) ;
extern bool         S3DEngine_iPhone_IsMultiTouchEnabled            ( ) ;
extern int          S3DEngine_iPhone_GetViewportRotation            ( ) ;
extern bool         S3DEngine_iPhone_IsVirtualKeyboardNeeded        ( ) ;
extern void         S3DEngine_OnVirtualKeyboardTextChanged          ( const char *_pText ) ;
extern void         S3DEngine_OnVirtualKeyboardValidate             ( ) ;
extern const char  *S3DEngine_GetVirtualKeyboardText                ( ) ;
extern void         S3DEngine_OnOverlayMovieStopped                 ( ) ;
extern void         S3DEngine_iPhone_OnTouchesChanged               ( int _iS0, int _iTC0, float _fX0, float _fY0, 
                                                                      int _iS1, int _iTC1, float _fX1, float _fY1, 
                                                                      int _iS2, int _iTC2, float _fX2, float _fY2, 
                                                                      int _iS3, int _iTC3, float _fX3, float _fY3, 
                                                                      int _iS4, int _iTC4, float _fX4, float _fY4 ) ;
extern bool         S3DEngine_AdMob_WantVisible                     ( ) ;
extern const char  *S3DEngine_AdMob_GetPublisherId                  ( ) ;
extern bool         S3DEngine_AdMob_GetUseTestAd                    ( ) ;
extern float        S3DEngine_AdMob_GetAdMobBackColorR              ( ) ;
extern float        S3DEngine_AdMob_GetAdMobBackColorG              ( ) ;
extern float        S3DEngine_AdMob_GetAdMobBackColorB              ( ) ;
extern float        S3DEngine_AdMob_GetAdMobBackColorA              ( ) ;
extern float        S3DEngine_AdMob_GetAdMobTextColorR              ( ) ;
extern float        S3DEngine_AdMob_GetAdMobTextColorG              ( ) ;
extern float        S3DEngine_AdMob_GetAdMobTextColorB              ( ) ;
extern float        S3DEngine_AdMob_GetAdMobTextColorA              ( ) ;
        
//-----------------------------------------------------------------------------
#endif
//-----------------------------------------------------------------------------
