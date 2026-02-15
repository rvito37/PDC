// Function/Procedure Prototype Table  -  Last Update: 02-18-97 @ 11:59:02am
// ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
// Return Value         Function/Arguments
// ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ  ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
// MOUSE                STATIC PROCEDURE INSLETABC
// MOUSE                STATIC PROCEDURE ShowScoreboard()
// MOUSE                PROCEDURE HebReader( get )
// Void                 proc HebApplyKey(get, key)
// Void                 proc HebMApplyKey(get, key)
// Void                 FUNCTION HEBM_ACTIV(_a,_b,_c)
// Void                 FUNCTION HEBM_DACTIV(_a,_b,_c)
// MOUSE                FUNCTION HEB_ACTIV(_A,_B,_C)
// SCORE_COL 60         FUNCTION HEB_DACTIV(_a,_b,_c)
// Void                 FUNCTION HEB_TOGGLE
// Void                 FUNCTION HebMReader( get,Mlist,pos,Getlist )
// MOUSE                FUNCTION LANG_TOGGLE
// Void                 FUNCTION MHEB_TOGGLE
// MOUSE                FUNCTION SetInsBlock(lOnOff,bBlock)
// Void                 FUNCTION SetMInsBlock(lOnOff,bBlock)
// .t.                  static function eng_toggle
// .t.                  static function getmapplykey


#include "Set.ch"
#include "Inkey.ch"
#include "Getexit.ch"
#include "Error.ch"
#include "Support.ch"

#define K_UNDO          K_CTRL_U


// state variables for active READ
static Format
static Updated := .f.
static KillRead
static BumpTop
static BumpBot
static LastExit
static LastPos
static ActiveGet
static ReadProcName
static ReadProcLine
static _hb_ind_ins
static _hb_ins_key
static _hb_mispar
static _hb_mret
static _hb_lock
static _hb_hbr:=.t.
static _hb_get
STATIC lIsMouseSupport
STATIC bInsOff
STATIC bInsOn
STATIC LET_ABC

// format of array used to preserve state variables
#define GSV_KILLREAD            1
#define GSV_BUMPTOP                     2
#define GSV_BUMPBOT                     3
#define GSV_LASTEXIT            4
#define GSV_LASTPOS                     5
#define GSV_ACTIVEGET           6
#define GSV_READVAR             7
#define GSV_READPROCNAME        8
#define GSV_READPROCLINE        9

#define GSV_COUNT                       9

/***
*       HebReader()
*       Standard modal read of a single GET for hebrew.
*/
#IFDEF MOUSE
FUNCTION HebMReader( get,Mlist,pos,Getlist )
#ELSE
PROCEDURE HebReader( get )
#ENDIF
    LOCAL ncol,nCursor
    LOCAL nKey,mCol,m

    IF bInsOn=NIL
#IFDEF MOUSE
       SetMInsBlock(.T.)
#ELSE
       SetInsBlock(.T.)
#ENDIF
    ENDIF

    IF bInsOff=NIL
#IFDEF MOUSE
       SetMInsBlock(.F.)
#ELSE
       SetInsBlock(.F.)
#ENDIF
    ENDIF

#IFDEF MOUSE
    lIsMouseSupport:=.t.
#ELSE
    lIsMouseSupport:=.f.
#ENDIF

    EVAL(IF(Set(_SET_INSERT),bInsOn,bInsOff))

    IF ! readinsert(.f.)
        _HB_IND_INS:= 0
        _hb_ins_key:=.f.
    ELSE
        _HB_IND_INS := 1
        readinsert(.t.)
        _hb_ins_key:=.t.
    ENDIF
    IF ! SET(_SET_INSERT)
        _HB_IND_INS := 0
    ELSE
        _hb_ins_key:=.t.
        _HB_IND_INS := 1
        readinsert(.t.)
    ENDIF
    _HB_MRET := .T.
    _HB_HBR:=.T.
    _HB_lock:=.F.
    _HB_MISPAR:=.F.
    _hb_get:=.t.


    // read the GET if the WHEN condition is satisfied
    if ( GetPreValidate(get) )

        // activate the GET for reading
        MCUROFF()
        get:SetFocus()
        Get:pos := LEN(Get:buffer)
        Get:display()
        MCURON()

        while ( get:exitState == GE_NOEXIT )

            // check for initial typeout (no editable positions)
            if ( get:typeOut )
                get:exitState := GE_ENTER
            end

            // apply keystrokes until exit
            while ( get:exitState == GE_NOEXIT )

#IFDEF MOUSE
              nKey := InKey()
              while  ( nKey == 0 )
                if ( _isbutton(1) )     /* Mouse press */
                   m_wait(1)    /* wait for release */
                   m := MousePick(mList)  /* in __mlist.prg */
                     if( m != 0)
                       if( m == pos)
                         if get:type=="C" .and. get:picture<>NIL
                           mcol:=relat_mpos(get)
                         elseif get:type=="D"
                           mcol:=relat_dpos(get)
                         elseif get:type=="N"
                           mcol:=relat_npos(get)
                         else
                           mcol:=(m_col()-get:col)
                         endif
                         csroff()
                         m_csroff()
                         get:home()
                         for m = 1 to mcol
                           get:right()
                         next
                         csron()
                         m_csron()
                       else
                         get:exitState := GE_DOWN
                         pos := m-1
                         if( pos > 0 )
                           getList[pos]:exitState := GE_DOWN
                         endif
                         exit
                       endif
                     endif
                endif
                nKey := InKey()
              end                 // while  ( nKey == 0 )
                  if (nKey !=0)
                     if (_hb_get)
                         HebMF2ApplyKey( get, nkey)
                     else
                         getMApplyKey( get, nKey )
                     endif
                 endif
            end                  // while ( get:exitState == GE_NOEXIT )

