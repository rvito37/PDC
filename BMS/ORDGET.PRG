#include "avxdefs.ch"

STATIC lAppendMode ,;
       oLockKey    ,;
       oOrders     ,;
       nKey        ,;
		 aoOpenedList,;
		 aPtype      ,;
       cEsnCurr

// u- updateable field  r- read only field
STATIC uPOLN_ID    ,;
       uLINE       ,;
       uSIZE       ,;
       uVALUE      ,;
       uSONO       ,;
       uSONOLN     ,;
		 lSONOCng    ,;
       uSOORDLN    ,;
       uSOORDLN_NO ,;
       uPOLN_LOG   ,;
       rCUCO_ID    ,;
       uCU_ID      ,;
       rSAREA_ID   ,;
       uBILLAG_ID  ,;
       uSHIPAG_ID  ,;
       rENDCUCO_ID ,;
       uENDCU_ID   ,;
       uPROJ_ID    ,;
       uSO_PN      ,;
       uCU_PN      ,;
       uESN_ID     ,;
		 uAVXIL_PN   ,;
       uPOLN_STAT  ,;
       uPOLN_TYPE  ,;
       uD_ORDREC   ,;
       uD_RQSTDLV  ,;
       rD_ACKNDLV  ,;
       rD_REVDLV   ,;
       rD_MKRQREV  ,;
       uD_MKRQDLV  ,;
       uQTY_ORD    ,;
       uQTY_WAFER  ,;
       uCURR_POLN  ,;
       uSPCU_EA    ,;
       rSPCU_POLN  ,;
       rSPD_POLN   ,;
       uTPCU_EA    ,;
       rTPCU_POLN  ,;
       rTPD_POLN   ,;
       rSTDC_POLN  ,;
       uQTY_CANC   ,;
       uD_EXCH     ,;
       rEXCH_RATE  ,;
       uPOLN_MESS1 ,;
       rPOLN_MESS2 ,;
       uROUTE_ID   ,;
       uInitiator  ,;
       ud_mrkdlv   ,;
		 uDielId     ,;
       uDielWidth  ,;
		 uBnCaps     ,;
		 uProduct    ,;
		 uVoltId     ,;
		 uSrbId      ,;
		 dDateTp     ,;
		 cIniTp


STATIC cDbf, nDbf, aValues, cLine24

/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: ordGet()                                                   ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine         Designer:                            ³
 * ³ Date created: 08-04-96              Date updated: ş08-04-96              ³
 * ³ Time created: 10:54:00am            Time updated: ş10:54:00am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: pKey                                                       ³
 * ³             : cCallingProc                                               ³
 * ³             : cWhichDbf                                                  ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
PROCEDURE ordGet( pKey , cCallingProc, cWhichDbf )

LOCAL aFiles  := GenOpenFiles({"d_esn","c_esny","c_esnxx","c_volt","c_tc","c_rlib","d_revord","c_diel","c_bncaps"})
LOCAL oForm
LOCAL cMsg := IF( pKey = K_INS .or. pKey = K_CTRL_ENTER, "New request" , ;
                 IF( UPPER(cWhichDbf) == "D_ORD", "Edit an order","Edit a request" ) )
LOCAL aOldTitles
LOCAL nSaveRec
LOCAL lContinue := FALSE
LOCAL lCopy := FALSE
local lRnd := (UPPER(cWhichDbf) == "D_ORDRND")
local cRights := setRights() //vr id:1941935
default lRND to FALSE

IF AutoRates()  .AND. !(lRND)
   ChangeRates()
ENDIF

cDbf :=  cWhichDbf // just to make it STATIC instead of LOCAL
nDbf := IF( UPPER(cDbf) == "D_ORD", DBF_ORD,;
               IF( UPPER(cDbf) == "D_ORDREQ", DBF_ORDREQ,DBF_ORDRND))
IF nDbf == DBF_ORD
   c_postat->( AOFSetFilter("c_postat->scope == 'O' .OR. c_postat->scope == 'B' " ))
ELSEif nDbf == DBF_ORDREQ
   c_postat->( AOFSetFilter("c_postat->scope == 'R' .OR. c_postat->scope == 'B' " ))
ELSEIF nDbf == DBF_ORDRND .AND. cRights == "R"
     c_rlib->( AOFSetFilter("c_rlib->route_type == 'R' .OR. c_rlib->route_type == 'X' " ))
     genopenfiles({"c_tinit"})
     c_tinit->( AOFSetFilter("trim(c_tinit->ini_group) == 'R&D'" ))//vr id:1941935
ELSEIF nDbf == DBF_ORDRND .AND. cRights == "X"
     c_rlib->( AOFSetFilter("c_rlib->route_type $ 'R_X_C' " ))
     genopenfiles({"c_tinit"})
     c_tinit->( AOFSetFilter("trim(c_tinit->ini_group) == 'ENGINERING'" ))
ENDIF


SetKey( K_ALT_R , { || ChangeRates() } )

lAppendMode := ( pKey != K_ENTER )

nKey := pKey

IF Upper( cCallingProc ) $ "VIEW_BROW_"
   aOldTitles := SetTitle( cMsg , ProcName() )
ELSE
   oForm := Form():new(,,,, cMsg ,, ProcName() )
ENDIF

oLockKey := LockKey():new(cDbf)

// only in append mode we clear the screen
// in update we use the information on screen already

IF pKey = K_CTRL_ENTER
   lCopy := TRUE
ENDIF

// hide the help line
NoHelp()

IF lAppendMode .and. ! lCopy
   IF lRND
        ordscRNDSayCaptions()
   ELSE
        ordSayCaptions()
   ENDIF
ENDIF

nSaveRec := (cDbf)->( RecNo() )

   ordLoadValues(lCopy,lRnd)
   IF lCopy
        IF lRND
          ordRNDSayItAgain( aValues )
        else
          ordSayItAgain( aValues )
        endif
   ENDIF


IF EnterData(lRND)
  (cDbf)->( ReplaceData() )
ELSE
  (cDbf)->( DbGoTo( nSaveRec ) )
ENDIF

GetList := {}

IF Upper( cCallingProc ) $ "VIEW_BROW"
   OldTitle( aOldTitles)
ELSE
   oForm:hide()
ENDIF

SetKey( K_ALT_R , NIL )

ClearNoHelp()
GenCloseFiles(aFiles)
RETURN


/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: ordLoadValues                                              ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine         Designer:                            ³
 * ³ Date created: 08-04-96              Date updated: ş08-04-96              ³
 * ³ Time created: 10:52:00am            Time updated: ş10:52:00am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: None                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC PROCEDURE ordLoadValues(lCopy,lRnd)
Default lCopy To FALSE
Default lRnd To FALSE

IF lAppendMode .and. ! lCopy
   (cDbf)->( DbGoTo( 0 ) )
ELSE

   //IF !oLockKey:lockRec()   // lock the record
   //   RETURN
   //ENDIF

   //oLockKey:incKey()  // increment the record key

ENDIF

uPOLN_ID    :=  (cDbf)->POLN_ID
uSONO       :=  (cDbf)->SONO
uSONOLN     :=  (cDbf)->SONOLN
uSOORDLN    :=  (cDbf)->SOORDLN
uSOORDLN_NO :=  (cDbf)->SOORDLN_NO
uPOLN_LOG   :=  (cDbf)->POLN_LOG
rCUCO_ID    :=  (cDbf)->CUCO_ID
uCU_ID      :=  (cDbf)->CU_ID
rSAREA_ID   :=  (cDbf)->SAREA_ID
uBILLAG_ID  :=  (cDbf)->BILLAG_ID
uSHIPAG_ID  :=  (cDbf)->SHIPAG_ID
rENDCUCO_ID :=  (cDbf)->ENDCUCO_ID
uENDCU_ID   :=  (cDbf)->ENDCU_ID
uPROJ_ID    :=  (cDbf)->PROJ_ID
uSO_PN      :=  (cDbf)->SO_PN
uCU_PN      :=  (cDbf)->CU_PN
uESN_ID     :=  (cDbf)->ESN_ID
uAVXIL_PN   :=  (cDbf)->AVXILPN
uPOLN_STAT  :=  IF( lAppendMode, "H", (cDbf)->POLN_STAT )
uPOLN_TYPE  :=  (cDbf)->POLN_TYPE
uD_ORDREC   :=  (cDbf)->D_ORDREC
uD_RQSTDLV  :=  (cDbf)->D_RQSTDLV
rD_ACKNDLV  :=  (cDbf)->D_ACKNDLV   //  mrkOrdDue(.T.,cDbf)  //YG revdue
rD_REVDLV   :=  (cDbf)->D_REVDLV
uD_ORDREC   :=  (cDbf)->D_ORDREC
uD_MRKDLV   :=  (cDbf)->D_MRKDLV
uCURR_POLN  :=  (cDbf)->CURR_POLN
uSPCU_EA    :=  (cDbf)->SPCU_EA
rSPCU_POLN  :=  (cDbf)->SPCU_POLN
rSPD_POLN   :=  (cDbf)->SPD_POLN
uTPCU_EA    :=  (cDbf)->TPCU_EA
rTPCU_POLN  :=  (cDbf)->TPCU_POLN
rTPD_POLN   :=  (cDbf)->TPD_POLN
rSTDC_POLN  :=  (cDbf)->STDC_POLN
uQTY_CANC   :=  (cDbf)->QTY_CANC
uD_EXCH     :=  (cDbf)->D_EXCH
rEXCH_RATE  :=  (cDbf)->EXCH_RATE
uPOLN_MESS1 :=  (cDbf)->POLN_MESS1
rPOLN_MESS2 :=  (cDbf)->POLN_MESS2
uQTY_ORD    :=  (cDbf)->qty_ord //YG how could this have been missing?
rd_mkrqrev  :=  (cDbf)->d_mkrqrev //YG 14.3.99  // changed from date1 SS 18.07.99
ud_mkrqdlv  :=  (cDbf)->d_mkrqdlv // SS 18.07.99
cIniTp := Space(10)
dDateTp:= CTOD("  /  /  ")
IF UPPER(Cdbf) == "D_ORDRND"
	  uPOLN_TYPE :=  setRights()
     uRoute_id  := (cDbf)->route_id
     uInitiator := (cDbf)->init_id
     uqty_wafer := (cDbf)->qty_wafer
     uLINE      := (cDbf)->pline_id  //vr id:1941935
     uSIZE      := (cDbf)->size_id   //vr
     uVALUE     := (cDbf)->value_id  //vr
	  uDielId    := (cDbf)->Diel_id
	  uDielWidth := (cDbf)->Diel_width
	  uBnCaps    := (cDbf)->b_ncaps
	  uSrbId     := (cDbf)->srb_id
	  uVoltId    := (cDbf)->Volt_id
	  uProduct   := (cDbf)->BType_Nme
ENDIF
IF lAppendMode
   uPOLN_ID := NewOrdNo(cDbf)
   uD_RQSTDLV := ;
   uD_ORDREC  := ;
   uD_EXCH    := date()
   uPOLN_STAT := "H"
   IF lRnd
        uD_RQSTDLV := date() + 1
   ENDIF
   IF lCopy
        uSONOLN     :=  Space(1)
        uSOORDLN_NO :=  Space(1)
        uQTY_ORD    :=  0
        rSPD_POLN   :=  0
        rTPD_POLN   :=  0
        rSTDC_POLN  :=  0
        uQTY_CANC   :=  0
        oLockKey:unLockRec()
   ENDIF
ELSE
   oLockKey:unLockRec()
ENDIF

aValues := {;
            uPOLN_ID        ,;
            uSONO           ,;
            uSONOLN         ,;
            uSOORDLN        ,;
            uSOORDLN_NO     ,;
            uPOLN_LOG       ,;
            rCUCO_ID        ,;
            uCU_ID          ,;
            rSAREA_ID       ,;
            uBILLAG_ID      ,;    //10
            uSHIPAG_ID      ,;
            rENDCUCO_ID     ,;
            uENDCU_ID       ,;
            uPROJ_ID        ,;
            uSO_PN          ,;
            uCU_PN          ,;
            uESN_ID         ,;
				uAVXIL_PN       ,;
            uPOLN_STAT      ,;
            uPOLN_TYPE      ,;
            uD_ORDREC       ,;     //20
            uD_RQSTDLV      ,;
            rD_ACKNDLV      ,;
            rD_REVDLV       ,;
            uQTY_ORD        ,;
            uCURR_POLN      ,;     //25
            uSPCU_EA        ,;
            rSPCU_POLN      ,;
            rSPD_POLN       ,;
            uTPCU_EA        ,;
            rTPCU_POLN      ,;      //30
            rTPD_POLN       ,;
            rSTDC_POLN      ,;
            uQTY_CANC       ,;
            uD_EXCH         ,;
            rEXCH_RATE      ,;  //35
            uPOLN_MESS1     ,;
            rPOLN_MESS2     ,;
            uD_MKRQDLV      ,;
            uD_MRKDLV       ;
            }
IF UPPER(Cdbf) == "D_ORDRND"
     aadd(aValues,uRoute_id)  //39
     aadd(aValues,uInitiator)  //40
     aadd(aValues,uLINE)//vr
     aadd(aValues,uSIZE) //vr
     aadd(aValues,uVALUE) //vr
	  aadd(aValues,uDielId)
	  aadd(aValues,uDielWidth)
	  aadd(aValues,uBnCaps)
	  aadd(aValues,uSrbId)
     aadd(aValues,uProduct)
     aadd(aValues,uVoltId)
else
     aadd(aValues,rD_MKRQREV)  //39  //YG 14.3.99
ENDIF

RETURN

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: ResetSomeVars         Docs:                                ³
 * ³  Description: for resetting certain vars for continual editing           ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 08-04-96              Date updated: ş08-04-96              ³
 * ³ Time created: 11:18:09am            Time updated: ş11:18:09am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: FUNCTION ResetSomeVars                                     ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC FUNCTION ResetSomeVars

 uPOLN_ID := NewOrdNo()
 uD_RQSTDLV := ;
 uD_ORDREC  := ;
 uD_EXCH    := date()
 uPOLN_STAT := "H"
 uSO_PN      :=  SPACE(20)
 uCU_PN      :=  SPACE(20)
 uESN_ID     :=  SPACE(16)
 uAVXIL_PN   :=  SPACE(20)
 cIniTp := Space(10)
 dDateTp:= CTOD("  /  /  ")
RETURN NIL
/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: NewOrdNo              Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 08-04-96              Date updated: ş08-04-96              ³
 * ³ Time created: 10:51:54am            Time updated: ş10:51:54am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: o:nFullOrderNo                                             ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION NewOrdNo(cDbf)

LOCAL nOldSelect := SELECT()
LOCAL nOrdNo
default cDbf to "d_ordreq"

IF lower(cDbf) == "d_ordreq"
     NetUse( "n_Ordreq", STD_RETRY, RDD_IN_USE, USE_EXCLUSIVE, USE_NEW, NIL )
     nOrdNo := n_Ordreq->Poln_id + 1
     n_Ordreq->Poln_id := nOrdNo
     CLOSE n_Ordreq
elseif lower(cDbf) == "d_ordrnd"
     NetUse( "n_Ordrnd", STD_RETRY, RDD_IN_USE, USE_EXCLUSIVE, USE_NEW, NIL )
     nOrdNo := n_Ordrnd->Poln_id + 1
     n_Ordrnd->Poln_id := nOrdNo
     CLOSE n_Ordrnd
