[ENVIRONMENT, INHERIT ('comp$dir:vt100',
		       'comp$dir:utilities',
		       'mod$dir:pas_utils') ]


MODULE windows (INPUT,OUTPUT) ;



CONST
    ncolumns = 80 ;		(* number of columns on the screen          *)
    nlines   = 24 ;		(* number of lines per screen               *)
    top_line = 6 ;		(* Top line of text window                  *)
    max_lines	= 500 ;		(* maximum number of lines a file can have  *)
    EOB_marker = '[ End of Buffer ]' ;


TYPE
    char_rec = RECORD 
	ch	: char ;	(* the actual character stored in the cell *)
	bold_on : BOOLEAN ;	(* do I write the character in BOLD ?      *)
	grafix_on : BOOLEAN ;	(* is this character a GRAPHICS character? *)
	revs_on : BOOLEAN ;	(* is this character in REVERSE video ?    *)
    END ; { char_rec }


    screenline = ARRAY [1..ncolumns] OF char_rec ;	 (* one screen line *)
    fullscreen = ARRAY [1..nlines] OF screenline ;	 (* entire screen   *)

    text_file_array  =	ARRAY[1..max_lines] OF string ;


VAR
    screen    : fullscreen ;	   (* contents of the entire screen display *)
    text_file : text_file_array ;








(* this procedure clears the screen and the character map of the screen *)

PROCEDURE winclrscr(
	VAR screen : fullscreen) ;

VAR
    column : INTEGER ;	    (* column being restored *)
    row	   : INTEGER ;	    (* row being restored    *)

BEGIN	{ winclrscr }

    FOR row := 1 TO nlines DO
	FOR column := 1 TO ncolumns DO
	    WITH screen[row][column] DO
		BEGIN
		    ch := ' ' ;
		    revs_on := FALSE ;
		    bold_on := FALSE ;
		    grafix_on := FALSE ;
		END ;
    clrscr;

END ;	{ winclrscr }


PROCEDURE winbox
   (leftcolumn  : INTEGER ;     (* column number for left boundary  *)
    topline     : INTEGER ;     (* line number for top boundary     *)
    rightcolumn : INTEGER ;     (* column number for right boundary *)
    bottomline  : INTEGER ;     (* line number for bottom boundary  *)
    bold_on	: BOOLEAN := FALSE) ;
    
VAR k    : INTEGER ;   (* local loop index                         *)
    temp : INTEGER ;   (* for swapping parameters if necessary     *)

BEGIN


   bold(bold_on) ;
   box(leftcolumn,topline,rightcolumn,bottomline) ;
   bold(off) ;

      (* swap left and right columns if necessary *)

   IF leftcolumn > rightcolumn THEN
       BEGIN
          temp := leftcolumn ;
          leftcolumn := rightcolumn ;
          rightcolumn := temp ;
       END ;
      
      (* adjust left and right columns if necessary *)

   IF leftcolumn = 0 THEN leftcolumn := 1 ;
   IF leftcolumn > 80 THEN leftcolumn := 80 ;

   IF rightcolumn = 0 THEN rightcolumn := 1 ;
   IF rightcolumn > 80 THEN rightcolumn := 80 ;

      (* swap top and bottom lines if necessary *)

   IF topline > bottomline THEN
       BEGIN
          temp := topline ;
          topline := bottomline ;
          bottomline := temp ;
       END ;
      
      (* adjust top and bottom lines if necessary *)

   IF topline = 0 THEN topline := 1 ;
   IF topline > 24 THEN topline := 24 ;

   IF bottomline = 0 THEN bottomline := 1 ;
   IF bottomline > 24 THEN bottomline := 24 ;

      (* draw top horizontal line *)

   screen[topline][leftcolumn].ch := 'l' ;
   screen[topline][leftcolumn].grafix_on := TRUE ;
   screen[topline][leftcolumn].bold_on := bold_on ;

   FOR k := leftcolumn+1 TO rightcolumn-1 DO 
	BEGIN
	    screen[topline][k].ch := 'q' ;
	    screen[topline][k].grafix_on := TRUE ;
	END ;

   screen[topline][rightcolumn].ch := 'k' ;
   screen[topline][rightcolumn].grafix_on := TRUE ;
   screen[topline][rightcolumn].bold_on := bold_on ;

      (* draw left vertical line *)

   FOR k := topline+1 TO bottomline-1 DO
      BEGIN
	 screen[k][leftcolumn].ch := 'x' ;
	 screen[k][leftcolumn].grafix_on := TRUE ;
	 screen[k][leftcolumn].bold_on := bold_on ;
      END ;

      (* draw right vertical line *)

   FOR k := topline+1 TO bottomline-1 DO
      BEGIN
	 screen[k][rightcolumn].ch := 'x' ;
	 screen[k][rightcolumn].grafix_on := TRUE ;
         screen[k][rightcolumn].bold_on := bold_on ;
      END ;

      (* draw bottom horizontal line *)

   screen[bottomline][leftcolumn].ch := 'm' ;
   screen[bottomline][leftcolumn].grafix_on := TRUE ;
   screen[bottomline][leftcolumn].bold_on := bold_on ;

   FOR k := leftcolumn+1 TO rightcolumn-1 DO 
	BEGIN
	    screen[bottomline][k].ch := 'q' ;
	    screen[bottomline][k].grafix_on := TRUE ;
	    screen[bottomline][k].bold_on := bold_on ;
	END ;

   IF (bottomline < 24) OR (rightcolumn < 80) THEN
	BEGIN
	    screen[bottomline][rightcolumn].ch := 'j' ;
	    screen[bottomline][rightcolumn].grafix_on := TRUE ;
	    screen[bottomline][rightcolumn].bold_on := bold_on ;
	END ;


