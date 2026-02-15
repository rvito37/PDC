#DEFINE rpVERSION     "V2.3a"
#DEFINE CLIPPER52     " "

// #DEFINE _ENDUSER_   ''

#DEFINE _FONTS_  ''

#IFNDEF CLIPPER52
  #DEFINE TIGHTMEM     " "
#ENDIF

#DEFINE rpMULTI_WINDOWS  " "

/* main report oject defines
-------------------------------*/
#DEFINE rpQUERY       1

   #DEFINE rpQUERY_TEXT       1
   #DEFINE rpQUERY_BLOCK      2
   #DEFINE rpQUERY_DESC       3

#DEFINE rpFIELDS      2

   /* *-REPORT FIELD OBJECT-*
   ----------------------------*/
   #DEFINE rpREPORT_FIELD_OBJECT  { "", "", "", 0, 0, "" , NIL, "", 0, 0, 0,0, 0 , 0, 0, 0, 0, .f. , "", 0 }

   #DEFINE rpTABLE_NAME            1
   #DEFINE rpFIELD_NAME            2
   #DEFINE rpFIELD_TYPE            3
   #DEFINE rpFIELD_LEN             4
   #DEFINE rpFIELD_DEC             5
   #DEFINE rpFIELD_LONGNAME        6
   #DEFINE rpFIELD_BLOCK           7
   #DEFINE rpFIELD_TEXTBLOCK       8
   #DEFINE rpFIELD_VIRTUAL_POS     9
   #DEFINE rpFIELD_LEVEL           10
   #DEFINE rpFIELD_PROCESS_TYPE    11
   #DEFINE rpFIELD_TOTAL_TYPE      12
   #DEFINE rpFIELD_TOTAL_COUNTER   13
   #DEFINE rpFIELD_TOTAL_VAL       14
   #DEFINE rpFIELD_TOTAL_ACC_FREQ  15
   #DEFINE rpFIELD_VAL             16
   #DEFINE rpFIELD_TOTAL_RFO       17
// #DEFINE RESERVED                18
   #DEFINE rpFIELD_DISP_EXPR       19
   #DEFINE rpFIELD_PP_POS          20

#DEFINE rpREPORT  3

   #DEFINE rpREPORT_TOP                 1
   #DEFINE rpREPORT_LEFT                2
   #DEFINE rpREPORT_BOTTOM              3
   #DEFINE rpREPORT_RIGHT               4
   #DEFINE rpREPORT_COLOR               5
   #DEFINE rpREPORT_ERROR_COLOR         6
   #DEFINE rpREPORT_ACTIVE_COLOR        7
   #DEFINE rpREPORT_MOVE_COLOR          8
   #DEFINE rpREPORT_TOPORG              9
   #DEFINE rpREPORT_LEFTORG             10
   #DEFINE rpREPORT_CSRROW              11
   #DEFINE rpREPORT_CSRCOL              12
   #DEFINE rpREPORT_CURRFIELD           13
   #DEFINE rpREPORT_LINELEN             14
   #DEFINE rpREPORT_HIDEFLAG            15
   #DEFINE rpREPORT_MOVING              16
   #DEFINE rpREPORT_REPAINT             17
   #DEFINE rpREPORT_JUMPSIZE            18
   #DEFINE rpREPORT_JUMPFLAG            19
   #DEFINE rpREPORT_OBJTYPE             20
   #DEFINE rpREPORT_ERROR               21
   #DEFINE rpREPORT_PAGELEN             22
   #DEFINE rpREPORT_MARGIN_TOP          23
   #DEFINE rpREPORT_MARGIN_LEFT         24
   #DEFINE rpREPORT_MARGIN_BOTTOM       25
   #DEFINE rpREPORT_MARGIN_RIGHT        26
   #DEFINE rpREPORT_PRINTER             27
   #DEFINE rpREPORT_DEST                28
   #DEFINE rpREPORT_HANDLE              29
   #DEFINE rpREPORT_OUTFILE             30
   #DEFINE rpREPORT_RECS_ACROSS         31
   #DEFINE rpREPORT_COPIES              32
   #DEFINE rpREPORT_START_PAGE          33
   #DEFINE rpREPORT_END_PAGE            34
   #DEFINE rpREPORT_LINES_PER_INCH      35
   #DEFINE rpREPORT_CHARS_PER_INCH      36
   #DEFINE rpREPORT_PAGE_WAIT           37
   #DEFINE rpREPORT_EJECT_FINAL         38
   #DEFINE rpREPORT_PAGE_ORIENT         39
   #DEFINE rpREPORT_PAGE_NO             40
   #DEFINE rpREPORT_PREV_LIST           41
   #DEFINE rpREPORT_MEASURE_TYPES       42
   #DEFINE rpREPORT_NAME                43
   #DEFINE rpREPORT_VERSION             44
   #DEFINE rpREPORT_PAN_COUNT           45
   #DEFINE rpREPORT_SAVESCREEN          46
   #DEFINE rpREPORT_VIRTUAL_FILE        47
   #DEFINE rpREPORT_SCOPE_LOW           48
   #DEFINE rpREPORT_SCOPE_HIGH          49
   #DEFINE rpREPORT_SCOPE_TYPE          50
   #DEFINE rpREPORT_WRAP_FMT_VAL        51
   #DEFINE rpREPORT_MERGE_FMT_VAL       52
   #DEFINE rpREPORT_LINE_TEXT_LEN       53
   #DEFINE rpREPORT_ZOOM_TOP            54
   #DEFINE rpREPORT_ZOOM_LEFT           55
   #DEFINE rpREPORT_ZOOM_BOTTOM         56
   #DEFINE rpREPORT_ZOOM_RIGHT          57
   #DEFINE rpREPORT_COMPRESS_BODY_GRP   58
   #DEFINE rpREPORT_SUPPRESS_BODY       59
   #DEFINE rpREPORT_NEWLINE_SEMI        60
   #DEFINE rpREPORT_REC_WIDTH           61
   #DEFINE rpREPORT_REC_COPIES          62
   #DEFINE rpREPORT_REC_HEIGHT          63
   #DEFINE rpREPORT_HEADFOOT_IN_SUMMAY  64
   #DEFINE rpREPORT_BREAK_BODY          65
   #DEFINE rpREPORT_DATA_PATH           66
   #DEFINE rpREPORT_INDEX_PATH          67
   #DEFINE rpREPORT_SWAP_PATH           68
   #DEFINE rpREPORT_REPO_PATH           69
   #DEFINE rpREPORT_ASCII_MEMO          70
   #DEFINE rpREPORT_PRINTER_COLORS      71
   #DEFINE rpREPORT_OVER_APPEND         72
   #DEFINE rpREPORT_PATH_OVERRIDE       73
   #DEFINE rpREPORT_TEMP_MASK           74
   #DEFINE rpREPORT_OUT_PORT            75
   #DEFINE rpREPORT_PRINT_DBF           76
   #DEFINE rpREPORT_PARSESTR            77
   #DEFINE rpREPORT_SHOW_COUNTER        78
   #DEFINE rpREPORT_USE_DICTIONARY      79
   #DEFINE rpREPORT_GENERIC_VIDEO       80
   #DEFINE rpREPORT_USE_FONTS           81
   #DEFINE rpREPORT_BODY_SHADE          82
   #DEFINE rpREPORT_FONT_RESET          83

   // ELEMENTS 84-100 ARE RESERVED


