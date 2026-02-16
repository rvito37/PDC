#include "abrowser.ch"
#include "Box.ch"
#include "Checkdef.ch"
#include "Checks.ch"
#include "classy2.ch"
#include "Combobox.ch"
#include "Combodef.ch"
#include "common.ch"
//#include "dbfntxax.ch"
#include "dbfcdxax.ch"  // YH
#include "Dbstruct.ch"
#include "directry.ch"
#include "fileio.ch"
#include "Getexit.ch"
#include "inkey.ch"
#include "radiobtn.ch"
#include "Radiodef.ch"
#include "Radios.ch"
#include "set.ch"
#include "setcurs.ch"
 
MEMVAR bInsSave, nCursSave, GetList
 
#command ASK FOR HELP =>;
                       IF nKey = K_F1                     ;;
                          nKey := HlpKeys( aKeyList )    ;;
                       END
 
 
#command F1 PRESSED  =>;
                       IF nKey = K_F1          ;;
                          nKey := HlpKeys()    ;;
                       END
 
#command SH_F1 PRESSED  =>;
                       IF nKey = K_SH_F1       ;;
                          nKey := HlpKeys()    ;;
                       END
 
 
#translate Colors() =>  iif(IsColor(),"gr+/b,w+/r, nil,g+/b,n+/r,w/n,gr+/rb" ,"w/n,b/n,n/w,b/n,w/n,b/n,n/w")
#translate NewColors() =>  iif(IsColor(),"gr+/b,w+/r, nil,g+/b,n+/r,w/n,gr+/rb,gr+/bg,w+/g" ,"w/n,w+/n,n/w,w+/n,w/n,w+/n,n/w,gr+/bg,w+/g")
#translate UtilColors() =>  iif(IsColor(),"w+/bg,gr+/r, nil,g+/b,n+/r,w/n" ,"w/n,w+/n,n/w,w+/n,w/n,w+/n,n/w")
 
#command  CHECK FOR BLOCK => ;
                IF ( (bKeyBlock := SetKey(nKey)) != NIL )        ;;
                   Eval(bKeyBlock, ProcName(1), ProcLine(1), "") ;;
                   LOOP                                          ;;
                END
 
#define FRAME  "€ﬂ€€€‹€€"
#define FRAMECAPTION  "€€€€€‹€€"
 
#translate OldTitle(<a>)  => SetTitle( <a>\[1\] , <a>\[2\] )
 
 
#command BROWSE STUFF <o> => ;
                        <o>:headSep   := "Õ—Õ"      ;;
                        <o>:colSep    := " ≥ "      ;;
                        <o>:footSep   := "ÕœÕ"      ;;
                        <o>:colorSpec := Colors()   ;;
 
// requests entry calculations
//
// balance
#translate ordreqBalance() => ( (cDbf)->qty_ord - (cDbf)->qty_shipd - (cDbf)->qty_canc )
// pending
#translate ordreqPending() =>  ( (cDbf)->qty_ord - (cDbf)->qty_shipd - (cDbf)->qty_canc - (cDbf)->qty_alloc)
 
// orders entry calculations
// balance
#translate ordBalance() => ( (cDbf)->qty_ord - (cDbf)->qty_shipd - (cDbf)->qty_canc )
// pending
#translate ordPending() =>  ( (cDbf)->qty_ord - (cDbf)->qty_shipd - (cDbf)->qty_canc - (cDbf)->qty_alloc)
//#translate ordPending() =>  ( (cDbf)->qty_ord - (cDbf)->qty_shipd - (cDbf)->qty_canc - (cDbf)->qty_alloc)
 
#command XREADALL  => ;
         bInsSave  := SetKey(K_INS, {|| SetCursor( if( ReadInsert( !ReadInsert() ),SC_NORMAL, SC_INSERT ))  }) ;;
         nCursSave := SetCursor( if(ReadInsert(), SC_INSERT, SC_NORMAL) )                                    ;;
         ReadModal( GetList )                                                                                ;;
         Getlist := {}                                                                                       ;;
         SetCursor(nCursSave)                                                                                ;;
         SetKey(K_INS, bInsSave)                                                                             ;;
         SETKEY(K_F2,NIL)
 
#define GETCOLORS "g+/b,g+/r"
 
 
#define COMPILE(exp)  &("{||" + exp + "}")
 
#translate :EditValue     => :cargo
 
#translate ADVANTAGE => VIA "dbfntxax"
 
#translate AddShadow(<t>,<l>,<b>,<r>) => ;
           IF IsColor()                  ;;
              Shadow(<t>,<l>,<b>,<r>)    ;;
           END
 
 
 
#command SET ATTRIBUTES TO BROWSE <bro>  =>;
         <bro>:headSep   := "Õ—Õ"     ;;
         <bro>:colSep    := " ≥ "     ;;
         <bro>:footSep   := "ÕœÕ"     ;;
         <bro>:colorSpec := Colors()
 
 
#command NETCLOSE <alias>          => ;
         SetLockInfo( <(alias)> ,, .F. ) ;;
         <alias>->( dbCloseArea() )
 
#define NEWLINE Chr(13) + Chr(10 )
 
 
#xcommand USER INTO REC FILE <file> PROGRAM <prog> [<add:NEW>] =>;
         GetUserInfo():updateUserInRec( <file> , <prog> , <.add.> )
 
// stdc unit price names
#define LABOR        1
#define OVERHEAD     2
#define MATERIALS    3
#define DEPRECIATION 4
#define UPKEEP       5
 
 
#xcommand OUT ON UP ARROW =>;
         IF LastKey() = K_UP     ;;
            SetKey( K_F2 , NIL ) ;;
            RETURN .T.           ;;
         END
 
