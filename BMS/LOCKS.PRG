// locks.prg
// Function/Procedure Prototype Table  -  Last Update: 24-06-96 @ 14:56:55
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// Return Value         Function/Arguments
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// Void                 PROCEDURE SetLockInfo( cDbfName , lOpenMode , lState )
// Void                 PROCEDURE WhoIsUsing
// AddRec( nWaitSec...  FUNCTION AddRec( nWaitSeconds )
// FilLock( nSeconds )  FUNCTION FilLock( nSeconds )
// NetUse( cDataBas...  FUNCTION NetUse( cDataBase, nSeconds,cDriver,lOpenMode,lNewWorkArea,cDir )
// RecLock( nSeconds )  FUNCTION RecLock( nSeconds )

/***
*
*  Locks.prg
*  Sample network functions to supplant USE, FLOCK(), RLOCK() and
*  APPEND BLANK.
*
*  Copyright, Nantucket Corporation, 1989, 1990
*
*  Compile as follows:
*
*         C>CLIPPER Locks /N /W /A /M
*/

#include "avxdefs.ch"
/***
*  AddRec( <nWaitSeconds> ) --> lSuccess
*  Attempt to APPEND BLANK with optional retry
*/

// ADDED 2nd PARAMETER 08-02-98 for new system field update system
FUNCTION AddRec( nWaitSeconds, cCallingProc )

LOCAL cAlias := ALIAS()
LOCAL lForever,lRestart:=.t.,nWaitTime
local cLockingUser := ""

DEFAULT nWaitSeconds TO 5
DEFAULT cCallingProc TO PROCNAME(1)

dbappend()

IF !neterr()
   // new system to ease programming. the system fields will be automatically
   // updated here instead of calling UpdateUserInRec() everywhere
   IF (cAlias)->(FIELDPOS("dlu_rec") ) > 0
       GetUserInfo():updateUserInRec( cAlias, cCallingProc, .T. )
   END
   RETURN (.T.)
ENDIF

lForever = (nWaitSeconds = 0)

WHILE lRestart
      nWaitTime:=nWaitSeconds
      WHILE (lForever .OR. nWaitTime > 0)
            DBAPPEND()
            IF .NOT. NETERR()
               RETURN .T.
            ENDIF
            INKEY(1)         // Wait 1/2 second
            nWaitTime--
      ENDDO
      cLockingUser := fn_whoami(ax_UserLockId())
      DEFAULT cLockingUser to ""
      lRestart:= ALERT("!!! ’‚˜‹ “‰‘…„Œ š‰ €Œ;"+cLockingUser+" ˜‡€ ™š™ Œ™ š…Œ‰’” —’; ;?š…™’Œ „",;
                 {" ?…™ “‰‘…„Œ š…‘Œ "," ?“‰‘…„Œ ‰Œ ‰‰‘Œ "}) = 1 // …™ š…‘Œ
END
RETURN (.F.)         // Not locked



/***
*  FilLock( <nWaitSeconds> ) --> lSuccess
*  Attempt to FLOCK() with optional retry
*/
FUNCTION FilLock( nSeconds )
LOCAL lForever,lRestart:=.t.,nWaitTime
local cLockingUser := ""

IF FLOCK()
     RETURN (.T.)      // Locked
ENDIF

lForever = (nSeconds = 0)

WHILE lRestart
     nWaitTime := nSeconds
     DO WHILE (lForever .OR. nWaitTime > 0)
          INKEY(1)         // Wait 1/2 second
          nWaitTime--
          IF FLOCK()
          RETURN (.T.)   // Locked
          ENDIF
     ENDDO
          cLockingUser := fn_whoami(ax_UserLockId())
          default cLockingUser to ""
          lRestart:= alert("!!! ’‚˜‹ “‰‘…„Œ š‰ €Œ;"+cLockingUser+"˜‡€ ™š™ Œ™ š…Œ‰’” —’; ;?š…™’Œ „",;
                    {" ?…™ “‰‘…„Œ š…‘Œ "," ?“‰‘…„Œ ‰Œ ‰‰‘Œ "}) = 1 // …™ š…‘Œ

//         lRestart:= alert("!š‰ƒ’Œ •…— ™š™„Œ š‰ €Œ;˜‡€ ™š™ ‰ƒ‰ Œ’ ™…”š •…—„; ;?š…™’Œ „",;
//                    {" ?…™ ™š™„Œ š…‘Œ "," ?‰‰‘Œ "}) = 1 // …™ š…‘Œ
END
RETURN (.F.)         // Not locked



