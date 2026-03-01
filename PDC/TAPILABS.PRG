// Function/Procedure Prototype Table  -  Last Update: 04-06-97 @ 14:30:01Pm
// ��������������������������������������������������������������������������
// Return Value         Function/Arguments
// �������������������  �����������������������������������������������������
// NIL                  STATIC FUNCTION AddALine( aLab, n, nWhich, l1st )
// NIL                  STATIC FUNCTION BtchPrn( nTo )
// TRUE                 STATIC FUNCTION ResetPics( n )
// NIL                  STATIC FUNCTION SetUpLabPrn( nFrom, nTo )
// NIL                  FUNCTION DrawBox(t,l,b,r)
// NIL                  FUNCTION LetsPrintSomeLabels
// NIL                  FUNCTION PrnBoxLabels
// NIL                  FUNCTION PrnLabels
// NIL                  FUNCTION PrnTestLabels


#include "avxdefs.ch"
#include "edi.ch"
#xtranslate LabelPad(<cStr>)   => PADR(<cStr>, 43 ) // it's compressed printing
#define LABELLINES      5
#define Kyo_reset  '!R! RES; EXIT;'            // reset to std Kyocera mode
#define Kyo_12p    ""//'!R! FONT 8411 ; EXIT ; '      // Heb font 12 pitch
#define Kyo_17p    '!R! FONT 8421; EXIT;'      // Heb font 17 pitch
#define Kyo_52p    '!R! FONT 52; EXIT;'          // font for B_ID
#define Kyo_space  '!R! UNIT D;SLS 51; EXIT;'            // line spacing
#define Kyo_top    '!R! UNIT D;STM 43; EXIT; '           // top margin
#define Kyo_lines  '!R! UNIT D;SLPP 67; EXIT;'           // lines per page

STATIC nWaf,nReel,nGlobal,nLine,cBoxLine,cReelLine,lZebraMode

FUNCTION StevePrintSomeLabels(lZebra)

LOCAL cOldScr    := SAVESCREEN()
LOCAL nFrom      := Space(6)
LOCAL nTo        := Space(6)
LOCAL aType      := {"By Batch Nos."}
LOCAL nSelect    := SELECT()
LOCAL cPurp      := "1"

default lZebra to FALSE
lZebraMode := lZebra

IF SELECT("D_Line") == 0
     NetUse( "D_Line", STD_RETRY, RDD_IN_USE, USE_SHARED, USE_NEW, NIL )
ENDIF
d_line->( DBCLEARINDEX() )
d_line->( ordsetfocus("ib_idln") )

@ 2, 3 CLEAR TO 20, 63
DrawBox(10, 27, 15, 47)

@ 7, 27 SAY " TAPI Label Printing" COLOR "W+/B"

@ 12, 29 SAY "From B/N: " GET nFrom PICTURE "999999"
@ 13, 29 SAY "To B/N:   "
XREAD
nTo := nFrom
@ 13, 29 SAY "To B/N:   " GET nTo   PICTURE "999999"  VALID nTo >= nFrom
XREAD


XREAD

RESTSCREEN(,,,,cOldScr)
SETCURSOR(0)

IF LASTKEY() == K_ESC
ELSE
     ALERT("Make sure that the correct labels are in the printer;"+;
          "and the printer is online.",{"OK"}, ALERT_STD)
     SetUpLabPrn(nFrom, nTo )
ENDIF

CLOSE d_Line
SELECT (nSelect)

RETURN NIL


STATIC FUNCTION SetUpLabPrn(nFrom, nTo, cPurp )

LOCAL cFrom, cTo

d_line->( ORDSETFOCUS("ib_idln") )
d_line->( DBSEEK( nFrom, TRUE ) )
cFrom := nFrom
cTo   := nTo

IF d_line->( EOF() )
     Msg24("No labels found in the range of:"+cFrom+"-"+cTo, 3, .T. )
     d_line->( ORDSETFOCUS("ib_idln") )
     d_line->( DBGOTOP() )
ELSE
     b_idPrn( nTo )
ENDIF

d_line->( ORDSETFOCUS("ib_idln") )
d_line->( DBGOTOP() )

