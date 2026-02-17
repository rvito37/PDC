// tabselct.prg
// Function/Procedure Prototype Table  -  Last Update: 24-06-96 @ 15:08:28
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// Return Value         Function/Arguments
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// self                 METHOD init( cFileName , aColPointers , bSelectBlock ) , (cFileName , aColPointers)
// self                 METHOD process( nTimeOut , lHighLight )

// G:\BMS\SOURCE\TABSELCT.PRG

#include "avxdefs.ch"


CREATE CLASS TabSelect FROM TabBro

VISIBLE:
       VAR bSelectBlock
       VAR xSeekKey
       VAR nTimeOut
       VAR ApplyBlock
       VAR lAltS

       METHOD init
       METHOD process
END CLASS


METHOD init( cFileName , aColPointers , bSelectBlock , lAltS, aHeaders, aIndexes,cDatFile )

DEFAULT lAltS TO .T.
       ::super:init( cFileName, aColPointers, lAltS, aHeaders, aIndexes, cDatFile )

       ::bSelectBlock  := bSelectBlock
       ::lAltS        := lAltS

RETURN self


METHOD process( nTimeOut , lHighLight, lF2Win )
LOCAL oCol , nColMark , oDelCol , nDelCol
LOCAL nKey , cSaveLine
LOCAL nTimeCounter := 0 , nRefreshCount := 0
LOCAL cSeekKey
LOCAL aKeys :={;
               {"Esc             - Quit                  " , K_ESC   },;
               {"Alt H           - Highlight             " , K_ALT_H },;
               {"Alt M           - Mark column           " , K_ALT_M },;
               {"Alt N           - Move marked column    " , K_ALT_N },;
               {"Back space      - Delete a filter letter" , K_BS    },;
               {"Alt Back space  - Delete filter         " , K_ALT_BS},;
               {"A letter        - Filtering records     " , 0       },;
               {"Alt S           - Change order          " , K_ALT_S },;
               {"Alt F           - Freeze columns        " , K_ALT_F },;
               {"Enter           - Select a row          " , K_ENTER };
             }

Add2HlpKeys( aKeys )

::nTimeOut := nTimeOut
DEFAULT nTimeOut TO 6000000 , lHighLight to .F.
DEFAULT lF2Win TO FALSE

IF ::nIndexPointer == NIL .OR. EMPTY(::nIndexPointer)
   ::nIndexPointer := 1
ENDIF

//(::cFileName)->(ordsetfocus(::aIndexlist[1])) //vr
IF !Empty(::aIndexCaptions)
   ::oForm:Say( 0,::oForm:nRight-30 ,Replicate("Û",30),,"w+/g" )
   ::oForm:Say( 0,::oForm:nRight-30 ,"Order is:"+substr(::aIndexCaptions[::nIndexPointer],1,21)+" ",,"w+/r" )
ENDIF

cSaveLine := SaveScreen( ::oForm:nBottom ,::oForm:nLeft ,::oForm:nBottom , ::oForm:nRight )

IF Empty( ::xSeekKey )
   (::cFileName)->( DbGoTop() )
   ::oBro:goTop()
ELSE
   IF !Empty( ::aIndexList )
      cSeekKey :=  RTrim( ::xSeekKey )                          // seek soft ( near )
      IF (::cFileName)->( DbSeek( cSeekKey ),.T. )             // seek it
         IF (::cFileName)->( Eof() )
            (::cFileName)->( DbGoTop() )
            ::oBro:goTop()
         ENDIF
      ELSE
         (::cFileName)->( DbGoTop() )
         ::oBro:goTop()
      ENDIF
   ELSE
      (::cFileName)->(__dbLocate( {|| FieldGet(1) = ::xSeekKey} ) )  // locate it
      IF (::cFileName)->( Eof() )
         (::cFileName)->( DbGoTop() )
         ::oBro:goTop()

      ENDIF
   ENDIF
ENDIF

::oBro:refreshAll()

