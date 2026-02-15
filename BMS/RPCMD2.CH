#undef ERROR

#command CREATE REPORT [OBJECT <oRP>] AT <t>, <l>, <b>, <r> COLOR <c> LINELEN <len> [REPOPATH <(RP)>] [DATAPATH <(DP)>] [INDEXPATH <(IP)>] [SWAPPATH <(SP)>] =>;
         IIF(<.oRP.>,<oRP>,oRP) := rpNew(<t>,<l>,<b>,<r>,<c>,<len>,<(RP)>,<(DP)>,<(IP)>,<(SP)>)

#command OPEN REPORT DATABASE <DB> [INDEX <IN>] [ALIAS <AL>] [VIA <RDD>] [TAG <TG>] [<NL:NOLOAD>] [OBJECT <oRP>] =>;
         rpNewDB( IIF( <.oRP.>, <oRP>, oRP ), <(DB)>,<(AL)>,<(IN)>,<(RDD)>,<(TG)>, !<.NL.>)

#command LOAD TABLE INFO [FROM] <(c)> [DATABASE IS <(d)>] [INDEX IS <(i)>] [TAG IS <(t)>] [RDD IS <(r)>] [OBJECT <oRP>] =>;
         rpSetDB( IIF(<.oRP.>,<oRP>,oRP), <(d)> , <(c)> , <(i)>, <(r)>, <(t)> )

#command CREATE AUTOREPORT [USING] FIELDS <fields,...> [<l:NO BREAKS>] [OBJECT <oRP>] =>;
         rpAutoRepo( IIF(<.oRP.>,<oRP>,oRP), { <(fields)> }, !<.l.>)

#command RETRIEVE REPORT FROM <(r)> [OPEN <o:ALL,NONE,NEEDED,&>] [OBJECT <oRP>]  => ;
         rpRetrieve(IIF(<.oRP.>,<oRP>,oRP), <(r)>, IIF( <.o.>, <(o)>, "") )

#command SAVE REPORT [AS <(r)>] [OBJECT <oRP>]  => ;
         rpSave(IIF(<.oRP.>,<oRP>,oRP), IIF(<.r.>, <(r)>, "" ) )

#command SET EXACT RELATION [FROM] <(al1)> INTO <(al2)> ON <ex> [FAILURE EQUALS <f:BLANK,SKIP,TERMINATE,&>] [MATCH ON <ex2>] [MATCH LENGTH <nl>] [OBJECT <oRP>] =>;
         rpDBRelate( IIF(<.oRP.>,<oRP>,oRP), rpGetRDO( IIF( <.oRP.>, <oRP>, oRP ),<(al1)>), rpGetRDO( IIF( <.oRP.>, <oRP>, oRP ),<(al2)>), "{|oRP|"+<"ex">+"}", IIF(<.ex2.>, "{|oRP|"+<"ex2">+"}",NIL), rpREL_ONE_TO_ONE,<(f)>, .f., <nl> )

#command SET SCAN RELATION [FROM] <(al1)> INTO <(al2)> ON <ex> [FAILURE EQUALS <f:BLANK,SKIP,TERMINATE,&>] [MATCH ON <ex2>] [MATCH LENGTH <nl>] [OBJECT <oRP>] =>;
         rpDBRelate( IIF(<.oRP.>,<oRP>,oRP), rpGetRDO( IIF( <.oRP.>, <oRP>, oRP ),<(al1)>), rpGetRDO( IIF( <.oRP.>, <oRP>, oRP ),<(al2)>), "{|oRP|"+<"ex">+"}", IIF(<.ex2.>, "{|oRP|"+<"ex2">+"}",NIL), rpREL_ONE_TO_MANY,<(f)>, .f. , <nl> )

