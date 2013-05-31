//------------------------------------------------------------------------------
#ifndef __ball_h__
#define __ball_h__
//------------------------------------------------------------------------------
#include "S3DX/S3DXAIModel.h"
#include "hyroscope_Plugins.h"
//------------------------------------------------------------------------------
S3DX_DECLARE_AIMODEL( ball )
{
public:
    
    // Handlers:
    // 
    S3DX_DECLARE_HANDLER( onEnterFrame );
    S3DX_DECLARE_HANDLER( onSensorCollisionBegin );
    
    // States:
    // 
    
    // Functions:
    // 
    
    // Variables:
    // 
    S3DX_DECLARE_VARIABLE( nSoundVolume );
    S3DX_DECLARE_VARIABLE( nAverageSpeed );
    S3DX_DECLARE_VARIABLE( nTimeStopSound );

};
//------------------------------------------------------------------------------
#endif // __ball_h__
//------------------------------------------------------------------------------
