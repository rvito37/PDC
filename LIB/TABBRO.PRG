// tabbro.prg
// Function/Procedure Prototype Table  -  Last Update: 08-22-96 @ 11:21:37am
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// Return Value         Function/Arguments
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// self                 METHOD addDefaultCols()
// bBlock               METHOD blockify( i )
// self                 METHOD createBrowse
// Ascan( ::aDataHe...  METHOD getColumnPos( cHeading )
// self                 METHOD init( cFileName , aColPointers ) , (cFileName )
// oColumn              METHOD makeColumn( cBuffer )
// cPicture             METHOD makePicture( nLen , nDec )
// self                 METHOD readAttribute
// self                 METHOD ReScope(cNewSearcher)


// G:\BMS\SOURCE\BROTAB.PRG

#include "avxdefs.ch"


CREATE CLASS TabBro FROM TabBase
HIDDEN:

       METHOD makeColumn
       METHOD blockify

VISIBLE:
       VAR oBro
       VAR oForm
       VAR aColumns
       VAR aColPointers

       VAR nMaxLen
       VAR aDataHeaders
       VAR aDataDriven
       VAR ApplyBlock

       VAR cSearcher
       VAR cBottom
       VAR bKey
       VAR nIndexPointer


       METHOD init
       METHOD readAttributes
       METHOD makePicture
       METHOD createBrowse
       METHOD addDefaultCols
       METHOD getColumnPos
       METHOD ReScope
       METHOD Re2Scope


END CLASS


METHOD init( cFileName , aColPointers, lAltS, aHeaders, aIndexes,cDatFile)

DEFAULT lAltS TO TRUE
DEFAULT aHeaders TO {}
       ::super:init( cFileName, aIndexes )
       ::cSearcher   := ""
       ::bKey        := {|| "" }
       ::nMaxLen     := 0
       ::aColPointers := aColPointers
       ::aDataHeaders := aHeaders

       ::setIndexList()
       ::xopen()

       ::readAttributes(cDatFile)

RETURN self


METHOD readAttributes(cDatFile)
LOCAL cDbfDir := GetUserInfo():cDbfDir
LOCAL cBuffer
LOCAL nPosition , aTemp , cTemp ,i

::aDataDriven  := {}
::aColumns     := {}
IF LEN(::aDataHeaders)=0
IF !Empty(cDatFile)
   cBuffer := MemoRead( cDbfDir + cDatFile+".dat" )
ELSE
	cBuffer := MemoRead( cDbfDir + ::cFileName+".dat" )
ENDIF
::aDataHeaders := {}
WHILE !Empty(cBuffer)
      nPosition := At(NEWLINE,cBuffer)
      cTemp  := SubStr(cBuffer,1,nPosition-1)
      IF "*h" $ cTemp
         ::aDataHeaders  := &( "{" + SubStr(cTemp,3) + "}" )
      ELSE
         Aadd( ::aColumns , ::makeColumn( cTemp,Len(::aColumns) ) )
      ENDIF
      cBuffer := Substr(cBuffer,nPosition + 2 )
ENDDO
ELSE
FOR i=1 to Len(::aDataHeaders)
         cTemp  := '  "('+::aColPointers[i] +[)","]+::aDataHeaders[i]+'" , , '
         Aadd( ::aColumns , ::makeColumn( ,i ) )
NEXT
ENDIF
RETURN self

METHOD createBrowse
LOCAL t,l,b,r

IF ::oForm:lFullScreen
   t := 3
   l := 1
   b := 23
   r := 78
ELSE
   t := ::oForm:nTop  + 1
   l := ::oForm:nLeft + 1
   b := ::oForm:nBottom - 1
   r := ::oForm:nRight - 1
ENDIF

DEFAULT  ::cSearcher  TO ""

::oBro := TBrowseDB( t , l, b, r )
::oBro:headSep   := "Í"  //"ÍÑÍ"
::oBro:colSep    := "³"
::oBro:footSep   := "Í"  //"ÍÏÍ"
::oBro:colorSpec := Colors()

::oBro:gotopBlock    :={|| (::cFileName)->(Top(::cSearcher))            }
::oBro:gobottomBlock :={|| (::cFileName)->(Bot(::cSearcher))            }
::oBro:skipBlock     :={|n|(::cFileName)->(SkipIt(n,::cSearcher,::bKey))}
IF FILE(::cFileName + ".CDX") .AND. !Empty( (::cFileName)->(OrdKey()))//VR
   ::bKey := COMPILE( (::cFileName)->(OrdKey()) )
ENDIF

RETURN self

