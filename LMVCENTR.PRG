#include "avxdefs.ch"

STATIC aColos := {28,29,23,22,21,24,50,33,36,40,51,53} //removed 22 from after 23. (25-06-01 VR 16251489 {28,29,23,22,21,24,50,33,36,40})
STATIC aCurrentCols
STATIC bApplyKeys
STATIC aoOpenedList
STATIC cProgId
STATIC oBc
STATIC oLockKey
STATIC oCurrentPage
STATIC lCanSave := FALSE
STATIC lFromDat := FALSE
STATIC cDbf
STATIC nWhich
STATIC cParent
static nLastStAge
static nPrevStage
PROCEDURE ProcCenter( cPid, nFile )

LOCAL aOldList, i
LOCAL aKeyList
LOCAL cPrefix
LOCAL cTitle := ""


DEFAULT bApplyKeys TO {|nKey , o , oForm | ApplyKeys(nKey,o,oForm ) } ,;
        aColos     TO {1,2,3,4,5,6}

DEFAULT nFile TO 1//BAT_NORMAL
nWhich := nFile
IF nWhich ==  1//BAT_NORMAL //vr
   cDbf    := "m_linemv"
   cParent := "d_line"
   aKeyList:={;
                 { "Ins        - New Process                          " ,K_INS   }   ,;
                 { "Ctrl Ins   - Add Several Processes                " ,K_CTRL_INS} ,;
                 { "Enter      - Update Process                       " ,K_ENTER }   ,;
                 { "Del        - Delete Process                       " ,K_DEL   }   ,;
					  { "Ctrl Del   - Delete Several Processes             " ,K_CTRL_DEL} ,;
                 { "F3         - Print Process                        " ,K_F3    }   ,;
                 { "F5         - Backup/Advance one reporting stage   " ,K_F5    }   ,; //Vitaly TaskID: 2112622 08-01-02
                 { "F6         - Backup one process                   " ,K_F6    }   ,;
                 { "F8         - Advance one process                  " ,K_F8    }   ,;
					  { "Alt L      - Update lead time for product         " ,K_ALT_L }   ,;
					  { "Alt M      - Samples shipment                     " ,K_ALT_M }   ,;
					  { "Ctrl Enter - Split Batch                          " ,K_CTRL_ENTER},;
                 { "Alt V      - View Process                         " ,K_ALT_V }    ;
                }
ELSEIF nWhich ==  5//BAT_RND
   cTitle  := "     (RND)"
   cDbf    := "m_linemv"
   cParent := "d_line"
   aKeyList:={;
              { "Alt V           - View Process         " ,K_ALT_V };
             }
ELSE
   aKeyList:={;
              { "Alt V           - View Process         " ,K_ALT_V };
             }
   IF nWhich == 2//BAT_HISTORY
      cTitle  := " (HISTORY)"
      cDbf    := "h_linemv"
      cParent := "h_line"
   ELSE
      cTitle  := " (ARCHIVE)"
      cDbf    := "a_linemv"
      cParent := "a_line"
   END
END

IF Empty( aCurrentCols )
   aCurrentCols := aColos
ENDIF

aOldList := SetHlpKeys( aKeyList )

oBc := BroCenter():new( cDbf , aCurrentCols, FALSE, NIL, FALSE, FALSE )
                   //BAT_NORMAL        BAT_RND
cPrefix := IF( nWhich == 1 .OR. nWhich == 5 .OR. nWhich == 10,"i",;
     IF( nWhich == 2,"h","a")) //BAT_HISTORY
(cDbf)->( ordSetFocus(cPrefix+"lnmvbs") )
oBc:oForm :=  Form():new(,,,, "Batch: "+ (cParent)->b_id+" ESN:"+(cParent)->esn_id+cTitle,, ProcName() )

oBc:createBrowse():addDefaultCols()
FOR i := 1 TO oBc:oBro:ColCount
    oBc:oBro:GetColumn(i):ColorBlock := {|| IF(CurrPass(),{7,2},IF((cDbf)->proc_type $ "_R_N_A",{3,2},{1,2}) )}
NEXT
oBc:Rescope((cParent)->b_id)
oBc:lCanAltS := FALSE
oBc:ApplyBlock := bApplyKeys
oBc:process()

aCurrentCols := oBc:CurrentCols()

oBc:oForm:hide()

oLockKey := oBc := NIL

aKeyList := SetHlpKeys( aOldList )

RETURN

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: procSetProgId()        Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 08-11-96              Date updated: þ08-11-96              ³
 * ³ Time created: 09:57:13am            Time updated: þ09:57:13am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: cNewVal                                                    ³
 * ³ Return Value: cOldProgId                                                 ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION ProcSetProgId( cNewVal )
LOCAL cOldProgId := cProgId

IF cNewVal != NIL
   cProgId := cNewVal
ENDIF

RETURN cOldProgId


/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: ProcSetCols()          Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 08-11-96              Date updated: þ08-11-96              ³
 * ³ Time created: 09:57:17am            Time updated: þ09:57:17am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: aNewVal                                                    ³
 * ³ Return Value: aOldCols                                                   ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION ProcSetCols( aNewVal )
LOCAL aOldCols := aColos

IF aNewVal != NIL
   aColos := aNewVal
ENDIF

RETURN aOldCols

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: ProcSetApplyKeys()     Docs:                               ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 08-11-96              Date updated: þ08-11-96              ³
 * ³ Time created: 09:57:22am            Time updated: þ09:57:22am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: bNewVal                                                    ³
 * ³ Return Value: bOldKeys                                                   ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION ProcSetApplyKeys( bNewVal )
LOCAL bOldKeys   := bApplyKeys

IF bNewVal != NIL
   bApplyKeys := bNewVal
ENDIF

RETURN bOldKeys

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: ApplyKeys()           Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 08-27-96              Date updated: þ08-27-96              ³
 * ³ Time created: 04:01:32pm            Time updated: þ04:01:32pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: nKey                                                       ³
 * ³             : oBroCenter                                                 ³
 * ³             : oForm                                                      ³
 * ³ Return Value: lProcessed                                                 ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC FUNCTION ApplyKeys( nKey , oBroCenter , oForm )
