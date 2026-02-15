//  Bmsbar3.prg
// Function/Procedure Prototype Table  -  Last Update: 24-06-96 @ 14:50:19
// ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
// Return Value         Function/Arguments
// ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ  ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
// xValue               STATIC FUNCTION AllRetVal ( cTableName )
// .T.                  STATIC FUNCTION DoFinQc
// .T.                  STATIC FUNCTION DoKitFinQc
// .T.                  STATIC FUNCTION DoPackFinQc
// aRetVal              STATIC FUNCTION GetAttributes
// LastKey() = K_ENTER  STATIC FUNCTION GetBN( cBN )
// {"c_volt","c_tc"...  STATIC FUNCTION GetTabName(o)
// d_esn->( Found()...  STATIC FUNCTION IsESN( cEsn )
// oPart:cEsn           STATIC FUNCTION MakeESN( aLine )
// lRetVal              STATIC FUNCTION QtyOk( nQty )
// lRetVal              STATIC FUNCTION SrcBelongToPack( cSRCBN )
// lToBuild             STATIC FUNCTION ToBuildEsn( cTabName )
// lRetVal              STATIC FUNCTION TolCheck( cFinFile )
// OpenState( aoOpe...  STATIC FUNCTION openTables
// lRetVal              STATIC FUNCTION postAll(o)
// .T.                  STATIC FUNCTION postKitESN(o)
// .T.                  STATIC FUNCTION postKitQty( o )
// .T.                  STATIC FUNCTION postQty(o)
// lRetVal              STATIC FUNCTION postWh(o)
// lRetVal              STATIC FUNCTION postbar3BN(o)
// .T.                  STATIC FUNCTION preAll(o)
// .T.                  STATIC FUNCTION preQty(o)
// Void                 STATIC PROCEDURE CloseFiles
// Void                 STATIC PROCEDURE DoKitLineMove
// Void                 STATIC PROCEDURE DoLineMove
// Void                 STATIC PROCEDURE DoRejAll
// Void                 STATIC PROCEDURE EsnxxWin
// Void                 STATIC PROCEDURE GetKitData(cCode)
// Void                 STATIC PROCEDURE GetTolRInfo
// Void                 STATIC PROCEDURE LastPackStep
// Void                 STATIC PROCEDURE MakeKitBrow
// Void                 STATIC PROCEDURE MakeTheBrow( nTop , nBot )
// Void                 STATIC PROCEDURE MakeWinBrow( cTableName )
// Void                 STATIC PROCEDURE ShowGetParts
// Void                 STATIC PROCEDURE ShowKitParts
// Void                 STATIC PROCEDURE ShowQcDoc( cFinFile )
// Void                 STATIC PROCEDURE WinAll
// Void                 PROCEDURE DelTolR( o )
// Void                 PROCEDURE DoEndBatch
// Void                 PROCEDURE DoEndKitMatch
// Void                 PROCEDURE DoEndOfBatch
// Void                 PROCEDURE DoEndPack
// Void                 PROCEDURE DoPackRejAll
// Void                 PROCEDURE GetData(cCode)
// Void                 PROCEDURE LastKitStep
// Void                 PROCEDURE LastStep
// Void                 PROCEDURE MakePackBrow
// Void                 PROCEDURE ReQcDoc
// Void                 PROCEDURE ScrBatchOn
// Void                 PROCEDURE ShowPackParts( aoBjs )
// cRetVal              FUNCTION SwType()

// G:\BMSBAR\SOURCE\BMSBAR3.PRG
#include "avxdefs.ch"
#include "edi.ch"

STATIC aRandNtx

STATIC nTolRQty , nsTolRQty

STATIC  cCodeM , cCodeDoc , cScrNote

STATIC  csCodeM , csCodeDoc , csScrNote

STATIC nRejected
STATIC lRegularRej := .F. , lSwType := .F.
STATIC aRegularRej := {}

STATIC lTolR := .F.
STATIC oPart
STATIC aGoodKeys := {K_ENTER,K_PGDN, K_PGUP}

STATIC aoOpenedList
STATIC cEndType
STATIC aControlTable :=;
                       {;  // 1 capacitors   2 inductors   3 fuses    4 couplers
                         {   .t. , .t. , .t. , .t. , .t. , .t. },;  // 1 caps
                         {   .f. , .f. , .t. , .t. , .t. , .t. },;  // 2 indc
                         {   .f. , .f. , .t. , .f. , .t. , .t. },;  // 3 fuses
                         {   .f. , .f. , .t. , .f. , .t. , .t. },;  // 4 couplers
                         {   .f. , .f. , .t. , .f. , .t. , .t. },;  // 5 Filter
                         {   .f. , .f. , .t. , .t. , .t. , .t. },;   // 6 Resonator
                         {   .f. , .f. , .f. , .f. , .t. , .t. };   // 7 Other R&D
                        }

STATIC aStock  , aSourceBN , cToran
STATIC o , oWin , oP
STATIC cCaps ,bKey


STATIC aAttrib := {"volt_id" , "tc_id" , "value_id" , "tol_id" , "esnxx_id" , "esny_id" }
STATIC aTitles := { "àåÖÖ" , "TC","äòí" ,   "TOL" , "XX" , "Y" }

/**************************************************************/
PROCEDURE DoEndOfBatch

LOCAL cEndType := GetEndType()
aoOpenedList  := {}

IF !OpenTables()
   RETURN
ENDIF

IF IfEnglish()
	aTitles := {"VOLT","TC","VALUE","TOL","XX","Y"}
ENDIF


DO CASE
   CASE cEndType == "Y"  // yizur
        DoEndBatch()
   CASE cEndType == "A"  // ariza
        DoEndPack()
   CASE cEndType == "K"  // kit
        DoEndKitMatch()
   CASE cEndType == "E"  // escaped
        IIF( !IfEnglish(),Alert( "ÑòâáÅ Äåå çÖâë öòâáÅ äåÑéé Äñâ ôéöôéÑ" , {"..."} ) ,;
		                    Alert( "Operation aborted" , {"..."} ) )
ENDCASE

CloseFiles()

RETURN

/*
 * ⁄ƒ Function ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
 * ≥         Name: openTables            Docs: Shalom LeVine                  ≥
 * ≥  Description:                                                            ≥
 * ≥       Author: Shalom LeVine                                              ≥
 * ≥ Date created: 09-29-96              Date updated: ˛09-29-96              ≥
 * ≥ Time created: 10:46:11am            Time updated: ˛10:46:11am            ≥
 * ≥    Copyright: Shalom LeVine                                              ≥
 * √ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥
 * ≥    Arguments: None                                                       ≥
 * ≥ Return Value: OpenState( aoOpenedList )                                  ≥
 * ≥     See Also:                                                            ≥
 * ¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
 */
STATIC FUNCTION openTables
LOCAL oTab
LOCAL cRandNtx
aRandNtx := {}

aoOpenedList := GenOpenFiles({"c_esny","c_esnxx","c_tol","c_value",;
                               "c_tc","c_volt","d_esn","d_prom","d_ord","c_pline"})
d_esn->( ORDSETFOCUS("iesn_id") )
d_prom->( ORDSETFOCUS(1) )
d_ord->( ORDSETFOCUS("IPO_OO") )

RETURN OpenState( aoOpenedList )

/*
 * ⁄ƒ Procedure ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
 * ≥         Name: CloseFiles                                                 ≥
 * ≥  Description:                                                            ≥
 * ≥       Author: Shalom LeVine         Designer: Shalom LeVine              ≥
 * ≥ Date created: 09-29-96              Date updated: ˛09-29-96              ≥
 * ≥ Time created: 10:46:28am            Time updated: ˛10:46:28am            ≥
 * ≥    Copyright: Shalom LeVine                                              ≥
 * √ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥
 * ≥   Parameters: None                                                       ≥
 * ≥     See Also:                                                            ≥
 * ¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
 */
STATIC PROCEDURE CloseFiles

LOCAL i

Aeval( aoOpenedList , {| oTable | oTable:close() } )


RETURN


/*
⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
≥                           òÖñââ öêé  ç Ö â ë  áÖÖâÉ                           ≥
√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥
≥            äòÖñÑ öÉâéÅ ÑòíÑ ìëÖÑ (É)               åíÖîÅ ESN åí áÖÖÉ  (Ä)     ≥
≥                    áÖÖâÉÑ öÄ òôÄ (Ñ)                    öÖéã åí áÖÖÉ  (Å)     ≥
≥                                                    ÉíâÑ èëáé åí áÖÖÉ  (Ç)     ≥
√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥
≥    06031J2R4BBT020 :ESN   ZZ 6-01 :  öÖîâáÉ öéò  3 :ÉÖíâ  310010: Ñêé 'ëé     ≥
≥      V02A :ÅÖöâê ÉÖó   130 :ÅåôÑ 'ëé            öâîÖë öòÖóâÅ 195.0 :äâåÑö     ≥
≥            66,900* çâÅâãò    222* öÖàÇÅ   11  öÖëÖòî    :Ååôå ÑëâêãÅ öÖéã     ≥
√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥
≥                                                               4 :caps 'ëé -   ≥
≥                                                     åíÖîÅ ESN âêÖöê àÖòâî -   ≥
≥                                ÑòíÑ èëáé    öÖéã  àåÖÖ TC    äòí  åÖà XX Y    ≥
≥                             THB Äåå    3   3,000    1   J   2.4    A  02 0    ≥
≥                                        4  12,000    1   J   2.4    B  02 0    ≥
≥                   02 öÖôâòÉÅ Ééí Äå    1     865    1   J   2.4    C  00 1    ≥
≥                                        9     311    1   J   2.4    R  02 1    ≥
≥                                                                               ≥
≥                                                                               ≥
≥                                                                               ≥
¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ


                                ÑòíÑ èëáé    öÖéã  àåÖÖ TC    äòí  åÖà XX Y
                             THB Äåå    3   3,000    1   J   2.4    A  02 0
                                        4  12,000    1   J   2.4    B  02 0
                   02 öÖôâòÉÅ Ééí Äå    1     865    1   J   2.4    C  00 1
                                        9     311    1   J   2.4    R  02 1


*/

PROCEDURE DoEndBatch

ScrBatchOn()

IF m_linemv->ptype_id == "C"
   cCaps := m_linemv->b_ncaps
	IF !IfEnglish()
	   @ 11,64 GET cCaps
   ELSE
      @ 11,16 GET cCaps
	ENDIF
   READ
   IF LastKey() = K_ESC
      RETURN
   ENDIF
ELSE
     cCaps := " "
ENDIF

IF Empty( aStock )
   aStock := {}
   GetData( "N" )
   IF LastKey() = K_ESC .OR. Empty( aStock )
      RETURN
   ENDIF
ENDIF

MakeTheBrow()
ShowGetParts()
aStock := NIL

RETURN

/**********************************************************************/
PROCEDURE ScrBatchOn
IF !IfEnglish()
   @ 0 ,0 SAY  "⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø"
   @ 1 ,0 SAY  "≥                           òÖñââ öêé  ç Ö â ë  áÖÖâÉ                          ≥"
   @ 2 ,0 SAY  "√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥"
   @ 3 ,0 SAY  "≥            äòÖñÑ öÉâéÅ ÑòíÑ ìëÖÑ (É)               åíÖîÅ ESN åí áÖÖÉ  (Ä)    ≥"
   @ 4 ,0 SAY  "≥                    áÖÖâÉÑ öÄ òôÄ (Ñ)                    öÖéã åí áÖÖÉ  (Å)    ≥"
   @ 5 ,0 SAY  "≥                                                    ÉíâÑ èëáé åí áÖÖÉ  (Ç)    ≥"
   @ 6 ,0 SAY  "√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥"
   @ 7 ,0 SAY  "≥                    :ESN           :  öÖîâáÉ öéò    :ÉÖíâ        : Ñêé 'ëé    ≥"
   @ 8 ,0 SAY  "≥           :ÅÖöâê ÉÖó       :ÅåôÑ 'ëé                               :äâåÑö    ≥"
   @ 9 ,0 SAY  "≥                    çâÅâãò         öÖàÇÅ       öÖëÖòî    :Ååôå ÑëâêãÅ öÖéã    ≥"
   @ 10,0 SAY  "√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥"
   @ 11,0 SAY  "≥                                                                              ≥"
   @ 12,0 SAY  "≥                                                     åíÖîÅ ESN âêÖöê àÖòâî -  ≥"
   @ 13,0 SAY  "≥                                                                              ≥"
   @ 14,0 SAY  "≥                                                                              ≥"
   @ 15,0 SAY  "≥                                                                              ≥"
   @ 16,0 SAY  "≥                                                                              ≥"
   @ 17,0 SAY  "≥                                                                              ≥"
   @ 18,0 SAY  "≥                                                                              ≥"
   @ 19,0 SAY  "≥                                                                              ≥"
   @ 20,0 SAY  "≥                                                                              ≥"
   @ 21,0 SAY  "≥                                                                              ≥"
   @ 22,0 SAY  "≥                                                                              ≥"
   @ 23,0 SAY  "¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ"
ELSE
	@ 0 ,0 SAY  "⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø"
   @ 1 ,0 SAY  "≥                  Production Batch Completion Report                          ≥"
   @ 2 ,0 SAY  "√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥"
   @ 3 ,0 SAY  "≥  a. Enter Actual ESN                          d. Add a comment if necessary  ≥"
   @ 4 ,0 SAY  "≥  b. Enter Quantity                            e. Confirm                     ≥"
   @ 5 ,0 SAY  [≥  c. Enter Destination Warehouse                                              ≥]
   @ 6 ,0 SAY  "√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥"
   @ 7 ,0 SAY  "≥  Batch No.:          Purpose:     Priority:           ESN:                   ≥"
   @ 8 ,0 SAY  "≥  Process  :                             Stage No.:        Route Code:        ≥"
   @ 9 ,0 SAY  "≥  Quantity Before Scraping            Wafers          Strips           Pieces ≥"
   @ 10,0 SAY  "√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥"
   @ 11,0 SAY  "≥                                                                              ≥"
   @ 12,0 SAY  "≥ - Actual ESN details                                                         ≥"
   @ 13,0 SAY  "≥                                                                              ≥"
   @ 14,0 SAY  "≥                                                                              ≥"
   @ 15,0 SAY  "≥                                                                              ≥"
   @ 16,0 SAY  "≥                                                                              ≥"
   @ 17,0 SAY  "≥                                                                              ≥"
   @ 18,0 SAY  "≥                                                                              ≥"
   @ 19,0 SAY  "≥                                                                              ≥"
   @ 20,0 SAY  "≥                                                                              ≥"
   @ 21,0 SAY  "≥                                                                              ≥"
   @ 22,0 SAY  "≥                                                                              ≥"
   @ 23,0 SAY  "¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ"