ENDIF
SELECT (nOldSelect)
RETURN nOrdNo

/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: ReplaceData                                                ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine         Designer:                            ³
 * ³ Date created: 08-04-96              Date updated: ş08-04-96              ³
 * ³ Time created: 10:52:22am            Time updated: ş10:52:22am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: None                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC PROCEDURE ReplaceData
LOCAL lWriteRec := .F.
LOCAL o , i
LOCAL cSav24 := SAVESCREEN(24,0,24,79)
LOCAL nOldSelect := SELECT()
LOCAL lSV_E   := (cDbf)->POLN_STAT  == uPOLN_STAT .AND. uPOLN_STAT == "E"
LOCAL lSV_E_H := (cDbf)->POLN_STAT  == "E" .AND. uPOLN_STAT == "H"

IF lAppendMode
   IF oLockKey:appendRec()
      lWriteRec := .T.
   ENDIF
ELSE
   IF oLockKey:lockRec() // .AND. oLockKey:compareKey()
      // No chance 2 users may edit the exact same P/O !!
      // The comparekey only caused problems... 23/05/02 D.Laor
      lWriteRec := .T.
      // Update m_ord/m_ordreq with original values
      @24, 0 SAY  "Updating record, please be patient..."
      IIF(lSV_E_H .OR. lSV_E, nil ,UpdateLogFile("0"))
   ENDIF
ENDIF

IF !lWriteRec
   oLockKey:unLockRec()
   RETURN
ENDIF

IF !lAppendMode
   GetUserInfo():updateUserInRec( cDbf , "ORDGET"  )
ENDIF

(cDbf)->POLN_ID    := uPOLN_ID
(cDbf)->SONO       := uSONO
(cDbf)->SONOLN     := uSONOLN
(cDbf)->SOORDLN_NO := uSOORDLN_NO
(cDbf)->SOORDLN    := uSOORDLN
(cDbf)->POLN_LOG   := uPOLN_LOG
(cDbf)->CUCO_ID    := rCUCO_ID
(cDbf)->CU_ID      := uCU_ID
(cDbf)->SAREA_ID   := rSAREA_ID
(cDbf)->BILLAG_ID  := uBILLAG_ID
(cDbf)->SHIPAG_ID  := uSHIPAG_ID
(cDbf)->ENDCUCO_ID := rENDCUCO_ID
(cDbf)->ENDCU_ID   := uENDCU_ID
(cDbf)->PROJ_ID    := uPROJ_ID
(cDbf)->SO_PN      := uSO_PN
(cDbf)->CU_PN      := uCU_PN
(cDbf)->ESN_ID     := uESN_ID
(cDbf)->AVXILPN    := uAVXIL_PN
(cDbf)->POLN_STAT  := uPOLN_STAT
(cDbf)->POLN_TYPE  := uPOLN_TYPE
(cDbf)->D_ORDREC   := uD_ORDREC
(cDbf)->D_RQSTDLV  := uD_RQSTDLV
(cDbf)->D_ACKNDLV  := rD_ACKNDLV
(cDbf)->D_REVDLV   := rD_REVDLV
(cDbf)->QTY_ORD    := uQTY_ORD
(cDbf)->CURR_POLN  := uCURR_POLN
(cDbf)->SPCU_EA    := uSPCU_EA
(cDbf)->SPCU_POLN  := rSPCU_POLN
(cDbf)->SPD_POLN   := rSPD_POLN
(cDbf)->TPCU_EA    := uTPCU_EA
(cDbf)->TPCU_POLN  := rTPCU_POLN
(cDbf)->TPD_POLN   := rTPD_POLN
(cDbf)->STDC_POLN  := rSTDC_POLN
(cDbf)->QTY_CANC   := uQTY_CANC
(cDbf)->D_EXCH     := uD_EXCH
(cDbf)->EXCH_RATE  := rEXCH_RATE
(cDbf)->POLN_MESS1 := uPOLN_MESS1
IF !Empty(cIniTp)
   (cDbf)->POLN_MESS2 := AllTrim(rPOLN_MESS2) + "TP:"+DTOC(dDateTp)+ " "+cIniTp
ELSE
   (cDbf)->POLN_MESS2 := rPOLN_MESS2
ENDIF
IF UPPER(Cdbf) == "D_ORDRND"
     (cDbf)->route_id   := uRoute_id
     (cDbf)->init_id    := uInitiator
     (cDbf)->QTY_WAFER  := uQTY_WAFER
     (cDbf)->poln_type  := setRights() //vitaly id:1941935
	  (cDbf)->Diel_id    := uDielId
	  (cDbf)->Diel_width := uDielWidth
	  (cDbf)->b_ncaps    := uBnCaps
	  (cDbf)->srb_id     := uSrbId
	  (cDbf)->Volt_id    := uVoltId
	  (cDbf)->BType_Nme := uProduct

ENDIF
IF ud_mrkdlv <> NIL .AND. (cDbf)->D_MRKDLV <> uD_MRKDLV //YG 14/3/99
          (cDbf)->D_MRKDLV := uD_MRKDLV
          d_revord->(addrec(5,"ORDGET"))
          d_revord->poln_id  := (cDbf)->poln_id
          d_revord->d_mrkdlv := uD_MRKDLV
          d_revord->d_rev    := date()
ENDIF
IF ud_mkrqdlv <> NIL .AND. (cDbf)->D_MKRQDLV <> uD_MKRQDLV //YG 14/3/99
          (cDbf)->D_MKRQREV := date()     // changed from date1
          (cDbf)->D_MKRQDLV := uD_MKRQDLV
ENDIF

o := PartBase():new()
o:cEsn := uESN_ID
o:scattar()

(cDbf)->PTYPE_ID   := o:cPartType
(cDbf)->PLINE_ID   := o:cProductLine
/*(cDbf)->SIZE_ID    := IF( o:cSize      == NIL,SPACE(4), o:cSize      )
(cDbf)->VALUE_ID   := IF( o:nValue     == NIL,      0 , o:nValue     )
(cDbf)->VOLT_ID    := IF( o:cVoltage   == NIL,SPACE(1), o:cVoltage   )
(cDbf)->TOL_ID     := IF( o:cTolerance == NIL,SPACE(1), o:cTolerance )
(cDbf)->TC_ID      := IF( o:cTemperatureCoefficient == NIL, SPACE(1),;
                          o:cTemperatureCoefficient )
(cDbf)->TERM_ID    := IF( o:cTerminationCode == NIL, SPACE(1), o:cTerminationCode )
(cDbf)->ESNXX_ID   := IF( o:cEsnNo           == NIL, SPACE(2), o:cEsnNo           )
(cDbf)->ESNY_ID    := IF( o:cEsnPacking      == NIL, SPACE(1), o:cEsnPacking      )*/

//Changes by VR
(cDbf)->SIZE_ID    := o:cSize
(cDbf)->VALUE_ID   := o:nValue
(cDbf)->VOLT_ID    := o:cVoltage
(cDbf)->TOL_ID     := o:cTolerance
(cDbf)->TC_ID      := o:cTemperatureCoefficient
(cDbf)->TERM_ID    := o:cTerminationCode
(cDbf)->ESNXX_ID   := o:cEsnNo
(cDbf)->ESNY_ID    := o:cEsnPacking

IF UPPER(Cdbf) == "D_ORDRND" .AND. "ZZ" $ uESN_ID    //VR 09-04-01 id:1941935
   IIF(!Empty(uLINE),(cDbf)->PLINE_ID := uLINE,nil)
   IIF(!Empty(uSIZE),(cDbf)->Size_id := uSIZE,nil)
   IIF(!Empty(uVALUE),(cDbf)->VALUE_ID := uVALUE,nil)
   IIF(!Empty(uVoltId),(cDbf)->VOLT_ID := uVoltId,nil)
ENDIF
(cDbf)->( DbCommit() )
oLockKey:unLockRec()

// Update m_ord/m_ordreq with edited values
IF lAppendMode // only update c_esnxrf.dbf for a new record
      IF SELECT("c_esnxrf") == 0
        NetUse( "c_esnxrf", STD_RETRY, RDD_IN_USE, USE_SHARED, USE_NEW, NIL )
      END
   C_esnxrf->( ORDSETFOCUS("C_ESNXRE") )
   IF !EMPTY( uCU_PN ) .OR. !EMPTY( uSO_PN )
     IF C_esnxrf->( DBSEEK(uCU_ID+uESN_ID) )
        IF c_esnxrf->( RecLock(5,"ordget") )
           c_esnxrf->so_pn := if(!EMPTY( uSO_PN ),uSo_Pn,c_esnxrf->so_pn )
           c_esnxrf->cu_pn := IF(!EMPTY( uCU_PN ),uCU_Pn,c_esnxrf->CU_pn )
           c_esnxrf->( DbCommit() )
        END
     ELSE
        IF c_esnxrf->( AddRec(5, "ORDGET" ) )
           c_esnxrf->esn_id := uEsn_id
           c_esnxrf->cu_id := ucu_Id
           c_esnxrf->so_pn := uSo_Pn
           c_esnxrf->cu_pn := uCu_Pn
           c_esnxrf->( DbCommit() )
        END
     ENDIF
   END
   CLOSE c_esnxrf
   IF UPPER(cDbf)=="D_ORDREQ"
       UpdateLogFile("A")
   ENDIF
ELSE      // only do this for an edit
	IF lSV_E_H
		UpdateLogFile("A")
	ELSEIF !lSV_E_H .AND. !lSV_E
	   UpdateLogFile("1")
	ENDIF
END

SELECT( nOldSelect )
RESTSCREEN(24,0,24,79,cSav24)

RETURN

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: UpdateLogFile()       Docs:                                ³
 * ³  Description: Update transaction logs for d_ord/d_ordreq changes         ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 08-13-96              Date updated: ş08-13-96              ³
 * ³ Time created: 01:11:03pm            Time updated: ş01:11:03pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: cWhich                                                     ³
 * ³ Return Value: nOldSelect := SELECT()                                     ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC FUNCTION UpdateLogFile(cWhich)

LOCAL nOldSelect := SELECT()
LOCAL cLog := "m"+SUBSTR(cDbf,2)
LOCAL i

NetUse( cLog, STD_RETRY, RDD_IN_USE, USE_SHARED, USE_NEW, NIL )
(cLog)->(ordsetfocus(cLog))
(cLog)->( AddRec(5) )
FOR i := 1 TO (cDbf)->( FCOUNT() )
    (cLog)->( FIELDPUT( i, (cDbf)->( FIELDGET(i) ) ) )
    (cLog)->Marker := cWhich
    (cLog)->( DBCOMMIT() )
NEXT

(cLog)->( DBCLOSEAREA() )
SELECT (nOldSelect)

RETURN NIL

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: EnterData             Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 07-18-96              Date updated: ş07-18-96              ³
 * ³ Time created: 12:08:55pm            Time updated: ş12:08:55pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: LastKey() != K_ESC                                         ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC FUNCTION EnterData(lRND)
LOCAL bInsSave
LOCAL nCursSave
LOCAL lDord := (nDbf == DBF_ORD)
LOCAL lRet := TRUE
LOCAL n

// we need to instanciate this STATIc, as we don't go into the ESN_ID get when
// editing d_ord
//IF lDord
   cEsnCurr := EsnTpCurr( uEsn_id , c_cust->tp_type )
//ENDIF