LOCAL lProcessed := .T.
local cProc_id
LOCAL nSaveRec,n
LOCAL nRec_line,nRec_move
LOCAL cTempDir := GetUserInfo():cTempDir
LOCAL aMlineStruct := (cDbf)->(dbstruct())
LOCAL aTlineStruct := (cParent)->(dbstruct())
LOCAL nOldArea := Select()
AADD(aMlineStruct,{"RecNo","N",8,0})
AADD(aTlineStruct,{"RecNo","N",8,0})
IIF(File(cTempDir+"t_lineMV.dbf"),Ferase(cTempDir+"t_lineMV.dbf") , NIL)
IIF(File(cTempDir+"t_lineMV.cdx"),Ferase(cTempDir+"t_lineMV.cdx") , NIL)
IIF(File(cTempDir+"t_line.cdx"),Ferase(cTempDir+"t_line.cdx") , NIL)
IIF(File(cTempDir+"t_line.dbf"),Ferase(cTempDir+"t_line.dbf") , NIL)
dbcreate(cTempDir+"t_lineMV.dbf",aMlineStruct,NIL)
dbcreate(cTempDir+"t_line.dbf",aTlineStruct,NIL)
NetUse( "t_lineMV",5, NIL, USE_EXCLUSIVE, USE_NEW, cTempDir)
NetUse( "t_line",5, NIL, USE_EXCLUSIVE, USE_NEW, cTempDir)
DO CASE
   CASE nKey = K_ALT_V
          nKey := (cDbf)->( RecNo() )
          ProcView(FALSE,nWhich)
          IF SELECT(cDbf) == 0
               DBUSEAREA(TRUE,"DBFCDXAX",cDbf)
          ENDIF
          (cDbf)->( DbGoTo( nKey ) )
   CASE nKey = K_ALT_L .AND. "AIFRAH" $ GetUserInfo():cUserID
          SetLead()
			 oBroCenter:oBro:refreshAll()
   CASE nKey = K_ALT_M .AND. CurrPass()
          SmplShip()
			 oBroCenter:oBro:refreshAll()
	CASE nKey == K_CTRL_DEL .AND. nWhich == 1
		  DeleteGroup()
		  oBroCenter:oBro:refreshAll()
   CASE nKey == K_DEL .AND. nWhich == 1//BAT_NORMAL
        IF ReadOnly() .AND. Alltrim(GetUserInfo():cGroupID) <> "CZ_MGR"
           Msg24( {MSG_RO}, 3, TRUE )
        ELSEIF CanDelete()
             TONE(800,0)
             IF ALERT("Are you sure you want to;delete this process?",{"Yes","No"}, ALERT_STD) == 1
                StoreAudit("D")
                (cDbf)->( RecLock(5,"",.F.) )
					 cProc_id := (cDbf)->cpproc_id
                (cDbf)->( DBDELETE() )
                (cDbf)->( DBUNLOCK() )
                (cDbf)->( DBSKIP(0) )
             ENDIF
             IF d_line->( RecLock(5,"lmvcentr") ) // Vitaly 19-06-01 16191452
                d_line->ExpFinDate := batchCalc3("d_line")
					 IF CurrPass()
						 d_line->CP_DARR     := CTOD("  /  /  ")
						 d_line->CP_TARR     := ""
						 d_line->CP_WIDARR   := ""
						 d_line->CP_DSTA     := CTOD("  /  /  ")
						 d_line->CP_TSTA     := ""
						 d_line->CP_WIDSTA   := ""
						 d_line->( xDBUNLOCK() )
					 ENDIF
             ENDIF
             if CurrPass() .AND. d_line->( RecLock(5,"lmvcentr") )//Vitaly TaskID: 2112622 08-01-02
                 d_line->CP_BQTYP   := (cDbf)->CP_BQTYP
                 d_line->CP_BQTYS   := (cDbf)->CP_BQTYS
                 d_line->CP_BQTYW   := (cDbf)->CP_BQTYW
                 (cDbf)->( DBSKIP(1) )
                 d_line->CPWKSTN_ID := (cDbf)->cPWKSTN_id
                 d_line->CPPROC_ID  := (cDbf)->cpproc_id
                 d_line->CP_PCCODE  := (cDbf)->cP_PCCODE
                 (cDbf)->( DBSKIP(-1) )
                 IF (cDbf)->B_ID == d_line->b_id   // First movement  in the batch
                     d_line->PPPROC_ID  := (cDbf)->cpproc_id
                     d_line->PP_PCCODE  := (cDbf)->cP_PCCODE
                     d_line->PP_WKSTN   := (cDbf)->cPWKSTN_id
                     d_line->PP_BQTYP   := (cDbf)->CP_BQTYP
                     d_line->PP_BQTYS   := (cDbf)->CP_BQTYS
               		d_line->PP_BQTYW   := (cDbf)->CP_BQTYW
							(cDbf)->( DBSKIP() )
                 ELSE
                     (cDbf)->( DBSKIP() )
                     d_line->PPPROC_ID  := d_line->cpproc_id
               		d_line->PP_PCCODE  := d_line->cP_PCCODE
               		d_line->PP_WKSTN   := d_line->cPWKSTN_id
               		d_line->PP_BQTYP   := d_line->CP_BQTYP
               		d_line->PP_BQTYS   := d_line->CP_BQTYS
                		d_line->PP_BQTYW   := d_line->CP_BQTYW
                 ENDIF
				     d_line->( xDBUNLOCK() )
					  IF (cDbf)->( RecLock(5,"",.F.) )
						  (cDbf)->CPWKSTN_ID := d_line->cPWKSTN_id
						  (cDbf)->CP_BQTYP   := d_line->CP_BQTYP
						  (cDbf)->CP_BQTYS   := d_line->CP_BQTYS
						  (cDbf)->CP_BQTYW   := d_line->CP_BQTYW
						  (cDbf)->( DBUNLOCK() )
					  ENDIF
				 endif
				 oBroCenter:oBro:refreshAll()
        END
   CASE nKEy == K_INS .AND. nWhich == 1//BAT_NORMAL
       IF ReadOnly() .AND. Alltrim(GetUserInfo():cGroupID) <> "CZ_MGR"
          Msg24( {MSG_RO}, 3, TRUE )
		 ELSE
          InsertStuff()
		 ENDIF
   CASE nKEy == K_CTRL_INS .AND. nWhich == 1//BAT_NORMAL
       IF ReadOnly()
          Msg24( {MSG_RO}, 3, TRUE )
		 ELSE
          InsertStuff(nil,"Group")
		 ENDIF
   CASE nKey =  K_ENTER .AND. nWhich == 1//BAT_NORMAL
       IF ReadOnly()
          Msg24( {MSG_RO}, 3, TRUE )
       ELSE
          IF d_line->b_stat == "C"
             Msg24("Record not Editable due to its status: "+ d_line->b_stat, 3, .T. )
          ELSE
             ProcView( TRUE )
             oBroCenter:oBro:refreshAll()
          ENDIF
       ENDIF

   CASE nKey == K_F3 .AND. nWhich == 1//BAT_NORMAL
          PrnProcLine()
   CASE nKey == K_F6 .AND. nWhich == 1//BAT_NORMAL
        IF ReadOnly() .AND. Alltrim(GetUserInfo():cGroupID) <> "CZ_MGR"
           Msg24( {MSG_RO}, 3, TRUE )
        ELSEIF ((cDbf)->ARR .AND. (cDbf)->STA .AND. (cDbf)->FIN) .OR. (cDbf)->cp_bqtyp == 0
           Msg24("You must be on the current process to run this function.",3,.T.)
        ELSEIF (cDbf)->cpproc_id="194.0"
           Msg24("You cannot step back this final process !",3,.T.)
        ELSEIF (cDbf)->b_stat $ "E_M"
           Msg24("You cannot step back this batch ! Current status is:"+(cDbf)->b_stat,3,.T.)
        ELSE
          n := ALERT([Back up one process.Please select:],;
                    {"Normal back up","Insert a new proccess","Cancel"})
          IF n == 1
             Backup1Step(.t.,oBroCenter)
             oBroCenter:oBro:refreshAll()
          elseif n == 2
             nKey := (cDbf)->( RecNo() )
             Backup1Step(.F.,oBroCenter)
             if InsertStuff(calcRightcStage())
                (CdBF)->(DBSKIP(-1))
                advanceStuff(oBroCenter,.T.)
                oBroCenter:oBro:refreshAll()
             else
                ReturnValues()
                (cDbf)->( DbGoTo( nKey ) )
                oBroCenter:oBro:refreshAll()
             endif
          ENDIF
        ENDIF
   CASE nKey == K_F5 //Vitaly TaskID: 2112622 08-01-02
        IF ReadOnly() .AND. Alltrim(GetUserInfo():cGroupID) <> "CZ_MGR"
           Msg24( {MSG_RO}, 3, TRUE )
        ELSEIF ((cDbf)->ARR .AND. (cDbf)->STA .AND. (cDbf)->FIN) .OR. (cDbf)->cp_bqtyp == 0
           Msg24("You must be on the current process to run this function.",3,.T.)
        ELSEIF (cDbf)->cpproc_id="194.0"
           Msg24("You cannot step back this final process !",3,.T.)
		  ELSEIF (cDbf)->b_stat $ "E_M_C_D"
           Msg24("You cannot step back this batch ! Current status is:"+(cDbf)->b_stat,3,.T.)
        ELSE
          n := ALERT([Backup or advance one reporting stage:],;
                    {"Backup","Advance"})
			 IF  n == 1 .AND. (cDbf)->( RecLock(5,"lmvcentr") )   //left moving
				IF !((cDbf)->ARR .OR. (cDbf)->STA .OR. (cDbf)->FIN)
					 Backup1Step(.t.,oBroCenter,"I comming from delete module")
				ELSEIF (cDbf)->ARR .AND. !((cDbf)->STA .OR. (cDbf)->FIN)
					(cDbf)->ARR         := .F.
					(cDbf)->CP_DARR     := CTOD("  /  /  ")
					(cDbf)->CP_TARR     := ""
					(cDbf)->CP_WIDARR   := ""
					IF d_line->( RecLock(5,"lmvcentr") )
					   d_line->CP_DARR    := CTOD("  /  /  ")
                  d_line->CP_TARR    := ""
                  d_line->CP_WIDARR  := ""
						D_LINE->(xDBUNLOCK())
					ENDIF
				ELSEIF ((cDbf)->ARR .OR. (cDbf)->STA) .AND. !(cDbf)->FIN
					(cDbf)->STA         := .F.
					(cDbf)->CP_DSTA     := CTOD("  /  /  ")
					(cDbf)->CP_TSTA     := ""
					(cDbf)->CP_WIDSTA   := ""
					IF d_line->( RecLock(5,"lmvcentr") )
					   d_line->CP_DSTA    := CTOD("  /  /  ")
                  d_line->CP_TSTA    := ""
                  d_line->CP_WIDSTA  := ""
						D_LINE->(xDBUNLOCK())
					ENDIF
				ELSEIF (cDbf)->ARR .AND. (cDbf)->STA .AND. (cDbf)->FIN
					(cDbf)->FIN         := .F.
					(cDbf)->CP_DFIN     := CTOD("  /  /  ")
					(cDbf)->CP_TFIN     := ""
					(cDbf)->CP_WIDFIN   := ""
				ENDIF
				(cDbf)->( DBUNLOCK() )
				oBroCenter:oBro:refreshAll()
          ELSEIF n == 2 .AND. (cDbf)->( RecLock(5,"lmvcentr") )   //right moving
			   IF !((cDbf)->ARR .OR. (cDbf)->STA .OR. (cDbf)->FIN)
					(cDbf)->ARR         := .T.
					(cDbf)->CP_DARR     := DATE()
					(cDbf)->CP_TARR     := TIME()
					(cDbf)->CP_WIDARR   := "_tapi"
					IF d_line->( RecLock(5,"lmvcentr") )
					   d_line->CP_DARR    := DATE()
                  d_line->CP_TARR    := TIME()
                  d_line->CP_WIDARR  := "_tapi"
						D_LINE->(xDBUNLOCK())
					ENDIF
				ELSEIF (cDbf)->ARR .AND. !((cDbf)->STA .OR. (cDbf)->FIN)
					(cDbf)->STA         := .T.
					(cDbf)->CP_DSTA     := DATE()
					(cDbf)->CP_TSTA     := TIME()
					(cDbf)->CP_WIDSTA   := "_tapi"
					IF d_line->( RecLock(5,"lmvcentr") )
					   d_line->CP_DSTA    := DATE()
                  d_line->CP_TSTA    := TIME()
                  d_line->CP_WIDSTA  := "_tapi"
						D_LINE->(xDBUNLOCK())
					ENDIF
				ELSEIF ((cDbf)->ARR .AND. (cDbf)->STA) .AND. !(cDbf)->FIN
					advanceStuff(oBroCenter)
				ENDIF
				(cDbf)->( DBUNLOCK() )
				oBroCenter:oBro:refreshAll()
			 ENDIF
        ENDIF
	CASE nKey == K_F8
          advanceStuff(oBroCenter)
	CASE nKey == K_CTRL_ENTER .AND. nWhich == 1//BAT_NORMAL
       IF ReadOnly()
          Msg24( {MSG_RO}, 3, TRUE )
       ELSEIF CurrPass()
			 nRec_line := d_line->(recNo())
			 nRec_move := m_linemv->(RecNo())
			 opnbtchOpenFiles()
			 OpenBatch(TRUE,TRUE,,,.T. )
			 opnbtchCloseFiles()
			 d_line->(dbgoto(nRec_line))
			 m_linemv->(dbgoto(nRec_move))
		 ENDIF
	OTHERWISE
       lProcessed := .F.
