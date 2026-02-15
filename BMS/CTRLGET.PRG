

/*
#xcommand @ <row>, <col> ASCIIGET <var>                                 ;
                        [PICTURE <pic>]                                 ;
                        [VALID <valid>]                                 ;
                        [WHEN <when>]                                   ;
                        [SEND <msg>]                                    ;
                                                                        ;
      => SetPos( <row>, <col> )                                         ;
       ; AAdd(                                                          ;
           GetList,                                                     ;
           _GET_( <var>, <"var">, <pic>, <{valid}>, <{when}> ):display();
             )                                                          ;
       ; ATail(GetList):Reader := {|x| ASCIIReader(x) }                 ;
      [; ATail(GetList):<msg>]
*/
#include "avxdefs.ch"
/*******************************************************************
*
* PROCEDURE ASCIIReader( oGet )
* Custom reader; includes hotkey to imbed lo&hi ASCII in a GET
*/
PROCEDURE ASCIIReader( oGet )


// don't allow ever to use insert mode in this GET
SET( _SET_INSERT, .F. )

   // Read the GET if the WHEN condition is satisfied
   IF ( GetPreValidate( oGet ) )

      // Activate the GET for reading
      oGet:setFocus()

      WHILE ( oGet:exitState == GE_NOEXIT )

         // Check for initial typeout (no editable positions)
         IF ( oGet:typeOut )
            oGet:exitState := GE_ENTER
      ENDIF

      @ 24, 0 SAY PADC("Press F2 for ASCII character list ",80) COLOR "W+/r"
      DEVPOS( oGet:row, oGet:Col )
         // Apply keystrokes until exit
         WHILE ( oGet:exitState == GE_NOEXIT )
            ASCIIApplyKey( oGet, inkey( 0 ) )
         ENDDO

         // Disallow exit if the VALID condition is not satisfied
         IF ( !GetPostValidate( oGet ) )
            oGet:exitState := GE_NOEXIT
         ENDIF
      ENDDO

      // De-activate the GET
      oGet:killFocus()

   ENDIF

   @ 24, 0 SAY SPACE(80) COLOR "W+/r"

   RETURN

/********************************************************************/
PROCEDURE AsciiApplyKey( oGet, nKey )

   LOCAL cKey
   LOCAL bKeyBlock
   LOCAL n
   LOCAL aCTRLCHRS := {;
            "", "", "", "", "", "", "", "", "", "", "",     ;
            "", "", "", "", "", "", "", "", "", "", "",     ;
            "", "", "", "", "", "€", "", "‚", "ƒ", "„", "…", "†",;
            "‡", "ˆ", "‰", "Š", "‹", "Œ", "", "Ž", "", "", "‘", "’",;
            "“", "”", "•", "–", "—", "˜", "™", "š", "›", "œ", "", "ž",;
            "Ÿ", " ", "¡", "¢", "£", "¤", "¥", "¦", "§", "¨", "©", "ª",;
            "«", "¬", "­", "®", "¯", "°", "±", "²", "³", "´", "µ", "¶",;
            "·", "¸", "¹", "º", "»", "¼", "½", "¾", "¿", "À", "Á", "Â",;
            "Ã", "Ä", "Å", " ", "Ç", "È", "É", "Ê", "Ë", "Ì", "Í", "Î",;
            "Ï", "Ð", "Ñ", "Ò", "Ó", "Ô", "Õ", "Ö", "×", "Ø", "Ù", "Ú",;
            "Û", "Ü", "Ý", "Þ", "ß", "à", "á", "â", "ã", "ä", "å", "æ",;
            "ç", "è", "é", "ê", "ë", "ì", "í", "î", "ï", "ð", "ñ", "ò",;
            "ó", "ô", "õ", "ö", "÷", "ø", "ù", "ú", "û", "ü", "ý", "þ" }

   // Check for SET KEY first
   IF !( ( bKeyBlock := setkey( nKey ) ) == NIL )
      GetDoSetKey( bKeyBlock, oGet )
      RETURN                           // NOTE
   ENDIF

   DO CASE
   CASE ( nKey == K_UP )
      oGet:exitState := GE_UP

   CASE ( nKey == K_SH_TAB )
      oGet:exitState := GE_UP

   CASE ( nKey == K_DOWN )
      oGet:exitState := GE_DOWN

   CASE ( nKey == K_TAB )
      oGet:exitState := GE_DOWN

   CASE ( nKey == K_ENTER )
      oGet:exitState := GE_ENTER

   CASE ( nKey == K_ESC )
      IF ( SET( _SET_ESCAPE ) )

         oGet:undo()
         oGet:exitState := GE_ESCAPE

      ENDIF

   CASE ( nKey == K_PGUP )
      oGet:exitState := GE_WRITE

   CASE ( nKey == K_PGDN )
      oGet:exitState := GE_WRITE

   CASE ( nKey == K_CTRL_HOME )
      oGet:exitState := GE_TOP


