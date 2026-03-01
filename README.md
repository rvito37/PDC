# AVX PDC — Production Data Collection System

Clipper 5.3 → Harbour 3.2 migration. Israeli manufacturing ERP (Kyocera AVX).
Barcode scanning, QC, batch movement, label printing, shipping/yield reports.

**Status**: ✅ Compiles and runs. Main menu loads, ADS connects, user auth works.

---

## Build

### Requirements
- **Harbour 3.2.0dev** (r2602120139) — `C:\harbour-mingw\hb32`
- **MinGW GCC** (bundled) — `C:\harbour-mingw\hb32\comp\mingw\bin\gcc.exe`
- **ADS Client** — `ace32.dll` in PATH or app directory

### Compile
```bash
cd PDC
set PATH=C:\harbour-mingw\hb32\comp\mingw\bin;C:\harbour-mingw\hb32\bin;%PATH%
hbmk2 bmsbar.hbp -comp=mingw
```

### Run
```
BMSBAR.exe VITALY
```
Parameter = username from `d_user.dbf`. Without param reads `c:\bmsname.txt`.

---

## Project Structure (89 files — minimum for compilation)

```
PDC-clean/
├── PDC/              # 19 PRG + bmsbar.hbp  (main app + build)
├── BMS/              # 13 PRG + 46 CH       (business logic + all headers)
└── LIB/              # 11 PRG               (shared library)
```

### PDC/ — Main Application (19 PRG)

| File | Purpose |
| --- | --- |
| **BMSBAR.PRG** | ★ Entry point. BmsBarMain, ADS init, menu, ~97 functions |
| **BMSBAR2.PRG** | BNleave, barSetMoreGets, rejection system, update handlers |
| **BMSBAR3.PRG** | DoEndOfBatch, DoFinQc, DoKitFinQc, QC docs, ESN |
| **BMSBAR4.PRG** | QcDoc — QC document display/print |
| **BMSBAR5.PRG** | QcPackDoc — QC pack document display/print |
| **BNPATH.PRG** | Batch path query — history of batch movements |
| **FUNCS.PRG** | YosUse — DB open with retry |
| **HELPKYS1.PRG** | Help keys display |
| **LMVCENTR.PRG** | ProcCenter, Advance1Step — batch movement controller |
| **MISCALL.PRG** | MisCall — task/call form |
| **PRODLABS.prg** | Production labels printing |
| **QPQC37V1.PRG** | Shipping query (AWB, batch) |
| **RPQC36V1.prg** | Yield analysis — specs, tolerances, performance |
| **STOKPROC.PRG** | WIP by process query |
| **STOKWORK.PRG** | WIP by workstation query |
| **SUBMENU.prg** | SubMenu CLASS — popup menu with navigation |
| **TAPILABS.PRG** | Kyocera label printing |
| **stubs.prg** | ★ Compatibility layer — ADS wrappers, Novell stubs, misc |
| **bmsbar.hbp** | ★ Build project file |

### BMS/ — Business Modules (13 PRG + 46 CH)

**PRG files compiled:**
AVXFUNCS, AVXUTI, CTRLGET, INDXINFO, LOCKS, ORDGET, PRNCRIT,
QTYCON, RIGHTS, THEREPO, UP_DLINE, USERINFO, PARTBASE

**Excluded PRG (duplicates):**
- `AVXBMS.PRG` — duplicates PushMenu, PopMenu, GetUserInfo from BMSBAR.PRG
- `TAPILABS.PRG` — duplicates PDC/TAPILABS.PRG