ENDCASE
t_lineMV->(dbclosearea())
t_line->(dbclosearea())
dbselectarea(nOldArea)
RETURN lProcessed

Static Procedure SmplShip()
Local aFields := {},i
Local cStage,nQty:=0
Local cOldScr := SAVESCREEN()
local dDate,cTime,nShpDoc := GetCounter()
local nSelect := Select()

@11,30 CLEAR TO 13, 55
DrawBox(11,30,13,55)
@ 12,33 SAY "Enter Qty  " COLOR "n/bg"
@ 12,45  GET nQty  PICTURE "999999" VALID  nQty>0 .AND. nQty<=(cDbf)->CP_BQTYP  COLOR "B/R"
READ
IF LastKey() <> K_ESC////
nLastStage := (cDbf)->CP_STAGE
(cDbf)->( DBSKIP(-1) )
nPrevStage := (cDbf)->CP_STAGE
cStage := calcRightcStage()
dDate := (cDbf)->CP_DFIN
cTime := (cDbf)->CP_TFIN
(cDbf)->( DBSKIP(1) )

FOR i := 1 TO (cDbf)->( FCOUNT() )
    AADD( aFields, (cDbf)->( FIELDGET(i) ) )
NEXT

IF !(cDbf)->( AddRec(5,"lmvcentr") )
   ALERT("ERROR;;Unable to save record!",{"OK"})
   RETURN
END

FOR i := 1 TO (cDbf)->( FCOUNT() )
       (cDbf)->( FIELDPUT(i ,aFields[i] ) )
NEXT

(cDbf)->CP_STAGE  := Val(cStage)
(cDbf)->CPPROC_ID := "997.7"
(cDbf)->CP_PCCODE := "6700"
(cDbf)->CPWKSTN_ID:= "3500"
(cDbf)->Arr := TRUE
(cDbf)->Sta := TRUE
(cDbf)->Fin := TRUE

(cDbf)->CP_DFIN := (cDbf)->CP_DSTA := (cDbf)->CP_DARR := dDate
(cDbf)->CP_TFIN := (cDbf)->CP_TSTA := (cDbf)->CP_TARR := cTime
(cDbf)->CP_TOTSCR := nQty
(cDbf)->( DBCOMMIT() )
(cDbf)->( DBUNLOCK() )
(cDbf)->( DBSKIP(1) )
IF (cDbf)->( RecLock(5,"",.F.) )
	(cDbf)->CP_BQTYP := (cDbf)->CP_BQTYP - nQty
	(cDbf)->( DBCOMMIT() )
	(cDbf)->( DBUNLOCK() )
ENDIF

NetUse("d_rejrep",5)
IF d_rejrep->(AddRec(5,"CZH"))
	d_rejrep->b_id := (cDbf)->B_id
	d_rejrep->CP_STAGE := Val(cStage)
	d_rejrep->CPPROC_ID := "997.7"
	d_rejrep->QTY_REJ   := nQty
	d_rejrep->REJ_ID    := "SMPL"
	d_rejrep->REJ_COM   := "Samples shipment QC(CZ)"
   d_rejrep->(dbclosearea())
ENDIF


NetUse("d_dlvntD",5)
NetUse("d_dlvntH",5)

if d_dlvntH->(AddRec(5,"CZH"))
   d_dlvntH->shpdoc := nShpDoc
   d_dlvntH->doc_type := "S2IL"
   d_dlvntH->(dbclosearea())
endif
SET PRINTER TO LPT1
SET PRINTER ON
SET CONSOLE OFF

? PrnSetup()

 ? "ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»"
 ? "º                                   A V X   I S R A E L                             º"
 ? "ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹"
 ? "º                          Packaging List for External Production                   º"
 ? "º                                * * * S A M P L E S * * *                          º"
 ? "ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶"
 ? "º                                                                                   º"
 ? "º                                                                                   º"
 ? "º                                                           Date : " + DTOC(Date()) + "         º"
 ? "º                                                           Ref No: " + str(nShpDoc) + "          º"
 ? "º                                                                                   º"
 ? "º ÚÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄ¿ º"
 ? "º ³ #  ³ Batch No ³      ESN        ³ Line | Size ³  Value  ³ W ³   Psc   ³Status ³ º"
 ? "º ÃÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄ´ º"
 	 if d_dlvntD->( AddRec(5) )
       d_dlvntD->ShpDoc := nShpDoc
       d_dlvntD->b_id := (cParent)->b_id
 		 d_dlvntD->CP_BQTYW := 0
 		 d_dlvntD->CP_BQTYP := nQty
  	    d_dlvntD->doc_type := "S2IL"
 		 d_dlvntD->(dbunlock())
 	 endif
  	 ? "º ³" + Str(i,3)                 + " | "           + ;
      		  (cParent)->b_id             + "   |"          + ;
  	 		     (cParent)->esn_id           + " | "           + ;
 				  (cParent)->pline_id         + "  | "          + ;
  	 		     (cParent)->size_id          + " |"            + ;
                         Str((cParent)->value_id,9,3)+ " |"         + ;
                         Transform(0,"999") + "|" + ;
                         Transform(nQty,"9,999,999") + "|" + ;
                       (cParent)->B_stat           + "      | º"

? "º ÀÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÙ º"
? "ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼"
?? "E"
? PrnReset()

SET PRINTER TO
SET PRINTER OFF
SET CONSOLE ON
d_dlvntD->(dbclosearea())
ENDIF/////


RESTSCREEN(,,,,cOldScr)
dbselectarea(nSelect)
Return

Static Function GetCounter()

local nRetVal
local cDbf := "n_czdlv"

NetUse(cDbf,5)

IF (cDbf)->( RecLock(5, "CZH") )
   (cDbf)->counter++
   (cDbf)->(dbcommit())
   nRetVal := (cDbf)->counter
	(cDbf)->(dbclosearea())
ENDIF

Return nRetVal



STATIC FUNCTION opnbtchOpenFiles

LOCAL oTab
LOCAL cTempDir    := GetUserInfo():cTempDir

aoOpenedList := {}

aoOpenedList := genOpenFiles( {"d_esn","c_tol","c_pline","c_prornd","c_size","c_volt","c_value",;
                               "c_prior","c_bstat","c_esnlnk","c_diel","c_bncaps","d_prornd","d_pcaud"})

SELECT c_rlib
ordSetFocus( "irlibid" )

SELECT c_esnlnk
ordSetFocus( "ilnkesn" )

SELECT d_line
ordSetFocus( "ib_idln" )

RETURN aoOpenedList

STATIC Procedure opnbtchCloseFiles()

Aeval( aoOpenedList , {| oTable | oTable:close() } )

RETURN


/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: Advance1Step          Docs: Shalom LeVine                  ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 11-12-97              Date updated: þ11-12-97              ³
 * ³ Time created: 02:32:44pm            Time updated: þ02:32:44pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: NIL                                                        ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION Advance1Step(lForward)

LOCAL aPrevValues, cCurBid, cPrevUOM, cNewUOM
LOCAL cScr := SAVESCREEN(24,0,24,79)

