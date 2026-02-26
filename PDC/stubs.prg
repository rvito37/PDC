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

// BatchCalc3 — real implementation below (from BMS/DELIVSCH.PRG)

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

// LTime_NoRoute — real implementation from BMS/DELIVSCH.PRG
Function LTime_NoRoute(cAliasName)  //vitaly 98101301 20/12/99 WHITHOUT ROUTE_ID
Local nOldSelect,nOrder
LOCAL nTempBID
Local nRetCount  := 0.00
Local lWasOpened
Local lOpen_leadt := FALSE
Local nMRecNo
Local nMorder
IF cAliasName == NIL ; cAliasName := "d_line" ; ENDIF
nOldSelect := SELECT()
nOrder := INDEXORD()

IF Select("c_leadt") == 0
   GenOpenFiles({"c_leadt"})
   lOpen_leadt := TRUE
ENDIF

IF Select("m_linemv") == 0
   NetUse("m_linemv",5)
   lWasOpened := .T.
ELSE
   lWasOpened := .F.
   nMorder := m_linemv->(ordsetfocus("ilnmvbn"))
   nMRecNo  := m_linemv->(RecNo())
ENDIF

c_leadt->(ORDSETFOCUS("itcppr"))
m_linemv->(ORDSETFOCUS("ilnmvbn"))

m_linemv->(DBSEEK( (cAliasName)->B_ID  + (cAliasName)->CPPROC_ID) )
nTempBID := m_linemv->B_ID
DBSELECTAREA("m_linemv")
m_linemv->(ORDSETFOCUS("ilnmvbs"))
WHILE !EOF().AND. m_linemv->B_ID == nTempBID .AND. m_linemv->FIN
      m_linemv->(dbskip(1))
End

WHILE !EOF().AND. m_linemv->B_ID == nTempBID
          IF m_linemv->PTYPE_ID $ "U_K"
              c_leadt->(DBSEEK( m_linemv->PTYPE_ID + m_linemv->CPPROC_ID) )
          ELSE
              c_leadt->(DBSEEK( m_linemv->PTYPE_ID + m_linemv->CPPROC_ID + m_linemv->PLINE_ID) )
          ENDIF

          IF C_LEADT->(FOUND())
               nRetCount := nRetCount + c_leadt->LEADT_DAYS
          ENDIF
     m_linemv->(DBSKIP())
END

IF !lWasOpened
   m_linemv->(ordsetfocus(nMorder))
   m_linemv->(dbgoto(nMRecNo))
ELSE
   m_linemv->(dbclosearea())
ENDIF

if lOpen_leadt
   c_leadt->(dbclosearea())
endif
SELECT(nOldSelect)

Return NotCommas(nRetCount)

// batchCalc3 — real implementation from BMS/DELIVSCH.PRG
FUNCTION batchCalc3(cName)      //vitaly  98101301 20/12/99

LOCAL dRetVal := Ctod("  /  /  ")
IF cName == NIL ; cName := "d_line" ; ENDIF
dRetVal := date() + LTime_NoRoute(cName)+;
IIF((cName)->esnxx_id $ "_0B_",14 - GetIhur(cName),IIF((cName)->esnxx_id $ "_77_0G_" ,7 ,0 ) )
IF (cName)->b_stat == "T"
   dRetVal := dRetVal + 1
ENDIF
RETURN dRetVal

// GetIhur — helper for batchCalc3 (from BMS/DELIVSCH.PRG, was STATIC)
FUNCTION GetIhur(cName)

local nMRecNo,nMorder,lWasOpened,nRet := 0

IF Select("m_linemv") == 0
   NetUse("m_linemv",5)
   lWasOpened := .T.
ELSE
   lWasOpened := .F.
ENDIF
nMRecNo  := m_linemv->(RecNo())
nMorder := m_linemv->(ordsetfocus("ilnmvbn"))
IF (m_linemv->(DBSEEK( (cName)->B_ID  + "190.0" )) .OR. ;
   m_linemv->(DBSEEK( (cName)->B_ID  + "190.5" ))) .AND.;
   m_linemv->ARR
   nRet := date() - m_linemv->cp_darr
ENDIF

IF !lWasOpened
   m_linemv->(ordsetfocus(nMorder))
   m_linemv->(dbgoto(nMRecNo))
ELSE
   m_linemv->(dbclosearea())
ENDIF
Return nRet

// MybatchCalc3 — wrapper (from BMS/DELIVSCH.PRG)
FUNCTION MybatchCalc3(cName)
LOCAL dRetVal
RETURN (dRetVal := batchCalc3(cName))

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

// GetIndicators, SetCheckBlocks, SetTheDevices, PrnFace, GetDevType,
// GetSortType, GetSpreadFile — real implementation in BMS/PRNFACE.PRG

FUNCTION CustomPLine()
RETURN NIL

FUNCTION LExport()
RETURN NIL

// GetPrintFile — real implementation in BMS/PRNFACE.PRG

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

// GetPrinter — real implementation in BMS/PRNFACE.PRG

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

// aPrnCritPage — real implementation in BMS/PRNFACE.PRG

FUNCTION rpLinePlace()
RETURN NIL

FUNCTION rpRFldNew()
RETURN NIL

FUNCTION rpLFieldNew()
RETURN NIL

FUNCTION rpRebuildDisp()
RETURN NIL

// PrnHelpCrits — real implementation in BMS/PRNFACE.PRG

FUNCTION FillSubTitle()
RETURN NIL

FUNCTION SetKotMsg()
RETURN NIL

// PrnGetUserMsg — real implementation in BMS/PRNFACE.PRG

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