ENDIF



ShowSpec()
IF m_linemv->ptype_id = "C"
   IF !IfEnglish()
	    @ 11, 66 SAY ":caps 'ëé -"
	ELSE
		 @ 11, 02 SAY "- No of Caps:"
	ENDIF
ENDIF
RETURN

STATIC FUNCTION GetAttributes
LOCAL aRetVal
DO CASE
   CASE m_linemv->ptype_id = "C"
        aRetVal := aControlTable[1]
   CASE m_linemv->ptype_id = "L"
        aRetVal := aControlTable[2]
   CASE m_linemv->ptype_id = "F"
        aRetVal := aControlTable[3]
   CASE m_linemv->ptype_id = "U"
        aRetVal := aControlTable[4]
   CASE m_linemv->ptype_id = "T"
        aRetVal := aControlTable[5]
   CASE m_linemv->ptype_id = "S"
        aRetVal := aControlTable[6]
   CASE m_linemv->ptype_id $ "ZXD"
        aRetVal := aControlTable[7]
   OTHERWISE
        Alert( "Error value in m_linemv->ptype_id:"+m_linemv->ptype_id+;
               " ("+Ltrim(Str( m_linemv->( RecNo() ) ))+")" ,{"..."} )
ENDCASE
RETURN aRetVal


STATIC PROCEDURE MakeTheBrow( nTop , nBot )
LOCAL aWork , oCol
LOCAL i , nLen
LOCAL nLeft , nRight

DEFAULT nTop TO 14 , nBot TO 22

IF !IfEnglish()
   IF nTop = 14
      nLeft   := 22
      nRight  := 78
   ELSE
      nLeft   := 12
      nRight  := 68
   ENDIF
ELSE
   nLeft   := 2
   nRight  := 58
ENDIF

aWork := GetAttributes()


o := ABrowseNEW(nTop,nLeft,nBot,nRight,aStock )

IF !IfEnglish()///////////////////////////////////////////////////////////////
o:addColumn( TBColumnNEW( "           ÑòíÑ" , {|| o:arrayReference[o:arrayIndex,1]} ) )
o:addColumn( TBColumnNEW( "èëáé" , {|| Padc(o:arrayReference[o:arrayIndex,2],4 )} ) )
o:addColumn( TBColumnNEW( "   öÖéã",{|| Transform(o:arrayReference[o:arrayIndex,3],"999,999") }))

IF aWork[1]
   oCol := TBColumnNEW( aTitles[1]    , {|| o:arrayReference[o:arrayIndex,4]} )
   oCol:cargo := 1
   o:addColumn( oCol )
ENDIF

IF aWork[2]
   oCol := TBColumnNEW( aTitles[2]    , {|| o:arrayReference[o:arrayIndex,5]} )
   oCol:cargo := 2
   o:addColumn( oCol )
ENDIF

IF aWork[3]
   oCol := TBColumnNEW( Padc( aTitles[3],8 ) , {|| o:arrayReference[o:arrayIndex,6]} )
   oCol:cargo := 3
   o:addColumn( oCol )
ENDIF

IF aWork[4]
   oCol := TBColumnNEW( aTitles[4]    , {|| o:arrayReference[o:arrayIndex,7]} )
   oCol:cargo := 4
   o:addColumn( oCol )
ENDIF

IF aWork[5]
   oCol := TBColumnNEW( aTitles[5]    , {|| o:arrayReference[o:arrayIndex,8]} )
   oCol:cargo := 5
   o:addColumn( oCol )
ENDIF

IF aWork[6]
   oCol := TBColumnNEW(  aTitles[6] , {||o:arrayReference[o:arrayIndex,9] } )
   oCol:cargo := 6
   o:addColumn( oCol )
ENDIF

ELSE/////////////////////////////////////////////////////////////////////////

IF aWork[6]
   oCol := TBColumnNEW(  aTitles[6] , {||o:arrayReference[o:arrayIndex,9] } )
   oCol:cargo := 6
   o:addColumn( oCol )
ENDIF

IF aWork[5]
   oCol := TBColumnNEW( aTitles[5]    , {|| o:arrayReference[o:arrayIndex,8]} )
   oCol:cargo := 5
   o:addColumn( oCol )
ENDIF

IF aWork[4]
   oCol := TBColumnNEW( aTitles[4]    , {|| o:arrayReference[o:arrayIndex,7]} )
   oCol:cargo := 4
   o:addColumn( oCol )
ENDIF

IF aWork[3]
   oCol := TBColumnNEW( Padc( aTitles[3],8 ) , {|| o:arrayReference[o:arrayIndex,6]} )
   oCol:cargo := 3
   o:addColumn( oCol )
ENDIF

IF aWork[2]
   oCol := TBColumnNEW( aTitles[2]    , {|| o:arrayReference[o:arrayIndex,5]} )
   oCol:cargo := 2
   o:addColumn( oCol )
ENDIF

IF aWork[1]
   oCol := TBColumnNEW( aTitles[1]    , {|| o:arrayReference[o:arrayIndex,4]} )
   oCol:cargo := 1
   o:addColumn( oCol )
ENDIF

o:addColumn( TBColumnNEW( "Quantity"     ,{|| Transform(o:arrayReference[o:arrayIndex,3],"999,999") }))
o:addColumn( TBColumnNEW( "Warehouse"    , {|| Padc(o:arrayReference[o:arrayIndex,2],4 )} ) )
o:addColumn( TBColumnNEW( "Comment     " , {|| o:arrayReference[o:arrayIndex,1]} ) )

ENDIF///////////////////////////////////////////////////////////////////

RETURN

/***********************************************************/
STATIC PROCEDURE ShowGetParts

LOCAL nKey

IF !IfEnglish()
   @ 24,0 SAY Padc( "Enter-èÖóâö  Space-ìëÖê  Del-åàÅ  F5-òÖôâÄ  Alt+P-èëáéå Äå öÖåâëî" , 80 ) COLOR If( IsColor() , "W+/BR" , "W+/N" )
   o:panEnd()
ELSE
	@ 24,0 SAY Padc( "Scrap not for WH-Alt+P,Confirm-F5,Cancel-Del,Additional-Space,Correct-Enter" , 80 ) COLOR If( IsColor() , "W+/BR" , "W+/N" )
ENDIF


WHILE .T.

    WHILE !o:stabilize() ; ENDDO

    nKey := InKey(0)

    IF nKey = K_ESC
       EXIT
    ELSEIF StdKeys( nKey , o )
    ELSEIF nKey = K_F5
       LastStep()
       EXIT
    ELSEIF nKey = K_ALT_P
       SetRejEob( .T. )
       nKey := 0
       Aeval( aStock , {|el,i| nKey += el[3] } ) // sum qty entered
       nRejected := (m_linemv->cp_bqtyp - nKey) // calc how many rejctions you can enter
       lRegularRej := SetRejected( nRejected )  //
       EmptyRejBuffer()
       GetScr2_F3F4F5()
       lRegularRej := SetRejected( 0 ) // lRegularRej saves if there are any rejected p
       SetRejEob( .F. )
    ELSEIF nKey = K_ENTER
       GetData("U")
       o:refreshCurrent()
    ELSEIF nKey = K_SPACE
       GetData("N")
       o:configure()
       o:goTop()
       o:refreshAll()
    ELSEIF nKey = K_DEL
       IF Empty( aStock )
          GetData("N")
          IF LastKey() = K_ESC
             EXIT
          ENDIF
       ELSE
          DelTolR(o)
          Adel( aStock , o:arrayIndex )
          Asize( aStock , Len( aStock ) - 1 )

          IF Empty( aStock )
             GetData("N")
             IF LastKey() = K_ESC
                EXIT
             ENDIF
          ENDIF

          IF o:arrayIndex > Len( aStock )
             o:arrayIndex := Len( aStock )
          ENDIF

          o:configure()
          o:goTop()
          o:refreshAll()
       ENDIF
    ENDIF
ENDDO
RETURN

/********************************************************************/
PROCEDURE GetData(cCode)

LOCAL aCurrent
LOCAL cScreen := SaveScreen()
LOCAL aWork := GetAttributes()
LOCAL i
LOCAL aValues := { " " , " " , 0 , " " , "  " , " " }
LOCAL nQty := 0
LOCAL cWh  := " "
LOCAL cNote:= Space( 20 )// Vr 31-12-01
LOCAL cBN := Space( 6 )
LOCAL nLine

IF cToran = NIL .OR. cToran == "pack" .OR. cToran == ""
   aCurrent := aStock
ELSEIF cToran == "src"
   aCurrent := aSourceBN
ELSE
   Alert( "Error in GetData proc (bmsbar3 line 388) call mis now!!" , "Enter" )
   Quit
ENDIF

IF cCode = "N"
   IF Len( aCurrent ) = 0
      aValues[1] := d_line->volt_id   // volt
      aValues[2] := d_line->tc_id     // tc
		IF d_prom->(dbseek(d_line->b_id)) .AND. d_ord->(dbseek(str(d_prom->poln_id,9,2)))
			aValues[3] := d_ord->value_id  // value
		ELSE
			aValues[3] := d_line->value_id  // value
		ENDIF
      aValues[4] := d_line->tol_id    // tol
      aValues[5] := d_line->esnxx_id  // xx
      aValues[6] := d_line->esny_id   // y
   ELSE
      aValues[1] := d_line->volt_id   // volt
      aValues[2] := d_line->tc_id     // tc
   ENDIF
   IF cToran == "src"
      cBN   := Space(6)
   ENDIF
ELSE
   i := o:arrayIndex
   cNote      := aCurrent[i , 1 ]
   cWh        := aCurrent[i , 2 ]
   nQty       := aCurrent[i , 3 ]
   aValues[1] := aCurrent[i , 4 ]  // volt
   aValues[2] := aCurrent[i , 5 ]  // tc
   aValues[3] := aCurrent[i , 6 ]  // value
   aValues[4] := aCurrent[i , 7 ]  // tol
   aValues[5] := aCurrent[i , 8 ]  // xx
   aValues[6] := aCurrent[i , 9 ]  // y
   IF cToran == "src"
      cBN   :=  aCurrent[i , 10 ]  // bn
   ENDIF
ENDIF


IF !IfEnglish()////////////////////////////////////////////////////
@ 6,17 CLEAR TO 18 , 47
@ 6,17 TO 18 , 47  DOUBLE

IF cToran == "src"
   @ 6 , 23 SAY "∂Source B/N«"
   @ 7 , 23 SAY       "           xxxxxx:B/N"
   @ 7 , 34 GET cBN PICTURE "@K XXXXX9" SEND postBlock := {|o| postbar3BN(o) }
ELSEIF cToran == "pack"
   @ 6 , 23 SAY "∂Packing B/N«"
ENDIF

@ 8 ,23 SAY       "                x:Y "
@ 8 ,39 GET aValues[6]  PICTURE "!";
                        SEND preBlock  := {|o| preAll( o ) } ;
                        SEND postBlock := {|o| postAll( o ) }

@ 9 ,23 SAY       "               xx:XX"
@ 9 ,38 GET aValues[5]  SEND preBlock  := {|o| preAll( o ) } ;
                        SEND postBlock := {|o| postAll( o ) }


nLine := 9
IF m_linemv->ptype_id $ "C_L_"
   nLine++
   @ nLine,23 SAY       "                x:TOL"
   @ nLine, 39 GET aValues[4] PICTURE "!";
                              SEND preBlock  := {|o| preAll( o ) } ;
                              SEND postBlock := {|o| postAll( o ) }

ENDIF

nLine++
@ nLine,23 SAY       "         xxxxxxxx:äòí"
@ nLine,32 GET aValues[3] PICTURE '99999.999';
                 SEND preBlock  := {|o| preAll( o ) } ;
                 SEND postBlock := {|o| postAll( o ) }
IF m_linemv->ptype_id == "C"
   nLine++
   @ nLine,23 SAY       "                x:TC"
   @ nLine, 39 GET aValues[2] PICTURE "!";
                              SEND preBlock  := {|o| preAll( o ) } ;
                              SEND postBlock := {|o| postAll( o ) }


   nLine++
   @ nLine,23 SAY       "                x:àåÖÖ"
   @ nLine, 39 GET aValues[1]  SEND preBlock  := {|o| preAll( o ) } ;
                               SEND postBlock := {|o| postAll( o ) }

ENDIF
nLine++
@ nLine,23 SAY       "           999999:öÖéã"
@ nLine,34 GET nQty PICTURE '999999' SEND preBlock := {|o| preQty(o) } ;
                                     SEND postBlock := {|o| postQty(o, cCode) }

nLine++
@ nLine, 23 SAY       "                x:èëáé"
@ nLine,39 GET cWh PICTURE "9" SEND postBlock := {|o| postWh(o) }

nLine++
@ nLine,18 SAY       "  xxxxxxxxxxxxxxxxxxxx:ÑòíÑ"
@ nLine,20 GET cNote SEND reader := {|o| HebReader(o) }
ELSE//////////////////////////////////////////////////////////////
@ 6,47 CLEAR TO 18 , 77
@ 6,47 TO 18 , 77  DOUBLE

IF cToran == "src"
   @ 6 , 53 SAY "∂Source B/N«"
   @ 7 , 51 SAY   "B/N      :          "
   @ 7 , 61 GET cBN PICTURE "@K XXXXX9" SEND postBlock := {|o| postbar3BN(o) }
ELSEIF cToran == "pack"
   @ 6 , 51 SAY "∂Packing B/N«"
ENDIF

@ 8 ,51 SAY       "Y        :          "
@ 8 ,61 GET aValues[6]  PICTURE "!";
                        SEND preBlock  := {|o| preAll( o ) } ;
                        SEND postBlock := {|o| postAll( o ) }

@ 9 ,51 SAY       "XX       :          "
@ 9 ,61 GET aValues[5]  SEND preBlock  := {|o| preAll( o ) } ;
                        SEND postBlock := {|o| postAll( o ) }


