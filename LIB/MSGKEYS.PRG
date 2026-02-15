// msgkeys.prg
// Function/Procedure Prototype Table  -  Last Update: 24-06-96 @ 14:57:42
// 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
// Return Value         Function/Arguments
// 컴컴컴컴컴컴컴컴컴�  컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
// cMsg                 STATIC FUNCTION GetMsg( nMsgCode )
// Void                 STATIC PROCEDURE InserSubText( aMsg , cMsg )
// lOldMode             FUNCTION SetMsgMode( lNewMode )
// cOldKeys             FUNC Keys24( cMsg ,cColor , lAdd)
// Void                 PROC Msg24( aMsg, nTime , lTone)

//  MSGKEYS.PRG
#include "common.ch"

STATIC cCurrentKeys

STATIC lMode := .T. , lLanMode := .T.

// if lMode is .T.  cMsg param contains msg num witch taken from D_MSG
// lLangMode .T. - heb msg
// lLangMode .F. - eng msg


PROC Msg24( aMsg, nTime , lTone)
LOCAL cScreen
LOCAL cMsg

DEFAULT nTime TO 0, lTone TO .F., aMsg TO ""

IF lMode
   IF ValType( aMsg ) == "A"
      cMsg:= GetMsg( Val( aMsg[1] ) )
      IF Len( aMsg ) > 1
         InserSubText( aMsg , @cMsg )
      ENDIF
   ELSE
      cMsg := aMsg
   ENDIF
ENDIF

IF nTime = 0
   cMsg := AllTrim( cMsg ) + " (Press any key...)"
ENDIF

cScreen := SaveScreen( 24 , 0 , 24 , 79 )
@ 24,0 SAY Padc(cMsg,80) COLOR "w+/r"

IF lTone
   Tone(300,1)
END

inKey(nTime)


RestScreen( 24,0,24,79, cScreen )

RETURN

FUNC Keys24( cMsg ,cColor , lAdd)
LOCAL cOldKeys := cCurrentKeys

DEFAULT cMsg TO "" , cColor TO "gr+/rb" ,lAdd TO .F.

IF !Empty(cMsg)

   IF lAdd
      cCurrentKeys += "  " + cMsg
   ELSE
      cCurrentKeys := cMsg
   END
   @ 24,0 SAY Padr(cCurrentKeys,80) COLOR  cColor
END

RETURN cOldKeys


FUNCTION SetMsgMode( lNewMode )
LOCAL lOldMode := lMode

IF lNewMode != NIL
   lMode := lNewMode
ENDIF

RETURN lOldMode


STATIC FUNCTION GetMsg( nMsgCode )
LOCAL nSelect := Select( Alias() )
LOCAL oMsg := TabBase():new( "d_msg" )
LOCAL cMsg

oMsg:setIndexList()
oMsg:xopen()
oMsg:setorder("imsgno")//vr

IF d_msg->( DbSeek( Str(nMsgCode,6) ) )
   IF lLanMode
      cMsg := d_msg->texth
   ELSE
      cMsg := d_msg->teste
   ENDIF
ELSE
      cMsg := ""
ENDIF

oMsg:close()
SELECT (nSelect )
RETURN cMsg


STATIC PROCEDURE InserSubText( aMsg , cMsg )
LOCAL i , nLen
LOCAL cI , nPos

Adel( aMsg , 1 )
Asize( aMsg , Len(aMsg)-1 )
nLen := Len( aMsg )

FOR i := 1 TO nLen
    cI := Str( i , 1 )
    IF ValType( aMsg[i] ) == "C"
       cMsg := StrTran( cMsg , "@"+cI , aMsg[i] , 1 )
    ELSE
       Alert("Sub text not character in msg24 function" )
    ENDIF
NEXT

RETURN