#DEFINE rpDATABASE      4

   /* *-REPORT DATABASE OBJECT-*
   ------------------------------*/
   #DEFINE rpDATABASE_OBJECT { "", "", "", "", NIL, 0, 0, {}, "", 0, NIL , upper(DBSetDriver()), indexext(), ".DBF" , rpOPEN_SHARED, "" }

   #DEFINE rpDATABASE_TABLE        1
   #DEFINE rpDATABASE_ALIAS        2
   #DEFINE rpDATABASE_INDEX        3
   #DEFINE rpDATABASE_KEYTBLOCK    4
   #DEFINE rpDATABASE_KEYBLOCK     5
   #DEFINE rpDATABASE_MANYCNT      6
   #DEFINE rpDATABASE_POS          7
   #DEFINE rpDATABASE_REL          8

      /* *-REPORT RELATION OBJECT-*
      ------------------------------*/
      #DEFINE rpREL_OBJECT { "", "", "", "", "" , "" , 0 , 0 , 0 , .f. , .f. , 0 , .f., 0, "" }

      #DEFINE rpREL_FROMALIAS      1
      #DEFINE rpREL_TOALIAS        2
      #DEFINE rpREL_SEEK           3
      #DEFINE rpREL_SEEKTEXT       4
      #DEFINE rpREL_MATCH          5
      #DEFINE rpREL_MATCHTEXT      6
      #DEFINE rpREL_TYPE           7
      #DEFINE rpREL_LASTVAL        8
      #DEFINE rpREL_POS            9
      #DEFINE rpREL_SOFT_SEEK      10
      #DEFINE rpREL_SCANNED        11
      #DEFINE rpREL_FAIL_ACTION    12
      #DEFINE rpREL_STATUS         13
      #DEFINE rpREL_MATCHLEN       14

   #DEFINE rpDATABASE_ORDER_NAME    9
   #DEFINE rpDATABASE_ORDER_NO     10
   #DEFINE rpDATABASE_METHODS      11
   #DEFINE rpDATABASE_RDDNAME      12
   #DEFINE rpDATABASE_INDEX_EXT    13
   #DEFINE rpDATABASE_DATA_EXT     14
   #DEFINE rpDATABASE_OPEN_MODE    15
   #DEFINE rpDATABASE_ALT_RDD      16


#DEFINE rpRUNTIME    5

   #DEFINE rpRUNTIME_PREVIOUS        1

     #DEFINE rpRUNTIME_PREVIOUS_RFO   1
     #DEFINE rpRUNTIME_PREVIOUS_FNAME 2
     #DEFINE rpRUNTIME_PREVIOUS_VAL   3

   #DEFINE rpRUNTIME_SCANS           2
   #DEFINE rpRUNTIME_CURR_SCAN       3
   #DEFINE rpRUNTIME_SORT_DBF        4
   #DEFINE rpRUNTIME_SORT_NTX        5
   #DEFINE rpRUNTIME_REL_RFOS        6
   #DEFINE rpRUNTIME_PREPROCESSED    7
   #DEFINE rpRUNTIME_ACROSS_POS      8
   #DEFINE rpRUNTIME_TOTAL_PAGES     9
   #DEFINE rpRUNTIME_GENLINE_NO      10
   #DEFINE rpRUNTIME_SORTED_FLAG     11
   #DEFINE rpRUNTIME_LINE_MARK_START 12
   #DEFINE rpRUNTIME_LINE_MARK_END   13
   #DEFINE rpRUNTIME_TAGGED          14
   #DEFINE rpRUNTIME_DBFPOS_LIST     15
   #DEFINE rpRUNTIME_RECS_READ       16
   #DEFINE rpRUNTIME_RECS_MATCH      17
   #DEFINE rpRUNTIME_SORT_ALIAS      18
   #DEFINE rpRUNTIME_CODES           19
   #DEFINE rpRUNTIME_TORG            20
   #DEFINE rpRUNTIME_LORG            21
   #DEFINE rpRUNTIME_ERROR_MSG       22
   #DEFINE rpRUNTIME_CURR_COPY       23
   #DEFINE rpRUNTIME_CARGO           24
   #DEFINE rpRUNTIME_TMP_HANDLES     25
   #DEFINE rpRUNTIME_TMP_NAMES       26
   #DEFINE rpRUNTIME_PP_NTX          27
   #DEFINE rpRUNTIME_CALCS_IN_RELS   28
   #DEFINE rpRUNTIME_ALL_ONES        29
   #DEFINE rpRUNTIME_ASCII_FIELDS    30
   #DEFINE rpRUNTIME_DEFAULT_EXTS    31


