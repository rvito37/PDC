// dirs.prg
// Function/Procedure Prototype Table  -  Last Update: 24-06-96 @ 14:52:53
// ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
// Return Value         Function/Arguments
// ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ  ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
// .T.                  STATIC FUNCTION Check( o , nKey)
// Void                 PROCEDURE GetInfo( nKey )
// Void                 PROC Dirs
// lHandled             FUNCTION ApplyKeys( nKey , o )
// aTemp                FUNCTION ListIt(cBuffer)
// aDirList             FUNCTION LoadDirs
// lUpdated             FUNCTION ShowDirs
// Void                 PROC WriteDirs
 
#include "avxdefs.ch"
 
STATIC aDirList := {}
STATIC oDirs
STATIC lUpdated
 
PROC Dirs
LOCAL cProgId := "GEN00001"
LOCAL cScr := scrnPush()
 
DispBox(4,1,20,77, FRAMECAPTION +" ",if(IsColor(),"w+/bg","w/n"))
@ 4,6  SAY " Directories çâòÖÉé öíâÅó " COLOR if(IsColor(),"w+/g","w/n")
IF IsColor()
   Shadow(4,1,20,77)
END
LoadDirs()
 
lUpdated := .F.
 
IF ShowDirs()
   IF Alert( "Data change has detected! ;Do you wish to update?    " , {"Yes","No"} ) = 1
      WriteDirs()
   ENDIF
ENDIF
 
scrnPop()
RETURN
 
FUNCTION LoadDirs
LOCAL cBuffer
LOCAL aDir
LOCAL nLen ,i
LOCAL cKeyWord,cPath,nAt
 
IF !File( "sysdirs" )
   MemoWrit("sysdirs","")
ENDIF
*
* cBuffer å Sysdirs èãÖö öÅñÑ
*
IF Empty( cBuffer := MemoRead("sysdirs") )
   aDir := { Space(10) + ":" , Space(60) }
ELSE
   aDir := ListIt(cBuffer)
ENDIF
nLen := Len(aDir)
 
aDirList := {}
FOR i :=  1 TO nLen
 
    nAt := At("=",aDir[i])
 
    IF nAt > 0
       cKeyWord := Padr(Upper(AllTrim(Substr(aDir[i],1,nAt - 1))),10)
       cPath    := Padr(Upper(AllTrim(Substr(aDir[i],nAt + 1))),60)
       Aadd( aDirList , { cKeyWord , cPath } )
    END
 
NEXT
 
RETURN aDirList
 
FUNCTION ListIt(cBuffer)
LOCAL aTemp := {}
LOCAL nAt
WHILE !Empty(cBuffer)
      nAt := At( Chr(13)+Chr(10), cBuffer )
      Aadd( aTemp , SubStr(cBuffer , 1 , nAt-1) )
      cBuffer := SubStr( cBuffer ,nAt + 2 )
END
RETURN aTemp
 
 
PROC WriteDirs
LOCAL i,nLen := Len(aDirList)
LOCAL cBuffer := ""
 
FOR i := 1 TO nLen
    IF !Empty(aDirList[i,2])
       cBuffer += AllTrim(Left(aDirList[i,1],10))+" = "+ AllTrim(aDirList[i,2])+Chr(13)+Chr(10)
    END
NEXT
 
MemoWrit("sysdirs",cBuffer)
 
RETURN
 
FUNCTION ShowDirs
LOCAL oTbc , nKey
LOCAL aKeyList:={;
                 {"Enter   -    òÖÉé èãÉí",K_ENTER },;
                 {"F9      -    òÖÉé ìëÖÑ",K_F9    },;
                 {"Del     -     ÑòÖô óáé",K_DEL   },;
                 {"Ctrl S  - çââÖêâô òÖéô",K_CTRL_S},;
                 {"Esc     -        çââë",K_ESC };
                }
Asort( aDirList ,,, {|x,y| x[1] < y[1] } )
oDirs := ABrowseNEW(5,2,19,76,aDirList )
 
oDirs:headSep   := "ÕÕÕ"
oDirs:colSep    := " = "
oDirs:colorSpec := UtilColors()
oTbc := TBColumnNEW("Category ", {|| oDirs:arrayReference[oDirs:arrayIndex,1]})
oTbc:width := 12
oDirs:addColumn(oTbc)
oTbc := TBColumnNEW("Drive & Path", {|| oDirs:arrayReference[oDirs:arrayIndex,2]})
oDirs:addColumn(oTbc)
 
