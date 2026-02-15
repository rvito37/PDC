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

// loginuser
#include "avxdefs.ch"
//#xtranslate MiddleTab(<nLine>) => SPACE(<nLine>*2 + 2)//SPACE(<nLine> * 2 + 4)
#xtranslate LabelPad(<cStr>)   => PADR(<cStr>, 43 ) // it's compressed printing
#define LABELLINES      5
#define Kyo_reset  '!R! RES; EXIT;'            // reset to std Kyocera mode
#define Kyo_12p    ""//'!R! FONT 8411 ; EXIT ; '      // Heb font 12 pitch
#define Kyo_17p    '!R! FONT 8421; EXIT;'      // Heb font 17 pitch
#define Kyo_52p    '!R! FONT 52; EXIT;'          // font for B_ID
#define Kyo_space  '!R! UNIT D;SLS 51; EXIT;'            // line spacing
#define Kyo_top    '!R! UNIT D;STM 43; EXIT;'           // top margin
#define Kyo_lines  '!R! UNIT D;SLPP 67; EXIT;'           // lines per page

STATIC nWaf
STATIC nC

FUNCTION SteveProdLabels(lFromLabApp)

LOCAL cOldScr    := SAVESCREEN()
LOCAL nFrom      := Space(6)
LOCAL nTo        := Space(6)
LOCAL aType      := {"By Batch Nos."}
LOCAL nSelect    := SELECT()
LOCAL cPurp      := '1'
LOCAL cCoup      := ' '

DEFAULT lFromLabApp TO FALSE

IF SELECT("D_Line") == 0
     NetUse( "D_Line", STD_RETRY, RDD_IN_USE, USE_SHARED, USE_NEW, NIL )
ENDIF
IF SELECT("c_bpurp") == 0
     NetUse( "c_bpurp", STD_RETRY, RDD_IN_USE, USE_SHARED, USE_NEW, NIL )
ENDIF
SELECT d_line

d_line->( DBCLEARINDEX() )
d_line->( ordsetfocus("ib_idln") )

@ 2, 3 CLEAR TO 23, 61
DrawBox(11, 27, 19, 50)

@ 7, 27 SAY " TAPI Label Printing" COLOR "W+/B"

//@  4, 6 SAY "Choose Item Type:"   GET nItemType  WITH RADIOBUTTONS {"Fuses","Inductors","Caps"} NOBOX
//@  9, 6 SAY "Choose Scope type:"  GET nScopeType WITH RADIOBUTTONS {"By Order Nos.   ","By Reel Serial #"} NOBOX
@ 12, 29 SAY "To B/N:   " GET nFrom  PICTURE "999999" ;
         SEND PostBlock := {|o|  nTo := nFrom, .T. }
@ 13, 29 SAY "To B/N:   " GET nTo   PICTURE "999999"  VALID nTo >= nFrom
@ 15, 29 SAY "Purpose   " GET cPurp Picture "!";
                SEND preBlock   :=  { |o| preMod (o) };
                SEND postBlock  :=  { |o| postMod (o) }
@ 16, 29 SAY "Coupler Fix Page" GET cCoup PICTURE "!"
// new optional data entry for couplers as per shachar SS 14.09.99

xread
RESTSCREEN(,,,,cOldScr)
SETCURSOR(0)

IF LASTKEY() == K_ESC
ELSE
     ALERT("Make sure that the correct labels are in the printer;"+;
          "and the printer is online.",{"OK"}, ALERT_STD)
     SetUpLabPrn(nFrom, nTo, cPurp, cCoup, lFromLabApp )
ENDIF

CLOSE d_Line
SELECT (nSelect)

RETURN NIL

STATIC FUNCTION preMod(o)

LOCAL nSelect := Select( ALIAS() )
SetF2Key(o, "c_bpurp")
return .T.

STATIC FUNCTION postMod(o)

LOCAL nSelect := Select( ALIAS() )
LOCAL lFound  := FALSE

SELECT c_bpurp
LOCATE FOR c_bpurp->b_purp == o:varGet()

IF c_bpurp->( Found() )
//     @ o:row ,o:col+2 say left(c_bpurp->bpurp_nme,25) color "w+/r"  // no longer needed SS 22.09.99
     lFound := TRUE
ELSE
     TONE(100,0)
ENDIF

SELECT d_line
RETURN lFound

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
STATIC FUNCTION SetUpLabPrn(nFrom, nTo, cPurp, cCoup, lFromLabApp )

LOCAL cFrom, cTo

d_line->( ORDSETFOCUS("ib_idln") )
d_line->( DBSEEK( nFrom, TRUE ) )
cFrom := nFrom
cTo   := nTo

// we don't check for FOUND(), as there might be numbers greater than the SEEK
// value, so as long as it didn't get to EOF, we might have something to print
IF d_line->( EOF() )
     Msg24("No labels found in the range of:"+cFrom+"-"+cTo, 3, .T. )
     d_line->( ORDSETFOCUS("ib_idln") )
     d_line->( DBGOTOP() )
