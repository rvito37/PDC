static ___h___

/////////////////////////////////////////////////////////////////////
//          THESE ARE *STRICTLY* GET/SET ROUTINES                  //
// MAJOR PROBLEMS IF THE REAL FUNCTION DOES MORE THAN GET/SET!!!!  //
/////////////////////////////////////////////////////////////////////

#xtranslate rpTop( <oRP> )                   => <oRP>\[ rpREPORT \]\[ rpREPORT_TOP \]
#xtranslate rpTop( <oRP> , <Val> )           => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_TOP \], <oRP>\[ rpREPORT \]\[ rpREPORT_TOP \] := <Val>, ___h___)

#xtranslate rpLeft( <oRP> )                  => <oRP>\[ rpREPORT \]\[ rpREPORT_LEFT \]
#xtranslate rpLeft( <oRP> , <Val> )          => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_LEFT \], <oRP>\[ rpREPORT \]\[ rpREPORT_LEFT \] := <Val>, ___h___)

#xtranslate rpBottom( <oRP> )                => <oRP>\[ rpREPORT \]\[ rpREPORT_BOTTOM \]
#xtranslate rpBottom( <oRP> , <Val> )        => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_BOTTOM \], <oRP>\[ rpREPORT \]\[ rpREPORT_BOTTOM \] := <Val>, ___h___)

#xtranslate rpRight( <oRP> )                 => <oRP>\[ rpREPORT \]\[ rpREPORT_RIGHT \]
#xtranslate rpRight( <oRP> , <Val> )         => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_RIGHT \], <oRP>\[ rpREPORT \]\[ rpREPORT_RIGHT \] := <Val>, ___h___)

#xtranslate rpColor( <oRP> )                 => <oRP>\[ rpREPORT \]\[ rpREPORT_COLOR \]
#xtranslate rpColor( <oRP> , <Val> )         => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_COLOR \], <oRP>\[ rpREPORT \]\[ rpREPORT_COLOR \] := <Val>, ___h___)

#xtranslate rpErrorColor( <oRP> )            => <oRP>\[ rpREPORT \]\[ rpREPORT_ERROR_COLOR \]
#xtranslate rpErrorColor( <oRP> , <Val> )    => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_ERROR_COLOR \], <oRP>\[ rpREPORT \]\[ rpREPORT_ERROR_COLOR \] := <Val>, ___h___)

#xtranslate rpActiveColor( <oRP> )           => <oRP>\[ rpREPORT \]\[ rpREPORT_ACTIVE_COLOR \]
#xtranslate rpActiveColor( <oRP> , <Val> )   => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_ACTIVE_COLOR \], <oRP>\[ rpREPORT \]\[ rpREPORT_ACTIVE_COLOR \] := <Val>, ___h___)

#xtranslate rpMoveColor( <oRP> )             => <oRP>\[ rpREPORT \]\[ rpREPORT_MOVE_COLOR \]
#xtranslate rpMoveColor( <oRP> , <Val> )     => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_MOVE_COLOR \], <oRP>\[ rpREPORT \]\[ rpREPORT_MOVE_COLOR \] := <Val>, ___h___)

#xtranslate rpTopOrg( <oRP> )                => <oRP>\[ rpREPORT \]\[ rpREPORT_TOPORG \]
#xtranslate rpTopOrg( <oRP> , <Val> )        => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_TOPORG \], <oRP>\[ rpREPORT \]\[ rpREPORT_TOPORG \] := <Val>, ___h___)

#xtranslate rpLeftOrg( <oRP> )               => <oRP>\[ rpREPORT \]\[ rpREPORT_LEFTORG \]
#xtranslate rpLeftOrg( <oRP> , <Val> )       => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_LEFTORG \], <oRP>\[ rpREPORT \]\[ rpREPORT_LEFTORG \] := <Val>, ___h___)

#xtranslate rpRepaint( <oRP> )               => <oRP>\[ rpREPORT \]\[ rpREPORT_REPAINT \]
#xtranslate rpRepaint( <oRP> , <Val> )       => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_REPAINT \], <oRP>\[ rpREPORT \]\[ rpREPORT_REPAINT \] := <Val>, ___h___)