IF !lRND
     // 1
     @ 4,12 GET uPOLN_ID     PICTURE "999999.99" COLOR GETCOLORS ;
                             SEND preBlock := {|o| .F. }
     // 2
     @ 5,12 GET uSONO        PICTURE "@!" COLOR GETCOLORS;
                             SEND postBlock := {|o| postSONO(o,lDord) }

     // 3
     @ 5,28 GET uSONOLN      PICTURE "@! X"  COLOR GETCOLORS;
                             SEND postBlock := {|o| postSONOLN(o,getlist[2]) }
     // 4
     @ 6,12 GET uSOORDLN     PICTURE "@!" COLOR GETCOLORS ;
                             SEND postBlock := {|o| postSOORDLN(o, lDord) }
     // 5
     @ 6,28 GET uSOORDLN_NO  PICTURE "@! X"  COLOR GETCOLORS           ;
                             SEND postBlock := IF( lDORD, {|o| .T.  },;
                                                   {|o| postSRDLNNO(o,getlist[4], lDord) } )
     // 6
     @ 7,12 GET uPOLN_LOG    PICTURE "@!" COLOR GETCOLORS
     // 7
     @ 4,46 GET uCU_ID       PICTURE "@K 99999" COLOR GETCOLORS ;
                             SEND preBlock := {|o| preCU_ID(o) } ;
                             SEND postBlock := IF( lDORD, {|o| postCU_ID(o,TRUE) },;
                                                          {|o| postCU_ID(o,FALSE)} )
     // 8
     @ 7,42 GET uBILLAG_ID   PICTURE "@!" COLOR GETCOLORS ;
                             SEND preBlock := {|o| preBILLSHIP(o) } ;
                             SEND postBlock := {|o| postBILLSHIP(o) }
     // 9
     @ 8,42 GET uSHIPAG_ID   PICTURE "@!" COLOR GETCOLORS ;
                             SEND preBlock := {|o| preBILLSHIP(o) } ;
                             SEND postBlock := {|o| postBILLSHIP(o) }
     // 10
     @ 9,46 GET uENDCU_ID    PICTURE "@K 99999" COLOR GETCOLORS ;
                             SEND preBlock  := {|o| preENDCU_ID(o) } ;
                             SEND postBlock := {|o| postENDCU_ID(o) }
     // 11
     @ 10,42 GET uPROJ_ID    PICTURE "@!" COLOR GETCOLORS ;
                             SEND preBlock  := {|o| prePROJ_ID(o) } ;
                             SEND postBlock := {|o| postPROJ_ID(o) }
     // 12
     @ 09,12 GET uESN_ID     PICTURE "@!" COLOR GETCOLORS                        ;
                             SEND Reader    := IF( lDORD, {|o| DordReader(o)  },;
                                                          {|o| GetReader(o)   } );
                             SEND preBlock  := {|o| preESN_ID(o, lDORD ) }       ;
                             SEND postBlock := {|o| postESN_ID(o,lDORD) }
	  //13
     @ 10,12 GET uAVXIL_PN   PICTURE "@!" COLOR GETCOLORS ;
                             SEND postBlock := {|o| postToasties( o )  }

	  // 14
     @ 11,12 GET uSO_PN      PICTURE "@!" COLOR GETCOLORS  ;
                             SEND preBlock  :=  {|o| checkSO_PN( o ) };
                             SEND postBlock :=  {|o| postToasties( o )}
     // 15
     @ 12,12 GET uCU_PN      PICTURE "@!" COLOR GETCOLORS ;
                             SEND postBlock := {|o| postToasties( o )  }

     // 16
     @ 11,58 GET uPOLN_STAT  PICTURE "!" COLOR GETCOLORS ;
                             SEND preBlock  := {|o| prePOLN_STAT(o) } ;
                             SEND postBlock := {|o| postPOLN_STAT(o,lDord) }
     // 17
     @ 12,58 GET uPOLN_TYPE  PICTURE "!" COLOR GETCOLORS ;
                             SEND preBlock  := {|o| prePOLN_TYPE(o) } ;
                             SEND postBlock := IF (lDord, {|o| postPOLN_TYPE(o,TRUE,) } ,;
                                                          {|o| postPOLN_TYPE(o,FALSE) } )
     // 18
     @ 15,0  GET uD_ORDREC   COLOR GETCOLORS ;
                             SEND preBlock  := IF(lDord,{|o| FALSE },{|o| TRUE });
                             SEND postBlock := if(lDord,{|o| TRUE },{|o| postDATA(o, "Rcvd date") })
                                               //had to do this caz it was doing a double post check
                                               //and checking post blocks even when preblock was .f.
     // 19
     @ 15,11 GET uD_RQSTDLV  COLOR GETCOLORS ;
                             SEND preBlock  := IF(lDord,{|o| FALSE },{|o| TRUE });
                             SEND postBlock := if(lDord,{|o| TRUE },{|o| postDATA(o, "Req date") })
     // 20
     @ 15,71 GET uQTY_ORD    PICTURE "9,999,999" COLOR GETCOLORS ;
                             SEND preBlock  := IF( lDord, {|o| FALSE },{|o| preQTY_ORD(o) } );
                             SEND postBlock := IF( lDord, {|o| postQTY_ORD(o,TRUE,uESN_ID)},;
                                                          {|o| postQTY_ORD(o,FALSE,uESN_ID)})
                  // Add a "REALLOCATE" warning if the new qty is smaller than the original
     // 21
     @ 17,3  GET uCURR_POLN  PICTURE "!!!" COLOR GETCOLORS ;
                             SEND preBlock  := IF( lDord, {|o| preCURR_POLN(o,TRUE, uPoln_stat) },;
                                                          {|o| preCURR_POLN(o,FALSE,uPoln_stat) });
                             SEND postBlock := {|o| postCURR_POLN(o) }
     // 22
     @ 17,11 GET uSPCU_EA    PICTURE "99,999.9999" COLOR GETCOLORS  ;
                             SEND preBlock  := IF( lDord,;
                                                {|o| preCU_EACH(o,TRUE,uPoln_stat)},;
                                                {|o| preCU_EACH(o,FALSE) }         );
                             SEND postBlock := {|o| postCU_EACH(o, "SP") }
     // 23
     @ 18,11 GET uTPCU_EA    PICTURE "99,999.9999" COLOR GETCOLORS  ;
                             SEND preBlock  := IF( lDord,;
                                                {|o| preCU_EACH(o,TRUE,uPoln_stat)},;
                                                {|o| preCU_EACH(o,FALSE) }         );
                             SEND postBlock := {|o| postCU_EACH(o,"TP") }
     // 24
     @ 17,71 GET uQTY_CANC   PICTURE "9,999,999"         ; // COLOR GETCOLORS                            ;
                             SEND preBlock  := {|| .F. } ;
                             SEND postBlock := {|o| postToasties( o )  }


          /*                 SEND preBlock  := IF( lDord, {|| .F. }, {|o| preQTY_CANC(o) } );
                             SEND postBlock := {|o| postQTY_CANC(o) }*/
     // 25
     @ 20,10 GET uD_EXCH                                ;
                 SEND postBlock := {|o| Postd_exch(o)  };
                 COLOR GETCOLORS
     // 26
     @ 22,0  GET uPOLN_MESS1     ;
                 COLOR GETCOLORS ;
                 SEND postBlock := {|o| postToasties( o )  }
     @ 23,0  GET rPOLN_MESS2     ;
                 COLOR GETCOLORS ;
                 SEND postBlock := {|o| postToasties( o )  }
     IF lDord
     @ 15,41  GET UD_MRKDLV   COLOR GETCOLORS ;
                             SEND preBlock  := IF((uPoln_STAT $ " _Q" .AND.;
                                                       (cdbf)->qty_alloc = (cdbf)->qty_ord) .OR.;
                                                  (uPoln_STAT $ " _Q" .AND.;
                                                       (cdbf)->qty_alloc+(cdbf)->qty_canc = (cdbf)->qty_ord) .OR. ;
                                                  (uPoln_STAT $ " _Q" .AND.;
                                                       (cdbf)->qty_ord - (cdbf)->qty_shipd = (cdbf)->qty_alloc + (cdbf)->qty_canc),;
                                                 {|o| TRUE },{|o| FALSE });
                             SEND postBlock := if((uPoln_STAT == " _Q" .AND.;
                                                       (cdbf)->qty_alloc = (cdbf)->qty_ord) .OR.;
                                                  (uPoln_STAT $ " _Q" .AND.;
                                                       (cdbf)->qty_alloc+(cdbf)->qty_canc = (cdbf)->qty_ord) .OR. ;
                                                  (uPoln_STAT $ " _Q" .AND.;
                                                       (cdbf)->qty_ord - (cdbf)->qty_shipd = (cdbf)->qty_alloc + (cdbf)->qty_canc),;
                                                       {|o| postMrk(o, "Marketing date") },{|o| TRUE })
                                               //had to do this caz it was doing a double post check
                                               //and checking post blocks even when preblock was .f. and because i am too stupid to understand the get system.
                                               //I put this get at the end in order no to screw up
                                               // get list order
                             //YG 29/3/99 99032302 allow marketing access to due field in the last or clause
                             //when qty_canc+qty_alloc = qty_ord
                             //SS 2/8/99 99072102 allow marketing access to request field when status='Q'
     @ 15,51  GET UD_MKRQDLV   COLOR GETCOLORS ;
                             SEND preBlock  := IF((uPoln_STAT == "Q" .AND.;
                                                       (cdbf)->qty_alloc <> (cdbf)->qty_ord) .OR.;
                                                  (uPoln_STAT == "Q" .AND.;
                                                       (cdbf)->qty_alloc+(cdbf)->qty_canc <> (cdbf)->qty_ord) .OR. ;
                                                  (uPoln_STAT == "Q" .AND.;
                                                       (cdbf)->qty_ord - (cdbf)->qty_shipd <>(cdbf)->qty_alloc + (cdbf)->qty_canc),;
                                                 {|o| TRUE },{|o| FALSE });
                             SEND postBlock := if((uPoln_STAT == "Q" .AND.;
                                                       (cdbf)->qty_alloc <>(cdbf)->qty_ord) .OR.;
                                                  (uPoln_STAT == "Q" .AND.;
                                                       (cdbf)->qty_alloc+(cdbf)->qty_canc <>(Cdbf)->qty_ord) .OR. ;
                                                  (uPoln_STAT == "Q" .AND.;
                                                       (cdbf)->qty_ord - (cdbf)->qty_shipd <>(cdbf)->qty_alloc + (cdbf)->qty_canc),;
                                                       {|o| postMrk(o, "Marketing date") },{|o| TRUE })
                                               //had to do this caz it was doing a double post check
                                               //and checking post blocks even when preblock was .f. and because i am too stupid to understand the get system.
                                               //I put this get at the end in order no to screw up
                                               // get list order
                             //YG 29/3/99 99032302 allow marketing access to due field in the last or clause
                             //when qty_canc+qty_alloc = qty_ord
                             //SS 2/8/99 99072102 allow marketing access to request field when status='Q'
     ENDIF
else //lRND true
     // 1

     @ 4,12 GET uPOLN_ID     PICTURE "999999.99" COLOR GETCOLORS ;
                             SEND preBlock := {|o| .F. }
	  @ 5 ,12 GET uPOLN_STAT  PICTURE "!" COLOR GETCOLORS ;
                             SEND preBlock  := {|o| .F. };
                             SEND postBlock := {|o| .T. }
	  @ 6 ,12 GET uPOLN_TYPE  PICTURE "!" COLOR GETCOLORS ;
                             SEND preBlock  := {|o| FALSE } ;
                             SEND postBlock := {|o| postPOLNTYPE_rnd(o) }
	  @ 7 ,12 GET uInitiator  PICTURE "!!!!!!!!!!" COLOR "W+/B,G+/R"      ;
                             SEND preBlock  := {|o| preInit_id(o) };
                             SEND postBlock := {|o| PostPick(o,"C_TINIT","INIT_ID",,"c_TINIT") }
     @ 8 ,12 GET uPROJ_ID    PICTURE "@!" COLOR GETCOLORS ;
                             SEND preBlock  := {|o| prePROrnd_ID(o)  } ;
                             SEND postBlock := {|o| postRNDPROJ_ID(o) }
     @ 4,45 GET uCU_ID       PICTURE "@K 99999" COLOR GETCOLORS ;
                             SEND preBlock  := {|o| preCU_ID(o) } ;
                             SEND postBlock := {|o| postCUID_Rnd(o)}
	  @ 5 ,45 GET uSONO       COLOR GETCOLORS;
                             SEND postBlock := {|o| postSONO_Rnd(o) }
	  @ 6 ,45 GET uD_ORDREC   COLOR GETCOLORS ;
                             SEND preBlock  := {|o| FALSE } ;
                             SEND postBlock := {|o| TRUE }
	  @ 7 ,45 GET uD_RQSTDLV  COLOR GETCOLORS ;
                             SEND preBlock  := {|o| TRUE };
                             SEND postBlock := {|o| postDATA(o, "Req date") }
     @ 10,12 GET uPOLN_MESS1     ;
                 COLOR GETCOLORS ;
                 SEND reader := {|o| HebReader(o) } SEND postBlock := {|o| postToasties( o )  }

	  @ 12,10 GET uProduct     PICTURE "@!" COLOR GETCOLORS

	  @ 13,8  GET uESN_ID     PICTURE "@!" COLOR GETCOLORS            ;
                             SEND preBlock  := {|o| preESN_ID(o,,.T.) }       ;
                             SEND postBlock := {|o| postESN_ID(o,,.T.) }
	  @ 14,8 GET uLINE       PICTURE "!!!" COLOR "W+/B,G+/R";
                             SEND preBlock  := {|o| PreLine(o,"rnd")  };
                             SEND postBlock := {|o| PostLine(o) }
     @ 15,8 GET uSIZE       PICTURE "!!!!" COLOR "W+/B,G+/R";
                             SEND preBlock  := {|o| PreSize(o,"rnd")  };
                             SEND postBlock := {|o| PostSize(o) }
	  @ 16,8 GET uVALUE      PICTURE "@!" COLOR "W+/B,G+/R";
                             SEND preBlock  := {|o| PreValue(o,"rnd")  };
                             SEND postBlock := {|o| PostValue(o) }
	  @ 17,8 GET uVoltId      PICTURE "@!" COLOR "W+/B,G+/R";
                             SEND preBlock  := {|o| PreVolt_Rnd(o)  };
                             SEND postBlock := {|o| PostVolt(o) }
	  @ 13,41 GET uDielID     COLOR GETCOLORS ;
                             SEND preBlock  :=  {|o| preDi_Rnd(o) } ;
                             SEND postBlock :=  {|o| postDi_Rnd(o)}
	  @ 14,41 GET uBnCaps     COLOR GETCOLORS ;
                             SEND preBlock  := {|o| preCaps_Rnd(o) };
                             SEND postBlock := {|o| postCaps_Rnd(o)}
	  @ 15,41 GET uDielWidth  COLOR GETCOLORS
     @ 13,62 GET uROUTE_ID   PICTURE "!!!!" COLOR "W+/B,G+/R"      ;
                             SEND preBlock  := {|o| preRoute_id(o) };
                             SEND postBlock := {|o| PostPick(o,"C_RLIB","ROUTE_ID",,"IRLIBID") }
     @ 14,62 GET uQTY_ORD    PICTURE "999" COLOR GETCOLORS ;
                             SEND postBlock := {|o| postQTY_RND(o)}
     @ 14,76 GET uQTY_WAFER  PICTURE "999"  COLOR GETCOLORS ;
                             SEND postBlock := {|o| postQTY_RND(o)}
	  @ 15,62 GET uSrbId      COLOR GETCOLORS
ENDIF
XREADALL

IF K == 1
   lRet := FALSE
ENDIF

@24,0 SAY SPACE(80) COLOR "br/rb"
RETURN lRet
///////////////////////////////////////////////////////////
STATIC FUNCTION preSize(o,cRnd) //Vitaly 04-09-01 id 1941935
local lRetVal := "ZZ" $ IIF(Empty(cRnd) ,GetList[3]:VarGet() ,GetList[12]:VarGet() )
IF lRetVal
	SetF2Key( o , "c_size" )
ENDIF
RETURN lRetVal

STATIC FUNCTION preValue(o,cRnd) //VR
local lRetVal := "ZZ" $ IIF(Empty(cRnd) ,GetList[3]:VarGet() ,GetList[12]:VarGet() )
IF lRetVal
 SetF2Key( o , "c_value" )
ENDIF
RETURN lRetVal

STATIC FUNCTION preLine(o,cRnd) //VR
local lRetVal := "ZZ" $ IIF(Empty(cRnd) ,GetList[3]:VarGet() ,GetList[12]:VarGet() )
IF lRetVal
 SetF2Key( o , "c_pline" )
ENDIF
RETURN lRetVal

STATIC FUNCTION postSize(o)//VR
LOCAL nSelect := Select( Alias() )
LOCAL lFound

OUT ON UP ARROW

IF Empty( o:varGet() )
   RETURN .T.
ELSE
   NetUse("c_size",5)
   ordsetfocus("c_size")
   LOCATE FOR c_size->size_id == o:varGet()
   IF (lFound := c_size->( Found() ))
   ELSE
      Msg24( {"166" , "Size" } , 3 , .T. )
   ENDIF
   c_size->(dbclosearea())
   SELECT ( nSelect )
ENDIF

RETURN lFound

STATIC FUNCTION postValue(o) //VR
LOCAL nSelect := Select( Alias() )
LOCAL lFound

OUT ON UP ARROW

IF Empty( o:varGet() )
   RETURN .T.
ELSE
   NetUse("c_value",5)
   ordsetfocus("ivalpr")
   LOCATE FOR c_value->value_id = o:varGet()
   IF (lFound := c_value->( Found() ))
   ELSE
      Msg24( {"166" , "Value" } , 3 , .T. )
   ENDIF
   c_value->(dbclosearea())
   SELECT ( nSelect )
ENDIF

RETURN lFound

STATIC FUNCTION predi_Rnd(o)

LOCAL nSelect := Select( Alias() )
SetF2Key( o , "c_diel")
SELECT c_diel
LOCATE FOR c_diel->diel_id == o:varGet()
IF c_diel->( Found() )
  @ o:row , o:col + 4   SAY left(c_diel->diel_nm,19) COLOR "W+/B"
ENDIF
SELECT (nSelect)
RETURN .T.


STATIC FUNCTION postdi_Rnd(o)
LOCAL nSelect := Select( Alias() )
LOCAL lFound

OUT ON UP ARROW

SELECT c_diel
LOCATE FOR c_diel->diel_id == o:varGet()

IF (lFound := c_diel->(Found()))
	 @ o:row , o:col + 4   SAY left(c_diel->diel_nm,19) COLOR "W+/B"
    SetKey( K_F2 , NIL )
ELSEIF (lFound := Empty(o:varGet()) .OR. TRUE )
     SetKey( K_F2 , NIL )
ENDIF
RETURN lFound

STATIC FUNCTION postLine(o) //VR
LOCAL nSelect := Select( Alias() )
LOCAL lFound

