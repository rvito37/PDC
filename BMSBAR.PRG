// Bmsbar.prg
// Function/Procedure Prototype Table  -  Last Update: 24-06-96 @ 14:50:02
// ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
// Return Value         Function/Arguments
// ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ  ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
// Void                 PROCEDURE BNenter
// Void                 PROCEDURE BarUpdate( cWidSta )
// Void                 PROCEDURE BmsBarMain
// Void                 PROCEDURE CloseInfoFile
// Void                 PROCEDURE OpenInfoFile
// Void                 PROCEDURE ProductionRepsb
// Void                 PROCEDURE PutS1OnScreen
// Void                 PROCEDURE SayLogo
// Void                 PROCEDURE ShowS2()
// Void                 PROCEDURE bmsQueries()
// Void                 PROCEDURE enterClose
// lRetVal              FUNCTION BidExists(o)
// cErrorFile           FUNCTION GetErrorFile
// { { NIL,NIL,"ims...  FUNCTION GetFileIndexInfo( cFile )
// oUserInfo            FUNCTION GetUserInfo
// lAdMin               FUNCTION IsAdMin
// lRetVal              FUNCTION Negative( o )
// lRetVal              FUNCTION ProcExists(o)
// lRetVal              FUNCTION WidExists(o)
// nOpenedFiles = 4     FUNCTION enterOpen
// lRetVal              FUNCTION postStage(o , bCheck , lFinCode )

#translate OldTitle(<a>)  => SetTitle( <a>\[1\] , <a>\[2\] )

#include "avxdefs.ch"
#include "netto.ch"

#define PRN_QUEUE       1
#define PRN_NAME        2
#define PRN_LANPRINTER  3
#define PRN_SETUP       4
#define PRN_RESET       5
#define PRN_6LPI        6
#define PRN_8LPI        7
#define PRN_10CPI       8
#define PRN_12CPI       9
#define PRN_COMPR      10
#define PRN_PORT       11
#define PRN_LAND       12
#define PRN_BDON       13
#define PRN_BDOFF      14
#define PRN_ULON       15
#define PRN_ULOFF      16
#define PRN_ITON       17
#define PRN_ITOFF      18
#define PRN_LANSERVER  19
#define  COLORS_FIRST     "W+/BG,W+/B*"
#define  COLORS_SECOND    "W+/B*,W+/R*"
#define  HEADSEP    CHR(205) + CHR(209) + CHR(205)
#define  COLSEP     CHR(32)  + CHR(179) + CHR(32)
#define  FOOTSEP    CHR(205) + CHR(207) + CHR(205)
#define BACKGROUND DispBox(0,0,MaxRow(),MaxCol(),Replicate(" ",9))
#define CAPTION 1
#define ROW     2
#define COL     3
#define LABELAPP .T.



STATIC aoOpenedList
STATIC cErrorFile
STATIC oUserInfo
STATIC lAdMin    := .F.
STATIC CMyDriver
STATIC aGoodKeys := {K_ENTER,K_PGDN, K_PGUP,K_CTRL_END}
STATIC lEnglish
STATIC aAllocRecNo
STATIC aTree
STATIC aMenuList  := {}
STATIC aMenuStack := {}
STATIC oMenu
STATIC aColors

static pBarRow, pBarCol, pBarWidth, pScaleColr, pBarColor, pBarStep


/******************************************************************/
PROCEDURE BmsBarMain(cParam1)

LOCAL cTempStr,i,j
LOCAL cProgId := "MAIN"
LOCAL cOpenErr := ""
LOCAL cMenuCaption := "A V X  P D C" , nExitCode
LOCAL oForm


RDDSETDEFAULT(GetMyDriver())
AX_ChooseOrdBagExt(".CDX")
AX_AutoOpen(TRUE)

SET EXCLUSIVE OFF
SET DELETE ON

IF cParam1 != NIL
	cParam1:= Upper( cParam1 )
ENDIF


oUserInfo := UserInfo():new(cParam1)   // creates user info & net info
//FT_OnIdle({||FT_IAmIdle(20,.T.)})


IF !oUserInfo:canProcess( cProgId )
   CanNotProcess()
   RETURN
END

IF !SetCap()
   CloseCap()
END


IF IsColor()
   SetColor( "W+/B,W+/R,,,W+/B" )
   aColors := {"w+/bg","gr+/bg","r/bg","gr+/r+","g+/r+"}
ELSE
   SetColor( "W/N" )
   aColors := {"w/n"  ,"w/n"   ,"w+/n","n/w"   ,"w+/n"}
END


SET EPOCH TO 1990
SET EXCL OFF

SetColor("gr+/b")

//SET CURSOR OFF
BACKGROUND

SetTitle( "A V X  P D C" , ProcName() )
SET RIGHTS CHECKING OFF
SetMsgMode( .T. )
LoadIndexInfo()

//OpenInfoFile()

//LoadUserIni()