#IFNDEF TIGHTMEM

   #xtranslate rpJumpSize( <oRP> )              => <oRP>\[ rpREPORT \]\[ rpREPORT_JUMPSIZE \]
   #xtranslate rpJumpSize( <oRP> , <Val> )      => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_JUMPSIZE \], <oRP>\[ rpREPORT \]\[ rpREPORT_JUMPSIZE \] := <Val>, ___h___)

   #xtranslate rpJumpFlag( <oRP> )              => <oRP>\[ rpREPORT \]\[ rpREPORT_JUMPFLAG \]
   #xtranslate rpJumpFlag( <oRP> , <Val> )      => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_JUMPFLAG \], <oRP>\[ rpREPORT \]\[ rpREPORT_JUMPFLAG \] := <Val>, ___h___)

   #xtranslate rpPageLen( <oRP> )               => <oRP>\[ rpREPORT \]\[ rpREPORT_PAGELEN \]
   #xtranslate rpPageLen( <oRP> , <Val> )       => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_PAGELEN \], <oRP>\[ rpREPORT \]\[ rpREPORT_PAGELEN \] := <Val>, ___h___)

   #xtranslate rpTopMargin( <oRP> )             => <oRP>\[ rpREPORT \]\[ rpREPORT_MARGIN_TOP \]
   #xtranslate rpTopMargin( <oRP> , <Val> )     => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_MARGIN_TOP \], <oRP>\[ rpREPORT \]\[ rpREPORT_MARGIN_TOP \] := <Val>, ___h___)

   #xtranslate rpLeftMargin( <oRP> )            => <oRP>\[ rpREPORT \]\[ rpREPORT_MARGIN_LEFT \]
   #xtranslate rpLeftMargin( <oRP> , <Val> )    => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_MARGIN_LEFT \], <oRP>\[ rpREPORT \]\[ rpREPORT_MARGIN_LEFT \] := <Val>, ___h___)

   #xtranslate rpBottomMargin( <oRP> )          => <oRP>\[ rpREPORT \]\[ rpREPORT_MARGIN_BOTTOM \]
   #xtranslate rpBottomMargin( <oRP> , <Val> )  => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_MARGIN_BOTTOM \], <oRP>\[ rpREPORT \]\[ rpREPORT_MARGIN_BOTTOM \] := <Val>, ___h___)

   #xtranslate rpRightMargin( <oRP> )           => <oRP>\[ rpREPORT \]\[ rpREPORT_MARGIN_RIGHT \]
   #xtranslate rpRightMargin( <oRP> , <Val> )   => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_MARGIN_RIGHT \], <oRP>\[ rpREPORT \]\[ rpREPORT_MARGIN_RIGHT \] := <Val>, ___h___)

   #xtranslate rpSemiNewLine( <oRP> )           => <oRP>\[ rpREPORT \]\[ rpREPORT_NEWLINE_SEMI  \]
   #xtranslate rpSemiNewLine( <oRP> , <Val> )   => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_NEWLINE_SEMI  \], <oRP>\[ rpREPORT \]\[ rpREPORT_NEWLINE_SEMI \] := <Val>, ___h___)

   #xtranslate rpOverMode( <oRP> )              => <oRP>\[ rpREPORT \]\[ rpREPORT_OVER_APPEND  \]
   #xtranslate rpOverMode( <oRP> , <Val> )      => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_OVER_APPEND  \], <oRP>\[ rpREPORT \]\[ rpREPORT_OVER_APPEND \] := <Val>, ___h___)

   #xtranslate rpBreakBody( <oRP> )             => <oRP>\[ rpREPORT \]\[ rpREPORT_BREAK_BODY  \]
   #xtranslate rpBreakBody( <oRP> , <Val> )     => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_BREAK_BODY  \], <oRP>\[ rpREPORT \]\[ rpREPORT_BREAK_BODY \] := <Val>, ___h___)

   #xtranslate rpPrinter( <oRP> )               => <oRP>\[ rpREPORT \]\[ rpREPORT_PRINTER \]
   #xtranslate rpPrinter( <oRP> , <Val> )       => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_PRINTER \], <oRP>\[ rpREPORT \]\[ rpREPORT_PRINTER \] := <Val>, ___h___)

   #xtranslate rpDestination( <oRP> )           => <oRP>\[ rpREPORT \]\[ rpREPORT_DEST \]
   #xtranslate rpDestination( <oRP> , <Val> )   => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_DEST \], <oRP>\[ rpREPORT \]\[ rpREPORT_DEST \] := <Val>, ___h___)

   #xtranslate rpOutHandle( <oRP> )             => <oRP>\[ rpREPORT \]\[ rpREPORT_HANDLE \]
   #xtranslate rpOutHandle( <oRP> , <Val> )     => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_HANDLE \], <oRP>\[ rpREPORT \]\[ rpREPORT_HANDLE \] := <Val>, ___h___)

   #xtranslate rpOutFile( <oRP> )               => <oRP>\[ rpREPORT \]\[ rpREPORT_OUTFILE \]
   #xtranslate rpOutFile( <oRP> , <Val> )       => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_OUTFILE \], <oRP>\[ rpREPORT \]\[ rpREPORT_OUTFILE \] := <Val>, ___h___)

   #xtranslate rpRecsAcross( <oRP> )            => <oRP>\[ rpREPORT \]\[ rpREPORT_RECS_ACROSS \]
   #xtranslate rpRecsAcross( <oRP> , <Val> )    => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_RECS_ACROSS \], <oRP>\[ rpREPORT \]\[ rpREPORT_RECS_ACROSS \] := <Val>, ___h___)

   #xtranslate rpRecHeight( <oRP> )             => <oRP>\[ rpREPORT \]\[ rpREPORT_REC_HEIGHT \]
   #xtranslate rpRecHeight( <oRP> , <Val> )     => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_REC_HEIGHT \], <oRP>\[ rpREPORT \]\[ rpREPORT_REC_HEIGHT \] := <Val>, ___h___)

   #xtranslate rpRecWidth( <oRP> )              => <oRP>\[ rpREPORT \]\[ rpREPORT_REC_WIDTH  \]
   #xtranslate rpRecWidth( <oRP> , <Val> )      => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_REC_WIDTH \], <oRP>\[ rpREPORT \]\[ rpREPORT_REC_WIDTH  \] := <Val>, ___h___)

   #xtranslate rpCopies( <oRP> )                => <oRP>\[ rpREPORT \]\[ rpREPORT_COPIES \]
   #xtranslate rpCopies( <oRP> , <Val> )        => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_COPIES \], <oRP>\[ rpREPORT \]\[ rpREPORT_COPIES \] := <Val>, ___h___)

   #xtranslate rpStartPage( <oRP> )             => <oRP>\[ rpREPORT \]\[ rpREPORT_START_PAGE \]
   #xtranslate rpStartPage( <oRP> , <Val> )     => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_START_PAGE \], <oRP>\[ rpREPORT \]\[ rpREPORT_START_PAGE \] := <Val>, ___h___)

   #xtranslate rpEndPage( <oRP> )               => <oRP>\[ rpREPORT \]\[ rpREPORT_END_PAGE \]
   #xtranslate rpEndPage( <oRP> , <Val> )       => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_END_PAGE \], <oRP>\[ rpREPORT \]\[ rpREPORT_END_PAGE \] := <Val>, ___h___)

   #xtranslate rpLinesPerInch( <oRP> )          => <oRP>\[ rpREPORT \]\[ rpREPORT_LINES_PER_INCH \]
   #xtranslate rpLinesPerInch( <oRP> , <Val> )  => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_LINES_PER_INCH \], <oRP>\[ rpREPORT \]\[ rpREPORT_LINES_PER_INCH \] := <Val>, ___h___)

   #xtranslate rpCharsPerInch( <oRP> )          => <oRP>\[ rpREPORT \]\[ rpREPORT_CHARS_PER_INCH \]
   #xtranslate rpCharsPerInch( <oRP> , <Val> )  => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_CHARS_PER_INCH \], <oRP>\[ rpREPORT \]\[ rpREPORT_CHARS_PER_INCH \] := <Val>, ___h___)

   #xtranslate rpPageWait( <oRP> )              => <oRP>\[ rpREPORT \]\[ rpREPORT_PAGE_WAIT \]
   #xtranslate rpPageWait( <oRP> , <Val> )      => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_PAGE_WAIT \], <oRP>\[ rpREPORT \]\[ rpREPORT_PAGE_WAIT \] := <Val>, ___h___)

   #xtranslate rpEjectLastPage( <oRP> )         => <oRP>\[ rpREPORT \]\[ rpREPORT_EJECT_FINAL \]
   #xtranslate rpEjectLastPage( <oRP> , <Val> ) => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_EJECT_FINAL \], <oRP>\[ rpREPORT \]\[ rpREPORT_EJECT_FINAL \] := <Val>, ___h___)

   #xtranslate rpOrientation( <oRP> )           => <oRP>\[ rpREPORT \]\[ rpREPORT_PAGE_ORIENT \]
   #xtranslate rpOrientation( <oRP> , <Val> )   => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_PAGE_ORIENT \], <oRP>\[ rpREPORT \]\[ rpREPORT_PAGE_ORIENT \] := <Val>, ___h___)

   #xtranslate rpHFInSummary(  <oRP> )          => <oRP>\[ rpREPORT \]\[ rpREPORT_HEADFOOT_IN_SUMMAY  \]
   #xtranslate rpHFInSummary(  <oRP> , <Val> )  => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_HEADFOOT_IN_SUMMAY  \], <oRP>\[ rpREPORT \]\[ rpREPORT_HEADFOOT_IN_SUMMAY  \] := <Val>, ___h___)

   #xtranslate rpPrintData( <oRP> )           => <oRP>\[ rpREPORT \]\[ rpLEVEL_PRINT_DATA \]
   #xtranslate rpPrintData( <oRP> , <Val> )   => (___h___ := <oRP>\[ rpREPORT \]\[ rpLEVEL_PRINT_DATA \], <oRP>\[ rpREPORT \]\[ rpLEVEL_PRINT_DATA \] := <Val>, ___h___)

   #xtranslate rpCompressBody( <oRP> )           => <oRP>\[ rpREPORT \]\[ rpREPORT_COMPRESS_BODY_GRP \]
   #xtranslate rpCompressBody( <oRP> , <Val> )   => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_COMPRESS_BODY_GRP \], <oRP>\[ rpREPORT \]\[ rpREPORT_COMPRESS_BODY_GRP \] := <Val>, ___h___)

   #xtranslate rpSuppressBody( <oRP> )           => <oRP>\[ rpREPORT \]\[ rpREPORT_SUPPRESS_BODY \]
   #xtranslate rpSuppressBody( <oRP> , <Val> )   => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_SUPPRESS_BODY \], <oRP>\[ rpREPORT \]\[ rpREPORT_SUPPRESS_BODY \] := <Val>, ___h___)


   //----- LINE STUFF -----//
   #xtranslate rpLineRow( <oLine> )             => <oLine>\[ rpLINE_ROW \]
   #xtranslate rpLineRow( <oLine> , <Val> )     => (___h___ := <oLine>\[ rpLINE_ROW \], <oLine>\[ rpLINE_ROW \] := <Val>, ___h___)

   #xtranslate rpLineType( <oLine> )            => <oLine>\[ rpLINE_TYPE \]
   #xtranslate rpLineType( <oLine> , <Val> )    => (___h___ := <oLine>\[ rpLINE_TYPE \], <oLine>\[ rpLINE_TYPE \] := <Val>, ___h___)

   #xtranslate rpLineNewPage( <oLine> )         => <oLine>\[ rpLINE_NEWPAGE \]
   #xtranslate rpLineNewPage( <oLine> , <Val> ) => (___h___ := <oLine>\[ rpLINE_NEWPAGE \], <oLine>\[ rpLINE_NEWPAGE \] := <Val>, ___h___)

   #xtranslate rpLineFilter( <oLine> )          => <oLine>\[ rpLINE_FILTER \]
   #xtranslate rpLineFilter( <oLine> , <Val> )  => (___h___ := <oLine>\[ rpLINE_FILTER \], <oLine>\[ rpLINE_FILTER \] := <Val>, ___h___)

   #xtranslate rpLAutoTrim( <oLine> )           => <oLine>\[ rpLINE_AUTOTRIM \]
   #xtranslate rpLAutoTrim( <oLine> , <Val> )   => (___h___ := <oLine>\[ rpLINE_AUTOTRIM \], <oLine>\[ rpLINE_AUTOTRIM \] := <Val>, ___h___)

   #xtranslate rpLineColor( <oLine> )           => <oLine>\[ rpLINE_COLOR \]
   #xtranslate rpLineColor( <oLine> , <Val> )   => (___h___ := <oLine>\[ rpLINE_COLOR \], <oLine>\[ rpLINE_COLOR \] := <Val>, ___h___)

   #xtranslate rpLineLevel( <oLine> )           => <oLine>\[ rpLINE_LEVEL \]
   #xtranslate rpLineLevel( <oLine> , <Val> )   => (___h___ := <oLine>\[ rpLINE_LEVEL \], <oLine>\[ rpLINE_LEVEL \] := <Val>, ___h___)
   //----- LINE STUFF -----//

   //----- RFO STUFF -----//
   #xtranslate rpRFldBlock( <oField> )           => <oField>\[ rpFIELD_BLOCK \]
   #xtranslate rpRFldBlock( <oField> , <Val> )   => (___h___ := <oField>\[ rpFIELD_BLOCK \], <oField>\[ rpFIELD_BLOCK \] := <Val>, ___h___)

   #xtranslate rpRFldDec( <oField> )             => <oField>\[ rpFIELD_DEC \]
   #xtranslate rpRFldDec( <oField> , <Val> )     => (___h___ := <oField>\[ rpFIELD_DEC \], <oField>\[ rpFIELD_DEC \] := <Val>, ___h___)

   #xtranslate rpRFldLen( <oField> )             => <oField>\[ rpFIELD_LEN \]
   #xtranslate rpRFldLen( <oField> , <Val> )     => (___h___ := <oField>\[ rpFIELD_LEN \], <oField>\[ rpFIELD_LEN \] := <Val>, ___h___)

   #xtranslate rpRFldLevel( <oField> )           => <oField>\[ rpFIELD_LEVEL \]
   #xtranslate rpRFldLevel( <oField> , <Val> )   => (___h___ := <oField>\[ rpFIELD_LEVEL \], <oField>\[ rpFIELD_LEVEL \] := <Val>, ___h___)

   #xtranslate rpRFldLong( <oField> )            => <oField>\[ rpFIELD_LONGNAME \]
   #xtranslate rpRFldLong( <oField> , <Val> )    => (___h___ := <oField>\[ rpFIELD_LONGNAME \], <oField>\[ rpFIELD_LONGNAME \] := <Val>, ___h___)

   #xtranslate rpRFldName( <oField> )            => <oField>\[ rpFIELD_NAME \]
   #xtranslate rpRFldName( <oField> , <Val> )    => (___h___ := <oField>\[ rpFIELD_NAME \], <oField>\[ rpFIELD_NAME \] := <Val>, ___h___)

   #xtranslate rpRFldType( <oField> )            => <oField>\[ rpFIELD_TYPE \]
   #xtranslate rpRFldType( <oField> , <Val> )    => (___h___ := <oField>\[ rpFIELD_TYPE \], <oField>\[ rpFIELD_TYPE \] := <Val>, ___h___)

   #xtranslate rpRTableName( <oField> )          => <oField>\[ rpTABLE_NAME \]
   #xtranslate rpRTableName( <oField> , <Val> )  => (___h___ := <oField>\[ rpTABLE_NAME \], <oField>\[ rpTABLE_NAME \] := <Val>, ___h___)

   #xtranslate rpRFldAccFreq( <oField> )         => <oField>\[ rpFIELD_TOTAL_ACC_FREQ \]
   #xtranslate rpRFldAccFreq( <oField> , <Val> ) => (___h___ := <oField>\[ rpFIELD_TOTAL_ACC_FREQ \], <oField>\[ rpFIELD_TOTAL_ACC_FREQ \] := <Val>, ___h___)

   #xtranslate rpRFldProcess( <oField> )         => <oField>\[ rpFIELD_PROCESS_TYPE \]
   #xtranslate rpRFldProcess( <oField> , <Val> ) => (___h___ := <oField>\[ rpFIELD_PROCESS_TYPE \], <oField>\[ rpFIELD_PROCESS_TYPE \] := <Val>, ___h___)
   //----- RFO STUFF -----//

   //--------------------------------------------//
   //----- GET ONLY FROM GET/SET ROUTINES -------//
   //--------------------------------------------//
   #xtranslate rpRelType(   <oRel> )   => ( <oRel>\[ rpREL_TYPE \] )
   #xtranslate rpRelTMatch( <oRel> )   => ( <oRel>\[ rpREL_MATCHTEXT \] )
   #xtranslate rpRelBMatch( <oRel> )   => ( <oRel>\[ rpREL_MATCH \] )
   #xtranslate rpRelTSeek(  <oRel> )   => ( <oRel>\[ rpREL_SEEKTEXT \] )
   #xtranslate rpRelBSeek(  <oRel> )   => ( <oRel>\[ rpREL_SEEK \] )
   #xtranslate rpRelTo(     <oRel> )   => ( <oRel>\[ rpREL_TOALIAS \] )
   #xtranslate rpRelFrom(   <oRel> )   => ( <oRel>\[ rpREL_FROMALIAS \] )

   #xtranslate rpError( <oRP> )        => ( <oRP>\[ rpREPORT \]\[ rpREPORT_ERROR \])
   #xtranslate rpQuery( <oRP> )        => ( <oRP>\[ rpQUERY \]\[ rpQUERY_BLOCK \])
   //--------------------------------------------//
   //----- GET ONLY FROM GET/SET ROUTINES -------//
   //--------------------------------------------//

   #xtranslate rpUserBlock( <oRP> )           => <oRP>\[ rpUSERFUNCS \]\[ rpUSER_LINE_OUT_BLOCK \]
   #xtranslate rpUserBlock( <oRP> , <Val> )   => (___h___ := <oRP>\[ rpUSERFUNCS \]\[ rpUSER_LINE_OUT_BLOCK \], <oRP>\[ rpUSERFUNCS \]\[ rpUSER_LINE_OUT_BLOCK \] := <Val>, ___h___)

   #xtranslate rpRepoPath(  <oRP> )             => <oRP>\[ rpREPORT \]\[ rpREPORT_REPO_PATH  \]
   #xtranslate rpDataPath(  <oRP> )             => <oRP>\[ rpREPORT \]\[ rpREPORT_DATA_PATH  \]
   #xtranslate rpIndexPath( <oRP> )             => <oRP>\[ rpREPORT \]\[ rpREPORT_INDEX_PATH \]
   #xtranslate rpSwapPath(  <oRP> )             => <oRP>\[ rpREPORT \]\[ rpREPORT_SWAP_PATH  \]

   //----- RUNTIME STUFF -----//
   #xtranslate rpCurrCopy(  <oRP> )           => <oRP>\[ rpRUNTIME \]\[ rpRUNTIME_CURR_COPY \]
   #xtranslate rpCurrCopy(  <oRP> , <Val> )   => (___h___ := <oRP>\[ rpRUNTIME \]\[ rpRUNTIME_CURR_COPY \], <oRP>\[ rpRUNTIME \]\[ rpRUNTIME_CURR_COPY \] := <Val>, ___h___)

   #xtranslate rpBaseScreen( <oRP> )           => <oRP>\[ rpREPORT \]\[ rpREPORT_SAVESCREEN \]
   #xtranslate rpBaseScreen( <oRP> , <Val> )   => (___h___ := <oRP>\[ rpREPORT \]\[ rpREPORT_SAVESCREEN \], <oRP>\[ rpREPORT \]\[ rpREPORT_SAVESCREEN \] := <Val>, ___h___)
   //----- RUNTIME STUFF -----//


   //----- LFO STUFF -----//
   #xtranslate rpLField( <oLine> , <nElem> )     => ;
           { <oLine>\[ rpLFIELD_START       \]\[ <nElem> \], ;
           <oLine>\[ rpLFIELD_END         \]\[ <nElem> \], ;
           <oLine>\[ rpLFIELD_INDEX       \]\[ <nElem> \], ;
           <oLine>\[ rpLFIELD_FORMAT      \]\[ <nElem> \], ;
           <oLine>\[ rpLFIELD_JUSTIFY     \]\[ <nElem> \], ;
           <oLine>\[ rpLFIELD_DISPVAL     \]\[ <nElem> \], ;
           <oLine>\[ rpLFIELD_PATTR       \]\[ <nElem> \], ;
           <oLine>\[ rpLFIELD_COLOR       \]\[ <nElem> \], ;
           <oLine>\[ rpLFIELD_AUTOTRIM    \]\[ <nElem> \], ;
           <oLine>\[ rpLFIELD_DEC         \]\[ <nElem> \], ;
           <oLine>\[ rpLFIELD_FONT        \]\[ <nElem> \], ;
           <oLine>\[ rpLFIELD_SHADE       \]\[ <nElem> \], ;
           <oLine>\[ rpLFIELD_BORDER      \]\[ <nElem> \], ;
           <oLine>\[ rpLFIELD_STYLE       \]\[ <nElem> \]} ;
   //----- LFO STUFF -----//

