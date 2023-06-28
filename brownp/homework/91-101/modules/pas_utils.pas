(*
 
Proc. UNBOX (top_column,top_row,bot_column,bot_row)
	erase a box on the screen

Proc. VERTLN (column, row, string)
	write a string vertically on the screen starting at column,row

Proc. BLANKLN (number of lines)
	write <number of lines> blanks lines on the screen.

Proc. WRITEAT (column, row, string, reverse<On or Off>)
	write STRING at COLUMN, ROW in reverse if flag is TRUE.
	Flag defaults at false (you can omit parameter) and column defaults
	at 1.

Proc. ECHO (On or Off)
	set term/ noecho if FALSE /echo if TRUE
	defaults at TRUE (you may omit parameter)

Proc. READINT (prompt, VAR integer)
	writes the prompt, reads a string and converts it to an integer

Func. VALID_FILE (filename) : BOOLEAN
	returns TRUE if <filename> is in the current directory.

Proc. STANDARDIZE_STRING (VAR string)
	lowcase and strips blanks.  Good for comparing two strings.

Proc. FLASH_SCREEN
	flashes the screen

Proc. HEADER ( program name, program version)
	Writes a single byline . Version defaults at 1.0, you can omit the parm

Proc. GOTOVIRTUALXY (center_x,center_y,x_pos,y_pos)
	Converts the screen into a cartesian coord system with 
	(center_x,center_y) being (0,0) and puts the cursor at
	x_pos,y_pos

Proc. SHADEDBOX (top_x,top_y,bottom_x,bottom_y)
	draws a box and puts the 2-sided "windows" shade behind it

Proc. DROP_STRING (column, row, string )
	"drops" a string character by character into the position defined
	by COLUMN and ROW

Proc. SLIDE_STRING (column, row, num_places, str)
	"slides" STR from (COLUMN, ROW) to (COLUMN = NUM_PLACES, ROW)

Proc. NORMALIZE_SCREEN 
	returns the screen to its natural state.  Good for termination of
	a program.
*)

[ENVIRONMENT ,
 INHERIT('group$disk:[compsci]vt100' ,
	 'group$disk:[compsci]utilities',
	 'sys$library:starlet')]


MODULE pas_utils ;


CONST

    (* These are mnemonics for key_codes returned from *)
    (* GetCh, GetKBHit, Get1Char                       *)

    K_LOW_A = 97 ;	K_UP_A = 65 ;
     
    K_LOW_B = 98 ;	K_UP_B = 66 ;
    
    K_LOW_C = 99 ;	K_UP_C = 67 ;
    
    K_LOW_D = 100 ;	K_UP_D = 68 ;
    
    K_LOW_E = 101 ;	K_UP_E = 69 ;
    
    K_LOW_F = 102 ;	K_UP_F = 70 ;
    
    K_LOW_G = 103 ;	K_UP_G = 71 ;
    
    K_LOW_H = 104 ;	K_UP_H = 72 ;
    
    K_LOW_I = 105 ;	K_UP_I = 73 ;
    
    K_LOW_J = 106 ;	K_UP_J = 74 ;
    
    K_LOW_K = 107;	K_UP_K = 75 ;
    
    K_LOW_L = 108;	K_UP_L = 76 ;
    
    K_LOW_M = 109;	K_UP_M = 77 ;
    
    K_LOW_N = 110;	K_UP_N = 78 ;
    
    K_LOW_O = 111;	K_UP_O = 79 ;
    
    K_LOW_P = 112;	K_UP_P = 80 ;
    
    K_LOW_Q = 113;	K_UP_Q = 81 ;
    
    K_LOW_R = 114;	K_UP_R = 82 ;
    
    K_LOW_S = 115;	K_UP_S = 83 ;
    
    K_LOW_T = 116;	K_UP_T = 84 ;
    
    K_LOW_U = 117;	K_UP_U = 85 ;
    
    K_LOW_V = 118;	K_UP_V = 86 ;
    
    K_LOW_W = 119;	K_UP_W = 87 ;
    
    K_LOW_X = 120;	K_UP_X = 88 ;
    
    K_LOW_Y = 121;	K_UP_Y = 89 ;
    
    K_LOW_Z = 122;	K_UP_Z = 90 ;
    
    K_0 = 48 ;
    K_1 = 49 ;
    K_2 = 50 ;
    K_3 = 51 ;
    K_4 = 52 ;
    K_5 = 53 ;
    K_6 = 54 ;
    K_7 = 55 ;
    K_8 = 56 ;
    K_9 = 57 ;
    
    K_UP    = 274 ;
    K_DOWN  = 275 ;
    K_LEFT  = 276 ;
    K_RIGHT = 277 ;

    K_RETURN = 13 ;

    K_TAB = 9 ;
    K_DELETE = 127 ;
    K_BACKSPACE = 8 ;
    K_ESC =  511 ;
    K_PF1 =  256 ;
    K_PF2 =  257 ;
    K_PF3 =  258 ;
    K_PF4 =  259 ;
    K_QUEST = 63 ;  
    K_PERIOD = 46 ;
    K_COMMA = 44 ;