#ELSE
                if (_hb_get)
                    HebF2ApplyKey( get, rdb_Inkey(0) )
                else
                    if get:exitstate == GE_NOEXIT
                        getApplyKey( get, rdb_Inkey(0) )
                    endif
                endif
            end
#ENDIF
            nCursor:=SETCURSOR()
            MCUROFF()
            setcursor(0)
            // disallow exit if the VALID condition is not satisfied
            nCol:=get:pos
            if ( !GetPostValidate(get) )
                get:exitState := GE_NOEXIT
                //get:pos:=nCol
                Get:pos := LEN(Get:buffer)
                setpos(get:row,get:col+get:pos-1)
                setcursor(nCursor)
            end
            MCURON()
            setcursor(nCursor)
        end
        MCUROFF()
        get:KillFocus()
        MCURON()
        DispGet(get)
    end
#IFDEF MOUSE
RETURN(pos)
#ELSE
RETURN
#ENDIF



/***
*       HebApplyKey()
*       Apply a single Inkey() keystroke to a GET.
*
*       NOTE: GET must have focus.
*/
#IFDEF MOUSE
proc HebMApplyKey(get, key)
#ELSE
proc HebApplyKey(get, key)
#ENDIF

    local cKey,cVal,nPos,nCount,nCursor
    local bKeyBlock
    local _HB_XX,_HB_LEN,_OLD_INSERT,B_POS

    IF _HB_MISPAR==NIL
        _HB_MISPAR:=GET:TYPE=="N"
    ENDIF

    // check for SET KEY first
    if ( (bKeyBlock := SetKey(key)) <> NIL )

        GetDoSetKey(bKeyBlock, get)
        return                                       // NOTE

    end


    do case
    case ( key == K_UP )
        get:exitState := GE_UP

    case ( key == K_SH_TAB )
        get:exitState := GE_UP

    case ( key == K_DOWN )
        get:exitState := GE_DOWN

    case ( key == K_TAB )
        get:exitState := GE_DOWN

    case ( key == K_ENTER )
        get:exitState := GE_ENTER

    case ( key == K_ESC )
        if ( Set(_SET_ESCAPE) )
            MCUROFF()
            get:undo()
            MCURON()
            get:exitState := GE_ESCAPE
        end

    case ( key == K_PGUP )
        get:exitState := GE_WRITE

    case ( key == K_PGDN )
        get:exitState := GE_WRITE

    case ( key == K_CTRL_HOME )
        get:exitState := GE_TOP


        #ifdef CTRL_END_SPECIAL

        // both ^W and ^End go to the last GET
    case (key == K_CTRL_END)
        get:exitState := GE_BOTTOM

        #else

        // both ^W and ^End terminate the READ (the default)
    case (key == K_CTRL_W)
        get:exitState := GE_WRITE

        #endif


    case (key == K_INS)
        Set( _SET_INSERT, !Set(_SET_INSERT) )
        EVAL(IF(Set(_SET_INSERT),bInsOn,bInsOff))
        IF _HB_IND_INS = 0
            _HB_IND_INS = 1
            _hb_ins_key = .t.
            readinsert(.t.)
        ELSE
            _HB_IND_INS = 0
            _hb_ins_key = .f.
            readinsert(.f.)
        ENDIF

    case (key == K_UNDO)
        MCUROFF()
        get:Undo()
        MCURON()
    case (key == K_HOME)
        MCUROFF()
        Get:pos := LEN(Get:buffer)
        Get:display()
        MCURON()
    case (key == K_END)
        nCursor:=SETCURSOR()
        MCUROFF()
        setcursor(0)
        nPos:=get:pos
        get:home()
        if  (! empty(get:buffer))
            if  (! empty(substr(get:buffer,1,nPos)) .or. nPos==1 )
                do while substr(get:buffer,get:pos,1)=" " .and. get:pos<len(get:buffer)
                    get:right()
                enddo
                get:left()
            endif
        endif
        setcursor(nCursor)
        MCURON()

    case (key == K_RIGHT)
        MCUROFF()
        get:Right()
        MCURON()

    case (key == K_LEFT)
        MCUROFF()
        get:Left()
        MCURON()

    case (key == K_CTRL_RIGHT)
        MCUROFF()
        get:pos := Min(get:pos + 1, Len(get:buffer))
        while (SubStr(get:buffer,get:pos,1)==" ") .and. (get:pos < Len(get:buffer))
            get:pos ++
        end
        while !(SubStr(get:buffer,get:pos,1)==" ") .and. (get:pos < Len(get:buffer))
            get:pos ++
        end
        if (get:pos < Len(get:buffer))
            get:pos --
        endif
        get:Display()
        MCURON()

    case (key == K_CTRL_LEFT)
        MCUROFF()
        while !(SubStr(get:buffer,get:pos,1)==" ") .and. (get:pos > 1)
            get:pos --
        end
        while (SubStr(get:buffer,get:pos,1)==" ") .and. (get:pos > 1)
            get:pos --
        end
        get:Display()
        MCURON()

    case (key == K_BS)
      MCUROFF()
        if get:pos#len(get:buffer)
            if get:pos<len(get:buffer)
                get:right()
            endif
            cval:=get:untransform()
            npos:=relat_pos(get)
            cval:=" "+substr(cval,1,npos-1)+substr(cval,npos+1)
           get:buffer:=cVal
           get:changed=.t.
          get:display()
      endif
      MCURON()

    case (key == K_DEL)
      MCUROFF()
        cval:=get:untransform()
        npos:=relat_pos(get)
        cval:=" "+substr(cval,1,npos-1)+substr(cval,npos+1)
        get:buffer:=cVal
      get:changed=.t.
        get:display()
        MCURON()

    case (key == K_CTRL_T)
      MCUROFF()
        nCount := 0
        while (get:pos > 1) .and. (SubStr(get:buffer, get:pos, 1) == " ")
            get:buffer := Stuff(get:buffer, get:pos, 1, "")
            get:pos --
            nCount ++
        end
        while (get:pos > 1) .and. !(SubStr(get:buffer, get:pos, 1) == " ")
            get:buffer := Stuff(get:buffer, get:pos, 1, "")
            get:pos --
            nCount ++
        end
        get:buffer := Space(nCount) + get:buffer
        get:pos := Min(get:pos + nCount, Len(get:buffer))
                get:Display()
        MCURON()
    case (key == K_CTRL_Y)
        MCUROFF()
        cval:=get:untransform()
        npos:=relat_pos(get)
        cval:=space(npos)+substr(cval,npos+1)
        get:buffer:=cVal
        get:changed=.t.
        get:display()
        MCURON()

    case (key == K_CTRL_BS)
        MCUROFF()
        get:DelWordRight()
        MCURON()
    otherwise
        IF LET_ABC=NIL
            DO INSLETABC
        ENDIF

        if (key >= 32 .and. key <= 255)

            if ((key>=96 .and. key<123) .or. (chr(key)$",./';"))
                ckey := chr(heb_chrc(key-31,let_abc))
            else
                ckey:=chr(key)
            endif

            if (get:type == "N" .and. (cKey == "." .or. cKey == ","))
                MCUROFF()
                get:ToDecPos()
                MCURON()
            else
                IF (key>47 .AND. key<58) .OR. (key>64 .AND. key<91) ;
                    .OR. (key>96 .AND. key<123 .AND. (.NOT. _HB_HBR));
                    .OR. (key>31 .AND. key<48  .AND. (.NOT. _HB_HBR) );
                    .OR.(_HB_MISPAR.AND.ckey$"-/.,;")
                    _HB_MISPAR=.T.
                    _HB_IND_INS = 1
                    _old_insert:=Set( _SET_INSERT,.t.)

                ELSE
                    IF _HB_MISPAR .AND. _HB_HBR
                        _hb_len:=get:pos
                        _HB_XX:=SUBSTR(get:buffer,_hb_len,1)
                        DO WHILE (_HB_XX>CHR(47) .AND. _HB_XX<CHR(58)) .OR.;
                            (_HB_XX>CHR(64) .AND. _HB_XX<CHR(91)) .OR.;
                            ( ((_HB_XX>CHR(96) .AND. _HB_XX<CHR(123)).OR.(_HB_XX$'-/.,;')) ;
                            .AND. (.NOT. _HB_HBR) );
                            .OR. ( _HB_XX>CHR(31) .AND. _HB_XX<CHR(48)  .AND. (.NOT. _HB_HBR) );
                            .OR. (_HB_XX$'-/.,;')
                            IF _HB_LEN>1
                                _HB_LEN--
                                get:pos--
                                _HB_XX=SUBSTR(get:buffer,_HB_LEN,1)
                            ELSE
                                EXIT
                            ENDIF
                        ENDDO
                        _HB_MISPAR=.F.
                        if _hb_ins_key
                            _HB_IND_INS = 1
                        else
                            _HB_IND_INS = 0
                        endif
                    ENDIF
                ENDIF
                if ( Set(_SET_INSERT))
                    IF ! _HB_HBR
                        ckey:= CHR(key)
                    ENDIF
                    MCUROFF()
                    cVal:=get:untransform()
                    npos:=relat_pos(get)
                    IF SUBSTR(cVal,1,1)=" " .or. !_hb_mispar .or. _hb_hbr
                        cVal:=SUBSTR(cval,2,npos-1)+ ckey + SUBSTR(cval,npos+1,len(cval)-npos)
                        get:buffer:=cVal
                        Get:changed := .T.
                    ENDIF
                    _hb_len:=get:pos
                    IF COL() > get:col
                        IF .NOT. _HB_MISPAR
                            _HB_LEN--
                            get:pos--
                            *   @ _HB_ROW,COL()-1 SAY ""
                        ENDIF
                    ENDIF
                    if (! _hb_ins_key)
                        SET(_SET_INSERT,_OLD_INSERT)
                    endif
                    get:display()
                    MCURON()
                else
                    b_pos=get:pos
                    MCUROFF()
                    get:overstrike(cKey)
                    Get:changed := .T.
                    if b_pos#get:pos
                        get:left()
                    endif
                    get:left()
                    MCURON()
                end
                if len(get:buffer)==1
                    get:pos++
                endif
                if (get:typeOut .and. !Set(_SET_CONFIRM) )
                    if ( Set(_SET_BELL) )
                        ?? Chr(7)
                    end

                    get:exitState := GE_ENTER
                end

            end

        end

    endcase

