/*
 * ÚÄ Program ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³  Application: AVXBMS                                                     ³
 * ³    File Name: AVXFUNCS.PRG                                               ³
 * ³  Description:                                                            ³
 * ³             :                                                            ³
 * ³             :                                                            ³
 * ³             :                                                            ³
 * ³       Author: Danny Hazan           Tester:                              ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:18:55pm            Time updated: ş02:18:55pm            ³
 * ³    Make File: AVXBMS.RMK                                                 ³
 * ³    Exec File: AVXBMS.EXE            Docs By:                             ³
 * ³    DBFs/NTXs:                                                            ³
 * ³             :                                                            ³
 * ³             :                                                            ³
 * ³             :                                                            ³
 * ³             :                                                            ³
 * ³             :                                                            ³
 * ³    Copyright: (c) 1996 by AVX                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */

// Function/Procedure Prototype Table  -  Last Update: 10/01/99 @ 18:06:28
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// Return Value         Function/Arguments
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// nRet                 STATIC FUNCTION GetChar( cStr, cChar, nStart )
// nRet                 STATIC FUNCTION GetUom( cType )
// lretval              STATIC FUNCTION OtzarOrder(o,dToday,aRatesave)
// Void                 PROCEDURE AllRates
// Void                 PROCEDURE ArrLocateByStr( cSearch , o , nLookCol )
// Void                 PROCEDURE ChangeRates
// Void                 PROCEDURE EditRate(o,nUSD)
// Void                 PROCEDURE OutFromRead
// lChanged             FUNCTION AutoRates
// CTOD("01\"+STR(M...  FUNCTION BOM( dDate )
// NIL                  FUNCTION ClearNoHelp
// IF( nLen < 30, L...  FUNCTION CompNM( cCuco_id, nLen )
// IF( nLen < 30, L...  FUNCTION CountryNM( cCountry_id, nLen )
// IF( nLen < 30, L...  FUNCTION CustNM( cCu_id, nLen )
// aTemp                FUNCTION CustomerInfo( cCUSTID )
// cRetVal              FUNCTION DielVal( cCode )
// NIL                  FUNCTION DrawBox(t,l,b,r)
// LEFT( CMONTH( dDate  FUNCTION DtoM( iTimes )
// FotM( FotM(dDate) +  FUNCTION EotM( dDate )
// xTpRet               FUNCTION EsnTpCurr( cEsn , cTpType , cCode )
// cRetVal              FUNCTION EsnxxName(cEsnxx)
// cState               FUNCTION FindCurrency( cCurr , dDate )
// NIL                  FUNCTION FindIt( cDbf )
// NIL                  FUNCTION FindIt2( cDbf, c1stField )
// d_ord->poln_id       FUNCTION FindLastOrd( nOrd )
// dDate - ( DAY(dD...  FUNCTION FotM( dDate )
// aRetVal              FUNCTION Get2VarInfo( cDbf )
// cRetVal              FUNCTION GetBNMEtype( pPLINE_ID , pESNXX_ID )
// cRetVal              FUNCTION GetBtype( pPLINE_ID , pESNXX_ID )
// nRate                FUNCTION GetCurrRate( cCurr , dDate )
// cRet                 FUNCTION GetPLine( cAvxpn )
// cRet                 FUNCTION GetPType( cAvxpn )
// PlinePic( cPline...  FUNCTION GetPline2Pic( cEsn_id )
// cPlineID             FUNCTION GetPlineID( cEsn )
// PlinePic( cPlineID,  FUNCTION GetPlineName( cEsn_id, cPlineid )
// cPlinePic            FUNCTION GetPlinePic( cB_id )
// aRetVal              FUNCTION GetVarInfo( cDbf )
// ULOFF()              FUNCTION HpUlOff
// ULON()               FUNCTION HpUlOn
// "C"+StrZero( nCo...  FUNCTION IncComplem
// nSerNo               FUNCTION IncSerNo
// FALSE                FUNCTION IsInStr( cGetVal, cString, cErrMsg )
// TRUE                 FUNCTION IsUnique( uVal, cDbf, cIndex, nIndexOrder )
// ALERT("You press...  FUNCTION LEAVE
// PADR(ALLTRIM(cSt...  FUNCTION LJustify(cStr, nLen)
// NIL                  FUNCTION MsgBox( cMsg )
// lFound               FUNCTION MultiSeek( cSeekIn, cSeekFrom )
// IF((Fn_IsNet()>0...  FUNCTION NNetWhoAmI()
// lRetVal              FUNCTION NegaCheck(o)
// lRetVal              FUNCTION Negative( o )
// cNewId               FUNCTION NewCustId( cCustId )
// NIL                  FUNCTION NoHelp
// TRUE                 FUNCTION NotEmpty( uVal )
// IF( nOrdered-nAl...  FUNCTION NotFilled( nOrdered, nAllocated, nCanceled, nShipped )
// nQtyNval             FUNCTION Nval2Val( cBid, nQtySold )
// NIL                  FUNCTION OhSayCanYouSee( cSrchStr, cFile, cIndex, aColumns)
// cRetVal              FUNCTION PLineName(cPline)
// cRetVal              FUNCTION PTypeName(cPtype)
// NIL                  FUNCTION PickSay( r, c, cSayStr, cGetVar, cDbf, cValField, cDescField, lOk2Bblank )
// cPlinePic            FUNCTION PlinePic( cPline_Id, lPlineName )
// cPlineTitle          FUNCTION PlineTitle( cPlineID )
// cPlineID             FUNCTION Plineid( cBid )
// lRetVal              FUNCTION PostPick( o, cDbf, cValField, cDescField, cIndex, lDescribe, lCanBeEmpty )
// TRUE                 FUNCTION PrePick( o, cDbf, aColumns, bBlock, aSkips,;
// TRUE                 FUNCTION PutInGet( o, getlist, cVarname )
// PADL(ALLTRIM(cSt...  FUNCTION RJustify( cStr, nLen )
// cRetVal              FUNCTION RecElement( uCode , bRetBlock , cAlias , cIndex )
// cRetVal              FUNCTION RejName( cRejCode )
// { nResult , nDiv...  FUNCTION RoundDown( nSource, cEsnY )
// aoOpenedList         FUNCTION SH_OpenFiles( aFileList )
// IF( nLen < 30, L...  FUNCTION SareaNM( csarea_id, nLen )
// nRetVal              FUNCTION Slack(cFileName)
// IF( cStat $ "AH"...  FUNCTION Stat2Num( cStat )
// NIL                  FUNCTION TestSeeks // temporary test function
// { lFound, &(cKey) }  FUNCTION TopDownSeek( cSeekIn, cSeekFrom ,cFilter)
// nRetVat              FUNCTION Vat( lType ) // NIL 17 , .T. - 0.17
// cRetVal              FUNCTION VoltName( cCode )
// cRetVal              FUNCTION WidName( cWidCode )
// NIL                  FUNCTION genCloseFiles( aFileList )
// aoOpenedList         FUNCTION genOpenFiles( aFileList )
// cRetVal              Function Ackndlv(cPoln_id)
// FT_chdir(cName)      Function DirChange(cName)
// rpCurDir()           Function DirName()
// CurDrive()           Function DiskName()
// cRetVal              function MonthName(cMonth,cFormat)
// dRetVal              function MrkOrdDue(lUseAlias,cDbf) //YG revdue
// .t.                  Function MyFerase(cPattern,cTempDir) //s.b
// .t.                  Function MyRun(cCommand)
// IF((Fn_IsNet()>0...  Function NNetStaId()
// IF((Fn_IsNet()>0...  Function NNetWork()
// nRetVal              Function Pending(cPoln_id)
// Void                 function PlayItBaby() //guess who?
// FT_LastKey(nKey)     Function SetLastKey(nKey)
// NIL                  function ShowDLineCom(cBid,CeSN)
// nil                  function deleteRandomFiles()
// nil                  function deleteTempFiles(aFileNames)
// NIL                  function dstockfix
// d_esn->tp1/d_esn...  function getTotTp(cEsnid) //YG 10/2/98 (already existed as a dummy function
// cRetVal              function lightEmUp(cBid,cEsn)
// NIL                  function swapDemDates(cDbf)
// NIL                  function updateCalender
// lToReturn            function ChangeMode(DBAliasName)
// lToReturn            function Check(cDriver,lStatus,DBAliasName)
// lToReturn            function CheckNTX(DBAliasName,lStatus,cDriver)
// lToReturn            function CheckCDX(DBAliasName,lStatus,cDriver)
// cRetStr              function XSoftTrans(cString)

// G:\BMS\SOURCE\AVXFUNCS.PRG

//#include "Directry.ch"
#include "avxdefs.ch"

#define DBS_VAL 5


STATIC aoOpenedList
STATIC nVat

/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: AllRates                                                   ³
 * ³  Description:                                                            ³
 * ³       Author: Danny Hazan           Designer:                            ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:21:03pm            Time updated: ş02:21:03pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: None                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
PROCEDURE AllRates

LOCAL aRate := genOpenFiles({ "c_exrate"} )

AutoRates()
ChangeRates()


IF !Empty(aRate)
   IF aRate[1] != NIL
      aRate[1]:close()
   ENDIF
ENDIF
RETURN

/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: ArrLocateByStr()                                           ³
 * ³  Description:                                                            ³
 * ³       Author: Danny Hazan           Designer:                            ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:21:24pm            Time updated: ş02:21:24pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: cSearch                                                    ³
 * ³             : o                                                          ³
 * ³             : nLookCol                                                   ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
PROCEDURE ArrLocateByStr( cSearch , o , nLookCol )
LOCAL nPosition
LOCAL bSearchBlock

IF ValType( o:arrayReference[1] ) == "A"
   bSearchBlock := {|el| Alltrim( Upper( el[nLookCol] )) = Upper( cSearch ) }
ELSE
   bSearchBlock := {|el| Alltrim( Upper( el )) = Upper( cSearch ) }
ENDIF

nPosition := Ascan(  o:arrayReference , bSearchBlock )

IF !Empty( nPosition )
   o:arrayIndex := nPosition
ENDIF

o:refreshAll()

RETURN

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: AutoRates             Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Danny Hazan                                                ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:21:07pm            Time updated: ş02:21:07pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: lChanged                                                   ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION AutoRates

LOCAL nSelect := Select()
LOCAL lChanged := FALSE
LOCAL lCloseit := FALSE
LOCAL nOldOrder
LOCAL aRates := {} , i
LOCAL dLastDate , nLen
LOCAL cOldMsg := Keys24( "Updating rates" , "W+/R" )
LOCAL cOrd

 IF SELECT("c_exrate") == 0
    IF NetUse( "c_exrate" ,5)
       lCloseit := TRUE
       //c_exrate->( DbSetIndex("itpdt" ) )
       //c_exrate->( DbSetIndex("idate" ) )
    END
 END

cOrd := c_exrate->( ordSetFocus( "idate" ) )

c_exrate->( DbGoBottom() )

dLastDate := dtos(c_exrate->d_exch)

c_exrate->( DbSeek( dLastDate ) )

WHILE DTOS(c_exrate->d_exch) == dLastDate .AND. !c_exrate->( EOF() )
      Aadd( aRates , { c_exrate->curr_type , c_exrate->nis_in_uom } )
      c_exrate->( DbSkip() )              //changerates
ENDDO

nLen := Len( aRates )
FOR i := 1 TO nLen

    // if rate exists for this day do not add it
    IF c_exrate->( DbSeek( Dtos( date() ) + aRates[i,1] ) )
       lChanged := .F.
       EXIT
    ENDIF

    lChanged := .T.
    IF c_exrate->( AddRec( 5,"AUTORATES" ) )
       c_exrate->curr_type  := aRates[i,1]
       c_exrate->d_exch     := date()
       c_exrate->nis_in_uom := aRates[i,2]

       //GetUserInfo():updateUserInRec( "c_exrate" , "ALLRates", .T. )

       c_exrate->( DbUnLock() )
    ENDIF
NEXT

IF lCloseit
   c_exrate->( DBCLOSEAREA() )
ELSE
   c_exrate->( ordSetFocus( cOrd ) )
ENDIF
SELECT (nSelect)
Keys24( cOldMsg )

RETURN lChanged

/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: ChangeRates                                                ³
 * ³  Description:                                                            ³
 * ³       Author: Danny Hazan           Designer:                            ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: None                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
PROCEDURE ChangeRates

LOCAL lCloseX    := FALSE
LOCAL lCloseCurr := FALSE
LOCAL o
LOCAL oForm , nKey
LOCAL cSearcher , bKey
LOCAL nOldOrder
LOCAL nSelect   := Select( Alias() )
LOCAL aRateSave := {}
LOCAL dToday    := date()
LOCAL i
LOCAL nUSDRate  := 0
LOCAL cLine24   := SAVESCREEN(24,0,24,79)

 IF SELECT("c_exrate") == 0

   genopenfiles({"c_exrate"})
    //IF NetUse( "c_exrate" ,5)
       lCloseX := TRUE
    //   c_exrate->( DbSetIndex("itpdt" ) )
    //   c_exrate->( DbSetIndex("idate" ) )
    END
// END
 nOldOrder := c_exrate->( IndexOrd() )

 IF SELECT("c_curr") == 0
    IF NetUse("c_curr", 5)
       lCloseCurr := TRUE
       c_curr->( ordsetfocus("ccurrtyp" ) )
    ENDIF
 ENDIF

 SELECT c_exrate
 ordSetFocus( "idate" )
 IF c_exrate->( DBSEEK( DTOS( dToday ) ) )
    WHILE c_exrate->d_exch == dToday
          AADD( aRateSave, { DTOS( dToday )+c_exrate->curr_type, c_exrate->nis_in_uom } )
          IF c_exrate->curr_type == "USD"
             nUSDRate := c_exrate->nis_in_uom
          ENDIF
          c_exrate->( DBSKIP() )
    END
    c_exrate->( DBGOTOP() )
 ELSE
    // error trapping
    TONE(100,0)
    ALERT("ERROR;;Exchange rate list for today doesn't yet exist",{" OK "})
    RETURN
 ENDIF

@24,0 SAY PADC( "F5 to save & exit, F4 for Bank of Israel order, Esc to exit without saving changes", 80) COLOR "GR+/R\"

o               := TBrowseDB( 3, 5 , 21 , 50 )
o:colorSpec     := colors()
cSearcher       := Dtos( dToday )
o:gotopBlock    := {||  c_exrate->(Top(cSearcher))}
o:gobottomBlock := {||  c_exrate->(Bot(cSearcher))}
o:skipBlock     := {|n| c_exrate->(Skipit(n,cSearcher,bKey))}
bKey            := COMPILE( c_exrate->( ordKey() ) )

o:addColumn( TBColumnNEW( "Cur"        , {|| c_exrate->curr_type } ) )
o:addColumn( TBColumnNEW( "Uom     "   , {|| GetUom(c_exrate->curr_type) } ) )
o:addColumn( TBColumnNEW( "Date    "   , {|| c_exrate->d_exch } ) )
o:addColumn( TBColumnNEW( "Nis_in_Uom" , {|nVal| if(nVal=NIL,Transform( c_exrate->nis_in_uom, "99999.9999") , c_exrate->nis_in_uom:=nVal)}))
o:addColumn( TBColumnNEW( "USD_In_UOM" , {|| TRANSFORM( c_exrate->nis_in_uom/nUSDRate,"99999.9999") } ))

o:goTop()

oForm := Form():new( 2, 4 , 22 , 51 , "Rates on "+Dtoc( date() ), "W+/B" )

WHILE .T.
    WHILE !o:stabilize()
      nKey := INKEY()
      IF nKey <> 0
         EXIT
      ENDIF
    ENDDO
    nKey := TimeOutInKey()

    IF nKey = K_ESC
       FOR i := 1 TO LEN( aRateSave )
           c_exrate->( DBSEEK( aRateSave[i][1] ) )
           c_exrate->( RecLock(15,"ChangeRa") )
           c_exrate->nis_in_uom := aRateSave[i][2]
           c_exrate->( DbUnLock() )
       NEXT
       EXIT
    ELSEIF nKey == K_F5
       EXIT
    ELSEIF nKey == K_F4  //YG 9/28/97 Misrad Haotzar order project
          IF OtzarOrder(o ,dToday ,aRatesave) //TRUE = SAVE
               EXIT
          END
    ELSEIF StdKeys( nKey , o )

    ELSEIF o:colPos = 4 .AND. (nKey  >= 48 .AND. nKey <= 57)
           // edit cell acording to browse cursor
           IF nKey  >= 48 .AND. nKey <= 57
              Keyboard Chr( nKey )
              nKey := 0
           ENDIF

           EditRate( o, @nUSDRate )
           IF c_exrate->curr_type == "USD"
              o:refreshAll()
           ELSE
              o:refreshCurrent()
           ENDIF
    ENDIF
ENDDO

oForm:hide()
IF lCloseX
    c_exrate->( DBCLOSEAREA() )
ELSE
    c_exrate->( DbSetOrder( nOldOrder ) )
END
IF lCloseCurr
    c_curr->( DBCLOSEAREA() )
END
SELECT (nSelect)
RESTSCREEN(24,0,24,79,cLine24)
RETURN

/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: OtzarOrder                                                 ³
 * ³  Description: Transfer to any currency for today rate                    ³
 * ³       Author:                       Designer:                            ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: o,dToday,aRatesave       Return Value:lRetVal              ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */

