// partbase.prg
// Function/Procedure Prototype Table  -  Last Update: 24-06-96 @ 14:59:02
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// Return Value         Function/Arguments
// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
// ::nValue             METHOD ToValue
// NIL                  METHOD createCapacitor
// NIL                  METHOD createFilter //s.b.
// NIL                  METHOD createFuse
// NIL                  METHOD createInductor
// ::cEsn               METHOD esnNo
// self                 METHOD init(cPartType , cEsnNo)
// self                 METHOD scattar( cType )
// self                 METHOD scattarCapacitor
// self                 METHOD scattarFilter
// self                 METHOD scattarFuse
// self                 METHOD scattarInductor
// self                 METHOD setAttributes( aAttributes , aTableInd )
// NIL                  METHOD setCapSpec( cPicture )
// NIL                  METHOD setFilSpec( cPicture )
// NIL                  METHOD setFuseSpec( cPicture )
// NIL                  METHOD setIndSpec( cPicture )
// cRetVal              METHOD setProdLine
// NIL                  METHOD setSpecCode
// cRetName             METHOD setValueName
// NIL                  METHOD setValueType

// PARTBASE.PRG

#include "avxdefs.ch"


CREATE CLASS PartBase
EXPORT:

       VAR cPartType                         TYPE character

       VAR cPart                             TYPE character
       VAR cEsn                              TYPE character

/* capacitors

    00000000011111
    12345678901234
    12065J0R2FAWTR

*/
       VAR cVoltage                         TYPE character     //  5  5  1
       VAR cVoltageName                     TYPE character     //  5  5  1
       VAR cTemperatureCoefficient          TYPE character     //  6  6  1
       VAR cDiel
       VAR cCapacitance                     TYPE character     //  7  9  3

//   fuses
/*
     00000000011111
     12345678901234
     F1206A0R20FWTR
*/
       VAR cFuseType                       TYPE character      //  6  6  1
       VAR cCurrentRating                  TYPE character      //  7 10  4


//   inductors
/*
     0000000001111
     1234567890123
     L08052R7DEWTR
*/
       VAR cInductance                     TYPE character
       VAR cAccuLTech

/* Filter    //s.b.
*/

       VAR cFilterType                     TYPE character      //  7  7  1
       VAR cFrequency                      TYPE character      //  8 11  4
       VAR cDummyCode                      TYPE character      //  12 12  1

       VAR cCouplerType                    TYPE character       //  7  7  1
       VAR cResonatorType                  TYPE character       //  7  7  1
       VAR cKitsType                       TYPE character       //  7  7  1
       VAR cMatchType                      TYPE character       //  7  7  1
       VAR cSolgelType                     TYPE character       //  7  7  1

// common properties
       VAR cSize                           TYPE character
       VAR cTolerance                      TYPE character
       VAR cSpecificationCode              TYPE character
       VAR cValue                          TYPE character
       VAR nValue                          TYPE numeric
       VAR cTerminationCode                TYPE character
       VAR cPackgingCode                   TYPE character

       VAR cProductLine                    TYPE character

       VAR cEsnNo                          TYPE character
       VAR cEsnPacking                     TYPE character

       VAR aLineTab , aVoltNames


       METHOD init
       METHOD esnNo
       METHOD createCapacitor
       METHOD createFuse
       METHOD createInductor
       METHOD createFilter
       METHOD createCoupler
       METHOD createResonator
       METHOD createKits
       METHOD createMatch
       METHOD createSolgel              // 14/06/00
       METHOD createOther

       METHOD scattarCapacitor
       METHOD scattarFuse
       METHOD scattarInductor
       METHOD scattarFilter
       METHOD scattarCoupler
       METHOD scattarResonator
       METHOD scattarKits
       METHOD scattarMatch
       METHOD scattarSolgel             // 14/06/00
       METHOD scattarOther

       METHOD setAttributes
       METHOD SetAccuLtech

       METHOD scattar
       METHOD setValueType , setSpecCode
       METHOD ToValue
       METHOD ToMyValue
       METHOD setProdLine

       METHOD setCapSpec , setFuseSpec , setIndSpec, setSolSpec // 14/06/00
       METHOD setCopSpec , setResSpec, setKitsSpec,setMatchSpec
       METHOD SetFilSpec
       METHOD setValueName
       METHOD NewAccuLTech

