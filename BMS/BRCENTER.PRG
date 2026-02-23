/*
 * ÚÄ Program ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³  Application: AVXBMS                                                     ³
 * ³    File Name: BRCENTER.PRG                                               ³
 * ³  Description:                                                            ³
 * ³             :                                                            ³
 * ³             :                                                            ³
 * ³             :                                                            ³
 * ³       Author: Danny Hazan           Tester:                              ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:24:14pm            Time updated: ş02:24:14pm            ³
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

// Function/Procedure Prototype Table  -  Last Update: 24-06-96 @ 14:50:43
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// Return Value         Function/Arguments
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// aColsPointers        METHOD currentCols
// self                 METHOD init( cFileName , aColPointers ) ,(cFileName , aColPointers )
// self                 METHOD process( nTimeOut , lHighLight )
// NIL                  METHOD setNewColumns
// self                 METHOD showRecord( cState )
// if( i > ::oBro:c...  METHOD tagIt( cHeading )

// G:\BMS\SOURCE\BRCENTER.PRG
#include "avxdefs.ch"

/*
 * ÚÄ Class ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: BroCenter                                                  ³
 * ³  Description:                                                            ³
 * ³       Author: Danny Hazan                                                ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:24:23pm            Time updated: ş02:24:23pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³ Parent class: TabBro                                                     ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
CREATE CLASS BroCenter FROM TabBro



HIDDEN:
       VAR    nTimeOut

       METHOD setNewColumns
       METHOD tagIt

VISIBLE:

       VAR oUserInfo
       VAR aColumns
       VAR aExtKeys
       VAR lCanAltS    // en/disable switching index keys on the fly
       VAR lCanScope    // en/disable switching index keys on the fly
       VAR lCanSearch  // en/disable incremental searching
       VAR lUseExtHelp // en/disable extended help menu

       METHOD init
       METHOD process
       METHOD showRecord
       METHOD currentCols

END CLASS


/*
 *ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 *³         Name: init()                                                     ³
 *³  Description:                                                            ³
 *³       Author: Danny Hazan                                                ³
 *³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 *³ Time created: 02:24:29pm            Time updated: ş02:24:29pm            ³
 *³    Copyright: AVX                                                        ³
 *ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 *³    Arguments: cFileName                                                  ³
 *³             : aColPointers                                               ³
 *³ Return Value: self                                                       ³
 *³     See Also:                                                            ³
 *ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD init( cFileName , aColPointers, lAltS, aHeaders, lSearch, lExtHelp,lScope )

DEFAULT lAltS    TO TRUE
DEFAULT lSearch  TO TRUE
DEFAULT aHeaders TO {}
DEFAULT lExtHelp TO TRUE
DEFAULT lScope TO FALSE

       ::super:init( cFileName, aColPointers, lAltS, aHeaders )

       ::lUseExtHelp := lExtHelp
       ::lCanAltS    := lAltS
       ::lCanScope   := lScope
       ::lCanSearch  := lSearch
       ::oUserInfo   := GetUserInfo()
       :: aExtKeys   := IF( ::lCanAltS,;
             {;
               {"Any character      - Apply filter/Add character to filter         " , 0}        ,;
               {"[Back space]       - Shorten filter by one character              " , K_BS}     ,;
               {"[Alt] [Back space] - Cancel filter                                " , K_ALT_BS} ,;
               {"[Alt] [A]          - Show current row data (all columns)          " , K_ALT_A} ,;
               {"[Alt] [O]          - Show current row data (selected columns)     " , K_ALT_O} ,;
               {"[Alt] [F]          - Freeze current column and others to its left " , K_ALT_F} ,;
               {"[Alt] [M]          - Mark column                                  " , K_ALT_M} ,;
               {"[Alt] [N]          - Move marked column                           " , K_ALT_N} ,;
               {"[Alt] [H]          - Mark row                                     " , K_ALT_H} ,;
               {"[F8]               - Select and order columns                     " , K_F8 }   ,;
               {"[Esc]              - Exit                                         " , K_ESC}   ;
              },;
              {;
               {"Any character      - Apply filter/Add character to filter       " , 0}        ,;
               {"[Back space]       - Shorten filter by one character            " , K_BS}     ,;
               {"[Alt] [Back space] - Cancel filter                              " , K_ALT_BS} ,;
               {"[Alt] [A]          - Show current row data (all columns)        " , K_ALT_A} ,;
               {"[Alt] [O]          - Show current row data (selected columns)   " , K_ALT_O} ,;
               {"[Alt] [F]          - Freeze current column and other to its left" , K_ALT_F} ,;
               {"[Alt] [M]          - Mark column                                " , K_ALT_M} ,;
               {"[Alt] [N]          - Move marked column                         " , K_ALT_N} ,;
               {"[Alt] [H]          - Mark row                                   " , K_ALT_H} ,;
               {"[F8]               - Select and order columns                   " , K_F8 }   ,;
               {"[Esc]              - Exit                                       " , K_ESC}   ;
             }  )
//             {"Alt S           - Change order                                 " , K_ALT_S} ,;

RETURN self


/*
 *ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 *³         Name: process()                                                  ³
 *³  Description:                                                            ³
 *³       Author: Danny Hazan                                                ³
 *³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 *³ Time created: 02:25:06pm            Time updated: ş02:25:06pm            ³
 *³    Copyright: AVX                                                        ³
 *ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 *³    Arguments: nTimeOut                                                   ³
* ³             : lHighLight                                                 ³
 *³ Return Value: self                                                       ³
 *³     See Also:                                                            ³
 *ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
METHOD process( nTimeOut , lHighLight )
LOCAL oCol , nColMark , oDelCol , nDelCol
LOCAL nKey,nIKey,i
LOCAL cSaveLine
LOCAL nTimeCounter := 0 , nRefreshCount := 0
LOCAL aKeys := { {"Shift F1        - Extended Browse Functions            " , K_SH_F1} }
LOCAL aOldHlpKeys
LOCAL cTempTitle := IF(::nIndexPointer=NIL,"",::aIndexCaptions[::nIndexPointer])
LOCAL c1stField
LOCAL cOldScr := SAVESCREEN()

DEFAULT nTimeOut   TO 90000000 // Changed from 30000000 by y.h 21-12-99  and added by
DEFAULT lHighLight TO FALSE

::nTimeOut := nTimeOut

::nIndexPointer := 1
::oForm:Say( 2,30 ,cTempTitle,,"bg+/b" )
cSaveLine := SaveScreen( 2,0, 2,29 )

IF ::lUseExtHelp
   Add2HlpKeys( aKeys )
END

     // show that there are more rows and cols
     ::oForm:Say( 2,79, "",,"bg+/b")
     ::oForm:Say( 4,79, CHR(26),,"bg+/b")

     //(::cFileName)->(ordsetfocus(1))
//     (::cFileName)->(dbgotop())  vitaly
WHILE .T.

             nIKey := (::cFileName)->( IndexOrd() )
          //   nKey++

          //   IF nKey > (::cFileName)->( AX_IndexCount() )
          //      nKey := 1
          //   END

          //   (::cFileName)->(  DbSetOrder( nKey ) )
          //   ::bKey := COMPILE( (::cFileName)->( IndexKey() ) )
          //   ::cSearcher := ""
          //   ::oBro:goTop()
          //   ::oBro:refreshAll()

             //::nIndexPointer := nIKey
             IF LEN(::aIndexCaptions)>0
                 ::oForm:Say( 2,20 ,Padc(::aIndexCaptions[::nIndexPointer],31),,"bg+/b" )
             ENDIF

     IF lHighLight
        ::oBro:colorRect({::oBro:rowPos,1,::oBro:rowPos,::oBro:colCount},{1,1})
        ::oBro:hilite()
     ENDIF

     WHILE NextKey() = 0 .AND. !::oBro:stabilize()  ; END
            IF ::oBro:HitTop
               Tone(100,0)
               ::oForm:Say( 2, 0, " ",,"bg+/b")
               ::oBro:hitTop := FALSE
            ELSE
               ::oForm:Say( 2, 0, "",,"bg+/b")
            END
            IF ::oBro:HitBottom
               Tone(100,0)
               ::oForm:Say( 2,79, " ",,"bg+/b")
               ::oBro:HitBottom := FALSE
            ELSE
               ::oForm:Say( 2,79, "",,"bg+/b")
            END
     WHILE NextKey() = 0 .AND. !::oBro:stabilize()  ; END
            IF ::oBro:HitTop
               Tone(100,0)
               ::oForm:Say( 2, 0, " ",,"bg+/b")
               ::oBro:hitTop := FALSE
            ELSE
               ::oForm:Say( 2, 0, "",,"bg+/b")
            END
            IF ::oBro:HitBottom
               Tone(100,0)
               ::oForm:Say( 2,79, " ",,"bg+/b")
               ::oBro:HitBottom := FALSE
            ELSE
               ::oForm:Say( 2,79, "",,"bg+/b")
            END
            //
            //


     IF lHighLight
        ::oBro:colorRect({::oBro:rowPos,1,::oBro:rowPos,::oBro:colCount},{3,2})
        ::oBro:hilite()
     ENDIF

     WHILE Empty( nKey := InKey(1) )
        IF !Empty( nTimeOut ) .AND. ++nTimeCounter > nTimeOut
           nKey := K_ESC
           EXIT
        ELSE
           IF ++nRefreshCount > 60000
              nRefreshCount := 0
              //::oBro:refreshAll()
              //::oBro:forceStable()
           ENDIF
        ENDIF
     END

     nTimeCounter := 0

     F1 PRESSED

     IF nKey == K_SH_F1 .AND. ::lUseExtHelp
        aOldHlpKeys := SetHlpKeys( ::aExtKeys )
        nKey := HlpKeys()
        SetHlpKeys( aOldHlpKeys )
     ENDIF

     DO CASE
        CASE nKey = K_ALT_F1
             prnHelpCrits()
        CASE nKey = K_ESC
             EXIT
        CASE nKey = K_ALT_H  .AND. ::lUseExtHelp  // highlight
             lHighLight := !lHighLight
             ::oBro:refreshAll()
        CASE nKey = K_ALT_Z  .AND. ::lUseExtHelp// Temporary, for debugging, will be ALT_D in the future
             IF ::oBro:colCount > 1
                nDelCol := ::oBro:colPos
                oDelCol := ::oBro:delColumn(::oBro:colPos)
                ::oBro:configure()
             END
        CASE nKey = K_ALT_I  .AND. ::lUseExtHelp
             IF oDelCol != NIL
                ::oBro:insColumn(nDelCol,oDelCol)
                ::oBro:configure()
                nDelCol := 0
                oDelCol := NIL
             END
        CASE nKey = K_ALT_M  .AND. ::lUseExtHelp// mark column to set
             IF oCol = NIL
                oCol := ::oBro:getcolumn(::oBro:colPos)
                oCol:defColor := {3,3}
                nColMark := ::oBro:colPos
             ELSEIF  oCol == ::oBro:getcolumn(::oBro:colPos)
                ::oBro:getcolumn(::oBro:colPos):defColor := {1,2}
                oCol := NIL
                nColMark := NIL
             ELSE
                oCol:defColor := {1,2}
                ::oBro:getcolumn(::oBro:colPos):defColor := {3,3}
                oCol := ::oBro:getcolumn(::oBro:colPos)
                nColMark := ::oBro:colPos
             END
             ::oBro:configure()
        CASE nKey = K_ALT_N  .AND. oCol != NIL   .AND. ::lUseExtHelp// set new marked column
             ::oBro:delColumn(nColMark)
             oCol:defColor := {1,2}
             ::oBro:insColumn(::oBro:colPos,oCol)
             nColMark := oCol := NIL
             ::oBro:configure()

        CASE nKey = K_BS .AND. ::lCanSearch
             IF !Empty(Len(::cSearcher))
                ::cSearcher := SubStr(::cSearcher,1,Len(::cSearcher)-1)
                IF !Empty(Len(::cSearcher))
                 //  IF UPPER(LEFT( (::cFileName)->(IndexKey()), 3 )) = "STR" .OR. NoAlpha( ::cSearcher )
                 //    (::cFileName)->( DbSeek( PADL(::cSearcher, LEN(&(INDEXKEY())),.T.) ) )
                 //  ELSE
                      (::cFileName)->( DbSeek(::cSearcher,.T.) )
                 //  END
                ELSE
                  (::cFileName)->( DBgoTop() )
                END
                  ::oBro:refreshAll()
             END

             IF ::lCanScope
              ::Re2Scope( ::cSearcher,::cSearcher )
             ENDIF
             RestScreen(2,0,2,29,cSaveLine)
             @ 2,1 SAY ::cSearcher COLOR "n/w"

        CASE nKey = K_ALT_BS .AND. ::lCanSearch
             ::cSearcher := ""
             ::oBro:goTop()
             ::oBro:refreshAll()
             RestScreen(2,0,2,29,cSaveLine)
             @ 2,1 SAY ::cSearcher COLOR "n/w"

        CASE (nKey >= 32 .AND. nKey <= 126) .AND. ::lCanSearch
             ::cSearcher += Upper( Chr( nKey ) )
             (::cFileName)->( DbSeek( ::cSearcher, .T. ) )
             IF (::cFileName)->( FOUND() )
             ELSE
					 IF "CZ" $ GetUserInfo():cGroupID
						 Alert("No records found in this range!",{"Enter"})
					 ELSE
						 Alert("!„€‰‚™;;!! „† …‡š š…˜…™ ‰€",{"˜…™‰€"})
					 ENDIF

                ::cSearcher := SubStr(::cSearcher,1,Len(::cSearcher)-1)
                (::cFileName)->(DbSeek(::cSearcher,.T.))
                IF !EMPTY(::cSearcher)
                      (::cFileName)->( DbSeek(::cSearcher,.T.) )
                ELSE
                   (::cFileName)->( DBGOTOP())
                END
             END
             RestScreen(2,0,2,29,cSaveLine)
             @ 2,1 SAY ::cSearcher COLOR "n/w"
             IF ::lCanScope
              ::Re2Scope( ::cSearcher,::cSearcher )
             ENDIF
             ::oBro:refreshAll()
        CASE nKey = K_ALT_Q .AND. ::lCanAltS
				 @11,21 CLEAR TO 11, 24
				 DrawBox(10,21,12,24)
				 @ 11, 22 GET nKey PICTURE "99" VALID nKey <= LEN(::aIndexList)
				 READ

				 RESTSCREEN(,,,,cOldScr)
				 IF lastkey() <> K_ESC
					 (::cFileName)->(  ordsetfocus( nKey ) )
					 ::bKey := COMPILE( (::cFileName)->( ordKey() ) )
					 ::cSearcher := ""
					 RestScreen(2,0,2,29,cSaveLine)
					 ::oBro:refreshAll()
				 ENDIF

				 FOR i := 1 TO  Len(::aIndexList)
				   IIF(UPPER(::aIndexList[i]) $ Ax_TagName(),nKey := i,NIL)
				 NEXT

				 ::nIndexPointer := nKey
				 IF LEN(::aIndexCaptions)>0
				    ::oForm:Say( 2,30 ,Padr(::aIndexCaptions[::nIndexPointer],10),,"bg+/b" )
				 ENDIF
				 cSaveLine := SaveScreen( 2,0, 2,29 )
				 ::oBro:refreshAll()
        CASE nKey = K_ALT_S .AND. ::lCanAltS
				 ::oForm:Say( 2,30 ,Space(38),,"bg+/b" )
             nKey := (::cFileName)->( IndexOrd() )
             nKey++

             IF nKey > LEN(::aIndexList)
                nKey := 1
             END

             (::cFileName)->(  ordsetfocus( nKey ) )
             ::bKey := COMPILE( (::cFileName)->( ordKey() ) )
             ::cSearcher := ""
             RestScreen(2,0,2,29,cSaveLine)
             ::oBro:refreshAll()

             FOR i := 1 TO  Len(::aIndexList)
               IIF(UPPER(::aIndexList[i]) $ Ax_TagName(),nKey := i,NIL)
             NEXT

             ::nIndexPointer := nKey
             IF LEN(::aIndexCaptions)>0
                ::oForm:Say( 2,30 ,Padr(::aIndexCaptions[::nIndexPointer],10),,"bg+/b" )
             ENDIF
             cSaveLine := SaveScreen( 2,0, 2,29 )

        CASE nKey = K_ALT_W .AND. ::lCanAltS

             ::oForm:Say( 2,30 ,Space(38),,"bg+/b" )

             nKey := (::cFileName)->( IndexOrd() )
             nKey--

             IF nKey == 0
                nKey := LEN(::aIndexList)
             END

             (::cFileName)->(  DbSetOrder( nKey ) )
             ::bKey := COMPILE( (::cFileName)->( ordKey() ) )
             ::cSearcher := ""
             RestScreen(2,0,2,29,cSaveLine)
             ::oBro:refreshAll()

             ::nIndexPointer := nKey
             IF LEN(::aIndexCaptions)>0
                 ::oForm:Say( 2,30 ,Padr(::aIndexCaptions[::nIndexPointer],20),,"bg+/b" )
             ENDIF
             cSaveLine := SaveScreen( 2,0, 2,29 )

        CASE nKey = K_F8 .AND. ::lUseExtHelp
             ::setNewColumns()
             ::oBro:refreshAll()
        CASE nKey = K_ALT_F   // freeze
             IF ::oBro:freeze = 0
                ::oBro:freeze := ::oBro:colPos
             ELSE
                ::oBro:panHome()
                ::oBro:freeze = 0
             ENDIF
             ::oBro:refreshAll()
        CASE nKey = K_ALT_A   // all fields in record
             ::showRecord("a")
        CASE nKey = K_ALT_O   // only selected columns
             ::showRecord("o")
        CASE StdKeys( nKey , ::oBro )
            //
            IF ::oBro:ColPos < 1 ; ::oBro:ColPos := 1 ; END
            IF ::oBro:ColPos > ::oBro:ColCount
               ::oBro:ColPos := ::oBro:ColCount
            ENDIF
            IF ::oBro:ColPos == 1
               ::oForm:Say( 4, 0, " ",,"bg+/b")
               ::oForm:Say( 4,79, CHR(26),,"bg+/b")
            ELSEIF ::oBro:ColPos == ::oBro:ColCount
               ::oForm:Say( 4, 0, CHR(27),,"bg+/b")
               ::oForm:Say( 4,79, " ",,"bg+/b")
            ELSE
               ::oForm:Say( 4, 0, CHR(27),,"bg+/b")
               ::oForm:Say( 4,79, CHR(26),,"bg+/b")
            ENDIF

        OTHERWISE
           IF ::oBro:stable .AND. ValType( ::ApplyBlock ) == "B"
              ::ApplyBlock:eval( nKey , self , ::oForm )
              ::oBro:refreshAll()
           ENDIF
     ENDCASE

ENDDO


::close()
SizeHlpKeys()
RETURN self


/******************************************************************/
FUNCTION Get1stField( cKey )