#xtranslate OpenState(<a>) => Empty( Ascan( <a> , NIL ) )
#xtranslate SelectCriterion() => EsnAll()
 
#xtranslate AreYouSure() => Alert( "Are you sure?" , {"Yes" , "No" } )
 
#xtranslate OutFromRead() => GetActive():ExitState := GE_WRITE
 
#xtranslate AvxCloseFiles() => Aeval( aoOpenedList , {| oTable | oTable:close() } )
 
// names for returned elements from CustomerInfo()
#define CUCOID   1
#define CUNM     2
#define CNTRYID  3
#define CNTRYNM  4
#define SAREAID  5
#define SAREANM  6
#define BILLAGID 7
#define BILLAGNM 8
#define SHIPAGID 9
#define SHIPAGNM 10
#define CURRTYPE 11
#define TPTYPE   12
#define RATE     13
 
// part components
#define PTYPE    1
#define PLINE    2
#define SIZE     3
#define VALUE    4
#define TOL      5
#define TERM     6
#define TC       7
#define VOLT     8
#define ESNXX    9
#define ESNY     10
 
 
// Additions by Shalom LeVine
 
#define RDD_IN_USE    "ADS"   // Harbour: was "DBFNTXAX"
#define NTX_EXT       ".NTX"
#define USE_NEW       .T.
#define USE_SHARED    .T.
#define USE_EXCLUSIVE .F.
#define STD_RETRY      5
 
// for access rights
#define ACCESS_RO     "RO"
#define ACCESS_DENIED "XX"
#define MSG_DENIED    "304"
#define MSG_RO        "305"
 
// For Report Class
#define DBFS 1
#define NTXS 2
 
// for report class - cross tab report special cargo array
// documented in XTAB.PRG
#define XT_STRUCT    1   // the DBF field structures
#define XT_COLTITLES 2   // titles for the Report columns
#define XT_REPTITLE  3   // report title
//  COLDEFS has 3 possibilities:
//  NIL - field doesn't appear in report
// .F.  - not an Xtab field
// .T.  - Xtab field
#define XT_COLDEFS   4
#define XT_FORMAT    5   // picture format for field, if NIL same as above
 
// embedded arrays to the XT_COLTITLES array
#define XT_NONXTAB   1    // titles for the nonXtab columns
#define XT_GROUP     2    // group title - this is the xtabbed field value
#define XT_SUBGRP    3    // if needed, for multi field xtab, a subgrouping
#define XT_COLS      4    // actual column title for each xtab column
 
// for OrderCenter control of 2 dbfs
#define DBF_ORDREQ 1
#define DBF_ORD    2
 
#define R_TB "TB" // TitleBand  abbreviation for r_bands->BAND
#define R_HB "HB" // HeaderBand abbreviation for r_bands->BAND
#define R_FB "FB" // FooterBand abbreviation for r_bands->BAND
 
//for lmvcentr, new process
#define PROC_194 "194.0"
#define PROC_196 "196.0"
 


// Additions by Shalom LeVine
#define NEW_RECORD .T.
#define OLD_RECORD .F.

#define RDD_IN_USE    "ADS"   // Harbour: was "DBFCDXAX"
#define NTX_EXT       ".NTX"
#define USE_NEW       .T.
#define USE_SHARED    .T.
#define USE_EXCLUSIVE .F.
#define STD_RETRY      5

// for access rights
#define ACCESS_RO     "RO"
#define ACCESS_DENIED "XX"
#define MSG_DENIED    "304"
#define MSG_RO        "305"

// For Report Class
#define DBFS 1
#define NTXS 2

// for report class - cross tab report special cargo array
// documented in XTAB.PRG
#define XT_STRUCT    1   // the DBF field structures
#define XT_COLTITLES 2   // titles for the Report columns
#define XT_REPTITLE  3   // report title
//  COLDEFS has 3 possibilities:
//  NIL - field doesn't appear in report
// .F.  - not an Xtab field
// .T.  - Xtab field
#define XT_COLDEFS   4
#define XT_FORMAT    5   // picture format for field, if NIL same as above

// embedded arrays to the XT_COLTITLES array
#define XT_NONXTAB   1    // titles for the nonXtab columns
#define XT_GROUP     2    // group title - this is the xtabbed field value
#define XT_SUBGRP    3    // if needed, for multi field xtab, a subgrouping
#define XT_COLS      4    // actual column title for each xtab column

// for testing substitutions
#define FIELDS_NORMAL 1
#define FIELDS_SOURCE 2
#define FIELDS_DEST   3

// for OrderCenter control of 2 dbfs
#define DBF_ORDREQ 1
#define DBF_ORD    2
#define DBF_ORDRND 3

#define R_TB "TB" // TitleBand  abbreviation for r_bands->BAND
#define R_HB "HB" // HeaderBand abbreviation for r_bands->BAND
#define R_FB "FB" // FooterBand abbreviation for r_bands->BAND

//for lmvcentr, new process
#define PROC_194 "194.0"
#define PROC_196 "196.0"

// misc.
#define AREA_ISRAEL "4"
#define SYM_YEN     "ù"

// for generic batch viewing functions
#define BAT_NORMAL  1
#define BAT_HISTORY 2
#define BAT_ARCHIVE 3
#DEFINE BAT_ACTIVE  4
#DEFINE BAT_RND     5

// added by Shalom for FIXMIS calls for manual corrections
#define FIX_MKT   "1"
#define FIX_PROD  "2"
#define FIX_STOCK "3"
#define FIX_MIS   "4"
#define FIX_V7    "5"


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

#xcommand @ <row>, <col> HEBF2GET <var>                                    ;
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
       ; ATail(GetList):Reader := {|x| HebF2Reader(x) }                 ;
      [; ATail(GetList):<msg>]