/************************************/
STATIC FUNCTION OtzarOrder(o,dToday,aRatesave)
LOCAL aOtzarOrd :=  { 0,0,0,0,0,0 }     //YG 9.28.97 and the rest new variables
// added EUR 22.09.99 SS
LOCAL aOtzarCurr := {"USD","STG","YEN","EUR","ILL","DM","FFR"}
LOCAL aGetRate   := { }
LOCAL nGetRate   := 0000.00000
LOCAL i
LOCAL cClr, nKey
LOCAL cScr
LOCAL aOptions := { "Save", "Exit without saving" }
LOCAL lretval := .F.

          cScr := savescreen()
          // 3, 5 , 21 , 50
          @ 11, 8 CLEAR TO 20, 44
          cClr := color()
          SETCOLOR("w+/br")
          dispbox(11,8,20,44,2,"w+/b")
          //DrawBox( 11, 8, 19, 44, 2 )
          @ 11,16 SAY "Bank of Israel Order" color "w+/b"
          @ 12,10 SAY "Cur      Nis_in_Uom"  color "w+/b"
          @ 20,12 say "Press Enter after last value" color "w+/b"
          FOR i := 1 TO len(aOtzarCurr)
               @ i+12,10 say aOtzarCurr[i] color GETCOLORS
          NEXT
          //@ 2,10 say "  " //reseting row position
          FOR i := 1 TO len(aOtzarCurr)
                aadd(aGetRate,0)  //loading yesterdays rates YG 06/10/97
// changed order as of 04/11/98 SS
// added EUR 22.09.99 SS
                IF i == 1     //usd
                    aGetrate[1] := aRateSave[6][2]
                elseif i == 2  //stg
                    aGetrate[2] := aRateSave[5][2]
                elseif i == 3  //yen
                    aGetrate[3] := aRateSave[7][2]
                elseif i == 4  //eur
                    aGetrate[4] := aRateSave[2][2]
                elseif i == 5  //Ill
                    aGetrate[5] := aRateSave[4][2]
                elseif i == 6  //dm
                    aGetrate[6] := aRateSave[1][2]
                elseif i == 7  //ffr
                    aGetrate[7] := aRateSave[3][2]
                ENDIF

            @ i+12,19 get aGetRate[i] picture "99999.9999" color GETCOLORS
          NEXT
// tried at the last minute before my miluim to get F5 to kick us out of the read
// and save the results.
//          nKey := INKEY()
//          IF nKey == K_F5
//               FOR i := 1 TO len(aOtzarCurr)
//                    if !(c_exrate->(DBSEEK(dtos(dToday)+aOtzarCurr[i])))
//                         alert("Error: didn't find Currency type for today.")
//                    else
//                         IF rlock()
//                              c_exrate->nis_in_uom := aGetRate[i]
//                              unlock
//                         ENDIF
//                    endif
//               NEXT
//               lretval := .T.    // to also initiate save in the original screen
//               SETCOLOR(cClr)
//               RESTSCREEN(,,,,cScr)
//               o:refreshall()
//               o:gotop()
//               return lretval
//         ENDIF
          XREAD
          IF ALERT("Save present values?", aOptions) == 1
               FOR i := 1 TO len(aOtzarCurr)
                    if !(c_exrate->(DBSEEK(dtos(dToday)+aOtzarCurr[i])))
                         alert("Error: didn't find Currency type for today.")
                    else
                         IF rlock()
                              c_exrate->nis_in_uom := aGetRate[i]
                              unlock
                         ENDIF
                    endif
               NEXT
               lretval := .T.    // to also initiate save in the original screen
          ENDIF
          SETCOLOR(cClr)
          RESTSCREEN(,,,,cScr)
          o:refreshall()
          o:gotop()
RETURN lretval

/********************************/
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: GetUom                                              ³
 * ³  Description: Return 'Curr_uom' field from 'c_curr' table         ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: cType       Return Value:nRet                       ³
 * ³     See Also:                                                     ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC FUNCTION GetUom( cType )

LOCAL nRet := 0

IF c_curr->( DBSEEK( cType ) )
   nRet := c_curr->curr_Uom
ENDIF

RETURN nRet
/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: CustomerInfo()        Docs:                                ³
 * ³  Description: Return basic information for cust_id                       ³
 * ³       Author: Danny Hazan                                                ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:20:54pm            Time updated: ş02:20:54pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: cCUSTID                                                    ³
 * ³ Return Value: aTemp                                                      ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION CustomerInfo( cCUSTID )
LOCAL aTemp := {}
LOCAL nSelect := Select( Alias() )
LOCAL nOldOrd

Aadd( aTemp, RecElement( cCUSTID , {||c_cust->cuco_id},"c_cust","icu_id"))
Aadd( aTemp, c_cust->cu_nm )
Aadd( aTemp, RecElement( cCUSTID, {||c_cust->country_id},"c_cust","icu_id"))
Aadd( aTemp, RecElement(c_cust->country_id,{||c_cntry->country_nm },"c_cntry","cntryid"))
Aadd( aTemp, c_cust->sarea_id )
Aadd( aTemp, RecElement( c_cust->sarea_id, {|| c_sarea->sarea_nm }, "c_sarea","isarea" ))
Aadd( aTemp, c_cust->billag_id )
Aadd( aTemp, RecElement( aTemp[7] , {|| c_agency->ag_nm }, "c_agency", "iagencid" ))
Aadd( aTemp, c_cust->shipag_id )
Aadd( aTemp, RecElement( aTemp[9] , {|| c_agency->ag_nm }, "c_agency", "iagencid" ))
Aadd( aTemp, c_cust->curr_type )
Aadd( aTemp, c_cust->tp_type )

SELECT c_exrate
nOldOrd := c_exrate->( IndexOrd() )
ordSetFocus( "itpdt" )

IF c_exrate->( DbSeek( c_cust->curr_type + Dtos(date()) ) )
   Aadd( aTemp , c_exrate->nis_in_uom )
ELSE
   Aadd( aTemp , -1 )
ENDIF

c_exrate->( DbSetOrder( nOldOrd ) )
SELECT (nSelect)

RETURN aTemp

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: DielVal()             Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Danny Hazan                                                ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:21:56pm            Time updated: ş02:21:56pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: cCode                                                      ³
 * ³ Return Value: cRetVal                                                    ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION DielVal( cCode )
LOCAL cRetVal
DO CASE
   CASE cCode == "J"
        cRetVal := "S"
   CASE cCode == "K"
        cRetVal := "N"
   OTHERWISE
        cRetVal := " "
ENDCASE

RETURN cRetVal

/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: EditRate()                                                 ³
 * ³  Description: For ChangeRate()                                           ³
 * ³       Author: Danny Hazan           Designer:                            ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:21:16pm            Time updated: ş02:21:16pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: o                                                          ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
PROCEDURE EditRate(o,nUSD)
LOCAL bInsSave
LOCAL nCursSave
LOCAL nRow := o:nTop+o:RowPos
LOCAL nPos := Col()
LOCAL GetList := {}
LOCAL cPicture
LOCAL nVal := Val( Eval( o:getColumn( o:colPos ):block ) )

@ nRow , nPos GET nVal PICTURE "99999.9999" COLOR GETCOLORS ;
                       SEND postBlock := {|o| NegaCheck(o) }
READ

IF LastKey()  = K_ENTER .OR. LASTKEY() == K_PGDN .OR. LASTKEY() == K_PGUP
   IF c_exrate->( RecLock(5,"Editrate") )
      Eval( o:getColumn( o:colPos ):block , nVal )
      c_exrate->( DbUnLock() )
      IF c_exrate->curr_type == "USD"
         nUSD := nVal
      ENDIF
   ENDIF
ENDIF

RETURN
/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: EsnTpCurr()           Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Danny Hazan                                                ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:20:49pm            Time updated: ş02:20:49pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: cEsn                                                       ³
 * ³             : cTpType                                                    ³
 * ³             : cCode                                                      ³
 * ³ Return Value: xTpRet                                                     ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION EsnTpCurr( cEsn , cTpType , cCode )
LOCAL xTpRet
LOCAL aCurr , aTp
LOCAL nTp := Val( cTpType )

DEFAULT cCode TO "CURR"

cCode := Upper( cCode )

// seek the part ( ESN )
IF RecElement( cEsn , {|| d_esn->( Found() ) }, "d_esn" , "iesn_id" )

   IF Empty( nTp )
      IF cCode == "CURR"
         xTpRet := "???"
      ELSE
         xTpRet := 0
      ENDIF
   ELSE
      IF cCode == "CURR"
         aCurr := { d_esn->tp1_curr ,d_esn->tp2_curr ,d_esn->tp3_curr ,;
                    d_esn->tp4_curr ,d_esn->tp5_curr ,d_esn->tp6_curr ,;
                    d_esn->tp7_curr }

         xTpRet := aCurr[nTp]

      ELSE
         aTp   := { d_esn->tp1 ,d_esn->tp2 ,d_esn->tp3 ,;
                    d_esn->tp4 ,d_esn->tp5 ,d_esn->tp6 ,;
                    d_esn->tp7 }

         xTpRet := aTp[nTp]

/*  Removed by D.Laor. 27/05/97 . This division was done for historical reasons
    On the old system tp=sp on Israeli customers.
           IF nTp != 4
            xTpRet /= 1000
           ENDIF
*/
//           xTpRet /= 1000
           xTpRet /= d_esn->stdc_unit //SS 28.10.98

      ENDIF
   ENDIF

ELSE
   IF cCode == "CURR"
      xTpRet := "???"
   ELSE
      xTpRet := 0
   ENDIF
ENDIF

RETURN xTpRet

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: FindCurrency()        Docs:                                ³
 * ³  Description: For Trans2Dollar()                                         ³
 * ³       Author: Danny Hazan                                                ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:20:58pm            Time updated: ş02:20:58pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: cCurr                                                      ³
 * ³             : dDate                                                      ³
 * ³ Return Value: cState                                                     ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION FindCurrency( cCurr , dDate  )
LOCAL cState
LOCAL nSelect := Select( Alias() )
LOCAL nOldOrder := c_exrate->( IndexOrd() )

SELECT c_exrate
ordSetFocus( "itpdt" )

IF c_exrate->( DbSeek( cCurr + Dtos( dDate ) , .T. ) )
   cState := "EQ"
ELSE
   WHILE .T.
         IF c_exrate->curr_type == cCurr
            IF c_exrate->d_exch < dDate
               cState := "LOW"
               EXIT
            ENDIF
         ENDIF
         c_exrate->( DbSkip(-1) )

         IF c_exrate->( Bof() )
            cState := "NG"
            EXIT
         ENDIF
   ENDDO
ENDIF

c_exrate->( IndexOrd( nOldOrder ) )
SELECT (nSelect)

RETURN cState

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: FindLastOrd()         Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Danny Hazan                                                ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:21:29pm            Time updated: ş02:21:29pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: nOrd                                                       ³
 * ³ Return Value: d_ord->poln_id                                             ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION FindLastOrd( nOrd )
LOCAL nSelect := Select( Alias() )
LOCAL nIndexOrder
LOCAL oOrdNo := OrderNo():new( nOrd )

SELECT d_ord
nIndexOrder := d_ord->( IndexOrd() )
ordSetFocus( "ipoln_id" )

oOrdNo:combine( , 99 )

IF d_ord->( DbSeek( Str( oOrdNo:nFullOrderNo,9,2) ) )
   d_ord->( DbSkip(-1) )
ENDIF

d_ord->( DbSetOrder( nIndexOrder ) )
SELECT ( nSelect )
RETURN d_ord->poln_id


/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: GetCurrRate()         Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Danny Hazan                                                ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:21:20pm            Time updated: ş02:21:20pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: cCurr                                                      ³
 * ³             : dDate                                                      ³
 * ³ Return Value: nRate                                                      ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION GetCurrRate( cCurr , dDate )
LOCAL nRate

IF c_exrate->( DbSeek( cCurr + Dtos( dDate ) ) )
   nRate := c_exrate->nis_in_uom
ELSE
   nRate := -1

ENDIF

RETURN nRate

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: HpUlOn                Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Danny Hazan                                                ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:21:49pm            Time updated: ş02:21:49pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: Chr(27)+"&d0D"                                             ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION HpUlOn
RETURN ULON()    //Chr(27)+"&d0D"

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: HpUlOff               Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Danny Hazan                                                ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:21:53pm            Time updated: ş02:21:53pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: Chr(27)+"{ReturnValue}d"                                   ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION HpUlOff
RETURN ULOFF() //Chr(27)+"&d@"
/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: IncComplen               Docs:                             ³
 * ³  Description:                                                            ³
 * ³       Author: Danny Hazan                                                ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:21:53pm            Time updated: ş02:21:53pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: "C"+Strzero(cCompNo,5)                                     ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */

FUNCTION IncComplem
LOCAL nCompNo
LOCAL oTab := TabBase():new( "n_comple" )

IF oTab:xopen()
   IF n_comple->( RecLock(5) )
      n_comple->counter++
      nCompNo := n_comple->counter
      n_comple->( DbUnLock() )
   ENDIF
ENDIF

oTab:close()

RETURN "C"+StrZero( nCompNo , 5 )
/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: IncSerNo              Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Danny Hazan                                                ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:21:32pm            Time updated: ş02:21:32pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: nSerNo                                                     ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION IncSerNo
LOCAL nSerNo

IF n_serno->( RecLock(5,"",.F.) )
   n_serno->counter++
   nSerNo := n_serno->counter
   n_serno->( DbUnLock() )
ENDIF

RETURN nSerNo

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: IsInStr()             Docs:                                ³
 * ³  Description: Check if                                                   ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 07-09-96              Date updated: ş07-09-96              ³
 * ³ Time created: 09:27:02am            Time updated: ş09:27:02am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: cGetVal                                                    ³
 * ³             : cString                                                    ³
 * ³ Return Value: FALSE                                                      ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION IsInStr( cGetVal, cString, cErrMsg )

IF cGetVal $ cString
   RETURN TRUE
ELSEIF cErrMsg <> NIL
   Msg24( {cErrMsg}, 3, TRUE )
ELSE
   TONE( 100, 1 ) // at least beep at him
ENDIF

RETURN FALSE

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: IsUnique()            Docs:                                ³
 * ³  Description: Test for a unique value in a DBF                           ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 06-30-96              Date updated: ş06-30-96              ³
 * ³ Time created: 04:08:20pm            Time updated: ş04:08:20pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: uVal          - value to test                              ³
 * ³             : cDbf          - dbf to test againsst                       ³
 * ³             : cIndex        - index of value field                       ³
 * ³             : nIndexOrder   - index order in index list, for changing    ³
 * ³ Return Value: Logical                                                    ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION IsUnique( uVal, cDbf, cIndex, nIndexOrder )

IF !NotEmpty( uVal )
   RETURN FALSE
ENDIF

IF SELECT( cDbf ) == 0
ENDIF

// How to set order? talk to Shai

IF (cDbf)->( DBSEEK( uVal ) )
   Msg24({"303"})
   RETURN FALSE
END

RETURN TRUE
/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: NegaCheck()           Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Danny Hazan                                                ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:22:08pm            Time updated: ş02:22:08pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: o                                                          ³
 * ³ Return Value: lRetVal                                                    ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION NegaCheck(o)
LOCAL lRetVal
OUT ON UP ARROW
IF Negative(o)
   lRetVal := .F.
ELSE
   lRetVal := .T.
ENDIF
RETURN lRetVal

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: Negative()            Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Danny Hazan                                                ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:22:05pm            Time updated: ş02:22:05pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: o                                                          ³
 * ³ Return Value: lRetVal                                                    ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION Negative( o )

LOCAL nVal
LOCAL lRetVal := FALSE

IF ValType(o) == "O"
   nVal := o:varGet()
ELSE
   nVal := o
ENDIF

IF (lRetVal := nVal < 0 )
   Msg24( {"214"} , 3 , .T. )
ENDIF

RETURN lRetVal

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: NewCustId             Docs:                                ³
 * ³  Description: Get a Customer ID number for a new Customer                ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 06-30-96              Date updated: ş06-30-96              ³
 * ³ Time created: 03:26:38pm            Time updated: ş03:26:38pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: cNewId                                                     ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION NewCustId( cCustId )

LOCAL nOldRec := c_cust->( RECNO() )
LOCAL cNewId
LOCAL nOrd :=c_cust->(IndexOrd())
c_cust->(OrdSetFocus("icu_id"))
c_cust->( DBGOBOTTOM() )
cNewId := STR( VAL( c_cust->cu_id ) + 1, 5 )

c_cust->( OrdSetFocus( nOrd) )
c_cust->( DBGOTO( nOldRec) )

IF cCustId <> NIL
   IF cNewID > cCustID
     ALERT("Changing Customer ID #", {" OK "}, ALERT_STD )
   ENDIF
ENDIF

RETURN cNewId

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: NotEmpty()            Docs:                                ³
 * ³  Description: Generic Validation Function for GET that must be filled    ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 06-30-96              Date updated: ş06-30-96              ³
 * ³ Time created: 03:55:58pm            Time updated: ş03:55:58pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: uVal                                                       ³
 * ³ Return Value: Logical                                                    ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION NotEmpty( uVal )

        IF EMPTY( uVal )
           Msg24( {"300"} , 3, .T. )
           RETURN FALSE
        ENDIF

