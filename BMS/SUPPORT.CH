#IFDEF MOUSE
#DEFINE MCURON() m_csron()
#DEFINE MCUROFF() m_csroff()
#ELSE
#DEFINE MCURON()
#DEFINE MCUROFF()
#ENDIF

/***
*  Nation Message Constants
*  These constants are used with the NationMsg(<msg>) function.
*  The <msg> parameter can range from 1-12 and returns the national
*  version of the system message.
*/
#define _GET_INSERT_ON   7     // "Ins"
#define _GET_INSERT_OFF  8     // "   "
#define _GET_INVD_DATE   9     // "Invalid Date"
#define _GET_RANGE_FROM  10    // "Range: "
#define _GET_RANGE_TO    11    // " - "
