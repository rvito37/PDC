// G:\DVLPDC\SOURCE\STOKPROC.PRG
#include "avxdefs.ch"

STATIC cProc , bKey , nMone:=1 ,nMaxMone,aIndex

PROCEDURE StockInProc
LOCAL nStep := 1
LOCAL oLineMove
LOCAL oProc
Field esn_p2
aIndex := {"ISLACK","NWISLACK"}

@ 1,0 SAY Padc( IIF(!IfEnglish() ,"Š‰Œ„š ‰€ŒŽ ššŒ‰€™" ,"Process WIP Query" ) , 80 ) COLOR "N/W"

oProc := TabBase():new( "C_proc" ,{"iproc_id"} )
oProc:xopen()
oLineMove := TabBase():new( "D_line" ,{aIndex[1]} )//{"iLnBrCd"} edomo 19-06-01 16191452
oLineMove:xopen()
GenOPenFiles({"c_prornd","C_leadt","C_bstat","m_linemv"})
c_prornd->(ordsetfocus("iwip"))

SELECT D_line
Set Relation to Padr(esn_p2,8) into c_prornd
WHILE .T.
   DO CASE
      CASE nStep = 1
           GetProc()
           IF LastKey() = K_ESC
              EXIT
           ELSEIF LastKey() = K_ENTER
              nStep := 2
           ENDIF
      CASE nStep = 2
			  IF cProc == "190.0"
			     aIndex := {"QCISLACK","ISLACK","NWISLACK"}
			     d_line->(ordsetfocus(aIndex[1]))
			  ELSEIF  cProc == "001.0"
			     aIndex := {"IMSLACK"}
			     d_line->(ordsetfocus(aIndex[1]))
			  ELSE
			     aIndex := {"ISLACK","NWISLACK"}
			     d_line->(ordsetfocus(aIndex[1]))
			  ENDIF
			  ShowStockInProc()
           IF LastKey() = K_ESC
              nStep := 1
           ENDIF
   ENDCASE
ENDDO

cProc := NIL
oLineMove:close() // closes d_line
oProc:close()     // closes c_proc
GenCloseFiles({"c_leadt","c_bstat","m_linemv","c_prornd" })
RETURN

STATIC PROCEDURE GetProc
LOCAL bInsSave  ,;
      nCursSave

DEFAULT cProc TO "     "

@ 3,4  SAY "Process:" COLOR if( IsColor() , "W+/B" , "W+/N" )
@ 3,12 GET cProc COLOR if( IsColor() , "W+/B,W+/R" , "W+/N,N/W" ) ;
                 PICTURE "999.9" ;
                 SEND PreBlock  :=  {|o| PrePick( o, "c_proc")} ;
                 SEND postBlock := { |o| cProc == "001.0" .OR. postProc(o) } // VR 20-06-01 16201460

XREADALL
GetList := {}

RETURN
*

STATIC FUNCTION postProc(o)
LOCAL lRetVal

IF Empty( o:varGet() )
   Msg24( {"88"} , 3 , .T. )
   RETURN .F.
ENDIF

IF c_proc->( DbSeek( o:varGet() ) )
   lRetVal := .T.
	IF !IfEnglish()
		@ 3,20 SAY Alltrim( c_proc->proc_nmh ) + Space( 50 ) COLOR if( IsColor() , "W+/B" , "W+/N" )
	ELSE
      @ 3,20 SAY Alltrim( c_proc->proc_nme ) + Space( 50 ) COLOR if( IsColor() , "W+/B" , "W+/N" )
	ENDIF
ELSE
   Msg24( {"90"} , 3 , .T. )
   lRetVal := .F.
ENDIF

IF cProc == "190.0"
   @ 3,40 SAY "                                        "
   @ 3,40 SAY "Index: Stat+Prior+Slack+Purp+B/N" COLOR "W+/N"
ELSEIF cProc == "001.0"
	@ 3,40 SAY "                                        "
	@ 3,40 SAY "Index: Stat+Prior+Slack+Purp+B/N(METAL) " COLOR "W+/N"
ELSE
   @ 3,40 SAY "                                        "
   @ 3,40 SAY "Index: Prior+Slack+Purp+Stat+B/N" COLOR "W+/N"
