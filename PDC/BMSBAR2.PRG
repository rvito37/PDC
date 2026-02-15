#include "avxdefs.ch"

STATIC mB_ID
STATIC mCP_WIDSTA

STATIC nQtyW
STATIC nQtyS
STATIC nQtyP
STATIC mConfirm
STATIC mRej,HVal_DT := 0.00,LVal_DT := 0.00,lDT := FALSE
STATIC lRejFlag

STATIC lEndOfBatch := .F.
STATIC cEndType , lGoodSw

STATIC nRejected , nM999Rejected

STATIC aRegularRej :={}

STATIC lRejEob := .F.

STATIC nTolPP
STATIC nTolQP
STATIC nTolAP                                    // tolerance A Packed
STATIC nTolBP
STATIC nTolCP
STATIC nTolDP
STATIC nTolFP
STATIC nTolGP
STATIC nTolJP
STATIC nTolZP
STATIC nTolXP

STATIC nTolPL
STATIC nTolQL
STATIC nTolAL                                    // tolerance A lOOSE
STATIC nTolBL
STATIC nTolCL
STATIC nTolDL
STATIC nTolFL
STATIC nTolGL
STATIC nTolJL
STATIC nTolZL
STATIC nTolXL
STATIC nTolRL

STATIC nScrap_Q,nScrap_Flash,nScrap_Res,nScrap_NoDescr

// variables for screen F7
STATIC nGoodPacked , nGoodLoose , nValueR

// variables for screen F8
STATIC nRange1
STATIC nRange2
STATIC nRange3
STATIC nRange4
STATIC nRange5
STATIC nRange6
STATIC nRange7
STATIC nRange8
STATIC nRange9
STATIC nRange10


STATIC cCode1Rej,cCode2Rej
STATIC cDoch1Eatama,cDoch2Eatama
STATIC cNote1 , cNote2
STATIC aRejInfo := {}

STATIC aGoodKeys := {K_ENTER,K_PGDN, K_PGUP}

#DEFINE SCRAP_TOL   1
#DEFINE SCRAP_Q     2
#DEFINE SCRAP_FLASH 3
#DEFINE SCRAP_RES   4

PROCEDURE BNleave
LOCAL cScreen := SaveScreen()
LOCAL cLine24
LOCAL mCPPROC_ID := 0
LOCAL mCP_STAGE  := 0

LOCAL oRejTab
LOCAL bCheck :=   {|| m_linemv->arr .AND. m_linemv->sta .AND. !m_linemv->fin }


mCP_WIDSTA := "     "
mB_ID      := Space( 6 )


nQtyW := 0
nQtyS := 0
nQtyP := 0
mConfirm := .Y.
mRej     := .N.

IF !enterOpen()
     Alert( "Can not open " + GetErrorFile() )
RETURN
ENDIF


IF NetUse( "c_thqty" , 5 )
     c_thqty->( ordsetfocus( "itsuom" ) )
ENDIF

IF NetUse( "c_rejcd" , 5 )
     c_rejcd->( ordsetfocus( "irejid" ) )
ENDIF

PutF1OnScreen()

lEndOfBatch := .F.

IF !IfEnglish()
   @ 5,29 GET mB_ID       PICTURE "@K 999999" SEND postBlock := { |o| BidExists(o) }
   @ 6,30 GET mCP_WIDSTA  PICTURE "@K 99999"  SEND postBlock := { |o| WidExists(o) }
   @ 7,30 GET mCPPROC_ID  PICTURE "@K 999.9"  SEND postBlock := { |o| Proc2Exists(o) }
   @ 8,31 GET mCP_STAGE   PICTURE "@K 9999"   SEND postBlock := { |o| postStage(o,bCheck,.T. ) }
ELSE
   @ 5,40 GET mB_ID       PICTURE "@K 999999" SEND postBlock := { |o| BidExists(o) }
   @ 6,41 GET mCP_WIDSTA  PICTURE "@K 99999"  SEND postBlock := { |o| WidExists(o) }
   @ 7,41 GET mCPPROC_ID  PICTURE "@K 999.9"  SEND postBlock := { |o| Proc2Exists(o) }
   @ 8,42 GET mCP_STAGE   PICTURE "@K 9999"   SEND postBlock := { |o| postStage(o,bCheck,.T. ) }
ENDIF
READ

IF ASCAN( aGoodKeys, LASTKEY() ) > 0
     IF mConfirm
          IF lEndOfBatch
               DoEndOfBatch()
          ELSE
               barUpdateAll(mCP_WIDSTA)
          ENDIF
			 UpdLoc(mB_ID,mCP_WIDSTA)
			 NetUse("c_warea",5)
			 c_warea->(ordsetfocus(2))
			 NetUse("d_warea",5)
			 d_warea->(ordsetfocus(2))
			 if d_warea->(dbseek(mCP_WIDSTA)) .AND. ;
			 	c_warea->(dbseek(str(mCPPROC_ID,5,1)))       .AND. ;
			 	d_warea->warea_id <> c_warea->warea_id .AND. ;
			    d_warea->( RecLock( 5 ) )

			 	d_warea->FINISH_D := Date()
			 	d_warea->FINISH_T := Left( Time() , 5 )
			 	d_warea->(dbunlock())
			 	IF d_warea->( AddRec(5) )
			 	   d_warea->warea_id := c_warea->warea_id
			 	   d_warea->desc     := c_warea->desc
			 	   d_warea->w_id     := mCP_WIDSTA
			 	   d_warea->START_D  := Date()
			 	   d_warea->START_T  := Left( Time() , 5 )

			 	   d_warea->(dbunlock())
			 	ENDIF
			 	Msg24("Finish in your previous work has been reported..." , 2 , .T. )
			 elseif !d_warea->(dbseek(mCP_WIDSTA))          .AND. ;
			 	     c_warea->(dbseek(str(mCPPROC_ID,5,1)))  .AND. ;
			 	     d_warea->( AddRec(5) )


					 d_warea->warea_id := c_warea->warea_id
			  		 d_warea->desc     := c_warea->desc
			  		 d_warea->w_id     := mCP_WIDSTA
			  		 d_warea->START_D  := Date()
			  		 d_warea->START_T  := Left( Time() , 5 )
			  		 d_warea->(dbunlock())
			  		 Msg24("Start in your new work has been reported !" , 2 , .T. )
			 endif
			 c_warea->(dbcloseArea())
			 d_warea->(dbcloseArea())
     ENDIF
ENDIF

enterClose()
bar2Kill()

c_rejcd->( DbCloseArea() )
c_thqty->( DbCloseArea() )
RestScreen( ,,,, cScreen )
RETURN

STATIC PROCEDURE bar2Kill
nQtyW := nQtyS := nQtyP := mConfirm := mRej := ;
nTolPP:=nTolQP:=nTolAP:=nTolBP:=nTolCP:=nTolDP:=nTolFP:=nTolGP:=nTolJP:=nTolZP:=nTolXP:=;
nTolPL:=nTolQL:=nTolAL:=nTolBL:=nTolCL:=nTolDL:=nTolFL:=nTolGL:=nTolJL:=nTolZL:=nTolXL:=;
nGoodPacked := nGoodLoose:=nTolRL:= nScrap_Q:= nScrap_Flash:= nScrap_Res:=nScrap_NoDescr:=;
nValueR:=nRange1:=nRange2:=nRange3:=nRange4:=nRange5:=nRange6:=;
         nRange7:=nRange8:=nRange9:=nRange10:=NIL
RETURN

STATIC FUNCTION Proc2Exists(o)
LOCAL lRetVal
LOCAL cList
LOCAL nOldArea := Select()

HVal_DT := 0.00
LVal_DT := 0.00
lDT := FALSE

IF o:varGet() = 196 .OR. o:varGet() = 196.5//vr 23-02-03
     cList := MemoRead( "barpass" )
     IF FALSE //!(NNetWhoAmI() $ Upper(cList))
		 IF !IfEnglish()
           Alert( "!! „† Œ™ ‡……ƒŒ „™˜… …‰€ „† ™š™", {"..."} )
		 ELSE
                 Alert( "User is not allowed to report this stage", {"..."} )
		 ENDIF
       RETURN .F.
     ELSE
          lEndOfBatch := .T.
     ENDIF
ELSEIF o:varGet() = 194 .OR. o:varGet() = 194.5
		 IF !IfEnglish()
           Alert( "!! (194.5)-… (194) ‰Œ™ ‡……ƒŒ „™˜… …‰€ „† ™š™", {"..."} )
		 ELSE
                 Alert( "User is not allowed to report stages 194 or 194.5", {"..."} )
		 ENDIF
       RETURN .F.
ELSEIF o:varGet() = 197.3
		 IF !IfEnglish()
           Alert( "!! 197.3 ‰Œ™ ‡……ƒŒ „™˜… …‰€ „† ™š™", {"..."} )
		 ELSE
                 Alert( "User is not allowed to report stages 197.3", {"..."} )
		 ENDIF
       RETURN .F.
ELSE
     lEndOfBatch := .F.
ENDIF

IF (o:varGet() = 190 .OR. o:varGet() = 190.5) .AND. ;
		 d_line->value_id = 0.00                .AND. ;
		 d_line->ptype_id == "U"                .AND. ;
		 ! "DB" $ d_line->pline_id              .AND. ;
		 d_line->size_id $ "0805_0603_0402"
		 NetUse("c_pline",5)
		 ordsetfocus(1)
		 IF c_pline->(dbseek(d_line->pline_id+d_line->size_id))
			 HVal_DT := c_pline->HVal_DT
			 LVal_DT := c_pline->LVal_DT
			 lDT := TRUE
		 ENDIF
		 c_pline->(dbclosearea())
		 DbSelectArea(nOldArea)
ELSEIF (o:varGet() = 190 .OR. o:varGet() = 190.5 .OR. o:varGet() = 197.1 .OR. o:varGet() = 197.6) .AND. ;
		 d_line->value_id <> 0.00                   .AND. ;
		 d_line->ptype_id == "U"                    .AND. ;
		 ! "DB" $ d_line->pline_id                  .AND. ;
		 d_line->size_id $ "0805_0603_0402"
		 HVal_DT := d_line->value_id * 1.1
		 LVal_DT := d_line->value_id * 0.9
		 lDT := TRUE
ENDIF

lRetVal := ProcExists(o)

RETURN lRetVal