#ENDIF

//----- RUNTIME STUFF -----//
#xtranslate rpRecsRead(  <oRP> )           => <oRP>\[ rpRUNTIME \]\[ rpRUNTIME_RECS_READ \]
#xtranslate rpRecsRead(  <oRP> , <Val> )   => (___h___ := <oRP>\[ rpRUNTIME \]\[ rpRUNTIME_RECS_READ \], <oRP>\[ rpRUNTIME \]\[ rpRUNTIME_RECS_READ \] := <Val>, ___h___)

#xtranslate rpRecsMatch( <oRP> )           => <oRP>\[ rpRUNTIME \]\[ rpRUNTIME_RECS_MATCH \]
#xtranslate rpRecsMatch( <oRP> , <Val> )   => (___h___ := <oRP>\[ rpRUNTIME \]\[ rpRUNTIME_RECS_MATCH \], <oRP>\[ rpRUNTIME \]\[ rpRUNTIME_RECS_MATCH \] := <Val>, ___h___)

#xtranslate rpOrigLOrg(   <oRP> )           => <oRP>\[ rpRUNTIME \]\[ rpRUNTIME_LORG \]
#xtranslate rpOrigLOrg(   <oRP> , <Val> )   => (___h___ := <oRP>\[ rpRUNTIME \]\[ rpRUNTIME_LORG \], <oRP>\[ rpRUNTIME \]\[ rpRUNTIME_LORG \] := <Val>, ___h___)