nLine := 9
IF m_linemv->ptype_id $ "C_L_"
   nLine++
   @ nLine,51 SAY "TOL      :           "
   @ nLine,61 GET aValues[4] PICTURE "!";
                              SEND preBlock  := {|o| preAll( o ) } ;
                              SEND postBlock := {|o| postAll( o ) }

ENDIF

nLine++
@ nLine,51 SAY    "VALUE    :           "
@ nLine,61 GET aValues[3] PICTURE '99999.999';
                 SEND preBlock  := {|o| preAll( o ) } ;
                 SEND postBlock := {|o| postAll( o ) }
IF m_linemv->ptype_id == "C"
   nLine++
   @ nLine,51 SAY "TC       :           "
   @ nLine,61 GET aValues[2] PICTURE "!";
                              SEND preBlock  := {|o| preAll( o ) } ;
                              SEND postBlock := {|o| postAll( o ) }


   nLine++
   @ nLine,51 SAY "VOLT     :           "
   @ nLine,61 GET aValues[1]  SEND preBlock  := {|o| preAll( o ) } ;
                               SEND postBlock := {|o| postAll( o ) }

ENDIF
nLine++
@ nLine,51 SAY    "QUANTITY :           "
@ nLine,61 GET nQty PICTURE '999999' SEND preBlock := {|o| preQty(o) } ;
                                     SEND postBlock := {|o| postQty(o, cCode) }

nLine++
@ nLine,51 SAY    "WAREHOUSE:           "
@ nLine,61 GET cWh PICTURE "9" SEND postBlock := {|o| postWh(o) }

nLine++
@ nLine,51 SAY    "COM:                    "
@ nLine,55 GET cNote
ENDIF/////////////////////////////////////////////////////////////

READ

IF ASCAN( aGoodKeys, LASTKEY() ) > 0
   IF cCode = "N"
      Aadd( aCurrent , { cNote , cWh , nQty , aValues[1] ,aValues[2] ,aValues[3] ,;
                       aValues[4] ,aValues[5] ,aValues[6] } )

      IF cToran == "src"
         Aadd( Atail( aCurrent ) , cBN )
      ENDIF

   ELSE
      aCurrent[i , 1 ] := cNote
      aCurrent[i , 2 ] := cWh
      aCurrent[i , 3 ] := nQty
      aCurrent[i , 4 ] := aValues[1]
      aCurrent[i , 5 ] := aValues[2]
      aCurrent[i , 6 ] := aValues[3]
      aCurrent[i , 7 ] := aValues[4]
      aCurrent[i , 8 ] := aValues[5]
      aCurrent[i , 9 ] := aValues[6]

      IF cToran == "src"
         aCurrent[i , 10 ] := cBN
      ENDIF

   ENDIF

ENDIF

RestScreen( ,,,, cScreen )
RETURN


/********************************************************************/
STATIC FUNCTION preAll(o)
SetKey( K_F2 , {|| WinAll() } )
RETURN .T.

/********************************************************************/
STATIC FUNCTION postAll(o)

LOCAL cTableName := GetTabName(o)
LOCAL lRetVal
LOCAL xKey


IF LastKey() = K_UP
   RETURN .T.
ENDIF

IF cTableName == "c_tol"
   IF lTolr := o:varGet() == "R"
      GetTolRInfo()
   ENDIF
ENDIF

IF cTableName == "c_value"
   xKey :=  Str( o:varGet(), 9 ,3 ) + d_line->ptype_id
   c_value->( ordsetfocus("ivalpr"))                   // Make sure the right index in ON
   IF Negative(o)
      RETURN .F.
   ENDIF
ELSE
   xKey := o:varGet()
ENDIF
(cTableName)->( Dbgotop())
IF (cTableName)->( DbSeek( xKey ) )
   lRetVal := .T.
   IF ToBuildEsn( cTableName )
      lRetVal := IsESN()  // check part conbined from attributes entered
   ENDIF
ELSE
   Tone( 300,2 )
   Alert( IIF(!IfEnglish() ,"èâóö Äå ","Incorrect ") + aTitles[ o:subScript[1] ] , {"..."})
   lRetVal := .F.
ENDIF
IF lRetVal
    SetKey( K_F2 , NIL )
ENDIF

RETURN lRetVal

/********************************************************************/
STATIC FUNCTION GetTabName(o)
LOCAL nIndex
IF Empty( o:cargo )
   nIndex := o:subScript[1]
ELSE
   nIndex := o:cargo
ENDIF

RETURN {"c_volt","c_tc","c_value","c_tol","c_esnxx","c_esny"}[nIndex]

/********************************************************************/
STATIC PROCEDURE WinAll
LOCAL cTableName := GetTabName(GetActive())
LOCAL cScreen := SaveScreen()
LOCAL nKey
LOCAL cBoxColor := IsColor( "W+/B" , "W+/N" )
LOCAL xPutVal,cOldOrd

IF cTableName = "c_esnxx"
   EsnxxWin()
   RestScreen( ,,,, cScreen )
   RETURN
ENDIF

cOldOrd := (cTableName)->(indexOrd())

MakeWinBrow( cTableName )
DispBox( oWin:nTop-1, oWin:nLeft-1 , oWin:nBottom+1 , oWin:nRight+1, B_SINGLE+" " , cBoxColor )

oWin:goTop()
WHILE .T.
      WHILE !oWin:stabilize() ; ENDDO

      nKey := InKey(0)

      IF nKey = K_ESC

         EXIT
      ELSEIF StdKeys( nKey , oWin )
      ELSEIF nKey = K_ENTER
             xPutVal := AllRetVal( cTAbleName )
             GetActive():varPut( xPutVal )

             EXIT
      ENDIF
ENDDO

(cTableName)->( ORDSETFOCUS(cOldOrd) )
RestScreen( ,,,, cScreen )

IF nKey = K_ENTER
   GetActive():display()
ENDIF

RETURN

STATIC FUNCTION AllRetVal ( cTableName )
LOCAL xValue

DO CASE
   CASE cTableName == "c_esny"
        xValue := c_esny->esny_id
   CASE cTableName == "c_tol"
        xValue := c_tol->tol_id
   CASE cTableName == "c_value"
        xValue := c_value->value_id
   CASE cTableName == "c_tc"
       xValue := c_tc->tc_id
   CASE cTableName == "c_volt"
       xValue := c_volt->volt_id
ENDCASE

RETURN xValue


STATIC PROCEDURE MakeWinBrow( cTableName )

LOCAL oCol
LOCAL cOldOrd

oWin := (cTableName)->( TBrowseDB(5,2,15) )

DO CASE
   CASE cTableName == "c_esny"
        SELECT c_esny
        cOldOrd := c_esny->( Ordname() )
        oWin:nRight   := 77
        oCol := TBColumnNew( " " , {|| c_esny->esny_id } )
        oWin:AddColumn( oCol )
        oCol := TBColumnNew( Padc("ESNY Name",60) , {|| c_esny->esny_nm } )
        oWin:AddColumn( oCol )
        oCol := TBColumnNew( "Qty        " , {|| Transform(c_esny->esny_qty,"999,999,999") } )
        oWin:AddColumn( oCol )
   CASE cTableName == "c_tol"
        SELECT c_tol
        cOldOrd := c_tol->(Ordsetfocus("c_ptol"))
        oWin:nRight   := 65
        oCol := TBColumnNew( " " , {|| c_tol->tol_id } )
        oWin:AddColumn( oCol )
        oCol := TBColumnNew( Padc("Tolerance  Name",60) , {|| c_tol->tol_nm } )
        oWin:AddColumn( oCol )

bKey            := COMPILE( c_tol->( IndexKey() ) )
owin:gotopBlock    := {|| c_tol->(Top(m_linemv->ptype_id))}
owin:gobottomBlock := {|| c_tol->(Bot(m_linemv->ptype_id))}
owin:skipBlock     := {|n| c_tol->(SkipIt(n,m_linemv->ptype_id,bKey))}

   CASE cTableName == "c_value"
        SELECT c_value
        cOldOrd := c_value->(OrdsetFocus("Ivalpv"))
        oWin:nRight   := 12
        oCol := TBColumnNew( "Value   " , {|| c_value->value_id } )
        oWin:AddColumn( oCol )

bKey            := COMPILE( c_value->( IndexKey() ) )
owin:gotopBlock    := {|| c_value->(Top(m_linemv->ptype_id))}
owin:gobottomBlock := {|| c_value->(Bot(m_linemv->ptype_id))}
owin:skipBlock     := {|n| c_value->(SkipIt(n,m_linemv->ptype_id,bKey))}

   CASE cTableName == "c_tc"
        SELECT c_tc
        cOldOrd := c_tc->( ORDNAME() )
        oWin:nRight   := 65
        oCol := TBColumnNew( " " , {|| c_tc->tc_id } )
        oWin:AddColumn( oCol )
        oCol := TBColumnNew( Padc("TC  Name",60) , {|| c_tc->tc_nm } )
        oWin:AddColumn( oCol )
   CASE cTableName == "c_volt"
        SELECT c_volt
        cOldOrd := c_volt->( ORDNAME() )
        oWin:nRight   := 65
        oCol := TBColumnNew( " " , {|| c_volt->volt_id } )
        oWin:AddColumn( oCol )
        oCol := TBColumnNew( Padc("Volt Name",60) , {|| c_volt->volt_nm } )
        oWin:AddColumn( oCol )
ENDCASE

RETURN

/****************************************************************/
STATIC FUNCTION IsESN( cEsn )

LOCAL aGetList := Aclone( GetList )
LOCAL nSelect := Select( Alias() )
LOCAL oTab

IF cToran == "src"
   Adel( aGetList , 1 )
   Asize( aGetList , Len( aGetList) - 1 )
ENDIF

oPart := PartBase():new()

lTolR := .F.

oPart:cPartType    := d_line->ptype_id
oPart:cEsnNo       := aGetList[2]:varGet()

oPart:cEsnPacking  := aGetList[1]:varGet()

oPart:cProductLine := d_line->pline_id
oPart:setSpecCode()

oPart:cSize  := d_line->size_id

IF m_linemv->ptype_id $ "C_L_"
   // capacitors, inductors
   oPart:cValue := Left( Ltrim( Str( aGetList[4]:varGet() , 9 , 3 )) , 5 )
    oPart:nValue := aGetList[4]:varGet()
ELSE
   // fuses
   oPart:cValue := Left( Ltrim( Str( aGetList[3]:varGet() , 9 , 3 )),5)
   oPart:nValue := aGetList[3]:varGet()
ENDIF

oPart:cValue := oPart:setValueName()
oPart:setValueType()

IF m_linemv->ptype_id $ "C_L_"
   oPart:cTolerance := aGetList[3]:varGet()
   lTolR            := aGetList[3]:varGet() == "R"
ENDIF

IF m_linemv->ptype_id == "C"
   oPart:cTemperatureCoefficient := aGetList[5]:varGet()
   oPart:cVoltage                := aGetList[6]:varGet()
ENDIF

oPart:cTerminationCode := d_line->term_id

oPart:esnNo("esn")

cEsn := oPart:cEsn

IF d_esn->( DbSeek( cEsn ) )
   oTab := TabBase():new( "m_stkmv" , {"istmvsrf" } )
   oTab:xopen()
   IF m_stkmv->( DbSeek(GetList[1]:varGet() + "   " + d_line->b_id ) ) .AND. ; // VR ID:00040603 08-04-02
		m_stkmv->sresn_id <> cEsn
      IIF(!IfEnglish(),;
			               Alert( " òÖóéÑ öêé ESN é ÑêÖô èÜÖÑô ESN " , {"òÉëÅ"} ),;
								Alert( "Entered ESN is different from the source batch ESN" , {"OK"} ))
   ENDIF
   oTab:close()
ELSE
   IIF(!IfEnglish(),Alert( cEsn +" :çâàâòîÑ öåÅàÅ Äñéê Äå àâòî" , {"..."} ),;
                    Alert( "ESN " + cEsn +" not found in ESN file", {"..."} ))
ENDIF

SELECT (nSelect)

RETURN d_esn->( Found() )

STATIC FUNCTION postWh(o)

LOCAL lRetVal
LOCAL cTol := ""
LOCAL cBuffer, cYcode := GetList[1]:varGet()

IF LastKey() = K_UP
   RETURN .T.
ENDIF

cBuffer := o:varGet()

IF cBuffer $ "1_2_4_9_6"
   IF d_line->ptype_id $ "C_L_"
      IF cToran = "src"
         cTol := GetList[4]:varGet()
      ELSE
         cTol := GetList[3]:varGet()
      ENDIF
   ENDIF
   lRetVal := .T.

   IF cTol == "R" .AND.  cBuffer != "9"
      IIF(!IfEnglish(),Alert( "9 èëáéå óò R ëêòåÖà áÖÖâÉ" , {"..."} ),;
			              Alert( "Tolerance R should only be entered into WH 9" , {"..."} ))
      RETURN .F.
   ENDIF

   IF cBuffer = "9" .AND. cTol != "R"
      IIF(!IfEnglish(),Alert( "R ëêòåÖàå óò 9 èëáé áÖÖâÉ" , {"..."} ),;
							  Alert( "Tolerance R should only be entered into warehouse 9" , {"..."} ))
      RETURN .F.
   ENDIF

   IF cYcode = "V"  .AND. ! (cBuffer  $ "1_9_2")               // Stop QC defining new "V" Y code to WH 1
      IIF(!IfEnglish(),Alert( "ÉÅåÅ 9 ÖÄ 1 èëáéå Y='V' ÉÖó áÖÖâÉ" , {"..."} ),;
			              Alert( "Y  code 'V' should only be entered into warehouses 1,9,2" , {"..."} ))// 8-7-99 D.Laor
      RETURN .F.
   ENDIF

   DO CASE
      CASE c_esny->lpflag == "P"
           IF cBuffer $ "_2_"
              IIF(!IfEnglish(),Alert( " 4 ÖÄ  3 :èëáéå óò áÖÖâÉ" , {"..."} ),;
                               Alert( "Only warehouses 3 and 4 are allowed" , {"..."} ))
              lRetVal := .F.
			  ELSEIF cBuffer $ "_1_" .AND. !c_esny->esny_id $ "3,R,S,T,U,,4,7,B,C,D,H,Z"
               IIF(!IfEnglish(),Alert( " 4 ÖÄ  3 :èëáéå óò áÖÖâÉ" , {"..."} ),;
                               Alert( "Only warehouses 3 and 4 are allowed" , {"..."} ))
				  lRetVal := .F.
           ELSE
              lRetVal := .T.
           ENDIF
      CASE c_esny->lpflag != "P"
           IF cBuffer $ "3_4_"
              IIF(!IfEnglish(),Alert( " 2 ÖÄ  1 :èëáéå óò áÖÖâÉ" , {"..."} ),;
						             Alert( " Only warehouses 1 and 2 are allowed" , {"..."} ))
              lRetVal := .F.
			  ELSEIF cBuffer $ "_2_" .AND. !c_esny->esny_id $ "1V"
              IIF(!IfEnglish(),Alert( " 2 ÖÄ  1 :èëáéå óò áÖÖâÉ" , {"..."} ),;
						             Alert( " Only warehouses 1 and 2 are allowed" , {"..."} ))
              lRetVal := .F.
           ELSE
              lRetVal := .T.
           ENDIF
   ENDCASE
