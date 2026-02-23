/*
 * ÚÄ Program ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³  Application: AVXBMS                                                     ³
 * ³    File Name: CHECKS.PRG                                                 ³
 * ³  Description:                                                            ³
 * ³             :                                                            ³
 * ³             :                                                            ³
 * ³             :                                                            ³
 * ³       Author: Danny Hazan           Tester:                              ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:30:10pm            Time updated: ş02:30:10pm            ³
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
 
// Function/Procedure Prototype Table  -  Last Update: 24-06-96 @ 14:51:26
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// Return Value         Function/Arguments
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// Void                 PROC CheckApplyKey(oGet, nKey)
// Void                 Proc CheckReader( oGet )
// Void                 PROC DrawCheck(oGet)
// oGet                 FUNCTION CheckGetNew(bVar, cVar, cStr)
 
/***
* Checks.prg
*
* Implementation of check boxes.
*
* Compile with:
*
*   Clipper Checks /m /n /w
*
* Link with Checktst for test version.
*/
 
#include "avxdefs.ch"
 
 
/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: CheckGetNew()         Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Danny Hazan                                                ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:30:13pm            Time updated: ş02:30:13pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: bVar                                                       ³
 * ³             : cVar                                                       ³
 * ³             : cStr                                                       ³
 * ³ Return Value: oGet                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION CheckGetNew(bVar, cVar, cStr,lSupercolor)
 
LOCAL oGet
LOCAL nRow := Row(), nCol := Col()
 
DEFAULT lSupercolor TO FALSE
*
* Display [ ] before the get
*
DevPos(nRow, nCol)
IF lSupercolor
     DevOut("[ ]", if( IsColor() , "R+/B" ,"W/N") )
ELSE
     DevOut("[ ]", if( IsColor() , "GR+/B" ,"W/N") )
ENDIF
*
* ™ƒ‡ Get ˆ—‰‰…€ š‰‰
*
oGet := GetNew()
*
* Its position is 4 spaces to the right of the cursor
* (just past [ ] )
*
oGet:col   := nCol + 4
oGet:row   := nRow
*
*  Set get:name for hot keys
*
oGet:name  := cVar
oGet:cargo := Array(CHECK_NUM_IVARS)
*
* …‰˜ˆ‰˜—„ .‘Œ €š„ ‰‚…Œ ’ —…Œ ƒ…— Œ— checkGsb Method „ …€ Instance „
*                                                .Š‘„ ‚"’ š‰‹š„ „‚‰– …š…€
*
oGet:checkGsb := bVar
*
* ‰‡‹…„ …‰˜ˆ‰˜—„ ™ €…„ cStr
*
oGet:block := {|| cStr }
*
* Check box gets have their own reader, of course
*
oGet:reader := {|o| CheckReader(o) }
oGet:colorSpec := "G+/B,G+/R"
*
* …‰˜ˆ‰˜—„ ˜…š”‹ X ˜‰‰–š „€„ „‰–—…”„ ,.T. Š˜’ Œ— oGet:checkGsb €
*
DrawCheck(oGet)
 
oGet:display()
 
RETURN oGet
 
 
 
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: CheckReader()                                              ³
 * ³  Description:                                                            ³
 * ³       Author: Danny Hazan           Designer:                            ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:30:23pm            Time updated: ş02:30:23pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: oGet                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
Proc CheckReader( oGet )
 
  // read the GET if the WHEN condition is satisfied
  IF ( GetPreValidate(oGet) )
    // activate the GET for reading
    oGet:SetFocus()
 
    DO WHILE ( oGet:exitState == GE_NOEXIT )
      // check for initial typeout (no editable positions)
      IF ( oGet:typeOut )
        oGet:exitState := GE_ENTER
      ENDIF
 
      // apply keystrokes until exit
      DO WHILE ( oGet:exitState == GE_NOEXIT )
        CheckApplyKey(oGet, InKey(0))
      ENDDO
 
      // disallow exit if the VALID condition is not satisfied
      IF ( !GetPostValidate(oGet) )
        oGet:exitState := GE_NOEXIT
      ENDIF
    ENDDO
 
    // de-activate the GET
    oGet:KillFocus()
  ENDIF
 
RETURN
 
 
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: CheckApplyKey()                                            ³
 * ³  Description:                                                            ³
 * ³       Author: Danny Hazan           Designer:                            ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:30:26pm            Time updated: ş02:30:26pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: oGet                                                       ³
 * ³             : nKey                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
PROC CheckApplyKey(oGet, nKey)
 
LOCAL cKey
LOCAL bKeyBlock
LOCAL nSaveRow, nSaveCol
 
*  check for SET KEY first
IF ( (bKeyBlock := SetKey(nKey)) <> NIL )
   GetDoSetKey(bKeyBlock, oGet)
   RETURN  // NOTE
ENDIF
 
DO CASE
   CASE ( nKey == K_UP )
        oGet:exitState := GE_UP
 
   CASE ( nKey == K_SH_TAB )
        oGet:exitState := GE_UP
 
   CASE ( nKey == K_DOWN )
        oGet:exitState := GE_DOWN
 
   CASE ( nKey == K_TAB )
        oGet:exitState := GE_DOWN
 
   CASE ( nKey == K_ENTER )
        oGet:exitState := GE_ENTER
 
   CASE nKey == K_SPACE // …‰˜ˆ‰˜— ˜‡
        *  Toggle state of this check box.
        Eval(oGet:checkGsb, !Eval(oGet:checkGsb))
 
        IF ValType( oGet:postBlock ) == "B"
           Eval( oGet:postBlock , oGet )
        ENDIF
 
        oGet:changed := .T.
        *
        *  ˜‡™ …‰˜ˆ‰˜—„ ƒ‰Œ X …‰‘ ƒ‰˜… ‘
        *
        DrawCheck(oGet)
   CASE ( nKey == K_ESC )
        IF ( Set(_SET_ESCAPE) )
           oGet:undo()
           oGet:exitState := GE_ESCAPE
        ENDIF
 
   CASE (nKey == K_PGUP )
        oGet:exitState := GE_WRITE
 
   CASE (nKey == K_PGDN )
        oGet:exitState := GE_WRITE
 
   CASE ( nKey == K_CTRL_HOME )
        oGet:exitState := GE_TOP
 
        // both ^W and ^End terminate the READ (the default)
   CASE (nKey == K_CTRL_W)
        oGet:exitState := GE_WRITE
 
   CASE (nKey == K_INS)
        Set( _SET_INSERT, !Set(_SET_INSERT) )
 
ENDCASE
 
RETURN
 
 
 
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: DrawCheck()                                                ³
 * ³  Description:                                                            ³
 * ³       Author: Danny Hazan           Designer:                            ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:30:33pm            Time updated: ş02:30:33pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: oGet                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
PROC DrawCheck(oGet)
 
LOCAL lSelected
LOCAL oGet1
LOCAL nSaveRow := Row()
LOCAL nSaveCol := Col()
LOCAL nGet
 
IF ValType(oGet:cargo) == "A" .AND. Len(oGet:cargo) = 1
   lSelected := Eval(oGet:checkGsb)
ELSE
   RETURN
ENDIF
 
DEVPOS(oGet:row, oGet:col - 3)
IF lSelected
  DevOut(CHECK_BOX , if( IsColor() , "g+/b", "n/w"))
ELSE
  DevOut(" " ,  if( IsColor() , "gr+/b", "w/n"))
ENDIF
 
DEVPOS(nSaveRow, nSaveCol)
 
RETURN
 
/*************************** EOF CHECKS.PRG ********************************/
