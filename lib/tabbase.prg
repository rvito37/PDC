* tabbase.prg - STUB (placeholder until real file is uploaded)
* TabBase class - table/database wrapper

#include "hbclass.ch"

CREATE CLASS TabBase

   VAR cTable
   VAR aIndex
   VAR lOpen

   METHOD new( cTable, aIndex )
   METHOD open()
   METHOD close()

END CLASS

METHOD new( cTable, aIndex ) CLASS TabBase
   ::cTable := cTable
   ::aIndex := aIndex
   ::lOpen := .F.
RETURN Self

METHOD open() CLASS TabBase
RETURN Self

METHOD close() CLASS TabBase
RETURN Self
