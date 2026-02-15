
// G:\DVLPDC\SOURCE\STOKWORK.PRG
#include "avxdefs.ch"

STATIC cWork , bKey
STATIC nMone:=1 ,nMaxMone,aIndex

PROCEDURE StockInWorkStation
LOCAL nStep := 1
LOCAL oLineMove
LOCAL oWork
field cpproc_id
aIndex := {"IWSLACK"}

IF !IfEnglish()
	@ 1,0 SAY Padc( "„‡š ‰€ŒŽ ššŒ‰€™" , 80 ) COLOR "N/W"
ELSE
	@ 1,0 SAY Padc( "Workstation WIP Query" , 80 ) COLOR "N/W"
ENDIF


oWork := TabBase():new( "C_wkstn" ,{"C_wkstn"} )
oWork:xopen()
oLineMove := TabBase():new( "D_line" ,{aIndex[1]} )
oLineMove:xopen()
GenOPenFiles({"C_leadt","C_bstat","c_proc"})

c_proc->(ordsetfocus(1))


SELECT D_line

Set Relation to cpproc_id into c_proc

WHILE .T.
   DO CASE
      CASE nStep = 1

           GetWork()
           IF LastKey() = K_ESC
              EXIT
           ELSEIF LastKey() = K_ENTER
              nStep := 2
           ENDIF

		CASE nStep = 2

		     aIndex := {"IWSLACK","iwSlack_1","iwSlack_2","iwSlack_3","iwSlack_4","iwSlack_5","iwSlack_6","iwSlack_0","iwSlack_7"}
			  IF !"GRU"$ cWork
			  	 d_line->(ordsetfocus(aIndex[1]))
			  ELSEIF "GRU1" == cWork
             d_line->(ordsetfocus(aIndex[2]))
			  ELSEIF "GRU2" == cWork
			    d_line->(ordsetfocus(aIndex[3]))
			  ELSEIF "GRU3" == cWork
			    d_line->(ordsetfocus(aIndex[4]))
			  ELSEIF "GRU4" == cWork
			    d_line->(ordsetfocus(aIndex[5]))
			  ELSEIF "GRU5" == cWork
			    d_line->(ordsetfocus(aIndex[6]))
			  ELSEIF "GRU6" == cWork
			    d_line->(ordsetfocus(aIndex[7]))
			  ELSEIF "GRU0" == cWork
			    d_line->(ordsetfocus(aIndex[8]))
			  ELSEIF "GRU7" == cWork
			    d_line->(ordsetfocus(aIndex[9]))
			  ENDIF


			  ShowStockInWork()
           IF LastKey() = K_ESC
              nStep := 1
           ENDIF
   ENDCASE
ENDDO
cWork := NIL
oLineMove:close()
oWork:close()
GenCloseFiles({"C_leadt","C_bstat","c_proc"})
RETURN

STATIC PROCEDURE GetWork
LOCAL bInsSave  ,;
      nCursSave

DEFAULT cWork TO "    "

@ 3,4  SAY "Workstation:" COLOR if( IsColor() , "W+/B" , "W+/N" )
@ 3,16 GET cWork COLOR if( IsColor() , "W+/B,W+/R" , "W+/N,N/W" ) ;
                 PICTURE "!!!!" ;
                 SEND PreBlock  := {|o| PrePick( o, "c_wkstn")}  ;
                 SEND postBlock := {|o| postWork(o) } //VR 20-06-01 16201459

XREADALL
GetList := {}

RETURN


STATIC FUNCTION postWork(o)
LOCAL lRetVal
LOCAL nSelect := Select( Alias() )

IF Empty( o:varGet() )
   Msg24( {"208"} , 3 , .T. )
   RETURN .F.
ENDIF

SELECT c_wkstn
LOCATE FOR c_wkstn->wkstn_id == o:varGet()
IF c_wkstn->( Found() )
   @ 3,21 SAY Alltrim(IIF(!IfEnglish() ,c_wkstn->wkstn_nmh ,c_wkstn->wkstn_nme )  ) + Space( 40 )
   lRetVal := .T.
