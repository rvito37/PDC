#include "avxdefs.ch"

STATIC oMyRep

FUNCTION MyRPQC36V1(ReportFunc)

LOCAL oRep
MEMVAR aBuffer

oRep := TheReport():New("RPQC36V1","Technical yield")

oRep:SetSort({"Type+Line+Size+Value+B/N+Date"} )
oRep:aReports := {"RPQC36V1"}

oRep:SetExprSort({"PTYPE_ID+PLINE_ID+SIZE_ID+STR(value_id,9,3)+b_id+DTOS(CP_DFIN)"} )

oRep:SetCrit({       "Product type"   ,;
                     "Product line"   ,;
                     "Size"           ,;
                     "Value"          ,;
                     "Tolerance"      ,;
                     "Voltage"        ,;
                     "TC"             ,;
                     "Termination"    ,;
                     "ESN(XX)"        ,;
                     "ESN(Y)"         ,;
                     "Date from...to" ,;
                     "Purpose"        ,;
							"Processes"      ,;
							"Rep.Unit"       ,;
							"B/N from...to"  ,;
                     "Remark"          ;
                   })

oRep:SetCheck( {  {|o| critBrowse( o ,{"all"},"c_ptype", NIL, {|| c_ptype->ptype_id }  ,{|| c_ptype->ptype_nm  }        )},;
                  {|o| critBrowse( o ,{"all"},"c_pline", NIL, {|| c_pline->pline_id }  ,{|| c_pline->pline_nm  }        )},;
                  {|o| critBrowse( o ,{"all"},"c_size" , NIL, {|| c_size->size_id }    ,{|| Space(60) }                 )},;
                  {|o| critBrowse( o ,{"all"},"c_value", NIL, {|| Str(c_value->value_id,9,3) } ,{|| c_value->value_nm } )},;
                  {|o| critBrowse( o ,{"all"},"c_tol"  , NIL, {|| c_tol->tol_id }      ,{|| c_tol->tol_nm      }        )},;
                  {|o| critBrowse( o ,{"all"},"c_volt" , NIL, {|| c_volt->volt_id }    ,{|| c_volt->volt_nm    }        )},;
                  {|o| critBrowse( o ,{"all"},"c_tc"   , NIL, {|| c_tc->tc_id }        ,{|| c_tc->tc_nm        }        )},;
                  {|o| critBrowse( o ,{"all"},"c_term" , NIL, {|| c_term->term_id }    ,{|| c_term->term_nm    }        )},;
                  {|o| critBrowse( o ,{"all"},"c_esnxx", NIL, {|| c_esnxx->esnxx_id }  ,{|| c_esnxx->esnxx_nm  }        )},;
                  {|o| critBrowse( o ,{"all"},"c_esny" , NIL, {|| c_esny->esny_id }    ,{|| c_esny->esny_nm    }        )},;
                  {|o| GetDate(o,{(date()-1),date()}                                                                    )},;
                  {|o| critBrowse( o ,{"all"},"c_bpurp", NIL, {|| c_bpurp->b_purp }    ,{|| c_bpurp->bpurp_nme }        )},;
						{|o| critBrowse( o ,{"all"},"c_proc" ,    , {|| c_proc->proc_id  }   ,{|| c_proc->proc_nme } )},;
						{|o| critBrowse( o ,{"all"},"c_repunt" ,  , {|| c_repunt->rep_unt }  ,{|| c_repunt->unt_nm } )},;
						{|o| GetBN(o,{"000000","999999"},"d_Line","ib_idln")},;
                  {|o| GetRemark ( o ,{ space(50)  }                                                                    )} ;
                })

oRep:SetBuffer( {"Product type" ,"Product line" ,"Size" ,"Value" ,"Tolerance",;
                 "Voltage" ,"TC" ,"Termination","ESN(XX)","ESN(Y)",;
                  "Date from...to","c_bpurp","Processes","Rep.Unit", "B/N from...to","Remark" })

