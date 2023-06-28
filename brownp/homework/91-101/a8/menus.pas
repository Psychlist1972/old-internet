(* this module is for use with SCROLLER.PAS and WINDOWS.PAS (module) *)


[ ENVIRONMENT, INHERIT ('comp$dir:utilities' ,
			'comp$dir:vt100' ,
			'mod$dir:pas_utils' ,
			'science$disk:[brownp.homework.91-101.a8]windows') ]



MODULE menus (INPUT,OUTPUT) ;


CONST
    max_menus = 5 ;
    max_options = 10 ;
    long_line = 'qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq' ;

TYPE
    orient_type = (HORIZONTAL, VERTICAL) ;
    option_array = ARRAY [1..max_options] OF string ;
    help_array = ARRAY [1..max_options] OF string ;

    mode_type = (MAIN_MENU,SUB_MENU,EDITING) ;

    menu_record = RECORD
	num_options : INTEGER ;	    (* number of options in this menu         *)
	current_option : INTEGER ;  (* currently highlighted option           *)
	option_help : help_array ;  (* short help thing displayed when select.*)
	option	    : option_array ;(* the option text string to be displayed *)
	x_pos	    : INTEGER ;	    (* x position of the string               *)
	y_pos	    : INTEGER ;	    (* y position of the string               *)
	orientation : orient_type ;
	
    END ; { menu_record }

    menu_array = ARRAY [1..max_menus] OF menu_record ;
    


VAR
    menu	 : menu_array ;	    (* array containg menu records      *)
    current_menu : INTEGER ;
    mode	 : mode_type ;	    (* what the user is currently doing *)




PROCEDURE show_mode ;
BEGIN
    IF mode = MAIN_MENU THEN
	writeat(45,top_line-1,'Keys:  <-v->  <return>   <esc>      ',TRUE) 
    ELSE
    IF mode = EDITING THEN
	writeat(45,top_line-1,'Keys:  ^v  T  U  D  H  F  Q  E <esc>',TRUE)
    ELSE
    IF mode = SUB_MENU THEN
	writeat(45,top_line-1,'Keys:  ^v     <return>   <esc>      ',TRUE) ;
END ;


(* this procedure contains stuff that will NEVER change during runtime *)
(* BUT will be overdrawn by the pull downs .                           *)

PROCEDURE display_header ;
BEGIN
    winbox(1,1,36,3,TRUE) ;		(* Box around menu options *)

    winbox(61,1,80,3,FALSE) ;		(* box around file spec    *)

    winwriteat(screen,67,1,'Buffer',bold_on := TRUE, pad := FALSE ) ;	
					(* title of file spec box  *)

    winbox(37,1,60,3,FALSE) ;

    winwriteat(screen,46,1,'Path', bold_on := TRUE, pad := FALSE) ;

    winbox(1,top_line-1,80,24,FALSE) ;	(* box around text window  *)

END ;