#command SET APPROXIMATE RELATION [FROM] <(al1)> INTO <(al2)> ON <ex> [FAILURE EQUALS <f:BLANK,SKIP,TERMINATE,&>] [MATCH ON <ex2>] [MATCH LENGTH <nl>] [OBJECT <oRP>] =>;
         rpDBRelate( IIF(<.oRP.>,<oRP>,oRP), rpGetRDO( IIF( <.oRP.>, <oRP>, oRP ),<(al1)>), rpGetRDO( IIF( <.oRP.>, <oRP>, oRP ),<(al2)>), "{|oRP|"+<"ex">+"}", IIF(<.ex2.>, "{|oRP|"+<"ex2">+"}",NIL), rpREL_ONE_TO_ONE,<(f)>, .t., <nl> )

#command SET RECNO RELATION [FROM] <(al1)> INTO <(al2)> ON <ex> [FAILURE EQUALS <f:BLANK,SKIP,TERMINATE,&>] [MATCH ON <ex2>] [OBJECT <oRP>] =>;
         rpDBRelate( IIF(<.oRP.>,<oRP>,oRP), rpGetRDO( IIF( <.oRP.>, <oRP>, oRP ),<(al1)>), rpGetRDO( IIF( <.oRP.>, <oRP>, oRP ),<(al2)>), "{|oRP|"+<"ex">+"}", IIF(<.ex2.>, "{|oRP|"+<"ex2">+"}",NIL), rpREL_RECNO,<(f)>, .t.)

#command CREATE DATABASE FIELD <(fn)> ALIAS <(al)> USING EXPRESSION <ex> TYPE <t> LEN <l> [DEC <d>] [LONGNAME <ln>] [OBJECT <oRP>] =>;
         rpRFldNew( IIF(<.oRP.>,<oRP>,oRP), <(al)>, <(fn)>, <(t)>, <l>, <d>, <(ln)>, "{|oRP|"+<"ex">+"}", 0, 0, 0, 0 )

#command CREATE CALCULATED [FIELD] <(fn)> USING EXPRESSION <ex> TYPE <t> LEN <l> [DEC <d>] [LONGNAME <ln>] [OBJECT <oRP>] =>;
         rpRFldNew( IIF(<.oRP.>,<oRP>,oRP), "_VIRTUAL_", <"fn">, <(t)>, <l>, <d>, <(ln)>, "{|oRP|"+<"ex">+"}", 0, 0, 0, 0 )

#command CREATE [TOTAL] <tt:SUM,COUNT,AVERAGE,LOWEST,HIGHEST,DEVIATION,VARIANCE,&> [FIELD] <fn>;
         USING EXPRESSION <ex> TYPE <t> LEN <l> [DEC <d>] [LONGNAME <ln>] ;
         RESET AT GROUP <gr> [ACCUMULATE AT <ac>] [<rt:RUNNING,PREPROCESSED,&>] [OBJECT <oRP>] =>;
         rpRFldNew( IIF( <.oRP.>, <oRP>, oRP ), "_VIRTUAL_", <(fn)>, <(t)>, <l>, <d>, <(ln)>, "{|oRP|"+<"ex">+"}", <gr>, <(tt)>, <ac>, <(rt)> )

#command CREATE [TOTAL] <tt:SUM,COUNT,AVERAGE,LOWEST,HIGHEST,DEVIATION,VARIANCE,&> [FIELD] <fn>;
         USING EXPRESSION <ex> TYPE <t> LEN <l> [DEC <d>] [LONGNAME <ln>] ;
         GRAND TOTAL [ACCUMULATE AT <ac>] [<rt:RUNNING,PREPROCESSED,&>] [OBJECT <oRP>] =>;
         rpRFldNew( IIF( <.oRP.>, <oRP>, oRP ), "_VIRTUAL_", <(fn)>, <(t)>, <l>, <d>, <(ln)>, "{|oRP|"+<"ex">+"}", 101, <(tt)>, <ac>, <(rt)> )

