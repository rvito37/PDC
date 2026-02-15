#undef ERROR

#command CREATE REPORT AT <t>, <l>, <b>, <r> COLOR <c> LINELEN <len> [REPOPATH <(RP)>] [DATAPATH <(DP)>] [INDEXPATH <(IP)>] [SWAPPATH <(SP)>] =>;
         oRP := rpNew(<t>,<l>,<b>,<r>,<c>,<len>,<(RP)>,<(DP)>,<(IP)>,<(SP)>)

#command OPEN REPORT DATABASE <DB> [INDEX <IN>] [ALIAS <AL>] [VIA <RDD>] [TAG <TG>] [<NL:NOLOAD>] =>;
         rpNewDB( oRP, <(DB)>,<(AL)>,<(IN)>,<(RDD)>,<(TG)>, !<.NL.>)

#command LOAD TABLE INFO [FROM] <(c)> [DATABASE IS <(d)>] [INDEX IS <(i)>] [TAG IS <(t)>] [RDD IS <(r)>] =>;
         rpSetDB( oRP, <(d)> , <(c)> , <(i)> , <(r)>, <(t)>)

#command CREATE AUTOREPORT [USING] FIELDS <fields,...> [<l:NO BREAKS>] =>;
         rpAutoRepo( oRP, { <(fields)> }, !<.l.>)

#command RETRIEVE REPORT FROM <(r)> [OPEN <o:ALL,NONE,NEEDED,&>] => ;
         rpRetrieve( oRP, <(r)>, IIF( <.o.>, <(o)>, "") )

#command SAVE REPORT [AS <(r)>] => ;
         rpSave( oRP, IIF(<.r.>, <(r)>, "" ) )

#command SET EXACT RELATION [FROM] <(al1)> INTO <(al2)> ON <ex> [FAILURE EQUALS <f:BLANK,SKIP,TERMINATE,&>] [MATCH ON <ex2>] [MATCH LENGTH <nl>] =>;
         rpDBRelate( oRP, rpGetRDO(oRP,<(al1)>), rpGetRDO(oRP,<(al2)>), "{|oRP|"+<"ex">+"}", IIF(<.ex2.>, "{|oRP|"+<"ex2">+"}",NIL), rpREL_ONE_TO_ONE,<(f)>, .f., <nl> )

#command SET SCAN RELATION [FROM] <(al1)> INTO <(al2)> ON <ex> [FAILURE EQUALS <f:BLANK,SKIP,TERMINATE,&>] [MATCH ON <ex2>] [MATCH LENGTH <nl>] =>;
         rpDBRelate( oRP, rpGetRDO(oRP,<(al1)>), rpGetRDO(oRP,<(al2)>), "{|oRP|"+<"ex">+"}", IIF(<.ex2.>, "{|oRP|"+<"ex2">+"}",NIL), rpREL_ONE_TO_MANY,<(f)>, .f. , <nl> )

#command SET APPROXIMATE RELATION [FROM] <(al1)> INTO <(al2)> ON <ex> [FAILURE EQUALS <f:BLANK,SKIP,TERMINATE,&>] [MATCH ON <ex2>] [MATCH LENGTH <nl>] =>;
         rpDBRelate( oRP, rpGetRDO(oRP,<(al1)>), rpGetRDO(oRP,<(al2)>), "{|oRP|"+<"ex">+"}", IIF(<.ex2.>, "{|oRP|"+<"ex2">+"}",NIL), rpREL_ONE_TO_ONE,<(f)>, .t., <nl> )

#command SET RECNO RELATION [FROM] <(al1)> INTO <(al2)> ON <ex> [FAILURE EQUALS <f:BLANK,SKIP,TERMINATE,&>] [MATCH ON <ex2>] =>;
         rpDBRelate( oRP, rpGetRDO(oRP,<(al1)>), rpGetRDO(oRP,<(al2)>), "{|oRP|"+<"ex">+"}", IIF(<.ex2.>, "{|oRP|"+<"ex2">+"}",NIL), rpREL_RECNO,<(f)>, .t.)

#command CREATE DATABASE FIELD <(fn)> ALIAS <(al)> USING EXPRESSION <ex> TYPE <t> LEN <l> [DEC <d>] [LONGNAME <ln>] =>;
         rpRFldNew( oRP, <(al)>, <(fn)>, <(t)>, <l>, <d>, <(ln)>, "{|oRP|"+<"ex">+"}", 0, 0, 0, 0 )