return

/******************************************************************
 *
 * New Reader to allow a picklist of ALL ascii characters
 * while in a Hebrew GET
 */
#IFDEF MOUSE
FUNCTION HebMF2Reader( get,Mlist,pos,Getlist )
#ELSE
PROCEDURE HebF2Reader( get )
#ENDIF
    LOCAL ncol,nCursor
    LOCAL nKey,mCol,m
    LOCAL cLine24 := SAVESCREEN(24,0,24,79)

    @24, 0 SAY PADC("Press F2 for ASCII table picklist", 80 ) COLOR "gr+/r"

    IF bInsOn=NIL
#IFDEF MOUSE
       SetMInsBlock(.T.)
#ELSE
       SetInsBlock(.T.)
#ENDIF
    ENDIF

    IF bInsOff=NIL
#IFDEF MOUSE
       SetMInsBlock(.F.)
#ELSE
       SetInsBlock(.F.)
#ENDIF
    ENDIF

#IFDEF MOUSE
    lIsMouseSupport:=.t.
#ELSE
    lIsMouseSupport:=.f.
#ENDIF

    EVAL(IF(Set(_SET_INSERT),bInsOn,bInsOff))

    IF ! readinsert(.f.)
        _HB_IND_INS:= 0
        _hb_ins_key:=.f.
    ELSE
        _HB_IND_INS := 1
        readinsert(.t.)
        _hb_ins_key:=.t.
    ENDIF
    IF ! SET(_SET_INSERT)
        _HB_IND_INS := 0
    ELSE
        _hb_ins_key:=.t.
        _HB_IND_INS := 1
        readinsert(.t.)
    ENDIF
    _HB_MRET := .T.
    _HB_HBR:=.T.
    _HB_lock:=.F.
    _HB_MISPAR:=.F.
    _hb_get:=.t.


    // read the GET if the WHEN condition is satisfied
    if ( GetPreValidate(get) )

        // activate the GET for reading
        MCUROFF()
        get:SetFocus()
        Get:pos := LEN(Get:buffer)
        Get:display()
        MCURON()

        while ( get:exitState == GE_NOEXIT )

            // check for initial typeout (no editable positions)
            if ( get:typeOut )
                get:exitState := GE_ENTER
            end

            // apply keystrokes until exit
            while ( get:exitState == GE_NOEXIT )