{   K_EXCLAMATION = 
    K_AT =  
}
    K_POUND = 35 ;
    K_DOLLAR = 36 ;
    K_PERCENT = 37 ;
    K_CARAT = 94 ;
    K_AMPERSAND = 38 ;
    K_ASTERIX = 42 ;
    K_OPEN_PAREN = 40 ;
    K_CLOSE_PAREN = 41 ;
    K_PLUS = 43 ;
    K_MINUS = 45 ;
    K_UNDERSCORE = 95 ;
    K_EQUALS = 61 ;
    K_TILDE = 126 ;
    K_BACK_QUOTE = 96 ;

    K_GREATER = 62 ;
    K_LESSER = 60 ;
    K_COLON = 58 ;
    K_SEMICOLON = 59;    

    K_SPACE = 32 ;

	(* Note, some of these are trapped by the system  *)
	(* Y,T,C etc, and some have other representations *)
	(* CTRL_I = K_TAB, CTRL_M = K_RETURN etc...       *)

    CTRL_A = 1 ;    CTRL_B = 2 ;    CTRL_C = 3 ;    CTRL_D = 4 ;
    CTRL_E = 5 ;    CTRL_F = 6 ;    CTRL_G = 7 ;    CTRL_H = 8 ;
    CTRL_I = 9 ;    CTRL_J = 10 ;   CTRL_K = 11 ;   CTRL_L = 12 ;
    CTRL_M = 13 ;   CTRL_N = 14 ;   CTRL_O = 15 ;   CTRL_P = 16 ;
    CTRL_Q = 17 ;   CTRL_R = 18 ;   CTRL_S = 19 ;   CTRL_T = 20 ;
    CTRL_U = 21 ;   CTRL_V = 22 ;   CTRL_W = 23 ;   CTRL_X = 24 ;
    CTRL_Y = 25 ;   CTRL_Z = 26 ;

    K_NULL = 0 ;


(* Use to call DCL commands *)

[external (lib$spawn)]
FUNCTION lib$spawn(
	command_string	: [class_s] PACKED ARRAY[$l1..$u1:INTEGER] OF CHAR
		  ) : unsigned ;
external ;


PROCEDURE UnBox(
	top_column  : INTEGER ;
	top_row	    : INTEGER ;
	bot_column  : INTEGER ;
	bot_row	    : INTEGER ) ;

VAR
    k : INTEGER ;	(* Local loop index variable *)

BEGIN	(* unbox *)

	(* Remove the top and bottom lines of the box *)

    FOR k := top_column TO bot_column DO
	BEGIN
	    gotoxy(k,top_row) ;
	    WRITELN(' ') ;
	    gotoxy(k,bot_row) ;
	    WRITELN(' ') ;
	END ;
    
	(* Remove the left and right sides of the box *)

    FOR k := top_row TO bot_row DO
	BEGIN
	    gotoxy(top_column,k) ;
	    WRITELN(' ') ;
	    gotoxy(bot_column,k) ;
	    WRITELN(' ') ;
	END ;

END ;	(* Unbox *)



(*                                                                           *)
(* Procedure VERTLN :                                                        *)
(* Purpose  : To facilitate writing a string vertically on the screen        *)
(* Usage    : VERTLN(column, row, string)                                    *)
(* Example  : VERTLN(40,10,'Hello There')                                    *)
(*                                                                           *)

PROCEDURE VertLn(
	column	: INTEGER ;
	row	: INTEGER ;
	str	: string ) ;

VAR
    k	: INTEGER ;	(* local loop index variable *)