oRep:SetQueryBlocks({ ;
             {|| M_LINEMV->ptype_id $ aBuffer[ 1] },;
             {|| M_LINEMV->pline_id $ aBuffer[ 2] },;
             {|| M_LINEMV->size_id  $ aBuffer[ 3] },;
             {|| STR(M_LINEMV->value_id,9,3) $ aBuffer[ 4] },;
             {|| M_LINEMV->tol_id   $ aBuffer[ 5] },;
             {|| M_LINEMV->Volt_id  $ aBuffer[ 6] },;
             {|| M_LINEMV->tc_id    $ aBuffer[ 7] },;
             {|| M_LINEMV->term_id  $ aBuffer[ 8] },;
             {|| M_LINEMV->esnxx_id $ aBuffer[ 9]},;
             {|| M_LINEMV->esny_id  $ aBuffer[ 10]},;
             {|| M_LINEMV->cp_dfin >= aBuffer[11][1] .and. M_LINEMV->cp_dfin<=aBuffer[11][2] },;
				 {|| M_LINEMV->b_purp  $ aBuffer[ 12]  },;
				 {|| M_LINEMV->CPPROC_ID  $ aBuffer[13]},;
				 {|| TRUE }                             ,;
				 {|| m_linemv->b_id >= aBuffer[15][1] .AND. m_linemv->b_id <= aBuffer[15][2] },;
             {|| IF(right(aBuffer[16],1)==".",left(aBuffer[16],len(aBuffer[16])-1),aBuffer[16]) $ d_line->b_remark }    ;
              })
// Setfields are for Speadsheet. B_PRWK was deleted. requested for new PQC13V2

oRep:SetFields( {"b_id"         ,;//1
					  "b_purp"       ,;//2
					  "ptype_id"     ,;//3
					  "pline_id"     ,;//4
					  "size_id"      ,;//5
					  "value_id"     ,;//6
					  "cpproc_id"    ,;//7
					  "CP_DFIN"      ,;//8
	              "CP_BQTYP"     ,;//9
					  "REP_UNIT"     ,;//10
					  "QTY_LOOSE"    ,;//11
					  "QTY_OKP"      ,;//12
					  "QTY_OUTP"     ,;//13
					  "ELEC_YLD"     ,;//14
					  "TolR_PER"     ,;//15
					  "Q_PERC"       ,;//16
					  "FL_PERC"       ;//17
					  })

// Settitles for spreadsheet.
oRep:SetTitles( {"B/N"          ,;//1
					  "Purp"         ,;//2
					  "Type"         ,;//3
					  "Line"         ,;//4
					  "Size"         ,;//5
					  "Value"        ,;//6
					  "Proc"         ,;//7
					  "Date"         ,;//8
					  "Init Qty"     ,;//9
					  "Rep.Unit"     ,;//10
					  "Qty"          ,;//11
					  "Accum Yield"  ,;//12
					  "Non Yield Qty",;//13
					  "Elect.Yield"  ,;//14
					  "Cap.Range %"  ,;//15
					  "Q %"          ,;//16
					  "Flash %"       ;//17
                })

oRep:SetDB({"M_LINEMV","D_IRRFIN"})
oRep:lSuperSmart    :=   .T.
oRep:aSuperCriteria :=   {11,15}
oRep:aSuperIndexes  :=   {{"ilnmvfin",.t.},{"ilnmvbs",.t.}}
oRep:cRepDbf   := "T_pqc36"
oRep:cPrepDbf  := "T_pqc36GEN"
//oRep:cbExtraCond  := {|| M_LINEMV->ptype_id $ "_C_L_U_"}
oRep:cbPrepDbf := {|o| Prep36bpqc(o) }
oRep:lPrepDBF  := TRUE
oRep:cRepFileName := "Rpqc36V1"
oRep:Exec()
deleteTempFiles({"t_pqc36","r_xx"})   //YG 4/5/98
Return NIL

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: Prep132pqc()          Docs: Shalom LeVine                  ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 07-22-97              Date updated: þ07-22-97              ³
 * ³ Time created: 11:10:54am            Time updated: þ11:10:54am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: o                                                          ³
 * ³ Return Value: Prep132pqc(o)                                              ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