#xtranslate rpOrigTOrg(   <oRP> )           => <oRP>\[ rpRUNTIME \]\[ rpRUNTIME_TORG \]
#xtranslate rpOrigTOrg(   <oRP> , <Val> )   => (___h___ := <oRP>\[ rpRUNTIME \]\[ rpRUNTIME_TORG \], <oRP>\[ rpRUNTIME \]\[ rpRUNTIME_TORG \] := <Val>, ___h___)
//----- RUNTIME STUFF -----//

//----- LFO STUFF -----//
#xtranslate rpLFieldAttr( <oField> )            => <oField>\[ rpLFIELD_PATTR \]
#xtranslate rpLFieldAttr( <oField> , <Val> )    => (___h___ := <oField>\[ rpLFIELD_PATTR \], <oField>\[ rpLFIELD_PATTR \] := <Val>, ___h___)

#xtranslate rpLFieldColor( <oField> )           => <oField>\[ rpLFIELD_COLOR \]
#xtranslate rpLFieldColor( <oField> , <Val> )   => (___h___ := <oField>\[ rpLFIELD_COLOR \], <oField>\[ rpLFIELD_COLOR \] := <Val>, ___h___)

#xtranslate rpLFieldIndex( <oField> )           => <oField>\[ rpLFIELD_INDEX \]
#xtranslate rpLFieldIndex( <oField> , <Val> )   => (___h___ := <oField>\[ rpLFIELD_INDEX \], <oField>\[ rpLFIELD_INDEX \] := <Val>, ___h___)