RETURN NIL

STATIC FUNCTION b_idPrn( nTo, cPurp )

LOCAL cOldScr := SAVESCREEN()
LOCAL nMAX  := 8
LOCAL nCopies := 0,k := 1,j
LOCAL cLblFile := "LBL_PACK.TXT"
LOCAL hLblFile := 99,cTempDir := GetUserInfo():cTempDir

@ 09,24 CLEAR TO 14,56
@ 09,24 TO 14,56 DOUBLE
@ 11,25 SAY "Printing Labels, please wait..."
@ 14, 40 SAY " ESC to Abort " COLOR "W+/B"
SET device to printer
SET CONSOLE OFF
SET PRINTER ON

cBoxLine:= ""
cReelLine := ""

IF !"CZ"    $ GetUserInfo():cGroupID .AND. ;
   !"VIZ"   $ GetUserInfo():cUserId  .AND. ;
   !"SORT"  $ GetUserInfo():cUserId
   ? '!R! CASS 0; EXIT;'
ENDIF  //EDOMO+VR 21-05-03
GenOpenFiles({"c_esny","c_proc","c_expqty"})
WHILE d_line->B_id <= nTo .AND. !d_line->(EOF()) .AND. LASTKEY() <> K_ESC
          IF d_line->b_stat $ 'CM'
               alert("You are about to print label for "+;
                    if(d_line->b_stat=="C","closed","frozen")+;
                    " batch")
          end
          ??Kyo_lines                          // sets lpp to 65
          ??Kyo_17p                            // Kyocera 17 pitch
          ??Kyo_space                          // Kyocera line spacing
          ??Kyo_top                            // Kyocera top margin
          //000306 vitaly 23.12.2000

          c_esny->(ordsetfocus(1))
          c_proc->(ordsetfocus(1))
          c_esny->(dbseek(d_line->esny_id))
          IIF(c_esny->esny_id $ "1_3_4_7_B_C_D_K_M_H_Z_S_",nCopies := 16 ,nCopies := batchCALC1("d_line")[2] / c_esny->esny_qty)

          FOR j := 1 TO NotCommas(nCopies / 16)
                FOR nWaf := k  TO k + 7
                    PrnLabels(hLblFile)
                NEXT
                k := k + 16
          NEXT  j

          EJECT // temporary
     d_line->( DBSKIP())
