//------------------------------------------------------------------------------
#include "ball.h"
//------------------------------------------------------------------------------
using namespace S3DX;
//------------------------------------------------------------------------------
S3DX_BEGIN_HANDLER_03( ball, onSensorCollisionBegin, nSensorID, hTargetObject, nTargetSensorID )
{
    AIVariable hScene = application.getCurrentUserScene();
    AIVariable sTag = scene.getObjectTag(hScene, hTargetObject);
    if ( sTag != "box" )
    {
        return 0;
    }
    AIVariable hBall = this->getObject();
    AIVariable hUser = application.getCurrentUser();
    AIVariable nVelY = user.getAIVariable(hUser, "hyroscope", "nVelY");
    dynamics.setLinearVelocity(hBall, 0.0f, nVelY, 0.0f, object.kGlobalSpace);
}
S3DX_END_HANDLER( )
//------------------------------------------------------------------------------