#command CREATE CALCULATED [FIELD] <(fn)> USING EXPRESSION <ex> TYPE <t> LEN <l> [DEC <d>] [LONGNAME <ln>] =>;
         rpRFldNew( oRP, "_VIRTUAL_", <"fn">, <(t)>, <l>, <d>, <(ln)>, "{|oRP|"+<"ex">+"}", 0, 0, 0, 0 )

#command CREATE [TOTAL] <tt:SUM,COUNT,AVERAGE,LOWEST,HIGHEST,DEVIATION,VARIANCE,&> [FIELD] <fn>;
         USING EXPRESSION <ex> TYPE <t> LEN <l> [DEC <d>] [LONGNAME <ln>] ;
         RESET AT GROUP <gr> [ACCUMULATE AT <ac>] [<rt:RUNNING,PREPROCESSED,&>] =>;
         rpRFldNew( oRP, "_VIRTUAL_", <(fn)>, <(t)>, <l>, <d>, <(ln)>, "{|oRP|"+<"ex">+"}", <gr>, <(tt)>, <ac>, <(rt)> )

#command CREATE [TOTAL] <tt:SUM,COUNT,AVERAGE,LOWEST,HIGHEST,DEVIATION,VARIANCE,&> [FIELD] <fn>;
         USING EXPRESSION <ex> TYPE <t> LEN <l> [DEC <d>] [LONGNAME <ln>] ;
         GRAND TOTAL [ACCUMULATE AT <ac>] [<rt:RUNNING,PREPROCESSED,&>] =>;
         rpRFldNew( oRP, "_VIRTUAL_", <(fn)>, <(t)>, <l>, <d>, <(ln)>, "{|oRP|"+<"ex">+"}", 101, <(tt)>, <ac>, <(rt)> )

#command CREATE [TOTAL] <tt:SUM,COUNT,AVERAGE,LOWEST,HIGHEST,DEVIATION,VARIANCE,&> [FIELD] <fn>;
         USING EXPRESSION <ex> TYPE <t> LEN <l> [DEC <d>] [LONGNAME <ln>] ;
         PAGE TOTAL [ACCUMULATE AT <ac>] [<rt:RUNNING,PREPROCESSED,&>] =>;
         rpRFldNew( oRP, "_VIRTUAL_", <(fn)>, <(t)>, <l>, <d>, <(ln)>, "{|oRP|"+<"ex">+"}", 100, <(tt)>, <ac>, <(rt)> )

#command CREATE <lt:TITLE,PAGE HEADER,BODY,PAGE FOOTER,SUMMARY> LINE ;
         [<np:NEW PAGE>] [<sh:SHOW FORMAT>] [FILTER <ex>] [COLOR <c>] =>;
         oLine := rpLineNew( oRP, <(lt)>, 0, IIF( <.np.>, .t., NIL ), IIF( <.sh.>, .t., NIL ), IIF( <.ex.>, "{|oRP|"+<"ex">+"}", NIL ), IIF( <.c.>, <c> , NIL ) )

#command CREATE HEADER LINE GROUP <g> ;
         [<np:NEW PAGE>] [<sh:SHOW FORMAT>] [FILTER <ex>] [COLOR <c>] =>;
         oLine := rpLineNew( oRP, RP_HEADER, <g>, IIF( <.np.>, .t., NIL ), IIF( <.sh.>, .t., NIL ), IIF( <.ex.>, "{|oRP|"+<"ex">+"}" , NIL ), IIF( <.c.>, <c> , NIL ) )

#command CREATE FOOTER LINE GROUP <g> ;
         [<np:NEW PAGE>] [<sh:SHOW FORMAT>] [FILTER <ex>] [COLOR <c>] =>;
         oLine := rpLineNew( oRP, RP_FOOTER, <g>, IIF( <.np.>, .t., NIL ), IIF( <.sh.>, .t., NIL ), IIF( <.ex.>, "{|oRP|"+<"ex">+"}" , NIL ), IIF(<.c.>, <c> , NIL ) )

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