LOCAL nPlus := AT("+", cKey) - 1
LOCAL cRet
LOCAL nLen
LOCAL nAt

IF nPlus == -1
   cRet := LOWER( cKey )
ELSE
  cRet := LOWER( LEFT( cKey, nPlus ) )
ENDIF

IF ( nAt := AT( "(", cRet ) ) > 0 .AND. AT( ")", cRet ) == 0
   cRet := SUBSTR( cRet, nAt+1 )
ENDIF

RETURN cRet
/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: setNewColumns                                              ³
 * ³  Description:                                                            ³
 * ³       Author: Danny Hazan                                                ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:26:21pm            Time updated: ş02:26:21pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: NIL                                                        ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD setNewColumns
LOCAL aCaptions := {} , i , nKey
LOCAL aSelected := {}
LOCAL o , oSel , oOrder
LOCAL  nT := 4, nL := 5 ,nB := 20
LOCAL nR := nL + ::nMaxLen + 10
LOCAL oForm , nTimeCounter := 0
LOCAL nItemNo , nControl := 0  , cSaveItem
LOCAL cArrLocateStr := ""

Aeval( ::aColumns ,;
       {|oCol| Aadd(aCaptions,{oCol:heading, ::tagIt(oCol:heading) } ) })

Asort( aCaptions ,,, {|x,y| Upper(x[1]) < Upper( y[1] ) } )

