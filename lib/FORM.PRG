// Form.prg
// Function/Procedure Prototype Table  -  Last Update: 24-06-96 @ 14:54:56
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// Return Value         Function/Arguments
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// self                 METHOD cls( t , l , b, r )
// self                 METHOD hide( lMode )
// self                 METHOD init(nT,nL,nB,nR, cCaption, cColor, cProcName , lWithShadow )
// self                 METHOD say( nRow , nCol ,xVal, cPicture , cColor )
// self                 METHOD sayBottom( nRow , nCol ,xVal, cPicture , cColor )

// G:\BMS\SOURCE\FORM.PRG

#include "avxdefs.ch"

/*
 * ÚÄ Class ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: Form                                                       ³
 * ³  Description:                                                            ³
 * ³       Author: Danny Hazan                                                ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 03:50:47pm            Time updated: ş03:50:47pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³ Parent class: None                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
CREATE CLASS Form
EXPORT:

       VAR cCaption                            TYPE character
       VAR lFullScreen
       VAR aOldTitles
       VAR lWithShadow

       VAR nTop , nLeft , nBottom , nRight     TYPE int
       VAR cColor                              TYPE character
       VAR cSaveScreen                         TYPE character

       METHOD init
       METHOD say ,sayBottom
       METHOD hide
       METHOD cls

END CLASS


/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: init()                                                     ³
 * ³  Description:                                                            ³
 * ³       Author: Danny Hazan                                                ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 03:50:52pm            Time updated: ş03:50:52pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: nT                                                         ³
 * ³             : nL                                                         ³
 * ³             : nB                                                         ³
 * ³             : nR                                                         ³
 * ³             : cCaption                                                   ³
 * ³             : cColor                                                     ³
 * ³             : cProcName                                                  ³
 * ³             : lWithShadow                                                ³
 * ³ Return Value: self                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD init(nT,nL,nB,nR,  cCaption, cColor, cProcName , lWithShadow )

      IF cCaption != NIL
        ::cCaption := cCaption
      END

      DEFAULT nT TO 0 ,;
              nL TO 0 ,;
              nB TO MaxRow() - 1 ,;
              nR TO MaxCol() ,;
              cColor TO "gr+/b" ,;
              lWithShadow  TO .T.

      ::nTop           := nT
      ::nLeft          := nL
      ::nBottom        := nB
      ::nRight         := nR
      ::cColor         := cColor
      ::lWithShadow    := lWithShadow

      ::lFullScreen :=  nT =  0 .AND.            ;
                        nL =  0 .AND.            ;
                        nB =  MaxRow() - 1 .AND. ;
                        nR =  MaxCol()

      IF !::lFullScreen
         scrnPush( ::nTop , ::nLeft , ::nBottom + 1 , ::nRight + 1 )
         DispBox( ::nTop , ::nLeft , ::nBottom , ::nRight , FRAMECAPTION +" " , cColor )

         IF lWithShadow
            AddShadow( ::nTop , ::nLeft , ::nBottom , ::nRight )
         ENDIF

         IF ::cCaption != NIL
            ::say( 0, 2 , ::cCaption ,,"N/W")
         ENDIF
         ::aOldTitles := NIL
      ELSE
        scrnPush( ::nTop , ::nLeft , ::nBottom , ::nRight , .T. )
        ::aOldTitles := SetTitle( ::cCaption , cProcName )
      ENDIF

RETURN self


/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: hide()                                                     ³
 * ³  Description:                                                            ³
 * ³       Author: Danny Hazan                                                ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 03:50:57pm            Time updated: ş03:50:57pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: lMode                                                      ³
 * ³ Return Value: self                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD hide( lMode )

scrnPop( lMode )
IF !Empty( ::aOldTitles )
   OldTitle( ::aOldTitles)
ENDIF

RETURN self

/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: say()                                                      ³
 * ³  Description:                                                            ³
 * ³       Author: Danny Hazan                                                ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 03:51:01pm            Time updated: ş03:51:01pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: nRow                                                       ³
 * ³             : nCol                                                       ³
 * ³             : xVal                                                       ³
 * ³             : cPicture                                                   ³
 * ³             : cColor                                                     ³
 * ³ Return Value: self                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD say( nRow , nCol ,xVal, cPicture , cColor )

DevPos( ::nTop + nRow , ::nLeft + nCol )
IF cPicture = NIL
   DevOut( xVal , cColor )
ELSE
   DevOutPict( xVal ,cPicture,cColor )
END

RETURN self


/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: sayBottom()                                                ³
 * ³  Description:                                                            ³
 * ³       Author: Danny Hazan                                                ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 04:00:37pm            Time updated: ş04:00:37pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: nRow                                                       ³
 * ³             : nCol                                                       ³
 * ³             : xVal                                                       ³
 * ³             : cPicture                                                   ³
 * ³             : cColor                                                     ³
 * ³ Return Value: self                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD sayBottom( nRow , nCol ,xVal, cPicture , cColor )

DevPos( IF( nRow == NIL, ::nBottom, nRow ) , ::nLeft + nCol )
IF cPicture = NIL
   DevOut( xVal , cColor )
ELSE
   DevOutPict( xVal ,cPicture, cColor )
END

RETURN self


/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: cls()                                                      ³
 * ³  Description:                                                            ³
 * ³       Author: Danny Hazan                                                ³
 * ³ Date created: 06-25-96              Date updated: ş06-25-96              ³
 * ³ Time created: 03:51:04pm            Time updated: ş03:51:04pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: t                                                          ³
 * ³             : l                                                          ³
 * ³             : b                                                          ³
 * ³             : r                                                          ³
 * ³ Return Value: self                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD cls( t , l , b, r )


DEFAULT t TO ::nTop+1    ,;
        l TO ::nLeft+1   ,;
        b TO ::nBottom-1 ,;
        r TO ::nRight-1

IF ::lFullScreen
   Scroll( ::nTop+3,0,::nBottom, ::nRight )
ELSE
   Scroll(  t , l , b, ,r )
ENDIF

RETURN self

/***************************** EOF FORM.PRG *******************************/