#command REPORT IS SORTED ON <(s1)> [<a1:ASCENDING,DESCENDING,&>] [, <(sn)> [<an:ASCENDING,DESCENDING,&>] ] =>;
         rpSortNew( oRP, rpRLongIndex(oRP, <"s1"> ), IIF( !<.a1.>, "A", IIF( <(a1)> == "ASCENDING","A","D") ) ) ;
         [;rpSortNew( oRP, rpRLongIndex(oRP, <"sn"> ), IIF( !<.an.>, "A", IIF( <(an)> == "ASCENDING","A","D") ) ) ]

#command REPORT IS GROUPED ON <(g1)> [DESCRIPTION <g1d>] [<rp1:RESET PAGENO>] [<sh1:SWAP HEADER>] [<sf1:SWAP FOOTER>] [<rh1:REPEAT HEADER>] [<nb1:NO BREAK>];
                           [, <(gn)> [DESCRIPTION <gnd>] [<rpn:RESET PAGENO>] [<shn:SWAP HEADER>] [<sfn:SWAP FOOTER>] [<rhn:REPEAT HEADER>] [<nbn:NO BREAK>]] =>;
           rpLevelNew( oRP, rpRLongIndex(oRP, <"g1"> ), IIF( !<.g1d.>, <(g1)>, <g1d> ) , <.rp1.>, <.sh1.>, <.sf1.>, <.rh1.>, !<.nb1.> ) ;
         [;rpLevelNew( oRP, rpRLongIndex(oRP, <"gn"> ), IIF( !<.gnd.>, <(gn)>, <gnd> ) , <.rpn.>, <.shn.>, <.sfn.>, <.rhn.>, !<.nbn.> ) ] ;

#command SET PAGE LENGTH TO <n> =>;
         rpPageLen( oRP, <n> )

#command SET RIGHT MARGIN TO <n> [<m:COLUMNS,INCHES,CENTIMETERS,&>] =>;
         rpRightMargin( oRP, <n> )

#command SET LEFT MARGIN TO <n> [<m:COLUMNS,INCHES,CENTIMETERS,&>] =>;
         rpLeftMargin( oRP, <n> )

#command SET TOP MARGIN TO <n> [<m:COLUMNS,INCHES,CENTIMETERS,&>] =>;
         rpTopMargin( oRP, <n> )

#command SET BOTTOM MARGIN TO <n> [<m:COLUMNS,INCHES,CENTIMETERS,&>] =>;
         rpBottomMargin( oRP, <n> )

#command SET COPIES TO <n> =>;
         rpCopies( oRP, <n> )

#command SET RECORDS ACROSS TO <n> =>;
         rpRecsAcross( oRP, <n> )

#command SET RECORD WIDTH TO <n> =>;
         rpRecWidth( oRP, <n> )

#command SET RECORD HEIGHT TO <n> [<m:LINES,INCHES,CENTIMETERS,&>] =>;
         rpRecHeight( oRP, <n> )

#command SET DESTINATION TO <c:PRINTER, DISPLAY, FILE, &> [NAMED <(nm)>] => ;
         rpDestination( oRP, CASE({<(c)>,"PRINTER",rpPRINTER,"FILE",rpPRINTER_FILE,rpDISPLAY}) );
         [;rpOutFile( oRP, <(nm)>) ]

#command SET BODY RECORD SUPPRESSION <l:ON,OFF,&> =>;
         rpSuppressBody( oRP, IIF(<l> =="ON",.t.,.f.) )

#command SET BREAK BODY <l:ON,OFF,&> =>;
         rpBreakBody( oRP, IIF(<l> =="ON",.t.,.f.) )

#command SET REPORT COLOR TO <n> =>;
         rpColor( oRP, <n> )

#command SET REPORT ACTIVE COLOR TO <n> =>;
         rpActiveColor( oRP, <n> )

#command SET REPORT MOVE COLOR TO <n> =>;
         rpMoveColor( oRP, <n> )

#command SET REPORT ERROR COLOR TO <n> =>;
         rpErrorColor( oRP, <n> )

#command SET CHARACTERS PER INCH TO <c:10, 12, COMPRESSED, &> =>;
         rpCharsPerInch( oRP, CASE({<(c)>,"10",10,"12",12,16}) );

#command SET CHARS PER INCH TO <c:10, 12, COMPRESSED, &> =>;
         rpCharsPerInch( oRP, CASE({<(c)>,"10",10,"12",12,16}) );

