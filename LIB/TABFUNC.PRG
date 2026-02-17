// tabfunc.prg
// Function/Procedure Prototype Table  -  Last Update: 24-06-96 @ 15:08:20
// 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
// Return Value         Function/Arguments
// 컴컴컴컴컴컴컴컴컴�  컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
// Void                 PROCEDURE ResetColumns( o , aCols )
// Void                 PROCEDURE SetLUNextField( o , xValue )
// Void                 PROCEDURE TableSelect( cTableName , bSelectBlock , aDefaultCols , bMoreApplyKeys )
// AllTrim( xRetVal )   FUNCTION CodeToName( o , cTableName , bGet)
// .T.                  FUNCTION SetF2Key( o , cFile , aDefaultCols )
// cItem                FUNCTION TransGet( cFileName , bSearch , bTransItem , o, xState)


// G:\BMS\SOURCE\TABFUNC.PRG

#include "avxdefs.ch"



PROCEDURE TableSelect( cTableName , bSelectBlock , aDefaultCols ,;
                       bMoreApplyKeys, aSkips, lF2Win, cIndex, lAltS,;
                       aHeaders, cFieldVal, cSeekField,cDatFile )
LOCAL oTable
LOCAL nOldOrder


oTable := TabSelect():new( cTableName , aDefaultCols , bSelectBlock , lAltS, aHeaders, {cIndex},cDatFile)

IF cIndex <> NIL
   oTable:Setorder(cIndex)
ENDIF

nOldOrder := (cTableName)->( IndexOrd() )

oTable:oForm :=  Form():new(4,1,16,77, " Select from:"+cTableName+" " ,"w+/b", ProcName() )

IF cIndex <> NIL
   oTable:Setorder(cIndex)
ENDIF

oTable:createBrowse():addDefaultCols()


// ADDED 14-11-96 along with the aSkips parameter, to allow scoped browsing
IF aSkips <> NIL
   (cTableName)->( DBSEEK(cFieldVal))
   oTable:oBro:GoTopBlock    := aSkips[1]
   oTable:oBro:GoBottomBlock := aSkips[2]
   oTable:oBro:SkipBlock     := aSkips[3]
ENDIF

oTable:ApplyBlock := bMoreApplyKeys

// position the pointer in the table to the current value in a get field
// by index if file is indexed
// by locate if not
IF cSeekField <> NIL
   oTable:xSeekKey := cSeekField
ELSEIF GetActive() <> NIL
   oTable:xSeekKey := GetActive():buffer
ELSEIF cFieldVal <> NIL
   oTable:xSeekKey := cFieldVal
ELSE
    oTable:xSeekKey := ""
END
// added 3rd parameter, lF2Win to remove F1 access if it is a picklist window
oTable :process(NIL,NIL, lF2Win)
oTable :oform:hide()

IIF(nOldOrder <> 0 ,(cTableName)->( DbSetOrder( nOldOrder ) ) ,nil )

oTable :close()

IF LastKey() = K_ENTER
  KEYBOARD Chr(13)
ENDIF

RETURN

/******************************************************************/
FUNCTION SetF2Key( o , cFile , aDefaultCols, bBlock, aSkips,;
                   cIndex, lAltS, aHeaders, cFieldVal, nField2Get, cSeekField,cDatFile )

//DEFAULT cIndex    TO ""
DEFAULT lAltS     TO .T.
DEFAULT aHeaders  TO {}
DEFAULT cFieldVal TO ""

DEFAULT bBlock TO {|| o:varPut( (cFile)->(FieldGet(1))),o:Changed := .T. }

// new, added 8/6/97 by shalom, along with the new 10th parameter
IF nField2Get <> NIL
   bBlock := {|| o:varPut( (cFile)->(FieldGet(nField2Get))),o:Changed := .T. }
ENDIF

SetKey( K_F2 , ;
        {|| TableSelect( cFile, bBlock , aDefaultCols, NIL, aSkips, TRUE,;
                         cIndex, lAltS, aHeaders, cFieldVal, cSeekField,cDatFile) } )
RETURN .T.

/******************************************************************/
FUNCTION TransGet( cFileName , bSearch , bTransItem , o, xState)
LOCAL oTab , cItem
LOCAL nRow := Row() , nCol := Col()
LOCAL nOldSelect := Select(Alias())


   oTab := TableTranslate():new( cFileName , ;
                                bSearch  )
   oTab:setIndexList()

   IF oTab:xopen() .AND. oTab:search()
      cItem := bTransItem:eval()
   ELSE
      cItem := Space( Len( bTransItem:eval() ) )
   END

   IF xState = NIL
      QQout( " " + cItem )
   ENDIF

   oTab:close()

SELECT (nOldSelect)

RETURN  cItem


/*
ADDED 31-10-96 by Shalom: nWhich parameter, to make possible to change
                          any other GET, not just the next one
*/
PROCEDURE SetLUNextField( o , xValue, nWhich )

LOCAL nPosition

DEFAULT nWhich TO 1

nPosition := CurrentGet()

GetList[nPosition+nWhich]:varPut(  xValue  )
GetList[nPosition+nWhich]:display()

RETURN


/******************************************************************/
PROCEDURE ResetColumns( o , aCols )
LOCAL i  , nLen := Len( aCols )

FOR i := o:colCount TO 1 STEP -1
    o:delColumn( i )
NEXT

FOR i := 1 TO nLen
    o:addColumn( aCols[i] )
NEXT

o:configure()
o:refreshAll()
o:goTop()

RETURN


/******************************************************************/
FUNCTION CodeToName( o , cTableName , bGet)
LOCAL xVal := o:getColumn( o:colPos):block:eval()   // get current value in cell
LOCAL oTab
LOCAL cTabName
LOCAL cFieldName
LOCAL nPointPos  := At( "." , cTableName )
LOCAL xRetVal    := ""
LOCAL Cond

IF Empty( nPointPos )
   Cond := {|| xVal }
ELSE

// cTable name contain  <file name.keyname> (e.g.  c_esny.esny_id )
   cFieldName := SubStr( cTableName , nPointPos + 1 )
   cTableName := Left( cTableName , nPointPos - 1 )
   Cond := {|| &(cFieldName) == xVal }
END

oTab := TableTranslate():new( cTableName , Cond )

IF oTab:xopen() .AND. oTab:search()
   xRetVal := oTab:getValue( bGet )
ENDIF

oTab:close()

RETURN AllTrim( xRetVal )