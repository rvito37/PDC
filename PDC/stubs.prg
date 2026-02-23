// stubs.prg - Stub functions for missing externals
// These are placeholder implementations for functions that are not available in Harbour
// They will need to be properly implemented or replaced

// Class(y) runtime NOT needed - Harbour hbclass.ch handles CREATE CLASS natively

// Set Hebrew CP862 BEFORE Harbour GT initializes
INIT PROCEDURE SetHebCP862()
   SetConsoleCP862()
RETURN

// ============================================
// Advantage Database Server (AX_*) compatibility layer
// Maps old Clipper AX_* functions to Harbour rddads Ads* functions
// ============================================

#include "ads.ch"
#include "dbinfo.ch"
#include "ord.ch"

FUNCTION AX_ChooseOrdBagExt( cExt )
// In Harbour rddads, file type is set via AdsSetFileType()
HB_SYMBOL_UNUSED( cExt )
AdsSetFileType( ADS_CDX )
RETURN .T.

FUNCTION AX_AutoOpen( lMode )
// No direct Harbour equivalent - indexes auto-open with ADS RDD
HB_SYMBOL_UNUSED( lMode )
RETURN .T.

FUNCTION AX_RightsCheck( lMode )
RETURN AdsRightsCheck( hb_defaultValue( lMode, .T. ) )

FUNCTION AX_AppendFrom( cFile, cType )
HB_SYMBOL_UNUSED( cType )
__dbApp( cFile )
RETURN .T.

FUNCTION AX_TagName( nOrder )
RETURN OrdName( nOrder )

FUNCTION AX_TagNo()
RETURN OrdNumber()

FUNCTION AX_TagCount()
RETURN OrdCount()

FUNCTION AX_IndexCount()
RETURN OrdCount()

FUNCTION AX_IndexName( nOrder )
RETURN OrdName( nOrder )

FUNCTION AX_SetTag( cTag )
RETURN OrdSetFocus( cTag )

FUNCTION AX_Tags()
LOCAL aResult := {}
LOCAL i
FOR i := 1 TO OrdCount()
   AAdd( aResult, OrdName( i ) )
NEXT
RETURN aResult

FUNCTION AX_TagInfo()
LOCAL aResult := {}
LOCAL i
FOR i := 1 TO OrdCount()
   AAdd( aResult, { OrdName( i ), OrdKey( i ), OrdFor( i ) } )
NEXT
RETURN aResult

FUNCTION AX_Unlock()
RETURN DbUnlock()

FUNCTION AX_CopyTo( cFile )
RETURN AdsCopyTable( cFile )

FUNCTION AX_IsShared()
RETURN DbInfo( DBI_SHARED )

FUNCTION AX_KillTag( xTag, cBag )
LOCAL i
IF ValType( xTag ) == "L" .AND. xTag
   // DELETE TAG ALL
   FOR i := OrdCount() TO 1 STEP -1
      OrdDestroy( OrdName( i ), cBag )
   NEXT
   RETURN .T.
ENDIF
RETURN OrdDestroy( xTag, cBag )

FUNCTION AX_UserLockId( cAlias )
HB_SYMBOL_UNUSED( cAlias )
RETURN 0

FUNCTION AX_AXSLocking( lMode )
RETURN AdsLocking( hb_defaultValue( lMode, .F. ) )

FUNCTION AX_IsFlocked( cAlias )
RETURN AdsIsTableLocked( cAlias )

FUNCTION AX_LockOwner( cFile, nType, nLock )
RETURN AdsMgGetLockOwner( cFile, nType, @nLock )

FUNCTION AX_Error()
LOCAL nErr := 0
AdsGetLastError( @nErr )
RETURN nErr

FUNCTION AX_CacheRecords( n )
RETURN AdsCacheRecords( n )

FUNCTION AX_SetServerAOF( cFilter, lResolve )
RETURN AdsSetAOF( cFilter, iif( hb_defaultValue( lResolve, .T. ), ADS_RESOLVE_IMMEDIATE, ADS_RESOLVE_DYNAMIC ) )

FUNCTION AX_ClearServerAOF()
RETURN AdsClearAOF()

FUNCTION AX_Loaded( cDrive )
RETURN ( AdsIsServerLoaded( hb_defaultValue( cDrive, "" ) ) > 0 )

FUNCTION AX_GetDrive( cPath )
RETURN Left( cPath, 2 )

FUNCTION AX_SetPass( cPassword )
HB_SYMBOL_UNUSED( cPassword )
RETURN .T.

FUNCTION AX_Transaction( nAction )
DO CASE
CASE nAction == 1
   AdsBeginTransaction()
CASE nAction == 2
   AdsCommitTransaction()
CASE nAction == 3
   AdsRollback()
ENDCASE
RETURN .T.

FUNCTION AX_SortOption( lUseCurrent )
HB_SYMBOL_UNUSED( lUseCurrent )
RETURN .T.

