Upload library PRG files here.

Required files (search with: dir /s G:\BMSBAR\SOURCE\*.prg and dir /s G:\DVLPDC\SOURCE\*.prg):

Classes:
- TabBase (tabbase.prg) - used by BNPATH, STOKWORK, STOKPROC, LMVCENTR
- UserInfo (userinfo.prg) - used by BMSBAR main
- Form (form.prg) - used by BMSBAR main
- TheReport (therep*.prg or report.prg) - used by RPQC36V1, QPQC37V1
- BroCenter (brocent*.prg) - used by LMVCENTR

Core utility functions:
- NetUse, GenOpenFiles, GenCloseFiles
- Msg24, Keys24, SetTitle, SetMsgMode
- StdKeys, RecLock, AddRec, xDbUnLock
- Top, Bot, SkipIt (TBrowse navigation)
- scrnPush, scrnPop, Win_Save, Win_Rest, Shadow
- ABrowseNEW, TBColumnNEW
- LoadIndexInfo, CheckIndex
- SetF2Key, PrePick
- barSetMoreGets, GoodEndCode, ShalInitvars
- GetEndType, Slack, CurrProcName
- PrnSetup, PrnReset
- BARC, BARCW (barcode functions)
- critBrowse, GetDate, GetBN, GetRemark
- deleteTempFiles
- NNetWhoAmI (or netto.prg)
- qemail, UP_DLINE
- IsSecurity, SetAccessLevel
- HebReader, Ishur1, MYRUN

Look in these directories:
- G:\BMSBAR\SOURCE\
- G:\DVLPDC\SOURCE\
- G:\AVXBMS\ (any .prg files)