oSel := ABrowseNEW(nT,nL,nB,nR,aCaptions)
oSel:addColumn( TBColumnNEW(NIL, {|| oSel:arrayReference[oSel:arrayIndex,2]})  )
oSel:addColumn( TBColumnNEW("Headers", {|| Padr(oSel:arrayReference[oSel:arrayIndex,1], ::nMaxLen ) }) )
Aadd( oSel:cargo, "sel" )

o := oSel

oForm := Form():new(nT-1 ,nL-1,nB+1, nR+1 , " Select " , "w+/b")

WHILE .T.

    WHILE !o:stabilize()
      nKey := INKEY()
      IF nKey <> 0
         EXIT
      ENDIF
    ENDDO

    IF Empty( nKey := InKey(100) )
       IF !Empty( ::nTimeOut ) .AND. ++nTimeCounter > ::nTimeOut
          EXIT
       ENDIF
    ENDIF

    nTimeCounter := 0

    IF nKey > 32 .AND. nKey <= 255
       cArrLocateStr += Chr( nKey )
       ArrLocateByStr( cArrLocateStr , o , 1 )
       LOOP
    ENDIF

    cArrLocateStr := ""

    IF nKey = K_ESC
       DO CASE
          CASE o:cargo[3] == "sel"
               EXIT
          CASE o:cargo[3] == "order"  // track back to selections
               o := oSel
               oForm:say( 0,2 , "Select" ,, "w+/g" )
               o:goTop()
               o:refreshAll()
       ENDCASE
    ELSEIF nKey = K_ALT_BS
       cArrLocateStr := ""
    ELSEIF nKey == K_ENTER
       DO CASE
          CASE o:cargo[3] == "sel"
               aSelected := {}
               Aeval( aCaptions , ;
                    {| aCaption | if( aCaption[2] = "[X]" , Aadd( aSelected , aCaption[1] ),) } )

               IF Empty( aSelected )
                  Msg24({"174"} , 3 , .T. )
                  LOOP
               ENDIF

               DispBox( nT,nL,nB,nR, "         " , "W+/B" )
               aSelected[1] := Padr( aSelected[1] , nR-nL )
               oOrder := ABrowseNEW(nT,nL,nB,nR,aSelected)
               oOrder:addColumn( TBColumnNEW("Headers", {|| oOrder:arrayReference[oOrder:arrayIndex] }) )
               Aadd( oOrder:cargo, "order" )
               o := oOrder
               o:goTop()
               o:refreshAll()
               oForm:say( 0,2 , "              " ,, "w+/g" )
               oForm:say( 0,2 , " Order " ,, "w+/g" )
          CASE o:cargo[3] == "order"
               nKey:=Len( aSelected )

               WHILE !Empty(::oBro:colCount)
                   ::oBro:delColumn(::oBro:colCount)
               END
               ::oBro:configure()

               FOR i := 1 TO nKey // nKey - functions as len var
                   nItemNo := Ascan( ::aColumns , {|oCol| oCol:heading == Alltrim(aSelected[i]) } )
                   ::oBro:addColumn( ::aColumns[nItemNo] )
               NEXT
               ::oBro:configure()
               ::oBro:refreshAll()
               EXIT
       ENDCASE

    ELSEIF StdKeys( nKey , o )
    ELSEIF nKey = K_SH_F7 .AND. o:cargo[3] == "sel"
           nKey := Len( o:arrayReference )
           Aeval( o:arrayReference , {| elem , i | o:arrayReference[i,2] := "[ ]" } )
           o:refreshAll()
    ELSEIF nKey = K_CTRL_F7 .AND. o:cargo[3] == "sel"
           nKey := Len( o:arrayReference )
           Aeval( o:arrayReference , {| elem , i | o:arrayReference[i,2] := "[X]" } )
           o:refreshAll()
    ELSEIF nKey = K_SPACE .AND. o:cargo[3] == "sel"
         IF o:arrayReference[o:arrayIndex,2] == "[X]"
            o:arrayReference[o:arrayIndex,2] := "[ ]"
         ELSE
            o:arrayReference[o:arrayIndex,2] := "[X]"
         ENDIF
         o:refreshCurrent()
    ELSEIF nKey = K_SPACE .AND. o:cargo[3] == "order"
           DO CASE
              CASE nControl = 0
                   nItemNo:=o:arrayIndex
                   nControl:=1
              CASE nControl = 1
                   nControl := 0
                   cSaveItem:=aSelected[nItemNo]
                   Adel(aSelected,nItemNo)
                   aIns(aSelected,o:arrayIndex)
                   aSelected[o:arrayIndex] := cSaveItem
                   o:RefreshAll()
           ENDCASE
    ENDIF