RETURN TRUE
/*
PROCEDURE OutFromRead
GetActive():ExitState := GE_WRITE
RETURN
*/

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: PickSay()             Docs:                                ³
 * ³  Description: @SAY replacement for PickList GETs, Adds a description     ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 06-30-96              Date updated: ş06-30-96              ³
 * ³ Time created: 12:09:17pm            Time updated: ş12:09:17pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: r             - Row                                        ³
 * ³             : c             - column                                     ³
 * ³             : cSayStr       - Caption                                    ³
 * ³             : cGetVar       - Get variable value                         ³
 * ³             : cDbf          - Lookup Table                               ³
 * ³             : cValField     - Lookup table Field for this GET            ³
 * ³             : cDescField    - Parallel Description Field                 ³
 * ³ Return Value: PickSay( r, c, cSayStr, cGetVar, cDbf, cValField, cDescField )
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION PickSay( r, c, cSayStr, cGetVar, cDbf, cValField, cDescField, lOk2Bblank )

DEFAULT lOk2Bblank TO FALSE

@ r, c SAY cSayStr

IF !EMPTY( cGetVar) .OR. lOk2Bblank
   IF RecElement( cGetVar, {|| (cDbf)->( Found() ) }, cDbf )
      @ r, c + (LEN(cSayStr)) SAY;
                SPACE( LEN( cGetVar ) ) +" "+ IF( cDescField <> NIL,;
                (cDbf)->(FIELDGET( (cDbf)->(FIELDPOS(cDescField)))),"");
      COLOR "W+/B"
   END
ENDIF

RETURN NIL
/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: PrePick()             Docs:                                ³
 * ³  Description: Generic PreValidation function for PickList GETs, opens the³
 * ³               Lookup Table to be used for validation                     ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 06-30-96              Date updated: ş06-30-96              ³
 * ³ Time created: 10:45:01am            Time updated: ş10:45:01am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: o     - Get object                                         ³
 * ³             : cDbf  - Picklist DBF                                       ³
 * ³ Return Value: TRUE                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION PrePick( o, cDbf, aColumns, bBlock, aSkips,;
                  cIndex, lAltS, aHeaders, cFieldVal, nField2Get, cSeekField )


IF aColumns == NIL
   SetF2Key( o, cDbf )
ELSE
   SetF2Key( o , cDbf , aColumns, bBlock, aSkips,;
                   cIndex, lAltS, aHeaders, cFieldVal, nField2Get, cSeekField )
ENDIF

RETURN TRUE

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: PostPick()            Docs:                                ³
 * ³  Description: Generic PostValidation Function for PickList GETs          ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 06-30-96              Date updated: ş06-30-96              ³
 * ³ Time created: 10:45:08am            Time updated: ş10:45:08am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: o            - Get object                                  ³
 * ³             : cDbf         - Lookup Table                                ³
 * ³             : cValField    - Lookup Table Validation Field               ³
 * ³             : cDescField   - parallel description Field                  ³
 * ³ Return Value: lRetVal      - Found?                                      ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION PostPick( o, cDbf, cValField, cDescField, cIndex, lDescribe, lCanBeEmpty,cWhatFrom ) // vitaly 05-06-01

LOCAL lRetVal := .T.
LOCAL lOpenHere := .F.
LOCAL cPos
LOCAL uSearch
MEMVAR cBuffer
//LOCAL cBuffer
PRIVATE cBufferx
//OUT ON UP ARROW

DEFAULT lDescribe TO TRUE
DEFAULT lCanBeEmpty TO FALSE
DEFAULT cWhatFrom TO " " //vitaly 05-06-01
// If the GET is a numeric string, right-justify it
IF LEFT( ALLTRIM( o:VarGet() ), 1 ) $ "1234567890" .and. LEN( o:VarGet ) <= 12
  cBuffer :=  PADL( ALLTRIM( o:varGet() ), LEN( o:VarGet ) )
  o:VarPut( cBuffer )
ELSE // it's not a numeric string
  cBuffer := Rtrim(o:VarGet())
END

 /*
 NOTE: Error messages 300 and 301 are generic:
       300 : Field Can't be left empty
       301 : Value not found in lookup table
*/
IF Empty( cBuffer ) .AND. !lCanBeEmpty
   Msg24( {"300"} , 3, .T. )
   lRetVal := .F.
ELSE
   // make sure the correct index is active
   IF Select(cDbf)==0
      GenOpenFiles({cDbf})
      lOpenHere := .T.
   ENDIF
   IF cIndex <> NIL
     (cDbf)->( ORDSETFOCUS(cIndex))
     uSearch := cBuffer
   ELSE
     cPos := STR( (cDbf)->( FIELDPOS(cValField) ), 2, 0 )
     uSearch := &([{|| FIELDGET(]+cPos+[) == "]+cBuffer+[" }])
   ENDIF
   IF RecElement( uSearch, {|| (cDbf)->( Found() ) }, cDbf )
      @ o:row , o:col SAY cBuffer +" "+;
    IF( cDescField <> NIL,(cDbf)->(FIELDGET( (cDbf)->(FIELDPOS(cDescField)))), "" ) ;
      COLOR "W+/B"
        lRetVal := .T.
   ELSE
      Msg24( {"301"} , 3, .T. )
      lRetVal := .F.
      IF lDescribe
         @ o:row , o:col SAY cBuffer + space( 20 )
      END
   ENDIF
ENDIF

IF lRetVal
   SetKey( K_F2 , NIL )
ENDIF
IF lOpenHere
    GencloseFiles({cDbf})
ENDIF
/*IF lRetVal .AND. cWhatFrom == "qpqc31v1" .AND. !d_line->(dbseek(cBuffer)) //Vitaly 05-06-01
   ALERT( "!! „† Š‰Œ„Œ ‰…š …€– €Œ" , {"Enter"} )
   lRetVal := .F.
ENDIF*/
RETURN lRetVal

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: PutInGet()            Docs:                                ³
 * ³  Description: Generic function to change a GET value                     ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 06-30-96              Date updated: ş06-30-96              ³
 * ³ Time created: 03:06:43pm            Time updated: ş03:06:43pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: o         - Present GET object                             ³
 * ³             : getlist   -                                                ³
 * ³             : cVarname  - name of GET to change its value                ³
 * ³ Return Value: PutInGet( o, getlist, cVarname )                           ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION PutInGet( o, getlist, cVarname )

LOCAL oGet

oGet := Getlist[ ASCAN( Getlist, {|o| o:name == cVarName } ) ]

oGet:VarPut( o:VarGet() )
oGet:Display()

RETURN TRUE
/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: RecElement()          Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Danny Hazan                                                ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:19:31pm            Time updated: ş02:19:31pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: cCode          to search                                   ³
 * ³             : bRetBlock      value to return                             ³
 * ³             : cAlias         alias to look on                            ³
 * ³             : cIndex         it's index                                  ³
 * ³ Return Value: cRetVal                                                    ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION RecElement( uCode , bRetBlock , cAlias , cIndex )

LOCAL cRetVal
LOCAL nSelect := Select(Alias())
LOCAL nOldOrder
LOCAL nLen


IF ValType( bRetBlock:eval() ) == "C"
   nLen := Len( bRetBlock:eval() )
ELSE
   nLen := 0
ENDIF

IF Empty( Select( cAlias ) )
   Alert( "ERROR;;"+cAlias + " file is not opened" , {" OK "} )
   RETURN Space(nLen)
ELSE
   SELECT (cAlias)
ENDIF

IF ValType( uCode ) == "C" .AND. AX_TagCount() > 0  // table is indexed
   nOldOrder := (cAlias)->( IndexOrd() )
   ordSetFocus( cIndex )

   IF (cAlias)->( DbSeek( uCode ) )
      cRetVal := bRetBlock:eval()
   ELSE
      IF ValType( bRetBlock:eval() ) == "C"
         cRetVal := Space( nLen )
      ELSE
         cRetVal := bRetBlock:eval()
      ENDIF
   ENDIF
   (cAlias)->( ordsetfocus( nOldOrder ) )   //vr

ELSE

   (cAlias)->( DbGoTop() )
   IF  (cAlias)->( __dbLocate( uCode ) , Found() )  // locate it
      cRetVal := bRetBlock:eval()
   ELSE
      IF ValType( bRetBlock:eval() ) == "C"
         cRetVal := Space( nLen )
      ELSE
         cRetVal := bRetBlock:eval()
      ENDIF
   ENDIF

ENDIF
SELECT (nSelect)
RETURN cRetVal

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: RejName()             Docs:                                ³
 * ³  Description: Return rejname from "c_rejcd" table for cRejcode           ³
 * ³       Author: Danny Hazan                                                ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:19:10pm            Time updated: ş02:19:10pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: cRejCode                                                   ³
 * ³ Return Value: cRetVal                                                    ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION RejName( cRejCode )
LOCAL cRetVal

IF Empty( Select( "c_rejcd" ) )
   Alert( "ERROR;;c_rejcd file is not opened" , {" OK "} )
   RETURN Space(20)
ENDIF

IF c_rejcd->( DbSeek( cRejCode ) )
   cRetVal := c_rejcd->rej_nmh
ELSE
   cRetVal := Space( 20 )
ENDIF
RETURN cRetVal



/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: VoltName()            Docs:                                ³
 * ³  Description: Return Volt name for volt code                             ³
 * ³       Author: Danny Hazan                                                ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:22:00pm            Time updated: ş02:22:00pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: cCode                                                      ³
 * ³ Return Value: cRetVal                                                    ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION VoltName( cCode )
LOCAL nPos , cRetVal
LOCAL aVoltNames :=  { { "1", "100V" },;
                       { "2", "200V" },;
                       { "3", "25V " },;
                       { "5", "50V " },;
                       { "8", "400V" } }

       nPos := Ascan(  aVoltNames , {| el | el[1] == cCode } )
       IF nPos > 0
          cRetVal := aVoltNames[nPos,2]
       ELSE
          cRetVal := "    "
       END
RETURN cRetVal
/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: Getbtype               Docs:                               ³
 * ³  Description: Return b_type for "pline_id+pesnexx_id"                    ³
 * ³       Author: Danny Hazan                                                ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:21:53pm            Time updated: ş02:21:53pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: pline_id,pesnxx_id                                         ³
 * ³ Return Value: cRetVal                                                    ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
//  get b_type acordin to line & esnxx
FUNCTION GetBtype( pPLINE_ID , pESNXX_ID )
LOCAL nSelect := Select( Alias() )
LOCAL oTab := TabBase():new("c_btype")
LOCAL cRetVal
oTab:setIndexList()
oTab:xopen()

SELECT c_btype
ordSetFocus( "ilinesnx" )

IF c_btype->( DbSeek( pPLINE_ID + pESNXX_ID ) )
   cRetVal := c_btype->b_type
ELSE
   cRetVal := " "
ENDIF
oTab:close()
SELECT (nSelect)
RETURN cRetVal

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: GetBNMEtype               Docs:                            ³
 * ³  Description: Return btype_nme                                           ³
 * ³       Author: Danny Hazan                                                ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:21:53pm            Time updated: ş02:21:53pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: Chr(27)+"{ReturnValue}d"                                   ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */

FUNCTION GetBNMEtype( pPLINE_ID , pESNXX_ID )
LOCAL nSelect := Select( Alias() )
LOCAL oTab,lOpenHere := FALSE
LOCAL cRetVal

IF Select("c_btype")==0

oTab := TabBase():new("c_btype")
oTab:setIndexList()
oTab:xopen()
lOpenHere := TRUE
ENDIF

c_btype->(ordSetFocus("ilinesnx"))

IF c_btype->( DbSeek( pPLINE_ID + pESNXX_ID ) )
   cRetVal := c_btype->Btype_nme
ELSE
   cRetVal := Space(25)
ENDIF
IF lOpenHere
   oTab:close()
ENDIF
SELECT (nSelect)
RETURN cRetVal


/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: WidName()             Docs:                                ³
 * ³  Description: Return work_nmh                                            ³
 * ³       Author: Danny Hazan                                                ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 02:19:14pm            Time updated: ş02:19:14pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: cWidCode                                                   ³
 * ³ Return Value: cRetVal                                                    ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION WidName( cWidCode )
LOCAL cRetVal

IF Empty( Select( "d_wid" ) )
   Alert( "d_wid file is not opened" , {"Enter"} )
   RETURN Space(20)
ENDIF

IF d_wid->( DbSeek( cWidCode ) )
   cRetVal := d_wid->work_nmh
ELSE
   cRetVal := Space( 20 )
ENDIF
RETURN cRetVal
/****************************************************************/
FUNCTION RJustify( cStr, nLen )
RETURN PADL(ALLTRIM(cStr),IF( nLen <> NIL, nLen, LEN(cStr)) )
/****************************************************************/
FUNCTION LJustify(cStr, nLen)
RETURN PADR(ALLTRIM(cStr),IF( nLen <> NIL, nLen, LEN(cStr)) )

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: GetPType() /getpline()   Docs:                             ³
 * ³  Description: FOR D_REELS indexing on product type                       ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 08-15-96              Date updated: ş08-15-96              ³
 * ³ Time created: 11:22:26am            Time updated: ş11:22:26am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: cAvxpn                                                     ³
 * ³ Return Value: d_esn->Ptype_id                                            ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION GetPType( cAvxpn,cPoln )

LOCAL cRet
LOCAL lCanClose := FALSE
LOCAL nOldArea := Select()
LOCAL nOldTag,nRec

IF SELECT("d_esn") == 0
   lCanClose := TRUE
   NetUse( "d_esn", STD_RETRY, RDD_IN_USE, USE_SHARED, USE_NEW, NIL )
   d_esn->(ordsetfocus("iavxilpn"))
ELSE
   d_esn->( ordsetfocus("iavxilpn"))  //vr
ENDIF

if d_esn->( DBSEEK( cAvxpn ) )
   cRet :=  d_esn->Ptype_id
elseif !Empty(cPoln)//vr 21-01-04,see also in labelget.prg
	IF Select("d_ord") == 0
		NetUse("d_ord",5)
		ordsetfocus(1)
		dbseek(cPoln)
		cRet :=  d_ord->Ptype_id
		d_ord->(dbclosearea())
	ELSE
		nRec := d_ord->(RecNo())
		nOldTag := d_ord->(ordsetfocus(1))
		d_ord->(dbseek(cPoln))
		cRet :=  d_ord->Ptype_id
		d_ord->(ordsetfocus(nOldTag))
		d_ord->(dbgoto(nRec))
   ENDIF
endif

IF lCanClose
   CLOSE d_esn
ELSE
   d_esn->( ordsetfocus("iesn_id"))
ENDIF
dbselectarea(nOldArea)
RETURN cRet
/////////////////////////////////////////////////////////////////
FUNCTION GetPLine( cAvxpn,cPoln )

LOCAL cRet
LOCAL lCanClose := FALSE
LOCAL nOldArea := Select()
LOCAL nOldTag,nRec


IF SELECT("d_esn") == 0
   lCanClose := TRUE
   NetUse( "d_esn", STD_RETRY, RDD_IN_USE, USE_SHARED, USE_NEW, NIL )
   d_esn->(ordsetfocus("iavxilpn"))
ELSE
   d_esn->( ordsetfocus("iavxilpn"))
ENDIF

if d_esn->( DBSEEK( cAvxpn ) )
   cRet :=  d_esn->Pline_id
elseif !Empty(cPoln)//vr 21-01-04,see also in labelget.prg
	IF Select("d_ord") == 0
		NetUse("d_ord",5)
		ordsetfocus(1)
		dbseek(cPoln)
		cRet :=  d_ord->Pline_id
		d_ord->(dbclosearea())
	ELSE
		nRec := d_ord->(RecNo())
		nOldTag := d_ord->(ordsetfocus(1))
		d_ord->(dbseek(cPoln))
		cRet :=  d_ord->Pline_id
		d_ord->(ordsetfocus(nOldTag))
		d_ord->(dbgoto(nRec))
   ENDIF
endif

IF lCanClose
   CLOSE d_esn
ELSE
   d_esn->( DBSETORDER("iesn_id"))
END

RETURN cRet

// 5 functions Added 12-09 by Shalom for special Index creation
// 4th function added 17-09, to get the pline_id from the ESN_id for d_ord
/**********************************************************************/
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: GetPlineID                                          ³
 * ³  Description:                                                     ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: cEsn        Return Value:cPlineID                   ³
 * ³     See Also:                                                     ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION GetPlineID( cEsn )

LOCAL cPlineID
LOCAL nSelect := 0

IF Select("d_esn") == 0
   nSelect := SELECT()
   NetUse( "d_esn", STD_RETRY, RDD_IN_USE, USE_SHARED, USE_NEW, NIL )
   d_esn->( ordsetfocus("iesn_id") )
ENDIF

cPlineID := IF( d_esn->( DBSEEK( cEsn )), d_esn->pline_id, SPACE(3) )

IF nSelect > 0
   CLOSE d_esn
   SELECT (nSelect)
ENDIF

RETURN cPlineID
/**********************************************************************/
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: PlineTitle                                          ³
 * ³  Description:                                                     ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: cPlineID    Return Value:cPlineTitle                ³
 * ³     See Also:                                                     ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION PlineTitle( cPlineID )

LOCAL cPlineTitle
LOCAL nSelect := 0

IF Select("c_pline") == 0
   nSelect := SELECT()
   NetUse( "c_pline", STD_RETRY, RDD_IN_USE, USE_SHARED, USE_NEW, NIL )
   c_pline->( ordsetfocus("c_pline") )
ENDIF

cPlinetitle := IF( c_pline->( DBSEEK( cPlineID ) ), c_pline->pline_id+" - " + ;
                                                    c_pline->pline_nm, SPACE(33))

IF nSelect > 0
   CLOSE c_pline
   SELECT (nSelect)
ENDIF

RETURN cPlineTitle

/**********************************************************************/
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: Plineid                                             ³
 * ³  Description:                                                     ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: cBid        Return Value:cPlineID                   ³
 * ³     See Also:                                                     ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION Plineid( cBid )