PROCEDURE PutF1OnScreen()
/*
  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³                 Œ™  „„  ƒ…‰’    … ‰ ‘   Œ’  ‡……‰ƒ                 ³
  ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
  ³                          310010  (…š‰ ‘‰ˆ˜‹ €–) „ ƒ…—-˜ ˜’„  .1³
  ³    xxxxxxxxxxx‰…Œ” ‰‰‡  xx211               ‡……ƒ ƒ…’ ƒ…—-˜ ˜’„  .2³
  ³              ‰…‘‰‹ š—ƒ„    250                    Š‰Œ„š ƒ…—-˜ ˜’„  .3³
  ³                             130          …š‰ Œ™ ˜”‘ ƒ…—-˜ ˜’„  .4³
  ³                                    …‰‘ š…‹„ Œ’ ‡……‰ƒŒ ƒ…—-˜ ˜’„  .5³
  ³                                :‰ƒ‰ƒ        :š…ˆ‚         :š…‘…˜”    ³
  ³                                                                  3      ³
  ³                                                  '˜…™‰€' ƒ…—-˜ ˜’„  .6³
  ³                    ** ˜…‡€Œ ƒ‡€ ƒ’– ˜…†‡Œ Œ‹…š „˜†‡ ƒ…—-˜ š˜’„ ‰"’ ** ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
  ³ 06031J2R4BBT020 :ESN   ZZ 6-01 :  š…”‰‡ƒ š˜  3 :ƒ…’‰  310010: „ '‘  ³
  ³                           SiO2 : ˜ˆ—Œ€‰ƒ ‚…‘            AF1  : ˜–… …—  ³
  ³                           2.40 :˜ˆ—Œ€‰ƒ ‰…’            0603 :    Œƒ…‚  ³
  ³                                                         2.40 :     Š˜’  ³
  ³                 W    S    P    : š‰‡‹… š…‹            B    :  š…–‰”€  ³
  ³                 3   145* 4,301*                         02   : ESN(XX)  ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

IF !ifEnglish()
   @ 2,2 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
   @ 3,2 SAY "³                 Œ™  „„  ƒ…‰’    … ‰ ‘   Œ’  ‡……‰ƒ                 ³"
	@ 4,2 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
	@ 5,2 SAY "³                                  (…š‰ ‘‰ˆ˜‹ €–) „ ƒ…—-˜ ˜’„  .1³"
	@ 6,2 SAY "³                                               ‡……ƒ ƒ…’ ƒ…—-˜ ˜’„  .2³"
	@ 7,2 SAY "³                                                    Š‰Œ„š ƒ…—-˜ ˜’„  .3³"
	@ 8,2 SAY "³                                          …š‰ Œ™ ˜”‘ ƒ…—-˜ ˜’„  .4³"
	@ 9,2 SAY "³                                    …‰‘ š…‹„ Œ’ ‡……‰ƒŒ ƒ…—-˜ ˜’„  .5³"
	@10,2 SAY [³                                :‰ƒ‰ƒ        :š…ˆ‚         :š…‘…˜”    ³]
	@11,2 SAY "³                                                                         ³"
	@12,2 SAY "³                                 „Œ‰‘” €ŒŒ „‰’ Œ’ ‡……‰ƒŒ ƒ…—-˜ ˜’„  .6³"
	@13,2 SAY [³                                                  '˜…™‰€' ƒ…—-˜ ˜’„  .7³]
	@14,2 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
ELSE
   @ 2,2 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
   @ 3,2 SAY "³                 Production Stage Completion Notificaton                 ³"
	@ 4,2 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
	@ 5,2 SAY "³1. Scan Batch No.Barcode                                                 ³"
	@ 6,2 SAY "³2. Scan Employee ID Barcode                                              ³"
	@ 7,2 SAY "³3. Scan Production Process Barcode                                       ³"
	@ 8,2 SAY "³4. Scan Production Stage Barcode                                         ³"
	@ 9,2 SAY "³5. Enter Quantities at process completion                                ³"
	@10,2 SAY [³                             Wafers              Strips          Pieces  ³]
	@11,2 SAY "³                                                                         ³"
	@12,2 SAY "³6. Scan to report problem without scrap                                  ³"
	@13,2 SAY [³7. Confirm                                                               ³]
	@14,2 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
ENDIF
RETURN

PROCEDURE PutS3OnScreen()
// New screen to input cancelation of closing batches: 196.0 back to start status
// As new spec:BMSBITUL.DOC               David Laor   17-08-97
IF !ifEnglish()
   @ 2,2 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
   @ 3,2 SAY "³                     „„ …‰‘   Œ … ˆ ‰    Œ’  ‡……‰ƒ                   ³"
   @ 4,2 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
   @ 5,2 SAY "³                                                           :„‘‰‘ ™—„  .1³"
   @ 6,2 SAY "³                                  (…š‰ ‘‰ˆ˜‹ €–) „ ƒ…—-˜ ˜’„  .2³"
   @ 7,2 SAY "³                                               ‡……ƒ ƒ…’ ƒ…—-˜ ˜’„  .3³"
   @ 8,2 SAY "³                                                                         ³"
   @ 9,2 SAY "³                                                                         ³"
   @10,2 SAY [³                                                                         ³]
   @11,2 SAY "³                                                                         ³"
   @12,2 SAY "³                                                  '˜…™‰€' ƒ…—-˜ ˜’„  .4³"
   @13,2 SAY [³                                                                         ³]
   @14,2 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
ELSE
   @ 2,2 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
   @ 3,2 SAY "³                     Cancel Completion Batch Report                      ³"
   @ 4,2 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
   @ 5,2 SAY "³1. Enter Password:                                                       ³"
   @ 6,2 SAY "³2. Scan Batch No. Barcode                                                ³"
   @ 7,2 SAY "³3. Scan Employee ID Barcode                                              ³"
   @ 8,2 SAY "³                                                                         ³"
   @ 9,2 SAY "³                                                                         ³"
   @10,2 SAY [³                                                                         ³]
   @11,2 SAY "³                                                                         ³"
   @12,2 SAY "³4. Confirm                                                               ³"
   @13,2 SAY [³                                                                         ³]
   @14,2 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
ENDIF

RETURN


Function barSetMoreGets

lGoodSw := .T.

IF lEndOfBatch
     IF LastKey() = K_UP
          RETURN TRUE
     ELSE
          barSelectEnd()
          DO CASE
               CASE cEndType == "E"              // escape
                    lGoodSw := .F.
               CASE cEndType == "Y"              // yizur
                    IF d_line->b_type $ "KB" .OR. d_line->b_purp $ "5_8_T_6"
                         IF !IfEnglish()
								 	  Alert( "‰‰—š ‰€ ˜…–‰‰ š ‰…š;B type:"+d_line->b_type +"    B purp:"+d_line->b_purp , {"Enter"} )
								 ELSE
									  Alert( "This batch is not a Production batch", {"Enter"} )
								 ENDIF
                         lGoodSw := .F.
                    ENDIF
               CASE cEndType == "A"              // ariza
                    IF !(d_line->b_purp $ "5_8_T_6" .AND. !(d_line->b_type $ "KB"))
								 IF !IfEnglish()
								     Alert( "‰‰—š ‰€ „†‰˜€ š ‰…š;B type:"+d_line->b_type +"    B purp:"+d_line->b_purp , {"Enter"} )
								 ELSE
									  Alert( "This batch is not a Packing batch", {"Enter"} )
								 ENDIF
								 lGoodSw := .F.
                    ENDIF
               CASE cEndType == "K"              // kit matchbooks
                    IF !(d_line->b_type $ "KB")
								 IF !IfEnglish()
								     Alert( "‰‰—š ‰€ ‰ˆ‰— š ‰…š;B type:"+d_line->b_type +"    B purp:"+d_line->b_purp , {"Enter"} )
								 ELSE
									  Alert( "This batch is not a Kit/Matchbook batch", {"Enter"} )
								 ENDIF
								 lGoodSw := .F.
                    ENDIF
          ENDCASE
          IF !lGoodSw
               RETURN TRUE
          ENDIF
     ENDIF
ENDIF

IF Len( GetList ) > 4
   RETURN TRUE
ENDIF

IF !IfEnglish()
   @ 11,69 GET nQtyW  PICTURE "@Z 999"      SEND preBlock := {|o| c_proc->must_w .AND. !lEndOfBatch};
           SEND postBlock := {|o| postWSP(o,"W")  }

   @ 11,51 GET nQtyS  PICTURE "@Z 99999"    SEND preBlock := {|o| c_proc->must_s .AND. !lEndOfBatch } ;
	        SEND postBlock := {|o| postWSP(o,"S") }

	@ 11,35 GET nQtyP  PICTURE "@Z 9999999"  SEND preBlock := {|o| NextScr2ForP(o) } ;
           SEND postBlock := {|o| postWSP(o,"P") }

	@ 12,34 GET mRej     PICTURE "Y" SEND postBlock := {|o| !mRej .OR. postRWR(o) }
	@ 13,34 GET mConfirm PICTURE "Y" SEND preBlock := {|o| Oper_Cancel(o) }

ELSE
   @ 11,32 GET nQtyW  PICTURE "@Z 999"      SEND preBlock := {|o| c_proc->must_w .AND. !lEndOfBatch};
           SEND postBlock := {|o| postWSP(o,"W")  }

   @ 11,51 GET nQtyS  PICTURE "@Z 99999"    SEND preBlock := {|o| c_proc->must_s .AND. !lEndOfBatch } ;
		     SEND postBlock := {|o| postWSP(o,"S") }

	@ 11,67 GET nQtyP  PICTURE "@Z 9999999"  SEND preBlock := {|o| NextScr2ForP(o) } ;
   		  SEND postBlock := {|o| postWSP(o,"P") }

   @ 12,43 GET mRej     PICTURE "Y" SEND postBlock := {|o| !mRej .OR. postRWR(o) }
	@ 13,14 GET mConfirm PICTURE "Y" SEND preBlock  := {|o| Oper_Cancel(o) }
ENDIF

RETURN TRUE


FUNCTION GoodEndCode
RETURN lGoodSw


STATIC PROCEDURE barSelectEnd
LOCAL cScreen := SaveScreen()
LOCAL nOption
Tone( 300 , 2 )

@ 4,15 CLEAR TO 8, 54
@ 4,15 TO 8, 54  DOUBLE

IF !IfEnglish()
   @ 5, 16 PROMPT [        ˜…–‰‰ š… …‰‘ ‡"…ƒ]
   @ 6, 16 PROMPT [        „†‰˜€ š… …‰‘ ‡"…ƒ]
   @ 7, 16 PROMPT [matchbook/ˆ‰— š… …‰‘ ‡"…ƒ]
ELSE
   @ 5, 16 PROMPT [Production Batch Completion Report   ]
   @ 6, 16 PROMPT [Packing Batch Completion Report      ]
   @ 7, 16 PROMPT [Kit/Matchbook Batch Completion Report]
ENDIF

MENU TO nOption

DO CASE
     CASE nOption = 0
          cEndType := "E"                        // escaped
     CASE nOption = 1
          cEndType := "Y"                        // yizur
     CASE nOption = 2
          cEndType := "A"                        // ariza
     CASE nOption = 3
          cEndType := "K"                        // kit match book
ENDCASE

RestScreen( ,,,, cScreen )
RETURN

STATIC Function GetQtyCode()

Return IIF(c_proc->scr2 == "F3" ,"W",IIF(c_proc->scr2 == "F4" ,"S","P"))

STATIC FUNCTION postRWR(o)

Local aReg := aRegularRej
Local i

aRegularRej := {}
GetScr2_F3F4F5(GetQtyCode(),,,.T.)

IF LastKey() == K_F5
   FOR i := 1 TO Len(aRegularRej)
	    aadd(aReg,aRegularRej[i])
   NEXT
ELSE
	o:VarPut(.N.)
ENDIF

aRegularRej := aReg

RETURN LastKey() == K_F5

STATIC FUNCTION postWSP(o, cCode )
LOCAL lRetVal

IF LastKey() = K_UP
   RETURN .T.
ENDIF

IF Negative( o )
   RETURN .F.
ENDIF

lRetVal := CheckQtys( o:varGet(),cCode )         // new qty in  get object

IF lRetVal
     IF lRejFlag
          aRegularRej := {}
          GetScr2_F3F4F5( cCode )
          lRetVal := (LastKey() = K_F5)
     ENDIF
ELSEIF !ifEnglish()
     Alert( [!‡……ƒ„ š€ —šŒ …€ ‰"”šŒ š…”Œ € ,˜š…„ š‚˜…‡ …‰‘ š…‹], {"..."} )
ELSE
     Alert( [Final quantity incorrect. Please correct or contact production control!], {"..."} )
ENDIF

RETURN lRetVal


STATIC FUNCTION NextScr2ForP(o)
LOCAL aGetList := GetList                        // save the public get list for nested red
LOCAL cScreen := SaveScreen()
LOCAL lRetVal

IF lEndOfBatch
RETURN .F.
ENDIF

IF !c_proc->must_p
RETURN .F.
ENDIF

IF LastKey() = K_UP
RETURN .T.
ENDIF

IF c_proc->scr2 $ "F6_F7_F8"
     GetList := {}                               // prepare getlist for nest read
     lRetVal := .F.
     DO CASE
          CASE c_proc->scr2 == "F6"
               GetScr2_F6(o)
          CASE c_proc->scr2 == "F7"
               GetScr2_F7(o)
          CASE c_proc->scr2 == "F8"
               GetScr2_F8(o)
          OTHERWISE
               lRetVal := .T.
     ENDCASE
     GetList := aGetList                         // restore upper lever read
ELSEIF c_proc->scr2 $ "F3_F4_F5"
     lRetVal := .T.
ELSE
     Alert( "Bad Screen in scr2 " + c_proc->scr2 + " call MIS department NOW!!",{"..."})
	  lRetVal := .F.
ENDIF

RestScreen( ,,,, cScreen )
o:display()
RETURN lRetVal




STATIC PROCEDURE GetScr2_F7(o)
ScrF7On()

nGoodPacked := nGoodLoose := nValueR := 0
cCode1Rej   := "    "
cDoch1Eatama  := "      "
cNote1        := Space(14)


IF !IfEnglish()
   @ 14,34 GET nGoodPacked   PICT '999999' SEND postBlock := {|o| !Negative(o) }
   @ 14,41 GET nGoodLoose    PICT '999999' SEND postBlock := {|o| CheckF7Range(o) }
   @ 19,63 GET nValueR       PICT '999999' SEND preBlock  := {|o| preRejected(o, nGoodPacked,nGoodLoose) } ;
                                           SEND postBlock := {|o| postRejected(o,.T.) }

   @ 19,49  GET cCode1Rej    SEND preBlock  := {|o| preRej(o) .AND. ChkRej(nValueR)} ;
                             SEND postBlock := {|o| postRej(o,,nValueR)}

   @ 19,20  GET cDoch1Eatama SEND preBlock  := {|o| ChkRej(nValueR)} ;
                          VALID IF( nValueR=0, .T. ,IF( cDoch1Eatama<>"      ", .T. , .F. ) )
   @ 19,2   GET cNote1       SEND preBlock  := {|o| ChkRej(nValueR)} ;
                             SEND reader := {|o| HebReader(o) }
ELSE

	@ 14,34 GET nGoodPacked   PICT '999999' SEND postBlock := {|o| !Negative(o) }

	@ 14,41 GET nGoodLoose    PICT '999999' SEND postBlock := {|o| CheckF7Range(o) }

	@ 19,09 GET nValueR       PICT '999999' SEND preBlock  := {|o| preRejected(o, nGoodPacked,nGoodLoose) } ;
                                           SEND postBlock := {|o| postRejected(o,.T.) }

   @ 18,29  GET cCode1Rej    SEND preBlock  := {|o| preRej(o) .AND. ChkRej(nValueR)} ;
                             SEND postBlock := {|o| postRej(o,,nValueR,.T.)}

   @ 20,43  GET cDoch1Eatama SEND preBlock  := {|o| ChkRej(nValueR)} ;
                          VALID IF( nValueR=0, .T. ,IF( cDoch1Eatama<>"      ", .T. , .F. ) )
   @ 21,36  GET cNote1       SEND preBlock  := {|o| ChkRej(nValueR)}
ENDIF

READ

IF ASCAN( aGoodKeys, LASTKEY() ) > 0
     o:varPut( nGoodPacked + nGoodLoose )
ENDIF

RETURN


STATIC PROCEDURE GetScr2_F8(o)
ScrF8On()

nRange1 :=;
nRange2 :=;
nRange3 :=;
nRange4 :=;
nRange5 :=;
nRange6 :=;
nRange7 :=;
nRange8 :=;
nRange9 :=;
nRange10:= 0

cCode1Rej    := cCode2Rej     := "    "
cDoch1Eatama := cDoch2Eatama  := "      "
cNote1       := cNote2        := Space(14)

@ 14,07 GET nRange1  PICT '999999' SEND postBlock := {|o| !Negative(o) }
@ 14,14 GET nRange2  PICT '999999' SEND postBlock := {|o| !Negative(o) }
@ 14,21 GET nRange3  PICT '999999' SEND postBlock := {|o| !Negative(o) }
@ 14,28 GET nRange4  PICT '999999' SEND postBlock := {|o| !Negative(o) }
@ 14,35 GET nRange5  PICT '999999' SEND postBlock := {|o| !Negative(o) }
@ 14,42 GET nRange6  PICT '999999' SEND postBlock := {|o| !Negative(o) }
@ 14,49 GET nRange7  PICT '999999' SEND postBlock := {|o| !Negative(o) }
@ 14,56 GET nRange8  PICT '999999' SEND postBlock := {|o| !Negative(o) }
@ 14,63 GET nRange9  PICT '999999' SEND postBlock := {|o| CheckF8Range(o) }

IF !IfEnglish()
   @ 18,63 GET nRange10 PICT '999999' SEND preBlock  := {|o| preRejected(o) } ;
                                      SEND postBlock := {|o| postRejected(o) }
   @ 18,49 GET cCode2Rej              SEND preBlock  := {|o| preRej(o) .AND. ChkRej(nRange10)} ;
                                      SEND postBlock := {|o| postRej(o,,nRange10)}
   @ 18,20 GET cDoch2Eatama           SEND preBlock  := {|o| ChkRej(nRange10)} ;
                                      VALID IF( nRange10=0, .T. ,IF( cDoch2Eatama<>"      ", .T. , .F. ) )
   @ 18,02 GET cNote2                 SEND preBlock  := {|o| ChkRej(nRange10)} ;
                                      SEND reader    := {|o| HebReader(o) } VALID IF( nRange10=0, .T. ,IF( cNote2<>space(14), .T. , .F. ) )
ELSE
   @ 18,09 GET nRange10 PICT '999999' SEND preBlock  := {|o| preRejected(o) } ;
                                      SEND postBlock := {|o| postRejected(o) }
   @ 17,29 GET cCode2Rej              SEND preBlock  := {|o| preRej(o) .AND. ChkRej(nRange10)} ;
                                      SEND postBlock := {|o| postRej(o,,nRange10,.T.)}
   @ 19,43 GET cDoch2Eatama           SEND preBlock  := {|o| ChkRej(nRange10)} ;
                                      VALID IF( nRange10=0, .T. ,IF( cDoch2Eatama<>"      ", .T. , .F. ) )
   @ 20,36 GET cNote2                 SEND preBlock  := {|o| ChkRej(nRange10)} ;
                                      VALID IF( nRange10=0, .T. ,IF( cNote2<>space(14), .T. , .F. ) )
ENDIF

READ

IF ASCAN( aGoodKeys, LASTKEY() ) > 0
     o:varPut( nRange1+nRange2+nRange3+nRange4+nRange5+nRange6+nRange7+nRange8+nRange9 )
ENDIF

RETURN

STATIC PROCEDURE GetScr2_F6(o)
LOCAL nPos,i // Space between get fields on screen + 2
LOCAL aTemp := {}
ScrF6On()
// INIT VARS

aRegularRej := {}
aRejInfo := {}

nTolPP := nTolQP := nTolAP := nTolBP := nTolCP := nTolDP :=  ;
nTolFP := nTolGP := nTolJP := nTolZP := nTolXP :=            ;
nTolPL := nTolQL := nTolAL := nTolBL := nTolCL := nTolDL :=  ;
nTolFL := nTolGL := nTolJL := nTolZL := nTolXL :=            ;
nTolRL := nScrap_Q := nScrap_Flash := nScrap_Res := nScrap_NoDescr := 0


While 1>0
	IF Len(aRejInfo) < 5
		AADD(aRejInfo,{"    ","      ",Space(14)})
	ELSE
		EXIT
	ENDIF
End

NetUse("c_f6scr2",5)
c_f6scr2->(ordsetfocus("if6scr2"))
c_f6scr2->(dbseek(d_line->cpproc_id + d_line->ptype_id))


IF !c_f6scr2->(found())
   IIF(!ifEnglish() ,ALERT(".‡……‰ƒ ƒ—š„Œ š‰ €Œ;!MIS - Œ €˜—" , " OK "),;
						   ALERT("Can not proceed with report.;Call to MIS!", " OK "))
   c_f6scr2->(dbclosearea())
	KEYBOARD CHR(K_ESC)
	Return
ENDIF

@ 14,nPos:=2 GET nTolZP  PICT '999999' SEND preBlock  := {|o| GenPreBlock(o)} SEND postBlock := {|o| !Negative(o) }
@ 14,nPos+=7 GET nTolXP  PICT '999999' SEND preBlock  := {|o| GenPreBlock(o)} SEND postBlock := {|o| !Negative(o) }
@ 14,nPos+=7 GET nTolPP  PICT '999999' SEND preBlock  := {|o| GenPreBlock(o)} SEND postBlock := {|o| !Negative(o) }
@ 14,nPos+=7 GET nTolQP  PICT '999999' SEND preBlock  := {|o| GenPreBlock(o)} SEND postBlock := {|o| !Negative(o) }
@ 14,nPos+=7 GET nTolAP  PICT '999999' SEND preBlock  := {|o| GenPreBlock(o)} SEND postBlock := {|o| !Negative(o) }
@ 14,nPos+=7 GET nTolBP  PICT '999999' SEND preBlock  := {|o| GenPreBlock(o)} SEND postBlock := {|o| !Negative(o) }
@ 14,nPos+=7 GET nTolCP  PICT '999999' SEND preBlock  := {|o| GenPreBlock(o)} SEND postBlock := {|o| !Negative(o) }
@ 14,nPos+=7 GET nTolDP  PICT '999999' SEND preBlock  := {|o| GenPreBlock(o)} SEND postBlock := {|o| !Negative(o) }
@ 14,nPos+=7 GET nTolFP  PICT '999999' SEND preBlock  := {|o| GenPreBlock(o)} SEND postBlock := {|o| !Negative(o) }
@ 14,nPos+=7 GET nTolGP  PICT '999999' SEND preBlock  := {|o| GenPreBlock(o)} SEND postBlock := {|o| !Negative(o) }
@ 14,nPos+=7 GET nTolJP  PICT '999999' SEND preBlock  := {|o| GenPreBlock(o)} SEND postBlock := {|o| !Negative(o) }
@ 16,nPos:=2 GET nTolZL  PICT '999999' SEND preBlock  := {|o| GenPreBlock(o)} SEND postBlock := {|o| !Negative(o) }
@ 16,nPos+=7 GET nTolXL  PICT '999999' SEND preBlock  := {|o| GenPreBlock(o)} SEND postBlock := {|o| !Negative(o) }
@ 16,nPos+=7 GET nTolPL  PICT '999999' SEND preBlock  := {|o| GenPreBlock(o)} SEND postBlock := {|o| !Negative(o) }
@ 16,nPos+=7 GET nTolQL  PICT '999999' SEND preBlock  := {|o| GenPreBlock(o)} SEND postBlock := {|o| !Negative(o) }
@ 16,nPos+=7 GET nTolAL  PICT '999999' SEND preBlock  := {|o| GenPreBlock(o)} SEND postBlock := {|o| !Negative(o) }
@ 16,nPos+=7 GET nTolBL  PICT '999999' SEND preBlock  := {|o| GenPreBlock(o)} SEND postBlock := {|o| !Negative(o) }
@ 16,nPos+=7 GET nTolCL  PICT '999999' SEND preBlock  := {|o| GenPreBlock(o)} SEND postBlock := {|o| !Negative(o) }
@ 16,nPos+=7 GET nTolDL  PICT '999999' SEND preBlock  := {|o| GenPreBlock(o)} SEND postBlock := {|o| !Negative(o) }
@ 16,nPos+=7 GET nTolFL  PICT '999999' SEND preBlock  := {|o| GenPreBlock(o)} SEND postBlock := {|o| !Negative(o) }
@ 16,nPos+=7 GET nTolGL  PICT '999999' SEND preBlock  := {|o| GenPreBlock(o)} SEND postBlock := {|o| !Negative(o) }
@ 16,nPos+=7 GET nTolJL  PICT '999999' SEND preBlock  := {|o| GenPreBlock(o)} SEND postBlock := {|o| !Negative(o) }


IF !IfEnglish()
   @ 21,62      GET nTolRL         PICT '999999' SEND preBlock  := {|o| GenPreBlock(o) } ;
	                                              SEND postBlock := {|o| CheckF6Range(o) .AND. postRejected(o,,.T.) .AND. GetScrapCode(o,1) }

   @ 21,55      GET nScrap_Q       PICT '999999' SEND preBlock  := {|o| d_line->ptype_id $ "U_C" .AND. GenPreBlock(o) .AND. GenPreBlock(o) } ;
                                                 SEND postBlock := {|o| CheckF6Range(o) .AND. postRejected(o,,.T.) .AND. GetScrapCode(o,2) }

	@ 21,48      GET nScrap_Flash   PICT '999999' SEND preBlock  := {|o| GenPreBlock(o) } ;
                                                 SEND postBlock := {|o| CheckF6Range(o) .AND. postRejected(o,,.T.) .AND. GetScrapCode(o,3) }

   @ 21,41      GET nScrap_Res     PICT '999999' SEND preBlock  := {|o| GenPreBlock(o) } ;
                                                 SEND postBlock := {|o| CheckF6Range(o) .AND. postRejected(o,,.T.) .AND. GetScrapCode(o,4) }
	@ 23,48      GET nScrap_NoDescr PICT '999999' SEND preBlock  := {|o| preRejected(o,,,.T.) } ;
                                                 SEND postBlock := {|o| GetScrapCode(o,5)}
ELSE
   @ 21,05       GET nTolRL         PICT '999999' SEND preBlock  := {|o| GenPreBlock(o) } ;
	                                               SEND postBlock := {|o| CheckF6Range(o) .AND. postRejected(o,,.T.) .AND. GetScrapCode(o,1) }

   @ 21,12       GET nScrap_Q       PICT '999999' SEND preBlock  := {|o| d_line->ptype_id $ "U_C" .AND. GenPreBlock(o) } ;
                                                  SEND postBlock := {|o| CheckF6Range(o) .AND. postRejected(o,,.T.) .AND. GetScrapCode(o,2) }

	@ 21,19       GET nScrap_Flash   PICT '999999' SEND preBlock  := {|o| GenPreBlock(o) } ;
                                                  SEND postBlock := {|o| CheckF6Range(o) .AND. postRejected(o,,.T.) .AND. GetScrapCode(o,3) }

   @ 21,26       GET nScrap_Res     PICT '999999' SEND preBlock  := {|o| GenPreBlock(o) } ;
                                                  SEND postBlock := {|o| CheckF6Range(o) .AND. postRejected(o,,.T.) .AND. GetScrapCode(o,4) }
	@ 23,19       GET nScrap_NoDescr PICT '999999' SEND preBlock  := {|o| preRejected(o,,,.T.) } ;
                                                  SEND postBlock := {|o| GetScrapCode(o,5)}//CheckF6Range(o)}
ENDIF

READ


IF ASCAN( aGoodKeys, LASTKEY() ) > 0
     o:varPut( nTolPL+nTolQL+nTolAL+nTolBL+nTolCL+nTolDL+nTolFL+nTolGL+nTolJL+nTolZL+nTolXL+;
               nTolPP+nTolQP+nTolAP+nTolBP+nTolCP+nTolDP+nTolFP+nTolGP+nTolJP+nTolZP+nTolXP)
ENDIF

if LastKey() <> K_ESC
	IF Len(aRegularRej) <> 0
		FOR  i:= 1 TO Len(aRegularRej)
			IF !Empty(aRegularRej[i])
				aadd(aTemp,aRegularRej[i])
			ENDIF
		NEXT
		aRegularRej := aTemp
	ENDIF
	//IF aScan(aRegularRej,{|aVal| !Empty(aVal) .AND. aVal[6] == GetScrapName(5)}) == 0
	//	aadd(aRegularRej,{ "š‰ˆ…ˆ…€ „Œ‰‘”","",,"M999",CheckF6Range(,.T.),"99" })
	//ENDIF
   GetScr2_F3F4F5( "P",.T.,o)
endif

c_f6scr2->(dbclosearea())

RETURN


Static Function GenPreBlock(o)

local nOldArea := Select()
local lRetVal := TRUE
Local cVarName := o:Name


c_f6scr2->(ordsetfocus("if6scr2"))
c_f6scr2->(dbseek(d_line->cpproc_id + d_line->ptype_id))

do case
	case cVarName $ "_nTolPP_"
		  lRetVal := c_f6scr2->p_packed .AND. !d_line->tol_id $ "_F_G_J_H"
	case cVarName $ "nTolQP_nTolAP_nTolBP_nTolCP_nTolDP_nTolZP_nTolXP_"
		  lRetVal := c_f6scr2->packed .AND. !d_line->tol_id $ "_F_G_J_H"
	case cVarName $ "_nTolFP_nTolGP_nTolJP_"
		  lRetVal := c_f6scr2->packed .AND. d_line->tol_id $ "_F_G_J_H"
	case cVarName $ "_nTolPL_"
		  lRetVal := c_f6scr2->p_loose .AND. !d_line->tol_id $ "_F_G_J_H"
	case cVarName $ "nTolQL_nTolAL_nTolBL_nTolCL_nTolDL_nTolZL_nTolXL"
		  lRetVal := c_f6scr2->loose .AND. !d_line->tol_id $ "_F_G_J_H"
	case cVarName $ "_nTolFL_nTolGL_nTolJL_"
		  lRetVal := c_f6scr2->loose .AND. d_line->tol_id $ "_F_G_J_H"
	case cVarName $ "_nTolRL_"// .AND. (c_f6scr2->r_tol .OR. c_f6scr2->flash .OR. c_f6scr2->Q_OR_COUPL .OR. c_f6scr2->Resis)
		  lRetVal := c_f6scr2->r_tol
	case cVarName $ "_nScrap_Flash_"
		  lRetVal := c_f6scr2->flash
	case cVarName $ "_nScrap_Q_"
		  lRetVal := c_f6scr2->Q_OR_COUPL
	case cVarName $ "_nScrap_Res_"
		  lRetVal := c_f6scr2->Resis
endcase


dbselectarea(nOldArea)
Return lRetVal

Function GetScrapName(nIndex)
local cRetVal
IF nIndex == 1
	cRetVal := "RL"
ELSEIF nIndex == 2
   cRetVal := "QR"
ELSEIF nIndex == 3
   cRetVal := "FL"
ELSEIF nIndex == 4
   cRetVal := "RR"
ELSEIF nIndex == 5
   cRetVal := "99"
ENDIF
Return cRetVal


STATIC PROCEDURE ScrF6On

IF !IfEnglish()
   @ 0 ,0 SAY  "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
   @ 1 ,0 SAY  "³                       „†‰˜€… …‰    … ‰ ‘   ‡……‰ƒ                         ³"
   @ 2 ,0 SAY  "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
   @ 3 ,0 SAY  "³     „Œ‰‘”„ š‰‘Œ “‘… ˜…€š “‘…„ (ƒ)            šŒ‘”„ š…‹„ Œ’ ‡……ƒ  (€)     ³"
   @ 4 ,0 SAY  "³                   ‡……‰ƒ„ š€ ˜™€ („)         „Œ‰‘”„ š‰‘ ƒ…— Œ’ ‡……ƒ  ()     ³"
   @ 5 ,0 SAY  [³                                           „€š„-‰€ ‡"…ƒ '‘ Œ’ ‡……ƒ  (‚)     ³]
   @ 6 ,0 SAY  "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
   @ 7 ,0 SAY  "³                   :ESN           :  š…”‰‡ƒ š˜    :ƒ…’‰        : „ '‘     ³"
   @ 8 ,0 SAY  "³          :…š‰ ƒ…—       :Œ™„ '‘                               :Š‰Œ„š     ³"
   @ 9 ,0 SAY  "³                   ‰‰‹˜         š…ˆ‚       š…‘…˜”    :Œ™Œ „‘‰‹ š…‹     ³"
   @ 10,0 SAY  "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
   @ 11,0 SAY  "³ÚÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄ¿³"
   @ 12,0 SAY  "³³  Z   ³  X   ³  P   ³  Q   ³  A   ³  B   ³  C   ³  D   ³  F   ³  G   ³  J   ³³"
   @ 13,0 SAY  "³ÆÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØ¾"
   @ 14,0 SAY  "³³      ³      ³      ³      ³      ³      ³      ³      ³      ³      ³      »"
   @ 15,0 SAY  "³ÆÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍµº"
   @ 16,0 SAY  [³³      ³      ³      ³      ³      ³      ³      ³      ³      ³      ³      ³º]
   @ 17,0 SAY  "³ÀÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÙº"
   @ 18,0 SAY  "³                                       ÚÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄ¿   º      º"
   @ 19,0 SAY  [³                                       ³'‚š„ ³ Flash³Q/Coup³R 'Œ…ˆ³   º †…˜€Æ¼]
   @ 20,0 SAY  "³                                       ÆÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍµ   º      ³"
   @ 21,0 SAY  "³                                       ³      ³      ³      ³      ³  ƒ‰ƒ    ³"
   @ 22,0 SAY  "³                                       ÀÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÁÄÄÄÄÄÄÙ          ³"
   @ 23,0 SAY  "³                                              ³      ³:˜‘… €Œ ˜’”           ³"
	@ 24,0 SAY  "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
ELSE
   @ 0 ,0 SAY  "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
   @ 1 ,0 SAY  "³         Completion of Sorting and Packing Stages Notifications               ³"
   @ 2 ,0 SAY  "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
   @ 3 ,0 SAY  "³  a. Enter Scrap Quantity          d. Additional Description for Scrap Cause  ³"
   @ 4 ,0 SAY  "³  b. Enter Scrap Cause Code        e. Confirm                                 ³"
   @ 5 ,0 SAY  [³  c. Enter Non Conformity report                                              ³]
   @ 6 ,0 SAY  "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
   @ 7 ,0 SAY  "³  Batch No.:          Purpose:     Priority:           ESN:                   ³"
   @ 8 ,0 SAY  "³  Process  :                             Stage No.:        Route Code:        ³"
   @ 9 ,0 SAY  "³  Quantity Before Scraping            Wafers          Strips           Pieces ³"
   @ 10,0 SAY  "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
   @ 11,0 SAY  "³ÚÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄ¿³"
   @ 12,0 SAY  "³³  Z   ³  X   ³  P   ³  Q   ³  A   ³  B   ³  C   ³  D   ³  F   ³  G   ³  J   ³³"
   @ 13,0 SAY  "³ÆÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØ¾"
   @ 14,0 SAY  "³³      ³      ³      ³      ³      ³      ³      ³      ³      ³      ³      »"
   @ 15,0 SAY  "³ÆÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍµº"
   @ 16,0 SAY  [³³      ³      ³      ³      ³      ³      ³      ³      ³      ³      ³      ³º]
   @ 17,0 SAY  "³ÀÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÙº"
   @ 18,0 SAY  "³   ÚÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄ¿                                     º        º"
   @ 19,0 SAY  [³   ³ R Tol³Q/Coup³ Flash³Resis.³                                     º PackedÆ¼]
   @ 20,0 SAY  "³   ÆÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍµ                                     º        ³"
   @ 21,0 SAY  "³   ³      ³      ³      ³      ³                                      Loose   ³"
   @ 22,0 SAY  "³   ÀÄÄÄÄÄÄÁÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÙ                                              ³"
   @ 23,0 SAY  "³ Unaccounted Qty:³      ³                                                     ³"
	@ 24,0 SAY  "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
ENDIF

ShowSpec()

RETURN

Static Function GetScrapCode(oScrap,nIndex)

LOCAL cScr := SAVESCREEN()
LOCAL cOldList := GetList
LOCAL nScan
LOCAL cRetVal := TRUE
LOCAL cDescripton := ""

GetList := {}

IF LastKey() = K_UP
   RETURN .T.
ENDIF

aRejInfo[nIndex] := {"    ","      ",Space(14)}

IF UPPER(oScrap:Name) == "NSCRAP_NODESCR" .AND. oScrap:Changed
     Alert("Changing Quantity is not allowed!",{"OK"})
	oScrap:VarPut(oScrap:Original)
ENDIF


IF !IfEnglish()
   @18,01 CLEAR TO 22, 77
   DrawBox( 18,1,22,77,FRAMECAPTION)

   @ 19,2 SAY  "         “‘… ˜…€š  ‡'…ƒ '‘                „Œ‰‘” š‰‘…            ƒ…—"
   @ 20,2 SAY  "                    „€š„-‰€"
   @ 21,68     GET aRejInfo[nIndex,1]    SEND preBlock  := {|o| preRej(o) .AND. ChkRej(oScrap:VarGet(),nIndex)} ;
                                         SEND postBlock := {|o| postRej(o,@cDescripton,oScrap:VarGet(),.T.)}

   @ 21,23     GET aRejInfo[nIndex,2]    SEND preBlock  := {|o| ChkRej(oScrap:VarGet(),nIndex)} ;
                                         VALID IF( oScrap:VarGet()=0, .T. ,IF( aRejInfo[nIndex,2]<>"      ", .T. , .F. ) )

   @ 21,5      GET aRejInfo[nIndex,3]    SEND preBlock  := {|o| ChkRej(oScrap:VarGet(),nIndex)} ;
                                         SEND reader := {|o| HebReader(o) }
ELSE
   @18,35 CLEAR TO 23, 75
   DrawBox( 18,35,23,75,FRAMECAPTION)

   @ 19,37 SAY "Scrap Code"
   @ 20,37 SAY "Desc."
   @ 21,37 SAY "Non Conformity report No"
   @ 22,37 SAY "Additional Descrip."

	@ 19,51     GET aRejInfo[nIndex,1]  SEND preBlock  := {|o| preRej(o) .AND. ChkRej(oScrap:VarGet(),nIndex)} ;
                                       SEND postBlock := {|o| postRej(o,@cDescripton,oScrap:VarGet(),.T.)}

   @ 21,67     GET aRejInfo[nIndex,2]  SEND preBlock  := {|o| ChkRej(oScrap:VarGet(),nIndex)} ;
                                       VALID IF( oScrap:VarGet()=0, .T. ,IF( aRejInfo[nIndex,2]<>"      ", .T. , .F. ) )

   @ 22,60     GET aRejInfo[nIndex,3]  SEND preBlock  := {|o| ChkRej(oScrap:VarGet(),nIndex)}
ENDIF

READ

nScan := aScan(aRegularRej,{|aVal| !Empty(aVal) .AND. aVal[6] == GetScrapName(nIndex)})

IF (nScan == 0 .AND. oScrap:VarGet() <> 0 .AND. nIndex <> 5) .OR. ;
   (nScan == 0 .AND. oScrap:VarGet() <> 0 .AND. nIndex == 5 .AND. !Empty(aRejInfo[nIndex,1]))
   Aadd( aRegularRej , { aRejInfo[nIndex,3],aRejInfo[nIndex,2],cDescripton,aRejInfo[nIndex,1],oScrap:VarGet(),GetScrapName(nIndex),.F. } )
ELSEIF nScan == 0 .AND. oScrap:VarGet() <> 0 .AND. nIndex == 5 .AND. Empty(aRejInfo[nIndex,1])
	Aadd(aRegularRej,{ "š‰ˆ…ˆ…€ „Œ‰‘”","",,"M999",oScrap:VarGet(),"99",.F. })
ELSEIF (nScan <> 0 .AND. oScrap:VarGet() <> 0 .AND. nIndex <> 5) .OR. ;
		 (nScan <> 0 .AND. oScrap:VarGet() <> 0 .AND. nIndex == 5 .AND. !Empty(aRejInfo[nIndex,1]))
   aRegularRej[nScan] := { aRejInfo[nIndex,3],aRejInfo[nIndex,2],cDescripton,aRejInfo[nIndex,1],oScrap:VarGet(),GetScrapName(nIndex),.F. }
ELSEIF nScan <> 0 .AND. oScrap:VarGet() <> 0 .AND. nIndex == 5 .AND. Empty(aRejInfo[nIndex,1])
	aRegularRej[nScan] := { "š‰ˆ…ˆ…€ „Œ‰‘”","",,"M999",oScrap:VarGet(),"99",.F. }
ELSEIF nScan <> 0  .AND. oScrap:VarGet() == 0
	ADEL(aRegularRej,nScan)
ENDIF


RESTSCREEN(,,,,cScr)

GetList := cOldList

IF LastKey() == K_ESC
   cRetVal := FALSE
ENDIF

Return cRetVal

STATIC PROCEDURE ScrF7On

IF !IfEnglish()
   @ 0 ,0 SAY  "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
   @ 1 ,0 SAY  "³                              „†‰˜€    … ‰ ‘   ‡……‰ƒ                        ³"
   @ 2 ,0 SAY  "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
   @ 3 ,0 SAY  "³      „Œ‰‘”„ š‰‘Œ “‘… ˜…€š “‘…„ (ƒ)            ‰‰‹˜„ š…‹ Œ’ ‡……ƒ  (€)    ³"
   @ 4 ,0 SAY  "³                    ‡……‰ƒ„ š€ ˜™€ („)         „Œ‰‘”„ š‰‘ ƒ…— Œ’ ‡……ƒ  ()    ³"
   @ 5 ,0 SAY  [³                                            „€š„-‰€ ‡"…ƒ '‘ Œ’ ‡……ƒ  (‚)    ³]
   @ 6 ,0 SAY  "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
   @ 7 ,0 SAY  "³                    :ESN           :  š…”‰‡ƒ š˜    :ƒ…’‰        : „ '‘    ³"
   @ 8 ,0 SAY  "³           :…š‰ ƒ…—       :Œ™„ '‘                               :Š‰Œ„š    ³"
   @ 9 ,0 SAY  "³                    ‰‰‹˜         š…ˆ‚       š…‘…˜”    :Œ™Œ „‘‰‹ š…‹    ³"
   @ 10,0 SAY  "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
   @ 11,0 SAY  "³                                ÚÄÄÄÄÄÄÂÄÄÄÄÄÄ¿                               ³"
   @ 12,0 SAY  "³                                ³ †…˜€ ³ ƒ‰ƒ ³                               ³"
   @ 13,0 SAY  "³                                ÆÍÍÍÍÍÍØÍÍÍÍÍÍµ                               ³"
   @ 14,0 SAY  [³                                ³      ³      ³ ‰‰—š ‰‰‹˜ ‹"„‘            ³]
   @ 15,0 SAY  "³                                ÀÄÄÄÄÄÄÁÄÄÄÄÄÄÙ                               ³"
   @ 16,0 SAY  "³                                                                              ³"
   @ 17,0 SAY  [³       “‘… ˜…€š  ‡"…ƒ '‘          „Œ‰‘” š‰‘…  ƒ…—                          ³]
   @ 18,0 SAY  "³                  „€š„-‰€                                   ÚÄÄÄÄÄÄ¿         ³"
   @ 19,0 SAY  "³                                                             ³      ³ ‡……ˆ    ³"
   @ 20,0 SAY  "³                                                             ÀÄÄÄÄÄÄÙ         ³"
   @ 21,0 SAY  "³                                                                              ³"
   @ 22,0 SAY  "³                                                                              ³"
   @ 23,0 SAY  "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
ELSE
   @ 0 ,0 SAY  "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
   @ 1 ,0 SAY  "³                          Completion Packing Stages Notifications             ³"
   @ 2 ,0 SAY  "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
   @ 3 ,0 SAY  "³  a. Enter Scrap Quantity          d. Additional Description for Scrap Cause  ³"
   @ 4 ,0 SAY  "³  b. Enter Scrap Cause Code        e. Confirm                                 ³"
   @ 5 ,0 SAY  [³  c. Enter Non Conformity report                                              ³]
   @ 6 ,0 SAY  "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
   @ 7 ,0 SAY  "³  Batch No.:          Purpose:     Priority:           ESN:                   ³"
   @ 8 ,0 SAY  "³  Process  :                             Stage No.:        Route Code:        ³"
   @ 9 ,0 SAY  "³  Quantity Before Scraping            Wafers          Strips           Pieces ³"
   @ 10,0 SAY  "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
   @ 11,0 SAY  "³                                ÚÄÄÄÄÄÄÂÄÄÄÄÄÄ¿                               ³"
   @ 12,0 SAY  "³                                ³Packed³Loose ³                               ³"
   @ 13,0 SAY  "³                                ÆÍÍÍÍÍÍØÍÍÍÍÍÍµ                               ³"
   @ 14,0 SAY  [³       No. of good component    ³      ³      ³                               ³]
   @ 15,0 SAY  "³                                ÀÄÄÄÄÄÄÁÄÄÄÄÄÄÙ                               ³"
   @ 16,0 SAY  "³                                                                              ³"
   @ 17,0 SAY  [³                                                                              ³]
   @ 18,0 SAY  "³       ÚÄÄÄÄÄÄ¿  Scrap Code                                                   ³"
   @ 19,0 SAY  "³ Range ³      ³  Desc.                                                        ³"
   @ 20,0 SAY  "³       ÀÄÄÄÄÄÄÙ  Non Conformity report No                                     ³"
   @ 21,0 SAY  "³                 Additional Descr.                                            ³"
   @ 22,0 SAY  "³                                                                              ³"
   @ 23,0 SAY  "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
ENDIF
ShowSpec()
RETURN

STATIC PROCEDURE ScrF8On

IF !IfEnglish()
   @ 0 ,0 SAY  "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
   @ 1 ,0 SAY  "³                       (‰‹‰š)  …‰    … ‰ ‘   ‡……‰ƒ                      ³"
   @ 2 ,0 SAY  "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
   @ 3 ,0 SAY  "³      „Œ‰‘”„ š‰‘Œ “‘… ˜…€š “‘…„ (ƒ)            ‰‰‹˜„ š…‹ Œ’ ‡……ƒ  (€)    ³"
   @ 4 ,0 SAY  "³                    ‡……‰ƒ„ š€ ˜™€ („)         „Œ‰‘”„ š‰‘ ƒ…— Œ’ ‡……ƒ  ()    ³"
   @ 5 ,0 SAY  [³                                            „€š„-‰€ ‡"…ƒ '‘ Œ’ ‡……ƒ  (‚)    ³]
   @ 6 ,0 SAY  "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
   @ 7 ,0 SAY  "³                    :ESN           :  š…”‰‡ƒ š˜    :ƒ…’‰        : „ '‘    ³"
   @ 8 ,0 SAY  "³           :…š‰ ƒ…—       :Œ™„ '‘                               :Š‰Œ„š    ³"
   @ 9 ,0 SAY  "³                    ‰‰‹˜         š…ˆ‚       š…‘…˜”    :Œ™Œ „‘‰‹ š…‹    ³"
   @ 10,0 SAY  "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
   @ 11,0 SAY  "³     ÚÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄ¿         ³"
   @ 12,0 SAY  "³     ³  1   ³  2   ³  3   ³  4   ³  5   ³  6   ³  7   ³  8   ³  9   ³         ³"
   @ 13,0 SAY  "³     ÆÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍµ         ³"
   @ 14,0 SAY  "³     ³      ³      ³      ³      ³      ³      ³      ³      ³      ³ ƒ‰ƒ    ³"
   @ 15,0 SAY  "³     ÀÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÙ         ³"
   @ 16,0 SAY  [³       “‘… ˜…€š  ‡"…ƒ '‘          „Œ‰‘” š‰‘…  ƒ…—           ‡……ˆ           ³]
   @ 17,0 SAY  "³                  „€š„-‰€                                   ÚÄÄÄÄÄÄ¿         ³"
   @ 18,0 SAY  "³                                                             ³      ³ 10      ³"
   @ 19,0 SAY  "³                                                             ÀÄÄÄÄÄÄÙ         ³"
	@ 20,0 SAY  "³                                                                              ³"
	@ 21,0 SAY  "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
ELSE
   @ 0 ,0 SAY  "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
   @ 1 ,0 SAY  "³                          Fuse Sorting Stages Notifications                   ³"
   @ 2 ,0 SAY  "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
   @ 3 ,0 SAY  "³  a. Enter Scrap Quantity          d. Additional Description for Scrap Cause  ³"
   @ 4 ,0 SAY  "³  b. Enter Scrap Cause Code        e. Confirm                                 ³"
   @ 5 ,0 SAY  [³  c. Enter Non Conformity report                                              ³]
   @ 6 ,0 SAY  "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
   @ 7 ,0 SAY  "³  Batch No.:          Purpose:     Priority:           ESN:                   ³"
   @ 8 ,0 SAY  "³  Process  :                             Stage No.:        Route Code:        ³"
   @ 9 ,0 SAY  "³  Quantity Before Scraping            Wafers          Strips           Pieces ³"
   @ 10,0 SAY  "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
   @ 11,0 SAY  "³     ÚÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄ¿         ³"
   @ 12,0 SAY  "³     ³  1   ³  2   ³  3   ³  4   ³  5   ³  6   ³  7   ³  8   ³  9   ³         ³"
   @ 13,0 SAY  "³     ÆÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍµ         ³"
   @ 14,0 SAY  "³     ³      ³      ³      ³      ³      ³      ³      ³      ³      ³         ³"
   @ 15,0 SAY  "³     ÀÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÙ         ³"
	@ 16,0 SAY  "³          10                                                                  ³"
   @ 17,0 SAY  [³       ÚÄÄÄÄÄÄ¿  Scrap Code                                                   ³]
   @ 18,0 SAY  "³ Range ³      ³  Desc.                                                        ³"
   @ 19,0 SAY  "³       ÀÄÄÄÄÄÄÙ  Non Conformity report No                                     ³"
   @ 20,0 SAY  "³                 Additional Descr.                                            ³"
	@ 21,0 SAY  "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
ENDIF

ShowSpec()

RETURN



PROCEDURE ShowSpec


IF !IfEnglish()
   @ 7,4  SAY m_linemv->esn_id
   @ 7,27 SAY m_linemv->b_prior
   @ 7,30 SAY d_line->b_wkprom
   @ 7,50 SAY m_linemv->b_purp
   @ 7,59 SAY m_linemv->b_id

   @ 8,6  SAY d_line->route_id
   @ 8,23 SAY Str(m_linemv->cp_stage , 4 )
   @ 8,41 SAY ProcId()

   @ 9,9  SAY Transform( m_linemv->cp_bqtyp , "9,999,999" )+if( c_proc->must_p ,"","*")
   @ 9,27 SAY Transform( m_linemv->cp_bqtys , "99,999" )   +if( c_proc->must_s ,"","*")
   @ 9,42 SAY Transform( m_linemv->cp_bqtyw , "999" )      +if( c_proc->must_w ,"","*")
ELSE
   @ 7,61 SAY m_linemv->esn_id
   @ 7,46 SAY m_linemv->b_prior
   @ 7,49 SAY d_line->b_wkprom
   @ 7,32 SAY m_linemv->b_purp
   @ 7,14 SAY m_linemv->b_id

   @ 8,72 SAY d_line->route_id
   @ 8,53 SAY Str(m_linemv->cp_stage , 4 )
   @ 8,14 SAY ProcId()

   @ 9,62  SAY Transform( m_linemv->cp_bqtyp , "9,999,999" )+if( c_proc->must_p ,"","*")
   @ 9,47 SAY Transform( m_linemv->cp_bqtys , "99,999" )   +if( c_proc->must_s ,"","*")
   @ 9,34 SAY Transform( m_linemv->cp_bqtyw , "999" )      +if( c_proc->must_w ,"","*")
ENDIF

RETURN

STATIC FUNCTION ProcId

LOCAL cRetVal

IF c_proc->( DbSeek( m_linemv->cpproc_id ) )
     cRetVal := IIF(!IfEnglish() ,c_proc->proc_nmh ,c_proc->proc_nme ) + " " + m_linemv->cpproc_id
ELSE
     cRetVal := Space( 20 + 1 ) + m_linemv->cpproc_id
ENDIF

RETURN cRetVal

FUNCTION preRej(o)

SetKey( K_F2 ,{|| RejMsgs()} )

RETURN .T.

FUNCTION postRej( o , cNM , nQty,lSecondLine,lFromRWR)

DEFAULT nQty to 0
DEFAULT lSecondLine TO FALSE
DEFAULT lFromRWR    TO FALSE

IF c_rejcd->( DbSeek( o:varGet() ) )
	IF !IfEnglish()
     @ o:row , o:col- (Len(AllTrim(c_rejcd->rej_nmh)) + 2) SAY AllTrim(c_rejcd->rej_nmh)
     cNM := c_rejcd->rej_nmh
	ELSEIF IfEnglish() .AND. !lSecondLine
     @ o:row , o:col + 04 SAY c_rejcd->rej_nme
     cNM := c_rejcd->rej_nme
	ELSEIF IfEnglish() .AND. lSecondLine
     @ o:row +1 , o:col - 5 SAY AllTrim(c_rejcd->rej_nme)
     cNM := c_rejcd->rej_nme
	ENDIF
ELSE
     @ o:row , o:col- IIF(!IfEnglish() ,22 ,-04 ) SAY Padc( "Rej ID not found" , 20 )
     RETURN IF((nQty == 0 .AND. !lFromRWR) .OR. LASTKEY()== K_UP , .T. , .F. )
ENDIF
SetKey( K_F2 , NIL )
RETURN .T.

PROCEDURE RejMsgs

LOCAL nSelect := Select( Alias() )
LOCAL nOrder
LOCAL o , nKey
LOCAL cScreen := SaveScreen()
LOCAL cIndexName := "irejgrp"+ c_proc->rej_grp   //Restricted to 9 groups
LOCAL aTags,i//vr
SELECT c_rejcd
nOrder := c_rejcd->( IndexOrd() )

IF File( cIndexName+".cdx" )
     c_rejcd->( dbsetindex( cIndexName ) )
     c_rejcd->( ordsetfocus( cIndexName ) )
     c_rejcd->( DbGoTop() )
ELSE
     //CheckIndex(cIndexName,cIndexName,"rej_id",.T.,"c_proc->rej_grp $ c_rejcd->rej_grps")
	  CheckIndex(cIndexName,cIndexName,"rej_id",.T.)
ENDIF

o := TBrowseDB( 4, 1 , 20 ,48 )

@ o:nTop-1 , o:nLeft-1 TO o:nBottom+1 , o:nRight+1
@ o:nTop-1 , o:nLeft SAY IIF(!IfEnglish(),"¶  ƒ…—  ˜‡  Ç" ,"¶Choose a CodeÇ" )
o:addColumn( TBColumnNEW( NIL , {|| c_rejcd->rej_id } ) )
IF !IfEnglish()
	o:addColumn( TBColumnNEW( NIL , {|| c_rejcd->rej_nmh } ) )
ELSE
   o:addColumn( TBColumnNEW( NIL , {|| c_rejcd->rej_nme } ) )//e
ENDIF


WHILE .T.
     WHILE !o:stabilize() ; ENDDO

          nKey := InKey(0)

          IF nKey = K_ESC
               EXIT
          ELSEIF StdKeys( nKey , o )

          ELSEIF nKey = K_ENTER
               GetActive():varPut( c_rejcd->rej_id )
               KEYBOARD Chr(K_ENTER )
               EXIT
          ENDIF
     ENDDO

     IF nOrder > 0
          c_rejcd->( DbSetOrder( nOrder ) )
     END

     SELECT (nSelect )
     RestScreen( ,,,, cScreen )
RETURN

STATIC FUNCTION SummaryQtys( aValues )
LOCAL nTotal := 0
Aeval( aValues , {| nValue | nTotal += nValue } )
RETURN nTotal


STATIC FUNCTION CheckQtys( nNewQty , cCode ,lFromLastF6)
LOCAL lRetVal
LOCAL nTempQty, nTheoqty
LOCAL nRejBuget
LOCAL nChoice

DEFAULT lFromLastF6 TO FALSE


nRejected := 0
DO CASE
     CASE c_proc->uom_id  == "W" .AND. cCode = "W"
          DO CASE
               CASE nNewQty=0
                    lRejFlag := .F.
                    lRetVal  := .F.
					CASE nNewQty > m_linemv->cp_bqtyw .AND. nNewQty <= d_line->qty_bini
						  nRejected := (m_linemv->cp_bqtyw - nNewQty)
						  lRetVal  := .T.
                    lRejFlag := .T.
					CASE nNewQty > m_linemv->cp_bqtyw .AND. nNewQty > d_line->qty_bini
						  nRejected := (m_linemv->cp_bqtyw - nNewQty)
						  lRetVal  := .F.
                    lRejFlag := .F.
               CASE nNewQty < m_linemv->cp_bqtyw
                    nRejected := (m_linemv->cp_bqtyw - nNewQty)
                    lRejFlag := .T.
                    lRetVal  := .T.
               OTHERWISE
                    lRejFlag := .F.
                    lRetVal  := .T.
          ENDCASE
     CASE c_proc->uom_id  == "S"  .AND. cCode = "S"

          nRejBuget := if( Left(m_linemv->cpproc_id,3) == "161" , 5 , 2 )
			 nTheoqty := QtyConvert( d_line->qty_bini , d_line->b_type , m_linemv->pline_id, m_linemv->size_id  , d_line->uom_ini , "S" ,,,d_line->route_id,d_line->value_id)
          IF ! d_line->b_purp  $ "5_8_2_6_T"
               nTempQty := MIN(m_linemv->cp_bqtys * 1.05, nTheoqty)
          ELSE
               nTempQty := nTheoqty * 1.30
          ENDIF

          DO CASE
               CASE nNewQty > nTempQty .OR. nNewQty=0
                    lRejFlag := .F.
                    lRetVal  := .F.
               CASE nNewQty < m_linemv->cp_bqtys
                    IF  m_linemv->cp_bqtys - nNewQty >= 20                         .AND. ;
						  	   IIF(SpecProc() ,.T.,nNewQty<m_linemv->cp_bqtys * GetClstrFactor() )              .AND. ;
						  		(m_linemv->cp_bqtys - nNewQty) / m_linemv->cp_bqtys > 0.01
                         lRejFlag := .T.         // Make I-Hatama report
                    ELSE
                         lRejFlag := .F.         // No need for I-Hatama report
                    ENDIF
                    lRetVal := .T.               // you can continue...
                    nRejected := m_linemv->cp_bqtys - nNewQty
               OTHERWISE
                    lRejFlag := .F.
                    lRetVal  := .T.
          ENDCASE

     CASE c_proc->uom_id  == "P" .AND. cCode = "P"

          // nTempQty is now:
          // if it is NOT a packing batch (purp is one of: "5_8_2_6_T"),
          //     the smallest qty between:
          //     a) 10% more than the prev. proccess qty. pieces
           //     b) Theoretical qty - pieces of the batch when started.
          // otherwise
          //        30% more than theoretical qty - pieces of the batch when started.
          // as requested by TAPI. D. Laor 14-08-97 ;last updt:16-09-97
          IF d_line->uom_ini="P"
               nTheoqty := d_line->qty_bini
          ELSE
               nTheoqty := QtyConvert( d_line->qty_bini , d_line->b_type , m_linemv->pline_id, m_linemv->size_id  , d_line->uom_ini , "P" ,,,d_line->route_id,d_line->value_id)
          ENDIF
          IF ! d_line->b_purp $ "5_8_2_6_T"
               nTempQty := MIN(m_linemv->cp_bqtyp * 1.10, nTheoqty)
          ELSE
               nTempQty := nTheoqty * 1.30
          ENDIF

          DO CASE
               CASE (nNewQty > nTempQty .OR. nNewQty=0) .AND. !lFromLastF6
						  lRejFlag := .F.
                    lRetVal  := .F.
               CASE nNewQty < m_linemv->cp_bqtyp .AND. !lFromLastF6
                    IF m_linemv->cp_bqtyp - nNewQty >= 1000                      .AND. ;
						  	  IIF(SpecProc() ,.T. ,nNewQty< m_linemv->cp_bqtyp * GetClstrFactor() )   .AND. ;
						  	  (m_linemv->cp_bqtyp - nNewQty) / m_linemv->cp_bqtyp > 0.01
                         lRejFlag := .T.         // Make I-Hatama report
                    ELSE
                         lRejFlag := .F.         // No need for I-Hatama report
                    ENDIF
                    nRejected := m_linemv->cp_bqtyp - nNewQty
                    lRetVal  := .T.
               CASE nNewQty >= m_linemv->cp_bqtyp*0.10 .AND. lFromLastF6
						  nRejected := nNewQty
                    lRejFlag := .F.
                    lRetVal  := .F.
               CASE nNewQty < m_linemv->cp_bqtyp*0.10 .AND. lFromLastF6
						  nRejected := nNewQty
                    lRejFlag := .F.
                    lRetVal  := .T.
               OTHERWISE
                    lRejFlag := .F.
                    lRetVal  := .T.
          ENDCASE
     OTHERWISE
          IF (cCode $ "WSP") .AND. (c_proc->uom_id $ "WSP")
               IF Negative(nNewQty) .OR. nNewQty=0
                    lRetVal := .F.
               ELSE
                    DO CASE
                         CASE cCode = "W"
                              IF nNewQty<>m_linemv->cp_bqtyw
                                   nChoice := IIF(!IfEnglish() ,ALERT( "ƒ…— Œ™ Œ™ š…‹„ š‚˜…‡ š…‘…˜” …‰‘ š…‹" ,{"—š","˜™€"}) ,ALERT( "Final wafers quantity exceeds previous stage's quantity" ,{"Correct","Confirm"}) )
                                   lRetVal := IF(nChoice == 1, .F. , .T. )
                              ELSE
                                   lRetVal := .T.
                              ENDIF
                         CASE cCode = "S"
                              IF nNewQty<>m_linemv->cp_bqtys
                                   nChoice := IIF(!IfEnglish() ,ALERT( "ƒ…— Œ™ Œ™ š…‹„ š‚˜…‡ š…ˆ‚ …‰‘ š…‹" ,{"—š","˜™€"}) ,ALERT( "Final strips quantity exceeds previous stage's quantity" ,{"Correct","Confirm"}) )
                                   lRetVal := IF(nChoice == 1, .F. , .T. )
                              ELSE
                                   lRetVal := .T.
                              ENDIF
                         CASE cCode = "P"
                              IF nNewQty<>m_linemv->cp_bqtyp
                                   nChoice := IIF(!IfEnglish() ,ALERT( "ƒ…— Œ™ Œ™ š…‹„ š‚˜…‡ ‰‰‹˜ …‰‘ š…‹" ,{"—š","˜™€"}) ,ALERT( "Final pieces quantity exceeds previous stage's quantity" ,{"Correct","Confirm"}) )
                                   lRetVal := IF(nChoice == 1, .F. , .T. )
                              ELSE
                                   lRetVal := .T.
                              ENDIF
                         END
                    ENDIF
                    lRejFlag := .F.
               ELSE
                    Alert( c_proc->uom_id + ":‰‰— €Œ „ƒ‰ š…ƒ‰‡‰ ƒ…—" , {"..."} )
               ENDIF
     ENDCASE

RETURN lRetVal

Static Function SpecProc()

Return m_linemv->cpproc_id $ "191.5_156.5_391.5_490.5_293.5_191.6_590.5_191.0_199.0_156.0_293.0_590.0_391.0_490.0_191.1_189.5_189.0_189.1_192.5_192.0_294.0_194.0_194.5"


Static Function GetClstrFactor()

local nRet := 0
local cWipPath  := GetUserInfo():cWipCostDir
local nOldArea := Select()
local nFctr

NetUse("d_esn",5)
ordsetfocus(1)

IF d_esn->(dbseek(m_linemv->esn_id))
	USE (cWipPath+AllTrim(d_esn->wip_clstr)) NEW EXCLUSIVE
	ordsetfocus(1)
	IF (alias())->(dbseek(m_linemv->cpproc_id))
		nFctr := (alias())->proc_fctr
	ELSE
		nFctr := 0.1
	ENDIF
ELSE
	alert("ESN NOT FOUND!",{"Ok"})
ENDIF

(alias())->(dbclosearea())
d_esn->(dbclosearea())

IF m_linemv->ptype_id == "U"
	nRet := 1 - (nFctr * 1.5)
ELSE
	nRet := 1 - (nFctr * 2)
ENDIF


dbselectarea(nOldArea)

Return nRet



STATIC FUNCTION CheckF6Range(o,lFromUnDesc)
LOCAL lRetVal
LOCAL nNewQty := SummaryQtys( {;
 nTolPL,nTolQL,nTolAL,nTolBL,nTolCL,nTolDL,nTolFL,nTolGL,nTolJL,nTolZL,nTolXL,;
 nTolPP,nTolQP,nTolAP,nTolBP,nTolCP,nTolDP,nTolFP,nTolGP,nTolJP,nTolZP,nTolXP} )

default lFromUnDesc TO FALSE

IF !lFromUnDesc .AND. LastKey() = K_UP
   RETURN .T.
ENDIF

IF !lFromUnDesc .AND. Negative( o )
   RETURN .F.
ENDIF

IF !lFromUnDesc .AND. UPPER(o:Name) ==  "NTOLRL"
   nNewQty := nNewQty + nTolRL
ELSEIF !lFromUnDesc .AND. UPPER(o:Name) == "NSCRAP_Q"
	nNewQty := nNewQty + nScrap_Q + nTolRL
ELSEIF !lFromUnDesc .AND. UPPER(o:Name) == "NSCRAP_FLASH"
	nNewQty := nNewQty + nScrap_Q + nScrap_Flash+ nTolRL
ELSEIF !lFromUnDesc .AND. UPPER(o:Name) == "NSCRAP_RES"
	nNewQty := nNewQty + nScrap_Q + nScrap_Flash + nScrap_Res+ nTolRL
ELSEIF !lFromUnDesc .AND. UPPER(o:Name) == "NSCRAP_NODESCR"
	nNewQty := m_linemv->cp_bqtyp - (nNewQty + nScrap_Q + nScrap_Flash + nScrap_Res+ nTolRL)
ELSEIF lFromUnDesc
	nNewQty := m_linemv->cp_bqtyp - (nNewQty + nScrap_Q + nScrap_Flash + nScrap_Res+ nTolRL)
	Return nNewQty
ENDIF

lRetVal := CheckQtys( nNewQty , "P",UPPER(o:Name) == "NSCRAP_NODESCR")

IF !ifEnglish() .AND. !lRetVal .AND. UPPER(o:Name) <> "NSCRAP_NODESCR"
     Alert( [!‡……ƒ„ š€ —šŒ …€ ‰"”šŒ š…”Œ € ,˜š…„ š‚˜…‡ …‰‘ š…‹], {"..."} )
ELSEIF ifEnglish() .AND. !lRetVal .AND. UPPER(o:Name) <> "NSCRAP_NODESCR"
     Alert( [Final quantity incorrect. Please correct or contact production control!], {"..."} )
ENDIF

RETURN lRetVal


STATIC FUNCTION CheckF7Range(o)
LOCAL lRetVal
LOCAL nNewQty := SummaryQtys( {nGoodPacked , nGoodLoose} )

IF LastKey() = K_UP
RETURN .T.
ENDIF

IF Negative( o )
RETURN .F.
ENDIF

lRetVal := CheckQtys( nNewQty , "P")

IF !ifEnglish() .AND. !lRetVal
     Alert( [!‡……ƒ„ š€ —šŒ …€ ‰"”šŒ š…”Œ € ,˜š…„ š‚˜…‡ …‰‘ š…‹], {"..."} )
ELSEIF ifEnglish() .AND. !lRetVal
     Alert( [Final quantity incorrect. Please correct or contact production control!], {"..."} )
ENDIF

RETURN lRetVal


STATIC FUNCTION CheckF8Range(o)
LOCAL lRetVal
LOCAL nNewQty := SummaryQtys( { nRange1,nRange2, nRange3, nRange4, nRange5, nRange6,;
     nRange7, nRange8, nRange9 } )

IF LastKey() = K_UP
RETURN .T.
ENDIF

IF Negative( o )
RETURN .F.
ENDIF

lRetVal := CheckQtys( nNewQty , "P")

IF !ifEnglish() .AND. !lRetVal
     Alert( [!‡……ƒ„ š€ —šŒ …€ ‰"”šŒ š…”Œ € ,˜š…„ š‚˜…‡ …‰‘ š…‹], {"..."} )
ELSEIF ifEnglish() .AND. !lRetVal
     Alert( [Final quantity incorrect. Please correct or contact production control!], {"..."} )
ENDIF

RETURN lRetVal


STATIC FUNCTION preRejected(o,nGoodPacked,nGoodLoose,lFromF6)
LOCAL nPrevRejQty
DEFAULT nGoodPacked TO 0
DEFAULT nGoodLoose  TO 0
DEFAULT lFromF6 TO FALSE

IF nGoodPacked + nGoodLoose = m_linemv->cp_bqtyp
     // No need to ask for scrap ! D.Laor 22-12-99
     // See also line:1026
     RETURN .F.
ENDIF
IF lRejFlag .OR. (!lRejFlag .AND. lFromF6)
     IF READVAR() = "NRANGE10"
          nPrevRejQty := GetList[ 9 ]:varGet()
     ELSE
          nPrevRejQty := 0
     ENDIF
     o:varPut( nRejected-nPrevRejQty )
	  //IIF(UPPER(o:Name) == "NSCRAP_NODESCR" ,o:CarGo := nRejected-nPrevRejQty  ,nil )
ELSE
     o:varPut( 0 )
ENDIF
RETURN .T.

STATIC FUNCTION postRejected(o,lComesFromF7,lFromF6)
LOCAL lRetVal := .T.
LOCAL nPrevRejQty
LOCAL nCurrRejQty := o:varGet()
DEFAULT lComesFromF7 to .F.
DEFAULT lFromF6 to FALSE
IF LastKey() = K_UP
     RETURN .T.
ENDIF

// Special Treatment for screen F7.
// No reason for reporting automatic scrap ! If reported at least 1 piece
// There must be a reason different than M999. D.Laor 15-12-99
// Taken out same day. See also: Line 997
IF (lComesFromF7 .AND. o:varGet()=0)
   RETURN .F.
ENDIF
IF Negative( o )
     RETURN .F.
ENDIF

nM999Rejected := 0

IF lRejFlag
     IF READVAR() = "NRANGE10"                   //It comes from Screen F8
          nPrevRejQty := GetList[ 9 ]:varGet()
     ELSE
          nPrevRejQty := 0
     ENDIF

     IF (nCurrRejQty+nPrevRejQty) > nRejected .AND. !lFromF6
          o:varPut( nRejected-nPrevRejQty)
          Tone( 400, 1 )
     ELSEIF (nCurrRejQty+nPrevRejQty) = nRejected

     ELSE
          nM999Rejected := nRejected - (nCurrRejQty+nPrevRejQty)
     ENDIF
ENDIF
RETURN lRetVal



PROCEDURE GetScr2_F3F4F5( cCode,lFromF6,oFromF6,lFromRWR )

LOCAL aGetList := GetList
LOCAL cScreen := SaveScreen()

default lFromF6 to FALSE
default lFromRWR to FALSE

ScrF3F4F5On(lFromRWR)
GetList := {}
GetRejLines( cCode,lFromF6,oFromF6,lFromRWR )
GetList := aGetList
RestScreen( ,,,, cScreen )

RETURN


STATIC PROCEDURE ScrF3F4F5On(lFromRWR)
IF !ifEnglish()
    @ 0 ,0 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
    @ 1 ,0 SAY "³                                  š Œ ‰ ‘ ”  ‡……‰ƒ                            ³"
    @ 2 ,0 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
    @ 3 ,0 SAY "³      „Œ‰‘”„ š‰‘Œ “‘… ˜…€š “‘…„ (ƒ)            šŒ‘”„ š…‹„ Œ’ ‡……ƒ  (€)    ³"
    @ 4 ,0 SAY "³                    ‡……‰ƒ„ š€ ˜™€ („)         „Œ‰‘”„ š‰‘ ƒ…— Œ’ ‡……ƒ  ()    ³"
    @ 5 ,0 SAY [³                                            „€š„-‰€ ‡"…ƒ '‘ Œ’ ‡……ƒ  (‚)    ³]
    @ 6 ,0 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
    @ 7 ,0 SAY "³                    :ESN           :  š…”‰‡ƒ š˜    :ƒ…’‰        : „ '‘    ³"
    @ 8 ,0 SAY "³           :…š‰ ƒ…—       :Œ™„ '‘                               :Š‰Œ„š    ³"
    @ 9 ,0 SAY "³                    ‰‰‹˜         š…ˆ‚                 :Œ™Œ „‘‰‹ š…‹    ³"
    @ 10,0 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
	 IF lFromRWR
    @ 11,0 SAY "³                                                Œ™ xxxxxxŒ  š…‰’„ ˆ…˜‰”  - ³"
	 ELSE
    @ 11,0 SAY "³                                                Œ™ xxxxxxŒ š…Œ‰‘”„ ˆ…˜‰”  - ³"
	 ENDIF
    @ 12,0 SAY [³                                                                              ³]
    @ 13,0 SAY "³                                                                              ³"
    @ 14,0 SAY "³                                                                              ³"
    @ 15,0 SAY "³                                                                              ³"
    @ 16,0 SAY "³                                                                              ³"
    @ 17,0 SAY "³                                                                              ³"
    @ 18,0 SAY "³                                                                              ³"
    @ 19,0 SAY "³                                                                              ³"
    @ 20,0 SAY "³                                                                              ³"
    @ 21,0 SAY "³                                                                              ³"
    @ 22,0 SAY "³                                                                              ³"
    @ 23,0 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
ELSE
    @ 0 ,0 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
    @ 1 ,0 SAY "³                                  Scrap Report                                ³"
    @ 2 ,0 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
    @ 3 ,0 SAY "³  a. Enter Scrap Quantity          d. Additional Description for Scrap Cause  ³"
    @ 4 ,0 SAY "³  b. Enter Scrap Cause Code        e. Confirm                                 ³"
    @ 5 ,0 SAY [³  c. Enter Non Conformity report                                              ³]
    @ 6 ,0 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
	 @ 7 ,0 SAY "³  Batch No.:          Purpose:     Priority:           ESN:                   ³"
    @ 8 ,0 SAY "³  Process  :                             Stage No.:        Route Code:        ³"
    @ 9 ,0 SAY "³  Quantity Before Scraping            Wafers          Strips           Pieces ³"
    @ 10,0 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
	 IF lFromRWR
       @ 11,0 SAY "³          Problem details                                                     ³"
	 ELSE
		 @ 11,0 SAY "³          Scrap details                                                       ³"
	 ENDIF
    @ 12,0 SAY [³                                                                              ³]
    @ 13,0 SAY "³                                                                              ³"
    @ 14,0 SAY "³                                                                              ³"
    @ 15,0 SAY "³                                                                              ³"
    @ 16,0 SAY "³                                                                              ³"
    @ 17,0 SAY "³                                                                              ³"
    @ 18,0 SAY "³                                                                              ³"
    @ 19,0 SAY "³                                                                              ³"
    @ 20,0 SAY "³                                                                              ³"
    @ 21,0 SAY "³                                                                              ³"
    @ 22,0 SAY "³                                                                              ³"
    @ 23,0 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
ENDIF
DO CASE
     CASE lRejEob .OR. c_proc->scr2 == "F3"
          //         š…‘…˜”
			 IF !IfEnglish()
             @ 1 , 20 SAY "       š…‘…˜”"
             @ 11, 54 SAY "š…‘…˜”"
			 ELSE
			    @ 1 , 27 SAY "Wafers"
             @ 11, 02 SAY "Wafers"
			 ENDIF
     CASE c_proc->scr2 == "F4"
          //           š…ˆ‚
			 IF !IfEnglish()
             @ 1 , 20 SAY "        š…ˆ‚"
             @ 11, 54 SAY  "š…ˆ‚€"
			 ELSE
			    @ 1 , 27 SAY "Strips"
             @ 11, 02 SAY "Strips"
			 ENDIF
     CASE c_proc->scr2 == "F5"
          // ‰ƒ‰ƒ ‰‰‹˜
			 IF !IfEnglish()
             @ 1 , 20 SAY "‰ƒ‰ƒ ‰‰‹˜"
             @ 11, 54 SAY "‰‰‹˜"
			 ELSE
			    @ 1 , 27 SAY "Pieces"
             @ 11, 02 SAY "Pieces"
			 ENDIF
ENDCASE
ShowSpec()
RETURN

PROCEDURE EmptyRejBuffer()
aRegularRej := {}
RETURN

STATIC PROCEDURE GetRejLines( cCode,lFromf6,oFromF6,lFromRWR )


LOCAL  o , nKey

default lFromf6 to FALSE
default lFromRWR to FALSE

IF (Empty( aRegularRej ) .AND.  !lFromF6) .OR. ;
	(!Empty( aRegularRej ) .AND. lFromRWR .AND. !lFromF6)
     GetOneRejection("N",,,,lFromRWR) // new
     IF LastKey() = K_ESC
          RETURN
     ENDIF
ELSEIF Empty( aRegularRej ) .AND.  lFromF6
	RETURN
ENDIF



IF !IfEnglish()
	o := ABrowseNEW(12,1,21,73,aRegularRej)
   o:addColumn( TBColumnNEW( "   “‘… ˜…€š  ", {||o:arrayReference[o:arrayIndex,1]} ) )
   o:addColumn( TBColumnNEW( [‡"…ƒ '‘;„€š„-‰€] , {|| o:arrayReference[o:arrayIndex,2] }))
   o:addColumn( TBColumnNEW( IIF(lFromRWR ,"     „‰’„ ˜…€š","     „Œ‰‘” š‰‘…")  , {||o:arrayReference[o:arrayIndex,3]}))
   o:addColumn( TBColumnNEW( "ƒ…—"  , {||o:arrayReference[o:arrayIndex,4]}))
   o:addColumn( TBColumnNEW( IIF(lFromRWR ,"   š…‹   " ," „Œ…‘” š…‹" )  , {||Transform(o:arrayReference[o:arrayIndex,5],"999,999,999") }))
	IF lFromf6
		o:addColumn( TBColumnNEW( "„Œ‰‘” ‚…‘" , {||o:arrayReference[o:arrayIndex,6] }))
	ELSE
		o:addColumn( TBColumnNEW( "'‘;„‘…˜”" , {||Str(o:arrayReference[o:arrayIndex,6],5) }))
	ENDIF
   @ 24,0 SAY Padr( "Enter-„Œ‰‘” ‹ƒ’  Space-„™ƒ‡ „Œ‰‘”  Delete-„Œ‰‘” Œˆ  F5-˜…™‰€", 80 ) COLOR if( IsColor() , "W+/GR" , "N/W" )
   o:panEnd()
ELSE
	o := ABrowseNEW(12,1,21,73,aRegularRej)
	IF lFromf6
      o:addColumn( TBColumnNEW( "Wafer;ID"                  , {||o:arrayReference[o:arrayIndex,6] }))
	ELSE
		o:addColumn( TBColumnNEW( "Wafer;No"                  , {||Str(o:arrayReference[o:arrayIndex,6],5) }))
	ENDIF
	o:addColumn( TBColumnNEW( IIF(lFromRWR ,"   Quantity","   Scrap;   Quantity")      , {||Transform(o:arrayReference[o:arrayIndex,5],"999,999,999") }))
	o:addColumn( TBColumnNEW( IIF(lFromRWR ,"Code"       ,"Scrap;Code")          , {||o:arrayReference[o:arrayIndex,4]}))
	o:addColumn( TBColumnNEW( "Description"        , {||o:arrayReference[o:arrayIndex,3]}))
	o:addColumn( TBColumnNEW( [Non Conformity;Report No.] , {|| o:arrayReference[o:arrayIndex,2] }))
	o:addColumn( TBColumnNEW( "Additional;Description"    , {||o:arrayReference[o:arrayIndex,1]} ) )

   @ 24,0 SAY Padr( "Confirm - F5 , Cancel Scrap - Delete , New Scrap - Space , Update Scrap - Enter", 80 ) COLOR if( IsColor() , "W+/GR" , "N/W" )
ENDIF


WHILE .T.
     WHILE !o:stabilize() ; ENDDO

          nKey := InKey(0)

			 IF nKey == K_ESC .OR. nKey == K_F5
				     EXIT
          ELSEIF StdKeys( nKey , o )

          ELSEIF (nKey = K_ENTER .AND. !lFromF6) .OR. ;
			   	  (nKey = K_ENTER .AND. o:arrayReference[o:arrayIndex,6] <> "99")
                  GetOneRejection("U", o:arrayIndex,lFromf6,oFromF6,lFromRWR) // new
                  o:refreshAll()
          ELSEIF (nKey = K_DEL .AND.  !lFromF6) .OR. ;
			        (nKey = K_DEL .AND. o:arrayReference[o:arrayIndex,6] <> "99")
	              IF lFromF6
		  				  nRejected := aRegularRej[Len(aRegularRej),5] := aRegularRej[Len(aRegularRej),5] + aRegularRej[o:arrayIndex,5]
                    IF aRegularRej[o:arrayIndex,6] == "RL"
							  oFromF6:VarPut(oFromF6:VarGet() - nTolRL)
	                    nTolRL := 0
						  ELSEIF aRegularRej[o:arrayIndex,6] == "RL"
                       nTolRL := 0
                    ELSEIF aRegularRej[o:arrayIndex,6] == "QR"
	                    nScrap_Q := 0
                    ELSEIF aRegularRej[o:arrayIndex,6] == "FL"
                       nScrap_Flash := 0
                    ELSEIF aRegularRej[o:arrayIndex,6] == "RR"
                       nScrap_Res := 0
                    ENDIF
	              ENDIF
					  Adel( o:arrayReference, o:arrayIndex )
                 Asize( o:arrayReference , Len(o:arrayReference)-1)
                 IF Empty( o:arrayReference )
                    GetOneRejection("N",,,,lFromRWR)         // new
                    IF LastKey() = K_ESC
                         EXIT
                    ENDIF
                 ENDIF
                 o:configure()
                 o:goTop()
                 o:refreshAll()
          ELSEIF nKey = K_SPACE                  // new row
               GetOneRejection("N",,lFromf6,,lFromRWR) // new
               o:configure()
               o:refreshAll()
          ENDIF

     ENDDO

RETURN


static function GetNewRNO()

local cRepNO := "      "
local cDbf

IF c_Proc->WKSTN_ID $ "_6160_"//white
	cDbf := "n_repw"
ELSEIF c_Proc->WKSTN_ID $ "_6120_"//yellow
	cDbf := "n_repy"
ELSEIF c_Proc->WKSTN_ID $ "_6180_"//passivation & bonding
	cDbf := "n_reppb"
ELSEIF c_Proc->WKSTN_ID $ "_6800_7000_8000_"//IL Mid section
	cDbf := "n_repmsi"
ELSEIF c_Proc->WKSTN_ID $ "_8500_9000_9500_"//IL Backend
	cDbf := "n_repbei"
ELSEIF c_Proc->WKSTN_ID $ "_3500_"//CZ Mid section
	cDbf := "n_repmsc"
ELSEIF c_Proc->WKSTN_ID $ "_4000_"//CZ Backend
	cDbf := "n_repbec"

ENDIF

IF c_Proc->WKSTN_ID $ "_6160_6120_6180_6800_7000_8000__8500_9000_9500__3500__4000_"

       NetUse(cDbf,5)

       IF (cDbf)->( RecLock(5, "repstd") )
          (cDbf)->counter++
          (cDbf)->(dbcommit())
			 IF c_Proc->WKSTN_ID $ "_6160_"
				cRepNO := "W" + alltrim(str((cDbf)->counter))
			 ELSEIF c_Proc->WKSTN_ID $ "_6120_"
            cRepNO := "Y" + alltrim(str((cDbf)->counter))
			 ELSEIF c_Proc->WKSTN_ID $ "_6180_"
			   cRepNO := "P" + alltrim(str((cDbf)->counter))
			 ELSEIF c_Proc->WKSTN_ID $ "_6800_7000_8000_"
			   cRepNO := "D" + alltrim(str((cDbf)->counter))
			 ELSEIF c_Proc->WKSTN_ID $ "_8500_9000_9500_"
			   cRepNO := "I" + alltrim(str((cDbf)->counter))
			 ELSEIF c_Proc->WKSTN_ID $ "_3500_"
			   cRepNO := "M" + alltrim(str((cDbf)->counter))
			 ELSEIF c_Proc->WKSTN_ID $ "_4000_"
			   cRepNO := "B" + alltrim(str((cDbf)->counter))
			 ENDIF

       ENDIF
		 (cDbf)->(dbclosearea())
ENDIF

Return cRepNo

STATIC PROCEDURE GetOneRejection( cCode , i ,lFromF6,oFromF6,lFromRWR)

LOCAL cScreen := SaveScreen()
LOCAL nWeferNo
LOCAL nQtyRej    := 0
LOCAL cRejCode   := "    " , cDescription
LOCAL cCodeMnnnn := "      "
LOCAL cNote

default lFromF6  to FALSE
default lFromRWR to FALSE

cNote      := IIF(!lFromF6,Space(40) ,Space(14) )

nWeferNo   := IIF( !lFromf6,0,"    ")

GetList := {}

IF cCode == "U"
     iif(!lFromf6,nWeferNo   := aRegularRej[ i , 6 ],nil)
     nQtyRej    := aRegularRej[ i , 5 ]
     cRejCode   := aRegularRej[ i , 4 ]
     cCodeMnnnn := aRegularRej[ i , 2 ]
     cNote      := aRegularRej[ i , 1 ]
ELSEIF cCode <> "U"// .AND. lFromRWR //report for non scrap only
	  cCodeMnnnn := GetNewRNO()
ENDIF



IF !IfEnglish()
	IF !lFromF6
       @ 15,10 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
       @ 16,10 SAY "³                                                              ³"
       @ 17,10 SAY "³                                           :„‘…˜” '‘         ³"
	  IF lFromRWR
       @ 18,10 SAY "³                                           :š…‹              ³"
       @ 19,10 SAY "³                                           :„‰’ ƒ…—          ³"
	  ELSE
       @ 18,10 SAY "³                                           :„Œ…‘” š…‹        ³"
       @ 19,10 SAY "³                                           :„Œ‰‘” š‰‘… ƒ…—   ³"
	  ENDIF
      @  20,10 SAY [³                                           :„€š„-‰€ ‡"…ƒ '‘ ³]
      @  21,10 SAY "³                                           :“‘… ˜…€š         ³"
      @  22,10 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
	  IF lFromRWR
          @ 10,18 SAY iif( cCode = "U" , "„‰’ ‹ƒ’" , "„™ƒ‡ „‰’" ) COLOR if( IsColor() , "W+/B" , "W+/N" )
	  ELSE
            @ 10,18 SAY iif( cCode = "U" , "„Œ‰‘” ‹ƒ’" , "„™ƒ‡ „Œ‰‘”" ) COLOR if( IsColor() , "W+/B" , "W+/N" )
	  ENDIF
     @ 17 , 45 GET nWeferNo   PICTURE "999"    SEND postBlock  := {|o| postWafferNo(o,cCode,i,lFromRWR) }
     @ 18 , 42 GET nQtyRej    PICTURE "999999" SEND postBlock  := {|o| (lFromRWR .AND. PostQtyRWR(o)) .OR. postGetQtys(o,,,,lFromRWR) }
     @ 19 , 44 GET cRejCode   PICTURE "!999"   SEND preBlock   := {|o| preRej( o ) } ;
                                               SEND postBlock  := {|o| postRej( o, @cDescription , nQtyRej,,lFromRWR ) }
     @ 20 , 42 GET cCodeMnnnn PICTURE "!99999" VALID lFromRWR .OR. cCodeMnnnn <> "     "
     @ 21 , 11 GET cNote      SEND reader := {|o| HebReader(o) }
	ELSE
     @ 15,16 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
     @ 16,16 SAY "³                                              ³"
     @ 17,16 SAY "³                           :„Œ…‘” š…‹        ³"
     @ 18,16 SAY "³                           :„Œ‰‘” š‰‘… ƒ…—   ³"
     @ 19,16 SAY [³                           :„€š„-‰€ ‡"…ƒ '‘ ³]
     @ 20,16 SAY "³                           :“‘… ˜…€š         ³"
     @ 21,16 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
     @ 16,18 SAY if( cCode = "U" , "„Œ‰‘” ‹ƒ’" , "„™ƒ‡ „Œ‰‘”" ) COLOR if( IsColor() , "W+/B" , "W+/N" )

     @ 17 , 37 GET nQtyRej    PICTURE "999999" SEND postBlock  := {|o| postGetQtys(o,lFromF6,i,oFromF6) }

     @ 18 , 39 GET cRejCode   PICTURE "!999"   SEND preBlock   := {|o| preRej( o ) .AND. ;
	  	                                                                (cCode == "U" .AND. ChkRej(nQtyRej,aRegularRej[ i , 6 ])) .OR. cCode <> "U"} ;
                                               SEND postBlock  := {|o| postRej( o, @cDescription , nQtyRej ) }
     @ 19 , 37 GET cCodeMnnnn PICTURE "!99999" SEND preBlock   := {|o| (cCode == "U" .AND. ChkRej(nQtyRej,aRegularRej[ i , 6 ])) .OR. cCode <> "U"} ;
	                                            VALID IF( nQtyRej=0, .T. ,IF( cCodeMnnnn <> "      ", .T. , .F. ) )
     @ 20 , 29 GET cNote      SEND preBlock  := {|o| (cCode == "U" .AND. ChkRej(nQtyRej,aRegularRej[ i , 6 ])) .OR. cCode <> "U"};
	  	                        SEND reader    := {|o| HebReader(o) }
	ENDIF
ELSE
	IF !lFromF6
       @ 15,1 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
       @ 16,1 SAY "³                                                                           ³"
       @ 17,1 SAY "³  Wafer No.                                                                ³"
	  IF lFromRWR
       @ 18,1 SAY "³  Quantity                                                                 ³"
       @ 19,1 SAY "³  Problem Code                                                             ³"
	  ELSE
       @ 18,1 SAY "³  Scrap Quantity                                                           ³"
       @ 19,1 SAY "³  Scrap Cause Code                                                         ³"
	  ENDIF
       @ 20,1 SAY [³  Non Conformity report No                                                 ³]
       @ 21,1 SAY "³  Additional Description                                                   ³"
       @ 22,1 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
	  IF lFromRWR
          @ 16,40 SAY if( cCode = "U" , "Update Problem" , "New Problem" ) COLOR if( IsColor() , "W+/B" , "W+/N" )
	  ELSE
          @ 16,40 SAY if( cCode = "U" , "Update Scrap" , "New Scrap" ) COLOR if( IsColor() , "W+/B" , "W+/N" )
	  ENDIF
     @ 17 , 35 GET nWeferNo   PICTURE "999"    SEND postBlock  := {|o| postWafferNo(o,cCode,i,lFromRWR) }
     @ 18 , 32 GET nQtyRej    PICTURE "999999" SEND postBlock  := {|o| (lFromRWR .AND. PostQtyRWR(o)) .OR. postGetQtys(o,,,,lFromRWR) }
     @ 19 , 24 GET cRejCode   PICTURE "!999"   SEND preBlock   := {|o| preRej( o ) } ;
                                               SEND postBlock  := {|o| postRej( o, @cDescription , nQtyRej,,lFromRWR  ) }
     @ 20 , 32 GET cCodeMnnnn PICTURE "!99999" VALID lFromRWR .OR. cCodeMnnnn<>"     "
     @ 21 , 32 GET cNote
	ELSE
     @ 15,6 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
     @ 16,6 SAY "³                                                                   ³"
     @ 17,6 SAY "³  Scrap Quantity                                                   ³"
     @ 18,6 SAY "³  Scrap Cause Code                                                 ³"
     @ 19,6 SAY [³  Non Conformity report No                                         ³]
     @ 20,6 SAY "³  Additional Description                                           ³"
     @ 21,6 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
     @ 16,48 SAY if( cCode = "U" , "Update Scrap" , "New Scrap" ) COLOR if( IsColor() , "W+/B" , "W+/N" )

	  @ 17 , 37 GET nQtyRej    PICTURE "999999" SEND postBlock  := {|o| postGetQtys(o,lFromF6,i,oFromF6) }
	  @ 18 , 29 GET cRejCode   PICTURE "!999"   SEND preBlock   := {|o| preRej( o ) .AND. ;
	  	                                                                (cCode == "U" .AND. ChkRej(nQtyRej,aRegularRej[ i , 6 ])) .OR. cCode <> "U"} ;
                                               SEND postBlock  := {|o| postRej( o, @cDescription , nQtyRej ) }
     @ 19 , 37 GET cCodeMnnnn PICTURE "!99999" SEND preBlock   := {|o| (cCode == "U" .AND. ChkRej(nQtyRej,aRegularRej[ i , 6 ])) .OR. cCode <> "U"} ;
	                                            VALID IF( nQtyRej=0, .T. ,IF( cCodeMnnnn <> "      ", .T. , .F. ) )
     @ 20 , 37 GET cNote   SEND preBlock  := {|o| (cCode == "U" .AND. ChkRej(nQtyRej,aRegularRej[ i , 6 ])) .OR. cCode <> "U"}
	ENDIF
ENDIF

READ

IF ASCAN( aGoodKeys, LASTKEY() ) > 0
     IF cCode == "U"
          iif(!lFromf6,aRegularRej[ i , 6 ] := nWeferNo,nil)
          aRegularRej[ i , 5 ] := nQtyRej
          aRegularRej[ i , 4 ] := cRejCode
          aRegularRej[ i , 3 ] := cDescription
          aRegularRej[ i , 2 ] := cCodeMnnnn
          aRegularRej[ i , 1 ] := cNote
     ELSE
			 IF !lFromF6
			    Aadd( aRegularRej , { cNote,cCodeMnnnn,cDescription,cRejCode,nQtyRej,nWeferNo,lFromRWR } )
			 ELSE
				aSize(aRegularRej,Len(aRegularRej) + 1)
				aRegularRej[Len(aRegularRej)] := aRegularRej[Len(aRegularRej) - 1]
				aRegularRej[Len(aRegularRej) - 1] := { cNote,cCodeMnnnn,cDescription,cRejCode,nQtyRej,nWeferNo,lFromRWR }
			 ENDIF

          IF SwType() != "X"
               Aadd( Atail(aRegularRej) , SwType() )
          ENDIF

     ENDIF
ENDIF

RestScreen( ,,,, cScreen )
RETURN

STATIC FUNCTION postWafferNo(o,cCode,i,lFromRWR)
LOCAL nBuffer := o:varGet()
LOCAL lRetVal , nPos

IF Negative( o )
RETURN .F.
ENDIF

DO CASE
     CASE lRejEob
          lREtVal := .T.
     CASE (lRetVal := ((nBuffer < 1 .AND. !lFromRWR) .OR. nBuffer > 32) .AND. (nBuffer<>98) )
			 IF !IfEnglish()
			     Alert( "ƒŒ 98:ƒ…— …€ 32 ƒ’ 1: ‡……ˆ „‘…˜” ˜”‘", {"..."})
			 ELSE
              Alert( "Wafer No. Must be between 1 to 32 or code 98", {"..."})
			 ENDIF
          lRetVal := !lRetVal
     CASE ((nPos := Ascan( aRegularRej , {|el| el[6] == nBuffer })) > 0)
          DO CASE
               CASE cCode == "N"
                    lRetVal := .F.
               CASE cCode == "U"
                    lRetVal := (nPos = i)        // if we found the wafer in the same line we edit now
                    // we do not count it
          ENDCASE

          IF !lRetVal
               IIF(!IfEnglish() ,Alert(Ltrim(Str(nPos))+":„˜…™ ˜‹ ‡……ƒ „† „‘…˜” ˜”‘", {"..."} ) ,;
						               Alert("Wafer No. already report", {"..."} ) )
          ENDIF
     OTHERWISE
          lRetVal := .T.
ENDCASE

RETURN lRetVal


STATIC Function PostQtyRWR(o)

LOcal lRetVal

lRetVal := o:varGet() <= GetQtyPerCode()

Return lRetVal

STATIC Function GetQtyPerCode()

LOCAL cCode := GetQtyCode()
LOcal nRetVal

IF cCode == "W"
	nRetVal := m_linemv->cp_bqtyw
ELSEIF cCode == "S"
	nRetVal := m_linemv->cp_bqtys
ELSE
	nRetVal := m_linemv->cp_bqtyp
ENDIF

Return nRetVal



STATIC FUNCTION postGetQtys(o,lFromF6,nIndex,oFromF6,lFromRWR)
LOCAL lRetVal
LOCAL nSum := 0

default lFromF6  to FALSE
default lFromRWR to FALSE

IF LessThan1(o)                                  //Negative( o )
RETURN .F.
ENDIF

Aeval( aRegularRej , {|el,i| nSum += aRegularRej[i,5] })

IF (nSum+o:varGet() > nRejected .AND. !lFromF6) .OR.;
	(!Empty(nIndex) .AND. o:varGet() - aRegularRej[nIndex,5] > nRejected .AND. lFromF6) .OR. ;
   (Empty(nIndex) .AND. o:varGet() > nRejected .AND. lFromF6) .OR. ;
   (nRejected < 0 .AND. nSum+o:varGet() < nRejected .AND. !lFromF6)
	IF !IfEnglish()
       Alert( Transform(IIF(!lFromRWR ,nRejected ,GetQtyPerCode()),"999,999,999")+":…‰„ š‰‹…š„ …™‰‡ ‰”Œ ‡……ƒŒ š‰™ ‰Œ…‘”„ š…‹;"+;
              Transform(nSum+o:varGet(),"999,999,999")+":„‰„ ‰‡‹…„ ŒŒ…‹ „† ‡……‰ƒ ‰Œ…‘”„ š…‹", {"..."} )
	ELSE
       Alert( "ERROR : Cant't report scrap quantity above "+Transform(IIF(!lFromRWR ,nRejected ,GetQtyPerCode()),"999,999,999"), {"..."} )
	ENDIF
   lRetVal := .F.
ELSE
     lRetVal := .T.
	  IF lFromF6 .AND. !Empty(nIndex)
		  nRejected := aRegularRej[Len(aRegularRej),5] := aRegularRej[Len(aRegularRej),5] + (aRegularRej[nIndex,5] - o:varGet())
        IF aRegularRej[nIndex,6] == "RL"
			  oFromF6:VarPut(oFromF6:VarGet() - nTolRL + o:varGet())
	        nTolRL := o:varGet()
        ELSEIF aRegularRej[nIndex,6] == "QR"
	        nScrap_Q := o:varGet()
        ELSEIF aRegularRej[nIndex,6] == "FL"
           nScrap_Flash := o:varGet()
        ELSEIF aRegularRej[nIndex,6] == "RR"
           nScrap_Res := o:varGet()
        ENDIF
	  ELSEIF lFromF6 .AND. Empty(nIndex)
		  nRejected := aRegularRej[Len(aRegularRej),5] := aRegularRej[Len(aRegularRej),5] - o:varGet()
	  ENDIF
ENDIF

RETURN lRetVal


STATIC PROCEDURE barUpdateAll( cWID )

local nAVM := 0,nUnif := 0,nFreq := 0,nThick := 0
local aCoup := {0,0,0,0,0}
local aPoly := {0,0,0,0,0,0}
local nRec,i
local nOrd
local aFields := {}

IF barCanUpdate()

     IF c_proc->scr2 $ "F6_F7_F8"
          FinishUpdate()
     ENDIF

IF c_proc->proc_id $ "_190.0_190.5" .AND. m_linemv->ptype_id $ "_C_" .AND. m_linemv->size_id <> "C005" .AND. ;
	  Alert("Did visual sample passed successfully?",{"No","Yes"}) == 2
   nRec := m_linemv->(RecNO())
   nOrd := m_linemv->(ordsetfocus("ilnmvbn"))
   IF (m_linemv->(dbseek(d_line->b_id+"156.0")) .OR. m_linemv->(dbseek(d_line->b_id+"156.5"))) .AND. ;
      m_linemv->( RecLock( 5 ) )
 	  m_linemv->(dbdelete())
 	  m_linemv->( DbUnLock() )
   ENDIF
   IF (m_linemv->(dbseek(d_line->b_id+"157.0")) .OR. m_linemv->(dbseek(d_line->b_id+"157.5"))) .AND. ;
      m_linemv->( RecLock( 5 ) )
      m_linemv->(dbdelete())
      m_linemv->( DbUnLock() )
   ENDIF
   m_linemv->(ordsetfocus(nOrd))
   m_linemv->(dbgoto(nRec))
ENDIF


     ScrapUpdate()
     LineMovUpdate( cWID,c_proc->scr2 $ "_F6_" )

	  IF c_proc->proc_id $ "_189.0_189.5_"

		  SET ESCAPE OFF

		  NetUse("D_avmuni",5)

		  @12, 22 CLEAR TO 15, 50
		  DrawBox( 12, 22, 15, 50 )

		  @12, 23 SAY "AVG.C must be entered"


		  @13, 30 SAY "AVG.C: " GET nAVM PICTURE "999.999" VALID !Empty(nAVM) .AND. Alert("Are you sure ?",{"Yes","No"}) == 1

		  READ

		  if D_avmuni->(AddRec(5,"insAVG_Uni"))
			  D_avmuni->b_id      := m_linemv->b_id
			  D_avmuni->cp_stage  := m_linemv->cp_stage
			  D_avmuni->cpproc_id := m_linemv->cpproc_id
			  D_avmuni->CP_PCCODE := m_linemv->CP_PCCODE
			  D_avmuni->CPWKSTN_ID  := m_linemv->CPWKSTN_ID
			  D_avmuni->PTYPE_ID  := m_linemv->PTYPE_ID
			  D_avmuni->PLINE_ID  := m_linemv->PLINE_ID
			  D_avmuni->SIZE_ID   := m_linemv->SIZE_ID
			  D_avmuni->VALUE_ID  := m_linemv->VALUE_ID
			  D_avmuni->tol_ID    := m_linemv->tol_ID
			  D_avmuni->volt_ID   := m_linemv->volt_ID
			  D_avmuni->tc_ID     := m_linemv->tc_ID
			  D_avmuni->term_ID   := m_linemv->term_ID
			  D_avmuni->ESN_ID    := m_linemv->ESN_id
			  D_avmuni->ESNXX_ID  := m_linemv->ESNXX_ID
			  D_avmuni->ESNY_ID   := m_linemv->ESNY_ID
			  D_avmuni->DIEL_ID   := m_linemv->DIEL_ID
			  D_avmuni->DIEL_WIDTH := m_linemv->DIEL_WIDTH
			  D_avmuni->CP_BQTYP  := m_linemv->CP_BQTYP
			  D_avmuni->CP_BQTYS  := m_linemv->CP_BQTYS
			  D_avmuni->CP_BQTYW  := m_linemv->CP_BQTYW
			  D_avmuni->avg_c_avm := nAVM
			  D_avmuni->(dbclosearea())
		  endif
		  SET ESCAPE ON
	  ELSEIF c_proc->proc_id $ "_216.0_" .OR. ;
            (c_proc->proc_id $ "_622.0_" .AND. m_linemv->pline_id $ "CNJ_CNK_FL5_DB3" )

		  SET ESCAPE OFF

		  NetUse("D_avmuni",5)

		  @12, 20 CLEAR TO 17, 51
		  DrawBox( 12, 20, 17, 51 )

		  @12, 22 SAY "AVG.C & Unif must be entered"

		  @14, 30 SAY "AVG.C  : "GET nAVM PICTURE  "999.999" VALID !Empty(nAVM)
		  @15, 30 SAY "Unif(%): "GET nUnif PICTURE "99.9"    VALID !Empty(nUnif) .AND. Alert("Are you sure ?",{"Yes","No"}) == 1

		  READ

		  if D_avmuni->(AddRec(5,"insAVG_Uni"))
			  D_avmuni->b_id      := m_linemv->b_id
			  D_avmuni->cp_stage  := m_linemv->cp_stage
			  D_avmuni->cpproc_id := m_linemv->cpproc_id
			  D_avmuni->CP_PCCODE := m_linemv->CP_PCCODE
			  D_avmuni->CPWKSTN_ID  := m_linemv->CPWKSTN_ID
			  D_avmuni->PTYPE_ID  := m_linemv->PTYPE_ID
			  D_avmuni->PLINE_ID  := m_linemv->PLINE_ID
			  D_avmuni->SIZE_ID   := m_linemv->SIZE_ID
			  D_avmuni->VALUE_ID  := m_linemv->VALUE_ID
			  D_avmuni->tol_ID    := m_linemv->tol_ID
			  D_avmuni->volt_ID   := m_linemv->volt_ID
			  D_avmuni->tc_ID     := m_linemv->tc_ID
			  D_avmuni->term_ID   := m_linemv->term_ID
			  D_avmuni->ESN_ID    := m_linemv->ESN_id
			  D_avmuni->ESNXX_ID  := m_linemv->ESNXX_ID
			  D_avmuni->ESNY_ID   := m_linemv->ESNY_ID
			  D_avmuni->DIEL_ID   := m_linemv->DIEL_ID
			  D_avmuni->DIEL_WIDTH := m_linemv->DIEL_WIDTH
			  D_avmuni->CP_BQTYP  := m_linemv->CP_BQTYP
			  D_avmuni->CP_BQTYS  := m_linemv->CP_BQTYS
			  D_avmuni->CP_BQTYW  := m_linemv->CP_BQTYW
		     D_avmuni->avg_c_avm := nAVM
			  D_avmuni->unif      := nUnif
		     D_avmuni->(dbclosearea())
		  endif
		  SET ESCAPE ON
	  ELSEIF (c_proc->proc_id $ "_614.0_" .AND. m_linemv->pline_id $ "CNJ_CNK_FL5_DB3") .OR. ;
            (c_proc->proc_id $ "_412.0_" .AND. m_linemv->pline_id $ "DB1_DB2" .AND. m_linemv->size_id == "0805")



		  SET ESCAPE OFF

		  NetUse("D_avmuni",5)

		  @12, 20 CLEAR TO 17, 51
		  DrawBox( 12, 20, 17, 51 )

		  @12, 22 SAY "CD1 AVG&STD must be entered"

		  @14, 30 SAY "AVG.CD1: " GET nAVM PICTURE  "99.99" VALID !Empty(nAVM)
		  @15, 30 SAY "STD CD1: " GET nUnif PICTURE "9.99"  VALID !Empty(nUnif) .AND. Alert("Are you sure ?",{"Yes","No"}) == 1

		  READ

		  if D_avmuni->(AddRec(5,"insAVG_Uni"))
			  D_avmuni->b_id      := m_linemv->b_id
			  D_avmuni->cp_stage  := m_linemv->cp_stage
			  D_avmuni->cpproc_id := m_linemv->cpproc_id
			  D_avmuni->CP_PCCODE := m_linemv->CP_PCCODE
			  D_avmuni->CPWKSTN_ID  := m_linemv->CPWKSTN_ID
			  D_avmuni->PTYPE_ID  := m_linemv->PTYPE_ID
			  D_avmuni->PLINE_ID  := m_linemv->PLINE_ID
			  D_avmuni->SIZE_ID   := m_linemv->SIZE_ID
			  D_avmuni->VALUE_ID  := m_linemv->VALUE_ID
			  D_avmuni->tol_ID    := m_linemv->tol_ID
			  D_avmuni->volt_ID   := m_linemv->volt_ID
			  D_avmuni->tc_ID     := m_linemv->tc_ID
			  D_avmuni->term_ID   := m_linemv->term_ID
			  D_avmuni->ESN_ID    := m_linemv->ESN_id
			  D_avmuni->ESNXX_ID  := m_linemv->ESNXX_ID
			  D_avmuni->ESNY_ID   := m_linemv->ESNY_ID
			  D_avmuni->DIEL_ID   := m_linemv->DIEL_ID
			  D_avmuni->DIEL_WIDTH := m_linemv->DIEL_WIDTH
			  D_avmuni->CP_BQTYP  := m_linemv->CP_BQTYP
			  D_avmuni->CP_BQTYS  := m_linemv->CP_BQTYS
			  D_avmuni->CP_BQTYW  := m_linemv->CP_BQTYW
		     D_avmuni->AVG_CD1   := nAVM
			  D_avmuni->STD_CD1   := nUnif
		     D_avmuni->(dbclosearea())
		  endif
		  SET ESCAPE ON
	  /*ELSEIF c_proc->proc_id $ "_413.0_" .AND. m_linemv->ptype_id $ "_L_"

		  SET ESCAPE OFF

		  NetUse("D_avmuni",5)

		  @12, 20 CLEAR TO 18, 61
		  DrawBox( 12, 20, 18, 61 )

		  @12, 22 SAY "CD1 AVG&STD Thick AVG must be entered"

		  @14, 30 SAY "Thick AVG: " GET nThick PICTURE  "99.99" VALID !Empty(nThick)
		  @15, 30 SAY "AVG.  CD1: " GET nAVM PICTURE  "99.99" VALID !Empty(nAVM)
		  @16, 30 SAY "STD   CD1: " GET nUnif PICTURE "9.99"  VALID !Empty(nUnif) .AND. Alert("Are you sure ?",{"Yes","No"}) == 1

		  READ

		  if D_avmuni->(AddRec(5,"insAVG_Uni"))
			  D_avmuni->b_id      := m_linemv->b_id
			  D_avmuni->cp_stage  := m_linemv->cp_stage
			  D_avmuni->cpproc_id := m_linemv->cpproc_id
			  D_avmuni->CP_PCCODE := m_linemv->CP_PCCODE
			  D_avmuni->CPWKSTN_ID  := m_linemv->CPWKSTN_ID
			  D_avmuni->PTYPE_ID  := m_linemv->PTYPE_ID
			  D_avmuni->PLINE_ID  := m_linemv->PLINE_ID
			  D_avmuni->SIZE_ID   := m_linemv->SIZE_ID
			  D_avmuni->VALUE_ID  := m_linemv->VALUE_ID
			  D_avmuni->tol_ID    := m_linemv->tol_ID
			  D_avmuni->volt_ID   := m_linemv->volt_ID
			  D_avmuni->tc_ID     := m_linemv->tc_ID
			  D_avmuni->term_ID   := m_linemv->term_ID
			  D_avmuni->ESN_ID    := m_linemv->ESN_id
			  D_avmuni->ESNXX_ID  := m_linemv->ESNXX_ID
			  D_avmuni->ESNY_ID   := m_linemv->ESNY_ID
			  D_avmuni->DIEL_ID   := m_linemv->DIEL_ID
			  D_avmuni->DIEL_WIDTH := m_linemv->DIEL_WIDTH
			  D_avmuni->CP_BQTYP  := m_linemv->CP_BQTYP
			  D_avmuni->CP_BQTYS  := m_linemv->CP_BQTYS
			  D_avmuni->CP_BQTYW  := m_linemv->CP_BQTYW
		     D_avmuni->AVG_CD1   := nAVM
			  D_avmuni->STD_CD1   := nUnif
			  D_avmuni->THICK_AVG := nThick
		     D_avmuni->(dbclosearea())
		  endif
		  SET ESCAPE ON*/

	  ELSEIF (c_proc->proc_id $ "_621.0_" .AND. m_linemv->pline_id $ "CNJ_CNK_FL5_DB3") .OR. ;
            (c_proc->proc_id $ "_416.0_" .AND. m_linemv->pline_id $ "_FL3_FL2_" .AND. m_linemv->size_id == "0603") .OR. ;
            (c_proc->proc_id $ "_511.0_" .AND. m_linemv->pline_id $ "_FL1_FL4_" .AND. m_linemv->size_id == "0805") .OR. ;
				(c_proc->proc_id $ "_655.0_" .AND. m_linemv->pline_id $ "_CNE_")                                       .OR. ;
            (c_proc->proc_id $ "_411.0_" .AND. m_linemv->pline_id $ "_CN1_CN2_CN3_CN4_CN5_CN6_CN7_CN8_CN9_CL1_CL2_CL3_CL4_CL5_CL6_CL7_CL8_CL9")

		  SET ESCAPE OFF

		  NetUse("D_avmuni",5)

		  @12, 20 CLEAR TO 17, 51
		  DrawBox( 12, 20, 17, 51 )

		  @12, 22 SAY "CD2 AVG&STD must be entered"

		  @14, 30 SAY "AVG.CD2: " GET nAVM PICTURE  "99.99" VALID !Empty(nAVM)
		  @15, 30 SAY "STD CD2: " GET nUnif PICTURE "9.99"  VALID !Empty(nUnif) .AND. Alert("Are you sure ?",{"Yes","No"}) == 1

		  READ

		  if D_avmuni->(AddRec(5,"insAVG_Uni"))
			  D_avmuni->b_id      := m_linemv->b_id
			  D_avmuni->cp_stage  := m_linemv->cp_stage
			  D_avmuni->cpproc_id := m_linemv->cpproc_id
			  D_avmuni->CP_PCCODE := m_linemv->CP_PCCODE
			  D_avmuni->CPWKSTN_ID  := m_linemv->CPWKSTN_ID
			  D_avmuni->PTYPE_ID  := m_linemv->PTYPE_ID
			  D_avmuni->PLINE_ID  := m_linemv->PLINE_ID
			  D_avmuni->SIZE_ID   := m_linemv->SIZE_ID
			  D_avmuni->VALUE_ID  := m_linemv->VALUE_ID
			  D_avmuni->tol_ID    := m_linemv->tol_ID
			  D_avmuni->volt_ID   := m_linemv->volt_ID
			  D_avmuni->tc_ID     := m_linemv->tc_ID
			  D_avmuni->term_ID   := m_linemv->term_ID
			  D_avmuni->ESN_ID    := m_linemv->ESN_id
			  D_avmuni->ESNXX_ID  := m_linemv->ESNXX_ID
			  D_avmuni->ESNY_ID   := m_linemv->ESNY_ID
			  D_avmuni->DIEL_ID   := m_linemv->DIEL_ID
			  D_avmuni->DIEL_WIDTH := m_linemv->DIEL_WIDTH
			  D_avmuni->CP_BQTYP  := m_linemv->CP_BQTYP
			  D_avmuni->CP_BQTYS  := m_linemv->CP_BQTYS
			  D_avmuni->CP_BQTYW  := m_linemv->CP_BQTYW
		     D_avmuni->AVG_CD2   := nAVM
			  D_avmuni->STD_CD2   := nUnif
		     D_avmuni->(dbclosearea())
		  endif
		  SET ESCAPE ON
	  ELSEIF (c_proc->proc_id $ "_654.0_" .AND. m_linemv->pline_id $ "_CNE_") .OR. ;
		      (c_proc->proc_id $ "_419.0_" .AND. m_linemv->pline_id $ "_CN1_CN2_CN3_CN4_CN5_CN6_CN7_CN8_CN9_CL1_CL2_CL3_CL4_CL5_CL6_CL7_CL8_CL9")

		  SET ESCAPE OFF

		  NetUse("D_avmuni",5)

		  @12, 20 CLEAR TO 17, 51
		  DrawBox( 12, 20, 17, 51 )

		  @12, 22 SAY "CD3 AVG&STD must be entered"

		  @14, 30 SAY "AVG.CD3: " GET nAVM PICTURE  "99.99" VALID !Empty(nAVM)
		  @15, 30 SAY "STD CD3: " GET nUnif PICTURE "9.99"  VALID !Empty(nUnif) .AND. Alert("Are you sure ?",{"Yes","No"}) == 1

		  READ

		  if D_avmuni->(AddRec(5,"insAVG_Uni"))
			  D_avmuni->b_id      := m_linemv->b_id
			  D_avmuni->cp_stage  := m_linemv->cp_stage
			  D_avmuni->cpproc_id := m_linemv->cpproc_id
			  D_avmuni->CP_PCCODE := m_linemv->CP_PCCODE
			  D_avmuni->CPWKSTN_ID  := m_linemv->CPWKSTN_ID
			  D_avmuni->PTYPE_ID  := m_linemv->PTYPE_ID
			  D_avmuni->PLINE_ID  := m_linemv->PLINE_ID
			  D_avmuni->SIZE_ID   := m_linemv->SIZE_ID
			  D_avmuni->VALUE_ID  := m_linemv->VALUE_ID
			  D_avmuni->tol_ID    := m_linemv->tol_ID
			  D_avmuni->volt_ID   := m_linemv->volt_ID
			  D_avmuni->tc_ID     := m_linemv->tc_ID
			  D_avmuni->term_ID   := m_linemv->term_ID
			  D_avmuni->ESN_ID    := m_linemv->ESN_id
			  D_avmuni->ESNXX_ID  := m_linemv->ESNXX_ID
			  D_avmuni->ESNY_ID   := m_linemv->ESNY_ID
			  D_avmuni->DIEL_ID   := m_linemv->DIEL_ID
			  D_avmuni->DIEL_WIDTH := m_linemv->DIEL_WIDTH
			  D_avmuni->CP_BQTYP  := m_linemv->CP_BQTYP
			  D_avmuni->CP_BQTYS  := m_linemv->CP_BQTYS
			  D_avmuni->CP_BQTYW  := m_linemv->CP_BQTYW
		     D_avmuni->AVG_CD3   := nAVM
			  D_avmuni->STD_CD3   := nUnif
		     D_avmuni->(dbclosearea())
		  endif
		  SET ESCAPE ON
	  ELSEIF (c_proc->proc_id $ "_656.0_" .AND. m_linemv->pline_id $ "_CNE_") .OR. ;
		      (c_proc->proc_id $ "_407.0_" .AND. m_linemv->pline_id $ "_CN1_CN2_CN3_CN4_CN5_CN6_CN7_CN8_CN9_CNB_CL1_CL2_CL3_CL4_CL5_CL6_CL7_CL8_CL9_CLB") .OR. ;
			   (c_proc->proc_id $ "_522.0_" .AND. "CV" $ m_linemv->pline_id)

		  SET ESCAPE OFF

		  NetUse("D_avmuni",5)

		  @12, 20 CLEAR TO 21, 51
		  DrawBox( 12, 20, 21, 51 )

		  @12, 22 SAY "Poly via thickness AVG&STD "

        @14, 30 SAY "Point 1 : " GET aPoly[1] PICTURE "99.99" VALID !Empty(aPoly[1])
        @15, 30 SAY "Point 2 : " GET aPoly[2] PICTURE "99.99" VALID !Empty(aPoly[2])
        @16, 30 SAY "Point 3 : " GET aPoly[3] PICTURE "99.99" VALID !Empty(aPoly[3])
        @17, 30 SAY "Point 4 : " GET aPoly[4] PICTURE "99.99" VALID !Empty(aPoly[4])
		  @18, 30 SAY "Point 5 : " GET aPoly[5] PICTURE "99.99" VALID !Empty(aPoly[5])
        @19, 30 SAY "Point 6 : " GET aPoly[6] PICTURE "99.99" VALID !Empty(aPoly[6]) .AND. Alert("Are you sure ?",{"Yes","No"}) == 1

		  READ

		  /////////////////////

		  nAVM  := (aPoly[1]+aPoly[2]+aPoly[3]+aPoly[4]+aPoly[5]+aPoly[6]) / 6

		  aPoly[1] := (aPoly[1] - nAVM)**2
		  aPoly[2] := (aPoly[2] - nAVM)**2
		  aPoly[3] := (aPoly[3] - nAVM)**2
		  aPoly[4] := (aPoly[4] - nAVM)**2
		  aPoly[5] := (aPoly[5] - nAVM)**2
		  aPoly[6] := (aPoly[6] - nAVM)**2

		  nUnif := sqrt(0.1666 * (aPoly[1]  + aPoly[2] + aPoly[3] + aPoly[4] + aPoly[5] + aPoly[6]) )

		  /////////////////////

		  if D_avmuni->(AddRec(5,"insAVG_Uni"))
			  D_avmuni->b_id      := m_linemv->b_id
			  D_avmuni->cp_stage  := m_linemv->cp_stage
			  D_avmuni->cpproc_id := m_linemv->cpproc_id
			  D_avmuni->CP_PCCODE := m_linemv->CP_PCCODE
			  D_avmuni->CPWKSTN_ID:= m_linemv->CPWKSTN_ID
			  D_avmuni->PTYPE_ID  := m_linemv->PTYPE_ID
			  D_avmuni->PLINE_ID  := m_linemv->PLINE_ID
			  D_avmuni->SIZE_ID   := m_linemv->SIZE_ID
			  D_avmuni->VALUE_ID  := m_linemv->VALUE_ID
			  D_avmuni->tol_ID    := m_linemv->tol_ID
			  D_avmuni->volt_ID   := m_linemv->volt_ID
			  D_avmuni->tc_ID     := m_linemv->tc_ID
			  D_avmuni->term_ID   := m_linemv->term_ID
			  D_avmuni->ESN_ID    := m_linemv->ESN_id
			  D_avmuni->ESNXX_ID  := m_linemv->ESNXX_ID
			  D_avmuni->ESNY_ID   := m_linemv->ESNY_ID
			  D_avmuni->DIEL_ID   := m_linemv->DIEL_ID
			  D_avmuni->DIEL_WIDTH := m_linemv->DIEL_WIDTH
			  D_avmuni->CP_BQTYP  := m_linemv->CP_BQTYP
			  D_avmuni->CP_BQTYS  := m_linemv->CP_BQTYS
			  D_avmuni->CP_BQTYW  := m_linemv->CP_BQTYW
		     D_avmuni->POLY_AVG   := nAVM
			  D_avmuni->POLY_STD   := nUnif
		     D_avmuni->(dbclosearea())
		  endif

		  Netuse("c_pline",5)
		  ordsetfocus(1)

		  IF c_pline->(dbseek(m_linemv->pline_id + m_linemv->size_id)) .AND. !Empty(c_pline->h_poly)
			  IF c_pline->h_poly < nAVM .OR. c_pline->l_poly > nAVM

				  /*m_linemv->(dbskip(1))
				  IF m_linemv->( RecLock(5) )
					  m_linemv->cp_bqtyp := 0
					  m_linemv->cp_bqtys := 0
					  m_linemv->cp_bqtyw := 0
					  m_linemv->(dbunlock())
				  ENDIF
				  m_linemv->(dbskip(-1))

				  FOR i := 1 TO m_linemv->( FCOUNT() )
				      AADD( aFields, m_linemv->( FIELDGET(i) ) )
				  NEXT
				  IF m_linemv->( AddRec(5) )
					  FOR i := 1 TO m_linemv->( FCOUNT() )
					      m_linemv->( FIELDPUT(i, aFields[i]) )
					  NEXT
					  c_proc->(dbseek("415.0"))
					  m_linemv->cpproc_id := "415.0"
					  m_linemv->cp_pccode := c_proc->pcprocno
					  m_linemv->cp_stage := m_linemv->cp_stage + 1
					  m_linemv->cpwkstn_id := c_proc->wkstn_id
					  m_linemv->STA := m_linemv->ARR := m_linemv->FIN := FALSE
					  m_linemv->cp_darr := m_linemv->cp_dsta := m_linemv->cp_dfin := CTOD("  /  /  ")
					  m_linemv->cp_tarr := m_linemv->cp_tsta := m_linemv->cp_tfin := "   "
                 m_linemv->cp_widarr := m_linemv->cp_widsta := m_linemv->cp_widfin := "   "
					  m_linemv->(dbunlock())

					  IF d_line->( RecLock(5) )
					       d_line->cpproc_id  := m_linemv->cpproc_id
					       d_line->cp_pccode  := m_linemv->cp_pccode
					       d_line->cpwkstn_id := m_linemv->cpwkstn_id
					       d_line->ExpFinDate := batchCalc3("d_line") //Viatly 19-06-01 16191452
					       d_line->(dbcommit())
					       d_line->( xDbUnLock() )
					  ENDIF
				  ENDIF*/
			  ENDIF
		  ENDIF

		  c_pline->(dbclosearea())


		  SET ESCAPE ON
	  ELSEIF (c_proc->proc_id $ "_640.0_" .AND. m_linemv->pline_id $ "CNJ_CNK_FL5_DB3") .OR. ;
            (c_proc->proc_id $ "_540.0_" .AND. m_linemv->pline_id $ "_FL1_FL4_FL3_FL2_DB1_DB2_")

		  SET ESCAPE OFF

		  NetUse("D_avmuni",5)

		  @12, 20 CLEAR TO 17, 51
		  DrawBox( 12, 20, 17, 51 )

		  @12, 22 SAY "Diel. AVG&Unif must be entered"

		  @14, 30 SAY "Diel.AVG : " GET nAVM PICTURE  "9.99" VALID !Empty(nAVM)
		  @15, 30 SAY "Diel.Unif: " GET nUnif PICTURE "9.9"  VALID !Empty(nUnif) .AND. Alert("Are you sure ?",{"Yes","No"}) == 1

		  READ

		  if D_avmuni->(AddRec(5,"insAVG_Uni"))
			  D_avmuni->b_id      := m_linemv->b_id
			  D_avmuni->cp_stage  := m_linemv->cp_stage
			  D_avmuni->cpproc_id := m_linemv->cpproc_id
			  D_avmuni->CP_PCCODE := m_linemv->CP_PCCODE
			  D_avmuni->CPWKSTN_ID:= m_linemv->CPWKSTN_ID
			  D_avmuni->PTYPE_ID  := m_linemv->PTYPE_ID
			  D_avmuni->PLINE_ID  := m_linemv->PLINE_ID
			  D_avmuni->SIZE_ID   := m_linemv->SIZE_ID
			  D_avmuni->VALUE_ID  := m_linemv->VALUE_ID
			  D_avmuni->tol_ID    := m_linemv->tol_ID
			  D_avmuni->volt_ID   := m_linemv->volt_ID
			  D_avmuni->tc_ID     := m_linemv->tc_ID
			  D_avmuni->term_ID   := m_linemv->term_ID
			  D_avmuni->ESN_ID    := m_linemv->ESN_id
			  D_avmuni->ESNXX_ID  := m_linemv->ESNXX_ID
			  D_avmuni->ESNY_ID   := m_linemv->ESNY_ID
			  D_avmuni->DIEL_ID   := m_linemv->DIEL_ID
			  D_avmuni->DIEL_WIDTH := m_linemv->DIEL_WIDTH
			  D_avmuni->CP_BQTYP  := m_linemv->CP_BQTYP
			  D_avmuni->CP_BQTYS  := m_linemv->CP_BQTYS
			  D_avmuni->CP_BQTYW  := m_linemv->CP_BQTYW
		     D_avmuni->DI_AVG    := nAVM
			  D_avmuni->DI_UNIF   := nUnif
		     D_avmuni->(dbclosearea())
		  endif
		  SET ESCAPE ON
