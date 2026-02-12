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
LOCAL cIndexBuffer //:= MemoRead("syskeys")
LOCAL i
LOCAL nCount
LOCAL cTempDir := GetUserInfo():cTempDir     //YGCDX
*
* aIndexInfo ™ Š˜’ •…— ™ ‰”Œ ‰… SysKyes •…— š–„
*
aIndexInfo := {}
             * YGCDX
             * NetUse( "SYSKEYS", STD_RETRY, , USE_SHARED, USE_NEW,cTempDir )
DBUSEAREA(.T.,,"SYSKEYS",,.T.,.T.)
             * nCount := syskeys->( FCOUNT() )
Syskeys->(ORDSETFOCUS("syskeys"))
Syskeys->(DBGOTOP())
                *******************************************************************
                *
                * IF .F.  //yg FIRST CDX VERSION
                * While ! SYSKEYS->( EOF() )
                *      //cTemp := ""
                *      //aTemp := &("{"+ syskeys->filename+","+syskeys->descriptio+","+;
                *      //         syskeys->tagname +","+syskeys->tagdesc+","+;
                *      //          syskeys->expration+","+syskeys->forcond+"}")
                *      cTemp := "{"+ syskeys->( FIELDGET(1) )
                *      cTemp = cTemp + ","
                *      FOR i := 2 TO nCount
                *           cTemp +=  syskeys->( FIELDGET(i) )
                *           IF i <> nCount
                *                cTemp = cTemp + ","
                *           ENDIF
                *      NEXT
                *      cTemp := cTemp +"}"
                *      aTemp := &(cTemp)
                *      AADD( aIndexinfo, aTemp)
                *      skip 1
                * END
                * ENDIF
                ***************************************************************************************
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
      SYSKEYS->(DBskip())
END
SYSKEYS->(DBCLOSEAREA())

                ******************************************************************************
                * WHILE !Empty(cIndexBuffer)
                *
                *       nPosition := At(NEWLINE,cIndexBuffer)
                *
                *       IF Left( SubStr(cIndexBuffer,1,nPosition-1) , 1 ) == "*"
                *
                *       ELSE
                *          aTemp  := &("{"+SubStr(cIndexBuffer,1,nPosition-1)+"}")
                *          Aadd( aIndexInfo , aTemp )
                *       ENDIF
                *
                *       cIndexBuffer := Substr(cIndexBuffer,nPosition + 2 )
                * END
                ****************************************************************************
RETURN

FUNCTION GetFileIndexInfo( cFile )  // if param is empty send all the index information
LOCAL aFileIndexInfo := {}
LOCAL cTemp, aTemp
                * the commented stuff works but doesn't seem to improve speed
                * and since it relies on the syskeys.ntx being updated we are better off
                * with the stupid way.  Maybe when syskeeys becomes much larger it will
                * be better to use the smart way
                * IF SELECT("SYSKEYS") == 0
                *      DBUSEAREA(.T.,,"SYSKEYS",,.T.,.T.)
                *      syskeys->(dbsetindex("syskeys"))
                * endif
                * syskeys->(ordsetfocus("syskeys"))

IF cFile == NIL
   RETURN aIndexInfo
ELSE
                     *************************************************************************
                     *    if syskeys->(dbseek(lower(cFile)))
                     *         while trim(syskeys->filename) == lower(cFile)
                     *              cTemp := '{"'+ trim(syskeys->filename)  +'","'+;
                     *                   trim(syskeys->descriptio)+'","'+;
                     *                   trim(syskeys->tagname)   +'","'+;
                     *                   trim(syskeys->tagdesc)   +'","'+;
                     *                   trim(syskeys->expration) +'",' +;
                     *                   trim(syskeys->forcond)   +'}'
                     *              aTemp := &(cTemp)
                     *              aadd(aFileIndexInfo,aTemp)
                     *              syskeys->(dbskip())
                     *         end
                     *    else //the old fashoined way
                     **************************************************************************
   * YH
   *  ‰‹˜’ aIndexInfo š€ €ŒŒ ‰ƒ‹ LoadIndexInfo() Œ „€‰˜— €‹ ‰š”‘…„
   *       .„€‰‚™ š’ƒ…„ šŒ—š VSCDX  … NIL €‰„ aIndexInfo ,‹ €Œ €™
   *
   IF aIndexInfo==NIL
      LoadIndexInfo()
   ENDIF
   *
   *        „Œ™ Tags „… ‰‘‹ƒ‰€„ ‰…š„ ‰–— š…™ š€ Œ‰‹ aIndexInfo Š˜’„
   *                   .LoadIndexInfo() ‰"’ –…„… SysKeys.dbf •…— €˜—™ ‰”‹
   * š…˜…™„ š€ aFileIndexInfo Œ  “‰‘… €„ Œ…ƒ…„ ,„‰–—…”Œ ‡Œ™™ cFile •…—Œ
   *         š…™ š€ Œ‰‹‰ ˜™€ aFileIndexInfo Œ—š‰ . aIndexInfo  …Œ š…‘‡‰š„
   *                                   .SysKeys.dbf   …—š’…‰™ •…—Œ ‰‘‹ƒ‰€„
   *
   Aeval( aIndexInfo ,;
   {| aIndexLine, i | if( Upper( aIndexLine[1] ) == Upper( cFile ),;
                  Aadd( aFileIndexInfo , aIndexLine ) , ) } )
ENDIF
                       *************************************
                       * IF select("syskeys") <> 0
                       *      syskeys->(dbclosearea())
                       * ENDIF
                       ****************************************
RETURN aFileIndexInfo
