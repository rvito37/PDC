
#include "avxdefs.ch"

FUNCTION qtyconvert( nOrigQty , pBtype ,pLineId,pSizeId , pOrigUom , pConvUom , lFromYieldrep,pPurp,cRoute,nValue) //Vitaly 14-01-02 TID:2114110 ,18-04-02 TID:2418565
LOCAL cKey,cKeySpec
LOCAL cCombination := Upper( pOrigUom + pConvUom )
LOCAL nConvQty := 0
LOCAL oTab, nWSfactor, nSPfactor, cFirstKey, cSecondKey,cFirstSpec,cSecondSpec
LOCAL nSelect := Select()
LOCAL lErrorflag := .F.
local lCloseIt := .F.,lCloseTT := .F.
DEFAULT lFromYieldrep TO .F.
DEFAULT nValue to 0

IF select("c_thqty") == 0
     Netuse("c_thqty",5)
     lCloseit := .T.
ENDIF

IF select("c_tthqty") == 0
     Netuse("c_tthqty",5)
     lCloseTT := .T.
ENDIF

IF pBtype $ "_Z_K_A_S" //Vitaly 14-01-02 TID:2114110
	c_tthqty->(ordsetfocus("itsuom"))
	c_thqty->(ordsetfocus("itsuom"))
	cKey := pBtype + pSizeId + Upper( pOrigUom ) + Upper( pConvUom )
	cKeySpec := cRoute + pBtype + pSizeId + Upper( pOrigUom ) + Upper( pConvUom )
ELSEif pBtype $ "E_"
	c_tthqty->(ordsetfocus("ilinuom"))
	c_thqty->(ordsetfocus("ilinuom_1"))
	cKey := pBtype + pLineid + pSizeId + Upper( pOrigUom ) + Upper( pConvUom )
	cKeySpec := cRoute + pLineid + pSizeId + Upper( pOrigUom ) + Upper( pConvUom )
ELSE
	c_tthqty->(ordsetfocus("ilinuom"))
	c_thqty->(ordsetfocus("ilinuom"))
	cKey := pLineid + pSizeId + Upper( pOrigUom ) + Upper( pConvUom )
	cKeySpec := cRoute + pLineid + pSizeId + Upper( pOrigUom ) + Upper( pConvUom )
ENDIF


