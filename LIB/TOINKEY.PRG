// toinkey.prg
// Function/Procedure Prototype Table  -  Last Update: 24-06-96 @ 15:08:44
// 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
// Return Value         Function/Arguments
// 컴컴컴컴컴컴컴컴컴�  컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
// nKey                 FUNCTION TimeOutInKey( nTimeOut )

// G:\BMS\SOURCE\TOINKEY.PRG
#include "avxdefs.ch"


FUNCTION TimeOutInKey( nTimeOut )
LOCAL nTimeCounter := 0
LOCAL nKey
LOCAL nRow := Row() , nCol := Col()




DEFAULT nTimeOut TO 6000000

while TRUE
  WHILE Empty( nKey := InKey() )
     @ 0,74 SAY Left( Time() , 5 ) COLOR "W+/RB"
     DevPos( nRow , nCol )
     IF !Empty( nTimeOut ) .AND. ++nTimeCounter > nTimeOut
        KEYBOARD Chr( K_ESC )
        nKey := K_ESC
        EXIT
     ENDIF
  ENDDO
  IF nkey==370
     save_scr()
  else
     exit
  ENDIF
enddo
RETURN nKey

//---------------------
static func save_scr
local u_scr:=savescreen(0,0,24,79),sym:=''
local i,j,k:=1
FOR i:=1 TO 25
     FOR j:=1 TO 80
          sym+=substr(u_scr,k,1)
          k+=2
     NEXT
     sym+=chr(13)+chr(10)
NEXT
memowrit('im_scr.txt',sym)
return NIL