BEGIN
    FOR k := 1 TO (LENGTH(str)) DO
	BEGIN
	    gotoxy(column, ((row + k) - 1) ) ;
	    WRITELN(str[k]) ;
	END ;    
END ;


(*                                                                           *)
(* Procedure BLANKLN :                                                       *)
(* Purpose  : To facilitate WRITEing several blank lines on the screen       *)
(* Usage    : BLANKLN(<number of lines>)                                     *)
(* Example  : BLANKLN(10) ;  replaces 10 WRITELN ; statements                *)
(*                                                                           *)

PROCEDURE BlankLn(
	num_lines : INTEGER ) ;

VAR
    x	: INTEGER ;	(* local loop index variable *)

BEGIN
    IF num_lines > 0 THEN
	FOR x := 1 TO num_lines DO
	    WRITELN ;
END ; (* Blankln *)



(*                                                                           *)
(* Procedure WRITEAT :                                                       *)
(* Purpose   To allow the user to WriteLn a text string at any place on the  *)
(*           screen.                                                         *)
(* Arguments column (defaults at 1) row and string and REVERSE boolean def F *)
(* Usage     WriteAt(10,3,'Hello There') Would print Hello There at 10,3     *)
(*           WriteAt(10,3,'Hello',TRUE) Would print a reverse Hello at 10,3  *)
(*                                                                           *)

PROCEDURE WriteAt(
	column	: INTEGER := 1 ;	(* column to start text at *)
	row	: INTEGER ;		(* row to start text at    *)
	str	: string ;		(* string to print	   *)
	revs	: BOOLEAN := FALSE) ;	(* reverse or not          *)

BEGIN
    gotoxy(column,row) ;

    IF revs THEN
	reverse(On) ;

    WRITELN(str) ;
	
    IF revs THEN
	reverse(Off) ;
END ;



PROCEDURE Echo(
	switch : BOOLEAN := TRUE )  ;	(* On or Off *)

BEGIN
    IF switch THEN
	lib$spawn('set term/echo') 
    ELSE
	lib$spawn('set term/noecho') ;
END ;



(*                                                                           *)
(* Procedure READINT :                                                       *)
(* Purpose   To allow the user to read an integer in from the user without   *)
(*           fear of cxrashing if a string is entered instead                *)
(* Arguments prompt to display on the screen and the INTEGER returned        *)
(* Usage     Readint('>> ',my_integer) would write >> and wait for input     *)
(*                                                                           *)

PROCEDURE ReadInt(
	    prompt	: string := '' ;	(* Prompt to display *)
	VAR number	: INTEGER ;		(* Integer returned  *)
	    echo_switch : BOOLEAN := TRUE ) ;	(* switch for NOECHO *)
VAR
    num_string : string ;   (* String read from the user *)

BEGIN

    IF prompt <> '' THEN
	WRITE(prompt) ;

    IF (NOT(echo_switch)) THEN
	echo(off) ;

    READLN(num_string) ;

    IF (NOT(echo_switch)) THEN
	echo(On) ;

    number := atoi(num_string) ;

END ;



(*                                                                           *)
(* Function  VALID_FILE                                                      *)
(* Purpose   To allow the user to check to see if a file exists before       *)
(*           attempting to read from it.  Prevents crashing.                 *)
(* Arguments Filename (string) RETURNS : TRUE or FALSE                       *)
(* Usage     IF (valid_file(filename)) THEN . . .                            *)
(*                                                                           *)

FUNCTION valid_file(
	    filename	: string ) : BOOLEAN ;

VAR
    fileid : TEXT ;

BEGIN
    IF filename <> '' THEN
	BEGIN
	    OPEN (fileid, filename, HISTORY := OLD, ERROR := continue) ;
	    valid_file := (status(fileid) = 0) ;
	END
    ELSE
	valid_file := FALSE ;
END ;


(* Convert any string to a standard format *)

PROCEDURE standardize_string( 
	VAR str : string ) ;

BEGIN
    stripleadingblanks(str) ;
    striptrailingblanks(str) ;
    str := strlwr(str) ;
END ;



PROCEDURE flash_screen ;

BEGIN
    reversescreen(On) ;
    reversescreen(Off) ;
END ;	    


PROCEDURE header(
	program_name	: string ;
	program_version : real := 1.0 ) ;
	
