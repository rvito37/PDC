     // Function/Procedure Prototype Table  -  Last Update: 04-20-97 @ 14:30:01Pm
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// Return Value         Function/Arguments
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
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
//#xtranslate MiddleTab(<nLine>) => SPACE(<nLine>*2 + 2)//SPACE(<nLine> * 2 + 4)
#xtranslate LabelPad(<cStr>)   => PADR(<cStr>, 44 ) // it's compressed printing
#define LABELLINES      6
#define Kyo_reset  '!R! RES; EXIT ;'               // reset to std Kyocera mode
#define Kyo_12p    '!R! FONT 8411 ; EXIT ;'        // Heb font 12 pitch
#define Kyo_17p    '!R! FONT 8421 ; EXIT ;'        // Heb font 17 pitch
#define Kyo_52p    '!R! FONT 52 ; EXIT ;'          // font for B_ID
#define Kyo_space  '!R! SLS 51 ; EXIT ;'      // line spacing
#define Kyo_top    '!R! STM 43 ; EXIT ;'      // top margin
#define Kyo_lines  '!R! SLPP 65 ; EXIT ;'          // lines per page
STATIC nWaf

FUNCTION LetsPrintSomeLabels

LOCAL cOldScr    := SAVESCREEN()
LOCAL nFrom      := "     "
LOCAL nTo        := "     "
LOCAL aType      := {"By Batch Nos."}
LOCAL nSelect    := SELECT()

IF SELECT("D_Line") == 0
     NetUse( "D_Line", STD_RETRY, RDD_IN_USE, USE_SHARED, USE_NEW, NIL )
ENDIF
d_line->( DBCLEARINDEX() )
d_line->( DBSETINDEX("ib_idln") )

@ 2, 3 CLEAR TO 18, 31
DrawBox(3, 4, 17, 30)

@ 3, 10 SAY " Label Printing " COLOR "W+/B"

//@  4, 6 SAY "Choose Item Type:"   GET nItemType  WITH RADIOBUTTONS {"Fuses","Inductors","Caps"} NOBOX
//@  9, 6 SAY "Choose Scope type:"  GET nScopeType WITH RADIOBUTTONS {"By Order Nos.   ","By Reel Serial #"} NOBOX
@ 13, 6 SAY "From B/N: " GET nFrom PICTURE "XXXXXX"
@ 15, 6 SAY "To B/N:   " GET nTo   PICTURE "XXXXXX"  VALID nTo >= nFrom
XREADALL

RESTSCREEN(,,,,cOldScr)
SETCURSOR(0)

IF LASTKEY() == K_ESC
ELSE
     ALERT("Make sure that the correct labels are in the printer;"+;
	  "and the printer is online.",{"OK"})
     SetUpLabPrn(nFrom, nTo )
ENDIF

CLOSE d_Line
SELECT (nSelect)

RETURN NIL

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: SetUpLabPrn()         Docs:                                ³
 * ³  Description: reorder indexes and loop to Printit() alowing ESC abort    ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 08-15-96              Date updated: ş08-15-96              ³
 * ³ Time created: 10:47:36am            Time updated: ş10:47:36am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: nRadioChoice                                               ³
 * ³             : nType                                                      ³
 * ³             : nFrom                                                      ³
 * ³             : nTo                                                        ³
 * ³ Return Value: FUNCTION SetUpLabPrn( nRadioChoice, nType, nFrom, nTo )    ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC FUNCTION SetUpLabPrn(nFrom, nTo )

LOCAL cFrom, cTo

d_line->( ORDSETFOCUS("ib_idlin") )
d_line->( DBSEEK( nFrom, TRUE ) )
cFrom := nFrom
cTo   := nTo

// we don't check for FOUND(), as there might be numbers greater than the SEEK
// value, so as long as it didn't get to EOF, we might have something to print
IF d_line->( EOF() )
     Msg24("No labels found in the range of:"+cFrom+"-"+cTo, 3, .T. )
     d_line->( ORDSETFOCUS("d_line") )
     d_line->( DBGOTOP() )
ELSE
     b_idPrn( nTo )
ENDIF

d_line->( ORDSETFOCUS("d_line") )
d_line->( DBGOTOP() )