FUNCTION AX_ExprEngine( lMode )
HB_SYMBOL_UNUSED( lMode )
RETURN .T.

FUNCTION AX_SetScope( nScope, xValue )
IF nScope == 0
   OrdScope( TOPSCOPE, xValue )
ELSE
   OrdScope( BOTTOMSCOPE, xValue )
ENDIF
RETURN .T.

FUNCTION AX_ClrScope( nScope )
IF nScope == 0
   OrdScope( TOPSCOPE, NIL )
ELSE
   OrdScope( BOTTOMSCOPE, NIL )
ENDIF
RETURN .T.

FUNCTION AX_SetMemoBlock( nSize )
HB_SYMBOL_UNUSED( nSize )
RETURN .T.

// ============================================
// Novell NetWare (fn_*) stubs
// ============================================

FUNCTION fn_eLptCap()
RETURN .T.

FUNCTION fn_fLptCap()
RETURN .T.

FUNCTION fn_IsNet()
RETURN 0

FUNCTION fn_StaAddr()
RETURN "000000000000"

FUNCTION fn_WhoAmI()
LOCAL cUser := Upper( Alltrim( hb_CmdLine() ) )
IF Empty( cUser )
   // Fallback: read from c:\bmsname.txt
   IF File( "c:\bmsname.txt" )
      cUser := Upper( Alltrim( MemoRead( "c:\bmsname.txt" ) ) )
   ENDIF
ENDIF
IF Empty( cUser )
   cUser := "USER"
ENDIF
RETURN cUser

FUNCTION fn_RdProva()
RETURN ""

FUNCTION fn_ConnId()
RETURN 1

// ============================================
// LFN (Long File Names) stubs - native in Windows
// ============================================

FUNCTION LF_ChDir( cDir )
RETURN DirChange( cDir )

FUNCTION LF_ToLong( cFile )
RETURN cFile

FUNCTION LF_MemoRead( cFile )
RETURN MemoRead( cFile )

FUNCTION LF_GetFTime( cFile )
HB_SYMBOL_UNUSED( cFile )
RETURN ""

FUNCTION LF_FCopy( cSrc, cDst )
RETURN hb_FCopy( cSrc, cDst )

FUNCTION LF_FErase( cFile )
RETURN FErase( cFile )

FUNCTION LF_RmDir( cDir )
RETURN DirRemove( cDir )

// ============================================
// DBFCDXAX RDD - map to Harbour ADSCDX
// ============================================

FUNCTION DBFCDXAX()
RETURN "ADSCDX"

// ============================================
// Hebrew / display stubs
// ============================================

FUNCTION Heb_ChrC( n )
RETURN Chr( n )

FUNCTION MHeb_Toggle()
RETURN NIL

FUNCTION RDb_Inkey( nTimeout )
RETURN Inkey( nTimeout )

FUNCTION DispGet( o )
HB_SYMBOL_UNUSED( o )
RETURN NIL

FUNCTION Relat_Pos()
RETURN 0

// ============================================
// Misc stubs from BMS modules not included
// ============================================

FUNCTION CheckIndex( cAlias, cIndex, cKey, lReIndex, cFor, lUni )
HB_SYMBOL_UNUSED( cAlias )
HB_SYMBOL_UNUSED( cIndex )
HB_SYMBOL_UNUSED( cKey )
HB_SYMBOL_UNUSED( lReIndex )
HB_SYMBOL_UNUSED( cFor )
HB_SYMBOL_UNUSED( lUni )
RETURN .T.

FUNCTION NLen( n )
IF n == NIL ; RETURN 0 ; ENDIF
IF ValType( n ) != "N" ; RETURN Len( hb_ValToStr( n ) ) ; ENDIF
RETURN Len( Str( n ) )

// RadioGets/DrawRadios — real implementation in LIB/RADIOS.PRG

// SetF2Key removed — real implementation in LIB/TABFUNC.PRG

FUNCTION SetRefCounter( n )
HB_SYMBOL_UNUSED( n )
RETURN NIL

FUNCTION UpdateMovements()
RETURN NIL

FUNCTION BatchCalc1()
RETURN 0

FUNCTION BatchCalc3()
RETURN 0

// Top, Bot, SkipIt — real implementation in BMS/NAVIGATE.PRG

FUNCTION Win_Save( t, l, b, r )
RETURN SaveScreen( t, l, b, r )

FUNCTION Win_Rest( t, l, b, r, cScr )
RestScreen( t, l, b, r, cScr )
RETURN NIL

// BroCenter — real implementation in BMS/BRCENTER.PRG

FUNCTION ProcView()
RETURN NIL

FUNCTION StoreAudit()
RETURN NIL

FUNCTION PrnProcLine()
RETURN NIL

FUNCTION OpenBatch()
RETURN NIL

FUNCTION Ishur1()
RETURN .T.

FUNCTION CurrProcName( cId )
HB_SYMBOL_UNUSED( cId )
RETURN ""