END ;   (* winBox *)


PROCEDURE winwriteat(
	VAR screen  : fullscreen ;
	    x_pos   : INTEGER ;		(* column of first character *)
	    y_pos   : INTEGER ;		(* row of first character    *)
	    str	    : string  ;		(* string to write           *)
	    bold_on : BOOLEAN := FALSE ;
	    revs_on : BOOLEAN := FALSE ;
	    pad     : BOOLEAN := TRUE) ; (* add trailing blanks ?    *)

VAR
    column  : INTEGER ;

BEGIN
    IF pad THEN
	BEGIN
	    IF LENGTH(str) < ncolumns THEN
		FOR column := (LENGTH(str) + 1) TO ncolumns DO
		    str := str + ' ' ;
	    str := substr(str,1,78) ;
	END ;


	(* write ths actual string *)

    IF ( str = EOB_marker ) THEN
	bold(on)
    ELSE
	bold(bold_on) ;

    reverse(revs_on) ;
   
    writeat(x_pos, y_pos, str, revs_on) ;

    reverse(Off) ;
    bold(off) ;

	(* put the string in memory *)

    FOR column := x_pos TO x_pos + length(str) - 2 DO
	BEGIN
	    screen[y_pos][column].ch := str[column - x_pos  + 2] ;
	    screen[y_pos][column].bold_on := bold_on ;
	    screen[y_pos][column].revs_on := revs_on ;
	END ;
END ;



PROCEDURE winrestore(
	screen	: fullscreen ;
	top_x   : INTEGER := 6 ;
	top_y	: INTEGER := 1 ;
	bot_x	: INTEGER := 78 ;
	bot_y	: INTEGER := 23) ;

VAR
    k : INTEGER ;
    i : INTEGER ;

BEGIN

    FOR i := top_y TO bot_y DO
	FOR k := top_x-1 TO bot_x DO
	    BEGIN
		bold(screen[i][k].bold_on) ;

		IF screen[i][k].grafix_on THEN
		    graphicsOn
		ELSE
		    graphicsOff ;

		writeat(k+1, i, screen[i][k].ch, screen[i][k].revs_on) ; 
	    END ;

    graphicsOff ;
    attributesOff ;
    bold(off) ;
    reverse(off) ;

END ;



PROCEDURE winpop_up(
	top_x   : INTEGER ;
	top_y	: INTEGER ;
	bot_x	: INTEGER ;
	bot_y	: INTEGER ;
	title   : string ) ;	 

VAR
    i       : INTEGER ;

BEGIN

	(* erase the crap already under the popup window *)
	
    FOR i := top_y TO bot_y DO
	BEGIN
	    gotoxy(top_x,i) ;
	    WRITELN(' ':bot_x-top_x) ;
	END ;

	(* draw the actual box *)

    box(top_x,top_y,bot_x,bot_y) ;

	(* center the title on the window *)

    writeat((((top_x+bot_x) DIV 2) - (LENGTH(title) DIV 2)),
						top_y, title, FALSE) ;

	(* draw shadow on the bottom *)
    
    FOR i := top_x + 2 TO bot_x + 1 DO 
	writeat(i, bot_y + 1,' ',TRUE) ;

	(* draw shadow on the right *)

    FOR i := top_y + 1 to bot_y + 1 DO
	writeat(bot_x + 1 , i, ' ', TRUE) ;
END ;


(* This procedure is used to scroll the entire text UP one line *)

PROCEDURE winscroll_up(
	VAR screen	 : fullscreen ;
	VAR current_line : INTEGER  ;   (* what line IN THE FILE are we on *)
	    num_file_lines : INTEGER ) ;

VAR
    k : INTEGER ;

BEGIN
    current_line := current_line - 1 ;

    IF current_line >= 1 THEN
	FOR k := 1 TO (nlines - top_line ) DO
	    winwriteat(screen, 2, (top_line + k - 1), 
			text_file[current_line + k - 1]) 
    ELSE
	BEGIN
	    gotoxy(1,1) ;
	    beep ;
	    current_line := 1 ;
	END ;

    gotoxy(1,1) ;