#DEFINE rpLINES      6

   /*  *-REPORT LINE OBJECT-*
   ----------------------------*/
   #DEFINE rpLINE_OBJECT   { {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {} ,.f.,  0, RP_BODY, 0, 0, "", .f., .f., .f., {||.t.},"{||.t.}", 0, 0, .f., 0, 0, "" }

   #DEFINE rpLFIELD_START       1
   #DEFINE rpLFIELD_END         2
   #DEFINE rpLFIELD_INDEX       3
   #DEFINE rpLFIELD_FORMAT      4
   #DEFINE rpLFIELD_JUSTIFY     5
   #DEFINE rpLFIELD_DISPVAL     6
   #DEFINE rpLFIELD_PATTR       7
   #DEFINE rpLFIELD_COLOR       8
   #DEFINE rpLFIELD_AUTOTRIM    9
   #DEFINE rpLFIELD_DEC         10
   #DEFINE rpLFIELD_FONT        11
   #DEFINE rpLFIELD_SHADE       12
   #DEFINE rpLFIELD_BORDER      13
   #DEFINE rpLFIELD_STYLE       14
   #DEFINE rpFIELD_DISPORDER    15
   #DEFINE rpLINE_NEWPAGE       16
   #DEFINE rpPARENT_RP          17
   #DEFINE rpLINE_TYPE          18
   #DEFINE rpLINE_LEVEL         19
   #DEFINE rpLINE_ROW           20
   #DEFINE rpLINE_FIELDSTR      21
   #DEFINE rpLINE_SHOWFORMAT    22
   #DEFINE rpLINE_REPAINT       23
   #DEFINE rpLINE_AUTOTRIM      24
   #DEFINE rpLINE_FILTER        25
   #DEFINE rpLINE_TFILTER       26
   #DEFINE rpLINE_COLOR         27
   #DEFINE rpLINE_PATTR         28
   #DEFINE rpLINE_HAS_FILTER    29
   #DEFINE rpLINE_HEIGHT        30
   #DEFINE rpLINE_SCANNING      31
   #DEFINE rpLINE_TYPE_TEXT     32
   #DEFINE rpLINE_MEAS_TYPE     33

   //---------------------------------------------------------------------//
   // *VERY* Important! index of LFO subarrs to move, resize, etc.        //
   //---------------------------------------------------------------------//
   #DEFINE MOVEINDEX  { rpLFIELD_START , rpLFIELD_END , rpLFIELD_INDEX , rpLFIELD_FORMAT , rpLFIELD_JUSTIFY , rpLFIELD_DISPVAL , rpLFIELD_PATTR , rpLFIELD_COLOR, rpLFIELD_AUTOTRIM , rpLFIELD_DEC, rpLFIELD_FONT, rpLFIELD_SHADE, rpLFIELD_BORDER, rpLFIELD_STYLE }

#DEFINE rpLEVELS       7

   /* *-REPORT LEVELS OBJECT-*
   ------------------------------*/
   #DEFINE rpLEVELS_OBJECT { 0, "", 0, .f., .f., .f., .f., .f. }

   #DEFINE rpLEVEL_INDEX               1
   #DEFINE rpLEVEL_DESC                2
   #DEFINE rpLEVEL_LEVEL               3
   #DEFINE rpLEVEL_ALLOW_BREAK         4
   #DEFINE rpLEVEL_PAGE_RESET          5
   #DEFINE rpLEVEL_SWAP_HEADER         6
   #DEFINE rpLEVEL_SWAP_FOOTER         7
   #DEFINE rpLEVEL_REPEAT_HEADER       8


#DEFINE rpSORTS       8

   /* *-REPORT SORT OBJECT-*
   --------------------------*/
   #DEFINE rpSORTS_OBJECT { 0, " ", " " }

   #DEFINE rpSORT_RFO            1
   #DEFINE rpSORT_ORDER          2
   #DEFINE rpSORT_DESC           3

#DEFINE rpUSERFUNCS       9

   /* *-REPORT USER FUNCTION -*
   ----------------------------*/
   #DEFINE rpUSER_LINE_OUT         1

      #DEFINE rpUSER_LINE_OUT_BLOCK        1
      #DEFINE rpUSER_LINE_OUT_TBLOCK       2


#DEFINE rpFONTS       10

