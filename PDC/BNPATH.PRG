// G:\DVLPDC\SOURCE\BNPATH.PRG
#include "avxdefs.ch"

STATIC cBN , bKey

PROCEDURE BNpath
LOCAL nStep := 1
LOCAL oBN
LOCAL oLineMove
LOCAL oProc

IF !IfEnglish()
	@ 1,0 SAY Padc( "Ñêé åÖåëé ööåâÄô" , 80 ) COLOR "N/W"
ELSE
	@ 1,0 SAY Padc( "Batch line movement Query" , 80 ) COLOR "N/W"
ENDIF


oProc := TabBase():new( "c_proc" ,{"iproc_id"} )
oProc:xopen()

oBN := TabBase():new( "d_line" )// ,{"ib_idln"} )
oBN:setIndexList()
oBN:xopen()

oLineMove := TabBase():new( "m_linemv" ,{"ilnmvbs"} )
oLineMove:xopen()

SELECT m_linemv

WHILE .T.
   DO CASE
      CASE nStep = 1
           GetBN()
          IF LastKey() = K_ESC
             EXIT
          ELSEIF LastKey() = K_ENTER
             nStep := 2
          ENDIF
      CASE nStep = 2
			  IF val(d_line->CP_PCCODE)>=4550
				 @04,09 TO 21,70 DOUBLE COLOR "w+/bg"
				 MEMOEDIT(d_line->pack_mem,5,10,20,69,.F.)
			  ENDIF
           ShowBNpath()
           IF LastKey() = K_ESC
              nStep := 1
           ENDIF
   ENDCASE
ENDDO

cBN := NIL
oLineMove:close()
oProc:close()
oBN:close()
RETURN

Static PROCEDURE GetBN
LOCAL bInsSave  ,;
      nCursSave

DEFAULT cBN TO "      "

@ 3,4  SAY "B/N:" COLOR if( IsColor() , "W+/B" , "W+/N" )
@ 3,8  GET cBN COLOR if( IsColor() , "W+/B,W+/R" , "W+/N,N/W" ) ;
                 PICTURE "@K 999999" ;
                 SEND postBlock := { |o| postBN(o) }

XREADALL
GetList := {}

RETURN


Static FUNCTION postBN(o)
LOCAL lRetVal
LOCAL cBuffer := StrZero(Val(o:varGet()),6)

IF Empty( cBuffer )
   Msg24( {"10"} , 3 , .T. )
   RETURN .F.
ENDIF

IF d_line->( DbSeek( cBuffer ) )
   lRetVal := .T.
   SayBnDtails()  // purp  type
   o:varPut( cBuffer )
   o:display()
ELSE
   Msg24( {"90"} , 3 , .T. )
   lRetVal := .F.
ENDIF

RETURN lRetVal

STATIC PROCEDURE SayBnDtails
LOCAL nSelect := Select( Alias() )
LOCAL o
LOCAL cBtypeNme , cBpurpNme , cTitle

o := TabBase():new( "c_bpurp" )
o:xopen()
SELECT c_bpurp
LOCATE FOR c_bpurp->b_purp == d_line->b_purp
IF c_bpurp->( Found() )
   cBpurpNme := alltrim(c_bpurp->bpurp_nme)
ELSE
   cBpurpNme := ""
ENDIF
o:close()

o := TabBase():new( "c_btype", {"ibtype"} )
o:xopen()
IF c_btype->(DbSeek(d_line->b_type+d_line->esnxx_id+d_line->pline_id))
   cBtypeNme := alltrim(c_btype->btype_nme)
ELSE
   cBtypeNme := ""
ENDIF
o:close()

cTitle := "Purpose:" + cBpurpNme + "  Type:" + cBtypeNme
@ 2,3 SAY Padr(cTitle,74) COLOR if( IsColor() , "W+/B" , "W+/N" )
@ 3,23 SAY Padr("Loc:" + GetLoc(),74) COLOR if( IsColor() , "W+/B" , "W+/N" )
SELECT ( nSelect )

RETURN

static function Getloc()

local cRet := "òÖñâ"
local nOldarea := Select()

Netuse("m_loc",5);ordsetfocus(1)


if m_loc->(dbseek(d_line->b_id))
	While m_loc->b_id == d_line->b_id
			m_loc->(dbskip(1))
	End
	m_loc->(dbskip(-1))
	cRet := m_loc->loc+" #"+dtoc(m_loc->dadd_rec)+" #"+m_loc->tlu_rec
endif

m_loc->(dbclosearea())
dbselectarea(nOldarea)

return cRet


STATIC PROCEDURE ShowBNpath()
LOCAL o , nKey
LOCAL nRefreshCount := 0 , nTimeCounter := 0 , nTimeOut := 1000000

o := CreateBro()
o:goTop()

IF m_linemv->( Eof() )
	IF !IfEnglish()
		Alert( "!! ÖÜ Ñêéå çâêÖöê ÖÄñéê Äå" , {"Enter"} )
	ELSE
      Alert( "No information found for this batch !" , {"Enter"} )
	ENDIF
   SetLastKey(K_ESC)
   RETURN
ENDIF
o:refreshAll()

WHILE .T.

    WHILE !o:stabilize() ; ENDDO

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

    IF nKey = K_ESC
       EXIT
    ELSEIF StdKeys( nKey , o )
    ENDIF

ENDDO

RETURN

STATIC FUNCTION CreateBro
LOCAL oCol  , o

o := TBrowseDB(4,0,23,79)

o:headSep := "Õ"
o:colSep  := "≥"
o:footSep := "Õ"