OUT ON UP ARROW

IF Empty( o:varGet() )
   RETURN .T.
ELSE
   NetUse("c_pline",5)
   ordsetfocus("c_pline")
   LOCATE FOR c_pline->pline_id == o:varGet()
   IF (lFound := c_pline->( Found() ))
   ELSE
      Msg24( {"166" , "Line" } , 3 , .T. )
   ENDIF
   c_pline->(dbclosearea())
   SELECT ( nSelect )
ENDIF

RETURN lFound
/*********************************************************/
STATIC FUNCTION postToasties( o )
LOCAL cBuffer := o:VarGet()
RETURN .T.

/**********************************************************/
STATIC FUNCTION checkSO_PN(o)
local cBuffer := getList[14]:VarGet()
IF empty(cBuffer)
     cBuffer := getList[12]:varget()+space(4)  //YG 18/12/97 ADDED space(4) so
                                               //there would be enough room to add
                                               //caz it is a longer field
     //GetList[14]:Varput(cBuffer)
     //GetList[14]:Display()
ENDIF
return .T.
/*********************************************************/
STATIC FUNCTION postSRDLNNO( o, oSoordln )

LOCAL lRet := .T.
LOCAL nRec := (cDbf)->( RECNO() )
LOCAL nOrd := (cDbf)->( INDEXORD() )

(cDbf)->( ORDSETFOCUS("iordqsoo") )
IF (cDbf)->( DBSEEK( oSoordln:Varget()+o:varget() ) )
  IF lAppendMode .OR. (cDbf)->( RECNO() ) <> nRec //o:varget() <> o:original
     Msg24("This order line no. already exists.", 3, .T. )
     lRet := .F.
  ENDIF
ENDIF

(cDbf)->( ORDSETFOCUS(nOrd) )
(cDbf)->( DBGOTO( nRec ) )

RETURN lRet
/*********************************************************/
STATIC FUNCTION postSONOLN( o, oSoNo, l )

LOCAL lRet := .T.
LOCAL cNtx := IF( UPPER(cDbf) == "D_ORDREQ", "iordqsnl", "iordsnl")
LOCAL nRec := (cDbf)->( RECNO() )
LOCAL nOrd := (cDbf)->( INDEXORD() )

(cDbf)->( ORDSETFOCUS(cNtx) )
IF (cDbf)->( DBSEEK( oSoNo:Varget()+o:varget() ) )
  IF lAppendMode .OR. (cDbf)->( RECNO() ) <> nRec //o:varget() <> o:original
     Msg24("This SONO line no. already exists.", 3, .T. )
     lRet := .F.
  ENDIF
ENDIF
// The module must search on BOTH files always ! D. Laor 25.2.2002
// New duplicated requests may be fed into system when the same order
// already exists (as same SONO) at d_ord and viceversa:
// No changes should be done at d_ord for a number that was recently
// accepted as a request. Now search on the other file:
IF UPPER(cDbf) == "D_ORDREQ"
     Genopenfiles({"d_ord"})
     d_ord->( ORDSETFOCUS("iordsnl") )
     IF d_ord->(dbseek( oSoNo:Varget()+o:varget()))
          Msg24("This SONO line no. already exists at aproved order:"+str(d_ord->poln_id,9,2), 3, .T. )
          lRet := .F.
     ENDIF
     GenCloseFiles({"d_ord"})
ELSE
     Genopenfiles({"d_ordreq"})
     d_ordreq->( ORDSETFOCUS("iordqsnl") )
     IF d_ordreq->(dbseek( oSoNo:Varget()+o:varget()))
          Msg24("This SONO line no. already exists at request:"+str(d_ordreq->poln_id,9,2), 3, .T. )
          lRet := .F.
     ENDIF
     Genclosefiles({"d_ordreq"})
ENDIF
(cDbf)->( ORDSETFOCUS(nOrd) )
(cDbf)->( DBGOTO( nRec ) )
lSONOCng := o:Changed
RETURN lRet
/*********************************************************/
STATIC FUNCTION Postd_exch(o)

   cEsnCurr := EsnTpCurr( uEsn_id , c_cust->tp_type )
IF o:original <> NIL .AND. o:Varget() <> o:original
//   @ 21,10 SAY BuildRateLine( (cDbf)->curr_poln , (cDbf)->exch_rate , o:varget() ) color "W+/B"
//   @ 21,10 SAY BuildRateLine( cEsncurr , (cDbf)->exch_rate , o:varget() ) color "W+/B"
UpYourRate(uCurr_poln,o:varget())
   @ 21,10 SAY BuildRateLine( uCurr_Poln, rExch_rate , o:varget() ) color "W+/B"
   @ 16,11 SAY transform(rSpd_poln / uQty_ord,"99,999.9999")
   Redisplayrates(getlist[20])
END

RETURN TRUE

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: postSOORDLN()         Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 08-08-96              Date updated: ş08-08-96              ³
 * ³ Time created: 09:32:17am            Time updated: ş09:32:17am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: o                                                          ³
 * ³ Return Value: lRetVal                                                    ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC FUNCTION postSOORDLN(o, lDord)

LOCAL lRetVal
LOCAL cBuffer
LOCAL nRec
LOCAL nOrd
local lCloseIt := .F.

OUT ON UP ARROW

cBuffer := o:varGet()
IF Empty( cBuffer )
   Msg24( {"153"} , 3, .T. )
   lRetVal := .F.
ELSE
   lRetVal := .T.
ENDIF

IF !lDord
   **************************YG 8/12/97 to check for existing order in d_ord also
   IF select("d_ord") == 0
        NetUse( "d_ord", STD_RETRY, RDD_IN_USE, USE_SHARED, USE_NEW, NIL )
        d_ord->( ordsetfocus("iordsopo"))
        lCloseit := .T.
   ENDIF
   nRec := d_ord->( RECNO() )
   nOrd := d_ord->( INDEXORD() )
   d_ord->( ORDSETFOCUS("iordsopo") )
   IF d_ord->( DBSEEK( o:Varget() ) )
      IF lAppendMode .OR.  d_ord->( RECNO() ) <> nRec //o:varget() <> o:original
         Msg24("WARNING: This order no. already exists, continuing.", 3, .T. )
      END
   ENDIF
    d_ord->( ORDSETFOCUS(nOrd) )
    d_ord->( DBGOTO( nRec ) )
    IF lCloseIt
          d_ord->( DBCLOSEAREA() )
    ENDIF
   ****************************
   nRec := (cDbf)->( RECNO() )
   nOrd := (cDbf)->( INDEXORD() )
   (cDbf)->( ORDSETFOCUS("iordqsoo") )
   IF (cDbf)->( DBSEEK( o:Varget() ) )
      IF lAppendMode .OR. (cDbf)->( RECNO() ) <> nRec //o:varget() <> o:original
         Msg24("WARNING: This order no. already exists, continuing.", 3, .T. )
      END
   ENDIF
   (cDbf)->( ORDSETFOCUS(nOrd) )
   (cDbf)->( DBGOTO( nRec ) )
ENDIF

RETURN lRetVal

/***********************************************************************/
STATIC FUNCTION postSONO(o, lDord)

LOCAL cBuffer
LOCAL cNtx := IF( lAppendMode, "iordqsnl", "iordqsnl")
LOCAL lRetVal
LOCAL nRec
LOCAL nOrd
local lCloseIt := .F.

OUT ON UP ARROW

cBuffer := o:varGet()
IF Empty( cBuffer )
   Msg24( {"153"} , 3, .T. )
   lRetVal := .F.
ELSE
   lRetVal := .T.
ENDIF

IF !lDord
   **************************YG 8/12/97 to check for existing order in d_ord also
   IF select("d_ord") == 0
        NetUse( "d_ord", STD_RETRY, RDD_IN_USE, USE_SHARED, USE_NEW, NIL )
        d_ord->( ordsetfocus("iordsnl"))
        lCloseit := .T.
   ENDIF
   nRec := d_ord->( RECNO() )
   nOrd := d_ord->( INDEXORD() )
   d_ord->( ORDSETFOCUS("iordsnl") )
   IF d_ord->( DBSEEK( o:Varget() ) )
      IF lAppendMode .OR.  d_ord->( RECNO() ) <> nRec //o:varget() <> o:original
         Msg24("WARNING: This order no. already exists, continuing.", 3, .T. )
      END
   ENDIF
    d_ord->( ORDSETFOCUS(nOrd) )
    d_ord->( DBGOTO( nRec ) )
    IF lCloseIt
          d_ord->( DBCLOSEAREA() )
    ENDIF
   ****************************
   nRec := (cDbf)->( RECNO() )
   nOrd := (cDbf)->( INDEXORD() )
   (cDbf)->( ORDSETFOCUS(cNtx) )
   IF (cDbf)->( DBSEEK( o:Varget() ) )
      IF lAppendMode .OR. (cDbf)->( RECNO() ) <> nRec //o:varget() <> o:original
         Msg24("WARNING: This SONO already exists, continuing.", 3, .T. )
      END
   ENDIF
   (cDbf)->( ORDSETFOCUS(nOrd) )
   (cDbf)->( DBGOTO( nRec ) )
ENDIF

RETURN lRetVal

STATIC FUNCTION preVolt_Rnd(o)
local lRetVal := "ZZ" $ GetList[12]:VarGet()
IF lRetVal
 SetF2Key( o , "c_volt" )
ENDIF
RETURN lRetVal

STATIC FUNCTION postSONO_Rnd(o)

LOCAL cBuffer
LOCAL lRetVal
OUT ON UP ARROW

cBuffer := o:varGet()

IF Empty( cBuffer )
   lRetVal := .t.
ELSE
   lRetVal := .T.
ENDIF

RETURN lRetVal


/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: preCU_ID()            Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 08-08-96              Date updated: ş08-08-96              ³
 * ³ Time created: 09:32:14am            Time updated: ş09:32:14am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: o                                                          ³
 * ³ Return Value: .T.                                                        ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC FUNCTION preCU_ID(o)
     SetF2Key( o , "c_cust",NIL,NIL,NIL,"icu_nm")
RETURN .T.

STATIC FUNCTION preroute_ID(o)
     SetF2Key( o ,"c_rlib",{1,2,3,4,5},NIL,NIL,"irlibid")
RETURN .T.

STATIC FUNCTION preiNIT_ID(o)
     SetF2Key( o ,"c_tinit",NIL,NIL,NIL,"c_tinit")
RETURN .T.

FUNCTION preCAPS_Rnd(o)
LOCAL nSelect := Select( Alias() )
SetF2Key( o , "c_bncaps")
SELECT c_bncaps
LOCATE FOR c_bncaps->bncaps == o:varGet()
SELECT (nSelect)
RETURN .T.

FUNCTION postCAPS_Rnd(o)
LOCAL nSelect := Select( Alias() )
LOCAL lFound

DEFAULT lFound to .T.
OUT ON UP ARROW
SELECT c_bncaps
LOCATE FOR c_bncaps->bncaps == o:varGet()
IF (lFound := c_bncaps->(Found()) .OR. Empty(o:varGet()) .OR. TRUE )
   SetKey( K_F2 , NIL )
ENDIF

RETURN lFound

/*
FUNCTION SetF2Key( o , cFile , aDefaultCols, bBlock, aSkips,;
                   cIndex, lAltS, aHeaders, cFieldVal, nField2Get, cSeekField )

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
                         cIndex, lAltS, aHeaders, cFieldVal, cSeekField) } )
RETURN .T.

SetKey( K_F2 , ;
        {|| TableSelect( cFile, bBlock , aDefaultCols, NIL, aSkips, TRUE,;
                         cIndex, lAltS, aHeaders, cFieldVal, cSeekField) } )
*/
/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: postCU_ID()           Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 08-08-96              Date updated: ş08-08-96              ³
 * ³ Time created: 09:32:21am            Time updated: ş09:32:21am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: o                                                          ³
 * ³ Return Value: RATE 13                                                    ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC FUNCTION postCU_ID(o, lDord)
LOCAL lRetVal
LOCAL cBuffer
LOCAL nOldSelect := SELECT()

OUT ON UP ARROW
cBuffer := o:varGet()
IF Empty( cBuffer )
   Msg24( {"154"} , 3, .T. )
   lRetVal := .F.
ELSE
   cBuffer := Padl( Alltrim( cBuffer ) , 5 )
   IF RecElement( cBuffer , {||c_cust->( Found() )},"c_cust","icu_id")
     IF  o:Original <> NIL .AND. o:VarGet() <> o:Original
       SetCustomerInfo( cBuffer )
     ENDIF
     lRetVal := .T.
   ELSE
      Msg24( {"155"} , 3, .T. )
      lRetVal := .F.
   ENDIF
   IF lRetVal
      o:varPut( cBuffer )
      o:display()

      // handle any changes to cu_id as it affects SO_PN and CU_PN
      IF SELECT("c_esnxrf") == 0
        NetUse( "c_esnxrf", STD_RETRY, RDD_IN_USE, USE_SHARED, USE_NEW, NIL )
        c_esnxrf->(ordsetfocus("c_esnxre"))
      END
         IF c_esnxrf->( DBSEEK( o:VarGet()+ GetList[14]:VarGet() ) )
            IF o:Original <> NIL .AND. o:VarGet <> o:Original
               //GetList[14]:Varput(c_esnxrf->so_pn)
               //GetList[15]:Varput(c_esnxrf->cu_pn)
            ENDIF
         ELSEIF o:Original <> NIL .AND. o:VarGet <> o:Original
            //GetList[14]:Varput( SPACE( LEN(c_esnxrf->so_pn) ) )
            //GetList[15]:Varput( SPACE( LEN(c_esnxrf->cu_pn) ) )
         ENDIF
         //GetList[14]:Display()
         //GetList[15]:Display()
         CLOSE c_esnxrf
         SELECT (nOldSelect)
      //ENDIF
   ENDIF
ENDIF

IF lRetVal
   SetKey( K_F2 , NIL )
ENDIF

RETURN lRetVal //.AND. !(lSONOCng .AND. rSarea_id == "2")

STATIC FUNCTION postCUID_Rnd(o)
LOCAL lRetVal
LOCAL cBuffer
LOCAL aCustInfo := {}
LOCAL nOldSelect := SELECT()

OUT ON UP ARROW
cBuffer := o:varGet()
IF Empty( cBuffer )
   //Msg24( {"154"} , 3, .T. )
   lRetVal := .T.
ELSE
   cBuffer := Padl( Alltrim( cBuffer ) , 5 )
   IF RecElement( cBuffer , {||c_cust->( Found() )},"c_cust","icu_id")
		aCustInfo := CustomerInfo( cBuffer )
		@ 4 , 51 SAY Left( aCustInfo[CUNM] , 28 )
		lRetVal := .T.
   ELSE
      Msg24( {"155"} , 3, .T. )
      lRetVal := .F.
   ENDIF
ENDIF
IF lRetVal
   SetKey( K_F2 , NIL )
ENDIF
RETURN lRetVal


/*
#define CUCOID   1
#define CUNM     2
#define CNTRYID  3
#define CNTRYNM  4
#define SAREAID  5
#define SAREANM  6
#define BILLAGID 7
#define BILLAGNM 8
#define SHIPAGID 9
#define SHIPAGNM 10
#define CURRTYPE 11
#define TPTYPE   12
#define RATE     13
*/

