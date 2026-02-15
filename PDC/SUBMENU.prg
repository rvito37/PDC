// submenu.prg
// Function/Procedure Prototype Table  -  Last Update: 24-06-96 @ 15:07:55
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// Return Value         Function/Arguments
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// self                 METHOD Parsing( aMenuData )
// nKey                 METHOD Show
// self                 METHOD ShowPicture
// self                 METHOD adjustLines
// self                 METHOD hide
// self                 METHOD init(cCaption, nRow , nCol , aMenuData , aColors)
// nKey                 METHOD selectItem( nTimeOut )

// MENUINFO.PRG
#include "inkey.ch"
#include "common.ch"
#include "class(y).ch"


#define TITLE  1
#define ACTION 2
#define FRAME  "ÛßÛÛÛÜÛÛ"


// COLOR DEF
#define GENERAL    1
#define MENUITEM   2
#define MENULETTER 3
#define HIITEM     4
#define HILETTER   5



CREATE CLASS SubMenu
EXPORT:

       VAR cMenuCaption                          TYPE character

       VAR nTop , nLeft , nBottom , nRight     TYPE int
       VAR aColors                             TYPE array
       VAR cSaveScreen                         TYPE character


       VAR cHotCharacters                      TYPE character
       VAR aCharPosition                       TYPE array

       VAR nSelectedItem                       TYPE int

       VAR aCaptions                           TYPE array
       VAR aActions                            TYPE array
       VAR aActive                             TYPE array

       VAR cItemCaption                        TYPE character
       VAR bItemAction
       VAR lActive                             TYPE logical

       METHOD init
       METHOD parsing
       METHOD adjustLines
       MESSAGE exec TO bItemAction
       METHOD Show , ShowPicture
       METHOD selectItem
       METHOD hide

END CLASS


METHOD init(cCaption, nRow , nCol , aMenuData , aColors)

      ::cMenuCaption   := cCaption
      ::nTop           := nRow
      ::nLeft          := nCol
      ::aColors        := aColors
      ::cHotCharacters := ""
      ::nSelectedItem  := 0
      ::aCaptions      := {}
      ::aActions       := {}
      ::aActive        := {}
      ::aCharPosition  := {}
      ::cItemCaption   := ""
      ::bItemAction    := {|| nil }
      ::lActive        := .F.

      ::Parsing( aMenuData )

RETURN self


METHOD Parsing( aMenuData )
LOCAL i, nLen := Len( aMenuData )

FOR i := 2 TO nLen
    Aadd(::aCaptions, aMenuData[i,TITLE]  )
    Aadd(::aActions,  aMenuData[i,ACTION] )
    Aadd(::aActive , .T. )
NEXT

::adjustLines()

RETURN self


METHOD adjustLines
LOCAL i , nLen := Len( ::aCaptions )
LOCAL nMaxLen := Len( ::aCaptions[1] )
LOCAL nPos , nPadLen

FOR i := 1 TO nLen

    nPos := At( "~" , ::aCaptions[i] )
    ::aCaptions[i] := Stuff( ::aCaptions[i],nPos,1,"" )
    ::cHotCharacters += SubStr( ::aCaptions[i] , nPos , 1 )
    Aadd( ::aCharPosition , nPos )

    IF Len(::aCaptions[i]) > nMaxLen
       nMaxLen := Len( ::aCaptions[i] )
    END
NEXT

FOR i := 1 TO nLen
    nPos := At(";" , ::aCaptions[i] )
    ::aCaptions[i] := Stuff( ::aCaptions[i],nPos,1, Space( nMaxLen - Len( ::aCaptions[i] ) + 1 ) )
NEXT

RETURN self


METHOD Show
LOCAL nKey

::nBottom := ::nTop + Len( ::aCaptions )
::nRight  := ::nLeft + Len( :: aCaptions[1] )

scrnPush( ::nTop - 3 , ::nLeft - 2 , ::nBottom +2 , ::nRight + 2 )
// ::cSaveScreen := SaveScreen(::nTop - 3 , ::nLeft - 2 , ::nBottom +2 , ::nRight + 2 )

::ShowPicture()

RETURN nKey

METHOD ShowPicture
LOCAL cOldColor
LOCAL i , nLen := Len( ::aCaptions ) - 1

cOldColor := SetColor(::aColors[GENERAL])

DispBegin()

IF IsColor()
  Shadow(::nTop - 2 , ::nLeft - 1 , ::nBottom+1, ::nRight + 1)
END
DispBox( ::nTop - 3 , ::nLeft - 2 , ::nBottom    , ::nRight     , FRAME+" " )
@ ::nTop - 2 , ::nLeft SAY Padc(::cMenuCaption, Len( ::aCaptions[1] ) )
@ ::nTop -1 , ::nLeft - 1  TO ::nTop -1 , ::nRight-1
FOR i := 0 TO nLen
    @ ::nTop + i , ::nLeft SAY ::aCaptions[i+1]  COLOR ::aColors[MENUITEM]
    @ ::nTop + i , ::nLeft + ::aCharPosition[i+1] - 1 SAY SubStr(::cHotCharacters,i+1,1) COLOR  ::aColors[MENULETTER]
