//------------------------------------------------------------------------------
#include "hyroscope.h"
//------------------------------------------------------------------------------
using namespace S3DX;
//------------------------------------------------------------------------------
S3DX_BEGIN_HANDLER_05( hyroscope, onJoypadMove, nJoypad, nPart, nAxisX, nAxisY, nAxisZ )
{
    if ( this->bFirstAccelerate() )
    {
        this->nAxisYFirstValue(nAxisY);
        this->bFirstAccelerate(false);
        this->nLastRx(nAxisX);
        this->nLastRy(nAxisY);
        this->nLastRz(nAxisZ);
        return 0;
    }
    AIVariable hUser = application.getCurrentUser();
    AIVariable hScene = application.getCurrentUserScene();
    AIVariable hBox = scene.getTaggedObject(hScene, "box");
    while ( table.getSize(this->tblAxisY()) > 50.0f )
    {
        table.removeFirst(this->tblAxisY());
        table.removeFirst(this->tblDYPositions());
    }
    if ( table.getSize(this->tblAxisY()) > 0.0f )
    {
        AIVariable nDy = nAxisY - table.getLast(this->tblAxisY());
        table.add(this->tblDYPositions(), nDy);
    }
    else
    {
        AIVariable nDy = nAxisY - this->nAxisYFirstValue();
        table.add(this->tblDYPositions(), nDy);
    }
    table.add(this->tblAxisY(), nAxisY);
    AIVariable nPartSum = 0.0f;
    AIVariable nCount = table.getSize(this->tblDYPositions());
    if ( nCount > 5.0f )
    {
        S3DX_LUA_FOR( y, nCount - 5.0f, nCount )
        {
            nPartSum = nPartSum + table.getAt(this->tblDYPositions(), y);
        }
    }
    if ( this->bDbg() )
    {
        AIVariable hLblX = hud.getComponent(hUser, "dbg.lblX");
        hud.setLabelText(hLblX, string.format("%f", nAxisX));
        AIVariable hLblY = hud.getComponent(hUser, "dbg.lblY");
        hud.setLabelText(hLblY, string.format("%f", nAxisY));
        AIVariable hLblZ = hud.getComponent(hUser, "dbg.lblZ");
        hud.setLabelText(hLblZ, string.format("%f", nAxisZ));
        AIVariable hLblPartSum = hud.getComponent(hUser, "dbg.lblPartSum");
        hud.setLabelText(hLblPartSum, string.format("%f", nPartSum));
    }
    AIVariables<3> __v0 = object.getTranslation(hBox, object.kGlobalSpace);
    AIVariable nx = __v0[0]; 
    AIVariable ny = __v0[1]; 
    AIVariable nz = __v0[2]; 
    ny = ny - nPartSum * 2.0f;
    object.setTranslation(hBox, nx, ny, nz, object.kGlobalSpace);
    AIVariable hCam = scene.getTaggedObject(hScene, "cam");
    AIVariables<3> __v1 = object.getRotation(hCam, object.kLocalSpace);
    AIVariable rx = __v1[0]; 
    AIVariable ry = __v1[1]; 
    AIVariable rz = __v1[2]; 
    rx = rx + (nAxisX - this->nLastRx());
    ry = ry + (nAxisY - this->nLastRy());
    rz = rz + (nAxisZ - this->nLastRz());
    object.setRotation(hCam, - rx, - ry, - rz, object.kLocalSpace);
    this->nLastRx(nAxisX);
    this->nLastRy(nAxisY);
    this->nLastRz(nAxisZ);
}
S3DX_END_HANDLER( )
//------------------------------------------------------------------------------
