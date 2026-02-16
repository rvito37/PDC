// userinfo.prg
// Function/Procedure Prototype Table  -  Last Update: 24-06-96 @ 15:09:13
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// Return Value         Function/Arguments
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// cRetDir + "\"        METHOD GetDirectory( cCategory )
// Upper( cProgId )...  METHOD canProcess( cProgId )
// nError               METHOD cancelUser()
// self                 METHOD close
// self                 METHOD init()
// Upper(cBuffer)       METHOD readMapFile
// NIL                  METHOD updateUserInRec( cFileName , cProgName, lNewRec )
// ::lOpened            METHOD xopen( lMode )

// G:\BMS\SOURCE\USERINFO.PRG

#include "avxdefs.ch"

CREATE CLASS UserInfo
HIDDEN:
       VAR lOpened

       METHOD readMapFile

VISIBLE:
       VAR cUserId
       VAR cGroupID
       VAR cWIPCardNo
       VAR cMapInfo
       VAR cDirectories
       VAR cDbfDir
       VAR cMapDir
		 VAR cPrnDir
       VAR cWipCostDir
       VAR cWipDelCostDir
       VAR cRouteDir
       VAR cRouteDeletedDir
       VAR cSValDir
       VAR cSValmvDir
       VAR cUserIni
       VAR cUserIniDir
       VAR aPrinters
       VAR aConnectionTable
       VAR nActivePrinter
       VAR cTempDir

       METHOD init
       METHOD xopen
       METHOD close
       METHOD getDirectory
       METHOD canProcess
       METHOD cancelUser
       METHOD GetPrinterArray
       METHOD GetDefaultPrinter
       METHOD ConnNum
       METHOD updateUserInRec
       METHOD LoadUserIni
       METHOD GetIniInfo

END CLASS

/**************************************************************************/
METHOD init()
       ::aConnectionTable   :=  fn_connID()
       ::cWIPCardNo         := "00000000EE00"//NNetStaId()
       ::cUserId            := IF(NNetWhoAmI()=="GUEST","LOCAL",NNetWhoAmI())
       *
       * ::cDirectories Œ SysDirs ‹…š š–„
       *
       ::cDirectories       := LoadDirs()
       ::cDbfDir            := ::getDirectory("DBF")
       ::cMapDir            := ::getDirectory("USERINFO")
       ::cWipcostDir        := ::getDirectory("WIPCOST")
       ::cWipDelCostDir     := ::getDirectory("WIPDELETED")
       ::cRouteDir          := ::getDirectory("ROUTE")
       ::cRouteDeletedDir   := ::getDirectory("ROUDELETED")
       ::cSValDir           := ::getDirectory("SVAL")
       ::cSValmvDir         := ::getDirectory("SVALMV")
       ::cUserIniDir        := ::getDirectory("USERINFO")
		 ::cPrnDir            := ::getDirectory("PRNOUT")
       *
       * D_user.cdx …‰ ’ D_user š‡‰š”
       *
       ::xopen()
       IF d_user->( DBSEEK(::cUserId) )
          ::cGroupId     := d_user->group_id
       ELSE
          ::cGroupId     := "ERROR"
       END
       ::cMapInfo     := ::readMapFile()
       *
       * ‰†„ •…—Œ „–‰‡ ™+š‘”ƒ ™ Œ‰‹„ .ini „ ˆ‘—ˆ„ •…— €– „ „–‰‡„
       *
       ::cUserIni     := ::LoadUserIni()
       *
       * Class:oUserInfo  ‰†„ •…—„ …—‰ ™ š–„
       *
       ::cTempDir     := ::GetIniInfo("TMPFILE")
       IF RIGHT(::cTempDir, 1) <> "\"
          ::cTempDir += "\"
       ENDIF
       IF Left(::cTempDir,1) == "\" .AND. .NOT. Left(::cTempDir,2) == "\\"
          ::cTempDir := Left(::cDbfDir,2) + ::cTempDir
       ENDIF
       ::GetPrinterArray()
       ::GetDefaultPrinter()

       ::close()