NEXT
DispEnd()

SetColor(cOldColor)
RETURN self



METHOD selectItem( nTimeOut )
LOCAL nKey ,nAt , nTimeCount := 0
LOCAL cTime := MemoRead( "TIME.TIM" )
LOCAL aKeyList:={;
                 {chr(24)+"            - „Œ’Ž „˜…™",K_UP},;
                 {chr(25)+"            -  „ˆŽ „˜…™",K_DOWN},;
                 {"Space-Œ…‚Œ‰‚ ’ „ˆŽ „˜…™",K_SPACE},;
                 {"Home       - „…™€˜ „˜…™",K_HOME},;
                 {"End        - „…˜‡€ „˜…™",K_END},;
                 {"Esc        -       „˜…‡€",K_ESC},;
                 {"Enter      -         ˜‡",K_ENTER},;
                 {"Alt F10    -        ‰‰‘",K_ALT_F10};
                }

DEFAULT nTimeOut TO 6000000


      WHILE TRUE
          @ ::nTop+::nSelectedItem , ::nLeft  SAY ::aCaptions[::nSelectedItem+1]  COLOR ::aColors[HIITEM]
          @ ::nTop+::nSelectedItem , ::nLeft + ::aCharPosition[::nSelectedItem+1] - 1 SAY SubStr(::cHotCharacters,::nSelectedItem+1,1) COLOR  ::aColors[HILETTER]

          WHILE Empty( nKey := InKey() )
                IF Time() == cTime
                    qemail()
                ELSEIF substr(Time(),3,2) == "00"
                    UP_DLINE(.T.)
                ENDIF
                @ 0,74 SAY Left( Time() , 5 ) COLOR "W+/RB"
                IF !Empty(nTimeOut) .AND. ( ++nTimeCount > nTimeOut )
                   KEYBOARD Chr( K_ESC )
                   EXIT
                END
          ENDDO

          @ ::nTop+::nSelectedItem , ::nLeft SAY ::aCaptions[::nSelectedItem+1]  COLOR ::aColors[MENUITEM]
          @ ::nTop+::nSelectedItem , ::nLeft + ::aCharPosition[::nSelectedItem+1] - 1 SAY SubStr(::cHotCharacters,::nSelectedItem+1,1) COLOR  ::aColors[MENULETTER]


          IF nKey = K_F1
             nKey:=HlpKeys(aKeyList)
          END
          nTimeCount := 0
          DO CASE
             CASE nKey = K_ESC .or. nKey = K_ALT_F10
                  EXIT
             CASE nKey = K_ENTER
                   // 16-07-96: S.L.
                  // DO A CHECK HERE for access rights; if no rights
                  // ALERT("No rights to access this menu option")
                  // Test for ReadOnly, and set the RO (global static) flag
                  // HERE!
                  IF IsSecurity()
                   SetAccessLevel( UPPER(LEFT(::aCaptions[::nSelectedItem+1],;
                                   AT("  ",::aCaptions[::nSelectedItem+1] )-1)))
                  ENDIF
                   ::cItemCaption := ::aCaptions[::nSelectedItem+1]
                   ::bItemAction  := ::aActions[::nSelectedItem+1]
                   ::lActive      := ::aActive[::nSelectedItem+1]
                  EXIT
             CASE nKey = K_DOWN
                  ::nSelectedItem++
                  IF ::nSelectedItem > Len( ::aCaptions ) - 1
                     ::nSelectedItem := Len( ::aCaptions ) - 1
                  END
             CASE nKey = K_UP
                  ::nSelectedItem--
                  IF ::nSelectedItem < 0
                     ::nSelectedItem := 0
                  END
             CASE nKey = K_HOME
                  ::nSelectedItem := 0
             CASE nKey = K_END
                  ::nSelectedItem := Len( ::aCaptions ) - 1
             CASE nKey = K_SPACE
                  ::nSelectedItem++
                  IF ::nSelectedItem > Len( ::aCaptions ) - 1
                     ::nSelectedItem := 0
                  END
             CASE (nAt:=  At(Upper(Chr(nKey)),Upper(::cHotCharacters))) > 0
                  ::nSelectedItem := nAt - 1
          ENDCASE
     ENDDO

@ ::nTop+::nSelectedItem , ::nLeft  SAY ::aCaptions[::nSelectedItem+1]  COLOR ::aColors[HIITEM]
@ ::nTop+::nSelectedItem , ::nLeft + ::aCharPosition[::nSelectedItem+1] - 1 SAY SubStr(::cHotCharacters,::nSelectedItem+1,1) COLOR  ::aColors[HILETTER]

RETUR nKey


METHOD hide
scrnPop()
// RestScreen(::nTop - 3 , ::nLeft - 2 , ::nBottom +2 , ::nRight + 2 , ::cSaveScreen)
RETURN self