#IFDEF MOUSE
              nKey := InKey()
              while  ( nKey == 0 )
                if ( _isbutton(1) )     /* Mouse press */
                   m_wait(1)    /* wait for release */
                   m := MousePick(mList)  /* in __mlist.prg */
                     if( m != 0)
                       if( m == pos)
                         if get:type=="C" .and. get:picture<>NIL
                           mcol:=relat_mpos(get)
                         elseif get:type=="D"
                           mcol:=relat_dpos(get)
                         elseif get:type=="N"
                           mcol:=relat_npos(get)
                         else
                           mcol:=(m_col()-get:col)
                         endif
                         csroff()
                         m_csroff()
                         get:home()
                         for m = 1 to mcol
                           get:right()
                         next
                         csron()
                         m_csron()
                       else
                         get:exitState := GE_DOWN
                         pos := m-1
                         if( pos > 0 )
                           getList[pos]:exitState := GE_DOWN
                         endif
                         exit
                       endif
                     endif
                endif
                nKey := InKey()
              end                 // while  ( nKey == 0 )
                  if (nKey !=0)
                     if (_hb_get)
                         HebMF2ApplyKey( get, nkey)
                     else
                         getMApplyKey( get, nKey )
                     endif
                 endif
            end                  // while ( get:exitState == GE_NOEXIT )

#ELSE
                if (_hb_get)
                    HebF2ApplyKey( get, rdb_Inkey(0) )
                else
                    if get:exitstate == GE_NOEXIT
                        getApplyKey( get, rdb_Inkey(0) )
                    endif
                endif
            end
#ENDIF
            nCursor:=SETCURSOR()
            MCUROFF()
            setcursor(0)
            // disallow exit if the VALID condition is not satisfied
            nCol:=get:pos
            if ( !GetPostValidate(get) )
                get:exitState := GE_NOEXIT
                //get:pos:=nCol
                Get:pos := LEN(Get:buffer)
                setpos(get:row,get:col+get:pos-1)
                setcursor(nCursor)
            end
            MCURON()
            setcursor(nCursor)
        end
        MCUROFF()
        get:KillFocus()
        MCURON()
        DispGet(get)
    end
#IFDEF MOUSE
RETURN(pos)
#ELSE

RESTSCREEN( 24,0,24,79,cLine24)
RETURN
#ENDIF



