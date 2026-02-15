#command SET BODY RECORD SUPPRESSION <l:ON,OFF,&> =>;
         rpSuppressBody( oRP, IIF(<l> =="ON",.t.,.f.) )
#command SET BREAK BODY <l:ON,OFF,&> =>;
         rpBreakBody( oRP, IIF(<l> =="ON",.t.,.f.) )
#command SET BODY RECORD SUPPRESSION <l:ON,OFF,&> [OBJECT <oRP>]  => ;
         rpSuppressBody( IIF( <.oRP.>, <oRP>, oRP ), IIF(<(l)> =="ON",.t.,.f.) )
#command CREATE REPORT AT <t>, <l>, <b>, <r> COLOR <c> LINELEN <len> [REPOPATH <(RP)>] [DATAPATH <(DP)>] [INDEXPATH <(IP)>] [SWAPPATH <(SP)>] =>;
         oRP := rpNew(<t>,<l>,<b>,<r>,<c>,<len>,<(RP)>,<(DP)>,<(IP)>,<(SP)>)
#command ADD FIELD <fn> AT [COLUMN] <c> [JUSTIFY <jt:CENTER,LEFT,RIGHT,FULL,NONE,&> ];
         [<at:BOLD/ITALIC/UNDERSCORE,ITALIC/UNDERSCORE,BOLD/UNDERSCORE,BOLD/ITALIC,UNDERSCORE,ITALIC,BOLD,&>];
         [WIDTH <w>] [COLOR <co>] [<a:AUTOTRIM>] [DEC <nd>] [FORMAT <(fm)>] [FONT <(fnt)>] [SHADE <(sh)>] [BORDER <(br)>] [STYLE <(st)>] [BARCODE <(bc)>] =>;
         rpLFieldNew( oLine, <c>, rpRLongIndex(oRP,<(fn)>), <(fm)>, <co>, <c>+IIF(<.w.>, <w>-1, oRP\[ rpFIELDS \]\[ rpRLongIndex(oRP,<(fn)>) \]\[ rpFIELD_LEN \] ), <.a.>, <(jt)>,<(at)>,<nd>,<(fnt)>,<(sh)>,<(br)>,<st>,<bc>)

#command ADD TEXT [FIELD] <fn> AT [COLUMN] <c> [JUSTIFY <jt:CENTER,LEFT,RIGHT,FULL,NONE,&> ];
         [<at:BOLD/ITALIC/UNDERSCORE,ITALIC/UNDERSCORE,BOLD/UNDERSCORE,BOLD/ITALIC,UNDERSCORE,ITALIC,BOLD,&>];
         [WIDTH <w>] [COLOR <co>] [FORMAT <(fm)>] [FONT <(fnt)>] [SHADE <(sh)>] [BORDER <(br)>] [STYLE <(st)>] [BARCODE <(bc)>] => ;
         rpLFieldNew( oLine, <c>, rpRFldNew( oRP, "__TEXT__", "TEXT", "C", len(<fn>), 0, <fn>, "{||''}" ), <(fm)>, <co>, <c>+IIF( <.w.>, <w>-1, len(<fn>) ), .f., <(jt)>, <(at)>,,<(fnt)>, <(sh)>, <(br)>, <st>, <bc> )

#command ADD FIELD <fn> TO LINE <nl> AT [COLUMN] <c> [JUSTIFY <jt:CENTER,LEFT,RIGHT,FULL,NONE,&> ];
         [<at:BOLD/ITALIC/UNDERSCORE,ITALIC/UNDERSCORE,BOLD/UNDERSCORE,BOLD/ITALIC,UNDERSCORE,ITALIC,BOLD,&>];
         [WIDTH <w>] [COLOR <co>] [<a:AUTOTRIM>] [DEC <nd>] [FORMAT <(fm)>] [FONT <(fnt)>] [SHADE <(sh)>] [BORDER <(br)>] [STYLE <(st)>] [BARCODE <(bc)>] =>;
         rpLFieldNew( oRP\[ rpLINES \]\[ <nl> \], <c>, rpRLongIndex(oRP,<(fn)>), <(fm)>, <co>, <c>+IIF(<.w.>, <w>, oRP\[ rpFIELDS \]\[ rpRLongIndex(oRP,<(fn)>) \]\[ rpFIELD_LEN \] ),<.a.>,<(jt)>,<(at)>,<nd>,<(fnt)>,<(sh)>,<(br)>,<st>,<bc>)

