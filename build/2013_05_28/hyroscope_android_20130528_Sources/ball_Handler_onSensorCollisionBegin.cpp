//------------------------------------------------------------------------------
#include "ball.h"
//------------------------------------------------------------------------------
using namespace S3DX;
//------------------------------------------------------------------------------
S3DX_BEGIN_HANDLER_03( ball, onSensorCollisionBegin, nSensorID, hTargetObject, nTargetSensorID )
{
    AIVariable hScene = application.getCurrentUserScene();
    AIVariable hUser = application.getCurrentUser();
    AIVariable sTag = scene.getObjectTag(hScene, hTargetObject);
    if ( sTag != "box" )
    {
        return 0;
    }
    AIVariable bDirUp = user.getAIVariable(hUser, "hyroscope", "bDirUp");
    if ( bDirUp )
    {
        AIVariable nScoreWin = user.getAIVariable(hUser, "hyroscope", "nScoreWin");
        nScoreWin = nScoreWin + 1.0f;
        user.setAIVariable(hUser, "hyroscope", "nScoreWin", nScoreWin);
        AIVariable hScore = hud.getComponent(hUser, "scores.lblWin");
        hud.setLabelText(hScore, string.format("%d", nScoreWin));
    }
    else
    {
        AIVariable nScoreLoose = user.getAIVariable(hUser, "hyroscope", "nScoreLoose");
        nScoreLoose = nScoreLoose + 1.0f;
        user.setAIVariable(hUser, "hyroscope", "nScoreLoose", nScoreLoose);
        AIVariable hScore = hud.getComponent(hUser, "scores.lblLoose");
        hud.setLabelText(hScore, string.format("%d", nScoreLoose));
    }
    AIVariable hBall = this->getObject();
    AIVariable nVelY = user.getAIVariable(hUser, "hyroscope", "nVelY");
    dynamics.addLinearImpulse(hBall, 0.0f, nVelY * 100.0f, 0.0f, object.kGlobalSpace);
}
S3DX_END_HANDLER( )
//------------------------------------------------------------------------------