/***
*       HebApplyKey()
*       Apply a single Inkey() keystroke to a GET.
*
*       NOTE: GET must have focus.
*/
#IFDEF MOUSE
proc HebF2MApplyKey(get, key)
#ELSE
proc HebF2ApplyKey(get, key)
#ENDIF

    local cKey,cVal,nPos,nCount,nCursor
    local bKeyBlock
    local _HB_XX,_HB_LEN,_OLD_INSERT,B_POS
    LOCAL n
    LOCAL aCTRLCHRS := {;
            "", "", "", "", "", "", "", "", "", "", "",     ;
            "", "", "", "", "", "", "", "", "", "", "",     ;
            "", "", "", "", "", "a", "b", "c", "d", "e", "f", "g",;
            "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s",;
            "t", "u", "v", "w", "x", "y", "z","õ", "ú", "ù", "û",;
            "ü", "†", "°", "¢", "£", "§", "•", "¶", "ß", "®", "©", "™",;
            "´", "¨", "≠", "Æ", "Ø", "∞", "±", "≤", "≥", "¥", "µ", "∂",;
            "∑", "∏", "π", "∫", "ª", "º", "Ω", "æ", "ø", "¿", "¡", "¬",;
            "√", "ƒ", "≈", " ", "«", "»", "…", " ", "À", "Ã", "Õ", "Œ",;
            "œ", "–", "—", "“", "”", "‘", "’", "÷", "◊", "ÿ", "Ÿ", "⁄",;
            "€", "‹", "›", "ﬁ", "ﬂ", "‡", "·", "‚", "„", "‰", "Â", "Ê",;
            "Á", "Ë", "È", "Í", "Î", "Ï", "Ì", "Ó", "Ô", "", "Ò", "Ú",;
            "Û", "Ù", "ı", "ˆ", "˜", "¯", "˘", "˙", "˚", "¸", "˝", "˛" }


    IF _HB_MISPAR==NIL
        _HB_MISPAR:=GET:TYPE=="N"
    ENDIF

    // check for SET KEY first
    if ( (bKeyBlock := SetKey(key)) <> NIL )

        GetDoSetKey(bKeyBlock, get)
        return                                       // NOTE

    end


    do case
    case ( key == K_UP )
        get:exitState := GE_UP

    case ( key == K_SH_TAB )
        get:exitState := GE_UP

    case ( key == K_DOWN )
        get:exitState := GE_DOWN

    case ( key == K_TAB )
        get:exitState := GE_DOWN

    case ( key == K_ENTER )
        get:exitState := GE_ENTER

    case ( key == K_ESC )
        if ( Set(_SET_ESCAPE) )
            MCUROFF()
            get:undo()
            MCURON()
            get:exitState := GE_ESCAPE
        end

    case ( key == K_PGUP )
        get:exitState := GE_WRITE

    case ( key == K_PGDN )
        get:exitState := GE_WRITE

    case ( key == K_CTRL_HOME )
        get:exitState := GE_TOP


        #ifdef CTRL_END_SPECIAL

        // both ^W and ^End go to the last GET
    case (key == K_CTRL_END)
        get:exitState := GE_BOTTOM

        #else

        // both ^W and ^End terminate the READ (the default)
    case (key == K_CTRL_W)
        get:exitState := GE_WRITE

        #endif


    case (key == K_INS)
        Set( _SET_INSERT, !Set(_SET_INSERT) )
        EVAL(IF(Set(_SET_INSERT),bInsOn,bInsOff))
        IF _HB_IND_INS = 0
            _HB_IND_INS = 1
            _hb_ins_key = .t.
            readinsert(.t.)
        ELSE
            _HB_IND_INS = 0
            _hb_ins_key = .f.
            readinsert(.f.)
        ENDIF

    case (key == K_UNDO)
        MCUROFF()
        get:Undo()
        MCURON()
    case (key == K_HOME)
        MCUROFF()
        Get:pos := LEN(Get:buffer)
        Get:display()
        MCURON()
    case (key == K_END)
        nCursor:=SETCURSOR()
        MCUROFF()
        setcursor(0)
        nPos:=get:pos
        get:home()
        if  (! empty(get:buffer))
            if  (! empty(substr(get:buffer,1,nPos)) .or. nPos==1 )
                do while substr(get:buffer,get:pos,1)=" " .and. get:pos<len(get:buffer)
                    get:right()
                enddo
                get:left()
            endif
        endif
        setcursor(nCursor)
        MCURON()

    case (key == K_RIGHT)
        MCUROFF()
        get:Right()
        MCURON()

    case (key == K_LEFT)
        MCUROFF()
        get:Left()
        MCURON()

    case (key == K_CTRL_RIGHT)
        MCUROFF()
        get:pos := Min(get:pos + 1, Len(get:buffer))
        while (SubStr(get:buffer,get:pos,1)==" ") .and. (get:pos < Len(get:buffer))
            get:pos ++
        end
        while !(SubStr(get:buffer,get:pos,1)==" ") .and. (get:pos < Len(get:buffer))
            get:pos ++
        end
        if (get:pos < Len(get:buffer))
            get:pos --
        endif
        get:Display()
        MCURON()

    case (key == K_CTRL_LEFT)
        MCUROFF()
        while !(SubStr(get:buffer,get:pos,1)==" ") .and. (get:pos > 1)
            get:pos --
        end
        while (SubStr(get:buffer,get:pos,1)==" ") .and. (get:pos > 1)
            get:pos --
        end
        get:Display()
        MCURON()

    case (key == K_BS)
      MCUROFF()
        if get:pos#len(get:buffer)
            if get:pos<len(get:buffer)
                get:right()
            endif
            cval:=get:untransform()
            npos:=relat_pos(get)
            cval:=" "+substr(cval,1,npos-1)+substr(cval,npos+1)
           get:buffer:=cVal
           get:changed=.t.
          get:display()
      endif
      MCURON()

    case (key == K_DEL)
      MCUROFF()
        cval:=get:untransform()
        npos:=relat_pos(get)
        cval:=" "+substr(cval,1,npos-1)+substr(cval,npos+1)
        get:buffer:=cVal
      get:changed=.t.
        get:display()
        MCURON()

    case (key == K_CTRL_T)
      MCUROFF()
        nCount := 0
        while (get:pos > 1) .and. (SubStr(get:buffer, get:pos, 1) == " ")
            get:buffer := Stuff(get:buffer, get:pos, 1, "")
            get:pos --
            nCount ++
        end
        while (get:pos > 1) .and. !(SubStr(get:buffer, get:pos, 1) == " ")
            get:buffer := Stuff(get:buffer, get:pos, 1, "")
            get:pos --
            nCount ++
        end
        get:buffer := Space(nCount) + get:buffer
        get:pos := Min(get:pos + nCount, Len(get:buffer))
                get:Display()
        MCURON()
    case (key == K_CTRL_Y)
        MCUROFF()
        cval:=get:untransform()
        npos:=relat_pos(get)
        cval:=space(npos)+substr(cval,npos+1)
        get:buffer:=cVal
        get:changed=.t.
        get:display()
        MCURON()

    case (key == K_CTRL_BS)
        MCUROFF()
        get:DelWordRight()
        MCURON()

    /*
      Added CASE for F2 picklist handling
    */
   CASE Key == K_F2
       IF (n := AsciiList()) > 0
          Get:Buffer :=  STUFF( Get:Buffer, Get:Pos, 1, aCtrlChrs[n])
          Get:Varput(Get:Buffer)
          Get:left()
          Get:Display()
       ELSE
          DEVPOS( Get:row, Get:col+Get:pos-1)
       END

    otherwise
        IF LET_ABC=NIL
            DO INSLETABC
        ENDIF

        if (key >= 32 .and. key <= 255)

            if ((key>=96 .and. key<123) .or. (chr(key)$",./';"))
                ckey := chr(heb_chrc(key-31,let_abc))
            else
                ckey:=chr(key)
            endif

            if (get:type == "N" .and. (cKey == "." .or. cKey == ","))
                MCUROFF()
                get:ToDecPos()
                MCURON()
            else
                IF (key>47 .AND. key<58) .OR. (key>64 .AND. key<91) ;
                    .OR. (key>96 .AND. key<123 .AND. (.NOT. _HB_HBR));
                    .OR. (key>31 .AND. key<48  .AND. (.NOT. _HB_HBR) );
                    .OR.(_HB_MISPAR.AND.ckey$"-/.,;")
                    _HB_MISPAR=.T.
                    _HB_IND_INS = 1
                    _old_insert:=Set( _SET_INSERT,.t.)

                ELSE
                    IF _HB_MISPAR .AND. _HB_HBR
                        _hb_len:=get:pos
                        _HB_XX:=SUBSTR(get:buffer,_hb_len,1)
                        DO WHILE (_HB_XX>CHR(47) .AND. _HB_XX<CHR(58)) .OR.;
                            (_HB_XX>CHR(64) .AND. _HB_XX<CHR(91)) .OR.;
                            ( ((_HB_XX>CHR(96) .AND. _HB_XX<CHR(123)).OR.(_HB_XX$'-/.,;')) ;
                            .AND. (.NOT. _HB_HBR) );
                            .OR. ( _HB_XX>CHR(31) .AND. _HB_XX<CHR(48)  .AND. (.NOT. _HB_HBR) );
                            .OR. (_HB_XX$'-/.,;')
                            IF _HB_LEN>1
                                _HB_LEN--
                                get:pos--
                                _HB_XX=SUBSTR(get:buffer,_HB_LEN,1)
                            ELSE
                                EXIT
                            ENDIF
                        ENDDO
                        _HB_MISPAR=.F.
                        if _hb_ins_key
                            _HB_IND_INS = 1
                        else
                            _HB_IND_INS = 0
                        endif
                    ENDIF
                ENDIF
                if ( Set(_SET_INSERT))
                    IF ! _HB_HBR
                        ckey:= CHR(key)
                    ENDIF
                    MCUROFF()
                    cVal:=get:untransform()
                    npos:=relat_pos(get)
                    IF SUBSTR(cVal,1,1)=" " .or. !_hb_mispar .or. _hb_hbr
                        cVal:=SUBSTR(cval,2,npos-1)+ ckey + SUBSTR(cval,npos+1,len(cval)-npos)
                        get:buffer:=cVal
                        Get:changed := .T.
                    ENDIF
                    _hb_len:=get:pos
                    IF COL() > get:col
                        IF .NOT. _HB_MISPAR
                            _HB_LEN--
                            get:pos--
                            *   @ _HB_ROW,COL()-1 SAY ""
                        ENDIF
                    ENDIF
                    if (! _hb_ins_key)
                        SET(_SET_INSERT,_OLD_INSERT)
                    endif
                    get:display()
                    MCURON()
                else
                    b_pos=get:pos
                    MCUROFF()
                    get:overstrike(cKey)
                    Get:changed := .T.
                    if b_pos#get:pos
                        get:left()
                    endif
                    get:left()
                    MCURON()
                end
                if len(get:buffer)==1
                    get:pos++
                endif
                if (get:typeOut .and. !Set(_SET_CONFIRM) )
                    if ( Set(_SET_BELL) )
                        ?? Chr(7)
                    end

                    get:exitState := GE_ENTER
                end

            end

        end

    endcase

