//------------------------------------------------------------------------------
#include "ball.h"
//------------------------------------------------------------------------------
using namespace S3DX;
//------------------------------------------------------------------------------
S3DX_BEGIN_HANDLER_00( ball, onEnterFrame )
{
    AIVariable o = this->getObject();
    AIVariable avgSpeed = 0.5f * (this->nAverageSpeed() + dynamics.getLinearSpeed(o));
    this->nAverageSpeed(avgSpeed);
    AIVariables<3> __v0 = dynamics.getLinearVelocity(o, object.kGlobalSpace);
    AIVariable x = __v0[0]; 
    AIVariable y = __v0[1]; 
    AIVariable z = __v0[2]; 
    if ( (S3DX_DEFAULT_AND(dynamics.getLastCollisionTime(o) < 0.1f, y > 0.01f)) )
    {
        sound.stop(o, 0.0f);
        sound.play(o, 0.0f, this->nSoundVolume(), false, 0.5f);
    }
    if ( (application.getTotalFrameTime() > this->nTimeStopSound()) )
    {
        sound.stop(o, 0.0f);
        this->nTimeStopSound(application.getTotalFrameTime() + 1000.0f);
    }
    AIVariables<3> __v1 = object.getTranslation(o, object.kGlobalSpace);
    AIVariable xo = __v1[0]; 
    AIVariable yo = __v1[1]; 
    AIVariable zo = __v1[2]; 
    if ( yo < 0.0f )
    {
        yo = 15.0f;
    }
    object.setTranslation(o, 0.0f, yo, 0.0f, object.kGlobalSpace);
}
S3DX_END_HANDLER( )
//------------------------------------------------------------------------------