ELSE
     b_idPrn( nTo, cPurp, cCoup, lFromLabApp )
ENDIF

d_line->( ORDSETFOCUS("ib_idln") )
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
STATIC FUNCTION b_idPrn( nTo,cPurp, cCoup, lFromLabApp )

LOCAL cOldScr := SAVESCREEN()
LOCAL nMAX  := 8

@09,24 CLEAR TO 14,56
@09,24 TO 14,56 DOUBLE
@11,25 SAY "Printing Labels, please wait..."
@14, 40 SAY " ESC to Abort " COLOR "W+/B"

SET device to printer
SET CONSOLE OFF
SET PRINTER ON

IF !"CZ"    $ GetUserInfo():cGroupID .AND. ;
   !"VIZ"   $ GetUserInfo():cUserId
   ? '!R! CASS 0; EXIT;'
ENDIF  //EDOMO+VR 21-05-03





WHILE d_line->B_id <= nTo .AND. !d_line->(EOF()) .AND. LASTKEY() <> K_ESC
     IF d_line->b_purp = cPurp
          IF d_line->b_stat $ 'CM'
               alert("You are about to print labels for "+;
                    if(d_line->b_stat=="C","closed","frozen")+;
                    " batch")
          end
         nMax := IF( d_line->uom_ini="W",;
                   IF(d_line->qty_bini > 0, d_line->qty_bini,8),;
                   d_line->cp_bqtyw)
        ??Kyo_lines                          // sets lpp to 65
        ??Kyo_17p                            // Kyocera 17 pitch
        ??Kyo_space                          // Kyocera line spacing
        ??Kyo_top                            // Kyocera top margin

       IF cCoup <> ' '
          FOR nC := 1 TO 3
          PrnCouplers()
          NEXT
          EJECT
       ELSE
          FOR nWaf := 1 TO nMax
          PrnLabels()
          NEXT
          EJECT // temporary
     END
     END
     d_line->( DBSKIP())
END

IF !"CZ"    $ GetUserInfo():cGroupID .AND. ;
   !"VIZ"   $ GetUserInfo():cUserId
	? '!R! CASS 1; EXIT;'
ENDIF

SET PRINTER OFF
SET PRINTER TO
Set Device to screen
setcap()    // added to return user to default settings SS 08.03.99

RESTSCREEN(,,,,cOldScr)

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
STATIC FUNCTION PrnLabels

LOCAL aLabel[LABELLINES]
LOCAL i,j

AFILL( aLabel,"")                                // Important, so I can += to this empty string twice

For j :=1 To 3
     FOR i := 1 TO LABELLINES
          AddALine(aLabel,i,j)
     NEXT
NEXT

For j :=1 To 3
@ Prow(),43*(j-1) SAY " "+BARC()
NEXT
     ?
FOR i := 1 TO LABELLINES
     ? aLabel[i]
NEXT
// move printer head to next label row
     ? ""
     ? ""
IF nWaf = 6
     ?""
ENDIF

SET CONSOLE ON
IF nWaf = 8 .OR. nWaf = 16 .OR. nWaf = 24 .OR. nWaf = 32
    eject
ENDIF
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
//     BARC(),;                                   // line 1
//  allignment fix to 5th line in IF below for non-tol_id parts SS 11/07/99
LOCAL aLines := {}
  AADD( aLines,IF(nCol=1," AVX-KYOCERA"," ")+" BATCH: "+Kyo_52p+d_line->b_purp+'_'+d_line->B_ID+Kyo_17p+IF(nCol>1," WAFER: "+str(nwaf,2)+"       ","        ")                                                      )
  AADD( aLines, " " )
  AADD( aLines,IF(nCol=1," "+LDESC(d_line->pline_id,d_line->esnxx_id) + "  Size:"+d_line->size_id+"      ","")+IF(nCol=2," ÀÄÄÁÄÄÙ „‡Œ„         ÀÄÄÁÄÄÙ š…ˆ‚ ”–    ","")+IF(nCol=3," ÀÄÄÁÄÄÙ I ˜…‘‰                           ","") )
  AADD( aLines,;
       IF( nCol == 1, ;
           " Val: "                                  +;
           str(d_line->value_id,9,3)                +;
           IF(d_line->ptype_id='C' , " pF.       "    ,"")    +;
           IF(d_line->ptype_id='F' , " Amp."+SPACE(24),"")+;
           IF(d_line->ptype_id='L' , " nH        "    ,"")    +;
           IF(d_line->ptype_id $ 'U_T' , "           "    ,"")    +;
           IF(d_line->ptype_id$ 'C_L', "Tol  :"          +;
               IF(nWaf <= 4,space(3)+d_line->tol_id,"____")+;
           "        "      ,"                  "),;
        "")                                                +;
       IF(nCol=2,"  ÀÄÄÁÄÄÙ š…ˆ‚ …‰‘    ÀÄÄÁÄÄÙ „‰–‰˜ˆ    ","");
    )

  AADD( aLines,IF(d_line->ptype_id='C' .AND. nCol=1," Dielectric:   ","")+IF(d_line->diel_id='S' .AND. nCol=1,"Si02","")+IF(d_line->diel_id<>'S' .AND. d_line->ptype_id = 'C' .and. nCol=1,"SiNO","")+IF(d_line->ptype_id='C' .AND. nCol=1,"      Caps :   "+d_line->b_ncaps+"       ","")+IF(d_line->ptype_id <>'C' .AND. nCol = 1,space(43),"")+ IF(nCol=2," ÀÄÄÁÄÄÙ II ˜…‘‰      ÀÄÄÁÄÄÙ ˜… Œ…—‰   ","")+IF(nCol=3," ÀÄÄÁÄÄÙ š…ˆ‚ Œ…‡                        ","") )


