// radios.prg
// Function/Procedure Prototype Table  -  Last Update: 24-06-96 @ 15:00:55
// 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
// Return Value         Function/Arguments
// 컴컴컴컴컴컴컴컴컴�  컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
// Void                 PROC DrawRadios(aGetList, oGet)
// oGet                 FUNCTION RadioGets(bVar, cVar, aChoices, aGetList , aBlocks )
// {|x| c }             FUNCTION t(c)
// Void                 PROC RadioApplyKey(oGet, nKey, aGetList)
// Void                 Proc RadioReader( oGet, aGetList )

/***
* Radios.prg
*
* Implementation of radio buttons.
*
* Compile with:
*
*  /m /n /w
*
* Link with Radiotst for test version.
*/

#include "avxdefs.ch"
/*
#include "Getexit.ch"
#include "InKey.ch"
#include "Radios.ch"
#include "Radiodef.ch"
*/

// Issue radio button gets for array of character strings contained in
// aChoices. bVar is a get/set block for the get variable, cVar is the
// variable name.
FUNCTION RadioGets(bVar, cVar, aChoices, aGetList , aBlocks )

LOCAL oGet
LOCAL nRow := Row(), nCol := Col()
LOCAL nGets := Len(aChoices)
LOCAL nGet
LOCAL nStartGet := Len(aGetList) + 1

  // For each element in aChoices
  FOR nGet := 1 To nGets

    // Display ( ) before the get
    DevPos(nRow, nCol)
    DevOut("( ) ", if( IsColor() , "GR+/B" ,"W/N") )

    // Create an empty get object and add it to the list
    oGet := GetNew()
    Aadd(aGetList, oGet)

    // Its position is 4 spaces to the right of the cursor
    // (just past ( ) )
    oGet:col   := nCol + 4

    // We increment the row number so the next radio button
    // appears on the line below
    oGet:row   := nRow++

    // Set get:name for hot keys
    oGet:name  := cVar

    // Here's where it gets a bit tricky. The get object's get/set
    // block must just return the character string describing the
    // radio button ("Amex", e.g. ). We cannot, however, set it as:
    //    {|| aChoices[nGet] }
    // as this code block is reevaluated at READ time when nGet is
    // invalid. We solve the problem with a detached local.
    oGet:block := t(aChoices[nGet])

    // Cargo is an array of two elements. The first element contains
    // the get/set block for the real variable, the second element
    // is an array of offsets inside getlist of the other gets that
    // comprise the radio buttons
    oGet:cargo := Array(RADIO_NUM_IVARS)

    oGet:radioGsb  := bVar
    oGet:radioGets := Array(nGets)

    // Fill :radioGets with element numbers of other gets in radio
    // button list. nStartGet is the element number of the first one.
    Aeval(oGet:radioGets, {|x, n| oGet:radioGets[n] := nStartGet + n - 1})

    // Radio gets have their own reader, of course
    oGet:reader := {|o| RadioReader(o, aGetList) }
    oGet:colorSpec := GETCOLORS
    IF !Empty( aBlocks )
       oGet:postBlock := aBlocks[nGet]
    ENDIF
    oGet:display()
  NEXT

RETURN oGet


// Just return a code block, which, when evaluated, will return c.
// As the returned code block references a local variable that variable
// becomes "detached" from the activation stack.
FUNCTION t(c)

RETURN {|x| c }


// The reader for radio buttons
Proc RadioReader( oGet, aGetList )

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
        RadioApplyKey(oGet, InKey(1), aGetList)
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


PROC RadioApplyKey(oGet, nKey, aGetList)

LOCAL cKey
LOCAL bKeyBlock
LOCAL nSaveRow, nSaveCol

  // check for SET KEY first
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

    CASE nKey == K_SPACE
      // Toggle state of this radio button. If the get
      // currently contains this radio button, clear it.
      // If it does not, set it to that value
      IF Eval(oGet:radioGsb) == Eval(oGet:block)
        Eval(oGet:radioGsb, "")
      ELSE
        // This sets the real variable to the value
        // of this radio button
        Eval(oGet:radioGsb, Eval(oGet:block))
      ENDIF

      // Ensure Updated() gets set
      oGet:changed := .T.

      // And redraw the getlist
      DrawRadios(aGetlist, oGet)

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


// Draw all radio buttons in aGetList to which the get object in
// oGet is attached
PROC DrawRadios(aGetList, oGet)

LOCAL nRadios   := Len(oGet:radioGets)
LOCAL oGet1
LOCAL nSaveRow := Row()
LOCAL nSaveCol := Col()
LOCAL nGet
LOCAL oMarkGet



  FOR nGet := 1 TO nRadios
    oGet1 := aGetList[oGet:radioGets[nGet]]
    DevPos(oGet1:row, oGet1:col - 3)
    IF Eval(oGet1:radioGsb) == Eval(oGet1:block)
      DevOut(RADIO_BUTTON, if( IsColor() , "g+/b", "n/w") )
      IF ValType( oGet1:postBlock ) == "B"
         oMarkGet := oGet1
      ELSE
         oMarkGet := NIL
      ENDIF
    ELSE
      DevOut(" ",  if( IsColor() , "gr+/b", "w/n") )
    ENDIF
  NEXT

  IF ValType( oMarkGet ) == "O"
     Eval( oMarkGet:postBlock , oMarkGet )
  ENDIF

  DevPos(nSaveRow, nSaveCol)

RETURN