/*	  ELSEIF c_proc->proc_id $ "_192.0_192.5" .AND. m_linemv->pline_id $ "CNJ_CNK_FL5"

		  SET ESCAPE OFF

		  NetUse("D_avmuni",5)

		  @12, 20 CLEAR TO 18, 51
		  DrawBox( 12, 20, 18, 51 )

		  @12, 22 SAY "Coupling AVG&STD must be entered"

		  @14, 30 SAY "Coup.AVG : " GET nAVM PICTURE  "9.99" VALID !Empty(nAVM)
		  @15, 30 SAY "Coup.STD : " GET nUnif PICTURE "9.9"  VALID !Empty(nUnif)
		  @16, 30 SAY "Frequency: " GET nFreq PICTURE "0000" VALID !Empty(nFreq) .AND. Alert("Are you sure ?",{"Yes","No"}) == 1

		  READ

		  if D_avmuni->(AddRec(5,"insAVG_Uni"))
			  D_avmuni->b_id      := m_linemv->b_id
			  D_avmuni->cp_stage  := m_linemv->cp_stage
			  D_avmuni->cpproc_id := m_linemv->cpproc_id
			  D_avmuni->CP_PCCODE := m_linemv->CP_PCCODE
			  D_avmuni->CPWKSTN_ID  := m_linemv->CPWKSTN_ID
			  D_avmuni->PTYPE_ID  := m_linemv->PTYPE_ID
			  D_avmuni->PLINE_ID  := m_linemv->PLINE_ID
			  D_avmuni->SIZE_ID   := m_linemv->SIZE_ID
			  D_avmuni->VALUE_ID  := m_linemv->VALUE_ID
			  D_avmuni->tol_ID    := m_linemv->tol_ID
			  D_avmuni->volt_ID   := m_linemv->volt_ID
			  D_avmuni->tc_ID     := m_linemv->tc_ID
			  D_avmuni->term_ID   := m_linemv->term_ID
			  D_avmuni->ESN_ID    := m_linemv->ESN_id
			  D_avmuni->ESNXX_ID  := m_linemv->ESNXX_ID
			  D_avmuni->ESNY_ID   := m_linemv->ESNY_ID
			  D_avmuni->DIEL_ID   := m_linemv->DIEL_ID
			  D_avmuni->DIEL_WIDTH := m_linemv->DIEL_WIDTH
			  D_avmuni->CP_BQTYP   := m_linemv->CP_BQTYP
			  D_avmuni->CP_BQTYS   := m_linemv->CP_BQTYS
			  D_avmuni->CP_BQTYW   := m_linemv->CP_BQTYW
		     D_avmuni->COUP_AVG   := nAVM
			  D_avmuni->COUP_STD   := nUnif
			  D_avmuni->FREQ       := nFreq
		     D_avmuni->(dbclosearea())
		  endif
		  SET ESCAPE ON
*/
	  ELSEIF (c_proc->proc_id $ "_190.0_190.5" .AND. m_linemv->pline_id $ "CNJ_CNK_CNE_CN1_CN2_CN3_CN4_CN5_CN6_CN7_CN8_CN9_CL1_CL2_CL3_CL4_CL5_CL6_CL7_CL8_CL9")

		  SET ESCAPE OFF

		  NetUse("D_avmuni",5)

		  @12, 20 CLEAR TO 20, 51
		  DrawBox( 12, 20, 20, 51 )

		  @12, 22 SAY "Coupling must be entered"

		  @14, 30 SAY "Coup.F 1 : " GET aCoup[1] PICTURE "99.99" VALID !Empty(aCoup[1])
		  @15, 30 SAY "Coup.F 2 : " GET aCoup[2] PICTURE "99.99" VALID !Empty(aCoup[2])
		  @16, 30 SAY "Coup.F 3 : " GET aCoup[3] PICTURE "99.99" VALID !Empty(aCoup[3])
		  @17, 30 SAY "Coup.F 4 : " GET aCoup[4] PICTURE "99.99" VALID !Empty(aCoup[4])
		  @18, 30 SAY "Coup.F 5 : " GET aCoup[5] PICTURE "99.99" VALID !Empty(aCoup[5]) .AND. Alert("Are you sure ?",{"Yes","No"}) == 1

		  READ

		  if D_avmuni->(AddRec(5,"insAVG_Uni"))
			  D_avmuni->b_id      := m_linemv->b_id
			  D_avmuni->cp_stage  := m_linemv->cp_stage
			  D_avmuni->cpproc_id := m_linemv->cpproc_id
			  D_avmuni->CP_PCCODE := m_linemv->CP_PCCODE
			  D_avmuni->CPWKSTN_ID  := m_linemv->CPWKSTN_ID
			  D_avmuni->PTYPE_ID  := m_linemv->PTYPE_ID
			  D_avmuni->PLINE_ID  := m_linemv->PLINE_ID
			  D_avmuni->SIZE_ID   := m_linemv->SIZE_ID
			  D_avmuni->VALUE_ID  := m_linemv->VALUE_ID
			  D_avmuni->tol_ID    := m_linemv->tol_ID
			  D_avmuni->volt_ID   := m_linemv->volt_ID
			  D_avmuni->tc_ID     := m_linemv->tc_ID
			  D_avmuni->term_ID   := m_linemv->term_ID
			  D_avmuni->ESN_ID    := m_linemv->ESN_id
			  D_avmuni->ESNXX_ID  := m_linemv->ESNXX_ID
			  D_avmuni->ESNY_ID   := m_linemv->ESNY_ID
			  D_avmuni->DIEL_ID   := m_linemv->DIEL_ID
			  D_avmuni->DIEL_WIDTH := m_linemv->DIEL_WIDTH
			  D_avmuni->CP_BQTYP   := m_linemv->CP_BQTYP
			  D_avmuni->CP_BQTYS   := m_linemv->CP_BQTYS
			  D_avmuni->CP_BQTYW   := m_linemv->CP_BQTYW
		     D_avmuni->COUP_F1    := aCoup[1]
			  D_avmuni->COUP_F2    := aCoup[2]
			  D_avmuni->COUP_F3    := aCoup[3]
			  D_avmuni->COUP_F4    := aCoup[4]
			  D_avmuni->COUP_F5    := aCoup[5]
		     D_avmuni->(dbclosearea())
		  endif
		  SET ESCAPE ON
	  /*ELSEIF (c_proc->proc_id $ "_190.0_190.5" .AND. m_linemv->pline_id $ "_FL5_")

		  SET ESCAPE OFF

		  NetUse("D_avmuni",5)

		  @12, 20 CLEAR TO 20, 51
		  DrawBox( 12, 20, 20, 51 )

		  @12, 22 SAY "Freq.Response must be entered"

		  @14, 30 SAY "Freq.F 1 : " GET aCoup[1] PICTURE "99.99" VALID !Empty(aCoup[1])
		  @15, 30 SAY "Freq.F 2 : " GET aCoup[2] PICTURE "99.99" VALID !Empty(aCoup[2])
		  @16, 30 SAY "Freq.F 3 : " GET aCoup[3] PICTURE "99.99" VALID !Empty(aCoup[3])
		  @17, 30 SAY "Freq.F 4 : " GET aCoup[4] PICTURE "99.99" VALID !Empty(aCoup[4])
		  @18, 30 SAY "Freq.F 5 : " GET aCoup[5] PICTURE "99.99" VALID !Empty(aCoup[5]) .AND. Alert("Are you sure ?",{"Yes","No"}) == 1

		  READ

		  if D_avmuni->(AddRec(5,"insAVG_Uni"))
			  D_avmuni->b_id      := m_linemv->b_id
			  D_avmuni->cp_stage  := m_linemv->cp_stage
			  D_avmuni->cpproc_id := m_linemv->cpproc_id
			  D_avmuni->CP_PCCODE := m_linemv->CP_PCCODE
			  D_avmuni->CPWKSTN_ID  := m_linemv->CPWKSTN_ID
			  D_avmuni->PTYPE_ID  := m_linemv->PTYPE_ID
			  D_avmuni->PLINE_ID  := m_linemv->PLINE_ID
			  D_avmuni->SIZE_ID   := m_linemv->SIZE_ID
			  D_avmuni->VALUE_ID  := m_linemv->VALUE_ID
			  D_avmuni->tol_ID    := m_linemv->tol_ID
			  D_avmuni->volt_ID   := m_linemv->volt_ID
			  D_avmuni->tc_ID     := m_linemv->tc_ID
			  D_avmuni->term_ID   := m_linemv->term_ID
			  D_avmuni->ESN_ID    := m_linemv->ESN_id
			  D_avmuni->ESNXX_ID  := m_linemv->ESNXX_ID
			  D_avmuni->ESNY_ID   := m_linemv->ESNY_ID
			  D_avmuni->DIEL_ID   := m_linemv->DIEL_ID
			  D_avmuni->DIEL_WIDTH := m_linemv->DIEL_WIDTH
			  D_avmuni->CP_BQTYP   := m_linemv->CP_BQTYP
			  D_avmuni->CP_BQTYS   := m_linemv->CP_BQTYS
			  D_avmuni->CP_BQTYW   := m_linemv->CP_BQTYW
		     D_avmuni->COUP_F1    := aCoup[1]
			  D_avmuni->COUP_F2    := aCoup[2]
			  D_avmuni->COUP_F3    := aCoup[3]
			  D_avmuni->COUP_F4    := aCoup[4]
			  D_avmuni->COUP_F5    := aCoup[5]
		     D_avmuni->(dbclosearea())
		  endif
		  SET ESCAPE ON*/


	  ENDIF

	  IF lDT
		  @12, 20 CLEAR TO 17, 55
		  DrawBox( 12, 20, 17, 55 )

		  @12, 22 SAY "High & Low values must be entered"

		  @14, 30 SAY "High   : " GET HVal_DT PICTURE  "9999.999" VALID !Empty(HVal_DT)
		  @15, 30 SAY "Low    : " GET LVal_DT PICTURE  "9999.999" VALID LVal_DT <= HVal_DT

		  READ

		  if d_line->( RecLock(5) )
		     d_line->HVal_dt := HVal_DT
		     d_line->LVal_dt := LVal_DT
		     d_line->( DbUnLock() )
		  endif
	  ENDIF


	  m_linemv->( DbUnLock() )
     d_irrfin->( DbCloseArea() )
     d_rejrep->( DbCloseArea() )
	  m_bstamv->( DbCloseArea() )
	  d_stock->( DbCloseArea() )

