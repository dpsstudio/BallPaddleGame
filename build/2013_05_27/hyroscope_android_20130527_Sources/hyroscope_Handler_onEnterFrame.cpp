//------------------------------------------------------------------------------
#include "hyroscope.h"
//------------------------------------------------------------------------------
using namespace S3DX;
//------------------------------------------------------------------------------
S3DX_BEGIN_HANDLER_00( hyroscope, onEnterFrame )
{
    AIVariable hScene = application.getCurrentUserScene();
    AIVariable hBox = scene.getTaggedObject(hScene, "box");
    AIVariable hCam = scene.getTaggedObject(hScene, "cam");
    AIVariables<3> __v0 = object.getTranslation(hBox, object.kGlobalSpace);
    AIVariable x = __v0[0]; 
    AIVariable y = __v0[1]; 
    AIVariable z = __v0[2]; 
    if ( y > 8.5f )
    {
        y = 8.5f;
    }
    if ( y < 3.5f )
    {
        y = 3.5f;
    }
    object.setTranslation(hBox, x, y, z, object.kGlobalSpace);
    object.matchTranslation(hCam, hBox, object.kGlobalSpace);
}
S3DX_END_HANDLER( )
//------------------------------------------------------------------------------