//#ifdef CTRL_END_SPECIAL

   // changed by Shalom 04-08-96 for multiple edits
   CASE ( nKey == K_CTRL_ENTER )
      oGet:exitState := GE_WRITE

//#else

   // Both ^W and ^End terminate the READ (the default)
   CASE ( nKey == K_CTRL_W )
      oGet:exitState := GE_WRITE

//#endif

   CASE ( nKey == K_HOME )
      oGet:home()

   CASE ( nKey == K_END )
      oGet:end()

   CASE ( nKey == K_RIGHT )
         oGet:right()

   CASE ( nKey == K_LEFT )
         oGet:left()

   CASE nKey == K_DEL
      oGet:delete()

   CASE nKey == K_BS
      oGet:backSpace()

   // special case for this GET, embeds a low or high ASCII chr in the GET
   CASE nKey == K_F2
       IF (n := AsciiList()) > 0
          oGet:Buffer :=  STUFF( oGet:Buffer, oGet:Pos, 1, aCtrlChrs[n])
          oGet:Varput(oGet:Buffer)
          oGet:right()
          oGet:Display()
       ELSE
          DEVPOS( oGet:row, oGet:col+oGet:pos-1)
       END

   OTHERWISE

      IF ( nKey >= 32 .AND. nKey <= 255 )

         cKey := CHR( nKey )

            IF ( SET( _SET_INSERT ) )
               oGet:insert( cKey )
            ELSE
               oGet:overstrike( cKey )
            ENDIF

         IF ( oGet:typeOut )
            IF ( SET( _SET_BELL ) )
            ?? CHR(7)
            ENDIF

            IF ( !SET( _SET_CONFIRM ) )
            oGet:exitState := GE_ENTER
            ENDIF
         ENDIF

      END

   ENDCASE

  RETURN

/**********************************************************************/
STATIC FUNCTION AsciiList

