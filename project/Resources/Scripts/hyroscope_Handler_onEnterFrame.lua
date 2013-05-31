--------------------------------------------------------------------------------
--  Handler.......... : onEnterFrame
--  Author........... : 
--  Description...... : 
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
function hyroscope.onEnterFrame (  )
--------------------------------------------------------------------------------
	
    local hScene = application.getCurrentUserScene ( )
    local hBox = scene.getTaggedObject ( hScene, "box" ) 
	local hCam = scene.getTaggedObject (  hScene, "cam" )    
    
    local x,y,z = object.getTranslation ( hBox, object.kGlobalSpace )
    if y > 8.5
    then
        y = 8.5
    end
    if y<3.5
    then
        y = 3.5
    end
    object.setTranslation ( hBox, x,y,z, object.kGlobalSpace )
    
    object.matchTranslation ( hCam, hBox, object.kGlobalSpace )
	
--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------