FUNCTION Prep36bpqc(oRep)

LOCAL aDbfs       := {"T_pqc36","T_pqc36GEN","C_TOL" ,"c_repunt"}
LOCAL aNtxs       := {""        ,""         ,"C_PTOL","repunt"}


LOCAL cTempDir    := GetUserInfo():cTempDir
LOCAL i,nRec,nLastTolRec
LOCAL nSum_R_QR_FL := 0,nTol_R := 0
LOCAL cSearch      := "",nQty := 0
LOCAL cBid,lCont
LOCAL aFields := {}
LOCAL nQty_binip   := 0
LOCAL nQty_okp     := 0
LOCAL nQty_okp_Gen := 0
LOCAL nQty_outp    := 0
LOCAL aRepUnit     := IIF( !Empty(GetBuffer("Rep.Unit")),Alltrim(strtran(GetBuffer("Rep.Unit"),"_"," ")) ,nil ),cTempUnit
LOCAL nQty_rp      := 0
LOCAL aPqc36     := {  {"B_ID"       ,"C", 6, 0 },;
                       {"B_PURP"     ,"C", 1, 0 },;
                       {"PTYPE_ID"   ,"C", 1, 0 },;
                       {"PLINE_ID"   ,"C", 3, 0 },;
                       {"SIZE_ID"    ,"C", 4, 0 },;
                       {"VALUE_ID"   ,"N", 8, 3 },;
							  {"CPPROC_ID"  ,"C", 5, 1 },;
							  {"CP_DFIN"    ,"D", 8, 0 },;
                       {"CP_BQTYP"   ,"N", 7, 0 },;
                       {"REP_UNIT"   ,"C", 2, 0 },;
							  {"QTY_LOOSE"  ,"N", 6, 0 },;
							  {"QTY_OKP"    ,"N", 8, 0 },;
							  {"QTY_OUTP"   ,"N", 8, 0 },;
							  {"OKP_R"      ,"N", 8, 0 },;
							  {"OKP_R_QR_FL","N", 8, 0 },;
                       {"ELEC_YLD"   ,"N", 6, 2 },;
							  {"TolR_PER"   ,"N", 6, 2 },;
							  {"Q_PERC"     ,"N", 6, 2 },;
                       {"FL_PERC"    ,"N", 6, 2 } }

IF !FILE(cTempDir + "t_pqc36.DBF")
     DBCREATE( cTempDir+"t_pqc36",aPqc36,   )
ENDIF

IF SELECT("t_pqc36") > 0; CLOSE t_pqc36 ; ENDIF
NetUse( "t_pqc36", STD_RETRY, , USE_EXCLUSIVE, USE_NEW, cTempDir )
t_pqc36->( __DBZAP() )

FOR i := 3 TO LEN( aDbfs )
     IF Select(aDbfs[i])==0
          NetUse( aDbfs[i]  , STD_RETRY, RDD_IN_USE, USE_SHARED, USE_NEW, NIL )
     ENDIF

     IF !EMPTY(aNtxs[i])
          (aDbfs[i])->( OrdSETfocus(aNtxs[i]))
     ENDIF
NEXT

NetUse("D_IRRFIN",5)
ordsetfocus("D_IRRFIN")

IF !FILE(cTempDir + "t_irrfin.dbf")
	aFields := d_irrfin->(dbstruct())
	aadd(aFields,{"HI" ,"C", 2, 0 })
	DBCREATE( cTempDir+"t_irrfin",aFields, NIL )
ENDIF

ferase(cTempDir + "t_irrfin.cdx")

NetUse( "t_irrfin", STD_RETRY, , USE_EXCLUSIVE, USE_NEW, cTempDir )
t_irrfin->( __DBZAP() )

