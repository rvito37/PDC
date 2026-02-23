/*
 * ÚÄ Program ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³  Application: AVXBMS                                                     ³
 * ³    File Name: COMBOBOX.PRG                                               ³
 * ³  Description:                                                            ³
 * ³             :                                                            ³
 * ³             :                                                            ³
 * ³             :                                                            ³
 * ³       Author: Danny Hazan           Tester:                              ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:31:46pm            Time updated: ş02:31:46pm            ³
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
 
// Function/Procedure Prototype Table  -  Last Update: 24-06-96 @ 14:51:34
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// Return Value         Function/Arguments
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// Void                 PROC ComboBoxApplyKey(oGet, nKey)
// Void                 PROC ComboBoxReader( oGet )
// oGet                 FUNCTION ComboGetNew(bVar, cVar, aChoices,cColors,lReadOnly)
// NIL                  FUNCTION comboBox(oGet)
 
/***
* Combo.prg
*
* Implementation of combo box.
*
* Compile with:
*
*   Clipper Combo /m /n /w
*
* Link with Combotst for test version.
*/
 
#include "avxdefs.ch"
 
// Create Get object with reader implementing Combo box. aChoices
// has the elements to choose from.
 
/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: ComboGetNew()         Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Danny Hazan                                                ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:31:52pm            Time updated: ş02:31:52pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: bVar                                                       ³
 * ³             : cVar                                                       ³
 * ³             : aChoices                                                   ³
 * ³             : cColors                                                    ³
 * ³             : lReadOnly                                                  ³
 * ³ Return Value: oGet                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION ComboGetNew(bVar, cVar, aChoices,cColors,lReadOnly)
LOCAL nTop
LOCAL nLeft
LOCAL nBottom
LOCAL nRight
LOCAL i
LOCAL nLongest
LOCAL oGet
 
DEFAULT lReadOnly TO .F.
 
  oGet := GetNew(Row(), Col(), bVar, cVar)
  oGet:cargo := Array(COMBO_NUM_IVARS)
 
  nTop    := oGet:row + 1
  nLeft   := oGet:col + 1
  nBottom := Min(MaxRow(), nTop + Len(aChoices) + 1)
 
  IF nBottom - nTop < 2
    nTop := nBottom - 2
  ENDIF
 
  nLongest := 0
  *
  * ˜…š‰€Œ Printers.dbf •…— „˜‡ š…‘”ƒ„ Œ‹ Š˜’ aChoices Œ’ ˜’
  *    .Š‘ š‘”ƒ„ ™ …—‰ …™‰‡ Š˜…–Œ ˜š…‰ Š…˜€„ ™„ šŒ’ š‘”ƒ„
  *
  FOR i := 1 TO Len(aChoices)
      IF Len(aChoices[i]) > nLongest
         nLongest := Len(aChoices[i])
      ENDIF
  NEXT
  nRight := Min(MaxCol(), nLeft + nLongest + 1)
 
  IF (nRight - nLeft - 1) < nLongest
    nLeft := nRight - nLongest - 1
  ENDIF
 
  oGet:comboItems   := aChoices
  oGet:comboTop     := nTop
  oGet:comboLeft    := nLeft
  oGet:comboBottom  := nBottom
  oGet:comboRight   := nRight
  oGet:comboColors  := cColors
  oGet:readonly     := lReadOnly
  oGet:reader     := {|o| ComboBoxReader(o) }
 
  oGet:varPut(Pad(oGet:varGet(), nLongest))
  oGet:display()
 
  @ oGet:row, oGet:col + Len(oGet:varGet()) SAY Chr(25) COLOR "w+/n"
 
RETURN oGet
 
 
// The reader for the combo box
 
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: ComboBoxReader()                                           ³
 * ³  Description:                                                            ³
 * ³       Author: Danny Hazan           Designer:                            ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:32:00pm            Time updated: ş02:32:00pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: oGet                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
PROC ComboBoxReader( oGet )
 
LOCAL cScr := SAVESCREEN(24,0,24,79)
 
  // read the GET if the WHEN condition is satisfied
  IF ( GetPreValidate(oGet) )
    // activate the GET for reading
    oGet:SetFocus()
    @24,0 SAY PADR("[Alt-Down arrow] opens pick list, [Enter] to accept", 80 ) COLOR "w+/r"
 
    DO WHILE ( oGet:exitState == GE_NOEXIT )
      // check for initial typeout (no editable positions)
      IF ( oGet:typeOut )
        oGet:exitState := GE_ENTER
      ENDIF
 
      // apply keystrokes until exit
      DO WHILE ( oGet:exitState == GE_NOEXIT )
        ComboBoxApplyKey(oGet, InKey(0))
      ENDDO
 
      // disallow exit if the VALID condition is not satisfied
      IF ( !GetPostValidate(oGet) )
        oGet:exitState := GE_NOEXIT
      ENDIF
    ENDDO
 
    // de-activate the GET
    oGet:KillFocus()
  ENDIF
 
RESTSCREEN(24,0,24,79,cScr)
RETURN
 
 
PROC ComboBoxApplyKey(oGet, nKey)
 
  IF nKey == K_ALT_DOWN
    comboBox(oGet)
  ELSE
    IF (nKey >= 32 .AND. nKey <= 255 ) .AND. oGet:readonly  // do not allow keys input into buffer
    ELSE
       GetApplyKey(oGet, nKey)
    ENDIF
  ENDIF
 
RETURN
 
 
/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: comboBox()            Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Danny Hazan                                                ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:32:05pm            Time updated: ş02:32:05pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: oGet                                                       ³
 * ³ Return Value: NIL                                                        ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION comboBox(oGet)
 
LOCAL nTop    := oGet:comboTop, nLeft   := oGet:comboLeft
LOCAL nBottom := oGet:comboBottom, nRight  := oGet:comboRight
LOCAL cSaveScr, cChoice, nChoice
LOCAL cCurrentChoice := oGet:buffer
 
// N.B. Inexact comparison here ...
LOCAL nStartChoice := Ascan(oGet:comboItems, ;
                      {|c| Upper(c) = upper(Trim(cCurrentChoice)) } )
LOCAL nSaveRow := Row(), nSaveCol := Col()
LOCAL cSaveColor
  cSaveScr := SaveScreen(nTop, nLeft, nBottom, nRight)
 
  cSaveColor := SetColor( oGet:comboColors )
  DispBox( nTop , nLeft , nBottom , nRight , FRAME + " " , "w+/b")
 
  nChoice := Achoice(nTop + 1, nLeft + 1, nBottom - 1, nRight - 1, ;
                     oGet:comboItems, NIL, NIL, nStartChoice)
 
  RestScreen(nTop, nLeft, nBottom, nRight, cSaveScr)
  SetColor( cSaveColor )
  DevPos(nSaveRow, nSaveCol)
 
  IF nChoice > 0
    // Item was selected, update real variable
    cChoice := oGet:comboItems[nChoice]
    oGet:varPut(Pad(cChoice, Len(cCurrentChoice)))
    oGet:updateBuffer()
    oGet:changed := .T.
  ENDIF
 
RETURN NIL
 
/*************************** EOF COMBOBOX.PRG ******************************/