(* This procedure will let you hit ANY key to continue.  It is simply *)
(* a "pause" used at the end of windows that don't require input      *)

PROCEDURE hit_return_to_continue( 
	x_pos   : INTEGER ;
	y_pos	: INTEGER ) ;

VAR
    c : key_code ;	(* used by getch *)

BEGIN
	(* Draw a small box around the the word "OK" *)
	(* and prompt the user to hit return         *)

    box(x_pos-1,y_pos,x_pos+4,y_pos+2) ;
    writeat(x_pos,y_pos+1,' OK ',TRUE) ;
    c := getch ;

	(* make the box "flash" for a second *)

    reverse(on) ;
    box(x_pos-1,y_pos,x_pos+4,y_pos+2) ;
    reverse(off) ;
    box(x_pos-1,y_pos,x_pos+4,y_pos+2) ;
END ;


(* ----------------------------------------------------------------------- *)

PROCEDURE not_ready_yet ;
CONST	
    top_x   = 21 ;
    top_y   = 9 ;
    bot_x   = 59 ;
    bot_y   = 17 ;	 

BEGIN
	(* draw a shaded popup window *)

    winpop_up (top_x, top_y, bot_x, bot_y, 'Ya gotta wait') ; 

	(* write the text in the window *)
    writeat(top_x + 3, top_y + 1,
	    'Sorry, but that option won''t be ',FALSE) ;
    writeat(top_x + 3, top_y +2,
	    'available until a later date. I ',FALSE) ;
    writeat(top_x + 3, top_y +3,
	    'will let you know when it is. (PMB) ',FALSE) ;

    hit_return_to_continue ((((top_x+bot_x) DIV 2) - 2 ), top_y + 5);    

	(* remove the popup window *)
    winrestore (screen, top_x, top_y, bot_x + 1, bot_y + 1) ; 
END ;



(* This function returns a string input by the user.  It will display a *)
(* small box and position the cursor within it while waiting for the    *)
(* user to enter the string.                                            *)

FUNCTION get_string_response(
	top_x : INTEGER ;		(* positions for the answer box *)
	top_y : INTEGER ;
	bot_x : INTEGER ;
	bot_y : INTEGER  ) : string ;

VAR
    str : string ;
    c   : key_code ;	    (* used by getch *)

BEGIN

    box(top_x,top_y,bot_x,bot_y) ;  (* draw box around answer area *)  
    gotoxy(top_x + 1,top_y + 1 ) ;  (* position cursor inside box  *)


	(* Here is the new way of entering the string. *)

	(* repeat until user presses return, or the string is as big as     *)
	(* the alloted space.  PROBLEM.  You cannot delete characters       *)
	(* this can be solved by implementing a LINKED LIST at a later date *)

    cursor(ON) ;

    REPEAT 
	c := getch ;
	IF c <> K_RETURN THEN
	    BEGIN
		str := str + chr(c) ;
		gotoxy(top_x + 1,top_y + 1 ) ;  (* position cursor inside box *)
		WRITELN(str) ;			(* display the updated string *)
	    END ;

    UNTIL ((c = K_RETURN) OR (LENGTH(str) >= (bot_x - top_x - 2))) ;

    cursor(OFF) ;

    get_string_response := str ;

END ;


(* This function gets a YES or NO from the user *)

FUNCTION get_boolean_response(
	yes_x : INTEGER ;	(* positions of yes and no on the screen *)
	yes_y : INTEGER ;
	no_x  : INTEGER ;
	no_y  : INTEGER ) : BOOLEAN ;

CONST
    YES = TRUE ;
    NO  = FALSE ;

VAR
    key		      : key_code ;	    (* user's keypress    *)
    current_selection : BOOLEAN := NO ;	    (* Highlighted answer *)

BEGIN
	(* yes box *)

    box (yes_x-2, yes_y-1, yes_x+4, yes_y+1) ;

	(* no box *)

    box (no_x-2, no_y-1, no_x+4, no_y+1) ;

    writeat(yes_x-1,yes_y,' YES ') ;
    writeat(no_x-1,no_y,' NO  ',TRUE) ;

    REPEAT
	key := getch ;


	    (* unhighlight the old selection *)

	IF current_selection THEN
	    writeat(yes_x-1, yes_y,' YES ', FALSE) 
	ELSE
	    writeat(no_x-1, no_y,' NO  ', FALSE) ;


	    (* parse the new selection *)

	CASE key OF
	    K_LEFT,  
	    K_RIGHT, 
	    K_UP,    
	    K_DOWN   : current_selection := (NOT(current_selection)) ;

	    K_UP_Y,
	    K_LOW_Y  : current_selection := YES ;

	    K_UP_N,
	    K_LOW_N  : current_selection := NO ;

	    K_RETURN :  BEGIN
			    IF current_selection THEN
				BEGIN
				    reverse(on) ;
				    box (yes_x-2, yes_y-1, yes_x+4, yes_y+1) ;
				    reverse(off) ;
				    box (yes_x-2, yes_y-1, yes_x+4, yes_y+1) ;
				END 
			    ELSE
				BEGIN
				    reverse(on) ;
				    box (no_x-2, no_y-1, no_x+4, no_y+1) ;
				    reverse(off) ;
				    box (no_x-2, no_y-1, no_x+4, no_y+1) ;
				END ;

			    get_boolean_response := current_selection ;

			END ;
	    OTHERWISE
		beep ;

	END ; { case }

	    (* highlight new selection *)

	IF current_selection THEN
	    writeat(yes_x-1, yes_y,' YES ', TRUE)
	ELSE
	    writeat(no_x-1, no_y,' NO  ', TRUE) ;


    UNTIL (key = K_RETURN) ;
END ;



(* help menu options ------------------------------------------------------- *)

PROCEDURE do_help_about ;
CONST	
    top_x   = 21 ;
    top_y   = 8 ;
    bot_x   = 59 ;
    bot_y   = 14 ;	 

BEGIN
	(* draw a shaded popup window *)

    winpop_up (top_x, top_y, bot_x, bot_y, 'About') ; 

	(* write the text in the window *)

    writeat(top_x + 1, top_y + 1,
	    'Scroller written by The Psychlist, ',FALSE) ;

    writeat(top_x + 1, top_y + 2,
	    'Peter M Brown UMass - Lowell 1991',FALSE) ;


    hit_return_to_continue ((((top_x+bot_x) DIV 2) - 2 ), top_y + 3);    

	(* remove the popup window *)

    winrestore (screen, top_x, top_y, bot_x + 1, bot_y + 1) ; 

END ;



PROCEDURE do_help_general ;  

CONST	
    top_x   = 21 ;
    top_y   = 8 ;
    bot_x   = 59 ;
    bot_y   = 19 ;	 

BEGIN
	(* draw a shaded popup window *)

    winpop_up (top_x, top_y, bot_x, bot_y, 'General Help') ; 

	(* write the text in the window *)

    writeat(top_x + 1, top_y + 1,
	    'Scroll throught the file by using the',FALSE) ;

    writeat(top_x + 1, top_y + 2,
	    'arrow keys.  Use "U" for page up, "D"',FALSE) ;

    writeat(top_x + 1, top_y + 3,
	    'for page down. Hit ESCape twice, or',FALSE) ;

    writeat(top_x + 1, top_y + 4,
	    'T for (T)op Menus or use "hot keys" ',FALSE) ;

    writeat(top_x + 1, top_y + 5,
	    '(H,F,E,O) to access top menus, and',FALSE) ;

    writeat(top_x + 1, top_y + 6,
	    'Q to quit.  See "keys" bar on right.',FALSE) ;

    hit_return_to_continue ((((top_x+bot_x) DIV 2) - 2 ), top_y + 8);    

	(* remove the popup window *)

    winrestore (screen, top_x, top_y, bot_x + 1, bot_y + 1) ; 

END ;


(* file menu options ------------------------------------------------------- *)

PROCEDURE do_file_change_file(
	VAR current_file : string ;
	    current_dir  : string ) ;

CONST	
    top_x   = 21 ;
    top_y   = 9 ;
    bot_x   = 59 ;
    bot_y   = 15 ;	 

BEGIN

	REPEAT
		(* draw a shaded popup window *)

	    winpop_up (top_x, top_y, bot_x, bot_y, 'Change File') ; 

		(* write the text in the window *)

	    writeat(top_x + 1, top_y + 1,
		    'Enter name of file to load from:',FALSE) ;
	    writeat(top_x + 1, top_y + 2,
		    current_dir,FALSE) ;

		(* actually get the new filename *)

	    current_file := strupr(get_string_response(22,12,58,14)) ;

	UNTIL (valid_file(current_dir + current_file)) ;

	(* remove the popup window *)

    winrestore (screen, top_x, top_y, bot_x + 1, bot_y + 1) ; 
END ;


PROCEDURE do_file_change_dir(
	VAR current_dir : string ) ;

CONST	
    top_x   = 21 ;
    top_y   = 9 ;
    bot_x   = 59 ;
    bot_y   = 15 ;	 

BEGIN
	(* draw a shaded popup window *)

    winpop_up (top_x, top_y, bot_x, bot_y, 'Change Path') ; 

	(* write the text in the window *)

    writeat(top_x + 1, top_y + 1,
	    'Enter new pathname :',FALSE) ;

	(* actually get the new directory *)

    current_dir := strupr(get_string_response(22,12,58,14)) ;

	(* remove the popup window *)

    winrestore (screen, top_x, top_y, bot_x + 1, bot_y + 1) ; 

END ;


PROCEDURE do_file_save ;
BEGIN
    not_ready_yet ;
END ;

PROCEDURE do_file_save_as ;
BEGIN
    not_ready_yet ;
END ;

PROCEDURE do_quit_save ;
BEGIN
    not_ready_yet ;
END ;

PROCEDURE do_quit_save_as ;
BEGIN
    not_ready_yet ;
END ;

(* This function returns true if the user decides to quit.  *)


FUNCTION do_quit_quit : BOOLEAN ;

CONST	
    top_x   = 21 ;
    top_y   = 9 ;
    bot_x   = 59 ;
    bot_y   = 15 ;	 


BEGIN
	(* draw a shaded popup window *)

    winpop_up (top_x, top_y, bot_x, bot_y, 'Quit') ; 

	(* write the text in the window *)

    writeat(top_x + 6, top_y + 1,
	    'Do you really want to quit ? ',FALSE) ;

    do_quit_quit := get_boolean_response(top_x+12, top_y+4, top_x+25, top_y+4 ) ;

    winrestore(screen, top_x, top_y, bot_x+1, bot_y+1) ; 

END ;


(* options menu options ---------------------------------------------------- *)

PROCEDURE do_toggle_scrollbar(
	VAR bar_on : BOOLEAN) ;

BEGIN
    bar_on := (NOT(bar_on)) ;

    IF NOT(bar_on) THEN
	BEGIN
	    graphicsOn ;
	    vertln(80,6,'xxxxxxxxxxxxxxx') ;   (* the actual scroll bar *)
	    graphicsOff ;
	END 
END ;


PROCEDURE do_toggle_clock(
	VAR clock_on : BOOLEAN) ;

BEGIN
    clock_on := (NOT(clock_on)) ;

    IF NOT(clock_on) THEN
	winwriteat(screen,50,4,'                          ',
	    bold_on := FALSE, revs_on := FALSE, pad := FALSE) 
END ;


PROCEDURE do_toggle_auto_help(
	VAR show_help : BOOLEAN) ;

BEGIN
    show_help := (NOT(show_help)) ;
END ;


PROCEDURE do_refresh_screen ;
BEGIN
    not_ready_yet ;
END ;


PROCEDURE do_resize_window ;
BEGIN
    not_ready_yet ;
END ;

(* ------------ edit menu options ---------------------------------------- *)

PROCEDURE do_edit_edit ;
BEGIN
    not_ready_yet ;
END ;

PROCEDURE do_edit_cut ;
BEGIN
    not_ready_yet ;
END ;

PROCEDURE do_edit_copy ;
BEGIN
    not_ready_yet ;
END ;

PROCEDURE do_edit_paste ;
BEGIN
    not_ready_yet ;
END ;



(* This procedure will display the current menu option at the current   *)
(* menu option's x and y position, and depending upon BOOLEAN HIGHLIGHT *)
(* This procedure will also highlight or unhighlight the option         *)


PROCEDURE display_option (
	VAR one_menu : menu_record ;
	highlight    : BOOLEAN ) ;  (* should I or shouldn't I highlight *)

VAR
    i : INTEGER := 0 ;
    option_x : INTEGER ;

BEGIN
    WITH one_menu DO	
	BEGIN
	    IF orientation = VERTICAL THEN
		writeat(x_pos , y_pos+ current_option-1, 
		    option[current_option], highlight) 
	    ELSE
		BEGIN
		    IF current_option <> 1 THEN
			FOR i := 1 TO current_option DO
			    option_x := (LENGTH(option[1]) * (i - 1)) + x_pos
		    ELSE
			option_x := x_pos ;

			writeat(option_x , y_pos, option[current_option], 
				highlight) 

		END ;

		(* display the little option help string like MS Word does *)

{	    IF highlight THEN
		writeat(2,24,option_help[current_option],FALSE) 
	    ELSE 
		BEGIN
		    graphicsOn ;
		    writeat(2,24,long_line,FALSE) ;
		    graphicsOff ;
		    home ;  
		END ; }
	END ;
END ;

PROCEDURE display_full_menu(
	one_menu : menu_record ) ;
VAR
    i : INTEGER ;	(* local loop index *)

BEGIN
    WITH one_menu DO
	BEGIN
	    IF orientation = HORIZONTAL THEN
		BEGIN
		    gotoxy(x_pos,y_pos) ;
		    FOR i := 1 TO num_options DO
			WRITE(option[i]) ;

		    WRITELN ;	    (* dump buffer *)

		    current_option := 1 ;
		    display_option(menu[current_menu],TRUE)
		END
	    ELSE
		BEGIN
		    FOR i := 1 TO num_options DO
			BEGIN
			    writeat(x_pos,y_pos+i-1,option[i],FALSE) ;
			    current_option := 1 ;
			    display_option(menu[current_menu],TRUE)
			END ;
		END ;
	END ;
END ;



PROCEDURE initialize_menus(
	VAR menu : menu_array ) ;
BEGIN
    menu[1].num_options := 4 ;
    menu[1].orientation := HORIZONTAL ;
    menu[1].x_pos := 2 ;
    menu[1].y_pos := 2 ;
    menu[1].current_option := 1 ;
    menu[1].option[1] := ' (H)elp ' ;
    menu[1].option[2] := ' (F)ile ' ;
    menu[1].option[3] := ' (E)dit ' ;
    menu[1].option[4] := ' (O)ptions' ;
    
	(* Help menu *)

    menu[2].num_options := 2 ;
    menu[2].orientation := VERTICAL ;
    menu[2].x_pos := 2 ;
    menu[2].y_pos := 4 ;
    menu[2].current_option := 1 ;
    menu[2].option[1] := ' About        ' ;
    menu[2].option[2] := ' General Help ' ;
{    menu[2].option[3] := ' File Help    ' ;
    menu[2].option[4] := ' Edit Help    ' ; 
    menu[2].option[5] := ' Option Help  ' ; 
}
	(* File menu *)

    menu[3].num_options := 7 ;
    menu[3].orientation := VERTICAL ;
    menu[3].x_pos := ((LENGTH(menu[1].option[1])) + 2) ;
    menu[3].y_pos := 4 ;
    menu[3].current_option := 1 ;
    menu[3].option[1] := ' Change Path   ' ;
    menu[3].option[2] := ' New File      ' ;
    menu[3].option[3] := ' ~Save         ' ;
    menu[3].option[4] := ' ~Save As      ' ; 
    menu[3].option[5] := ' ~Quit/Save    ' ; 
    menu[3].option[6] := ' ~Quit/Save As ' ; 
    menu[3].option[7] := ' Quit/nosave   ' ; 

	(* Edit menu *)

    menu[4].num_options := 4 ;
    menu[4].orientation := VERTICAL ;
    menu[4].x_pos := ((LENGTH(menu[1].option[1] + menu[1].option[2])) + 2) ;
    menu[4].y_pos := 4 ;
    menu[4].current_option := 1 ;
    menu[4].option[1] := ' ~Edit text ' ;
    menu[4].option[2] := ' ~Cut text  ' ;
    menu[4].option[3] := ' ~Copy text ' ;
    menu[4].option[4] := ' ~Paste Text' ; 

	(* Options menu *)

    menu[5].num_options := 4 ;
    menu[5].orientation := VERTICAL ;
    menu[5].x_pos := ((LENGTH(menu[1].option[1] + menu[1].option[2] +
				menu[1].option[3])) + 2) ;
    menu[5].y_pos := 4 ;
    menu[5].current_option := 1 ;
    menu[5].option[1] := ' Toggle Scrollbar ' ;
    menu[5].option[2] := ' Toggle Clock     ' ;
    menu[5].option[3] := ' Toggle Auto Help ' ;
    menu[5].option[4] := ' ~Screen Refresh  ' ;
    menu[5].option[5] := ' ~Resize window   ' ; 
    

END ;

END. { module }