WHILE .T.

     IF lHighLight
        ::oBro:colorRect({::oBro:rowPos,1,::oBro:rowPos,::oBro:colCount},{1,1})
        ::oBro:hilite()
     ENDIF

     WHILE NextKey() = 0 .AND. !::oBro:stabilize()  ; END

     IF lHighLight
        ::oBro:colorRect({::oBro:rowPos,1,::oBro:rowPos,::oBro:colCount},{3,2})
        ::oBro:hilite()
     ENDIF

     WHILE Empty( nKey := InKey() )
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
     ENDDO

     nTimeCounter := 0

    IF !lF2Win
       F1 PRESSED
    END

     DO CASE
        CASE nKey = K_ESC
             EXIT
        CASE nKey = K_ALT_H   // highlight
             lHighLight := !lHighLight
             ::oBro:refreshAll()
        CASE nKey = K_ALT_M // mark column to set
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
        CASE nKey = K_ALT_N  .AND. oCol != NIL  // set new marked column
             ::oBro:delColumn(nColMark)
             oCol:defColor := {1,2}
             ::oBro:insColumn(::oBro:colPos,oCol)
             nColMark := oCol := NIL
             ::oBro:configure()
        CASE nKey = K_BS
             IF !Empty(Len(::cSearcher))
                ::cSearcher := SubStr(::cSearcher,1,Len(::cSearcher)-1)
                (::cFileName)->( DbSeek(::cSearcher,.T.) )
                ::oBro:goTop()
                ::oBro:refreshAll()
             END
             RestScreen(::oForm:nBottom ,::oForm:nLeft ,::oForm:nBottom , ::oForm:nRight,cSaveLine)
             ::oForm:sayBottom(  , 2  , ::cSearcher ,, "n/w")

        CASE nKey = K_ALT_BS
             ::cSearcher := ""
             ::oBro:goTop()
             ::oBro:refreshAll()
             RestScreen(::oForm:nBottom ,::oForm:nLeft ,::oForm:nBottom , ::oForm:nRight,cSaveLine)
             ::oForm:sayBottom(  , 2  , ::cSearcher ,, "n/w")
        CASE !Empty((::cFileName)->( AX_IndexCount() )) .AND. ;  // works only on indexed work area
             ((nKey >= 44 .AND. nKey <= 122) .OR.;   // ",-./" "1234567890"  "a" to "z"
             (nKey = K_SPACE) .OR. ;
             (nKey >= 38 .AND. nKey <= 41))    //  "& ' ( )"



             ::cSearcher += Upper( Chr( nKey ) )
             IF (::cFileName)->( DbSeek(::cSearcher,.T.) )

             ELSE
                Alert("!! „† …‡š š…˜…™ ‰€",{"..."})
                ::cSearcher := SubStr(::cSearcher,1,Len(::cSearcher)-1)
                (::cFileName)->(DbSeek(::cSearcher,.T.))
             END
             RestScreen(::oForm:nBottom ,::oForm:nLeft ,::oForm:nBottom , ::oForm:nRight,cSaveLine)
             ::oForm:sayBottom(  , 2  , ::cSearcher ,, "n/w")
             ::oBro:goTop()
             ::oBro:refreshAll()

        CASE nKey = K_ALT_S .AND. ::lAltS .AND. !Empty(::aIndexCaptions)

             nKey := (::cFileName)->( IndexOrd() )
             nKey++

             IF nKey > (::cFileName)->( AX_TagCount() )
                nKey := 1
             END

             (::cFileName)->(  DbSetOrder( nKey ) )
             ::bKey := COMPILE( (::cFileName)->( OrdKey() ) )  //indexkey
             ::cSearcher := ""
             RestScreen(::oForm:nBottom ,::oForm:nLeft ,::oForm:nBottom , ::oForm:nRight,cSaveLine)
             ::oBro:goTop()
             ::oBro:refreshAll()

             ::nIndexPointer := nKey

             ::oForm:Say( 0,::oForm:nRight-30 ,Replicate("Û",30),,"w+/g" )
  //         ::oForm:Say( 0,::oForm:nRight-30 ," Order is:"+::aIndexCaptions[::nIndexPointer]+" ",,"w+/r" )
             ::oForm:Say( 0,::oForm:nRight-30 ,"Order is:"+substr(::aIndexCaptions[::nIndexPointer],1,21),,"w+/r" )

        CASE nKey = K_ALT_F   // freeze
             IF ::oBro:freeze = 0
                ::oBro:freeze := ::oBro:colPos
             ELSE
                ::oBro:panHome()
                ::oBro:freeze = 0
             ENDIF
             ::oBro:refreshAll()
        CASE StdKeys( nKey , ::oBro )

        OTHERWISE
           IF ::oBro:stable
              IF nKey = K_ENTER .AND. ValType( ::bSelectBlock ) == "B"
                 ::bSelectBlock:eval()
                 EXIT
              ELSEIF ValType( ::ApplyBlock ) == "B"
                 nKey :=  Eval( ::ApplyBlock, nKey , self )
                 IF ValType( nKey ) == "C" .AND. nKey == "exit"
                    EXIT
                 ENDIF
                 ::oBro:refreshAll()
              ENDIF
           ENDIF
     ENDCASE
ENDDO

SizeHlpKeys()
RETURN self
