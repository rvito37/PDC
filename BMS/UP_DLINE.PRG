#include "avxdefs.ch"
#include "edi.ch"

FUNCTION UP_DLINE(lAuto,lSecondFase)
field esn_id
LOCAL i
LOCAL aDbfs     := {"d_line","c_proc","c_ptype"}
LOCAL aNtxs     := {"dpctdesn","iproc_id","iptype"}
LOCAL cTempDir  := GetUserInfo():cTempDir
LOCAL AStru

LOCAL cOldScr   := SAVESCREEN(2,0,24,80)
LOCAL cScr
LOCAL nChoice

default lAuto to FALSE
default lSecondFase to FALSE



IF lAuto
	nChoice := 1
ELSEIF lSecondFase
   nChoice := 2
ELSE
   nChoice := Alert("Choose!",{"Code Printing","PROBER","TERM","Cu plating line"})
ENDIF


IF LastKey() == K_ESC .AND. !lAuto .AND. !lSecondFase
   Return nil
ELSEIF nChoice == 4
	UPDLINE()
	Return nil
ENDIF

IF nChoice == 1
	AStru     := {{"B_ID"    ,"C",6,0}  ,;
                 {"ESN_ID"  ,"C",13,0} ,;
					  {"TERM_ID" ,"C", 1, 0},;
					  {"PLINE_ID","C", 3, 0},;
					  {"Pfam"    ,"C", 15, 0},;
					  {"SPC_BID" ,"C", 8, 0} }
ELSEIF nChoice == 3
	AStru     := {{"B_ID"       ,"C", 6, 0  },;
                 {"ESN_ID"     ,"C",16, 0  },;
					  {"PTYPE_ID"   ,"C", 1, 0  },;
                 {"SIZE_ID"    ,"C", 4, 0  },;
                 {"VALUE_ID"   ,"N", 9, 3  },;
                 {"TOL_ID"     ,"C", 1, 0  },;
					  {"TERM_ID"    ,"C", 1, 0  },;
					  {"CPPROC_ID"  ,"C", 5, 1  },;
					  {"b_purp"     ,"C", 1, 0  },;
					  {"PLINE_ID"   ,"C", 3, 0  }}
ELSE
	AStru     := {{"B_ID"       ,"C", 6, 0  },;
                 {"ESN_ID"     ,"C",16, 0  },;
					  {"PTYPE_ID"   ,"C", 1, 0  },;
                 {"SIZE_ID"    ,"C", 4, 0  },;
                 {"VALUE_ID"   ,"N", 9, 3  },;
                 {"TOL_ID"     ,"C", 1, 0  },;
					  {"TERM_ID"    ,"C", 1, 0  },;
					  {"CPPROC_ID"  ,"C", 5, 1  },;
					  {"b_purp"     ,"C", 1, 0  },;
					  {"PLINE_ID"   ,"C", 3, 0  },;
					  {"SPC_BID"    ,"C", 8, 0  },;
					  {"Pfam"       ,"C", 15, 0  }}
ENDIF
FOR i := 1 TO LEN(aDbfs)
         IF SELECT(aDbfs[i])== 0
            NetUse( aDbfs[i], STD_RETRY, RDD_IN_USE, USE_SHARED, USE_NEW, NIL )
         ENDIF
         (aDbfs[i])->(ordSETFocus( aNtxs[i]))
NEXT

/* USE "D_LINE" SHARED */

IF FILE(cTempDir + "ND_LINE.DBF")
   ERASE(cTempDir + "ND_LINE.DBF")
ENDIF

DBCREATE( cTempDir + "ND_LINE",AStru)

i := 0

IF nChoice == 1
   c_proc->(dbseek("184.2"))
ELSEIF lSecondFase
   c_proc->(dbseek("194.0"))
ELSE
	c_proc->(dbseek("160.0"))
ENDIF