/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: SetCustomerInfo()                                          ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine         Designer:                            ³
 * ³ Date created: 08-08-96              Date updated: ş08-08-96              ³
 * ³ Time created: 09:32:29am            Time updated: ş09:32:29am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: cCUST_ID                                                   ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC PROCEDURE SetCustomerInfo( cCUST_ID )
LOCAL aCustInfo
LOCAL cTpCurr

LOCAL cColor := SetColor( "W+/B" )

aCustInfo := CustomerInfo( cCUST_ID )

rCUCO_ID := aCustInfo[CUCOID]
@ 4 , 42 SAY rCUCO_ID+"/"
@ 4 , 52 SAY Left( aCustInfo[CUNM] , 28 )

@ 5 , 42 SAY aCustInfo[CNTRYID]
@ 5 , 46 SAY aCustInfo[CNTRYNM]

rSAREA_ID := aCustInfo[SAREAID]
@ 6 , 42 SAY rSAREA_ID
@ 6 , 44 SAY aCustInfo[SAREANM]

uBILLAG_ID := aCustInfo[BILLAGID]
@ 7 , 42 SAY uBILLAG_ID
@ 7 , 47 SAY aCustInfo[BILLAGNM]

uSHIPAG_ID := aCustInfo[SHIPAGID]
@ 8 , 42 SAY uSHIPAG_ID
@ 8 , 47 SAY aCustInfo[SHIPAGNM]

rENDCUCO_ID := rCUCO_ID
uENDCU_ID   := cCUST_ID
@ 9 , 42 SAY rENDCUCO_ID+"/"
@ 9 , 46 SAY uENDCU_ID
@ 9 , 52 SAY Left( aCustInfo[CUNM] , 28 )

uCURR_POLN := aCustInfo[CURRTYPE]
IF !uCurr_poln $ 'USD_YEN'
     @ 16 , 0 SAY 'SP(USD/Ea)'
ENDIF
@ 17 , 3 SAY uCURR_POLN
@ 17 ,26 SAY uCURR_POLN

rEXCH_RATE := aCustInfo[RATE]
@ 21,10 SAY BuildRateLine( (cDbf)->curr_poln , (cDbf)->exch_rate , (cDbf)->d_exch ) color "w+/b"
//@ 21,10 SAY

IF !Empty( GetList[12]:varGet() )

    cTpCurr := EsnTpCurr( GetList[12]:varGet() , aCustInfo[TPTYPE] )
    @ 18 , 3 SAY cTpCurr
    @ 18 ,26 SAY cTpCurr

    uTPCU_EA := EsnTpCurr( GetList[12]:varGet() , aCustInfo[TPTYPE] , "TP" )
    GetList[23]:varPut( uTPCU_EA )
    GetList[23]:display()
ELSE
    cTpCurr := "   "
    @ 18 , 3 SAY cTpCurr
    @ 18 ,26 SAY cTpCurr
    GetList[23]:varPut( 0 )
    GetList[23]:display()
ENDIF

SetColor( cColor )
RETURN

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: preBILLSHIP()         Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 08-08-96              Date updated: ş08-08-96              ³
 * ³ Time created: 09:31:39am            Time updated: ş09:31:39am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: o                                                          ³
 * ³ Return Value: .T.                                                        ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC FUNCTION preBILLSHIP(o)
SetF2Key( o , "c_agency")
RETURN .T.

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: postBILLSHIP()        Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 08-08-96              Date updated: ş08-08-96              ³
 * ³ Time created: 09:31:36am            Time updated: ş09:31:36am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: o                                                          ³
 * ³ Return Value: lRetVal                                                    ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC FUNCTION postBILLSHIP(o)
LOCAL lRetVal := .F.
LOCAL cBuffer

OUT ON UP ARROW

cBuffer := o:varGet()
IF Empty( cBuffer )
   Msg24( {"156"} , 3, .T. )
   lRetVal := .F.
ELSE
   IF RecElement( cBuffer , {|| c_agency->( Found() ) }, "c_agency", "iagencid" )
      @ o:row,47 SAY RecElement( cBuffer , {|| c_agency->ag_nm }, "c_agency", "iagencid" ) COLOR "W+/B"
      lRetVal := .T.
		IF o:name == "uBILLAG_ID"
		  rSAREA_ID := c_agency->sarea_id
		  @ 6 , 42 SAY rSAREA_ID
		  @ 6 , 44 SAY RecElement( rSAREA_ID, {|| c_sarea->sarea_nm }, "c_sarea","isarea" )
		ENDIF
	ELSE
      Msg24( {"157"} , 3, .T. )
      lRetVal := .F.
   ENDIF
ENDIF

IF lRetVal
   SetKey( K_F2 , NIL )
ENDIF

RETURN lRetVal

/**************************************************************/
STATIC FUNCTION preENDCU_ID(o)
SetF2Key( o , "c_cust")
RETURN .T.

/**************************************************************/
STATIC FUNCTION postENDCU_ID(o)
LOCAL cBuffer , aCustInfo
LOCAL lRetVal := .T.

OUT ON UP ARROW

   cBuffer := o:varGet()
   cBuffer := Padl( Alltrim( cBuffer ) , 5 )
   o:varPut( cBuffer )
   o:display()

   IF RecElement( cBuffer , {||c_cust->( Found() )},"c_cust","icu_id")
      aCustInfo := CustomerInfo( cBuffer )
      rENDCUCO_ID := aCustInfo[CUCOID]
      @ o:row , 42 SAY rENDCUCO_ID+"/"              COLOR "W+/B"
      @ o:row , 52 SAY Left( aCustInfo[CUNM] , 28 ) COLOR "W+/B"
      RecElement( GetList[7]:varGet() , {||c_cust->( Found() )},"c_cust","icu_id")  //YG 7/1/99
   ELSE
      Msg24( {"158"} , 3, .T. )
      lRetVal := .F.
   ENDIF

IF lRetVal
   SetKey( K_F2 , NIL )
ENDIF

RETURN lRetVal

/**************************************************************/
STATIC FUNCTION prePROJ_ID(o)
SetF2Key( o , "c_proj")
RETURN .T.

STATIC FUNCTION prePROrnd_ID(o)
 c_prornd->( dbsetfilter({||!Empty(c_prornd->proj_dep)},"!Empty(c_prornd->proj_dep)"))//03.06.2002 VR
 SetF2Key( o , "c_prornd")
RETURN .T.

/**************************************************************/
STATIC FUNCTION postPROJ_ID(o)

LOCAL cBuffer
LOCAL lRetVaL := .T.

OUT ON UP ARROW

cBuffer := o:varGet()
// Check for empty field removed 2-2-97 by Shalom on orders from David
IF Empty( cBuffer )
ELSE
   IF RecElement(cBuffer, {|| c_proj->( FOUND() ) } , "c_proj","c_Proj" )
      @ o:row,47 SAY Left( RecElement( cBuffer, {|| c_proj->proj_nm }, "c_proj" ) , 33 )  COLOR "W+/B"
      lRetVal := .T.
   ELSE
      Msg24( {"160"} , 3, .T. )
      lRetVal := .F.
   ENDIF
ENDIF

IF lRetVal
 SetKey( K_F2 , NIL )
ENDIF

RETURN lRetVal

STATIC FUNCTION postRNDPROJ_ID(o)

LOCAL cBuffer
LOCAL lRetVaL := .T.

OUT ON UP ARROW

cBuffer := o:varGet()
IF Empty( cBuffer )
   Msg24( {"159"} , 3, .T. )
   lRetVal := .F.
ELSE
   IF RecElement(cBuffer, {|| c_prornd->( FOUND() ) } , "c_prornd","c_Prornd" )
      @ o:row,18 SAY Left( RecElement( cBuffer, {|| c_prornd->proj_nm }, "c_prornd" ) , 33 )  COLOR "W+/B"
      lRetVal := .T.
   ELSE
      Msg24( {"160"} , 3, .T. )
      lRetVal := .F.
   ENDIF
ENDIF

IF lRetVal
 SetKey( K_F2 , NIL )
 c_prornd->(dbclearfilter())
ENDIF
RETURN lRetVal

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: preESN_ID()           Docs: Shalom LeVine                  ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 11-19-97              Date updated: ş11-19-97              ³
 * ³ Time created: 11:01:39am            Time updated: ş11:01:39am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: o                                                          ³
 * ³             : lDord                                                      ³
 * ³ Return Value: .T.                                                        ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC FUNCTION preESN_ID(o, lDord ,lRND)
LOCAL lRet := TRUE
default lRND to .F.

cLine24 := SAVESCREEN( 24,0,24,79)
IF (cDbf)->qty_alloc > 0 .OR. (cDbf)->qty_SHIPD > 0
   lRet := FALSE
ELSEIF !lRND .AND. lDord
   IF  !( d_ord->ptype_id $ "K_M_Z")
       @24,0 SAY PADR("F3 - Edit the ESN",80) COLOR "gr+/r"
       SETKEY( K_F3, {|| EditEsnID(o) })
   END
ELSEIF !lRND .AND. !( d_ordreq->ptype_id $ "K_M_Z")
   @24,0 SAY PADR("F2 - pick an ESN  F3 - Edit the ESN",80) COLOR "gr+/r"
   SETKEY( K_F3, {|| EditEsnID(o) })
   SetF2Key( o , "d_esn")
ELSE
   @24,0 SAY PADR("F2 - pick an ESN",80) COLOR "gr+/r"
   SetF2Key( o , "d_esn")
ENDIF

RETURN lRet

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: postESN_ID()          Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 07-18-96              Date updated: ş07-18-96              ³
 * ³ Time created: 01:16:30pm            Time updated: ş01:16:30pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: o                                                          ³
 * ³             : cCu_pn                                                     ³
 * ³             : uSo_pn                                                     ³
 * ³             : uCu_pn                                                     ³
 * ³ Return Value: lRetVal                                                    ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC FUNCTION postESN_ID( o, lDORD ,lRND)

LOCAL aOriginal := {}
LOCAL cBuffer
LOCAL cCurr
LOCAL i
LOCAL lRetVal := .T.
LOCAL nTp
LOCAL nOldSelect := SELECT()
LOCAL oEsn,cParam
default lRND to .F.

IF lRND //YG 3.9.98
     return PostPick(o,"D_ESN","ESN_id",,"iesn_id")
ENDIF

IF SELECT("c_esnxrf") == 0
   NetUse( "c_esnxrf", STD_RETRY, RDD_IN_USE, USE_SHARED, USE_NEW, NIL )
   c_esnxrf->(ordsetfocus("c_esnxre"))
END
IF SELECT ("c_esnlnk") == 0
   NetUse("c_esnlnk",5)
ENDIF
c_esnlnk->(ordSetFocus( "ilnkesn" ))

cBuffer := o:varGet()

oEsn := PartBase():new()
oEsn:cEsn := cBuffer
oEsn:scattar("esn")
cParam:= oEsn:cPartType+oEsn:cProductline+oEsn:cSize+lTrim(Str(oEsn:nValue,8,3))
IF oEsn:cPartType == "C"
   NetUse("d_edsgn",5)
   ordsetfocus("edtopdwn")
   d_edsgn->(dbseek(cParam))
   IF found()
      dbskip(1)
      IF d_edsgn->ptype_id+d_edsgn->pline_id+d_edsgn->size_id+lTrim(str(d_edsgn->value_id,8,3)) == cParam
         if !(Alltrim(d_edsgn->tc_id) == "K" .AND. oEsn:cTemperature == "J" ) .AND. ;
            TestSubst(oEsn:cVoltage,d_edsgn->volt_id)
            /*Maybe in feature in use (vitaly) */
         else
            DBSKIP(-1)
            if !(Alltrim(d_edsgn->tc_id) == "K" .AND. oEsn:cTemperature == "J" ) .AND. ;
               TestSubst(oEsn:cVoltage,d_edsgn->volt_id)
               /*Maybe in feature in use (vitaly) */
            else
               Alert("ESN should match to design")
            endif
         endif
      ELSE
         DBSKIP(-1)
         IF !(Alltrim(d_edsgn->tc_id) == "K" .AND. oEsn:cTemperature == "J" ) .AND. ;
            TestSubst(oEsn:cVoltage,d_edsgn->volt_id)
            /*Maybe in feature in use (vitaly) */
         ELSE
            Alert("ESN should match to design;Volt <= " + GetVoltNm(d_edsgn->volt_id) + " and TC = " + IIF(Alltrim(d_edsgn->tc_id) == "J/K","J/K","K") + ", are required")
         ENDIF
      ENDIF
   ENDIF
   d_edsgn->(DbCloseArea())
ENDIF
// Force users to see esn-details on small screen to check correct ESN
// details even before it gets to d_ordreq D.Laor 21/04/98
prodDetails(cBuffer,cBuffer,.F.,.T.)

IF lDord .AND. (o:Original <> NIL)
   d_esn->( DBSEEK( RTRIM(o:Original) ) )
   FOR i := 1 TO d_esn->( FCOUNT() )
       AADD( aOriginal, d_esn->( FIELDGET(i) ) )
   NEXT
ENDIF

IF !c_esnlnk->(dbseek(cBuffer)) //Vitalt 25-07-01
   Alert("This ESN has no engineering route...")
ENDIF

//IF LASTKEY() == K_UP
//   lRetVal := TRUE
//ELSE
IF Empty( cBuffer )
   Msg24( {"161"} , 3, .T. )
   lRetVal := FALSE
ELSEIF D_ESN->(DBSEEK(rtrim(cBuffer))) .and. EMPTY( d_esn->( FIELDGET(D_esn->( FIELDPOS("TP"+c_cust->tp_type) ) ) ) );
       .AND. c_cust->SAREA_id <> "4"  // 4 is ISRAEL, so no info needed in d_esn
   Msg24("TP"+c_cust->tp_type+" value is missing in the ESN.", 3, .T. )
   RETURN FALSE
ELSEIF !RecElement( cBuffer , {|| d_esn->( Found() ) }, "d_esn" , "iesn_id" )
      Msg24( "Not a valid ESN_ID." , 3, .T. )
      o:VarPut( SPACE(16) )
      o:Display()
      lRetVal := .F.
