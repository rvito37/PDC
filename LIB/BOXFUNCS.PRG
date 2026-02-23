/*
 * ÚÄ Program ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³  Application: AVXBMS                                                     ³
 * ³    File Name: BOXFUNCS.PRG                                               ³
 * ³  Description:                                                            ³
 * ³             :                                                            ³
 * ³             :                                                            ³
 * ³             :                                                            ³
 * ³       Author: Danny Hazan           Tester:                              ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:23:34pm            Time updated: ş02:23:34pm            ³
 * ³    Make File: AVXBMS.RMK                                                 ³
 * ³    Exec File: AVXBMS.EXE            Docs By:                             ³
 * ³    DBFs/NTXs:                                                            ³
 * ³             :                                                            ³
 * ³             :                                                            ³
 * ³             :                                                            ³
 * ³             :                                                            ³
 * ³             :                                                            ³
 * ³    Copyright: (c) 1996 by AVX                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */

// Function/Procedure Prototype Table  -  Last Update: 24-06-96 @ 14:50:35
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// Return Value         Function/Arguments
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// xDefaultVal          FUNCTION InPutBox( cCaption , xDefaultVal , cPicture , cTitle )

#include "avxdefs.ch"


/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: InPutBox()            Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Danny Hazan                                                ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:23:41pm            Time updated: ş02:23:41pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: cCaption                                                   ³
 * ³             : xDefaultVal                                                ³
 * ³             : cPicture                                                   ³
 * ³             : cTitle                                                     ³
 * ³ Return Value: xDefaultVal                                                ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION InPutBox( cCaption , xDefaultVal , cPicture , cTitle )
LOCAL nT := 10 , nL , nB := 14 , nR
LOCAL nWidth , nLen
LOCAL cType := ValType( xDefaultVal )
LOCAL oForm
LOCAL GetList := {}
LOCAL bInsSave , nCursSave
LOCAL lHeb := .F.

IF Upper(cPicture) == "H"
   lHeb := .T.
   cPicture := NIL
ENDIF

DO CASE
   CASE cType == "C"
        nLen := Len( xDefaultVal )
   CASE cType == "N"
        nLen := Len( cPicture )
   CASE cType == "D"
        nLen := 8
ENDCASE

nWidth := Len( cCaption ) + nLen + 1

nL := Int( 40 - ( nWidth / 2) - 2 )
nR := nL + nWidth + 2

oForm := Form():new( nT , nL , nB , nR ,, "w+/bg" )

oForm:say( 2 , 2 , cCaption ,, "N/BG" )

IF cTitle != NIL
   oForm:say( 0, 2 , cTitle ,, "W+/G" )
ENDIF

@ oForm:nTop + 2 , oForm:nLeft + Len( cCaption ) + 2 GET xDefaultVal ;
                   PICTURE  cPicture  ;
                   COLOR    "w+/r,w+/r"

IF lHeb
   Atail( GetList ):reader := {|oGet| HebReader( oGet ) }
ENDIF

XREAD

oForm:hide()
RETURN xDefaultVal

/*************************** EOF BOXFUNCS.PRG ******************************/