NetUse( "ND_LINE", STD_RETRY, , USE_EXCLUSIVE, USE_NEW, cTempDir,"DBTemp_line" )
D_LINE->(DBGOTOP())
@15,9 to 18,57 DOUBLE
@ 16,10 SAY "Update of Database for Printing machines module"
@ 17,10 SAY "Copying opened batches from AVXBMS into local  "
WHILE  ! (D_LINE->(EOF()))
        IF IIF(nChoice == 3 ,d_line->cp_pccode $ "_4080_" ,;
		  		                 d_line->cp_pccode < c_proc->pcprocno )
                DBTemp_line->(DBAPPEND())
					 DBTemp_line->B_ID    := D_LINE->B_ID


					 IF nChoice <> 3
						DBTemp_line->SPC_BID := D_LINE->B_ID+"$M"
						IF c_ptype->(dbseek(D_LINE->ptype_id))
							DBTemp_line->pfam := alltrim(c_ptype->PTYPE_NM)+"s"
						ENDIF
					 ENDIF
					 IF nChoice == 1 .OR. nChoice == 3
                   DBTemp_line->ESN_ID := D_LINE->PTYPE_ID + D_LINE->SIZE_ID + STR(D_LINE->VALUE_ID,8,3)
					 ELSE
                   DBTemp_line->ESN_ID := D_LINE->ESN_ID
					 ENDIF
					 IF nChoice == 2 .OR. nChoice == 3
						 DBTemp_line->PTYPE_ID  := D_LINE->PTYPE_ID
						 DBTemp_line->PLINE_ID  := D_LINE->PLINE_ID
						 DBTemp_line->SIZE_ID   := D_LINE->SIZE_ID
						 DBTemp_line->VALUE_ID  := D_LINE->VALUE_ID
						 DBTemp_line->TOL_ID    := D_LINE->TOL_ID
						 DBTemp_line->TERM_ID   := D_LINE->TERM_ID
						 DBTemp_line->CPPROC_ID := D_LINE->CPPROC_ID
						 DBTemp_line->b_purp := D_LINE->b_purp
					 ELSE
						 DBTemp_line->PLINE_ID  := D_LINE->PLINE_ID
						 DBTemp_line->TERM_ID   := D_LINE->TERM_ID
					 ENDIF
		  ENDIF
        D_LINE->(DBSKIP())
END
DBTemp_line->(DBCLOSEAREA())

FOR i := 1 TO LEN(aDbfs)
    (aDbfs[i])->(dbclosearea())
NEXT