END CLASS


/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: init()                                                     ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 09-10-96              Date updated: þ09-10-96              ³
 * ³ Time created: 04:17:03pm            Time updated: þ04:17:03pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: cPartType                                                  ³
 * ³             : cEsnNo                                                     ³
 * ³ Return Value: self                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD init(cPartType , cEsnNo)
LOCAL nSelect := Select( Alias() )
LOCAL oTab := TabBase():new( "c_pline" )

oTab:xopen()
SELECT c_pline
::aLineTab := {}
c_pline->( DbGoTop() )
WHILE !c_pline->( Eof() )
    Aadd( ::aLineTab , { c_pline->pline_id , c_pline->pline_pic , c_pline->ptype_id } )
    c_pline->( DbSkip() )
ENDDO
oTab:close()

::aVoltNames := {}
oTab := TabBase():new( "c_volt" )
oTab:xopen()
c_volt->( DbGoTop() )
WHILE !c_volt->( Eof() )
      Aadd( ::aVoltNames , { c_volt->volt_id , c_volt->volt_nm } )
      c_volt->( DbSkip() )
ENDDO
oTab:close()


SELECT (nSelect)
RETURN self

/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: setAttributes()                                            ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 09-10-96              Date updated: þ09-10-96              ³
 * ³ Time created: 04:17:00pm            Time updated: þ04:17:00pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: aAttributes                                                ³
 * ³             : aTableInd                                                  ³
 * ³ Return Value: self                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD setAttributes( aAttributes , aTableInd )

IF aTableInd[PTYPE]
  ::cPartType := aAttributes[PTYPE,2]
ELSE
  ::cPartType := ""
ENDIF

IF aTableInd[PLINE]
  ::cProductLine := aAttributes[PLINE,2]
  ::setSpecCode()
ELSE
  ::cProductLine := ""
ENDIF

IF aTableInd[SIZE]
   ::cSize := aAttributes[SIZE,2]
ELSE
   ::cSize := ""
ENDIF

IF aTableInd[VALUE]
   ::cValue := aAttributes[VALUE,3]
   ::nValue := aAttributes[VALUE,2]
   ::cValue := ::SetValueName()
   ::setValueType()
ELSE
   ::cValue := ""
ENDIF

IF aTableInd[TOL]
   ::cTolerance := aAttributes[TOL,2]
ELSE
   ::cTolerance := ""
ENDIF

IF aTableInd[TERM]
   ::cTerminationCode := aAttributes[TERM,2]
ELSE
   ::cTerminationCode := ""
ENDIF

IF aTableInd[TC]
   ::cTemperatureCoefficient := aAttributes[TC,2]
ELSE
   ::cTemperatureCoefficient := ""
ENDIF

IF aTableInd[VOLT]
   ::cVoltage  := aAttributes[VOLT,2]
ELSE
   ::cVoltage := ""
ENDIF

IF aTableInd[ESNXX]
   ::cEsnNo := aAttributes[ESNXX,2]
ELSE
   ::cEsnNo := ""
ENDIF

IF aTableInd[ESNY]
   ::cEsnPacking := aAttributes[ESNY,2]
ELSE
   ::cEsnPacking := ""
ENDIF

RETURN self

/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: esnNo                                                      ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 09-10-96              Date updated: þ09-10-96              ³
 * ³ Time created: 04:17:18pm            Time updated: þ04:17:18pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: ::cEsn                                                     ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD esnNo
DO CASE
   CASE ::cPartType = "C"
        ::createCapacitor("esn")
   CASE ::cPartType = "F"
        ::createFuse("esn")
   CASE ::cPartType = "L"
        ::createInductor("esn")
   CASE ::cPartType = "T"
        ::createFilter("esn")
   CASE ::cPartType = "U"
        ::createCoupler("esn")
   CASE ::cPartType = "S"
        ::createResonator("esn")
   CASE ::cPartType = "K"
        ::createKits("esn")
   CASE ::cPartType = "M"
        ::createMatch("esn")
   CASE ::cPartType = "W"      //s.s.
        ::createSolgel("esn")

   OTHERWISE
        ::createOther("esn")

