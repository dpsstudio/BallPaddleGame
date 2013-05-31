//------------------------------------------------------------------------------
#include "hyroscope.h"
//------------------------------------------------------------------------------
// Common AIModel implementation
//
S3DX_IMPLEMENT_AIMODEL( hyroscope )

//------------------------------------------------------------------------------
// States mapping
//
S3DX_BEGIN_STATE_MAP( hyroscope )
S3DX_END_STATE_MAP( hyroscope )

//------------------------------------------------------------------------------
// Event handlers mapping
//
S3DX_BEGIN_HANDLER_MAP( hyroscope )
    S3DX_HANDLER( hyroscope, onInit )
    S3DX_HANDLER( hyroscope, onEnterFrame )
    S3DX_HANDLER( hyroscope, onJoypadMove )
    S3DX_HANDLER( hyroscope, onKeyboardKeyDown )
S3DX_END_HANDLER_MAP( hyroscope )

//------------------------------------------------------------------------------
// Variables mapping
//
S3DX_BEGIN_VARIABLE_MAP( hyroscope )
    S3DX_VARIABLE( hyroscope, bDbg, S3DX_VARIABLE_TYPE_BOOLEAN )
    S3DX_VARIABLE( hyroscope, nVelY, S3DX_VARIABLE_TYPE_NUMBER )
    S3DX_VARIABLE( hyroscope, bDirUp, S3DX_VARIABLE_TYPE_BOOLEAN )
    S3DX_VARIABLE( hyroscope, nLastRx, S3DX_VARIABLE_TYPE_NUMBER )
    S3DX_VARIABLE( hyroscope, nLastRy, S3DX_VARIABLE_TYPE_NUMBER )
    S3DX_VARIABLE( hyroscope, nLastRz, S3DX_VARIABLE_TYPE_NUMBER )
    S3DX_VARIABLE( hyroscope, tblAxisY, S3DX_VARIABLE_TYPE_TABLE )
    S3DX_VARIABLE( hyroscope, bDirCount, S3DX_VARIABLE_TYPE_NUMBER )
    S3DX_VARIABLE( hyroscope, nScoreWin, S3DX_VARIABLE_TYPE_NUMBER )
    S3DX_VARIABLE( hyroscope, nScoreLoose, S3DX_VARIABLE_TYPE_NUMBER )
    S3DX_VARIABLE( hyroscope, tblDYPositions, S3DX_VARIABLE_TYPE_TABLE )
    S3DX_VARIABLE( hyroscope, bFirstAccelerate, S3DX_VARIABLE_TYPE_BOOLEAN )
    S3DX_VARIABLE( hyroscope, nAxisYFirstValue, S3DX_VARIABLE_TYPE_NUMBER )
S3DX_END_VARIABLE_MAP( hyroscope )

//------------------------------------------------------------------------------