ELSEIF o:Original <> NIL .AND. o:VarGet() <> o:Original
      cEsnCurr := cCurr := EsnTpCurr( cBuffer , c_cust->tp_type )
      uTPCU_EA := EsnTpCurr( cBuffer , c_cust->tp_type , "TP" )
      @ 18, 3 SAY cCurr  COLOR "W+/B"
      @ 18,26 SAY cCurr  COLOR "W+/B"
      GetList[23]:varPut( uTPCU_EA )
      GetList[23]:display()
    /*IF c_esnxrf->( DBSEEK( GetList[7]:Varget()+cBuffer) )
      IF GetList[15]:VarGet() <> c_esnxrf->cu_pn
         GetList[15]:VarPut(c_esnxrf->cu_pn)
         GetList[15]:Display()
      else
         GetList[15]:VarPut( SPACE( LEN(c_esnxrf->cu_pn) ) )
         GetList[15]:Display()
      ENDIF
      IF GetList[14]:VarGet() <> c_esnxrf->so_pn
         IF !empty(c_esnxrf->so_pn)
				  GetList[13]:VarPut(c_esnxrf->so_pn)
				  GetList[13]:Display()
				  IF Empty(GetList[14]:VarGet())
				  	  GetList[14]:VarPut(c_esnxrf->so_pn)
				  	  GetList[14]:Display()
				  ENDIF
         endif
      endif
    ElseIF d_esn->( dbseek(cBuffer) )
           GetList[13]:VarPut(d_esn->avxilpn)
           GetList[13]:Display()
			  IF Empty(GetList[14]:VarGet())
			     GetList[14]:VarPut(d_esn->avxilpn)
			     GetList[14]:Display()
			  ENDIF
    ELSE
			GetList[13]:VarPut( SPACE( LEN(c_esnxrf->so_pn) ) + SPACE(4))
			GetList[13]:Display()
         IF Empty(GetList[14]:VarGet())
			   GetList[14]:VarPut( SPACE( LEN(c_esnxrf->so_pn) ) + SPACE(4))
            GetList[14]:Display()
			ENDIF
    END*/
	 IF d_esn->( dbseek(cBuffer) )
	    GetList[13]:VarPut(d_esn->avxilpn)
	    GetList[13]:Display()
	    IF Empty(GetList[14]:VarGet())
	       GetList[14]:VarPut(d_esn->avxilpn)
	       GetList[14]:Display()
	    ENDIF
	 ENDIF

    lRetVal := .T.
ENDIF
//YG 30/11/97 to set a default for lazy people when so_pn is blank
IF empty(GetList[14]:VarGet())
     GetList[14]:VarPut( (GetList[14]:VarGet()) )
     GetList[14]:Display()
ENDIF
IF empty(GetList[13]:VarGet())
     GetList[13]:VarPut( (GetList[13]:VarGet()) )
     GetList[13]:Display()
ENDIF
IF(SUBSTR(cBuffer,8,4) == "0000") //vitaly 17.01.2000
   //lRetval := .F.
   Msg24("ESN with value = 0.0 is invalid", 3, .T. )
ENDIF
IF lRetVal
   SetKey( K_F2 , NIL )
   SetKey( K_F3 , NIL )
   RESTSCREEN(24,0,24,79,cLine24)
ENDIF

CLOSE c_esnxrf
c_esnlnk->(dbclosearea())
SELECT( nOldSelect )

RETURN lRetVal

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: postSO_PN()           Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 07-18-96              Date updated: ş07-18-96              ³
 * ³ Time created: 01:14:15pm            Time updated: ş01:14:15pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: o                                                          ³
 * ³             : cCu_pn                                                     ³
 * ³ Return Value: lRetVal                                                    ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC FUNCTION postSO_PN(o)

LOCAL lRetVal
LOCAL nOldSelect := SELECT()

USE c_esnxrf NEW SHARED
c_esnxrf->(ordsetfocus("c_esnxrs"))

IF LastKey() = K_UP
   lRetVal := TRUE
ELSEIF Empty( o:varGet() )
   lRetVal := TRUE
ELSEIF c_esnxrf->( DBSEEK( GetList[7]:VarGet()+o:VarGet() ) )
      IF GetList[15]:VarGet() <> c_esnxrf->cu_pn
         //GetList[15]:VarPut(c_esnxrf->cu_pn)
         //GetList[15]:Display()
      ENDIF
      IF GetList[12]:VarGet() <> c_esnxrf->esn_ID
         //GetList[12]:VarPut(c_esnxrf->esn_ID)
         //GetList[12]:Display()
      ENDIF
      lRetVal := TRUE
ELSE
  Msg24( {"301"} , 3, .T. )
  lRetVal := FALSE
ENDIF

CLOSE c_esnxrf
SELECT( nOldSelect )

RETURN lRetVal

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: postCU_PN()           Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 07-18-96              Date updated: ş07-18-96              ³
 * ³ Time created: 01:14:09pm            Time updated: ş01:14:09pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: o                                                          ³
 * ³             : cCu_pn                                                     ³
 * ³ Return Value: lRetVal                                                    ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC FUNCTION postCU_PN(o)
LOCAL lRetVal
LOCAL nOldSelect := SELECT()

USE c_esnxrf NEW SHARED
c_esnxrf->(ordsetfocus("c_esnxrc"))

IF LastKey() = K_UP
   lRetVal := TRUE
ELSEIF Empty( o:varGet() )
   lRetVal := TRUE
ELSEIF c_esnxrf->( DBSEEK( GetList[7]:VarGet()+o:VarGet() ) )
      //IF GetList[14]:VarGet() <> c_esnxrf->so_pn
      //   GetList[14]:VarPut(c_esnxrf->so_pn)
      //   GetList[14]:Display()
      //ENDIF
      IF GetList[13]:VarGet() <> c_esnxrf->so_pn
         //GetList[13]:VarPut(c_esnxrf->so_pn)
         //GetList[13]:Display()
      ENDIF
      IF GetList[12]:VarGet() <> c_esnxrf->esn_ID
         //GetList[12]:VarPut(c_esnxrf->esn_ID)
         //GetList[12]:Display()
      ENDIF
      lRetVal := TRUE
ELSE
  Msg24( {"301"} , 3, .T. )
  lRetVal := FALSE
ENDIF

CLOSE c_esnxrf
SELECT( nOldSelect )
RETURN lRetVal


/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: prePOLN_STAT()        Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 07-18-96              Date updated: ş07-18-96              ³
 * ³ Time created: 01:14:32pm            Time updated: ş01:14:32pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: o                                                          ³
 * ³ Return Value: .T.                                                        ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC FUNCTION prePOLN_STAT(o)

// changed 23-11-97 by Shalom; removed ability to edit the field
// so F2 key disabled and RETURN FALSE will make it skip this GET

//IF o:varget() <> "H"
//   RETURN FALSE
//ELSE
//   SetF2Key( o , "c_postat")
//ENDIF
//YG the above was commented out before, not by the following
//revdue changes
IF o:varget() $ "Q_T_E_"      //== "Q"    change by Tanya
   RETURN TRUE
ELSE
   return FALSE
ENDIF

RETURN FALSE // .T.

/**************************************************************/
STATIC FUNCTION postPOLN_STAT(o, lDord)
LOCAL cBuffer
LOCAL lRet :=  TRUE

OUT ON UP ARROW
cBuffer := o:varGet()

/*     s.b.  For the new Scheduled systems it's not needed.
IF !lAppendMode .AND. o:original <> "H"
   Msg24("You may not change this status", 3, .T. )
   lRet := FALSE
ELSEIF !lAppendMode .AND. o:original == "H" .AND. !cBuffer $ "HC"
      Msg24("You may only change the status from H to C", 3, .T. )
      lRet := FALSE
ELSEIF
*/
//YG the above was commented out before, not by the following
//revdue changes
//YG REVDUE
IF lDord
     IF d_ord->poln_stat == "Q"
          IF !(o:varget() $ "Q_ ")
               ALERT("You can only change a Q to a blank ")
               o:varput("Q")
               o:Display()
               return FALSE
          else //if now " " set d_ord->d_mrkdlv to empty
                 IF o:varget() == " "
                    ud_mkrqdlv := ctod("  /  /  ")
                    rd_mkrqrev := ctod("  /  /  ")
                    @ 15,44 SAY ud_mkrqdlv //even though it hasn't been updated yet
                    o:Display()
                 ENDIF
                 return TRUE
          ENDIF
     ENDIF
ELSEIF nDbf == DBF_ORDREQ .AND. d_ordreq->poln_stat == "E"
          IF !(o:varget() $ "H_E")
               ALERT("You can only change a E to a H ")
               o:varput("H")
               o:Display()
               return FALSE
			 ENDIF
ENDIF

IF RecElement( cBuffer, {|| c_postat->(FOUND()) }, "c_postat" )
   @ o:row,60 SAY RecElement( cBuffer, {|| c_postat->postat_nm }, "c_postat" , "c_postat") COLOR "W+/B"
   lRet := TRUE
   SetKey( K_F2 , NIL )
ELSE
   Msg24({"301"}, 3, TRUE )
   lRet := FALSE
END
RETURN lRet

/**************************************************************/
STATIC FUNCTION prePOLN_TYPE(o)
SetF2Key( o , "c_potype")
RETURN .T.

/**************************************************************/
STATIC FUNCTION postPOLN_TYPE(o,lDord)
LOCAL lRetVal := .T.
LOCAL cBuffer

OUT ON UP ARROW

cBuffer := o:varGet()
/*IF Empty( cBuffer )
   Msg24( {"164"} , 3, .T. )
   lRetVal := .F.
ELSE*/
//YG 11.5.99
//if the order has true in c_potype we will not allow a change to a poln_type
//that has a false in c_potype->incl_book
//please enjoy my clear code
IF lDord .AND. RecElement(d_ord->poln_type,{|| c_potype->(FOUND())},"c_potype","c_potype")
     if c_potype->incl_book .AND. RecElement(cBuffer,{|| c_potype->(FOUND())},"c_potype","c_potype");
          .AND. !c_potype->incl_book
          alert("No changing from billable to non-billable type allowed;" + ;
                 "Cancel old order and open up a new one")

          return .F.
     endif
ENDIF
IF RecElement(cBuffer,{|| c_potype->(FOUND())},"c_potype","c_potype")
     @ o:row,60 SAY c_potype->potype_nm COLOR "W+/B"
     lRetVal := .T.
ELSE
     Msg24( {"165"} , 3, .T. )
     lRetVal := .F.
ENDIF
//ENDIF
// added to reset date ordered to today if poln type changed to normal  SS 19.08.98
IF lDord .AND. cBuffer <> d_ord->poln_type .AND. cBuffer = ' '
    uD_ordrec = date()
ENDIF
IF lRetVal
   SetKey( K_F2 , NIL )
ENDIF

RETURN lRetVal

STATIC FUNCTION postPOLNTYPE_rnd(o)
LOCAL lRetVal := .T.
LOCAL cBuffer

OUT ON UP ARROW

cBuffer := o:varGet()
IF RecElement(cBuffer,{|| c_potype->(FOUND())},"c_potype","c_potype")
     lRetVal := .T.
ELSE
     Msg24( {"165"} , 3, .T. )
     lRetVal := .F.
ENDIF
IF lRetVal
   SetKey( K_F2 , NIL )
ENDIF

RETURN lRetVal



STATIC FUNCTION postDATA(o, cMsg )
LOCAL lRetVal

OUT ON UP ARROW

IF Empty( o:varGet() )
   Msg24( {"166" , cMsg } , 3, .T. )
   lRetVal := .F.
ELSEif o:varget() < date() .AND. lAppendMode
     Alert("Request date cannot be before " + dtoc(date()))
   lRetVal := .F.
ELSE
   lRetVal := .T.
ENDIF

RETURN lRetVal

STATIC FUNCTION postMrk(o, cMsg )
LOCAL lRetVal

OUT ON UP ARROW

if o:varget() < date()  .AND. dtoc(o:varget()) <> "  /  /  "  .AND. lAppendMode
     alert("Marketing date cannot be before " + dtoc(date()))
     lRetVal := .F.
ELSE
if o:varget() < date()+1  .AND. dtoc(o:varget()) <> "  /  /  "  .AND. (cdbf)->qty_alloc = (cdbf)->qty_ord
     alert("Marketing date cannot be before " + dtoc(date()+1))
     lRetVal := .F.
ELSE
     lRetVal := .T.
ENDIF
ENDIF

RETURN lRetVal

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: preQTY_ORD()          Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 08-18-96              Date updated: ş08-18-96              ³
 * ³ Time created: 10:14:36am            Time updated: ş10:14:36am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: o                                                          ³
 * ³ Return Value: .T.                                                        ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC FUNCTION preQTY_ORD(o)
o:picture := "999999999"
RETURN .T.


/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: postQTY_ORD()         Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 08-18-96              Date updated: ş08-18-96              ³
 * ³ Time created: 10:14:39am            Time updated: ş10:14:39am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: o                                                          ³
 * ³             : lDord                                                      ³
 * ³ Return Value: lRetVal                                                    ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC FUNCTION postQTY_ORD(o, lDord, cEsn )

LOCAL lRetVal
LOCAL nSelect := SELECT()
LOCAL aFiles  := GenOpenFiles({"d_esn","c_esny","c_esnxx","c_volt","c_tc"})
LOCAL nBuffer := o:VarGet()

d_esn->( ORDSETFOCUS("iesn_id"))

IF LastKey() = K_UP
   o:picture := "9,999,999"
   lRetVal := .T.
ENDIF

IF Negative( o )
   RETURN .F.
ENDIF

IF Empty( o:varGet() )
   Msg24( {"167"} , 3, .T. )
   lRetVal := .F.

ELSEIF lDord .AND. o:VarGet() < (cDbf)->qty_alloc
       Msg24("The order amount may NOT be less than the amount allocated.",3,.t.)
       lRetVal := FALSE

ELSE
   IF o:varGet() - GetList[24]:varGet() - (cDbf)->qty_shipd < 0
      Msg24( {"168"} , 3, .T. )
      lRetVal := .F.
   ELSE
      CalcSayBal()
      CalcSayPend()
      Redisplayrates(o)
      o:picture := "9,999,999"
      lRetVal := .T.
   ENDIF
ENDIF

IF d_esn->( DBSEEK(cEsn))
   IF c_esny->( DBSEEK(d_esn->esny_id))
      IF !Empty( nBuffer % c_esny->esny_qty )
         Msg24("The quantitiy must be in increments of "+;
                ALLTRIM(STR(c_esny->esny_qty))+".",3,.T.)
         lRetVal := FALSE
      ENDIF
   ELSE
      Msg24("The esnY value for this item not found in the control file. Call MIS.",3,.T.)
      lRetVal := FALSE
   ENDIF
ELSE
      Msg24("The esn value for this item not found in the control file. Call MIS.",3,.T.)
      lRetVal := FALSE
END

GenCloseFiles( aFiles )

RETURN lRetVal


STATIC FUNCTION postQTY_RND(o)
LOCAL lRetVal := .T.


IF Negative( o )
   lRetVal := .F.
ENDIF
IF o:varget() == 0
     lRetVal := .F.
ENDIF
return lRetVal


STATIC function Redisplayrates(o)
      // 1
      calcSPCU_POLN(  GetList[22]:varGet() , o:varGet() , GetList[24]:varGet() )
      @ 17,31 SAY Transform( rSPCU_POLN , "99,999,999.99" ) COLOR "W+/B"

      // 2
      calcSPD_POLN( GetList[22]:varGet() , o:varGet() , GetList[24]:varGet() , GetList[21]:varGet() )
      @ 17,51 SAY Transform( rSPD_POLN , "99,999,999.99" ) COLOR "W+/B"
      IF !uCurr_poln $ "USD_YEN"
          @ 16,11 SAY transform(rSpd_poln / uQty_ord,"99,999.9999")
      ENDIF
      // 3
      calcTPCU_POLN( GetList[23]:varGet() , o:varGet() , GetList[24]:varGet() )
      @ 18,31 SAY Transform( rTPCU_POLN , "99,999,999.99" ) COLOR "W+/B"

      // 4
      calcTPD_POLN( GetList[23]:varGet() , o:varGet() , GetList[24]:varGet() , cEsnCurr )
      @ 18,51 SAY Transform( rTPD_POLN , "99,999,999.99" ) COLOR "W+/B"

      // 5
      calcSTDC_POLN( o:varGet() , GetList[24]:varGet() , GetList[12]:varGet() )
      @ 19,51 SAY Transform( rSTDC_POLN , "99,999,999.99" ) COLOR "W+/B"


      @ 20, 53 SAY Transform( GMTP() , "999.9" ) COLOR "W+/B"
      @ 21, 53 SAY Transform( GMSP() , "999.9" ) COLOR "W+/B"