ELSEIF o:varGet() == "GRU1"
	@ 3,21 SAY "Lito + Neg + Pos" + Space( 40 )
	lRetVal := .T.
ELSEIF o:varGet() == "GRU2"
	@ 3,21 SAY "Polymid" + Space( 40 )
	lRetVal := .T.
ELSEIF o:varGet() == "GRU3"
	@ 3,21 SAY "Chemical" + Space( 40 )
	lRetVal := .T.
ELSEIF o:varGet() == "GRU4"
	@ 3,21 SAY "Electroplating" + Space( 40 )
	lRetVal := .T.
ELSEIF o:varGet() == "GRU5"
	@ 3,21 SAY "Cure" + Space( 40 )
	lRetVal := .T.
ELSEIF o:varGet() == "GRU6"
	@ 3,21 SAY "Measurements" + Space( 40 )
	lRetVal := .T.
ELSEIF o:varGet() == "GRU0"
	@ 3,21 SAY "Substrate Cleaning" + Space( 40 )
	lRetVal := .T.
ELSEIF o:varGet() == "GRU7"
	@ 3,21 SAY "ET - 6" + Space( 40 )
	lRetVal := .T.
ELSE
   Msg24( {"209"} , 3 , .T. )
   lRetVal := .F.
ENDIF

SELECT ( nSelect )
RETURN lRetVal


STATIC PROCEDURE ShowStockInWork()
LOCAL o , nKey
LOCAL nRefreshCount := 0 , nTimeCounter := 0 , nTimeOut := 1000000

o := CreateBro()
o:goTop()

IF d_line->( Eof() )
	IF !IfEnglish()
		Alert( "!! …† „‡šŒ ‰…š …€–Ž €Œ" , {"Enter"} )
	ELSE
          Alert( "No records found for this station !" , {"Enter"} )
	ENDIF
   SetLastKey( K_ESC )
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

o := TBrowseDB(4,0,22,79)

o:headSep := "Í"
o:colSep  := "³"
o:footSep := "Í"
o:colorSpec := if(IsColor(),"W+/B,W+/R,B/Bg","w/n,n/w,w/n,w/n,w+/n")


oCol := TBColumnNEW( "P;u"                , {|| D_line->b_purp} )
oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})}
o:addColumn( oCol )

oCol := TBColumnNEW( "Esn"                , {|| D_line->esn_id} )
oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})}
o:addColumn( oCol )

oCol := TBColumnNEW( "Batch"             , {|| D_line->b_id } )
oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})}
o:addColumn( oCol )

oCol := TBColumnNEW( "Wfr"       , {|| Transform(D_line->cp_bqtyw,"999") } )
oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})}
o:addColumn( oCol )

oCol := TBColumnNEW( "Pcs"          , {|| Transform(D_line->cp_bqtyp,"9,999,999") } )
oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})}
o:addColumn( oCol )

oCol := TBColumnNEW( "Proc"         , {|| D_line->cpproc_id} )
oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})}
o:addColumn( oCol )

oCol := TBColumnNEW( "Proc Name"    , {|| c_proc->PROC_NMH} )
oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})}
o:addColumn( oCol )


oCol := TBColumnNEW( "St"      , {|| D_line->B_stat} )
oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})}
o:addColumn( oCol )

oCol := TBColumnNEW( "Pr"      , {|| D_line->B_prior} )
oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})}
o:addColumn( oCol )

oCol := TBColumnNEW( "Days"  , {|| Transform(Date()-D_line->cp_darr,"999999") } )
oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})}
o:addColumn( oCol )

oCol := TBColumnNEW( " Slack "            , {|| Slack("D_line") } )
oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})}
o:addColumn( oCol )

oCol := TBColumnNEW( "Comments        " , {|| D_line->B_remark} )
oCol:colorBlock:={||Iif(EMPTY(D_line->Cp_dSta),{1,2},{3,2})}
o:addColumn( oCol )

o:gotopBlock    := {|| d_line->(Top(cWork))}
o:gobottomBlock := {|| d_line->(Bot(cWork))}
o:skipBlock     := {|n| d_line->(SkipIt(n,cWork,bKey))}
bKey            := COMPILE( d_line->( IndexKey() ) )

RETURN o