/*IF "CZ" $ GetUserInfo():cGroupID
	IF nChoice == 1
		COPY FILE &(cTempDir+"ND_LINE.DBF") TO FTP\D_LINE.DBF
		cScr := savescreen()
	   run "ftpeng_line.bat"
		RestScreen( ,,,, cScr )
	ELSE
		COPY FILE &(cTempDir+"ND_LINE.DBF") TO FTP\BATCHLST.DBF
		cScr := savescreen()
		run "ftpeng_blst.bat"
		RestScreen( ,,,, cScr )
	ENDIF
ELSE*/
	IF nChoice == 1 .AND. !lAuto
	   COPY FILE &(cTempDir+"ND_LINE.DBF") TO C:\AVX\DATA\D_LINE.DBF
	ELSEIF nChoice == 1
      COPY FILE &(cTempDir+"ND_LINE.DBF") TO &(cTempDir+"D_LINE.DBF")
	ELSEIF nChoice == 3
		COPY FILE &(cTempDir+"ND_LINE.DBF") TO C:\AVX\DATA\BATCHLST.DBF
	ELSE
		COPY FILE &(cTempDir+"ND_LINE.DBF") TO C:\AVX\DATA\BATCHLST.DBF
		COPY FILE &(cTempDir+"ND_LINE.DBF") TO U:\BATCHLST.DBF

		NetUse( "ND_LINE", STD_RETRY, , USE_EXCLUSIVE, USE_NEW, cTempDir)
		Lexport( ( "G:\FTP\BATCHLST.WK1") ,,,,"E4")
		COPY FILE G:\FTP\BATCHLST.WK1 TO U:\BATCHLST.WK1
		COPY TO U:\BATCHLST DELIMITED
		ND_LINE->(dbgotop())
		While !ND_LINE->(eof())
				 IF ND_LINE->ptype_id $ "C_F"
					 ND_LINE->esn_id  := substr(ND_LINE->esn_id,1,12)
				 ELSEIF ND_LINE->ptype_id $ "T_U"
					 ND_LINE->esn_id  := substr(ND_LINE->esn_id,1,13)
				 ELSEIF ND_LINE->ptype_id $ "L"
				    ND_LINE->esn_id  := substr(ND_LINE->esn_id,1,11)
				 ENDIF
				 ND_LINE->(dbskip(1))
		end

		ND_LINE->(dbclosearea())

		IF !file(cTempDir+"PD_LINE.DBF")
			 COPY FILE &(cTempDir+"ND_LINE.DBF") TO &(cTempDir+"PD_LINE.DBF")
			 NetUse( "PD_LINE", STD_RETRY, , USE_EXCLUSIVE, USE_NEW, cTempDir)
			 CheckIndex("Ibid", GetUserInfo():cTempDir + "PD_LINE","b_id",.T.)
		else
			 COPY FILE &(cTempDir+"ND_LINE.DBF") TO &(cTempDir+"TD_LINE.DBF")
			 NetUse( "PD_LINE", STD_RETRY, , USE_EXCLUSIVE, USE_NEW, cTempDir)
			 PD_LINE->(ORDSETFOCUS(1))
			 PD_LINE->(DbReindex())
		ENDIF

		NetUse( "ND_LINE", STD_RETRY, , USE_EXCLUSIVE, USE_NEW, cTempDir)

		ND_line->(DBGOTOP())

		while !ND_LINE->(eof())
		      IF  PD_LINE->(dbseek(ND_LINE->b_id))
					 ND_LINE->(dbdelete())
		      ENDIF
				ND_LINE->(dbskip(1))
		End

		ND_LINE->( __DBPACK())

		PD_LINE->(dbclosearea())
		COPY FILE &(cTempDir+"TD_LINE.DBF") TO &(cTempDir+"PD_LINE.DBF")
		dbselectarea("ND_LINE")

		if !ND_LINE->(eof()) .AND. !ND_LINE->(bof())
			COPY FIELDS SPC_BID,ESN_ID,PFAM TO U:\SPCBLIST DELIMITED WITH " "
			DBCLOSEAREA()
			COPY FILE U:\SPCBLIST.TXT TO Y:\BATCHLST.TXT
		else
			DBCLOSEAREA()
		endif

	ENDIF
//ENDIF


IF !lAuto .AND. !lSecondFase
	ALERT("Database updated !")
ENDIF

RESTSCREEN(2,0,24,80,cOldScr)

IF lAuto
	UP_DLINE(.F.,.T.)
ENDIF

RETURN nil

procedure spcpreps()

local aFiles,i,j,nHandle,cBuffer,k
local aTmp := {},hOut,cur_str
local cBid,CWaf,cEsn,cProcNm,cPtype
local dCrDate,cCrTime
local aFileInfo := {},aMes := {}
local cProc,CProcAdd,cprocBms,nRecNo
LOCAL cTempDir  := GetUserInfo():cTempDir
local cSrcNM,CDestNm,hLog,nMesCount := 0

local AStru     := {{"B_ID"       ,"C", 8 , 0  },;
		              {"cWaf"       ,"C", 2 , 0  },;
						  {"SPC_NME"    ,"C", 30, 0  },;
		              {"add_info"   ,"C", 30, 0  },;
		              {"proc_ID"    ,"C", 5 , 0  },;
		              {"esn_ID"     ,"C", 16, 0  },;
						  {"p_fam"      ,"C", 15, 0  },;
						  {"thick_a"    ,"N", 10, 4  },;
						  {"thick_b"    ,"N", 10, 4  },;
						  {"thick_c"    ,"N", 10, 4  },;
						  {"mes_count"  ,"N", 1, 0   }}



/*hlog:=fcreate(cTempDir+"P16last.txt")
fwrite(hlog,'I was here ' + time()+EOL)
fclose(hlog)*/

lf_chdir("G:\avxbms\spc")
aFiles := Directory("G:\avxbms\spc\*.*","D")

FOR i := 1 TO len(afiles)
		aadd(atmp,lf_tolong(afiles[i,1]))
NEXT

aFiles := {}