return nil

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: preQTY_CANC()         Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 08-18-96              Date updated: ş08-18-96              ³
 * ³ Time created: 10:14:28am            Time updated: ş10:14:28am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: o                                                          ³
 * ³ Return Value: .T.                                                        ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC FUNCTION preQTY_CANC(o)
o:picture := "999999999"
RETURN .T.

/**************************************************************/
STATIC FUNCTION postQTY_CANC(o)

IF LastKey() = K_UP
   o:picture := "9,999,999"
   RETURN .T.
ENDIF

IF Negative( o )
   RETURN .F.
ENDIF

IF GetList[19]:varGet() - o:varGet() - (cDbf)->qty_shipd < 0
   Msg24( {"168"} , 3, .T. )
   RETURN .F.
ENDIF

o:picture := "9,999,999"

CalcSayBal()
CalcSayPend()

// 1
calcSPCU_POLN(  GetList[22]:varGet() , GetList[20]:varGet() , o:varGet() )
@ 17,31 SAY Transform( rSPCU_POLN , "99,999,999.99" ) COLOR "W+/B"

// 2
calcSPD_POLN( GetList[22]:varGet() , GetList[20]:varGet() , o:varGet() , GetList[21]:varGet() )
@ 17,51 SAY Transform( rSPD_POLN , "99,999,999.99" ) COLOR "W+/B"
IF !uCurr_poln $ "USD_YEN"
       @ 16,11 SAY transform(rSpd_poln / uQty_ord,"99,999.9999")
ENDIF
// 3
calcTPCU_POLN( GetList[23]:varGet() , GetList[20]:varGet() , o:varGet() )
@ 18,31 SAY Transform( rTPCU_POLN , "99,999,999" ) COLOR "W+/B"

// 4
calcTPD_POLN( GetList[23]:varGet() , GetList[20]:varGet() ,  o:varGet() , cEsnCurr )
@ 18,51 SAY Transform( rTPD_POLN , "99,999,999.99" ) COLOR "W+/B"

// 5
calcSTDC_POLN( GetList[20]:varGet() , o:varGet() , GetList[12]:varGet())
@ 19,51 SAY Transform( rSTDC_POLN , "99,999,999.99" ) COLOR "W+/B"


@ 20, 53 SAY Transform( GMTP() , "999.9" ) COLOR "W+/B"
@ 21, 53 SAY Transform( GMSP() , "999.9" ) COLOR "W+/B"
RETURN .T.
/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: preCU_EACH()          Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 08-08-96              Date updated: ş08-08-96              ³
 * ³ Time created: 09:36:19am            Time updated: ş09:36:19am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: o                                                          ³
 * ³ Return Value: .T.                                                        ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC FUNCTION preCU_EACH(o, lDord, cStat)

IF lDord .AND. !cStat $ " _Q_T" // added Q & T SS 17/05/00 (open orders)
   RETURN FALSE
ENDIF

o:picture := "999999.9999"
RETURN .T.

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: postCU_EACH()         Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 08-08-96              Date updated: ş08-08-96              ³
 * ³ Time created: 09:36:22am            Time updated: ş09:36:22am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: o                                                          ³
 * ³             : cCode                                                      ³
 * ³ Return Value: lRetVal                                                    ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC FUNCTION postCU_EACH(o , cCode )
LOCAL lRetVal

IF LastKey() = K_UP
   o:picture := "99,999.9999"
   lRetVal := .T.
ENDIF

IF Empty( o:varGet() ) .AND. ((GetList[16]:varGet() <> "4") .AND. (uBillag_id <> "PHOA"))
   Msg24( {"170"} , 3, .T. )
   lRetVal := .F.
ELSE
   o:picture := "99,999.9999"
// introduce new check: if isralei agency is phoenix don't bind TP to SP SS 17.05.00
   IF cCode == "SP" .AND. ((GetList[17]:varGet() <> "4")  .AND. (uBillag_id <> "PHOA"))
      calcSPCU_POLN(  o:varGet() , GetList[20]:varGet() , GetList[24]:varGet() )
      @ 17,31 SAY Transform( rSPCU_POLN , "99,999,999.99" ) COLOR "W+/B"

      calcSPD_POLN( o:varGet() , GetList[20]:varGet() , GetList[24]:varGet() , GetList[21]:varGet() )
      @ 17,51 SAY Transform( rSPD_POLN , "99,999,999.99" ) COLOR "W+/B"
      IF !uCurr_poln $ "USD_YEN"
       @ 16,11 SAY transform(rSpd_poln / uQty_ord,"99,999.9999")
      ENDIF
       // this IF..END gives default value to TP_EACH for Israeli customers
       IF (o:Original <> NIL  .AND. c_cust->SAREA_ID == "4") .OR. ;
          EMPTY( Getlist[23]:Varget() )            //.AND. o:Varget() <> o:Original
         Getlist[23]:VarPut( o:Varget() )
         Getlist[23]:display()
      ENDIF
   ELSE
      calcTPCU_POLN(  o:varGet() , GetList[20]:varGet() , GetList[24]:varGet() )
      @ 18,31 SAY Transform( rTPCU_POLN, "99,999,999.99" ) COLOR "W+/B"
      // 4
      calcTPD_POLN( o:varGet() , GetList[20]:varGet() ,  GetList[24]:varGet() , cEsnCurr )
      @ 18,51 SAY Transform( rTPD_POLN , "99,999,999.99" ) COLOR "W+/B"
		IF o:changed
			GetDescription()
		ENDIF
   ENDIF

   @ 20, 53 SAY Transform( GMTP() , "999.9" ) COLOR "W+/B"
   @ 21, 53 SAY Transform( GMSP() , "999.9" ) COLOR "W+/B"
   lRetVal := .T.
ENDIF

RETURN lRetVal .AND. LastKey() <> K_ESC

Static Procedure GetDescription()

LOCAL cScreen := SaveScreen()
//LOCAL cTmpGetList := GetList
cIniTp := AllTrim(GetUserInfo():cUserId)//Space(10)
dDateTp:= Date()//CTOD("  /  /  ")
//GetList := {}

/*@12, 20 CLEAR TO 17, 61
DrawBox( 12, 20, 17, 61 )

@12, 22 SAY "TP Changed...."

@14, 30 SAY "Initiator  : " GET cIniTp  PICTURE '@!' VALID !Empty(cIniTp) COLOR GETCOLORS
@15, 30 SAY "Date       : " GET dDateTp VALID !Empty(dDateTp) COLOR GETCOLORS

READ


RestScreen( ,,,, cScreen )

GetList := cTmpGetList*/
Alert("Transfer price has been changed",{"Ok"})
Return



/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: preCURR_POLN()        Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 08-08-96              Date updated: ş08-08-96              ³
 * ³ Time created: 09:36:27am            Time updated: ş09:36:27am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: o                                                          ³
 * ³ Return Value: .T.                                                        ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC FUNCTION preCURR_POLN(o, lDord, cStat)

IF lDord .AND. cStat <> " " // open order
   RETURN .f.
ENDIF

SetF2Key( o , "c_curr")
RETURN .T.

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: postCURR_POLN()       Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 08-08-96              Date updated: ş08-08-96              ³
 * ³ Time created: 09:36:30am            Time updated: ş09:36:30am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: o                                                          ³
 * ³ Return Value: lRetVal                                                    ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC FUNCTION postCURR_POLN(o)
LOCAL lRetVal := .T.
LOCAL cBuffer


OUT ON UP ARROW

cBuffer := o:varGet()
IF Empty( cBuffer )
   Msg24( {"171"} , 3, .T. )
   lRetVal := .F.
ELSE
   IF RecElement( cBuffer, {|| c_curr->( Found() ) }, "c_curr" )
      @ o:row , 26 SAY cBuffer COLOR "W+/B"
      lRetVal := .T.
   ELSE
      Msg24( {"172"} , 3, .T. )
      lRetVal := .F.
   ENDIF
ENDIF


IF lRetVal
   SetKey( K_F2 , NIL )
ENDIF

UpYourRate(cBuffer,uD_Exch)

@ 21,10 SAY BuildRateLine( cBuffer , rEXCH_RATE , uD_Exch ) color "w+/b"
IF !uCurr_poln $ 'USD_YEN'
    @ 16,11 SAY transform(rSpd_poln / uQty_ord,"99,999.9999")
ENDIF
RETURN lRetVal

// new rate getter SS 19/11/98
STATIC FUNCTION UpYourRate(a,b)
// a = rate, b = date
LOCAL nOldOrd
LOCAL nSelect := Select( Alias() )
SELECT c_exrate
nOldOrd := c_exrate->( IndexOrd() )
ordSetFocus( "itpdt" )

IF c_exrate->( DbSeek( a + dtos(b)) )
   rEXCH_RATE := c_exrate->nis_in_uom
ENDIF

c_exrate->( DbSetOrder( nOldOrd ) )
SELECT (nSelect)
RETURN rExch_rate
// calculate and say balance

/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: CalcSayBal()                                               ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine         Designer:                            ³
 * ³ Date created: 08-08-96              Date updated: ş08-08-96              ³
 * ³ Time created: 09:36:41am            Time updated: ş09:36:41am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: None                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC PROCEDURE CalcSayBal()
LOCAL nBal := GetList[20]:varGet() - GetList[24]:varGet() - (cDbf)->qty_shipd
@ 19,71 SAY Transform( nBal , "9,999,999" ) COLOR "R+/B"
RETURN

// calculate and say pending

/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: CalcSayPend()                                              ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine         Designer:                            ³
 * ³ Date created: 08-08-96              Date updated: ş08-08-96              ³
 * ³ Time created: 09:36:46am            Time updated: ş09:36:46am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: None                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC PROCEDURE CalcSayPend()
LOCAL nPend := GetList[20]:varGet() - GetList[24]:varGet() - (cDbf)->qty_shipd - (cDbf)->qty_alloc
@ 21,71 SAY Transform( nPend , "9,999,999" ) COLOR "BG+/B"
RETURN

// 1
/**************************************************************/
FUNCTION calcSPCU_POLN( pSPCU_EA , pQTY_ORD , pQTY_CANC )
RETURN (rSPCU_POLN := pSPCU_EA * ( pQTY_ORD - pQTY_CANC ))

// 2
// ( calc 3 in mrkscr2.doc )
/**************************************************************/
FUNCTION calcSPD_POLN( pSPCU_EA , pQTY_ORD , pQTY_CANC , cCurrPOLN )
RETURN ( rSPD_POLN := (( pQTY_ORD - pQTY_CANC ) * Trans2Dollar( pSPCU_EA , cCurrPOLN, uD_EXCH )) )

// 3
/**************************************************************/
FUNCTION calcTPCU_POLN( pTPCU_EA , pQTY_ORD , pQTY_CANC )
RETURN (rTPCU_POLN := pTPCU_EA * ( pQTY_ORD - pQTY_CANC ))

// 4
// ( calc 4 in mrkscr2.doc )
/**************************************************************/
FUNCTION calcTPD_POLN( pTPCU_EA , pQTY_ORD , pQTY_CANC , cTPCurr)
RETURN (rTPD_POLN := (( pQTY_ORD - pQTY_CANC ) * Trans2Dollar( pTPCU_EA , cTPCurr, uD_EXCH)) )

//
/**************************************************************/
FUNCTION calcSTDC_POLN( pQTY_ORD , pQTY_CANC , cESN )

LOCAL oUnit := UnitCost():new( cESN )
oUnit:calculatePrice()
RETURN ( rSTDC_POLN := oUnit:nCostPerUnit * ( pQTY_ORD - pQTY_CANC ) )


/**************************************************************/
FUNCTION Trans2Dollar( nEa , cCurr, dD_exch )

LOCAL nNis_Ea := 0
LOCAL nD_Ea := 0
LOCAL cFindCurr

IF RecElement( cCurr, {|| c_curr->( Found() )},"c_curr" )

   cFindCurr := FindCurrency( cCurr , dD_EXCH )

   IF cFindCurr $ "EQ_LOW"
      nNis_Ea := nEa * ( c_exrate->nis_in_uom / c_curr->curr_uom )

      cFindCurr := FindCurrency( "USD" , dD_EXCH )
      IF cFindCurr $ "EQ_LOW"
         nD_Ea := nNis_Ea / c_exrate->nis_in_uom  // USD UOM=1
      ENDIF
   ELSE
   nD_Ea := nEa  //0
   ENDIF

ELSE
   Msg24( {"173", cCurr}  ,3 , .T. )
   nD_Ea := nEa  //0
ENDIF

RETURN nD_Ea

/**************************************************************/
FUNCTION SetD_Exch( dParam )
LOCAL dOld := uD_EXCH

IF dParam != NIL
   uD_EXCH := dParam
ENDIF
RETURN dOld

/**************************************************************/
STATIC FUNCTION GMTP()
RETURN ((rTPD_POLN - rSTDC_POLN) / rTPD_POLN) * 100

/**************************************************************/
STATIC FUNCTION GMSP()
RETURN ((rSPD_POLN - rTPD_POLN) / rSPD_POLN) * 100



/**************************************************************/
PROCEDURE OpenOrder
LOCAL nSaveRec
LOCAL oOrdReq := TabBase():new( cDbf )

oOrdReq:setIndexList()
oOrdReq:xopen()

scrnPush(2,0,23,79, .T. )  // .T. to scroll the region (e.g Clear it)

ordviewOpenTables()

ordGet( K_INS , "brow" )

ordviewClose()
scrnPop()

oOrdReq:close()

RETURN

/**************************************************************
* This section contains the functions to edit an ESN_ID
* from within an order, and add it to d_esn.dbf if it
* doesn't exist
******************************************************/

FUNCTION EditESNID( oGet )

LOCAL cEsnSave
LOCAL cScr      := SAVESCREEN()
LOCAL GetList   := {}
LOCAL lContinue := TRUE
LOCAL o         := PartBase():new()

LOCAL t := 10
LOCAL l := 20
LOCAL b := 19
LOCAL r := 60

IF EMPTY( oGet:VarGet() )
   ALERT("You must first select an ESN to edit.",{" OK "})
   lContinue := FALSE
ENDIF

