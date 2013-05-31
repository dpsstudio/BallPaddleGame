--------------------------------------------------------------------------------
--  Handler.......... : onSensorCollisionBegin
--  Author........... : 
--  Description...... : 
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
function ball.onSensorCollisionBegin ( nSensorID, hTargetObject, nTargetSensorID )
--------------------------------------------------------------------------------
	
    local hScene = application.getCurrentUserScene ( )
    local hUser = application.getCurrentUser ( )
    local sTag = scene.getObjectTag ( hScene, hTargetObject )
    if sTag ~= "box"
    then
        return
    end
    
    local bDirUp = user.getAIVariable ( hUser, "hyroscope", "bDirUp" )
    if bDirUp
    then
        local nScoreWin = user.getAIVariable ( hUser, "hyroscope", "nScoreWin" )
        nScoreWin = nScoreWin + 1
        user.setAIVariable ( hUser, "hyroscope", "nScoreWin", nScoreWin )
        local hScore = hud.getComponent ( hUser, "scores.lblWin" )
        hud.setLabelText ( hScore, string.format ( "%d", nScoreWin ) )
    else
        local nScoreLoose = user.getAIVariable ( hUser, "hyroscope", "nScoreLoose" )
        nScoreLoose = nScoreLoose + 1
        user.setAIVariable ( hUser, "hyroscope", "nScoreLoose", nScoreLoose )
        local hScore = hud.getComponent ( hUser, "scores.lblLoose" )
        hud.setLabelText ( hScore, string.format ( "%d", nScoreLoose ) )    
    end
    

    local hBall = this.getObject ( )
    
    local nVelY = user.getAIVariable ( hUser, "hyroscope", "nVelY" )
    --dynamics.setLinearVelocity ( hBall, 0, nVelY, 0, object.kGlobalSpace )
    dynamics.addLinearImpulse ( hBall, 0, nVelY*100, 0, object.kGlobalSpace )
	
--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------