return

*------------------------------------------------------------------

STATIC PROCEDURE INSLETABC
    let_abc := "  !"+chr(34)+"#$%&,()*+ö-ï.0123456789:ì<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let_abc := let_abc+"[\]^_;ôêÅÇóãíâèáåäñéçî/òÉÄÖÑ'ëàÜ{|}~; "
RETURN

*------------------------------------------------------------------
#IFDEF MOUSE
FUNCTION SetMInsBlock(lOnOff,bBlock)
#ELSE
FUNCTION SetInsBlock(lOnOff,bBlock)
#ENDIF
    LOCAL oErr
    LOCAL bRetVal
    IF VALTYPE(bInsOff)="U"
        bInsOff := {|| ShowScoreboard()}
    ENDIF
    IF VALTYPE(bInsOn)="U"
        bInsOn := {|| ShowScoreboard()}
    ENDIF
    IF VALTYPE(lOnOff)="U"
      oErr := ErrorNew()
      oErr:severity := 2
      oErr:genCode := EG_ARG
      oErr:subSystem := "HEBREW"
      oErr:description := "Must sent On/Off parmeter"
      Eval(ErrorBlock(), oErr)
   ELSEIF (lOnOff)
       bRetVal:=bInsOn
        IF VALTYPE(bBlock)="B"
            bInsOn:=bBlock
        ENDIF
    ELSEIF !(lOnOff)
       bRetVal:=bInsOff
        IF VALTYPE(bBlock)="B"
            bInsOff:=bBlock
        ENDIF
   ENDIF