#command CREATE [TOTAL] <tt:SUM,COUNT,AVERAGE,LOWEST,HIGHEST,DEVIATION,VARIANCE,&> [FIELD] <fn>;
         USING EXPRESSION <ex> TYPE <t> LEN <l> [DEC <d>] [LONGNAME <ln>] ;
         PAGE TOTAL [ACCUMULATE AT <ac>] [<rt:RUNNING,PREPROCESSED,&>] [OBJECT <oRP>] =>;
         rpRFldNew( IIF( <.oRP.>, <oRP>, oRP ), "_VIRTUAL_", <(fn)>, <(t)>, <l>, <d>, <(ln)>, "{|oRP|"+<"ex">+"}", 100, <(tt)>, <ac>, <(rt)> )

#command CREATE <lt:TITLE,PAGE HEADER,BODY,PAGE FOOTER,SUMMARY> LINE ;
         [<np:NEW PAGE>] [<sh:SHOW FORMAT>] [FILTER <ex>] [COLOR <c>] [OBJECT <oRP>] =>;
         oLine := rpLineNew( IIF( <.oRP.>, <oRP>, oRP ), <(lt)>, 0, IIF( <.np.>, .t., NIL ), IIF( <.sh.>, .t., NIL ), IIF( <.ex.>, "{|oRP|"+<"ex">+"}" , NIL ), IIF( <.c.>, <c> , NIL ) )

#command CREATE HEADER LINE GROUP <g> ;
         [<np:NEW PAGE>] [<sh:SHOW FORMAT>] [FILTER <ex>] [COLOR <c>] [OBJECT <oRP>] =>;
         oLine := rpLineNew( IIF( <.oRP.>, <oRP>, oRP ), RP_HEADER, <g>, IIF( <.np.>, .t., NIL ), IIF( <.sh.>, .t., NIL ), IIF( <.ex.>, "{|oRP|"+<"ex">+"}" , NIL ), IIF( <.c.>, <c> , NIL ) )

#command CREATE FOOTER LINE GROUP <g> ;
         [<np:NEW PAGE>] [<sh:SHOW FORMAT>] [FILTER <ex>] [COLOR <c>] [OBJECT <oRP>] =>;
         oLine := rpLineNew( IIF( <.oRP.>, <oRP>, oRP ), RP_FOOTER, <g>, IIF( <.np.>, .t., NIL ), IIF( <.sh.>, .t., NIL ), IIF( <.ex.>, "{|oRP|"+<"ex">+"}" , NIL ), IIF( <.c.>, <c> , NIL ) )

#command ADD FIELD <fn> AT [COLUMN] <c> [JUSTIFY <jt:CENTER,LEFT,RIGHT,FULL,NONE,&> ];
         [<at:BOLD/ITALIC/UNDERSCORE,ITALIC/UNDERSCORE,BOLD/UNDERSCORE,BOLD/ITALIC,UNDERSCORE,ITALIC,BOLD,&>];
         [WIDTH <w>] [COLOR <co>] [<a:AUTOTRIM>] [DEC <nd>] [FORMAT <(fm)>] [FONT <(fnt)>] [SHADE <(sh)>] [BORDER <(br)>] [STYLE <(st)>] [BARCODE <(bc)>] [OBJECT <oRP>] =>;
         rpLFieldNew( oLine, <c>, rpRLongIndex( IIF( <.oRP.>, <oRP>, oRP ) ,<(fn)>), <(fm)>, <co>, <c>+IIF(<.w.>, <w>-1, ;
                IIF( <.oRP.>, <oRP>, oRP )\[ rpFIELDS \]\[ rpRLongIndex( IIF( <.oRP.>, <oRP>, oRP ),<(fn)>) \]\[ rpFIELD_LEN \] ), <.a.>, <(jt)>, <(at)>, <nd>, <(fnt)>, <(sh)>, <(br)>, <st>, <bc> )