#command SET LINES PER INCH TO <c:6, 8, &> =>;
         rpLinesPerInch( oRP, CASE({<(c)>,"8",8,6}) );

#command SET SEMICOLON BREAK <l:ON,OFF,&> =>;
         rpSemiNewLine( oRP, IIF(<l> =="ON",.t.,.f.) )

#command SET STARTING PAGE TO <n> =>;
         rpStartPage( oRP, <n> )

#command SET ENDING PAGE TO <n> =>;
         rpEndPage( oRP, <n> )

#command REBUILD LINES =>;
         rpRebuildDispLines( oRP )

#command SAVE REPORT AS <(c)> =>;
         rpSave( oRP, <(c)> )

#command LOAD REPORT FROM <(c)> =>;
         rpRetreive( oRP, <(c)> )

#command SET JUMPSIZE TO <n> =>;
         rpJumpSize( oRP, <n> )

#command SET JUMPSTART <l:ON,OFF,&> =>;
         rpJumpStart( oRP, IIF( <(l)> == "ON", .t., .f.) )

#command SET QUERY TO <(ex)> =>;
         rpQueryTBlock( oRP, "{|oRP|"+<"ex">+"}" )

#command SET QUERY DESCRIPTION TO <(c)> =>;
         rpQueryDesc( oRP, <(c)> )

#command SET PAGE WAIT <l:ON,OFF,&> =>;
         rpPageWait( oRP, IIF(<(l)> =="ON",.t.,.f.) )

#command SET EJECT LAST PAGE  <l:ON,OFF,&> =>;
         rpEjectLastPage( oRP, IIF(<(l)> =="ON",.t.,.f.) )

#command SET SCOPE TYPE TO <(c)> =>;
         rpScopeType( oRP, <(c)> )

#command SET HIGH SCOPE TO <c> =>;
         rpScopeHigh( oRP, <c> )

#command SET LOW SCOPE TO <c> =>;
         rpScopeLow( oRP, <c> )

#command GENERATE REPORT =>;
         rpGenReport( oRP )

#command INVOKE PAINTER =>;
         rpPainter( oRP )

#command KILL SORT FILES =>;
         rpKillSorts( oRP )

#command SET REPORT PRINTER TO <(p)> [ON PORT <(r)>] => ;
         rpPrinter( oRP,  <(p)> ) ;
         [;rpOutPort( oRP, <(r)> ) ]

#command SET ORIENTATION TO <o> =>;
         rpOrientation( oRP, IIF( <"o"> == "LANDSCAPE", rpLANDSCAPE, rpPORTRAIT ) )
//
// FONT RELATED COMMANDS
//
#command ENABLE FONTS => ;
         rpUseFonts( oRP, .t. )

#command DISABLE FONTS  => ;
         rpUseFonts( oRP, .f. )

#command DEFINE FONT <(f)> FROM <t> SIZE <n> [SYMSET <s>] => ;
       	 rpFontNew( oRP, <t>, <(f)>, <(s)>, <n> )

#command SET FONT PATH TO <(c)> => ;
         rpFontPath( oRP, <(c)> )

#command SET FONT LANGUAGE TO <(c)> => ;
         rpFontLanguage( oRP,IIF(upper(<(c)>)=="PCL5",rpPCL_5,rpPCL_4))

#command SET PAPER SOURCE TO <c> => ;
         rpPaperSource( oRP, upper(<(c)>) )

#command SET PAPER SIZE TO <(c)> [OBJECT <oRP>]  => ;
         rpPaperSize( oRP, , upper(<(c)>) )

//#command SET PAPER SIZE TO <(c)> [OBJECT <oRP>]  => ;
//         rpPaperSize( oRP, ;
//                CASE({upper(<(c)>),"LETTER",rpLETTER,"LEGAL",rpLEGAL,"EXECUTIVE",rpEXEC,"A3", rpA3, "A4", rpA4, rpLETTER }) )
//
//
//#command SET PAPER SOURCE TO <c> => ;
//         rpPaperSource( oRP, ;
//                CASE({upper(<(c)>),"UPPER TRAY",rpTRAY_UPPER,"LOWER TRAY",rpTRAY_LOWER,"MANUAL FEED",rpTRAY_MANUAL, "CASSETTE/DECK", rpTRAY_DECK, rpTRAY_DEFAULT }) )
//
