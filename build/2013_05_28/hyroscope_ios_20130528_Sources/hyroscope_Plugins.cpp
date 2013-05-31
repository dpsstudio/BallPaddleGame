//------------------------------------------------------------------------------
#include "hyroscope_Plugins.h"
//------------------------------------------------------------------------------




extern "C" bool S3DX::RegisterDynamicallyLinkedPlugin ( S3DX::Plugin *_pPlugin )
{
    for ( uint32 iPackage = 0; iPackage <  _pPlugin->GetAIPackageCount ( ) ; iPackage++ )
    {
        const S3DX::AIPackage *pPackage = _pPlugin->GetAIPackageAt ( iPackage ) ;
        if ( pPackage )
        {
        }
    }
    return true;
}
