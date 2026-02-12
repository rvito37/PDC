/***
* Radios.ch
*
* Header file for Radio button gets.
*/

// #define K_SPACE 32
#define RADIO_BUTTON Chr(4)

#command @ <row>, <col> GET <var>                                ;
                        RADIO <radios,...>                       ;
                        [BLOCKS <blk>]                                        ;
      =>                                                         ;
         SetPos(<row>, <col>)                                    ;
         ; RadioGets({|x| iif(x == NIL, <var>, <var> := x) },    ;
                     <(var)>, <radios>, GetList , <blk>)         ;
         ; DrawRadios(GetList, Atail(GetList))