ENDDO

oForm:hide()

RETURN NIL

/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: tagIt()                                                    ³
 * ³  Description:                                                            ³
 * ³       Author: Danny Hazan                                                ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:26:30pm            Time updated: ş02:26:30pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: cHeading                                                   ³
 * ³ Return Value: if( i > ::oBro:colCount , "[ ]" , "[X]" )                  ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD tagIt( cHeading )
LOCAL i

FOR i:= 1 TO ::oBro:colCount
    IF ::oBro:getColumn(i):heading == cHeading
       EXIT
    ENDIF
NEXT

RETURN  if( i > ::oBro:colCount , "[ ]" , "[X]" )

/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: showRecord()                                               ³
 * ³  Description:                                                            ³
 * ³       Author: Danny Hazan                                                ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:26:33pm            Time updated: ş02:26:33pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: cState                                                     ³
 * ³ Return Value: self                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD showRecord( cState )
LOCAL xTempVal
LOCAL aWorkCols := {} , i
LOCAL aData := {} , nLen
LOCAL nMaxHeaderLen := 0
LOCAL nMaxFieldLen  := 0
LOCAL cCaption
LOCAL oForm
LOCAL o , nKey
DO CASE
   CASE cState == "o"
        cCaption := " Columns record details  for rec no:"+Ltrim(Str( (::cFileName)->( RecNo() )))
        FOR i := 1 TO ::oBro:colCount
            Aadd( aWorkCols , ::oBro:getColumn( i ) )
        NEXT
   CASE cState == "a"
        cCaption := " Full record details  for rec no:"+Ltrim(Str( (::cFileName)->( RecNo() )))
        aWorkCols := ::aColumns