ENDIF







RETURN lRetVal


STATIC PROCEDURE ShowStockInProc()
LOCAL o , nKey ,oLineMove ,nFirstLine,cOldscr
LOCAL aKeyList
LOCAL nRefreshCount := 0 , nTimeCounter := 0 , nTimeOut := 1000000
LOCAL nTempRec
LOCAL nTempOrd
FIELD B_stat,B_purp,CpWkstn_id,CpProc_id,Seq_no,B_dprom,B_remark,Cp_widSta,;
 Pp_widFin,Pp_dArr,B_prior,B_wkProm,Pp_dFin,Cp_bQtyP,Cp_bQtyS,Cp_bQtyW,Value_id;
  ,Size_id,B_type,pLine_id,B_id

IF !IfEnglish()
	aKeyList:={;
                 {CHR(24)+"         -   „Œ’Ž „˜…™",5},; //
                 {CHR(25)+"         -    „ˆŽ „˜…™",24},; //
                 {'PgDn'+"      -    „ˆŽŒ Š‘Ž", 3},; // PgDn
                 {'PgUn'+"      -   „Œ’ŽŒ Š‘Ž",18},; // PgUp
                 {"Ctrl_PgUp - „…™€˜ „˜…™",31},; // 
                 {"Ctrl_PgDn - „…˜‡€ „˜…™",30},; // 
                 {"F4        -   „Ž ™…”‰‡",-3},;
                 {"Ctrl_T    -     ‰Ž…‹‰‘",20},;
                 {"Esc       -        ‰‰‘",K_ALT_F10};
                }
ELSE
	aKeyList:={;
                 {"UpLine      -            ",5} ,; //
                 {"DownLine    -            ",24},; //
                 {"Page Down   -         PgDn", 3},; // PgDn
                 {"Page Up     -         PgUp",18},; // PgUp
                 {"First line  -    Ctrl_PgUp",31},; // 
                 {"Last Line   -    Ctrl_PgDn",30},; // 
                 {"Search...   -           F4",-3},;
                 {"Totals      -       Ctrl_T",20},;
                 {"Exit        -          Esc",K_ALT_F10};
                }
ENDIF

//NetUse("d_date",5) //VR & edomo 19-06-01 16191452
IF SELECT("D_line")>0
   DBSELECTAREA("D_line")
ELSE
   DBUSEAREA(.T.,"DBFCDXAX","D_line")
   ORDSETFOCUS("DlcPPtsv")
ENDIF
DBSEEK(cProc,.F.)

IF D_line->( EOF() )
	IF !IfEnglish()
		ALERT( "!! „† Š‰Œ„Œ ‰…š …€–Ž €Œ" , {"Enter"} )
	ELSE
          ALERT( "No records found for this process !" , {"Enter"} )
	ENDIF
   SetLastKey(K_ESC)
   //d_date->(dbclosearea())
   RETURN
ENDIF
IF FILE("T_line.cdx")
   WHILE .T.
         IF FERASE("T_line.cdx")==-1
            EXIT
         ENDIF
   ENDD
ENDIF
IF SELECT("C_leadt")==0
   GenOpenFiles({"C_leadt"})
ENDIF
IF SELECT("C_bstat")==0
   GenOpenFiles({"C_bstat"})
ENDIF
DBSELECTAREA("D_line")

IF cProc == "001.0"
   COUNT TO nMaxMone WHILE "01"$D_line->CpProc_id
ELSE
	COUNT TO nMaxMone WHILE D_line->CpProc_id==cProc
ENDIF