#command ADD TEXT [FIELD] <fn> TO LINE <nl> AT [COLUMN] <c> [JUSTIFY <jt:CENTER,LEFT,RIGHT,FULL,NONE,&> ];
         [<at:BOLD/ITALIC/UNDERSCORE,ITALIC/UNDERSCORE,BOLD/UNDERSCORE,BOLD/ITALIC,UNDERSCORE,ITALIC,BOLD,&>];
         [WIDTH <w>] [COLOR <co>] [FORMAT <(fm)>] [FONT <(fnt)>] [SHADE <(sh)>] [BORDER <(br)>] [STYLE <(st)>] [BARCODE <(bc)>] => ;
         rpLFieldNew( oRP\[ rpLINES \]\[ <nl> \], <c>, rpRFldNew( oRP, "__TEXT__", "TEXT", "C", len(<fn>), 0, <fn>, "{||''}" ), <(fm)>, <co>, <c>+IIF( <.w.>, <w>, len(<(fn)>) ), .f.,<(jt)>,<(at)>,,<(fnt)>,<(sh)>,<(br)>,<st>,<bc>)

#command OPEN REPORT DATABASE <DB> [INDEX <IN>] [ALIAS <AL>] [VIA <RDD>] [TAG <TG>] [<NL:NOLOAD>] =>;
         rpNewDB( oRP, <(DB)>,<(AL)>,<(IN)>,<(RDD)>,<(TG)>, !<.NL.>)

#command CREATE <lt:TITLE,PAGE HEADER,BODY,PAGE FOOTER,SUMMARY> LINE ;
         [<np:NEW PAGE>] [<sh:SHOW FORMAT>] [FILTER <ex>] [COLOR <c>] =>;
         oLine := rpLineNew( oRP, <(lt)>, 0, IIF( <.np.>, .t., NIL ), IIF( <.sh.>, .t., NIL ), IIF( <.ex.>, "{|oRP|"+<"ex">+"}", NIL ), IIF( <.c.>, <c> , NIL ) )

#command SET LINES PER INCH TO <c:6, 8, &> =>;
         rpLinesPerInch( oRP, CASE({<(c)>,"8",8,6}) );

#command SET CHARACTERS PER INCH TO <c:10, 12, COMPRESSED, &> =>;
         rpCharsPerInch( oRP, CASE({<(c)>,"10",10,"12",12,16}) );

#command SET RIGHT MARGIN TO <n> [<m:COLUMNS,INCHES,CENTIMETERS,&>] =>;
         rpRightMargin( oRP, <n> )

#command SET LEFT MARGIN TO <n> [<m:COLUMNS,INCHES,CENTIMETERS,&>] =>;
         rpLeftMargin( oRP, <n> )

#command SET TOP MARGIN TO <n> [<m:COLUMNS,INCHES,CENTIMETERS,&>] =>;
         rpTopMargin( oRP, <n> )

#command SET BOTTOM MARGIN TO <n> [<m:COLUMNS,INCHES,CENTIMETERS,&>] =>;
         rpBottomMargin( oRP, <n> )


#command SET PAGE LENGTH TO <n> =>;
         rpPageLen( oRP, <n> )

#command SET ORIENTATION TO <o> =>;
         rpOrientation( oRP, IIF( <"o"> == "LANDSCAPE", rpLANDSCAPE, rpPORTRAIT ) )

#command SET EJECT LAST PAGE  <l:ON,OFF,&> =>;
         rpEjectLastPage( oRP, IIF(<(l)> =="ON",.t.,.f.) )

#command REBUILD LINES =>;
         rpRebuildDispLines( oRP )

#DEFINE rpLINES      6
#DEFINE rpFIELDS      2
#DEFINE rpFIELD_LEN             4
#DEFINE rpLANDSCAPE   2

#define GT  >