ENDCASE

nLen := Len( aWorkCols )

FOR i := 1 TO nLen
    nMaxHeaderLen := Max( nMaxHeaderLen , Len( aWorkCols[i]:heading) )
    nMaxFieldLen  := Max( nMaxFieldLen  , aWorkCols[i]:width )
NEXT

FOR i := 1 TO nLen

    xTempVal := aWorkCols[i]:block:eval()

    IF ValType( xTempVal ) == "N"
       xTempVal := Str( xTempVal )
    ELSEIF ValType( xTempVal ) == "D"
       xTempVal := Dtoc( xTempVal )
    ENDIF

    Aadd( aData ,;
             Padr( aWorkCols[i]:heading , nMaxHeaderLen ) +":"+xTempVal )
NEXT

oForm := Form():new( 3,1 , 21 , 78 , cCaption   , "w+/b")
o := AbrowseNEW( oForm:nTop+1,oForm:nLeft+1,oForm:nBottom-1,oForm:nRight-1, aData )
o:addColumn( TBColumnNEW(NIL, {|| Left( o:arrayReference[o:arrayIndex] ,78 )  } ) )
o:getColumn(1):width := 78

WHILE .T.
   WHILE !o:stabilize()
      nKey := INKEY()
      IF nKey <> 0
         EXIT
      ENDIF
   ENDDO
   nKey := InKey(0)
   IF nKey = K_ESC
      EXIT
   ELSEIF StdKeys( nKey , o )
   ENDIF
ENDDO
oForm:hide()
RETURN self

METHOD currentCols
LOCAL i , nLen := ::oBro:colCount , nPosition
LOCAL aColsPointers := {}

FOR i := 1 TO nLen
    nPosition := Ascan( ::aColumns , {|oCol| oCol:heading == ::oBro:getColumn(i):heading} )
    Aadd( aColsPointers , nPosition )
NEXT

RETURN aColsPointers

/*************************** EOF BRCENTER.PRG ******************************/