#command ADD TEXT [FIELD] <fn> AT [COLUMN] <c> [JUSTIFY <jt:CENTER,LEFT,RIGHT,FULL,NONE,&> ];
         [<at:BOLD/ITALIC/UNDERSCORE,ITALIC/UNDERSCORE,BOLD/UNDERSCORE,BOLD/ITALIC,UNDERSCORE,ITALIC,BOLD,&>];
         [WIDTH <w>] [COLOR <co>] [FORMAT <(fm)>]  [FONT <(fnt)>] [SHADE <(sh)>] [BORDER <(br)>] [STYLE <st>] [BARCODE <(bc)>]  [OBJECT <oRP>] => ;
         rpLFieldNew( oLine, <c>, rpRFldNew( IIF( <.oRP.>, <oRP>, oRP ), "__TEXT__", "TEXT", "C", len(<fn>), 0, <fn>, "{||''}" ), <(fm)>, <co>, <c>+IIF( <.w.>, <w>-1, ;
                len(<fn>)-1 ), .f., <(jt)>, <(at)>, , <(fnt)>, <(sh)>, <(br)>, <(st)>, <bc> )

#command ADD FIELD <fn> TO LINE <nl> AT [COLUMN] <c> [JUSTIFY <jt:CENTER,LEFT,RIGHT,FULL,NONE,&> ];
         [<at:BOLD/ITALIC/UNDERSCORE,ITALIC/UNDERSCORE,BOLD/UNDERSCORE,BOLD/ITALIC,UNDERSCORE,ITALIC,BOLD,&>];
         [WIDTH <w>] [COLOR <co>] [<a:AUTOTRIM>] [DEC <nd>] [FORMAT <(fm)>] [FONT <(fnt)>] [SHADE <(sh)>] [BORDER <(br)>] [STYLE <(st)>] [BARCODE <(bc)>] [OBJECT <oRP>] =>;
         rpLFieldNew( IIF( <.oRP.>, <oRP>, oRP )\[ rpLINES \]\[ <nl> \], <c>, rpRLongIndex( IIF( <.oRP.>, <oRP>, oRP ) ,<(fn)>), <(fm)>, <co>, <c>+IIF(<.w.>, <w>-1, ;
                IIF( <.oRP.>, <oRP>, oRP )\[ rpFIELDS \]\[ rpRLongIndex( IIF( <.oRP.>, <oRP>, oRP ),<(fn)>) \]\[ rpFIELD_LEN \] ), <.a.>, <(jt)>, <(at)>, <nd>, <(fnt)>, <(sh)>, <(br)>, <st>, <bc> )

#command ADD TEXT [FIELD] <fn> TO LINE <nl> AT [COLUMN] <c> [JUSTIFY <jt:CENTER,LEFT,RIGHT,FULL,NONE,&> ];
         [<at:BOLD/ITALIC/UNDERSCORE,ITALIC/UNDERSCORE,BOLD/UNDERSCORE,BOLD/ITALIC,UNDERSCORE,ITALIC,BOLD,&>];
         [WIDTH <w>] [COLOR <co>] [FORMAT <(fm)>]  [FONT <(fnt)>] [SHADE <(sh)>] [BORDER <(br)>] [STYLE <st>] [BARCODE <(bc)>] [OBJECT <oRP>] => ;
         rpLFieldNew( IIF( <.oRP.>, <oRP>, oRP )\[ rpLINES \]\[ <nl> \], <c>, rpRFldNew( IIF( <.oRP.>, <oRP>, oRP ), "__TEXT__", "TEXT", "C", len(<fn>), 0, <fn>, "{||''}" ), <(fm)>, <co>, <c>+IIF( <.w.>, <w>, ;
                len(<(fn)>)-1 ), .f., <(jt)>, <(at)>, , <(fnt)>, <(sh)>, <(br)>, <(st)>, <bc> )

#command REPORT IS SORTED ON <(s1)> [<a1:ASCENDING,DESCENDING,&>] ;
                          [, <(sn)> [<an:ASCENDING,DESCENDING,&>] ] [OBJECT <oRP>] =>;
           rpSortNew(IIF(<.oRP.>,<oRP>,oRP),rpRLongIndex(IIF(<.oRP.>,<oRP>,oRP),<"s1">),IIF(!<.a1.>, "A",IIF(<(a1)> == "ASCENDING","A","D"))) ;
         [;rpSortNew(IIF(<.oRP.>,<oRP>,oRP),rpRLongIndex(IIF(<.oRP.>,<oRP>,oRP),<"sn">),IIF(!<.an.>, "A",IIF(<(an)> == "ASCENDING","A","D"))) ]

