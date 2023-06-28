[ INHERIT ( 'nodecont',
	    'mod$dir:pas_utils',
	    'mod$dir:linked1',
	    'comp$dir:utilities',
	    'comp$dir:vt100' ) ]

PROGRAM phone_book (INPUT, OUTPUT) ;

VAR
    L : listtype ;

PROCEDURE show_error (str : string) ;
VAR
    i : INTEGER ;

BEGIN
    beep ;
    IF (str.length < 79) THEN
	BEGIN
	    FOR i := str.length + 1 TO 79 DO
		str := str + ' ' ;
	END 
    ELSE IF (str.length > 79) THEN
	str := substr (str,1,79) ;
	
    writeat(1,23,str) ;
END ;


PROCEDURE clear_record (phonerec : listdatatype) ;
VAR
    i : INTEGER ;

BEGIN
    WITH phonerec DO
	BEGIN
	    last_name := '' ;
	    first_name := '' ;
	    middle_init := CHR(K_SPACE) ;
	    area_code := '(000)' ;
	    phone_number := '000-0000' ;
	    notes_used := FALSE ;

	    FOR i := 1 TO max_notes DO
		notes[i] := '' ; 
	END ;
END ;

(* This procedure does a primitive search for a series of characters *)
(* in the list.  It will print out all names that start with those   *)
(* characters.                                                       *)

PROCEDURE find_name ;
BEGIN
END ;


(* This procedure will insert a record into the list *)

PROCEDURE insert_record (rec : listnodeptr) ;
BEGIN
END ;


(* This procedure will allow a person to edit a single record *)

FUNCTION edit_record (rec : listnodeptr) : BOOLEAN ;
BEGIN
    edit_record := TRUE ;
END ;


PROCEDURE view_record ;

VAR
    i : INTEGER ;

BEGIN
    IF L.cursor <> NIL THEN
	WITH L.cursor^ DO
	    BEGIN
		bold(on) ;
		WRITELN('Name         : ',last_name,', ',first_name,' ',middle_init) ;
		bold(off) ;
		WRITELN('Phone Number : ',area_code,' ',phone_number) ;
		WRITELN ;
		IF notes_used THEN
		    BEGIN
			FOR i := 1 TO max_notes DO
			    WRITELN(notes[i]) ;
			WRITELN ;
		    END 
		ELSE
		    WRITELN('No notes on ',first_name,' ',last_name,'.') ;
	    END
    ELSE
	show_error ('% Error in view_record, current record is "NIL".') ;
END ;

PROCEDURE add_record ;
VAR
    newnode : listnodeptr ;
    phonerec : listdatatype ;

BEGIN
    clear_record (phonerec) ;

    newnode := NIL ;

    createnode(phonerec,newnode) ;

    L.cursor := newnode ;

    IF edit_record (newnode) THEN
	BEGIN
	    insert_record (newnode) 
	END
    ELSE
	show_error ('% No record added.') ;
END ;


PROCEDURE parser ;
BEGIN
END ;


PROCEDURE setup_screen ;
BEGIN
    clrscr ; 
    home ;
    WRITELN ;
END ;


BEGIN
    create (L) ;
    setup_screen ;   
    parser ;
    normalize_screen ;
END .
