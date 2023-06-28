(* PROGRAM scroller *)

(* +-------------------------------------------------------------------+ *)
(* |          See File SCROLLER.DOC for important information          | *)
(* +-------------------------------------------------------------------+ *)

(* Revision History *)
(* ---------------- *)

(*  19-OCT-1991		PMB	Original Coding, scrolling concepts      *)
(*  25-OCT-1991		PMB	Addition of pull-down menus              *)
(*  30-OCT-1991		PMB	Addition of mode concept                 *)
(*  1-NOV-1991		PMB	Addition of various hot keys             *)
(*  5-NOV-1991		PMB	SCROLLER.DOC product support file (rough)*)

(* UTILITIES and VT100 Written by Jesse M Heines, 1990-1991              *)
(* PAS_UTILS, MENUS and WINDOWS written by Peter M Brown,  1991          *)



[ INHERIT ('comp$dir:utilities' ,
	   'comp$dir:vt100' ,
	   'mod$dir:pas_utils' ,
	   'science$disk:[brownp.homework.91-101.a8]windows' ,
	   'science$disk:[brownp.homework.91-101.a8]menus') ]




PROGRAM scroller (INPUT,OUTPUT) ;



VAR
    current_file    : string ;		    (* the currently buffered file   *)
    current_dir	    : string ;		    (* directory where that file is  *)

    num_file_lines  : INTEGER ;		    (* number of lines in the file   *)
    current_line    : INTEGER ;	(* the current line OF THE FILE you are on   *)


    i		    : INTEGER ;		    (* loop index variable           *)

    file_truncated  : BOOLEAN := FALSE ;    (* has the file been truncated ? *)
    quit	    : BOOLEAN := FALSE ;    (* true if user wants to quit    *)
    c		    : key_code ;	    (* used by getkbhit	             *)


	(* These are set by menu OPTIONS *)

    clock_on : BOOLEAN := TRUE ;	    (* show the date and time ?      *)
    bar_on   : BOOLEAN := TRUE ;	    (* show the scroll bar ?         *)
    mode_on  : BOOLEAN := TRUE ;	    (* show what mode we are in ?    *)
    show_help: BOOLEAN := TRUE ;	    (* show help if user messes up ? *)







FUNCTION read_text_file(
	filename : string ;
	VAR num_file_lines : INTEGER ) :BOOLEAN;

VAR
   fileid : TEXT ;
 
BEGIN
    file_truncated := FALSE ;

    IF valid_file(filename) THEN
	BEGIN

	    read_text_file := TRUE ;

	    OPEN (fileid, filename, HISTORY := OLD) ;
	    RESET (fileid) ;

	    num_file_lines := 0 ;

	    WHILE ((NOT(EOF(fileid))) AND (num_file_lines < (max_lines - 1))) DO
		BEGIN
		    num_file_lines := num_file_lines + 1 ;
		    READLN(fileid,text_file[num_file_lines]) ;
		    text_file[num_file_lines] := { '  ' + } 
			    text_file[num_file_lines] ;
		END ;

	    num_file_lines := num_file_lines + 1 ;
	    text_file[num_file_lines] := EOB_marker ;

	    IF (NOT(EOF(fileid))) THEN
		BEGIN
		    writeat(5,top_line+1,'File truncated to '
			    +itoa(num_file_lines-1)+' lines.',TRUE) ;
		    file_truncated := TRUE ;
		END ;


	    CLOSE (fileid) ;

	    gotoxy(1,1) ;
	    WRITELN ;

	END 
    ELSE
	BEGIN
	    read_text_file := FALSE ;
	END ;
END ;


    (* get and display the current date and time *)

PROCEDURE update_clock ;

VAR
    datestr : string ;
    timestr : string ;
    timesigstr : string ;

BEGIN
    dateandtime(datestr,timestr,timesigstr) ;
    winwriteat(screen,50,4,'['+datestr+' '+timestr+' '+timesigstr+']       ',
		bold_on := TRUE, revs_on := FALSE, pad := FALSE) ;