/***
*  NetUse( cDataBase, nSeconds,lOpenMode,lNewWorkArea,cDir )   --> lSuccess
*  Attempt to USE a database file with optional retry
*
*
*    params
*         1. cDataBase    - name of dbf
*         2. nSeconds     - time to try
*         3. lOpenMode    - .t. SHARED , .f. EXCLUSIVE
*         4. lNewWorkArea - whether new work area needed
*         5. lRonly       - READONLY MODE
*         6. cDir         - Directory to Open
*         7. cAlias       - Alias to Open
*
*/
FUNCTION NetUse( cDataBase, nSeconds,cDriver,lOpenMode,lNewWorkArea,cDir,cAlias,lDirectory,cTag )
*
LOCAL lForever,lRestart:=.t.,nWaitTime
LOCAL cDbfDir
LOCAL nAlert
local cLockingUser, aLockingUser := {"",Nil}, nLock
IF( cDir == NIL, cDbfDir := GetUserInfo():cDbfDir, cDbfDir := cDir )
cDriver := IIF(Left(cDbfDir,2) $ "C:" , "DBFCDX" , "DBFCDXAX" ) //vr 18-11-02
IF( lNewWorkArea == NIL, lNewWorkArea := .T.     , NIL )
IF( lOpenMode    == NIL, lOpenMode    := .T.     , NIL )
IF( nSeconds     == NIL, nSeconds     := 5       , NIL )
IF( cDriver      == NIL, cDriver := GetMyDriver(), NIL )

lForever := (nSeconds = 0)

WHILE lRestart
      nWaitTime := nSeconds

      WHILE (lForever .OR. nWaitTime > 0)


            IF (SELECT(cDataBase) == 0).OR. (SELECT(cDataBase)!= 0 .AND. SELECT(cAlias) == 0)     // .AND. cAlias == NIL) .OR. SELECT(cAlias) == 0   changed by
               IF Empty(lDirectory)
                  DBUSEAREA( lNewWorkArea, cDriver, (cDbfDir+cDataBase), cAlias, lOpenMode, .f.)
               ELSE
                  DBUSEAREA( lNewWorkArea, cDriver, (cDataBase), cAlias, lOpenMode, .f.)
               ENDIF
            ELSE                                                 //vr
               SELECT Select(cDataBase)
            ENDIF
            IF !NetErr()          // USE succeeds
               //SetLockInfo( cDataBase , lOpenMode , .T. )  // save lock info in flocklst vitaly
// No Need to use flocklst.dbf anymore.
// This saves tons of available disk space for this useless DATA
// D.Laor May 24th 2001
					IIF( !Empty(cTag),ordsetfocus(cTag) ,nil )//VR 29-08-02 because i ,sometime, want to get opened dbf with specify index
               RETURN (.T.)
            ENDIF
            INKEY(1)                 // Wait 1 second
            nWaitTime--
      ENDDO
      ALERT("axs lock:"+iif(ax_axslocking(),"true","false")+;
               ";"+cDatabase+" locked status:"+iif(ax_isflocked(cDatabase),"true","false")+;
               ";userid :"+str(ax_userlockid(cDatabase)))
      aLockingUser := AX_LockOwner(cDataBase+".dbf",,@nLock)


      IF nLock > 1  //not locked
         cLockingUser := aLockingUser[1]
         IF empty(cLockingUser)
            ALERT("An error occured retrieving the locking users's name;"+;
                     "Error:" +str(AX_error()))
         ENDIF
      ENDIF
      DEFAULT cLockingUser to ""
      nAlert := Alert("! •…— ™š™„Œ š‰ €Œ;"+cLockingUser+" ˜‡€ ™š™ ‰ƒ‰ Œ’ ™…”š •…—„; ;?š…™’Œ „",;
                {" ?…™ ™š™„Œ š…‘Œ "," ?‰‰‘Œ "})  // …™ š…‘Œ

      DO CASE
         CASE nAlert = 1
              lRestart:= .T.
         CASE nAlert = 2 .OR. nAlert = 0
              SETCOLOR("w/n")
              SETCURSOR(1)
              CLS
              QUIT
              lRestart:= .F.
      ENDCASE