END
RETURN ::cEsn

/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: createCapacitor                                            ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 09-10-96              Date updated: þ09-10-96              ³
 * ³ Time created: 04:17:21pm            Time updated: þ04:17:21pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: NIL                                                        ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD createCapacitor

 ::cEsn :=  ::cSize + ::cVoltage + ::cTemperatureCoefficient + ;
          Left(::cCapacitance,3) + ::cTolerance + ::cSpecificationCode +;
          ::cTerminationCode + ::cEsnNo + ::cEsnPacking

RETURN NIL


/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: createFuse                                                 ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 09-10-96              Date updated: þ09-10-96              ³
 * ³ Time created: 04:17:25pm            Time updated: þ04:17:25pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: NIL                                                        ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD createFuse

 ::cEsn :=  "F"+ ::cSize + ::cFuseType + Left(::cCurrentRating,4) + ;
          ::cSpecificationCode + ::cTerminationCode + ;
          ::cEsnNo + ::cEsnPacking

RETURN NIL


/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: createInductor                                             ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 09-10-96              Date updated: þ09-10-96              ³
 * ³ Time created: 04:17:29pm            Time updated: þ04:17:29pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: NIL                                                        ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD createInductor
 ::cEsn :=  ::cSpecificationCode + ::cSize + Left(::cInductance,3) +;
          ::cTolerance + ::cAccuLTech + ::cTerminationCode + ::cEsnNo + ;
          ::cEsnPacking
RETURN NIL

METHOD createFilter          //s.b.
 ::cEsn :=  ::cSpecificationCode + ::cSize + ::cFilterType +;
            Left(::cFrequency,4) + ::cDummyCode + ;
            ::cTerminationCode + ::cEsnNo + ::cEsnPacking
RETURN NIL

METHOD createCoupler          //s.b.
 ::cEsn :=  ::cSpecificationCode + ::cSize + ::cCouplerType +;
            Left(::cFrequency,4) + ::cDummyCode + ;
            ::cTerminationCode + ::cEsnNo + ::cEsnPacking
RETURN NIL

METHOD createResonator          //s.b.
 ::cEsn :=  ::cSpecificationCode + ::cSize + ::cResonatorType +;
            Left(::cFrequency,4) + ::cTolerance + ;
            ::cTerminationCode + ::cEsnNo + ::cEsnPacking
RETURN NIL

METHOD createSolgel           //s.s.
 ::cEsn :=  ::cSpecificationCode + ::cProductLine+ ::cSize +;
            ::cSolType + ::cEsnNo + ::cEsnPacking
RETURN NIL

METHOD createKits          //s.b.
 ::cEsn :=  ::cSpecificationCode + ::cProductLine+ ::cSize +;
            ::cKitsType + ::cEsnNo + ::cEsnPacking
RETURN NIL

METHOD createMatch          //s.b.
 ::cEsn :=  ::cSpecificationCode + ::cProductLine +;
            ::cMatchtype + ::cEsnNo + ::cEsnPacking
RETURN NIL

METHOD createOther
 ::cEsn :=  ::cESN
RETURN NIL

/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: setValueType                                               ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 09-10-96              Date updated: þ09-10-96              ³
 * ³ Time created: 04:17:31pm            Time updated: þ04:17:31pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: NIL                                                        ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD setValueType
LOCAL cTemp , nIntPart

/*
 ::cValue := AllTrim( ::cValue )
::nValue := Val(::cValue)
cTemp := ::setValueName()

IF Empty( cTemp )
   IF ::cPartType == "T"
      ::cValue := StrZero( ::cValue )
   ELSE
      nIntPart := Int( ::nValue )
      DO CASE
         CASE nIntPart > 99
              ::cValue := Str( nIntPart+1 , 3 )
         CASE nIntPart > 9
              ::cValue := Str( nIntPart , 2 ) + "0"
         //CASE nIntPart > 1
         //CASE nIntPart < 1
         OTHERWISE
              ::cValue := StrTran( ::cValue , "." , "R" )
      ENDCASE
   ENDIF
ELSE
   ::cValue := cTemp
ENDIF
*/