END
IF  lZebraMode
 hLblFile := fcreate(cTempDir+cLblFile)
 FOR j := 1  to 5
	 fwrite(hLblFile,cBoxLine)
	 IF c_esny->esny_id == "B"
	    EXIT
	 ENDIF
 NEXT

 IF c_esny->esny_id <> "B"
 FOR j := 1  to IIF(c_esny->esny_id $ "1_3_4_7_C_D_K_M_H_Z_S_" ,8 ,NotCommas(nCopies) + 5 )
	 cReelLine := stuff(cReelLine,30,2,str(j,2))
	 fwrite(hLblFile,cReelLine)
 NEXT
 ENDIF

 fclose(hLblFile)
 COPY FILE (cTempDir+cLblFile) TO ('G:\USERS\AUTOMAIL\'+cLblFile)

ENDIF



IF !"CZ"    $ GetUserInfo():cGroupID .AND. ;
   !"VIZ"   $ GetUserInfo():cUserId  .AND. ;
   !"SORT"  $ GetUserInfo():cUserId
	? '!R! CASS 1; EXIT;'
ENDIF
GenCloseFiles({"c_esny","c_proc","c_expqty"})

SET PRINTER OFF
SET PRINTER TO
Set Device to screen
Setcap()                 // restores users original capture SS 28-10-97
RESTSCREEN(,,,,cOldScr)
RETURN NIL

STATIC FUNCTION AddALine( aLab, nRow, nCol,hLblFile)

local lFaseII := FALSE

LOCAL i,aLines := {;
     IF(nCol=1,"AVX-KYOCERA ","")+" BATCH: "+Kyo_52p+d_line->b_purp+'_'+d_line->B_ID+Kyo_17p+;
     IF(nCol=2 ,"    REEL: "+str(nwaf,2)+"        ",IF(ncol=3,"    REEL: "+str(nwaf+8,2)+"        ","        ")),;   // line 2
     LDESC(d_line->pline_id,d_line->esnxx_id)+"  Size:"+d_line->size_id+"       ",;           // line 3
     IF(d_line->ptype_id $ 'U_T',"Freq:","Val: ")+str(d_line->value_id,8,3)+IF(d_line->ptype_id='C'," pF.       ","")+;
     IF(d_line->ptype_id='F'," Amp.      ","")+;                   // line 4
     IF(d_line->ptype_id='L'," nH        ","")+;
     IF(d_line->ptype_id $ 'U_T',"           ","")+;
     IF(!d_line->ptype_id $ 'F_U_T' .and. nCol=1,;
          IF(nwaf <= 4,"Tol  :   "+d_line->tol_id+"         ","Tol  :_____        "),;
               IF(nCol=1,space(19),""))+;
     IF(!d_line->ptype_id $ 'F_U_T' .and. (nCol=2 .or. nCol=3) ,"Tol  :_____        ",IF(nCol=2,space(19),"")),;
     IF(d_line->ptype_id='C' .AND. d_line->diel_id='S',"Dielectric:   Si02","") +IF(d_line->ptype_id='C' .AND. d_line->diel_id<>'S',"Dielectric:   SiNo","")+;
     IF(d_line->ptype_id='C',"      Caps :   "+d_line->b_ncaps+"        ",""),; // line 5
     IF(nCol>1,"QTY :_______                               ",Space(43))+IF(nCol>1 .and. d_line->b_purp='8',"SOURCE:________","");       // line 6
	  }
	  //

aLab[nRow] += aLines[nRow]
IF nRow == 1 .AND. empty(cBoxLine)
FOR i := 1 TO 3
	 IF "AVX-KYOCERA" $ aLines[i] .AND. i == 1
		 cBoxLine := cBoxLine + d_line->b_id+","+substr(aLines[i],1,19)+substr(aLines[i],39,8)+" --- "+substr(aLines[4],1,35)+","
	 ELSEIF  i == 1
		 cBoxLine := cBoxLine +d_line->b_id+","+substr(aLines[i],2,7)+substr(aLines[i],27,8)+substr(aLines[i],58,10)+" --- "+substr(aLines[4],1,35)+","
	 ELSEIF i == 3
		 cBoxLine := cBoxLine + aLines[i]
	 ELSE
		 cBoxLine := cBoxLine + aLines[i]+","
	 ENDIF
NEXT
cBoxLine := cBoxLine + EOL
lFaseII := TRUE
endif


IF nRow == 1 .AND. empty(cReelLine) .AND. !lFaseII
FOR i := 1 TO 3
	 IF "AVX-KYOCERA" $ aLines[i] .AND. i == 1
		 cReelLine := cReelLine + d_line->b_id+","+substr(aLines[i],1,19)+substr(aLines[i],39,8)+" --- "+substr(aLines[4],1,35)+","
	 ELSEIF  i == 1
		 cReelLine := cReelLine +d_line->b_id+","+substr(aLines[i],2,7)+substr(aLines[i],27,8)+substr(aLines[i],58,10)+" --- "+substr(aLines[4],1,35)+","
	 ELSEIF i == 3
		 cReelLine := cReelLine + aLines[i]
	 ELSE
		 cReelLine := cReelLine + aLines[i]+","
	 ENDIF
NEXT
cReelLine := cReelLine + EOL
endif


///vito
RETURN NIL

STATIC FUNCTION BARC
Return [!R! UNIT D;MRP 20,-40; BARC 19, N,']+d_line->b_id+[', 48, 48, 2, 5, 5, 6, 2, 5, 5, 5;MRP -20,40;EXIT;]
*************************
FUNCTION Ldesc(cline,cxx)

LOCAL cTYP := space(25)
LOCAL nSelect := Select()

IF select("c_btype") == 0
     GenOpenFiles({"c_btype"})
ENDIF
c_btype->( ordsetfocus("ilinesnx") )
if c_btype->( dbseek(cline+cxx))
     cTyp := left(c_btype->btype_nme,25)
endif
Select Select(nSelect)
RETURN cTyp

STATIC FUNCTION PrnLabels(hLblFile)

LOCAL aLabel[LABELLINES]
LOCAL i,j

AFILL( aLabel,"")

For j :=1 To 3
     FOR i := 1 TO LABELLINES
          AddALine(aLabel,i,j,hLblFile)
     NEXT
NEXT
IF !lZebraMode

?

For j :=1 To 3
    @ Prow(),43*(j-1) SAY " "+BARC()
NEXT


FOR i := 1 TO LABELLINES
     ? aLabel[i]
NEXT
?

? ""

IF nWaf = 6 .OR. nWaf = 22 .OR. nWaf = 38 .OR. nWaf = 54
     ? ""
ENDIF
ENDIF

SET CONSOLE ON

RETURN NIL


/***************************************************************/
FUNCTION GSOPLabels

LOCAL cOldScr    := SAVESCREEN()
LOCAL nFrom      := Space(6)
LOCAL nTo        := Space(6)
LOCAL aType      := {"By Batch Nos."}
LOCAL nSelect    := SELECT()
LOCAL cPurp      := "1"

NetUse( "D_finqc", STD_RETRY, RDD_IN_USE, USE_SHARED, USE_NEW, NIL )
d_finqc->( ordsetfocus(1) )

@ 2, 3 CLEAR TO 20, 63
DrawBox(10, 27, 15, 47)

@ 7, 27 SAY " GSOP Label Printing" COLOR "W+/B"

@ 12, 29 SAY "From B/N: " GET nFrom PICTURE "999999"
@ 13, 29 SAY "To B/N:   "
XREAD
nTo := nFrom
@ 13, 29 SAY "To B/N:   " GET nTo   PICTURE "999999"  VALID nTo >= nFrom
XREAD


XREAD

RESTSCREEN(,,,,cOldScr)
SETCURSOR(0)

IF LASTKEY() == K_ESC
ELSE
     ALERT("Make sure that the correct labels are in the printer;"+;
          "and the printer is online.",{"OK"}, ALERT_STD)
     SetUpGSOPPrn(nFrom, nTo )
ENDIF

CLOSE d_finqc
SELECT (nSelect)

RETURN NIL



STATIC FUNCTION SetUpGSOPPrn(nFrom, nTo, cPurp )

LOCAL cFrom, cTo

d_finqc->( ORDSETFOCUS(1) )
d_finqc->( DBSEEK( nFrom, TRUE ) )
cFrom := nFrom
cTo   := nTo

IF d_finqc->( EOF() )
     Msg24("No labels found in the range of:"+cFrom+"-"+cTo, 3, .T. )
     d_finqc->( ORDSETFOCUS(1) )
     d_finqc->( DBGOTOP() )
ELSE
     b_idPrnGSOP( nTo )
ENDIF

d_finqc->( ORDSETFOCUS(1) )
d_finqc->( DBGOTOP() )

RETURN NIL



STATIC FUNCTION b_idPrnGSOP( nTo, cPurp )

LOCAL cOldScr := SAVESCREEN()
LOCAL nPart := 1,cLblFile := "LBL_GSOP.TXT"
LOCAL hLblFile := 99,cTempDir := GetUserInfo():cTempDir

nReel := 1
@ 09,24 CLEAR TO 14,56
@ 09,24 TO 14,56 DOUBLE
@ 11,25 SAY "Printing Labels, please wait..."
@ 14, 40 SAY " ESC to Abort " COLOR "W+/B"
nLine := 1
WHILE d_finqc->B_id <= nTo .AND. !d_finqc->(EOF()) .AND. LASTKEY() <> K_ESC
		IF !d_finqc->wh$"341"
			d_finqc->( DBSKIP())
			nPart++
			loop
		ENDIF

		IIF(hLblFile == 99 ,hLblFile := fcreate(cTempDir+cLblFile) , nil)
      GenOpenFiles({"c_esny"})
      c_esny->(ordsetfocus(1))
      c_esny->(dbseek(d_finqc->esny_id))

		nGlobal := d_finqc->QC_QTY
		RecElement( d_finqc->esny_id , {||c_esny->( Found() )},"c_esny","c_esny")

		while nGlobal > 0
		  	 PrnGSOPLabels(nPart,hLblFile)
		  	 nReel++

		End
      GenCloseFiles({"c_esny"})

		nPart++
      d_finqc->( DBSKIP())
END

IF hLblFile <> 99
	fclose(hLblFile)
	COPY FILE (cTempDir+cLblFile) TO ('G:\USERS\AUTOMAIL\'+cLblFile)
ENDIF

RESTSCREEN(,,,,cOldScr)
RETURN NIL

STATIC FUNCTION PrnGSOPLabels(nPart,hLblFile)

LOCAL aLabel[LABELLINES],j,i,k
local nOrigin := nGlobal

j :=1

While nGlobal > 0 .AND. j < 4
		nReel++
		j++
		IF c_esny->lpflag == "P" .AND. c_esny->esny_qty == 1 .AND. c_esny->esny_id <> "K"

			fwrite(hLblFile,"HIL"+d_finqc->b_id+padl(AllTrim(str(nPart)),2,"0")+padl(AllTrim(str(nReel)),3,"0")+","+;
				               "IL"+d_finqc->b_id+padl(AllTrim(str(nPart)),2,"0")+padl(AllTrim(str(nReel)),3,"0")+","+;
			 					"AVX ESN ID :"+d_finqc->esn_id+","+"QTY :"+AllTrim(str(nGlobal))+","+"Q"+AllTrim(str(nGlobal))+EOL)
         nGlobal := 0
		ELSE

			fwrite(hLblFile,"HIL"+d_finqc->b_id+padl(AllTrim(str(nPart)),2,"0")+padl(AllTrim(str(nReel)),3,"0")+","+;
				               "IL"+d_finqc->b_id+padl(AllTrim(str(nPart)),2,"0")+padl(AllTrim(str(nReel)),3,"0")+","+;
			 					"AVX ESN ID :"+d_finqc->esn_id+","+"QTY :"+AllTrim(str(c_esny->esny_qty))+","+"Q"+AllTrim(str(c_esny->esny_qty))+EOL)
         nGlobal := nGlobal - c_esny->esny_qty
		ENDIF
End

nReel := nReel - j + 1

AFILL( aLabel,"")

For i := 1 To j - 1
     FOR k := 1 TO 4
          AddGSOPALine(aLabel,nReel,IIF(c_esny->lpflag == "P" .AND. c_esny->esny_qty == 1 .AND. c_esny->esny_id <> "K",nOrigin ,c_esny->esny_qty ),k,nPart)
     NEXT
	  nReel++
NEXT

nReel--


nLine++

SET CONSOLE ON

RETURN NIL

STATIC FUNCTION AddGSOPALine( aLab, nReel,nQty,nRow,nPart)

LOCAL cYYWW := SetWeekNo( date(), TRUE )
LOCAL aLines := {;
	  "IL"+Kyo_52p+d_finqc->B_ID+Kyo_17p+padl(AllTrim(str(nPart)),2,"0")+padl(AllTrim(str(nReel)),3,"0")+space(26),;
  	  Space(14)+"                              ",;
     "AVX ESN ID:"+d_finqc->esn_id+                    +"                 ",;
	  "QTY :" +str(nQty,5) + " " + [!R! UNIT D;MRP 20,-40;BARC 19, N,']+"Q"+alltrim(str(nQty,5))+[',48, 48, 2, 5, 5, 6, 2, 5, 5, 5;MRP -20,40;EXIT;]+;
	  "                                 "}
aLab[nRow] += aLines[nRow]

RETURN NIL



STATIC FUNCTION BARCCOL(nReel,nPart)
Return [!R! UNIT D;MRP 20,-40;BARC 19, N,']+"HIL"+;
                                            d_finqc->b_id+;
														  padl(AllTrim(str(nPart)),2,"0")+padl(AllTrim(str(nReel)),3,"0")+;
       [',48, 48, 2, 5, 5, 6, 2, 5, 5, 5;MRP -20,40;EXIT;]
