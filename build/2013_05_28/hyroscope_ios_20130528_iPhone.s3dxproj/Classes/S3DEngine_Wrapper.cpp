//-----------------------------------------------------------------------------
#include "S3DClient_Wrapper.h"
#include "S3DXAIVariable.h"
//-----------------------------------------------------------------------------
extern "C" void ObjectiveC_OpenURL          ( const char *_pURL ) ;
extern "C" bool ObjectiveC_WakeUpWWAN       ( ) ;
extern "C" void ObjectiveC_InitWakeUpWWAN   ( ) ;
extern "C" bool ObjectiveC_PlayMovie        ( const char *_pURL ) ;
extern "C" void ObjectiveC_StopMovie        ( ) ;
extern "C" void ObjectiveC_LogMessage       ( const char *_pMsg ) ;
//-----------------------------------------------------------------------------
#include <stdio.h>
#include <string.h>
//-----------------------------------------------------------------------------
static bool  bPaused                = false ;
static bool  bAdMobWantVisible      = false ;
static bool  bAdMobUseTestAd        = false ;
static char  aAdMobPublisherId [64] = "" ;
static float fAdMobBackColorR       = 0.0f ;
static float fAdMobBackColorG       = 0.0f ;
static float fAdMobBackColorB       = 0.0f ;
static float fAdMobBackColorA       = 1.0f ;
static float fAdMobTextColorR       = 1.0f ;
static float fAdMobTextColorG       = 1.0f ;
static float fAdMobTextColorB       = 1.0f ;
static float fAdMobTextColorA       = 1.0f ;
extern int   iScreenWidth           ;
extern int   iScreenHeight          ;
//-----------------------------------------------------------------------------


//-----------------------------------------------------------------------------

extern "C" bool S3DEngine_iPhone_Init ( const char *_pLibraryFolder, const char *_pDocumentsFolder )
{    
    ObjectiveC_InitWakeUpWWAN ( ) ;
    
    return S3DClient_Init ( _pDocumentsFolder ) ;
}

//-----------------------------------------------------------------------------

void OpenURLCallback ( const char *_pURL, const char *_pTarget, void *_pUserData )
{
    ObjectiveC_OpenURL ( _pURL ) ;
}

//-----------------------------------------------------------------------------

bool WakeUpConnectionCallback ( void *_pUserData )
{
    return ObjectiveC_WakeUpWWAN ( ) ;
}

//-----------------------------------------------------------------------------

bool PlayMovieCallback ( const char *_pURL, void *_pUserData )
{
    return ObjectiveC_PlayMovie ( _pURL ) ;
}

//-----------------------------------------------------------------------------

void StopMovieCallback ( void *_pUserData )
{
    ObjectiveC_StopMovie ( ) ;
}

//-----------------------------------------------------------------------------

void LogCallback ( int _iUnused, const char *_pMsg )
{
    ObjectiveC_LogMessage ( _pMsg ) ;
}

//-----------------------------------------------------------------------------

void AdMobRegisterPublisherCallback ( unsigned char _iArgumentCount, const void *_pArguments, void *_pUserData )
{
    if ( _pArguments && ( _iArgumentCount == 1 ) )
    {
        const S3DX::AIVariable *pVariables = (const S3DX::AIVariable *)_pArguments ;
        
        if ( pVariables[0].GetType ( ) == S3DX::AIVariable::eTypeString )
        {
            strncpy ( aAdMobPublisherId, pVariables[0].GetStringValue ( ), 63 ) ;
        }
    }
}

//-----------------------------------------------------------------------------

void AdMobRegisterUseTestAdCallback ( unsigned char _iArgumentCount, const void *_pArguments, void *_pUserData )
{
    if ( _pArguments && ( _iArgumentCount == 1 ) )
    {
        const S3DX::AIVariable *pVariables = (const S3DX::AIVariable *)_pArguments ;

        if ( pVariables[0].GetType ( ) == S3DX::AIVariable::eTypeBoolean )
        {
             bAdMobUseTestAd = pVariables[0].GetBooleanValue ( ) ;
        }
    }
}

//-----------------------------------------------------------------------------

void AdMobRegisterBackColorCallback ( unsigned char _iArgumentCount, const void *_pArguments, void *_pUserData )
{
    if ( _pArguments && ( _iArgumentCount == 4 ) )
    {
        const S3DX::AIVariable *pVariables = (const S3DX::AIVariable *)_pArguments ;

        if ( pVariables[0].GetType ( ) == S3DX::AIVariable::eTypeNumber ) fAdMobBackColorR = pVariables[0].GetNumberValue ( ) ;
        if ( pVariables[1].GetType ( ) == S3DX::AIVariable::eTypeNumber ) fAdMobBackColorG = pVariables[1].GetNumberValue ( ) ;
        if ( pVariables[2].GetType ( ) == S3DX::AIVariable::eTypeNumber ) fAdMobBackColorB = pVariables[2].GetNumberValue ( ) ;
        if ( pVariables[3].GetType ( ) == S3DX::AIVariable::eTypeNumber ) fAdMobBackColorA = pVariables[3].GetNumberValue ( ) ;
    }
}