DO CASE
   CASE cCombination $ "WS_SP"
        IF c_tthqty->( DbSeek( cKeySpec ) )
           nConvQty := Round( nOrigQty / c_tthqty->orig_amt * c_tthqty->th_qty,0)
		  ELSEIF pBtype == "E" .AND. c_thqty->( DbSeek( cKey ) )
			  While cKey == C_THQTY->B_TYPE+C_THQTY->PLINE_ID+C_THQTY->SIZE_ID+C_THQTY->ORIG_UOM+C_THQTY->CONV_UOM
					  IF nValue <= c_thqty->h_val .AND. nValue >= c_thqty->l_val
			           nConvQty := Round( nOrigQty / c_thqty->orig_amt * c_thqty->th_qty,0)
						  EXIT
					  ENDIF
					  c_thqty->( DbSkip(1))
			  End
		  ELSEIF !pBtype $ "_Z_K_A_S" .AND. c_thqty->( DbSeek( cKey ) )
			  While cKey == C_THQTY->PLINE_ID+C_THQTY->SIZE_ID+C_THQTY->ORIG_UOM+C_THQTY->CONV_UOM
					  IF nValue <= c_thqty->h_val .AND. nValue >= c_thqty->l_val
			           nConvQty := Round( nOrigQty / c_thqty->orig_amt * c_thqty->th_qty,0)
						  EXIT
					  ENDIF
					  c_thqty->( DbSkip(1))
			  End
		  ELSEIF c_thqty->( DbSeek( cKey ) )
           nConvQty := Round( nOrigQty / c_thqty->orig_amt * c_thqty->th_qty,0)
        ELSE
           lErrorflag := .T.
        ENDIF
   CASE cCombination $ "WP"
        IF lFromYieldrep
          IF c_tthqty->( DbSeek( cKeySpec ) )
             IF pPurp $ "_5_8_"
					 nConvQty := Round( nOrigQty / c_tthqty->orig_amt * c_tthqty->th_qty,0)
				 ELSE
                nConvQty := Round( nOrigQty / c_tthqty->orig_amt * c_tthqty->yd_qty,0) //Vitaly 18-04-02 2418565
				 ENDIF
			 ELSEIF pBtype == "E" .AND. c_thqty->( DbSeek( cKey ) )
				  While cKey == C_THQTY->B_TYPE+C_THQTY->PLINE_ID+C_THQTY->SIZE_ID+C_THQTY->ORIG_UOM+C_THQTY->CONV_UOM
				   	  IF nValue <= c_thqty->h_val .AND. nValue >= c_thqty->l_val
							  IF pPurp $ "_5_8_"
							     nConvQty := Round( nOrigQty / c_thqty->orig_amt * c_thqty->th_qty,0)
							  ELSE
							     nConvQty := Round( nOrigQty / c_thqty->orig_amt * c_thqty->yd_qty,0) //Vitaly 18-04-02 2418565
							  ENDIF
				   		  EXIT
				   	  ENDIF
				   	  c_thqty->( DbSkip(1))
				  End
			 ELSEIF  !pBtype $ "_Z_K_A_S" .AND. c_thqty->( DbSeek( cKey ) )
				  While cKey == C_THQTY->PLINE_ID+C_THQTY->SIZE_ID+C_THQTY->ORIG_UOM+C_THQTY->CONV_UOM
				   	  IF nValue <= c_thqty->h_val .AND. nValue >= c_thqty->l_val
							  IF pPurp $ "_5_8_"
							     nConvQty := Round( nOrigQty / c_thqty->orig_amt * c_thqty->th_qty,0)
							  ELSE
							     nConvQty := Round( nOrigQty / c_thqty->orig_amt * c_thqty->yd_qty,0) //Vitaly 18-04-02 2418565
							  ENDIF
				   		  EXIT
				   	  ENDIF
				   	  c_thqty->( DbSkip(1))
				  End
			 ELSEIF c_thqty->( DbSeek( cKey ) )
				  nConvQty := Round( nOrigQty / c_thqty->orig_amt * c_thqty->th_qty,0)
			 ELSE
               lErrorflag := .T.
          ENDIF
        ELSE
			 //////////////////////////////////////////
			 // Search for WS factor first
          IIF(pBtype $ "_Z_K_A_S_",cFirstKey  := pBtype + pSizeId + "WS",IIF(pBtype == "E" ,cFirstKey  := pBtype + pLineId + pSizeId + "WS" ,cFirstKey  := pLineId + pSizeId + "WS" ))
          IIF(pBtype $ "_Z_K_A_S_",cSecondKey := pBtype + pSizeId + "SP",IIF(pBtype == "E" ,cSecondKey  := pBtype + pLineId + pSizeId + "SP" ,cSecondKey  := pLineId + pSizeId + "SP" ))
          IIF(pBtype $ "_Z_K_A_S_",cFirstSpec  := cRoute + pBtype + pSizeId + "WS",cFirstSpec  := cRoute + pLineId + pSizeId + "WS")
          IIF(pBtype $ "_Z_K_A_S_",cSecondSpec := cRoute +pBtype + pSizeId + "SP",cSecondSpec := cRoute + pLineId + pSizeId + "SP")
			 IF c_tthqty->( DbSeek( cFirstSpec ) )  //1
               nWSfactor := c_tthqty->th_qty
               IF c_tthqty->( DbSeek( cSecondSpec ) )
                    nSPfactor := c_tthqty->th_qty
                    nConvQty :=  Round( nOrigQty / c_tthqty->orig_amt * nWSfactor * nSPfactor,0)
               ELSE
                    lErrorflag := .T.
               ENDIF
			 ELSEIF c_thqty->( DbSeek( cFirstKey ) )//1
				While &(c_thqty->(ordkey())) == cFirstKey
				 IF nValue <= c_thqty->h_val .AND. nValue >= c_thqty->l_val//2
					nWSfactor := c_thqty->th_qty
					IF c_thqty->( DbSeek( cSecondKey ) )                    //3
					 While &(c_thqty->(ordkey())) == cSecondKey
						IF nValue <= c_thqty->h_val .AND. nValue >= c_thqty->l_val//4
                    nSPfactor := c_thqty->th_qty
                    nConvQty :=  Round( nOrigQty / c_thqty->orig_amt * nWSfactor * nSPfactor,0)
						  EXIT
						ENDIF                                                     //4
						c_thqty->( DbSkip(1))
					 END
					 EXIT
				   ENDIF			                                                   //3
				 ENDIF                                                     //2
				 c_thqty->( DbSkip(1))
				END
          ELSE//1
              lErrorflag := .T.
          ENDIF//1
			 ///////////////////////////
        ENDIF
   CASE cCombination $ "SW_PW_PS"
        IF c_tthqty->( DbSeek( cKeySpec ) )
           IF (nOrigQty/c_tthqty->orig_amt * c_tthqty->th_qty) < 1 //.AND. nOrigQty / c_thqty->orig_amt * c_thqty->th_qty  <> 0
               nConvQty := 1
           else
                nConvQty := Round( nOrigQty / c_tthqty->orig_amt * c_tthqty->th_qty,0)
           ENDIF
		  ELSEIF c_thqty->( DbSeek( cKey ) )
           IF (nOrigQty/c_thqty->orig_amt * c_thqty->th_qty) < 1 //.AND. nOrigQty / c_thqty->orig_amt * c_thqty->th_qty  <> 0
               nConvQty := 1
           else
                nConvQty := Round( nOrigQty / c_thqty->orig_amt * c_thqty->th_qty,0)
           ENDIF
        ELSE
          lErrorflag := .T.
        ENDIF
   OTHERWISE
       nConvQty := 0
ENDCASE

IF lErrorflag .AND. cCombination<>"SW"
     nConvQty := 0
ENDIF

IF lCloseIt
     c_thqty->(dbclosearea())
ENDIF
IF lCloseTT
     c_tthqty->(dbclosearea())
ENDIF

Select (nSelect)
RETURN nConvQty