ENDIF

RETURN

FUNCTION barCanUpdate
LOCAL nCounter := 0

IF d_line->( RecLock(5) )
     nCounter++                                  // 1
ENDIF

IF m_linemv->( RecLock(5) )
     nCounter++                                  // 2
ENDIF

IF len(genopenfiles({"d_irrfin"})) > 0
     nCounter++                                  // 3
ENDIF

IF len(genopenfiles({"d_rejrep"})) > 0
     nCounter++                                  // 4
ENDIF

IF len(genopenfiles({"m_bstamv"})) > 0
     nCounter++                                  // 5
ENDIF

IF len(genopenfiles({"d_stock"})) > 0
     nCounter++                                  // 6
ENDIF


RETURN (nCounter = 6)


PROCEDURE FinishUpdate
LOCAL nLen , i
LOCAL aWorkList
LOCAL aCodeList
LOCAL lStat := FALSE

DO CASE
     CASE c_proc->scr2 = "F6"
          aWorkList := {;
          nTolZP,nTolXP,nTolPP,nTolQP,nTolAP,nTolBP,nTolCP,nTolDP,nTolFP,nTolGP,nTolJP,;
          nTolZL,nTolXL,nTolPL,nTolQL,nTolAL,nTolBL,nTolCL,nTolDL,nTolFL,nTolGL,nTolJL,;
          nTolRL,nScrap_Q,nScrap_Flash,nScrap_Res       }
          aCodeList := {;
                       "ZP", "XP","PP", "QP", "AP", "BP", "CP", "DP", "FP", "GP", "JP" ,;
                       "ZL", "XL","PL", "QL", "AL", "BL", "CL", "DL", "FL", "GL", "JL" ,;
                       "RL", "QR","FL", "RR";
                       }
     CASE c_proc->scr2 = "F7"
          aWorkList := { nGoodPacked , nGoodLoose }
          aCodeList := { " P" , " L" }
     CASE c_proc->scr2 = "F8"
          aWorkList := { nRange2, nRange3, nRange4, nRange5,;
               nRange6, nRange7, nRange8, nRange9;
               }
          aCodeList := { "1L" , "2L" , "3L" , "4L" , "5L" ,;
               "6L" , "7L" , "8L" , "9L" }
     OTHERWISE
          Alert( "Error:" + c_proc->scr2 +" not valid in c_proc->scr2" , {"..."} )
