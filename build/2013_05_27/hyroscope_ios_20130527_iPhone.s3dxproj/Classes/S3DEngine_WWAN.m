//-----------------------------------------------------------------------------
#include <CoreFoundation/CoreFoundation.h>
#include <CFNetwork/CFNetwork.h>
//-----------------------------------------------------------------------------
static BOOL bResultGiven  = YES ;
static BOOL bQueryPending = NO  ;
static BOOL bWWANIsUp     = NO  ;
//-----------------------------------------------------------------------------
static CFHostRef           m_HostRef   = NULL ;
static CFReadStreamRef     m_ReadRef   = NULL ;
static CFWriteStreamRef    m_WriteRef  = NULL ;
static CFRunLoopRef        m_RunLoop   = NULL ;
//-----------------------------------------------------------------------------

static void WakeUpWWAN_WriteStreamCallback ( CFWriteStreamRef _streamRef, CFStreamEventType _eventType, void *_clientCallBackInfo )
{
    if ( _eventType == kCFStreamEventOpenCompleted )
    {
        // at this point, the connection is up.  It's possible this is wifi, or EDGE/3G
        // and BSD socket functions will work.
        //
        bQueryPending   = NO  ;
        bWWANIsUp       = YES ;

        NSLog ( @"WakeUpWWAN_WriteStreamCallback : succeeded" ) ;
    }
    else
    {
        bQueryPending   = NO ;
        bWWANIsUp       = NO ;
        
        NSLog ( @"WakeUpWWAN_WriteStreamCallback : failed" ) ;
    }
    
    // You should remove this from the runloop as well, unless you want to continue receiving
    // connection notifications asyncrhonously
    // [[NSRunLoop currentRunLoop] getCFRunLoop]
    if ( m_RunLoop )
    {
        if ( m_WriteRef )
        {
            CFWriteStreamUnscheduleFromRunLoop  ( m_WriteRef, m_RunLoop, (CFStringRef)NSDefaultRunLoopMode ) ;
            CFWriteStreamClose                  ( m_WriteRef ) ;
            CFRelease                           ( m_WriteRef ) ;
            m_WriteRef                          = NULL ;
        }
        if ( m_ReadRef )
        {
            CFRelease                           ( m_ReadRef  ) ;
            m_ReadRef                           = NULL ;
        }
        if ( m_HostRef )
        {
            CFRelease                           ( m_HostRef  ) ;
            m_HostRef                           = NULL ;
        }
    }
}

//-----------------------------------------------------------------------------

static BOOL WakeUpWWAN ( )
{
    // The only way to force the EDGE network to come up, is to create a connection to some
    // address using CFStream* interface. This code, tries to create a connection to
    // stonetrip.com. Once that connection is established, then we can start the SOCKS proxy.
    //
    m_HostRef   = CFHostCreateWithName ( nil, (CFStringRef)@"www.stonetrip.com" ) ;
    
    if ( m_HostRef )
    {
        CFStreamCreatePairWithSocketToCFHost ( nil, m_HostRef, 80, &m_ReadRef, &m_WriteRef ) ;
        
        CFStreamClientContext context ;
        memset(&context, 0, sizeof(context));
        context.version = 0;
        context.info = nil; // self
        
        if ( CFWriteStreamSetClient ( m_WriteRef, kCFStreamEventOpenCompleted | kCFStreamEventErrorOccurred | kCFStreamEventEndEncountered, WakeUpWWAN_WriteStreamCallback, &context ) )
        {
            // put the write ref on the runloop
            //
            //CFRunLoopRef runLoop = [[NSRunLoop currentRunLoop] getCFRunLoop] ;
            
            if ( m_RunLoop )
            {
                CFWriteStreamScheduleWithRunLoop ( m_WriteRef, m_RunLoop, (CFStringRef)NSDefaultRunLoopMode ) ;
                
                if ( CFWriteStreamOpen ( m_WriteRef ) )
                {
                    // You app should wait for the callback above to be called, and then continue on.
                    // at this point, the the SDK will try to open the socket asynchronously, and when it does, your callback function will be called.
                    //
                    return YES ;
                }
            }
        }
    }
    
    return NO ;
}

//-----------------------------------------------------------------------------

void ObjectiveC_InitWakeUpWWAN ( )
{
    m_RunLoop = [[NSRunLoop currentRunLoop] getCFRunLoop] ;
}

//-----------------------------------------------------------------------------

bool ObjectiveC_WakeUpWWAN ( )
{
    if ( bQueryPending )
    {
        // We do not have the result yet, return true
        //
    }
    else if ( ! bResultGiven )
    {
        // We get a result from the OS, return it and reset our booleans.
        //
        bResultGiven    = YES ;
        bQueryPending   = NO  ;
           
        return bWWANIsUp ;
    }
    else
    {
        bQueryPending   = YES ;
        bResultGiven    = NO  ;
        bWWANIsUp       = NO  ;
        
        if ( WakeUpWWAN ( ) )
        {
            NSLog ( @"WakeUpWWAN : query started" ) ;
        }
        else 
        {
            // Reset to defaults
            //
            bQueryPending   = NO ;
            bResultGiven    = YES ;
            bWWANIsUp       = NO ;

            return false ; // Error occured.
        }
    }
    return true ; // Query sent, waiting for result.
}