#ifdef _FONTS_

   #DEFINE rpFONTS_FILES                   1

      /* *-REPORT FONTFILE OBJECT-*
      ------------------------------*/
      #DEFINE rpFONTS_OBJECT { "", "", rpSS_ASCII, 10.0, .f., rpATTR_NONE, 0 }

      #DEFINE rpFONTS_FILE         1
      #DEFINE rpFONTS_NAME         2
      #DEFINE rpFONTS_SYMBOL_SET   3
      #DEFINE rpFONTS_POINTS       4
      #DEFINE rpFONTS_SCALED       5
      #DEFINE rpFONTS_ATTR         6
      #DEFINE rpFONTS_INDEX        7

   #DEFINE rpFONT_PATH                     2
   #DEFINE rpFONT_JOBTYPE                  3
   #DEFINE rpFONT_LANGUAGE                 4
   #DEFINE rpFONT_PAPER_SIZE               5
   #DEFINE rpFONT_PAPER_SOURCE             6
#endif

// required
#DEFINE RP_C_FMT_WORDWRAP          5
#DEFINE RP_C_FMT_MAILMERGE         6

/*========================================================================*/
#DEFINE rpREPORT_OBJECT  { ;
                         { "{||.t.}", {||.t.}, "None." }, ;
                         {} ,;
                           { 0,  ;          // rpREPORT_TOP
                             0,  ;          // rpREPORT_LEFT
                             24, ;          // rpREPORT_BOTTOM
                             79, ;          // rpREPORT_RIGHT
                             31, ;          // rpREPORT_COLOR
                             79, ;          // rpREPORT_ERROR_COLOR
                   roloc( 31 ),  ;          // rpREPORT_ACTIVE_COLOR
                            48,  ;          // rpREPORT_MOVE_COLOR
                             0,  ;          // rpREPORT_TOPORG
                             0,  ;          // rpREPORT_LEFTORG
                             1,  ;          // rpREPORT_CSRROW
                             1,  ;          // rpREPORT_CSRCOL
                             0,  ;          // rpREPORT_CURRFIELD
                             0,  ;          // rpREPORT_LINELEN
                             .f.,;          // rpREPORT_HIDEFLAG
                             0,  ;          // rpREPORT_MOVING
                             .f.,;          // rpREPORT_REPAINT
                             5,  ;          // rpREPORT_JUMPSIZE
                             .t.,;          // rpREPORT_JUMP_FLAG
            rpREPORT_OBJECT_TYPE,;          // rpREPORT_OBJTYPE
                             0,  ;          // rpREPORT_ERROR
                            66,  ;          // rpREPORT_PAGELEN
                             0,  ;          // rpREPORT_MARGIN_TOP
                             0,  ;          // rpREPORT_MARGIN_LEFT
                             0,  ;          // rpREPORT_MARGIN_BOTTOM
                             0,  ;          // rpREPORT_MARGIN_RIGHT
                       "ASCII",  ;          // rpREPORT_PRINTER
                     rpDISPLAY,  ;          // rpREPORT_DEST
                             0,  ;          // rpREPORT_HANDLE
                    "temp.tmp",  ;          // rpREPORT_OUTFILE
                             1,  ;          // rpREPORT_RECS_ACROSS
                             1,  ;          // rpREPORT_COPIES
                             1,  ;          // rpREPORT_START_PAGE
                        999999,  ;          // rpREPORT_END_PAGE
                             6,  ;          // rpREPORT_LINES_PER_INCH
                            10,  ;          // rpREPORT_CHARS_PER_INCH
                           .f.,  ;          // rpREPORT_PAGE_WAIT
                           .f.,  ;          // rpREPORT_EJECT_FINAL
                            1 ,  ;          // rpREPORT_PAGE_ORIENT
                            1 ,  ;          // rpREPORT_PAGE_NO
                            {},  ;          // rpREPORT_PREV_LIST
                       {,,,,,},  ;          // rpREPORT_MEASURE_TYPES
                        "    ",  ;          // rpREPORT_NAME
                          .F. ,  ;          // rpREPORT_VERSION
                            1 ,  ;          // rpREPORT_PAN_COUNT
                           "" ,  ;          // rpREPORT_SAVESCREEN
                           "" ,  ;          // rpREPORT_VIRTUAL_FILE
                              ,  ;          // rpREPORT_SCOPE_LOW
                              ,  ;          // rpREPORT_SCOPE_HIGH
                           "" ,  ;          // rpREPORT_SCOPE_TYPE
           RP_C_FMT_WORDWRAP  ,  ;          // rpREPORT_WRAP_FMT_VAL
           RP_C_FMT_MAILMERGE ,  ;          // rpREPORT_MERGE_FMT_VAL
                            7 ,  ;          // rpREPORT_LINE_TEXT_LEN
                            4 ,  ;          // rpREPORT_ZOOM_TOP
                            0 ,  ;          // rpREPORT_ZOOM_LEFT
                     lastrow(),  ;          // rpREPORT_ZOOM_BOTTOM
                     lastcol(),  ;          // rpREPORT_ZOOM_RIGHT
                           .f.,  ;          // rpREPORT_COMPRESS_BODY_GRP
                           .f.,  ;          // rpREPORT_SUPPRESS_BODY
                           .f.,  ;          // rpREPORT_NEWLINE_SEMI
                            80,  ;          // rpREPORT_REC_WIDTH
                             1,  ;          // rpREPORT_REC_COPIES
                             0,  ;          // rpREPORT_REC_HEIGHT
                           .t.,  ;          // rpREPORT_HEADFOOT_IN_SUMMAY
                           .f.,  ;          // rpREPORT_BREAK_BODY
                           "" ,  ;          // rpREPORT_DATA_PATH
                           "" ,  ;          // rpREPORT_INDEX_PATH
                           "" ,  ;          // rpREPORT_SWAP_PATH
                           "" ,  ;          // rpREPORT_REPO_PATH
                           "" ,  ;          // rpREPORT_ASCII_MEMO
     {9,10,11,12,13,14,15,31} ,  ;          // rpREPORT_PRINTER_COLORS
                           .t.,  ;          // rpREPORT_OVER_APPEND
                           .t.,  ;          // rpREPORT_PATH_OVERRIDE
                       "*.tmp",  ;          // rpREPORT_TEMP_MASK
                       "LPT1" ,  ;          // rpREPORT_OUT_PORT
               "PRINTERS.DBF" ,  ;          // rpREPORT_PRINT_DBF
            RP_LINE_PARSE_STR ,  ;          // rpREPORT_PARSESTR
                           .t.,  ;          // rpREPORT_SHOW_COUNTER
                           .f.,  ;          // rpREPORT_USE_DICTIONARY
                           .f.,  ;          // rpREPORT_GENERIC_VIDEO
                           .t.,  ;          // rpREPORT_USE_FONTS
   			     0,	 ;          // rpREPORT_BODY_SHADE
                           .t.,  ;          // rpREPORT_FONT_RESET
                         } ,;
                         {} ,;
                         { {{},{},{}},{},{},"","",{},.f., 1,0,0,.F.,0,0, {},{},0,0,"",{{},{{,},{,},{,},{,},{,},{,},{,},{,}}},0,0,"", 0, {'','','','','','','','','',''}, {0,0,0,0,0},{,,,,}," ", .t.,.f.,{{},{}},{rpDEFAULT_EXTENSIONS}, 0.0 },;// runtime
                         {} ,;
                         { {}, {}, {}, {}, {}, {}, {}, {}},;
                         {},;
                         {,},; // userfuncs
                         {{},,,,,,,,} ,;
                         {}  ;
                         }