LOCAL aCTRLLIST := {;
"  1   01h      SOH","  2   02h      STX","  3   03h      ETX",;
"  4   04h      EOT","  5   05h      ENQ","  6   06h      ACK",;
"  7   07h      BEL","  8   08h      BS ",                      ;
" 11   0Bh      VT "," 14   0Eh      SO "," 15   0Fh      SI ",;
" 16   10h      DLE"," 17   11h      DC1"," 18   12h      DC2",;
" 19   13h      DC3"," 20   14h      DC4"," 21   15h      NAK",;
" 22   16h      SYN"," 23   17h      ETB"," 24   18h      CAN",;
" 25   19h      EM "," 27   1Bh      ESC",                      ;
" 28   1Ch      FS "," 29   1Dh      GS "," 30   1Eh      RS ",;
" 31   1Fh      US ","127   7Fh         ","128   80h   €      ",;
"129   81h         ","130   82h   ‚      ","131   83h   ƒ      ",;
"132   84h   „      ","133   85h   …      ","134   86h   †      ",;
"135   87h   ‡      ","136   88h   ˆ      ","137   89h   ‰      ",;
"138   8Ah   Š      ","139   8Bh   ‹      ","140   8Ch   Œ      ",;
"141   8Dh         ","142   8Eh   Ž      ","143   8Fh         ",;
"144   90h         ","145   91h   ‘      ","146   92h   ’      ",;
"147   93h   “      ","148   94h   ”      ","149   95h   •      ",;
"150   96h   –      ","151   97h   —      ","152   98h   ˜      ",;
"153   99h   ™      ","154   9Ah   š      ","155   9Bh   ›      ",;
"156   9Ch   œ      ","157   9Dh         ","158   9Eh   ž      ",;
"159   9Fh   Ÿ      ","160   A0h          ","161   A1h   ¡      ",;
"162   A2h   ¢      ","163   A3h   £      ","164   A4h   ¤      ",;
"165   A5h   ¥      ","166   A6h   ¦      ","167   A7h   §      ",;
"168   A8h   ¨      ","169   A9h   ©      ","170   AAh   ª      ",;
"171   ABh   «      ","172   ACh   ¬      ","173   ADh   ­      ",;
"174   AEh   ®      ","175   AFh   ¯      ","176   B0h   °      ",;
"177   B1h   ±      ","178   B2h   ²      ","179   B3h   ³      ",;
"180   B4h   ´      ","181   B5h   µ      ","182   B6h   ¶      ",;
"183   B7h   ·      ","184   B8h   ¸      ","185   B9h   ¹      ",;
"186   BAh   º      ","187   BBh   »      ","188   BCh   ¼      ",;
"189   BDh   ½      ","190   BEh   ¾      ","191   BFh   ¿      ",;
"192   C0h   À      ","193   C1h   Á      ","194   C2h   Â      ",;
"195   C3h   Ã      ","196   C4h   Ä      ","197   C5h   Å      ",;
"198   C6h   Æ      ","199   C7h   Ç      ","200   C8h   È      ",;
"201   C9h   É      ","202   CAh   Ê      ","203   CBh   Ë      ",;
"204   CCh   Ì      ","205   CDh   Í      ","206   CEh   Î      ",;
"207   CFh   Ï      ","208   D0h   Ð      ","209   D1h   Ñ      ",;
"210   D2h   Ò      ","211   D3h   Ó      ","212   D4h   Ô      ",;
"213   D5h   Õ      ","214   D6h   Ö      ","215   D7h   ×      ",;
"216   D8h   Ø      ","217   D9h   Ù      ","218   DAh   Ú      ",;
"219   DBh   Û      ","220   DCh   Ü      ","221   DDh   Ý      ",;
"222   DEh   Þ      ","223   DFh   ß      ","224   E0h   à      ",;
"225   E1h   á      ","226   E2h   â      ","227   E3h   ã      ",;
"228   E4h   ä      ","229   E5h   å      ","230   E6h   æ      ",;
"231   E7h   ç      ","232   E8h   è      ","233   E9h   é      ",;
"234   EAh   ê      ","235   EBh   ë      ","236   ECh   ì      ",;
"237   EDh   í      ","238   EEh   î      ","239   EFh   ï      ",;
"240   F0h   ð      ","241   F1h   ñ      ","242   F2h   ò      ",;
"243   F3h   ó      ","244   F4h   ô      ","245   F5h   õ      ",;
"246   F6h   ö      ","247   F7h   ÷      ","248   F8h   ø      ",;
"249   F9h   ù      ","250   FAh   ú      ","251   FBh   û      ",;
"252   FCh   ü      ","253   FDh   ý      ","254   FEh   þ      " }
LOCAL cClr := SETCOLOR("w+/bg")
LOCAL cScr := SAVESCREEN()
LOCAL n

@ 24, 0 SAY PADC("Up/Down arrows to move, ENTER to choose, ESC to abort ",80) COLOR "gr+/r"
DrawBox(5,40,15,60)
SETCOLOR("bg+/bg,gr+/r")
n := ACHOICE( 6,41,14,59,aCtrlList)

SETCOLOR(cClr)
RESTSCREEN(0,0,24,79,cScr)

RETURN n