NetUse( "T_pqc36GEN", STD_RETRY, , USE_EXCLUSIVE, USE_NEW, cTempDir )
CheckIndex("T_pqc36GEN",cTempDir + "T_pqc36GEN","PTYPE_ID+PLINE_ID+SIZE_ID+STR(value_id,9,3)+B_ID+STR(T_pqc36GEN->CP_STAGE,4)+CPPROC_ID",.T.)
T_pqc36GEN->( DBGOTOP() )

WHILE !T_pqc36GEN->(EOF())
		if D_IRRFIN->(dbseek(T_pqc36GEN->B_ID+STR(T_pqc36GEN->CP_STAGE,4)+T_pqc36GEN->CPPROC_ID))
			While T_pqc36GEN->B_ID + STR(T_pqc36GEN->CP_STAGE,4) + T_pqc36GEN->CPPROC_ID == ;
					D_IRRFIN->B_ID   + STR(D_IRRFIN->CP_STAGE,4)   + D_IRRFIN->CPPROC_ID
				   T_IRRFIN->(ADDREC(5))
					FOR i := 1 TO D_IRRFIN->( FCOUNT() )
					    T_IRRFIN->( FIELDPUT( i, D_IRRFIN->(FIELDGET(i)) ) )
					NEXT
					T_IRRFIN->HI := CurrentLevel(T_IRRFIN->REP_UNIT)
					D_IRRFIN->(dbskip(1))
			End
		endif
		T_pqc36GEN->(dbskip(1))
END
D_IRRFIN->(dbclosearea())
T_IRRFIN->(dbclosearea())

NetUse( "t_irrfin", STD_RETRY, , USE_EXCLUSIVE, USE_NEW, cTempDir ,"d_irrfin")

CheckIndex("D_IRRFIN",cTempDir + "t_irrfin","D_IRRFIN->B_ID+STR(D_IRRFIN->CP_STAGE,4)+D_IRRFIN->CPPROC_ID+D_IRRFIN->HI",.T.)
CheckIndex("IREPUNIT",cTempDir + "t_irrfin","D_IRRFIN->B_ID+D_IRRFIN->CPPROC_ID+D_IRRFIN->REP_UNIT",.T.)
D_IRRFIN->(ordsetfocus("D_IRRFIN"))

D_IRRFIN->(dbgotop())
WHILE !D_IRRFIN->(EOF())
	    cSearch := D_IRRFIN->B_ID+STR(D_IRRFIN->CP_STAGE,4)+D_IRRFIN->CPPROC_ID+D_IRRFIN->HI
		 D_IRRFIN->(dbskip(1))
		 if cSearch == D_IRRFIN->B_ID+STR(D_IRRFIN->CP_STAGE,4)+D_IRRFIN->CPPROC_ID+D_IRRFIN->HI
			 nQty := D_IRRFIN->QTY_LOOSE + D_IRRFIN->QTY_REEL
			 D_IRRFIN->(dbdelete())
          D_IRRFIN->(dbskip(-1))
			 D_IRRFIN->QTY_LOOSE	:= D_IRRFIN->QTY_LOOSE + nQty
		 else
			 D_IRRFIN->(dbskip(-1))
		 EndIf
		 nQty := 0
	    D_IRRFIN->(dbskip(1))
END
D_IRRFIN->( __DBPACK())

T_pqc36GEN->( DBGOTOP() )