//-----------------------------------------------------------------------------

void AdMobRegisterTextColorCallback ( unsigned char _iArgumentCount, const void *_pArguments, void *_pUserData )
{
    if ( _pArguments && ( _iArgumentCount == 4 ) )
    {
        const S3DX::AIVariable *pVariables = (const S3DX::AIVariable *)_pArguments ;

        if ( pVariables[0].GetType ( ) == S3DX::AIVariable::eTypeNumber ) fAdMobTextColorR = pVariables[0].GetNumberValue ( ) ;
        if ( pVariables[1].GetType ( ) == S3DX::AIVariable::eTypeNumber ) fAdMobTextColorG = pVariables[1].GetNumberValue ( ) ;
        if ( pVariables[2].GetType ( ) == S3DX::AIVariable::eTypeNumber ) fAdMobTextColorB = pVariables[2].GetNumberValue ( ) ;
        if ( pVariables[3].GetType ( ) == S3DX::AIVariable::eTypeNumber ) fAdMobTextColorA = pVariables[3].GetNumberValue ( ) ;
    }
}

//-----------------------------------------------------------------------------

void AdMobSetVisibleCallback ( unsigned char _iArgumentCount, const void *_pArguments, void *_pUserData )
{
    if ( _pArguments && ( _iArgumentCount == 1 ) )
    {
        const S3DX::AIVariable *pVariables = (const S3DX::AIVariable *)_pArguments ;
        
        if ( pVariables[0].GetType ( ) == S3DX::AIVariable::eTypeBoolean )
        {
             bAdMobWantVisible = pVariables[0].GetBooleanValue ( ) ;
        }
    }
}

//-----------------------------------------------------------------------------

extern "C" bool S3DEngine_iPhone_LoadPack ( const char *_pStartupPackPath, const char *_pPackPath )
{
    S3DClient_iPhone_SetViewportRotation    ( 0 ) ;
    S3DClient_SetGraphicContainer           ( NULL , 0, 0, iScreenWidth, iScreenHeight ) ;
    S3DClient_SetFullscreen                 ( false ) ;
    S3DClient_SetClientType                 ( S3DClient_Type_StandAlone ) ;
    S3DClient_SetOpenURLCallback            ( OpenURLCallback,          NULL ) ;
    S3DClient_SetWakeUpConnectionCallback   ( WakeUpConnectionCallback, NULL ) ;
    S3DClient_SetPlayOverlayMovieCallback   ( PlayMovieCallback,        NULL ) ;
    S3DClient_SetStopOverlayMovieCallback   ( StopMovieCallback,        NULL ) ;
    S3DClient_SetLogCallbacks               ( LogCallback, LogCallback, LogCallback ) ;
    S3DClient_LoadPack                      ( _pStartupPackPath, _pPackPath, 0 ) ;
    S3DClient_InstallCurrentUserEventHook   ( "AdMob", "onRegisterPublisher", AdMobRegisterPublisherCallback, NULL ) ;
    S3DClient_InstallCurrentUserEventHook   ( "AdMob", "onRegisterUseTestAd", AdMobRegisterUseTestAdCallback, NULL ) ;
    S3DClient_InstallCurrentUserEventHook   ( "AdMob", "onRegisterBackColor", AdMobRegisterBackColorCallback, NULL ) ;
    S3DClient_InstallCurrentUserEventHook   ( "AdMob", "onRegisterTextColor", AdMobRegisterTextColorCallback, NULL ) ;
    S3DClient_InstallCurrentUserEventHook   ( "AdMob", "onSetVisible",        AdMobSetVisibleCallback,        NULL ) ;

    return true ;
}

//-----------------------------------------------------------------------------

extern "C" void S3DEngine_iPhone_Shutdown ( )
{
    S3DClient_Shutdown ( ) ;
}

//-----------------------------------------------------------------------------

extern "C" void S3DEngine_iPhone_Pause ( bool _bPause )
{
    bPaused         = _bPause   ;
    S3DClient_Pause ( _bPause ) ; // ???
}

//-----------------------------------------------------------------------------

extern "C" bool S3DEngine_iPhone_RunOneFrame ( )
{
    if ( bPaused ) 
    {
        return true ;
    }
    return S3DClient_RunOneFrame ( ) ;
}

//-----------------------------------------------------------------------------

extern "C" bool S3DEngine_iPhone_Stopped ( )
{
    return S3DClient_Stopped ( ) ;
}

//-----------------------------------------------------------------------------

extern "C" bool S3DEngine_iPhone_Paused ( )
{
    return bPaused ;
}

//-----------------------------------------------------------------------------

extern "C" void S3DEngine_iPhone_OnMouseMoved ( float _x, float _y )
{
    if ( ! bPaused ) 
    {
        S3DClient_iPhone_OnMouseMoved ( _x, _y ) ;
    }
}

