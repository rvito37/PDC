#include "avxdefs.ch"


FUNCTION ABrowseNEW( nT,nL,nB,nR ,aReference)
LOCAL oTbr := TBrowseNew(nT,nL,nB,nR )

oTbr:cargo := Array(2)

oTbr:arrayReference := aReference

oTbr:arrayIndex    := 1
oTbr:goTopBlock    := { || oTbr:arrayIndex := 1 }
oTbr:goBottomBlock := { || oTbr:arrayIndex := Len(oTbr:arrayReference) }
oTbr:SkipBlock     := { |nToSkip,nTemp| ;
                        nTemp := oTbr:arrayIndex, ;
                        oTbr:arrayIndex := Iif(nToSkip > 0 , ;
                             Min(oTbr:arrayIndex + nToSkip, Len(oTbr:arrayReference)),;
                             Max(1,oTbr:arrayIndex + nToSkip)),;
                             oTbr:arrayIndex - nTemp;
                      }

RETURN oTbr
