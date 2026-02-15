/***
* Combobox.ch
*
* Definition of @ ... GET COMBO command.
*/

#command @ <row>, <col> GET COMBO <var>                             ;
                        [SEND <msg>]                                ;
                        [COMBO <drops>]                             ;
                        [CBOCOLORS <cbocolors>]                     ;
                        [<ro: READONLY>]                            ;
      =>                                                            ;
         SetPos(<row>, <col>)                                       ;
         ; Aadd(GetList,                                            ;
              ComboGetNew({|x| iif(x == NIL, <var>, <var> := x) },  ;
                          <(var)>, <drops>,<cbocolors>, <.ro.>))                        ;
         [; ATail(GetList):<msg>]