END ;


(* This procedure is used to update information at the top of the screen *)

PROCEDURE update_header ;

CONST
    blanks = '                 ' ;

BEGIN
	(*display the number of lines in the file*)

    winwriteat(screen,4,4,'Number of Lines in File : '+itoa(num_file_lines-1)+
		'               ',bold_on := FALSE, revs_on := FALSE ,
		pad := FALSE) ;

    IF file_truncated THEN
	winwriteat(screen,34,4,' truncated ', bold_on := FALSE ,
		    revs_on := TRUE, pad := FALSE ) ;

	(* display the current filename *)

    winwriteat(screen,62,2,substr(current_file+blanks,1,18),bold_on := FALSE,
		revs_on := TRUE, pad := FALSE ) ;

	(* display the current pathname *)

    winwriteat(screen,38,2,substr(current_dir+blanks,1,22),bold_on := FALSE ,
		revs_on := TRUE , pad := FALSE ) ;

END ;





PROCEDURE set_up_screen ;
BEGIN
    winclrscr(screen) ;
    display_header ;
    display_full_menu(menu[1]) ;
END ;



PROCEDURE initialize_all ;
BEGIN
    current_file    := 'BILLOFRIGHTS.TXT' ; 
    current_dir	    := 'GROUP$DISK:[COMPSCI]' ;
    current_line    := 1 ;
    num_file_lines  := 1 ;

    current_menu := 1 ;
    initialize_menus(menu) ;

    mode := EDITING ;

END ;




PROCEDURE do_get_new_file(
	show_error : BOOLEAN := FALSE) ;

VAR
    ok : BOOLEAN:= FALSE ;  (* is the text file openable ?  *)
    filename : string ;	    (* the directory plus the file  *)

BEGIN
    REPEAT
	 filename := current_dir+current_file ;

	 ok := read_text_file(filename ,num_file_lines) ;

	 IF (not(ok)) THEN
	    IF show_error THEN
		BEGIN
		    beep ; beep ; beep ;
		    bold(on) ;
		    writeat(3,7,'Error opening "'+filename+'" .',TRUE) ;
		    bold(off) ;
		END 
	    ELSE
		do_file_change_file(current_file,current_dir) ;    

    UNTIL (ok) ;
END ;


