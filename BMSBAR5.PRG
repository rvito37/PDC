// Bmsbar5.prg
// Function/Procedure Prototype Table  -  Last Update: 24-06-96 @ 14:50:28
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// Return Value         Function/Arguments
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// "³" + aEntry[1] + ;  STATIC FUNCTION Entry( aEntry )
// "³ " + aEntry[1]...  STATIC FUNCTION sEntry( aEntry )
// Void                 STATIC PROCEDURE GetEsnId
// Void                 STATIC PROCEDURE SendToLpt( nCopyNo )
// Void                 STATIC PROCEDURE ShowDoc
// Void                 PROCEDURE QcPackDoc( aLines , a2Lines , cFile )

// G:\BMSBAR\SOURCE\BMSBAR4.PRG
#include "avxdefs.ch"
// nCopies was 3. A requested was made by Carleen as a "waste of paper",
// since she doesn't need it. David L. 19/03/98
STATIC nCopies := 1 ,;
       aEntries     ,;
       a2Entries    ,;
       cFinFile     ,;
       o            ,;
       aDocShow     ,;
       cDocType


PROCEDURE QcPackDoc( aLines , a2Lines , cFile )
LOCAL i , nLen
aEntries  := aLines
a2Entries := a2Lines
cFinFile := cFile

GetEsnID()  // add esn_id to source BN's ( sort and number )

aDocShow := {}

