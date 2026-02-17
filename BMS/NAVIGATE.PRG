FUNCTION SkipIt(n, cTop,bKey)

LOCAL i := 0
LOCAL nTop := LEN( cTop )

IF  n = 0 .OR. Empty( LastRec() )
     DBSKIP(0)
ELSEIF n > 0 .AND. RECNO() <> LASTREC() + 1
       WHILE i < n
             DBSKIP()
             IF EOF() .OR.  LEFT( bKey:eval(), nTop ) <> cTop
               DBSKIP(-1)
               EXIT
             ENDIF
            i++
       END
ELSEIF n < 0
       WHILE i > n
           DBSKIP(-1)
           IF BOF()
              EXIT
           ELSEIF LEFT( bKey:eval(), nTop ) <> cTop
              DBSKIP()
              EXIT
           ENDIF
           i--
       END
END

RETURN i

FUNCTION Skip2It(n,cTop,cBottom,bKey)

LOCAL i := 0
LOCAL nTop := LEN( cTop )

IF  n = 0 .OR. Empty( LastRec() )
    DBSKIP(0)
ELSEIF n > 0 .AND. RECNO() <> LASTREC() + 1
       WHILE i < n
             DBSKIP()
             IF EOF() .OR. !( LEFT( bKey:eval(), nTop ) >= cTop .AND.;
                              LEFT( bKey:eval(), nTop ) <= cBottom)
               DBSKIP(-1)
               EXIT
             ENDIF
            i++
       END
ELSEIF n < 0
       WHILE i > n
           DBSKIP(-1)
           IF BOF()
              EXIT
           ELSEIF !(LEFT( bKey:eval(), nTop ) >= cTop .AND.;
                    LEFT( bKey:eval(), nTop ) <= cBottom)
              DBSKIP()
              EXIT
           ENDIF
           i--
       END
END

RETURN i

PROCEDURE Top(searcher)

IF Empty(searcher)
   DbGoTop()
ELSE
   DbSeek(searcher)
END

RETURN

/***********************************************************/
// block to skip bottom
PROCEDURE Bot( cSearcher)

LOCAL save_soft   :=Set(_SET_SOFTSEEK,.t.)
LOCAL cNumbers    := "0123456789."
LOCAL lIsNumber   := .T.
LOCAL nLen        := LEN(cSearcher)
LOCAL lZeroPadded := LEFT(cSearcher,1 ) == "0"
LOCAL i

IF !Empty(cSearcher)
   FOR i := 1 TO nLen
       IF !( SUBSTR( cSearcher, i, 1 ) $ cNumbers )
          lIsNumber := .F.
          EXIT
       ENDIF
   NEXT
   IF lIsNumber
      cSearcher := STR( VAL( cSearcher)+1, nLen )
      IF lZeroPadded
         cSearcher := PADL( ALLTRIM(cSearcher), nLen, "0" )
      END
      SEEK cSearcher
   ELSE
     SEEK SubStr(cSearcher,1,len(cSearcher)-1)+;
        Chr(Asc(SubStr(cSearcher,Len(cSearcher)))+1)
   END
   DbSkip(-1)
ELSE
   DbGoBottom()
END

Set(_SET_SOFTSEEK,save_soft)
RETURN