IF lContinue
    cEsnSave := oGet:VarGet()
    o:cEsn   := oGet:VarGet()
   DO CASE
      CASE Left( o:cEsn ,2 ) == "LP"
           o:scattarFilter()
      CASE Left( o:cEsn ,2 ) == "CP"
           o:scattarCoupler()
      CASE Left( o:cEsn ,2 ) == "RS"
           o:scattarResonator()
      CASE Left( o:cEsn ,3 ) == "KIT"
           o:scattarKits()
      CASE Left( o:cEsn ,3 ) == "MAT"
           o:scattarMatch()
      CASE Left( o:cEsn ,1 ) == "F"
           o:scattarFuse()
      CASE Left( o:cEsn ,1 ) == "L"
           o:scattarInductor()
      OTHERWISE
          o:scattarCapacitor()
   END


    DispBox( t, l, b,  r ,FRAMECAPTION+" ", "w+/b" )
    @ t , l+2 SAY " Edit ESN ID: "+o:cEsn+" " COLOR "w+/g"
    AddShadow( t, l, b, r  )

    @ t+ 3, l+1 SAY REPLICATE( "Ä", r-l-1)
    @ t+ 5, l+1 SAY REPLICATE( "Ä", r-l-1)
    @ t+ 7, l+1 SAY REPLICATE( "Ä", r-l-1)

    @ t+ 2, l+9 SAY "Voltage   :" COLOR IF( o:cVoltage                == NIL .OR. EMPTY(o:cVoltage               ), "n+/b", "bg+/b")
    @ t+ 4, l+9 SAY "TC        :" COLOR IF( o:cTemperatureCoefficient == NIL .OR. EMPTY(o:cTemperatureCoefficient), "n+/b", "bg+/b")
    @ t+ 6, l+9 SAY "ESNXX     :" COLOR IF( o:cEsnNo                  == NIL .OR. EMPTY(o:cEsnNo                 ), "n+/b", "bg+/b")
    @ t+ 8, l+9 SAY "ESNY      :" COLOR IF( o:cEsnPacking             == NIL .OR. EMPTY(o:cEsnPacking            ), "n+/b", "bg+/b")

    IF o:cVoltage  <> NIL  .AND. !EMPTY(o:cVoltage)
       @ t+ 2, l+21 GET o:cVoltage         ;
         PICTURE "!"                       ;
         SEND PreBlock  := {|o| PreV(o)  };
         SEND PostBlock := {|o| PostV(o) }
    END
    IF o:cTemperatureCoefficient <> NIL .AND. !EMPTY(o:cTemperatureCoefficient)
       @ t+ 4, l+21 GET o:cTemperatureCoefficient;
         PICTURE "!"                             ;
         SEND PreBlock  := {|o| PreTC(o)  }      ;
         SEND PostBlock := {|o| PostTC(o) }
    END
    IF o:cEsnNo <> NIL  .AND. !EMPTY(o:cEsnNo)
       @ t+ 6, l+21 GET o:cEsnNo           ;
         PICTURE "!!"                      ;
         SEND PreBlock  := {|o| PreXX(o)  };
         SEND PostBlock := {|o| PostXX(o) }
    END
    IF o:cEsnPacking  <> NIL  .AND. !EMPTY(o:cEsnPacking)
       @ t+ 8, l+21 GET o:cEsnPacking     ;
         PICTURE "!"                      ;
         SEND PreBlock  := {|o| PreY(o)  };
         SEND PostBlock := {|o| PostY(o) }
    END

    READ

    IF LASTKEY() == K_ESC
       SetF2Key( o , "d_esn")
    ELSE
       o:EsnNo()
       UpdateEsnDbf( cEsnSave, o )
       oGet:VarPut( o:EsnNo )
       oGet:Display()
    ENDIF
ENDIF   // lContinue

RESTSCREEN(0,0,24,79,cScr)

RETURN NIL

/************************************************************************/
STATIC FUNCTION PreV( oGet )
SetF2Key( oGet, "c_volt",NIL,NIL,NIL,"c_volt")
RETURN TRUE

STATIC FUNCTION PreTC( oGet )
SetF2Key( oGet, "c_tc",NIL,NIL,NIL,"c_tc")
RETURN TRUE

/**********************************************************************/
STATIC FUNCTION PreXX( oGet )
SetF2Key( oGet, "c_esnxx",NIL,NIL,NIL,"esnxxid")
RETURN TRUE

STATIC FUNCTION PreY( oGet )
SetF2Key( oGet, "c_esny",NIL,NIL,NIL,"c_esny")
RETURN TRUE

/**********************************************************************/
STATIC FUNCTION PostV( oGet )

LOCAL lRet := FALSE
LOCAL cBuffer := oGet:varGet()

IF Empty( cBuffer )
   Msg24( {"300"} , 3, .T. )
ELSEIF !RecElement( cBuffer, {|| c_volt->(FOUND()) }, "c_volt" , "c_volt")
   Msg24( {"301"} , 3, .T. )
ELSE
   lRet := TRUE
   SETKEY( K_F2, NIL )
ENDIF

RETURN lRet

/**********************************************************************/
STATIC FUNCTION PostTC( oGet )

LOCAL lRet := FALSE
LOCAL cBuffer := oGet:varGet()

IF Empty( cBuffer )
   Msg24( {"300"} , 3, .T. )
ELSEIF !RecElement( cBuffer, {|| c_tc->(FOUND()) }, "c_tc" , "c_tc")
   Msg24( {"301"} , 3, .T. )
ELSE
   lRet := TRUE
   SETKEY( K_F2, NIL )
ENDIF

RETURN lRet

/**********************************************************************/
STATIC FUNCTION PostXX( oGet )

LOCAL lRet := FALSE
LOCAL cBuffer := oGet:varGet()

IF Empty( cBuffer )
   Msg24( {"300"} , 3, .T. )
ELSEIF !RecElement( cBuffer, {|| c_esnxx->(FOUND()) }, "c_esnxx" , "esnxxid")
   Msg24( {"301"} , 3, .T. )
ELSE
   lRet := TRUE
   SETKEY( K_F2, NIL )
ENDIF

RETURN lRet

/**********************************************************************/
STATIC FUNCTION PostY( oGet )

LOCAL lRet := FALSE
LOCAL cBuffer := oGet:varGet()

IF Empty( cBuffer )
   Msg24( {"300"} , 3, .T. )
ELSEIF !RecElement( cBuffer, {|| c_esny->(FOUND()) }, "c_esny" , "c_esny")
   Msg24( {"301"} , 3, .T. )
ELSE
   lRet := TRUE
   SETKEY( K_F2, NIL )
ENDIF

RETURN lRet

/**********************************************************************/
STATIC FUNCTION UpdateEsnDbf( cEsnSave, oPart )

LOCAL aInfo  := {}
LOCAL cScr   := SAVESCREEN(24,0,24,79)
LOCAL i

d_esn->( ORDSETFOCUS("iesn_id"))

IF !d_esn->( DBSEEK( oPart:cEsn ) )
   @24, 0 SAY "Updating lookup table, please wait..." COLOR "gr+/r"
   d_esn->( DBSEEK(cEsnSave) )
   FOR i := 1 TO d_esn->( FCOUNT() )
       AADD( aInfo, d_esn->( FIELDGET(i) ) )
   NEXT
   d_esn->( AddRec(5, "ORDGET" ) )
   FOR i := 1 TO d_esn->( FCOUNT() )
       d_esn->( FIELDPUT( i, aInfo[i] ) )
   NEXT
   d_esn->esn_id   := oPart:cEsn
   d_esn->avxilpn  := CreateAVXil(opart:cEsn)
   d_esn->maxstock := 0
   d_esn->dlu_maxstk := ctod("  /  /  ")
   IF( oPart:cVoltage <> NIl, d_esn->volt_id := oPart:cVoltage, NIL )
   d_esn->esnxx_id := oPart:cEsnNo
   d_esn->esny_id  := oPart:cEsnPacking
   IF( oPart:cTemperatureCoefficient <> NIL,;
                           d_esn->tc_id := oPart:cTemperatureCoefficient, NIL )
ENDIF

RETURN NIL

FUNCTION SETSOPN(esnid,sopn)
default sopn to ""
IF empty(SOPN)
     SOPN := ESNID
ENDIF
return nil

// added 12/12/97 to establish new avxilpn SS
STATIC FUNCTION CreateAVXil (esnid)
local esnlen :=  len(rtrim(esnid))
local esny   :=  subs(esnid,esnlen,1)
local esnil  := space(16)
Do Case
   Case esny $ '1_3_B'                 // added 3_B SS 19.05.98
     esnil := subs(esnid,1,esnlen-3)
   Otherwise
     esnil := subs(esnid,1,esnlen-3)+'TR'
End

return esnil

STATIC FUNCTION postRoute(o)
LOCAL cBuffer := o:varGet()

OUT ON UP ARROW

IF Empty( cBuffer )
   Msg24( {"166" , "Route card" } , 3 , .T. )
   RETURN .F.
ENDIF

IF c_rlib->( DbSeek( cBuffer ) )
   IF c_rlib->route_stat == "H"
      Msg24( {"204"} , 3 , .T. )
      RETURN .F.
   ELSE
         RETURN .F.
   ENDIF
ELSE
   Msg24( {"189" , "Route:"+cBuffer } , 3 , .T. )
   RETURN .F.
ENDIF

RETURN .T.
//////////////////vitaly 25.02.2001
Function TestSubst(cVoltSource,cVoltTarget)
LOcal lRetVal
Local cSourceEsn := "0805"+cVoltSource + "K0R1AAW000"   //using sust.function.Only tc & volt are
lOCAL cTargetEsn := "0805"+cVoltTarget+"K0R1AAW000" //currently relevant
local oProfile := StkValSub():new()
lRetVal := oProfile:GoodSubst(cSourceEsn,nil,cTargetEsn,NIL,.F.,.F.)
Return lRetVal
////////////////////////////////////
Static Function GetVoltNm(cVolt)
local cRetVal
DO CASE
   CASE cVolt == "1"
        cRetVal := "100V"
   CASE cVolt == "3"
        cRetVal := "25V"
   CASE cVolt == "5"
        cRetVal := "50V"
   CASE cVolt == "Y"
        cRetVal := "16V"
   CASE cVolt == "Z"
        cRetVal := "10V"
ENDCASE
Return cRetVal

PROCEDURE RMA()

LOCAL oCol
LOCAL oForm
local cSopn := Space(15)
local oBro
local aDetails := {}

LOCAL aKeyList:={;
                 { "F5       - Open new RMA   ",K_F5     },;
                 { "Esc      - Exit           ",K_ESC    };
                }


aPtype := {}

SetHlpKeys( aKeyList )


oForm := Form():new(/*t*/,/*l*/,/*b*/,/*r*/, "RMA management",NIL, ProcName(), FALSE )

IF !rmaOpenFiles()
   RETURN
ENDIF

oBro := ABrowseNEW(2,50,8,78,aPtype )
oBro:headSep   := "ÍÑÍ"
oBro:colSep    := " ³ "
oBro:footSep   := "ÍÏÍ"
oBro:colorSpec := Colors()

oCol := TBColumnNEW("Sono", {|| oBro:arrayReference[oBro:arrayIndex]})
oBro:addColumn( oCol )

set cursor on

@ 3,2 SAY "Enter Sono's for new RMA:" GET cSopn PICTURE "@!" COLOR GETCOLORS;
                 SEND postBlock := {|o| pSONORMA(o,oBro) }

READ

WHILE .T.
     WHILE !oBro:stabilize() ; ENDDO

     nKey := TimeOutInKey()

     F1 PRESSED

     IF nKey = K_ESC
        EXIT
     ELSEIF nKey = K_RIGHT
         Tone( 45 , .5 )
     ELSEIF StdKeys( nKey , oBro )
     ELSE
         DO CASE
            CASE nKey = K_F5
					  aDetails := LoadSonos()
/*            CASE nKey = K_SPACE .AND. nSelector = 1 // FOR PRODUCT TYPE

                 nKey := 0
                 FOR i := 1 TO Len( o:arrayReference )
                     IF o:arrayReference[i,1] == "[X]"
                        nKey := i // save old tag
                     ENDIF
                     o:arrayReference[i,1] := "[ ]"
                 NEXT

                 cProductType := o:arrayReference[o:arrayIndex,2]
                 IF ValidDependings(o:arrayReference[o:arrayIndex,2], nKey )
                    o:arrayReference[o:arrayIndex,1] := "[X]"
                    //
                    nKey := At( o:arrayReference[o:arrayIndex,2] , cPartSymbol )
                    cPartControl := aAttrib[nKey]
                    aPline       := {}
                    aSize        := {}
                    aValue       := {}
                    aTolerance   := {}
                    aTermination := {}
                    aTC          := {}
                    aVoltage     := {}
                    aESNxx       := {}
                    aESNy        := {}
                 ELSE
                    IF nKey = 0
                       cProductType := ""
                    ELSE
                       o:arrayReference[nKey,1] := "[X]"
                       cProductType := o:arrayReference[o:arrayIndex,2]
                    ENDIF
                 ENDIF
                 o:refreshAll()
            CASE nKey = K_SPACE .AND. nSelector > 1  // REST OF TABLEs
                 IF o:arrayReference[o:arrayIndex,1] == "[ ]"
                    IF ValidDependings( o:arrayReference[o:arrayIndex,2] , nKey )
                       o:arrayReference[o:arrayIndex,1] := "[X]"
                    ENDIF
                 ELSE
                    o:arrayReference[o:arrayIndex,1] := "[ ]"
                 ENDIF
                 o:refreshCurrent()
            CASE nKey = K_F7 .AND. nSelector > 1    // tag all
                 FOR i := 1 TO Len( o:arrayReference )
                     IF ValidDependings(o:arrayReference[i,2], nKey)
                        o:arrayReference[i,1] := "[X]"
                     ENDIF
                 NEXT
                 o:refreshAll()
            CASE nKey = K_SH_F7 .AND. nSelector > 1
                 FOR i := 1 TO Len( o:arrayReference )
                     o:arrayReference[i,1] := "[ ]"
                 NEXT
                 o:refreshAll()
                 lChanged := .T.
            CASE nKey = K_ALT_F7 .AND. nSelector > 1
                 FOR i := 1 TO Len( o:arrayReference )
                     IF o:arrayReference[i,1] == "[ ]"
                        IF ValidDependings(o:arrayReference[i,2], nKey )
                           o:arrayReference[i,1] := "[X]"
                        ENDIF
                     ELSE
                        o:arrayReference[i,1] := "[ ]"
                     ENDIF
                 NEXT
                 o:refreshAll()
            CASE nKey = K_ALT_V // .AND. nSelector > 1
                 esngenViewSelections()
            CASE nKey = K_F10
                 IF ValidSelected()
                    cOldScr := SAVESCREEN(24,0,24,79)
                    @24,0 SAY "Processing, please be patient..." COLOR "w+/r"
                    esngenGenearate( esngenGetComponents() , esngenSetIndic() )
                    RESTSCREEN(24,0,24,79,cOldScr)
                    IF lCode
                       esngenPartShow( lCode )
                    ELSE
                       EXIT
                    ENDIF
                 ENDIF*/
         ENDCASE
     ENDIF
ENDDO

AvxCloseFiles()
oForm:hide(TRUE)

set cursor off

RETURN

Static Function LoadSonos()
local aRet
Return aRet

Static Function pSONORMA(o,oBro)

local lRet := FALSE
IF ascan(aPtype,o:Varget()) == 0 .AND. d_ord->(dbseek(o:Varget()))
	aadd(aPtype,o:Varget())
	WHILE !oBro:stabilize() ; ENDDO
	oBro:RefreshAll()
	IF Alert("Do you want another one?",{"Yes","No"}) == 2
		lRet := TRUE
	ENDIF
ENDIF
Return lRet

STATIC FUNCTION rmaOpenFiles

aoOpenedList := {}
aoOpenedList := genOpenFiles( { "c_cust", "c_cntry" , "c_cuco"  ,;
                                "c_curr", "c_sarea", "c_agency",;
                                "d_ord" })

d_ord->(ordsetfocus("iordsnl"))

RETURN OpenState( aoOpenedList )