BEGIN
    initialize_all ;
    set_up_screen ;

    bold(on) ;
    writeat(10,11,'Please wait one moment, attempting to load :') ;
    writeat(13,12,'"'+current_dir+current_file+'"') ;
    bold(off) ;

    WRITELN ;

    do_get_new_file (TRUE)  ;

    gotoxy(1,1) ;
    WRITELN ;

    update_header ;
{    windisplay_text (screen,text_file,num_file_lines) ; }

    winpage_up (screen,current_line,num_file_lines) ;

    IF bar_on THEN
	winupdate_scroll_bar(num_file_lines,current_line) ;

    gotoxy(1,1) ;	    (* put the cursor in a null position *)
    cursor(off) ;

    REPEAT  { until user quits }

	    (* use getkbhit so the clock will be updated every second *)

	c := getkbhit ;


	IF clock_on THEN
	    update_clock ;
	
	IF mode_on THEN
	    show_mode ;

	IF mode = EDITING THEN
	    CASE c OF

	    K_UP	:   BEGIN
				winscroll_up (screen, current_line,
					num_file_lines) ; (* scroll up *)
				IF bar_on THEN
    				    winupdate_scroll_bar(num_file_lines,current_line) ;
			    END ;

	    K_DOWN	:   BEGIN
				winscroll_down (screen, current_line,
					  num_file_lines) ; (* down *)
				IF bar_on THEN
				    winupdate_scroll_bar(num_file_lines,current_line) ;
			    END ;

	    K_UP_U,
	    K_LOW_U	:   BEGIN
				winpage_up (screen,current_line,num_file_lines) ;
				IF bar_on THEN
				    winupdate_scroll_bar(num_file_lines,current_line) ;
			    END ;

	    K_UP_D,
	    K_LOW_D	:   BEGIN
				winpage_down (screen,current_line,num_file_lines) ;
				IF bar_on THEN
				    winupdate_scroll_bar(num_file_lines,current_line) ;
			    END ;

	    511,
	    K_UP_T,
	    K_LOW_T	:   BEGIN
				mode	     := MAIN_MENU ;
				show_mode ;
			    END ;

	    K_UP_H,
	    K_LOW_H	:   BEGIN
				mode := MAIN_MENU ;
				show_mode ;
				current_menu := 1 ;
				display_option (menu[current_menu], FALSE) ;
				menu[current_menu].current_option := 1 ;
				display_option (menu[current_menu], TRUE) ;
			    END ;


	    K_UP_F,
	    K_LOW_F	:   BEGIN
				mode := MAIN_MENU ;
				show_mode ;
				current_menu := 1 ;
				display_option (menu[current_menu], FALSE) ;
				menu[current_menu].current_option := 2 ;
				display_option (menu[current_menu], TRUE) ;
			    END ;


	    K_UP_E,
	    K_LOW_E	:   BEGIN
				mode := MAIN_MENU ;
				show_mode ;
				current_menu := 1 ;
				display_option (menu[current_menu], FALSE) ;
				menu[current_menu].current_option := 3 ;
				display_option (menu[current_menu], TRUE) ;
			    END ;


	    K_UP_O,
	    K_LOW_O	:   BEGIN
				mode := MAIN_MENU ;
				show_mode ;
				current_menu := 1 ;
				display_option (menu[current_menu], FALSE) ;
				menu[current_menu].current_option := 4 ;
				display_option (menu[current_menu], TRUE) ;
			    END ;


	    K_UP_Q,
	    K_LOW_Q	:  quit := do_quit_quit; (* quit options (w/b menu later) *)

	    K_NULL	: ;	(* prevent constant beeping *)

	    OTHERWISE
		    BEGIN
			IF show_help THEN
			    do_help_general
			ELSE
			    beep ;
		    END ;

	    END  { case c if mode = EDITING  }
    ELSE
	IF mode = MAIN_MENU THEN
	    CASE c OF
		K_RIGHT	:   BEGIN
				WITH menu[current_menu] DO
				    BEGIN
					display_option (menu[current_menu],
									FALSE) ;
					current_option := current_option + 1 ;
					
					IF current_option > num_options THEN
					    BEGIN
						current_option := num_options ;
						beep ;
					    END ;

					display_option (menu[current_menu],
									TRUE) ;
				    END ;
			    END ;

		K_LEFT  :   BEGIN
				WITH menu[current_menu] DO
				    BEGIN
					display_option (menu[current_menu],
									FALSE) ;
					current_option := current_option - 1 ;
					
					IF current_option < 1 THEN
					    BEGIN
						current_option := 1 ;
						beep ;
					    END ;

					display_option (menu[current_menu],
									TRUE) ;
				    END ;
			    END ;


		K_RETURN,
		K_DOWN  :   WITH menu[1] DO
			    BEGIN

				mode := SUB_MENU ;
				current_menu := current_option + 1 ;

				WITH menu[current_menu] DO
				    BEGIN
					FOR i := 1 TO num_options DO
					    IF i = current_option THEN
						writeat(x_pos,y_pos+i-1,
							option[i], TRUE) 
					    ELSE
						writeat(x_pos,y_pos+i-1,
							option[i], FALSE) ;
					bold(ON) ;
					box(x_pos-1,y_pos-1,x_pos+
					    (LENGTH(option[1])),y_pos+
						num_options) ;
					bold(OFF) ;
				    END ;
			    END ;

		511     :   BEGIN
				mode := EDITING ; 
			    END ;

		K_NULL	: mode := MAIN_MENU ;	(* prevent constant beeping *)

	    OTHERWISE
		    BEGIN
			IF show_help THEN
			    do_help_general
			ELSE
			    beep ;
		    END ;

	    END { case c if mode = MAIN_MENU }

    ELSE 
	IF mode = SUB_MENU THEN
	    CASE c OF
		K_UP	:   BEGIN
				WITH menu[current_menu] DO
				    BEGIN
					display_option(menu[current_menu],FALSE) ;
					current_option := current_option - 1 ;
					IF current_option < 1 THEN
					    current_option := num_options ;
					display_option(menu[current_menu],TRUE);
				    END 
			    END ;

		K_DOWN  :   BEGIN
				WITH menu[current_menu] DO
				    BEGIN
					display_option(menu[current_menu],FALSE) ;
					current_option := current_option + 1 ;
					IF current_option > num_options THEN
					    current_option := 1 ;
					display_option(menu[current_menu],TRUE);
				    END 
			    END ;


		511     :   BEGIN
				mode := MAIN_MENU ; 
				
