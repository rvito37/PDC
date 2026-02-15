 // Function/Procedure Prototype Table  -  Last Update: 07-16-96 @ 01:30:53pm
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// Return Value         Function/Arguments
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// lAccessDenied        FUNCTION AccessDenied( lIsIt )
// cGroup_ID            FUNCTION GroupID( cUser )
// lRO                  FUNCTION ReadOnly( lIsIt )
// NIL                  FUNCTION SetAccessLevel( cMenu )


/*
 * ÚÄ Program ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³  Application: AVXBMS                                                     ³
 * ³    File Name: RIGHTS.PRG                                                 ³
 * ³  Description: Functions to handle user access rights in the system       ³
 * ³             :                                                            ³
 * ³             :                                                            ³
 * ³             :                                                            ³
 * ³       Author: Shalom LeVine         Tester:                              ³
 * ³ Date created: 07-16-96              Date updated: ş07-16-96              ³
 * ³ Time created: 11:45:59am            Time updated: ş11:45:59am            ³
 * ³    Make File: AVXBMS.RMK                                                 ³
 * ³    Exec File: AVXBMS.EXE            Docs By:                             ³
 * ³    DBFs/NTXs: d_user                                                     ³
 * ³             : d_rights                                                   ³
 * ³             : //d_groups                                                 ³
 * ³             :                                                            ³
 * ³             :                                                            ³
 * ³             :                                                            ³
 * ³    Copyright: (c) 1996 by AVX                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */

#include "avxdefs.ch"

#ifdef __XPP__
   #define ReadOnly isReadOnly
#endif

STATIC cGroup_ID
STATIC lAccessDenied
STATIC lRO
STATIC cPrn_ID

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: AccessDenied()        Docs:                                ³
 * ³  Description: Access/Assign for the lAccessDenied flag                   ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 07-16-96              Date updated: ş07-16-96              ³
 * ³ Time created: 11:51:25am            Time updated: ş11:51:25am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: lIsIt                                                      ³
 * ³ Return Value: lAccessDenied                                              ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION AccessDenied( lIsIt )


DEFAULT lAccessDenied TO FALSE

IF( lIsIt <> NIL, lAccessDenied := lIsIt, NIL )

RETURN lAccessDenied

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: ReadOnly()            Docs:                                ³
 * ³  Description: Access/Assign function for lRO flag                        ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 07-16-96              Date updated: ş07-16-96              ³
 * ³ Time created: 11:45:04am            Time updated: ş11:45:04am            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: lIsIt                                                      ³
 * ³ Return Value: lRO                                                        ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION ReadOnly( lIsIt )


DEFAULT lRO TO FALSE

IF( lIsIt <> NIL, lRO := lIsIt, NIL )

RETURN lRO

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: SetAccessLevel()      Docs:                                ³
 * ³  Description: Adjust the ReadOnly() and AccessDenied() statics           ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 07-16-96              Date updated: ş07-16-96              ³
 * ³ Time created: 01:23:28pm            Time updated: ş01:23:28pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: cMenu                                                      ³
 * ³ Return Value: NIL                                                        ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION SetAccessLevel( cMenu )

#define MENU_LEN 72

    IF !NetUSe( "d_rights", STD_RETRY, RDD_IN_USE, USE_SHARED, USE_NEW )
       ALERT("Unable to access file: D_RIGHTS.DBF; contact MIS.",{" OK "})
       RETURN ""
    END
    d_rights->(ordsetfocus("d_rights"))
    //SET INDEX TO d_rights
    IF d_rights->( DBSEEK( GroupID()+PADR(UPPER(cMenu), MENU_LEN) ) )
       IF UPPER(d_rights->rights) == ACCESS_RO
          ReadOnly( TRUE )
          AccessDenied( FALSE )
       ELSEIF UPPER(d_rights->rights) == ACCESS_DENIED
          ReadOnly( FALSE )
          AccessDenied( TRUE )
       END
    ELSE
       ReadOnly( FALSE )
       AccessDenied( FALSE )
    END

    CLOSE d_rights

RETURN NIL

/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: GroupID()             Docs:                                ³
 * ³  Description: Access/Assign function for the cGroup_ID                   ³
 * ³               and get NIC info, to see if user has access from that station
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 07-16-96              Date updated: ş07-16-96              ³
 * ³ Time created: 01:10:09pm            Time updated: ş01:10:09pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: cUser                                                      ³
 * ³ Return Value: cGroup_ID                                                  ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION GroupID( cUser, cNic )


DEFAULT cUSer TO "NOBODYSPECIAL"

 // initialize the Static Var
 IF cGroup_ID == NIL
    IF !NetUSe( "d_user", STD_RETRY, RDD_IN_USE, USE_SHARED, USE_NEW )
       ALERT("Unable to access file: D_USER.DBF; contact MIS.",{" OK "})
       cGroup_ID := ""
    END
    d_user->(ordsetfocus("d_user"))
    //SET INDEX TO d_user
    IF !d_user->( DBSEEK( cUser) )
       ALERT("You do not belong to any group with;"+;
             "access rights to this application;Contact MIS.",{" OK "})
       cGroup_ID :=  ""
    ELSE
       cGroup_ID := UPPER( d_user->group_id )
    ENDIF

    // added test for NIC, to see if user can access app from this station
    // but allow MIS people access from anywhere.

    IF !d_user->( DBSEEK( PADR(cUser,15)) )
      IF ALLTRIM(cGroup_ID) <> "MIS"
        ALERT("You may not access the applicaton;from this station.",{" OK "})
        CLS
        QUIT
      ENDIF
    ENDIF
    CLOSE d_user
 ENDIF

RETURN cGroup_ID

/*************************** EOF RIGHTS.PRG **********************************/