ELSE
   lRetVal := .F.
   IIF(!IfEnglish(),Alert( "1  2  3  4  9  6:çâêëáéå çâòöÖé çâÉÖó" , {"..."} ),;
                    Alert( "Allowed warehouses are 1,2,3,4,9,6" , {"..."} ))
ENDIF

RETURN lRetVal


STATIC FUNCTION preQty(o)
SetKey( K_F2 , NIL )
RETURN .T.


STATIC FUNCTION postQty(o, cCode)

LOCAL nQty := o:varGet()
LOCAL nWh  := 0
LOCAL nConverted := 0

IF LastKey() = K_UP
   RETURN .T.
ENDIF

IF Negative( o )
   RETURN .F.
ENDIF

IF Empty( nQty )
   IIF( !IfEnglish(),Alert( "çâÅâãò öÖéã ôâóÑå ôâ" , {"..."} ) ,;
		               Alert( "Zero or negative quantity not allowed" , {"..."} ) )
   RETURN .F.
ENDIF

IF c_esny->lpflag == "P" .AND. !lTolR
   IF !Empty( nQty % c_esny->esny_qty )
		IF !IfEnglish()
		Alert( "        öáÄ ÑÜâòÄå öÖéã åô öÖåîãéÅ çâêÖöê ôóÑ;" +;
            Transform( c_esny->esny_qty, "999,999,999") + " - ÄâÑ ÖÜ ÑÜâòÄ öÉâáâå öÖéã  :ÖêââÑÉ;"+;
            "öâòÄô Äåå Ñåîãéå íâÇÑå öêé åí "+ Ltrim( Transform(nQty-(nQty % c_esny->esny_qty),"999,999,999"))+":öâàéÖàÖÄ ÖôóÖâ",{"..."})
		ELSE
		Alert( "Enter Quantity in multiples of " + Transform( c_esny->esny_qty, "999,999,999") + ";    Quantity is rounded to nearest multiples of "+;
              Ltrim( Transform(nQty-(nQty % c_esny->esny_qty),"999,999,999")),{"..."})
		ENDIF
            Tone( 300,2 )
            o:varPut( nQty-(nQty % c_esny->esny_qty ) )
      RETURN .F.
   ENDIF
ENDIF

IF !QtyOk( o, IF( cCode == "U", .T., .F. ) )
   IF d_line->cpproc_id="196.0"         // Use a diff. message for closing a batch
     IF d_line->uom_ini<>"P"  // In case of pieces I dont have to convert
          nConverted := QtyConvert(d_line->qty_bini,d_line->b_type,d_line->pline_id,d_line->size_id,d_line->uom_ini,"P",,,m_linemv->route_id,m_linemv->value_id)
     ELSE
          nConverted := d_line->qty_bini
     ENDIF

	  IF !IfEnglish()
	      Alert(  Transform(nConverted , "9,999,999")+;
                ":ÑêéÑ åô öâöåáöÑ öÖéãÑ öÄ öòÅÖí Ñã Éí öáÖÖÉé öÖéã",{"..."})
	  ELSE
	      Alert( "The reported quantity exeeds the initial batch quantity:"+Transform(nConverted , "9,999,999"),{"..."})
	  ENDIF

   ELSE
     IF !IfEnglish()
	      Alert(  Transform(m_linemv->cp_bqtyp , "9,999,999")+;
                ": Ååôå ÑëâêãÅ öÖéãÑ öÄ öòÅÖí Ñã Éí öáÖÖÉé öÖéã;",{"..."})
	  ELSE
	      Alert("The reported quantity exeeds the initial quantity of current stage:"+Transform(m_linemv->cp_bqtyp , "9,999,999"),{"..."})
	  ENDIF
   ENDIF
   RETURN .F.
ENDIF

IF lTolR
   IF cToran = "src"
      nsTolrQty := nQty
   ELSE
      nTolrQty := nQty
   ENDIF
ENDIF

RETURN .T.

STATIC FUNCTION QtyOk( o, lEdit )

LOCAL nQty := o:varget()
LOCAL lRetVal
LOCAL aRej := GetRegularRej()
LOCAL nConverted

 Aeval( aStock , {|el,i| nQty += el[3] } )

IF !Empty( aRej )
   Aeval( aRej , {|el| nQty += el[5] } )
ENDIF
IF lEdit // added 14-01-97 by Shalom
   nQty -= o:original
ENDIF
// QC's stage 196.0 can report qtys. bigger than the previous process
// BUT NO MORE than the initial qty. of the batch. ID:98032207
// D.Laor 29/06/98
IF d_line->cpproc_id="196.0"
     IF d_line->uom_ini<>"P"  // In case of pieces I dont have to convert
          nConverted := QtyConvert(d_line->qty_bini,d_line->b_type, d_line->pline_id,d_line->size_id,d_line->uom_ini,"P",,,m_linemv->route_id,m_linemv->value_id)
     ELSE
          nConverted := d_line->qty_bini
     ENDIF
     lRetVal := ( nQty <= nConverted )
ELSE
     lRetVal := ( nQty <= m_linemv->cp_bqtyp)
ENDIF


RETURN lRetVal


STATIC PROCEDURE EsnxxWin
LOCAL nKey

@ 4 , 2 CLEAR TO  16 , 73
@ 4 , 2  TO  16 , 73
IF !ifEnglish()
   @ 15,3 SAY "Enter-ÑòâáÅ Esc-ÑòâáÅ Äåå ÑÄñâ PgDn-ÄÅÑ PgUp-çÉÖó Home-èÖôÄò End-èÖòáÄ" COLOR If( IsColor() , "W+/B" , "W+/N" )
ELSE
	@ 15,3 SAY "Enter-Choose Esc-Esc w/out Choose PgDn-Next PgUp-Prev Home-First End-Last" COLOR If( IsColor() , "W+/B" , "W+/N" )
ENDIF

WHILE .T.

   @ 5 ,3 SAY "ESN(XX) :"+c_esnxx->esnxx_id COLOR If( IsColor() , "W+/B" , "W+/N" )
   @ 6 ,3 SAY "ESN Name:"+c_esnxx->esnxx_nm COLOR If( IsColor() , "W+/B" , "W+/N" )
   @ 7 ,3 SAY "Title 1 :"+c_esnxx->esnxxtl1 COLOR If( IsColor() , "W+/B" , "W+/N" )
   @ 8 ,3 SAY "Title 2 :"+c_esnxx->esnxxtl2 COLOR If( IsColor() , "W+/B" , "W+/N" )
   @ 9 ,3 SAY "Title 3 :"+c_esnxx->esnxxtl3 COLOR If( IsColor() , "W+/B" , "W+/N" )
   @ 10,3 SAY "Title 4 :"+c_esnxx->esnxxtl4 COLOR If( IsColor() , "W+/B" , "W+/N" )
   @ 11,3 SAY "Title 5 :"+c_esnxx->esnxxtl5 COLOR If( IsColor() , "W+/B" , "W+/N" )
   @ 12,3 SAY "Title 6 :"+c_esnxx->esnxxtl6 COLOR If( IsColor() , "W+/B" , "W+/N" )
   @ 13,3 SAY "Title 7 :"+c_esnxx->esnxxtl7 COLOR If( IsColor() , "W+/B" , "W+/N" )

   nKey := InKey(0)

   DO CASE
      CASE nKey = K_ESC
           EXIT
      CASE nKey = K_ENTER
           GetActive():varPut( c_esnxx->esnxx_id )
           EXIT
      CASE nKey = K_PGUP
           c_esnxx->( DbSkip( -1 ) )
           IF c_esnxx->( Bof() )
              Tone( 300, 3 )
              c_esnxx->( DbGoTop() )
           ENDIF
      CASE nKey = K_PGDN
           c_esnxx->( DbSkip( 1 ) )
           IF c_esnxx->( Eof() )
              Tone( 300, 3 )
              c_esnxx->( DbGoBottom() )
           ENDIF
      CASE nKey = K_HOME
           c_esnxx->( DbGoTop() )
      CASE nKey = K_END
           c_esnxx->( DbGoBottom() )
   ENDCASE
ENDDO
RETURN

STATIC PROCEDURE GetTolRInfo
LOCAL cScreen := SaveScreen()
LOCAL aGetList := GetList
LOCAL cxCodeM    := "    "      ,;
      cxCodeDoc  := "      "    ,;
      cxScrNote  := Space(14)

GetList := {}

