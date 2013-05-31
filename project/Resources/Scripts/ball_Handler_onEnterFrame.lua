--------------------------------------------------------------------------------
--  Handler.......... : onEnterFrame
--  Author........... : 
--  Description...... : 
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
function ball.onEnterFrame (  )
--------------------------------------------------------------------------------
	
    
	local o = this.getObject ( )
    
    local avgSpeed = 0.5 * ( this.nAverageSpeed ( ) + dynamics.getLinearSpeed ( o ) )
    this.nAverageSpeed ( avgSpeed )

    local x, y, z = dynamics.getLinearVelocity ( o, object.kGlobalSpace )
	if ( dynamics.getLastCollisionTime ( o ) < 0.1 and y > 0.01 )
    then
        sound.stop ( o, 0 )
        sound.play ( o, 0, this.nSoundVolume ( ), false, 0.5 )
        --this.nSoundVolume ( this.nSoundVolume ( ) * 0.96 )
        --this.nTimeStopSound ( application.getTotalFrameTime ( ) + avgSpeed / 3 )
        --sound.setPitch ( o, 0 , 1 - this.nSoundVolume ( ) / 50 )
    end
    if ( application.getTotalFrameTime ( ) > this.nTimeStopSound ( ) )
    then
        sound.stop ( o, 0 )
        this.nTimeStopSound ( application.getTotalFrameTime ( ) + 1000 )
    end
    
    local xo,yo,zo = object.getTranslation ( o, object.kGlobalSpace )
    if yo < 0
    then
        yo = 15
    end
    object.setTranslation ( o, 0.0, yo, 0.0, object.kGlobalSpace )
	
--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------