o:= CreateBro()
o:goBottom()
IIF(!IfEnglish() ,o:panEnd() ,NIL )
o:refreshAll()
nFirstLine:=D_line->(RECNO())
WHILE .T.

    WHILE !o:stabilize() ; ENDDO
    /*IF d_date->curr_date <> Date()//VR&edomo 19-06-01 16191452
       cOldScr := SAVESCREEN()
       MsgBox("Updating batches file, please be patient...")
       nTempRec := d_line->(recNo())
       nTempOrd := d_line->(ordsetfocus("ilnesnp"))
       d_line->(dbgotop())
       While !d_line->(eof())
             if d_line->(RecLock(5,"STOKPROC"))
                d_line->ExpFinDate := batchCalc3("d_line")
                d_line->(xdbunlock())
             endif
             d_line->(dbskip(1))
       End
       d_line->(ordsetfocus(nTempOrd))
       d_line->(dbgoto(nTempRec))
       if d_date->(RecLock(5,"STOKPROC"))
          d_date->curr_date := Date()
          d_date->(dbunlock())
       endif
       RESTSCREEN(,,,,cOldscr)
    ENDIF*/
    WHILE Empty( nKey := InKey() )
       IF !Empty( nTimeOut ) .AND. ++nTimeCounter > nTimeOut
          nKey := K_ESC
          EXIT
       ELSE
          IF ++nRefreshCount > 10000
             nRefreshCount := 0
             o:refreshAll()
             o:forceStable()
          ENDIF
       ENDIF
    ENDDO
    nTimeCounter := 0
    nMone := qpqc31Keys(nKey,o,nFirstLine,cProc,nMone,nMaxMone) // Located at Avxfuncs.prg
    DO CASE
       CASE nKey = K_ESC
            nMone:=1
            EXIT
		 CASE nKey == K_ALT_S
			 @ 3,40 SAY "                                        "
			 IF cProc <> "190.0"
				IF aIndex[1] == d_line->(ax_tagname())
					d_line->(ordsetfocus(aIndex[2]))
					@ 3,40 SAY "Index: Type+Line+Size+Prior+Slack+Purp" COLOR "W+/N"
				ELSE
					@ 3,40 SAY "Index: Prior+Slack+Purp+Stat+B/N"       COLOR "W+/N"
               d_line->(ordsetfocus(aIndex[1]))
				ENDIF
			 ELSE
				IF aIndex[1] == d_line->(ax_tagname())
					d_line->(ordsetfocus(aIndex[2]))
					@ 3,40 SAY "Index: Prior+Slack+Purp+Stat+B/N" COLOR "W+/N"
				ELSEIF aIndex[2] == d_line->(ax_tagname())
					d_line->(ordsetfocus(aIndex[3]))
					@ 3,40 SAY "Index: Type+Line+Size+Prior+Slack+Purp"       COLOR "W+/N"
				ELSE
					d_line->(ordsetfocus(aIndex[1]))
					@ 3,40 SAY "Index: Stat+Prior+Slack+Purp+B/N"       COLOR "W+/N"
				ENDIF
			 ENDIF
				qpqc31Keys(18,o,nFirstLine,cProc,nMone,nMaxMone)
				o:refreshAll()
       CASE nKey = K_F1
            nKey:=HlpKeys(aKeyList)
            nMone := qpqc31Keys(nKey,o,nFirstLine,cProc,nMone,nMaxMone)
       ENDCASE
ENDDO
//d_date->(dbclosearea())
RETURN

STATIC FUNCTION CreateBro

LOCAL oCol  , o

o := TBrowseDB(4,0,22,79)