#command REPORT IS GROUPED ON <(g1)> [DESCRIPTION <g1d>] [<rp1:RESET PAGENO>] [<sh1:SWAP HEADER>] [<sf1:SWAP FOOTER>] [<rh1:REPEAT HEADER>] [<nb1:NO BREAK>];
                            [,<(gn)> [DESCRIPTION <gnd>] [<rpn:RESET PAGENO>] [<shn:SWAP HEADER>] [<sfn:SWAP FOOTER>] [<rhn:REPEAT HEADER>] [<nbn:NO BREAK>] ] [OBJECT <oRP>] =>;
           rpLevelNew(IIF(<.oRP.>,<oRP>,oRP), rpRLongIndex(IIF(<.oRP.>,<oRP>,oRP ),<"g1">),IIF(!<.g1d.>,<(g1)>,<g1d>),<.rp1.>,<.sh1.>,<.sf1.>,<.rh1.>,!<.nb1.>) ;
         [;rpLevelNew(IIF(<.oRP.>,<oRP>,oRP), rpRLongIndex(IIF(<.oRP.>,<oRP>,oRP ),<"gn">),IIF(!<.gnd.>,<(gn)>,<gnd>),<.rpn.>,<.shn.>,<.sfn.>,<.rhn.>,!<.nbn.>) ]

#command SET PAGE LENGTH TO <n> [OBJECT <oRP>] =>;
         rpPageLen(IIF(<.oRP.>,<oRP>,oRP), <n> )

#command SET RIGHT MARGIN TO <n> [<m:COLUMNS,INCHES,CENTIMETERS,&>] [OBJECT <oRP>] =>;
         rpRightMargin(IIF(<.oRP.>,<oRP>,oRP), <n> )

#command SET LEFT MARGIN TO <n> [<m:COLUMNS,INCHES,CENTIMETERS,&>] [OBJECT <oRP>] =>;
         rpLeftMargin(IIF(<.oRP.>,<oRP>,oRP), <n> )

#command SET TOP MARGIN TO <n> [<m:COLUMNS,INCHES,CENTIMETERS,&>] [OBJECT <oRP>] =>;
         rpTopMargin(IIF(<.oRP.>,<oRP>,oRP), <n> )

#command SET BOTTOM MARGIN TO <n> [<m:COLUMNS,INCHES,CENTIMETERS,&>] [OBJECT <oRP>] =>;
         rpBottomMargin(IIF(<.oRP.>,<oRP>,oRP), <n> )

#command SET COPIES TO <n> [OBJECT <oRP>] =>;
         rpCopies( IIF( <.oRP.>, <oRP>, oRP ), <n> )

#command SET RECORDS ACROSS TO <n> [OBJECT <oRP>]  => ;
         rpRecsAcross( IIF( <.oRP.>, <oRP>, oRP ), <n> )

#command SET RECORD WIDTH TO <n> [OBJECT <oRP>]  => ;
         rpRecWidth( IIF( <.oRP.>, <oRP>, oRP ), <n> )

#command SET RECORD HEIGHT TO <n> [<m:LINES,INCHES,CENTIMETERS,&>] [OBJECT <oRP>]  => ;
         rpRecHeight( IIF( <.oRP.>, <oRP>, oRP ), <n> )

#command SET DESTINATION TO <c:PRINTER, DISPLAY, FILE, &> [NAMED <(nm)>] [OBJECT <oRP>]  => ;
         rpDestination( IIF( <.oRP.>, <oRP>, oRP ), CASE({<(c)>,"PRINTER",rpPRINTER,"FILE",rpPRINTER_FILE,rpDISPLAY}) );
         [;rpOutFile( IIF( <.oRP.>, <oRP>, oRP ), <(nm)> )]