RETURN self

/**************************************************************************/
METHOD GetDirectory( cCategory )
LOCAL nAt , cRetDir

IF (nAt := Ascan( ::cDirectories , {| element| element[1] == Padr( cCategory, 10 )} )) > 0
   cRetDir := Alltrim(::cDirectories[nAt,2])
ELSE
   Alert( "ERROR;;" + cCategory +" not defined in SYSDIRS file" , {"Quit"} )
   QUIT
   cRetDir := ""
ENDIF

RETURN cRetDir + "\"


/**************************************************************************/
METHOD xopen( lMode )

DEFAULT lMode TO .T.

::lOpened := .T.
*
* ‰”…‘‰€ Loop  €‰„ ‡š” •…—„ € ‰‹ Œ„Œƒ „€Œ…Œ„ š€ ‰š‰‰™
*
WHILE  ( dbusearea( .T.,DBSETDRIVER(),(::cDbfDir+"d_user"),,lMode,.F.) , NetErr() )
    IF InKey() = K_ESC
       ::lOpened := .F.
    END
END

IF ::lOpened
   IF File( ::cDbfDir+"d_user.cdx" )
      d_user->( ordsetfocus( "d_user" ) )
   ELSE
       CheckIndexes("d_user","d_user","upper(user_id)",.T.)
   ENDIF
ENDIF

RETURN ::lOpened

/**************************************************************************/
METHOD close
 NETCLOSE d_user
 ::lOpened := .F.
RETURN self


/**************************************************************************/
METHOD readMapFile
LOCAL cBuffer  , cMapFile

IF d_user->( DbSeek( Padr( ::cUserId , 15 ) ) )

   IF File( cMapFile := ::cMapDir+Alltrim(d_user->progids)+".map" )
      cBuffer := MemoRead( cMapFile )
   ELSE
      cBuffer := ""
   ENDIF

ELSE
   cBuffer := ""

ENDIF
RETURN Upper(cBuffer)

/**************************************************************************/
METHOD canProcess( cProgId )
RETURN Upper( cProgId ) $  ::cMapInfo  .OR. IsAdMin()

/**************************************************************************/
METHOD cancelUser()
LOCAL lCanceled := .T.
LOCAL nError := 0

IF ::open(.F.)

   IF d_user->( DbSeek( Padr( ::cUserId , 15 ) ) )
      Ferase(::cMapDir+Alltrim(d_user->progids)+".map" )

      IF Ferror() != 0
         nError := 1
      ENDIF

      d_user->( DbDelete() )
      PACK

   ENDIF
   ::close()
ELSE
   nError := 2
ENDIF

RETURN nError


/**************************************************************************/
METHOD updateUserInRec( cFileName , cProgName, lNewRec )

DEFAULT lNewRec TO .F.


IF lNewRec
   (cFileName)->dadd_rec := Date()
  // (cFileName)->tadd_rec := LEFT( TIME(), 5 )
     IF (cFileName)->(FIELDPOS("tadd_rec") ) > 0  //cFileName $ "d_ordreq_d_ord"
          (cFileName)->tadd_rec := LEFT( TIME(), 5 )
     ENDIF
ENDIF
(cFileName)->dlu_rec  := Date()
(cFileName)->tlu_rec  := Time()
(cFileName)->ulu_rec  := ::cUserId
(cFileName)->wlu_rec  := ::cWIPCardNo
(cFileName)->plu_rec  := Upper( cProgName )

RETURN NIL

/**************************************************************************/
METHOD GetPrinterArray

