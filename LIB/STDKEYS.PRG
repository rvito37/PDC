// StdKeys.prg - Standard TBrowse keyboard handler
// Dispatches navigation keys to TBrowse object methods
// Returns .T. if key was handled, .F. otherwise

#include "inkey.ch"

FUNCTION StdKeys( nKey, o )

   IF o == NIL
      RETURN .F.
   ENDIF

   DO CASE
   CASE nKey == K_UP         ; o:up()
   CASE nKey == K_DOWN       ; o:down()
   CASE nKey == K_PGUP       ; o:pageUp()
   CASE nKey == K_PGDN       ; o:pageDown()
   CASE nKey == K_CTRL_PGUP  ; o:goTop()
   CASE nKey == K_CTRL_PGDN  ; o:goBottom()
   CASE nKey == K_HOME       ; o:home()
   CASE nKey == K_END        ; o:end()
   CASE nKey == K_LEFT       ; o:left()
   CASE nKey == K_RIGHT      ; o:right()
   CASE nKey == K_CTRL_HOME  ; o:panHome()
   CASE nKey == K_CTRL_END   ; o:panEnd()
   CASE nKey == K_CTRL_LEFT  ; o:panLeft()
   CASE nKey == K_CTRL_RIGHT ; o:panRight()
   OTHERWISE
      RETURN .F.
   ENDCASE

RETURN .T.
