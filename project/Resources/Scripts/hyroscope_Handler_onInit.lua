--------------------------------------------------------------------------------
--  Handler.......... : onInit
--  Author........... : 
--  Description...... : 
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
function hyroscope.onInit (  )
--------------------------------------------------------------------------------
	
	application.setCurrentUserScene ( "hyroscope" )
    local hUser = application.getCurrentUser ( )
    if this.bDbg ( )
    then
        hud.newTemplateInstance ( hUser, "hyroscope_debug", "dbg" )
    end
	
    hud.newTemplateInstance ( hUser, "scores", "scores" )
    
    local hScene = application.getCurrentUserScene ( )
    local hBall = scene.getTaggedObject ( hScene, "ball" )    
    --dynamics.setLinearVelocity ( hBall, 0, this.nVelY ( ), 0, object.kGlobalSpace )
    
    scene.setDynamicsGravity ( hScene, 0.0, -30, 0.0 )
    
    local hCam = scene.getTaggedObject (  hScene, "cam" )    
    user.setActiveCamera ( hUser, hCam )
    
--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------
