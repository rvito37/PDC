FUNCTION MisCall(lNew)
*
*  AvxMis  „™’ ˜ƒ„™ ‰”‹ Task š‡‰š”
#include "INKEY.CH"
#define FRAMECAPTION  "ÛÛÛÛÛÜÛÛ"
*
LOCAL cCaption,cSvScrn
LOCAL getlist:={}
LOCAL cMisexe  := IF( lNew, SPACE( 3), d_task->mis_exec)
*
* ™ƒ…‡„ Œ™ š…˜”‘ 2 + „™ Œ™ š……˜‡€ š…˜”‘ 2 :Ž—Œƒ‹ (Ta_id) Task Œ •˜.‘Ž …™‰‡
*                                                                      •˜.‘Ž +
*
LOCAL cID      := IF( lNew, NewId(  ), d_task->ta_id   )
LOCAL cNme1    := IF( lNew, SPACE(40), d_task->ta_nme1 )
LOCAL cNme2    := IF( lNew, SPACE(40), d_task->ta_nme2 )
LOCAL cNme3    := IF( lNew, SPACE(40), d_task->ta_nme3 )
LOCAL cMiscom1 := IF( lNew, SPACE(40), d_task->ta_miscom1 )
LOCAL cMiscom2 := IF( lNew, SPACE(40), d_task->ta_miscom2 )
LOCAL cMiscom3 := IF( lNew, SPACE(40), d_task->ta_miscom3 )
LOCAL cNotify  := IF( lNew, SPACE(20), d_task->notify  )
LOCAL cRemark1 := IF( lNew, SPACE(40), d_task->remarks1)
LOCAL cRemark2 := IF( lNew, SPACE(40), d_task->remarks2)
LOCAL cOldClr  := SETCOLOR("bg+/b")
LOCAL t        := 3
LOCAL l        := 2
LOCAL b        := 11
LOCAL r        := 53
 
SETCURSOR(1)
*
*  š…˜š…‹… š˜‚‘Ž ’ —‰˜ Š‘Ž
*
cSvScrn:=SAVESCREEN(t, l, b,  r)
DispBox( t, l, b,  r ,FRAMECAPTION+" ", "w+/b" )
cCaption := ":„™ƒ‡ „ŒˆŽ"
@ t , l+40 SAY cCaption COLOR "w+/g"
@ t+1, l+47  SAY ":‘Ž"
@ t+1, l+38 SAY cId COLOR "gr+/b"
*
* ˆŒ— š…˜š…‹
*
@ t+2, l+44 SAY ": ˜…€š"
@ t+3, l+44 SAY "..Š™„"
@ t+4, l+44 SAY "..Š™Ž„"
SETCOLOR( cOldClr )
*
* ‰š™Ž ˆŒ—
*
@ t+2, l+2  GET cNme1 SEND reader := {|o| HebReader(o)}   // "Task:"->Ta_nme1
@ t+3, l+2  GET cNme2 SEND reader := {|o| HebReader(o)}    // "Desc:"-> Ta_nme2
@ t+4, l+2  GET cNme3 SEND reader := {|o| HebReader(o)}    // "     "->Ta_nme3
READ
SETCURSOR(0)
IF LASTKEY() <> K_ESC
   IF Ishur1('? „™ƒ‡ „ŒˆŽ “‰‘…„Œ',{||DEVPOS(0,9),DevOut(TIME(),"W+/R")};
                        ,"W+/R,B/BG",'X'+CHR(16))
      *
      * Task „ ˜”‘Ž š‰‰
      *
      cID:=NewId()
      *
      * D_task Œ „—‰˜ „Ž…™˜ š”‘…„
      *
      D_task->( AddRec(5) )
      *
      * .…‰„ š’™… Š‰˜€š ‰‹˜’ „’™… Š‰˜€š š…ƒ™ ‰…Œ‰Ž
      *  .username Š˜’ Œ—‰ ULU_REC „ƒ™
      *
      GetUserInfo():updateUserInRec( "d_task" , "TBMISA", .T. )
      *
      * „™ƒ‡„ „Ž…™˜Œ Œƒ‡Ž š…˜‰˜ ‰‹˜’ š–„
      *
      D_task->ta_cat    := "SUP"
      D_task->ta_sys    := "EQR"
      D_task->ta_loc    := "PRODUCTION"
      D_task->ta_prior  := "H"
      D_task->ta_type   := "TS"
      D_task->ini_dpt   := "PQC"
      D_task->mis_exec  := "GRP"
      D_task->d_ini     := DATE()
      *
      * „™ƒ‡„ „Ž…™˜Œ blank ‰‹˜’ š–„
      *
      D_task->Ta_miscom1:= REPLICATE(" ",LEN(D_task->ta_miscom1))
      D_task->Ta_miscom2:= REPLICATE(" ",LEN(D_task->ta_miscom2))
      D_task->Ta_miscom3:= REPLICATE(" ",LEN(D_task->ta_miscom3))
      D_task->Ta_ref    := REPLICATE(" ",LEN(D_task->ta_ref))
      D_task->Ta_mod    := REPLICATE(" ",LEN(D_task->ta_mod))
      D_task->Ta_stat   := REPLICATE(" ",LEN(D_task->ta_stat))
      D_task->Mis_sub   := REPLICATE(" ",LEN(D_task->Mis_sub))
      D_task->D_due     := CTOD("  -  -  ")
      D_task->D_sta     := CTOD("  -  -  ")
      D_task->T_sta     := REPLICATE(" ",LEN(D_task->T_sta))
      D_task->D_fin     := CTOD("  -  -  ")
      D_task->T_fin     := REPLICATE(" ",LEN(D_task->T_fin))
      D_task->Dsgn_hr   := 0
      D_task->Prg_hr    := 0
      D_task->Tst_hr    := 0
      D_task->Eu_hr     := 0
      D_task->Ot_hr     := 0
      D_task->Sub_hr    := 0
      D_task->Pln_hr    := 0
      D_task->Notify    := REPLICATE(" ",LEN(D_task->Notify))
      D_task->Revise    := REPLICATE(" ",LEN(D_task->Revise))
      D_task->Prgs      := REPLICATE(" ",LEN(D_task->Prgs))
      D_task->Remarks1  := REPLICATE(" ",LEN(D_task->Remarks1))
      D_task->Remarks2  := REPLICATE(" ",LEN(D_task->Remarks2))
      D_task->d_revdue  := CTOD("  -  -  ")
      *
      * „™ƒ‡„ „Ž…™˜Œ ™Žš™Ž„ ‰"’ …ƒŒ—…„™ ‰‹˜’ š–„
      *
 
      D_task->ta_nme1   := cNme1
      D_task->ta_nme2   := cNme2
      D_task->ta_nme3   := cNme3
      *
      * „™ƒ‡„ „Ž…™˜Œ š‹˜’Ž„ ‰"’ ‰™…‡Ž ‰‹˜’ š–„
      *
      D_task->Ini_usr   := NNetWhoAmI()
      D_task->Ta_id     := cID
 
      D_task->( DBUNLOCK() )
      *
      *  „™ƒ‡„ „Ž…™˜„ šˆ‰Œ— š…ƒ…€ „’ƒ…„ š‚–„
      *
      DISPBOX(5,9,10,10+LEN(' 246;377 :š…˜™ ƒ—…ŽŒ „”')+1,2,"GR+/BG")
      SETPOS(6,10)
      DISPOUT('         ! „Œ—š„ Šš‰‰” ',"B/BG")
      SETPOS(7,10)
      DISPOUT('         ‰”‘… ‰˜…˜‰Œ ',"B/BG")
      SETPOS(8,10)
      DISPOUT(' 246;377 :š…˜™ ƒ—…ŽŒ „” ',"B/BG")
      SETPOS(9,10)
      SETBLINK(.T.)
      DISPOUT('                  ! „ƒ…š ',"B*/BG")
      INKEY(4)
   ENDIF
   // A send message is issued to users so, they will know a new task has
   // been opened for them: Only for Israel Neer, and Dave Darpak so far.
   IF cMisExe $ "DAV_INE"
     MYRUN("pop_up.bat "+;
        IF(cMisExe="DAV","DDREPAK",;
        IF(cMisExe="INE","INEER",NIL )))
   ENDIF
 
 