#xtranslate rpLFieldStart( <oField> )           => <oField>\[ rpLFIELD_START \]
#xtranslate rpLFieldStart( <oField> , <Val> )   => (___h___ := <oField>\[ rpLFIELD_START \], <oField>\[ rpLFIELD_START \] := <Val>, ___h___)

#xtranslate rpLFieldEnd( <oField> )             => <oField>\[ rpLFIELD_END \]
#xtranslate rpLFieldEnd( <oField> , <Val> )     => (___h___ := <oField>\[ rpLFIELD_END \], <oField>\[ rpLFIELD_END \] := <Val>, ___h___)

#xtranslate rpLFieldFormat( <oField> )          => <oField>\[ rpLFIELD_FORMAT \]
#xtranslate rpLFieldFormat( <oField> , <Val> )  => (___h___ := <oField>\[ rpLFIELD_FORMAT \], <oField>\[ rpLFIELD_FORMAT \] := <Val>, ___h___)
//----- LFO STUFF -----//


//----- GET ONLY -----//
#xtranslate rpFldFullName( <oRP>, <nIndex> )  => (trim( <oRP>\[ rpFIELDS \]\[ <nIndex> \]\[ rpTABLE_NAME \] ) + "->" + trim( <oRP>\[ rpFIELDS \]\[ <nIndex> \]\[ rpFIELD_NAME \] ))
#xtranslate rpRFOFullName( <oRP>, <oField> )  => (trim( <oField>\[ rpTABLE_NAME \] ) + "->" + trim( <oField>\[ rpFIELD_NAME \] ) )
#xtranslate rpGetRFO( <oRP>, <nField> )       => (<oRP>\[ rpFIELDS \]\[ <nField> \])
//----- GET ONLY -----//