// veersion 1  { {{},{},{}},{},{},"","",{},.f., 1,0,0,.F.,0,0, {},{},0,0,"",{{},{{,},{,},{,},{,},{,},{,},{,},{,}}},0,0,"", 0, {'','','','','','','','','',''}, {0,0,0,0,0},{,,,,}," ", .t.,.f.,{{},{}},{rpDEFAULT_EXTENSIONS}, 0.0 },;// runtime

/*========================================================================*/

/* relation types
--------------------*/
#DEFINE rpREL_ONE_TO_ONE    1
#DEFINE rpREL_ONE_TO_MANY   2
#DEFINE rpREL_RECNO         3

#DEFINE RP_RELTYPES   {"Exact", "Scan", "Approx." , "Recno" }

/* seek types
---------------*/
#DEFINE rpREL_SEEK_EXACT   1
#DEFINE rpREL_SEEK_SOFT    2

/* failure actions
--------------------*/
#DEFINE rpFAILURE_BLANK_REC     1
#DEFINE rpFAILURE_PARENT_SKIP   2
#DEFINE rpFAILURE_TERMINATE     3

#DEFINE RP_FAILTYPES   {"Blank", "Skip", "Terminate" }

/* printer orientation
-----------------------*/
#DEFINE rpPORTRAIT    1
#DEFINE rpLANDSCAPE   2

/* printer attributes
----------------------*/
#DEFINE rpBOLD                    1
#DEFINE rpITALIC                  2
#DEFINE rpUNDERSCORE              3
#DEFINE rpBOLD_ITALIC             4
#DEFINE rpBOLD_UNDERSCORE         5
#DEFINE rpBOLD_ITALIC_UNDERSCORE  6
#DEFINE rpITALIC_UNDERSCORE       7
#DEFINE rpATTR_NONE               8

/* valid line types
---------------------*/
#DEFINE RP_TITLE         1
#DEFINE RP_PAGE_HEADER   2
#DEFINE RP_HEADER        3
#DEFINE RP_BODY          4
#DEFINE RP_FOOTER        5
#DEFINE RP_SUMMARY       6
#DEFINE RP_PAGE_FOOTER   7

#DEFINE RP_LINE_PARSE_STR  "RP_TITLE;RP_PAGE_HEADER;RP_HEADER;RP_BODY;RP_FOOTER;RP_PAGE_FOOTER;RP_SUMMARY"

/* justifications
-------------------*/
#DEFINE rpDEFAULT_JUSTIFY  0
#DEFINE rpLEFT_JUSTIFY     1
#DEFINE rpRIGHT_JUSTIFY    2
#DEFINE rpCENTER_JUSTIFY   3
#DEFINE rpFULL_JUSTIFY     4
#DEFINE rpWRAP_LEFT     5    // only used by importer
#DEFINE rpWRAP_RIGHT    6    // only used by importer
#DEFINE rpWRAP_FULL     7    // only used by importer

/* total types
----------------*/
#DEFINE RP_TOTAL_TYPE_STR  {"Count", "Sum", "Average", "Lowest", "Highest", "Deviation", "Variance" }

#DEFINE RP_COUNT        1
#DEFINE RP_SUM          2
#DEFINE RP_AVERAGE      3
#DEFINE RP_LOWEST       4
#DEFINE RP_HIGHEST      5
#DEFINE RP_DEVIATION    6
#DEFINE RP_VARIANCE     7

/* process types
------------------*/
#DEFINE RP_RUNNING       1
#DEFINE RP_PREPROCESSED  2


/* file open types
--------------------*/
#DEFINE rpOPEN_SHARED        1
#DEFINE rpOPEN_READONLY      2


/* break types
---------------*/
#DEFINE RP_PAGEBREAK    	100
#DEFINE RP_GRANDTOTAL   	101