DO CASE
   CASE ::cPartType == "C"
        ::cCapacitance := ::cValue
   CASE ::cPartType == "F"
        ::cCurrentRating := ::cValue
   CASE ::cPartType == "L"
        ::cInductance := ::cValue
   CASE ::cPartType == "T"
        ::cFrequency := ::cValue
   CASE ::cPartType == "U"
        ::cFrequency := ::cValue
   CASE ::cPartType == "S"
        ::cFrequency := ::cValue
ENDCASE
RETURN NIL

/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: setSpecCode                                                ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 09-10-96              Date updated: þ09-10-96              ³
 * ³ Time created: 04:17:39pm            Time updated: þ04:17:39pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: NIL                                                        ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD setSpecCode
LOCAL nPos

nPos := Ascan( ::aLineTab , {|el|el[1]==::cProductLine } )

IF nPos > 0
   DO CASE
      CASE ::cPartType == "C"
           ::setCapSpec( ::aLineTab[nPos,2] )
      CASE ::cPartType == "F"
           ::setFuseSpec( ::aLineTab[nPos,2] )
      CASE ::cPartType == "L"
           ::setIndSpec( ::aLineTab[nPos,2] )
      CASE ::cPartType == "T"
           ::setFilSpec( ::aLineTab[nPos,2] )
      CASE ::cPartType == "U"
           ::setCopSpec( ::aLineTab[nPos,2] )
      CASE ::cPartType == "S"
           ::setResSpec( ::aLineTab[nPos,2] )
      CASE ::cPartType == "K"
           ::setKitsSpec( ::aLineTab[nPos,2] )
      CASE ::cPartType == "W"
           ::setSolSpec( ::aLineTab[nPos,2] )
      CASE ::cPartType == "M"
           ::setMatchSpec( ::aLineTab[nPos,2] )
      OTHERWISE
         ::cSpecificationCode := ""
   ENDCASE
ELSE
    Alert( "Product line "+::cProductLine+" not found" , {"Enter"} )
    ::cSpecificationCode := "@"
ENDIF

RETURN NIL

/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: scattar()                                                  ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 09-10-96              Date updated: þ09-10-96              ³
 * ³ Time created: 04:17:44pm            Time updated: þ04:17:44pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: cType                                                      ³
 * ³ Return Value: self                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD scattar( cType )
LOCAL lOpenHere := FALSE
LOCAL nOrd,cEsn

IF SELECT("D_ESN") == 0
   GENOPENFILES({"D_ESN"})
   lOpenHere :=  TRUE //YGFALSE
ENDIF
nOrd :=  d_esn->(indexord())    //YG
D_ESN->(ordSetFocus("iesn_id"))
IF D_ESN->(DBSEEK(::cESN))
/*
DO CASE
   CASE D_ESN->ptype_id == "T"    //s.b.
        ::scattarFilter( cType )
   CASE D_ESN->ptype_id == "U"    //s.b.
        ::scattarCoupler( cType )
   CASE D_ESN->ptype_id == "S"    //s.b.
        ::scattarResonator( cType )
   CASE D_ESN->ptype_id == "K"    //s.b.
        ::scattarKits( cType )
   CASE D_ESN->ptype_id == "M"    //s.b.
        ::scattarMatch( cType )
   CASE D_ESN->ptype_id == "F"    //s.b.
        ::scattarFuse( cType )
   CASE D_ESN->ptype_id == "L"    //s.b.
        ::scattarInductor( cType )
   CASE D_ESN->ptype_id == "C"    //s.b.
       ::scattarCapacitor( cType )
  OTHERWISE
       ::scattarOTHER( cType )
END
*/

       ::scattarOTHER( cType )
ELSE

