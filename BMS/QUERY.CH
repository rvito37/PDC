

#DEFINE rpQUERY_MENU_EDIT             1
#DEFINE rpQUERY_MENU_CONNECT          2
#DEFINE rpQUERY_MENU_INSERT           3
#DEFINE rpQUERY_MENU_REMOVE           4
#DEFINE rpQUERY_MENU_LEFT_BRACE       5
#DEFINE rpQUERY_MENU_RIGHT_BRACE      6
#DEFINE rpQUERY_MENU_TEST             7
#DEFINE rpQUERY_MENU_RESET            8
#DEFINE rpQUERY_MENU_EXIT             9


#DEFINE rpQUERY_LINE        1
#DEFINE rpQUERY_CONNECT     2
#DEFINE rpQUERY_DISPLAY     3
#DEFINE rpQUERY_TOP         4
#DEFINE rpQUERY_LEFT        5
#DEFINE rpQUERY_BOTTOM      6
#DEFINE rpQUERY_RIGHT       7
#DEFINE rpQUERY_ACTIVE      8
#DEFINE rpQUERY_START       9

#DEFINE rpQUERY_LINE_NEW    { 0, 0, 0, { 0, NIL }, 0 }

#DEFINE rpQUERY_OPEN_PAREN        1
#DEFINE rpQUERY_FROM_RFO          2
#DEFINE rpQUERY_COMP_TYPE         3
#DEFINE rpQUERY_COMP_TO           4
#DEFINE rpQUERY_COMP_TO_RFO          1
#DEFINE rpQUERY_COMP_TO_VAL          2
#DEFINE rpQUERY_CLOSE_PAREN       5



#DEFINE rpEXACT_EQUAL_TO                1
#DEFINE rpEQUAL_TO                      2
#DEFINE rpNOT_EQUAL_TO                  3
#DEFINE rpGREATER_THAN                  4
#DEFINE rpGREATER_THAN_OR_EQUAL_TO      5
#DEFINE rpLESS_THAN                     6
#DEFINE rpLESS_THAN_OR_EQUAL_TO         7
#DEFINE rpCONTAINS                      8
#DEFINE rpEMPTY                         9
#DEFINE rpNOT_EMPTY                    10
#DEFINE rpIN_RANGE                     11
#DEFINE rpNOT_IN_RANGE                 12
#DEFINE rpBETWEEN                      13
#DEFINE rpNOT_BETWEEN                  14
#DEFINE rpIN_LIST                      15
#DEFINE rpNOT_IN_LIST                  16


static aOps := ;
               { "Exactly Equal To"         , ;
                 "Equal To"                 , ;
                 "Not Equal To"             , ;
                 "Greater Than"             , ;
                 "Greater Than Or Equal To" , ;
                 "Less Than"                , ;
                 "Less Than Or Equal To"    , ;
                 "Contains"                 , ;
                 "Empty"                    , ;
                 "Not Empty"                , ;
                 "In The Range"             , ;
                 "Not In The Range"         , ;
                 "Between"                  , ;
                 "Not Between"              , ;
                 "In The List"              , ;
                 "Not In The List"            ;
                }


static aOpsTrans := ;
               { "==" ,;
                 "="  ,;
                 "!=" ,;
                 ">"  ,;
                 ">=" ,;
                 "<"  ,;
                 "<=" ,;
                 "$"  ,;
                 "Empty( <uField> )"               ,;
                 "!Empty( <uField> )"              ,;
                 "InRange( <uField>, <uList> )"    ,;
                 "!InRange( <uField>, <uList> )"   ,;
                 "InBetween( <uField>, <uList> )"  ,;
                 "!InBetween( <uField>, <uList> )" ,;
                 "InList( <uField>, <uList> )"     ,;
                 "!InList( <uField>, <uList> )"     ;
                }


static aConnectors := { ".AND." , ;
                        ".OR. " , ;
                        ".NOT." , ;
                        "None "   ;
                      }

static nOffSet  := 0