WHILE !T_pqc36GEN->(EOF())
		 //Fase I
		 D_IRRFIN->(dbseek(T_pqc36GEN->B_ID+STR(T_pqc36GEN->CP_STAGE,4)+T_pqc36GEN->CPPROC_ID))
		 while T_pqc36GEN->B_ID+STR(T_pqc36GEN->CP_STAGE,4)+T_pqc36GEN->CPPROC_ID == ;
				 D_IRRFIN->B_ID+STR(D_IRRFIN->CP_STAGE,4)+D_IRRFIN->CPPROC_ID

			    t_pqc36->(dbappend())
		       t_pqc36->B_ID      := T_pqc36GEN->B_ID
       		 t_pqc36->B_PURP    := T_pqc36GEN->B_PURP
      		 t_pqc36->PTYPE_ID  := T_pqc36GEN->PTYPE_ID
		       t_pqc36->PLINE_ID  := T_pqc36GEN->PLINE_ID
		       t_pqc36->SIZE_ID   := T_pqc36GEN->SIZE_ID
		       t_pqc36->VALUE_ID  := T_pqc36GEN->VALUE_ID
		       t_pqc36->CPPROC_ID := T_pqc36GEN->CPPROC_ID
		       t_pqc36->CP_DFIN   := T_pqc36GEN->CP_DFIN
		       t_pqc36->CP_BQTYP  := T_pqc36GEN->CP_BQTYP
		       t_pqc36->REP_UNIT  := D_IRRFIN->REP_UNIT
				 t_pqc36->QTY_LOOSE := D_IRRFIN->QTY_LOOSE + D_IRRFIN->QTY_REEL

				 nRec := D_IRRFIN->(RecNo())

		       while T_pqc36GEN->B_ID+STR(T_pqc36GEN->CP_STAGE,4)+T_pqc36GEN->CPPROC_ID == ;
				       D_IRRFIN->B_ID+STR(D_IRRFIN->CP_STAGE,4)+D_IRRFIN->CPPROC_ID  .AND. !D_IRRFIN->(BOF())

				       IF !AllTrim(t_pqc36->REP_UNIT) $ "_RR_QR_FL_" .OR. AllTrim(t_pqc36->REP_UNIT) == "F"
					        nQty_okp := nQty_okp + D_IRRFIN->QTY_LOOSE + D_IRRFIN->QTY_REEL
							  nQty_okp_Gen := nQty_okp
						 ELSEIF AllTrim(t_pqc36->REP_UNIT) $ "_RR_QR_FL_" .AND. t_pqc36->REP_UNIT == D_IRRFIN->REP_UNIT
							  nSum_R_QR_FL := nSum_R_QR_FL + D_IRRFIN->QTY_LOOSE + D_IRRFIN->QTY_REEL
							  if AllTrim(t_pqc36->REP_UNIT) == "R"
								  nTol_R := D_IRRFIN->QTY_LOOSE + D_IRRFIN->QTY_REEL
							  endif
				       ENDIF

				       D_IRRFIN->(dbskip(-1))
				 End

				 D_IRRFIN->(DBGOTO(nRec))

				 t_pqc36->qty_okp   := nQty_okp
				 nQty_okp := 0

				 D_IRRFIN->(dbskip(1))
		 End

		 //Fase II
		 D_IRRFIN->(ordsetfocus("IRepUnit"))

		 While T_pqc36GEN->B_ID + dtoc(T_pqc36GEN->CP_DFIN) + T_pqc36GEN->CPPROC_ID == ;
				 T_pqc36->B_ID    + dtoc(T_pqc36->CP_DFIN)    + T_pqc36->CPPROC_ID .AND. !t_pqc36->(BOF())

				 D_IRRFIN->(dbseek(t_pqc36->B_ID+t_pqc36->CPPROC_ID+t_pqc36->REP_UNIT))
				 IF AllTrim(t_pqc36->REP_UNIT) $ "R_P_Q_A_B_C_D_F_G_J_K_"
					 IF AllTrim(t_pqc36->REP_UNIT) == "R"
						 t_pqc36->TolR_PER := (D_IRRFIN->QTY_LOOSE+ D_IRRFIN->QTY_REEL)/(nQty_okp_Gen+D_IRRFIN->QTY_LOOSE+ D_IRRFIN->QTY_REEL) * 100
					 ELSE
						 t_pqc36->QTY_OUTP := nQty_okp_Gen - t_pqc36->qty_okp
						 IF t_pqc36->ptype_id$"UT"
							t_pqc36->ELEC_YLD := (t_pqc36->qty_okp-nSum_R_QR_FL)/(nQty_okp_Gen+nTol_R) * 100
						 ELSE
                     t_pqc36->ELEC_YLD := t_pqc36->qty_okp/(nQty_okp_Gen+nTol_R) * 100
						 ENDIF
					 ENDIF
					 t_pqc36->OKP_R    := nQty_okp_Gen+nTol_R
				 ELSEIF AllTrim(t_pqc36->REP_UNIT) $ "_QR_RR_"
				 	 t_pqc36->Q_PERC := (D_IRRFIN->QTY_LOOSE + D_IRRFIN->QTY_REEL)/(nQty_okp_Gen+nSum_R_QR_FL) * 100
					 t_pqc36->OKP_R_QR_FL := nQty_okp_Gen+nSum_R_QR_FL
				 ELSEIF AllTrim(t_pqc36->REP_UNIT) == "FL"
				 	 t_pqc36->FL_PERC := (D_IRRFIN->QTY_LOOSE + D_IRRFIN->QTY_REEL)/(nQty_okp_Gen+nSum_R_QR_FL) * 100
					 t_pqc36->OKP_R_QR_FL := nQty_okp_Gen+nSum_R_QR_FL
				 ENDIF
				 t_pqc36->(dbskip(-1))
		 End
       D_IRRFIN->(ordsetfocus("D_IRRFIN"))
		 T_pqc36GEN->(dbskip(1))
		 nQty_okp_Gen := 0
		 nSum_R_QR_FL := 0
		 nTol_R       := 0