#command SET BODY RECORD SUPPRESSION <l:ON,OFF,&> [OBJECT <oRP>]  => ;
         rpSuppressBody( IIF( <.oRP.>, <oRP>, oRP ), IIF(<(l)> =="ON",.t.,.f.) )

#command SET BREAK BODY <l:ON,OFF,&> [OBJECT <oRP>]  => ;
         rpBreakBody( IIF( <.oRP.>, <oRP>, oRP ), IIF(<(l)> =="ON",.t.,.f.) )

#command SET REPORT COLOR TO <n> [OBJECT <oRP>]  => ;
         rpColor( IIF( <.oRP.>, <oRP>, oRP ), <n> )

#command SET REPORT ACTIVE COLOR TO <n> [OBJECT <oRP>]  => ;
         rpActiveColor(IIF(<.oRP.>,<oRP>,oRP ), <n> )

#command SET REPORT MOVE COLOR TO <n> [OBJECT <oRP>]  => ;
         rpMoveColor(IIF(<.oRP.>,<oRP>,oRP), <n> )

#command SET REPORT ERROR COLOR TO <n> [OBJECT <oRP>]  => ;
         rpErrorColor(IIF(<.oRP.>,<oRP>,oRP), <n> )

#command SET CHARACTERS PER INCH TO <c:10, 12, COMPRESSED, &> [OBJECT <oRP>]  => ;
         rpCharsPerInch(IIF(<.oRP.>,<oRP>,oRP), CASE({<(c)>,"10",10,"12",12,16}) );

#command SET CHARS PER INCH TO <c:10, 12, COMPRESSED, &> [OBJECT <oRP>]  => ;
         rpCharsPerInch(IIF(<.oRP.>,<oRP>,oRP), CASE({<(c)>,"10",10,"12",12,16}) );

#command SET LINES PER INCH TO <c:6, 8, &> [OBJECT <oRP>]  => ;
         rpLinesPerInch( IIF( <.oRP.>, <oRP>, oRP ), CASE({<(c)>,"8",8,6}) );

#command SET SEMICOLON BREAK <l:ON,OFF,&> [OBJECT <oRP>]  => ;
         rpSemiNewLine( IIF( <.oRP.>, <oRP>, oRP ), IIF(<(l)> =="ON",.t.,.f.) )

#command SET STARTING PAGE TO <n> [OBJECT <oRP>]  => ;
         rpStartPage( IIF( <.oRP.>, <oRP>, oRP ), <n> )

#command SET ENDING PAGE TO <n> [OBJECT <oRP>]  => ;
         rpEndPage( IIF( <.oRP.>, <oRP>, oRP ), <n> )

#command REBUILD LINES [OBJECT <oRP>]  => ;
         rpRebuildDispLines( IIF( <.oRP.>, <oRP>, oRP ) )

#command SAVE REPORT AS <(c)> [OBJECT <oRP>]  => ;
         rpSave( IIF( <.oRP.>, <oRP>, oRP ), <(c)> )

#command LOAD REPORT FROM <(c)> [OBJECT <oRP>]  => ;
         rpRetreive( IIF( <.oRP.>, <oRP>, oRP ), <(c)> )

#command SET JUMPSIZE TO <n> [OBJECT <oRP>]  => ;
         rpJumpSize( IIF( <.oRP.>, <oRP>, oRP ), <n> )

#command SET JUMPSTART <l:ON,OFF,&> [OBJECT <oRP>]  => ;
         rpJumpStart( IIF(<.oRP.>,<oRP>,oRP), IIF( <(l)> == "ON", .t., .f.) )

#command SET QUERY TO <(ex)> [OBJECT <oRP>]  => ;
         rpQueryTBlock( IIF( <.oRP.>, <oRP>, oRP ), "{|oRP|"+<"ex">+"}" )

#command SET QUERY DESCRIPTION TO <(c)> [OBJECT <oRP>]  => ;
         rpQueryDesc( IIF( <.oRP.>, <oRP>, oRP ), <(c)> )