o:headSep := "ÍÑÍ"
o:colSep  := " ³ "
o:footSep := "ÍÏÍ"
o:colorSpec := if(IsColor(),"W+/B,W+/R,B/Bg","w/n,n/w,w/n,w/n,w+/n")
*****************************************
IF !IfEnglish()
    oCol := TBColumnNEW( "            ˆ—‰‰…˜”", {|| c_prornd->proj_nm + " -- " + Padr(c_prornd->wip_clstr,8)} )
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})}
    o:addColumn( oCol )
    oCol := TBColumnNEW( "             š…˜’„" , {|| D_line->B_remark} )
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})}
    o:addColumn( oCol )
    oCol := TBColumnNEW( " Œ—Ž "             , {|| D_line->Cp_widArr} )//D_line->Cp_widSta, vitaly 01.05.01 00072403
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})} // YH 14-6-00
    o:addColumn( oCol )
    oCol := TBColumnNEW( " ˜‘…Ž "             , {|| D_line->Pp_widFin} )
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})} // YH 14-6-00
    o:addColumn( oCol )
    oCol := TBColumnNEW( "Š‰˜€š;„‘‰‹"        , {|| D_line->Cp_dArr } ) //edomo 13-05-01 000724023 {|| D_line->Pp_dArr } )
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})} // YH 14-6-00
    o:addColumn( oCol )
    oCol := TBColumnNEW( " Slack "            , {|| Slack("D_line") } )
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})} // YH 14-6-00
    o:addColumn( oCol )
    oCol := TBColumnNEW( " š…”‰ƒ’"            , {|| D_line->B_prior + D_line->B_wkprom } )
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})} // YH 14-6-00
    o:addColumn( oCol )
    oCol := TBColumnNEW( "  ‰Ž‰;Š‰Œ„š"      , {|| Transform(Date()-D_line->cp_darr,"999999") } )//edomo 13-05-01 00072403 Date()-D_line->Pp_dfin
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})} // YH 14-6-00
    o:addColumn( oCol )
    oCol := TBColumnNEW( "   `‘Ž;‰‰‹˜"      , {|| Transform(D_line->cp_bqtyp,"9,999,999") } )
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})} // YH 14-6-00
    o:addColumn( oCol )
    oCol := TBColumnNEW( "  `‘Ž;š…ˆ‚"        , {|| Transform(D_line->cp_bqtys,"99,999") } )
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})} // YH 14-6-00
    o:addColumn( oCol )
    oCol := TBColumnNEW( "`‘Ž; ˜”"            , {|| Transform(D_line->cp_bqtyw,"999") } )
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})} // YH 14-6-00
    o:addColumn( oCol )
    oCol := TBColumnNEW( "Š˜’"                , {|| D_line->Value_id} )
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})} // YH 14-6-00
    o:addColumn( oCol )
    oCol := TBColumnNEW( "Œƒ…‚"               , {|| D_line->Size_id} )
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})} // YH 14-6-00
    o:addColumn( oCol )
    oCol := TBColumnNEW( "B;t"                , {|| D_line->B_type } )
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})} // YH 14-6-00
    o:addColumn( oCol )
    oCol := TBColumnNEW( "P_;line"            , {|| D_line->pline_id} )
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})} // YH 14-6-00
    o:addColumn( oCol )
    oCol := TBColumnNEW( "S;t"                , {|| D_line->b_stat } )
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})} // YH 14-6-00
    o:addColumn( oCol )
    oCol := TBColumnNEW( "„Ž   "             , {|| D_line->b_id } )
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})} // YH 14-6-00
    o:addColumn( oCol )
    oCol := TBColumnNEW( "P;u"                , {|| D_line->b_purp} )
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})} // YH 14-6-00
    o:addColumn( oCol )
    *
    * YH 6-12-00 Task 00070305
    *
    oCol := TBColumnNEW( " #  "                , {||IIF(nMone==0,nMone:=1,),STR(nMone,4)})
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})} // YH 14-6-00
    o:addColumn( oCol )