RETURN NIL

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: b_idPrn()              Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 08-15-96              Date updated: ş08-15-96              ³
 * ³ Time created: 11:12:56am            Time updated: ş11:12:56am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: nTo                                                        ³
 * ³ Return Value: NIL                                                        ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC FUNCTION b_idPrn( nTo )

LOCAL cOldScr := SAVESCREEN()
LOCAL nMAX  := 8
nWaf := 1
@09,24 CLEAR TO 14,56
@09,24 TO 14,56 DOUBLE
@11,25 SAY "Printing Labels, please wait..."
@14, 40 SAY " ESC to Abort " COLOR "W+/B"

WHILE d_line->B_id <= nTo .AND. !d_line->(EOF()) .AND. LASTKEY() <> K_ESC
  if !d_line->bstat $ 'CM'
      nmax := if(d_line->b_purp='8',4,8)
      WHILE nWaf <= nMax
	PrnLabels()
	nWaf++
      END
  end
d_line->( DBSKIP())
END
nwaf := 1
RESTSCREEN(,,,,cOldScr)
RETURN NIL

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: ResetPics()           Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 08-15-96              Date updated: ş08-15-96              ³
 * ³ Time created: 10:43:08am            Time updated: ş10:43:08am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: n                                                          ³
 * ³ Return Value: TRUE                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
//STATIC FUNCTION ResetPics( n )

//Getlist[3]:Picture := "999999"
//Getlist[4]:Picture := "999999"
//@13,22 SAY " "
//@15,22 SAY " "

//Getlist[3]:Display()
//Getlist[4]:Display()
//RETURN TRUE

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: DrawBox()             Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 08-15-96              Date updated: ş08-15-96              ³
 * ³ Time created: 10:43:04am            Time updated: ş10:43:04am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: t                                                          ³
 * ³             : l                                                          ³
 * ³             : b                                                          ³
 * ³             : r                                                          ³
 * ³ Return Value: NIL                                                        ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION DrawBox(t,l,b,r)

LOCAL i

FOR i := t TO b
     @ i, l SAY "Û"
     @ i, r SAY "Û"
NEXT

@ t, l+1 SAY REPLICATE( "ß", r-l-1)
@ b, l+1 SAY REPLICATE( "Ü", r-l-1)

RETURN NIL


/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: PrnLabels             Docs:                                ³
 * ³  Description: Label Printing                                             ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 08-11-96              Date updated: ş08-11-96              ³
 * ³ Time created: 06:06:02pm            Time updated: ş06:06:02pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: None                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION PrnLabels

LOCAL aLabel[LABELLINES]
//LOCAL nWhatKind := GetWhatKind()
LOCAL i,j

AFILL( aLabel,"")         // Important, so I can += to this empty string twice

For j :=1 To 3
    FOR i := 1 TO LABELLINES
     AddALine(aLabel,i,j)
    NEXT
NEXT

// TEMPORARY TEST
SET PRINTER TO lpt1
SET PRINTER ON
SET CONSOLE OFF
??Kyo_reset                                       // clears print registers
??Kyo_lines                                       // sets lpp to 65
??Kyo_17p                                         // Kyocera 17 pitch
??Kyo_space                                       // Kyocera line spacing
??Kyo_top                                         // Kyocera top margin

FOR i := 1 TO LABELLINES
     ? aLabel[i]
NEXT
// move printer head to next label row
FOR i := 1 TO 6
     ? ""
NEXT
//?? PrnReset()
SET PRINTER OFF
SET PRINTER TO
SET CONSOLE ON

d_line->( DBSKIP())

RETURN NIL

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: PrnTestLabels         Docs:                                ³
 * ³  Description: Label Printing                                             ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 08-11-96              Date updated: ş08-11-96              ³
 * ³ Time created: 06:06:02pm            Time updated: ş06:06:02pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: None                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION PrnTestLabels

LOCAL aLabel[LABELLINES]
LOCAL i
LOCAL lContinue := TRUE, nRet
LOCAL nSelect   := SELECT()

NetUse( "d_line", STD_RETRY, RDD_IN_USE, USE_SHARED, USE_NEW, NIL )

AFILL( aLabel,"")

FOR i := 1 TO LABELLINES
     AddALine( aLabel, i, 4,  TRUE, FALSE)