FOR i := 1 TO len(atmp)
	 IIF("$M" $ atmp[i] .AND. (len(atmp[i]) == 25 .OR. len(atmp[i]) == 26),aadd(aFiles,atmp[i]) ,nil )
NEXT

Netuse("d_line");d_line->(ordsetfocus(1));Netuse("bms2spc");bms2spc->(ordsetfocus(1))
Netuse("c_ptype");c_ptype->(ordsetfocus(1));Netuse("m_linemv");m_linemv->(ordsetfocus(2))
Netuse("m_spc")


FOR i := 1 TO len(aFiles)
	  //Fase I looking for P16 files and scrapping DATA into arrays
	  k := 0
	  aMes := {}
	  cBuffer := lf_memoread(aFiles[i]+"\seqstat.txt")
	  aFileInfo := lf_getftime(aFiles[i]+"\seqstat.txt",LFN_CRETIME)

	  cBid := substr(aFiles[i],15,6)
	  IIF(len(aFiles[i]) == 25 ,cWaf := substr(aFiles[i],24,2) ,cWaf := substr(aFiles[i],24,3) )

	  IF d_line->(dbseek(cBid))
	  	IF D_LINE->ptype_id $ "C_F"
	  	   cEsn  := substr(D_LINE->esn_id,1,12)
	  	ELSEIF D_LINE->ptype_id $ "T_U"
	  	   cEsn  := substr(D_LINE->esn_id,1,13)
	  	ELSEIF D_LINE->ptype_id $ "L_Z"
	  	   cEsn  := substr(D_LINE->esn_id,1,11)
	  	ENDIF

	  	IF c_ptype->(dbseek(D_LINE->ptype_id))
	  		cPtype := alltrim(c_ptype->PTYPE_NM)+"s"
	  	ENDIF

	  	IF m_linemv->(dbseek(cBid))
	  		while m_linemv->b_id == cBid
					 IF linRange(aFileInfo)
	  					IF bms2spc->(dbseek(m_linemv->CPPROC_ID ))
	  						cProc    := bms2spc->SPC_NME
	  						cProcAdd := bms2spc->ADD_INFO
	  						cprocBms := m_linemv->CPPROC_ID
						ELSE
							cProc    := "General"
							cProcAdd := "P16 Default thickness"
							cprocBms := m_linemv->CPPROC_ID
	  					ENDIF
						EXIT
					 ENDIF
	  				m_linemv->(dbskip(1))
	  		end
	  	ENDIF
	  ENDIF

	  do while !empty(cBuffer)
				  k++
				  j:=at(EOL,cBuffer)
				  IF empty(j)
				  	cur_str := cBuffer
				  ELSE
				  	cur_str := substr(cBuffer,1,j-1)
				  	cBuffer := substr(cBuffer,j+2)
				  ENDIF
				  IF val(Substr(cur_str,1,1)) >= 1 .AND. val(Substr(cur_str,1,1)) <= 9
					  aadd(aMes,val(Substr(cur_str,45,8)))
				  ENDIF
	  enddo
	  //Fase II Storing DATA into m_spc  dbf

	  IF !empty(aMes)
			  IF  Empty(cProc)
			      IF bms2spc->(dbseek(d_line->CPPROC_ID ))
			      	cProc    := bms2spc->SPC_NME
			      	cProcAdd := bms2spc->ADD_INFO
			      	cprocBms := d_line->CPPROC_ID
			      ELSE
			      	cProc    := "General"
			      	cProcAdd := "P16 Default thickness"
			      	cprocBms := d_line->CPPROC_ID
			      ENDIF
			  ENDIF

			IF m_spc->( AddRec(5,"spc_up") )

				m_spc->b_id     := cBid+"$M"
				m_spc->cWaf     := upper(cWaf)
				m_spc->proc_id  := cprocBms
				m_spc->SPC_NME  := cProc
				m_spc->ADD_INFO := cProcAdd
				m_spc->esn_id   := cEsn
				m_spc->p_fam    := cPtype
				IIF( len(aMes) > 0 ,m_spc->THICK_A  :=  aMes[1] ,nil )
				IIF( len(aMes) > 1 ,m_spc->THICK_B  :=  aMes[2] ,nil )
				IIF( len(aMes) > 2 ,m_spc->THICK_C  :=  aMes[3] ,nil )
				m_spc->( DBUNLOCK() )
			ENDIF
	  ENDIF

	  //Fase III move the files to backup and delete from "live" directory

		lf_fcopy(aFiles[i]+"\seqstat.txt","G:\avxbms\spc\back\"+cBid+cWaf+".txt")
		lf_ferase(aFiles[i]+"\seqstat.txt")
		lf_rmdir(aFiles[i])
NEXT

//Fase IV looking for "x" wafers and  prepare summery txt file for SPC
m_spc->(ordsetfocus("ispcx"))
m_spc->(dbgotop())
While !m_spc->(eof()) .AND. !m_spc->(bof())
 		cBid := m_spc->b_id;cProc := m_spc->SPC_NME
 		m_spc->(ordsetfocus("ispctop"))

 		IF FILE(cTempDir + "P162SPC.DBF")
 		   ERASE(cTempDir + "P162SPC.DBF")
 		ENDIF

 		DBCREATE( cTempDir + "P162SPC",AStru)
 		NetUse( "P162SPC", STD_RETRY, , USE_EXCLUSIVE, USE_NEW, cTempDir )
		m_spc->(dbseek(cBid+cProc))

 		While cBid == m_spc->b_id .AND. cProc == m_spc->SPC_NME

				nMesCount := 0

				P162SPC->(DBAPPEND())
 				P162SPC->B_ID     :=  m_spc->B_ID+"$M"
 				P162SPC->cWaf     :=  m_spc->cWaf
 				P162SPC->SPC_NME  :=  m_spc->SPC_NME
 				P162SPC->add_info :=  m_spc->add_info
 				P162SPC->proc_ID  :=  m_spc->proc_ID
 				P162SPC->esn_ID   :=  m_spc->esn_ID
 				P162SPC->p_fam    :=  m_spc->p_fam
 				P162SPC->thick_a  :=  m_spc->thick_a
 				P162SPC->thick_b  :=  m_spc->thick_b
 				P162SPC->thick_c  :=  m_spc->thick_c







           IF m_spc->thick_a <> 0
               nMesCount++
           ENDIF

			  IF m_spc->thick_b <> 0
			      nMesCount++
			  ENDIF

			  IF m_spc->thick_c <> 0
			      nMesCount++
			  ENDIF

			  P162SPC->mes_count = nMesCount

			  /*	IF m_spc->thick_a <> 0 .AND. m_spc->thick_b <> 0 .AND. m_spc->thick_c <> 0
					P162SPC->mes_count = 3
				ELSEIF m_spc->thick_a <> 0 .AND. m_spc->thick_b <> 0
					P162SPC->mes_count = 2
				ELSEIF m_spc->thick_a <> 0
					P162SPC->mes_count = 1
				ENDIF*/

				IF  m_spc->( RecLock( 5 ) )
					 m_spc->lspc := TRUE
					 m_spc->( DBUNLOCK() )
				ENDIF

				m_spc->(dbskip(1))
				//m_spc->(dbskip(-1))
 		End

		cSrcNM := "U:\P16_" + substr(cBid,3,3)
      cDestNM := "Y:\P16_" + substr(cBid,3,3)

 		IF !(P162SPC->(eof()) .AND. P162SPC->(bof()))//tmp file not zero
			 P162SPC->(dbgotop())
 			 COPY FIELDS B_ID,cWaf,SPC_NME,add_info,proc_ID,esn_ID,p_fam,thick_a,thick_b,thick_c,mes_count ;
 			 TO &(cSrcNM)  DELIMITED WITH " "
 			 P162SPC->(DBCLOSEAREA())
			 COPY FILE &(cSrcNM+".TXT") TO &(cDestNM+".TXT")
			 COPY FILE &(cSrcNM+".TXT") TO &("G:\avxbms\spc\back\"+cBid+".txt")
 		ENDIF
		m_spc->(ordsetfocus("ispcx"))
		m_spc->(dbskip(1));m_spc->(dbskip(-1))
End

CLOSE ALL

return

static Function linRange(aFileInfo)

local lRet := FALSE

IF m_linemv->Arr .AND. m_linemv->sta .AND. m_linemv->fin
	IF m_linemv->CP_DARR < aFileInfo[LFN_FDATE] .AND. m_linemv->CP_DFIN > aFileInfo[LFN_FDATE]
     lRet := TRUE
	ELSEIF m_linemv->CP_DARR == aFileInfo[LFN_FDATE] .AND. m_linemv->CP_DFIN == aFileInfo[LFN_FDATE] .AND. ;
			 m_linemv->CP_TARR <= aFileInfo[LFN_FTIME] .AND. m_linemv->CP_TFIN >= aFileInfo[LFN_FTIME]
	  lRet := TRUE
	ELSEIF m_linemv->CP_DARR < aFileInfo[LFN_FDATE] .AND. m_linemv->CP_DFIN == aFileInfo[LFN_FDATE] .AND. m_linemv->CP_TFIN >= aFileInfo[LFN_FTIME]
	  lRet := TRUE
	ENDIF
ELSEIF  m_linemv->Arr .AND. m_linemv->sta .AND. !m_linemv->fin
	IF m_linemv->CP_DARR < aFileInfo[LFN_FDATE] .AND. m_linemv->CP_DSTA > aFileInfo[LFN_FDATE]
	  lRet := TRUE
	ELSEIF m_linemv->CP_DARR == aFileInfo[LFN_FDATE] .AND. m_linemv->CP_DSTA == aFileInfo[LFN_FDATE] .AND. ;
			 m_linemv->CP_TARR <= aFileInfo[LFN_FTIME] .AND. m_linemv->CP_TSTA >= aFileInfo[LFN_FTIME]
	  lRet := TRUE
	ELSEIF m_linemv->cpproc_id == d_line->cpproc_id
	  lRet := TRUE
	ENDIF
ELSEIF  m_linemv->Arr .AND. !m_linemv->sta .AND. !m_linemv->fin
	IF m_linemv->CP_DARR < aFileInfo[LFN_FDATE]
	  lRet := TRUE
	ELSEIF m_linemv->CP_DARR == aFileInfo[LFN_FDATE] .AND. ;
			 m_linemv->CP_TARR <= aFileInfo[LFN_FTIME]
	  lRet := TRUE
	ELSEIF m_linemv->cpproc_id == d_line->cpproc_id
	  lRet := TRUE
	ENDIF
ENDIF

return lRet

FUNCTION UPDLINE()
LOCAL i
LOCAL aDbfs     := {"d_line","c_proc"}
LOCAL aNtxs     := {"dpctdesn","iproc_id"}
LOCAL cTempDir  := GetUserInfo():cTempDir
LOCAL AStru

	AStru     := {{"B_ID"       ,"C", 6, 0  },;
                 {"ESN_ID"     ,"C",16, 0  },;
					  {"PTYPE_ID"   ,"C", 1, 0  },;
                 {"SIZE_ID"    ,"C", 4, 0  },;
                 {"VALUE_ID"   ,"N", 9, 3  },;
                 {"TOL_ID"     ,"C", 1, 0  },;
					  {"TERM_ID"    ,"C", 1, 0  },;
					  {"CPPROC_ID"  ,"C", 5, 1  },;
					  {"PLINE_ID"   ,"C", 3, 0 }}


FOR i := 1 TO LEN(aDbfs)
         IF SELECT(aDbfs[i])== 0
            NetUse( aDbfs[i], STD_RETRY, RDD_IN_USE, USE_SHARED, USE_NEW, NIL )
         ENDIF
         (aDbfs[i])->(ordSETFocus( aNtxs[i]))
NEXT

/* USE "D_LINE" SHARED */



IF FILE(cTempDir + "ND_LINE.DBF")
   ERASE(cTempDir + "ND_LINE.DBF")
ENDIF

DBCREATE( cTempDir + "ND_LINE",AStru)

i := 0

c_proc->(dbseek("160.0"))


NetUse( "ND_LINE", STD_RETRY, , USE_EXCLUSIVE, USE_NEW, cTempDir,"DBTemp_line" )
D_LINE->(DBGOTOP())
WHILE  ! (D_LINE->(EOF()))
        IF d_line->cp_pccode < c_proc->pcprocno
                DBTemp_line->(DBAPPEND())
					 DBTemp_line->B_ID   := D_LINE->B_ID
                DBTemp_line->ESN_ID := D_LINE->ESN_ID
					 DBTemp_line->PTYPE_ID  := D_LINE->PTYPE_ID
					 DBTemp_line->PLINE_ID  := D_LINE->PLINE_ID
					 DBTemp_line->SIZE_ID   := D_LINE->SIZE_ID
					 DBTemp_line->VALUE_ID  := D_LINE->VALUE_ID
					 DBTemp_line->TOL_ID    := D_LINE->TOL_ID
					 DBTemp_line->TERM_ID   := D_LINE->TERM_ID
					 DBTemp_line->CPPROC_ID := D_LINE->CPPROC_ID
		  ENDIF
        D_LINE->(DBSKIP())
END


FOR i := 1 TO LEN(aDbfs)
    (aDbfs[i])->(dbclosearea())
NEXT

Lexport( ( "G:\FTP\BATCHLST.WK1") ,,,,"E4")
DBTemp_line->(DBCLOSEAREA())
COPY FILE &(cTempDir+"ND_LINE.DBF") TO G:\FTP\BATCHLST.DBF
//////////for yellow
	AStru     := {{"B_ID"       ,"C", 6, 0  },;
                 {"ESN_ID"     ,"C",16, 0  },;
					  {"PTYPE_ID"   ,"C", 1, 0  },;
                 {"SIZE_ID"    ,"C", 4, 0  },;
                 {"VALUE_ID"   ,"N", 9, 3  },;
                 {"TOL_ID"     ,"C", 1, 0  },;
					  {"TERM_ID"    ,"C", 3, 0  },;
					  {"CPPROC_ID"  ,"C", 5, 1  },;
					  {"PLINE_ID"   ,"C", 3, 0 }}

FOR i := 1 TO LEN(aDbfs)
         IF SELECT(aDbfs[i])== 0
            NetUse( aDbfs[i], STD_RETRY, RDD_IN_USE, USE_SHARED, USE_NEW, NIL )
         ENDIF
         (aDbfs[i])->(ordSETFocus( aNtxs[i]))
NEXT

/* USE "D_LINE" SHARED */

IF FILE(cTempDir + "ND_LINE.DBF")
   ERASE(cTempDir + "ND_LINE.DBF")
ENDIF

DBCREATE( cTempDir + "ND_LINE",AStru)

i := 0

c_proc->(dbseek("160.0"))


NetUse( "ND_LINE", STD_RETRY, , USE_EXCLUSIVE, USE_NEW, cTempDir,"DBTemp_line" )
D_LINE->(DBGOTOP())
WHILE  ! (D_LINE->(EOF()))
        IF d_line->cp_pccode < c_proc->pcprocno
                DBTemp_line->(DBAPPEND())
					 DBTemp_line->B_ID   := D_LINE->B_ID
                DBTemp_line->ESN_ID := D_LINE->ESN_ID
					 DBTemp_line->PTYPE_ID  := D_LINE->PTYPE_ID
					 DBTemp_line->SIZE_ID   := D_LINE->SIZE_ID
					 DBTemp_line->VALUE_ID  := D_LINE->VALUE_ID
					 DBTemp_line->TOL_ID    := D_LINE->TOL_ID
					 DBTemp_line->TERM_ID   := D_LINE->PLINE_ID
					 DBTemp_line->CPPROC_ID := D_LINE->CPPROC_ID
					 DBTemp_line->PLINE_ID  := D_LINE->PLINE_ID
		  ENDIF
        D_LINE->(DBSKIP())
END


FOR i := 1 TO LEN(aDbfs)
    (aDbfs[i])->(dbclosearea())
NEXT

Lexport( ( "G:\FTP\YELLOW\BATCHLST.WK1") ,,,,"E4")
DBTemp_line->(DBCLOSEAREA())
COPY FILE &(cTempDir+"ND_LINE.DBF") TO G:\FTP\YELLOW\BATCHLST.DBF
COPY FILE &(cTempDir+"ND_LINE.DBF") TO C:\AVX\DATA\BATCHLST.DBF
Msg24("Cu plating data updated", 3, .T. )


RETURN nil