ENDIF
 
D_task->(DBCLOSEAREA())
RESTSCREEN(t, l, b,  r,cSvScrn)
*scrnPop()
RETURN NIL
*
STATIC FUNCTION NewId()
*
* (D_task->Ta_id) Task .‘Ž …™‰‡
*
LOCAL lFound
LOCAL cYear := transform(year(date()),"9999") // 4 digits format for Y2K: "YYYY/MM/DD"
LOCAL cMonth:= substr(DTOC(DATE()),4,2)
LOCAL cDay  := substr(DTOC(DATE()),1,2)
LOCAL cNewId:= cYear+cMonth+cDay
LOCAL cNewNo , lFirst9numbers , nActualNo
LOCAL cOrder:= d_task->(ORDSETFOCUS("taskid"))
*
* ‰‡‹…Œ 1 š”‘…„… …˜‡€ •˜.‘Ž ˜…š‰€ ,‰-Task …‡š” ˜‹ ‰‡‹…„ …‰ €
*
IF (lFound := d_task->( DBSEEK(cNewId) ) )
    cNewId := substr(cNewId,3,6) // ‰‡‹… …‰ š…˜”‘ 2 + ™ƒ…‡ š…˜”‘ 2+š‰‡‹…„ „™„ Œ™ š……˜‡€ š…˜”‘ 2
    DO WHILE cNewId = left(d_task->ta_id,6)
     d_task->(DBSKIP())
    ENDDO
    D_TASK->(DBSKIP(-1))
    nActualNo      := val(right(d_task->ta_id,2))
    lFirst9Numbers := IF( nActualNo<9,.T.,.F.)
    IF lFirst9Numbers
         cNewNo:="0"+str(nActualNo+1,1,0)
    ELSE
         // This calculation does apply for NO MORE than 99 calls a day
         cNewNo:=str(nActualNo+1,2,0)
    ENDIF
    cNewId:=cNewId+cNewNo
ELSE
    *
    * š…˜”‘ 2 + „™„ Œ™ š……˜‡€ š…˜”‘ 2 :Ta_id.‘Ž š‰ ‰‡‹…„ …‰ …™€˜ Task Œ
    *              .01 •˜.‘Ž + ‰‡‹…„ …‰„ Œ™ š…˜”‘ 2 + ‰‡‹…„ ™ƒ…‡„ Œ™ š…˜”‘ 2
    *
    cNewId := substr(cNewId,3,6) // Back to old "YY/MM/DD" format
    cNewId:=cNewId+"01"
ENDIF
*
* „† Š‰˜€šŒ …‡š”™ ‰ Task „ Œ™ •˜.‘Ž„ š…˜”‘„ 2 + ‰‡‹… Š‰˜€š ‰”Œ …‰Ž
*
d_task->(ORDSETFOCUS(cOrder))
 
RETURN cNewId
