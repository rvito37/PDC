// Indxinfo.prg
// Function/Procedure Prototype Table  -  Last Update: 24-06-96 @ 14:56:02
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// Return Value         Function/Arguments
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// Void                 PROCEDURE LoadIndexInfo
// aFileIndexInfo       FUNCTION GetFileIndexInfo( cFile ) // if param is empty send all the index information

// G:\BMS\SOURCE\INDXINFO.PRG

#include "avxdefs.ch"

STATIC aIndexInfo


PROCEDURE LoadIndexInfo
LOCAL nPosition , aTemp ,cTemp
LOCAL cIndexBuffer
LOCAL i
LOCAL nCount
LOCAL cTempDir := GetUserInfo():cTempDir     //YGCDX
*
* aIndexInfo ™ Š˜’Ž •…— ™ ‰”Œ ‰…ŽŽ SysKyes •…— š–„
*
aIndexInfo := {}
DBUSEAREA(.T.,,"SYSKEYS",,.T.,.T.)
Syskeys->(ORDSETFOCUS("syskeys"))
*
* YH 16-11-00 ˜…–‰‰„ š”–˜ š”…’š ‚€ …—‰šŒ
*
Syskeys->(DBGOTOP())
WHILE ! Syskeys->( EOF() )    //YG second cdx version
                      * aTemp := &("{"+ syskeys->filename+","+syskeys->descriptio+","+;
                      *           syskeys->tagname +","+syskeys->tagdesc+","+;
                      *           syskeys->expration+","+syskeys->forcond+"}")
      cTemp := '{"'+ trim(syskeys->filename)  +'","'+;
                     trim(syskeys->descriptio)+'","'+;
                     trim(syskeys->tagname)   +'","'+;
                     trim(syskeys->tagdesc)   +'","'+;
                     trim(syskeys->expration) +'",' +;
                     trim(syskeys->forcond)   +'}'
      aTemp := &(cTemp)
      Aadd(aIndexinfo, aTemp)
      skip 1
END
SYSKEYS->(DBCLOSEAREA())
RETURN
*
FUNCTION GetFileIndexInfo( cFile )  // if param is empty send all the index information
LOCAL aFileIndexInfo := {}
LOCAL cTemp, aTemp

IF cFile == NIL
   RETURN aIndexInfo
ELSE
   * YH
   *  ‰‹˜’ aIndexInfo š€ €ŒŽŒ ‰ƒ‹ LoadIndexInfo() Œ „€‰˜— €‹ ‰š”‘…„
   *       .„€‰‚™ š’ƒ…„ šŒ—šŽ VSCDX  … NIL €‰„ aIndexInfo ,‹ €Œ €™
   *
   IF aIndexInfo==NIL
      LoadIndexInfo()
   ENDIF
   *
   *        „Œ™ Tags „… ‰‘‹ƒ‰€„ ‰…š„ ‰–— š…Ž™ š€ Œ‰‹Ž aIndexInfo Š˜’Ž„
   *                   .LoadIndexInfo() ‰"’ –…„… SysKeys.dbf •…—Ž €˜—™ ‰”‹
   * š…˜…™„ š€ aFileIndexInfo Œ  “‰‘…Ž €„ Œ…ƒ…Ž„ ,„‰–—…”Œ ‡Œ™™ cFile •…—Œ
   *         š…Ž™ š€ Œ‰‹‰ ˜™€ aFileIndexInfo Œ—š‰ . aIndexInfo  …Œ š…‘‡‰šŽ„
   *                                   .SysKeys.dbf  Ž …—š’…‰™ •…—Œ ‰‘‹ƒ‰€„
   *
   Aeval( aIndexInfo ,;
   {| aIndexLine, i | if( Upper( aIndexLine[1] ) == Upper( cFile ),;
                  Aadd( aFileIndexInfo , aIndexLine ) , ) } )
ENDIF

RETURN aFileIndexInfo