LOCAL nSelect := SELECT()
LOCAL nByte, i

 ::aPrinters := {}

 USE D_groups EXCLUSIVE NEW
    LOCATE FOR D_groups->group_id == ::cGroupId
    IF Found()
       nByte := d_groups->prn_pos
       USE printers SHARED NEW
       WHILE !printers->( EOF() )
             IF SUBSTR( printers->groups, nByte, 1 ) == "1"
                AADD( ::aPrinters, { UPPER(printers->queue) } )
                AADD( ATAIL(::aPrinters), UPPER(printers->pr_name) )
                AADD( ATAIL(::aPrinters),;
                     IF( SUBSTR(printers->lanprinter, nByte,1) == "1",;
                        .T. , .F.) )
                FOR i := 6 TO printers->( FCOUNT() )
                   AADD( ATAIL(::aPrinters), ALLTRIM(printers->( FIELDGET(i)) ) )
                NEXT
                IF SUBSTR(printers->lanprinter, nByte,1) == "1"
                   AADD( ATAIL(::aPrinters), ALLTRIM(printers->lan_server) )
                END
             ENDIF
             printers->( DBSKIP() )
       END
       ::aPrinters := ASORT( ::aPrinters, NIL, NIL, {|x,y| x[2] <= y[2] } )
       CLOSE printers
    ELSE
       AADD( ::aPrinters, {"","",.F.} )
    ENDIF
    CLOSE d_groups
    SELECT (nSelect)
RETURN self

METHOD ConnNum()
RETURN ALLTRIM(STR(::aConnectionTable[1,2],0))+ALLTRIM(STR(::aConnectionTable[1,9],0))

/**************************************************************************/
METHOD LoadUserIni

IF !File( ::cUserIniDir+::cUserID+".ini")
   Alert( "ERROR;;"+::cUserID+".INI not found !", {"Quit"} )
   CLOSE DATABASES
   Quit
ENDIF

RETURN Upper( MemoRead( ::cUserIniDir+::cUserID+".ini" ) )

/******************************************************************/
METHOD GetIniInfo( cKeyword )

LOCAL nAtCrLf
LOCAL nAtKeyWord
LOCAL cBuffer := ""
LOCAL cRetDir

nAtKeyWord := At( UPPER(cKeyWord) , ::cUserIni )

IF !Empty( nAtKeyWord )
   cBuffer := SubStr( ::cUserIni , nAtKeyWord )
ENDIF

nAtCrLf := At( Chr(13)+Chr(10) , cBuffer )

IF !Empty( nAtCrLf )
   cBuffer := SubStr( cBuffer , 1 , nAtCrLf-1 )
ENDIF

nAtKeyWord := At( "=" , cBuffer )

IF !Empty( nAtKeyWord )
   cBuffer := Alltrim(SubStr( cBuffer  , nAtKeyWord+1 ))
ENDIF

RETURN cBuffer

/**********************************************************************/
METHOD GetDefaultPrinter

LOCAL cBuffer := UPPER( ::GetIniInfo( "PRINTER" ) )
LOCAL nAt := AT( ",", cBuffer )
LOCAL cQueue := ""
LOCAL cName  := ""

IF EMPTY( cBuffer )
   ::nActivePrinter := 1
ELSEIF nAt == 0  // he might have forgotten to add the comma
   cName :=  UPPER( ALLTRIM( cBuffer ) )
   ::nActivePrinter := ASCAN( ::aPrinters, {|e| ALLTRIM(e[2]) == cName  } )
ELSEIF  nAt == 1
   cName :=  UPPER( ALLTRIM( SUBSTR(cBuffer,2) ) )
   ::nActivePrinter := ASCAN( ::aPrinters, {|e| ALLTRIM(e[2]) == cName  } )
ELSE
   cQueue := UPPER( ALLTRIM( LEFT(cBuffer,nAt-1) ) )
   cName  := UPPER( ALLTRIM( SUBSTR( cBuffer, nAt+1, LEN(cBuffer)-nAt ) ) )
   ::nActivePrinter := ;
            ASCAN( ::aPrinters, {|e| ALLTRIM(e[1]) ==  cQueue .AND. ALLTRIM(e[2]) == cName } )
ENDIF

RETURN self