RETURN(bRetVal)

*------------------------------------------------------------------
#IFDEF MOUSE
FUNCTION HEBM_ACTIV(_a,_b,_c)
#ELSE
FUNCTION HEB_ACTIV(_A,_B,_C)
#ENDIF

    IF ! readinsert(.f.)
        _HB_IND_INS:= 0
        _hb_ins_key:=.f.
    ELSE
        _HB_IND_INS := 1
        readinsert(.t.)
        _hb_ins_key:=.t.
    ENDIF
    IF ! SET(_SET_INSERT)
        _HB_IND_INS := 0
    ELSE
        _hb_ins_key:=.t.
        _HB_IND_INS := 1
        readinsert(.t.)
    ENDIF
    _HB_MISPAR:=.F.
    _HB_MRET := .T.
    _HB_lock:=.F.
    _hb_get:=.t.
RETURN _hb_get
*------------------------------------------------------------------
#IFDEF MOUSE
FUNCTION HEBM_DACTIV(_a,_b,_c)
#ELSE
FUNCTION HEB_DACTIV(_a,_b,_c)
#ENDIF
    _hb_get:=.f.
RETURN _hb_get
*------------------------------------------------------------------
// display coordinates for SCOREBOARD
#define SCORE_ROW               0
#define SCORE_COL               60
/***
*   ShowScoreboard()
*/

STATIC PROCEDURE ShowScoreboard()

   LOCAL nRow
   LOCAL nCol

   IF ( SET( _SET_SCOREBOARD ) )
      nRow := ROW()
      nCol := COL()

      SETPOS( SCORE_ROW, SCORE_COL )
      DISPOUT( IF( SET( _SET_INSERT ), NationMsg(_GET_INSERT_ON),;
                                   NationMsg(_GET_INSERT_OFF)) )
      SETPOS( nRow, nCol )
   ENDIF

   RETURN
*------------------------------------------------------------------
#IFNDEF MOUSE // to avoid DOUBLE DEFINITION warning in LIB.EXE

FUNCTION LANG_TOGGLE
LOCAL oG:=getactive()

    IF oG:TYPE!="C"
        return _hb_get
    ENDIF

    if oG:Reader==NIL
        ENG_TOGGLE()
    else
        HEB_TOGGLE()
        MHEB_TOGGLE()
    endif

RETURN _hb_get

#ENDIF
*------------------------------------------------------------------
#IFDEF MOUSE
FUNCTION MHEB_TOGGLE

    IF _hb_get != NIL .AND. lIsMouseSupport
        _hb_get:=!_hb_get

        IF _hb_get
            getactive():pos:=len(getactive():buffer())  // Ñêâéâå èéëÑ öÄ ÜÜÑ
        ELSE
            getactive():home()                          // åÄéôå èéëÑ öÄ ÜÜÑ
        ENDIF
    ENDIF

RETURN  _hb_get

#ELSE

*------------------------------------------------------------------
FUNCTION HEB_TOGGLE

    IF _hb_get != NIL .AND. !lIsMouseSupport
        _hb_get:=!_hb_get

        IF _hb_get
            getactive():pos:=len(getactive():buffer())  // Ñêâéâå èéëÑ öÄ ÜÜÑ
        ELSE
            getactive():home()                          // åÄéôå èéëÑ öÄ ÜÜÑ
        ENDIF
    ENDIF

RETURN _hb_get
#ENDIF

*------------------------------------------------------------------
static function eng_toggle
return .t.

