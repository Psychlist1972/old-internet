(*--------------------------------------------*)
(* GEORGE, DON'T SPAWN THIS PROGRAM !!!       *)
(*--------------------------------------------*)

(* Electronic personals. (E-PERSONALS)        *)
(* Written By Peter M Brown UMass Lowell 1991 *)
(* Based upon a concept by George Cercone     *)
(* All documentation by Peter M Brown         *)


(* Internet Mailing addresses for Peter M Brown :            *)
(* --------------------------------------------------------- *)
(* "brownp@woods.ulowell.edu" "pbrown@cs.ulowell.edu"        *)
(* "gmngr4@woods.ulowell.edu" "snappa@albert.gnu.ai.mit.edu" *)


(* Internet Mailing addresses for George Cercone :           *)
(* --------------------------------------------------------- *)
(* "cerconeg@woods.ulowell.edu"                              *)
(* "gcercone@cs.ulowell.edu"                                 *)
(* --------------------------------------------------------- *)

(* Revision History *)
(* ------------+--------+-------+-------------------------------------------- *)
(* Revis. Date |  Vers. |  Who  | Description of changes                      *)
(* ------------+--------+-------+-------------------------------------------- *)
(* 04-DEC-1991    v1.0     PMB   Original Coding by Peter M Brown             *)
(* 04-DEC-1991    v1.1     PMB   Addition of Read New and Scrollable Menu     *)
(* 04-DEC-1991    v1.2     PMB   Addition of Write Personal and LIB$ routines *)
(* 05-DEC-1991    v1.3     PMB   Addition of users, phone, mail and clock     *)
(* 05-DEC-1991    v1.4     PMB   Addition of catch-up                         *)
(* 05-DEC-1991    v1.5     PMB   Addition of List read/unread function.       *)
(* 05-DEC-1991    v1.6     PMB   Addition of Help option.                     *)
(* 05-DEC-1991    v1.7     PMB   Addition of Screen refresh.                  *)
(* 05-DEC-1991    v1.8     PMB   Addition of Notify_of_bugs                   *)
(* 05-DEC-1991    v1.9     PMB   Addition of Extract.                         *)
(* 05-DEC-1991    v2.0     PMB   Addition of Unread, Exit and Quit durng read *)
(*                               as well as statistics.                       *)
(* 06-DEC-1991    v2.1     PMB   Addition of Jump_to, Edit_masterfile,        *)
(*                               reset_personals, logging usernames.          *)
(* 11-DEC-1991    v2.2     PMB   Addition of the PERSRC.DAT routines, options *)
(* 11-DEC-1991    v2.3     PMB   Addition of Archives.                        *)
(* 13-DEC-1991    v2.4     PMB   Addition of followup.                        *)


(* -------------------------------------------------------------------------- *)
(* Documented shortcomings / bugs                                             *)
(* -------------------------------------------------------------------------- *)
(* This program requires a fairly sizeable allocation of temporary disk space *)
(* in the accounts of the people running it.  It requires room for:           *)
(*     PER.DAT      - A copy of the masterfile containing all personals.      *)
(*     PER2.DAT     - A copy of PER.DAT used by the Extract procedure.        *)
(*     PER_PER.DAT  - The personal you just wrote.                            *)
(*     PER_DATE.DAT - The header for the personal you just wrote (3 lines)    *)
(*     PER_BUGS.DAT - Used if you EMail bugs to the personals administrators  *)
(*                                                                            *)
(* as well as room for these PERMANENT files:                                 *)
(*     PERSONAL.DAT - The datafile storing the number or read/unread personals*)
(*     PERSONAL_x.PERS - only used if you EXTRACT a personal from the E_Page  *)
(*                                                                            *)
(* -------------------------------------------------------------------------- *)
(*                                                                            *)
(* If 2 people try and append to the masterfile then one will get a deadlock  *)
(* and crash, losing the currently written personal.                          *)
(*                                                                            *)
(* -------------------------------------------------------------------------- *)


(* logicals defined in LOGIN.COM/[BROWNP.TOOLS]NEWCMDS.COM *)
(* ------------------------------------------------------- *)
(* comp$dir = group$disk:[compsci]                         *)
(* mod$dir = science$disk:[brownp.homework.91-101.modules  *)
(* ------------------------------------------------------- *)

(* sys logicals defined in the LMS_PROCESS_TABLE           *)
(* ------------------------------------------------------- *)
(* sys$login   = the directory that is default at login    *)
(* sys$library = directory that LIB$ routines are in       *)
(* ------------------------------------------------------- *)

 
[INHERIT ('comp$dir:utilities', 'comp$dir:vt100',  'mod$dir:pas_utils', 
	    'sys$library:starlet') ]


(* -------------------------------------------------------------- *)
(* External Declarations Imported                                 *)
(* -------------------------------------------------------------- *)
(* UTILITIES.PEN   - Written By Jesse M Heines UMass Lowell 1991  *)
(*                                                                *)
(* TYPES string and key_code                                      *)
(*                                                                *)
(* stripleadingblanks    striptrailingblanks    dateandtime       *)
(* itoa   beep   strlwr                                           *)
(*                                                                *)
(* -------------------------------------------------------------- *)
(* VT100.PEN       - Written By Jesse M Heines UMass Lowell 1991  *)
(*                                                                *)
(* CONSTants  ON = TRUE  OFF = FALSE                              *)
(*                                                                *)
(* clrscr  reverse  gotoxy  doubleheighttop  doubleheightbottom   *)
(* doublewidth  attributesOFF  graphicsOFF  box  bold  clreos     *)
(* blink  graphicsON                                              *)
(*                                                                *)
(* -------------------------------------------------------------- *)
(* PAS_UTILS.PEN   - Written By Peter M Brown UMass Lowell 1991   *)
(*                                                                *)
(* CONSTants  K_x     CTRL_x                                      *)
(*                                                                *)
(* valid_file   lib$spawn   echo                                  *)
(*                                                                *)
(* -------------------------------------------------------------- *)
(* STARLET         - Imported from the SYS$LIBRARY                *)
(*                                                                *)
(* lib$delete_file   lib$disable_ctrl   lib$enable_ctrl           *)
(*                                                                *)
(* -------------------------------------------------------------- *)


PROGRAM e_personals (INPUT, OUTPUT) ;

CONST
    adm1 = 'WOODS::BROWNP' ;		 (* People who get mail about bugs *) 
    adm2 = 'WOODS::CERCONEG' ;		 (* when someone hits CTRL-B       *)

	(* NOTE: passwords must be lowercase and have NO *)
	(*       leading or trailing blanks.             *)

    edit_password = 'monty python' ;	 (* for editing master file     *)
    reset_password = 'monty python' ;    (* for resetting the personals *)

    arc_comfile = 'science$disk:[brownp.personal]arc.com' ;
    pers_datfile = 'electrical$disk:[cerconeg.bbs]PER.DAT' ; (* masterfile *)
    log_comfile = 'electrical$disk:[cerconeg.bbs]LOG.COM' ;  (* users file *)
    copy_comfile = 'science$disk:[brownp.personal]PERS_COPY.COM' ;

    version	    = 'v2.4' ;	(* change this to correspond with rev hist *)
    max_personals   = 500 ;	(* maximum number of personals in a week   *)
    max_menus	    = 13 ;	(* the number of main screen menu options  *)
    top_row	    = 5 ;	(* top row for displaying menus            *)


TYPE
	(* record used to update datfile.  NEVER change this *)

    personal_type = RECORD
			status	    : string ;	    (* 'read', 'unread' *)
			num_lines   : INTEGER ;	    (* lines of text    *)
			date_string : string ;	    (* date written     *)
			time_string : string ;	    (* time written     *)
			author	    : string ;	    (* personal name    *)
			to_whom	    : string ;	    (* to whom          *)
		    END ;


    option_record = RECORD
			dcl_prompt	    : string ;
			default_to	    : string ;
			enhanced	    : string ;
			extract_directory   : string ;
			personal_name	    : string ;
			sigfile		    : string ;
			temp_dir	    : string ;
			menu_kind	    : string ;
			editor_call	    : string ;
		    END ;

VAR
    enhanced	    : BOOLEAN ;		(* copy of options.enhanced   *) 
    mask	    : UNSIGNED ;	(* for disabling control y, c *)
    saved_ctrl_mask : UNSIGNED ;	(* old control key mask       *)

    left_column	    : INTEGER := 22 ;	    (* for menu display            *)
    done	    : BOOLEAN := FALSE ;    (* is user done with program ? *)
    user_level	    : INTEGER := 0 ;	    (* useless right now           *)
    current_personal: INTEGER := 1 ;
    current_menu    : INTEGER ;		    (* current menu option         *)
    num_active	    : INTEGER := 1 ;        (* current number of personals *)
    first_reading   : BOOLEAN := TRUE ;	    (* first read of this session  *)

    menu	    : ARRAY [1..max_menus] OF string ; (* main menu options *)

    personal	    : ARRAY [1..max_personals] OF personal_type ;

    options	    : option_record ;


(* draw a graphics line at the current position on the screen *)

PROCEDURE draw_line ;

VAR
    k : INTEGER ;	(* local loop index variable *)

BEGIN
    IF enhanced THEN
	BEGIN
	    graphicsON ;
	    FOR k := 1 to 78 DO
		WRITE ('q') ;
	    WRITELN ('q') ;
	    graphicsOFF ;
	END
    ELSE
	BEGIN
	    FOR k := 1 to 78 DO
		WRITE ('-') ;
	    WRITELN ('-') ; 
	END ;
END ;

(* This procedure is used to update the PERSONAL.DAT file for each person *)
(* The PERSONAL.DAT file is   'SYS$LOGIN:PERSONAL.DAT'                    *)

PROCEDURE update_datfile ;

VAR
    fileid   : TEXT ;		(* VMS file id for the personal.DAT file *)
    k	     : INTEGER ;	(* local loop index variable             *)
    temp     : string ;		(* used to write status to datfile       *)

BEGIN
    OPEN (fileid, 'SYS$LOGIN:PERSONAL.DAT', HISTORY := UNKNOWN, 
	    ERROR := CONTINUE) ;
    REWRITE (fileid) ;

    WRITELN (fileid, num_active:0) ;	    (* update number of active pers *)

    FOR k := 1 TO num_active DO
    	BEGIN
	    stripleadingblanks (personal[k].status) ;
	    striptrailingblanks (personal[k].status) ;
 
	    IF (personal[k].status = 'read') OR
	       (personal[k].status = '1') THEN
		temp := '1'			(* for compatibility  *)
	    ELSE				(* w/george's version *)
		temp := '0' ;

	    WRITELN (fileid, temp) ;
	END ;

    CLOSE (fileid) ;  
END ;


PROCEDURE create_persrc_file ;

VAR
    persrc : TEXT ;

BEGIN
    stripleadingblanks (options.personal_name) ;
    striptrailingblanks (options.personal_name) ;

    IF options.personal_name = '' THEN
	BEGIN
	    WRITELN ;
	    WRITELN ('You will only have to do this once.') ;
	    WRITELN ('Please answer each question.') ;

	    REPEAT 
		WRITELN ;
		WRITE ('Please enter your default personal name : ') ;
		READLN (options.personal_name) ;
		stripleadingblanks (options.personal_name) ;
		striptrailingblanks (options.personal_name) ;
	    UNTIL (options.personal_name <> '') ;
	END ;

    OPEN (persrc, 'SYS$LOGIN:PERSRC.DAT',HISTORY := NEW, ERROR := CONTINUE) ;
    REWRITE (persrc) ;

    WRITELN (persrc,'# Created by Personals  '+version) ;
    WRITELN (persrc,'# Written By Peter M Brown UMass Lowell 1991-92') ;
    WRITELN (persrc,'#') ;
    WRITELN (persrc,'# Feel free to edit this file and change the defaults.') ;
    WRITELN (persrc,'#') ;
    WRITELN (persrc,'##########################################################################') ;
    WRITELN (persrc) ;
    WRITELN (persrc,'# Do you want an enhanced display (reverse, bold etc...)') ;
    WRITELN (persrc) ;
    WRITELN (persrc,'enhanced = ',options.enhanced) ;
    WRITELN (persrc) ;
    WRITELN (persrc,'# What directory should extracted files show up in (sys$login:,') ;
    WRITELN (persrc,'# [SMITHJ], [SMITHJ.PERSONALS]) are all valid specifications)') ;
    WRITELN (persrc) ;
    WRITELN (persrc,'extract_directory = ',options.extract_directory) ;
    WRITELN (persrc) ;
    WRITELN (persrc,'# What is your personal name. Leave this empty if you want to be prompted.') ;
    WRITELN (persrc) ;
    WRITELN (persrc,'personal_name = ',options.personal_name) ;
    WRITELN (persrc) ;
    WRITELN (persrc,'# What is the default "To Line" to show up in the personals') ;
    WRITELN (persrc,'# header section? (ex All interested parties.)') ;
    WRITELN (persrc) ;
    WRITELN (persrc,'default_to = ',options.default_to) ;
    WRITELN (persrc) ;
    WRITELN (persrc,'# What is your signature file (include directory specification.) ') ;
    WRITELN (persrc,'# example: (sys$login:sigfile.sig, [SMITHJ.PERSONAL]sigfile.sig)') ;
    WRITELN (persrc) ;
    WRITELN (persrc,'sigfile = ',options.sigfile) ;
    WRITELN (persrc) ;
    WRITELN (persrc,'# What directory should the temporary files be kept in ? ') ;
    WRITELN (persrc) ;
    WRITELN (persrc,'temp_dir = ',options.temp_dir) ;
    WRITELN (persrc) ;
    WRITELN (persrc,'# What is the DCL command line used to call your editor?') ;
    WRITELN (persrc,'# Don''t change this if you are not sure what it means.') ;
    WRITELN (persrc,'# This can be used to call up command libraries and/or') ;
    WRITELN (persrc,'# environments with your editor') ;
    WRITELN (persrc) ;
    WRITELN (persrc,'# example: EDIT/CREATE (which is the default) or LSE or EDIT/TPU.') ;
    WRITELN (persrc) ;
    WRITELN (persrc,'editor_call = ',options.editor_call) ;
    WRITELN (persrc) ;
    WRITELN (persrc,'# What prompt to you want to have for the DCL spawn?') ;
    WRITELN (persrc) ;
    WRITELN (persrc,'dcl_prompt = ',options.dcl_prompt) ;
    WRITELN (persrc) ;
    WRITELN (persrc,'# Do you want the menu highlighted or do you want to use ') ;
    WRITELN (persrc,'# the -> for selections (highlight, arrow)') ;
    WRITELN (persrc) ;
    WRITELN (persrc,'menu_kind = ',options.menu_kind) ;
    WRITELN (persrc) ;
    WRITELN (persrc,'# Do not add any extra definition lines to this file,') ;
    WRITELN (persrc,'# feel free to add comment lines/ documentation, but they') ;
    WRITELN (persrc,'# Will disappear when versions are upgraded.') ;
    CLOSE (persrc) ;

END ;

PROCEDURE update_persrc_version ;
VAR
    persrc	: TEXT ;
    text_line	: string ;
    current_version : BOOLEAN := FALSE ;

BEGIN
    OPEN (persrc, 'SYS$LOGIN:PERSRC.DAT',HISTORY := OLD, ERROR := CONTINUE) ;
    RESET (persrc) ;
    WHILE NOT(EOF(persrc)) AND (NOT(current_version)) DO
	BEGIN
	    READLN (persrc, text_line) ;
	    IF (INDEX (text_line, 'dcl_prompt =') > 0) AND
	       (INDEX (text_line, '#') = 0) THEN
		BEGIN
		    current_version := TRUE ;
		END ;
	END ;

    CLOSE (persrc) ;

    IF NOT(current_version) THEN
	BEGIN
	    create_persrc_file ;
	END ;
END ;


(* This file reads the list of options from your sys$login:persrc.dat file *)


PROCEDURE read_persrc_file ;

CONST
    persrc_file = 'SYS$LOGIN:PERSRC.DAT' ;

VAR
    line_number : INTEGER ;
    pers_rc	: TEXT ;
    option_line : string ;


    FUNCTION rest_of_line : string ;

    VAR 
	i : INTEGER ;	    (* index of the '=' *)
	s : string ;

    BEGIN
	i := INDEX (option_line, '=') ;
	s := substr (option_line, i + 1, (option_line.length - i)) ;

	stripleadingblanks(s) ;
	striptrailingblanks(s) ;

	rest_of_line := s ;

    END ;

BEGIN
    IF valid_file (persrc_file) THEN
	BEGIN
	    OPEN (pers_rc, persrc_file, HISTORY := OLD, ERROR := CONTINUE) ;
	    RESET (pers_rc) ;

	    WHILE (NOT(EOF(pers_rc))) DO
		BEGIN
		    READLN (pers_rc, option_line) ;
		    line_number := line_number + 1 ;

		    stripleadingblanks(option_line) ;
		    striptrailingblanks(option_line) ;

		    IF (option_line.length > 0) THEN
			BEGIN
			    IF option_line[1] <> '#' THEN
				IF (INDEX (option_line, 'enhanced =') > 0) THEN
				    options.enhanced := rest_of_line
				ELSE IF (INDEX (option_line, 'extract_directory =') > 0) THEN 
				    options.extract_directory := rest_of_line
				ELSE IF (INDEX (option_line, 'personal_name =') > 0 ) THEN
				    options.personal_name := rest_of_line
				ELSE IF (INDEX (option_line, 'sigfile =') > 0) THEN
				    options.sigfile := rest_of_line
				ELSE IF (INDEX (option_line, 'temp_dir =') > 0) THEN
				    options.temp_dir := rest_of_line
				ELSE IF (INDEX (option_line, 'menu_kind =') > 0) THEN
				    options.menu_kind := rest_of_line
				ELSE IF (INDEX (option_line, 'default_to =') > 0 ) THEN
				    options.default_to := rest_of_line
				ELSE IF (INDEX (option_line, 'editor_call =') > 0 ) THEN
				    options.editor_call := rest_of_line
				ELSE IF (INDEX (option_line, 'dcl_prompt =') > 0 ) THEN
				    options.dcl_prompt := rest_of_line

			END
		    ELSE IF option_line.length > 0 THEN 
			    IF option_line[1] <> '#' THEN
				BEGIN
				    stripleadingblanks (option_line) ;
				    striptrailingblanks (option_line) ;

				    bold(enhanced) ;
				    WRITELN ('Error parsing line ',line_number:0,' of PERSRC.DAT file.') ;
				    WRITELN (option_line) ;
				    bold(OFF) ;
				END

		END ;
	    CLOSE (pers_rc) ;
	END
    ELSE
	create_persrc_file ;
END ;


(* This procedure will read data from a user's personal.DAT file *)
(* located in 'SYS$LOGIN:PERSONAL.DAT'                           *)

PROCEDURE read_init_file ;

CONST
    dat_file = 'SYS$LOGIN:PERSONAL.DAT' ;

VAR
    fileid	: TEXT ;	    (* VMS fileid for the personal.DAT file  *)
    line_num	: INTEGER := 0 ;    (* what line are we on in the datfile    *)
    text_line	: string ;	    (* a single line in PERSONAL.DAT file    *)
    k : INTEGER := 0 ;		    (* local loop index variable             *)

BEGIN
    FOR k := 1 to max_personals DO
	personal[k].status := 'unread' ;

    IF (valid_file (dat_file)) THEN
	BEGIN
	    OPEN (fileid, dat_file, HISTORY := OLD, SHARING := READWRITE,
		    ERROR := CONTINUE) ;
	    RESET (fileid, ERROR := CONTINUE ) ;
	    READLN (fileid, num_active) ;

	    WHILE (NOT(EOF(fileid))) DO
		BEGIN
		    line_num := line_num + 1 ;
		    READLN(fileid,text_line) ;

		    stripleadingblanks (text_line) ;
		    striptrailingblanks (text_line) ;

		    IF (text_line = '1') OR (text_line = 'read') THEN
			personal[line_num].status := 'read' 
		    ELSE IF (text_line = '0') OR (text_line = 'unread') THEN
			personal[line_num].status := 'unread'
		    ELSE
			BEGIN
			    WRITELN('Error parsing line ',line_num:0,' of PERSONAL.DAT file/') ;
			    WRITELN(' "',text_line,'"') ;
			    personal[line_num].status := 'unread' ;
			END ;
		END ;
	    CLOSE (fileid) ;
	END
    ELSE
	update_datfile ;
END ;


(* This procedure will check the PER.DAT file and return the number of *)
(* currently active personals.                                         *)

PROCEDURE check_active_personals ;
VAR
    text_line	     : string ;		    (* a single line in PER.DAT    *)
    number_personals : INTEGER := 0 ;	    (* number of personals read in *)
    fileid	     : TEXT ;		    (* VMS file id of PER.DAT      *)
    num_lines	     : INTEGER := 0 ;	    (* number of lines in perosnal *)
    k		     : INTEGER := 0 ;	    (* local loop index variable   *)


BEGIN

    OPEN (fileid, pers_datfile, HISTORY := OLD, ERROR := CONTINUE) ;
    RESET (fileid, ERROR := CONTINUE ) ;

    WHILE NOT(EOF(fileid)) DO
	BEGIN
	    number_personals := number_personals + 1 ;

	    READLN (fileid, num_lines) ;			    (* lines*)
	    personal[number_personals].num_lines := num_lines ;

	    READLN (fileid, text_line) ;			    (* date *)
	    personal[number_personals].date_string := text_line ;

	    READLN (fileid, text_line) ;			    (* time *)
	    personal[number_personals].time_string := text_line ;


	    IF (num_lines > 4) THEN
		BEGIN 
		    READLN (fileid, text_line) ;

		    IF text_line.length > 24 THEN 
			personal[number_personals].author := 
			    (substr(text_line, 22,(text_line.length - 21)))
		    ELSE
			personal[number_personals].author := 'Unknown' ;

		    READLN (fileid, text_line) ;

		    IF text_line.length > 24 THEN 
			personal[number_personals].to_whom := 
			    (substr(text_line, 22,(text_line.length - 21)))
		    ELSE
			personal[number_personals].to_whom := 'Unknown' ;

		    FOR k := 1 TO num_lines - 2 DO
			READLN (fileid, text_line) ;
		END 
	    ELSE
		BEGIN
		    personal[number_personals].author := 'Unknown' ;
		    personal[number_personals].to_whom := 'Unknown' ;

		    FOR k := 1 TO num_lines DO		 (* actual personal *)
			READLN (fileid, text_line) ;
		END ;
	END ;


	IF (number_personals < num_active) THEN
	    BEGIN
		FOR k := 1 TO max_personals DO
		    personal[k].status := 'unread' ;
	    END ;

	num_active := number_personals ;

	update_datfile ;

END ;


(* This procedure is used to put the header and instructions on the screen  *)
(* This should be called at the end of every unit of PERSONAL.  SHould be   *)
(* Used with DISPLAY_MENUS.  Both are contained in peocedure REFRESH_SCREEN *)

PROCEDURE display_header ;

CONST
    e_pers = ' VAX/VMS  Electronic Personals ' ;

BEGIN
    graphicsOFF ;

    clrscr ;

    reverse(enhanced) ;
    gotoxy ((20-length(e_pers) DIV 2),1) ;
    doubleheighttop(enhanced) ;
    WRITELN(e_pers) ;
    doubleheighttop(OFF) ;
    gotoxy ((20-length(e_pers) DIV 2),2) ;
    doubleheightbottom(enhanced) ;
    WRITELN(e_pers) ;
    doubleheightbottom(OFF) ;
    reverse(OFF) ;
    WRITELN ;	    (* dump buffer *)

    reverse(enhanced) ;
    gotoxy ((40-length(e_pers)), 3) ;
    WRITELN(' ':(length(e_pers)*2) ) ;
    gotoxy ((40-length(e_pers)), 4) ;
    WRITELN(' ':(length(e_pers)*2) ) ;

    gotoxy ((40 - LENGTH(version+' by peter m brown (the psychlist)') DIV 2), 3) ;
    WRITELN (version,' By Peter M Brown (The Psychlist)') ;
    gotoxy ((40 - length('Based upon an original concept by George Cercone') DIV 2) ,4) ;
    WRITELN ('Based upon an original concept by George Cercone') ;
    reverse(OFF) ;
    WRITELN ;	    (* dump buffer *)

    gotoxy (1,20) ;
    doublewidth(enhanced) ;
    WRITELN ('    Use the cursor keys or hot keys.') ;

    gotoxy (1,21) ;
    doublewidth(enhanced) ;
    WRITELN ('     ? for HELP , CTRL-B for bugs.') ;

    doublewidth(OFF) ;
    WRITELN ;	    (* dump buffer *)


    gotoxyimmediate (3,8) ;
    cputs ('Current active : '+itoa(num_active)) ;

    gotoxyimmediate (3,9) ;
    cputs ('Scanning number: ') ;

    gotoxyimmediate (3,10) ;
    cputs ('Current number : '+itoa(current_personal)) ;

END ;


(* This is what appears when you exit the program *)

PROCEDURE display_footer ;
BEGIN
    attributesOFF ;
    graphicsOFF ;
    WRITELN ;
    WRITELN ('VMS electronic personals written by Peter M Brown (The Psychlist).') ;
    WRITELN ('Based upon an original concept by George Cercone.') ;
    WRITELN ;
    bold(enhanced) ;
    WRITELN ('                   H a v e   a   n i c e   d a y !') ;
    bold(OFF) ;
    WRITELN ;
END ;


(* Use this procedure to highlight or unhighlight a particular menu option   *)
(* The BOOLEAN HIGHLIGHT controls whether or not to write the string in revs *)

PROCEDURE highlight_menu (
	menu_number : INTEGER ; 
	highlight : BOOLEAN) ;

BEGIN

    IF options.menu_kind <> 'arrow' THEN
	BEGIN
	    gotoxy (left_column + 1, top_row + menu_number) ;
	    reverse(highlight) ;
	    WRITELN(menu[menu_number]) ;
	    reverse(OFF) ;
	END
    ELSE
	BEGIN
	    gotoxy (left_column + 2, top_row + menu_number) ;

	    IF (highlight) THEN 
		BEGIN
		    bold(ON) ;
		    WRITELN ('->') ;
		    bold(OFF) ;
		    WRITELN ;
		END 
	    ELSE
		WRITELN ('  ') ;
	END ;

    gotoxy (1,1) ;
    WRITELN ;	    (* dump buffer *)
END ;


(* This procedure is called every second by the main menu.  It gets the    *)
(* current time from the system and displays it under the last menu option *)

PROCEDURE update_clock ;

VAR
    date    : string := '' ;	    (* current date (not used) *)
    time    : string := '' ;	    (* current time in HH:MM   *)
    timesig : string := '' ;	    (* AM, PM, Noon, Midnight  *)
    clock   : string ;		    (* The final string        *)

BEGIN
    dateandtime (date, time, timesig) ;
    clock := ' Sys time : [' + time + '] [' + timesig + '] ' ;

	(* center the clock string *)

    gotoxy (40 - (clock.length DIV 2), top_row + max_menus + 1) ;
    reverse (enhanced) ;
    WRITELN (clock) ;
    reverse (OFF) ;
    WRITELN ;	    (* dump buffer *)
END ;


(* This procedure is used to display the entire menu screen.  Usually used *)
(* In conjunction with DISPLAY_HEADER to refresh the main menu screen      *)

PROCEDURE display_menus ;

VAR
    k : INTEGER := 0 ;

BEGIN

	(* draw box around the menu options *)

    box (left_column,
	    top_row, 
	    menu[1].length + left_column + 1, 
	    max_menus + top_row + 1) ;


	(* write the menu options *)

    FOR k := 1 TO max_menus DO
	BEGIN
	    gotoxy (left_column + 1, top_row + k) ;
	    WRITELN(menu[k]) ;
	END ;


	(* display the clock under the last option *)

    update_clock ;

	(* highlight the current menu option *)

    highlight_menu (current_menu, TRUE) ;
    WRITELN ;
END ;



(* Use this to disable control y etc *)

[external]
FUNCTION lib$disable_ctrl (
	disable_mask : UNSIGNED ;
	VAR old_mask : [VOLATILE] UNSIGNED := %IMMED 0) : INTEGER; 
EXTERNAL;

(* use this to turn the control y and t back on *)

[external]
FUNCTION lib$enable_ctrl (
	enable_mask : UNSIGNED;
	VAR old_mask : [VOLATILE] UNSIGNED := %IMMED 0) : INTEGER; 
EXTERNAL;

(* Use this to delete a file without spawning a subprocess *)

[external]
FUNCTION lib$delete_file (
	filespec : [CLASS_S] PACKED ARRAY [$l1..$u1:INTEGER] OF CHAR) : INTEGER ;
external ;


(* This procedure lists the personals by number, date, time, number *)
(* of lines and whether or not you have read it.                    *)

PROCEDURE list_read_unread ;
VAR
    finished	: BOOLEAN := FALSE ;
    c		: key_code ;		(* used for page break       *)
    k		: INTEGER := 0 ;	(* local loop index variable *)
    screen_line : INTEGER := 0 ;	(* used for page breaks      *)


    PROCEDURE internal_show_header ;
    BEGIN
	clrscr ;

	bold(enhanced) ;
	WRITE ('Num':3) ;
        WRITE ('Author':20) ;
	WRITE ('To Whom':30) ;
	WRITE ('Lines':7) ;
	WRITE ('Date':9) ;
	WRITE ('Stat':8) ;
	bold(OFF) ;
	WRITELN ;
    END ;

BEGIN
    check_active_personals ;		(* get an accurate count *)
    read_init_file ;			(* check your PERSONAL.DAT file *)
					(* and update records           *)
    internal_show_header ;

    WHILE (k < num_active) AND (NOT(finished)) DO
	BEGIN
	    k := k + 1 ;
	    screen_line := screen_line + 1 ;
	    
	    IF ((personal[k].status = '1') OR
	        (personal[k].status = 'read')) THEN
		personal[k].status := 'read'
	    ELSE
		personal[k].status := 'unread' ;

	    WRITE (k:3) ;

		(* if you are the author, put author in bold *)

	    bold(INDEX(personal[k].author, options.personal_name) > 0 ) ; 
	    WRITE ('  ',personal[k].author:19) ;

		(* If you are the reciepient, put name in bold *)

	    bold(INDEX(personal[k].to_whom, options.personal_name) > 0 ) ; 
	    WRITE ('  ',personal[k].to_whom:28) ;

	    bold(OFF) ;
	    WRITE ('  ',personal[k].num_lines:3) ;
	    WRITE ('  ',personal[k].date_string:10) ;

	    bold (personal[k].status = 'unread') ;
	    WRITE ('  ',personal[k].status) ;
	    bold(OFF) ;
	    WRITELN ;

		(* force a page break *)

	    IF (screen_line MOD 21 = 0) OR
		(k >= num_active) THEN
		BEGIN
		    reverse(enhanced) ;
		    WRITELN ('  | <m>enu | <q>uit | e<x>it | any other key to continue |  ') ;
		    reverse(OFF) ;
		    c := getch ;

		    CASE c OF
			K_LOW_M,
			K_UP_M	:   finished := TRUE ;

			K_UP_Q,
			K_LOW_Q,
			K_LOW_X,
			K_UP_X  :   BEGIN
					finished := TRUE ;
					done := TRUE ;
				    END ;

		    END ; (* case *)

		    IF NOT(finished) THEN
			internal_show_header ;
		END ;
	END ;

    IF NOT(done) THEN
	BEGIN
	    display_header ;
	    display_menus ;
	END ;

    update_datfile ;

END ;


(* Use this procedure to extract a personal and save it in your account *)

PROCEDURE extract_personal(
	personal_number : INTEGER  ;	    (* The personal to extract *)
        filename : string := '') ;

VAR
    dumpfileid	: TEXT ;	(* the VMS file id of 'filename'      *)
    persfileid  : TEXT ;	(* the VMS file id of the personals   *)
    k,i		: INTEGER ;	(* local loop index variables         *)
    text_line	: string ;	(* a single line of the per.dat file  *)
    date	: string ;	(* Today's date                       *)
    time	: string ;	(* Time right now HH:MM               *)
    timesig	: string ;	(* time sig. AM, PM, Noon, Midnight   *)


BEGIN
    gotoxy (1,21) ;	(* nuke the menu bar *)
    clreos ;

    draw_line ;

    IF (filename = '') THEN
	BEGIN
	    WRITE ('Save this personal as ?  [',
		'ARTICLE_',itoa(personal_number),'.TXT','] > ') ;
	    READLN (filename) ;

	    stripleadingblanks (filename) ;
	    striptrailingblanks (filename) ;

		(* did they just hit return ? *)

	    IF (filename = '') THEN
		filename := ('ARTICLE_'+ itoa(personal_number) + '.TXT') ;

		(* did they specify an extension ? *)

	    IF INDEX (filename, '.') < 1 THEN
		filename := filename + '.DAT' ;

		(* did they specify a directory ? *)

	    IF INDEX (filename, ']') < 1 THEN
		filename := options.extract_directory + filename ;

    	END ;


    OPEN (persfileid, options.temp_dir+ 'PER2.DAT', HISTORY := OLD, 
				SHARING := READWRITE, ERROR := CONTINUE) ;

    RESET (persfileid, ERROR := CONTINUE ) ;  

    k := 0 ;

    WHILE (k < (personal_number - 1)) DO
	BEGIN
	    k := k + 1 ;
	    READLN (persfileid, text_line ) ;	(* num_lines    *)
	    READLN (persfileid, text_line ) ;	(* date written *)
	    READLN (persfileid, text_line ) ;	(* time_written *)

	    FOR i := 1 TO personal[k].num_lines DO
		READLN(persfileid, text_line) ;
	END ;

    k := 0 ;

    dateandtime (date, time, timesig) ;

    OPEN (dumpfileid, filename, HISTORY := NEW , ERROR := CONTINUE) ;
    REWRITE (dumpfileid) ;

    WRITELN (dumpfileid) ;
    WRITELN (dumpfileid) ;

    FOR k := 1 TO (personal[personal_number].num_lines + 3) DO
	BEGIN
	    READLN (persfileid, text_line) ;
	    IF k = 1 THEN	    (* dont write the number of lines *)
	    ELSE IF k = 2 THEN
		WRITE (dumpfileid, text_line,'   -   ')	(* put date and time *) 
	    ELSE IF k = 3 THEN				(* on same line      *)
		WRITELN (dumpfileid, text_line) 
	    ELSE
		WRITELN (dumpfileid, text_line) ;
	END ;
    
    WRITELN (dumpfileid) ;

    CLOSE (dumpfileid) ;
    CLOSE (persfileid) ;

END ;


PROCEDURE append_sigfile ;

VAR
    sig_id  : TEXT ;
    dest_id : TEXT ;

BEGIN
    IF (options.sigfile <> '') THEN
	BEGIN
	    IF (valid_file (options.sigfile)) AND
		NOT (valid_file (options.temp_dir + 'PER_PER.DAT')) THEN
		BEGIN
		    WRITELN ('COPYING sigfile.') ;
		    lib$spawn ('copy '+options.sigfile+' '+options.temp_dir+
			    'PER_PER.DAT')
		END 

	    ELSE IF (valid_file (options.sigfile)) AND 
		    (valid_file (options.temp_dir + 'PER_PER.DAT')) THEN
		BEGIN
		    beep ;
		    beep ;
		    WRITELN ('APPENDING sigfile.') ;
		    lib$spawn ('APPEND '+options.sigfile+' '+
				    options.temp_dir+'PER_PER.DAT') ;
		END 
	    ELSE
		BEGIN
		    beep ;
		    reverse(enhanced) ;
		    WRITELN (' Error Reading signature file: ') ;
		    WRITELN (' -> '+options.sigfile) ;
		    reverse(OFF) ;
		    WRITELN ;
		    beep ;
		END ;
	END
    ELSE
	WRITELN ('You have no sigfile...') ;
END ;

(* Returns the length (in lines) of FILENAME *)

FUNCTION file_length (filename : string) : INTEGER ;

VAR
    len		: INTEGER := 0 ;
    the_fileid	: TEXT ;
    text_line	: string ;

BEGIN
    OPEN (the_fileid, filename, HISTORY := OLD, ERROR := CONTINUE) ;
    RESET (the_fileid, ERROR := CONTINUE ) ;
    WHILE NOT(EOF(the_fileid)) DO
	BEGIN
	    READLN(the_fileid, text_line) ;
	    len := len + 1 ;
	END ;
    CLOSE (the_fileid) ;

    file_length := len ;

END ;



PROCEDURE write_personal(
	followup : BOOLEAN := FALSE ;	(* called by followup procedure ? *)
	author	: string := '' ) ;	(* parameter passed by followup   *)

CONST
    default_subject = 'Stuff in general' ;

VAR
    default_to_line : string := '' ;
    date	    : string := '' ;
    time	    : string := '' ;
    timesig	    : string := '' ;
    fileid	    : TEXT ;
    valid	    : BOOLEAN := TRUE ;
    from_person	    : string ;
    to_person	    : string ;
    subject	    : string ; 
    header_lines    : INTEGER := 1 ;    (* number of lines in the header *)

BEGIN
    default_to_line := options.default_to ;

    stripleadingblanks (default_to_line) ;
    striptrailingblanks (default_to_line) ;

    IF (default_to_line = '') THEN
	default_to_line := 'All interested parties.' ;

    IF (author <> '') THEN
	default_to_line := author ;

    IF (author = options.personal_name) THEN
	default_to_line := 'Myself' ;

    IF (num_active < max_personals) THEN
	BEGIN
	    header_lines := 1 ; (* one blank line *)

	    clrscr ;

	    WRITELN ;
	    WRITELN ('Personal name to be displayed.') ;
	    WRITE ('default = [',options.personal_name,'] > ') ;
	    READLN (from_person) ;
	    header_lines:= header_lines + 1 ;

	    WRITELN ;
	    WRITELN ;
	    WRITELN ('Hit return to send this personal to "',default_to_line,',"') ;
	    WRITELN ('or type the name of the person or people that this personal is meant for.') ;
	    WRITELN ;
	    WRITE ('Who is this to : ') ;
	    READLN (to_person) ;
	    header_lines:= header_lines + 1 ;

	 {   WRITELN ;
	    WRITELN ('Enter the subject, or hit return to set the subject to:') ; 
	    WRITELN ('"',default_subject,'"') ;
	    WRITE ('What is the subject : ') ;
	    READLN (subject) ;
	    header_lines := header_lines + 1 ;       }

	    WRITELN ;
	    WRITELN ('Thank you.') ;   
	    WRITELN ;


		(* update the list of users *)

{ uncomment the next line if you want to keep track of who writes what }
{	    lib$spawn ('@'+log_comfile+' unknown ') ;                  }

	    stripleadingblanks (from_person) ;
	    stripleadingblanks (to_person) ;
	    stripleadingblanks (subject) ;

	    IF (from_person = '') THEN
		from_person := options.personal_name ;

	    IF (to_person = '') THEN
		to_person := default_to_line ;

	    IF (subject = '') THEN
		subject := default_subject ;

	    dateandtime (date, time, timesig) ;

	    IF (NOT(followup)) THEN
		append_sigfile ;

	    lib$spawn (options.editor_call+' '+options.temp_dir+'PER_PER.DAT') ;    

	    valid := valid_file(options.temp_dir+'PER_PER.DAT') ; 

	    IF (valid) THEN
		BEGIN
		    OPEN (fileid, options.temp_dir+'PER_DATA.DAT', HISTORY := NEW) ;
		    REWRITE (fileid) ;
		    WRITELN (fileid, (file_length(options.temp_dir+'PER_PER.DAT')+
					    header_lines):3) ;
		    WRITELN (fileid, date) ;
		    WRITELN (fileid, time, ' ', timesig) ;
		    WRITELN (fileid,'From the mind of  :  ',from_person) ;
		    WRITELN (fileid,'Directed towards  :  ',to_person) ;
{		    WRITELN (fileid,'In regards to     :  ',subject) ; }
		    WRITELN (fileid) ;
		    CLOSE (fileid) ;

		    WRITELN ('Appending to the Master File.') ;

		    lib$spawn ('APPEND '+options.temp_dir+'PER_PER.DAT '+options.temp_dir+'PER_DATA.DAT') ;
		    lib$spawn ('APPEND '+options.temp_dir+'PER_DATA.DAT '+pers_datfile) ;

		    WRITELN ('deleting PER_PER.DAT') ;
		    lib$delete_file (options.temp_dir+'PER_PER.DAT;*') ;

		    WRITELN ('deleting PER_DATA.DAT') ;
		    lib$delete_file (options.temp_dir+'PER_DATA.DAT;*') ;

		    num_active := num_active + 1 ;

		END
	    ELSE
		WRITELN('File is empty, posting aborted.') ;

	    IF NOT(followup) THEN
		BEGIN
		    display_header ;
		    display_menus ;
		END ;
	END
    ELSE
	BEGIN
	    beep ;
	    gotoxy (1,22) ;
	    WRITELN('There are already ',max_personals:0,' personals. There is no more room!') ;
	END ;
END ;


(* This is used to post a reply to a personal *)

PROCEDURE followup_to(
	pers_num : INTEGER ) ;

VAR
    filename	: string ;
    source_id	: TEXT ;
    dest_id	: TEXT ;
    text_line	: string ;


BEGIN
    gotoxy (1,23) ;
    WRITELN ('One moment please...') ;

    filename := options.temp_dir + 'FOLLOWUP.DAT' ;

    extract_personal (pers_num, filename) ;
    
    OPEN (source_id, filename, HISTORY := OLD, ERROR := CONTINUE) ;
    RESET (source_id) ;

    OPEN (dest_id, options.temp_dir+'PER_PER.DAT', HISTORY := NEW, ERROR := CONTINUE) ;
    REWRITE (dest_id) ;

    WRITELN (dest_id) ;
    WRITELN (dest_id, 'Followup to posting # ', pers_num:0,', by : ',
		personal[pers_num].author) ;

    WRITELN (dest_id) ;

    WHILE (NOT(EOF(source_id))) DO
	BEGIN
	    READLN (source_id, text_line) ;
	    text_line := '>'+text_line ;
	    WRITELN (dest_id, text_line) ;
	    WRITELN (text_line) ;
	END ;

    CLOSE (dest_id) ;
    CLOSE (source_id) ;

    append_sigfile ;

    write_personal (TRUE, personal[pers_num].author) ;

    lib$delete_file (filename) ;

END ;


(* This procedure is the core of the entire program *)
(* The BOOLEAN READ_ONLY_NEW is TRUE when the user selects NEW from the *)
(* Main menu.  IT is FALSE when the select JUMP or READ ALL             *)


PROCEDURE read_personals(
	read_only_new	: BOOLEAN ;
	start_position	: INTEGER := 0 ) ;

CONST
    prompt_bar = '  |<e>xtract |<f>ollowup |<j>ump |<m>enu |<u>nread |e<x>it |<return> page |  ' ;

VAR
    ask_prompt	: BOOLEAN := TRUE ;	    (* FALSE if skipping this pers.  *)
    counter	: INTEGER ;		    (* used by skip algorithm        *)
    pers_fileid : TEXT ;		    (* VMS fileid of the datfile     *)
    pers_num	: INTEGER := 0 ;	    (* The personal being read       *)
    text_line	: string ;		    (* a single line read in PER.DAT *)
    k		: INTEGER ;		    (* local loop index counter      *)
    first_line  : BOOLEAN := TRUE ;	    (* True if on first page of pers *)
    line_num	: INTEGER := 0 ;	    (* used for page breaks only     *)
    finished	: BOOLEAN := FALSE ;	    (* done reading ?                *)
    percent_read: INTEGER := 1 ;	    (* how much of current pers read *)
    option	: string ;		    (* option selected by user       *)
    skip	: BOOLEAN ;		    (* used by UNREAD                *)
    previous_active : INTEGER := 0 ;	    (* number active before read new *)
    lines_read  : INTEGER := 0 ;	    (* Number of lines you've read   *)


    (* Procedures local to read_personals *)

    PROCEDURE internal_jump_to (
	VAR start_position : INTEGER ) ;
    VAR
	s : string ;

    BEGIN
	gotoxy(1,22) ;
	clreos ;
	gotoxy (1,22) ;

	WRITE ('Jump to which personal [',(pers_num+2):0,'..',num_active:0,'] > ') ;
	READLN(s) ;
	start_position := atoi(s) ;
	IF ((start_position < pers_num+2) OR
	    (start_position > num_active)) THEN
	    BEGIN
		beep ;
		start_position := pers_num ;
		current_personal := pers_num ;
	    END ;
    END ;



    PROCEDURE get_option ;
    VAR
	key : key_code ;

    BEGIN
	gotoxy (1,3) ;
	WRITELN ;	(* dump buffer *)

	key := getch ;

	option := CHR(key) ;

	    CASE key OF
	        K_UP_U,
		K_LOW_U:BEGIN 
			    personal[pers_num].status := 'unread' ;
			    skip := TRUE ;
			END ;

		K_UP_M,
		K_LOW_M: finished := TRUE ;

		K_UP_Q,
		K_LOW_Q,
		CTRL_Z,
		K_UP_X,
		K_LOW_X :BEGIN
			    finished := TRUE ;
			    done     := TRUE ;
			 END ;

		K_UP_E,
		K_LOW_E:    BEGIN
				extract_personal (pers_num) ;
			    END ;
		K_UP_J,
		K_LOW_J:    BEGIN
				internal_jump_to (start_position) ;
			    END ;
		K_UP_N,
		K_LOW_N:    BEGIN
				FOR k := lines_read + 1 TO 
				    personal[pers_num].num_lines DO
				    READLN (pers_fileid,text_line) ;

				lines_read := k ;

			    END ;
		K_LOW_F,
		K_UP_F:	    BEGIN
				followup_to (pers_num) ;
			    END ;

		K_RETURN : ;

	    OTHERWISE beep ;
	    END ;	(* case *)


	WRITELN ;	(* dump buffer *)
	gotoxy (1,3) ;
	clreos ;
	gotoxy (1,23) ;
	reverse(enhanced) ;
	WRITELN (prompt_bar) ;
	reverse(OFF) ;
	gotoxy (1,3) ;

    END ;

BEGIN
    gotoxy (40 - (LENGTH ('One moment please . . . ') DIV 2) ,23) ;
    blink(enhanced) ;
    WRITELN('One moment please . . . ') ;
    blink(OFF) ;
    gotoxy (1,22) ;
    WRITELN ;

	(* get an accurate count *)

    previous_active := num_active ;
    check_active_personals ;

	(* This my require some explaining: *)
	(* What I do is copy the current PER.DAT file from the    *)
	(* personal directory, and put it in your SYS$LOGIN. That *)
	(* way, you aren't deadlocking the file.  That is, when   *)
	(* someone else goes to append to the PER.DAT file, or    *)
	(* read from it, you wont have it locked.                 *)

    IF (valid_file (options.temp_dir+'PER.DAT')) THEN
	lib$delete_file ('SYS$LOGIN:PER.DAT;*') ;

{    IF (previous_active < num_active) OR (first_reading)  THEN }
	lib$spawn ('copy '+pers_datfile+' '+ options.temp_dir +'PER.DAT') ;

	(* This one, PER2.DAT is used by EXTRACT.  This way, there *)
	(* aren't any deadlocks when you try and RE-OPEN this file *)
	(* to extract while you are reading the file.  If you omit *)
	(* This, you will get a RECORD LOCKED BY ANOTHER STREAM    *)
	(* error.  That "other stream" is YOU, reading the E_page. *)

    IF (valid_file (options.temp_dir+'PER2.DAT')) THEN
	lib$delete_file ('SYS$LOGIN:PER2.DAT;*') ;

 {   IF (previous_active < num_active) OR (first_reading) THEN  }
	lib$spawn ('copy '+pers_datfile+' '+ options.temp_dir +'PER2.DAT') ;


    OPEN (pers_fileid, options.temp_dir+'PER.DAT', HISTORY := OLD, 
			    SHARING := READWRITE, ERROR := CONTINUE) ;

    RESET (pers_fileid, ERROR := CONTINUE ) ;
    UNLOCK (pers_fileid, ERROR := CONTINUE ) ;

    first_reading := FALSE ;

    WHILE (NOT(EOF(pers_fileid))) AND (NOT(finished)) DO
	BEGIN
	    skip	:= FALSE ;		(* use in UNREAD         *)
	    pers_num	:= pers_num + 1 ;	(* next personal in file *)
	    current_personal := pers_num ;	(* current personal      *)
	    line_num	:= 0 ;			(* reset line number     *)
	    lines_read  := 0 ;			(* numbner of lines read *)
	    first_line	:= TRUE ;		(* first time viewing    *)
	    k		:= 0 ;			(* loop index varible    *)

	    READLN(pers_fileid, personal[pers_num].num_lines) ;
	    READLN(pers_fileid, personal[pers_num].date_string) ;
	    READLN(pers_fileid, personal[pers_num].time_string) ;

	    IF (((personal[pers_num].status = 'unread') AND 
		(read_only_new)) OR

		((NOT(read_only_new)) AND
		(start_position = 0)) OR

		((start_position > 0) AND 
{		(NOT(read_only_new)) AND   }
		(pers_num >= start_position ))) AND

{		(lines_read <= personal[pers_num].num_lines) THEN }
		(lines_read < personal[pers_num].num_lines) THEN 

	    WHILE ((k < personal[pers_num].num_lines) AND (NOT(finished))) DO
		BEGIN
		    k := k + 1 ;
		    READLN(pers_fileid,text_line) ;
		    line_num := line_num + 1 ;
		    lines_read := lines_read + 1 ;

		    IF (first_line) THEN
			BEGIN
			    graphicsOFF ;
			    first_line := FALSE ;
			    clrscr ;
			    gotoxy (1,1) ;
			    WRITE ('  Personal : ') ;
			    bold(enhanced) ;
			    WRITE (pers_num:0,'/',num_active:0) ;
			    bold(off) ;
			    WRITE ('  Lines : ') ;
			    bold(enhanced) ;
			    WRITE (personal[pers_num].num_lines:0) ;
			    bold(off) ;
			    WRITE ('  Date and time written : ') ;
			    bold(enhanced) ;
			    WRITE (personal[pers_num].date_string) ;
			    WRITE (' ') ;
			    WRITE (personal[pers_num].time_string) ;
			    bold(off) ;
			    WRITELN ;	(* dump buffer *)
			    gotoxy(1,2) ;
			    draw_line ;
			    WRITELN ;	(* dump buffer *)
			    gotoxy (1,23) ;
			    reverse(enhanced) ;
			    WRITELN(prompt_bar) ;
			    reverse(OFF) ;
			    gotoxy(1,3) ;

			{    IF NOT(skip) THEN
				personal[pers_num].status := 'read' ; }

			END	(* if firstline then *)

		    ELSE IF ((line_num MOD 19) = 0) THEN
			BEGIN
			{    IF NOT(skip) THEN
				personal[pers_num].status := 'read' ;  }
			    line_num := 1 ;
			    gotoxy (1,21) ;
			    percent_read := ROUND(((k) /
				(personal[pers_num].num_lines )) * 100) ;

			    draw_line ;

			    bold(enhanced) ;
			    WRITE (' ',percent_read:0,'% read, select an option.') ;
			    bold(OFF) ;
			    get_option ;

			END ;	(* if line_num mod 19 *)


		    WRITELN (text_line) ;	(* write the line ! *)

		    ask_prompt := TRUE ;	(* reset ask_prompt *)

		END

			    (* Skip this personal *)

	    ELSE IF (((read_only_new) AND 
		    (personal[pers_num].status = 'read')) OR
		    (start_position > 0))  THEN
		    BEGIN
			FOR counter := 1 TO personal[pers_num].num_lines DO
			    BEGIN
				READLN(pers_fileid, text_line) ;
			    END ;
			ask_prompt := FALSE ;
			gotoxyimmediate (18,9) ;
			cputs(': '+itoa(pers_num)) ;
			graphicsOFF ;
			gotoxy(1,1) ;
			WRITELN ;
		    END ;

	    IF (NOT(skip)) AND (start_position = 0)  THEN
		personal[pers_num].status := 'read' ;

	    IF (ask_prompt) AND (NOT(finished)) AND (NOT(done)) THEN
		BEGIN
		    graphicsOFF ;
		    gotoxy (1,21) ;
		    draw_line ;
		    bold(enhanced) ;
		    WRITE (' 100% read, select an option. ') ;
		    bold(OFF) ;
		    get_option ;
		END ;
	
	    IF NOT(skip) THEN
		personal[pers_num].status := 'read' ;

	END ;
    CLOSE (pers_fileid) ;

    update_datfile ;

    IF NOT(done) THEN
	BEGIN
	    display_header ;
	    display_menus ;
	END ;
END ;


PROCEDURE set_user_level ;

VAR
    userid : string := '' ;

    FUNCTION get_userid : string ;
    BEGIN
	get_userid := '' ;
    END ;

BEGIN

    (* Values of Userlevel  *)
    (* -------------------- *)
    (* 0   Normal user      *)
    (* 1   Misc maintenance *)
    (* 2   See real userids *)
    (* 3   Edit master file *)
    (* 4   Reset Personals  *)
    
    userid := get_userid ;

    IF userid = 'cerconeg' THEN
	user_level := 10 

    ELSE IF userid = 'brownp' THEN
	user_level := 1 

    ELSE
	user_level := 0 ;

END ;


(* This procedure should take care of any variable initializations *)
(* and file initializations.                                       *)

PROCEDURE initialize ;

VAR
    x : INTEGER := 1 ;

BEGIN

    set_user_level ;

    current_personal := 1 ;
    current_menu := 1 ;

    WRITELN('VAX/VMS Electronic personals By Peter M Brown (The Psychlist)') ;
    WRITELN ;
    bold(ON) ;
    WRITELN ('Use CONTROL-B to report bugs.') ;
    WRITELN ;
    bold(OFF) ;
    WRITELN ;
    WRITELN ('Please wait...') ;
    WRITELN ;
    WRITELN ('Initializing menu options.') ;

    menu[1]  := '   (r)  read all personals      ' ;
    menu[2]  := '   (w)  write a personal        ' ;
    menu[3]  := '   (n)  read new personals      ' ;
    menu[4]  := '   (e)  exit from personals     ' ;
    menu[5]  := '   (c)  catch up (set all read) ' ;
    menu[6]  := '   (p)  $ phone                 ' ;
    menu[7]  := '   (m)  $ mail                  ' ;
    menu[8]  := '   (u)  $ show users/full       ' ;
    menu[9]  := '   (s)  statistics/utilities    ' ;
    menu[10] := '   (l)  list all personals      ' ;
    menu[11] := '   (j)  jump to a personal      ' ;
    menu[12] := '   (a)  archives                ' ;
    menu[13] := '   ($)  Spawn to DCL            ' ;

    left_column := (40 - (LENGTH (menu[1] + '||') DIV 2 ));

    WRITELN ('Initializing database of personals.') ;

    FOR x := 1 TO max_personals DO
	BEGIN
	    personal[x].status := 'unread' ;
	    personal[x].num_lines := 0 ;
	    personal[x].date_string := 'non-exist' ;
	    personal[x].time_string := 'non-exist' ;
	    personal[x].author := 'Unknown' ;
	    personal[x].to_whom := 'Unknown' ;
	END ;

    WRITELN('Reading PERSONAL.DAT file.') ;

    read_init_file ;

    WRITELN ('Reading list of active personals.') ;

    check_active_personals ;	(* get an accurate count of personals    *)
    WRITELN (num_active:0,' personals active.') ;

    WRITELN('Updating PERSONAL.DAT file.') ;

    update_datfile ;

    WRITELN ('Checking for PERSRC.DAT file.') ;

    options.extract_directory := 'SYS$LOGIN:' ;
    options.personal_name := '' ;
    options.enhanced := 'TRUE' ;
    options.sigfile := '' ;
    options.temp_dir := 'SYS$LOGIN:' ;
    options.menu_kind := 'HIGHLIGHT' ;
    options.default_to := 'All interested parties.' ;
    options.editor_call := 'EDIT/CREATE' ;
    options.dcl_prompt := '$_DCL> ' ;

    read_persrc_file ;

    enhanced := (strlwr(options.enhanced) <> 'false') ;

    IF NOT(enhanced) THEN
	BEGIN
	    WRITELN ;
	    WRITELN ('You are running in NOGRAPHICS mode...') ;
	    WRITELN ;
	    WRITELN ;
	    options.menu_kind := 'arrow' ;
	END ;

    update_persrc_version ;
END ;


(* This procedure will mark all personals as read *)

PROCEDURE catch_up ;

VAR
    k : INTEGER ;

BEGIN
    check_active_personals ;

    FOR k := 1 TO num_active DO
	personal[k].status := 'read' ;

    update_datfile ;

    gotoxy (10,18) ;
    read_init_file ;
    WRITELN ('All caught-up.') ;
END ;

PROCEDURE spawn_to_dcl ;
VAR
    command : string := '  ' ;

BEGIN
    clrscr ;
    bold(enhanced) ;
    WRITELN ('Spawned to the operating system.') ;
    WRITELN ('Use "EXIT" to return to the E-Personals.') ;
    bold(OFF) ;
    WRITELN ;
    WRITELN ;

    options.dcl_prompt := options.dcl_prompt + ' ' ;

    WHILE (strlwr(command) <> 'exit') DO
	BEGIN
	    WRITE (options.dcl_prompt) ;
	    READLN (command) ;
	    lib$spawn (command) ;
	    WRITELN ;
	END ;

    display_header ;
    display_menus ;

END ;


PROCEDURE use_phone ;
BEGIN
    clrscr ;
    WRITELN ;
    lib$spawn ('phone') ;
    display_header ;
    display_menus ;
END ;


PROCEDURE check_mail ;
BEGIN
    clrscr ;
    WRITELN ;
    lib$spawn ('mail') ;
    display_header ;
    display_menus ;
END ;


PROCEDURE show_users ;
BEGIN
    clrscr ;
    WRITELN ;
    lib$spawn ('@science$disk:[brownp.public]_who2.com') ;
    WRITE ('Hit return...') ;
    READLN ;
    display_header ;
    display_menus ;
END ;


PROCEDURE show_stats ;

VAR
    k		  : INTEGER := 0 ;
    total_lines   : INTEGER := 0 ;
    number_read   : INTEGER := 0 ;
    average_lines : INTEGER := 0 ;
    master_size	  : INTEGER := 0 ;

BEGIN
    FOR k := 1 TO num_active DO
	BEGIN
	    total_lines := total_lines + personal[k].num_lines ;
	    IF personal[k].status = 'read' THEN
		number_read := number_read + 1 ;
	END ;

    master_size := total_lines + 3 * num_active ;

    average_lines := (total_lines DIV num_active) ;

    WRITELN ;
    WRITELN ;
    bold(enhanced) ;
    WRITELN ('Statistics ') ;
    bold(OFF) ;
    WRITELN ;
    WRITELN ('  -  Number of active personals  : ',num_active:0) ;
    WRITELN ('  -  Size of Master file (lines) : ',master_size:0) ;
    WRITELN ('  -  Total personal lines        : ',total_lines:0) ;
    WRITELN ('  -  Average number of lines     : ',average_lines:0) ;
    WRITELN ('  -  Date of first personal      : ',personal[1].date_string) ;
    IF personal[2].date_string <> 'non-exist' THEN
	WRITELN ('  -  Date of second personal     : ',personal[2].date_string) ;
    WRITELN ('  -  Date of last personal       : ',personal[num_active].date_string) ;
    WRITELN ('  -  Number of personals read    : ',number_read:0) ;
    WRITELN ;

END ;


PROCEDURE edit_masterfile ;
VAR
    password : string ;

BEGIN
    WRITELN ('Authorization password : ') ;
    echo(OFF) ;
    READLN (password) ;
    echo(ON) ;
    stripleadingblanks (password) ;
    striptrailingblanks (password) ;
    password := strlwr (password) ;
 
    IF password <> edit_password THEN
	beep 
    ELSE
	lib$spawn (options.editor_call+' '+pers_datfile) ;
END ;


PROCEDURE reset_personals ;
VAR
    password : string ;

BEGIN
    WRITELN ('Authorization password : ') ;
    echo(OFF) ;
    READLN (password) ;
    echo(ON) ;

    stripleadingblanks (password) ;
    striptrailingblanks (password) ;
    password := strlwr (password) ;
 
    IF password <> reset_password THEN
	beep
    ELSE
	BEGIN
	    WRITELN ('Sorry, this is not implemented yet.') ;
	END ;
END ;


(* This procedure is used by the manager of the perosnals. *)

PROCEDURE system_manager ;

CONST
    prompt_bar = '  | <s>tatistics | <r>eset personals | <e>dit master file | <m>ain menu |  ' ;

VAR
    c : key_code ;
    done_system : BOOLEAN := FALSE ;
    valid_key : BOOLEAN := TRUE ;

BEGIN
    REPEAT 
	clrscr ;

	WRITELN ('         Personals Management Menu. Note: Not all options are for you.') ; 
	draw_line ;
	WRITE ('  ') ;
	reverse(enhanced) ;
	WRITELN (prompt_bar) ;
	reverse(OFF) ;
	draw_line ;
	gotoxy (1,6) ;

	valid_key := TRUE ;

	c := getch ;
    
	CASE c OF
	    K_UP_X,
	    K_LOW_X,
	    K_UP_M,
	    K_LOW_M,
	    K_UP_Q,
	    K_LOW_Q : done_system := TRUE ;

	    K_UP_E,
	    K_LOW_E : edit_masterfile ;

	    K_UP_S,
	    K_LOW_S : show_stats ;

	    K_UP_R,
	    K_LOW_R : reset_personals ;

	OTHERWISE BEGIN
		    beep ;
		    valid_key:= FALSE ;
		  END ;

	END ; (* case *)

	IF ((valid_key) AND (NOT(done_system))) THEN
	    BEGIN
		WRITELN ;
		gotoxy (1,23) ;
		reverse(enhanced) ;
		WRITELN (' Hit any key to continue ') ;
		c := getch ;
		reverse(OFF) ;
	    END ;

    UNTIL (done_system) ;



    display_header ;
    display_menus ;

END ;

PROCEDURE jump_to ;

VAR
    start_position : string ;

BEGIN
    gotoxy (1,22) ;
    WRITE ('Start reading at personal number (1..',num_active:0,') > ') ;
    READLN (start_position) ; 
    IF (atoi(start_position) <= 1) THEN			(* too low  *)
	read_personals (FALSE) 
    ELSE IF (atoi(start_position) <= num_active) THEN	(* in range *)
	read_personals (FALSE, atoi(start_position)) 
    ELSE
	BEGIN						(* too high *)
	    beep ;
	    display_header ;
	    display_menus ;
	END ;
END ;


PROCEDURE display_help ;
BEGIN
    clrscr ;

    WRITELN ;
    WRITELN('VAX/VMS electronic personals developed by Peter M Brown and') ;
    WRITELN('George Cercone, UMass-Lowell December 1991.') ;

    WRITELN ;

    WRITELN('To select an item from the menu, you can do one of two things:') ;
    WRITELN ;
    bold(enhanced) ; WRITE('    o    ') ; bold(OFF) ;
    WRITELN('Use the cursor keys to highlight a menu option') ;
    WRITELN('         then press <RETURN> to select the highlighted option.') ;
    WRITELN ;
    bold(enhanced) ; WRITE('    o    ') ; bold(OFF) ;
    WRITELN('Press the letter in the () next to the option you want.') ;
    WRITELN ;
    WRITELN('To refresh the screen, hit CTRL-W.  This is useful if someone blasts') ;
    WRITELN('you or you get mail.') ;
    WRITELN ;
    WRITELN('NOTE: The program may bomb if there are two people attempting to') ;
    WRITELN('      append to the master personal file at the same time.') ;
    WRITELN('      This bug is currently being worked on.  Please bear with us.') ;
    WRITELN ;
    bold(enhanced) ;
    WRITELN('IMPORTANT: To report any bugs in the program hit CTRL-B, and send ') ;
    WRITELN('	   us the nature of the bug and any error messages you got.') ;
    WRITELN('      This can also be used to notify us of any enhancements you would') ;
    WRITELN('      like to see in this program.') ;
    bold(OFF) ;
    WRITELN ;


    reverse(enhanced) ;
    WRITE (' Press return to continue ') ;
    reverse(OFF) ;
    READLN ;
    WRITELN ;
    clrscr ;
    WRITELN ('Summary of main menu options: ') ;
    WRITELN ;
    WRITELN ('  (r)  Starting reading all personals from first on.');
    WRITELN ('  (w)  Write a new personal.');
    WRITELN ('  (n)  Start reading at first unread personal.');
    WRITELN ('  (e)  Exit the E-Page (can also use Q or CTRL-Z) ');
    WRITELN ('  (c)  Mark all personals as read.');
    WRITELN ('  (p)  Spawn out to the VAX phone utility. EXIT to return.');
    WRITELN ('  (m)  Spawn out to the VAX mail utiltiy. EXIT to return.');
    WRITELN ('  (u)  List all users on teh system (with page breaks!) ');
    WRITELN ('  (s)  Get information about this program and its usage.');
    WRITELN ('  (l)  List all personals by: lines, author, date, to whom and read/unread');
    WRITELN ('  (j)  Jump to a personal (REALLY BUGGY!!!) ');
    WRITELN ('  (a)  Read personals from previous weeks.');

    WRITELN ;
    WRITELN ;

    reverse(enhanced) ;
    WRITE (' Press return to continue ') ;
    reverse(OFF) ;
    READLN ;
    WRITELN ;

    clrscr ;

    WRITELN ;
    WRITELN ('Options available while reading a personal.') ;
    WRITELN ;
    WRITELN ('  (e)  Extract the current personal and save it to your account.') ;
    WRITELN ('  (f)  Followup to the current personal.') ;
    WRITELN ('  (j)  Jump to a personal. (REALLY BUGGY!) ') ;
    WRITELN ('  (m)  Go back to the main menu.') ;
    WRITELN ('  (n)  Jump to next personal (Not really working properly) ') ;
    WRITELN ('  (u)  Mark this personal as UNREAD.') ;
    WRITELN ('  (x)  Exit back to the operating system.') ;
    WRITELN (' (ret) Read next page.') ;
    WRITELN ;

    reverse(enhanced) ;
    WRITE (' Press return to continue ') ;
    reverse(OFF) ;
    READLN ;
    WRITELN ;

    display_header ;
    display_menus ;
END ;

PROCEDURE refresh_screen ;
BEGIN
    clrscr;
    graphicsOFF ;
    bold(OFF) ;
    attributesOFF ;
    WRITELN ;
    clrscr ;

    display_header ;
    display_menus ;
END ;



PROCEDURE notify_of_bugs ;
VAR
    filename : string ;

BEGIN
    filename := options.temp_dir + 'PER_BUGS.DAT' ;    

    lib$spawn (options.editor_call+' '+ filename) ;

    WRITELN (filename) ;

    IF valid_file(filename) THEN 
	BEGIN
	    lib$spawn ('mail '+filename + ' ' + adm1 + '/subj = "Bugs in personals"') ;
	    lib$spawn ('mail '+filename + ' ' + adm2 + '/subj = "Bugs in personals"') ;

	    lib$delete_file (filename + ';*') ;
	END 
    ELSE
	WRITELN('File is empty...aborted') ;

    display_header ;
    display_menus ;

END ;

(* The archive procedure should do the following :             *)
(*                                                             *)
(*  o  allow a user to change thier current PER.DAT to the     *)
(*     archived file.                                          *)
(*                                                             *)
(*  o  allow the user to read the UNCOMPRESSED archives as     *)
(*     though they were the current ones.                      *)
(*                                                             *)
(*  o  Lastly, it must reload the OLD personal.dat file so     *)
(*     number of active personals will be reset to the CURRENT *)
(*     PER.DAT file                                            *)
(*                                                             *)

PROCEDURE archives ;
BEGIN
    clrscr ;
    WRITELN ;

	(* temporary way of doing this *)

    lib$spawn ('@'+ arc_comfile) ;

	(* The last three lines of this should be :      *)
	(* read_init_file, display_header, display_menus *)

    read_init_file ;

    display_header ;
    display_menus ;
END ;


(* This procedure is the mainline of the whole program.  It gets a   *)
(* keypress from the user and then performs the appropriate function *)

PROCEDURE handle_keypress ;

VAR
    c : key_code ;

BEGIN
    REPEAT
	update_clock ;

	c := getkbhit ;		(* get a keypress from the user *)

	CASE c OF
	    K_NULL    : (* do nothing to avoid beeping *) ;

	    CTRL_W, (* actual screen refresh *)
	    CTRL_C, (* the next 2 mess up screen so refresh anyway *)
	    CTRL_Y    : refresh_screen ;

	    CTRL_B    : notify_of_bugs ;

	    K_QUEST,
	    K_UP_H,
	    K_LOW_H   : display_help ;

	    K_UP,
	    K_LEFT    :	BEGIN
			    highlight_menu (current_menu, FALSE) ;
			    current_menu := current_menu - 1 ;
			    IF current_menu < 1 THEN
				current_menu := max_menus ;
			    highlight_menu (current_menu, TRUE) ;
			END ;

	    K_DOWN,
	    K_RIGHT  :	BEGIN
			    highlight_menu (current_menu, FALSE) ;
			    current_menu := current_menu + 1 ;
			    IF current_menu > max_menus THEN
				current_menu := 1 ;
			    highlight_menu (current_menu, TRUE) ;
			END ;

	    K_RETURN:	BEGIN
			    CASE current_menu OF
				1 : read_personals (FALSE) ;
				2 : write_personal ;
				3 : read_personals (TRUE) ;
				4 : done := TRUE ;
				5 : catch_up ;
				6 : use_phone ;
				7 : check_mail ;
				8 : show_users ;
				9 : system_manager ;
				10: list_read_unread ;
				11: jump_to ;
				12: archives ;
				13: spawn_to_dcl ;
			    END ; (* case *)
			END ;

	    K_DOLLAR:   spawn_to_dcl ;

	    K_UP_A,
	    K_LOW_A :   BEGIN
			    highlight_menu(current_menu, FALSE) ;
			    current_menu := 12 ;
			    highlight_menu(current_menu, TRUE) ;
			    archives ;
			END ;

	    K_UP_J,
	    K_LOW_J :	BEGIN
			    highlight_menu(current_menu, FALSE) ;
			    current_menu := 11 ;
			    highlight_menu(current_menu, TRUE) ;
			    jump_to ;
			END ;

	    K_UP_L,
	    K_LOW_L :	BEGIN
			    highlight_menu(current_menu, FALSE) ;
			    current_menu := 10 ;
			    highlight_menu(current_menu, TRUE) ;
			    list_read_unread ;
			END ;

	    K_UP_S,
	    K_LOW_S :	BEGIN
			    highlight_menu(current_menu, FALSE) ;
			    current_menu := 9 ;
			    highlight_menu(current_menu, TRUE) ;
			    system_manager ;
			END ;

	    K_UP_P,
	    K_LOW_P :	BEGIN
			    highlight_menu(current_menu, FALSE) ;
			    current_menu := 6 ;
			    highlight_menu(current_menu, TRUE) ;
			    use_phone ;
			END ;

	    K_UP_M,
	    K_LOW_M :	BEGIN
			    highlight_menu(current_menu, FALSE) ;
			    current_menu := 7 ;
			    highlight_menu(current_menu, TRUE) ;
			    check_mail ;
			END ;

	    K_UP_U,
	    K_LOW_U :	BEGIN
			    highlight_menu(current_menu, FALSE) ;
			    current_menu := 8 ;
			    highlight_menu(current_menu, TRUE) ;
			    show_users ;
			END ;

	    K_UP_C,
	    K_LOW_C :	BEGIN
			    highlight_menu(current_menu, FALSE) ;
			    current_menu := 5 ;
			    highlight_menu(current_menu, TRUE) ;
			    catch_up ;
			END ;

	    K_UP_W,
	    K_LOW_W :	BEGIN
			    highlight_menu(current_menu, FALSE) ;
			    current_menu := 2 ;
			    highlight_menu(current_menu, TRUE) ;
			    write_personal ;
			END ;

	    K_UP_R,
	    K_LOW_R :	BEGIN
			    highlight_menu(current_menu, FALSE) ;
			    current_menu := 1 ;
			    highlight_menu(current_menu, TRUE) ;
			    read_personals (FALSE) ;	(* false means read all     *)
			END ;
	    K_UP_N,
	    K_LOW_N :	BEGIN
			    highlight_menu(current_menu, FALSE) ;
			    current_menu := 3 ;
			    highlight_menu(current_menu, TRUE) ;
			    read_personals (TRUE) ;	(* True means read only new *)
			END ;

	    CTRL_Z,
	    K_UP_E,
	    K_LOW_E,
	    K_UP_X,
	    K_LOW_X,
	    K_UP_Q,
	    K_LOW_Q :	BEGIN
			    highlight_menu(current_menu, FALSE) ;
			    current_menu := 4 ;
			    highlight_menu(current_menu, TRUE) ;
			    done := TRUE ;
			END ;

	OTHERWISE beep ;

	END ; (* case *)


    UNTIL (done) ;
END ;

			(* Mainline *)

BEGIN
    lib$spawn('set prot = (w,s,g,o:rwed) sys$login:personal.dat') ;

    mask := %X'02000000' ; (* ctrl Y and ctrl C *)

    lib$disable_ctrl (mask, saved_ctrl_mask) ;

    attributesOFF ;		(* make sure screen is all cleaned up    *)
    graphicsOFF ;		(* in case someone left bold or graphics *) 
    clrscr ;			(* on or something like that             *)
    WRITELN ;			(* dump buffer *)
    initialize ;


    refresh_screen ;		(* display menu and opening screen       *)

    handle_keypress ;		(* routine that calls all others         *)

    clrscr ;

    WRITELN ;
    WRITELN ('One moment please . . . ') ;
    WRITELN ;
    WRITELN ;
    WRITELN ;

    update_datfile ;		(* update PERSONAL.DAT before end of prgm*)

	(* clean up their account *)

    IF valid_file (options.temp_dir+'PER.DAT') THEN
	lib$delete_file (options.temp_dir+'PER.DAT;*') ;

    IF valid_file (options.temp_dir+'PER_PER.DAT') THEN
	lib$delete_file (options.temp_dir + 'PER_PER.DAT;*') ;

    IF valid_file (options.temp_dir+'PER_DATE.DAT') THEN
	lib$delete_file (options.temp_dir+'PER_DATE.DAT;*') ;

    IF valid_file (options.temp_dir+'PER2.DAT') THEN
	lib$delete_file (options.temp_dir+'PER2.DAT;*') ;

    IF valid_file ('SYS$LOGIN:PERSONAL.DAT') THEN
	lib$spawn ('purge sys$login:pers*.dat') ;

    lib$enable_ctrl (saved_ctrl_mask) ;
    lib$spawn('set prot = (w,s,g,o:r) sys$login:personal.dat') ;
    lib$spawn('set prot = (w,g,s,o:rwed) sys$login:persrc.dat') ;

    display_footer ;
END .

(* Look for other Programs by Peter M Brown, The Psychlist   *)
(* --------------------------------------------------------- *)
(*                                                           *)
(* Nemesis, a multi-user local VMS Science-fiction MUD       *)
(*                                                           *)
(* Nemedit, a full screen editor for use in programs of your *)
(*          own design.  Originally configured for Nemesis.  *)
(*                                                           *)
(* Time Riffte, Single user adventure game of the Zork Genre *)
(*                                                           *)
(* And more.  Send EMail to the addresses above for info     *)
(*                                                           *)
(* --------------------------------------------------------- *)