ELSE
    *
    * YH 6-12-00 Task 00070305
    *
    oCol := TBColumnNEW( " #  "                , {||IIF(nMone==0,nMone:=1,),STR(nMone,4)})
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})} // YH 14-6-00
    o:addColumn( oCol )
    oCol := TBColumnNEW( "P;u"                , {|| D_line->b_purp} )
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})} // YH 14-6-00
    o:addColumn( oCol )
    oCol := TBColumnNEW( "Batch "             , {|| D_line->b_id } )
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})} // YH 14-6-00
    o:addColumn( oCol )
    oCol := TBColumnNEW( "S;t"                , {|| D_line->b_stat } )
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})} // YH 14-6-00
    o:addColumn( oCol )
    oCol := TBColumnNEW( "P_;line"            , {|| D_line->pline_id} )
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})} // YH 14-6-00
    o:addColumn( oCol )
    oCol := TBColumnNEW( "B;t"                , {|| D_line->B_type } )
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})} // YH 14-6-00
    o:addColumn( oCol )
    oCol := TBColumnNEW( "Size"               , {|| D_line->Size_id} )
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})} // YH 14-6-00
    o:addColumn( oCol )
    oCol := TBColumnNEW( "Val"                , {|| D_line->Value_id} )
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})} // YH 14-6-00
    o:addColumn( oCol )
    oCol := TBColumnNEW( "No of;Wafers"            , {|| Transform(D_line->cp_bqtyw,"999") } )
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})} // YH 14-6-00
    o:addColumn( oCol )
    oCol := TBColumnNEW( "No of;Strips"        , {|| Transform(D_line->cp_bqtys,"99,999") } )
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})} // YH 14-6-00
    o:addColumn( oCol )
    oCol := TBColumnNEW( "No of;Pcs"      , {|| Transform(D_line->cp_bqtyp,"9,999,999") } )
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})} // YH 14-6-00
    o:addColumn( oCol )
    oCol := TBColumnNEW( "Days in;process"      , {|| Transform(Date()-D_line->cp_darr,"999999") } )//edomo 13-05-01 00072403 Date()-D_line->Pp_dfin
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})} // YH 14-6-00
    o:addColumn( oCol )
    oCol := TBColumnNEW( " Prior "            , {|| D_line->B_prior + D_line->B_wkprom } )
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})} // YH 14-6-00
    o:addColumn( oCol )
    oCol := TBColumnNEW( " Slack "            , {|| Slack("D_line") } )
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})} // YH 14-6-00
    o:addColumn( oCol )
    oCol := TBColumnNEW( "Arrive;Date"        , {|| D_line->Cp_dArr } ) //edomo 13-05-01 000724023 {|| D_line->Pp_dArr } )
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})} // YH 14-6-00
    o:addColumn( oCol )
    oCol := TBColumnNEW( "Delivered;by"             , {|| D_line->Pp_widFin} )
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})} // YH 14-6-00
    o:addColumn( oCol )
	 oCol := TBColumnNEW( "Recived;by"             , {|| D_line->Cp_widArr} )//D_line->Cp_widSta, vitaly 01.05.01 00072403
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})} // YH 14-6-00
    o:addColumn( oCol )
	 oCol := TBColumnNEW( "Comments        " , {|| D_line->B_remark} )
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})}
    o:addColumn( oCol )
    oCol := TBColumnNEW( "Project            ", {||  Padr(c_prornd->wip_clstr,8) + " -- " + c_prornd->proj_nm} )
    oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})}
    o:addColumn( oCol )

ENDIF
*
* YH  5-6-00
*
o:goBottomBlock := {||D_line->(DBSEEK(cProc,.T.))}
o:gotopBlock    := {||D_line->(DBSEEK(ALLTRIM(STR(VAL(cProc)+1)),.T.))}
o:skipBlock     := {|n|MySkipper(n,bKey)}

IF cProc == "001.0"
   bKey            := {|| TRUE }
ELSE
   bKey            := {||D_line->CpProc_id==cProc}
ENDIF

RETURN o
*
STATIC FUNCTION MySkipper(nToSkip,bWhileCond)
*
* (•…— Œ’) tbrowse Œ skipper
*
LOCAL nSkipped:=0
IF nToSkip == 0
   DBSKIP(0)
   Return(0)
ENDIF
DbGoto(Recno())

WHILE nSkipped != nToSkip .AND. !EOF() .AND. !BOF() .AND. EVAL(bWhileCond)
      IF nToSkip>0
         DBSKIP(1)
         *
         *YH 10-12-00 TASK 00070305
         *
         ++nMone
         nSkipped++
      ELSE
         DBSKIP(-1)
         nSkipped--
         --nMone
         *
         *YH 10-12-00 TASK 00070305
         *
         IF nMone<0
            ++nMone
         ENDIF
      ENDIF
ENDDO

IF Eof()
   DbSkip(-1)
   --nMone
   *
   *YH 10-12-00 TASK 00070305
   *
   IF nMone<0
      ++nMone
   ENDIF
   nSkipped--
ELSEIF Bof()
   nSkipped++
   ++nMone
ELSEIF !Eval(bWhileCond)
       IF nToSkip>0
          DbSkip(-1)
          --nMone
          *
          *YH 10-12-00 TASK 00070305
          *
          IF nMone<0
             ++nMone
          ENDIF
          nSkipped--
       ELSE
          DbSkip(1)
          ++nMone
          nSkipped++
       ENDIF