ENDCASE

nLen := Len( aWorkList )
FOR i := 1 TO nLen

     IF aWorkList[i] != 0 .AND. d_irrfin->( AddRec(5) )

          d_irrfin->b_id      := m_linemv->b_id
          d_irrfin->cp_stage  := m_linemv->cp_stage
          d_irrfin->cpproc_id := m_linemv->cpproc_id
          d_irrfin->rep_unit  := IIF(i>23 ,aCodeList[i] ,Left(aCodeList[i],1) ) // unit

          IF Right( aCodeList[i],1) == "P"
               d_irrfin->qty_reel  := aWorkList[i]
               d_irrfin->qty_loose := 0
          ELSE
               d_irrfin->qty_loose := aWorkList[i]
               d_irrfin->qty_reel  := 0
          ENDIF
			 IF "198" $ m_linemv->cpproc_id    .AND. ;
				 m_linemv->b_purp == "6"        .AND. ;
				 d_stock->( AddRec(5,"WH_KIT") )
				 d_stock->b_id         := m_linemv->b_id
				 d_stock->b_type       := m_linemv->b_type
				 d_stock->esn_id       := m_linemv->esn_id
				 d_stock->esnxx_id     := m_linemv->esnxx_id
				 d_stock->esny_id      := m_linemv->esny_id
				 d_stock->ptype_id     := m_linemv->ptype_id
				 d_stock->pline_id     := m_linemv->pline_id
				 d_stock->size_id      := m_linemv->size_id
				 d_stock->value_id     := m_linemv->value_id
				 d_stock->volt_id      := m_linemv->volt_id
				 d_stock->tc_id        := m_linemv->tc_id
				 d_stock->tol_id       := d_irrfin->rep_unit
				 IF !Empty(d_irrfin->rep_unit)
					 d_stock->seq_no       := CurrentLevel(m_linemv->ptype_id+d_irrfin->rep_unit)
				 ENDIF
				 d_stock->wh7          := d_irrfin->qty_loose
				 d_stock->term_id      := m_linemv->term_id
				 d_stock->b_ncaps      := m_linemv->b_ncaps
				 d_stock->diel_id      := m_linemv->diel_id
				 d_stock->diel_width   := m_linemv->diel_width
				 d_stock->diel_id      := m_linemv->diel_id
				 d_stock->loc          := IIF(".5" $ m_linemv->cpproc_id,"CZ" ,"IL" )
				 d_stock->(dbunlock())

				 NetUse("n_refno",5)

				 IF n_refno->( RecLock( 5 ) )
				    n_refno->counter++
				    SetRefCounter( n_refno->counter )
				    n_refno->(dbclosearea())
				 ENDIF
				 NetUse("n_serno",5)
				 NetUse("m_stkmv",5)
				 UpdateMovements("11",IncSerNo(),"Entry to Kit WH's",,0,d_irrfin->qty_loose,"0","7","LIQUID")
				 n_serno->(dbclosearea())
				 m_stkmv->(dbclosearea())

			 ENDIF

			 IF !lStat                          .AND. ;
			 	 "198" $ m_linemv->cpproc_id     .AND. ;
				 m_linemv->b_purp == "6"         .AND. ;
			 	 d_line->( RecLock(5,"WH_KIT") ) .AND. ;
				 m_bstamv->( AddRec(5,"WH_KIT") )
				 m_bstamv->B_id     := d_line->b_id
				 m_bstamv->Esn_id   := d_line->esn_id
				 m_bstamv->B_purp   := d_line->B_purp
				 m_bstamv->Ptype_id := d_line->Ptype_id
				 m_bstamv->Pline_id := d_line->Pline_id
				 m_bstamv->Size_id  := d_line->Size_id
				 m_bstamv->Value_id := d_line->Value_id
				 m_bstamv->Volt_id  := d_line->Volt_id
				 m_bstamv->Tol_id   := d_line->Tol_id
				 m_bstamv->Tc_id    := d_line->Tc_id
				 m_bstamv->Term_id  := d_line->Term_id
				 m_bstamv->Esnxx_id := d_line->Esnxx_id
				 m_bstamv->Esny_id  := d_line->Esny_id
				 m_bstamv->B_prior  := D_line->B_prior
				 m_bstamv->cb_stat  := D_line->B_stat
				 m_bstamv->nb_stat  := "C"
				 m_bstamv->cp_bqtyp  := d_line->cp_bqtyp
				 m_bstamv->cp_bqtyw  := d_line->cp_bqtyw
				 m_bstamv->cp_bqtys  := d_line->cp_bqtys
				 m_bstamv->cpproc_id := d_line->cpproc_id
				 m_bstamv->cp_pccode := d_line->cp_pccode
				 m_bstamv->cpwkstn_id:= d_line->cpwkstn_id
				 m_bstamv->dadd_rec  := d_line->dadd_rec
				 m_bstamv->(dbunlock())
				 d_line->b_stat := "C"
				 lStat := TRUE
				 d_line->(xdbunlock())
			 ENDIF

     ENDIF

