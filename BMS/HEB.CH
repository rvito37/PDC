
#command @ <row>, <col> GET <var> HEB                                   ;
                        [PICTURE <pic>]                                 ;
                        [VALID <valid>]                                 ;
                        [WHEN <when>]                                   ;
                        [SEND <msg>]                                    ;
                                                                        ;
      => SetPos( <row>, <col> )                                         ;
       ; AAdd(                                                          ;
           GetList,                                                     ;
           _GET_( <var>, <(var)>, <pic>, <{valid}>, <{when}> ):display();
             )                                                          ;
       ; ATAIL(Getlist):Reader := {|x| HebReader(x)} ;
      [; ATail(GetList):<msg>];;

