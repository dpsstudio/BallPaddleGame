//------------------------------------------------------------------------------
#include "hyroscope.h"
//------------------------------------------------------------------------------
using namespace S3DX;
//------------------------------------------------------------------------------
S3DX_BEGIN_HANDLER_00( hyroscope, onInit )
{
    application.setCurrentUserScene("hyroscope");
    AIVariable hUser = application.getCurrentUser();
    if ( this->bDbg() )
    {
        hud.newTemplateInstance(hUser, "hyroscope_debug", "dbg");
    }
    AIVariable hScene = application.getCurrentUserScene();
    AIVariable hBall = scene.getTaggedObject(hScene, "ball");
    dynamics.setLinearVelocity(hBall, 0.0f, this->nVelY(), 0.0f, object.kGlobalSpace);
    AIVariable hCam = scene.getTaggedObject(hScene, "cam");
    user.setActiveCamera(hUser, hCam);
}
S3DX_END_HANDLER( )
//------------------------------------------------------------------------------