END

IF FILE(cTempDir + "temp.cdx")
	ferase(cTempDir + "temp.cdx")
ENDIF
dbselectarea("t_pqc36")
CheckIndex("temp",cTempDir + "temp","B_ID+REP_UNIT",.T.)
lCont := TRUE
t_pqc36->(dbgotop())

IF !Empty(aRepUnit) .AND. Len(aRepUnit) == 1
	/////////////////////
	While !t_pqc36->(EOF())
		    lCont := TRUE
			 cBid := t_pqc36->b_id
			 cTempUnit := aRepUnit
			 While lCont
			  IF Empty(cTempUnit) .OR. t_pqc36->(dbseek(cBid + cTempUnit))
              t_pqc36->(dbseek(cBid))
				  while t_pqc36->b_id == cBid .AND. !t_pqc36->(EOF())
				        IF alltrim(t_pqc36->rep_unit) <> cTempUnit
                       t_pqc36->(dbdelete())
				        ENDIF
						  t_pqc36->(dbskip(1))
				  End
				  lCont := FALSE
				  t_pqc36->( __DBPACK() )
				  IIF(!Empty(cTempUnit),t_pqc36->(dbseek(cBid)) ,nil )
			  ELSE
				  t_pqc36->(dbseek(cBid))
				  cTempUnit := ChangeTol(cTempUnit)
			  ENDIF
			 End
		    t_pqc36->(dbskip(1))
   End
	/////////////////////
Endif

t_pqc36->( __DBPACK() )

FOR i := 1 TO LEN( aDbfs )
    (aDbfs[i])->( DBCLOSEAREA() )
NEXT

D_IRRFIN->(dbclosearea())

oRep:cPrepDbf := "T_pqc36"

RETURN NIL

Static Function ChangeTol(cTol)

Local cRetVal
Local nOldArea := Select()

dbselectarea("c_tol")
ordsetfocus("c_ptol")
dbseek(t_pqc36->ptype_id+cTol)
ordsetfocus("c_pseq")
DbSkip(-1)
IF BOF() .OR. c_tol->ptype_id <> t_pqc36->ptype_id
	cRetVal := NIL
ELSE
	cRetVal := c_tol->tol_id
ENDIF
dbselectarea(nOldArea)

Return cRetVal

Function CurrentLevel(cRepUnit)

Local cRetVal := " "

if c_repunt->(dbseek(cRepUnit))
   cRetVal := c_repunt->seq_no
endif

Return cRetVal






























































































































































