FUNCTION qemail()
RETURN NIL

FUNCTION SetWeekNo()
RETURN 0

FUNCTION HandleUser()
RETURN NIL

FUNCTION OrderNo()
RETURN ""

FUNCTION GenOpenFile( cFile )
HB_SYMBOL_UNUSED( cFile )
RETURN NIL

FUNCTION LTime_NoRoute()
RETURN 0

// TableSelect — real implementation in LIB/TABFUNC.PRG
// TableTranslate — real implementation in LIB/TABTRANS.PRG

FUNCTION rpCurDir()
RETURN hb_cwd()

FUNCTION AofSetFilter()
RETURN NIL

FUNCTION LockKey()
RETURN NIL

FUNCTION OrdScrndSayCaptions()
RETURN NIL

FUNCTION OrdSayCaptions()
RETURN NIL

FUNCTION OrdRndSayItAgain()
RETURN NIL

FUNCTION OrdSayItAgain()
RETURN NIL

FUNCTION dOrdReader()
RETURN NIL

FUNCTION PostVolt()
RETURN NIL

FUNCTION BuildRateLine()
RETURN NIL

FUNCTION ProdDetails()
RETURN NIL

FUNCTION UnitCost()
RETURN 0

FUNCTION OrdViewOpenTables()
RETURN NIL

FUNCTION OrdViewClose()
RETURN NIL

FUNCTION StkValSub()
RETURN 0

FUNCTION GetIndicators()
RETURN {}

// ============================================
// Report system stubs (TheReport dependencies)
// ============================================

FUNCTION SetCheckBlocks()
RETURN NIL

FUNCTION SetTheDevices()
RETURN NIL

FUNCTION PrnFace()
RETURN NIL

FUNCTION CustomPLine()
RETURN NIL

FUNCTION GetDevType()
RETURN "Screen"

FUNCTION GetSortType()
RETURN ""

FUNCTION GetSpreadFile()
RETURN ""

FUNCTION LExport()
RETURN NIL

FUNCTION GetPrintFile()
RETURN ""

FUNCTION SaveVideo()
RETURN NIL

FUNCTION RestVideo()
RETURN NIL

FUNCTION rpNew()
RETURN NIL

FUNCTION rpDataPath()
RETURN ""

FUNCTION rpIndexPath()
RETURN ""

FUNCTION rpSwapPath()
RETURN ""

FUNCTION rpQuickLoad()
RETURN NIL

FUNCTION rpUseFonts()
RETURN NIL

FUNCTION rpQuerytBlock()
RETURN NIL

FUNCTION rpGetRDO()
RETURN NIL

FUNCTION rpDBTable()
RETURN NIL

FUNCTION rpMyDBOpen()
RETURN NIL

FUNCTION rpDBIndex()
RETURN NIL

FUNCTION rpDBKeyTBlock()
RETURN NIL

FUNCTION rpDestination()
RETURN NIL

FUNCTION rpPrinter()
RETURN NIL

FUNCTION rpOutFile()
RETURN ""

FUNCTION GetPrinter()
RETURN NIL

FUNCTION rpInitPCodes()
RETURN NIL

FUNCTION rpGenReport()
RETURN NIL

FUNCTION rpKillSorts()
RETURN NIL

FUNCTION rpCloseData()
RETURN NIL

FUNCTION ScrollBox()
RETURN NIL

FUNCTION aLen( a )
RETURN Len( a )

FUNCTION aPrnCritPage()
RETURN {}

FUNCTION rpLinePlace()
RETURN NIL

FUNCTION rpRFldNew()
RETURN NIL

FUNCTION rpLFieldNew()
RETURN NIL

FUNCTION rpRebuildDisp()
RETURN NIL

FUNCTION PrnHelpCrits()
RETURN NIL

FUNCTION FillSubTitle()
RETURN NIL

FUNCTION SetKotMsg()
RETURN NIL

FUNCTION PrnGetUserMsg()
RETURN ""

FUNCTION SetFileToPrint()
RETURN NIL

FUNCTION TbPrint()
RETURN NIL

FUNCTION SendToPrinter()
RETURN NIL

FUNCTION FileToPrint()
RETURN ""

// LoadDirs() - now in LIB/DIRS.PRG

// ============================================
// Functions from AVXBMS.PRG (excluded due to duplicates)
// ============================================

PROCEDURE CanNotProcess()
Alert( "You do not have access to this program" )
RETURN

PROCEDURE HideAll()
RETURN

// ============================================
// SwpRunCmd stub
// ============================================

FUNCTION SwpRunCmd( cCmd )
RETURN hb_run( cCmd )

// ============================================
// Additional missing function stubs
// ============================================

FUNCTION StevePrintSomeLabels()
RETURN NIL

FUNCTION LDesc()
RETURN ""

FUNCTION PaintRow( o )
IF o != NIL
   o:refreshCurrent()
ENDIF
RETURN NIL