LOCAL cPlineID
LOCAL nSelect := 0

IF Select("d_line") == 0
   nSelect := SELECT()
   NetUse( "d_line", STD_RETRY, RDD_IN_USE, USE_SHARED, USE_NEW, NIL )
   d_line->( ordsetfocus("ib_idln") )
ENDIF

cPlineID :=  IF( d_line->( DBSEEK( cBid ) ),  d_line->Pline_Id, SPACE(3))

IF nSelect > 0
   CLOSE d_line
   SELECT (nSelect)
ENDIF

RETURN cPlineID
/**********************************************************************/
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: PlinePic                                            ³
 * ³  Description:                                                     ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: cPline_id,lPlineName       Return Value:cPlinePic   ³
 * ³     See Also:                                                     ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION PlinePic( cPline_Id, lPlineName )

LOCAL cPlinePic
LOCAL nSelect1 := 0
LOCAL nSelect2 := 0

IF( lPlineName == NIL, lPlineName := .F. , NIL )

IF Select("d_line") == 0
   nSelect1 := SELECT()
   NetUse( "d_line", STD_RETRY, RDD_IN_USE, USE_SHARED, USE_NEW, NIL )
   d_line->( ordsetfocus("ib_idln") )
ENDIF

IF Select("c_pline") == 0
   nSelect2 := SELECT()
   NetUse( "c_pline", STD_RETRY, RDD_IN_USE, USE_SHARED, USE_NEW, NIL )
   c_pline->( ordsetfocus("c_pline") )
ENDIF

cPlinePic := IF( c_pline->( DBSEEK( cPline_Id) )                       ,;
                IF( lPlineName, c_Pline->pline_nm, c_Pline->pline_Pic ),;
                IF( lPlineName, SPACE(30), SPACE(20) )                  ;
               )

IF nSelect1 > 0
   CLOSE d_line
END
IF nSelect2 > 0
   CLOSE c_pline
END
IF nSelect1 > 0
   SELECT (nSelect1)
ELSEIF nSelect2 > 0
   SELECT (nSelect2)
ENDIF

RETURN cPlinePic

/**********************************************************************/
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: GetPlinePic                                         ³
 * ³  Description:                                                     ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: cB_id       Return Value:cPlinePic                  ³
 * ³     See Also:                                                     ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION GetPlinePic( cB_id )

LOCAL cPlinePic := SPACE(20)
LOCAL nSelect1  := 0
LOCAL nSelect2  := 0

IF Select("d_line") == 0
   nSelect1 := SELECT()
   NetUse( "d_line", STD_RETRY, RDD_IN_USE, USE_SHARED, USE_NEW, NIL )
   d_line->( ordsetfocus("ib_idln") )
ELSE
   d_line->( ORDSETFOCUS("ib_idln") )
ENDIF
IF Select("c_pline") == 0
   nSelect2 := SELECT()
   NetUse( "c_pline", STD_RETRY, RDD_IN_USE, USE_SHARED, USE_NEW, NIL )
   c_pline->( ordsetfocus("c_pline") )
ENDIF

IF d_line->( DBSEEK( cB_id ) )
   IF(c_pline->(DBSEEK(d_line->Pline_Id)), cPlinePic := c_Pline->pline_Pic, NIL)
END

IF nSelect1 > 0
   CLOSE d_line
END
IF nSelect2 > 0
   CLOSE c_pline
END
IF nSelect1 > 0
   SELECT (nSelect1)
ELSEIF nSelect2 > 0
   SELECT (nSelect2)
ENDIF

RETURN cPlinePic
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: GetPline2Pic                                        ³
 * ³  Description:                                                     ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: cEsn_id       Return Value:PlinePic(cPlineID)       ³
 * ³     See Also:                                                     ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
/**********************************************************************/
FUNCTION GetPline2Pic( cEsn_id )

LOCAL cPlineID := GetPlineId( cEsn_id )
RETURN PlinePic( cPlineID )
/**********************************************************************/
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: GetPlineName                                        ³
 * ³  Description:                                                     ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³ Parameters: cEsn_id,cPlineID Return Value:PlinePic(cPlineID,TRUE) ³
 * ³ See Also:                                                         ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION GetPlineName( cEsn_id, cPlineid )

IF( cPlineID == NIL, cPlineID := GetPlineId( cEsn_id ), NIL )

RETURN PlinePic( cPlineID, .T. )
/**********************************************************************/
// Function for d_prom to index on status as 3rd index key. I want a single
// return value for 2 dofferent statuses.
FUNCTION Stat2Num( cStat )
RETURN IF( cStat $ "AH", "0", "1" )
/**********************************************************************/
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: MsgBox                                              ³
 * ³  Description:                                                     ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: cMsg        Return Value:NIL                        ³
 * ³     See Also:                                                     ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION MsgBox(  cMsg )

LOCAL nLen    := LEN( cMsg ) + 4
LOCAL nTop    := 11
LOCAL nLeft   := 40 - ( nLen / 2 )
LOCAL nBottom := 15
LOCAL nMsgRow := 13
LOCAL nRight  := nLeft + nLen

DispBox( nTop, nLeft, nBottom, nRight, FRAME +" ", "w+/bg")
@ nMsgRow, nLeft + 2 SAY cMsg COLOR "n/bg"

RETURN NIL
/*******************************************************************
* Function to calculate the amount of non valued stock that
* was sold for a given batch number
*
* RETURNS: Total non valued stock up to amount of sale
*/
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: Nval2Val                                            ³
 * ³  Description:                                                     ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: cBid,nQtySold       Return Value:nQtyNVal           ³
 * ³     See Also:                                                     ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION Nval2Val( cBid, nQtySold )

LOCAL nSelect      := SELECT()
LOCAL nRec
LOCAL lAlreadyOpen := SELECT("d_stock") > 0
LOCAL nQtyNval     := 0
LOCAL aoOpenFiles

IF lAlreadyOpen
   nRec := d_stock->( RECNO() )
ENDIF

  aoOpenFiles := GenOpenFile({"d_stock"})
  d_stock->( ORDSETFOCUS("bnesn_st"))
  d_stock->( DBSEEK( cBid ) )

  WHILE nQtySold > 0 .AND. d_stock->b_id == cBid
        IF nQtySold > d_stock->qty_nval
           nQtyNval += d_stock->qty_nval
           nQtySold -= d_stock->qty_nval
           d_stock->( RecLock(5,"Nval2Val") )
           d_stock->qty_nval := 0
           d_stock->( DBUNLOCK() )
        ELSE
           nQtyNval += nQtySold
           d_stock->( RecLock(5,"Nval2Val") )
           d_stock->qty_nval -= nQtySold
           d_stock->( DBUNLOCK() )
           nQtySold := 0
        ENDIF
        d_stock->( DBSKIP() )
  END
  // Added 16-12-97 by Shalom to handle the missing link; qty_valued stock
  // that must be removed from d_stock in a sale greater than all of the
  // nonvalued stock available.
  IF nQtySold > 0
     d_stock->( DBSEEK( cBid ) )
     WHILE nQtySold > 0 .AND. d_stock->b_id == cBid
           IF nQtySold > d_stock->qty_val
              nQtySold -= d_stock->qty_val
              d_stock->( RecLock(5,"Nval2Val") )
              d_stock->qty_val := 0
              d_stock->( DBUNLOCK() )
           ELSE
              d_stock->( RecLock(5,"Nval2Val") )
              d_stock->qty_val -= nQtySold
              d_stock->( DBUNLOCK() )
              nQtySold := 0
           ENDIF
           d_stock->( DBSKIP() )
     END
  END

IF lAlreadyOpen
   d_stock->( DBGOTO( nRec ) )
ELSE
   CLOSE d_stock
ENDIF
SELECT (nSelect)

RETURN nQtyNval

*********************************************************************
FUNCTION NotFilled( nOrdered, nAllocated, nCanceled, nShipped )
RETURN  IF( nOrdered-nAllocated-nCanceled-nShipped== 0, "0", "1" )
*********************************************
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: Slack                                               ³
 * ³  Description:                                                     ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: cFileName       Return Value:nRetVal                ³
 * ³     See Also:                                                     ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
FUNCTION Slack(cFileName)

LOCAL nRetVal

nRetVal := (cFileName)->b_dprom - ( date() + LTime_NoRoute(cFileName) )

RETURN nRetVal

*/
/**************************************************************/
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: CustNM,CompNM,CountryNM,SareaNM                     ³
 * ³  Description:                                                     ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: cCu_id,nLen       Return Value:cRet                 ³
 * ³     See Also:                                                     ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION CustNM( cCu_id, nLen ,cAlias)

LOCAL cRet
LOCAL lOpenHere := FALSE
LOCAL nSelect := SELECT()

DEFAULT nLen TO 30
IF Empty(val(cCu_id))
	cRet := substr( (cAlias)->poln_mess1 ,1,nLen )
	RETURN cRet
ENDIF
 IF Select("C_CUST")=0
    GenOpenFiles({"C_CUST"})
    lOpenHere := TRUE

 ENDIF
 cRet := RecElement( cCu_id, {|| c_cust->cu_nm}, "c_cust" , "icu_id")
 SELECT (nSelect)
 IF lOpenHere
    GENCLOSEFILES({"c_Cust"})
 ENDIF

RETURN IF( nLen < 30, LEFT(cRet,nLen), cRet )

/*******************************************************************/
FUNCTION CompNM( cCuco_id, nLen )

LOCAL cRet
LOCAL nSelect := SELECT()

DEFAULT nLen TO 30

 IF Select("C_CUCO")=0
    GenOpenFiles({"C_CUCO"})
 endif
 cRet := RecElement( cCuCo_id, {|| c_cuco->cuco_nm}, "c_cuco" , "icuco")
 SELECT (nSelect)

RETURN IF( nLen < 30, LEFT(cRet,nLen), cRet )

/*******************************************************************/
FUNCTION SareaNM( csarea_id, nLen )

LOCAL cRet
LOCAL nSelect := SELECT()
LOCAL lOpenHere := .f.

DEFAULT nLen TO 30

 IF Select("C_SAREA")=0
    GenOpenFiles({"C_SAREA"})
    lOpenHere := .t.
 ENDIF
 cRet := RecElement( csarea_id, {|| c_sarea->sarea_nm}, "c_sarea" , "isarea")
 SELECT (nSelect)
 IF lOpenHere
    GenCloseFiles({"C_SAREA"})
 ENDIF

RETURN IF( nLen < 30, LEFT(cRet,nLen), cRet )

/*******************************************************************/
FUNCTION CountryNM( cCountry_id, nLen )

LOCAL cRet
LOCAL nSelect := SELECT()

DEFAULT nLen TO 30

 IF Select("C_Cntry")=0
    GenOpenFiles({"C_Cntry"})
 ENDIF
 cRet := RecElement( cCountry_id, {|| c_cntry->country_nm}, "c_cntry" , "cntryid")

 SELECT (nSelect)

RETURN IF( nLen < 30, LEFT(cRet,nLen), cRet )

/**************************************************************/
*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: OhSayCanYouSee                                      ³
 * ³  Description:                                                     ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: cSrchStr,cFile,cIndex,aColumns    Return Value:NIL  ³
 * ³     See Also:                                                     ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION OhSayCanYouSee( cSrchStr, cFile, cIndex, aColumns)

LOCAL cOrd
LOCAL lClose := TRUE

LOCAL aSkips := {;
                 {|| (cFile)->( Top( cSrchStr ) ) }                                        ,;
                 {|| (cFile)->( Bot( cSrchStr  ) ) }                                       ,;
                 {|n| (cFile)->( SkipIt( n, cSrchStr , COMPILE( (cFile)->(ordKey() ) ) ) )} ;
                }

IF SELECT(cFile) == 0
   NetUse(cFile,5)
      (cFile)->( ordsetfocus(cIndex) )
ELSE
   lClose := FALSE
   cOrd := (cFile)->( ORDSETFOCUS( cIndex ) )
END
      IF(cFile)->( DBSEEK(cSrchStr) )
         IF lClose
            (cFile)->( DBCLOSEAREA() )
         END
         TableSelect( cFile, {|| .T.  } , aColumns , NIL, aSkips, TRUE,;
                      cIndex, FALSE, NIL, cSrchStr )
      ELSE
         IF lClose
            (cFile)->( DBCLOSEAREA() )
         ENDIF
         Msg24("No matching records found", 3, .T. )
      END

IF !lClose
   (cFile)->( ORDSETFOCUS( cOrd ) )
ENDIF

RETURN NIL
/************************************************************************/
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: Pending                                             ³
 * ³  Description:                                                     ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: cPoln_id       Return Value:nRetVal                 ³
 * ³     See Also:                                                     ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
Function Pending(cPoln_id) //Vitaly 25-07-01

LOCAL nRetVal := 0
LOCAL nSelect := SELECT()
LOCAL lWasOpenedHere := .F.

IF Select("d_ord") == 0
   GenOpenFiles({"d_ord"})
   lWasOpenedHere := .T.
ENDIF
IF d_ord->(DBSEEK(cPoln_id))
   nRetVal := d_ord->QTY_ORD - d_ord->QTY_CANC - d_ord->QTY_ALLOC - d_ord->QTY_SHIPD
ENDIF
IF lWasOpenedHere
   D_ORD->(dbclosearea()) //Vitaly 24-07-01
ENDIF
dbselectarea(nSelect)
RETURN nRetVal

/************************************************************************/
Function GetESN_ID(cPoln_id)   //vitaly
*
* YH 19-11-00
*      € .š†…˜‡ …‰‰„ ,Len(Esn) „˜‰†‡ „‰–—…”„ .0 Š˜’ „Œ‰‡š‹Œ Œ‰— nRetVal
* !!! š‰‹š„ š”…’šŒ €‰„ Len(0) … 0 „˜š… Œƒ‡„ š˜‰˜ ,D_ord  „€– €Œ „…™˜„
*
LOCAL nRetVal := "",lFlag := .F.
LOCAL nSelect := SELECT()
LOCAL aFiles
IIF(select("d_ord")==0,lFlag := .T.  ,NIL )
aFiles := GenOpenFiles({"d_ord"})
IF d_ord->(DBSEEK(cPoln_id))
   nRetVal := d_ord->ESN_ID//ESNXX_ID
ENDIF
IIF(lFlag,GenCloseFiles({"d_ord"} ) ,NIL )
RETURN nRetVal

/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: Ackndlv                                             ³
 * ³  Description: Return mrkorddue for cpoln_id                       ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: cPoln_id       Return Value:cRetVal                 ³
 * ³     See Also:                                                     ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
Function GetPolnType(cPoln_id)   //vitaly
*
* YH 19-11-00
*      € .š†…˜‡ …‰‰„ ,Len(Esn) „˜‰†‡ „‰–—…”„ .0 Š˜’ „Œ‰‡š‹Œ Œ‰— nRetVal
* !!! š‰‹š„ š”…’šŒ €‰„ Len(0) … 0 „˜š… Œƒ‡„ š˜‰˜ ,D_ord  „€– €Œ „…™˜„
*
LOCAL cRetVal := " ",lFlag := .F.
LOCAL nSelect := SELECT()
LOCAL aFiles
IIF(select("d_ord")==0,lFlag := .T.  ,NIL )
aFiles := GenOpenFiles({"d_ord"})
IF d_ord->(DBSEEK(cPoln_id))
   cRetVal := d_ord->poln_type
ENDIF
IIF(lFlag,GenCloseFiles({"d_ord"} ) ,NIL )
RETURN cRetVal

Function Ackndlv(cPoln_id)

LOCAL cRetVal := "  /  /  "
LOCAL nSelect := SELECT()
//LOCAL aFiles := GenOpenFiles({"d_ord"})
LOCAL nOrder
local nrecNo
local lCloseIt := .F.

IF select("d_ord") == 0
     GenOpenFiles({"d_ord"})
     lCloseIt := .T.
else
     nOrder := d_ord->(indexord())
     nrecNo := d_ord->(recno())
ENDIF
d_ord->(ordsetfocus("ipolnoid"))
IF d_ord->(DBSEEK(cPoln_id))
   cRetVal := DTOC(mrkOrdDue(.T.,"d_ord"))
//   cRetVal := DTOC(d_ord->d_ackndlv)
ENDIF
IF lCloseIt
     D_ORD->(DBCLOSEAREA())
else
     d_ord->(dbsetorder(nOrder))
     d_ord->(dbgoto(nRecNo))
ENDIF
SELECT (nSelect)
RETURN cRetVal
/////////////////////////////////////////////////////////////////////
FUNCTION NoHelp
@24,0 SAY "No help available for this screen" COLOR "gr+/rb"
RETURN NIL
////////////////////////////////////////////////////////////////////////
FUNCTION ClearNoHelp
@24,0 SAY "Help:[F1]                        "  COLOR "gr+/rb"
RETURN NIL
/********************************************************************/
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: PTypeName                                           ³
 * ³  Description:                                                     ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: cPType      Return Value:cRetVal                    ³
 * ³     See Also:                                                     ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION PTypeName(cPtype)

LOCAL cOldNtx
LOCAL cRetVal := ""
LOCAL lAlreadyOpen := TRUE

IF SELECT("c_ptype") == 0
   lAlreadyOpen := FALSE
   GenOpenFiles({"c_ptype"})
ENDIF
cOldNtx :=  c_ptype->( ORDSETFOCUS("iptype") )

IF c_ptype->( __DbLocate( {|| c_ptype->ptype_id == cptype } ) , Found() )
   cRetVal := c_ptype->ptype_nm