#DEFINE RP_ZERO_FIELD_LEN  	128

/* error types
----------------*/
#DEFINE rpERROR_CREATE                 1
#DEFINE rpERROR_OPEN                   2
#DEFINE rpERROR_WRITE                  3
#DEFINE rpERROR_CLOSE                  4
#DEFINE rpERROR_TIMEOUT                5
#DEFINE rpERROR_NO_RECORDS             6
#DEFINE rpERROR_NO_DATABASES           7
#DEFINE rpERROR_OVERLAP                8
#DEFINE rpERROR_INVALID_PRINTER        9
#DEFINE rpERROR_SORTING                10
#DEFINE rpERROR_USER_ABORT             11
#DEFINE rpERROR_RELATE_FAIL            12
#DEFINE rpERROR_CIRCULAR_REF           13
#DEFINE rpERROR_NAME_EXISTS            14
#DEFINE rpERROR_INCON_RESET_LEVEL      15
#DEFINE rpERROR_EOF                    16
#DEFINE rpERROR_NO_LOW_SCOPE_FOUND     17
#DEFINE rpERROR_LOW_SCOPE_BOUNDS       18
#DEFINE rpERROR_FAILURE_PARENT_SKIP    19
#DEFINE rpERROR_FAILURE_TERMINATE      20
#DEFINE rpERROR_EVALUATION             21
#DEFINE rpERROR_NO_OUTFILE_SPECIFIED   22
#DEFINE rpERROR_REPORT_RESTART         23
#DEFINE rpERROR_RFO_MATCH_FAILURE      24
#DEFINE rpERROR_DISK_FULL              25
#DEFINE rpERROR_FILE_NOT_FOUND         26
#DEFINE rpERROR_DUPLICATE_FIELD        27
#DEFINE rpERROR_MISSING_RDD            28
#DEFINE rpERROR_MISSING_TAG            29
#DEFINE rpERROR_KEY_MATCH_FAILED       30
#DEFINE rpERROR_SWAP_CREATE            31
#DEFINE rpERROR_FONT_NOT_FOUND         32
#DEFINE rpERROR_JOB_INITIALIZE         33

/* message types
------------------*/
#DEFINE rpMESSAGE_WAIT                 1
#DEFINE rpMESSAGE_RECS_STATUS          2
#DEFINE rpMESSAGE_PAGE_STATUS          3
#DEFINE rpMESSAGE_OPTIMIZING           4
#DEFINE rpMESSAGE_TEXT_EDIT            5
#DEFINE rpMESSAGE_FIELD_IN_USE         6
#DEFINE rpMESSAGE_INVALID_NAME         7
#DEFINE rpMESSAGE_REQUIRED_FIELD       8
#DEFINE rpMESSAGE_BAD_EXPRESSION       9
#DEFINE rpMESSAGE_SCOPE_LOW_GT_HIGH    10
#DEFINE rpMESSAGE_NEW_PAGE_NO_FIELDS   11
#DEFINE rpMESSAGE_NO_DELETE_LINK       12
#DEFINE rpMESSAGE_NO_FLDS_MATCH_TOTAL  13
#DEFINE rpMESSAGE_DB_OPEN_ERROR        14
#DEFINE rpMESSAGE_INDEX_OPEN_ERROR     15
#DEFINE rpMESSAGE_PREPROCESSING        16
#DEFINE rpMESSAGE_PRINTER_FAIL         17
#DEFINE rpMESSAGE_CIRCULAR_REF         18
#DEFINE rpMESSAGE_GEN_CODE             19
#DEFINE rpMESSAGE_QUIT                 20
#DEFINE rpMESSAGE_RFO_MATCH_FAILURE    21
#DEFINE rpMESSAGE_NO_INDEX_FOUND       22
#DEFINE rpMESSAGE_NO_FILE_FOUND        23
#DEFINE rpMESSAGE_REPORT_NOT_FOUND     24
#DEFINE rpMESSAGE_NO_FIELD_OF_TYPE     25
#DEFINE rpMESSAGE_NO_KEY_MATCH         26
#DEFINE rpMESSAGE_PAGE_WAIT            27
#DEFINE rpMESSAGE_IMPORTING            28
#DEFINE rpMESSAGE_REPRINT_PAGE         29
#DEFINE rpMESSAGE_INVALID_PRINTER      30
#DEFINE rpMESSAGE_LOADING_REPORT       31
#DEFINE rpMESSAGE_FILE_NOT_FOUND       32
#DEFINE rpMESSAGE_INVALID_PATH         33
#DEFINE rpMESSAGE_ALIAS_EXISTS         34
#DEFINE rpMESSAGE_SINGLE_REPORT        35
#DEFINE rpMESSAGE_PASTE_BUFFER_EMPTY   36
#DEFINE rpMESSAGE_LOADING_FONTS        37
#DEFINE rpMESSAGE_FONT_NOT_FOUND       38
#DEFINE rpMESSAGE_FILE_CREATE          39
#DEFINE rpMESSAGE_JOB_ERROR            40
#DEFINE rpMESSAGE_NO_FONT_DEFINED      41
#DEFINE rpMESSAGE_OPTION_UNAVAILABLE  100

/* used in determining which
   sub-arr of format blocks to use
-----------------------------------*/
#DEFINE C_BLOCKS   1
#DEFINE N_BLOCKS   2
#DEFINE D_BLOCKS   3
#DEFINE L_BLOCKS   4