DO CASE
   CASE Left( ::cEsn ,2 ) == "LP"    //s.b.
        ::scattarFilter( cType )
   CASE Left( ::cEsn ,2 ) == "CP"    //s.b.
        ::scattarCoupler( cType )
   CASE Left( ::cEsn ,2 ) == "RS"    //s.b.
        ::scattarResonator( cType )
   CASE Left( ::cEsn ,3 ) == "KIT"    //s.b.
        ::scattarKits( cType )
   CASE Left( ::cEsn ,3 ) == "MAT"    //s.b.
        ::scattarMatch( cType )
   CASE Left( ::cEsn ,3 ) == "SOL"    //s.s.
        ::scattarSolgel( cType )
   CASE Left( ::cEsn ,1 ) == "F"
        ::scattarFuse( cType )
   CASE Left( ::cEsn ,1 ) == "L"
        ::scattarInductor( cType )
   OTHERWISE
       ::scattarCapacitor( cType )
END
ENDIF

D_ESN->(OrdsetFocus(nOrd))
IF lOpenHere
   GencloseFiles({"D_ESN"})
ENDIF

RETURN self

/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: scattarFuse                                                ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 09-10-96              Date updated: þ09-10-96              ³
 * ³ Time created: 04:17:48pm            Time updated: þ04:17:48pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: self                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD scattarFuse

       ::cPartType := "F"
       ::cSize                      := SubStr( ::cEsn, 2 ,4 )
       ::cFuseType                  := SubStr( ::cEsn, 6 ,1 )
       ::cValue := ::cCurrentRating := SubStr( ::cEsn, 7 ,4 )
       ::cSpecificationCode         := SubStr( ::cEsn, 11 ,1 )
       ::cTerminationCode           := SubStr( ::cEsn, 12 ,1 )
       ::cEsnNo                     := SubStr( ::cEsn, 13 ,2 )
       ::cEsnPacking                := SubStr( ::cEsn, 15 ,1 )
       ::toValue()
       ::setProdLine()
RETURN self

/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: scattarInductor                                            ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 09-10-96              Date updated: þ09-10-96              ³
 * ³ Time created: 04:17:51pm            Time updated: þ04:17:51pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: self                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD scattarInductor

       ::cPartType := "L"
       ::cSize                      := SubStr( ::cEsn, 2 ,4 )
       ::cValue := ::cInductance    := SubStr( ::cEsn, 6 ,3 )
       ::cTolerance                 := SubStr( ::cEsn, 9 ,1 )
       ::cSpecificationCode         := SubStr( ::cEsn, 1 ,1 )
       // added 10-09 by Shalom
       ::cAccuLTech                 := SubStr( ::cEsn, 10 ,1 )
       //
       ::cTerminationCode           := SubStr( ::cEsn, 11 ,1 )
       ::cEsnNo                     := SubStr( ::cEsn, 12 ,2 )
       ::cEsnPacking                := SubStr( ::cEsn, 14 ,1 )
       //::SetIndSpec()
       ::toValue()
       ::setProdLine()
RETURN self

/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: scattarFilter                                              ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 09-10-96              Date updated: þ09-10-96              ³
 * ³ Time created: 04:17:58pm            Time updated: þ04:17:58pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: self                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD scattarFilter

       ::cPartType := "T"
       ::cSize                      := SubStr( ::cEsn, 3 ,4 )
       ::cValue := ::cFrequency     := SubStr( ::cEsn, 8 ,4 )
       ::cSpecificationCode         := SubStr( ::cEsn, 1 ,2 )
       ::cTerminationCode           := SubStr( ::cEsn, 13 ,1 )
       ::cEsnNo                     := SubStr( ::cEsn, 14 ,2 )
       ::cEsnPacking                := SubStr( ::cEsn, 16 ,1 )
       ::toValue()
       ::setFilSpec( ::cEsn )
       ::setProdLine()
RETURN self

METHOD scattarCoupler

       ::cPartType := "U"
       ::cSize                      := SubStr( ::cEsn, 3 ,4 )
       ::cValue := ::cFrequency     := SubStr( ::cEsn, 8 ,4 )
       ::cSpecificationCode         := SubStr( ::cEsn, 1 ,2 )
       ::cTerminationCode           := SubStr( ::cEsn, 13 ,1 )
       ::cEsnNo                     := SubStr( ::cEsn, 14 ,2 )
       ::cEsnPacking                := SubStr( ::cEsn, 16 ,1 )
       ::toValue()
       ::setCopSpec(::cEsn)
       ::setProdLine()