#xtranslate rpDBMode( <oDB> )               => <oDB>\[ rpDATABASE_OPEN_MODE \]
#xtranslate rpDBMode( <oDB> , <Val> )       => (___h___ := <oDB>\[ rpDATABASE_OPEN_MODE \], <oDB>\[ rpDATABASE_OPEN_MODE \] := <Val>, ___h___)

//--------------------------------------------//
//----- GET ONLY FROM GET/SET ROUTINES -------//
//--------------------------------------------//
#xtranslate rpScrRow( <oRP> )                => ( ( <oRP>\[ rpREPORT \]\[ rpREPORT_CSRROW \] - <oRP>\[ rpREPORT \]\[ rpREPORT_TOPORG \] + <oRP>\[ rpREPORT \]\[ rpREPORT_TOP \] ) + 1 )
#xtranslate rpScrCol( <oRP> )                => ( ( <oRP>\[ rpREPORT \]\[ rpREPORT_CSRCOL  \] - <oRP>\[ rpREPORT \]\[ rpREPORT_LEFTORG \] + <oRP>\[ rpREPORT \]\[ rpREPORT_LEFT \] ) + <oRP>\[ rpREPORT \]\[ rpREPORT_LINE_TEXT_LEN \] + 1 )

#xtranslate rpLine( <oRP> )                  => <oRP>\[ rpLINES \]\[ rpCsrRow( <oRP> ) \]
#xtranslate rpLine( <oRP> , <Val> )          => <oRP>\[ rpLINES \]\[ <Val> \]

