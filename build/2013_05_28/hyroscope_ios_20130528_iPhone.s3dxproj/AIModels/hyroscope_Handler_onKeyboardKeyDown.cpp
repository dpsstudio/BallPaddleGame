//------------------------------------------------------------------------------
#include "hyroscope.h"
//------------------------------------------------------------------------------
using namespace S3DX;
//------------------------------------------------------------------------------
S3DX_BEGIN_HANDLER_01( hyroscope, onKeyboardKeyDown, kKeyCode )
{
    AIVariable hUser = application.getCurrentUser();
    AIVariable hScene = application.getCurrentUserScene();
    AIVariable hBox = scene.getTaggedObject(hScene, "box");
    AIVariable nPartSum = 0.0f;
    AIVariables<3> __v0 = object.getTranslation(hBox, object.kGlobalSpace);
    AIVariable nx = __v0[0]; 
    AIVariable ny = __v0[1]; 
    AIVariable nz = __v0[2]; 
    if ( kKeyCode == input.kKeyUp )
    {
        nPartSum = 0.5f;
    }
    else if ( kKeyCode == input.kKeyDown )
    {
        nPartSum = - 0.5f;
    }
    ny = ny - nPartSum;
    object.setTranslation(hBox, nx, ny, nz, object.kGlobalSpace);
}
S3DX_END_HANDLER( )
//------------------------------------------------------------------------------