RETURN self

METHOD scattarResonator

       ::cPartType := "S"
       ::cSize                      := SubStr( ::cEsn, 3 ,4 )
       ::cValue := ::cFrequency     := SubStr( ::cEsn, 8 ,4 )
       ::cTolerance                 := SubStr( ::cEsn, 12 ,1 )
       ::cSpecificationCode         := SubStr( ::cEsn, 1 ,2 )
       ::cTerminationCode           := SubStr( ::cEsn, 13 ,1 )
       ::cEsnNo                     := SubStr( ::cEsn, 14 ,2 )
       ::cEsnPacking                := SubStr( ::cEsn, 16 ,1 )
       ::toValue()
       ::setProdLine()
RETURN self

METHOD scattarKits
       ::cPartType := "K"
       ::cSize                      := SubStr( ::cEsn, 7 ,4 )
       ::cSpecificationCode         := SubStr( ::cEsn, 1 ,3 )
       ::cKitsType                  := SubStr( ::cEsn, 11 ,1 )
       ::cEsnNo                     := SubStr( ::cEsn, 12 ,2 )
       ::cEsnPacking                := SubStr( ::cEsn, 14 ,1 )
       ::setProdLine()
RETURN self

METHOD scattarSolgel
       ::cPartType := "W"
       ::cSpecificationCode         := SubStr( ::cEsn, 1 ,3 )
       ::cSize                      := SubStr( ::cEsn, 7 ,4 )
       ::cSolgelType                := SubStr( ::cEsn, 11 ,1 )
       ::cEsnNo                     := SubStr( ::cEsn, 12 ,2 )
       ::cEsnPacking                := SubStr( ::cEsn, 14 ,1 )
       ::setProdLine()
RETURN self

METHOD scattarMatch

       ::cPartType := "M"
       ::cSpecificationCode         := SubStr( ::cEsn, 1 ,7 )
       ::cEsnNo                     := SubStr( ::cEsn, 12 ,2 )
       ::cMatchType                  := SubStr( ::cEsn, 11 ,1 )
       ::cEsnPacking                := SubStr( ::cEsn, 14 ,1 )
       ::setProdLine()
RETURN self

METHOD scattarOther

       ::cPartType                  := D_ESN->Ptype_ID
       ::cProductLine               := D_ESN->PLINE_ID
       ::cSize                      := D_ESN->SIZE_ID
       ::cVoltage                   := D_ESN->VOLT_ID
       ::cTemperatureCoefficient    := D_ESN->TC_ID
       ::cValue := ::cCapacitance   := STR(D_ESN->value_id,9,3)
       ::nValue                     := D_ESN->VALUE_ID
       ::cTolerance                 := D_ESN->TOL_ID
       ::cEsnNo                     := D_ESN->ESNXX_ID
       ::cEsnPacking                := D_ESN->ESNY_ID
       ::cTerminationCode           := D_ESN->TERM_ID
//       ::ToMyValue()
       ::cValue := ::setValueName()

RETURN self
/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: scattarCapacitor                                           ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 09-10-96              Date updated: þ09-10-96              ³
 * ³ Time created: 04:18:01pm            Time updated: þ04:18:01pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: self                                                       ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD scattarCapacitor
