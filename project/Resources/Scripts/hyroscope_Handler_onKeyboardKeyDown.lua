--------------------------------------------------------------------------------
--  Handler.......... : onKeyboardKeyDown
--  Author........... : 
--  Description...... : 
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
function hyroscope.onKeyboardKeyDown ( kKeyCode )
--------------------------------------------------------------------------------
	
    local hUser = application.getCurrentUser ( )
    local hScene = application.getCurrentUserScene ( )
    local hBox = scene.getTaggedObject ( hScene, "box" )    
    
    local nPartSum = 0
    local nx, ny, nz = object.getTranslation ( hBox, object.kGlobalSpace )
    
    
    if kKeyCode == input.kKeyUp
    then
        nPartSum = 0.5
    elseif kKeyCode == input.kKeyDown
    then
        nPartSum = -0.5
    end
    
    ny = ny - nPartSum
    object.setTranslation ( hBox, nx, ny, nz, object.kGlobalSpace )
	
--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------