NEXT
FOR i := 1 TO LABELLINES
     AddALine( aLabel, i, 4, FALSE, FALSE)
NEXT

WHILE lContinue
     IF ( nRet := ALERT("Print test labels?",{"Yes","No"}) ) == 2
	  lContinue := FALSE
     ELSE
	  SET PRINTER TO lpt1
	  SET PRINTER ON
	  SET CONSOLE OFF
//          ?? PrnSetup()+Compress()
	  FOR i := 1 TO LABELLINES
	       ? aLabel[i]
	  NEXT
	  // move printer head to next label row
	  FOR i := 1 TO 6
	       ? ""
	  NEXT
//          ?? PrnReset()
	  SET PRINTER OFF
	  SET PRINTER TO
	  SET CONSOLE ON
     END
END

CLOSE d_line
SELECT (nSelect)

RETURN NIL

RETURN NIL

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: AddALine()            Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 08-11-96              Date updated: ş08-11-96              ³
 * ³ Time created: 05:52:51pm            Time updated: ş05:52:51pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: aLab                                                       ³
 * ³             : n                                                          ³
 * ³             : nWhich                                                     ³
 * ³             : l1st                                                       ³
 * ³ Return Value: NIL                                                        ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC FUNCTION AddALine( aLab, nRow,nCol)

LOCAL aLines := {;
     BARC(),;                                                             // line 1
     IF(nCol=1,"AVX-KYOCERA","")+"BATCH:"+Kyo_52p+d_line->B_ID+Kyo_17p+;  // line 2
     IF(nCol=2,"   REEL:  "+str(nwaf,2),""),;
     LDESC()+"       Size :  "+d_line->size_id,;                          // line 3
     "Val: "+str(d_line->value_id,9,3)+IF(d_line->ptype_id='C'," pF.       ","")+;
     IF(d_line->ptype_id='F'," Amp.","")+;
     IF(d_line->ptype_id='L'," nH         ","")+;
     IF(!d_line->ptype_id='F'.and. nCol=1,"Tol  :   "+d_line->tol_id,"")+;
     IF(!d_line->ptype_id='F'.and.(nCol=1 .or. nCol=2),"Tol  :_____",""),; // line 4
     IF(d_line->ptype_id='C',"Dielectric:   ","")+IF(d_line->diel_id='S',"Si02","")+;
     IF(d_line->diel_id='N',"SiNO","")+;
     IF(d_line->ptype_id='C',"       Caps :   "+d_line->b_ncaps,""),;      // line 5
     IF(nCol>1,"QTY :_______   ","")+IF(nCol>1 .and. d_line->b_purp='8',"SOURCE:________",""); // line 6
    }

aLab[nRow] += LabelPad(aLines[nRow] )

RETURN NIL

STATIC FUNCTION BARC
LOCAL batchbarc := "!R! UNIT D; BARC 19, N, '"+d_line->b_id+'$M'+"', 48, 48, 4, 7, 7, 8, 4, 7, 7, 7; EXIT;"
Return batchbarc

STATIC FUNCTION Ldesc
local TYP
DO CASE
  CASE  d_line->b_type='O'
      TYP := 'Accu-F             '
  CASE  d_line->b_type='P'
      TYP := 'Accu-F printed     '
  CASE d_line->b_type='M'
      TYP := 'Accu-P             '
  CASE d_line->b_type='V'
      TYP := 'Accu-P printed     '
  CASE d_line->pline_id ='AG1' .and. d_line->b_type = 'F'
      TYP := 'Accu-G I           '
  CASE d_line->b_type='G' .and. d_line->pline_id = 'AG1'
      TYP := 'Accu-G I printed   '
  CASE d_line->pline_id='AG2'
      TYP := 'Accu-G II printed  '
  CASE d_line->pline_id = 'AG3'
      TYP := 'Accu-G III printed '
  CASE d_line->pline_id = 'AL1'
      TYP := 'Accu-L             '
  CASE d_line->pline_id = 'AL2'
      TYP := 'Accu-L II          '
  CASE d_line->pline_id = 'CP1'
      TYP := 'Coupler            '
  CASE d_line->pline_id = 'RS1'
      TYP := 'Resonator          '
  CASE d_line->pline_id = 'LP1'
      TYP := 'Low Pass Filter    '
ENDCASE

RETURN Typ