NEXT

RETURN

Static Function CurrentLevel(cFam)
local nOldArea := Select()
local cRetVal := "  "
NetUse("c_tol",5)
ordsetfocus("c_ptol")
if c_tol->(dbseek(cFam))
   cRetVal := c_tol->seq_no
endif
c_tol->(dbclosearea())
dbselectarea(nOldArea)
Return cRetVal


PROCEDURE ScrapUpdate()

LOCAL nLen , i
LOCAL aWorkList
LOCAL cTempRej
LOCAL nTotRejQty := 0

DEFAULT nRejected to 0

// do not forget to handle 999 automatic rejection
DO CASE
     CASE c_proc->scr2 = "F6" .AND. Len( aRegularRej ) > 0
			 aWorkList    := aRegularRej
          cCode1Rej    := aRegularRej[1,4]
          cDoch1Eatama := aRegularRej[1,2]
     CASE c_proc->scr2 = "F7"
          aWorkList := { {cNote1 , cDoch1Eatama, , cCode1Rej, nValueR , "  ",.F.} }
     CASE c_proc->scr2 = "F8"
          aWorkList := { {cNote1 , cDoch1Eatama, , cCode1Rej, nRange1 , " 1",.F.},;
                         {cNote2 , cDoch2Eatama, , cCode2Rej, nRange10, "10",.F.};
                       }
     OTHERWISE
          DEFAULT aRegularRej TO {}

          aWorkList := aRegularRej

          IF Len( aRegularRej ) > 0
               cCode1Rej    := aRegularRej[1,4]
               cDoch1Eatama := aRegularRej[1,2]
          ELSE
               cCode1Rej    := "    "
               cDoch1Eatama := "      "
          ENDIF