oCol := TBColumnNEW( "Pr" , {|| m_linemv->b_prior } )
oCol:colorBlock := { |xVal| if( m_linemv->arr .AND. !m_linemv->fin,{2,1} , {1,2}) }
o:addColumn( oCol )
oCol := TBColumnNEW( "Stage" , {|| Str(m_linemv->cp_stage,5) } )
oCol:colorBlock := { |xVal| if( m_linemv->arr .AND. !m_linemv->fin,{2,1} , {1,2}) }
o:addColumn( oCol )
oCol := TBColumnNEW( "Process & name            " , {|| m_linemv->cpproc_id+" "+ProcName() } )
oCol:colorBlock := { |xVal| if( m_linemv->arr .AND. !m_linemv->fin,{2,1} , {1,2}) }
o:addColumn( oCol )
oCol := TBColumnNEW( "Wfr" , {|| Transform(m_linemv->cp_bqtyw,"999") } )
oCol:colorBlock := { |xVal| if( m_linemv->arr .AND. !m_linemv->fin,{2,1} , {1,2}) }
o:addColumn( oCol )
oCol := TBColumnNEW( "Str" , {|| Transform(m_linemv->cp_bqtys,"99,999") } )
oCol:colorBlock := { |xVal| if( m_linemv->arr .AND. !m_linemv->fin,{2,1} , {1,2}) }
o:addColumn( oCol )
oCol := TBColumnNEW( "Pcs" , {|| Transform(m_linemv->cp_bqtyp,"9,999,999") } )
oCol:colorBlock := { |xVal| if( m_linemv->arr .AND. !m_linemv->fin,{2,1} , {1,2}) }
o:addColumn( oCol )
oCol := TBColumnNEW( "Arr Date    Time " , {|| if(m_linemv->arr,"Yes","No ")+" "+Dtoc(m_linemv->cp_darr)+" "+Left(m_linemv->cp_tarr,5)})
oCol:colorBlock := { |xVal| if( m_linemv->arr .AND. !m_linemv->fin,{2,1} , {1,2}) }
o:addColumn( oCol )
oCol := TBColumnNEW( "Sta Date    Time " , {|| if(m_linemv->sta,"Yes","No ")+" "+Dtoc(m_linemv->cp_dsta)+" "+Left(m_linemv->cp_tsta,5)})
oCol:colorBlock := { |xVal| if( m_linemv->arr .AND. !m_linemv->fin,{2,1} , {1,2}) }
o:addColumn( oCol )
oCol := TBColumnNEW( "Fin Date    Time " , {|| if(m_linemv->fin,"Yes","No ")+" "+Dtoc(m_linemv->cp_dfin)+" "+Left(m_linemv->cp_tfin,5)})
oCol:colorBlock := { |xVal| if( m_linemv->arr .AND. !m_linemv->fin,{2,1} , {1,2}) }
o:addColumn( oCol )

o:gotopBlock    := {|| m_linemv->(Top(cBN))}
o:gobottomBlock := {|| m_linemv->(Bot(cBN))}
o:skipBlock     := {|n| m_linemv->(SkipIt(n,cBN,bKey))}
bKey            := COMPILE( m_linemv->( IndexKey() ) )

RETURN o


STATIC FUNCTION ProcName()
LOCAL cRetVal
IF c_proc->( DbSeek( m_linemv->cpproc_id ) ) .AND. !IfEnglish()
   cRetVal := c_proc->proc_nmh
ELSEIF c_proc->(Found()) .AND. IfEnglish()
   cRetVal := c_proc->proc_nme
ELSE
   cRetVal := Space(20)
ENDIF
RETURN cRetVal

FUNCTION  ReprnBN()

LOCAL nStep := 1
LOCAL oBN
LOCAL oLineMove
LOCAL oProc
LOCAL cFile
LOCAL lGo :=.f.

IF !IfEnglish()
	@ 1,0 SAY Padc( "Ñêé çÖâë á'ÖÉ öòÜÖá ÑëîÉÑ" , 80 ) COLOR "N/W"
ELSE
	@ 1,0 SAY Padc( "Reprint Completion Batch Report" , 80 ) COLOR "N/W"
ENDIF


oProc := TabBase():new( "c_proc" ,{"iproc_id"} )
oProc:xopen()

oBN := TabBase():new( "d_line" )
oBN:setIndexList()
oBN:xopen()

oLineMove := TabBase():new( "m_linemv" ,{"ilnmvbs"} )
oLineMove:xopen()
GenOpenFiles({"d_finqc","h_finqc","a_finqc"})

SELECT m_linemv

       GetBN()
       IF LastKey()<>K_ESC

          IF ! D_Finqc->(DBSEEK(cBN))

              IF ! H_Finqc->(DBSEEK(cBN))

                   IF ! A_Finqc->(DBSEEK(cBN))
                   ELSE
                      cFile := "A_Finqc"
                      lGo := .t.
                   ENDIF
              ELSE
                    cFile := "H_Finqc"
                    lGo := .t.
              ENDIF
          ELSE
               cFile := "D_Finqc"
               lGo := .t.
          ENDIF
          IF lGo
           MyShowQcDoc( cFile,cBN )
          ELSE
	         IF !IfEnglish()
		          Alert( "!! ÖÜ Ñêéå çâêÖöê ÖÄñéê Äå" , {"Enter"} )
          	ELSE
                Alert( "No information found for this batch !" , {"Enter"} )
	         ENDIF
          ENDIF
       ENDIF
cBN := NIL
GenCloseFiles({"d_finqc","h_finqc","a_finqc"})
oLineMove:close()
oProc:close()
oBN:close()
RETURN Nil