END

IF lAlreadyOpen
   c_ptype->( ORDSETFOCUS( cOldNtx ) )
ELSE
   c_ptype->( DBCLOSEAREA() )
ENDIF

RETURN cRetVal
/*******************************************************************/
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: PLineName                                           ³
 * ³  Description:                                                     ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: cPline      Return Value:cRetVal                    ³
 * ³     See Also:                                                     ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION PLineName(cPline)

LOCAL cRetVal := ""
LOCAL cOldNtx
LOCAL lAlreadyOpen := TRUE

IF SELECT("c_pline") == 0
   lAlreadyOpen := FALSE
   GenOpenFiles({"c_pline"})
ENDIF
cOldNtx :=  c_pline->( ORDSETFOCUS("c_pline") )
//GenOpenFiles({"c_ptype"})
IF c_pline->( dbseek( cPline ) )
   cRetVal := c_pline->pline_nm
END
IF lAlreadyOpen
   c_pline->( ORDSETFOCUS( cOldNtx ) )
ELSE
   c_pline->( DBCLOSEAREA() )
ENDIF
RETURN cRetVal
/*******************************************************************/
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: EsnxxName                                           ³
 * ³  Description:                                                     ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: cEsnxx      Return Value:cRetVal                    ³
 * ³     See Also:                                                     ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION EsnxxName(cEsnxx)
LOCAL cRetVal := ""
//GenOpenFiles({"c_ptype"})
IF c_esnxx->( dbseek( cEsnxx ) )
   cRetVal := c_esnxx->esnxx_nm
END
RETURN cRetVal
/****************************************************************/
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: Vat                                                 ³
 * ³  Description:                                                     ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: lType       Return Value:nRetVat                    ³
 * ³     See Also:                                                     ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION Vat( lType )  // NIL 17 , .T. - 0.17
LOCAL nRetVAt

DEFAULT lType TO .F.


IF Empty( nVat)
   nVat := Val( MemoRead( "VAT.VAT" ) )
ENDIF

IF lType
   nRetVat := ROUND(nVat / 100,3)
ELSE
   nRetVat := nVat
ENDIF


RETURN nRetVat

/*******************************************************************/
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: RoundDown                                           ³
 * ³  Description:                                                     ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: cSource,cEsnY      Return Value:{nResult,nDivisor}  ³
 * ³     See Also:                                                     ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION RoundDown( nSource, cEsnY )

LOCAL nDivisor
LOCAL nResult

IF c_esny->( DBSEEK(cEsnY) )
   IF (nDivisor := c_esny->esny_qty) == 0
       nDivisor := 1
   END
ELSE
   ALERT("WARNING;;No listing for this ESN(Y) ("+cEsnY+")",{" OK "}, ALERT_WARN )
   nDivisor := 1
END

//IF ( nResult := nSource / nDivisor ) > INT( nResult )
//     nResult := INT(nResult) * nDivisor
//ELSE
     nResult := INT( nSource / nDivisor ) * nDivisor
//ENDIF

