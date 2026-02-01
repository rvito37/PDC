#define COMPILE(c) &("{||" + c + "}")
*FUNCS.PRG
*
* AvxFuncs å ÖëêãÖÑ Äåô öÖòâô öÖâñóêÖî öâêãö
*
#include "Setcurs.ch"
#include "Inkey.ch"
#include "Set.ch"
#include "Common.ch"
#include "Fileio.ch"
#define NET_SECS     2     // Number of seconds to continue retry
#define NET_WAIT     0.5   // Seconds to wait between retries
*
FUNCTION YosUse( cDatabase, lOpenMode ,lNew ,cDriver, nSeconds)
 
LOCAL lForever    // Retry forever?
 
DEFAULT nSeconds TO NET_SECS
lForever := ( nSeconds == 0 )
 
// Keep trying as long as our time's not up
WHILE ( lForever .OR. ( nSeconds > 0 ) )
      *
      * .F.  Shared ÖÄ .T. Exclusive áöîâ ïÅÖóÑ çÄ íÅÖó lOpenMode
      *
      IF lOpenMode
          *USE ( cDatabase ) EXCLUSIVE IIF(lNew,.T.,.F.)
          IF SELECT(cDatabase)==0
             DBUSEAREA(IIF(lNew,.T.,.T.),cDriver, cDatabase,,.F.) // The last .F. is for EXCLUSIVE
          ENDIF
      ELSE
          *USE ( cDatabase ) SHARED IIF(lNew,.T.,.F.)
          IF SELECT(cDatabase)==0
             DBUSEAREA(IIF(lNew,.T.,.F.),cDriver, cDatabase,,.T.) // The last .T. is forSHARED
          ENDIF
      ENDIF
 
      IF !NETERR()
         RETURN ( .T. )     // NOTE
      ENDIF
 
      INKEY( NET_WAIT )     // Wait
      nSeconds -= NET_WAIT
 
ENDDO
RETURN ( .F. )          // USE fails
*