#xtranslate rpMoving( <oRP> )                => <oRP>\[ rpREPORT \]\[ rpREPORT_MOVING \]

#xtranslate rpCurrField( <oRP> )             => <oRP>\[ rpREPORT \]\[ rpREPORT_CURRFIELD \]

#xtranslate rpLineLen( <oRP> )               => <oRP>\[ rpREPORT \]\[ rpREPORT_LINELEN \]

#xtranslate rpLFldLen( <oField> )            => (<oField>\[ rpLFIELD_END \] - <oField>\[ rpLFIELD_START \] + 1 )

#xtranslate rpCsrRow( <oRP> )                => <oRP>\[ rpREPORT \]\[ rpREPORT_CSRROW \]
#xtranslate rpCsrCol( <oRP> )                => <oRP>\[ rpREPORT \]\[ rpREPORT_CSRCOL \]

#xtranslate rpHeight( <oRP> )                => ( <oRP>\[ rpREPORT \]\[ rpREPORT_BOTTOM \] - <oRP>\[ rpREPORT \]\[ rpREPORT_TOP \] -1 )

#xtranslate rpScanCount( <oRP> )             => ( len( <oRP>\[ rpRUNTIME \]\[ rpRUNTIME_SCANS \] ) )
#xtranslate rpRelScanned( <oREL> )           => (<oREL>\[ rpREL_SCANNED \])
#xtranslate rpRelPos( <oREL> )               => (<oREL>\[ rpREL_POS \])

