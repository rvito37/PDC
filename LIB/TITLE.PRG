// title.prg
// Function/Procedure Prototype Table  -  Last Update: 24-06-96 @ 15:08:42
// 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
// Return Value         Function/Arguments
// 컴컴컴컴컴컴컴컴컴�  컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
// Void                 PROC BuildLines( pPad )
// cLine1               FUNC SetRepTitle( nLineLen)
// {cOldDesc , cOld...  FUNC SetTitle(pDescription , pProgName)
// Void                 PROC TitleDisplay()

// TITLE.PRG


STATIC cUserName
STATIC cDate , cTime
static cWID
STATIC cDescription
STATIC cProgName
STATIC cLine1 := "" , cLine2 := ""

FUNC SetTitle(pDescription , pProgName)
LOCAL cOldDesc := cDescription
LOCAL cOldProg := cProgName

IF cUserName == NIL
   cUserName := LogInUser()
END

IF cDate == NIL
   cDate := Dtoc( Date() )
END

IF cWid == NIL
   cWid := NetCardNo()
END

cTime        := Left( Time() , 5 )
cDescription := pDescription
cProgName    := pProgName

BuildLines(80)
TitleDisplay()

RETURN {cOldDesc , cOldProg }

FUNC SetRepTitle( nLineLen)


IF cUserName == NIL
   cUserName := LogInUser()
END

IF cDate == NIL
   cDate := Dtoc( Date() )
END


cTime        := Left( Time() , 5 )

BuildLines(nLineLen)

RETURN  cLine1


PROC TitleDisplay()
@ 0,0 SAY cLine1 COLOR "w+/rb"
@ 1,0 SAY cLine2 COLOR "w+/rb"
RETURN

PROC BuildLines( pPad )
LOCAL cPart1 := "User:"+cUserName
LOCAL cPart2 := "AVX Israel"
LOCAL cPart3 := Padr(cDate+" "+cTime,15)

LOCAL cPart4 := "WID:"+cWID
LOCAL cPart5 := AllTrim( cDescription )
LOCAL cPart6 := "Prog:"+ Padr(cProgName,10)

LOCAL nPad


IF Len( cPart1 ) > Len( cPart4 )
   cPart4 := Padr( cPart4 , Len( cPart1 ) )
ELSE
   cPart1 := Padr( cPart1 , Len( cPart4 ) )
ENDIF

IF Len( cPart3 ) > Len( cPart6 )
   cPart6 := Padr( cPart6 , Len( cPart3 ) )
ELSE
   cPart3 := Padr( cPart3 , Len( cPart6 ) )
ENDIF

nPad  := pPad - Len( cPart4 + cPart6)

cLine1 := cPart1 + Padc( cPart2 ,nPad ) + cPart3
cLine2 := cPart4 + Padc( cPart5 ,nPad ) + cPart6

RETURN