{				winrestore(screen,
				    menu[current_menu].x_pos - (current_menu - 2),
				    menu[current_menu].y_pos - 1,
is this needed			    menu[current_menu].x_pos+
					    length(menu[current_menu].option[1]),
				    menu[current_menu].y_pos+
					menu[current_menu].num_options+1) ;
				current_menu := 1 ;
}			    END ;


		K_NULL	:   mode := SUB_MENU ;	(* prevent constant beeping *)


		K_RETURN :  BEGIN

				CASE current_menu OF
				    1 : ; (* top level menu *)

				    2 :	BEGIN
					CASE menu[2].current_option OF 
					    1 : do_help_about ;
					    2 : do_help_general ;
				{	    3 : do_help_file ;
					    4 : do_help_edit ;
					    5 : do_help_options ; } 
					END ; {case }
					END ;

				    3 :	BEGIN
					CASE menu[3].current_option OF 
					    1 : do_file_change_dir
						    (current_dir) ;
					    2 : do_file_change_file
						    (current_file,current_dir) ;
					    3 : do_file_save ;
					    4 : do_file_save_as ;
					    5 : do_quit_save ;
					    6 : do_quit_save_as ;
					    7 : quit := do_quit_quit ;
					END ; {case }
					update_header ;
					END ;

				    4 :	BEGIN
					CASE menu[4].current_option OF 
					    1 : do_edit_edit ;
					    2 : do_edit_cut ;
					    3 : do_edit_copy ;
					    4 : do_edit_paste ;
					END ; {case }
					END ;

				    5 :	BEGIN
					CASE menu[5].current_option OF 
					    1 : do_toggle_scrollbar(bar_on) ;
					    2 : do_toggle_clock(clock_on) ;
					    3 : do_toggle_auto_help(show_help) ;
					    4 : do_refresh_screen ;
					    5 : do_resize_window ;
					END ; {case }
					END ;

				OTHERWISE 
				    BEGIN
					clrscr ;
					normalize_screen ;
					WRITELN('current_menu is BAD : ',
						current_menu:0) ;
					HALT ;
				    END ;
				END ;	{case }

				mode := MAIN_MENU ;

 				winrestore(screen,
				    menu[current_menu].x_pos - (current_menu - 2),
				    menu[current_menu].y_pos - 1,
				    menu[current_menu].x_pos+
					    length(menu[current_menu].option[1]),
				    menu[current_menu].y_pos+
					menu[current_menu].num_options+1) ;
				current_menu := 1 ;

			    END ; { K_return }

	    OTHERWISE
		    BEGIN
			IF show_help THEN
			    do_help_general
			ELSE
			    beep ;
		    END ;

	    END ; { case c if mode = SUB_MENU }


    IF mode_on THEN
	show_mode ;

    UNTIL (quit) ;

    cursor(ON) ;

    clrscr ;
    WRITELN('One moment please . . .') ;
    normalize_screen ;

END.