aLab[nRow] += aLines[nRow]

RETURN NIL

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: PrnCouplers             Docs:                              ³
 * ³  Description: Coupler Label Printing                                     ³
 * ³       Author: Steve S                                                    ³
 * ³ Date created: 08-11-96              Date updated: ş08-11-96              ³
 * ³ Time created: 06:06:02pm            Time updated: ş06:06:02pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: None                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC FUNCTION PrnCouplers

LOCAL aLabel[LABELLINES]
LOCAL i,j

AFILL( aLabel,"")                   // Important, so I can += to this empty string twice

For j :=1 To 3
     FOR i := 1 TO LABELLINES
          AddACoupler(aLabel,i,j)
     NEXT
NEXT


For j :=1 To 3
@ Prow(),43*(j-1) SAY " "+BARC()
NEXT
     ?
FOR i := 1 TO LABELLINES
     ? aLabel[i]
NEXT
// move printer head to next label row
     ? ""
     ? ""
IF nC = 3
     ?""
ENDIF

SET CONSOLE ON

RETURN NIL

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: AddAcoupler           Docs:                                ³
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
STATIC FUNCTION AddACoupler( aLab, nRow,nCol)
LOCAL aLines := {}
  AADD( aLines,"  BATCH: "+Kyo_52p+d_line->b_purp+'_'+d_line->B_ID+Kyo_17p+" WAFER:          ")
  AADD( aLines, " " )
  AADD( aLines," "+LDESC(d_line->pline_id,d_line->esnxx_id) + "     Size :  "+d_line->size_id+"      " )
  AADD( aLines, " " )
  AADD( aLines, " ÀÄÄÁÄÄÙ ‰˜Œ”— ‰…—‰                      ")
  AADD( alines, " " )

aLab[nRow] += aLines[nRow]

RETURN NIL

STATIC FUNCTION BARC
Return [!R! UNIT D; BARC 19, N,']+d_line->b_id+[$M', 48, 48, 4, 7, 7, 8, 4, 7, 7, 7; EXIT;]


STATIC FUNCTION BARCW
Return [!R! UNIT D; BARC 19, N,']+str(nwaf,2)+[$M', 48, 48, 4, 7, 7, 8, 4, 7, 7, 7; EXIT;]

/*
STATIC FUNCTION Ldesc

LOCAL cTYP

DO CASE
     CASE  d_line->b_type='O'
          cTYP := 'Accu-F             '
     CASE  d_line->b_type='P'
          cTYP := 'Accu-F printed     '
     CASE d_line->b_type='M'
          cTYP := 'Accu-P             '
     CASE d_line->b_type='V'
          cTYP := 'Accu-P printed     '
     CASE d_line->pline_id ='AG1' .and. d_line->b_type = 'F'
          cTYP := 'Accu-G I           '
     CASE d_line->b_type='G' .and. d_line->pline_id = 'AG1'
          cTYP := 'Accu-G I printed   '
     CASE d_line->pline_id='AG2' .AND. d_line->size_id='0805'
          cTYP := 'Accu-G II printed  '
     CASE d_line->pline_id='AG2' .AND. d_line->size_id='1206' .AND. d_line->esnxx_id $'01_41_43'
          cTYP := 'Accu-G II printed  '
     CASE d_line->pline_id='AG2' .AND. d_line->size_id='1206'
          cTYP := 'Accu-G II          '
     CASE d_line->pline_id = 'AG3'
          cTYP := 'Accu-G III printed '
     CASE d_line->pline_id = 'AL1'
          cTYP := 'Accu-L             '
     CASE d_line->pline_id = 'AL2'
          cTYP := 'Accu-L II          '
     CASE d_line->pline_id = 'CP1'
          cTYP := 'Coupler            '
     CASE d_line->pline_id = 'RS1'
          cTYP := 'Resonator          '
     CASE d_line->pline_id = 'FL1'
          cTYP := 'Low Pass Filter    '
     OTHERWISE
          cTYP := '                   '
ENDCASE

RETURN cTyp
*/