@24, 0 SAY PADR("Working, please be patient...", 80) COLOR "W+/r"
@24,40 SAY PADR("Updating present process...",40) COLOR "gr+/r"

      IF (cDbf)->( RecLock(5,"lmvcentr") )
         (cDbf)->STA         := .T.
         IF( EMPTY( (cDbf)->CP_DSTA ), (cDbf)->CP_DSTA := DATE()           , NIL )
         IF( EMPTY( (cDbf)->CP_TSTA ), (cDbf)->CP_TSTA := LEFT( TIME(), 5 ), NIL )
         (cDbf)->CP_WIDSTA   := "_tapi"
         (cDbf)->FIN         := .T.
         IF( EMPTY((cDbf)->CP_DFIN),(cDbf)->CP_DFIN := DATE(),NIL)
         IF( EMPTY((cDbf)->CP_TFIN),(cDbf)->CP_TFIN := LEFT( TIME(),5),NIL)
         (cDbf)->CP_WIDFIN   := "_tapi"
         IF !Empty(lForward) .AND. Empty((cDbf)->CP_darr)
                 (cDbf)->Arr       := .T.
                 (cDbf)->CP_darr   := DATE()
                 (cDbf)->CP_tarr   := LEFT( TIME(), 5 )
                 (cDbf)->CP_WIDARR   := "_tapi"
         ENDIF
         aPrevValues         := {(cDbf)->cp_bqtyw,(cDbf)->cp_bqtys,(cDbf)->cp_bqtyp, ;
                                 (cDbf)->cp_darr ,(cDbf)->cp_tarr ,(cDbf)->cp_totscr }
         cCurBid  := (cDbf)->B_ID
         c_proc->(dbseek((cDbf)->cpproc_id))
         cPrevUOM  := c_proc->uom_id
         (cDbf)->( DBUNLOCK() )

         @24,40 SAY PADR("Updating new process...",40) COLOR "w+/r"
         (cDbf)->( DBSKIP(1) )
        IF (cDbf)->B_ID == cCurBid
           IF (cDbf)->( RecLock(5,"lmvcentr") )
              c_proc->(dbseek((cDbf)->cpproc_id))
              cNewUOM  := c_proc->uom_id
              IF aPrevValues[6] = 0 // There is NO scrap to consider
               (cDbf)->cp_bqtyw  := aPrevValues[1]
               (cDbf)->cp_bqtys  := aPrevValues[2]
               (cDbf)->cp_bqtyp  := aPrevValues[3]
              ELSE
               (cDbf)->cp_bqtyw  := aPrevValues[1]-IF(cPrevUOM="W",aPrevValues[6],;
                                                      qtyconvert(aPrevValues[6]  ,;
                                                                 (cDbf)->b_type  ,;
																					  (cDbf)->pline_id,;
                                                                 (cDbf)->size_id ,;
                                                                  cPrevUOM,"W",,,(cDbf)->route_id)   )
               (cDbf)->cp_bqtys  := aPrevValues[2]-IF(cPrevUOM="S",aPrevValues[6],;
                                                      qtyconvert(aPrevValues[6]  ,;
                                                                 (cDbf)->b_type  ,;
																					  (cDbf)->pline_id,;
                                                                 (cDbf)->size_id ,;
                                                                  cPrevUOM,"S",,,(cDbf)->route_id)   )
               (cDbf)->cp_bqtyp  := aPrevValues[3]-IF(cPrevUOM="P",aPrevValues[6],;
                                                      qtyconvert(aPrevValues[6]  ,;
                                                                 (cDbf)->b_type  ,;
																					  (cDbf)->pline_id,;
                                                                 (cDbf)->size_id ,;
                                                                  cPrevUOM,"P",,,(cDbf)->route_id)   )
              ENDIF
              /*(cDbf)->Arr       := .T.
              (cDbf)->CP_darr   := DATE()
              (cDbf)->CP_tarr   := LEFT( TIME(), 5 )*/
              //GetUserInfo():updateUserInRec( cDbf, "lmvcentr", .F. )
              (cDbf)->( DBUNLOCK() )
           END
        ENDIF

        IF d_line->( RecLock(5,"lmvcentr") )
           @24,40 SAY PADR("Updating batch information...",40) COLOR "gr+/r"
           d_line->PPPROC_ID := d_line->CPPROC_ID
           d_line->PP_PCCODE := d_line->CP_PCCODE
           d_line->PP_WKSTN  := d_line->CPWKSTN_ID
           d_line->PP_BQTYP  := d_line->CP_BQTYP
           d_line->PP_BQTYS  := d_line->CP_BQTYS
           d_line->PP_BQTYW  := d_line->CP_BQTYW
           d_line->PP_DARR   := aPrevValues[4]
           d_line->PP_TARR   := aPrevValues[5]
           d_line->PP_DSTA   := IF( EMPTY( d_line->CP_DSTA ),  DATE() , d_line->CP_DSTA )
           d_line->PP_TSTA   := IF( EMPTY( d_line->CP_TSTA ),  LEFT( TIME(), 5 ) , d_line->CP_TSTA )
           d_line->PP_DFIN   := DATE()
           d_line->PP_TFIN   := LEFT( TIME(), 5 )
           d_line->PP_WIDFIN := "_tapi"
           d_line->PP_TOTSCR := 0
           d_line->CPPROC_ID := (cDbf)->cpproc_id
           d_line->CP_PCCODE := (cDbf)->cP_PCCODE
           d_line->CPWKSTN_id:= (cDbf)->cPWKSTN_id
           d_line->CP_BQTYP  := (cDbf)->CP_BQTYP
           d_line->CP_BQTYS  := (cDbf)->CP_BQTYS
           d_line->CP_BQTYW  := (cDbf)->CP_BQTYW
           d_line->CP_DSTA   := ctod("  /  /  ")
           d_line->CP_TSTA   := ""
           d_line->CP_WIDSTA := "     "
           d_line->CP_DARR   := ctod("  /  /  ")
           d_line->CP_TARR   := "     "
           d_line->CP_WIDARR   := ""
           d_line->ExpFinDate := batchCalc3("d_line") //Vitaly 19-06-01 16191452
           d_line->( xDBUNLOCK() )
		  END
		ENDIF
RESTSCREEN(24,0,24,79,cScr)
RETURN NIL




/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: Backup1Step           Docs: Shalom LeVine                  ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 05-18-97              Date updated: þ05-18-97              ³
 * ³ Time created: 06:37:44pm            Time updated: þ06:37:44pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: NIL                                                        ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC FUNCTION Backup1Step(lFull,oBroCenter,cFromDelete)