LOCAL nPos

       ::cPartType := "C"
       ::cSize                      := SubStr( ::cEsn, 1 ,4 )
       ::cVoltage                   := SubStr( ::cEsn, 5 ,1 )
       ::cTemperatureCoefficient    := SubStr( ::cEsn, 6 ,1 )
       ::cValue := ::cCapacitance   := SubStr( ::cEsn, 7 ,3 )
       ::cTolerance                 := SubStr( ::cEsn, 10 ,1 )
       ::cSpecificationCode         := SubStr( ::cEsn, 11 ,1 )
       ::cTerminationCode           := SubStr( ::cEsn, 12 ,1 )
       ::cEsnNo                     := SubStr( ::cEsn, 13 ,2 )
       ::cEsnPacking                := SubStr( ::cEsn, 15 ,1 )
       nPos := Ascan( ::aVoltNames , {| el | el[1] == ::cVoltage} )
       DO CASE
          CASE ::cTemperatureCoefficient == "J"
               ::cDiel := "S"
          CASE ::cTemperatureCoefficient == "K"
               ::cDiel := "N"
          OTHERWISE
               ::cDiel := " "
       ENDCASE
       IF nPos > 0
          ::cVoltageName := ::aVoltNames[nPos,2]
       ELSE
          ::cVoltageName := "???v"
       END
       ::toValue()
       ::setProdLine()
RETURN self

/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: ToValue                                                    ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 09-10-96              Date updated: þ09-10-96              ³
 * ³ Time created: 04:18:07pm            Time updated: þ04:18:07pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: ::nValue                                                   ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD ToValue
::nValue := Val( StrTran( ::cValue , "R" , "." ) )
RETURN ::nValue

METHOD ToMyValue
::nValue := Val(::cValue)
::cValue := StrTran( ::cValue, ".", "R" )
RETURN ::nValue


/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: setProdLine                                                ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 09-10-96              Date updated: þ09-10-96              ³
 * ³ Time created: 04:18:10pm            Time updated: þ04:18:10pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: cRetVal                                                    ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD setProdLine
LOCAL cRetVal
LOCAL nPos
LOCAL KitKat

DO CASE
   CASE ::cPartType  == "C"
         // added test for termination code 14-12-97 Shalom to fix new line
        nPos := Ascan( ::aLineTab , {|el| el[3] == "C" .AND. SubStr(el[2],11,2) == ::cSpecificationCode+::cTerminationCode } )
   CASE ::cPartType  == "F"
        nPos := Ascan( ::aLineTab , {|el| el[3] == "F" .AND. SubStr(el[2],6,1) == ::cFuseType } )
   CASE ::cPartType  == "L"
        nPos := Ascan( ::aLineTab , {|el| el[3] == "L" .AND. SubStr(el[2],10,1) == ::cAccuLTech } )
   CASE ::cPartType  == "T"
        nPos := Ascan( ::aLineTab , {|el| el[3] == "T" .AND. SubStr(el[2],7,1) == ::cFilterType .AND. SubStr(el[2],13,1) == ::cTerminationCode } )
   CASE ::cPartType  == "U"
        nPos := Ascan( ::aLineTab , {|el| el[3] == "U" .AND. SubStr(el[2],7,1) == ::cCouplerType .AND. SubStr(el[2],12,1) == ::cDummyCode } )
   CASE ::cPartType  == "S"
        nPos := Ascan( ::aLineTab , {|el| el[3] == "S" .AND. SubStr(el[2],7,1) == ::cResonatorType } )
   CASE ::cPartType  == "K"
        KitKat := substr( ::cEsn,5,2 )
        nPos := Ascan( ::aLineTab , {|el| el[3] == "K" .AND. SubStr(el[2],5,2) == KitKat } )
   CASE ::cPartType  == "M"
        nPos := Ascan( ::aLineTab , {|el| el[3] == "M" .AND. SubStr(el[2],1,1) == ::cPartType } )
   CASE ::cPartType  == "W"
        nPos := Ascan( ::aLineTab , {|el| el[3] == "W" .AND. SubStr(el[2],11,1) == ::cSolgelType } )
END

IF nPos > 0
   ::cProductLine := ::aLineTab[nPos , 1 ]
ELSE
   ::cProductLine := "***"
END


RETURN cRetVal


/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: setCapSpec()                                               ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 09-10-96              Date updated: þ09-10-96              ³
 * ³ Time created: 04:18:13pm            Time updated: þ04:18:13pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: cPicture                                                   ³
 * ³ Return Value: NIL                                                        ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD setCapSpec( cPicture )
::cSpecificationCode := SubStr( cPicture , 11 , 1 )
RETURN NIL