/* *-DESTINATIONS TYPES-*
--------------------------*/
#DEFINE RP_DESTINATION_TYPES  { "Printer", "Printer File", "Display" }
//#DEFINE RP_DESTINATION_TYPES  { "Printer", "Printer File", "Display","TreeDucer" } // TREEDUCER

#DEFINE rpPRINTER             1
#DEFINE rpPRINTER_FILE        2
#DEFINE rpDISPLAY             3
//#DEFINE rpTREEDUCER	      4 // TREEDUCER

/* *-REPORT OBJECT TYPE-*
---------------------------*/
#DEFINE rpREPORT_OBJECT_TYPE      20

/* PCL language types
----------------------*/
#DEFINE rpPCL_4			256
#DEFINE rpPCL_5			257

/* paper size types
--------------------*/
#DEFINE rpLETTER        	1
#DEFINE rpLEGAL         	5
#DEFINE rpEXEC          	7
#DEFINE rpA3 			8
#DEFINE rpA4 			9

/* bar code types
------------------*/
#DEFINE rpBAR_NONE                 0
#DEFINE rpBAR_POSTNET              1
#DEFINE rpBAR_CODE39               2
#DEFINE rpBAR_CODE39C              3
#DEFINE rpBAR_INTER25              4
#DEFINE rpBAR_INTER25C             5
#DEFINE rpBAR_CODABAR              6
#DEFINE rpBAR_CODE128              7


/* border types
------------------*/
#DEFINE rpBORDER_NONE     	   0
#DEFINE rpBORDER_TLBR     	   1
#DEFINE rpBORDER_T        	   2
#DEFINE rpBORDER_L        	   3
#DEFINE rpBORDER_B        	   4
#DEFINE rpBORDER_R        	   5
#DEFINE rpBORDER_TL       	   6
#DEFINE rpBORDER_TB       	   7
#DEFINE rpBORDER_TR       	   8
#DEFINE rpBORDER_TLB      	   9
#DEFINE rpBORDER_TLR      	  10
#DEFINE rpBORDER_TRB      	  11
#DEFINE rpBORDER_BL       	  12
#DEFINE rpBORDER_BR       	  13
#DEFINE rpBORDER_BLR      	  14
#DEFINE rpBORDER_LR       	  15

/* border styles
------------------*/
#DEFINE rpBORDER_SINGLE   	   1
#DEFINE rpBORDER_DOUBLE   	   2


/* paper sources
------------------*/
#define rpTRAY_UPPER               1
#define rpTRAY_LOWER               2
#define rpTRAY_MANUAL              4
#define rpTRAY_DEFAULT             7
#define rpTRAY_DECK               14


#ifndef TIGHTMEM

/* Intellifont fonts
----------------------*/
#define ALBERTUS       "9NB18467" // Albertus
#define ALBERTUS_B     "9NB00041" // Albertus Extra Bold
#define OLIVE          "9NB19169" // Antique Olive
#define OLIVE_I        "9NB26500" // Antique Olive Italic
#define OLIVE_B        "9NB06334" // Antique Olive Bold
#define CLARENDON      "9NB15724" // Clarendon Condensed
#define CORONET        "9NB03902" // Coronet
#define COURIER        "9NB24464" // Courier
#define COURIER_I      "9NB29358" // Courier Italic
#define COURIER_B      "9NB11478" // Courier Bold
#define COURIER_BI     "9NB26962" // Courier Bold/Italic
#define ANTIQUA        "9NB16827" // Garamond Antiqua
#define KURSIV         "9NB28145" // Garamond Kursiv
#define HALBFETT       "9NB05705" // Garamond Halbfett
#define KURS_HALB      "9NB23281" // Garamond Kursic/Halbfett
#define LGOTHIC        "9NB02995" // Letter Gothic
#define LGOTHIC_I      "9NB00491" // Letter Gothic Italic
#define LGOTHIC_B      "9NB09961" // Letter Gothic Bold
#define MARIGOLD       "9NB11942" // Marigold
#define OMEGA          "9NB14604" // Omega
#define OMEGA_I        "9NB05436" // Omega Italic
#define OMEGA_B        "9NB04827" // Omega Bold
#define OMEGA_BI       "9NB32391" // Omega Bold/Italic
#define CGTIMES        "9NB17421" // CG Times
#define CGTIMES_I      "9NB00292" // CG Times Italic
#define CGTIMES_B      "9NB00153" // CG Times Bold
#define CGTIMES_BI     "9NB12382" // CG Times Bold/Italic
#define UNIVERS        "9NB01869" // Univers
#define UNIVERS_I      "9NB14771" // Univers Italic
#define UNIVERS_B      "9NB19718" // Univers Bold
#define UNIVERS_BI     "9NB11538" // Univers Bold/Italic
#define UNICOND        "9NB19895" // Univers Condensed
#define UNICOND_I      "9NB18716" // Univers Condensed Italic
#define UNICOND_B      "9NB05447" // Univers Condensed Bold
#define UNICOND_BI     "9NB21726" // Univers Condensed Bold/Italic


/* TrueType fonts
------------------*/
#define ARIAL          "9NB17035" // Arial
#define ARIAL_I        "9NB25667" // Arial Italic
#define ARIAL_B        "9NB19912" // Arial Bold
#define ARIAL_BI       "9NB26299" // Arial Bold/Italic
#define SYMBOL         "9NB28703" // Symbol
#define TIMESNR        "9NB17673" // Times New Roman
#define TIMESNR_I      "9NB31322" // Times New Roman Italic
#define TIMESNR_B      "9NB23811" // Times New Roman Bold
#define TIMESNR_BI     "9NB30333" // Times New Roman Bold/Italic
#define WINGDINGS     " 9NB09894" // Wingdings