ENDCASE

nLen := Len( aWorkList )

FOR i := 1 TO nLen
     IF (aWorkList[i,5] != 0 .OR. (aWorkList[i,5] == 0 .AND. aWorkList[i,7]) ) .AND. d_rejrep->( AddRec(5) )

          IF ValType( aWorkList[i,6] ) == "N"
               cTempRej := Str( aWorkList[i,6] , 2 )
               nTotRejQty += IIF(aWorkList[i,7] ,0,aWorkList[i,5] )
          ELSE
               cTempRej := aWorkList[i,6]
          ENDIF

          d_rejrep->b_id       := m_linemv->b_id
          d_rejrep->cp_stage   := m_linemv->cp_stage
          d_rejrep->cpproc_id  := m_linemv->cpproc_id
          d_rejrep->rej_unit   := cTempRej
			 IF aWorkList[i,7]//VR 412-->09.06.04
				 d_rejrep->qty_nonrej := aWorkList[i,5]
			 ELSE
				 d_rejrep->qty_rej    := aWorkList[i,5]
			 ENDIF
          d_rejrep->rej_id     := aWorkList[i,4]
          d_rejrep->discr_rep  := aWorkList[i,2]
          d_rejrep->rej_com    := aWorkList[i,1]
			 d_rejrep->w_id       := mCP_WIDSTA

     ENDIF
