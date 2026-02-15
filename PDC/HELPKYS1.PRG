 
#include "avxdefs.ch"
STATIC aHelpList
STATIC nAddedItems
 
FUNCTION HlpKeys(aKeyList,nT,nL)
 
LOCAL i:=1
LOCAL cScr
LOCAL cLine24 := SAVESCREEN(24,0,24,79)
LOCAL nCursor
LOCAL nB
LOCAL nR
LOCAL oHelp,oKotCol
LOCAL nKey,nPos
 
DEFAULT nT TO 1
DEFAULT nL TO 2
 
IF aKeyList != NIL
   aHelpList := aKeyList
ENDIF
 
nB    := nT + LEN( aHelpList)
nR    := nL + LEN( aHelpList[1,1])-1
cScr  := Win_Save(nT-1,nL-2,nB+2,nR+3)
oHelp := TBrowseNEW(nT,nL,nB,nR)
oHelp:colorSpec     := IF( ISCOLOR(),"GR+/BG,GR+/R","W/N,N/W")
oHelp:goTopBlock    := {|| i := 1 }
oHelp:goBottomBlock := {|| i := LEN( aHelpList ) }
oHelp:skipBlock     := {|n,si| si := i,;
                        i := IF(n>0,MIN(LEN(aHelpList),I+n),MAX(1,i+n)),i-si}
 
oHelp:addColumn(TBColumnNEW(Padl(":„Œ…’” ˜‡",Len(aHelpList[1,1])),{||aHelpList[i,1]}))
nCursor := SetCursor(SC_NONE)
 
IF ISCOLOR()
   Shadow(nT-2,nL-1,nB+2,nR+3)
END
DispBox(nT-1,nL-2,nB+1,nR+2,FRAME+" ",if(IsColor(),"w+/bg","w/n"))
@ nT-1,nR-12 say " ‰™— š…Œ…’” " color if(IsColor(),"w+/g","n/w")
Keys24("Close HELP:[F1]")
DO WHILE .T.
   DispBegin()
   DO WHILE NextKey()=0 .and. !oHelp:stabilize() ; ENDDO
   DispEnd()
   nKey := TimeOutInKey(0)
   DO CASE
      CASE nKey == K_DOWN  //chr(25) 
           oHelp:down()
      CASE nKey == K_UP    // chr(24) 
           oHelp:up()
      CASE nKey == K_ENTER ; EXIT
      CASE nKey == K_ESC
           nKey := 0
           EXIT
      CASE nKey == K_SPACE ; EXIT
      CASE nKey == K_F1    ; EXIT
      OTHERWISE
           IF( nPos:=Ascan(aHelpList,{|el| el[2] = nKey})) > 0
              nKey:=aHelpList[nPos,2]
              EXIT
           ENDIF
   ENDCASE
END
 
Win_Rest(cScr)
RESTSCREEN(24,0,24,79,cLine24)
//Keys24("Help:[F1]")
SetCursor(nCursor)
 
IF nKey = K_ENTER
   nKey := aHelpList[i,2]
ELSEIF nKey = K_F1    // close window
   nKey := 0
ENDIF
 
RETURN nKey
 
FUNCTION Read_Hlp_Keys(ah)
LOCAL bAction
IF  (bAction:=SetKey(HlpKeys(ah))) != NIL
    bAction:eval()
END
RETURN NIL
 
FUNCTION SetHlpKeys( aKeyList )
LOCAL aOldList := aHelpList
 
IF aKeyList != NIL
   aHelpList := aKeyList
ENDIF
 
RETURN aOldList
 
 
/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: Add2HlpKeys()         Docs:                                ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 07-09-96              Date updated: ş07-09-96              ³
 * ³ Time created: 02:33:37pm            Time updated: ş02:33:37pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: aKeyList                                                   ³
 * ³ Return Value: nAddedItems                                                ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION Add2HlpKeys( aKeyList )
nAddedItems := Len( aKeyList )
 
IF aHelpList = NIL
   aHelpList := {}
ENDIF
 
Aeval( aKeyList , {| aElement | Aadd( aHelpList , aElement) } )
 
RETURN nAddedItems
 
/*
 * ÚÄ Procedure ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: SizeHlpKeys()                                              ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine         Designer:                            ³
 * ³ Date created: 07-09-96              Date updated: ş07-09-96              ³
 * ³ Time created: 02:32:43pm            Time updated: ş02:32:43pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³   Parameters: nElements                                                  ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
PROCEDURE SizeHlpKeys( nElements )
LOCAL nNewSize
 
IF nElements = NIL
   nNewSize := Len( aHelpList ) - nAddedItems    // the added items from add2hlpkeys
ELSE
   nNewSize := nElements
ENDIF
 
IF nNewSize <= Len( aHelpList )
   Asize( aHelpList , nNewSize )
ELSE
   Alert( "You can only decrease the number of elements of help items")
ENDIF
 
RETURN