END ;


(* This procedure is used to scroll the entire text DOWN one line *)

PROCEDURE winscroll_down(
	VAR screen	 : fullscreen ;
	VAR current_line : INTEGER ;    (* what line IN THE FILE are we on *)
	    num_file_lines : INTEGER ) ;

VAR
    k : INTEGER ;

BEGIN
    current_line := current_line + 1 ;

    IF current_line <= (num_file_lines - (nlines-top_line)) THEN
	FOR k := 1 TO (nlines - top_line) DO
	    winwriteat(screen, 2, (top_line + k - 1), 
			text_file[current_line + k - 1]) 
    ELSE
	BEGIN
	    gotoxy(1,1) ;
	    beep ;
	    current_line := (num_file_lines- (nlines-top_line ))  ;
	END ;

    gotoxy(1,1) ;

END ;


(* This procedure is used to scroll the entire text UP one page *)

PROCEDURE winpage_up(
	VAR screen	 : fullscreen ;
	VAR current_line : INTEGER ;    (* what line IN THE FILE are we on *)
	    num_file_lines : INTEGER ) ;

VAR
    k : INTEGER ;

BEGIN
    current_line := current_line - (nlines-top_line) ;

    IF current_line < 1 THEN 
	BEGIN
	    current_line := 1 ;
	    beep ;
	END ;

    FOR k := 1 TO (nlines - top_line) DO
	winwriteat(screen, 2, (top_line + k - 1), 
			text_file[current_line + k - 1]) 

END ;


(* This procedure is used to scroll the entire text DOWN one page *)

PROCEDURE winpage_down(
	VAR screen	 : fullscreen ;
	VAR current_line : INTEGER ;    (* what line IN THE FILE are we on *)
	    num_file_lines : INTEGER ) ;

VAR
    k : INTEGER ;

BEGIN
    current_line := current_line + (nlines-top_line) ;

    IF current_line > (num_file_lines - (nlines-top_line) + 1) THEN
	BEGIN
	    current_line := (num_file_lines - (nlines-top_line) + 1) ;
	    beep ;
	END ;

    FOR k := 1 TO (nlines - top_line) DO
	winwriteat(screen, 2, (top_line + k - 1), 
			text_file[current_line + k - 1]) 

END ;

(* This procedure redraws the scroll bar on the right of the screen *)

PROCEDURE winupdate_scroll_bar(
	current_line     : INTEGER  ;
	text_file_length : INTEGER ) ;

CONST
    scroll_bar_size = 17 ; 
    locator = 'a' ;

VAR
    locator_pos : INTEGER ;

BEGIN
	(* draw the actual scroll bar using VERTLN from pas_utils *)

    reverse(ON) ;
    vertln(80,6,'               ') ;   (* the actual scroll bar *)
    reverse(OFF) ;

	(* compute the Y position of the scroll bar *)

    locator_pos :=(TRUNC(scroll_bar_size/(current_line / text_file_length))) ;

    IF locator_pos > 17 THEN 
	locator_pos := 17 ;

	(* quick bug fixing...a hack *)

    graphicsOn ;
    writeat(80,6+locator_pos,locator,FALSE) ;
    graphicsOff ;
    
	(* prevent the ENTIRE screen from scrolling *)

    gotoxy(1,1) ;
    WRITELN ;
END ;


(* Use this procedure to display the file for the first time *)

PROCEDURE windisplay_text(
	VAR screen	   : fullscreen ;	(* the screen array        *)
	    text_file	   : text_file_array ;	(* array holding text file *)
	    num_file_lines : INTEGER ) ;	(* number of lines in file *)

VAR
    k : INTEGER ;

BEGIN
    FOR k := 1 TO nlines - top_line DO
	BEGIN
	    IF (LENGTH(text_file[k]) > 78) THEN 
		winwriteat(screen,2,k+top_line-1, substr(text_file[k],1,78) + '*') 
	    ELSE 
		winwriteat(screen,2,k+top_line-1, text_file[k]) ; 
	END ; 

END ;


(* This bloody procedure doesn't work yet !!!! *)

(* This procedure defines a scrolling region on the terminal screen *)
(* Note: ALWAYS call WINDEFINE_REGION with no parms. at teh end of  *)
(* your program.  This will normalize the screen                    *)


PROCEDURE windefine_region(
	top_line : INTEGER := 1 ;   (* top line of scrolling region    *)
	bot_line : INTEGER := 24) ; (* bottom line of scrolling region *)

BEGIN
    IF (((top_line > 0) AND (bot_line < 25)) AND (top_line < bot_line)) THEN
	BEGIN
	    WRITELN (ESC, '[',top_line,';',bot_line,' r') ;
	END 
    ELSE
	BEGIN
	    beep ;
	    blink(ON) ;
	    WRITELN('%WINDEFINE_REGION Region not define, invalid parameters.') ;
	    blink(OFF) ;
	END ;
END ;




END. { module windows }