IF !IfEnglish()///////////////////////////////////////////////////////
   Aadd( aDocShow , Padr( "1 …‹ƒ’ 15B ‘”…ˆ" ,80 ) )
   Aadd( aDocShow , Padc( "‰‰‹˜  ‘—€.‰….‰€ „˜‘…‰—" ,80 ) )
   Aadd( aDocShow , Space(80) )
   Aadd( aDocShow , Padl( Left(Time(),5)+" :„‘”ƒ„ š’™ "+Dtoc(Date())+" :„‘”ƒ„ Š‰˜€š",80) )
   Aadd( aDocShow , Padl([4 Š…šŽ 1:'‘Ž —š…’],80))
   Aadd( aDocShow , Space(80) )
   Aadd( aDocShow , Space(80) )

   Aadd( aDocShow , Padc((cFinFile)->packb_id+[:'‘Ž „†‰˜€ šŽ …‰‘ ‡"…ƒ],80))

   Aadd( aDocShow , Space(80) )
   Aadd( aDocShow , Space(80) )

   Aadd( aDocShow , Padl( [„†‰˜€ šŽ ‰…š],80))
   Aadd( aDocShow , Padc( [ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄ¿],80))
   Aadd( aDocShow , Padc( [³        „˜’„        ³‘‡Ž³  š…Ž‹ ³   Œ’…” ESN    ³ƒ"‘Ž³],80))
   Aadd( aDocShow , Padc( [ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄ´],80))

   nLen := Len( aEntries )
   FOR i := 1 TO nLen
       Aadd( aDocShow , Padc( Entry( aEntries[i] ) , 80 ) )
   NEXT
   Aadd( aDocShow , Padc( [ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÙ],80))
   Aadd( aDocShow , Space(80) )

   Aadd( aDocShow , Padl( [˜…—Ž š…Ž ‰…š],80))
   Aadd( aDocShow , Padc( [ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄ¿],80))
   Aadd( aDocShow , Padc( [³        „˜’„        ³‘‡Ž³  š…Ž‹ ³   Œ’…” ESN    ³˜…—Ž š…Ž '‘Ž³ƒ"‘Ž³],80))
   Aadd( aDocShow , Padc( [ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄ´],80))

   nLen := Len( a2Entries )
   FOR i := 1 TO nLen
       Aadd( aDocShow , Padc( sEntry( a2Entries[i] ) , 80 ) )
   NEXT
   a2Entries := {}
   Aadd( aDocShow , Padc( [ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÙ],80))
   Aadd( aDocShow , Space(80) )
   Aadd( aDocShow , Space(80) )

   Aadd( aDocShow , Padl("š…‹‰€ š˜…— ˜…™‰€",80) )
   Aadd( aDocShow , Padl("ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ",80) )
   Aadd( aDocShow , Padl([         „Ž‰š‡                 šŽš…‡/™     Š‰˜€š],80))
   Aadd( aDocShow , Padl( Dtoc((cFinFile)->b_dqc),80))
   Aadd( aDocShow , Padl("ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄÄ",80))
   Aadd( aDocShow , Space(80) )
   Aadd( aDocShow , Space(80) )
   Aadd( aDocShow , Padl([‚"–…š ‘‡Ž „Œ— ˜…™‰€],80) )
   Aadd( aDocShow , Padl("ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ",80) )
   Aadd( aDocShow , Padl([         „Ž‰š‡                 šŽš…‡/™     Š‰˜€š],80))
   Aadd( aDocShow , Space(80) )
   Aadd( aDocShow , Padl("ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄÄ",80))
ELSE//////////////////////////////////////////////////////////////////////////
   Aadd( aDocShow , Padl( "Form:15B Rev :1" ,80 ) )
   Aadd( aDocShow , Padc( "KYOCERA AVX COMPONENTS" ,80 ) )
   Aadd( aDocShow , Space(80) )
   Aadd( aDocShow , Padr( Space(5)+"Print Date: " + Dtoc(Date())+" Time: "+Left(Time(),5),80) )
   Aadd( aDocShow , Padr( Space(5)+[Copy 1 From 4],80))
   Aadd( aDocShow , Space(80) )
   Aadd( aDocShow , Space(80) )

   Aadd( aDocShow , Padc([Completion Report for Packing Batch No:]+(cFinFile)->packb_id,80))

   Aadd( aDocShow , Space(80) )
   Aadd( aDocShow , Space(80) )

   Aadd( aDocShow , Padr( Space(5)+[Packing Batch details],80))
   Aadd( aDocShow , Padc( [ÚÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿],80))
   Aadd( aDocShow , Padc( [³ #  ³   Actual ESN   ³  Qty  ³ WH ³       Comment      ³],80))
   Aadd( aDocShow , Padc( [ÃÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´],80))

   nLen := Len( aEntries )
   FOR i := 1 TO nLen
       Aadd( aDocShow , Padc( Entry( aEntries[i] ) , 80 ) )
   NEXT
   Aadd( aDocShow , Padc( [ÀÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ],80))
   Aadd( aDocShow , Space(80) )

   Aadd( aDocShow , Padr( Space(5)+[Source Batches details],80))
   Aadd( aDocShow , Padc( [ÚÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿],80))
   Aadd( aDocShow , Padc( [³ #  ³Source Batch ³   Actual ESN   ³  Qty  ³ WH ³      Comment       ³],80))
   Aadd( aDocShow , Padc( [ÃÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´],80))

   nLen := Len( a2Entries )
   FOR i := 1 TO nLen
       Aadd( aDocShow , Padc( sEntry( a2Entries[i] ) , 80 ) )
   NEXT
   a2Entries := {}
   Aadd( aDocShow , Padc( [ÀÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ],80))
   Aadd( aDocShow , Space(80) )
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
ENDIF/////////////////////////////////////////////////////////////////////////
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

//  ³        „˜’„        ³‘‡Ž³  š…Ž‹³   Œ’…” ESN    ³˜…—Ž š…Ž '‘Ž³ƒ"‘Ž³
//  ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄ´
//  ³xxxxxxxxxxxxxxxxxxxx³xxxx³999,999³xxxxxxxxxxxxxxxx³      999999 ³9999³
STATIC FUNCTION sEntry( aEntry )
RETURN IIF(!IfEnglish() ,;
       "³" + aEntry[1]                          + ;
       "³" + Padc( aEntry[2] , 4 )              + ;
       "³" + Transform( aEntry[3] , "999,999" ) + ;
       "³" + aEntry[11]                         + ;
       "³" + pADL(aEntry[10],12) + " "          + ;
       "³" + Str( aEntry[12] , 4 )              + "³",;
		 "³" + Str( aEntry[12] , 4 )              + ;
       "³" + pADR(aEntry[10],12) + " "          + ;
		 "³" + aEntry[11]                         + ;
		 "³" + Transform( aEntry[3] , "999,999" ) + ;
		 "³" + Padc( aEntry[2] , 4 )              + ;
		 "³" + aEntry[1]                          + "³")

STATIC PROCEDURE ShowDoc
LOCAL nKey , i
LOCAL cScreen := SaveScreen()

@24, 0 SAY PADC("Press F3 to print",80) COLOR "gr+/r"

o := ABrowseNEW(0,0,MaxRow(),MaxCol(), aDocShow)
o:addColumn(TBColumnNEW(NIL, {|| o:arrayReference[o:arrayIndex]}))

WHILE .T.
    WHILE !o:stabilize() ; ENDDO

    nKey := InKey(1)

    IF nKey = K_ESC
       EXIT
    ELSEIF StdKeys( nKey , o )

    ELSEIF nKey = K_F3
//       set printer to barbar.txt
       SET PRINTER ON
       SET CONSOLE OFF

       FOR i := 1 TO nCopies
           SendToLpt(i)
       NEXT

       set printer to
       SET PRINTER OFF
       SET CONSOLE ON
    ENDIF

ENDDO


RestScreen( ,,,, cScreen )
RETURN


STATIC PROCEDURE SendToLpt( nCopyNo )
LOCAL i ,nLen := Len( aDocShow )

IF !IfEnglish()
    aDocShow[5] := Stuff( aDocShow[5],64,1,Str( nCopies,1 ))
    aDocShow[5] := Stuff( aDocShow[5],71,1,Str( nCopyNo,1 ))
ELSE
    aDocShow[5] := Stuff( aDocShow[5],18,1,Str( nCopies,1 ))
    aDocShow[5] := Stuff( aDocShow[5],11,1,Str( nCopyNo,1 ))
ENDIF

FOR i := 1 TO nLen
    ? aDocShow[i]
NEXT
EJECT
RETURN


STATIC PROCEDURE GetEsnId
LOCAL i := 0
LOCAL nSaveFinRecNo  := (cFinFile)->( RecNo() )
LOCAL cB_id := ""
LOCAL cOldorder

// Previous for-next loop was getting ALWAYS the same esn_id
// since it was seeking again to the same record... 5/3/98 David L.
IF ! EMPTY(a2Entries)    // In cases of no source packing batches
 // No need to use source BN since it may already exist as production before!
 //  (cFinFile)->( DbSeek( a2Entries[1,10] ) )  // source BN
 IF UPPER(cFinfile) == "D_FINQC"
    cOldorder := (cFinfile)->(ORDSETFOCUS("ifinqpbn"))
 ELSEIF UPPER(cFinfile) == "H_FINQC"
    cOldorder := (cFinfile)->(ORDSETFOCUS("hfinqpbn"))
 ELSE
    cOldorder := (cFinfile)->(ORDSETFOCUS("afinqpbn"))
 ENDIF
 cB_id := d_line->b_id    // Take b_id of packing batch from d_line
 (cFinFile)->( DbSeek( cB_id  ) ) // Seek on this batch into packing index
  DO WHILE (cFinfile)->packb_id == cB_id
     IF (cFinfile)->FIN_TYPE = "3" // Is a source of a packing batch ??
          Aadd( a2Entries[++i] , (cFinFile)->esn_id )
          Aadd( a2Entries[i] , 0 )
     ENDIF
     (cFinfile)->( dbskip() )
 ENDDO
 (cFinfile)->(ORDSETFOCUS(cOldorder))

 Asort( a2Entries ,,, {|x,y| x[10]+x[11]+x[2] < y[10]+y[11]+y[2] } )
 Aeval( a2Entries , {|el,i| el[12] := i } )

 (cFinFile)->( DbGoTo( nSaveFinRecNo ) )
ENDIF

RETURN