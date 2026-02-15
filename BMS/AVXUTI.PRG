#include "avxdefs.ch"

#define DBS_VAL 5
///////////////FUNCTIONS FOR FILE&INDEX UTILITIES////////////////

STATIC aoOpenedList
STATIC nVat


/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: deleteRandomFiles()   Docs: Yaacov Greenstein              ³
 * ³  Description: for deleteing random file names that are getting added     ³
 * ³       Author: Yaacov Greenstein                                          ³
 * ³ Date created: 04-05-98              Date updated: þ04-05-98              ³
 * ³ Time created: 12:42:35pm            Time updated: þ12:42:35pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: nil                                                        ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
function deleteRandomFiles()

LOCAL cTempDir := GetUserInfo():cTempDir
local cDosCommand, cScr

//cScr := savescreen()
//    Change by Shai 3.6.98 changed back by YG 18.6.98 - erasing in wrong directory
/*
cDosCommand :=  "del "+ cTempDir +"1*.*"
run (cDosCommand)
cDosCommand :=  "del "+ cTempDir +"2*.*"
run (cDosCommand)
cDosCommand :=  "del "+ cTempDir +"3*.*"

run (cDosCommand)
cDosCommand :=  "del "+ cTempDir +"4*.*"
run (cDosCommand)
cDosCommand :=  "del "+ cTempDir +"5*.*"
run (cDosCommand)
cDosCommand :=  "del "+ cTempDir +"6*.*"
run (cDosCommand)
cDosCommand :=  "del "+ cTempDir +"7*.*"
run (cDosCommand)
cDosCommand :=  "del "+ cTempDir +"8*.*"
run (cDosCommand)
cDosCommand :=  "del "+ cTempDir +"9*.*"
run (cDosCommand)
*/

cDosCommand :=   "0*.*"
MyFerase(cDosCommand,cTempDir)
cDosCommand :=   "1*.*"
MyFerase(cDosCommand,cTempDir)
cDosCommand :=   "2*.*"
MyFerase(cDosCommand,cTempDir)
cDosCommand :=   "3*.*"
MyFerase(cDosCommand,cTempDir)
cDosCommand :=   "4*.*"
MyFerase(cDosCommand,cTempDir)
cDosCommand :=   "5*.*"
MyFerase(cDosCommand,cTempDir)
cDosCommand :=  "6*.*"
MyFerase(cDosCommand,cTempDir)
cDosCommand :=   "7*.*"
MyFerase(cDosCommand,cTempDir)
cDosCommand :=   "8*.*"
MyFerase(cDosCommand,cTempDir)
cDosCommand :=   "9*.*"
MyFerase(cDosCommand,cTempDir)


//RESTSCREEN(,,,,cScr)

return nil
/////////////////////////////////////////////////////////////
Function MyFerase(cPattern,cTempDir)        //s.b
LOCAL aDir

aDir := DIRECTORY(cTempDir+cPattern)
AEVAL(aDir, { |aFile|FERASE(cTempDir+aFile[F_NAME]) })

RETURN .t.
////////////////////////////////////////////////////////////////
/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: deleteTempFiles()   Docs: Yaacov Greenstein                ³
 * ³  Description: for deleteing random file names that are getting added     ³
 * ³       Author: Yaacov Greenstein                                          ³
 * ³ Date created: 04-05-98              Date updated: þ04-05-98              ³
 * ³ Time created: 12:42:35pm            Time updated: þ12:42:35pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: nil                                                        ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
function deleteTempFiles(aFileNames)

LOCAL cTempDir := GetUserInfo():cTempDir
local cDosCommand,j,i,cScr

j = len(aFileNames)
cScr := savescreen()
FOR i := 1 TO j
//     cDosCommand :=  "del " + cTempDir + aFilenames[i] + "*.dbf"
     cDosCommand :=  aFilenames[i] + "*.dbf"
//     run (cDosCommand)
     myferase(cDosCommand,cTempDir)
     cDosCommand :=  aFilenames[i] + "*.cdx"
     // run (cDosCommand)
    myferase(cDosCommand,cTempDir)