**Key CH headers:**
| Header | Role |
| --- | --- |
| **AVXDEFS.CH** | ★ Master header — includes all others, defines constants, paths, RDD |
| **CLASSY2.CH** | ★ Redirects to `hbclass.ch` (was Class(y) v2.4, now Harbour native) |
| **dbfcdxax.ch** | ★ ADS RDD — `ads.ch` + REQUEST ADSCDX/DBFCDX + command mappings |
| **NETTO.CH** | Network constants and macros (Novell NetWare → stubs) |
| **newclass.ch** | Empty (Harbour doesn't need it) |
| **endclass.ch** | Empty (Harbour doesn't need it) |
| **LFNLIB.ch** | Empty stub (Harbour has native LFN support) |

All 46 CH files in BMS/ are needed — they're referenced via `-incpath=../BMS` in hbp.

### LIB/ — Shared Library (11 PRG)

| File | Purpose |
| --- | --- |
| ABROWSER.PRG | Array browser UI |
| DIRS.PRG | LoadDirs() — reads `sysdirs` config file |
| FORM.PRG | Form CLASS — windows/dialogs with shadow |
| HEBSYS.PRG | Hebrew text system |
| MSGKEYS.PRG | Msg24/Keys24 — status bar messages |
| SCRNPP.PRG | Screen push/pop |
| SHADOW.PRG | Shadow() — window shadow effect |
| STDKEYS.PRG | StdKeys() — stub (5 lines) |
| TABBASE.PRG | TabBase CLASS — table/index wrapper |
| TITLE.PRG | SetTitle — window title bar |
| TOINKEY.PRG | ToInkey — keyboard input wrapper |

**Excluded LIB (duplicate):** `HLPKEYS.PRG` — duplicates PDC/HELPKYS1.PRG

---

## Clipper → Harbour Migration Map

### ADS RDD (stubs.prg)
Old DBFCDXAX driver replaced with Harbour ADSCDX via `rddads.hbc` contrib.

| Clipper (AX_*) | Harbour (Ads*) |
| --- | --- |
| AX_ChooseOrdBagExt | AdsSetFileType(ADS_CDX) |
| AX_RightsCheck | AdsRightsCheck() |
| AX_TagCount | OrdCount() |
| AX_SetTag | OrdSetFocus() |
| AX_TagInfo | OrdName/OrdKey/OrdFor loop |
| AX_IsShared | DbInfo(DBI_SHARED) |
| AX_AXSLocking | AdsLocking() |
| AX_CacheRecords | AdsCacheRecords() |
| AX_SetServerAOF | AdsSetAOF() |
| AX_ClearServerAOF | AdsClearAOF() |
| AX_Transaction | AdsInTransaction/AdsBegin/AdsCommit/AdsRollback |
| AX_KillTag | OrdDestroy() |
| AX_KeyCount | OrdKeyCount() |
| AX_KeyNo | OrdKeyNo() |
| AX_KeyGoto | OrdKeyGoto() |
| DBFCDXAX() | Returns "ADSCDX" |
| DBI_ISEXCLUSIVE | DBI_SHARED (reversed logic!) |

### ADS Init Sequence (BMSBAR.PRG)
```harbour
#include "ads.ch"
REQUEST DBFCDX
REQUEST ADS

rddRegister( "ADS", 1 )
rddsetdefault( "ADS" )
SET SERVER REMOTE
SET FILETYPE TO CDX
SET DEFAULT TO G:\AVXBMS
```

### Class(y) OOP (CLASSY2.CH)
Harbour has built-in Class(y) compatibility via `HB_CLS_CSY` in `hbclass.ch`.
Replaced 242-line Class(y) v2.4 definitions with single `#include`` "hbclass.ch"`.

### Novell NetWare (stubs.prg)
All `fn_*` functions return safe defaults:
- `fn_LoggedIn()` → .T.
- `fn_nwLogout()` → 0
- `fn_connID()` → {{0,0,0,0,0,0,0,0,0}}
- `fn_NWFullName()` → ""
- etc.

### Build Dependencies (bmsbar.hbp)
```
hbnf.hbc     — NanFor library (FT_* functions)
hbxpp.hbc    — xBase++ compatibility
rddads.hbc   — ADS RDD driver (links ace32.dll)
```

### Other Stubs in stubs.prg
| Function | What it was | Stub returns |
| --- | --- | --- |
| SysColors() | Novell colors | NIL |
| HideAll() | Screen hiding | NIL |
| SwpRunCmd() | Shell exec | hb_run() |
| CanNotProcess() | Access denied | Alert |
| PaintRow() | TBrowse paint | o:refreshCurrent() |
| StevePrintSomeLabels() | Label printing | NIL |
| LDesc() | Line description | "" |
| SetCap/CloseCap/OpenCap | Report capture | NIL/.T. |
| BarGrow/BarInit | Progress bar | NIL |
| TbPrint/SendToPrinter | Printing | NIL |

---

## Runtime Environment

### Production Server
- ADS data on `G:\AVXBMS` (drive G: = `Bms on 'Avx-bms'`)
- SET SERVER REMOTE — ADS server on same machine
- `sysdirs` file in PDC/ directory (NOT in git — create on deployment):
```
DBF = G:\AVXBMS
ROUDELETED = G:\AVXBMS\ROUTE\DELETED
ROUTE = G:\AVXBMS\ROUTE
PRNOUT = G:\AVXBMS\PRNOUT
USERINFO = G:\AVXBMS\INIDEFS
WIPCOST = G:\AVXBMS\WIPSC
WIPDELETED = G:\AVXBMS\WIPSC\DELETED
SVAL = G:\AVXBMS\SVAL\SVAL
SVALMV = G:\AVXBMS\SVAL\SVALMV
```

### User Authentication
- `d_user.dbf` in DBF directory — user table
- `.INI` files in `USERINFO` directory (e.g., `VITALY.ini`)
- `.MAP` files in `USERINFO` directory (e.g., `VITALY.map` — access rights)
- `c:\bmsname.txt` — fallback username if no command-line param

### Logging
- `bmsbar.log` — created in working directory
- `LogWrite()` function in BMSBAR.PRG
- `BmsErrorHandler()` — catches errors, logs call stack, shows Alert

---

## Header Include Chain

```
BMSBAR.PRG
├── ads.ch              (Harbour ADS contrib)
├── avxdefs.ch          (★ master header)
│   ├── abrowser.ch
│   ├── Box.ch
│   ├── Checkdef.ch / Checks.ch
│   ├── classy2.ch      → hbclass.ch (Harbour native)
│   ├── Combobox.ch / Combodef.ch
│   ├── common.ch
│   ├── dbfCDXax.ch     → ads.ch + REQUEST ADSCDX
│   ├── Dbstruct.ch
│   ├── directry.ch
│   ├── fileio.ch
│   ├── Getexit.ch
│   ├── inkey.ch
│   ├── radiobtn.ch / Radiodef.ch / Radios.ch
│   ├── set.ch / setcurs.ch
│   └── LFNLIB.ch       (empty stub)
└── netto.ch            (Novell NetWare macros)
```

---

## Known Issues (TODO)

1. **Hebrew display** — shows garbled (codepage 862 needed). Try `hb_cdpSelect("IL862")` or `hb_SetTermCP("CP862")`
2. **SUBMENU.prg** — uses `#include "class(y).ch"` and has typo `RETUR nKey` → should be `RETURN nKey` and use `hbclass.ch`
3. **Stub functions** — many functions are stubs (printing, reports, Hebrew reader). When deeper functionality is needed, real implementations from production BMS source should replace them
4. **Report system** — TheReport class, BroCenter class, critBrowse, ABrowseNEW, HebReader — all need real implementations from production source
5. **Printing** — fn_* Novell printing is stubbed out, TbPrint/SendToPrinter need real implementation