BEGIN
    clrscr ;
    home ;
    reverse(On) ;
    WRITELN(program_name,' v',program_version:4:2,' brought to you by The Psychlist.') ;
    reverse(Off) ;
    WRITELN ;
END ;


PROCEDURE GotoVirtualXY(
	center_x : INTEGER ;	(* C_y and C_x are the points of intersection *)
	center_y : INTEGER ;	(* of the 2 axes on the cartesian graph       *)
	x_pos	 : INTEGER ;	(* x_pos and y_pos are the actual coords of   *)
	y_pos	 : INTEGER ) ;	(* the point you wish to plot                 *)

BEGIN	(* GotoVirtualXY *)

    gotoxy((center_x + x_pos), (center_y + y_pos)) ;

END ;	(* GotoVirtualXY *)



FUNCTION get_current_directory : string ;

BEGIN	(* get current directory *)

    (* not done yet *)

    get_current_directory := '' ;

END ;	(* get current directory *)



(* Draw a shaded "window" box on the screen *)

PROCEDURE ShadedBox(
	top_x	    : INTEGER ;
	top_y	    : INTEGER ;
	bottom_x    : INTEGER ;
	bottom_y    : INTEGER ) ;

VAR
    k	: INTEGER ;	    (* local loop index variable *)

BEGIN	(* shaded box *)
    k := 0 ;

	(* draw the actual box *)

    box(top_x,top_y,bottom_x,bottom_y) ;
    
	(* Draw a vertical shadow on right side *)

    FOR k := (top_y + 1) TO (bottom_y + 1) DO
	writeat((bottom_x+1),k,' ',TRUE) ;

	(* draw horizontal shadow across bottom *)

    k := 0 ;

    FOR k := (top_x + 1) TO (bottom_x) DO
	writeat(k,(bottom_y + 1),' ',TRUE) ; 

END ;	(* shaded box *)


PROCEDURE drop_string(
	    column  : INTEGER ;	    (* column and row that the string *)
	    row	    : INTEGER ;	    (* will end up at                 *)
	    str	    : string  ;
	    revs    : BOOLEAN := FALSE ) ;

VAR
    k		: INTEGER ;	(* local loop index variable   *)
    current_row : INTEGER ;	(* another loop index variable *)

BEGIN

	(* drop each character consectively *)
    
    FOR k := 1 TO (LENGTH(str)) DO
	FOR current_row := 1 TO row DO
	    BEGIN
		    (* write the character on the screen *)

		writeat((column + k - 1 ),current_row,str[k],REVS) ;

		    (* Now erase the character we just wrote *)

		IF (current_row <> row) THEN
		    writeat((column + k - 1),current_row,' ',FALSE) ;
	    END ;
END ;


PROCEDURE slide_string(
	column	    : INTEGER ;	    (* STARTING column		 *)
	row	    : INTEGER ;	    (* STARTING row		 *)
	num_places  : INTEGER ;	    (* number of places to RIGHT *)
	str	    : string ;
	revs	    : BOOLEAN := FALSE ) ;

VAR
    k	: INTEGER ;	    (* local loop index variable *)
BEGIN
    IF (num_places > 0 ) THEN 
	BEGIN
	    FOR k := 0 TO num_places DO
		BEGIN
		    writeat(column + k, row, str, REVS) ;
		    IF k <> num_places THEN
			writeat(column + k, row, '   ', FALSE) ;
		END ;
	
	END
    ELSE
	WRITELN('%Cannot slide string.  Num_places must be > 0.') ;
END ;


PROCEDURE normalize_screen ;

BEGIN
    echo(ON) ;
    attributesOff ;
    graphicsOff ;
    reversescreen(OFF) ;
    gotoxy(1,24) ;
END ;

PROCEDURE window (
	top_row : INTEGER := 1 ;
	bottom_row : INTEGER := 24) ;
VAR
    tmp : INTEGER ;

BEGIN
    IF (top_row <1) THEN
	top_row := 1 ;
    IF (bottom_row >24) THEN
	bottom_row := 24 ;

    IF top_row > bottom_row THEN
	BEGIN
	    tmp := top_row ;
	    top_row := bottom_row ; 
	    bottom_row := tmp ;
	END ;

    WRITELN (CHR(27)+ '[' +itoa(top_row)+ ';' +itoa(bottom_row)+ ' r') ;
END ;

END. (* Module *)
