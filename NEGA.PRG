
/*
 * ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 * ³         Name: Negative()            Docs: Shalom LeVine                  ³
 * ³  Description:                                                            ³
 * ³       Author: Shalom LeVine                                              ³
 * ³ Date created: 09-17-96              Date updated: ş09-17-96              ³
 * ³ Time created: 07:29:50pm            Time updated: ş07:29:50pm            ³
 * ³    Copyright: Shalom LeVine                                              ³
 * ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
 * ³    Arguments: o                                                          ³
 * ³ Return Value: lRetVal                                                    ³
 * ³     See Also:                                                            ³
 * ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 */
FUNCTION Negative( o )
LOCAL nVal
LOCAL lRetVal
IF ValType(o) == "O"
   nVal := o:varGet()
ELSE
   nVal := o
ENDIF
IF lRetVal := (nVal < 0)
   Alert( "˜…‘€ ‰Œ‰Œ™ Š˜’" , {"Enter"} )
ENDIF
RETURN lRetVal