//-----------------------------------------------------------------------------

extern "C" void S3DEngine_iPhone_OnMouseButtonPressed ( )
{
    if ( ! bPaused ) 
    {
        S3DClient_iPhone_OnMouseButtonPressed ( ) ;
    }
}

//-----------------------------------------------------------------------------

extern "C" void S3DEngine_iPhone_OnMouseButtonReleased ( )
{
    if ( ! bPaused ) 
    {
        S3DClient_iPhone_OnMouseButtonReleased ( ) ;
    }
}

//-----------------------------------------------------------------------------

extern "C" void S3DEngine_iPhone_OnDeviceMoved ( float _x, float _y, float _z )
{
    if ( ! bPaused ) 
    {
        S3DClient_iPhone_OnDeviceMoved ( _x, _y, _z ) ;
    }
}

//-----------------------------------------------------------------------------

extern "C" bool S3DEngine_iPhone_IsMultiTouchEnabled ( )
{
    return S3DClient_iPhone_IsMultiTouchEnabled ( ) ;
}

//-----------------------------------------------------------------------------

extern "C" int S3DEngine_iPhone_GetViewportRotation ( )
{
    return S3DClient_iPhone_GetViewportRotation ( ) ;
}

//-----------------------------------------------------------------------------

extern "C" bool S3DEngine_iPhone_IsVirtualKeyboardNeeded ( )
{
    return S3DClient_IsVirtualKeyboardNeeded ( ) ;
}

//-----------------------------------------------------------------------------

extern "C" void S3DEngine_OnVirtualKeyboardTextChanged ( const char *_pText )
{
    S3DClient_OnVirtualKeyboardTextChanged ( _pText ) ;
}

//-----------------------------------------------------------------------------

extern "C" void S3DEngine_OnVirtualKeyboardValidate ( )
{
    S3DClient_OnVirtualKeyboardValidate ( ) ;
}

//-----------------------------------------------------------------------------

extern "C" const char *S3DEngine_GetVirtualKeyboardText ( )
{
    return S3DClient_GetVirtualKeyboardText ( ) ;
}

//-----------------------------------------------------------------------------

extern "C" void S3DEngine_OnOverlayMovieStopped ( )
{
    S3DClient_OnOverlayMovieStopped ( ) ;
}

//-----------------------------------------------------------------------------

extern "C" void S3DEngine_iPhone_OnTouchesChanged ( int _iS0, int _iTC0, float _fX0, float _fY0, 
                                                    int _iS1, int _iTC1, float _fX1, float _fY1, 
                                                    int _iS2, int _iTC2, float _fX2, float _fY2, 
                                                    int _iS3, int _iTC3, float _fX3, float _fY3, 
                                                    int _iS4, int _iTC4, float _fX4, float _fY4 )
{
    if ( ! bPaused ) 
    {
        S3DClient_iPhone_OnTouchesChanged ( _iS0, _iTC0, _fX0, _fY0, 
                                            _iS1, _iTC1, _fX1, _fY1, 
                                            _iS2, _iTC2, _fX2, _fY2, 
                                            _iS3, _iTC3, _fX3, _fY3, 
                                            _iS4, _iTC4, _fX4, _fY4 ) ;
    }
}

//-----------------------------------------------------------------------------
//  AdMob support
//-----------------------------------------------------------------------------

extern "C" bool S3DEngine_AdMob_WantVisible ( )
{
    return bAdMobWantVisible ;
}

//-----------------------------------------------------------------------------

extern "C" const char *S3DEngine_AdMob_GetPublisherId ( )
{
    return aAdMobPublisherId ;
}

//-----------------------------------------------------------------------------

extern "C" bool S3DEngine_AdMob_GetUseTestAd ( )
{
    return bAdMobUseTestAd ;
}

//-----------------------------------------------------------------------------

extern "C" float S3DEngine_AdMob_GetAdMobBackColorR ( ) { return fAdMobBackColorR ; } ;
extern "C" float S3DEngine_AdMob_GetAdMobBackColorG ( ) { return fAdMobBackColorG ; } ;
extern "C" float S3DEngine_AdMob_GetAdMobBackColorB ( ) { return fAdMobBackColorB ; } ;
extern "C" float S3DEngine_AdMob_GetAdMobBackColorA ( ) { return fAdMobBackColorA ; } ;
extern "C" float S3DEngine_AdMob_GetAdMobTextColorR ( ) { return fAdMobTextColorR ; } ;
extern "C" float S3DEngine_AdMob_GetAdMobTextColorG ( ) { return fAdMobTextColorG ; } ;
extern "C" float S3DEngine_AdMob_GetAdMobTextColorB ( ) { return fAdMobTextColorB ; } ;
extern "C" float S3DEngine_AdMob_GetAdMobTextColorA ( ) { return fAdMobTextColorA ; } ;

//-----------------------------------------------------------------------------
