--------------------------------------------------------------------------------
--  Handler.......... : onJoypadMove
--  Author........... : 
--  Description...... : 
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
function hyroscope.onJoypadMove ( nJoypad, nPart, nAxisX, nAxisY, nAxisZ )
--------------------------------------------------------------------------------
	
    if this.bFirstAccelerate ( )
    then
        this.nAxisYFirstValue ( nAxisY )
        this.bFirstAccelerate ( false )
        
        this.nLastRx ( nAxisX )
        this.nLastRy ( nAxisY )
        this.nLastRz ( nAxisZ )
        return
    end
    
    local hUser = application.getCurrentUser ( )
    local hScene = application.getCurrentUserScene ( )
    local hBox = scene.getTaggedObject ( hScene, "box" )    
    

    while table.getSize ( this.tblAxisY ( ) ) > 50
    do
        table.removeFirst ( this.tblAxisY ( ) )
        table.removeFirst ( this.tblDYPositions ( ) )
    end
    
    if table.getSize ( this.tblAxisY ( ) ) > 0
    then
        local nDy = nAxisY - table.getLast ( this.tblAxisY ( ) )
        table.add ( this.tblDYPositions ( ), nDy )
    else
        local nDy = nAxisY - this.nAxisYFirstValue ( )
        table.add ( this.tblDYPositions ( ), nDy )
    end
    table.add ( this.tblAxisY ( ), nAxisY )
    
    local nPartSum = 0
    local nCount = table.getSize ( this.tblDYPositions ( ) )
    if  nCount > 5
    then
        for y = nCount-5, nCount
        do
            nPartSum = nPartSum + table.getAt ( this.tblDYPositions ( ), y)
        end
    end
    
    if this.bDbg ( )
    then
        local hLblX = hud.getComponent ( hUser, "dbg.lblX" )
        hud.setLabelText ( hLblX, string.format ( "%f",  nAxisX ) )
        
        local hLblY = hud.getComponent ( hUser, "dbg.lblY" )
        hud.setLabelText ( hLblY, string.format ( "%f",  nAxisY ) )

        local hLblZ = hud.getComponent ( hUser, "dbg.lblZ" )
        hud.setLabelText ( hLblZ, string.format ( "%f",  nAxisZ ) )    
        
        local hLblPartSum = hud.getComponent ( hUser, "dbg.lblPartSum" )
        hud.setLabelText ( hLblPartSum, string.format ( "%f",  nPartSum ) )
    end

    local nx, ny, nz = object.getTranslation ( hBox, object.kGlobalSpace )
    ny = ny - nPartSum * 2.0
    object.setTranslation ( hBox, nx, ny, nz, object.kGlobalSpace )
    this.bDirUp ( nPartSum < 0.0 )
    
    local hCam = scene.getTaggedObject ( hScene, "cam" ) 
    local rx, ry, rz = object.getRotation ( hCam, object.kLocalSpace )
    rx = rx + (nAxisX - this.nLastRx ( ))
    ry = ry + (nAxisY - this.nLastRy ( ))
    rz = rz + (nAxisZ - this.nLastRz ( ))
    object.setRotation ( hCam, 0.0, -ry, 0.0, object.kLocalSpace )
    
    this.nLastRx ( nAxisX )
    this.nLastRy ( nAxisY )
    this.nLastRz ( nAxisZ )    

--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------