/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: makeColumn()                                               ³
 * ³  Description: create a browse column from the info in the .dat file      ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 08-27-96              Date updated: þ08-27-96              ³
 * ³ Time created: 04:50:41pm            Time updated: þ04:50:41pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: cBuffer                                                    ³
 * ³ Return Value: oColumn                                                    ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD makeColumn( cBuffer,nlen )
LOCAL oColumn
LOCAL bBlock , i
LOCAL lFunc := FALSE
LOCAL cTmpHead,nPos,cTmpField
LOCAL lShaiQ := FALSE
LOCAL aData   //:= &( "{" + cBuffer + "}" )
IF cBuffer==NIL
    aData := {::aColPointers[nLen],::aDataHeaders[nLen]}
    lShaiQ := TRUE
ELSE
    aData := &( "{" + cBuffer + "}" )
ENDIF

oColumn := TBColumnNEW()

Aadd( ::aDataDriven , aData )

// 27-08-96 TEST by Shalom, to see if we can give access to functions
// instaed of just column nos., for RDB columns

// IF i==NIL
//   i := nLen
// ENDIF
IF lShaiQ
   oColumn:block := &( "{||" + aData[1] + "}" )
   oColumn:heading := RTRIM(aData[2]) //AllTrim(aData[2])
   cTmpHead := oColumn:heading
  nPos := AT(";",cTmpHead)
  cTmpHead := If(nPos==0,cTmpHead,Substr(cTmpHead,1,nPos-1))
  cTmpField := aData[1]
  nPos := ASCAN(::cFileStructure,{|aVal| ALLTRIM(UPPER(aVal[1])) == ALLTRIM(UPPER(cTmpField)) })
  IF nPos > 0
     i := nPos
  ELSEIF i==NIL
      i := nLen
  ENDIF

  IF "(" $ aData[1]
   lFunc := TRUE
  ENDIF
  IF VALTYPE(oColumn:Block:Eval())=="C"
    oColumn:Width   := Max( Len(cTmpHead) , MAX(LEN(oColumn:Block:Eval()),IIF(Len(::cFileStructure) >= i,::cFileStructure[i,3] ,1 ) ))
  ENDIF

ELSE

IF "(" $ aData[1]
   oColumn:block := &( "{||" + aData[1] + "}" )
   oColumn:heading := AllTrim(aData[2])
   cTmpHead := oColumn:heading
   oColumn:Width   := Max( Len(cTmpHead) , lEN(oColumn:Block:Eval())) //::cFileStructure[i,3] )
   lFunc := TRUE
ELSE
   i := Val(aData[1])
   oColumn:heading := AllTrim(aData[2])
   cTmpHead := oColumn:heading
   nPos := AT(";",cTmpHead)
   cTmpHead := If(nPos==0,cTmpHead,Substr(cTmpHead,1,nPos-1))
   oColumn:Width   := Max( Len(cTmpHead) , ::cFileStructure[i,3] )
   oColumn:block   := ::Blockify( i )
   // oColumn:Width   := Max( Len(cTmpHead) , lEN(oColumn:Block:Eval())) //::cFileStructure[i,3] )
ENDIF
IF i==NIL
   i := nLen
ENDIF
ENDIF
   IF !lFunc .AND. ::cFileStructure[i,2]  == "N"    // type
      oColumn:picture := ::MakePicture( ::cFileStructure[i,3] , ::cFileStructure[i,4] )
      cTmpHead := oColumn:heading
      nPos := AT(";",cTmpHead)
      cTmpHead := If(nPos==0,cTmpHead,Substr(cTmpHead,1,nPos-1))
      oColumn:Width  := Max( Len(cTmpHead) , Len( oColumn:picture ) )
      ::nMaxLen := Max( oColumn:Width , ::nMaxLen )
   ELSEIF lFunc .and. ValType(oColumn:Block:Eval())=="N"
     oColumn:picture :=  ::MakePicture(Len(Str(oColumn:Block:Eval())),;
          IF(INT(oColumn:Block:Eval())==oColumn:Block:Eval(),0,2))
   ENDIF


RETURN oColumn


METHOD blockify( i )
// LOCAL nFieldLen := ::cFileStructure[i,3]
// LOCAL nFieldDec := ::cFileStructure[i,4]
// LOCAL cPicture
LOCAL cType     := ::cFileStructure[i,2]
LOCAL bBlock