#command SET PAGE WAIT <l:ON,OFF,&> [OBJECT <oRP>]  => ;
         rpPageWait( IIF( <.oRP.>, <oRP>, oRP ), IIF(<(l)> =="ON",.t.,.f.) )

#command SET EJECT LAST PAGE  <l:ON,OFF,&> [OBJECT <oRP>]  => ;
         rpEjectLastPage( IIF( <.oRP.>, <oRP>, oRP ), IIF(<(l)> =="ON",.t.,.f.) )

#command SET SCOPE TYPE TO <(c)> [OBJECT <oRP>]  => ;
         rpScopeType( IIF( <.oRP.>, <oRP>, oRP ), <(c)> )

#command SET HIGH SCOPE TO <c> [OBJECT <oRP>]  => ;
         rpScopeHigh( IIF( <.oRP.>, <oRP>, oRP ), <c> )

#command SET LOW SCOPE TO <c> [OBJECT <oRP>]  => ;
         rpScopeLow( IIF( <.oRP.>, <oRP>, oRP ), <c> )

#command GENERATE REPORT [OBJECT <oRP>]  => ;
         rpGenReport( IIF( <.oRP.>, <oRP>, oRP ) )

#command INVOKE PAINTER [OBJECT <oRP>]  => ;
         rpPainter( IIF( <.oRP.>, <oRP>, oRP ) )

#command KILL SORT FILES [OBJECT <oRP>]  => ;
         rpKillSorts( IIF( <.oRP.>, <oRP>, oRP ) )

#command SET REPORT PRINTER TO <(p)> [ON PORT <(r)>] [OBJECT <oRP>]  =>  ;
         rpPrinter( IIF( <.oRP.>, <oRP>, oRP ), <(p)> ) ;
         [;rpOutPort( IIF( <.oRP.>, <oRP>, oRP ), <(r)> )]

#command SET ORIENTATION TO <o> [OBJECT <oRP>]  =>;
         rpOrientation( IIF(<.oRP.>,<oRP>,oRP), IIF( <"o"> == "LANDSCAPE", rpLANDSCAPE, rpPORTRAIT ) )

//
// FONT RELATED COMMANDS
//
#command ENABLE FONTS [OBJECT <oRP>] => ;
         rpUseFonts( IIF( <.oRP.>, <oRP>, oRP ), .t. )

#command DISABLE FONTS [OBJECT <oRP>] => ;
         rpUseFonts( IIF( <.oRP.>, <oRP>, oRP ), .f. )

#command DEFINE FONT <(f)> FROM <t> SIZE <n> [SYMSET <s>] [OBJECT <oRP>] => ;
       	 rpFontNew( IIF(<.oRP.>,<oRP>,oRP), <t>, <(f)>, <(s)>, <n> )

#command SET FONT PATH TO <(c)> [OBJECT <oRP>]  => ;
         rpFontPath( IIF( <.oRP.>, <oRP>, oRP ), <(c)> )

#command SET FONT LANGUAGE TO <(c)> [OBJECT <oRP>]  => ;
         rpFontLanguage(IIF(<.oRP.>,<oRP>,oRP),IIF(upper(<(c)>)=="PCL5",rpPCL_5,rpPCL_4))

#command SET PAPER SOURCE TO <c> [OBJECT <oRP>]  => ;
         rpPaperSource( IIF(<.oRP.>,<oRP>,oRP), ;
                CASE({upper(<(c)>),"UPPER TRAY",rpTRAY_UPPER,"LOWER TRAY",rpTRAY_LOWER,"MANUAL FEED",rpTRAY_MANUAL, "CASSETTE/DECK", rpTRAY_DECK, rpTRAY_DEFAULT }) );

#command SET PAPER SIZE TO <(c)> [OBJECT <oRP>]  => ;
         rpPaperSize( IIF(<.oRP.>,<oRP>,oRP), ;
                CASE({upper(<(c)>),"LETTER",rpLETTER,"LEGAL",rpLEGAL,"EXECUTIVE",rpEXEC,"A3", rpA3, "A4", rpA4, rpLETTER }) );