#xtranslate rpDBCount( <oRP> )               => (len( <oRP>\[ rpDATABASE \] ) )
#xtranslate rpDBIndex( <oDB> )               => (<oDB>\[ rpDATABASE_INDEX \])
#xtranslate rpDBTable( <oDB> )               => (<oDB>\[ rpDATABASE_TABLE \])
//--------------------------------------------//
//----- GET ONLY FROM GET/SET ROUTINES -------//
//--------------------------------------------//

//
// PSUDO-FUNCTIONS ONLY - THESE DO NOT EXIST AS REAL FUNCTIONS
//
#xtranslate rpRelFailAct(  <oRel> )          => (<oRel>\[ rpREL_FAIL_ACTION \] )
#xtranslate rpRelSoftSeek( <oRel> )          => (<oRel>\[ rpREL_SOFT_SEEK \] )
#xtranslate rpRelMatchLen( <oRel> )          => (<oRel>\[ rpREL_MATCHLEN \] )
#xtranslate rpRelMatchLen( <oRel>, <Val> )   => (___h___ := <oRel>\[ rpREL_MATCHLEN \], <oRel>\[ rpREL_MATCHLEN \] := <Val>, ___h___)
#xtranslate rpRelCount(  <oDB> )             => (len( <oDB>\[ rpDATABASE_REL \] ) )
#xtranslate rpDBRels(    <oDB> )             => (<oDB>\[ rpDATABASE_REL \] )
#xtranslate rpGetRRO(    <oDB>, <nVal> )     => (<oDB>\[ rpDATABASE_REL \]\[ <nVal> \] )
#xtranslate rpDBRDDName( <oDB> )             => (<oDB>\[ rpDATABASE_RDDNAME \] )
#xtranslate rpDBTagName( <oDB> )             => (<oDB>\[ rpDATABASE_ORDER_NAME \] )
#xtranslate rpSortCnt(   <oRP> )             => (len(<oRP>\[ rpSORTS \]))
#xtranslate rpLineFldCnt( <oLine> )          => (len(<oLine>\[ rpLFIELD_START \]))