#endif


/* Symbol Sets
----------------*/
#define rpSS_ASCII            "0U" // ASCII

#ifndef TIGHTMEM

#define rpSS_LEGAL            "1U" // Legal
#define rpSS_ROMAN8           "8U" // Roman-8
#define rpSS_PC8             "10U" // PC-8 (Code Page 437)
#define rpSS_PC8DN           "11U" // PC-8 Danish/Norwegian
#define rpSS_PC850           "12U" // PC-850 Multilingual
#define rpSS_PI_FONT         "15U" // Pi Font
#define rpSS_PC852           "17U" // PC-865, Latin 2
#define rpSS_PC860           "20U" // PC 860 Portugal
#define rpSS_PC861           "21U" // PC 861 Iceland
#define rpSS_PC863           "23U" // PC 863 Canada-French
#define rpSS_PC865           "25U" // PC 865 Norway
#define rpSS_ARABIC8          "8V" // Arabic-8
#define rpSS_PCLA            "10V" // PC Latin/Arabic
#define rpSS_WIN30L1          "9U" // Windows 3.0 Latin 1
#define rpSS_WIN31L2          "9E" // Windows 3.1 Latin 2
#define rpSS_WIN31LG          "9G" // WIndows 3.1 Latin/Greek
#define rpSS_WIN31LA          "9V" // Windows 3.1 Latin/Arabic
#define rpSS_WIN31LC          "9R" // Windows 3.1 Latin/Cyrilli
#define rpSS_TAXLD            "2L" // Tax Line Draw
#define rpSS_ZDB_V            "9L" // Ventura ITC Zapf Dingbats
#define rpSS_ZDB             "10L" // PS ITC Zapf Dingbats
#define rpSS_ZDB100          "11L" // ITC Zapf Dingbats 100
#define rpSS_ZDB200          "12L" // ITC Zapf Dingbats 200
#define rpSS_ZDB300          "13L" // ITC Zapf Dingbats 300
#define rpSS_WD             "579L" // Wing Dings
#define rpSS_OCR_A            "0O" // OCR A
#define rpSS_OCR_B            "1O" // OCR B
#define rpSS_OCR_M            "2O" // OCR M
#define rpSS_MICR            "10O" // MICR
#define rpSS_LATIN1           "0N" // ISO 8859/1 Latin 1
#define rpSS_LATIN2           "2N" // ISO 8859/2 Latin 2
#define rpSS_LATIN3           "3N" // ISO 8859/3 Latin 3
#define rpSS_LATIN4           "4N" // ISO 8859/4 Latin 4
#define rpSS_LATIN5          "10N" // ISO 8859/9 Latin 5
#define rpSS_MSPUB            "6J" // Microsoft Publishing
#define rpSS_DESKTOP          "7J" // DeskTop
#define rpSS_PS_TEXT         "10J" // PS Text
#define rpSS_V_INTL          "13J" // Ventura International
#define rpSS_V_US            "14J" // Venture US
#define rpSS_PS_MATH          "5M" // PS Math
#define rpSS_V_MATH           "6M" // Ventura Math
#define rpSS_MATH_8           "8M" // Math-8

#endif

/* *-USER OUTPUT BLOCK ELEMENTS-*
-----------------------------------*/
#DEFINE  rpUSER_OUT_RFO         1
#DEFINE  rpUSER_OUT_START       2
#DEFINE  rpUSER_OUT_END         3
#DEFINE  rpUSER_OUT_ON          4
#DEFINE  rpUSER_OUT_OFF         5
#DEFINE  rpUSER_OUT_VAL         6
#DEFINE  rpUSER_OUT_ISWRAP      7
#DEFINE  rpUSER_OUT_ISTRIM      8
#DEFINE  rpUSER_OUT_JUSTIFY     9
#DEFINE  rpUSER_OUT_ISTEXT     10

#DEFINE rpDEFAULT_EXTENSIONS "DBFNTX,DBF,NTX"    ,;
                             "DBFCDX,DBF,CDX,IDX",;
                             "DBFNDX,DBF,NDX"    ,;
                             "DBFMDX,DBF,MDX"    ,;
                             "DBPX,DB,PX,X,Y"

//#DEFINE rpGENERIC_VIDEO
#IFDEF rpGENERIC_VIDEO
   #xtranslate csrput( <r>, <c> ) => DEVPOS( <r>, <c> )
#ENDIF


// FROM FUNCKYII
   /*
   *  Clipper Like Defines
   */

#define NOT .not.
#define OR .or.
#define AND .and.
#define DOWHILE  DO WHILE

#define EQ  ==
#define GT  >
#define LT  <
#define GE  >=
#define LE  <=
#define NE  !=

#define DOUBLE    "ÉÍ»º¼ÍÈº "
#define SINGLE    "ÚÄ¿³ÙÄÀ³ "

#IFDEF STANDALONE
  #define FALSE  .F.
  #define TRUE   .T.
#ENDIF

#define NULLSTR   ""
#define NULL	  nil
#define ERROR     -1
//#define DEFAULT   -2

#define ENTER        13
#define ESC          27

#define A_NORMAL      0
#define A_READONLY    1
#define A_HIDDEN      2
#define A_SYSTEM      4
#define A_DIRECTORY   16
#define A_ARCHIVE     32
#define A_COMBINE     32

#DEFINE K_SHIFT_F11        -42
#DEFINE K_SHIFT_F12        -43