RETURN { nResult , nDivisor }
/*******************************************************************/
Function NNetStaId()
RETURN IF((Fn_IsNet()>0),"012345678911",Fn_StaAddr())
////////////////////////////////////////////////////////////////////
FUNCTION NNetWhoAmI()
RETURN IF((Fn_IsNet()>0),"SHAI",Fn_WhoAmI())
/////////////////////////////////////////////////////////////////////
Function NNetWork()
RETURN IF((Fn_IsNet()>0),.f.,.t.)
/////////////////////////////////////////////////////////////////////
Function DiskName()
Return CurDrive()
/////////////////////////////////////////////////////////////////////
Function DirName()
Return rpCurDir()
/////////////////////////////////////////////////////////////////////
Function DirChange(cName)
Return FT_chdir(cName)
/////////////////////////////////////////////////////////////////////
Function SetLastKey(nKey)
Return FT_LastKey(nKey)
/////////////////////////////////////////////////////////////////////
FUNCTION BOM( dDate )
RETURN CTOD("01\"+STR(MONTH(dDate),2,0)+"\"+RIGHT(STR(YEAR(dDate),4,0),2) )
/////////////////////////////////////////////////////////////////////
FUNCTION DtoM( iTimes )
LOCAL dDate := BOM( date() ) + ( 32 * iTimes )
RETURN LEFT( CMONTH( dDate ), 3 )+" "+RIGHT(STR(YEAR(dDate),4,0),2)
/***********************************************************************/
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: FindIt                                              ³
 * ³  Description:                                                     ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: cDbf       Return Value:NIL                         ³
 * ³     See Also:                                                     ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION FindIt( cDbf )

LOCAL cScr := SAVESCREEN(10,05,14,75)
LOCAL cClr := SETCOLOR("n/bg, bg/n")
LOCAL uVar := GetVarInfo( cDbf )
LOCAL Getlist := {}
LOCAL lContinue := .T.
LOCAL nRec      := (cDbf)->( RECNO() )
LOCAL cChrTitle :=  "A partial search pattern is allowed ."
LOCAL cnumTitle :=  "Only a full search pattern will work."
SETCURSOR(1)

@10,05 CLEAR TO 14,75
@10,05 TO 14,75 DOUBLE COLOR "w+/bg"
@12, 07 SAY "Enter a search pattern: " GET uVar[DBS_VAL] PICTURE "@!"  // uVar[5]
@13, 06 SAY PADC( IF(uVar[DBS_TYPE] == "C", cChrTitle, cNumTitle ),68) COLOR "gr+/bg"   // uVar[2]

READ

IF LASTKEY() == K_ESC
   lContinue := .F.
ENDIF
IF lContinue
   IF uVar[DBS_TYPE] == "N"
      uVar[DBS_VAL] := STR( uVar[DBS_VAL], uVar[DBS_LEN], uVar[DBS_DEC] )
   ELSEIF uVar[DBS_TYPE] == "C"
      uVar[DBS_VAL] := ALLTRIM( uVar[DBS_VAL] )
   ELSEIF uVar[DBS_TYPE] == "D"
     uVar[DBS_VAL] := DTOS( uVar[DBS_VAL])
   ENDIF

   IF !(cDbf)->( DBSEEK( uVar[DBS_VAL] ) )
      IF uVar[DBS_TYPE] == "C"
         IF LOWER( uVar[DBS_NAME] ) == "b_id"
            uVar[DBS_VAL] := PADL(uVar[DBS_VAL],uVar[DBS_LEN],"0")
         //ELSEIF LOWER( uVar[DBS_NAME] ) == ""
         ELSE
            uVar[DBS_VAL] := PADL(uVar[DBS_VAL],uVar[DBS_LEN] )
         ENDIF
         IF !(cDbf)->( DBSEEK( uVar[DBS_VAL] ) )
            Msg24( "Search pattern not found", 3, .T. )
            (cDbf)->( DBGOTO( nRec ) )
         END
      ELSE
         Msg24( "Search pattern not found", 3, .T. )
         (cDbf)->( DBGOTO( nRec ) )
      END
   END
ENDIF

SETCURSOR(0)
SETCOLOR( cClr )
RESTSCREEN(10,05,14,75,cScr)
RETURN NIL
/*************************************************************************/
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: FindIt2                                             ³
 * ³  Description:                                                     ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: cDbf,c1stField       Return Value:NIL               ³
 * ³     See Also:                                                     ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION FindIt2( cDbf, c1stField )

LOCAL cScr := SAVESCREEN(10,05,14,75)
LOCAL cClr := SETCOLOR("n/bg, bg/n")
LOCAL uVar := Get2VarInfo( cDbf )
LOCAL Getlist := {}
LOCAL lContinue := .T.
LOCAL nRec      := (cDbf)->( RECNO() )
LOCAL cChrTitle :=  "A partial search pattern is allowed ."
LOCAL cnumTitle :=  "Only a full search pattern will work."
SETCURSOR(1)

@10,05 CLEAR TO 14,75
@10,05 TO 14,75 DOUBLE COLOR "w+/bg"
@12, 07 SAY "Enter a search pattern: " GET uVar[DBS_VAL] PICTURE "@!"
@13, 06 SAY PADC( IF(uVar[DBS_TYPE] == "C", cChrTitle, cNumTitle ),68) COLOR "gr+/bg"

READ

IF LASTKEY() == K_ESC
   lContinue := .F.
ENDIF
IF lContinue
   IF uVar[DBS_TYPE] == "N"
      uVar[DBS_VAL] := STR( uVar[DBS_VAL], uVar[DBS_LEN], uVar[DBS_DEC] )
   ELSEIF uVar[DBS_TYPE] == "C"
      uVar[DBS_VAL] := ALLTRIM( uVar[DBS_VAL] )
   ENDIF

   IF !(cDbf)->( DBSEEK( c1stField+uVar[DBS_VAL] ) )
      IF uVar[DBS_TYPE] == "C"
         IF LOWER( uVar[DBS_NAME] ) == "b_id"
            uVar[DBS_VAL] := PADL(uVar[DBS_VAL],uVar[DBS_LEN],"0")
         //ELSEIF LOWER( uVar[DBS_NAME] ) == ""
         ELSE
            uVar[DBS_VAL] := PADL(uVar[DBS_VAL],uVar[DBS_LEN] )
         ENDIF
         IF !(cDbf)->( DBSEEK( c1stField+uVar[DBS_VAL] ) )
            Msg24( "Search pattern not found", 3, .T. )
            (cDbf)->( DBGOTO( nRec ) )
         END
      ELSE
         Msg24( "Search pattern not found", 3, .T. )
         (cDbf)->( DBGOTO( nRec ) )
      END
   END
ENDIF

SETCURSOR(0)
SETCOLOR( cClr )
RESTSCREEN(10,05,14,75,cScr)
RETURN NIL
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: GetTotTp                                            ³
 * ³  Description:                                                     ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: cEsnid       Return Value:tp1/stdc_unit             ³
 * ³     See Also:                                                     ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
/*************************************************************************/
function getTotTp(cEsnid)     //YG 10/2/98 (already existed as a dummy function
                              //in tvr\main but couldn't find it used anywhere
                              //so decided to define it.  Called from rfgs09v1.rh2

if select("d_esn") == 0
   NetUse( "d_esn", STD_RETRY, RDD_IN_USE, USE_SHARED, USE_NEW, NIL )
   d_esn->(ordsetfocus("iesn_id"))
else
   d_esn->( ORDSETFOCUS("iesn_id"))
endif
d_esn->(dbseek(cEsnId))

return d_esn->tp1/d_esn->stdc_unit
/*************************************************************************/
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: GetVarInfo,Get2VarInfo                              ³
 * ³  Description:                                                     ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: cDbf       Return Value:aRetVal                     ³
 * ³     See Also:                                                     ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION GetVarInfo( cDbf )

LOCAL aStruct := (cDbf)->( DBSTRUCT() )
LOCAL cFieldName
LOCAL cKey   := (cDbf)->( ORDKEY() )
LOCAL nGT    := AT(">",cKey)      //changed by Tanya
LOCAL nGC    := AT("(",cKey)
LOCAL nPlus  := AT( "+", cKey )
LOCAL nComma := AT(",", cKey)
LOCAL nParen := AT(")", cKey)
LOCAL nEnd
LOCAL nField
LOCAL aRetVal := {}

nEnd := IF( nPlus > nComma .AND. nComma > 0, nComma, IF(nPlus == 0, nComma, nPlus) )
IF( (nEnd > nParen .OR. nEnd == 0) .AND. nParen > 0, nEnd := nParen, NIL )
IF( nEnd == 0, nEnd := LEN(cKey), nEnd -= 1 )
IF ">" $ cKey
     cKey := UPPER( ALLTRIM( SUBSTR( cKey, nGT+1, IF( nEnd>0, nEnd-1-nGT+1, LEN(cKey)-nGT+1) ) ) )
ELSEIF nPlus != 0 .AND. nPlus < nGC
     cKey := UPPER( ALLTRIM( SUBSTR( cKey, 1, IF( nEnd>0, nEnd, LEN(cKey)) ) ) )
ELSE
     cKey := UPPER( ALLTRIM( SUBSTR( cKey, nGC+1, IF( nEnd>0, nEnd-1-nGC+1, LEN(cKey)-nGC+1) ) ) )
ENDIF
nField := ASCAN( aStruct, {|elem| cKey == elem[DBS_NAME] } )

AADD( aRetVal, aStruct[nField][DBS_NAME] )
AADD( aRetVal, aStruct[nField][DBS_TYPE] )
AADD( aRetVal, aStruct[nField][DBS_LEN]  )
AADD( aRetVal, aStruct[nField][DBS_DEC]  )

IF aStruct[nField][DBS_TYPE] == "C"
   AADD( aRetVal, SPACE( aStruct[nField][DBS_LEN] ) )
ELSEIF aStruct[nField][DBS_TYPE] == "N"
   IF aStruct[nField][DBS_DEC] > 0
      AADD( aRetVal, ;
        VAL( REPLICATE("0",aStruct[nField][DBS_LEN]-(aStruct[nField][DBS_DEC]+1))+;
              "." + REPLICATE("0",aStruct[nField][DBS_DEC]) ) )
   ELSE
      AADD( aRetVal, 0  )
   ENDIF
ELSEIF aStruct[nField][DBS_TYPE] == "D"
      AADD( aRetVal, CTOD("  /  /  ") )
ENDIF

RETURN aRetVal
/***********************************************************************/
FUNCTION Get2VarInfo( cDbf )

LOCAL aStruct := (cDbf)->( DBSTRUCT() )
LOCAL cFieldName
LOCAL cKey   := (cDbf)->( ORDKEY() )
LOCAL nPlus  := AT( "+", cKey )
LOCAL nPlus2 := GetChar(cKey,"+",nPlus+1)
LOCAL nComma := GetChar(cKey,",",nPlus+1)
LOCAL nGT    := GetChar(cKey,">",nPlus+1)
LOCAL nParen := GetChar(cKey,")",nPlus+1)
LOCAL nEnd
LOCAL nField
LOCAL aRetVal := {}

nEnd := IF( nPlus2 > nComma .AND. nComma > 0, nComma, IF(nPlus2 == 0, nComma, nPlus2) )
IF( (nEnd > nParen .OR. nEnd == 0) .AND. nParen > 0, nEnd := nParen, NIL )
IF( nEnd == 0, nEnd := LEN(cKey), nEnd -= 1 )

cKey := UPPER( ALLTRIM( SUBSTR( cKey, nGT+1, IF( nEnd>0, nEnd-1-nGT+1, LEN(cKey)-nGT+1) ) ) )
nField := ASCAN( aStruct, {|elem| cKey == elem[DBS_NAME] } )

AADD( aRetVal, aStruct[nField][DBS_NAME] )
AADD( aRetVal, aStruct[nField][DBS_TYPE] )
AADD( aRetVal, aStruct[nField][DBS_LEN]  )
AADD( aRetVal, aStruct[nField][DBS_DEC]  )

IF aStruct[nField][DBS_TYPE] == "C"
   AADD( aRetVal, SPACE( aStruct[nField][DBS_LEN] ) )
ELSEIF aStruct[nField][DBS_TYPE] == "N"
   IF aStruct[nField][DBS_DEC] > 0
      AADD( aRetVal, ;
        VAL( REPLICATE("0",aStruct[nField][DBS_LEN]-(aStruct[nField][DBS_DEC]+1))+;
              "." + REPLICATE("0",aStruct[nField][DBS_DEC]) ) )
   ELSE
      AADD( aRetVal, 0  )
   ENDIF
ELSEIF aStruct[nField][DBS_TYPE] == "D"
      AADD( aRetVal, CTOD("  /  /  ") )
ENDIF

RETURN aRetVal
/***********************************************************************/
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: GetChar                                             ³
 * ³  Description:                                                     ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: cStr,cChar,nStart       Return Value:nRet           ³
 * ³     See Also:                                                     ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
STATIC FUNCTION GetChar( cStr, cChar, nStart )

LOCAL i
LOCAL nLen := LEN( cStr )
LOCAL nRet := 0

FOR i := nStart TO nLen
    IF SUBSTR( cStr, i, 1 ) == cChar
       nRet := i
       EXIT
    ENDIF
NEXT

RETURN nRet
/***********************************************************************/
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: MultiSeek                                           ³
 * ³  Description:                                                     ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: cSeekIn,cSeekFrom       Return Value:lFound         ³
 * ³     See Also:                                                     ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION MultiSeek( cSeekIn, cSeekFrom )

LOCAL cKey      := (cSeekIn)->( INDEXKEY() )
LOCAL lContinue := TRUE
LOCAL lFound    := TRUE
LOCAL nEnd

// all of the indexkey fields are aliased
cKey := STRTRAN( cKey, cSeekIn, cSeekFrom )

WHILE lContinue
      IF (cSeekIn)->( DBSEEK( &(cKey) ) )
         lContinue := FALSE
      ELSEIF ( nEnd := RAT( "+", cKey ) ) == 0
         lFound    := FALSE
         lContinue := FALSE
      ELSE
         cKey := LEFT( cKey, nEnd - 1 )
      ENDIF
END

RETURN lFound
/***********************************************************************/
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: TopDownSeek                                         ³
 * ³  Description:                                                     ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: cSeekIn,cSeekFrom,cFilter                           ³
 * ³     See Also:                       Return Value:lFound,cFilter   ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION TopDownSeek( cSeekIn, cSeekFrom ,cFilter)

LOCAL aStruct   := (cSeekFrom)->( DBSTRUCT() )
LOCAL cField
LOCAL cKey      := (cSeekIn)->( ORDKEY() )
LOCAL lContinue := TRUE
LOCAL lFound    := FALSE //YG
LOCAL nEnd
LOCAL nPad      := VAL( SUBSTR( cKey, RAT( ",", cKey) + 1, RAT( ')', cKey ) - 1 ) )
LOCAL nRat
// all of the indexkey fields are aliased
cKey := STRTRAN( cKey, UPPER(cSeekIn), cSeekFrom )

WHILE lContinue
      IF empty(cFilter)
          lFound := FALSE
          exit
      ENDIF
      IF (cSeekIn)->( DBSEEK( cFilter ) )
         lContinue := FALSE
         lFound    := TRUE
      else
         cFilter := substr(cFilter,1,len(cFilter)-1)
      endif
END
RETURN { lFound, cFiLTER }
/* YG 27.8.98
      IF (cSeekIn)->( DBSEEK( &(cKey) ) )
         lContinue := FALSE
      ELSEIF ( nEnd := RAT( "+", cKey ) ) == 0
         lFound    := FALSE
         lContinue := FALSE
      ELSE
         // This special handling is required because there is an embedded
         // LTRIM(STR(...)) in the indexkey
         nRat   := RAT(',', cKey)
         nRat   := IF( SUBSTR( cKey, nRat - 1, 1 ) == ")", nRat - 3,  nRat - 1 )
         cField := SUBSTR( cKey, RAT( ">", cKey )+1, nRat-RAT( ">", cKey ) )

         // because of 1 field with a STR() call )-:
         WHILE RIGHT( cField, 1 ) $ "1234567890,"
               cField := LEFT( cField, LEN( cField ) - 1 )
         END

         // We have to reduce the padding by the length of the removed field
         nRat   := ASCAN( aStruct, {|e| e[1] == cField })
         nPad   -= aStruct[nRat][DBS_LEN]
         cKey   := LEFT( cKey, nEnd - 1 ) + ","+ALLTRIM(STR(nPad))+")"
      ENDIF
END
RETURN { lFound, &(cKey) }
*/
/******************************************/
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: TestSeeks                                           ³
 * ³  Description:                                                     ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: None                  Return Value:NIL              ³
 * ³     See Also:                                                     ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION TestSeeks // temporary test function

LOCAL aFound

USE d_esn   index i_esnp   SHARED NEW
USE d_line  index ilnesnp  SHARED NEW
USE d_stock index istkespr SHARED NEW

aFound := TopDownSeek( "d_esn"  , "d_line" )
aFound := TopDownSeek( "d_line" , "d_esn"  )
aFound := TopDownSeek( "d_line" , "d_stock")
aFound := TopDownSeek( "d_stock", "d_line" )

CLOSE d_esn
CLOSE d_line
CLOSE d_stock

RETURN NIL
/*****************************************************************/
FUNCTION LEAVE
RETURN ALERT("You pressed the Esc key.;Do you want to:",;
            {"Exit without saving","Continue editing"}, ALERT_STD )  // ALERT_STD

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: EotM()                Docs: Shalom LeVine                  ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 01-05-98              Date updated: ş01-05-98              ³
 * ³ Time created: 01:30:41pm            Time updated: ş01:30:41pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: dDate                                                      ³
 * ³ Return Value: FotM( FotM(dDate) + 32 ) - 1                               ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION EotM( dDate )
RETURN FotM( FotM(dDate) + 32 ) - 1

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: FotM()                Docs: Shalom LeVine                  ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 01-05-98              Date updated: ş01-05-98              ³
 * ³ Time created: 01:30:44pm            Time updated: ş01:30:44pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: dDate                                                      ³
 * ³ Return Value: None                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION FotM( dDate )
RETURN dDate - ( DAY(dDate) - 1 )

function PlayItBaby(cSong)    //guess who?
     default cSong to "charge"
     IF cSong == "charge"
          tone(196,3)
          tone(261.7,3)
          tone(329.6,3)
          tone(392,6)
          tone(329.6,3)
          tone(392,6)
     elseif cSong == "french"
          tone(196,6)
          tone(196,2)
          tone(261.7,8)
          tone(261.7,8)
          tone(294,8)
          tone(294,8)
          tone(392,12)
          tone(329.6,4)
          tone(262,6)
     ENDIF
return nil
/************************** EOF AVXFUNCS.PRG **************************/
/*

select 1
use a

select 2
use b

select a
DO WHILE !EOF()
      SELECT B
      SEEK A->SOMETHING
      REPLACE B->S WITH A->S
      SELECT A
      SKIP 1
ENDDO

USE A NEW
USE B NEW
WHILE ! A->( eof())
       B->( DBSEEK(A->CCC))
       B->X := A->X
       A->( dbskip() )
end

      ENDIF
*/

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: SH_OpenFiles()        Docs: Shalom LeVine                  ³
 * ³  Description: I needed this function, because, although TabBase's        ³
 * ³               Xopen() method accepts a path for the DBF, GenOpenfiles()  ³
 * ³               doesn't! this does.                                        ³
 * ³   IMPORTANT!: The structure of the array sent to this function is        ³
 * ³               different that that sent to GenOpenFiles. This accepts     ³
 * ³               embedded arrays, each containing the dbf name and either   ³
 * ³               NIL as the 2nd element or a path:                          ³
 * ³               { { cDbf, NilOrcPath }, { cDbf, NilOrcPath } }              ³
 * ³       Author: Shalom LeVine                                              ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 08/03/98              Date updated: ş08/03/98              ³
 * ³ Time created: 17:19:32              Time updated: ş17:19:32              ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: aFileList                                                  ³
 * ³ Return Value: aoOpenedList                                               ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION SH_OpenFiles( aFileList )

LOCAL i , nLen := Len( aFileList )
LOCAL oTab

aoOpenedList := {}

FOR i := 1 TO nLen
    IF EMPTY( SELECT( aFileList[i][1] ) )
       oTab := TableTranslate():new( aFileList[i][1] )
       oTab:setIndexList()
       IF oTab:xopen(aFileList[i][2])
          Aadd( aoOpenedList , oTab )
       ELSE
          Aadd( aoOpenedList , NIL )
       ENDIF
    ENDIF
NEXT

RETURN aoOpenedList
/////////////////////////////////
Function MyRun(cCommand)
// Running extrnal programs
Local success
LOCAL cScr := SaveScreen()

    success := SWPRUNCMD(cCommand,0,"","")
RESTSCREEN(,,,,cScr)
Return .t.
/////////////////////////////////
FUNCTION DrawBox(t,l,b,r)

LOCAL i

FOR i := t TO b
     @ i, l SAY "Û"
     @ i, r SAY "Û"
NEXT

@ t, l+1 SAY REPLICATE( "ß", r-l-1)
@ b, l+1 SAY REPLICATE( "Ü", r-l-1)

RETURN NIL
///////////////////////////////
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: MrkOrdDue                                           ³
 * ³  Description:                                                     ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: lUseAlias,cDbf        Return Value:dRetVal          ³
 * ³     See Also:                                                     ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION MrkOrdDue(lUseAlias,cDbf)  //YG revdue
*
*  removing poln_stat $ "Q_T" check since now d_mrkdlv only contains approved
*  mrk due date. d_mkrqdlv will contain requested mrk due date
*
LOCAL dRetVal := CTOD("  /  /  ")
FIELD d_mrkdlv, d_ackndlv

DEFAULT lUseAlias to .F.
DEFAULT cDbf to ""

IF Select(cDbf)==0 .AND. lUseAlias
	Return date()
ENDIF

IF lUseAlias
   IF !empty((cDbf)->d_mrkdlv)
        dRetval := (cDbf)->d_mrkdlv
   ELSE
        dRetval := (cDbf)->d_ackndlv
   ENDIF
ELSE
   IF !EMPTY(D_mrkdlv)
        dRetval := D_mrkdlv
   ELSE
        dRetval := D_ackndlv
   ENDIF
ENDIF

RETURN dRetVal

************************
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: ligthEmUp                                           ³
 * ³  Description:                                                     ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: cBid,cEsn       Return Value:cRetVal                ³
 * ³     See Also:                                                     ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
function lightEmUp(cBid,cEsn)
local nOldArea := Select()
local cRetval := " "
local nOrder,nRecNo
local lCloseItAfterwards := .F.
local l2CloseItAfterwards := .F.
local n2Order,n2RecNo
local lGot1 := .F.

IF select("d_line") == 0
     genopenfiles({"d_line"})
     lCloseItAfterwards := .T.
ENDIF
IF !lCloseItAfterwards
     nOrder := d_line->(indexord())
     nRecNo := d_line->(recNo())
ENDIF
IF select("h_finqc") == 0
     genopenfiles({"h_finqc"})
     l2CloseItAfterwards := .T.
ENDIF
IF !l2CloseItAfterwards
     n2Order := h_finqc->(indexord())
     n2RecNo := h_finqc->(recNo())
ENDIF

d_line->(ordsetfocus("ib_idln"))
if d_line->( dbseek(cBid) )
     IF !empty(d_line->b_remark)
          lGot1 := .T.
     ENDIF
endif

IF select("d_frzstk") == 0     //vitaly for sched 05/11/2000
     genopenfiles({"d_frzstk"})
ENDIF

d_frzstk->(ordsetfocus(1))
if d_frzstk->( dbseek(cBid + cEsn) )
     IF !empty(d_frzstk->frz_remark)
          lGot1 := .T.
     ENDIF
endif
d_frzstk->(dbclosearea())      ////////end

IF lCloseItAfterwards
     d_line->(dbclosearea())
else
     d_line->(dbSetOrder(nOrder))
     d_line->(dbgoto(nRecNo))
ENDIF
h_finqc->(ordsetfocus("hfqcbesn"))
if h_finqc->( dbseek(cBid+cEsn) )
     IF !empty(h_finqc->qc_com)
          lGot1 := .T.
     ENDIF
endif
IF l2CloseItAfterwards
     h_finqc->(dbclosearea())
else
     h_finqc->(dbSetOrder(n2Order))
     h_finqc->(dbgoto(n2RecNo))
ENDIF
IF lGot1
     cRetVal := "*"
ENDIF
dbselectarea(nOldArea)
return cRetVal

************************
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: ShowDLineCom                                        ³
 * ³  Description:                                                     ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: cBid,CeSN       Return Value:NIL                    ³
 * ³     See Also:                                                     ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
function ShowDLineCom(cBid,CeSN,lFromPrint)
local nOrder,nRecNo
local lCloseItAfterwards := .F.
local l2CloseItAfterwards := .F.
local n2Order,n2RecNo
local cMessage := " "

default lFromPrint to FALSE

IF select("d_line") == 0
     genopenfiles({"d_line"})
     lCloseItAfterwards := .T.
ENDIF
IF !lCloseItAfterwards
     nOrder := d_line->(indexord())
     nRecNo := d_line->(recNo())
ENDIF
IF select("h_finqc") == 0
     genopenfiles({"h_finqc"})
     l2CloseItAfterwards := .T.
ENDIF
IF !l2CloseItAfterwards
     n2Order := h_finqc->(indexord())
     n2RecNo := h_finqc->(recNo())
ENDIF
d_line->(ordsetfocus("ib_idln"))
if d_line->( dbseek(cBid) )
     IF !empty(d_line->b_remark)
          cMessage := d_line->b_remark + ";"
     else
     ENDIF
endif
IF lCloseItAfterwards
     d_line->(dbclosearea())
else
     d_line->(dbSetOrder(nOrder))
     d_line->(dbgoto(nRecNo))
ENDIF
h_finqc->(ordsetfocus("hfqcbesn"))
//vr for tapi_366
if h_finqc->( dbseek(cBid+cEsn) )
     IF !empty(h_finqc->qc_com)
          cMessage += h_finqc->qc_com
     ENDIF
endif
/*if h_finqc->( dbseek(cBid) )
	while h_finqc->b_id == cBid .AND. !h_finqc->( EOF() )
     IF !empty(h_finqc->qc_com)
          cMessage += h_finqc->qc_com
     ENDIF
	  h_finqc->( dbskip(1) )
  end
endif*/
//
IF l2CloseItAfterwards
     h_finqc->(dbclosearea())
else
     h_finqc->(dbSetOrder(n2Order))
     h_finqc->(dbgoto(n2RecNo))
ENDIF

IF select("d_frzstk") == 0     //vitaly for sched 05/11/2000
     genopenfiles({"d_frzstk"})
ENDIF

d_frzstk->(ordsetfocus(1))
if d_frzstk->( dbseek(cBid + cEsn) )
     IF !empty(d_frzstk->frz_remark)
                cMessage := cMessage + d_frzstk->frz_remark + ";"
     ENDIF
endif
d_frzstk->(dbclosearea())      ////////end

IIF(!lFromPrint ,alert(cMessage) ,nil )

return IIF(lFromPrint ,cMessage ,nil)
*******************************************************************
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: swapDemDates                                        ³
 * ³  Description:                                                     ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: cDbf                  Return Value:NIL              ³
 * ³     See Also:                                                     ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
function swapDemDates(cDbf)
LOCAL cTempDir := GetUserInfo():cTempDir
local lCloseItAfterwards := .F.
local nOrder, nRecNo

IF select(cDbf) == 0
     NetUse( cDbf, STD_RETRY, , USE_EXCLUSIVE, USE_NEW, cTempDir )
     lCloseItAfterwards := .T.
ENDIF
IF !lCloseItAfterwards
     nOrder := (cDbf)->(indexord())
     nRecNo := (cDbf)->(recNo())
ENDIF
(cDbf)->(flock())
replace (cDbf)->d_ackndlv with MrkordDue(.T.,cDbf) all
(cDbf)->(dbunlock())

IF lCloseItAfterwards
     (cDbf)->(dbclosearea())
else
     (cDbf)->(dbSetOrder(nOrder))
     (cDbf)->(dbgoto(nRecNo))
endif

return NIL
****************************************************************
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: MonthName                                           ³
 * ³  Description:                                                     ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: cMonth,cFormat       Return Value:cRetVal           ³
 * ³     See Also:                                                     ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
function MonthName(cMonth,cFormat)
local cRetVal := ""
default cFormat to "short"

IF cMonth == "01"
     IF cFormat == "short"
          cRetVal :=  "Jan"
     else
          cRetVal := "January"
     ENDIF
elseif cMonth == "02"
     IF cFormat == "short"
          cRetVal := "Feb"
     else
          cRetVal := "February"
     ENDIF
elseif cMonth == "03"
     IF cFormat == "short"
          cRetVal := "Mar"
     else
          cRetVal := "March"
     ENDIF
elseif cMonth == "04"
     IF cFormat == "short"
          cRetVal := "Apr"
     else
          cRetVal := "April"
     ENDIF
elseif cMonth == "05"
     IF cFormat == "short"
          cRetVal := "May"
     else
          cRetVal := "May"
     ENDIF
elseif cMonth == "06"
     IF cFormat == "short"
          cRetVal := "Jun"
     else
          cRetVal := "June"
     ENDIF
elseif cMonth == "07"
     IF cFormat == "short"
          cRetVal := "Jul"
     else
          cRetVal := "July"
     ENDIF
elseif cMonth == "08"
     IF cFormat == "short"
          cRetVal := "Aug"
     else
          cRetVal := "August"
     ENDIF
elseif cMonth == "09"
     IF cFormat == "short"
          cRetVal := "Sep"
     else
          cRetVal := "September"
     ENDIF
elseif cMonth == "10"
     IF cFormat == "short"
          cRetVal := "Oct"
     else
          cRetVal := "October"
     ENDIF
elseif cMonth == "11"
     IF cFormat == "short"
          cRetVal := "Nov"
     else
          cRetVal := "November"
     ENDIF
elseif cMonth == "12"
     IF cFormat == "short"
          cRetVal := "Dec"
     else
          cRetVal := "December"
     ENDIF
ENDIF
return cRetVal
********************************************************
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: dstockfix                                           ³
 * ³  Description:                                                     ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: None                  Return Value:NIL              ³
 * ³     See Also:                                                     ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
function dstockfix
local cBid, cdiel_id, cb_ncaps
local lFixit

genopenfiles({"d_stock"})
d_stock->(ordsetfocus("bnesn_st"))
d_stock->(dbgotop())
while !d_stock->(eof())
     @2,2 say d_stock->b_id
     while d_stock->ptype_id <> "C" .AND. !d_stock->(eof())
          @2,30 say "skipping: " + d_stock->b_id
          d_stock->(dbskip())
     end
     IF d_stock->(eof())
          return NIL
     ENDIF
     cBid     := d_stock->b_id
     cDiel_id := d_stock->diel_id
     cb_ncaps := d_stock->b_ncaps
     lFixIt := .T.
     while d_stock->b_id == cBid
          IF !empty(d_stock->diel_id) .AND. !empty(cDiel_id)
               if d_stock->diel_id <> cDiel_id
                    lFixIt := .F.
                    EXIT
               end
          ENDIF
          IF !empty(d_stock->b_ncaps) .AND. !empty(cb_ncaps)
               if d_stock->b_ncaps <> cb_ncaps
                    lFixIt := .F.
                    EXIT
               end
          ENDIF
          IF !empty(d_stock->diel_id) .AND. empty(cDiel_id)
               cDiel_id := d_stock->diel_id
          ENDIF
          IF !empty(d_stock->b_ncaps) .AND. empty(cb_ncaps)
               cb_ncaps := d_stock->b_ncaps
          ENDIF
          d_stock->(dbskip())
     end
     IF lFixIt
          d_stock->(dbseek(cBid))
          while d_stock->b_id == cBid
               if d_stock->diel_id <> cDiel_id
                    d_stock->(rlock())
                    d_stock->diel_id := cDiel_id
                    d_stock->(dbunlock())
               end
               if d_stock->b_ncaps <> cb_ncaps
                    d_stock->(rlock())
                    d_stock->b_ncaps := cb_ncaps
                    d_stock->(dbunlock())
               end
               d_stock->(dbskip())
          end
     ENDIF
end
D_STOCK->(DBCLOSEAREA())
return NIL
*************************************************************
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: updateCalender                                      ³
 * ³  Description:                                                     ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: None                  Return Value:NIL              ³
 * ³     See Also:                                                     ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
function updateCalender
local dLast
local dUntil := ctod("  /  /  ")
genopenfiles({"d_calndr"})
d_calndr->(dbgobottom())
dLast := d_calndr->cal_date
@3,2 say "Update d_calndr until:"
@4,2 get dUntil
XREAD
IF dLast >= dUntil
     return NIL
ENDIF
d_calndr->(flock())
while dLast <= dUntil
     @5,2 say dLast
     d_calndr->(dbappend())
     d_calndr->cal_date := dLast + 1
     dLast++
     IF month(dLast) <= 12 .AND. month(dLast) >= 4
          d_calndr->fy := str(year(dLast)+1,4)
          d_calndr->fm := str(month(dLast)-3,2)
     else
          d_calndr->fy := str(year(dLast),4)
          d_calndr->fm := str(month(dLast)+9,2)
     ENDIF
     IF dow(dLast) == 7  //Shabbes Kodesh
          d_calndr->day_type := "H"
          d_calndr->DAY_pcnt := 0.00
     else
          d_calndr->day_type := "W"
          d_calndr->DAY_pcnt := 1.00
     ENDIF
end
d_calndr->(dbunlock())
d_calndr->(dbclosearea())

//   1    CAL_DATE    D    008     000
//   2    FY          C    004     000
//   3    FM          C    002     000
//   4    DAY_TYPE    C    001     000
//   5    DAY_PCNT    N    004     002
//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
return NIL

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: addEsnY()             Docs: Yaacov Greenstein              ³
 * ³  Description: another inovativate maintainace program                    ³
 * ³       Author: Yaacov Greenstein                                          ³
 * ³ Date created: 26/05/99              Date updated: ş26/05/99              ³
 * ³ Time created: 08:15:14              Time updated: ş08:15:14              ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: NIL                                                        ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
function addEsnY()
local cPType := " ", cPLine := "   ", cSize := "    ", cEsnyOld := " ",;
      cEsnyNew := " " , cBtype := " "
local aFieldContent,i, nRecNo, oForm, cSucker
local cWhich := "", n
LOCAL   cEsn_id   ,;                   // Declare memvars for D_esn...
     cEsnxx_id ,;
     cEsny_id  ,;
     cAvxilpn  ,;
     cAltpn1   ,;
     cAltpn2   ,;
     cPtype_id ,;
     cPline_id ,;
     cSize_id  ,;
     nValue_id ,;
     cTerm_id  ,;
     cTol_id   ,;
     cTc_id    ,;
     cVolt_id  ,;
     cEsn_p1   ,;
     cEsn_p2   ,;
     cEsn_p3   ,;
     dDlu_stdy ,;
     nStd_yldp ,;
     nStdc_dlab,;
     nStdc_ovhd,;
     nStdc_matl,;
     nStdc_depr,;
     nStdc_upkp,;
     nStdc_fctr,;
     nStdc_unit,;
     dDlu_stdc ,;
     cWip_clstr,;
     dDlu_wipcl,;
     nTp1      ,;
     cTp1_curr ,;
     dDlu_tp1  ,;
     nTp2      ,;
     cTp2_curr ,;
     dDlu_tp2  ,;
     nTp3      ,;
     cTp3_curr ,;
     dDlu_tp3  ,;
     nTp4      ,;
     cTp4_curr ,;
     dDlu_tp4  ,;
     nTp5      ,;
     cTp5_curr ,;
     dDlu_tp5  ,;
     nTp6      ,;
     cTp6_curr ,;
     dDlu_tp6  ,;
     nTp7      ,;
     cTp7_curr ,;
     dDlu_tp7  ,;
     cInv_ctrl ,;
     nMaxstock ,;
     dDlu_maxst,;
     nMinstock ,;
     dDlu_minst,;
     cMrk_stat ,;
     dDlu_mrkst,;
     cMrk_rem  ,;
     cEng_stat ,;
     dDlu_engst,;
     cEng_rem  ,;
     cEsn_rem  ,;
     cShipl_id ,;
     dDadd_rec ,;
     dDlu_rec  ,;
     cTlu_rec  ,;
     cUlu_rec  ,;
     cWlu_rec  ,;
     cPlu_rec  ,;
     nLockkey
n := alert("Hi",{"y","xx"})
IF n == 1
     cWhich := "y"
     oForm := Form():new(,,,, "Add a new EsnY, ya bugger",, ProcName() )
elseif n == 2
     cWhich := "xx"
     cEsnyOld := "  "
     cEsnyNew := "  "
     oForm := Form():new(,,,, "Add a new EsnXX, ya bugger",, ProcName() )
ENDIF
genopenfiles({"d_esn","C_BTYPE"})
d_esn->(ordsetfocus("i_esnp"))
C_BTYPE->(ordsetfocus("ibtype"))
aFieldContent := d_esn->(array(fcount()))
//d_esn->(aFields(aFieldNames))
IF cWhich == "y"
     @3,10 say "Let's add a new Esn Y!"
     @5,10 SAY "Prod Type:" get cPType picture "!"
     @6,10 SAY "Prod Line:" get cPLine picture "!!!"
     @7,10 SAY "     Size:" get cSize  picture "!!!!"
     @8,10 SAY " ESNY Old:" get cEsnyOld picture "!"
     @9,10 SAY " ESNY New:" get cEsnyNew picture "!"
else
@3,10 say "Let's add a new Esn XX!"
     @4,10 say "Batch Type:" get cbtype  picture "!"
     @5,10 SAY "Prod Type:" get cPType   picture "!"
     @6,10 SAY "Prod Line:" get cPLine   picture "!!!"
     @7,10 SAY "     Size:" get cSize    picture "!!!!"
     @8,10 SAY " ESNXX Old:" get cEsnyOld picture "!!"
     @9,10 SAY " ESNXX New:" get cEsnyNew picture "!!"
endif
XREADALL
i := alert("Are you sure you want to go through with this?;It isn't too late.",;
     {"Yep","Let's back out of this"})
IF i == 2
     return NIL
ENDIF
IF cWhich == "xx"
     if !c_btype->(dbseek(cbtype+cEsnynew+cPLine))
          alert("AAAAAAAAARRRRGGGGGGGGGGGHHHHHHHHHH")
          return NIL
     end
ENDIF
d_esn->(dbseek(cPType+cPLine+cSize))
IF cWhich == "y"
     cSucker := "esny_id" //d_esn->esny_id
else
     cSucker := "esnxx_id" //d_esn->esnxx_id
endif
while d_esn->PType_id+d_esn->PLine_id+d_esn->Size_id == cPType+cPLine+cSize
     IF if(cWhich == "y",d_esn->esny_id == cEsnyOld,d_esn->esnxx_id == cEsnyOld)
          nRecNo := d_esn->(recNo())
          IF cWhich == "y"
               cEsn_id := left(d_esn->esn_id,len(TRIM(d_esn->esn_id))-1)+cEsnyNew
          else
               cEsn_id := left(d_esn->esn_id,len(TRIM(d_esn->esn_id))-3)+cEsnyNew+right(trim(d_esn->esn_id),1)
          ENDIF
          d_esn->(ordsetfocus("iesn_id"))
          IF d_esn->(dbseek(cEsn_id)) //already exists!
               @11,10 SAY d_esn->esn_id
               @12,10 SAY cEsn_id+" Already exits!"
               d_esn->(ordsetfocus("i_esnp"))
               d_esn->(dbgoto(nRecNo))
               d_esn->(dbskip())
               loop
          else
               @12,10 SAY cEsn_id +"                 "
          ENDIF
          d_esn->(ordsetfocus("i_esnp"))
          d_esn->(dbgoto(nRecNo))
          //cEsn_id    := D_esn->Esn_id
          cEsnxx_id  := D_esn->Esnxx_id
          cEsny_id   := D_esn->Esny_id
          cAvxilpn   := D_esn->Avxilpn
          cAltpn1    := D_esn->Altpn1
          cAltpn2    := D_esn->Altpn2
          cPtype_id  := D_esn->Ptype_id
          cPline_id  := D_esn->Pline_id
          cSize_id   := D_esn->Size_id
          nValue_id  := D_esn->Value_id
          cTerm_id   := D_esn->Term_id
          cTol_id    := D_esn->Tol_id
          cTc_id     := D_esn->Tc_id
          cVolt_id   := D_esn->Volt_id
          cEsn_p1    := D_esn->Esn_p1
          cEsn_p2    := D_esn->Esn_p2
          cEsn_p3    := D_esn->Esn_p3
          dDlu_stdy  := D_esn->Dlu_stdy
          nStd_yldp  := D_esn->Std_yldp
          nStdc_dlab := D_esn->Stdc_dlab
          nStdc_ovhd := D_esn->Stdc_ovhd
          nStdc_matl := D_esn->Stdc_matl
          nStdc_depr := D_esn->Stdc_depr
          nStdc_upkp := D_esn->Stdc_upkp
          nStdc_fctr := D_esn->Stdc_fctr
          nStdc_unit := D_esn->Stdc_unit
          dDlu_stdc  := D_esn->Dlu_stdc
          cWip_clstr := D_esn->Wip_clstr
          dDlu_wipcl := D_esn->Dlu_wipcl
          nTp1       := D_esn->Tp1
          cTp1_curr  := D_esn->Tp1_curr
          dDlu_tp1   := D_esn->Dlu_tp1
          nTp2       := D_esn->Tp2
          cTp2_curr  := D_esn->Tp2_curr
          dDlu_tp2   := D_esn->Dlu_tp2
          nTp3       := D_esn->Tp3
          cTp3_curr  := D_esn->Tp3_curr
          dDlu_tp3   := D_esn->Dlu_tp3
          nTp4       := D_esn->Tp4
          cTp4_curr  := D_esn->Tp4_curr
          dDlu_tp4   := D_esn->Dlu_tp4
          nTp5       := D_esn->Tp5
          cTp5_curr  := D_esn->Tp5_curr
          dDlu_tp5   := D_esn->Dlu_tp5
          nTp6       := D_esn->Tp6
          cTp6_curr  := D_esn->Tp6_curr
          dDlu_tp6   := D_esn->Dlu_tp6
          nTp7       := D_esn->Tp7
          cTp7_curr  := D_esn->Tp7_curr
          dDlu_tp7   := D_esn->Dlu_tp7
          cInv_ctrl  := D_esn->Inv_ctrl
          nMaxstock  := D_esn->Maxstock
          dDlu_maxst := D_esn->Dlu_maxstk
          nMinstock  := D_esn->Minstock
          dDlu_minst := D_esn->Dlu_minstk
          cMrk_stat  := D_esn->Mrk_stat
          dDlu_mrkst := D_esn->Dlu_mrkst
          cMrk_rem   := D_esn->Mrk_rem
          cEng_stat  := D_esn->Eng_stat
          dDlu_engst := D_esn->Dlu_engst
          cEng_rem   := D_esn->Eng_rem
          cEsn_rem   := D_esn->Esn_rem
          cShipl_id  := D_esn->Shipl_id
          dDadd_rec  := D_esn->Dadd_rec
          dDlu_rec   := D_esn->Dlu_rec
          cTlu_rec   := D_esn->Tlu_rec
          cUlu_rec   := D_esn->Ulu_rec
          cWlu_rec   := D_esn->Wlu_rec
          cPlu_rec   := D_esn->Plu_rec
          nLockkey   := D_esn->Lockkey
          //FOR i := 1 TO len(aFieldContent)
          //     aFieldContent[i] := d_esn->(fieldget(i))
          //NEXT
          @11,10 SAY d_esn->esn_id
          @12,10 SAY cEsn_id
          if d_esn->(addrec(2,"ADDESNY"))
               d_esn->(reclock(2,"ADDESNY"))
               //D_esn->Esn_id    := cEsn_id
               //D_esn->Esnxx_id  := cEsnxx_id
               //D_esn->Esny_id   := cEsny_id
               IF cWhich == "y"
                    D_esn->Esnxx_id  := cEsnxx_id
                    //D_esn->Esny_id   := cEsny_id
               else
                    //D_esn->Esnxx_id  := cEsnxx_id
                    D_esn->Esny_id   := cEsny_id
               endif
               D_esn->Avxilpn   := cAvxilpn
               D_esn->Altpn1    := cAltpn1
               D_esn->Altpn2    := cAltpn2
               D_esn->Ptype_id  := cPtype_id
               D_esn->Pline_id  := cPline_id
               D_esn->Size_id   := cSize_id
               D_esn->Value_id  := nValue_id
               D_esn->Term_id   := cTerm_id
               D_esn->Tol_id    := cTol_id
               D_esn->Tc_id     := cTc_id
               D_esn->Volt_id   := cVolt_id
               D_esn->Esn_p1    := cEsn_p1
               D_esn->Esn_p2    := cEsn_p2
               D_esn->Esn_p3    := cEsn_p3
               D_esn->Dlu_stdy  := dDlu_stdy
               D_esn->Std_yldp  := nStd_yldp
               D_esn->Stdc_dlab := nStdc_dlab
               D_esn->Stdc_ovhd := nStdc_ovhd
               D_esn->Stdc_matl := nStdc_matl
               D_esn->Stdc_depr := nStdc_depr
               D_esn->Stdc_upkp := nStdc_upkp
               D_esn->Stdc_fctr := nStdc_fctr
               D_esn->Stdc_unit := nStdc_unit
               D_esn->Dlu_stdc  := dDlu_stdc
               D_esn->Wip_clstr := cWip_clstr
               D_esn->Dlu_wipcl := dDlu_wipcl
               D_esn->Tp1       := nTp1
               D_esn->Tp1_curr  := cTp1_curr
               D_esn->Dlu_tp1   := dDlu_tp1
               D_esn->Tp2       := nTp2
               D_esn->Tp2_curr  := cTp2_curr
               D_esn->Dlu_tp2   := dDlu_tp2
               D_esn->Tp3       := nTp3
               D_esn->Tp3_curr  := cTp3_curr
               D_esn->Dlu_tp3   := dDlu_tp3
               D_esn->Tp4       := nTp4
               D_esn->Tp4_curr  := cTp4_curr
               D_esn->Dlu_tp4   := dDlu_tp4
               D_esn->Tp5       := nTp5
               D_esn->Tp5_curr  := cTp5_curr
               D_esn->Dlu_tp5   := dDlu_tp5
               D_esn->Tp6       := nTp6
               D_esn->Tp6_curr  := cTp6_curr
               D_esn->Dlu_tp6   := dDlu_tp6
               D_esn->Tp7       := nTp7
               D_esn->Tp7_curr  := cTp7_curr
               D_esn->Dlu_tp7   := dDlu_tp7
               D_esn->Inv_ctrl  := cInv_ctrl
               D_esn->Maxstock  := 0
               //D_esn->Dlu_maxstk := dDlu_maxst
               D_esn->Minstock  := 0
               //D_esn->Dlu_minstk := dDlu_minst
               D_esn->Mrk_stat  := cMrk_stat
               D_esn->Dlu_mrkst := dDlu_mrkst
               D_esn->Mrk_rem   := cMrk_rem
               D_esn->Eng_stat  := cEng_stat
               D_esn->Dlu_engst := dDlu_engst
               D_esn->Eng_rem   := cEng_rem
               D_esn->Esn_rem   := cEsn_rem
               D_esn->Shipl_id  := cShipl_id
               //D_esn->Dadd_rec  := dDadd_rec
               //D_esn->Dlu_rec   := dDlu_rec
               //D_esn->Tlu_rec   := cTlu_rec
               //D_esn->Ulu_rec   := cUlu_rec
               //D_esn->Wlu_rec   := cWlu_rec
               //D_esn->Plu_rec   := cPlu_rec
               //D_esn->Lockkey   := nLockkey

               //FOR i := 1 TO len(aFieldContent)
               //     d_esn->(fieldput(i,aFieldContent[i]))
               //NEXT
          endif
          IF cWhich == "y"
               d_esn->esny_ID := cEsnyNew
          else
               d_esn->esnXX_ID := cEsnyNew
          ENDIF
          d_esn->esn_id := cEsn_id
          d_esn->(dbunlock())
          d_esn->(dbgoto(nRecNo))
     ENDIF
     d_esn->(dbskip())
end
d_esn->(dbclosearea())
IF cWhich == "xx"
     c_btype->(dbclosearea())
ENDIF
oForm:hide()
return NIL
******************************************************
function getSValName(cSmType)
c_svalmv->(dbseek(cSmType))
return c_svalmv->description
*******************************************************
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: setRights                                           ³
 * ³  Description:                                                     ³
 * ³       Author:                       Designer:                     ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96       ³
 * ³ Time created: 02:21:11pm            Time updated: ş02:21:11pm     ³
 * ³    Copyright: AVX                                                 ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: None                  Return Value:cRetVal          ³
 * ³     See Also:                                                     ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
function setRights
LOCAL cRetVal

local cUserId := GetUserInfo():cUserId     //YG 20.5.98
genopenfiles({"engRight","d_user"})  //YG 20.5.98
engright->(ordsetfocus("engright"))
IF engRight->(dbseek(cUserId))  //YG 20.5.98
     cRetVal := trim(engRight->rights)  //YG 20.5.98
else  //YG 20.5.98  the users name is not in the excertion list
      //and will be assigned the default rights of his or her group
     d_user->(ordsetfocus("d_user"))
     d_user->(dbseek(cUserid))
     IF     d_user->group_id == "ENGINEERING"
          cRetval := "X"
     ELSEIF d_user->group_id == "R&D"
          cRetval := "R"
     ELSE
          cRetval := ""    //meaning access to all
     ENDIF
ENDIF  //YG 20.5.98
engRight->(dbclosearea())
d_user->(dbclosearea())
return cRetVal
////////////////////////////////////////////////////////////////////
/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: XSoftTrans()             Docs:                              ³
 * ³  Description: Transform to string without file name                      |
 * ³       Author: Tanya Veksler                                              ³
 * ³ Date created: 08/12/99              Date updated: ş                      ³
 * ³ Time created: 15:50:14              Time updated: ş                      ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: cString                                                    ³
 * ³ Return Value: cRetStr                                                    ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
*-----------------------------------------------------------------------------*
FUNCTION XSoftTrans(cString)
LOCAL cTempStr,cRetStr
LOCAL aParam[2]
IF ">" $ cString
        aParam := FParametr(cString)
        cTempStr := STUFF(cString,aParam[1],aParam[2],"")      //aParam[1] is Start position
        cRetStr := XSoftTrans(cTempStr)                        //aRaram[2] is number of char to delete
ELSE
        cRetStr := cString
ENDIF
return cRetStr

FUNCTION FParametr(cString)
local cTemp,nPlus,nParen,nPoint,nYra
local aRetVal[2]
local nEnd := AT(">",cString)
cTemp := STUFF(cString,nEnd+1,LEN(cString) - nEnd,"")
nPlus  := RAT("+",cTemp)
nParen := RAT("(",cTemp)
nPoint := RAT(".",cTemp)
nYra   := RAT("!",cTemp)

IF nParen!=0 .AND. nParen > nPlus .AND. nParen > nPoint .AND. nParen > nYra
        aRetVal[2] := nEnd - nParen
        aRetVal[1] := LEN(cTemp) - aRetVal[2] + 1
ELSEIF nPlus!=0 .AND. nPlus > nParen .AND. nPlus > nPoint .AND. nPlus > nYra
        aRetVal[2] := nEnd - nPlus
        aRetVal[1] := LEN(cTemp) - aRetVal[2] + 1
ELSEIF nPoint!=0 .AND. nPoint > nParen .AND. nPoint > nPlus .AND. nPoint > nYra
        aRetVal[2] := nEnd - nPoint
        aRetVal[1] := LEN(cTemp) - aRetVal[2] + 1
ELSEIF nYra!=0 .AND. nYra > nParen .AND. nYra > nPoint .AND. nYra > nPlus
        aRetVal[2] := nEnd - nYra
        aRetVal[1] := LEN(cTemp) - aRetVal[2] + 1
ELSEIF nParen == 0 .AND. nPlus == 0 .AND. nPoint == 0 .AND. nYra == 0
        aRetVal[2] := nEnd
        aRetVal[1] := 1
ENDIF
return aRetVal

/////////////////////////////////////////////////////////////////////////////
FUNCTION NtxProgress(nPos,nLastRec)
LOCAL cComplete := Padl(ALLtrim(STR((RECNO()/nLastRec) * 100,0)),3)
@ 2,35 SAY "Sorting Index #:"+Alltrim(Str(nPos))+ "  Progress"+ cComplete + "%"
RETURN .T.
////////////////////////////////////////////////////////////////////////////

FUNCTION NotCommas(n)
LOCAL nReturn,cNewStr
LOCAL nPoint := AT(".",STR(n))
cNewStr := SUBSTR(STR(n),nPoint)
IF VAL("0" + cNewStr) > 0
    nReturn :=VAL(STR(INT(n)+1) + ".00")
ELSE
     nReturn := n
ENDIF
return nReturn

////////////////////////////////////////////////////////////////////
/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: SwitchTag(cFileName)             Docs:                     ³
 * ³  Description: Switch tag to next tag                                     |
 * ³       Author: Tanya Veksler                                              ³
 * ³ Date created: 04/10/00              Date updated: ş                      ³
 * ³ Time created: 15:50:14              Time updated: ş                      ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: cAlias                                                     ³
 * ³ Return Value: nil                                                        ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */

Function SwitchTag(cFileName,aCoord)
LOCAL nOldSelect,n,i,cCurrTag
LOCAL aInfo := {},aTagInfo := {},aTagKeyInfo := {}
aInfo  := (cFileName)->(AX_TagInfo())

nOldSelect := SELECT()
cCurrTag := (cFileName)->(ORDSETFOCUS())
FOR i := 1 TO len(aInfo)
     AADD(aTagInfo,aInfo[i,1])
     //AADD(aTagKeyInfo,aInfo[i,2])
NEXT

NetUse("syskeys",5)
ordsetfocus(1)
dbseek(cFileName)
While trim(syskeys->filename) == cFileName
      AADD(aTagKeyInfo,trim(syskeys->descriptio) + chr(15) + trim(syskeys->tagdesc))
      syskeys->(dbskip(1))
End
syskeys->(dbclosearea())

n := ASCAN(aTagInfo,cCurrTag)
@ aCoord[1],aCoord[2] SAY "                                                  "
IF n == len(aTagInfo)
     (cFileName)->(ORDSETFOCUS(1))
     @ aCoord[1],aCoord[2] SAY aTagKeyInfo[1]
ELSE
     (cFileName)->(ORDSETFOCUS(n+1))
     @ aCoord[1],aCoord[2] SAY aTagKeyInfo[n+1]
ENDIF
SELECT(nOldSelect)
return nil


////////////////////////////////////////////////////////////////////////////
/*

func LOAD_DLL(dllname)
local libhan := BLILIBLOD (dllname)            // Dynamically load the DLL

if libhan > 32                         // If it loaded successfully

else   //error loading
   alert("DLL file "+dllname+" not found or failed to load",{'Quit'})
   quit

endif
return libhan


func FREE_DLL(libhan)
   BLILIBFRE (libhan)                  // Free the library when finished
return NIL


func CALL_DLL(dllname,funcname)
local libhan := BLILIBLOD (dllname)            // Dynamically load the DLL
local funhan                           //function handle

if libhan > 32                         // If it loaded successfully

//          ******************         // EITHER (most efficient and controlled)

   funhan := BLIFUNHAN (libhan,funcname)  // Get the function handle
   if funhan <> 0                      // If the function was found

                                       // Call function
      BLIFUNCAL(funhan)
                                       // Note that function handle is LAST
   else
      alert("DLL file "+dllname+" does not contain function "+funcname,{'Quit'})
      quit
   endif

   BLILIBFRE (libhan)                  // Free the library when finished

else
   alert("DLL file "+dllname+" not found or failed to load",{'Quit'})
   quit

endif
return NIL
*/


FUNCTION QPQC31Keys(nKey,oBjct,nFirstRec,cProc,nMone,nMaxMone)
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
        *Objct:pagedown()  !!! ƒ…’ €Œ „†
   CASE nKey=18  //K_PGUP
        *Objct:pageup()
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
   /*CASE nKey = K_ALT_F   // freeze
        IF Objct:freeze == 0
           Objct:freeze := Objct:colPos
        ELSE
           Objct:panHome()
           Objct:freeze := 0
        ENDIF
        Objct:refreshAll()*/
   CASE nKey=K_HOME      ;  Objct:home()
   CASE nKey=K_END       ;  Objct:end()
   CASE nKey=K_CTRL_LEFT ;  Objct:panleft()
   CASE nKey=K_CTRL_RIGHT;  Objct:panright()
   CASE nKey=K_CTRL_HOME ;  Objct:panhome()
   CASE nKey=K_CTRL_END  ;  Objct:panend()
   CASE nKey=-3  // „ ™…”‰‡
        @10,05 CLEAR TO 14,75
        cScr  := SAVESCREEN(10,05,14,75)
        DISPBOX(10,05,14,75,REPLICATE('ÉÍ»º¼ÍÈº ',9),"W+/BG")
        DEVPOS(13, 06)
        DEVOUT(PADC("! „„ Œ™ ‰……š„ š™™ €…Œ ƒ‰Œ—„Œ ™‰",69),"GR+/BG")
        DEVPOS(12, 17)
        DEVOUT(":„ .‘ ƒ‰Œ—„Œ €","N/BG")
        @12, 07 GET cBatch PICTURE '999999'
        READ
        SETCOLOR(cOldColor)
        *
        nRecno:=RECNO()
        D_line->(ORDSETFOCUS("iB_idln")) // B_id ‰”Œ D_line …‰
        D_line->(DBSEEK(cBatch),.F.)   // ƒŒ—…„™ „ ™…”‰‡
        *
        * €… cProc Œ „„† CpProc_id „ € ,D_line  š€– € Tbrowse  š€– „„
        *                                                    .CD  „…™ B_stat „
        *
        IF D_line->(FOUND()) .AND. D_line->CpProc_Id==cProc .AND. ;
         !UPPER(D_line->B_stat) $ ('CD') .AND. LASTKEY() # 27
           cB_id:=D_line->B_id
           D_line->(ORDSETFOCUS("iSlack")) // ‰˜…—„ …‰Œ „˜†‡ Vitaly 25-07-01 ("iLnBrCd"))
           *
           * „€–™ „Œ ƒ’ Š‘ „…™€˜„ „„ š…˜…™„ š˜‰”‘
           *
           D_line->(DBGOTO(nFirstRec)) // š‰˜…š„ „…™˜„ „… š˜‰”‘ Š˜…–Œ …Œ‡ „…™€˜„ „…™˜ š…—š„
           COUNT to nLine WHILE D_line->B_id # cB_id
           nMone:=nLine + 1 // 1  nMone …Œ‰€… 0  Œ‰‡š nLine
           oBjct:refreshAll()
           oBjct:forceStable()
        ELSE
           IF LASTKEY() # 27
              *
              *cProc # CpProc_id „ Š€ €– …€ D …€ C €…„ B_stat Œ€ €– …€ €– €Œ €
              *      .ƒ…—„ „…Œ… šƒ…—„ „…™˜Œ ˜…†‡Œ ™‰ (‰˜…—„ …‰ ’‰”… €Œ ’™)
              *
              D_line->(ORDSETFOCUS("iSlack")) // ‰˜…—„ …‰Œ „˜†‡
              D_line->(DBGOTO(nRecno)) // š‰˜…š„ „…™˜Œ „˜†‡
              DEVPOS(20, 17)
              ALERT("!! š™—…„ „„ „€– €Œ", {"Š™„Œ …„™Œ‹ ™— Œ’ •‡Œ"} )
           ELSE
              D_line->(ORDSETFOCUS("iSlack"))//D_line->(ORDSETFOCUS("iLnBrCd"))VR 25-06-01 16191452 // ‰˜…—„ …‰Œ „˜†‡
              D_line->(DBGOTO(nRecno)) // š‰˜…š„ „…™˜Œ „˜†‡
           ENDIF
        ENDIF
        *
   CASE nKey=20  //  ‰…‹‰‘ Ctrl_t
        nCurrenLine:=D_line->(RECNO())
        D_line->(DBSEEK(cProc))
        *
        *  š…‰…‹„ ‰˜‚…€Œ ‰šŒ‡š„ Š˜’ š
        *
        nSumW:=nSumS:=nSumP:=0
        *
        * „Œ€™ Tbrowse „ š††„
        *
        oBjct:panEnd()
        DO WHILE !oBjct:stabilize()
        ENDDO
        *
        * ‰…‹‰‘„ š…€–…š …Œ‡ š‰‰
        *
        *cScr  := SaveScreen(22,0,24,79)
        cScr  := SaveScreen(23,0,23,79)
        *DispBox(22,0,24,79,"ÚÄ¿³ÙÄÀ³ ", "B/BG","W/N")
        *DEVPOS(23,1)
        *DEVOUT(PADC('    ! š„ ,…‹‰‘ ’–',78),"R+/BG")
        WHILE D_line->CpProc_id==cProc .AND. !D_line->(EOF())
              nSumW+=D_line->Cp_BqtyW
              nSumS+=D_line->Cp_BqtyS
              nSumP+=D_line->Cp_BqtyP
              D_line->(DBSKIP())
        ENDDO
        @23,1  say ALLTRIM(TRANSFORM(nSumP,'999,999,999')) color "GR+/B"
        @23,13 say ALLTRIM(TRANSFORM(nSumS,'999,999,999')) color "GR+/B"
        @23,25 say ALLTRIM(TRANSFORM(nSumW,'999,999,999')) color "GR+/B"
        @23,40 say ' ! …„™Œ‹ ™— Œ’ •‡Œ Š™„Œ'             color "R+/B"
        @23,75 say ALLTRIM(STR(nMaxMone,5))                color "GR+/B"
        SETCURSOR(0)
        DEVPOS(23,40)
        INKEY(0)
        SETCURSOR(1)
        RESTSCREEN(23,0,23,79,cScr)
        D_line->(DBGOTO(nCurrenLine))
        *
   OTHERWISE
     // kh:=.f.  What is the meaning of returning false ?
ENDCASE

RETURN (nMone) // Updated value
*
FUNCTION Repaint(o)
   o:ColorRect( {o:RowPos, 1, o:RowPos, o:ColCount}, {1, 2} )
RETURN NIL

Function GetNewBidSort() //VR 01-2003 ID:28221242
Return right((Alias())->b_id,1)+left((Alias())->b_id,5)



Procedure UpdatePrnFile(cPrnFile,cMoveType)//VR 01-04-2003

Local nOldArea := Select()

NetUse("d_prnout",5)
IF d_prnout->(AddRec(5,ProcName()))
	d_prnout->File_name := cPrnFile
   d_prnout->smtype_id := cMoveType
ENDIF
d_prnout->(dbclosearea())
DbSelectArea(nOldArea)
Return

Function GetUniProc() //ID:430_tapi
Return IIF("CZ" $ GetUserInfo():cGroupID,SUBSTR(C_PROC->PROC_NME,1,19),SUBSTR(C_PROC->PROC_NMH,2,19))

Function xDbUnLock(cDbf)

local cDate

DEFAULT cDbf to "d_line"



cDate := AllTrim(STR(100000+((cDbf)->b_dprom-(cDbf)->ExpFindate),6))

IF Len(cDate) == 5
	cDate := "0" + cDate
ENDIF

(cDbf)->iSlack    := (cDbf)->cpproc_id+(cDbf)->b_prior+;
	                  cDate+;
							IF((cDbf)->b_purp=CHR(55),CHR(50),;
							IF((cDbf)->b_purp=CHR(54),CHR(51),(cDbf)->b_purp))+;
							IF((cDbf)->b_stat=CHR(78),CHR(49),;
							IF((cDbf)->b_stat=CHR(32),CHR(50),;
							IF((cDbf)->b_stat=CHR(82),CHR(51),;
							IF((cDbf)->b_stat=CHR(80),CHR(52),;
							CHR(999-ASC((cDbf)->b_stat))))))+(cDbf)->b_id
(cDbf)->qciSlack  := (cDbf)->cpproc_id+;
	                  IF((cDbf)->b_stat=CHR(78),CHR(49),;
							IF((cDbf)->b_stat=CHR(32),CHR(50),;
							IF((cDbf)->b_stat=CHR(82),CHR(51),;
							IF((cDbf)->b_stat=CHR(80),CHR(52),;
							CHR(999-ASC((cDbf)->b_stat))))))+;
							(cDbf)->b_prior+cDate+;
							IF((cDbf)->b_purp=CHR(55),CHR(50),;
							IF((cDbf)->b_purp=CHR(54),CHR(51),(cDbf)->b_purp))+;
							(cDbf)->b_id
(cDbf)->( DBCOMMIT() )
Return (cDbf)->( ax_UnLock() )

Function GetSngLeadt(nLead,cAlias)

local nRet := 99.99

default cAlias to "m_linemv"

IF (cAlias)->PTYPE_ID $ "U_K" .and. c_leadt->(DBSEEK( (cAlias)->PTYPE_ID + (cAlias)->CPPROC_ID) )
	if Empty(nLead)
	   nRet := c_leadt->LEADT_DAYS
	elseif c_leadt->( RecLock(15,"TAPI") )
		c_leadt->LEADT_DAYS := nLead
		c_leadt->(dbunlock())
	endif
ELSEIF c_leadt->(DBSEEK( (cAlias)->PTYPE_ID + (cAlias)->CPPROC_ID + (cAlias)->PLINE_ID) )
	if Empty(nLead)
	   nRet := c_leadt->LEADT_DAYS
	elseif c_leadt->( RecLock(15,"TAPI") )
		c_leadt->LEADT_DAYS := nLead
		c_leadt->(dbunlock())
	endif
ELSEIF c_leadt->( AddRec(15,"TAPI") )
		 c_leadt->ptype_id := (cAlias)->PTYPE_ID
       c_leadt->proc_id := (cAlias)->CPPROC_ID
		 c_leadt->LEADT_DAYS := 1
		 IIF(!(cAlias)->PTYPE_ID $ "U_K" ,c_leadt->pline_id := (cAlias)->Pline_ID , NIL)
		 c_leadt->(dbunlock())
		 nRet := c_leadt->LEADT_DAYS
ENDIF

Return nRet