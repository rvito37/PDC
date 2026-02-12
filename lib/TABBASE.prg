/*
 * ÚÄ Program ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³  Application: AVXBMS                                                     ³
 * ³    File Name: TABBASE.PRG                                                ³
 * ³  Description:                                                            ³
 * ³             :                                                            ³
 * ³             :                                                            ³
 * ³             :                                                            ³
 * ³       Author: Shalom LeVine         Tester:                              ³
 * ³ Date created: 07-02-96              Date updated: ş07-02-96              ³
 * ³ Time created: 03:58:56pm            Time updated: ş03:58:56pm            ³
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

// tabbase.prg
// Function/Procedure Prototype Table  -  Last Update: 24-06-96 @ 15:08:16
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// Return Value         Function/Arguments
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// self                 METHOD close
// self                 METHOD init( cFileName , aIndexList )
// self                 METHOD setIndexList
// self                 SETORDER( cOrder )
// self                 ResetOrder()
// lOpened              METHOD xopen( cDirectory , lMode , cRdd )

// G:\BMS\SOURCE\BASETAB.PRG

#include "avxdefs.ch"


/*
 * ÚÄ Class ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: TabBase                                                    ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 07-02-96              Date updated: ş07-02-96              ³
 * ³ Time created: 03:59:02pm            Time updated: ş03:59:02pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³ Parent class: None                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
CREATE CLASS TabBase

VISIBLE:
       VAR lWasOpened
       VAR cFileName
       VAR cFileStructure
       VAR aIndexList
       VAR aIndexCaptions
       VAR nLastOrder     // So I can ResetOrder to a previous
       VAR nPresentOrder  // order without keeping explicit track of it
       VAR cAlias
       VAR nIndexPointer

       METHOD init
       METHOD setIndexList
       METHOD SetOrder
       METHOD ResetOrder
       METHOD xopen
       METHOD xopenTemp
       METHOD close

END CLASS


/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: init()                                                     ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 07-02-96              Date updated: ş07-02-96              ³
 * ³ Time created: 03:59:05pm            Time updated: ş03:59:05pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: cFileName                                                  ³
 * ³             : aIndexList                                                 ³
 * ³ Return Value: self                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD init( cFileName , aIndexList )
       ::cFileName      := cFileName
       ::aIndexList     := aIndexList
       ::aIndexCaptions := {}
       ::nLastOrder     := 0
       ::nPresentOrder  := 0

RETURN self


/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: SetOrder()                                                 ³
 * ³  Description: Enhanced DBSETORDER() replacement, keeps track of          ³
 * ³               previous index order                                       ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 07-02-96              Date updated: ş07-02-96              ³
 * ³ Time created: 04:08:41pm            Time updated: ş04:08:41pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: nOrder                                                     ³
 * ³ Return Value: self                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD SetOrder( cOrder )

LOCAL nOrder := ASCAN( ::aIndexList, {|x| UPPER(x) == UPPER(cOrder)} )

       ::nLastOrder    := ::nPresentOrder
       ::nPresentOrder := nOrder
       (::cFileName)->( ORDSETFOCUS( cOrder ) )  //VR

       ::nIndexPointer := nOrder

RETURN .T.

/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: ResetOrder                                                 ³
 * ³  Description: used in conjunction with ::SetOrder()  to reset the        ³
 * ³               index order to the order saved in ::nLastOrder             ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 07-02-96              Date updated: ş07-02-96              ³
 * ³ Time created: 04:08:38pm            Time updated: ş04:08:38pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: self                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD ResetOrder

LOCAL nOrder

       (::cFileName)->( ORDSETFOCUS( ::nLastOrder ) )//VR DBSETORDER
         nOrder        := ::nLastOrder
       ::nLastOrder    := ::nPresentOrder
       ::nPresentOrder := nOrder

RETURN self

/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: xopen()                                                    ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 07-02-96              Date updated: ş07-02-96              ³
 * ³ Time created: 04:11:06pm            Time updated: ş04:11:06pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: cDirectory                                                 ³
 * ³             : lMode                                                      ³
 * ³             : cRdd                                                       ³
 * ³ Return Value: lOpened                                                    ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD xopen( cDirectory , lMode , cRdd )
LOCAL cDbfDir
LOCAL lOpened
LOCAL i , nLen


DEFAULT lMode TO .T.

IF cDirectory = NIL
   IF GetUserInfo() == NIL
      cDbfDir := ""
	ELSEIF "\" $ ::cFileName//VERY IMPORTANT FROM VR
      cDbfDir := SubStr(::cFileName,1,rat("\",::cFileName))
      ::cFileName := SubStr(::cFileName,rat("\",::cFileName)+1)
   ELSe
      cDbfDir := GetUserInfo():cDbfDir
   ENDIF
ELSE
   cDbfDir := cDirectory
ENDIF

::lWasOpened := lOpened := !Empty( Select( ::cFileName ) )  // if the file is open

IF  !lOpened
    lOpened := NetUse( ::cFileName,5,cRdd,lMode,,cDbfDir)
    ::lWasOpened := .F.
ENDIF

// open index list
IF lOpened
   ::cFileStructure := ( ::cFileName )->( DbStruct() )
ENDIF
IF !Empty( ::aIndexList )
   (::cFileName)->( ordsetfocus( ::aIndexList[1] ) )
ENDIF

RETURN lOpened
/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: xopentemp()                                                ³
 * ³  Description: Open Temporary Dbfs that sit in the user's Temp Dir        ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 07-02-96              Date updated: ş07-02-96              ³
 * ³ Time created: 04:11:06pm            Time updated: ş04:11:06pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: cDirectory                                                 ³
 * ³             : lMode                                                      ³
 * ³             : cRdd                                                       ³
 * ³ Return Value: lOpened                                                    ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD xopenTemp( cDirectory , lMode , cRdd )
LOCAL cDbfDir
LOCAL lOpened
LOCAL i , nLen


DEFAULT lMode TO .T.

// here is the major change from the Xopen() method; the path to the TEMP dir
IF cDirectory = NIL
   cDbfDir := GetTempFileDir()
ELSE
   cDbfDir := cDirectory
ENDIF

::lWasOpened := lOpened := !Empty( Select( ::cFileName ) )  // if the file is open

IF  !lOpened
    IF LEFT( cDbfdir, 1 ) $ "CD"
       cRdd := "DBFCDX"
    END
    lOpened := NetUse( ::cFileName,5,cRdd,lMode,,cDbfDir)
    ::lWasOpened := .F.
ENDIF

// open index list
IF lOpened
   ::cFileStructure := ( ::cFileName )->( DbStruct() )
   IF !Empty( ::aIndexList )
       ( ::cFileName )->( DbClearIndex() )
      //nLen := Len( ::aIndexList )
      Aeval( ::aIndexList ,;
            {| element | (::cFileName)->( ordsetfocus( element ) ) } )
   ENDIF
ENDIF

RETURN lOpened

/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: close                                                      ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 07-02-96              Date updated: ş07-02-96              ³
 * ³ Time created: 03:59:12pm            Time updated: ş03:59:12pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: self                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD close
IF !::lWasOpened
   NETCLOSE ( ::cFileName )
ENDIF
RETURN self

/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: setIndexList                                               ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 07-02-96              Date updated: ş07-02-96              ³
 * ³ Time created: 03:59:18pm            Time updated: ş03:59:18pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: self                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD setIndexList
LOCAL nPosition , aTemp
LOCAL aIndexBuffer := GetFileIndexInfo( ::cFileName )

// create index list
::aIndexList  := {}
::aIndexCaptions := {}

Aeval(  aIndexBuffer , ;
        { | aIndexLine |;
            Aadd( ::aIndexList , aIndexLine[3] ) ,;
            Aadd( ::aIndexCaptions , left(trim(aIndexLine[4])+" KEY: "+trim(aIndexLine[2]),78)) ;
        } ;
     )

::nPresentOrder  := IF( !EMPTY(::aIndexList), 1, 0 )


RETURN self

/*************************** EOF TABBASE.PRG *****************************/