DO CASE
   CASE cType == "C"
        bBlock := ;
              {;
               |xVal|;
                if(xVal=NIL,;
                    (::cFileName)->(FieldGet(i)),;
                    (::cFileName)->(FieldPut(i,xVal));
                  );
              }
   CASE cType == "L"
        bBlock := ;
              {;
               |xVal|;
                if(xVal=NIL,;
                    if( (::cFileName)->( FieldGet(i) ),"Y","N"),;
                    (::cFileName)->(FieldPut(i,xVal));
                  );
              }
   CASE cType == "D"
        bBlock := ;
              {;
               |xVal|;
                if(xVal=NIL,;
                    Dtoc( (::cFileName)->(FieldGet(i))),;
                    (::cFileName)->(FieldPut(i,xVal));
                  );
              }
   CASE cType == "N"
//        cPicture := ::MakePicture(nFieldLen , nFieldDec )
//                    Transform( (::cFileName)->(FieldGet(i)), cPicture ),;
        bBlock := ;
              {;
               |xVal|;
                if(xVal=NIL,;
                      (::cFileName)->(FieldGet(i)),;
                    (::cFileName)->(FieldPut(i,xVal));
                  );
              }


ENDCASE

RETURN bBlock


METHOD makePicture( nLen , nDec )
LOCAL nPicLen  := nLen + Int( (nLen-nDec-1) / 3)
LOCAL nDotPosition
LOCAL nCommaPosition
LOCAL nCommaCount  := Int( (nLen-nDec-1) / 3) , i
LOCAL cPicture

IF Empty( (nLen-nDec-1) % 3 )
   nPicLen--
   nCommaCount--
ENDIF

cPicture := Replicate ( "9" , nPicLen )

IF !Empty( nDec )
   nDotPosition := nPicLen - nDec
   cPicture := Stuff( cPicture , nDotPosition , 1,"." )
   nCommaPosition := nDotPosition - 1
ELSE
   nCommaPosition := nPicLen
ENDIF

IF nLen - nDec - 1 > 3
   FOR i:=1 TO nCommacount
       nCommaPosition -= 3
       cPicture := Stuff( cPicture , nCommaPosition , 1,"," )
       nCommaPosition--
   NEXT
ENDIF

RETURN cPicture


METHOD addDefaultCols()

// if parameter is empty generate table with all fields numbers 1,2,3...
IF Empty( ::aColPointers )
   ::aColPointers := Array( ( ::cFileName )->( Fcount() ) )
   Aeval( ::aColPointers , {|element , i | ::aColPointers[i] := i } )
ENDIF

// based on table now add the selected columns to the browse
Aeval( ::aColPointers ,;
       {|nPointer,i| ::oBro:addColumn( ::aColumns[IF(VALTYPE(nPointer)=="C",i,nPointer) ]) } )

RETURN self

METHOD getColumnPos( cHeading )
RETURN Ascan( ::aDataHeaders , {| cHeader | cHeading $ cHeader } )


METHOD ReScope(cNewSearcher)

::cSearcher := cNewSearcher

::oBro:gotopBlock   := {|| (::cFileName)->(Top(::cSearcher))            }
::oBro:gobottomBlock:= {|| (::cFileName)->(Bot(::cSearcher))            }
::oBro:skipBlock    := {|n|(::cFileName)->(SkipIt(n,::cSearcher,::bKey))}
(::cFileName)->( DBSEEK(::cSearcher) )
//::oBro:GoTop()
::oBro:Refreshall()

RETURN self

METHOD Re2Scope( cNewSearcher, cBotttomSearch )

LOCAL cBlock, bTempKey

::cSearcher := cNewSearcher
::cBottom  := cBotttomSearch

/*
::oBro:gotopBlock    :={|| (::cFileName)->(Top(::cSearcher))            }
::oBro:gobottomBlock :={|| (::cFileName)->(Bot(::cSearcher))            }
::oBro:skipBlock     :={|n|(::cFileName)->(SkipIt(n,::cSearcher,::bKey))}
IF !Empty( (::cFileName)->(IndexKey())  )
   ::bKey := COMPILE( (::cFileName)->(IndexKey()) )
ENDIF

*/
::oBro:gotopBlock   := {|| (::cFileName)->(Top(::cSearcher))          }
::oBro:gobottomBlock:= {|| (::cFileName)->(Bot(::cBottom))            }
::oBro:skipBlock    := {|n|(::cFileName)->(Skip2It( n, ::cSearcher, ::cBottom, ::bKey))}
IF !Empty( (::cFileName)->(IndexKey())  )
   ::bKey := COMPILE( (::cFileName)->(IndexKey()) )
END
DISPBEGIN()

(::cFileName)->( DBSEEK(::cSearcher, .T. ) )
::oBro:Refreshall()
::oBro:GoBottom()
::oBro:GoTop()
::oBro:Refreshall()
DISPEND()
RETURN self