ENDIF
*
RETURN(nSkipped)
*
STATIC FUNCTION QPQC31Keys(nKey,oBjct,nFirstRec,cProc,nMone,nMaxMone)
*
* Tbrowse „ ‚"’ š…’…š ’…–‰Œ „‰–—…”
*
LOCAL kh:= .t.,cScr, cOlsCursor:=SETCURSOR(1)
LOCAL cScr1,nRecno:=0 ,nLines:=0 ,cB_id,nLine,nTimes,nCurrenLine
LOCAL nSumW,nSumS,nSumP,cBatch:='      '
LOCAL cOldColor:=SETCOLOR("W+/B,W+/R,,,W+/B")

DO CASE
   CASE nKey=5 // 
        Objct:up()
        Repaint(objct)
   CASE nKey=24 // 
        Objct:down()
        Repaint(objct)
   CASE nKey= 3 //K_PGDN
        Repaint(objct)
        nTimes:=1
        WHILE D_line->CpProc_id==cProc .AND. nTimes<16
              D_line->(DBSKIP(1))
              IF D_line->CpProc_id # cProc
                 D_line->(DBSKIP(-1))
                 EXIT
              ENDIF
              ++nTimes
              ++nMone
        ENDDO
   CASE nKey=18  //K_PGUP
        Repaint(objct)
        nTimes:=1
        WHILE D_line->CpProc_id==cProc .AND. nTimes<16
              D_line->(DBSKIP(-1))
              IF D_line->CpProc_id # cProc
                 D_line->(DBSKIP(1))
                 EXIT
              ENDIF
              ++nTimes
              --nMone
        ENDDO
   CASE nKey=31  // CTRL_PGUP Tbrowse „ šŒ‰‡šŒ
        *
        * YH 13-12-00 Task 00070305
        *
        D_line->(DBGOBOTTOM())
        D_line->(DBSEEK(cProc,.T.))
        nMone:=1
        Repaint(objct)
   CASE nKey=K_CTRL_PGDN  // Tbrowse „ “…‘
        *
        * YH 13-12-00 Task 00070305
        *
        D_line->(DBGOBOTTOM())
        D_line->(DBSEEK(ALLTRIM(STR(VAL(cProc) + 0.1)),.T.))
        D_line->(DBSKIP(-1))
        nMone:=nMaxMone
        Repaint(objct)
   CASE nKey=K_RIGHT
       IF Objct:ColPos < Objct:ColCount
          Objct:right()
       ELSE
          Tone(100,0)
          Objct:ColPos := Objct:ColCount-1
       END
   CASE nKey=K_LEFT
       IF  Objct:ColPos > 1
           Objct:left()
       ELSE
           Tone(100,0)
           Objct:ColPos := 1
       END
   CASE nKey=K_HOME      ;  Objct:home()
   CASE nKey=K_END       ;  Objct:end()
   CASE nKey=K_CTRL_LEFT ;  Objct:panleft()
   CASE nKey=K_CTRL_RIGHT;  Objct:panright()
   CASE nKey=K_CTRL_HOME ;  Objct:panhome()
   CASE nKey=K_CTRL_END  ;  Objct:panend()
   CASE nKey=-3  // „Ž ™…”‰‡
        @10,05 CLEAR TO 14,75
        cScr  := SAVESCREEN(10,05,14,75)
        DISPBOX(10,05,14,75,REPLICATE('ÉÍ»º¼ÍÈº ',9),"W+/BG")
        DEVPOS(13, 06)
		  IF !ifEnglish()
			  DEVOUT(PADC("! „Ž„ Œ™ ‰……š„ š™™ €…ŒŽ ƒ‰Œ—„Œ ™‰",69),"GR+/BG")
			  DEVPOS(12, 17)
			  DEVOUT(":„Ž .‘Ž ƒ‰Œ—„Œ €","N/BG")
		  ELSE
                 DEVOUT(PADC("Full Batch Number(6 digits)!",69),"GR+/BG")
			  DEVPOS(12, 17)
                 DEVOUT("Please Enter Batch Number:","N/BG")
		  ENDIF
        @12, 45 GET cBatch PICTURE '999999'
        READ
        SETCOLOR(cOldColor)
        *
        nRecno:=RECNO()
        D_line->(ORDSETFOCUS("iB_idln")) // B_id ‰”Œ D_line …‰Ž
        D_line->(DBSEEK(cBatch),.F.)   // ƒŒ—…„™ „Ž ™…”‰‡
        IF D_line->(FOUND()) .AND. D_line->CpProc_Id==cProc .AND. ;
         !UPPER(D_line->B_stat) $ ('CD') .AND. LASTKEY() # 27
           cB_id:=D_line->B_id
           D_line->(ORDSETFOCUS("iSlack")) // ‰˜…—Ž„ …‰ŽŒ „˜†‡ Vitaly 25-07-01 ("iLnBrCd"))
           D_line->(DBGOTO(nFirstRec)) // š‰˜…š„ „Ž…™˜„ „…Ž š˜‰”‘ Š˜…–Œ …Œ‡ „…™€˜„ „Ž…™˜ š…Ž—Žš„
           COUNT to nLine WHILE D_line->B_id # cB_id
           nMone:=nLine + 1 // 1  nMone …Œ‰€… 0  Œ‰‡šŽ nLine
           oBjct:refreshAll()
           oBjct:forceStable()
        ELSE
           IF LASTKEY() # 27
              D_line->(ORDSETFOCUS("iSlack")) // ‰˜…—Ž„ …‰ŽŒ „˜†‡
              D_line->(DBGOTO(nRecno)) // š‰˜…š„ „Ž…™˜Œ „˜†‡
              DEVPOS(20, 17)
				  IF !IfEnglish()
					  ALERT("!! š™—…Ž„ „Ž„ „€–Ž €Œ", {"Š™Ž„Œ …„™Œ‹ ™—Ž Œ’ •‡Œ"} )
				  ELSE
                 ALERT("Batch not found!", {"Press any Key to continue"} )
				  ENDIF

           ELSE
              D_line->(ORDSETFOCUS("iSlack"))
              D_line->(DBGOTO(nRecno)) // š‰˜…š„ „Ž…™˜Œ „˜†‡
           ENDIF
        ENDIF
        *
   CASE nKey=20  //  ‰Ž…‹‰‘ Ctrl_t
        nCurrenLine:=D_line->(RECNO())
        D_line->(DBSEEK(cProc))
        *
        *  š…‰…Ž‹„ ‰˜‚…€Œ ‰šŒ‡š„ Š˜’ šŽ
        *
        nSumW:=nSumS:=nSumP:=0
        *
        * „Œ€Ž™ Tbrowse „ š††„
        *
        IIF( !IfEnglish(),oBjct:panEnd() ,oBjct:panHome() )
        DO WHILE !oBjct:stabilize()
        ENDDO
        cScr  := SaveScreen(23,0,23,79)
        WHILE D_line->CpProc_id==cProc .AND. !D_line->(EOF())
              nSumW+=D_line->Cp_BqtyW
              nSumS+=D_line->Cp_BqtyS
              nSumP+=D_line->Cp_BqtyP
              D_line->(DBSKIP())
        ENDDO
		  IF !ifEnglish()
			  @23,1  say ALLTRIM(TRANSFORM(nSumP,'999,999,999')) color "GR+/B"
			  @23,13 say ALLTRIM(TRANSFORM(nSumS,'999,999,999')) color "GR+/B"
			  @23,25 say ALLTRIM(TRANSFORM(nSumW,'999,999,999')) color "GR+/B"
			  @23,40 say ' ! …„™Œ‹ ™—Ž Œ’ •‡Œ Š™Ž„Œ'             color "R+/B"
			  @23,75 say ALLTRIM(STR(nMaxMone,5))                color "GR+/B"
		  ELSE
			  @23,01 say ALLTRIM(STR(nMaxMone,5))                color "GR+/B"
			  @23,11 say 'Press any key to continue'             color "R+/B"
			  @23,54 say ALLTRIM(TRANSFORM(nSumW,'999,999,999')) color "GR+/B"
			  @23,63 say ALLTRIM(TRANSFORM(nSumS,'999,999,999')) color "GR+/B"
			  @23,71 say ALLTRIM(TRANSFORM(nSumP,'999,999,999')) color "GR+/B"
		  ENDIF
        SETCURSOR(0)
        DEVPOS(23,40)
        INKEY(0)
        SETCURSOR(1)
        RESTSCREEN(23,0,23,79,cScr)
        D_line->(DBGOTO(nCurrenLine))
   OTHERWISE
ENDCASE

RETURN (nMone) // Updated value