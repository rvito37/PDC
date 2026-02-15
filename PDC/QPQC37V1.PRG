#include "avxdefs.ch"

STATIC oMyRep,lEngMode

Function ShpQuery(lEng)

LOCAL oRep
LOCAL ReportFunc := "QPQC37V1"

MEMVAR aBuffer


lEngMode := lEng
oRep := TheReport():New(ReportFunc,"Shipments Query")

oRep:SetSort({"B/N + Shipment Date + time" } )
oRep:SetExprSort({"b_id" } )

oRep:SetCrit({ "Batch number" })
oRep:SetCheck({{|o| GetBatch(o,{"000000"})} })
oRep:SetBuffer({"Batch number"})

oRep:SetQueryBlocks({ {|| d_dlvntD->b_ID == aBuffer[1]}})


oRep:SetFields( {"B_ID" ,"SHPDOC","GetAWB(SHPDOC,DOC_TYPE,1)","GetAWB(SHPDOC,DOC_TYPE,2)","GetAWB(SHPDOC,DOC_TYPE,3)","GetbStat(B_ID,1)","GetbStat(B_ID,2)","GetAWB(SHPDOC,DOC_TYPE,4)" })
oRep:SetTitles( {"B/N"  ,"Ref#"  ,"AWB #"                    ,"Type"                     ,"Date"                     ,"ST"              ,"Proc"            ,"Time"             })

oRep:SetDB({"d_dlvntD","d_dlvntH","d_line","C_PROC"})

oRep:cRepFileName := ReportFunc

oRep:QApplyKeys := {|nKey , o , oForm | ShpQueryKeys(nKey,o,oForm ) }

oRep:aKeyList := { {"F3       - Print Query                               ",K_F3   } }
oRep:lPrepDBF := TRUE
oRep:cPrepDbf :="t_shp01"
oRep:cTypeOfReport := "QUERY"
oMyRep := oRep
oRep:Exec()

Return NIL


Function GetAWB(nSHPDOC,cDOCTYPE,nIndex)

local cRetVal

d_dlvntH->(dbseek(str(999999 - nSHPDOC,6)+cDOCTYPE))

IF nIndex == 1
	cRetVal := d_dlvntH->AWB_NO
ELSEIF nIndex == 2
   cRetVal := d_dlvntH->doc_type
ELSEIF nIndex == 3
   cRetVal := d_dlvntH->DADD_REC
ELSEIF nIndex == 4
   cRetVal := d_dlvntH->tlu_rec
ENDIF

Return cRetVal

Function GetbStat(cBid,nIndex)

local cRetVal

d_line->(dbseek(cBid))
IF nIndex == 1
   cRetVal := d_line->b_stat
ELSE
   cRetVal := CurrProcName( d_line->cpproc_id,lEngMode )
ENDIF

Return cRetVal


FUNCTION ShpQueryKeys( nKey , oBroCenter , oForm )
LOCAL lProcessed := .T.
LOCAL nSaveRec
LOCAL cDbfile , cDriver ,cTmpDbfile
LOCAL cFileName := oMyRep:aDBs[1]

RETURN lProcessed