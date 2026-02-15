// SCRNPP.PRG
// screen push & pop stck

#include "avxdefs.ch"


#define TOP     1
#define LEFT    2
#define BOTTOM  3
#define RIGHT   4
#define SCREEN  5

STATIC aStack := {}


PROC scrnPush( t , l ,b , r ,lScroll)

DEFAULT t TO 0 , l TO 0 , b TO 24 , r TO 79 , lScroll TO .F.

Aadd( aStack , { t ,l , b , r , SaveScreen( t, l , b , r ) } )

IF lScroll
   Scroll( t,l,b,r)
END
RETURN


PROC scrnPop
LOCAL aScreenData

IF Empty( aStack )
   Alert( "Empty screen STACK !!")
   QUIT
END

aScreenData := Atail(aStack)
aStack := Asize( aStack , Len( aStack ) - 1 )

RestScreen( aScreenData[TOP]    ,;
            aScreenData[LEFT]   ,;
            aScreenData[BOTTOM] ,;
            aScreenData[RIGHT]  ,;
            aScreenData[SCREEN] )

RETURN