END
RETURN (.F.)                // USE fails



/***
*  RecLock( <nWaitSeconds> ) --> lSuccess
*  Attempt to RLOCK() with optional retry
*/
FUNCTION RecLock( nSeconds, cProc, lUpdate )

   LOCAL lForever,lRestart:=.t.,nWaitTime
   LOCAL cAlias := ALIAS()
   local cLockingUser := ""

   DEFAULT cProc    TO PROCNAME(1)
   DEFAULT lUpdate  TO .T.
   DEFAULT nSeconds TO 0

   lForever = (nSeconds = 0)

   WHILE lRestart
       nWaitTime:=nSeconds
       DO WHILE (lForever .OR. nWaitTime > 0)
          IF (cAlias)->(RLOCK())
             IF lUpdate .AND. (cAlias)->(FIELDPOS("plu_rec") ) > 0
                 GetUserInfo():updateUserInRec( cAlias, cProc, .F. )
             END
             RETURN (.T.)     // Locked
          ENDIF
          INKEY(1)           // Wait 1/2 second
          nWaitTime--
       ENDDO
      default cLockingUser to ""
      alert("axs lock:"+iif(ax_axslocking(),"true","false") + ;
          ";"+ cAlias + "is locked:" + iif(ax_isflocked(cAlias),"true","false") + ;
          "; userid :" + str(ax_userlockid(cAlias)))
      cLockingUser := fn_whoami(ax_UserLockId())
      lRestart:= alert("!!! ’‚˜‹ “‰‘…„Œ š‰ €Œ;"+cLockingUser+" ˜‡€ ™š™ Œ™ š…Œ‰’” —’; ;?š…™’Œ „",;
                 {" ?…™ “‰‘…„Œ š…‘Œ "," ?“‰‘…„Œ ‰Œ ‰‰‘Œ "}) = 1 // …™ š…‘Œ
//      lRestart:= alert("!…† „…™˜ ‹ƒ’Œ š‰ €Œ;˜‡€ ™š™ ‰ƒ‰ Œ’ ™…”š •…—„; ;?š…™’Œ „",;
//                 {" ?…™ ‹ƒ’Œ š…‘Œ "," ?‹ƒ’Œ ‰Œ ‰‰‘Œ "}) = 1 // …™ š…‘Œ
   END
RETURN (.F.)           // Not locked


PROCEDURE SetLockInfo( cDbfName , lOpenMode , lState )
// LOCAL nSelect := Select(Alias())
LOCAL o
LOCAL cDbfDir
LOCAL cUserId
//YG 14.9.98 LOCAL aNoLocks := {"USERS","FLOCKLIST","D_USERS","D_RIGHTS","D_GROUPS"}
LOCAL aNoLocks := {"USERS","FLOCKLIST","D_USER","D_RIGHTS","D_GROUPS"}

cDbfName := Upper( cDbfName )

IF  ASCAN( aNoLocks, UPPER(cDbfName) ) > 0
   RETURN
ENDIF

o := GetUserInfo()
cDbfDir := o:cDbfDir
cUserId := o:cUserId

IF flocklst->( DbSeek( Padr(cDbfName,8 ) + cUserId ) )
   WHILE !flocklst->( Rlock() ) ; ENDDO
ELSE
   IF lState
      WHILE  ( flocklst->(DbAppend()) , NetErr() ) ; ENDDO
      flocklst->filename   := cDbfName
      flocklst->username   := cUserId
   ENDIF
ENDIF

IF lState  // open
   flocklst->lockdate   := Dtoc( date() )
   flocklst->locktime   := Time()
   flocklst->wid        := o:cWIPCardNo
   flocklst->lockstate  := if( lOpenMode , "S" , "E" )
ELSE   // close
   flocklst->lockdate   := Space( 8 )
   flocklst->locktime   := Space( 8 )
   flocklst->wid        := Space( 12 )
   flocklst->lockstate  := " "
ENDIF

flocklst->( DbUnLock() )

RETURN


PROCEDURE WhoIsUsing
LOCAL nSelect := Select(Alias())
LOCAL cDbfDir := GetUserInfo():cDbfDir

scrnPush()

//USE (cDbfDir+"flocklst") NEW SHARED ADVANTAGE
   NetUse("flocklst" , 5 ,  ,,,cDbfDir )

