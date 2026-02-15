// Bmsbar4.prg
// Function/Procedure Prototype Table  -  Last Update: 24-06-96 @ 14:50:25
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// Return Value         Function/Arguments
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// "³" + aEntry[1] + ;  STATIC FUNCTION Entry( aEntry )
// Void                 STATIC PROCEDURE SendToLpt( nCopyNo )
// Void                 STATIC PROCEDURE ShowDoc
// Void                 PROCEDURE QcDoc( aLines , cFile )
// Void                 PROCEDURE SetDocType( cType )

// G:\BMSBAR\SOURCE\BMSBAR4.PRG
#include "avxdefs.ch"
// nCopies was 3. A requested was made by Carleen as a "waste of paper",
// since she doesn't need it. David L. 19/03/98
STATIC nCopies := 1 ,;
       aEntries     ,;
       cFinFile     ,;
       o            ,;
       aDocShow     ,;
       cDocType




PROCEDURE QcDoc( aLines , cFile )
LOCAL i , nLen
aEntries := aLines
cFinFile := cFile

aDocShow := {}

IF !IfEnglish()
   Aadd( aDocShow , Padr( "F-PW-05.01 :‘”…ˆ" ,80 ) )
   Aadd( aDocShow , Padr( "        0 :…‹ƒ’" ,80 ) )
   Aadd( aDocShow , Padc( "‰‰‹˜  ‘—€.‰….‰€ „˜‘…‰—" ,80 ) )
   Aadd( aDocShow , Space(80) )
   Aadd( aDocShow , Padl( Left(Time(),5)+" :„‘”ƒ„ š’™ "+Dtoc(Date())+" :„‘”ƒ„ Š‰˜€š",80) )
   Aadd( aDocShow , Padl([4 Š…š 1:'‘ —š…’],80))
   Aadd( aDocShow , Space(80) )
   Aadd( aDocShow , Space(80) )

   IF cDocType = NIL
      Aadd( aDocShow , Padc((cFinFile)->b_id+[:'‘ ˜…–‰‰ š …‰‘ ‡"…ƒ],80))
   ELSE
      Aadd( aDocShow , Padc((cFinFile)->b_id+[:'‘ ‰ˆ‰— ˜…–‰‰ š …‰‘ ‡"…ƒ],80))
   ENDIF

   IF !Empty((cFinFile)->HVal_dt)
     Aadd( aDocShow , Padc(Str((cFinFile)->HVal_dt,8,3)+"-"+Str((cFinFile)->LVal_dt,8,3)+[:DT š…Œ…‚],80) )
   ELSE
     Aadd( aDocShow , Space(80) )
   ENDIF

   Aadd( aDocShow , Space(80) )

   IF cDocType = NIL
      Aadd( aDocShow , Padl( (cFinFile)->b_ncaps+[:caps '‘],80))
   ELSE
      Aadd( aDocShow , Space(80) )
   ENDIF

   Aadd( aDocShow , Padc( [ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄ¿],80))
   Aadd( aDocShow , Padc( [³        „˜’„        ³‘‡³  š…‹ ³   Œ’…” ESN    ³ƒ"‘³],80))
   Aadd( aDocShow , Padc( [ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄ´],80))

   nLen := Len( aEntries )
   FOR i := 1 TO nLen
       Aadd( aDocShow , Padc( Entry( aEntries[i] ) , 80 ) )
   NEXT
   Aadd( aDocShow , Padc( [ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÙ],80))
   Aadd( aDocShow , Space(80) )
   Aadd( aDocShow , Padl("š…‹‰€ š˜…— ˜…™‰€",80) )
   Aadd( aDocShow , Padl("ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ",80) )
   Aadd( aDocShow , Padl([         „‰š‡                 šš…‡/™     Š‰˜€š],80))
   Aadd( aDocShow , Padl( Dtoc((cFinFile)->b_dqc),80))
   Aadd( aDocShow , Padl("ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄÄ",80))
   Aadd( aDocShow , Space(80) )
   Aadd( aDocShow , Space(80) )
   Aadd( aDocShow , Padl([‚"–…š ‘‡ „Œ— ˜…™‰€],80) )
   Aadd( aDocShow , Padl("ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ",80) )
   Aadd( aDocShow , Padl([         „‰š‡                 šš…‡/™     Š‰˜€š],80))
   Aadd( aDocShow , Space(80) )
   Aadd( aDocShow , Padl("ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄÄ",80))
ELSE/////////////////////////////////////////////////////////////////////////////
   Aadd( aDocShow , Padl( "Form:F-PW-05.01" ,80 ) )
   Aadd( aDocShow , Padl( "Rev :0         " ,80 ) )
   Aadd( aDocShow , Padc( "KYOCERA AVX COMPONENTS" ,80 ) )
   Aadd( aDocShow , Space(80) )
   Aadd( aDocShow , Padr(Space(5)+"Print Date: " + Dtoc(Date())+" Time: "+Left(Time(),5),80) )
   Aadd( aDocShow , Padr(Space(5)+[Copy 1 From 4],80))
   Aadd( aDocShow , Space(80) )
   Aadd( aDocShow , Space(80) )

   IF cDocType = NIL
      Aadd( aDocShow , Padc([Completion Report for Production Batch No:]+(cFinFile)->b_id,80))
   ELSE
      Aadd( aDocShow , Padc([Completion Report for Kits Production Batch No:]+(cFinFile)->b_id,80))
   ENDIF

   Aadd( aDocShow , Space(80) )

   IF !Empty((cFinFile)->HVal_dt)
     Aadd( aDocShow , Padc([DT Values:]+Str((cFinFile)->LVal_dt,8,3)+"-"+Str((cFinFile)->HVal_dt,8,3),80) )
   ELSE
     Aadd( aDocShow , Space(80) )
   ENDIF

   IF cDocType = NIL
      Aadd( aDocShow , Space(5)+Padr( [No of Caps:]+(cFinFile)->b_ncaps,80))
   ELSE
      Aadd( aDocShow , Space(80) )
   ENDIF

   Aadd( aDocShow , Padc( [ÚÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿],80))
   Aadd( aDocShow , Padc( [³ #  ³   Actual ESN   ³  Qty  ³ WH ³       Comment      ³],80))
   Aadd( aDocShow , Padc( [ÃÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´],80))

   nLen := Len( aEntries )
   FOR i := 1 TO nLen
       Aadd( aDocShow , Padc( Entry( aEntries[i] ) , 80 ) )
   NEXT
   Aadd( aDocShow , Padc( [ÀÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ],80))
   Aadd( aDocShow , Space(80) )

   Aadd( aDocShow , Padr(Space(5)+"Final Quality Control Approval",80) )
   Aadd( aDocShow , Padr(Space(5)+"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ",80) )
   Aadd( aDocShow , Padr(Space(5)+[Date          Name\Stamp            Signature    ],80))
   Aadd( aDocShow , Padr(Space(5)+ Dtoc((cFinFile)->b_dqc),80))
   Aadd( aDocShow , Padr(Space(5)+"ÄÄÄÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ",80))
   Aadd( aDocShow , Space(80) )
   Aadd( aDocShow , Space(80) )
   Aadd( aDocShow , Padr(Space(5)+[Finish Goods Warehouse Entry Approval],80) )
   Aadd( aDocShow , Padr(Space(5)+"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ",80) )
   Aadd( aDocShow , Padr(Space(5)+[Date          Name\Stamp            Signature    ],80))
   Aadd( aDocShow , Space(80) )
   Aadd( aDocShow , Padr(Space(5)+"ÄÄÄÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ",80))
ENDIF
ShowDoc()
RETURN

// [³xxxxxxxxxxxxxxxxxxxx³xxxx³999,999³xxxxxxxxxxxxxxxx³9999³
STATIC FUNCTION Entry( aEntry )
RETURN IIF(!IfEnglish() ,;
              "³" + aEntry[1]                          + ;
              "³" + Padc( aEntry[2] , 4 )              + ;
              "³" + Transform( aEntry[3] , "999,999" ) + ;
              "³" + aEntry[4]                          + ;
              "³" + Str( aEntry[5] , 4 )               + "³",;
				  "³" + Str( aEntry[5] , 4 )               + ;
              "³" + aEntry[4]                          + ;
              "³" + Transform( aEntry[3] , "999,999" ) + ;
              "³" + Padc( aEntry[2] , 4 )              + ;
              "³" + aEntry[1]                          + "³")



STATIC PROCEDURE ShowDoc
LOCAL nKey , i
LOCAL cScreen := SaveScreen()
@24, 0 SAY PADC("Press F3 to print",80) COLOR "gr+/r"


o := ABrowseNEW(2,0,MaxRow()-1,MaxCol(), aDocShow)
o:addColumn(TBColumnNEW(NIL, {|| o:arrayReference[o:arrayIndex]}))

WHILE .T.
    WHILE !o:stabilize() ; ENDDO

    nKey := InKey(1)

    IF nKey = K_ESC
       EXIT
    ELSEIF StdKeys( nKey , o )

    ELSEIF nKey = K_F3
       //set printer to barbar.txt

		 SET PRINTER TO LPT1
		 SET PRINTER ON
		 SET CONSOLE OFF

       ? PrnSetup()

       FOR i := 1 TO nCopies
           SendToLpt(i)
       NEXT

       //set printer to
       ? PrnReset()

		 SET PRINTER TO
		 SET PRINTER OFF
		 SET CONSOLE ON
    ENDIF

ENDDO


RestScreen( ,,,, cScreen )
RETURN


STATIC PROCEDURE SendToLpt( nCopyNo )
LOCAL i ,nLen := Len( aDocShow )


IF !IfEnglish()
    aDocShow[6] := Stuff( aDocShow[6],64,1,Str( nCopies,1 ))
    aDocShow[6] := Stuff( aDocShow[6],71,1,Str( nCopyNo,1 ))
ELSE
    aDocShow[6] := Stuff( aDocShow[6],18,1,Str( nCopies,1 ))
    aDocShow[6] := Stuff( aDocShow[6],11,1,Str( nCopyNo,1 ))
ENDIF



FOR i := 1 TO nLen
    ? aDocShow[i]
NEXT
EJECT
RETURN


PROCEDURE SetDocType( cType )
cDocType := cType
RETURN