LOCAL aFiles    := GenOpenFiles({"d_irrfin","d_rejrep"})
LOCAL cCurBid,i
LOCAL cScr      := SAVESCREEN(24,0,24,79)
LOCAL lContinue := TRUE
LOCAL nScrap    :=  0
LOCAL nSelect   := SELECT()


        cCurBid := (cDbf)->B_ID
        nLastStage := (cDbf)->CP_STAGE
        (cDbf)->( DBSKIP(-1) )
        IF (cDbf)->B_ID <> cCurBid
            (cDbf)->( DBSKIP(1) )
            ALERT([Can't back up one process from first process in batch],;
                   {" OK "})
            GenCloseFiles( aFiles )
            SELECT (nSelect)
            RESTSCREEN(24,0,24,79,cScr)
            RETURN NIL
        ELSE
           (cDbf)->( DBSKIP(1) )
        ENDIF

@24, 0 SAY PADR("Working, please be patient...", 80) COLOR "W+/r"
@24,40 SAY PADR("Updating present process...",40) COLOR "gr+/r"

      IF (cDbf)->( RecLock(5,"lmvcentr") )
         T_linemv->(dbappend())
         FOR i := 1 TO (cDbf)->( FCOUNT() )
             T_linemv->( FIELDPUT( i, (cDbf)->( FIELDGET(i) ) ) )
         NEXT
         T_lineMV->RecNo := (cDbf)->(RecNo())
         T_linemv->(dbcommit())
         (cDbf)->CP_BQTYP    := 0               //  N    007     000
         (cDbf)->CP_BQTYS    := 0               //  N    005     000
         (cDbf)->CP_BQTYW    := 0               //  N    003     000
         (cDbf)->CP_TOTSCR   := 0               //  N    007     000
         (cDbf)->B_LREJ      := ""              //  C    004     000
         (cDbf)->DISCR_REP   := ""              //  C    006     000
         (cDbf)->CP_ADJSCR   := 0               //  N    007     000
         (cDbf)->ARR         := .F.             //  L    001     000
         (cDbf)->CP_DARR     := CTOD("  /  /  ")//  D    008     000
         (cDbf)->CP_TARR     := ""              //  C    005     000
         (cDbf)->STA         := .F.             //  L    001     000
         (cDbf)->CP_DSTA     := CTOD("  /  /  ")//  D    008     000
         (cDbf)->CP_TSTA     := ""              //  C    005     000
         (cDbf)->CP_WIDSTA   := ""              //  C    005     000
         (cDbf)->FIN         := .F.             //  L    001     000
         (cDbf)->CP_DFIN     := CTOD("  /  /  ")//  D    008     000
         (cDbf)->CP_TFIN     := ""              //  C    005     000
         (cDbf)->CP_WIDFIN   := ""              //  C    005     000
         cCurBid := (cDbf)->B_ID
         (cDbf)->( DBUNLOCK() )
      ELSE
         lContinue := FALSE
      END
      IF lContinue
         @24,40 SAY PADR("Updating previous process...",40) COLOR "w+/r"
         (cDbf)->( DBSKIP(-1) )
          nPrevStage := (cDbf)->CP_STAGE
          IF d_irrfin->( DBSEEK((cDbf)->b_id+STR((cDbf)->cp_stage,4)+(cDbf)->cpproc_id))
             do while (cDbf)->b_id+STR((cDbf)->cp_stage,4)+(cDbf)->cpproc_id = ;
                    d_irrfin->b_id+STR(d_irrfin->cp_stage,4)+d_irrfin->cpproc_id
                  IF d_irrfin->( RecLock(5,"") )
                     d_irrfin->( DBDELETE() ,.F.)
                     d_irrfin->( DBUNLOCK() )
                  END
                  d_irrfin->(dbskip())
             enddo
          END
          IF d_rejrep->( DBSEEK((cDbf)->b_id+STR((cDbf)->cp_stage,4)+(cDbf)->cpproc_id))
             do while (cDbf)->b_id+STR((cDbf)->cp_stage,4)+(cDbf)->cpproc_id = ;
                    d_rejrep->b_id+STR(d_rejrep->cp_stage,4)+d_rejrep->cpproc_id
                  IF d_rejrep->( RecLock(5,"",.F.) )
                     d_rejrep->( DBDELETE() )
                     d_rejrep->( DBUNLOCK() )
                  END
                  d_rejrep->(dbskip())
             enddo
          END
        IF (cDbf)->B_ID == cCurBid  .AND. lFull
             IF (cDbf)->( RecLock(5,"lmvcentr") )
                T_linemv->(dbappend())
                FOR i := 1 TO (cDbf)->( FCOUNT() )
                    T_linemv->( FIELDPUT( i, (cDbf)->( FIELDGET(i) ) ) )
                NEXT
                T_lineMV->RecNo := (cDbf)->(RecNo())
                T_linemv->(dbcommit())
                (cDbf)->FIN       := FALSE
                (cDbf)->cp_dfin   := CTOD("  /  /  ")
                (cDbf)->CP_TFIN   := ""
                (cDbf)->CP_WIDFIN := ""
					 c_proc->(dbseek((cDbf)->cpproc_id))
					 CheckSplits(cCurBid,(cDbf)->CP_STAGE,c_proc->uom_id)
                IF Empty(cFromDelete)
                   (cDbf)->ARR         := .F.
                   (cDbf)->CP_DARR     := CTOD("  /  /  ")
                   (cDbf)->CP_TARR     := ""
                   (cDbf)->CP_WIDARR   := ""
                   (cDbf)->STA         := .F.
                   (cDbf)->CP_DSTA     := CTOD("  /  /  ")
                   (cDbf)->CP_TSTA     := ""
                   (cDbf)->CP_WIDSTA   := ""
					 ENDIF
                nScrap := (cDbf)->CP_TOTSCR
                IF lFull
                     (cDbf)->CP_TOTSCR   := 0
                ENDIF
                (cDbf)->( DBUNLOCK() )
             END
        ENDIF

        IF d_line->( RecLock(5,"lmvcentr") )
           @24,40 SAY PADR("Updating batch information...",40) COLOR "gr+/r"
           T_line->(dbappend())
           FOR i := 1 TO d_line->( FCOUNT() )
               T_line->( FIELDPUT( i, d_line->( FIELDGET(i) ) ) )
           NEXT
           T_line->RecNo := d_line->(RecNo())
           T_line->(dbcommit())
           d_line->CPPROC_ID  := d_line->PPPROC_ID
           d_line->CP_PCCODE  := d_line->PP_PCCODE
           d_line->CPWKSTN_ID := d_line->PP_WKSTN
           d_line->CP_BQTYP   := M_lineMV->CP_BQTYP
           d_line->CP_BQTYS   := M_lineMV->CP_BQTYS
           d_line->CP_BQTYW   := M_lineMV->CP_BQTYW
			  IF Empty(cFromDelete)
			     d_line->CP_DSTA    := CTOD("  /  /  ")
              d_line->CP_TSTA    := ""
              d_line->CP_WIDSTA  := ""
			     d_line->CP_DARR     := CTOD("  /  /  ")
			     d_line->CP_TARR     := ""
              d_line->CP_WIDARR   := ""
			  ELSE
				  d_line->CP_DSTA    := (cDbf)->CP_DSTA
				  d_line->CP_TSTA    := (cDbf)->CP_TSTA
				  d_line->CP_WIDSTA  := (cDbf)->CP_WIDSTA
				  d_line->CP_DARR     := (cDbf)->CP_DARR
			     d_line->CP_TARR     := (cDbf)->CP_TARR
              d_line->CP_WIDARR   := (cDbf)->CP_WIDARR
			  ENDIF
           d_line->ExpFinDate := batchCalc3("d_line") //Vitaly 19-06-01 16191452
           IF lFull
                d_line->qty_bscr   -= nScrap
           ENDIF
              (cDbf)->( DBSKIP(-1) )
              IF (cDbf)->B_ID == cCurBid   // First movement  in the batch
                 d_line->PPPROC_ID  := (cDbf)->cpproc_id
                 d_line->PP_PCCODE  := (cDbf)->cP_PCCODE
                 d_line->PP_WKSTN   := (cDbf)->cPWKSTN_id
                 d_line->PP_BQTYP   := (cDbf)->CP_BQTYP
                 d_line->PP_BQTYS   := (cDbf)->CP_BQTYS
                 d_line->PP_BQTYW   := (cDbf)->CP_BQTYW
                 d_line->PP_DARR    := (cDbf)->CP_DARR
                 d_line->PP_TARR    := (cDbf)->CP_TARR
                 d_line->PP_DSTA    := (cDbf)->CP_DSTA
                 d_line->PP_TSTA    := (cDbf)->CP_TSTA
                 d_line->PP_DFIN    := (cDbf)->CP_DFIN
                 d_line->PP_TFIN    := (cDbf)->CP_TFIN
                 d_line->PP_WIDFIN  := (cDbf)->CP_WIDFIN
               ELSE
                 (cDbf)->( DBSKIP() )
                 d_line->PPPROC_ID  := d_line->cpproc_id
                 d_line->PP_PCCODE  := d_line->cP_PCCODE
                 d_line->PP_WKSTN   := d_line->cPWKSTN_id
                 d_line->PP_BQTYP   := d_line->CP_BQTYP
                 d_line->PP_BQTYS   := d_line->CP_BQTYS
                 d_line->PP_BQTYW   := d_line->CP_BQTYW
                 d_line->PP_DARR    := d_line->CP_DSTA
                 d_line->PP_TARR    := d_line->CP_TSTA
                 d_line->PP_DSTA    := d_line->CP_DSTA
                 d_line->PP_TSTA    := d_line->CP_TSTA
                 d_line->PP_DFIN    := d_line->CP_DSTA
                 d_line->PP_TFIN    := d_line->CP_TSTA
                 d_line->PP_WIDFIN  := ""
               ENDIF
           d_line->( xDBUNLOCK() )
        END

       ENDIF

GenCloseFiles( aFiles )
SELECT (nSelect)
RESTSCREEN(24,0,24,79,cScr)
RETURN NIL

Static Procedure CheckSplits(cCurBid,nLastStage,mUOM_INI)
local nRecLine := d_line->(recno())
local nOrderLine := d_line->(ordsetfocus("i_split"))
local nRecMv := m_linemv->(recno())
local nArea := Select()
local aSplits := {0,0,0}

IF d_line->(dbseek(cCurBid))
	While d_line->esn_p1 == cCurBid
			IF AllTrim(d_line->esn_p3) >= Alltrim(Str(nLastStage)) .AND. ;
			  	m_linemv->(dbseek(d_line->b_id))
				aSplits[1] := aSplits[1] + m_linemv->cp_bqtyp
				aSplits[2] := aSplits[2] + m_linemv->cp_bqtyw
				aSplits[3] := aSplits[3] + m_linemv->cp_bqtys
			ENDIF
			d_line->(dbskip(1))
	End

	m_linemv->(dbgoto(nRecMv))
	D_LINE->(ORDSETFOCUS(1))
	d_line->(dbseek(cCurBid))

	IF mUOM_INI == "P"
		m_linemv->cp_bqtyp := m_linemv->cp_bqtyp - aSplits[1]
		m_linemv->(dbcommit())
		m_linemv->cp_bqtyw := qtyconvert(m_linemv->cp_bqtyp,d_line->B_TYPE,d_line->PLINE_ID,d_line->SIZE_ID , "P" , "W" ,,,d_line->route_id)
	   m_linemv->cp_bqtys := qtyconvert(m_linemv->cp_bqtyp,d_line->B_TYPE,d_line->PLINE_ID,d_line->SIZE_ID , "P" , "S" ,,,d_line->route_id)
	ELSEIF mUOM_INI == "W"
	   m_linemv->cp_bqtyw := m_linemv->cp_bqtyw - aSplits[2]
		m_linemv->(dbcommit())
	   m_linemv->cp_bqtys := qtyconvert( m_linemv->cp_bqtyw,d_line->B_TYPE ,d_line->PLINE_ID,d_line->SIZE_ID , "W" , "S" ,,,d_line->route_id )
	   m_linemv->cp_bqtyp := qtyconvert( m_linemv->cp_bqtyw,d_line->B_TYPE ,d_line->PLINE_ID,d_line->SIZE_ID , "W" , "P" ,,,d_line->route_id)
	ELSE
	   m_linemv->cp_bqtys := m_linemv->cp_bqtys - aSplits[3]
		m_linemv->(dbcommit())
		m_linemv->cp_bqtyp := qtyconvert( m_linemv->cp_bqtys,d_line->B_TYPE ,d_line->PLINE_ID,d_line->SIZE_ID , "S" , "P" ,,,d_line->route_id)
		m_linemv->(dbcommit())
		m_linemv->cp_bqtyw := qtyconvert( m_linemv->cp_bqtyp,d_line->B_TYPE ,d_line->PLINE_ID,d_line->SIZE_ID , "P" , "W" ,,,d_line->route_id )
	ENDIF

ENDIF


d_line->(ordsetfocus(nOrderLine))
d_line->(dbgoto(nRecLine))
m_linemv->(dbgoto(nRecMv))
dbselectarea(nArea)
Return
/////////////////////////////////////////////////////////////////
STATIC Procedure ReturnValues()
local i
While !T_line->(eof())
      d_line->(dbgoto(t_line->RecNo))
      IF d_line->( RecLock(5,"lmvcentr") )
         FOR i := 1 TO d_line->( FCOUNT() )
               d_line->( FIELDPUT( i, t_line->( FIELDGET(i) ) ) )
         NEXT

         d_line->(xdbunlock())
      ENDIF
      t_line->(dbskip(1))
End
While !T_lineMV->(eof())
      (cDbf)->(dbgoto(t_linemv->RecNo))
      IF (cDbf)->( RecLock(5,"lmvcentr") )
         FOR i := 1 TO (cDbf)->( FCOUNT() )
             (cDbf)->( FIELDPUT( i, t_linemv->( FIELDGET(i) ) ) )
         NEXT
         (cDbf)->(dbcommit())
         (cDbf)->(dbunlock())
      ENDIF
      t_linemv->(dbskip(1))
End
RETURN
////////////////////////////////////////////////////////////////

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: CanDelete             Docs:                                ³
 * ³  Description: Test m_linemv for active production, for DELETion of recs  ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 08-18-96              Date updated: þ08-18-96              ³
 * ³ Time created: 05:20:05pm            Time updated: þ05:20:05pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: lRet                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC FUNCTION CanDelete

LOCAL lRet := FALSE

IF (cDbf)->cpproc_id == PROC_194 .OR. (cDbf)->cpproc_id == PROC_196
   Msg24("This process may not be deleted.",3,.t.)
ELSEIF !((cDbf)->arr .AND. (cDbf)->fin .AND. (cDbf)->sta) .AND. ((cParent)->cpproc_id <> (cDbf)->cpproc_id .OR. (cDbf)->cp_bqtys == 0) .OR. ;
		 !((cDbf)->arr .AND. (cDbf)->fin .AND. (cDbf)->sta) .AND. (cParent)->cpproc_id == (cDbf)->cpproc_id
   lRet := TRUE
ELSE
   Msg24("You may only delete stages later than the current one.",3,.t.)
ENDIF

RETURN lRet



/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: AddNewProc            Docs:                                ³
 * ³  Description: Add a new process to the batch production line             ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 09-01-96              Date updated: þ09-01-96              ³
 * ³ Time created: 11:42:18am            Time updated: þ11:42:18am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: NIL                                                        ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC FUNCTION AddNewProc(cStage,cGroup)

LOCAL cOldScr := SAVESCREEN()
LOCAL cProc    := SPACE(5)
local lRetVal
LOCAL cMovType := " "  // Recurring process by default
LOCAL cOldClr := SETCOLOR()
LOCAL lFromF6 := !Empty(cStage)
LOCAL cRoute := "    "
LOCAL cStageFrom := space(4)
LOCAL cStageTo := space(4)
LOCAL cFiltString
/*local iMusic := 1
local a := { { 392, 3 }, { 392, 1 }, { 440, 4 }, { 392, 4 }, ;
             { 523.3, 4 }, { 493.9, 8 }, { 392, 3 }, { 392, 1 }, ;
             { 440, 4 }, { 392, 4 }, { 523.3, 4 }, { 493.9, 8 }, ;
             { 393, 3 }, { 392, 1 }, { 784, 4 }, { 659.2, 4 }, ;
             { 523.3, 4 }, { 493, 4 }, { 440, 4 }, { 698.4, 3 }, ;
             { 698.4, 1 }, { 659.2, 4 }, { 523.3, 4 }, { 587.4, 4 }, ;
             { 523.4, 8 } }*/

c_rlib->( dbsetfilter({|| c_rlib->route_type == 'C'} ))//we need this for f2  VR

default cStage to space(4)
SETCOLOR("w+/bg, gr+/r")
IF Empty(cGroup)
   @9,21 CLEAR TO 18, 68
   DrawBox(9,21,19,68)
	@ 9, 23 SAY " New Stage " COLOR "w+/bg"
ELSE
   @9,20 CLEAR TO 13, 68
   DrawBox(9,20,14,68)
	@ 9, 23 SAY " New several processes " COLOR "w+/bg"
	@ 10, 22 SAY "The processes from chosen route will be added "
	@ 11, 22 SAY "           after the last stage."
ENDIF

SETCURSOR(1)
IF Empty(cGroup)
   @ 11, 23 SAY "Stage #:" COLOR "n/bg"
   @ 11, 31 GET cStage PICTURE "@K 99999" ;
                SEND PostBlock := {|o| PostStage(o,lFromF6)  }

   @ 13, 23 SAY "Process:" COLOR "n/bg"
   @ 13, 31 GET cProc PICTURE "@K 999.9"             ;
                SEND PreBlock  := {|o| PreProc(o)  } ;
                SEND PostBlock := {|o| PostProc(o,GETLIST[1])  }
   @ 15, 23 SAY "Movement type:" COLOR "n/bg"
   @ 15, 38 SAY "< R > Std. Repeat\Rework proc." COLOR "n/bg"
   @ 16, 38 SAY "< A > Std. Alternative proc.  " COLOR "n/bg" //edomo 2612860 12-06-02
   @ 17, 38 SAY "< N > Non Std. Rework proc.   " COLOR "n/bg" //Vitaly 00122708 14-02-01
   @ 18, 38 SAY "<SPACE> Normal                " COLOR "n/bg"

   @ 15, 37 GET cMovType PICTURE "!"                 ;
                SEND PreBlock  := {|o| PreType(o,GETLIST[2])} ;
                SEND PostBlock := {|o| PostType(o) }  // Normal o Recurring process for rework
ELSE
   @ 12, 33 SAY "Route #:" COLOR "n/bg"
   @ 12, 41 GET cRoute COLOR "W+/B,G+/R"  PICTURE "!!!!"                         ;
		      SEND preBlock  := {|o| SetF2Key( o, "c_rlib",{1,2,3},NIL,NIL,"irlibid") } ;
            SEND postBlock := {|o| PostIns(o) }
ENDIF

XREADALL

IF k <> 1 .AND. lCanSave .AND. Empty(cGroup)
   Add2Lmv(cStage,cProc,cMovType)
   lRetVal := .T.
ELSEIF k <> 1 .AND. !Empty(cGroup)
	InitBar(13,22,45)
	(cDbf)->( DBSEEK(d_line->b_id))
	While !(cDbf)->(eof()) .AND. (cDbf)->b_id == d_line->b_id
			 (cDbf)->(dbskip(1))
	End
	(cDbf)->(dbskip(-1))
	nLastStAge := (cDbf)->cp_stage
   NetUse( cRoute, STD_RETRY, RDD_IN_USE, USE_SHARED, USE_NEW, GetUserInfo():cRouteDir )
	(cRoute)->(dbgotop())
	While !(cRoute)->(EOF())
			nLastStAge := nLastStAge+10
			Add2Lmv(str(nLastStAge),(cRoute)->Proc_ID," ",cRoute,(cRoute)->proc_spec)
		   AdvanceBar((cRoute)->(recno())/(cRoute)->(lastrec()))
		//tone( a[ iMusic, 1 ], a[ iMusic, 2 ] * 2 )
		//iMusic++
		//IIF(Empty(a[iMusic]),iMusic := 1,nil)
		   (cRoute)->(dbskip(1))
	End
	(cRoute)->(dbclosearea())
	IF d_line->( RecLock(5,"add_several") )
		d_line->route_id2 := cRoute
		c_rlib->(dbseek(cRoute))
		d_line->ROUTE_REV2 := c_rlib->ROUTE_REV
		d_line->(xdbunlock())
	ENDIF
	lRetVal := .T.
ELSE
   lRetVal := .F.
ENDIF

c_rlib->( dbclearfilter()) // Just discard the saved filter

SETCOLOR( cOldClr )
RESTSCREEN(,,,,cOldScr)
SETCURSOR(0)
SETKEY(K_F2,NIL)

RETURN lRetVal
//////////////////////////////////////////
Static function PreIns(o,cRoute)
SetF2Key( o, GetUserInfo():cRouteDir+cRoute,{1,2,3},{|| o:varPut(str((cRoute)->STAGE,4))},NIL,NIL,,,,,,"route")
Return TRUE
Static function PostIns(o)
SetKey( K_F2 , NIL)
Return TRUE

//////////////////////////////////////////
STATIC PROCEDURE DeleteGroup()

LOCAL cOldScr := SAVESCREEN()
LOCAL cOldClr := SETCOLOR()
LOCAL cStageFrom := space(4)
LOCAL cStageTo := space(4)
LOCAL nRet := (cDbf)->(RecNo())
LOCAL lContinue := TRUE
LOCAL cProc_id
SETCOLOR("w+/bg, gr+/r")
@9,31 CLEAR TO 14, 60
DrawBox(9,31,15,60)
@ 9, 33 SAY "Delete several processes" COLOR "w+/bg"
SETCURSOR(1)

@ 11, 33 SAY "From Stage #:" COLOR "n/bg"
@ 11, 46 GET cStageFrom PICTURE "@K 99999" SEND PostBlock := {|o| (cDbf)->( DBSEEK(d_line->b_id+padl(Alltrim(cStageFrom),4))) .AND. CanDelete() .AND. (cParent)->cpproc_id <> (cDbf)->cpproc_id}

@ 13, 33 SAY "To   Stage #:" COLOR "n/bg"
@ 13, 46 GET cStageTo PICTURE "@K 99999" SEND PostBlock := {|o| Val(cStageTo) > Val(cStageFrom)  .AND. (cDbf)->( DBSEEK(d_line->b_id+padl(Alltrim(cStageTo),4) ) ) }

XREADALL
//////engine//////////////////////////
if k <> 1 .AND. (cDbf)->( DBSEEK(d_line->b_id+padl(Alltrim(cStageFrom),4) ) )
While lContinue
      IF val(cStageTo) == (cDbf)->cp_stage
         lContinue := !lContinue
      ENDIF

      IF ReadOnly()
         Msg24( {MSG_RO}, 3, TRUE )
      ELSE//IF CanDelete()
             TONE(800,0)
             StoreAudit("D")
             (cDbf)->( RecLock(5,"",.F.) )
             cProc_id := (cDbf)->cpproc_id
             (cDbf)->( DBDELETE() )
             (cDbf)->( DBUNLOCK() )
             (cDbf)->( DBSKIP(0) )
             IF d_line->( RecLock(5,"lmvcentr") ) // Vitaly 19-06-01 16191452
                d_line->ExpFinDate := batchCalc3("d_line")
             	 d_line->CP_DARR     := CTOD("  /  /  ")
 	          	 d_line->CP_TARR     := ""
                d_line->CP_WIDARR   := ""
 	          	 d_line->CP_DSTA     := CTOD("  /  /  ")
 	          	 d_line->CP_TSTA     := ""
 	          	 d_line->CP_WIDSTA   := ""
                d_line->( xDBUNLOCK() )
             ENDIF
             IF (d_line->CPPROC_ID == cProc_id) .AND. d_line->( RecLock(5,"delgroup") )
                 d_line->CP_BQTYP   := (cDbf)->CP_BQTYP
                 d_line->CP_BQTYS   := (cDbf)->CP_BQTYS
                 d_line->CP_BQTYW   := (cDbf)->CP_BQTYW
                 (cDbf)->( DBSKIP(1) )
                 d_line->CPWKSTN_ID := (cDbf)->cPWKSTN_id
                 d_line->CPPROC_ID  := (cDbf)->cpproc_id
                 d_line->CP_PCCODE  := (cDbf)->cP_PCCODE
                 (cDbf)->( DBSKIP(-1) )
                 IF (cDbf)->B_ID == d_line->b_id   // First movement  in the batch
                     d_line->PPPROC_ID  := (cDbf)->cpproc_id
                     d_line->PP_PCCODE  := (cDbf)->cP_PCCODE
                     d_line->PP_WKSTN   := (cDbf)->cPWKSTN_id
                     d_line->PP_BQTYP   := (cDbf)->CP_BQTYP
                     d_line->PP_BQTYS   := (cDbf)->CP_BQTYS
                	   d_line->PP_BQTYW   := (cDbf)->CP_BQTYW
 	          			(cDbf)->( DBSKIP() )
                 ELSE
                     (cDbf)->( DBSKIP() )
                     d_line->PPPROC_ID  := d_line->cpproc_id
               		d_line->PP_PCCODE  := d_line->cP_PCCODE
               		d_line->PP_WKSTN   := d_line->cPWKSTN_id
               		d_line->PP_BQTYP   := d_line->CP_BQTYP
               		d_line->PP_BQTYS   := d_line->CP_BQTYS
                		d_line->PP_BQTYW   := d_line->CP_BQTYW
                 ENDIF
 	              d_line->( xDBUNLOCK() )
 	          	  IF (cDbf)->( RecLock(5,"",.F.) )
 	          		  (cDbf)->CPWKSTN_ID := d_line->cPWKSTN_id
 	          		  (cDbf)->CP_BQTYP   := d_line->CP_BQTYP
 	          		  (cDbf)->CP_BQTYS   := d_line->CP_BQTYS
 	          		  (cDbf)->CP_BQTYW   := d_line->CP_BQTYW
 	          		  (cDbf)->( DBUNLOCK() )
 	          	  ENDIF
		       ENDIF
      ENDIF
		(cDbf)->( DBSKIP(1))
END
endif
///////////////////////////////////////
SETCOLOR( cOldClr )
RESTSCREEN(,,,,cOldScr)
SETCURSOR(0)
SETKEY(K_F2,NIL)
(cDbf)->(dbgoto(nRet))
RETURN

///////////////////////////////////////////

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: PostStage()           Docs:                                ³
 * ³  Description: check for acceptable stage code                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 08-29-96              Date updated: þ08-29-96              ³
 * ³ Time created: 01:46:03pm            Time updated: þ01:46:03pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: oGet                                                       ³
 * ³ Return Value: None                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC FUNCTION PostStage(oGet,lFromF6)

LOCAL cCurr
LOCAL nRec := (cDbf)->( RECNO() )
LOCAL cStage := PADL(ALLTRIM(oGet:VarGet()),4)
LOCAL lRet := TRUE
LOCAL cPrevStage
(cDbf)->(dbskip(2)) //vitaly
cPrevStage := (cDbf)->cp_stage
(cDbf)->(dbgotop())
IF (cDbf)->( DBSEEK(d_line->b_id+cStage) )
   Msg24("Stage #:"+ALLTRIM(cStage)+" already exists!", 3, .T. )
   lRet := FALSE
ELSEIF lFromF6
   (cDbf)->( ordSetFocus(1) )
   (cDbf)->(DBSEEK(d_line->b_id+d_line->cpproc_id))
   IF VAL(cStage) <= (cDbf)->cp_stage .OR. VAL(cStage) >= cPrevStage
      Msg24("A new process may only be added BETWEEN the Current and Previous stages.",3, .T. )
      lRet := FALSE
   END
ELSE
   (cDbf)->( ordSetFocus(1) )
   (cDbf)->(DBSEEK(d_line->b_id+d_line->cpproc_id))
   IF VAL(cStage) <= (cDbf)->cp_stage
      Msg24("A new process may only be added AFTER the Current stage.",3, .T. )
      lRet := FALSE
   END
ENDIF
(cDbf)->( ordSetFocus(2) )
(cDbf)->( DBGOTO( nRec) )
RETURN lRet

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: PreProc()             Docs:                                ³
 * ³  Description: setup hotkey for picklist of processes                     ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 08-29-96              Date updated: þ08-29-96              ³
 * ³ Time created: 01:40:53pm            Time updated: þ01:40:53pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: oGet                                                       ³
 * ³ Return Value: .T.                                                        ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC FUNCTION PreProc(o)
SetF2Key( o , "c_proc")
RETURN .T.

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: PostProc()            Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 08-29-96              Date updated: þ08-29-96              ³
 * ³ Time created: 01:41:25pm            Time updated: þ01:41:25pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: oGet                                                       ³
 * ³ Return Value: FUNCTION PostProc(oGet)                                    ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC FUNCTION PostProc(oGet,oStage)

LOCAL nRec   := (cDbf)->( RECNO() )
LOCAL lRet   := FALSE
LOCAL cBid   := (cDbf)->b_id
LOCAL uVal   := oGet:varGet()
LOCAL uStage := VAL( oStage:Varget() )
LOCAL uLast
LOCAL uLVal
LOCAL uNxt2Last
LOCAL uN2LVal
IF EMPTY( uVal )
  Msg24("Process may not be left blank!.",3,.T.)
ELSEIF c_proc->(DBSEEK( uVal ))
  if "CZ" $ GetUserInfo():cGroupID
     @ oGet:row , oGet:col+5  SAY c_proc->proc_nme COLOR "W+/B"
  else
	  @ oGet:row , oGet:col+3  SAY c_proc->proc_nmh COLOR "W+/B"
  endif
  lRet := TRUE
ELSE
  Msg24("Process not found in lookup table.",3,.T.)
END

IF (cDbf)->( DBSEEK(cBid) )
   WHILE (cDbf)->b_id == cBid
         (cDbf)->(DBSKIP())
   END
   (cDbf)->(DBSKIP(-1))
   uLast := (cDbf)->cp_stage
   uLVal := (cDbf)->cpproc_id
   (cDbf)->(DBSKIP(-1))
   uNxt2Last := (cDbf)->cp_stage
   uN2LVal   := (cDbf)->cpproc_id
END

IF (uVal == PROC_194  .AND. uStage < uLast) .OR. ;
   (uVal <> PROC_194 .AND. uStage > uLast .AND. uLVal == PROC_194 )
   Msg24( "Warehousing must be the last stage.", 3, .t. )
   lRet := .F.
ELSEIF (uVal == PROC_196 .AND. uStage < uNxt2Last) .OR. ;
       (uVal <> PROC_196 .AND. uVal <> PROC_194 .AND. uStage > uNxt2Last .AND. uN2LVal == PROC_196)
   Msg24( "Final testing must be the next to last stage.", 3, .t. )
   lRet := .F.
ENDIF
(cDbf)->( DBGOTO(nRec) )
lCanSave := lRet
RETURN lRet
///////////////////////////////////////////////////////
STATIC FUNCTION PreType(oGet,oProc)  //Vitaly 00122708 14-02-01

LOCAL nRec   := (cDbf)->( RECNO() )
LOCAL cBid   := (cDbf)->b_id
LOCAL uVal   := oProc:Varget()

(cDbf)->( ORDSETFOCUS("ilnmvbn") ) // b_id+proc
if (cDbf)->( DBSEEK( d_line->b_id + uVal ) ) // New Proc already exists
     oGet:varPut("R")
else
     oGet:varPut("N")
endif
(cDbf)->( ordSetFocus(2) )
(cDbf)->( DBGOTO(nRec) )
RETURN .T.
///////////////////////////////////////////////////////////
STATIC FUNCTION PostType(oGet) //Vitaly 00122708 14-02-01, ID:2612860
Return oGet:VarGet() $ " _R_N_A"
/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: Add2Lmv               Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 09-01-96              Date updated: þ09-01-96              ³
 * ³ Time created: 02:16:46pm            Time updated: þ02:16:46pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: cStage,cProc                                               ³
 * ³ Return Value: NIL                                                        ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC FUNCTION Add2Lmv(cStage,cProc,cMovType,cRoute,cProcSpec)

LOCAL aFields := {}, cWip
LOCAL cWipDir:= GetUserInfo():cWipCostDir
LOCAL i, cBid, nI1, nI2, nI3, lProcExists := .F.
LOCAL aEmpties := ;
 {"ARR","CP_DARR","CP_TARR","CP_WIDSTA","STA","CP_DSTA","CP_TSTA","CP_WIDSTA",;
  "FIN","CP_DFIN","CP_TFIN","CP_WIDFIN","PROC_SPEC","I1","I2","I3",;
  "CP_BQTYP","CP_BQTYS","CP_BQTYW","CP_TOTSCR","B_LREJ","DISCR_REP","CP_ADJSCR"}

(cDbf)->( ORDSETFOCUS("ilnmvbn") ) // b_id+proc
if (cDbf)->( DBSEEK( d_line->b_id + cProc ) ) // New Proc already exists
     nI1        := (cDbf)->I1
     nI2        := (cDbf)->I2
     nI3        := (cDbf)->I3
     lProcExists:= .T.
endif
(cDbf)->( ORDSETFOCUS("ilnmvbs") )
(cDbf)->( DBSEEK( d_line->b_id + STR(VAL(cStage),4), TRUE ) )
(cDbf)->( DBSKIP(-1) )
FOR i := 1 TO (cDbf)->( FCOUNT() )
    AADD( aFields, (cDbf)->( FIELDGET(i) ) )
NEXT

IF !(cDbf)->( AddRec(5,"lmvcentr") )
   ALERT("ERROR;;Unable to save record!",{"OK"})
   RETURN NIL
END

FOR i := 1 TO (cDbf)->( FCOUNT() )
    IF ASCAN( aEmpties, ALLTRIM((cDbf)->( FIELDNAME(i) )) ) == 0
       (cDbf)->( FIELDPUT(i ,aFields[i] ) )
    END
NEXT

(cDbf)->cp_stage  := VAL(cStage)
(cDbf)->cpproc_id := cProc
IF !Empty(cRoute)
	(cDbf)->ROUTE_ID  := cRoute
	(cDbf)->proc_spec := cProcSpec
ENDIF

C_proc->( DBSEEK( cProc ) )
(cDbf)->CP_PCCODE  := c_proc->pcprocno
(cDbf)->CPWKSTN_ID := c_proc->wkstn_id

IF cMovType = "R"
     (cDbf)->proc_type := "R"  // Rework - process requested by user
ELSEIF cMovType = "N"          //vitaly 01122708 14-02-01
     (cDbf)->proc_type := "N"
ELSEIF cMovType = "A"          //vitaly 01122708 14-02-01
     (cDbf)->proc_type := "A"
ELSE
     (cDbf)->proc_type := " "
ENDIF
(cDbf)->( DBCOMMIT() )
(cDbf)->( DBUNLOCK() )

IF d_line->( RecLock(5,"lmvcentr") ) //Vitaly 19-06-01 16191452
   d_line->ExpFinDate := batchCalc3("d_line")
ENDIF
RETURN NIL

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: LmvName()             Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 09-01-96              Date updated: þ09-01-96              ³
 * ³ Time created: 02:16:52pm            Time updated: þ02:16:52pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: cProcId                                                    ³
 * ³ Return Value: RIGHT(c_proc->proc_nmh,10)                                 ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION LmvName( cProcId,lFromDat)

LOCAL cRet
LOCAL lClose := FALSE
default lFromDat to FALSE



IF SELECT("c_proc") == 0
   GenOpenFiles({"c_proc"})
   lClose := TRUE
ENDIF

c_proc->( DBSEEK( cProcId) )

if "CZ" $ GetUserInfo():cGroupID
   IF !lFromDat
	    cRet :=  SUBSTR(c_proc->proc_nme,1,14)
   ELSE
	    cRet :=  cProcId + " " + SUBSTR(c_proc->proc_nme,1,14)
   ENDIF
else
   IF !lFromDat
	    cRet :=  SUBSTR(c_proc->proc_nmh,-14)
   ELSE
	    cRet :=  cProcId + " " + SUBSTR(c_proc->proc_nmh,-14)
   ENDIF
endif


IF lClose
   CLOSE c_proc
ENDIF

RETURN cRet


FUNCTION LmvUOM( cProcId )

LOCAL cRet
LOCAL lClose := FALSE

IF SELECT("c_proc") == 0
   GenOpenFiles({"c_proc"})
   lClose := TRUE
ENDIF

c_proc->( DBSEEK( cProcId) )
cRet := c_proc->UOM_ID
IF lClose
   CLOSE c_proc
ENDIF

RETURN cRet

function InsertStuff(cStage,cGroup)
local lRetVal := .F.
default cStage  to space(4)
     IF d_line->b_stat == "C"
        Msg24("A new process may NOT be added to a closed batch.", 3, .T. )
     ELSE
        lRetVal := AddNewProc(cStage,cGroup)
     ENDIF
return lRetVal

**********************************************
Static Function CurrPass()
Return (cDbf)->cpproc_id == (cParent)->cpproc_id .AND. ! (cDbf)->FIN .AND. (cDbf)->CP_BQTYP <> 0

function advanceStuff(oBroCenter,lDoItAlready)

default ldoItAlready to .F.

IF ReadOnly() .AND. Alltrim(GetUserInfo():cGroupID) <> "CZ_MGR"
     Msg24( {MSG_RO}, 3, TRUE )
ELSEIF (((cDbf)->ARR .AND. (cDbf)->STA .AND. (cDbf)->FIN) .OR. (cDbf)->cp_bqtyp == 0) .AND. !lDoItAlready
     Msg24("You must be on the current process to run this function.",3,.T.)
ELSEIF (cDbf)->cpproc_id $ "194.0+196.0"
     Msg24("You cannot advance past this process !",3,.T.)
ELSEIF (cDbf)->b_stat $ "E_M"
     Msg24("You cannot step forward this batch ! Current status is:"+(cDbf)->b_stat,3,.T.)
ELSE
     IF !lDoItAlready
          IF (ALERT([Pressing "OK" will unconditionally; advance one process.],;
               {" OK "," No thanks "}) == 1)
               Advance1Step(.t.)
          ENDIF
          oBroCenter:oBro:refreshAll()
     else
          Advance1Step()
          oBroCenter:oBro:refreshAll()
     ENDIF
ENDIF
return nil

**************************
function calcRightcStage()
local nRetval
nRetval := (nPrevStage+nLastStage)/2
IF nRetval - round(nRetval,0) == -0.5
     nRetVal := nRetVal - 0.1
ENDIF
nRetVal := round(nRetval,0)
return alltrim(str(nRetVal,4))
******************************
Function GetProcType() //VR 25-06-01 16251489
Return IIF(!Empty(cDbf) ,(cDbf)->proc_type ,FIELD->proc_type )//(cDbf)->proc_type

Static Function GetExpQty(aExp)
Local aRet := {},i
Local aUOM := {"P","S","W"}
IF Empty(aExp)
FOR i := 1 TO 3
    IF c_expqty->(dbseek(aUOM[i]+(cDbf)->b_type+(cDbf)->size_id))
		 While  aUOM[i]+(cDbf)->b_type+(cDbf)->size_id == c_expqty->uom_id+c_expqty->b_type+c_expqty->size_id
			  IF (cDbf)->value_id <= c_expqty->HVal_lim .AND. (cDbf)->value_id >= c_expqty->LVal_lim .AND. (cDbf)->tol_id == c_expqty->tol_id
				  AADD(aRet,{c_expqty->exp_yld,c_expqty->(RecNo()),Str(c_expqty->LVal_lim,8,3),Str(c_expqty->HVal_lim,8,3)})
				  EXIT
			  ENDIF
			  c_expqty->(dbskip(1))
		 End
    ENDIF
NEXT
ELSE
FOR i := 1 TO 3
    c_expqty->(dbgoto(aExp[i,2]))
	 IF c_expqty->( RecLock(15,"TAPI") )
		 c_expqty->exp_yld := aExp[i,1]
		 c_expqty->(dbunlock())
	 ENDIF
NEXT
ENDIF

Return aRet

Static Procedure SetLead()

LOCAL cScreen := SaveScreen()
local nLead := GetSngLeadt()
local aExp  := GetExpQty()

set cursor on
@12, 22 CLEAR TO 18, 65
DrawBox( 12, 22, 18, 65 )

@12, 23 SAY "Update lead time/Exp.Qty"


@13, 30 SAY "Lead time   : " GET nLead PICTURE "99.99"
@14, 23 SAY "Pcs. Exp.Qty("+aExp[1,3] +"-"+aExp[1,4]+") :"  GET aExp[1,1] PICTURE "9.9999"
@15, 23 SAY "Str. Exp.Qty("+aExp[2,3] +"-"+aExp[2,4]+") :"  GET aExp[2,1] PICTURE "9.9999"
@16, 23 SAY "Wfr. Exp.Qty("+aExp[3,3] +"-"+aExp[3,4]+") :"  GET aExp[3,1] PICTURE "9.9999"

READ

IF LastKey() <> K_ESC
	GetSngLeadt(nLead)
	GetExpQty(aExp)
ENDIF
set cursor off
RestScreen( ,,,, cScreen )

Return