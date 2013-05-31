//------------------------------------------------------------------------------
#include "ball.h"
//------------------------------------------------------------------------------
// Common AIModel implementation
//
S3DX_IMPLEMENT_AIMODEL( ball )

//------------------------------------------------------------------------------
// States mapping
//
S3DX_BEGIN_STATE_MAP( ball )
S3DX_END_STATE_MAP( ball )

//------------------------------------------------------------------------------
// Event handlers mapping
//
S3DX_BEGIN_HANDLER_MAP( ball )
    S3DX_HANDLER( ball, onEnterFrame )
    S3DX_HANDLER( ball, onSensorCollisionBegin )
S3DX_END_HANDLER_MAP( ball )

//------------------------------------------------------------------------------
// Variables mapping
//
S3DX_BEGIN_VARIABLE_MAP( ball )
    S3DX_VARIABLE( ball, nSoundVolume, S3DX_VARIABLE_TYPE_NUMBER )
    S3DX_VARIABLE( ball, nAverageSpeed, S3DX_VARIABLE_TYPE_NUMBER )
    S3DX_VARIABLE( ball, nTimeStopSound, S3DX_VARIABLE_TYPE_NUMBER )
S3DX_END_VARIABLE_MAP( ball )

//------------------------------------------------------------------------------