WHILE .T.
 
    WHILE !oDirs:stabilize() ; ENDDO
 
    nKey := Inkey(0)
 
    ASK FOR HELP
 
    IF nKey = K_ESC
       EXIT
    ELSEIF StdKeys( nKey , oDirs )
 
    ELSEIF oDirs:stable .AND. ApplyKeys( nKey ,oDirs )
 
    ENDIF
 
ENDDO
 
RETURN lUpdated
 
FUNCTION ApplyKeys( nKey , o )
LOCAL lHandled := .T.
 
DO CASE
   CASE nKey = K_ENTER
        GetInfo( nKey )
   CASE nKey = K_F9
        GetInfo( nKey )
   CASE nKey = K_DEL
        IF Len( aDirList ) > 1   // you can not delete them all
           Adel( aDirList , oDirs:arrayIndex )
           Asize( aDirList , Len( aDirList ) - 1 )
           oDirs:refreshAll()
        ENDIF
   CASE nKey = K_CTRL_S
        WriteDirs()
 
   OTHERWISE
      lHandled := .F.
ENDCASE
 
RETURN lHandled
 
 
PROCEDURE GetInfo( nKey )
LOCAL cKeyWord
LOCAL cDirectory
LOCAL bInsSave
LOCAL nCursSave
 
IF nKey = K_F9
   cKeyWord   :=  Space(10)
   cDirectory :=  Space(60)
ELSE
   cKeyWord   :=  oDirs:arrayReference[oDirs:arrayIndex,1]
   cDirectory :=  oDirs:arrayReference[oDirs:arrayIndex,2]
ENDIF
 
//  Category :xxxxxxxxxx
//  Directory:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
 
 
 
scrnPush(7,3,13,77)
DispBox(7,3,12,76, FRAMECAPTION +" ",if(IsColor(),"w+/b","w/n"))
@ 7,6  SAY if( nKey=K_F9," NEW "," UPDATE ") + "Category " COLOR if(IsColor(),"w+/g","w/n")
AddShadow(7,3,12,76)
 
SetColor( GETCOLORS )
 
@  9,5 SAY "Category :"  COLOR "gr+/b"
@ 10,5 SAY "Directory:"  COLOR "gr+/b"
@ 9,15 GET cKeyWord      SEND preBlock  := {|o| nKey = K_F9  };
                         SEND postBlock := {|o| Check(o , nKey) } COLOR GETCOLORS ;
                         SEND picture   := "@!"
@10,15 GET cDirectory    SEND postBlock := {|o| Check(o) } COLOR GETCOLORS;
                         SEND picture   := "@!"
XREAD
 
GetList := {}
 
IF LastKey() = K_ENTER
 
   IF nKey = K_F9
      Aadd( oDirs:arrayReference , { cKeyWord , cDirectory } )
   ELSE
      oDirs:arrayReference[oDirs:arrayIndex,1] :=  cKeyWord
      oDirs:arrayReference[oDirs:arrayIndex,2] :=  cDirectory
   ENDIF
   lUpdated := .T.
   Asort( oDirs:arrayReference ,,, {|x,y| x[1] < y[1] } )
   oDirs:refreshAll()
ENDIF
scrnPop()
RETURN
 
STATIC FUNCTION Check( o , nKey)
LOCAL cBuffer := o:varGet()
LOCAL cSaveWorkingDir
LOCAL cSaveDestDir
IF LastKey() = K_UP
   RETURN .T.
ENDIF
 
IF Empty( cBuffer)
   Msg24( {"175"} , 3 , .T. )
   RETURN .F.
ENDIF
 
IF nKey = K_F9 .AND. Upper(o:name) = "CKEYWORD"
   IF Ascan( aDirList , {| element | element[1] == cBuffer } ) > 0
      Msg24( {"176"} , 3 ,.T. )
      RETURN .F.
   ENDIF
ENDIF
 
IF Upper(o:name) = "CDIRECTORY"
   cSaveWorkingDir := DiskName()+":"+DirName()
   IF SubStr( cBuffer , 2 , 1 ) == ":"
      cSaveDestDir := DirName(Left( cBuffer , 1 ) )
   ENDIF
 
   IF DirChange( cBuffer ) != 0
      Msg24( {"177" , AllTrim(cBuffer) } , 3 ,.T. )
      RETURN .F.
   ELSE
      DirChange(cSaveDestDir)
   ENDIF
   DirChange(cSaveWorkingDir)
ENDIF
 
RETURN .T.
