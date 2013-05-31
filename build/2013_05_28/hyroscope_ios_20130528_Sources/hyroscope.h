//------------------------------------------------------------------------------
#ifndef __hyroscope_h__
#define __hyroscope_h__
//------------------------------------------------------------------------------
#include "S3DX/S3DXAIModel.h"
#include "hyroscope_Plugins.h"
//------------------------------------------------------------------------------
S3DX_DECLARE_AIMODEL( hyroscope )
{
public:
    
    // Handlers:
    // 
    S3DX_DECLARE_HANDLER( onInit );
    S3DX_DECLARE_HANDLER( onEnterFrame );
    S3DX_DECLARE_HANDLER( onJoypadMove );
    S3DX_DECLARE_HANDLER( onKeyboardKeyDown );
    
    // States:
    // 
    
    // Functions:
    // 
    
    // Variables:
    // 
    S3DX_DECLARE_VARIABLE( bDbg );
    S3DX_DECLARE_VARIABLE( nVelY );
    S3DX_DECLARE_VARIABLE( bDirUp );
    S3DX_DECLARE_VARIABLE( nLastRx );
    S3DX_DECLARE_VARIABLE( nLastRy );
    S3DX_DECLARE_VARIABLE( nLastRz );
    S3DX_DECLARE_VARIABLE( tblAxisY );
    S3DX_DECLARE_VARIABLE( bDirCount );
    S3DX_DECLARE_VARIABLE( nScoreWin );
    S3DX_DECLARE_VARIABLE( nScoreLoose );
    S3DX_DECLARE_VARIABLE( tblDYPositions );
    S3DX_DECLARE_VARIABLE( bFirstAccelerate );
    S3DX_DECLARE_VARIABLE( nAxisYFirstValue );

};
//------------------------------------------------------------------------------
#endif // __hyroscope_h__
//------------------------------------------------------------------------------