IF !ifEnglish()
   @ 8 , 20 SAY "…ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕª"  COLOR If( IsColor() , "W+/B" , "W+/N" )
   @ 9 , 20 SAY "∫               Ñåâëî áÖÖâÉ                ∫"  COLOR If( IsColor() , "W+/B" , "W+/N" )
   @ 10, 20 SAY "«ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ∂"  COLOR If( IsColor() , "W+/B" , "W+/N" )
   @ 11, 20 SAY "∫                           :ÉÖó           ∫"  COLOR If( IsColor() , "W+/B" , "W+/N" )
   @ 12, 20 SAY [∫                           :ÑéÄöÑ âÄ á"ÖÉ ∫]  COLOR If( IsColor() , "W+/B" , "W+/N" )
   @ 13, 20 SAY "∫                           :ìëÖê òÖÄö     ∫"  COLOR If( IsColor() , "W+/B" , "W+/N" )
   @ 14, 20 SAY "∫ F2-çâÉÖó èÖåá                            ∫"  COLOR If( IsColor() , "W+/B" , "W+/N" )
   @ 15, 20 SAY "»ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº"  COLOR If( IsColor() , "W+/B" , "W+/N" )

   @ 11, 44 GET cxCodeM    PICTURE "!999"  SEND preBlock  := {|o| preRej(o) } ;
                                          SEND postBlock := {|o| postRej(o)}

   @ 12, 42 GET cxCodeDoc  PICTURE "!99999"

   @ 13, 34 GET cxScrNote  SEND reader := {|o| HebReader(o) }
ELSE
   @ 8 , 20 SAY "…ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕª"  COLOR If( IsColor() , "W+/B" , "W+/N" )
   @ 9 , 20 SAY "∫               Scrap Report               ∫"  COLOR If( IsColor() , "W+/B" , "W+/N" )
   @ 10, 20 SAY "«ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ∂"  COLOR If( IsColor() , "W+/B" , "W+/N" )
   @ 11, 20 SAY "∫ Scrap Code:                              ∫"  COLOR If( IsColor() , "W+/B" , "W+/N" )
   @ 12, 20 SAY [∫ Non Conformity report No:                ∫]  COLOR If( IsColor() , "W+/B" , "W+/N" )
   @ 13, 20 SAY "∫ Additional Descrip.:                     ∫"  COLOR If( IsColor() , "W+/B" , "W+/N" )
   @ 14, 20 SAY "∫ F2-Codes Window                          ∫"  COLOR If( IsColor() , "W+/B" , "W+/N" )
   @ 15, 20 SAY "»ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº"  COLOR If( IsColor() , "W+/B" , "W+/N" )

   @ 11, 34 GET cxCodeM    PICTURE "!999"  SEND preBlock  := {|o| preRej(o) } ;
                                          SEND postBlock := {|o| postRej(o)}

   @ 12, 50 GET cxCodeDoc  PICTURE "!99999"

   @ 13, 43 GET cxScrNote
ENDIF

READ

GetList := aGetList
RestScreen( ,,,, cScreen )

IF cToran == "src"
   csCodeM    := cxCodeM
   csCodeDoc  := cxCodeDoc
   csScrNote  := cxScrNote
ELSE
   cCodeM    := cxCodeM
   cCodeDoc  := cxCodeDoc
   cScrNote  := cxScrNote
ENDIF

RETURN

PROCEDURE LastStep

IF !IfEnglish()
   @ 24,0 SAY Padc( "ç â ñ Å ó    è Ö ã É í" ,80 ) COLOR If(IsColor(),"W+/B","W+/N")
ELSE
	@ 24,0 SAY Padc( "Update files" ,80 ) COLOR If(IsColor(),"W+/B","W+/N")
ENDIF

IF DoFinQc()
   DoRejAll()
   DoLineMove()
   ShowQcDoc("d_finqc")
   d_finqc->( DbCloseArea() )
ENDIF

RETURN

STATIC FUNCTION DoFinQc
LOCAL i , nLen , cEsn//,hOutFile
local cTempDir := GetUserInfo():cDbfDir+"ftp\out\"
LOCAL aBNWid := GetBNWid()
local vNewSn,nCount := 0
local HVal_DT := 0.00
local LVal_DT := 0.00

c_pline->(ordsetfocus(1))

IF Empty(d_line->HVal_dt) .AND. "CP" $ d_line->esn_id .AND. d_line->size_id $ "0805_0603_0402"
	IF Empty(d_line->value_id) .AND. c_pline->(dbseek(d_line->pline_id+d_line->size_id))
	   HVal_DT := c_pline->HVal_DT
	   LVal_DT := c_pline->LVal_DT
	ELSEIF !Empty(d_line->value_id)
		HVal_DT := d_line->value_id * 1.1
		LVal_DT := d_line->value_id * 0.9
	ELSE
		Alert("No DT specs!!!",{"Call MIS"})
	ENDIF
	@12, 20 CLEAR TO 17, 55
	DrawBox( 12, 20, 17, 55 )

	@12, 22 SAY "High & Low values must be entered"

	@14, 30 SAY "High   : " GET HVal_DT PICTURE  "9999.999" VALID !Empty(HVal_DT)
	@15, 30 SAY "Low    : " GET LVal_DT PICTURE  "9999.999" VALID LVal_DT <= HVal_DT

	READ

	if d_line->( RecLock(5) )
	   d_line->HVal_dt := HVal_DT
	   d_line->LVal_dt := LVal_DT
	   d_line->( DbUnLock() )
	endif

ENDIF

NetUse( "n_iswip", STD_RETRY, RDD_IN_USE, USE_EXCLUSIVE, USE_NEW, NIL )

vNewSn := n_iswip->counter + 1
n_iswip->counter := vNewSn
n_iswip->( DBCOMMIT() )
n_iswip->(dbclosearea())

GenOpenFiles({"d_finqc"})

nLen := Len( aStock )
/*IF ascan(aStock,{|aVal| aVal[2] $ "3_4"}) > 0
	hOutFile := fcreate(cTempDir+"W"+aBNWid[1])
ENDIF*/

FOR i := 1  TO nLen
    IF d_finqc->( AddRec( 5 ) )
	  IF d_line->ptype_id $ "XDS"
		  cEsn := d_line->esn_id
		  d_finqc->fin_type    := "1"
		  d_finqc->b_id        := aBNWid[1]     // BN entered by operator

		  IF cCaps != NIL
		     d_finqc->b_ncaps     := cCaps
		  ENDIF

		  d_finqc->esn_id      := cEsn
		  d_finqc->ptype_id    := d_line->ptype_id
		  d_finqc->pline_id    := d_line->pline_id
		  d_finqc->size_id     := d_line->size_id
		  d_finqc->HVal_DT     := d_line->HVal_DT
		  d_finqc->LVal_DT     := d_line->LVal_DT
		  d_finqc->value_id    := d_line->value_id
		  d_finqc->volt_id     := d_line->volt_id
		  d_finqc->tol_id      := d_line->tol_id
		  d_finqc->tc_id       := d_line->tc_id
		  d_finqc->term_id     := d_line->term_id
		  d_finqc->esnxx_id    := d_line->esnxx_id
		  d_finqc->esny_id     := d_line->esny_id
		  d_finqc->qc_qty      := aStock[i,3]
		  d_finqc->wh          := aStock[i,2]
		  d_finqc->qc_com      := aStock[i,1]
		  d_finqc->cp_widfin   := aBNWid[2]      // WID entered by operator
		  d_finqc->b_dqc       := Date()
		  d_finqc->b_tqc       := Left( Time() , 5 )
	  ELSE
       cEsn := MakeESN( aStock[i] )

       d_finqc->fin_type    := "1"
       d_finqc->b_id        := aBNWid[1]     // BN entered by operator

       IF cCaps != NIL
          d_finqc->b_ncaps     := cCaps
       ENDIF

       d_finqc->esn_id      := cEsn
       d_finqc->ptype_id    := oPart:cPartType
       d_finqc->pline_id    := d_line->pline_id
       d_finqc->size_id     := d_line->size_id
		 d_finqc->HVal_DT     := d_line->HVal_DT
		 d_finqc->LVal_DT     := d_line->LVal_DT
       d_finqc->value_id    := oPart:nValue
       d_finqc->volt_id     := oPart:cVoltage
       d_finqc->tol_id      := oPart:cTolerance
       d_finqc->tc_id       := oPart:cTemperatureCoefficient
       d_finqc->term_id     := oPart:cTerminationCode
       d_finqc->esnxx_id    := oPart:cEsnNo
       d_finqc->esny_id     := oPart:cEsnPacking
       d_finqc->qc_qty      := aStock[i,3]
       d_finqc->wh          := aStock[i,2]
       d_finqc->qc_com      := aStock[i,1]
       d_finqc->cp_widfin   := aBNWid[2]      // WID entered by operator
       d_finqc->b_dqc       := Date()
       d_finqc->b_tqc       := Left( Time() , 5 )
	  ENDIF
       d_finqc->( DbUnLock() )
		 /*IF aStock[i,2] $ "3_4"
			 nCount++
			 fwrite(hOutFile,'01 '+ aBNWid[1]+cEsn+str(aStock[i,3])+EOL)
		 ENDIF*/

    ENDIF

NEXT

//fwrite(hOutFile,'02 '+ str(nCount,2)+EOL)
//fclose(hOutFile)

//copy file (cTempDir+"W"+aBNWid[1]) to (cTempDir+'iswip.m'+padl(alltrim(str(vNewSn)),9,"0"))

IF lRegularRej
   aRegularRej   := GetRegularRej()
   nLen := Len( aRegularRej )
   FOR i := 1 TO nLen
       IF d_finqc->( AddRec( 5 ) )

          D_FINQC->FIN_TYPE    := "1"
          D_FINQC->B_ID        := aBNWid[1]     // BN entered by operator

          IF cCaps != NIL
             D_FINQC->B_NCAPS     := cCaps
          ENDIF

          D_FINQC->PTYPE_ID    := d_line->ptype_id
          D_FINQC->PLINE_ID    := d_line->pline_id
          D_FINQC->SIZE_ID     := d_line->size_id
			 d_finqc->HVal_DT     := d_line->HVal_DT
			 d_finqc->LVal_DT     := d_line->LVal_DT
          D_FINQC->QC_QTY      := aRegularRej[i,5]
          D_FINQC->QC_COM      := aRegularRej[i,1]
          D_FINQC->CP_WIDFIN   := aBNWid[2]      // WID entered by operator
          D_FINQC->B_DQC       := Date()
          D_FINQC->B_TQC       := Left( Time() , 5 )

          d_finqc->( DbUnLock() )
       ENDIF
   NEXT
 lRegularRej:=.F.
ENDIF



RETURN .T.
///////////////////////////////////////////////////
STATIC FUNCTION DoKitFinQc
LOCAL i , nLen , cEsn//,hOutFile
LOCAL aBNWid := GetBNWid()
local cTempDir := GetUserInfo():cDbfDir+"ftp\out\"

local vNewSn,nCount := 0

NetUse( "n_iswip", STD_RETRY, RDD_IN_USE, USE_EXCLUSIVE, USE_NEW, NIL )

vNewSn := n_iswip->counter + 1
n_iswip->counter := vNewSn
n_iswip->( DBCOMMIT() )
n_iswip->(dbclosearea())


IF len(genOpenFiles({"d_finqc"})) = 0
   RETURN .F.
ENDIF

nLen := Len( aStock )

/*IF ascan(aStock,{|aVal| aVal[2] $ "3_4"}) > 0
	hOutFile := fcreate(cTempDir+"W"+aBNWid[1])
ENDIF*/


FOR i := 1  TO nLen
    IF d_finqc->( AddRec( 5 ) )
		  cEsn := AllTrim(aStock[i,4])+aStock[i,5]+aStock[i,6]
       d_finqc->fin_type    := "4"
       d_finqc->b_id        := aBNWid[1]     // BN entered by operator

       d_finqc->esn_id      := AllTrim(aStock[i,4])+aStock[i,5]+aStock[i,6]
       d_finqc->ptype_id    := d_line->ptype_id
       d_finqc->pline_id    := d_line->pline_id
       d_finqc->size_id     := d_line->size_id
       d_finqc->value_id    := d_line->value_id
       d_finqc->volt_id     := d_line->volt_id
       d_finqc->tol_id      := d_line->tol_id
       d_finqc->tc_id       := d_line->tc_id
       d_finqc->term_id     := d_line->term_id
       d_finqc->esnxx_id    := aStock[i,5]
       d_finqc->esny_id     := aStock[i,6]
       d_finqc->qc_qty      := aStock[i,3]
       d_finqc->wh          := aStock[i,2]
       d_finqc->qc_com      := aStock[i,1]
       d_finqc->cp_widfin   := aBNWid[2]      // WID entered by operator
       d_finqc->b_dqc       := Date()
       d_finqc->b_tqc       := Left( Time() , 5 )

		 /*IF aStock[i,2] $ "3_4"
		    nCount++
		    fwrite(hOutFile,'01 '+ aBNWid[1]+cEsn+str(aStock[i,3])+EOL)
		 ENDIF*/

		 d_finqc->( DbUnLock() )

    ENDIF

NEXT

//fwrite(hOutFile,'02 '+ str(nCount,2)+EOL)
//fclose(hOutFile)


RETURN .T.
/////////////////////////////////////////////////////
STATIC FUNCTION DoPackFinQc
LOCAL i , nLen , cEsn//,hOutFile
LOCAL aBNWid := GetBNWid()
LOCAL aTemp
local cTempDir := GetUserInfo():cDbfDir+"ftp\out\"
local vNewSn,nCount := 0

local HVal_DT := 0.00
local LVal_DT := 0.00

c_pline->(ordsetfocus(1))

IF Empty(d_line->HVal_dt) .AND. "CP" $ d_line->esn_id .AND. d_line->size_id $ "0805_0603_0402"
	IF Empty(d_line->value_id) .AND. c_pline->(dbseek(d_line->pline_id+d_line->size_id))
	   HVal_DT := c_pline->HVal_DT
	   LVal_DT := c_pline->LVal_DT
	ELSEIF !Empty(d_line->value_id)
		HVal_DT := d_line->value_id
		LVal_DT := d_line->value_id
	ELSE
		Alert("No DT specs!!!",{"Call MIS"})
	ENDIF
	@12, 20 CLEAR TO 17, 55
	DrawBox( 12, 20, 17, 55 )

	@12, 22 SAY "High & Low values must be entered"

	@14, 30 SAY "High   : " GET HVal_DT PICTURE  "9999.999" VALID !Empty(HVal_DT)
	@15, 30 SAY "Low    : " GET LVal_DT PICTURE  "9999.999" VALID LVal_DT <= HVal_DT

	READ

	if d_line->( RecLock(5) )
	   d_line->HVal_dt := HVal_DT
	   d_line->LVal_dt := LVal_DT
	   d_line->( DbUnLock() )
	endif

ENDIF

NetUse( "n_iswip", STD_RETRY, RDD_IN_USE, USE_EXCLUSIVE, USE_NEW, NIL )

vNewSn := n_iswip->counter + 1
n_iswip->counter := vNewSn
n_iswip->( DBCOMMIT() )
n_iswip->(dbclosearea())


IF len(genOpenFiles({"d_finqc"})) = 0
   RETURN .F.
ENDIF

// runs on pack BN
nLen := Len( aStock )

/*IF ascan(aStock,{|aVal| aVal[2] $ "3_4"}) > 0
	hOutFile := fcreate(cTempDir+"W"+aBNWid[1])
ENDIF*/

FOR i := 1  TO nLen
    IF d_finqc->( AddRec( 5 ) )
		IF d_line->ptype_id $ "XD"
         cEsn := d_line->esn_id

         d_finqc->fin_type    := "2"
         d_finqc->b_id        := aBNWid[1]     // BN entered by operator
         d_finqc->packb_id    := aBNWid[1]     // BN entered by operator

         d_finqc->esn_id      := cEsn
         d_finqc->ptype_id    := d_line->ptype_id
         d_finqc->pline_id    := d_line->pline_id
         d_finqc->size_id     := d_line->size_id
		   d_finqc->HVal_DT     := d_line->HVal_DT
		   d_finqc->LVal_DT     := d_line->LVal_DT
         d_finqc->value_id    := d_line->value_id
         d_finqc->volt_id     := d_line->volt_id
         d_finqc->tol_id      := d_line->tol_id
         d_finqc->tc_id       := d_line->tc_id
         d_finqc->term_id     := d_line->term_id
         d_finqc->esnxx_id    := d_line->esnxx_id
         d_finqc->esny_id     := d_line->esny_id
         d_finqc->qc_qty      := aStock[i,3]
         d_finqc->wh          := aStock[i,2]
         d_finqc->qc_com      := aStock[i,1]
         d_finqc->cp_widfin   := aBNWid[2]      // WID entered by operator
         d_finqc->b_dqc       := Date()
         d_finqc->b_tqc       := Left( Time() , 5 )
		ELSE
			cEsn := MakeESN( aStock[i] )

			d_finqc->fin_type    := "2"
			d_finqc->b_id        := aBNWid[1]     // BN entered by operator
			d_finqc->packb_id    := aBNWid[1]     // BN entered by operator

			d_finqc->esn_id      := cEsn
			d_finqc->ptype_id    := oPart:cPartType
			d_finqc->pline_id    := d_line->pline_id
			d_finqc->size_id     := d_line->size_id
			d_finqc->HVal_DT     := d_line->HVal_DT
			d_finqc->LVal_DT     := d_line->LVal_DT
			d_finqc->value_id    := oPart:nValue
			d_finqc->volt_id     := oPart:cVoltage
			d_finqc->tol_id      := oPart:cTolerance
			d_finqc->tc_id       := oPart:cTemperatureCoefficient
			d_finqc->term_id     := oPart:cTerminationCode
			d_finqc->esnxx_id    := oPart:cEsnNo
			d_finqc->esny_id     := oPart:cEsnPacking
			d_finqc->qc_qty      := aStock[i,3]
			d_finqc->wh          := aStock[i,2]
			d_finqc->qc_com      := aStock[i,1]
			d_finqc->cp_widfin   := aBNWid[2]      // WID entered by operator
			d_finqc->b_dqc       := Date()
			d_finqc->b_tqc       := Left( Time() , 5 )
		ENDIF
		 /*IF aStock[i,2] $ "3_4"
		    nCount++
		    fwrite(hOutFile,'01 '+ aBNWid[1]+cEsn+str(aStock[i,3])+EOL)
		 ENDIF*/

		 d_finqc->( DbUnLock() )

    ENDIF

NEXT

//fwrite(hOutFile,'02 '+ str(nCount,2)+EOL)
//fclose(hOutFile)


// runs on source BN
nLen := Len( aSourceBN )
FOR i := 1  TO nLen
    IF d_finqc->( AddRec( 5 ) )
       cEsn := MakeESN( aSourceBN[i] )

       d_finqc->fin_type    := "3"
       d_finqc->b_id        := Atail(aSourceBN[i])  // source BN
       d_finqc->packb_id    := aBNWid[1]           // BN entered by operator

       d_finqc->esn_id      := cEsn
       d_finqc->ptype_id    := oPart:cPartType
       d_finqc->pline_id    := d_line->pline_id
       d_finqc->size_id     := d_line->size_id
		 d_finqc->HVal_DT     := d_line->HVal_DT
		 d_finqc->LVal_DT     := d_line->LVal_DT
       d_finqc->value_id    := oPart:nValue
       d_finqc->volt_id     := oPart:cVoltage
       d_finqc->tol_id      := oPart:cTolerance
       d_finqc->tc_id       := oPart:cTemperatureCoefficient
       d_finqc->term_id     := oPart:cTerminationCode
       d_finqc->esnxx_id    := oPart:cEsnNo
       d_finqc->esny_id     := oPart:cEsnPacking
       d_finqc->qc_qty      := aSourceBN[i,3]
       d_finqc->wh          := aSourceBN[i,2]
       d_finqc->qc_com      := aSourceBN[i,1]
       d_finqc->cp_widfin   := aBNWid[2]      // WID entered by operator
       d_finqc->b_dqc       := Date()
       d_finqc->b_tqc       := Left( Time() , 5 )

       d_finqc->( DbUnLock() )

    ENDIF

NEXT

IF lRegularRej
   aRegularRej   := GetRegularRej()
   nLen := Len( aRegularRej )
   FOR i := 1 TO nLen
       IF d_finqc->( AddRec( 5 ) )

          D_FINQC->FIN_TYPE    := aRegularRej[i,7]
          D_FINQC->B_ID        := aBNWid[1]     // BN entered by operator

          D_FINQC->PTYPE_ID    := d_line->ptype_id
          D_FINQC->PLINE_ID    := d_line->pline_id
          D_FINQC->SIZE_ID     := d_line->size_id
			 d_finqc->HVal_DT     := d_line->HVal_DT
			 d_finqc->LVal_DT     := d_line->LVal_DT
          D_FINQC->QC_QTY      := aRegularRej[i,5]
          D_FINQC->QC_COM      := aRegularRej[i,1]
          D_FINQC->CP_WIDFIN   := aBNWid[2]      // WID entered by operator
          D_FINQC->B_DQC       := Date()
          D_FINQC->B_TQC       := Left( Time() , 5 )

          d_finqc->( DbUnLock() )

       ENDIF
   NEXT
lRegularRej := .f.
ENDIF

RETURN .T.



/*************************************************************/
STATIC FUNCTION MakeESN( aLine )

oPart := PartBase():new()

oPart:cPartType               := d_line->ptype_id
oPart:cEsnPacking             := aLine[9]
oPart:cEsnNo                  := aLine[8]

oPart:cProductLine            := d_line->pline_id
oPart:setSpecCode()

IF d_line->ptype_id = "L"
   oPart:newAccuLTech()
ENDIF

oPart:cSize                   := d_line->size_id

IF m_linemv->ptype_id $ "C_L_"
   // capacitors
   // inductors
   oPart:cValue                  := Left( Ltrim( Str( aLine[6] , 8 , 4 )) , 3 )
ELSE
   // fuses
   oPart:cValue                  := Left( Ltrim( Str( aLine[6] , 8 , 4 )),4)
ENDIF

oPart:nValue := aLine[6]
oPart:cValue := oPart:setValueName()
oPart:setValueType()

IF m_linemv->ptype_id $ "C_L_"
   oPart:cTolerance              := aLine[7]
ELSE
   oPart:cTolerance              := ""
ENDIF

IF m_linemv->ptype_id == "C"
   oPart:cTemperatureCoefficient := aLine[5]
   oPart:cVoltage                := aLine[4]
ELSE
   oPart:cTemperatureCoefficient := ""
   oPart:cVoltage                := ""
ENDIF

oPart:cTerminationCode        := d_line->term_id

oPart:esnNo("esn")

RETURN oPart:cEsn

STATIC PROCEDURE DoRejAll
LOCAL i , nLen , nTotalGood := 0

// NetUse( "d_rejrep" , 5 )
Genopenfiles({"d_rejrep"})
// tol R
IF !Empty( cCodeM )
    IF d_rejrep->( AddRec( 5 ) )
       d_rejrep->B_ID      := m_linemv->b_id
       d_rejrep->CP_STAGE  := m_linemv->cp_stage
       d_rejrep->CPPROC_ID := m_linemv->cpproc_id
       d_rejrep->REJ_UNIT  := "R"
       d_rejrep->QTY_REJ   := nTolRQty
       d_rejrep->REJ_ID    := cCodeM
       d_rejrep->DISCR_REP := cCodeDoc
       d_rejrep->REJ_COM   := cScrNote
    ENDIF
ENDIF

// scraped not in use
Aeval( aStock , {|el,i| nTotalGood += el[3] } ) // sum qty entered
nRejected := (m_linemv->cp_bqtyp - nTotalGood) // calc how many rejctions you can enter

IF !Empty( nRejected )

   SetRejEob( .T. )
   lRegularRej := SetRejected( nRejected )  //

   ScrapUpdate()

   lRegularRej := SetRejected( 0 ) // lRegularRej saves if there are any rejected p
   SetRejEob( .F. )

ENDIF

d_rejrep->( DbCloseArea() )

RETURN


STATIC PROCEDURE DoLineMove
LOCAL nPQtyp := 0 ,;
      nPqtyw      ,;
      nPqtys

LOCAL cTmpProc,dExpDate := DATE()
LOCAL cCpTfin := Left( Time() , 5 )

Aeval(aStock,{|el|nPQtyp+=el[3]}) // sum qty entered

IF cToran = "src"
   Aeval(aSourceBN,{|el|nPQtyp+=el[3]}) // sum qty entered
ENDIF
                                                               // exclude tol R
IF m_linemv->( RecLock( 5 ) )

   nPqtyw := QtyConvert(nPQtyp,m_linemv->b_type, m_linemv->pline_id,;
                      m_linemv->size_id,"P","W",,,m_linemv->route_id,m_linemv->value_id)

   nPqtys := QtyConvert(nPQtyp,m_linemv->b_type, m_linemv->pline_id,;
                      m_linemv->size_id,"P","S",,,m_linemv->route_id,m_linemv->value_id)

   m_linemv->fin       := .T.
   m_linemv->cp_dfin   := Date()
   m_linemv->cp_tfin   := cCpTfin
   m_linemv->cp_widfin := GetBNWid()[2]
   GetUserInfo():updateUserInRec("m_linemv","BMSBAR3",.F.)

   IF !Empty( nRejected )
      m_linemv->cp_totscr := nRejected
   ENDIF

   IF !Empty( cCodeM )
      m_linemv->b_lrej    := cCodeM
   ENDIF

   IF !Empty( cCodeDoc )
      m_linemv->discr_rep := cCodeDoc
   ENDIF

   m_linemv->( DbUnLock() )
ENDIF

// d_line

IF d_line->( RecLock() )
   d_line->ppproc_id  := m_linemv->cpproc_id
   d_line->pp_pccode  := m_linemv->cp_pccode
   d_line->pp_wkstn   := m_linemv->cpwkstn_id
   d_line->pp_darr    := m_linemv->cp_darr
   d_line->pp_tarr    := m_linemv->cp_tarr
   d_line->pp_dsta    := m_linemv->cp_dsta
   d_line->pp_tsta    := m_linemv->cp_tsta
   d_line->pp_dfin    := m_linemv->cp_dfin
   d_line->pp_tfin    := m_linemv->cp_tfin
   d_line->pp_widfin  := m_linemv->cp_widfin
   d_line->pp_bqtyw   := m_linemv->cp_bqtyw
   d_line->pp_bqtys   := m_linemv->cp_bqtys
   d_line->pp_bqtyp   := m_linemv->cp_bqtyp

   IF !Empty( nRejected )
      d_line->pp_totscr := nRejected
   ENDIF
   IF !Empty( cCodeM )
      d_line->b_lrej    := cCodeM
   ENDIF
   IF !Empty( cCodeDoc )
      d_line->discr_rep := cCodeDoc
   ENDIF

   IF c_proc->uom_id = "P"
      d_line->qty_bscr  += nRejected
   ELSE
      d_line->qty_bscr  += QtyConvert( nRejected , d_line->b_type, m_linemv->pline_id , m_linemv->size_id , c_proc->uom_id , "P" ,,,m_linemv->route_id,m_linemv->value_id)
   ENDIF
   d_line->( xDbUnLock() )
ENDIF

IF d_line->b_purp == "6" .AND. D_LINE->cpproc_id $ "_196.0_196.5_"
 		@12, 20 CLEAR TO 16, 55
 		DrawBox( 12, 20, 16, 55 )

 		@12, 22 SAY "Expiry date must be entered"

 		@14, 30 SAY "Date   : " GET dExpDate VALID !Empty(dExpDate)

 		READ

 		NetUse("D_exp",5)

 		if d_exp->( AddRec(5) )
 		   d_exp->b_id := d_line->b_id
 		   d_exp->d_exp := dExpDate
 		   d_exp->( DbUnLock() )
 		endif

 		d_exp->(dbclosearea())
ENDIF



cTmpProc := m_linemv->cpproc_id
// next stage in route
m_linemv->( DbSkip() )

// m_linemv update
IF m_linemv->( RecLock(5) )
	IF m_linemv->cpproc_id $ "_194.0_194.5_" .AND. ;
		cTmpProc	   		  $ "_196.0_196.5_"
		m_linemv->arr         := .T.
		m_linemv->cp_darr     := Date()
		m_linemv->cp_tarr     := cCpTfin
	ENDIF
   m_linemv->cp_bqtyw    := nPqtyw
   m_linemv->cp_bqtys    := nPqtys
   m_linemv->cp_bqtyp    := nPqtyp
   m_linemv->( DbUnLock() )
ENDIF

// d_line update current proc based on new stage in m_linemv

IF d_line->( RecLock(5) )
   d_line->cpproc_id  := m_linemv->cpproc_id
   d_line->cp_pccode  := m_linemv->cp_pccode
   d_line->cpwkstn_id := m_linemv->cpwkstn_id
   d_line->cp_dsta    := m_linemv->cp_dsta
   d_line->cp_tsta    := m_linemv->cp_tsta
	d_line->cp_darr    := m_linemv->cp_darr//Vr 07.08.2002
	d_line->cp_tarr    := m_linemv->cp_tarr//Vr 07.08.2002
   d_line->cp_bqtyw   := m_linemv->cp_bqtyw
   d_line->cp_bqtys   := m_linemv->cp_bqtys
   d_line->cp_bqtyp   := m_linemv->cp_bqtyp

   d_line->( xDbUnLock() )
ENDIF

m_linemv->( DbSkip( -1 ) )  // return to current proc

RETURN

Proc MyShowQcDoc( cFinFile,cB_id )
 IF Select(cFinFile)==0
    GenOpenFiles({cFinFile})
 ENDIF
 ShowQcDoc( cFinFile,cB_id )
Return

STATIC PROCEDURE ShowQcDoc( cFinFile,cB_id )
LOCAL aEntries := {}
LOCAL n := 1
LOCAL nSaveFinRecNo
LOCAL cPB_id, nOrd ,nRec

//IF !EMPTY(aSourceBN)
    aSourceBN := {}
//ENDIF

cToran := ""

IF (cFinFile)->( DbSeek( IF(cB_id#NIL,cb_ID,m_linemv->b_id)) )

   nSaveFinRecNo := (cFinFile)->( RecNo() )

   WHILE (cFinFile)->b_id == IF(cB_id#NIL,cb_ID,m_linemv->b_id)

           Aadd( aEntries , { (cFinFile)->qc_com,(cFinFile)->wh ,;
                              (cFinFile)->qc_qty,(cFinFile)->esn_id,0 } )

           IF (cFinFile)->FIN_TYPE=="2"
                cToran := "src"
           ENDIF

           IF (cFinFile)->FIN_TYPE=="2"  .and. (aSourceBN == NIL .or. LEN(aSourceBN) == 0)
               cPB_id := (cFinFile)->b_id
               nOrd := (cFinFile)->(indexOrd())
               nRec := (cFinFile)->( RecNo() )
               DO CASE
                 CASE lower(cFinFile) = "d_finqc"
                            (cFinFile)->(OrdSetFocus("ifinqpbn"))
                 CASE lower(cFinFile) = "h_finqc"
                            (cFinFile)->(OrdSetFocus("hfinqpbn"))
                 CASE lower(cFinFile) = "a_finqc"
                            (cFinFile)->(OrdSetFocus("afinqpbn"))
               ENDCASE
               (cFinFile)->(dbseek(CpB_ID))

               IF (cFinFile)->FIN_TYPE=="2"
                   (cFinFile)->( DbSkip() )
               ENDIF
               // Next section (Do-while) was altered by D. Laor
               // in order to enable print Packing batches with no source batches.
               // otherwise the program loops.
               WHILE (cFinFile)->pACKb_id == cpB_id .AND.( (cFinFile)->fin_typE=="3" .OR. (cFinFile)->fin_typE=="2" )
                   if aSourceBN == NIL .OR. valtype(aSourceBN)#"A"
                       aSourceBN := {}
                   endif
                   IF (cFinFile)->fin_typE=="3"
                    Aadd( aSourceBN , { (cFinFile)->qc_com,(cFinFile)->wh ,;
                                       (cFinFile)->qc_qty,(cFinFile)->volT_id,;
                                       (cFinFile)->tc_id,(cFinFile)->Value_id,;
                                       (cFinFile)->TOL_id,(cFinFile)->esnxx_id,;
                                       (cFinFile)->esny_id,(cFinFile)->b_id } )
                   ELSEIF aScan(aEntries,{|aVal| aVal[4] == (cFinFile)->esn_id}) == 0
                    Aadd( aEntries , { (cFinFile)->qc_com,(cFinFile)->wh ,;
                                       (cFinFile)->qc_qty,(cFinFile)->esn_id,0 } )
                   ENDIF
                   (cFinFile)->( DbSkip() )
               enddo
               (cFinFile)->(OrdSetFocus(nOrd))
           ENDIF
           (cFinFile)->( DbSkip() )
   ENDDO
   (cFinFile)->( DbGoTo( nSaveFinRecNo ) )
ENDIF

Asort( aEntries ,,, {|x,y| x[4]+x[2] < y[4]+y[2] } )

Aeval( aEntries , {|el,i| el[5] := i } )


IF cToran = "src"
   QcPackDoc( aEntries  , aSourceBN ,cFinFile )
ELSE
   QcDoc( aEntries  , cFinFile )
ENDIF

RETURN

STATIC FUNCTION TolCheck( cFinFile )
LOCAL lRetVal

DO CASE
   CASE (cFinFile)->ptype_id = "C"
        lRetVal := !( (cFinFile)->tol_id $ " R" )
   CASE (cFinFile)->ptype_id = "L"
        lRetVal := !( (cFinFile)->tol_id $ " R" )
   OTHERWISE
        lRetVal := .T.
ENDCASE

RETURN lRetVal



PROCEDURE ReQcDoc

LOCAL aFinFiles := {" d_finqc" , "h_finqc" , "a_finqc" }
LOCAL aFinIndex := { "ifinqcbn", "hfinqcbn", "afinqcbn","ifinqpbn"}
LOCAL cFinFile , i
LOCAL cBN := "      "

IF !GetBN( @cBN )
   RETURN
ENDIF

GenOpenFiles( aFinFiles )
FOR i := 1 TO 3
       IF (aFinFiles[i])->( DbSeek( cBN ) )
          cFinFile := aFinFiles[i]
          EXIT
       ENDIF
NEXT

IF Empty( cFinFile )
   Alert( cBN + "  not found in FINQC files" , {"..."})
   RETURN
ELSE
    GenOpenfiles({"m_linemv"})
    m_linemv->( OrdSetFocus( "ilnmvbn"  ) )
      IF m_linemv->( DbSeek( cBN ) )
         ShowQcDoc( cFinFile )
         (cFinFile)->( DbCloseArea() )
         m_linemv->( DbCloseArea() )
      ELSE
         Alert( cBN +" not found in M_LINEMV file" , {"..."} )
      ENDIF
ENDIF

RETURN


STATIC FUNCTION GetBN( cBN  )
LOCAL cScreen := SaveScreen()

@ 2,5 CLEAR TO 4,16
@ 2,5 TO 4,16

@ 3 , 6 SAY "B/N"
@ 3, 10 GET cBN SEND postBlock := {|o| !Empty(o:varGet()) }
READ

RestScreen( ,,,, cScreen )
RETURN ASCAN( aGoodKeys, LASTKEY() ) > 0

STATIC FUNCTION ToBuildEsn( cTabName )
LOCAL lToBuild := .F.

DO CASE
   CASE m_linemv->ptype_id = "C" .AND. cTabName == "c_volt"
        lToBuild := .T.
   CASE m_linemv->ptype_id $ "L_F_U_T" .AND. cTabName == "c_value"
        lToBuild := .T.
   ENDCASE
RETURN lToBuild


PROCEDURE DoEndKitMatch
ScrBatchOn()
IF !ifEnglish()
   @ 1 , 23 SAY "kit/matchbooks"
   @ 3 , 44 SAY "çâàâó åô"
   @ 4 , 49 SAY "çâàâó åô"
   @ 5 , 44 SAY "çâàâó åô"
ELSE
   @ 1 , 15 SAY "kit/matchbooks"
ENDIF

aStock := {}
GetKitData("N")
IF LastKey() = K_ESC
   RETURN
ENDIF

MakeKitBrow()
ShowKitParts()
aStock := NIL
RETURN

STATIC PROCEDURE MakeKitBrow
LOCAL oCol
LOCAL i , nLen

IF !IfEnglish()
   o := ABrowseNEW(14,22,22,78,aStock )
ELSE
	o := ABrowseNEW(18,2,22,58,aStock )
ENDIF


IF !ifEnglish()
   o:addColumn( TBColumnNEW( "           ÑòíÑ" , {|| o:arrayReference[o:arrayIndex,1]} ) )
   o:addColumn( TBColumnNEW( "èëáé"            , {|| Padc(o:arrayReference[o:arrayIndex,2],4 )} ) )
   o:addColumn( TBColumnNEW( " öÖéã;çâàâó"     ,{|| Transform(o:arrayReference[o:arrayIndex,3],"999,999") }))
   o:addColumn( TBColumnNEW( "ESN             ", {|| o:arrayReference[o:arrayIndex,4]} ) )
   o:addColumn( TBColumnNEW( "XX"              , {|| o:arrayReference[o:arrayIndex,5]} ) )
   o:addColumn( TBColumnNEW( "Y"               , {|| o:arrayReference[o:arrayIndex,6]} ) )
ELSE
   o:addColumn( TBColumnNEW( "Y"               , {|| o:arrayReference[o:arrayIndex,6]} ) )
   o:addColumn( TBColumnNEW( "XX"              , {|| o:arrayReference[o:arrayIndex,5]} ) )
   o:addColumn( TBColumnNEW( "ESN             ", {|| o:arrayReference[o:arrayIndex,4]} ) )
	o:addColumn( TBColumnNEW( "Kit;Quantity"    ,{|| Transform(o:arrayReference[o:arrayIndex,3],"999,999") }))
   o:addColumn( TBColumnNEW( "WH"              , {|| Padc(o:arrayReference[o:arrayIndex,2],4 )} ) )
	o:addColumn( TBColumnNEW( "Comment        " , {|| o:arrayReference[o:arrayIndex,1]} ) )
ENDIF
RETURN

STATIC PROCEDURE GetKitData(cCode)
LOCAL cScreen := SaveScreen()
LOCAL i , nLine

LOCAL cNote  := Space( 15 ) ,;
      cWh    := " "         ,;
      nQty   := 0           ,;
      cESN   := Space(16)  ,;
      cXX    := "  "        ,;
      cY     := " "

// n - new    u - update
IF cCode = "N"
   cNote      := Space(15)
   cWh        := "4"
   nQty       := 0
   cESN       := Left( Alltrim(d_line->esn_id) , Len(Alltrim(d_line->esn_id))-3)
   cXX        := d_line->esnxx_id  // xx
   cY         := d_line->esny_id   // y
ELSE
   i := o:arrayIndex
   cNote      := aStock[i,1]
   cWh        := aStock[i,2]
   nQty       := aStock[i,3]
   cESN       := aStock[i,4]
   cXX        := aStock[i,5]
   cY         := aStock[i,6]
ENDIF

IF !IfEnglish()
   @ 6,22 CLEAR TO 18 , 47
   @ 6,22 TO 18 , 47  DOUBLE

   @ 8 ,23 SAY       "                x:Y "
   @ 8 ,39 GET cY      SEND preBlock  := {|o| preAll( o ) } ;
                       SEND postBlock := {|o| postAll( o ) }
   GetList[1]:cargo := 6

   @ 9 ,23 SAY       "               xx:XX"
   @ 9 ,38 GET cXX     SEND preBlock  := {|o| preAll( o ) } ;
                       SEND postBlock := {|o| postAll( o ) }
   GetList[2]:cargo := 5


   @ 10 ,23 SAY       "                 :ESN"
   @ 10, 27 GET cESN PICTURE "@!" SEND postBlock := {|o| postKitESN( o ) }

   @ 11 ,23 SAY       "           999999:öÖéã"
   @ 11,34 GET nQty PICTURE '999999'  SEND postBlock := {|o| postKitQty(o) }

   @ 12, 23 SAY       "                x:èëáé"
   @ 12,39 GET cWh SEND postBlock := {|o| postWh(o) }

   @ 13,23 SAY       "  xxxxxxxxxxxxxxx:ÑòíÑ"
   @ 13,25 GET cNote SEND reader := {|o| HebReader(o) }
ELSE//////////////////////////
   @ 6,47 CLEAR TO 18 , 77
   @ 6,47 TO 18 , 77  DOUBLE

   @ 8 ,51 SAY    "Y        :          "
   @ 8 ,61 GET cY  SEND preBlock  := {|o| preAll( o ) } ;
                   SEND postBlock := {|o| postAll( o ) }
   GetList[1]:cargo := 6

   @ 9 ,51 SAY    "XX       :          "
   @ 9 ,61 GET cXX     SEND preBlock  := {|o| preAll( o ) } ;
                       SEND postBlock := {|o| postAll( o ) }
   GetList[2]:cargo := 5

   @ 10 ,51 SAY   "ESN      :           "
   @ 10, 61 GET cESN PICTURE "@!" SEND postBlock := {|o| postKitESN( o ) }

   @ 11 ,51 SAY   "QUANTITY :           "
   @ 11 ,61 GET nQty PICTURE '999999'  SEND postBlock := {|o| postKitQty(o) }

   @ 12,51 SAY    "WAREHOUSE:           "
   @ 12,61 GET cWh SEND postBlock := {|o| postWh(o) }

   @ 13,51 SAY    "COM                     "
   @ 13,55 GET cNote
ENDIF/////////////////////////////////////////////////////////////

READ

IF ASCAN( aGoodKeys, LASTKEY() ) > 0
   IF cCode = "N"
      Aadd( aStock , { cNote , cWh, nQty, cESN, cXX, cY } )
   ELSE
      aStock[i , 1 ] := cNote
      aStock[i , 2 ] := cWh
      aStock[i , 3 ] := nQty
      aStock[i , 4 ] := cESN
      aStock[i , 5 ] := cXX
      aStock[i , 6 ] := cY
   ENDIF

ENDIF

RestScreen( ,,,, cScreen )
RETURN

STATIC PROCEDURE ShowKitParts
LOCAL nKey

IF !IfEnglish()
   @ 24,0 SAY Padc( "Enter-èÖóâö  Space-ìëÖê  Del-åàÅ  F5-òÖôâÄ  Alt+P-èëáéå Äå öÖåâëî" , 80 ) COLOR If( IsColor() , "W+/BR" , "W+/N" )
   o:panEnd()
ELSE
	@ 24,0 SAY Padc( "Scrap not for WH-Alt+P,Confirm-F5,Cancel-Del,Additional-Space,Correct-Enter" , 80 ) COLOR If( IsColor() , "W+/BR" , "W+/N" )
ENDIF


WHILE .T.

    WHILE !o:stabilize() ; ENDDO

    nKey := InKey(0)

    IF nKey = K_ESC
       EXIT
    ELSEIF StdKeys( nKey , o )
    ELSEIF nKey = K_F5
       LastKitStep()
       EXIT
    ELSEIF nKey = K_ENTER
       GetKitData("U")
       o:refreshCurrent()
    ELSEIF nKey = K_SPACE
       GetKitData("N")
       o:configure()
       o:goTop()
       o:refreshAll()
    ELSEIF nKey = K_DEL
       IF Empty( aStock )
          GetKitData("N")
          IF LastKey() = K_ESC
             EXIT
          ENDIF
       ELSE
          DelTolR(o)
          Adel( aStock , o:arrayIndex )
          Asize( aStock , Len( aStock ) - 1 )
          IF Empty( aStock )
             GetKitData("N")
             IF LastKey() = K_ESC
                EXIT
             ENDIF
          ENDIF

          IF o:arrayIndex > Len( aStock )
             o:arrayIndex := Len( aStock )
          ENDIF

          o:configure()
          o:goTop()
          o:refreshAll()
       ENDIF
    ENDIF
ENDDO
RETURN

PROCEDURE DelTolR( o )
LOCAL aTemp  := o:arrayReference
LOCAL nIndex := o:arrayIndex
LOCAL nPos , i , b

FOR i := 1 TO o:colCount
    IF o:getColumn(i):heading == "TOL"
       b := o:getColumn(i):block
       EXIT
    ENDIF
NEXT

IF ValType( b ) == "B"
   IF Eval( b ) == "R"
      IF cToran = "src"
         nsTolRQty := 0
         csCodeM   := ""
         csCodeDoc := ""
         csScrNote := ""
      ELSE
         nTolRQty := 0
         cCodeM   := ""
         cCodeDoc := ""
         cScrNote := ""
      ENDIF
   ENDIF
ENDIF

RETURN


STATIC FUNCTION postKitQty( o )

IF LastKey() = K_UP
   RETURN .T.
ENDIF

IF Empty( o:varGet() )
   IIF( !IfEnglish(),Alert( "çâàâó öÖéã ôóÑ Äê" , {"..."} ) ,Alert( "Enter Kit Quantity" , {"..."} ) )
   RETURN .F.
ENDIF

IF Negative( o )
   RETURN .F.
ENDIF

RETURN .T.

STATIC FUNCTION postKitESN(o)
LOCAL lRetVal
LOCAL cBuffer := o:varGet()

IF LastKey() = K_UP
   RETURN .T.
ENDIF

IF Empty( cBuffer )
   IIF(!IfEnglish(),Alert( "ESN ôâóÑå Äê" , {"..."}) ,Alert( "Enter ESN" , {"..."}) )
   RETURN .F.
ENDIF

IF d_esn->( DbSeek( cBuffer ) )
ELSE
   IIF(!IfEnglish() , Alert( "ESN:"+cBuffer + " çââó Äå" ,{"..."}),;
		                Alert( "ESN:"+cBuffer + " not found" , {"..."}) )
   RETURN .F.
ENDIF

RETURN .T.

PROCEDURE LastKitStep

IF !IfEnglish()
   @ 24,0 SAY Padc( "ç â ñ Å ó    è Ö ã É í" ,80 ) COLOR If(IsColor(),"W+/B","W+/N")
ELSE
	@ 24,0 SAY Padc( "Update files" ,80 ) COLOR If(IsColor(),"W+/B","W+/N")
ENDIF


IF DoKitFinQc()
   DoKitLineMove()
   SetDocType( "kit" )
   ShowQcDoc("d_finqc" )
   SetDocType()
   d_finqc->( DbCloseArea() )
ENDIF

RETURN


STATIC PROCEDURE DoKitLineMove
LOCAL nPQtyp := 0 ,;
      nPqtyw := 0 ,;
      nPqtys := 0

LOCAL cCpTfin := Left( Time() , 5 )

Aeval(aStock,{|el|nPQtyp+=el[3]}) // sum qty entered

IF m_linemv->( RecLock( 5 ) )


   m_linemv->cp_bqtyp  := nPQtyp   // KIT  (NOT PCS)
   m_linemv->fin       := .T.
   m_linemv->cp_dfin   := Date()
   m_linemv->cp_tfin   := cCpTfin
   m_linemv->cp_widfin := GetBNWid()[2]

   m_linemv->( DbUnLock() )
ENDIF

// d_line

IF d_line->( RecLock(5) )
   d_line->ppproc_id  := m_linemv->cpproc_id
   d_line->pp_pccode  := m_linemv->cp_pccode
   d_line->pp_wkstn   := m_linemv->cpwkstn_id
   d_line->pp_darr    := m_linemv->cp_darr
   d_line->pp_tarr    := m_linemv->cp_tarr
   d_line->pp_dsta    := m_linemv->cp_dsta
   d_line->pp_tsta    := m_linemv->cp_tsta
   d_line->pp_dfin    := m_linemv->cp_dfin
   d_line->pp_tfin    := m_linemv->cp_tfin
   d_line->pp_widfin  := m_linemv->cp_widfin
//   d_line->pp_bqtyw   := m_linemv->cp_bqtyw
//   d_line->pp_bqtys   := m_linemv->cp_bqtys
   d_line->pp_bqtyp   := m_linemv->cp_bqtyp

   d_line->( xDbUnLock() )
ENDIF


// next stage in route
m_linemv->( DbSkip() )

// m_linemv update
IF m_linemv->( RecLock(5) )
   m_linemv->arr         := .T.
   m_linemv->cp_darr     := Date()
   m_linemv->cp_tarr     := cCpTfin
   m_linemv->cp_bqtyp    := nPqtyp
   m_linemv->( DbUnLock() )
ENDIF

// d_line update current proc based on new stage in m_linemv

IF d_line->( RecLock(5) )
   d_line->cpproc_id  := m_linemv->cpproc_id
   d_line->cp_pccode  := m_linemv->cp_pccode
   d_line->cpwkstn_id := m_linemv->cpwkstn_id
   d_line->cp_dsta    := m_linemv->cp_dsta
   d_line->cp_tsta    := m_linemv->cp_tsta
   d_line->cp_bqtyp   := m_linemv->cp_bqtyp

   d_line->( xDbUnLock() )
ENDIF

m_linemv->( DbSkip( -1 ) )  // return to current proc

RETURN


PROCEDURE DoEndPack
ScrBatchOn()
IF !ifEnglish()
   @ 1 ,28 SAY "ÑÜâòÄ"
   @ 11,66 SAY "           "
   @ 12,41 SAY "ÑÜâòÄ öêé åô"
   @ 17,41 SAY "òÖóé öÖêé åô åíÖîÅ ESN âêÖöê àÖòâî -"
ELSE
   @ 1 ,19 SAY "   Packing"
   @ 11,02 SAY "             "
   @ 12,23 SAY "of Packing Batch"
   @ 17,03 SAY "- Actual ESN details of the Source Batches"
ENDIF

aStock    := {}
aSourceBN := {}
cToran := "pack"
GetData("N")
IF LastKey() = K_ESC
   RETURN
ENDIF

MakeTheBrow(13,16)
MakePackBrow()

ShowPackParts({o , oP } )
cToran := aSourceBN := aStock := NIL
RETURN

PROCEDURE MakePackBrow
LOCAL aWork , oCol
LOCAL i , nLen

aWork := GetAttributes()

IF !IfEnglish()
   oP := ABrowseNEW(18,10,22,78,aSourceBN )
ELSE
   oP := ABrowseNEW(18,2,22,58,aSourceBN )
ENDIF

IF !ifEnglish()//////////////////////////////////////////////////////////
   oP:addColumn( TBColumnNEW( "           ÑòíÑ" , {|| oP:arrayReference[oP:arrayIndex,1]} ) )
   oP:addColumn( TBColumnNEW( "èëáé" , {|| Padc(oP:arrayReference[oP:arrayIndex,2],4 )} ) )
   oP:addColumn( TBColumnNEW( "   öÖéã",{|| Transform(oP:arrayReference[oP:arrayIndex,3],"999,999") }))

   IF aWork[1]
      oCol := TBColumnNEW( aTitles[1]    , {|| oP:arrayReference[oP:arrayIndex,4]} )
      oCol:cargo := 1
      oP:addColumn( oCol )
   ENDIF

   IF aWork[2]
      oCol := TBColumnNEW( aTitles[2]    , {|| oP:arrayReference[oP:arrayIndex,5]} )
      oCol:cargo := 2
      oP:addColumn( oCol )
   ENDIF

   IF aWork[3]
      oCol := TBColumnNEW( Padc( aTitles[3],8 ) , {|| oP:arrayReference[oP:arrayIndex,6]} )
      oCol:cargo := 3
      oP:addColumn( oCol )
   ENDIF

   IF aWork[4]
      oCol := TBColumnNEW( aTitles[4]    , {|| oP:arrayReference[oP:arrayIndex,7]} )
      oCol:cargo := 4
      oP:addColumn( oCol )
   ENDIF

   IF aWork[5]
      oCol := TBColumnNEW( aTitles[5]    , {|| oP:arrayReference[oP:arrayIndex,8]} )
      oCol:cargo := 5
      oP:addColumn( oCol )
   ENDIF

   IF aWork[6]
      oCol := TBColumnNEW(  aTitles[6] , {||oP:arrayReference[oP:arrayIndex,9] } )
      oCol:cargo := 6
      oP:addColumn( oCol )
   ENDIF

   oP:addColumn( TBColumnNEW( "Ñêé 'ëé" , {||oP:arrayReference[oP:arrayIndex,10]}))
ELSE////////////////////////////////////////////////////////////////
   oP:addColumn( TBColumnNEW( "Batch No." , {||oP:arrayReference[oP:arrayIndex,10]}))

   IF aWork[6]
      oCol := TBColumnNEW(  aTitles[6] , {||oP:arrayReference[oP:arrayIndex,9] } )
      oCol:cargo := 6
      oP:addColumn( oCol )
   ENDIF

   IF aWork[5]
      oCol := TBColumnNEW( aTitles[5]    , {|| oP:arrayReference[oP:arrayIndex,8]} )
      oCol:cargo := 5
      oP:addColumn( oCol )
   ENDIF

   IF aWork[4]
      oCol := TBColumnNEW( aTitles[4]    , {|| oP:arrayReference[oP:arrayIndex,7]} )
      oCol:cargo := 4
      oP:addColumn( oCol )
   ENDIF

   IF aWork[3]
      oCol := TBColumnNEW( Padc( aTitles[3],8 ) , {|| oP:arrayReference[oP:arrayIndex,6]} )
      oCol:cargo := 3
      oP:addColumn( oCol )
   ENDIF

   IF aWork[2]
      oCol := TBColumnNEW( aTitles[2]    , {|| oP:arrayReference[oP:arrayIndex,5]} )
      oCol:cargo := 2
      oP:addColumn( oCol )
   ENDIF

   IF aWork[1]
      oCol := TBColumnNEW( aTitles[1]    , {|| oP:arrayReference[oP:arrayIndex,4]} )
      oCol:cargo := 1
      oP:addColumn( oCol )
   ENDIF

   oP:addColumn( TBColumnNEW( "Quantity",{|| Transform(oP:arrayReference[oP:arrayIndex,3],"999,999") }))
   oP:addColumn( TBColumnNEW( "Warehouse" , {|| Padc(oP:arrayReference[oP:arrayIndex,2],4 )} ) )
   oP:addColumn( TBColumnNEW( "Comment     " , {|| oP:arrayReference[oP:arrayIndex,1]} ) )
ENDIF///////////////////////////////////////////////////////////////

RETURN


PROCEDURE ShowPackParts( aoBjs )
LOCAL oToran := aoBjs[1]
LOCAL nKey

cToran := "pack"

IF !IfEnglish()
   @ 24,0 SAY Padc( "Enter-èÖóâö  Space-ìëÖê  Del-åàÅ  Tab-èÖåá ìåáÑ  F5-òÖôâÄ  Alt+P-èëáéå Äå öÖåâëî" , 80 ) COLOR If( IsColor() , "W+/BR" , "W+/N" )
   o:panEnd()
ELSE
	@ 24,0 SAY Padc( "Scrap-Alt+P,Confirm-F5,Cancel-Del,Chg Window-Tab,Additional-Space,Correct-Enter" , 80 ) COLOR If( IsColor() , "W+/BR" , "W+/N" )
ENDIF


EmptyRejBuffer()

WHILE .T.

    WHILE !oToran:stabilize() ; ENDDO

    oToran:hilite()
    nKey := InKey(0)

    IF nKey = K_ESC
       EXIT
    ELSEIF StdKeys( nKey , oToran )

    ELSEIF nKey = K_TAB
       oToran:deHilite()
       IF oToran == aoBjs[1]
          oToran := aoBjs[2]
          cToran := "src"
          IF Empty( oToran:arrayReference )
             GetData("N")
             IF LastKey() = K_ESC
                oToran := aoBjs[1]
                cToran := "pack"
             ELSEIF LastKey() <> K_ESC .AND. !IfEnglish()
                oToran:panEnd()
             ENDIF
          ENDIF
       ELSE
          oToran := aoBjs[1]
          cToran := "pack"
       ENDIF
       oToran:refreshAll()
    ELSEIF nKey = K_F5
       LastPackStep()
       EXIT
    ELSEIF nKey = K_ALT_P
       lSwType := .T.
       SetRejEob( .T. )
       nKey := 0
       Aeval( aStock , {|el,i| nKey += el[3] } ) // sum qty entered
       Aeval( aSourceBN , {|el,i| nKey += el[3] } ) // sum qty entered
       nRejected := (m_linemv->cp_bqtyp - nKey) // calc how many rejctions you can enter
       lRegularRej := SetRejected( nRejected )  //
       GetScr2_F3F4F5()
       lRegularRej := SetRejected( 0 ) // lRegularRej saves if there are any rejected p
       SetRejEob( .F. )
       lSwType := .F.
    ELSEIF nKey = K_ENTER
       GetData("U")
       oToran:refreshCurrent()
    ELSEIF nKey = K_SPACE
       GetData("N")
       oToran:configure()
       oToran:goTop()
       oToran:refreshAll()
    ELSEIF nKey = K_DEL
     IF Empty( oToran:arrayReference )
        GetData("N")
        IF LastKey() = K_ESC
           EXIT
        ENDIF
     ELSE
        DelTolR(o)
        Adel( oToran:arrayReference, oToran:arrayIndex )
        Asize( oToran:arrayReference , Len( oToran:arrayReference ) - 1 )
        IF Empty( oToran:arrayReference )
           GetData("N")
           IF LastKey() = K_ESC
              EXIT
           ENDIF
        ENDIF

        IF oToran:arrayIndex > Len( oToran:arrayReference )
           oToran:arrayIndex := Len( oToran:arrayReference )
        ENDIF

        oToran:configure()
        oToran:goTop()
        oToran:refreshAll()
     ENDIF
    ENDIF

ENDDO
EmptyRejBuffer()
RETURN

FUNCTION SwType()
LOCAL cRetVal := "X" // do not add fin type to rejection array
IF lSwType
   cRetVal := if( cToran == "src" , "3" , "2" )
ENDIF
RETURN cRetVal


STATIC FUNCTION postbar3BN(o)
LOCAL lRetVal
// I remarked next line because there was a need to allow user to
// input source batch in a "XXXXX0" format
// strzero function was also remarked two more lines.
// in case of correcting back to normal, correct also line 479 (get picture)
// LOCAL nBuffer := Val( o:varGet() )
LOCAL nBuffer :=  o:varGet()

// o:varPut( StrZero(nBuffer,6) )
o:display()

lRetVal := SrcBelongToPack( o:varGet() )

RETURN lRetVal


STATIC FUNCTION SrcBelongToPack( cSRCBN )
LOCAL nSelect := Select( Alias() )
// LOCAL cKey := d_line->b_id + cSRCBN
// correct key is source+refno             20/4/97
// 3 spaces added in order to build the correct key on a right justified field: sm_refno
LOCAL cKEY := cSRCBN + "   " + d_line->b_id
LOCAL oTab := TabBase():new( "m_stkmv" , {"istmvsrf" } )
LOCAL lRetVal

oTab:xopen()

IF m_stkmv->( DbSeek( cKey ) )
   lRetVal := .T.
ELSE
   Tone( 300, 2 )
   Alert( "This source batch is not part of this packing batch" , {"Enter"} )
   lRetVal := .F.
ENDIF

oTab:close()
SELECT (nSelect)

RETURN lRetVal


STATIC PROCEDURE LastPackStep

IF !IfEnglish()
   @ 24,0 SAY Padc( "ç â ñ Å ó    è Ö ã É í" ,80 ) COLOR If(IsColor(),"W+/B","W+/N")
ELSE
	@ 24,0 SAY Padc( "Update files" ,80 ) COLOR If(IsColor(),"W+/B","W+/N")
ENDIF


IF DoPackFinQc()
   DoPackRejAll()
   DoLineMove()
   ShowQcDoc("d_finqc")
   d_finqc->( DbCloseArea() )
ENDIF

RETURN



PROCEDURE DoPackRejAll
LOCAL i , nLen , nTotalGood := 0
IF nTolRQty == NIL
   nTolRQty := 0
ENDIF

// NetUse( "d_rejrep" , 5 )
genOpenFiles({"d_rejrep"})

// tol R packing
IF !Empty( cCodeM )
    IF d_rejrep->( AddRec( 5 ) )
       d_rejrep->B_ID      := m_linemv->b_id
       d_rejrep->CP_STAGE  := m_linemv->cp_stage
       d_rejrep->CPPROC_ID := m_linemv->cpproc_id
       d_rejrep->REJ_UNIT  := "R"
       d_rejrep->QTY_REJ   := nTolRQty
       d_rejrep->REJ_ID    := cCodeM
       d_rejrep->DISCR_REP := cCodeDoc
       d_rejrep->REJ_COM   := cScrNote
    ENDIF
ENDIF

// tol R source
IF !Empty( csCodeM )
    IF d_rejrep->( AddRec( 5 ) )
       d_rejrep->B_ID      := m_linemv->b_id
       d_rejrep->CP_STAGE  := m_linemv->cp_stage
       d_rejrep->CPPROC_ID := m_linemv->cpproc_id
       d_rejrep->REJ_UNIT  := "R"
       d_rejrep->QTY_REJ   := nsTolRQty
       d_rejrep->REJ_ID    := csCodeM
       d_rejrep->DISCR_REP := csCodeDoc
       d_rejrep->REJ_COM   := csScrNote
    ENDIF
ENDIF



// scraped not in use
Aeval( aStock , {|el,i| nTotalGood += el[3] } ) // sum qty entered
Aeval( aSourceBN , {|el,i| nTotalGood += el[3] } ) // sum qty entered
nRejected := (m_linemv->cp_bqtyp - nTotalGood) // calc how many rejctions you can en

IF !Empty( nRejected )

   SetRejEob( .T. )
   lRegularRej := SetRejected( nRejected )  //

   ScrapUpdate()

   lRegularRej := SetRejected( 0 ) // lRegularRej saves if there are any rejected p
   SetRejEob( .F. )

ENDIF

d_rejrep->( DbCloseArea() )

RETURN