NEXT
RESTSCREEN(,,,,cScr)

return nil
//////////////////////////////////////////////////////////////
/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: genOpenFiles()        Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Danny Hazan                                                ³
 * ³ Date created: 06-25-96              Date updated: þ06-25-96              ³
 * ³ Time created: 02:19:04pm            Time updated: þ02:19:04pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: aFileList                                                  ³
 * ³ Return Value: aoOpenedList                                               ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION genOpenFiles( aFileList,lMode )

LOCAL i , nLen := Len( aFileList )
LOCAL oTab

aoOpenedList := {}
*
* oTab  „Œ™ ‰‘—ƒ‰€„ …™‰˜… (Rpqc##V#.prg ) oRep:SetDb  ‰Ž…™˜„ ‰–—„ Œ‹ š‡‰š”
*
FOR i := 1 TO nLen
     // REMOVED the IF..ENDIF 14-11-96, as a test, Shalom
    IF Empty( Select( aFileList[i] ) )
       oTab := TableTranslate():new( aFileList[i] )
       *
       * aIndexList :Instance  ˜…š„ •…—Œ Tags „ š…Ž™ š–„
       *
       oTab:setIndexList()
       *
       *.cFileStru :Instance  …Œ™ Structure„ š–„… …‰Ž„ •…— + ‰™€˜„ •…—„ š‡‰š”
       *
       IF oTab:xopen( ,lMode, )
          Aadd( aoOpenedList , oTab )
       ELSE
          Aadd( aoOpenedList , NIL )
       ENDIF
    ENDIF
NEXT

RETURN aoOpenedList
////////////////////////////////////////////////////////////
/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: genCloseFiles()       Docs: Shalom LeVine                  ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 08/03/98              Date updated: þ08/03/98              ³
 * ³ Time created: 17:24:33              Time updated: þ17:24:33              ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: aFileList                                                  ³
 * ³ Return Value: NIL                                                        ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION genCloseFiles( aFileList )

LOCAL i , nLen := Len( aFileList )
LOCAL oTab



FOR i := 1 TO nLen
       If VALTYPE(aFileList[i]) =="O"
        oTab := aFileList[i]
        (oTab:cFileName )->(DBCLOSEAREA())
       ELSE
       ( aFileList[i] )->(DBCLOSEAREA())
       ENDIF
NEXT

RETURN NIL
//////////////////////////////////////////////////////
function CheckIndexes(DBAliasName,DBIndexName,DBKey,lReIndex,cFor,lUni)
LOCAL nOldArea := SELECT()
LOCAL aTagsInfo,i
IF !(FILE(DBAliasName)) .OR. (lReIndex)
       IF !Empty(lUni)
          IF !Empty(cFor)
              INDEX ON &DBKey TAG (DBAliasName) TO (DBIndexName) FOR &cFor UNIQUE
          ELSE
              INDEX ON &DBKey TAG (DBAliasName) TO (DBIndexName)  UNIQUE
          ENDIF
       ELSE
          IF !Empty(cFor)
              IF (ValType(cFor) == "B")
               INDEX ON &DBKey TAG (DBAliasName) TO (DBIndexName) FOR EVAL(cFor)
              else
               INDEX ON &DBKey TAG (DBAliasName) TO (DBIndexName) FOR &cFor
              endif
          ELSE
              INDEX ON &DBKey TAG (DBAliasName) TO (DBIndexName)
          ENDIF
       ENDIF
ENDIF
Select(nOldArea)
return NIL
////////////////////////////////////////////////////////////////
Function XSoftCopy(cFields,cTargName,cWhileExp,cForExp,lSDF)
IIF(EMPTY(lSDF),lSDF := .F.  ,NIL )

IF !EMPTY(cFields)
 IF !EMPTY(cWhileExp)
     IF !EMPTY(cForExp) .AND. lSDF
         IF (ValType(cForExp) == "B")
          COPY FIELDS(cFields) TO (cTargName) WHILE &cWhileExp  FOR EVAL(cForExp) SDF
         ELSE
          COPY FIELDS(cFields) TO (cTargName) WHILE &cWhileExp  FOR &cForExp SDF
         ENDIF
     ELSEIF !EMPTY(cForexp) .AND. !lSDF
        if (ValType(cForExp) == "B")
         COPY FIELDS(cFields) TO (cTargName) WHILE &cWhileExp  FOR EVAL(cForExp)
        else
         COPY FIELDS(cFields) TO (cTargName) WHILE &cWhileExp  FOR &cForExp
        endif
     ELSEIF EMPTY(cForExp) .AND. lSDF
         COPY FIELDS(cFields) TO (cTargName) WHILE &cWhileExp  SDF
     ELSEIF EMPTY(cForExp) .AND. !lSDF
         COPY FIELDS(cFields) TO (cTargName) WHILE &cWhileExp
     ENDIF
 ELSE
     IF !EMPTY(cForExp) .AND. lSDF
       if (ValType(cForExp) == "B")
         COPY FIELDS(cFields) TO (cTargName) FOR EVAL(cForExp) SDF
       else
         COPY FIELDS(cFields) TO (cTargName) FOR &cForExp SDF
       endif
     ELSEIF !EMPTY(cForexp) .AND. !lSDF
       if (ValType(cForExp) == "B")
         COPY FIELDS(cFields) TO (cTargName) FOR EVAL(cForExp)
       else
         COPY FIELDS(cFields) TO (cTargName) FOR &cForExp
       endif
     ELSEIF EMPTY(cForexp) .AND. lSDF
         COPY FIELDS(cFields) TO (cTargName) SDF
     ELSEIF EMPTY(cForExp) .AND. !lSDF
         COPY FIELDS(cFields) TO (cTargName)
     ENDIF
 ENDIF
ELSE
 IF !EMPTY(cWhileExp)
     IF !EMPTY(cForExp) .AND. lSDF
       if (ValType(cForExp) == "B")
         COPY TO (cTargName) WHILE &cWhileExp  FOR EVAL(cForExp) SDF
       else
         COPY TO (cTargName) WHILE &cWhileExp  FOR &cForExp SDF
       endif
     ELSEIF !EMPTY(cForexp) .AND. !lSDF
        if (ValType(cForExp) == "B" .AND. ValType(cWhileExp) == "B")
			 COPY TO (cTargName) WHILE EVAL(cWhileExp)  FOR EVAL(cForExp)
		  elseif (ValType(cForExp) == "B")
			 COPY TO (cTargName) WHILE &cWhileExp  FOR EVAL(cForExp)
		  else
          COPY TO (cTargName) WHILE &cWhileExp  FOR &cForExp
        endif
     ELSEIF EMPTY(cForexp) .AND. lSDF
         COPY TO (cTargName) WHILE &cWhileExp  SDF
     ELSEIF EMPTY(cForExp) .AND. !lSDF
         COPY TO (cTargName) WHILE &cWhileExp
     ENDIF
 ELSE
     IF !EMPTY(cForExp) .AND. lSDF
        if (ValType(cForExp) == "B")
         COPY TO (cTargName) FOR EVAL(cForExp) SDF
        else
         COPY TO (cTargName) FOR &cForExp SDF
        endif
     ELSEIF !EMPTY(cForexp) .AND. !lSDF
        if (ValType(cForExp) == "B")
         COPY TO (cTargName) FOR EVAL(cForExp)
        else
         COPY TO (cTargName) FOR &cForExp
        endif
     ELSEIF EMPTY(cForexp) .AND. lSDF
         COPY TO (cTargName) SDF
     ELSEIF EMPTY(cForExp) .AND. !lSDF
         COPY TO (cTargName)
     ENDIF
 ENDIF
ENDIF
Return NIL
/*
/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: ChangeMode()             Docs:                             ³
 * ³  Description: Toggle shared mode between 'Shared' and 'Exclusive'        |
 * ³       Author:   Veksler                                              ³
 * ³ Date created: 05/12/99              Date updated: þ26/05/99              ³
 * ³ Time created: 15:50:14              Time updated: þ08:15:14              ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: DBAliasName                                                ³
 * ³ Return Value: lToReturn                                                  ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
*-----------------------------------------------------------------------------*
FUNCTION ChangeMode(DBAliasName)
LOCAL nPos,cIndName,lStatus,cDriver
LOCAL lToReturn := FALSE
nPos := RECNO()
cDriver := RDDNAME()
cIndName := ORDSETFOCUS()
lStatus := AX_IsShared()
IF cDriver == "DBFCDXAX" .OR. cDriver == "DBFCDX"
     lToReturn := CheckCDX(DBAliasName,lStatus,cDriver)
ELSEIF cDriver == "DBFNTXAX" .OR. cDriver == "DBFNTX"
     lToReturn := CheckNTX(DBAliasName,lStatus,cDriver)
ENDIF
IF SELECT(DBAliasName) > 0
     ORDSETFOCUS(cIndName)
     (DBAliasName) ->(DBGOTO(nPos))
ENDIF
return lToReturn
*--------------------------------------------------------------------------*
FUNCTION  Check(cDriver,lStatus,DBAliasName)
LOCAL lToReturn := FALSE
IF lStatus == TRUE
      DBUSEAREA(,cDriver,DBAliasName,,FALSE)
      lToReturn := TRUE
ELSE
      DBUSEAREA(,cDriver,DBAliasName,,TRUE)
      lToReturn := TRUE
ENDIF
RETURN lToReturn
*---------------------------------------------------------------------------*
FUNCTION CheckNTX(DBAliasName,lStatus,cDriver)
LOCAL i,nIndCount := 1
LOCAL aIndexes := {}
LOCAL lToReturn := FALSE

DO WHILE ((DBAliasName)->(ORDNAME()) != NIL) .AND.;
          (ORDSETFOCUS(nIndCount++) != ORDSETFOCUS(nIndCount--))
     ORDSETFOCUS(nIndCount++)
     AADD(aIndexes,ORDNAME())
ENDDO
nIndCount--
(DBAliasName)->(DBCLOSEAREA())
lToReturn := Check(cDriver,lStatus,DBAliasName)
IF  SELECT(DBAliasName) > 0
     FOR i := 1 TO nIndCount
          (DBAliasName) ->(DBSETINDEX(aIndexes[i]))
     NEXT
ENDIF
return lToReturn
*---------------------------------------------------------------------------*
FUNCTION CheckCDX(DBAliasName,lStatus,cDriver)
LOCAL lToReturn := FALSE
(DBAliasName)->(DBCLOSEAREA())
lToReturn := Check(cDriver,lStatus,DBAliasName)
return lToReturn

*---------------------------------------------------------------------------*
FUNCTION DelUnneededIndexes(aDBFiles)
LOCAL nOldSelect,n,i,lFlag :=FALSE
LOCAL lOpen := FALSE
LOCAL aInfo := {}
nOldSelect := SELECT()
DBUSEAREA(TRUE,"DBFCDXAX","Syskeys")
FOR i := 1 TO LEN(aDBFiles)
     IF FILE(aDBFiles[i] + ".CDX")
          IF SELECT(aDBFiles[i]) == 0
               DBUSEAREA(TRUE,"DBFCDXAX",aDBFiles[i])
               lOpen := TRUE
          ENDIF
          (aDBFiles[i])->(ORDSETFOCUS(1))
          aInfo  := (aDBFiles[i])->(AX_TagInfo())
          FOR n := 1 TO LEN(aInfo)
               lFlag :=FALSE
               Syskeys->(DBGOTOP())
               DO WHILE !(Syskeys->(EOF()))
                    IF  ALLTRIM(aInfo[n][1]) == UPPER(ALLTRIM(Syskeys->Tagname))
                         lFlag := TRUE
                    ENDIF
                    Syskeys->(DBSKIP())
               ENDDO
               IF !lFlag
                      (aDBFiles[i])->(AX_KillTag(aInfo[n][1]))
               ENDIF
          NEXT
          IF lOpen
               DBCLOSEAREA(aDBFiles[i])
          ENDIF
     ENDIF
NEXT
DBCLOSEAREA("Syskeys")
SELECT(nOldSelect)
return nil
/***************************************************************************/
PROC DelAllUnneededIndexes()
LOCAL cTempName,cAlias
LOCAL nOldSelect,lFlag := TRUE
LOCAL lOpen := FALSE
LOCAL aIndex := {}
LOCAL aInfo := {}
nOldSelect := SELECT()
IF SELECT("Syskeys")== 0
     DBUSEAREA(TRUE,"DBFCDXAX","Syskeys")
ENDIF
Syskeys->(ORDSETFOCUS("Syskeys"))
Syskeys->(DBGOTOP())
cTempName := Syskeys->FILENAME
IF SELECT(Syskeys->FILENAME) == 0 .AND. FILE(Syskeys->FILENAME + ".CDX")
      DBUSEAREA(TRUE,"DBFCDXAX",ALLTRIM(Syskeys->FILENAME))
      lOpen := TRUE
ENDIF
(Syskeys->FILENAME)->(ORDSETFOCUS(1))
 aInfo  := (Syskeys->FILENAME)->(AX_TagInfo())
 cAlias := Syskeys->FILENAME
DO WHILE !(Syskeys->(EOF())) .AND. cTempName!= nil

      IF cAlias == Syskeys->FILENAME
             AADD(aIndex,Syskeys->TAGNAME)
             cAlias := Syskeys->FILENAME
             lFlag := FALSE
      ELSE
             IF !EMPTY(aIndex)
                 CheckTag(aInfo,aIndex,ALLTRIM(cAlias))
             ENDIF
             aIndex := {}
             IF lOpen     //.AND. FILE(cAlias + ".CDX")
                  DBSELECTAREA(ALLTRIM(cAlias))
                  DBCLOSEAREA(ALLTRIM(cAlias))
                  lOpen := FALSE
             ENDIF

             IF SELECT(Syskeys->FILENAME) == 0 .AND. FILE(Syskeys->FILENAME + ".CDX")
                   DBUSEAREA(TRUE,"DBFCDXAX",ALLTRIM(Syskeys->FILENAME))
                   lOpen := TRUE
             ENDIF
             IF  FILE(Syskeys->FILENAME + ".CDX")
                  (Syskeys->FILENAME)->(ORDSETFOCUS(1))
                   aInfo  := (Syskeys->FILENAME)->(AX_TagInfo())
                   AADD(aIndex,Syskeys->TAGNAME)
                   cAlias := Syskeys->FILENAME
             ENDIF
      ENDIF
      cTempName := Syskeys->FILENAME
      Syskeys->(DBSKIP())
ENDDO
DBSELECTAREA("Syskeys")
DBCLOSEAREA("Syskeys")
SELECT(nOldSelect)
return
/***************************************************************************/
function CheckTag(aInfo,aIndex,cTempName)
LOCAL n,i,lFlag := FALSE

FOR n := 1 TO LEN(aInfo)
    lFlag := FALSE
    FOR i := 1 TO LEN(aIndex)
          IF  ALLTRIM(aInfo[n][1]) == UPPER(ALLTRIM(aIndex[i]))
               lFlag := TRUE
               i := LEN(aIndex)
          ENDIF
    NEXT
    IF !lFlag
         (cTempName)->(AX_KillTag(aInfo[n][1]))
    ENDIF
NEXT
return nil
/***************************************************************************/
Procedure OpenClose()
LOCAL t          := 10
LOCAL l          := 25
LOCAL b          := 14
LOCAL r          := 55
LOCAL cOldClr    := SETCOLOR("W+/b")
LOCAL cScr := SAVESCREEN()
LOCAL cBid := Space(6)
LOCAL nQty := 0

NetUse("d_line",5)
ordsetfocus(1)
DispBox( t, l, b,  r ,FRAMECAPTION+" ", "w+/b" )
@ t , l+2 SAY " open closed batch" COLOR "w+/g"
AddShadow( t, l, b, r  )

@ t+ 2, l+1 SAY REPLICATE( "Ä", r-l-1)

SETCOLOR("bg+/b")
@ t+ 1, l+2 SAY "Batch # :"

SETCOLOR( cOldClr )
SETCURSOR(1)

@ t+1, l+23 GET cBid VALID d_line->(dbseek(cBid)) .AND. d_line->b_stat == "C"

READ

IF LASTKEY() <> K_ESC
	if d_line->( RecLock(5,"MIS"))
		d_line->b_stat := " "
		d_line->(xdbunlock())
		Alert("Updated.....",{"Ok"})
	ENDIF
ENDIF

RESTSCREEN(0,0,24,79,cScr)
SETCURSOR(0)
d_line->(dbclosearea())


Return

Procedure FixPinkPass()

LOCAL t          := 10
LOCAL l          := 25
LOCAL b          := 14
LOCAL r          := 55
LOCAL cOldClr    := SETCOLOR("W+/b")
LOCAL cScr := SAVESCREEN()
LOCAL cBid := Space(6)
LOCAL nQty := 0

NetUse("d_line",5)
ordsetfocus(1)
NetUse("m_linemv",5)
ORDSETFOCUS(2)

DispBox( t, l, b,  r ,FRAMECAPTION+" ", "w+/b" )
@ t , l+2 SAY " Fix Pink pass " COLOR "w+/g"
AddShadow( t, l, b, r  )

@ t+ 2, l+1 SAY REPLICATE( "Ä", r-l-1)

SETCOLOR("bg+/b")
@ t+ 1, l+2 SAY "Batch # :"
@ t+ 3, l+2 SAY "Ini.Qty :"

SETCOLOR( cOldClr )
SETCURSOR(1)

@ t+1, l+23 GET cBid VALID d_line->(dbseek(cBid))
@ t+3, l+23 GET nQty PICTURE "999999" SEND preBlock := { |o| (nQty := d_line->qty_bini) == nQty }

READ

m_linemv->(dbseek(cBid))

While !m_linemv->(eof()) .AND. m_linemv->sta .AND. m_linemv->arr .AND. m_linemv->fin .AND. ;
		 m_linemv->b_id == d_line->b_id
	    m_linemv->(dbskip(1))
End

IF LASTKEY() <> K_ESC
	IF m_linemv->b_id == d_line->b_id .AND. ;
		m_linemv->cpproc_id <> d_line->cpproc_id .AND. ;
		Alert("The problem is detected",{"Fix it"}) == 1 .AND. ;
		d_line->( RecLock(5,"MIS"))
		d_line->cpproc_id  := m_linemv->cpproc_id
		d_line->CP_PCCODE  := m_linemv->CP_PCCODE
		d_line->CPWKSTN_ID := m_linemv->CPWKSTN_ID
		d_line->(xdbunlock())
		Alert("Fixed.....",{"Ok"})
	ELSEIF m_linemv->b_id == d_line->b_id .AND. ;
			 m_linemv->CP_BQTYP = 0  .AND. ;
		Alert("The problem is detected",{"Fix it"}) == 1 .AND. ;
		m_linemv->( RecLock(5,"MIS"))
		m_linemv->CP_BQTYP := 1
		m_linemv->CP_BQTYS := 1
		m_linemv->CP_BQTYW := 1
		m_linemv->(dbunlock())
		Alert("Fixed,Don't forget change qty's to correct",{"Ok"})
	ELSEif Alert("The problem is not detected,please call MIS(246)",{"Ok","Just update Ini.Qty"}) == 2 .AND. ;
      d_line->( RecLock(5,"MIS"))
		d_line->qty_bini := nQty
		d_line->(xdbunlock())
		Alert("Updated.....",{"Ok"})
	ENDIF
ENDIF

RESTSCREEN(0,0,24,79,cScr)
SETCURSOR(0)
d_line->(dbclosearea())
m_linemv->(dbclosearea())
Return