IF(oUserInfo:cdbfDir == "\TEST\")
  cTempStr := space(55) + "Test Environment\User:" + oUserInfo:cUserID
  FOR i := 1 TO  70
   FOR j := 1 TO 10000
   NEXT
   Keys24("Help:[F1]" + Right(cTempStr,70))
  NEXT
ELSE
   Keys24("Help:[F1]")
ENDIF

MenuStructure()

MakeList()

PushMenu( cMenuCaption )

oMenu := SelectMenu( cMenuCaption )

oMenu:show()

WHILE .T.

   nExitCode := oMenu:selectItem()

   DO CASE
      CASE nExitCode = K_ESC         // select previous menu

           oMenu:hide()

           PopMenu()

           IF Empty( aMenuStack )  // end of stack
              EXIT
           ELSE
              cMenuCaption := Atail( aMenuStack )
              oMenu := SelectMenu( cMenuCaption )
           END
      CASE nExitCode = K_ENTER      //  select next menu or operation
           IF oMenu:lActive
              IF ValType(oMenu:bItemAction) == "B"
					  oForm := Form():new(,,,," ",, ProcName() )
					  oMenu:exec()
					  oForm:hide()
              ELSE
                 PushMenu( oMenu:bItemAction )
                 cMenuCaption := Atail( aMenuStack )
                 oMenu := SelectMenu( cMenuCaption )
					  IF cMenuCaption == "Production Floor Data Collection System"
						  lEnglish := TRUE
					  ELSEIF cMenuCaption == "òÖñâÑ öîñòé çâêÖöê ìÖëâÄ äòíé"
                    lEnglish := FALSE
					  ENDIF
                 oMenu:show()
              END
           ELSE
              Tone( 300,1)
              Alert("Menu item not active")
           END
      CASE nExitCode = K_ALT_F10
           HideAll()
           EXIT
   END

END

CLS

IF aoOpenedList<> NIL ; AvxCloseFiles() ; ENDIF
//CloseInfoFile()

RETURN



RETURN

Function IfEnglish()
IIF(Empty(lEnglish) ,lEnglish := FALSE  ,nil )
Return lEnglish


PROCEDURE bmsQueries()
LOCAL cScreen := SaveScreen()
LOCAL nOption

WHILE .T.    // main loop
     CLS
     IF IsColor()
          SetColor( "W+/B,W+/R,,,W+/B" )
     ELSE
          SetColor( "W/N,N/W,,,N/W" )
     ENDIF
     SayLogo()

	  IF !IfEnglish()
        @ 8  , 23 SAY "⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø"
        @ 9  , 23 SAY "≥             öÖöåâÄô              ≥"
        @ 10 , 23 SAY "√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥"
        @ 11 , 23 SAY "≥ 1                    äâåÑöÅ âÄåé ≥"
        @ 12 , 23 SAY "≥ 2                     ÑêáöÅ âÄåé ≥"
        @ 13 , 23 SAY "≥ 3                      Ñêé åÖåëé ≥"
        @ 14 , 23 SAY "≥ 0               çÉÖó àâòîöå ÑòÜá ≥"
        @ 15 , 23 SAY "¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ"

        @ 11 , 25 PROMPT "1                    äâåÑöÅ âÄåé"
        @ 12 , 25 PROMPT "2                     ÑêáöÅ âÄåé"
        @ 13 , 25 PROMPT "3                      Ñêé åÖåëé"
        @ 14 , 25 PROMPT "0               çÉÖó àâòîöå ÑòÜá"
	  ELSE
        @ 8  , 23 SAY "⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø"
        @ 9  , 23 SAY "≥             Queries              ≥"
        @ 10 , 23 SAY "√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥"
        @ 11 , 23 SAY "≥ 1 Process WIP                    ≥"
        @ 12 , 23 SAY "≥ 2 Workstation WIP                ≥"
        @ 13 , 23 SAY "≥ 3 Batch line movement            ≥"
        @ 14 , 23 SAY "≥ 0 Previous Menu                  ≥"
        @ 15 , 23 SAY "¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ"

        @ 11 , 25 PROMPT "1 Process WIP"
        @ 12 , 25 PROMPT "2 Workstation WIP"
        @ 13 , 25 PROMPT "3 Batch line movement"
        @ 14 , 25 PROMPT "0 Previous Menu"
	  ENDIF

     MENU TO nOption

     Scroll( 8,23,15,58)
     DO CASE
        CASE nOption = 1
             StockInProc()
        CASE nOption = 2
             StockInWorkStation()
        CASE nOption = 3
             BNpath()
        CASE nOption = 4
             EXIT
        OTHERWISE
             EXIT
     ENDCASE
ENDDO  // main loop
RestScreen( ,,,, cScreen )
RETURN

PROCEDURE BNenter
LOCAL cScreen := SaveScreen()
LOCAL cLine24
LOCAL mB_ID      := Space( 6 )
LOCAL mCP_WIDSTA := "     "
LOCAL mCPPROC_ID := 0
LOCAL mCP_STAGE  := 0
LOCAL mConfirm := .Y.
LOCAL bCheck :=  {|| m_linemv->arr .AND. !m_linemv->sta .AND. !m_linemv->fin }

IF !enterOpen()
   Alert( "Can not open " + cErrorFile )
   RETURN
ENDIF
CLS
SayLogo()
PutS1OnScreen()
IF !IfEnglish()
   @  8,29 GET mB_ID       PICTURE "@K 999999" SEND postBlock := { |o| BidExists(o) }
   @  9,30 GET mCP_WIDSTA  PICTURE "@K 99999"  SEND postBlock := { |o| WidExists(o) }
   @ 10,30 GET mCPPROC_ID  PICTURE "@K 999.9"  SEND postBlock := { |o| ProcExists(o,mCP_WIDSTA) }
   @ 11,31 GET mCP_STAGE   PICTURE "@K 9999"   SEND postBlock := { |o| postStage(o,bCheck,,Alltrim(Str(mCPPROC_ID)) ) }
   @ 12,34 GET mConfirm    PICTURE "Y" SEND postBlock := { |o| EngIns(o,mB_ID,str(mCPPROC_ID,5,1),IfEnglish()) }
ELSE
   @  8,40 GET mB_ID       PICTURE "@K 999999" SEND postBlock := { |o| BidExists(o) }
   @  9,41 GET mCP_WIDSTA  PICTURE "@K 99999"  SEND postBlock := { |o| WidExists(o) }
   @ 10,41 GET mCPPROC_ID  PICTURE "@K 999.9"  SEND postBlock := { |o| ProcExists(o,mCP_WIDSTA) }
   @ 11,42 GET mCP_STAGE   PICTURE "@K 9999"   SEND postBlock := { |o| postStage(o,bCheck,,Alltrim(Str(mCPPROC_ID))) }
   @ 12,45 GET mConfirm    PICTURE "Y" SEND postBlock := { |o| EngIns(o,mB_ID,str(mCPPROC_ID,5,1),IfEnglish()) }
ENDIF
READ

IF ASCAN( aGoodKeys, LASTKEY() ) > 0
   IF mConfirm
      BarUpdate( mCP_WIDSTA )
		UpdLoc(mB_ID,mCP_WIDSTA)
			NetUse("c_warea",5)
			c_warea->(ordsetfocus(2))
			NetUse("d_warea",5)
			d_warea->(ordsetfocus(2))
			if d_warea->(dbseek(mCP_WIDSTA))          .AND. ;
				c_warea->(dbseek(str(mCPPROC_ID,5,1))) .AND. ;
				d_warea->warea_id <> c_warea->warea_id .AND. ;
			   d_warea->( RecLock( 5 ) )

				d_warea->FINISH_D := Date()
				d_warea->FINISH_T := Left( Time() , 5 )
				d_warea->(dbunlock())
				IF d_warea->( AddRec(5) )
				   d_warea->warea_id := c_warea->warea_id
				   d_warea->desc     := c_warea->desc
				   d_warea->w_id     := mCP_WIDSTA
				   d_warea->START_D  := Date()
				   d_warea->START_T  := Left( Time() , 5 )

				   d_warea->(dbunlock())
				ENDIF
				Msg24("Finish in your previous work has been reported !" , 2 , .T. )
			elseif !d_warea->(dbseek(mCP_WIDSTA))          .AND. ;
			 	     c_warea->(dbseek(str(mCPPROC_ID,5,1))) .AND. ;
			 	     d_warea->( AddRec(5) )

					 d_warea->warea_id := c_warea->warea_id
					 d_warea->desc     := c_warea->desc
					 d_warea->w_id     := mCP_WIDSTA
					 d_warea->START_D  := Date()
					 d_warea->START_T  := Left( Time() , 5 )
					 d_warea->(dbunlock())
					 Msg24("Start in your new work has been reported !" , 2 , .T. )
			endif
			c_warea->(dbcloseArea())
			d_warea->(dbcloseArea())
	else
      Tone( 200, 2 )
      cLine24 := SaveScreen( 24,0,24,79)
      @ 24,0 SAY IIF(!IfEnglish() ,Padc( "ÑåàÖÅ ÑåÖíîÑ" , 80 ) ,Padc( "Operation aborted" , 80 ) ) COLOR if( IsColor() , "W+/R" , "N/W" )
      InKey(2)
      RestScreen( 24,0,24,79 , cLine24 )
   ENDIF
ENDIF

enterClose()
RestScreen( ,,, cScreen )
RETURN

static  function EngIns(o,mB_ID,mCPPROC_ID,lEng)

local lRet := TRUE
local nOldarea := Select()

Netuse("c_engri",5)
c_engri->(ordsetfocus("itop"))

IF c_engri->(dbseek(m_linemv->ptype_id + m_linemv->pline_id + m_linemv->size_id + str(m_linemv->value_id,8,3) + m_linemv->tol_id + mCPPROC_ID)) .OR. ;
	c_engri->(dbseek(m_linemv->ptype_id + m_linemv->pline_id + m_linemv->size_id + str(0,8,3) + m_linemv->tol_id + mCPPROC_ID)) .OR. ;
	c_engri->(dbseek(m_linemv->ptype_id + m_linemv->pline_id + m_linemv->size_id + str(0,8,3) + " " + mCPPROC_ID)) .OR. ;
	c_engri->(dbseek(m_linemv->ptype_id + m_linemv->pline_id + m_linemv->size_id + str(m_linemv->value_id,8,3) + " " + mCPPROC_ID))

	AlertEng(lEng)

 ENDIF


c_engri->(dbclosearea())
dbselectarea(nOldarea)

Return lRet

Static Procedure AlertEng(lEng)

local mMemo := c_engri->minstr

IF !lEng
	Alert("Mask ID is : " +  c_engri->mask_id)
ELSE
	inkey(1)

	set cursor on

	@04,09 TO 21,70 DOUBLE COLOR "w+/bg"
	mMemo := MEMOEDIT(mMemo,5,10,20,69,.F.)
ENDIF

Return

PROCEDURE BNarrive // 00072403 Vitaly 27-03-01
LOCAL cScreen := SaveScreen()
LOCAL cLine24
LOCAL mB_ID      := Space( 6 )
LOCAL mCPPROC_ID := 0
LOCAL mCP_STAGE  := 0
LOCAL mCP_WIDSTA := "     "
LOCAL mConfirm := .Y.
LOCAL bCheck :=  {|| !m_linemv->arr .AND. !m_linemv->sta .AND. !m_linemv->fin  .AND. m_linemv->cpproc_id == d_line->cpproc_id }

IF !enterOpen()
   Alert( "Can not open " + cErrorFile )
   RETURN
ENDIF
CLS
SayLogo()
PutSArriveOnScreen()
IF !IfEnglish()
   @  8,29 GET mB_ID       PICTURE "@K 999999" SEND postBlock := { |o| BidExists(o) }
   @  9,30 GET mCP_WIDSTA  PICTURE "@K 99999"  SEND postBlock := { |o| WidExists(o) }
   @ 10,30 GET mCPPROC_ID  PICTURE "@K 999.9"  SEND postBlock := { |o| ProcExists(o) }
	@ 11,31 GET mCP_STAGE   PICTURE "@K 9999"   SEND postBlock := { |o| postStage(o,bCheck ) }
	@ 12,34 GET mConfirm    PICTURE "Y"
ELSE
   @  8,40 GET mB_ID       PICTURE "@K 999999" SEND postBlock := { |o| BidExists(o) }
   @  9,41 GET mCP_WIDSTA  PICTURE "@K 99999"  SEND postBlock := { |o| WidExists(o) }
   @ 10,41 GET mCPPROC_ID  PICTURE "@K 999.9"  SEND postBlock := { |o| ProcExists(o) }
	@ 11,42 GET mCP_STAGE   PICTURE "@K 9999"   SEND postBlock := { |o| postStage(o,bCheck ) }
	@ 12,45 GET mConfirm    PICTURE "Y"
ENDIF

READ

IF ASCAN( aGoodKeys, LASTKEY() ) > 0
   IF mConfirm
      ArriveUpdate( mCP_WIDSTA,bCheck )
		UpdLoc(mB_ID,mCP_WIDSTA)
		/*NetUse("c_warea",5)
		c_warea->(ordsetfocus(2))
		NetUse("d_warea",5)
		d_warea->(ordsetfocus(2))
		if d_warea->(dbseek(mCP_WIDSTA)) .AND. ;
			c_warea->(dbseek(str(mCPPROC_ID,5,1)))       .AND. ;
			d_warea->warea_id <> c_warea->warea_id .AND. ;
		   d_warea->( RecLock( 5 ) )

			d_warea->FINISH_D := Date()
			d_warea->FINISH_T := Left( Time() , 5 )
			d_warea->(dbunlock())
			IF d_warea->( AddRec(5) )
			   d_warea->warea_id := c_warea->warea_id
			   d_warea->desc     := c_warea->desc
			   d_warea->w_id     := mCP_WIDSTA
			   d_warea->START_D  := Date()
			   d_warea->START_T  := Left( Time() , 5 )

			   d_warea->(dbunlock())
			ENDIF
			Msg24("Finish in your previous work has been reported..." , 2 , .T. )
		elseif !d_warea->(dbseek(mCP_WIDSTA))          .AND. ;
			 	  c_warea->(dbseek(str(mCPPROC_ID,5,1))) .AND. ;
			 	  d_warea->( AddRec(5) )

				 d_warea->warea_id := c_warea->warea_id
				 d_warea->desc     := c_warea->desc
				 d_warea->w_id     := mCP_WIDSTA
				 d_warea->START_D  := Date()
				 d_warea->START_T  := Left( Time() , 5 )
				 d_warea->(dbunlock())
				 Msg24("Start in your new work has been reported !" , 2 , .T. )
		endif
		c_warea->(dbcloseArea())
		d_warea->(dbcloseArea())*/
   ELSE
      Tone( 200, 2 )
      cLine24 := SaveScreen( 24,0,24,79)
      @ 24,0 SAY IIF(!IfEnglish() ,Padc( "ÑåàÖÅ ÑåÖíîÑ" , 80 ) ,Padc( "Operation aborted" , 80 ) ) COLOR if( IsColor() , "W+/R" , "N/W" )
      InKey(2)
      RestScreen( 24,0,24,79 , cLine24 )
   ENDIF
ENDIF
enterClose()
RestScreen( ,,, cScreen )
RETURN

procedure Updloc(mB_ID,mCP_WIDSTA)

local nOldarea := Select()

Netuse("m_loc",5);ordsetfocus(1)


if m_loc->(dbseek(d_line->b_id))
	While m_loc->b_id == d_line->b_id
			m_loc->(dbskip(1))
	End
	m_loc->(dbskip(-1))
     IF !"òÖñâ" $ m_loc->loc
		IF m_loc->( AddRec(5) )
			m_loc->b_id := mB_ID
         m_loc->loc := "òÖñâ"
			m_loc->cremark := "PDC Update"
			m_loc->cp_wid := mCP_WIDSTA
			m_loc->(dbunlock())
		ENDIF
	ENDIF
endif

m_loc->(dbclosearea())
dbselectarea(nOldarea)

return


PROCEDURE CancelFinishBatch()
LOCAL cScreen := SaveScreen()
LOCAL cLine24
LOCAL mB_ID := Space( 6 )
LOCAL mCP_WIDSTA := "     "
LOCAL cSisma:= Space(10)
LOCAL mConfirm := .Y.
LOCAL bCheck :=  {|| ! m_linemv->fin }

IF ! OpenCancelFiles()
   Alert( "Can not open " + cErrorFile )
   RETURN
ENDIF
CLS
SayLogo()
PutS3OnScreen()
IF !ifEnglish()
   @  5,52 GET cSisma      PICTURE "@! XXXXXXXXXX" SEND postBlock := { |o| Checkpwd(o) };
                                                   COLOR "R/R"
   @  6,29 GET mB_ID       PICTURE "@K 999999"     SEND postBlock := { |o| BidExists(o) }
   @  7,30 GET mCP_WIDSTA  PICTURE "@K 99999"      SEND postBlock := { |o| WidExists(o) }
   @ 12,34 GET mConfirm    PICTURE "Y"
ELSE
   @  5,21 GET cSisma      PICTURE "@! XXXXXXXXXX" SEND postBlock := { |o| Checkpwd(o) };
                                                   COLOR "R/R"
   @  6,30 GET mB_ID       PICTURE "@K 999999"     SEND postBlock := { |o| BidExists(o) }
   @  7,32 GET mCP_WIDSTA  PICTURE "@K 99999"      SEND postBlock := { |o| WidExists(o) }
   @ 12,14 GET mConfirm    PICTURE "Y"
ENDIF
READ

IF ASCAN( aGoodKeys, LASTKEY() ) > 0
   IF mConfirm
      IF m_linemv->( DBSEEK(mB_ID+"194.0") ) .OR. m_linemv->( DBSEEK(mB_ID+"194.5")) .OR. m_linemv->( DBSEEK(mB_ID+"198.0")) .OR. m_linemv->( DBSEEK(mB_ID+"198.5") ) // Checks only at entry at WH stage
          IF     m_linemv->fin
               IIF(!ifEnglish() ,ALERT("! èëáéå Ñëêãê "+d_line->b_id+":ÑêéÑ;"+;
                                       "ÑåÖíîÑ öÄ íñÅå èöâê Äå" , " OK "),;
                                 ALERT("eli--! èëáéå Ñëêãê "+d_line->b_id+":ÑêéÑ;"+;
                                       "ÑåÖíîÑ öÄ íñÅå èöâê Äå" , " OK "))
          ELSEIF ! m_linemv->arr
               IIF(!ifEnglish() ,ALERT("èëáéå Ñëâêã âêîå ÅåôÑ öÄ Ñéââë Äå "+d_line->b_id+":ÑêéÑ;"+;
                                       "ÑåÖíîÑ öÄ íñÅå èöâê Äå" , " OK "),;
											ALERT("eli--èëáéå Ñëâêã âêîå ÅåôÑ öÄ Ñéââë Äå "+d_line->b_id+":ÑêéÑ;"+;
                                       "ÑåÖíîÑ öÄ íñÅå èöâê Äå" , " OK "))

          ELSE
               Cancellaststage( mB_ID )
          ENDIF
      ELSE
          IIF(!ifEnglish() ,ALERT("! èëáéå Ñëâêã Ååô èâÄ "+d_line->b_id+":Ñêéå;"+;
                                  "ÑåÖíîÑ öÄ íñÅå èöâê Äå" , " OK "),;
									 ALERT("Missing warehouse entry stage for batch "+d_line->b_id+";"+;
									       "Can not proceed!", " OK "))
      ENDIF
   ELSE
      Tone( 200, 2 )
      cLine24 := SaveScreen( 24,0,24,79)
      @ 24,0 SAY IIF(!IfEnglish() ,Padc( "ÑåàÖÅ ÑåÖíîÑ" , 80 ) ,Padc( "Operation aborted" , 80 ) ) COLOR if( IsColor() , "W+/R" , "N/W" )
      InKey(2)
      RestScreen( 24,0,24,79 , cLine24 )
   ENDIF
ENDIF

enterClose()
RestScreen( ,,, cScreen )
RETURN


FUNCTION GetErrorFile
RETURN cErrorFile

/*******************************************************************/
FUNCTION enterOpen
   aoOpenedList := GenOpenFiles({"d_line","m_linemv","c_proc","d_wid"})
   m_linemv->( ORDSETFOCUS("ilnmvbs") )
RETURN ( LEN(aoOpenedList) = 4 )
/*******************************************************************/

FUNCTION Opencancelfiles()
   aoOpenedList := GenOpenFiles({"d_finqc","d_rejrep","d_line","m_linemv","m_qcupd","d_wid"})
   m_linemv->( ORDSETFOCUS("ilnmvbn") )
   d_finqc->( ORDSETFOCUS("ifinqcbn") )
RETURN ( LEN(aoOpenedList) = 6 )

/************************************************************************/
PROCEDURE enterClose
  avxCloseFiles()
RETURN
/******************************************************************/
PROCEDURE PutS1OnScreen

IF !IfEnglish()
   @ 5,2 SAY "⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø"
   @ 6,2 SAY "≥                 òÖñâÅ  Ååôå  ÑêéÑ   ö ë â ê ã   åí áÖÖâÉ                ≥"
   @ 7,2 SAY "√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥"
   @ 8,2 SAY "≥                                  (ÅÖöâê ëâàòãÅ Äñéê) Ñêé ÉÖó-òÅ òÅíÑ  .1≥"
   @ 9,2 SAY "≥                                               áÖÖÉé ÉÅÖí ÉÖó-òÅ òÅíÑ  .2≥"
   @10,2 SAY "≥                                                    äâåÑö ÉÖó-òÅ òÅíÑ  .3≥"
   @11,2 SAY "≥                                          ÅÖöâêÅ Ååô òîëé ÉÖó-òÅ òÅíÑ  .4≥"
   @12,2 SAY "≥                                                  'òÖôâÄ' ÉÖó-òÅ òÅíÑ  .5≥"
   @13,2 SAY [≥                    ** òÖáÄå ÉáÄ Éíñ òÖÜáå åãÖö ÑòÜá ÉÖó-òÅ öòÅíÑ â"í ** ≥]
   @14,2 SAY "¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ"
ELSE
   @ 5,2 SAY "⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø"
   @ 6,2 SAY "≥                 Start a Production Stage Notification                   ≥"
   @ 7,2 SAY "√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥"
   @ 8,2 SAY "≥1. Scan Batch No.Barcode                                                 ≥"
   @ 9,2 SAY "≥2. Scan Employee ID Barcode                                              ≥"
   @10,2 SAY "≥3. Scan Production Process Barcode                                       ≥"
   @11,2 SAY "≥4. Scan Production Stage Barcode                                         ≥"
   @12,2 SAY "≥5. Confirm                                                               ≥"
	@13,2 SAY [≥                                                                         ≥]
   @14,2 SAY "¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ"
ENDIF
RETURN
/******************************************************************/
PROCEDURE PutSArriveOnScreen // 00072403 Vitaly 27-03-01

IF !IfEnglish()
   @ 5,2 SAY "⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø"
   @ 6,2 SAY "≥                 òÖñâÅ  Ååôå  ÑêéÑ   ö í Ç Ñ     åí áÖÖâÉ                ≥"
   @ 7,2 SAY "√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥"
   @ 8,2 SAY "≥                                  (ÅÖöâê ëâàòãÅ Äñéê) Ñêé ÉÖó-òÅ òÅíÑ  .1≥"
   @ 9,2 SAY "≥                                               áÖÖÉé ÉÅÖí ÉÖó-òÅ òÅíÑ  .2≥"
   @10,2 SAY "≥                                                    äâåÑö ÉÖó-òÅ òÅíÑ  .3≥"
   @11,2 SAY "≥                                          ÅÖöâêÅ Ååô òîëé ÉÖó-òÅ òÅíÑ  .4≥"
   @12,2 SAY "≥                                                  'òÖôâÄ' ÉÖó-òÅ òÅíÑ  .5≥"
   @13,2 SAY [≥                    ** òÖáÄå ÉáÄ Éíñ òÖÜáå åãÖö ÑòÜá ÉÖó-òÅ öòÅíÑ â"í ** ≥]
   @14,2 SAY "¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ"
ELSE
   @ 5,2 SAY "⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø"
   @ 6,2 SAY "≥              Batch Arrival to Production Stage Notification             ≥"
   @ 7,2 SAY "√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥"
   @ 8,2 SAY "≥1. Scan Batch No.Barcode                                                 ≥"
   @ 9,2 SAY "≥2. Scan Employee ID Barcode                                              ≥"
   @10,2 SAY "≥3. Scan Production Process Barcode                                       ≥"
   @11,2 SAY "≥4. Scan Production Stage Barcode                                         ≥"
   @12,2 SAY "≥5. Confirm                                                               ≥"
	@13,2 SAY [≥                                                                         ≥]
   @14,2 SAY "¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ"
ENDIF
RETURN

PROCEDURE ShowS2()

IF !IfEnglish()
   @14,2 SAY "√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥"
   @15,2 SAY "≥                 :ESN           :  öÖîâáÉ öéò    :ÉÖíâ        : Ñêé 'ëé -≥"
   @16,2 SAY "≥                                : òàóåÄâÉ ÇÖë                 : òñÖé Öó  ≥"
   @17,2 SAY "≥                                :òàóåÄâÉ âÅÖí                 :    åÉÖÇ  ≥"
   @18,2 SAY "≥                                                              :     äòí  ≥"
   @19,2 SAY "≥       W        S           P   : öâáãÖê öÖéã                 :  öÖñâîÄ  ≥"
   @20,2 SAY "≥                                                              : ESN(XX)  ≥"
   @21,2 SAY "¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ"
    // 1 st line
   @ 15, 4 SAY m_linemv->esn_id
   @ 15,27 SAY m_linemv->b_prior
   @ 15,30 SAY d_line->b_wkprom
   @ 15,51 SAY m_linemv->b_purp
   @ 15,59 SAY m_linemv->b_id
   // 2 nd line
	IF !Empty(m_linemv->diel_id)
		@ 16,31 SAY if( m_linemv->diel_id = "S" , "SiO2" , IIF(m_linemv->diel_id = "N" ,"SiNO" ,"3LYR" ) )
	ENDIF

   @ 16,62 SAY m_linemv->pline_id
   // 3 rd line
   @ 17,29 SAY Str( m_linemv->diel_width , 6, 3 )
   @ 17,61 SAY m_linemv->size_id
   // 4 th line
   @ 18,57 SAY Str( m_linemv->value_id , 8 ,3 )
   // 5 th line
   @ 19,64 SAY m_linemv->tol_id

   // 6 th line
   @ 20,08 SAY Transform(m_linemv->cp_bqtyw , "999" )+if( c_proc->must_w ,"","*")
   @ 20,14 SAY Transform(m_linemv->cp_bqtys ,"99,999" )+if( c_proc->must_s ,"","*")
   @ 20,23 SAY Transform(m_linemv->cp_bqtyp ,"99,999,999" )+if( c_proc->must_p ,"","*")
   @ 20,63 SAY m_linemv->esnxx_id
ELSE
   @14,2 SAY "√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥"
   @15,2 SAY "≥ Batch No  :            Priority    :            ESN:                    ≥"
   @16,2 SAY "≥ Line      :            Dielecter   :            Purpose:                ≥"
   @17,2 SAY "≥ Size      :            Diel. Width :                                    ≥"
   @18,2 SAY "≥ Value     :                                                             ≥"
   @19,2 SAY "≥ Tolerance :            Current Qty :   W        S           P           ≥"
   @20,2 SAY "≥ ESN(XX)   :                                                             ≥"
   @21,2 SAY "¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ"
    // 1 st line
   @ 15,57 SAY m_linemv->esn_id
   @ 15,42 SAY m_linemv->b_prior
   @ 15,45 SAY d_line->b_wkprom
   @ 15,17 SAY m_linemv->b_id
   // 2 nd line
	@ 16,62 SAY m_linemv->b_purp
	IF !Empty(m_linemv->diel_id)
      @ 16,42 SAY if( m_linemv->diel_id = "S" , "SiO2" , IIF(m_linemv->diel_id = "N" ,"SiNO" ,"3LYR" ) )
	ENDIF
   @ 16,17 SAY m_linemv->pline_id
   // 3 rd line
   @ 17,42 SAY Alltrim(Str( m_linemv->diel_width , 6, 3 ))
   @ 17,17 SAY m_linemv->size_id
   // 4 th line
   @ 18,17 SAY Alltrim(Str( m_linemv->value_id , 8 ,3 ))
   // 5 th line
   @ 19,17 SAY m_linemv->tol_id

   // 6 th line
   @ 20,41 SAY Transform(m_linemv->cp_bqtyw , "999" )+if( c_proc->must_w ,"","*")
   @ 20,47 SAY Transform(m_linemv->cp_bqtys ,"99,999" )+if( c_proc->must_s ,"","*")
   @ 20,57 SAY Transform(m_linemv->cp_bqtyp ,"99,999,999" )+if( c_proc->must_p ,"","*")
   @ 20,17 SAY m_linemv->esnxx_id
ENDIF

RETURN


PROCEDURE BarUpdate( cWidSta )
LOCAL mCP_DSTA , mCP_TSTA

IF m_linemv->( RecLock( 5 ) )
   mCP_DSTA := Date()
   mCP_TSTA := Left( Time() , 5 )

   m_linemv->sta       := .T.
   m_linemv->cp_dsta   := mCP_DSTA
   m_linemv->cp_tsta   := mCP_TSTA
   m_linemv->cp_widsta := cWidSta
   m_linemv->( DbUnLock() )
ENDIF

IF d_line->( RecLock( 5 ) )
   d_line->cp_dsta   := mCP_DSTA
   d_line->cp_tsta   := mCP_TSTA
   d_line->cp_widsta := cWidSta
   d_line->( xDbUnLock() )
ENDIF

RETURN
////////////////////////
PROCEDURE ArriveUpdate( cWidSta,cBlock ) // 00072403 Vitaly 27-03-01
LOCAL mCP_DSTA , mCP_TSTA

IF m_linemv->( RecLock( 5 ) )
      mCP_DSTA := Date()
      mCP_TSTA := Left( Time() , 5 )
      m_linemv->arr       := .T.
      m_linemv->cp_darr   := mCP_DSTA
      m_linemv->cp_tarr   := mCP_TSTA
      m_linemv->cp_widarr := cWidSta
      m_linemv->( DbUnLock() )
ENDIF
IF d_line->( RecLock( 5 ) )
   d_line->cp_darr := Date() //edomo 13-05-01 00072403
   d_line->cp_tarr := Time()//VR 27-01-02 2127212
   d_line->cp_widarr := cWidSta  //vitaly 01.05.01 00072403
	d_line->( xDbUnLock() )
ENDIF

RETURN
///////////////////////

PROCEDURE CancelLastStage( bId )
LOCAL nCurrentrec, nPrevP, nPrevS, nPrevW
LOCAL nPrevscr,  nPrevproc, nPrevcode, nPrevwkstn
LOCAL nPrevdarr, nPrevtarr, nPrevdsta, nPrevtsta
LOCAL nPrevdfin, nPrevtfin, nPrevwidfin, nCounter
LOCAL afields, i, j
LOCAL nFields := d_finqc->( FCOUNT() )

j := 1
afields := ARRAY( j, nFields )

// Delete records from d_finqc. Save fields into a target array
// to copy them later to m_qcupd file
IF d_finqc->(DBSEEK(bId))          // Seeks by b_id
     DO WHILE d_finqc->b_id == bId
        IF d_finqc->( RecLock( 5 ) )  // Loops until record is locked
            FOR i := 1 TO nFields
                afields[j,i] := d_finqc->( FIELDGET(i) )
            NEXT
            AADD( afields, ARRAY( nFields ) )
            ++j
            IF d_finqc->( RecLock( 5 ) )
               d_finqc->( DBDELETE() )
            ENDIF
            d_finqc->(DBSKIP())
        ENDIF
     END
ENDIF

d_finqc->(ORDSETFOCUS("ifinqpbn"))
IF d_finqc->(DBSEEK(bId))          // Seeks by packing batch reference
     DO WHILE d_finqc->packb_id == bId
        IF d_finqc->( RecLock( 5 ) )  // Loops until record is locked
            FOR i := 1 TO nFields
                afields[j,i] := d_finqc->( FIELDGET(i) )
            NEXT
            AADD( afields, ARRAY( nFields ) )
            ++j
            IF d_finqc->( RecLock( 5 ) )
               d_finqc->( DBDELETE() )
            ENDIF
            d_finqc->(DBSKIP())
        ENDIF
     END
ENDIF

// Copy records from deleted d_finqc into m_qcupd
FOR i := 1 TO LEN(afields)
     IF afields[i,1] <> NIL
          m_qcupd->(DBAPPEND())
          FOR j := 1 TO nFields
               m_qcupd->( FIELDPUT(j, afields[i,j]) )
          NEXT
     ENDIF
NEXT

// Delete records if any, from rejected reports
IF d_rejrep->(DBSEEK(bId))          // Seeks by b_id
     DO WHILE d_rejrep->b_id == bId
          IF d_rejrep->cpproc_id="196.0"
            IF d_rejrep->( RecLock( 5 ) )
               d_rejrep->( DBDELETE() )
            ENDIF
          ENDIF
          d_rejrep->(DBSKIP())
     END
ENDIF

// Update current and previous record from m_linemv
IF m_linemv->( RecLock( 5 ) )
   // Cancel current 194.0 stage information
   m_linemv->cp_bqtyw  := 0
   m_linemv->cp_bqtys  := 0
   m_linemv->cp_bqtyp  := 0
   m_linemv->arr       := .F.
   m_linemv->sta       := .F.
   m_linemv->fin       := .F.
   m_linemv->cp_darr   := ctod("  /  /  ")
   m_linemv->cp_tarr   := "    "
   m_linemv->cp_dsta   := ctod("  /  /  ")
   m_linemv->cp_tsta   := "    "
   m_linemv->cp_dfin   := ctod("  /  /  ")
   m_linemv->cp_tfin   := "    "
   GetUserInfo():updateUserInRec( "m_linemv" , "CANCELLA",.T. )
   nCurrentrec         := m_linemv->(RECNO())
   m_linemv->( DbUnLock() )
   m_linemv->(ORDSETFOCUS("ilnmvbs"))
   m_linemv->(DBGOTO(nCurrentrec))
   m_linemv->(DBSKIP(-2))            // Gets the qtys. of the stage before
   nPrevW     := m_linemv->cp_bqtyw  // the previous stage of 194.0.
   nPrevS     := m_linemv->cp_bqtys  // These are the qtys. needed to update
   nPrevP     := m_linemv->cp_bqtyp  // previous of 194.0
   nPrevproc  := m_linemv->cpproc_id
   nPrevcode  := m_linemv->cp_pccode
   nPrevwkstn := m_linemv->cpwkstn_id
   nPrevdarr  := m_linemv->cp_darr
   nPrevtarr  := m_linemv->cp_tarr
   nPrevdsta  := m_linemv->cp_dsta
   nPrevtsta  := m_linemv->cp_tsta
   nPrevdfin  := m_linemv->cp_dfin
   nPrevtfin  := m_linemv->cp_tfin
   nPrevwidfin:= m_linemv->cp_widfin
   m_linemv->(DBSKIP(1))
   // Update previous stage information
   IF m_linemv->( RecLock( 5 ) )
     nPrevscr            := m_linemv->cp_totscr  // to substract later in d_line
     m_linemv->cp_totscr := 0
     m_linemv->cp_adjscr := 0
     m_linemv->cp_bqtyw  := nPrevW
     m_linemv->cp_bqtys  := nPrevS
     m_linemv->cp_bqtyp  := nPrevP
     m_linemv->b_lrej    := "    "
     m_linemv->discr_rep := "      "
     m_linemv->fin       := .F.
     m_linemv->cp_dfin   := ctod("  /  /  ")
     m_linemv->cp_tfin   := "    "
     GetUserInfo():updateUserInRec( "m_linemv" , "CANCELLA",.T. )
     m_linemv->( DbUnLock() )
   ENDIF
ENDIF

// Udpate d_line record
IF d_line->( RecLock( 5 ) )
   d_line->cp_bqtyw  := d_line->pp_bqtyw
   d_line->cp_bqtys  := d_line->pp_bqtys
   d_line->cp_bqtyp  := d_line->pp_bqtyp
   d_line->qty_bscr  := d_line->qty_bscr - nPrevscr
   d_line->cpproc_id := d_line->ppproc_id
   d_line->cp_pccode := d_line->pp_pccode
   d_line->cpwkstn_id:= d_line->pp_wkstn
   d_line->cp_dsta   := d_line->pp_dsta
   d_line->cp_tsta   := d_line->pp_tsta
   d_line->cp_widsta := d_line->pp_widfin
   d_line->pp_bqtyw  := nPrevW
   d_line->pp_bqtys  := nPrevS
   d_line->pp_bqtyp  := nPrevP
   d_line->ppproc_id := nPrevproc
   d_line->pp_pccode := nPrevcode
   d_line->pp_wkstn  := nPrevwkstn
   d_line->pp_darr   := nPrevdarr
   d_line->pp_tarr   := nPrevtarr
   d_line->pp_dsta   := nPrevdsta
   d_line->pp_tsta   := nPrevtsta
   d_line->pp_dfin   := nPrevdfin
   d_line->pp_tfin   := nPrevtfin
   d_line->pp_widfin := nPrevwidfin
   GetUserInfo():updateUserInRec( "d_line" , "CANCELLA",.T. )
   d_line->( xDbUnLock() )
ENDIF

RETURN

FUNCTION IsAdMin
RETURN lAdMin

FUNCTION GetUserInfo
RETURN oUserInfo


PROCEDURE OpenInfoFile

LOCAL cUserId := oUserInfo:cUserId

WHILE .T.

   USE ("flocklst") NEW SHARED VIA (getmydriver())

   IF NetErr()
      Alert( "Problem in opening FLOCKLST file " )
      QUIT
   ELSE
      flocklst->( ordsetfocus( "fileuser" ) )
      EXIT
   ENDIF
ENDDO

RETURN

PROCEDURE CloseInfoFile
flocklst->( DbCloseArea() )
RETURN


INIT PROCEDURE SetUp
   Set( _SET_CONFIRM , .T. )
   Set( _SET_SCOREBOARD, .F.)
   Set( _SET_DATEFORMAT , "DD/MM/YY" )
RETURN

FUNCTION BidExists(o)

LOCAL lRetVal := .T.
LOCAL cBuffer := StrZero(Val(o:varGet()),6)

IF !d_line->( DbSeek( cBuffer ) )
	IF !IfEnglish()
		Alert( cBuffer + " ÑÜ òîëé çí Ñêé öÄñéê Äå" , {"..."} )
	ELSE
		Alert( "Batch No. " + cBuffer + " not found" , {"..."} )
	ENDIF
   lRetVal := .F.
ELSEIF (d_line->b_stat $ "C_D_E_M" .AND. !d_line->cpproc_id $ "997.0_997.4") .OR. ;
		 (d_line->b_stat $ "_B_" .AND. d_line->cpproc_id == "165.5") .OR. ;
		 d_line->cpproc_id == "995.0"
	IF !IfEnglish()
      ALERT( "("+d_line->b_stat+" ëÖààë) ÖÜ Ñêé èãÉíå èöâê Äå", {"..."})
	ELSE
      ALERT( " This batch can not be updated ( " + d_line->b_stat+ "  - " + GetStDesc(d_line->b_stat) + " Status )", {"..."})
	ENDIF
   lRetVal := .F.
// New status Re-ord that enables to move the batch but not to 196 or 194
// Id:98050305. D.Laor 11-08-98.
// ELSEIF d_line->b_stat == "R" .AND. d_line->cpproc_id $ "196.0_194.0"
// 29-7-99. This was canceled with the recurring process project
// Changes made on poststage() function. Id. 98101309 D.Laor
ENDIF

IF lRetVal
   o:varPut( cBuffer )
   o:display()
ENDIF

RETURN lRetVal

Static Function GetStDesc(cStat)

local cRetVal

IF cStat $ "_D_"
	cRetVal := "Rejected by QC"
ELSEIF cStat $ "_E_"
	cRetVal := "Pending QC rejection"
ELSEIF cStat $ "_C_"
	cRetVal := "Closed"
ELSEIF cStat $ "_M_"
	cRetVal := "Frozen"
ENDIF

Return cRetVal


FUNCTION WidExists(o,lFromCzh)

LOCAL lRetVal
LOCAL cKey := Padl( Alltrim( o:varGet() ) , 5 )

IF LastKey() = K_UP
   RETURN .T.
ENDIF

IF d_wid->( DbSeek( cKey ) ) .AND. !IfEnglish()
   o:varPut( cKey )
   @ o:Row ,7 SAY d_wid->work_nmh COLOR if( IsColor() , "W+/B" , "W+/N" )
   lRetVal := .T.
ELSEIF d_wid->( DbSeek( cKey ) ) .AND. IfEnglish()
   o:varPut( cKey )
   @ o:Row ,50 SAY d_wid->work_nmh COLOR if( IsColor() , "W+/B" , "W+/N" )
   lRetVal := .T.
ELSE
	IF !IfEnglish()
       Alert( cKey + " ÑÜ òîëé çí ÉÅÖí Äñéê Äå" , {"..."} )
	ELSE
       Alert( "Employee ID not found - " + cKey , {"..."} )
	ENDIF
   lRetVal := .F.
ENDIF

RETURN lRetVal


FUNCTION CheckPwd(o,lFromCheh)

LOCAL lRetVal
LOCAL cSisma

default lFromCheh to FALSE

IF lFromCheh
    cSisma := UPPER( ALLTRIM( MEMOTRAN( MemoRead("d_shpbat.pwd")," ") ) )
ELSE
	 cSisma := UPPER( ALLTRIM( MEMOTRAN( MemoRead("d_finqc.pwd")," ") ) )
ENDIF


IF cSisma == ALLTRIM( o:varget() )
   lRetVal := .T.
ELSE
   IIF(!ifEnglish() , Alert( "!! ÑâÖÇô Ñéëâë" , {"..."} ),Alert( "Invalid password!" , {"..."} ) )
   lRetVal := .F.
ENDIF

IF lRetVal
   o:varPut( Padr(cSisma,10) )
   o:display()
ENDIF

RETURN lRetVal


FUNCTION ProcExists(o)
LOCAL lRetVal
LOCAL cKey :=  IIF(valType(o:varGet()) == "N" ,Str( o:varGet(), 5 ,1 ) ,o:varGet() )
LOCAL nSelect := Select()

IF LastKey() = K_UP
   RETURN .T.
ENDIF

IF c_proc->( DbSeek( cKey ) )
   IF  "194.0_194.5" $ cKey
		 IF !IfEnglish()
           Alert( "!! (194.5) ÖÄ (194) ÑÜ Ååô áÖÖÉå ÑôòÖé ÖêâÄ ÑÜ ôéöôé", {"..."} )
		 ELSE
                 Alert( "User is not allowed to report stage (194.0) or(194.5)", {"..."} )
		 ENDIF
       RETURN .F.
   ELSE
		IF !IfEnglish() .AND. valType(o:varGet()) == "N"
         @ o:Row ,7  SAY c_proc->proc_nmh COLOR if( IsColor() , "W+/B" , "W+/N" )
		ELSE
         @ o:Row ,50 SAY c_proc->proc_nme COLOR if( IsColor() , "W+/B" , "W+/N" )
		ENDIF
      lRetVal := .T.
   ENDIF
ELSE
	IF !IfEnglish()
		Alert( cKey + " ÑÜ òîëé çí äâåÑö Äñéê Äå" , {"..."} )
	ELSE
		Alert( "Production Process " + cKey + " not found" , {"..."} )
	ENDIF
   lRetVal := .F.
ENDIF

dbselectarea(nSelect)
RETURN lRetVal


/************************************************************/
FUNCTION postStage(o , bCheck , lFinCode,mCPPROC_ID )

LOCAL lRetVal , cFinCode
LOCAL cKey   := GetList[1]:varGet() + Str( o:varGet() , 4 )
local cOldScr,mMemo := d_line->pack_mem

IF LastKey() = K_UP
   RETURN .T.
ENDIF

IF Negative( o )
   RETURN .F.
ENDIF

IF lFinCode = NIL
// go on
ELSE
   // added this check for correct NITUV 25-03-97 as per Dmitri's reply
   IF !m_linemv->( DbSeek( cKey ) )
		IF !IfEnglish()
			Alert( GetList[1]:varGet() + ":ÑêéÅ"+ Str(o:varGet(),4) + ":ÑÜ Ååô Äñéê Äå" , {"..."} )
		ELSE
			Alert( "This stage not found in batch " + GetList[1]:varGet(), {"..."} )
		ENDIF
      RETURN .F.
   ELSE
     IF (d_line->b_stat == "R" .AND. m_linemv->proc_type <> "R") .OR.;
        (d_line->b_stat == "R" .AND. m_linemv->proc_type <> "N") // 00122708 edomo 14-02-01
          m_linemv->( ORDSETFOCUS("ilnmvbs"))
          IF !m_linemv->proc_type $ "R_N_A" //  edomo 14-02-01 00122708, 12-06-02 2312860
				 IF !IfEnglish()
					 ALERT( d_line->b_stat+":ëÖààë ,"+d_line->cpproc_id+":ÅåôÅ ÖÜ Ñêé èãÉíå èöâê Äå", {"..."})
				 ELSE
					 ALERT( "This batch can not be updated ,stage : " + d_line->cpproc_id + " Status : " + d_line->b_stat, {"..."})
				 ENDIF
             RETURN .F.
          ENDIF
     ENDIF
   END

   IF !barSetMoreGets() .OR. !GoodEndCode()
      RETURN .F.
   ENDIF
ENDIF


IF m_linemv->( DbSeek( cKey ) )
     IF m_linemv->cpproc_id != Str( GetList[3]:varGet(), 5 ,1)
		  IF !IfEnglish()
			  Alert( "!ÑÜ ÅåôÅ "+ m_linemv->cpproc_id +" áÖÖÉéÑ äâåÑöÑ òîëé öÄ çÄÖö ÖêâÄ "+ Str( GetList[3]:varGet(), 5 ,1) +" ôóÖÑô äâåÑö òîëé",{"..."})
		  ELSE
                 Alert( "Production Process and Production Stage do not match.;Production Process " + m_linemv->cpproc_id +" is expected.",{"..."})
		  ENDIF
        RETURN .F.
   ENDIF

   lRetVal := .T.
   IF Eval( bCheck ) // start arr:=.t.  sta=.f. fin:=.f.
                     // end   arr:=.t.  sta=.t. fin:=.f.
      ShowS2()

   ELSEIF !IfEnglish()
      Alert("         :Ååô Åñé;"+;
              if( m_linemv->arr ,"         íâîÖÑ   ","       íâîÖÑ Äå   " )+";"+;
              if( m_linemv->sta ,"         åâáöÑ   ","       åâáöÑ Äå   " )+";"+;
              if( m_linemv->fin ,"         çâöëÑ   ","       çâöëÑ Äå   " )   )
      lRetVal := .F.
	ELSE
      Alert( if( m_linemv->arr ,"Batch has arrived to process       ","Batch has not arrived to process   " )+";"+;
             if( m_linemv->sta ,"Batch has started the process      ","Batch has not started the process  " )+";"+;
             if( m_linemv->fin ,"Process has completed              ","Process has not completed          " )   )
      lRetVal := .F.
   ENDIF
ELSE
	IF !IfEnglish()
		Alert( GetList[1]:varGet() + ":ÑêéÅ"+ Str(o:varGet(),4) + ":ÑÜ Ååô Äñéê Äå" , {"..."} )
	ELSE
		Alert( "This stage not found in batch " + GetList[1]:varGet(), {"..."} )
	ENDIF
   lRetVal := .F.
ENDIF

IF lRetVal
	m_linemv->(dbskip(-1))
	IF !m_linemv->FIN .AND. d_line->b_id == m_linemv->b_id
		 Alert( "Finish previous stage before!", {"..."} )
		 lRetVal := .F.
	ENDIF
	m_linemv->(dbskip(1))
ENDIF

ShalInitvars()

IF lRetVal .AND. (mCPPROC_ID == "192.0" .OR. mCPPROC_ID == "192.5") .AND. Empty(d_line->pack_mem) .AND. !d_line->B_PURP $ "5_8_P_6_" //Q was removed per AIF 14092023
   lRetVal := FALSE
	Alert( "Call Tapi(Israel) for packing instruction's", {"..."} )
ELSEIF lRetVal .AND. (mCPPROC_ID == "192.0" .OR. mCPPROC_ID == "192.5") .AND. !Empty(d_line->pack_mem) .AND. !d_line->B_PURP $ "5_8_P_6_"//Q was removed per AIF 14092023
	cOldScr := SAVESCREEN()
	set cursor off
	@04,09 TO 21,70 DOUBLE COLOR "w+/bg"
	MEMOEDIT(mMemo,5,10,20,69,.F.)
	set cursor on
	RESTSCREEN(,,,,cOldscr)
ENDIF

IF lRetVal .AND. m_linemv->arr .AND. !m_linemv->sta .AND. !m_linemv->fin
	//GetRCard()
ENDIF

RETURN lRetVal



Static Procedure GetRCard()

local nOldarea := Select(),cRoute := d_line->route_id
local cRet := " ",i,fieldVal

local nField,cDbfIns
local nQty
local cRetRoute := "?"

IF File( GetUserInfo():cTempDir+"EQ.cdx" )
   ferase(GetUserInfo():cTempDir+"EQ.cdx")
endif

Netuse("c_rlib",5)
c_rlib->( ORDSETFOCUS("irlibid"))
IIF(c_rlib->( DbSeek( cRoute ) ),cRetRoute := c_rlib->route_type, NIL)

cDbfIns := IIF(cRetRoute <> "R","d_instr" ,"d_insrnd" )

DispBox( 22, 2, 24, 76 ,B_SINGLE+" ", "R+/b" )

NetUse(cDbfIns,5)
ordsetfocus(1)
NetUse( cRoute, STD_RETRY, , , , "G:\avxbms\ROUTE\" )
CheckIndex("temp",GetUserInfo():cTempDir + "EQ","PROC_ID + str(STAGE,4)",.T.)

IF (cRoute)->(dbseek(m_linemv->CPPROC_ID + str(m_linemv->CP_STAGE,4)))

	 cRet :=  cRet +" "+ (cRoute)->proc_spec

	FOR i = 1 TO 5

					 nField := (cRoute)->( FIELDPOS("i" + LTRIM(STR(i)) ))

					 fieldVal := (cRoute)->( FIELDGET( nField ) )

	             IF !EMPTY(fieldVal)
						  IF (cDbfIns)->( DbSeek( STR(fieldVal,5) ) )
								 cRet :=  cRet + "," + Alltrim((cDbfIns)->instr_nmh)
						       i++
						  ENDIF

	             ENDIF
	NEXT

	@ 23  , 3 SAY alltrim(cRet)

ENDIF
(cRoute)->(dbclosearea())
(cDbfIns)->(dbclosearea())
c_rlib->(dbclosearea())

dbselectarea(nOldarea)

Return

Static Procedure CzhehSends()

LOCAL o,nKey
LOCAL cTempDir := GetUserInfo():cTempDir
LOCAL oForm := Form():new(3,1,22,78, "                  Select batches for shipping               ","N/W", ProcName() )
LOCAL aOldF1Keys,nChoice
LOCAL aProc := {},lProcOK,i,nRecNo
LOCAL cWhatIshowNow
LOCAL aKeyList:={;
                 { "F5       - Print & Advance batches to Arrive " , K_F5    },;
                 { "Space    - Mark/UnMark line          " , K_SPACE },;
                 { "Shift F7 - UnMark all line           " , K_SH_F7 },;
                 { "F7       - Mark all line             " , K_F7    },;
					  { "TAB      - IL/CZ Window              " , K_TAB   },;
                 { "Esc      - Exit                      " , K_ESC   } ;
                }

NetUse("d_line",5)
d_line->(ordsetfocus("dlcpptsv"))
IF "CZ" $ GetUserInfo():cGroupID//here Elitzoor case for Users(look end of line also)
   Prepare_I()
	cWhatIshowNow := "CZ"
   @ 3, 70 SAY "      " COLOR "N/W"
	@ 3, 70 SAY "Czech " COLOR "N/W"
ELSE
   Prepare_II()
	cWhatIshowNow := "IL"
   @ 3, 70 SAY "      " COLOR "N/W"
	@ 3, 70 SAY "Israel" COLOR "N/W"
ENDIF
d_line->(dbclosearea())
Open_N_App()
aAllocRecNo := Array( d_lntmp->( LastRec() ) )
Afill( aAllocRecNo , " " )
d_lntmp->(dbgotop())
IF Empty(aAllocRecNo)
	if Alert("No records found",{"Exit","Batches ready for shipping to " + IIF("CZ" $ GetUserInfo():cGroupID,"Czech","Israel")}) == 1 .OR. LastKey() == K_ESC
	   oForm:hide()
	   d_lntmp->(dbclosearea())
	   Return
	else
		d_lntmp->(dbclosearea())
      NetUse("d_line",5)
      d_line->(ordsetfocus("dlcpptsv"))
      IF !"CZ" $ GetUserInfo():cGroupID//here Elitzoor case for Users(look end of line also)
	      Prepare_I()
			cWhatIshowNow := "CZ"
         @ 3, 70 SAY "      " COLOR "N/W"
	      @ 3, 70 SAY "Czech " COLOR "N/W"
      ELSE
         Prepare_II()
			cWhatIshowNow := "IL"
         @ 3, 70 SAY "      " COLOR "N/W"
	      @ 3, 70 SAY "Israel" COLOR "N/W"
      ENDIF
      d_line->(dbclosearea())
		Open_N_App()
		aAllocRecNo := Array( d_lntmp->( LastRec() ) )
      Afill( aAllocRecNo , " " )
		IF Empty(aAllocRecNo)
		   Alert("No records found",{"Exit"})
	      oForm:hide()
	      d_lntmp->(dbclosearea())
	      Return
		ENDIF
		d_lntmp->(dbgotop())
	endif
ENDIF
o := MakeBro()
aOldF1Keys := SetHlpKeys( aKeyList )
WHILE .T.
   WHILE !o:stabilize() ; END
   PaintRow(o); WHILE !o:stabilize() ; END

   nKey := TimeOutInKey(0)

   F1 PRESSED

   IF nKey = K_ESC
      EXIT
   ELSEIF StdKeys( nKey , o )
   ELSEIF nKey = K_F5
			 aProc   := {}
			 lProcOK := TRUE
			 nRecNo := d_lntmp->(recNo())
			 d_lntmp->( DbGoTop() )

			 WHILE !d_lntmp->( Eof() )
			      IF aAllocRecNo[ d_lntmp->( RecNo() ) ] = "X"
			 		  AADD(aProc,d_lntmp->cpproc_id)
			 	  ENDIF
			 	  d_lntmp->(dbskip())
			 End

			 FOR i := 1 TO nLen(aProc)
			     IF i > 1
			        lProcOK   := lProcOK .AND. aProc[i] == aProc[i - 1]
			     ENDIF
			 NEXT

			 d_lntmp->(dbgoto(nRecNo))

			 IF !lProcOK
             Alert("Mixing batches that are in different production process is forbidden!",{"Ok"})
				 LOOP
			 ENDIF


			 IF Ascan(aAllocRecNo,"X") > 0 .AND. ;
				 ((cWhatIshowNow $ GetUserInfo():cGroupID .AND. cWhatIshowNow == "CZ") .OR. (cWhatIshowNow == "IL" .AND. ! "CZ" $ GetUserInfo():cGroupID)) .AND. ;
				 Alert("Are you sure ?",{"Yes","No"}) == 1
				 nChoice := ArrCzheh()
				 IF LastKey() <> K_ESC
					 PrintCzheh(nil,nil,nChoice)
					 d_lntmp->( __DBPACK() )
				 ENDIF
				 IF d_lntmp->(LastRec()) > 0
				    o:RefreshAll()
				 ELSE
                d_lntmp->(dbclosearea())
                oForm:hide()
                RETURN
				 ENDIF
			 ELSEIF Ascan(aAllocRecNo,"X") > 0 .AND. !cWhatIshowNow $ GetUserInfo():cGroupID .AND. cWhatIshowNow == "CZ"
		           Msg24("Performing this action is not allowed !" , 1 , .T. )
			 ELSEIF Ascan(aAllocRecNo,"X") == 0
                 Alert("No records marked for printing !",{"..."})
			 ENDIF
 	ELSEIF nKey = K_TAB
		    d_lntmp->(dbclosearea())
          NetUse("d_line",5)
          d_line->(ordsetfocus("dlcpptsv"))
			 IF cWhatIshowNow <> "CZ"
				 Prepare_I()
				 cWhatIshowNow := "CZ"
             @ 3, 70 SAY "      " COLOR "N/W"
	          @ 3, 70 SAY "Czech " COLOR "N/W"
			 ELSE
				 Prepare_II()
				 cWhatIshowNow := "IL"
    			 @ 3, 70 SAY "      " COLOR "N/W"
			    @ 3, 70 SAY "Israel" COLOR "N/W"
			 ENDIF
			 d_line->(dbclosearea())
			 Open_N_App()
			 aAllocRecNo := Array( d_lntmp->( LastRec() ) )
          Afill( aAllocRecNo , " " )
          IF Empty(aAllocRecNo)
	          if Alert("No records found",{"Exit"}) == 1
	             oForm:hide()
	             d_lntmp->(dbclosearea())
	             Return
	          endif
          ENDIF
  		    d_lntmp->(dbgotop())
			 o:RefreshAll()
   ELSEIF nKey = K_SH_F7 .AND. ((cWhatIshowNow $ GetUserInfo():cGroupID .AND. cWhatIshowNow == "CZ") .OR. (cWhatIshowNow == "IL" .AND. ! "CZ" $ GetUserInfo():cGroupID))
          aFill( aAllocRecNo , " " )
          o:refreshAll()
   ELSEIF nKey = K_F7 .AND. ((cWhatIshowNow $ GetUserInfo():cGroupID .AND. cWhatIshowNow == "CZ") .OR. (cWhatIshowNow == "IL" .AND. ! "CZ" $ GetUserInfo():cGroupID))
          aFill( aAllocRecNo , "X" )
          o:refreshAll()
   ELSEIF nKey = K_SPACE .AND. ((cWhatIshowNow $ GetUserInfo():cGroupID .AND. cWhatIshowNow == "CZ") .OR. (cWhatIshowNow == "IL" .AND. ! "CZ" $ GetUserInfo():cGroupID))
     IF aAllocRecNo[d_lntmp->(RecNo())] == "X"
        aAllocRecNo[d_lntmp->(RecNo())] := " "
     ELSE
         aAllocRecNo[d_lntmp->( RecNo())] := "X"
     ENDIF
     o:refreshCurrent()
   ENDIF
ENDDO

d_lntmp->(dbclosearea())
oForm:hide()

RETURN


Static Function ArrCzheh()

LOCAL nOldArea := Select()
LOCAL nCounter
LOCAL cOldScr := SAVESCREEN()
LOCAL mCP_WIDSTA := "     "
LOCAL cSisma := Space(10)
LOCAL nChoice

GenOpenFiles({"d_line","m_linemv","d_wid"})

@11,30 CLEAR TO 14, 55

DrawBox(11,30,14,55)

@ 12,33 SAY "Password   " COLOR "n/bg"
@ 12,45  GET cSisma      PICTURE "@! XXXXXXXXXX" SEND postBlock := { |o| Checkpwd(o,.T.) } COLOR "R/R"
@ 13,33 SAY "Employee ID" COLOR "n/bg"
@ 13,45 GET mCP_WIDSTA  PICTURE "@K 99999"  SEND postBlock := { |o| d_wid->( DbSeek( Padl( Alltrim( o:varGet() ) , 5 ) ) ) }

READ

IF LastKey() <> K_ESC

nChoice := Alert("Reporting options",{"Arrive only","Arrive and Start"})

m_linemv->( ORDSETFOCUS("ilnmvbs") )

FOR nCounter := 1 TO Len(aAllocRecNo)
	 IF aAllocRecNo[nCounter] == "X"
		 d_lntmp->(dbgoto(nCounter))
		 d_line->(dbseek(d_lntmp->b_id))
		 m_linemv->(dbseek(d_line->b_id))
		 While !eval({|| !m_linemv->arr .AND. !m_linemv->sta .AND. !m_linemv->fin  .AND. m_linemv->cpproc_id == d_line->cpproc_id})
				 m_linemv->(dbskip(1))
		 End
		 IF d_line->b_id == m_linemv->b_id
		    ArriveUpdate(padl(alltrim(mCP_WIDSTA),5))
			 IF nChoice == 2
				 BarUpdate(padl(alltrim(mCP_WIDSTA),5))
			 ENDIF
			 d_lntmp->( DBDELETE() )
          d_lntmp->( DBSKIP(0) )
		 ENDIF
		 m_linemv->(dbgotop())
	 ENDIF
NEXT
ENDIF

d_wid->(dbclosearea())
m_linemv->(dbclosearea())
d_line->(dbclosearea())
dbselectarea(nOldArea)

RESTSCREEN(,,,,cOldScr)
Return nChoice

STATIC FUNCTION MakeBro

LOCAL o
LOCAL oCol, i

SELECT d_lntmp
o := d_lntmp->( TBrowseDB(4,2,21,77) )
o:headSep := "Õ"
o:colSep  := "≥"
o:colorSpec := Colors()

o:addColumn(TbColumnNEW( "  "         , {|| aAllocRecNo[ d_lntmp->( RecNo() ) ]      } ) )
o:addColumn(TbColumnNEW( "P"          , {|| d_lntmp->b_purp                          } ) )
o:addColumn(TbColumnNEW( "Batch; No"  , {|| d_lntmp->b_id                            } ) )
o:addColumn(TbColumnNEW( "   ESN   "  , {|| d_lntmp->esn_id                          } ) )
o:addcolumn(tbcolumnnew( "Line"       , {|| d_lntmp->pline_id                        } ) )
o:addColumn(TbColumnNEW( "Size"       , {|| d_lntmp->size_id                         } ) )
o:addColumn(TbColumnNEW( "Value"      , {|| Str(d_lntmp->value_id,9,3)               } ) )
o:addColumn(TbColumnNEW( "St"         , {|| d_lntmp->b_stat                          } ) ) //YG revdue
o:addColumn(TbColumnNEW( "Pcs   "     , {|| Transform(d_lntmp->CP_BQTYP,"9,999,999") } ) )
o:addColumn(TbColumnNEW( "Process"    , {|| d_lntmp->cpproc_id                       } ) ) //YG revdue

o:freeze := 1

RETURN o

Function RepStage(cFileName) //VR 27-01-02 TID:2127212
local cRetVal
IF Empty((cFileName)->cp_darr) .AND. Empty((cFileName)->cp_dsta) .AND. !Empty((cFileName)->pp_dfin)
	cRetVal := "F"
ELSEIF !Empty((cFileName)->cp_darr) .AND. Empty((cFileName)->cp_dsta) .AND. !Empty((cFileName)->pp_dfin)
	cRetVal := "A"
ELSEIF !Empty((cFileName)->cp_darr) .AND. !Empty((cFileName)->cp_dsta) .AND. !Empty((cFileName)->pp_dfin)
	cRetVal := "S"
ELSE
	cRetVal := "?"
ENDIF
Return cRetVal

Static Function GetTempProc()

local cProc
if AllTrim(d_dlvntH->doc_type) == "W2CZ"
     cProc := "997.0"
elseif AllTrim(d_dlvntH->doc_type) == "P2CZ"
     cProc := "997.2"
elseif AllTrim(d_dlvntH->doc_type) == "P2IL"
     cProc := "997.3"
elseif AllTrim(d_dlvntH->doc_type) == "W2IL"
	  cProc := "997.4"
endif

Return Cproc

Static Procedure PrintCzheh(cMode,lAll,nChoice)

LOCAL nShpDoc
LOCAL nCounter := 1
LOCAL nOldArea := Select()
LOCAL nRecNo := (Alias())->(RecNo())
LOCAL nIsraOrigin := 0
LOCAL nCzhOrigin  := 0
LOCAL nTotOrigin  := 0
LOCAL i := 1
LOCAL nRecNo_Bat,cStage
LOCAL aProducts := {}

default lAll to FALSE
default nChoice to 1


SET PRINTER TO LPT1
SET PRINTER ON
SET CONSOLE OFF

? PrnSetup()
? '!R! CASS 2; EXIT;'

IF Empty(cMode)
	 NetUse("m_linemv",5)
	 m_linemv->( ORDSETFOCUS("ilnmvbs") )
	 NetUse("d_dlvntD",5)
    NetUse("d_dlvntH",5)
	 nShpDoc := GetCounter(d_lntmp->cpproc_id)
    if d_dlvntH->(AddRec(5,"CZH"))
              d_dlvntH->shpdoc := nShpDoc
				  DO CASE
					  CASE d_lntmp->cpproc_id == "997.0"
						    d_dlvntH->doc_type := "W2CZ"
					  CASE d_lntmp->cpproc_id == "997.2"
						    d_dlvntH->doc_type := "P2CZ"
					  CASE d_lntmp->cpproc_id == "997.3"
						    d_dlvntH->doc_type := "P2IL"
					  CASE d_lntmp->cpproc_id == "997.4"
						    d_dlvntH->doc_type := "W2IL"
				  ENDCASE
              d_dlvntH->(dbclosearea())
    endif
ELSE
	 nRecNo_Bat :=  d_dlvntD->(RecNo())
	 dbselectarea("d_dlvntD")
	 DBSEEK( str(d_dlvntH->shpdoc,6)+d_dlvntH->doc_type )
	 nShpDoc := d_dlvntH->shpdoc
ENDIF


IF Empty(cMode)
   ? "…ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕª"
   ? "∫                                   KYOCERA AVX COMPONENTS                          ∫"
   ? "ÃÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ"
   ? "∫                          Packaging List for External Production                   ∫"
   ? "«ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ∂"
   ? "∫                                                                                   ∫"
   ? "∫                                                                                   ∫"
   ? "∫                                                           Date : " + DTOC(Date()) + "         ∫"
   ? "∫                                                           Ref No: " + str(nShpDoc) + "          ∫"
   ? "∫                                                                                   ∫"
   ? "∫ ⁄ƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒ¬ƒƒƒ¬ƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒø ∫"
   ? "∫ ≥ #  ≥ Batch No ≥      ESN        ≥ Line | Size ≥  Value  ≥ W ≥   Psc   ≥Stage  ≥ ∫"
   ? "∫ √ƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒ≈ƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒ≈ƒƒƒ≈ƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒ¥ ∫"
   //    XXX   XXXXXX    XXXXXXXXXXXXXXXX   XXX    XXXX  XXXXXXXX     X      XXXXXXX

  FOR nCounter := 1 TO Len(aAllocRecNo)
	 IF aAllocRecNo[nCounter] == "X"
		 IF nCounter > 1
                ? "∫ √ƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒ≈ƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒ≈ƒƒƒ≈ƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒ¥ ∫"
		 ENDIF
		 d_lntmp->(dbgoto(nCounter))
		 if d_dlvntD->( AddRec(5) )
          d_dlvntD->ShpDoc := nShpDoc
          d_dlvntD->b_id := d_lntmp->b_id
			 d_dlvntD->CP_BQTYW := d_lntmp->CP_BQTYW
			 d_dlvntD->CP_BQTYP := d_lntmp->CP_BQTYP
			 DO CASE
			    CASE d_lntmp->cpproc_id == "997.0"
			  	    d_dlvntD->doc_type := "W2CZ"
			    CASE d_lntmp->cpproc_id == "997.2"
			  	    d_dlvntD->doc_type := "P2CZ"
			    CASE d_lntmp->cpproc_id == "997.3"
			  	    d_dlvntD->doc_type := "P2IL"
			    CASE d_lntmp->cpproc_id == "997.4"
			  	    d_dlvntD->doc_type := "W2IL"
			 ENDCASE
			 d_dlvntD->(dbunlock())
		 endif
		 m_linemv->(dbseek(d_lntmp->b_id))
		 IF nChoice == 1
			 While !eval({|| m_linemv->arr .AND. !m_linemv->sta .AND. !m_linemv->fin  .AND. m_linemv->cpproc_id == d_lntmp->cpproc_id .AND. d_lntmp->b_id == m_linemv->b_id})
			   	 m_linemv->(dbskip(1))
			 End
		 ELSE
			While !eval({|| m_linemv->arr .AND. m_linemv->sta .AND. !m_linemv->fin  .AND. m_linemv->cpproc_id == d_lntmp->cpproc_id .AND. d_lntmp->b_id == m_linemv->b_id})
			  	 m_linemv->(dbskip(1))
			End
		 ENDIF



		 IF d_lntmp->b_id == m_linemv->b_id
			 cStage := Str(m_linemv->cp_stage,3)
		 ENDIF

	 	 ? "∫ ≥" + Str(i,3)                 + " | "           + ;
	     		     d_lntmp->b_id             + "   |"          + ;
	 	 		     d_lntmp->esn_id           + " | "           + ;
					  d_lntmp->pline_id         + "  | "          + ;
	 	 		     d_lntmp->size_id          + " |"            + ;
                           Str(d_lntmp->value_id,9,3)+ " |"         + ;
                           Transform(d_lntmp->CP_BQTYW,"999") + "|" + ;
                           Transform(d_lntmp->CP_BQTYP,"9,999,999") + "|" + ;
                         cStage           + "    | ∫"

		 i++
    ENDIF
  NEXT
  ? "∫ ¿ƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒ¡ƒƒƒ¡ƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒŸ ∫"
  ? "»ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº"
ELSEIF cMode == "Shipping"
   ? "…ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕª"
   ? "∫                                   KYOCERA AVX COMPONENTS                          ∫"
   ? "ÃÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ"
   ? "∫                          Packaging List for External Production                   ∫"
IF AllTrim(d_dlvntH->doc_type) == "S2IL"
	? "∫                                * * * S A M P L E S * * *                          ∫"
ENDIF
   ? "«ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ∂"
   ? "∫                                                                                   ∫"
   ? "∫                                                                                   ∫"
   ? "∫                                                           Date : " + DTOC(Date()) + "         ∫"
   ? "∫                                                           Ref No: " + str(nShpDoc) + "          ∫"
   ? "∫                                                                                   ∫"
   ? "∫ ⁄ƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒ¬ƒƒƒ¬ƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒø ∫"
   ? "∫ ≥ #  ≥ Batch No ≥      ESN        ≥ Line | Size ≥  Value  ≥ W ≥   Psc   ≥Status ≥ ∫"
   ? "∫ √ƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒ≈ƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒ≈ƒƒƒ≈ƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒ¥ ∫"
  While d_dlvntH->shpdoc == d_dlvntD->shpdoc .AND. d_dlvntH->doc_type == d_dlvntD->doc_type .AND. !d_dlvntD->(eof())
		 IF i > 1
                ? "∫ √ƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒ≈ƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒ≈ƒƒƒ≈ƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒ¥ ∫"
		 ENDIF
	 	 ? "∫ ≥" + Str(i,3)                 + " | "           + ;
	     		     d_line->b_id             + "   |"          + ;
	 	 		     d_line->esn_id           + " | "           + ;
					  d_line->pline_id         + "  | "          + ;
	 	 		     d_line->size_id          + " |"            + ;
                           Str(d_line->value_id,9,3)+ " |"         + ;
                           Transform(d_dlvntD->CP_BQTYW,"999") + "|" + ;
                           Transform(d_dlvntD->CP_BQTYP,"9,999,999") + "|  " + ;
	 	 		     d_line->B_stat           + "    | ∫"
		 i++
		 d_dlvntD->(dbskip(1))
  End
  ? "∫ ¿ƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒ¡ƒƒƒ¡ƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒŸ ∫"
  ? "»ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº"
ELSEIF cMode == "Packaging"
   ////test for Start
  	//NetUse("m_linemv",5)
  	m_linemv->( ORDSETFOCUS("ilnmvbs") )
	While d_dlvntH->shpdoc == d_dlvntD->shpdoc .AND. d_dlvntH->doc_type == d_dlvntD->doc_type .AND. !d_dlvntD->(eof()) .AND. !lAll
  		 m_linemv->(dbseek(d_line->b_id))
  		 While d_line->cpproc_id $ "_997.2_997.3_997.0_997.4_" .AND. ;
		 		 !eval({|| d_line->b_id == m_linemv->b_id .AND. m_linemv->cpproc_id == d_line->cpproc_id .AND. ! m_linemv->FIN})
  				 m_linemv->(dbskip(1))
  		 End
  		 IF ((!(m_linemv->arr .AND. m_linemv->sta .AND.;
		 	 !m_linemv->fin) .AND. d_line->cpproc_id $ "_997.2_997.3_997.0_997.4_") .OR. ;
          !d_line->cpproc_id $ "_997.2_997.3_997.0_997.4_") .AND. AllTrim(d_dlvntH->doc_type) <> "S2IL"
               if !IfEnglish()
						Alert("! "+d_line->b_id +" Ñêéå  START  áÖÖâÉ òëá ",{"OK"} )
					Else
					   Alert("Batch Arrival Notification for " + d_line->b_id+ " is missing",{"OK"} )
					Endif
          dbselectarea(nOldArea)
          dbgoto(nRecNo)
			 d_dlvntD->(dbgoto(nRecNo_Bat))
			 RETURN
  		 ENDIF
  		 m_linemv->(dbgotop())
  	    d_dlvntD->(dbskip(1))
  	END
  	dbselectarea("d_dlvntD")
  	DBSEEK( str(d_dlvntH->shpdoc,6) + d_dlvntH->doc_type )

	IF !lAll .AND. Empty(d_dlvntH->d_shipd) .AND. d_dlvntH->( RecLock( 5 ) )
	   d_dlvntH->d_shipd := Date()
	   d_dlvntH->(dbunlock())
	ENDIF

   /////////////
	?;?;?
   ? "(15Q"
   ?? "(s16.66H"
   ? "…ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕª"
   ? "∫                                                                                                              ∫"
	? "∫                                             INVOICE " + str(nShpDoc)+"                                                   ∫"
   ? "∫                                                                                                              ∫"
   ? "ÃÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ"
   ? "∫                                                                                                              ∫"
   ? "∫ " + "SENT BY"+"                                                                                Date : " + DTOC(d_dlvntH->d_shipd) + "       ∫"
	if ("CZ" $ GetUserInfo():cGroupID .AND. !lAll) .OR. (lAll .AND. AllTrim(d_dlvntH->doc_type) $ "_W2IL_P2IL_S2IL" )
		? "∫ " + "KYOCERA AVX COMPONENTS s.r.o.(BOND)"+"                                                                          ∫"
      ? "∫ " + "KYOCERA AVX THIN FILM OPERATION"+"                                                        AWB#:" + padc(d_dlvntH->awb_no,15) + "  ∫"
	   ? "∫ " + "Sokolovska 573"+"                                                                                               ∫"
      ? "∫ " + "68601 Uherske Hradiste"+"                                                                                       ∫"
      ? "∫ " + "CZECH REPUBLIC"+"                                                                                               ∫"
      ? "∫                                                                                                              ∫"
	   ? "ÃÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ"
	   ? "∫                                                                                                              ∫"
	   ? "∫ " + "SENT TO"+"                                                                                                      ∫"
      ? "∫ " + "KYOCERA AVX COMPONENTS"+"                                                                                       ∫"
      ? "∫ " + "Har Hachotzvim Industrial Area"+"                                                                               ∫"
      ? "∫ " + "3 Ha-Marpeh Street"+"                                                                                           ∫"
      ? "∫ " + "Jerusalem 9777403, ISRAEL"+"                                                                                    ∫"
      ? "∫                                                                                                              ∫"
      ? "∫ " + "Tel : 972-2-5720111"+"                                                                                          ∫"
      ? "∫ " + "Fax : 972-2-5815999"+"                                                                                          ∫"
	else
      ? "∫ " + "KYOCERA AVX COMPONENTS"+"                                                                                       ∫"
      ? "∫ " + "Har Hachotzvim Industrial Area"+"                                                         AWB#:" + padc(d_dlvntH->awb_no,15) + "  ∫"
      ? "∫ " + "3 Ha-Marpeh Street"+"                                                                                           ∫"
      ? "∫ " + "Jerusalem 9777403, ISRAEL"+"                                                                                    ∫"
		? "∫ " + "Vat Reg No. : 510862857               "+"                                                                       ∫"
      ? "∫                                                                                                              ∫"
      ? "∫ " + "Tel : 972-2-5720111"+"                                                                                          ∫"
      ? "∫ " + "Fax : 972-2-5815999"+"                                                                                          ∫"
      ? "∫                                                                                                              ∫"
	   ? "ÃÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ"
	   ? "∫                                                                                                              ∫"
	   ? "∫ " + "SENT TO"+"                                                                                                      ∫"
      ? "∫ " + "KYOCERA AVX COMPONENTS LTD VAT 680466469"+"                                                                     ∫"
      ? "∫ " + "KYOCERA AVX COMPONENTS s.r.o."+"                                                                                ∫"
		IF AllTrim(d_dlvntH->doc_type) $ "_P2CZ_"
 		   ? "∫ " + "Sokolovska 573"+"                                                                                               ∫"
         ? "∫ " + "68601 Uherske Hradiste"+"                                                                                       ∫"
         ? "∫ " + "CZECH REPUBLIC"+"                                                                                               ∫"
	      ? "∫ " + "ATT: HUNUS HOLZER"+"                                                                                            ∫"
	   ELSE
         ? "∫ " + "Sady - Za Oslakov 303"+"                                                                                        ∫"
         ? "∫ " + "68601 Uherske Hradiste"+"                                                                                       ∫"
         ? "∫ " + "CZECH REPUBLIC"+"                                                                                               ∫"
	      ? "∫ " + "ATT: HUNUS HOLZER"+"                                                                                            ∫"
		ENDIF
	endif
	? "∫                                                                                                              ∫"
	? "∫ ⁄ƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø      ∫"
   ? "∫ ≥ #  ≥ Part No.        ≥   Tariff    ≥Batch     ≥    Units   ≥   Israel origin   ≥Add Val  ≥  Total   ≥      ∫"
   ? "∫ ≥    ≥                 ≥             ≥          ≥            √ƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒ¥Czech    ≥          ≥      ∫"
	? "∫ ≥    ≥                 ≥             ≥No.       ≥            ≥  Value  ≥ Value   ≥Origin   ≥  Value   ≥      ∫"
  	? "∫ ≥    ≥                 ≥             ≥          ≥            ≥Per 1000 ≥         ≥         ≥          ≥      ∫"
   ? "∫ √ƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¥      ∫"

  While d_dlvntH->shpdoc == d_dlvntD->shpdoc .AND. d_dlvntH->doc_type == d_dlvntD->doc_type .AND. !d_dlvntD->(eof())
		  c_shpval->((dbseek(d_line->ptype_id + d_line->size_id)))
		  c_ptype->(dbseek(d_line->ptype_id))
		  d_esn->(dbseek(d_line->esn_id))
		  //temp for EDOMO
		  /*	 m_linemv->(ordsetfocus("ilnmvbn"))
          m_linemv->(dbseek(d_dlvntD->b_id+GetTempProc()))
			 IF !lAll .AND. m_linemv->(found()) .AND. d_dlvntD->( RecLock( 5 ) )
				 d_dlvntD->CP_BQTYW := m_linemv->CP_BQTYW
				 d_dlvntD->CP_BQTYP := m_linemv->CP_BQTYP
				 d_dlvntD->(dbunlock())
			 ELSEIF lAll .AND. m_linemv->(found()) .AND. d_dlvntH->( RecLock( 5 ) )
				 d_dlvntH->d_shipd := m_linemv->CP_DSTA
				 d_dlvntH->(dbunlock())
			 ENDIF
		  //End temp for EDOMO*/
		  IF !lAll .AND. Empty(d_dlvntD->amt_ilval) .AND. d_dlvntD->( RecLock( 5 ) )

			  if  AllTrim(d_dlvntH->doc_type) $ "_W2IL_P2IL_S2IL"
					d_dlvntD->amt_czval := d_dlvntD->CP_BQTYP / 1000 * c_shpval->ADDED_VAL
			  endif

	   	  d_dlvntD->amt_ilval := d_dlvntD->CP_BQTYP / 1000 * (d_esn->tp1 * 0.9)

			  d_dlvntD->(dbunlock())
		  ENDIF

        IF Ascan( aProducts , c_ptype->cust_ptype ) == 0
           Aadd( aProducts , c_ptype->cust_ptype )
        ENDIF

		 //IL2CZ_VAL
		 //by Benny request new tariff code for Mid section to CZ //31/01/12 it was 8536.10.0040
		 IF i > 1
			 ? "∫ √ƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¥      ∫"
		 ENDIF
	    IF i == 12
		    EJECT
		    ?;?;?;?;?
	    ENDIF
	 	 ? "∫ ≥" + Str(i,3)                 + " | "          + ;
	 	 		     d_line->esn_id           + "| "           + ;
					  c_ptype->tariff          + "| "            + ;
	     		     d_line->b_id             + "   | "         + ;
	 	 	  	     IIF(AllTrim(d_dlvntH->doc_type) $ "_W2CZ_" ,Transform(d_dlvntD->CP_BQTYW,"9,999,999") ,Transform(d_dlvntD->CP_BQTYP,"9,999,999") )     + "  |" + ;
                 Transform(d_dlvntD->amt_ilval/d_dlvntD->CP_BQTYP*1000,"99,999.99")     + "|" + ;
                 Transform(d_dlvntD->amt_ilval,"99,999.99")     + "≥"+Transform(IF(AllTrim(d_dlvntH->doc_type) $ "_W2IL_P2IL_S2IL",d_dlvntD->amt_czval ,0 ),"99,999.00")+"≥"+;
					  Transform(d_dlvntD->amt_ilval + IF(AllTrim(d_dlvntH->doc_type) $ "_W2IL_P2IL_S2IL",d_dlvntD->amt_czval ,0 ),"999,999.99")+"≥      ∫"
		 i++
 		 nIsraOrigin := nIsraOrigin + d_dlvntD->amt_ilval
       nCzhOrigin  := nCzhOrigin  + d_dlvntD->amt_czval
		 nTotOrigin  := nTotOrigin  + d_dlvntD->amt_ilval + IF(AllTrim(d_dlvntH->doc_type) $ "_W2IL_P2IL_S2IL",d_dlvntD->amt_czval ,0 )
		 d_dlvntD->(dbskip(1))
  End
	//IF i == 15
	//	?;?;?;?;?;?;?;?
	//ENDIF
	? "∫ √ƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¥      ∫"
	IF AllTrim(d_dlvntH->doc_type) $ "_W2IL_P2IL_S2IL"
		? "∫ ≥                                            Total Value (in USD) :    ≥         ≥"+Transform(nCzhOrigin,"9,999,999")+"≥"+Transform(nTotOrigin,"999,999.99") +"≥      ∫"
	ELSE
		? "∫ ≥                                            Total Value (in USD) :    ≥"+Transform(nIsraOrigin,"9,999,999")+"≥         ≥"+Transform(nTotOrigin,"999,999.99") +"≥      ∫"
	ENDIF

	//IF i == 13
	//	?;?;?;?;?;?;?;?
	//ENDIF
	? "∫ ¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒŸ      ∫"
	IF i >= 9 .AND. i <= 12
		EJECT
		?;?;?;?;?
	ENDIF
	? "∫ ⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø                                                                                  ∫"
   ? "∫ ≥      Product type       ≥                                                                                  ∫"
   ? "∫ √ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥                                                                                  ∫"
	FOR i := 1 TO nLen(aProducts)
		 ? "∫ ≥" + Padr( aProducts[i] , 25 )+"≥                                                                                  ∫"
	NEXT
   ? "∫ ¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ                                                                                  ∫"
	? "∫                                                                                                              ∫"
	? "∫                                                                                                              ∫"
	IF AllTrim(d_dlvntH->doc_type) $ "_W2IL_P2IL_S2IL"
	   ? //PADR("∫ Value for Customs Purpose Only: $"+AllTrim(Transform(nCzhOrigin,"9,999,999")),111)+"∫"
	ELSE
		? "∫ VAT680466469                                                                                                 ∫"
		? "∫ The exporter of the products covered by this document customs                                                ∫"
      ? "∫ authorization No. 510862857                                                                                  ∫"
      ? "∫ declares that, except where otherwise clearly indicated, these products are                                  ∫"
      ? "∫ of ISRAELI(Jerusalem, 9777403) preferential origin.                                                          ∫"
	ENDIF
   ? "»ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº"

ENDIF

?? "E"
//EJECT
? '!R! CASS 1; EXIT;'
? PrnReset()

SET PRINTER TO
SET PRINTER OFF
SET CONSOLE ON

IF Empty(cMode)
   d_dlvntD->(dbclosearea())
	m_linemv->(dbclosearea())
ELSE
	d_dlvntD->(dbgoto(nRecNo_Bat))
ENDIF
dbselectarea(nOldArea)
dbgoto(nRecNo)

Return

Static Procedure CzhehDeliv()

LOCAL oForm := Form():new(1,0,24,79,iif(IfEnglish(),"                     Printing of PROFORMA INVOICE","                            áÖåôé öÉÖíö öóîÑ"),"N/W", ProcName() )
LOCAL bDoc, column, nKey, cScreen, bBat, bCurrent
LOCAL nWhich_Doc,nWhich_Bat,nRec
LOCAL cWhatIshowNow
LOCAL cSisma:= Space(10)
LOCAL cOldScr

LOCAL aKeyList:={;
                 { "TAB      - Batches Window             ",K_TAB      },;
					  { "Ctrl+TAB - IL/CZ Window               ",K_CTRL_TAB },;
                 { "F3       - Print PROFORMA INVOICE Doc ",K_F3  	  },;
                 { "F4       - Print Packaging List       ",K_F4  	  },;
                 { "F10      - Updating of AWBN           ",K_F10      },;
					  { "F11      - Reprint PROFORMA           ",K_F11  	  },;
					  { "Del      - Delete  PROFORMA           ",K_DEL  	  },;
					  { "Alt+F4   - Search by active index     ",K_ALT_F4   },;
                 { "Esc      - Exit                       ",K_ESC      } ;
                }

LOCAL aKey    :={;
                 { "TAB    - Batches Window          ",K_TAB },;
                 { "Delete - Delete batch from list  ",K_DEL },;
                 { "Esc    - Exit                    ",K_ESC } ;
                }


SetHlpKeys( aKeyList )



SETBLINK(.F.)

NetUse("d_esn",5)
ordsetfocus(1)
NetUse("c_proc",5)
c_proc->(ordsetfocus("iproc_id"))
NetUse("c_ptype",5)
c_ptype->(ordsetfocus(1))
NetUse("c_shpval",5)
c_shpval->(ordsetfocus(1))
NetUse("d_dlvntH",5)
d_dlvntH->(ordsetfocus(1))
NetUse("d_dlvntD",5)
ordsetfocus("ishpbat")
NetUse("d_line",5)
d_line->(ordsetfocus("ib_idln"))
dbselectarea("d_dlvntD")
SET RELATION TO d_dlvntD->b_id INTO d_line
NetUse("m_linemv",5)
m_linemv->(ordsetfocus("ilnmvbn"))
dbselectarea("d_dlvntH")
d_dlvntH->(ordsetfocus(1))
/////////
SET RELATION TO str(d_dlvntH->shpdoc,6)+d_dlvntH->doc_type INTO d_dlvntD
/////////
if "CZ" $ GetUserInfo():cGroupID
   d_dlvntH->(dbsetfilter({|| AllTrim(d_dlvntH->doc_type) $ "_W2IL_P2IL_S2IL"}))
	cWhatIshowNow := "CZ"
   @ 1, 67 SAY "           " COLOR "N/W"
	@ 1, 67 SAY "From Czech " COLOR "N/W"
else
	d_dlvntH->(dbsetfilter({|| AllTrim(d_dlvntH->doc_type) $ "_W2CZ_P2CZ"}))
   cWhatIshowNow := "IL"
   @ 1, 67 SAY "           " COLOR "N/W"
   @ 1, 67 SAY "From Israel" COLOR "N/W"
endif

d_dlvntH->(dbgotop())


// d_dlvntH Browse
@  2, 1 TO 12,78 COLOR COLORS_FIRST
bDoc := TBrowseDB( 3, 2, 11, 77 )
bDoc:colSep    := COLSEP
bDoc:headSep   := HEADSEP
bDoc:footSep   := FOOTSEP
bDoc:colorSpec := Colors()//COLORS_FIRST

// d_dlvntD Browse
@ 13, 1 TO 24,78 COLOR COLORS_SECOND
bBat := TBrowseDB( 14, 2, 23, 77 )
bBat:skipBlock     := {|nSkip| SkipDB(nSkip,;
                 {|| str(d_dlvntH->shpdoc,6)+d_dlvntH->doc_type == str(d_dlvntD->shpdoc,6)+d_dlvntD->doc_type})}
bBat:goTopBlock    := {|| GoTopDB(;
                 {|| str(d_dlvntH->shpdoc,6)+d_dlvntH->doc_type == str(d_dlvntD->shpdoc,6)+d_dlvntD->doc_type})}
bBat:goBottomBlock := {|| GoBottomDB(;
                 {|| str(d_dlvntH->shpdoc,6)+d_dlvntH->doc_type == str(d_dlvntD->shpdoc,6)+d_dlvntD->doc_type})}
bBat:colSep    := COLSEP
bBat:headSep   := HEADSEP
bBat:footSep   := FOOTSEP
bBat:colorSpec := COLORS_SECOND


// TBColumn objects
// d_dlvntH file
column := TBColumnNew( "Ref No.", {|| d_dlvntH->shpdoc} )
column:ColorBlock:= {|| GetColors(cWhatIshowNow)}
bDoc:addColumn( column )
column := TBColumnNew( "AWBN"   , {|| d_dlvntH->awb_no} )
bDoc:addColumn( column )
column := TBColumnNew( "Date"   , {|| d_dlvntH->D_shipd} )
bDoc:addColumn( column )
column := TBColumnNew( " From / To " , {|| GetDestination()} )
bDoc:addColumn( column )

// TBColumn Objects
// d_dlvntD File
column := TBColumnNew( "Purp"      , {|| d_line->b_purp  } )
bBat:addColumn( column )
column := TBColumnNEW( "B/N"       , {|| d_dlvntD->b_id  } )
bBat:addColumn( column )
column := TBColumnNEW( "ESN"       , {|| d_line->esn_id  } )
bBat:addColumn( column )
column := TBColumnNEW( "Status"    , {|| d_line->b_stat} )
bBat:addColumn( column )
column := TBColumnNEW( " PR "      , {|| d_line->b_prior } )
bBat:addColumn( column )
column := TBColumnNEW( "Qty (Wfr)" , {|| Transform(d_dlvntD->CP_BQTYW,"999") } )
bBat:addColumn( column )
column := TBColumnNEW( "Qty (Psc)" , {|| Transform(d_dlvntD->CP_BQTYP,"9,999,999") } )
bBat:addColumn( column )
column := TBColumnNEW( "Proccess"  , {|| CurrProcName( d_line->cpproc_id ) } )
bBat:addColumn( column )




// Remember: The variable contains a REFERENCE
// to the object
// Dehilite cell in the unselected object
ForceStable( bBat )
bBat:deHilite()


// Current object
bCurrent := bDoc

nWhich_Doc := 0;nWhich_Bat := 0


WHILE .T.
   DISPBEGIN()
   WHILE !(bCurrent:stabilize()) .AND. (NEXTKEY() == 0)
   END
   DISPEND()

   IF (NEXTKEY() == 0) .AND. (nWhich_Doc != d_dlvntH->(RECNO()))
      nWhich_Doc  := d_dlvntH->(RECNO())

		dbselectarea("d_dlvntD")
      DBSEEK( str(d_dlvntH->shpdoc,6)+d_dlvntH->doc_type )
      bBat:refreshAll()
      ForceStable( bBat )
      bBat:deHilite()
		nWhich_Bat  := d_dlvntD->(RECNO())

		dbselectarea("d_dlvntH")
   ENDIF

    nKey := INKEY(1)

	F1 PRESSED//here i can to change the nkey
   // Process key
   IF !TBMoveCursor( nKey, bCurrent )
      IF ( nKey == K_ESC )
         EXIT
		ELSEIF nKey == K_ALT_F4 .AND. bCurrent == bDoc
			d_dlvntH->(ordsetfocus(2))
			FindIt("d_dlvntH")
			d_dlvntH->(ordsetfocus(1))
		   bCurrent:refreshall()
		ELSEIF ( nKey == K_F10 )
			IF bCurrent == bDoc  .AND. ((cWhatIshowNow $ GetUserInfo():cGroupID .AND. cWhatIshowNow == "CZ") .OR. (cWhatIshowNow == "IL" .AND. ! "CZ" $ GetUserInfo():cGroupID))
            WHILE !bCurrent:stabilize();END
			   InsertAWB( bCurrent )
			   bCurrent:refreshcurrent()
			ELSEIF bCurrent == bDoc .AND. !cWhatIshowNow $ GetUserInfo():cGroupID .AND. cWhatIshowNow == "IL"
            Msg24("Performing this action is not allowed !" , 1 , .T. )
			ELSE
				Msg24("This operation possible only in AWB browser" , 1 , .T. )
			ENDIF
		ELSEIF ( nKey == K_F3 )
			IF bCurrent == bDoc
            Msg24("Printing Shipping List...", 1 , .T. )
				PrintCzheh("Packaging")
				dbselectarea("d_dlvntH")
				bCurrent:RefreshaLL()
				ForceStable( bCurrent )
			ELSEIF bCurrent == bDoc .AND. !cWhatIshowNow $ GetUserInfo():cGroupID .AND. cWhatIshowNow == "IL"
            Msg24("Performing this action is not allowed !" , 1 , .T. )
			ELSE
				Msg24("This operation possible only in AWB browser" , 1 , .T. )
			ENDIF
		ELSEIF ( nKey == K_CTRL_TAB)
			IF bCurrent == bDoc
				if cWhatIshowNow == "CZ"
					d_dlvntH->(dbclearfilter())
					d_dlvntH->(dbsetfilter({|| AllTrim(d_dlvntH->doc_type) $ "_W2CZ_P2CZ"}))
					cWhatIshowNow := "IL"
				   @ 1, 67 SAY "           " COLOR "N/W"
					@ 1, 67 SAY "From Israel" COLOR "N/W"
				else
					d_dlvntH->(dbclearfilter())
					d_dlvntH->(dbsetfilter({|| AllTrim(d_dlvntH->doc_type) $ "_W2IL_P2IL_S2IL"}))
				   cWhatIshowNow := "CZ"
				   @ 1, 67 SAY "           " COLOR "N/W"
				   @ 1, 67 SAY "From Czech " COLOR "N/W"
				endif
				d_dlvntH->(dbgotop())
				d_dlvntD->(dbseek(str(d_dlvntH->shpdoc,6)+d_dlvntH->doc_type))
				bCurrent:RefreshaLL()
			ELSE
				Msg24("This operation possible only in AWB browser" , 1 , .T. )
			ENDIF
		ELSEIF ( nKey == K_F4 )
			IF bCurrent == bDoc
            Msg24("Printing Packaging List...", 1 , .T. )
				PrintCzheh("Shipping")
			ELSEIF bCurrent == bDoc .AND. !cWhatIshowNow $ GetUserInfo():cGroupID .AND. cWhatIshowNow == "IL"
            Msg24("Performing this action is not allowed !" , 1 , .T. )
			ELSE
				Msg24("This operation possible only in AWB browser" , 1 , .T. )
			ENDIF
		ELSEIF ( nKey == K_F11 )
			IF bCurrent == bDoc
            Msg24("Printing Shipping List...", 1 , .T. )
   			PrintCzheh("Packaging",.T.)
			ELSEIF bCurrent == bDoc .AND. !cWhatIshowNow $ GetUserInfo():cGroupID .AND. cWhatIshowNow == "IL"
            Msg24("Performing this action is not allowed !" , 1 , .T. )
			ELSE
				Msg24("This operation possible only in AWB browser" , 1 , .T. )
			ENDIF
		ELSEIF ( nKey == K_DEL ) .AND. bCurrent == bBat .AND. ;
				   ((cWhatIshowNow $ GetUserInfo():cGroupID .AND. cWhatIshowNow == "CZ") .OR. (cWhatIshowNow == "IL" .AND. ! "CZ" $ GetUserInfo():cGroupID))
  	          m_linemv->( ORDSETFOCUS("ilnmvbs") )
				 m_linemv->(dbseek(d_line->b_id))
		       While !eval({|| d_line->b_id == m_linemv->b_id .AND. m_linemv->cpproc_id == d_line->cpproc_id})
				        m_linemv->(dbskip(1))
      		 End
		       IF (m_linemv->arr .AND. !m_linemv->sta .AND. !m_linemv->fin)
                IF m_linemv->( RecLock( 5 ) )
					    m_linemv->arr       := .F.
                   m_linemv->cp_darr   := CTOD("  /  /  ")
                   m_linemv->cp_tarr   := ""
				       m_linemv->cp_widarr := ""
      				 m_linemv->( DbUnLock() )
					 ENDIF
					 IF d_line->( RecLock( 5 ) )
   					 d_line->cp_darr   := CTOD("  /  /  ")
   					 d_line->cp_tarr   := ""
   					 d_line->cp_widarr := ""
						 d_line->( xDbUnLock() )
					 ENDIF
				 ELSEIF (m_linemv->arr .AND. m_linemv->sta .AND. !m_linemv->fin)
                IF m_linemv->( RecLock( 5 ) )
					    m_linemv->arr       := .F.
                   m_linemv->cp_darr   := CTOD("  /  /  ")
                   m_linemv->cp_tarr   := ""
				       m_linemv->cp_widarr := ""
					    m_linemv->sta       := .F.
                   m_linemv->cp_dsta   := CTOD("  /  /  ")
                   m_linemv->cp_tsta   := ""
				       m_linemv->cp_widsta := ""
      				 m_linemv->( DbUnLock() )
					 ENDIF
					 IF d_line->( RecLock( 5 ) )
   					 d_line->cp_darr   := CTOD("  /  /  ")
   					 d_line->cp_tarr   := ""
   					 d_line->cp_widarr := ""
   					 d_line->cp_dsta   := CTOD("  /  /  ")
   					 d_line->cp_tsta   := ""
   					 d_line->cp_widsta := ""
						 d_line->( xDbUnLock() )
					 ENDIF
		       ENDIF
             IF d_dlvntD->( RLock()   )
                d_dlvntD->( DBDELETE())
                d_dlvntD->( DBCOMMIT())
                d_dlvntD->( DBUNLOCK())
					 d_dlvntD->( DBSKIP(0) )
             ENDIF
				 dbselectarea("d_dlvntD")
				 bCurrent:RefreshaLL()
				 ForceStable( bCurrent )
		ELSEIF ( nKey == K_DEL ) .AND. bCurrent == bDoc .AND. ;
				   ((cWhatIshowNow $ GetUserInfo():cGroupID .AND. cWhatIshowNow == "CZ") .OR. (cWhatIshowNow == "IL" .AND. ! "CZ" $ GetUserInfo():cGroupID))  .AND. ;
					Alert("Are you sure you want to delete ?",{"Yes","No"}) == 1

					cOldScr := SAVESCREEN()

					@11,30 CLEAR TO 13, 55
               DrawBox(11,30,13,55)
               @ 12,33 SAY "Password   " COLOR "n/bg"
               @ 12,45  GET cSisma      PICTURE "@! XXXXXXXXXX" SEND postBlock := { |o| Checkpwd(o,.T.) } COLOR "R/R"
					READ
					RESTSCREEN(,,,,cOldScr)
					IF LastKey() <> K_ESC
                 IF d_dlvntH->( RLock()   )
                    d_dlvntH->( DBDELETE())
                    d_dlvntH->( DBCOMMIT())
                    d_dlvntH->( DBUNLOCK())
									 d_dlvntH->( DBSKIP(0) )
                 ENDIF
				     While d_dlvntH->shpdoc == d_dlvntD->shpdoc .AND. d_dlvntH->doc_type == d_dlvntD->doc_type .AND. !d_dlvntD->(eof())
									 IF d_dlvntD->( RLock()   )
									    d_dlvntD->( DBDELETE())
									    d_dlvntD->( DBCOMMIT())
									    d_dlvntD->( DBUNLOCK())
									    d_dlvntD->( DBSKIP(0) )
									 ENDIF
				      	 d_dlvntD->(dbskip(1))
				     End
				     dbselectarea("d_dlvntH")
				     bCurrent:RefreshaLL()
				     ForceStable( bCurrent )
					ENDIF
      ELSEIF ( nKey == K_TAB )
         bCurrent:deHilite()
         IF bCurrent == bDoc
            bCurrent := bBat
				dbselectarea("d_dlvntD")
				SetHlpKeys( aKey )
         ELSE
            bCurrent := bDoc
				dbselectarea("d_dlvntH")
				SetHlpKeys( aKeyList )
         ENDIF
         bCurrent:hilite()
      ENDIF

   ENDIF

END

d_dlvntH->(dbclosearea())
d_dlvntD->(dbclosearea())
d_line->  (dbclosearea())
d_esn->  (dbclosearea())
c_proc->  (dbclosearea())
c_ptype-> (dbclosearea())
c_shpval->(dbclosearea())
m_linemv->(dbclosearea())

oForm:hide()

Return

Static Function GetColors(cWhatIshowNow)

local nOldArea := Select()
local aRetVal := {1,2}
if (m_linemv->(dbseek(d_line->b_id+IIF(cWhatIshowNow == "IL","997.2" ,"997.3" )))  .OR. ;
	 m_linemv->(dbseek(d_line->b_id+IIF(cWhatIshowNow == "IL","997.0" ,"997.4" )))) .AND. ;
	m_linemv->ARR .AND. m_linemv->STA .AND. m_linemv->FIN
     aRetVal := {3,5}
endif
dbselectarea(nOldArea)
Return aRetVal


PROCEDURE SayLogo
IF !IfEnglish()
	@ 0,0 SAY Dtoc(Date())+" "+ Left(Time(),5) + Padl( " òÖñââ Öóé çâêÖöê ìÖëâÄ äòíé    åÄòôâ  ëóÄ.âÖ.âÄ",66)    COLOR if( IsColor() , "W+/R" , "N/W" )
ELSE
	@ 0,0 SAY Padr( " KYOCERA AVX COMPONENTS   Production Floor Data Collection System",66) + Dtoc(Date())+" "+ Left(Time(),5) COLOR if( IsColor() , "W+/R" , "N/W" )
ENDIF
RETURN

Static FUNCTION CurrProcName( cProcId )

LOCAL cRet


c_proc->( DBSEEK( cProcId) )
cRet :=  cProcID+c_proc->proc_nmh

RETURN cRet



FUNCTION LessThan1( o )

LOCAL nVal
LOCAL lRetVal := FALSE

IF ValType(o) == "O"
   nVal := o:varGet()
ELSE
   nVal := o
ENDIF
IF nVal == 0
   IIF(!IfEnglish() ,Alert( "òÖëÄ âåâåô ÖÄ 0 äòí" , {"Enter"}) ,Alert( "Zero or negative quantity not allowed" , {"Enter"}) )
   lRetVal := TRUE
ENDIF
RETURN lRetVal

/******************************************************************/
FUNCTION GetMyDriver()
RETURN IF(cMyDriver=NIL,"DBFCDXAX",cMyDriver)

/****************************************************/
FUNCTION NetCardNo
RETURN oUserInfo:cWIPCardNo

/************************************************************************
* Generic functions to call printer Escape sequences based on which
* printer the user has selected. Also handle SET CAPTURE / ENDCAP
* based on whether the selected printer is a LAn printer or standalone*
*/

FUNCTION GetPrnArray
RETURN oUserInfo:aPrinters
*---------------------------------------------------------------------*
FUNCTION SetNewPrinter( nPrn )

oUserInfo:nActivePrinter := nPrn
IF !SetCap()
   CloseCap()
ENDIF

RETURN NIL
*---------------------------------------------------------------------*
/*FUNCTION SetCap()

LOCAL lRet := .F.
  IF oUserInfo:aPrinters[oUserInfo:nActivePrinter][PRN_LANPRINTER]
     lRet := .T.
     fn_PrintQ(1,oUserInfo:aPrinters[oUserInfo:nActivePrinter][PRN_QUEUE],"AVX_SERVER")
     CAPTURE NFF NT NB QUEUE (oUserInfo:aPrinters[oUserInfo:nActivePrinter][PRN_NAME] )
  ENDIF
RETURN lRet*/

FUNCTION SetCap()

LOCAL lRet := .F.
LOCAL cParam
  IF oUserInfo:aPrinters[oUserInfo:nActivePrinter][PRN_LANPRINTER]
     lRet := .T.
	  cParam := ALLTRIM(oUserInfo:aPrinters[oUserInfo:nActivePrinter][PRN_LANSERVER])+"\"+ALLTRIM(oUserInfo:aPrinters[oUserInfo:nActivePrinter][PRN_QUEUE])
     MYRUN("Net use lpt1 /d /y")
	  MYRUN("Net use lpt1 \\"+cParam+" /y")
  ENDIF
RETURN lRet

*---------------------------------------------------------------------*
FUNCTION CloseCap()

  IF !oUserInfo:aPrinters[oUserInfo:nActivePrinter][PRN_LANPRINTER]
     ENDCAP
  END

RETURN .T.
*---------------------------------------------------------------------*
FUNCTION PrnSetup()
RETURN oUserInfo:aPrinters[oUserInfo:nActivePrinter][PRN_SETUP]

*---------------------------------------------------------------------*
FUNCTION PrnReset()
RETURN oUserInfo:aPrinters[oUserInfo:nActivePrinter][PRN_RESET]

*---------------------------------------------------------------------*
FUNCTION Portrait()
RETURN oUserInfo:aPrinters[oUserInfo:nActivePrinter][PRN_PORT]

*---------------------------------------------------------------------*
FUNCTION Landscape()
RETURN oUserInfo:aPrinters[oUserInfo:nActivePrinter][PRN_LAND]

*---------------------------------------------------------------------*
FUNCTION UlOn()
RETURN oUserInfo:aPrinters[oUserInfo:nActivePrinter][PRN_ULON]

*---------------------------------------------------------------------*
FUNCTION UlOff()
RETURN oUserInfo:aPrinters[oUserInfo:nActivePrinter][PRN_ULOFF]

*---------------------------------------------------------------------*
FUNCTION ItOn()
RETURN oUserInfo:aPrinters[oUserInfo:nActivePrinter][PRN_ITON]

*---------------------------------------------------------------------*
FUNCTION ItOff()
RETURN oUserInfo:aPrinters[oUserInfo:nActivePrinter][PRN_ITOFF]

*---------------------------------------------------------------------*
FUNCTION BOn()
RETURN oUserInfo:aPrinters[oUserInfo:nActivePrinter][PRN_BDON]

*---------------------------------------------------------------------*
FUNCTION BOff()
RETURN oUserInfo:aPrinters[oUserInfo:nActivePrinter][PRN_BDOFF]

*---------------------------------------------------------------------*
FUNCTION Compress()
RETURN oUserInfo:aPrinters[oUserInfo:nActivePrinter][PRN_COMPR]

*---------------------------------------------------------------------*
FUNCTION LPI6()
RETURN oUserInfo:aPrinters[oUserInfo:nActivePrinter][PRN_6LPI]

*---------------------------------------------------------------------*
FUNCTION LPI8()
RETURN oUserInfo:aPrinters[oUserInfo:nActivePrinter][PRN_8LPI]

*---------------------------------------------------------------------*
FUNCTION CPI10()
RETURN oUserInfo:aPrinters[oUserInfo:nActivePrinter][PRN_10CPI]

*---------------------------------------------------------------------*
FUNCTION CPI12()
RETURN oUserInfo:aPrinters[oUserInfo:nActivePrinter][PRN_12CPI]
* ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ Include the following routines in your source ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ

procedure InitBar
*---------------*

* Author:  Todd C. MacDonald (Compuserve ID: 73767,2242)
* Syntax:  InitBar( <expN1>, <expN2>, <expN3> [, <expC1> [, <expC2> ] ] )
* Where:   <expN1> is the screen row to display the scale at
*          <expN2> is the screen column to display the scale at
*          <expN3> is the width in characters of the scale
*          <expC1> is the color used for the scale (default: "W/N")
*          <expC2> is the color used for the bar   (default: "W/N")
* Purpose: Initializes variables used by the AdvanceBar procedure and Displays a
*          "scale" of length <expN3> at row <expN1>, column <expN2> in the color
*          specified by <expC1>.  Subsequent calls to AdvanceBar will cause the
*          "bar" (displayed in the color specified by <expC2>) to advance
*          reflecting the current percentage complete.
*
parameters lRow, lCol, lWidth, lScaleColr, lBarColor

local lOrigColor
pBarRow    = lRow
pBarCol    = lCol
pBarWidth  = lWidth
pScaleColr = if(pcount() > 3, lScaleColr, "W/N")
pBarColor  = if(pcount() > 4, lBarColor, "G/N")
pBarStep   = 100 / pBarWidth / 100
lOrigColor = setcolor(pScaleColr)
@ pBarRow, pBarCol say replicate('∞', pBarWidth)
setcolor(lOrigColor)
return


Function AdvanceBar
*------------------*

* Author:  Todd C. MacDonald (Compuserve ID: 73767,2242)
* Syntax:  AdvanceBar( <expN> )
* Where:   <expN> is a number less than or equal to 1
* Purpose: Paints the bar on the scale reflecting the current percentage passed
*          in as a parameter.
*
parameters lPercent
local lOrigColor
lOrigColor = setcolor(pBarColor)
if lPercent < 1
  @ pBarRow, pBarCol say replicate('€', integer(lPercent/pBarStep))
else
  @ pBarRow, pBarCol say replicate('€', pBarWidth)
endif
setcolor(lOrigColor)
return TRUE


function Integer
*--------------*

* Author:  Todd C. MacDonald (Compuserve ID: 73767,2242)
* Syntax:  Integer( <expN> )
* Where:   <expN> is a real value to convert to an integer
* Returns: The integer portion of <expN>.  This function is a workaround for
*          Summer 1987 versions' unreliable int() function.
* Note:    For more specifics on this anomoly, obtain the file IntBug.zip.
*
parameters lNum
return val(left(str(lNum, 21, 10), 10))


* ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ End of %BAR.PRG ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ

STATIC FUNCTION GoTopDB( bWhileCond )
WHILE EVAL( bWhileCond ) .AND. !BOF()
	dbskip(-1)
   IF !EVAL( bWhileCond )
		dbskip(1)
      EXIT

   ENDIF

END
RETURN (NIL)

STATIC FUNCTION GoBottomDB( bWhileCond )
WHILE EVAL( bWhileCond ) .AND. !EOF()
	dbskip(1)

END
dbskip(-1)
RETURN (NIL)

STATIC FUNCTION SkipDB( nSkipRequest, bWhileCOnd )
LOCAL nActSkip := 0

IF nSkipRequest == 0
	dbskip(0)

ELSEIF nSkipRequest > 0 .AND. !EOF()
   WHILE nActSkip < nSkipRequest
		dbskip(1)

      IF !EVAL( bWhileCond ) .OR. EOF()
		dbskip(-1)
      EXIT

      END
      nActSkip++

   END

ELSEIF nSkipRequest < 0
   WHILE nActSkip > nSkipRequest
		dbskip(-1)
      IF BOF()
         EXIT

      ENDIF

      IF !EVAL( bWhileCond )
			dbskip(1)
         EXIT

      ENDIF
      nActSkip--

   END

ENDIF
RETURN (nActSkip)

/*****
 *
 * Cursor Movement Methods
 *
 */

FUNCTION TBMoveCursor( nKey, oObj )
LOCAL nFound
STATIC aCursorMethods := ;
    { K_DOWN      , {|b| b:down()},;
      K_UP        , {|b| b:up()},;
      K_PGDN      , {|b| b:pageDown()},;
      K_PGUP      , {|b| b:pageUp()},;
      K_CTRL_PGUP , {|b| b:goTop()},;
      K_CTRL_PGDN , {|b| b:goBottom()},;
      K_RIGHT     , {|b| b:right()},;
      K_LEFT      , {|b| b:left()},;
      K_HOME      , {|b| b:home()},;
      K_END       , {|b| b:end()},;
      K_CTRL_LEFT , {|b| b:panLeft()},;
      K_CTRL_RIGHT, {|b| b:panRight()},;
      K_CTRL_HOME , {|b| b:panHome()},;
      K_CTRL_END  , {|b| b:panEnd()} }

// Search into array
nFound := ASCAN( aCursorMethods, nKey )
IF nFound != 0
   EVAL( aCursorMethods[++nFound], oObj )

ENDIF
RETURN (nFound != 0)

/*****
 *
 * Forces Stabilization
 *
 */

STATIC FUNCTION ForceStable( obj )

DISPBEGIN()
WHILE !obj:stabilize()
END
DISPEND()
RETURN (NIL)
/////////////////////////////////

Static Function InsertAWB( o )

LOCAL nRow := Row()
LOCAL nPos := Col()
LOCAL GetList := {}
LOCAL xVal
LOCAL oGet
local lRet := FALSE

IF o:colPos == 2
   xVal :=  d_dlvntH->awb_no

   @ nRow , nPos GET xVal COLOR "gr+/r"

   XREAD

   IF LastKey() <> K_ESC .AND. d_dlvntH->( RecLock(5, "edi_inv") )
      d_dlvntH->awb_no := xVal
      d_dlvntH->( DBUNLOCK() )
		lRet := TRUE
   ENDIF
ENDIF

RETURN lRet

FUNCTION MakeList

LOCAL aMenuTree := GetMenuTree()
LOCAL i
LOCAL nLen := Len( aMenuTree )

FOR i := 1 TO nLen
   Aadd( aMenuList , SubMenu():new( aMenuTree[i,1,CAPTION] , aMenuTree[i,1,ROW] , aMenuTree[i,1,COL], aMenuTree[i], aColors ) )
NEXT

RETURN NIL

FUNCTION PushMenu( cItem )
Aadd( aMenuStack , cItem )
RETURN NIL

FUNCTION SelectMenu( cCaption )

LOCAL nPos
LOCAL i
LOCAL nLen := Len(aMenuList)

FOR i:=1 TO nLen
    IF aMenuList[i]:cMenuCaption == cCaption
       nPos := i
       EXIT
    END
NEXT

RETURN aMenuList[nPos]

FUNCTION PopMenu

Asize( aMenuStack , Len( aMenuStack ) - 1 )

RETURN NIL

FUNCTION IsSecurity()
RETURN .F.

PROC MenuStructure()


LOCAL aMain       ,;
      aHebMain    ,;
		aHebProdRep ,;
		aHebSends   ,;
		aHebQueries ,;
		aHebLabels  ,;
		aEngLabels  ,;
		aEngQueries ,;
		aEngSends   ,;
		aEngProdRep ,;
		aEngMain


   aHebMain   := {  { "òÖñâÑ öîñòé çâêÖöê ìÖëâÄ äòíé" ,9 , 15}          ,;
                    { "~1;                 òÖñâ âáÖÖâÉ", "òÖñâ âáÖÖâÉ"} ,;
						  { "~2;    öÖêáö âåÑêéå òÜí öÖöåâÄô", "öÖöåâÄô"}     ,;
						  { "~3;          òÖñââ/ÑÜâòÄ öÖóÅÉé", "öÖóÅÉé"}      ,;
                    { "~0;                  çÉÖó àâòîö" ,{|| PrevMenu()       }} }

   aHebProdRep:= {  { "òÖñâ âáÖÖâÉ" ,12 , 18}     ,;
                    { "~1;     òÖñâÅ Ååôå ÑêéÑ öíÇÑ  åí áÖÖâÉ" , {|| BNarrive()         }} ,;
						  { "~2;      ÅåôÅ ÑêéÑ òÖñâ öåâáö åí áÖÖâÉ" , {|| BNenter()          }} ,;
                    { "~3;      ÅåôÅ ÑêéÑ ÉÖÅâí çÖâë åí áÖÖâÉ" , {|| BNleave()          }} ,;
                    { "~4;               Ñêé çÖâë áÖÖâÉ åÖàâÅ" , {|| Cancelfinishbatch()}} ,;
				   	  { "~5;          Ñêé çÖâë á'ÖÉ öòÜÖá ÑëîÉÑ" , {|| ReprnBN()          }} ,;
                    { "~6; ÑòÜáÅÖ Ñâã'ñå òÖñâ öÖêé åô çâáÖåôé" , "çâáÖåôé"               } ,;
                    { "~7;            Ñêé  çÖóâé âÖêâô  áÖÖâÉ" , {|| BatchLoc()          }} ,;
						  { "~0;                         çÉÖó àâòîö" , {|| PrevMenu()         }} }

	aHebSends  := {  { "çâáÖåôé" ,14 , 20}     ,;
                    { "~1; 'ÑòÜáÖ âêÖñâá íÖñâÅ'-å ÑêéÑ öíÇÑ áÖÖâÉ" , {|| CzhehSends()    }} ,;
						  { "~2;                       áÖåôé öÉÖíö öóîÑ" , {|| CzhehDeliv()    }} ,;
						  { "~3;                         çâáÖåôé ööåâÄô" , {|| ShpQuery(.F.)   }} ,;
						  { "~0;                             çÉÖó àâòîö" , {|| PrevMenu()      }} }

	aHebQueries:= {  { "öÖöåâÄô" ,12 , 18}     ,;
                    { "~1; äâåÑöÅ âÄåé" , {|| StockInProc()           }} ,;
						  { "~2;  ÑêáöÅ âÄåé" , {|| StockInWorkStation()    }} ,;
						  { "~3;   Ñêé åÖåëé" , {|| BNpath()                }} ,;
						  { "~0;  çÉÖó àâòîö" , {|| PrevMenu()      }} }

	aHebLabels := {  { "öÖóÅÉé" ,12 , 18}     ,;
                    { "~1; ÑÜâòÄ öÖóÅÉé" , {|| StevePrintSomeLabels()         }} ,;
						  { "~2; òÖñââ öÖóÅÉé" , {|| SteveProdLabels(LABELAPP)      }} ,;
						  { "~0;  çÉÖó àâòîö" , {|| PrevMenu()      }} }


	aEngMain   := {  { "Production Floor Data Collection System"  ,9 , 15},;
                    { "~1 On-Line Updating of Production  Batch Movements;" , "On-Line Updating of Production  Batch Movements"},;
                    { "~2 Control Queries                                ;" , "Queries"                                        },;
						  { "~3 Production/Packing labels                      ;" , "Labels"                                         },;
                    { "~0 Previous menu                                  ;" , {|| PrevMenu()}                                  } }

   aEngProdRep:= {  { "On-Line Updating of Production  Batch Movements" ,12 , 18}     ,;
                    { "~1 Batch Arrival to Production Stage Notification;" , {|| BNarrive()         }} ,;
						  { "~2 Start a Production Stage Notification         ;" , {|| BNenter()          }} ,;
                    { "~3 Production Stage Completion Notification      ;" , {|| BNleave()          }} ,;
                    { "~4 Cancel Batch Completion Notification          ;" , {|| Cancelfinishbatch()}} ,;
				   	  { "~5 Reprint Batch Completion Notification         ;" , {|| ReprnBN()          }} ,;
                    { "~6 Shipments of Production Batches               ;" , "Shipments of Production Batches"} ,;
						  { "~7 Batch internal location                       ;" , {|| BatchLoc()          }} ,;
						  { "~0 Previous menu                                 ;" , {|| PrevMenu()         }} }

   aEngSends  := {  { "Shipments of Production Batches" ,14 , 20}     ,;
                    { "~1 Batch Arr. Notification for Outside Production;" , {|| CzhehSends()       }} ,;
						  { "~2 Printing of PROFORMA INVOICE                  ;" , {|| CzhehDeliv()       }} ,;
						  { "~3 Shipments Query                               ;" , {|| ShpQuery(.T.)      }} ,;
						  { "~0 Previous menu                                 ;" , {|| PrevMenu()         }} }

	aEngQueries:= {  { "Queries" ,12 , 18}     ,;
                    { "~1 Process WIP        ;" , {|| StockInProc()           }} ,;
						  { "~2 Workstation WIP    ;" , {|| StockInWorkStation()    }} ,;
						  { "~3 Batch line movement;" , {|| BNpath()                }} ,;
						  { "~0 Previous menu      ;" , {|| PrevMenu()              }} }

	aEngLabels := {  { "Labels" ,12 , 18}     ,;
                    { "~1 Packing labels        ;" , {|| StevePrintSomeLabels()                                              }} ,;
						  { "~2 Packing labels  ZEBRA ;" , {|| IIF("CZ" $ GetUserInfo():cGroupID ,StevePrintSomeLabels(.T.) ,NIL ) }} ,;
						  { "~3 Production labels     ;" , {|| SteveProdLabels(LABELAPP)                                           }} ,;
						  { "~0 Previous menu      ;" , {|| PrevMenu()              }} }

   aMain       := { { "A V X  P D C", 7 , 10 },;
                    { "~1 öâòÅí                    ;" , "òÖñâÑ öîñòé çâêÖöê ìÖëâÄ äòíé"    },;
                    { "~2 English                  ;" , "Production Floor Data Collection System"  },;
						  { "~3 Prod.Areas Reporting     ;" , {|| ProdArea()        }} ,;
                    { "~0 Exit                     ;      çÖâë" , { || __Quit()}}}

aTree := { aMain , aHebMain ,aHebProdRep,aHebSends,aHebQueries,aHebLabels,aEngMain,aEngProdRep,aEngSends,aEngQueries,aEngLabels }

RETURN

PROC NA()
LOCAL aOldTitle := SetTitle( "This prog is not..." , ProcName())
Alert("Not Available")

OldTitle( aOldTitle )
RETURN

FUNCTION GetMenuTree
RETURN aTree

PROCEDURE PrevMenu
KEYBOARD Chr(27)
RETURN

PROCEDURE MMM()
Alert( "Not Active!" , {"Enter"} )
RETURN

FUNCTION LogInUser
RETURN oUserInfo:cUserId

FUNCTION GetDefPrn
RETURN oUserInfo:aPrinters[oUserInfo:nActivePrinter][2]

FUNCTION  GetTempFileDir
RETURN oUserInfo:cTempDir

Static Procedure Prepare_I

LOCAL cTempDir := GetUserInfo():cTempDir

d_line->(dbseek("997.3"))
XSoftCopy( ,cTempdir+"t_CZHLN.dbf","d_line->cpproc_id == '997.3'","!d_line->b_stat $ '_C_D_' .AND. d_line->cpproc_id == '997.3' .AND. Empty(d_line->cp_darr)")

d_line->(dbseek("997.4"))
XSoftCopy( ,cTempdir+"t_CZL_AD.dbf","d_line->cpproc_id == '997.4'","!d_line->b_stat $ '_C_D_' .AND. d_line->cpproc_id == '997.4' .AND. Empty(d_line->cp_darr)")

Return

Static Procedure Prepare_II

LOCAL cTempDir := GetUserInfo():cTempDir


d_line->(dbseek("997.0"))
XSoftCopy( ,cTempdir+"t_CZHLN.dbf","d_line->cpproc_id == '997.0'","!d_line->b_stat $ '_C_D_' .AND. d_line->cpproc_id == '997.0' .AND. Empty(d_line->cp_darr)")

d_line->(dbseek("997.2"))
XSoftCopy( ,cTempdir+"t_CZL_AD.dbf","d_line->cpproc_id == '997.2'","!d_line->b_stat $ '_C_D_' .AND. d_line->cpproc_id == '997.2' .AND. Empty(d_line->cp_darr)")

Return

Static Procedure Open_N_App

LOCAL cTempDir := GetUserInfo():cTempDir

NetUse( "t_CZHLN", STD_RETRY, RDD_IN_USE, USE_EXCLUSIVE, USE_NEW, cTempdir,"d_lntmp" )
append from (cTempDir+"t_CZL_AD.dbf")

Return

Static Function GetDestination()

Local cRetVal

if AllTrim(d_dlvntH->doc_type) $ "W2CZ_W2IL"
   cRetVal := "Mid Section"
elseif AllTrim(d_dlvntH->doc_type) $ "P2CZ_P2IL"
   cRetVal := "Back End"
elseif AllTrim(d_dlvntH->doc_type) $ "_S2IL_"
   cRetVal := "Samples"
endif

Return cRetVal

Static Function GetCounter(cProc)

local nRetVal
local cDbf

IF cProc $ "997.0_997.2"
	cDbf := "n_ildlv"
ELSEIF cProc $ "997.3_997.4"
	cDbf := "n_czdlv"
ENDIF

NetUse(cDbf,5)

IF (cDbf)->( RecLock(5, "CZH") )
   (cDbf)->counter++
   (cDbf)->(dbcommit())
   nRetVal := (cDbf)->counter
	(cDbf)->(dbclosearea())
ENDIF

Return nRetVal

static Procedure BatchLoc()
LOCAL t         := 8
LOCAL l         := 20
LOCAL b         := 35
LOCAL r         := 75
LOCAL mConfirm  := .Y.
local cDest := "  "
local cRemark := " ",cFrRmk := Space(30)
LOCAL mB_ID      := Space( 6 )
LOCAL mCP_WIDSTA := "     "

Local aoOpenFiles := GenOpenFiles({"d_line","d_wid"})
scrnPush()

DispBox( t, l, b,  r ,FRAMECAPTION+" ")

SETCURSOR(3)

@ 10,55 say "Ñêé ëé"
@ 10,45 GET mB_ID       PICTURE "@K 999999" SEND postBlock := { |o| BidExists(o) }
@ 11,55 say "áÖÖÉé ÉÅÖí"
@ 11,46 GET mCP_WIDSTA  PICTURE "@K 99999"  SEND postBlock := { |o| postwid(o) }

//@13,23 CLEAR TO 20, 65

DrawBox( 13,23,23,72,FRAMECAPTION+" ")


@ 14, 25 say "Éíâ çóÖâé" GET cDest RADIO {"òÖñâ",;
                          "çâëâê öâêÖò",;
                          "èÑã ëâòâÄ",;
                          "ïâÅÖòâÄé åÄâòÄ",;
                          "åòâéÉ àê'Ü",;
                          "åÄêëÅ",;
                          "èéÉââÜ ÑÉÖÑâ",;
                          "öÖãÜ âêô"}


DrawBox( 23,23,28,72,FRAMECAPTION+" ")


@ 24, 30 say "ÑÅâë" GET cRemark RADIO {"öÖâáêÑ òÉíÑ åôÅ Ñêâöéé",;
                          "öÖêâóö âÄ åôÅ Ñêâöéé",;
                          "Ååô çÖâëÅ ëÉêÑé öóâÉÅ åôÅ Ñêâöéé",;
                          "öÖëÖòî âîö Ååô åôÅ Ñêâöéé"}

@ 30,30 say "âôîÖá ååé" GET cFrRmk COLOR "W+/R"

@ 32,30 say "òôÄ" GET mConfirm PICTURE "Y"

READ

IF ASCAN( aGoodKeys, LASTKEY() ) > 0
	IF mConfirm
		Netuse("m_loc",5)
		IF m_loc->( AddRec(5) )
			m_loc->b_id := mB_ID
			m_loc->loc := cDest
			m_loc->cremark := cremark
               m_loc->C_FRMRK := cFrRmk
			m_loc->cp_wid := mCP_WIDSTA
			m_loc->(dbunlock())
		ENDIF
		m_loc->(dbclosearea())
	ENDIF
endif

SETCURSOR(0)
scrnPop()
GenCloseFiles(aoOpenFiles)
Return

Static FUNCTION Postwid(o)

LOCAL lRetVal
LOCAL cKey := Padl( Alltrim( o:varGet() ) , 5 )

IF LastKey() = K_UP
   RETURN .T.
ENDIF

IF d_wid->( DbSeek( cKey ) )
   o:varPut( cKey )
   @ 11 ,25 SAY rtrim(d_wid->work_nmh) COLOR if( IsColor() , "W+/B" , "W+/N" )
   lRetVal := .T.
ELSE
   Alert( cKey + " ÑÜ òîëé çí ÉÅÖí Äñéê Äå" , {"..."} )
   lRetVal := .F.
ENDIF

RETURN lRetVal



Static Function ProdArea()

LOCAL cProc := Space(5)
LOCAL mCP_WIDSTA := "     "
LOCAL t         := 8
LOCAL l         := 20
LOCAL b         := 15
LOCAL r         := 65
Local aoOpenFiles := GenOpenFiles({"c_warea","d_warea","d_wid","c_proc"})
c_warea->(ordsetfocus(2))
d_warea->(ordsetfocus(2))
scrnPush()

DispBox( t, l, b,  r ,FRAMECAPTION+" ", "w+/b" )
@ t, l+2 SAY " Choose an Process & Worker ID" COLOR "w+/g"
AddShadow( t, l, b, r  )
@ b, l+4 SAY  " F2 - Listing " COLOR "bg+/bg"

 SETCURSOR(1)
 @ t+2, l+ 4 SAY "Process:"
 @ t+2, l+11 GET cProc PICTURE "@K 999.9"   ;
     SEND preBlock  := {|o| SetProc( o )} SEND postBlock  := {|o| ProcExists(o) .AND. PostProc( o )    }

 @ t+4, l+ 4 SAY "Worker ID:"
 @ t+4, l+11 GET mCP_WIDSTA PICTURE "@K 99999"   ;
     SEND postBlock  := { |o| WidExists(o,.T.) }


READ

SETCURSOR(0)
scrnPop()

IF LASTKEY() <> K_ESC
	IF d_warea->(dbseek(mCP_WIDSTA+c_warea->warea_id))
		IF Alert("Report stage",{"Start","Finish"}) == 2 .AND. d_warea->( RecLock( 5 ) )
			d_warea->FINISH_D := Date()
			d_warea->FINISH_T := Left( Time() , 5 )
			d_warea->(dbunlock())
		ELSEIF d_warea->( RecLock( 5 ) )
			d_warea->FINISH_D := Date()
			d_warea->FINISH_T := Left( Time() , 5 )
			d_warea->(dbunlock())
			IF d_warea->( AddRec(5) )
			   d_warea->warea_id := c_warea->warea_id
			   d_warea->desc     := c_warea->desc
			   d_warea->w_id     := mCP_WIDSTA
			   d_warea->START_D  := Date()
			   d_warea->START_T  := Left( Time() , 5 )
			   d_warea->(dbunlock())
			ENDIF
		ENDIF
	ELSEIF d_warea->(dbseek(mCP_WIDSTA)) .AND. d_warea->( RecLock( 5 ) )
			 d_warea->FINISH_D := Date()
			 d_warea->FINISH_T := Left( Time() , 5 )
			 d_warea->(dbunlock())
			 IF d_warea->( AddRec(5) )
				 d_warea->warea_id := c_warea->warea_id
				 d_warea->desc     := c_warea->desc
				 d_warea->w_id     := mCP_WIDSTA
				 d_warea->START_D  := Date()
				 d_warea->START_T  := Left( Time() , 5 )
   			 d_warea->(dbunlock())
			 ENDIF
	ELSEIF d_warea->( AddRec(5) )

			 d_warea->warea_id := c_warea->warea_id
			 d_warea->desc     := c_warea->desc
			 d_warea->w_id     := mCP_WIDSTA
			 d_warea->START_D  := Date()
			 d_warea->START_T  := Left( Time() , 5 )

			 d_warea->(dbunlock())
	ENDIF
ENDIF


GenCloseFiles(aoOpenFiles)

SETKEY( K_F2, NIL )


Return TRUE

STATIC FUNCTION SetProc( oGet )

   SetF2Key( oGet , "c_proc")

RETURN TRUE


STATIC FUNCTION PostProc( o )
SetKey( K_F2 , NIL )
RETURN c_warea->(dbseek(o:varGet()))