flocklst->( ordSetfocus( "filedate" ) )

flocklst->( DbEdit() )

flocklst->( DbCloseArea() )

scrnPop()

RETURN

// YG 24.12.98
FUNCTION ActLock(nWaitSeconds, cAct, cCallingProc,lForever)

LOCAL cAlias := ALIAS()
LOCAL lRestart:=.t.,nWaitTime, lCloseit := .F.
local lRetVal := .F.
LOCAL cTempDir := GetUserInfo():cTempDir
local nSelect := select()
local lfirstPass := .T.
LOCAL cKindOfMessage

DEFAULT nWaitSeconds TO 5
DEFAULT cCallingProc TO PROCNAME(1)
default lForever to .F.

DO CASE
     CASE cAct == "INVOICING"
          cKindOfMessage := "!!! ’‚˜‹ š…‰…™‡ €‰–…„Œ š‰ €Œ;"
     CASE cAct == "R&D USING AVXENG"
          cKindOfMessage := [!!! ’‚˜‹ ”"… ‰…š‰ Œ…ƒ…Œ ‘‹‰„Œ š‰ €Œ;]
     CASE cAct == "R&D USING ORDERS"
          cKindOfMessage := [!!! ’‚˜‹ ”"… š…†„ Œ…ƒ…Œ ‘‹‰„Œ š‰ €Œ;]
ENDCASE

IF SELECT("control") == 0
     NetUse( "control", STD_RETRY, RDD_IN_USE,USE_SHARED, , NIL )
     lCloseIt := .T.
ELSE
     CONTROL->(DBCLOSEAREA())
     NetUse( "control", STD_RETRY, RDD_IN_USE,USE_SHARED, , NIL )
     lCloseIt := .F.
ENDIF
select control
control->(dbgotop())
LOCATE FOR trim(control->item) == cAct
if control->(found())
   WHILE lRestart
      nWaitTime:=nWaitSeconds
      WHILE (lForever .OR. nWaitTime > 0)
               //MEANING: allow if info says "I am not in use" or if the date
               //of the previous 'lock' wasn't today or the previous lock was
               //over t'en minutes ago
               //the above was canceled - nice try
              IF control->(rLock())
                    control->(recLock(5,"ACTLOCK"))
                    control->info := "I am in use"
                    control->slu_rec := seconds()
                    CONTROL->(DBCOMMIT())
                    lRestart := .F.
                    lRetVal  := .T.
                    exit
              else
                   INKEY(1)         // Wait 1/2 second
                   nWaitTime--
                   lRestart:= alert(cKindOfMessage+trim(CONTROL->ULU_REC)+" ™š™ Œ™ š…Œ‰’” —’; ;?š…™’Œ „",;
                                     {" ? …™ š…‘Œ "," ? ‰‰‘Œ "}) = 1 // …™ š…‘Œ
                   IF !lRestart
                              lRetVal := .F.
                              exit
                   ENDIF
              endif
      END
   END
else
     alert(cAct+" wasn't found in Control.dbf.  Please contact MIS")
endif
/*
   lForever = (nWaitSeconds = 0)
   WHILE lRestart
      nWaitTime:=nWaitSeconds
      DO WHILE (lForever .OR. nWaitTime > 0)
*/
//IF !lRetVal .AND. lCloseIt
select ( nSelect )
IF lCloseIt .AND. !lRetVal
     control->(dbclosearea())
ENDIF

RETURN lRetVal

********************
function actUnLock(cAct)
local lCloseIt := .F.
IF SELECT("control") == 0
     NetUse( "control", STD_RETRY, RDD_IN_USE,USE_SHARED, , NIL )
     lCloseIt := .T.
ELSE
     CONTROL->(DBCLOSEAREA())
     NetUse( "control", STD_RETRY, RDD_IN_USE,USE_SHARED, , NIL )
     lCloseIt := .F.
ENDIF
control->(dbgotop())
LOCATE FOR trim(control->item) == cAct
IF control->(found()) .AND. control->(rlock())
     IF trim(CONTROL->ULU_REC) == trim(GetUserInfo():cUserId) //.AND. control-
          control->(reclock(5,"ACTUNLOCK"))
          control->info := "I am not in use"
     ENDIF
     control->(dbunlock())
endif
IF lCloseIt
    control->(dbclosearea())
ENDIF
return NIL