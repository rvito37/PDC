/***
*
*  Push.ch
*
*  Header file for push button gets
*
*  Copyright (c) 1992-1993, Computer Associates International, Inc.
*  All rights reserved.
*
*/

#command @ <row>, <col> GET <var> PUSH <b>     ;
        =>                                     ;
         SetPos(<row>, <col>)                  ;
           ; Aadd(GetList,                     ;
                  PushGetNew({|x| iif(x==NIL,  ;
                             <var>, <var> := x) },    ;
                            <(var)>, <b>))            