*------------------------------------------------------------------
static function getmapplykey
return .t.

/**********************************************************************/
STATIC FUNCTION AsciiList

LOCAL aCTRLLIST := {;
"  1   01h      SOH","  2   02h      STX","  3   03h      ETX",;
"  4   04h      EOT","  5   05h      ENQ","  6   06h      ACK",;
"  7   07h      BEL","  8   08h      BS ",                      ;
" 11   0Bh      VT "," 14   0Eh      SO "," 15   0Fh      SI ",;
" 16   10h      DLE"," 17   11h      DC1"," 18   12h      DC2",;
" 19   13h      DC3"," 20   14h      DC4"," 21   15h      NAK",;
" 22   16h      SYN"," 23   17h      ETB"," 24   18h      CAN",;
" 25   19h      EM "," 27   1Bh      ESC",                      ;
" 28   1Ch      FS "," 29   1Dh      GS "," 30   1Eh      RS ",;
" 31   1Fh      US ","127   7Fh         "," 97   61h   a      ",;
" 98   62h   b      "," 99   63h   c      ","100   64h   d      ",;
"101   65h   e      ","102   66h   f      ","103   67h   g      ",;
"104   68h   h      ","105   69h   i      ","106   6Ah   j      ",;
"107   6Bh   k      ","108   6Ch   l      ","109   6Dh   m      ",;
"110   6Eh   n      ","111   6Fh   o      ","112   70h   p      ",;
"113   71h   q      ","114   72h   r      ","115   73h   s      ",;
"116   74h   t      ","117   75h   u      ","118   76h   v      ",;
"119   77h   w      ","120   78h   x      ","121   79h   y      ",;
"122   7Ah   z      ","155   9Bh   õ      ","156   9Ch   ú      ",;
"157   9Dh   ù      ","158   9Eh   û      ","159   9Fh   ü      ",;
"160   A0h   †      ","161   A1h   °      ","162   A2h   ¢      ",;
"163   A3h   £      ","164   A4h   §      ","165   A5h   •      ",;
"166   A6h   ¶      ","167   A7h   ß      ","168   A8h   ®      ",;
"169   A9h   ©      ","170   AAh   ™      ","171   ABh   ´      ",;
"172   ACh   ¨      ","173   ADh   ≠      ","174   AEh   Æ      ",;
"175   AFh   Ø      ","176   B0h   ∞      ","177   B1h   ±      ",;
"178   B2h   ≤      ","179   B3h   ≥      ","180   B4h   ¥      ",;
"181   B5h   µ      ","182   B6h   ∂      ","183   B7h   ∑      ",;
"184   B8h   ∏      ","185   B9h   π      ","186   BAh   ∫      ",;
"187   BBh   ª      ","188   BCh   º      ","189   BDh   Ω      ",;
"190   BEh   æ      ","191   BFh   ø      ","192   C0h   ¿      ",;
"193   C1h   ¡      ","194   C2h   ¬      ","195   C3h   √      ",;
"196   C4h   ƒ      ","197   C5h   ≈      ","198   C6h   ∆      ",;
"199   C7h   «      ","200   C8h   »      ","201   C9h   …      ",;
"202   CAh          ","203   CBh   À      ","204   CCh   Ã      ",;
"205   CDh   Õ      ","206   CEh   Œ      ","207   CFh   œ      ",;
"208   D0h   –      ","209   D1h   —      ","210   D2h   “      ",;
"211   D3h   ”      ","212   D4h   ‘      ","213   D5h   ’      ",;
"214   D6h   ÷      ","215   D7h   ◊      ",;
"216   D8h   ÿ      ","217   D9h   Ÿ      ","218   DAh   ⁄      ",;
"219   DBh   €      ","220   DCh   ‹      ","221   DDh   ›      ",;
"222   DEh   ﬁ      ","223   DFh   ﬂ      ","224   E0h   ‡      ",;
"225   E1h   ·      ","226   E2h   ‚      ","227   E3h   „      ",;
"228   E4h   ‰      ","229   E5h   Â      ","230   E6h   Ê      ",;
"231   E7h   Á      ","232   E8h   Ë      ","233   E9h   È      ",;
"234   EAh   Í      ","235   EBh   Î      ","236   ECh   Ï      ",;
"237   EDh   Ì      ","238   EEh   Ó      ","239   EFh   Ô      ",;
"240   F0h         ","241   F1h   Ò      ","242   F2h   Ú      ",;
"243   F3h   Û      ","244   F4h   Ù      ","245   F5h   ı      ",;
"246   F6h   ˆ      ","247   F7h   ˜      ","248   F8h   ¯      ",;
"249   F9h   ˘      ","250   FAh   ˙      ","251   FBh   ˚      ",;
"252   FCh   ¸      ","253   FDh   ˝      ","254   FEh   ˛      " }
LOCAL cClr := SETCOLOR("w+/bg")
LOCAL cScr := SAVESCREEN()
LOCAL n

@ 24, 0 SAY PADC("Up/Down arrows to move, ENTER to choose, ESC to abort ",80) COLOR "gr+/r"
DrawBox(5,40,15,60)
SETCOLOR("bg+/bg,gr+/r")
n := ACHOICE( 6,41,14,59,aCtrlList)

SETCOLOR(cClr)
RESTSCREEN(0,0,24,79,cScr)

RETURN n