/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: setFuseSpec()                                              ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 09-10-96              Date updated: þ09-10-96              ³
 * ³ Time created: 04:18:16pm            Time updated: þ04:18:16pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: cPicture                                                   ³
 * ³ Return Value: NIL                                                        ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD setFuseSpec( cPicture )
::cFuseType          := SubStr( cPicture , 6 , 1 )
::cSpecificationCode := SubStr( cPicture , 11 , 1 ) // dummy character
RETURN NIL

/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: setFilSpec()                                               ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 09-10-96              Date updated: þ09-10-96              ³
 * ³ Time created: 04:18:19pm            Time updated: þ04:18:19pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: cPicture                                                   ³
 * ³ Return Value: NIL                                                        ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD setFilSpec( cPicture )
::cFilterType        := SubStr( cPicture , 7 , 1 )
::cSpecificationCode := SubStr( cPicture , 1 , 2 )
::cDummyCode         := SubStr( cPicture , 12 , 1 ) // dummy character
RETURN NIL

METHOD setCopSpec( cPicture )
::cCouplerType        := SubStr( cPicture , 7 , 1 )
::cSpecificationCode  := SubStr( cPicture , 1 , 2 )//"CP" VR 27-02-03
// no longer a dummy char, needed for new lines
::cDummyCode         :=  SubStr( cPicture , 12 , 1 )
RETURN NIL

METHOD setResSpec( cPicture )
::cResonatorType        := SubStr( cPicture , 7 , 1 )
::cSpecificationCode := "RS"
RETURN NIL

METHOD setKitsSpec( cPicture )
::cKitsType        := SubStr( cPicture , 11 , 1 )
::cSpecificationCode := "KIT"
RETURN NIL

METHOD setSolSpec( cPicture )
::cSolgelType        := SubStr( cPicture , 11 , 1 )
::cSpecificationCode := "SOL"
RETURN NIL

METHOD setMatchSpec( cPicture )
::cMatchType        := SubStr( cPicture , 11 , 1 )
::cSpecificationCode := "MATCHBK"
RETURN NIL
/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: setIndSpec()                                               ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 09-10-96              Date updated: þ09-10-96              ³
 * ³ Time created: 04:18:25pm            Time updated: þ04:18:25pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: cPicture                                                   ³
 * ³ Return Value: NIL                                                        ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD setIndSpec( cPicture )
::cSpecificationCode := "L"
::cAccuLTech := SubStr( cPicture , 10 , 1 )
RETURN NIL

/*
 * ÚÄ Method ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: setValueName                                               ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 09-10-96              Date updated: þ09-10-96              ³
 * ³ Time created: 04:18:30pm            Time updated: þ04:18:30pm            ³
 * ³    Copyright: AVX                                                        ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: None                                                       ³
 * ³ Return Value: cRetName                                                   ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
METHOD setValueName
LOCAL cRetName
LOCAL nSelect := Select( Alias() )
LOCAL oTab := TabBase():new( "c_value" )
oTab:setIndexList()
oTab:xopen()
oTab:setorder("ivalpr")

IF c_value->( DbSeek( Str(::nValue,9,3) + ::cPartType ) )
   cRetName := Alltrim( c_value->value_nm )
ELSE
   cRetName := ""
ENDIF

oTab:close()
SELECT (nSelect)
RETURN cRetName

// Created 11-12 by Steve!!!
METHOD SetAccuKit
::cAccuKit := SUBSTR(::cEsn, 5, 2 )
RETURN self

// Created 17-09 by Shalom, it's called twice from AVXPDC, but didn't exists
METHOD SetAccuLtech
::cAccuLtech := SUBSTR(::cEsn, 10, 1 )
RETURN self

METHOD NewAccuLTech

LOCAL nPos

nPos := Ascan( ::aLineTab , {|el| el[1] == ::cProductLine } )

IF nPos > 0
   DO CASE
      CASE ::cPartType == "L"
			  ::cAccuLTech := SubStr( ::aLineTab[nPos,2] , 10 , 1 )
   ENDCASE
ELSE
   ::cAccuLTech := "@"
ENDIF

RETURN self