NEXT

// create automatic rejection for regular rejections if any
nM999Rejected := (nRejected - nTotRejQty)

// automatic rejection
IF nM999Rejected > 0 .AND. c_proc->scr2 <> "F6"
     IF d_rejrep->( AddRec(5) )
          d_rejrep->b_id       := m_linemv->b_id
          d_rejrep->cp_stage   := m_linemv->cp_stage
          d_rejrep->cpproc_id  := m_linemv->cpproc_id
          d_rejrep->rej_unit   := "99"
          d_rejrep->qty_rej    := nM999Rejected
          d_rejrep->rej_id     := "M999"
          d_rejrep->discr_rep  := ""
          d_rejrep->rej_com    := "š‰ˆ…ˆ…€ „Œ‰‘”"
			 d_rejrep->w_id       := mCP_WIDSTA
          GetUserInfo():updateUserInRec( "d_rejrep" , "BMSBAR2",.T. )

     ELSE
          Alert( "can not append automatic rejection M999" , {"..."} )
     ENDIF
ELSEIF nM999Rejected = 0
     // no automatic rejection
ELSEIF nM999Rejected > 0 .AND. c_proc->scr2 == "F6"
	  // no automatic rejection
ELSE
     Alert( "Rejection Calculated:"+Ltrim(Transform(nRejected,"99,999,999"))+"   Entered:"+Ltrim(Transform(nTotRejQty,"99,999,999")),{"..."})
ENDIF


aRegularRej := {}
RETURN


PROCEDURE LineMovUpdate( cWIDFIN,lFromF6 )               // 3
LOCAL cCpTfin := Left( Time() , 5 ),i
local cProc,cOpt := "Yes"

LOCAL nPQtyw
LOCAL nPQtys
LOCAL nPQtyp
local aProcs := {"217.0","217.1","217.2","217.3","217.4"}

LOCAL cScr := SAVESCREEN()

default lFromF6 to FALSE
// current proc
IF m_linemv->cpproc_id $ "_215.0_" .AND. m_linemv->ptype_id $ "_C_"

	@9,21 CLEAR TO 16, 70
	DrawBox( 9,21,16,70,FRAMECAPTION+" ")
	@ 09 , 22 SAY " Did AVM Measurements passed successfully? " COLOR "w+/g"

	@ 10, 23 GET cOpt RADIO {"Yes","AVM Y","AVM X","AVM Z","AVM Y,Z","AVM X,Z"}

	READ

	IF cOpt ==  "Yes"
		cProc := "215.0"
	ELSEIF cOpt ==  "AVM Y"
		cProc := "217.0"
	ELSEIF cOpt ==  "AVM X"
		cProc := "217.1"
	ELSEIF cOpt ==  "AVM Z"
		cProc := "217.2"
   ELSEIF cOpt ==  "AVM Y,Z"
		cProc := "217.3"
	ELSE
		cProc := "217.4"
	ENDIF

	IF cProc <> "215.0"
	  Add2Lmv(str(m_linemv->cp_stage + 1,4) ,cProc,"R",m_linemv->ROUTE_ID,m_linemv->proc_spec)
	  Add2Lmv(str(m_linemv->cp_stage + 3,4) ,"215.0","R",m_linemv->ROUTE_ID,m_linemv->proc_spec)
	ENDIF
ENDIF



// m_linemv update
IF m_linemv->( REcLock(5) )

     NewQtyWSP( @nPQtyw,@nPQtys,@nPQtyp )

     m_linemv->fin         := .T.
     m_linemv->cp_dfin     := Date()
     m_linemv->cp_tfin     := cCpTfin
     m_linemv->cp_widfin   := cWIDFIN

     m_linemv->cp_totscr   := nRejected
	  IF lFromf6
		  m_linemv->cp_totscr := m_linemv->cp_totscr + ;
		                         nScrap_Q + nScrap_Flash + nScrap_Res + NTOLRL
	  ENDIF
     m_linemv->b_lrej      := cCode1Rej
     m_linemv->discr_rep   := cDoch1Eatama
     GetUserInfo():updateUserInRec("m_linemv","BMSBAR2",.F.)


     m_linemv->( DbUnLock() )

ENDIF
// d_line update
IF d_line->( RecLock(5) )
     d_line->ppproc_id  := m_linemv->cpproc_id
     d_line->pp_pccode  := m_linemv->cp_pccode
     d_line->pp_wkstn   := m_linemv->cpwkstn_id
     d_line->pp_darr    := m_linemv->cp_darr
     d_line->pp_tarr    := m_linemv->cp_tarr
     d_line->pp_dsta    := m_linemv->cp_dsta
     d_line->pp_tsta    := m_linemv->cp_tsta
     d_line->pp_dfin    := m_linemv->cp_dfin
     d_line->pp_tfin    := m_linemv->cp_tfin
     d_line->pp_widfin  := m_linemv->cp_widfin
     d_line->pp_bqtyw   := m_linemv->cp_bqtyw
     d_line->pp_bqtys   := m_linemv->cp_bqtys
     d_line->pp_bqtyp   := m_linemv->cp_bqtyp

     d_line->pp_totscr   := nRejected
     d_line->b_lrej      := cCode1Rej
     d_line->discr_rep   := cDoch1Eatama

     IF c_proc->uom_id = "P"
          d_line->qty_bscr  += nRejected
     ELSE
          d_line->qty_bscr  += QtyConvert( nRejected , d_line->b_type , m_linemv->pline_id, m_linemv->size_id , c_proc->uom_id , "P" ,,,m_linemv->route_id,m_linemv->value_id)
     ENDIF

     GetUserInfo():updateUserInRec("d_line","BMSBAR2",.F.)

     d_line->( xDbUnLock() )
ENDIF

m_linemv->( DbSkip() )
IF d_line->b_id<>m_linemv->b_id                  // Corrected by David L. 19/10/97
     m_linemv->( DbSkip(-1) )
ELSE
     IF m_linemv->( RecLock(5) )
          m_linemv->cp_bqtyw    := nPqtyw
          m_linemv->cp_bqtys    := nPqtys
          m_linemv->cp_bqtyp    := nPqtyp
          m_linemv->( DbUnLock() )
     ENDIF
ENDIF

// d_line update current proc based on new stage in m_linemv

IF d_line->( RecLock(5) )
     d_line->cpproc_id  := m_linemv->cpproc_id
     d_line->cp_pccode  := m_linemv->cp_pccode
     d_line->cpwkstn_id := m_linemv->cpwkstn_id
     d_line->cp_dsta    := CTOD("  /  /  ") // Vitaly 27-03-01 00072403
     d_line->cp_tsta    := "      "
     d_line->cp_widsta  := "      "
     d_line->cp_darr    := CTOD("  /  /  ") // edomo 13-05-01 00072403
     d_line->cp_tarr    := ""               // edomo 13-05-01 00072403
     d_line->cp_widarr  := "      "         //edomo 02-05-01 00072403
     d_line->cp_bqtyw   := m_linemv->cp_bqtyw
     d_line->cp_bqtys   := m_linemv->cp_bqtys
     d_line->cp_bqtyp   := m_linemv->cp_bqtyp
     d_line->ExpFinDate := batchCalc3("d_line") //Viatly 19-06-01 16191452
     d_line->(dbcommit())
     d_line->( xDbUnLock() )
ENDIF

m_linemv->( DbSkip( -1 ) )                       // return to current proc
RESTSCREEN(,,,,cScr)

RETURN

STATIC FUNCTION Add2Lmv(cStage,cProc,cMovType,cRoute,cProcSpec)

LOCAL aFields := {}, cWip
LOCAL cWipDir:= GetUserInfo():cWipCostDir
LOCAL i, cBid, nI1, nI2, nI3, lProcExists := .F.
LOCAL cDbf := "m_linemv"
LOCAL nRec := m_linemv->(recno())
LOCAL aEmpties := ;
 {"ARR","CP_DARR","CP_TARR","CP_WIDSTA","STA","CP_DSTA","CP_TSTA","CP_WIDSTA",;
  "FIN","CP_DFIN","CP_TFIN","CP_WIDFIN","PROC_SPEC","I1","I2","I3",;
  "CP_BQTYP","CP_BQTYS","CP_BQTYW","CP_TOTSCR","B_LREJ","DISCR_REP","CP_ADJSCR"}

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

m_linemv->(dbgoto(nRec))

RETURN NIL


PROCEDURE NewQtyWSP(nW , nS , nP)
LOCAL aMust := { c_proc->must_w,c_proc->must_s,c_proc->must_p }
LOCAL i

nW := nS := nP := 0

FOR i :=1 TO 3
     DO CASE
          CASE aMust[i]                          // this qty entered by operator since they must
               DO CASE
                    CASE i = 1                   // W
                         nW := nQtyW
                    CASE i = 2                   // S
                         nS := nQtyS
                    CASE i = 3                   // P
                         nP := nQtyP
               ENDCASE
          OTHERWISE
               DO CASE                           //  this qtys calculated dependin c_proc->uom_id because the not must
                    CASE i = 1                   // W
                         nW := QtyConvert( SetOrigQty() ,;
                              d_line->b_type, m_linemv->pline_id,;
                              m_linemv->size_id,;
                              c_proc->uom_id , "W",,,m_linemv->route_id ,m_linemv->value_id)
                    CASE i = 2                   // S
                         nS := QtyConvert( SetOrigQty() ,;
                              d_line->b_type, m_linemv->pline_id,;
                              m_linemv->size_id,;
                              c_proc->uom_id , "S",,,m_linemv->route_id,m_linemv->value_id )
                    CASE i = 3                   // P
                         nP := QtyConvert( SetOrigQty() ,;
                              d_line->b_type, m_linemv->pline_id,;
                              m_linemv->size_id,;
                              c_proc->uom_id , "P",,,m_linemv->route_id,m_linemv->value_id )
               ENDCASE
     ENDCASE
NEXT

RETURN


STATIC FUNCTION SetOrigQty
LOCAL nQty := 0

DO CASE
     CASE c_proc->uom_id == "W"
          nQty := nQtyW
     CASE c_proc->uom_id == "S"
          nQty := nQtyS
     CASE c_proc->uom_id == "P"
          nQty := nQtyP
     OTHERWISE
          Alert( "Bad data in c_proc->uom_id :" + c_proc->uom_id +"( C_PROC rec no:" + Ltrim(Str( c_proc->(RecNo())))+")" , {"..."} )
ENDCASE

RETURN nQty

FUNCTION IsEndOfBatch
RETURN lEndOfBatch

FUNCTION GetEndType
RETURN cEndType

PROCEDURE SetRejEob( lValue )
lRejEob := lValue
RETURN

FUNCTION SetRejected( nValue )
nRejected := nValue
IF LastKey() = K_ESC
     aRegularRej := {}
ENDIF
RETURN LastKey() = K_F5

FUNCTION GetBNWid
RETURN {mB_ID,mCP_WIDSTA}

FUNCTION GetRegularRej
RETURN aRegularRej

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: ShalInitVars()        Docs: Shalom LeVine                  ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 09-17-96              Date updated: ş09-17-96              ³
 * ³ Time created: 09:49:40pm            Time updated: ş09:49:40pm            ³
 * ³    Copyright: Shalom LeVine                                              ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: ShalInitVars()                                             ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION ShalInitVars()
// Qty. of the UOM at current process becomes zero in the GET:
// If the PREV_QTY flag is zero. This forces user to type qty.
// As requested by TAPI 31-07-97

nQtyW := IF( c_proc->UOM_ID="W" .AND. c_proc->EOP_QTYDEF="0", 0 ,m_linemv->cp_bqtyw )
nQtyS := IF( c_proc->UOM_ID="S" .AND. c_proc->EOP_QTYDEF="0", 0 ,m_linemv->cp_bqtys )
nQtyP := IF( c_proc->UOM_ID="P" .AND. c_proc->EOP_QTYDEF="0", 0 ,m_linemv->cp_bqtyp )


RETURN NIL

STATIC FUNCTION ChkRej(nScrap,nIndex)


LOCAl nTheoqty, nTempQty
// The qty is always pieces in this stage
// This function checks if the scrap is bigger than 5% or 30% of the
// previous movement's pcs. or initial qty (the smallest). If so then
// it will enable rej code input. D.Laor Id.99072209
IF d_line->uom_ini="P"
     nTheoqty := d_line->qty_bini
ELSE
     nTheoqty := QtyConvert( d_line->qty_bini , m_linemv->b_type , m_linemv->pline_id, m_linemv->size_id  , d_line->uom_ini , "P" ,,,m_linemv->route_id,m_linemv->value_id)
ENDIF
IF ! d_line->b_purp  $ "5_8_2_6_T"
	IF Empty(nIndex)
      nTempQty := MIN(m_linemv->cp_bqtyp * 1.05, nTheoqty)
      RETURN( IF( nScrap > nTempQty * 0.05, .T. , .F. ) )
	ELSEIF ValType(nIndex) == "N"
	    IF (nIndex == SCRAP_TOL   .AND. d_line->ptype_id == "C") .OR. ;
          (nIndex == SCRAP_FLASH .AND. d_line->ptype_id == "C") .OR. ;
			  nIndex == 5//NoDescr
           nTempQty := MIN(m_linemv->cp_bqtyp, nTheoqty)
		     //RETURN( IF( nScrap > nTempQty * 0.05, .T. , .F. ) )
			  RETURN( IF( nScrap>m_linemv->cp_bqtyp * (1 - GetClstrFactor()) .AND. ;
					  		(m_linemv->cp_bqtyp - nScrap) / m_linemv->cp_bqtyp > 0.01, .T. , .F. ) )
		 ELSEIF (nIndex == SCRAP_TOL .AND. d_line->ptype_id == "L")
	        nTempQty := MIN(m_linemv->cp_bqtyp, nTheoqty)
           RETURN( IF( nScrap > nTempQty * 0.01, .T. , .F. ) )
       ELSEIF nIndex == SCRAP_Q .AND. d_line->ptype_id == "C" .AND. d_line->size_id == "0201"
	        nTempQty := MIN(m_linemv->cp_bqtyp, nTheoqty)
           RETURN( IF( nScrap > nTempQty * 0.01, .T. , .F. ) )
       ELSEIF nIndex == SCRAP_Q .AND. d_line->ptype_id == "C" .AND. d_line->size_id == "0402"
	        nTempQty := MIN(m_linemv->cp_bqtyp, nTheoqty)
           RETURN( IF( nScrap > nTempQty * 0.01, .T. , .F. ) )
       ELSEIF (nIndex == SCRAP_Q .AND. d_line->ptype_id == "U") .OR.   ;
              (nIndex == SCRAP_RES .AND. d_line->ptype_id $ "_F_U_T_")
	        nTempQty := MIN(m_linemv->cp_bqtyp, nTheoqty)
           RETURN( IF( nScrap > nTempQty * 0.01, .T. , .F. ) )
       ELSEIF (nIndex == SCRAP_RES .AND. d_line->ptype_id == "L") .OR. ;
              (nIndex == SCRAP_TOL .AND. !d_line->ptype_id $ "_C_L")
	        nTempQty := MIN(m_linemv->cp_bqtyp, nTheoqty)
           RETURN( IF( nScrap > nTempQty * 0.01, .T. , .F. ) )
		 ENDIF
	ELSE
	    IF (nIndex == "RL"   .AND. d_line->ptype_id == "C") .OR. ;
          (nIndex == "FL" .AND. d_line->ptype_id == "C")
           nTempQty := MIN(m_linemv->cp_bqtyp, nTheoqty)
		     RETURN( IF( nScrap > nTempQty * 0.01, .T. , .F. ) )
       ELSEIF nIndex == "RL" .AND. d_line->ptype_id == "L"
	        nTempQty := MIN(m_linemv->cp_bqtyp, nTheoqty)
           RETURN( IF( nScrap > nTempQty * 0.01, .T. , .F. ) )
       ELSEIF nIndex == "QR" .AND. d_line->ptype_id == "C" .AND. d_line->size_id == "0201"
	        nTempQty := MIN(m_linemv->cp_bqtyp, nTheoqty)
           RETURN( IF( nScrap > nTempQty * 0.01, .T. , .F. ) )
       ELSEIF nIndex == "QR" .AND. d_line->ptype_id == "C" .AND. d_line->size_id == "0402"
	        nTempQty := MIN(m_linemv->cp_bqtyp, nTheoqty)
           RETURN( IF( nScrap > nTempQty * 0.01, .T. , .F. ) )
       ELSEIF (nIndex == "QR" .AND. d_line->ptype_id == "U") .OR.  ;
              (nIndex == "RR" .AND. d_line->ptype_id $ "_F_U_T_")
	        nTempQty := MIN(m_linemv->cp_bqtyp, nTheoqty)
           RETURN( IF( nScrap > nTempQty * 0.01, .T. , .F. ) )
       ELSEIF (nIndex == "RR" .AND. d_line->ptype_id == "L") .OR. ;
				  (nIndex == "RL" .AND. !d_line->ptype_id $ "_C_L")
	        nTempQty := MIN(m_linemv->cp_bqtyp, nTheoqty)
           RETURN( IF( nScrap > nTempQty * 0.01, .T. , .F. ) )
		 ENDIF
	ENDIF
ELSE
     nTempQty := nTheoqty * 1.30
     RETURN( IF( nScrap > nTempQty * 0.30, .T. , .F. ) )
ENDIF

RETURN(.T.)

FUNCTION OPER_CANCEL(o)
IF LASTKEY()= K_ESC
     ALERT("ESC was pressed !; Last operation was canceled")
     o:Varput(.F.) // To answer automatically confirmation of operation
     KEYBOARD CHR(K_ENTER)
ENDIF

RETURN(.T.)