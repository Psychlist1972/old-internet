(* Program LINE_EDIT.PAS *)
(* In fulfullment of:    *)
(* CS101 Assignment # 9  *)
(* --------------------- *)

(* Peter M Brown         *)
(* Umass-lowell Nov 1991 *)
(* --------------------- *)

(* a simple one-line text editor which allows for single-character input   *)
(* as well as editing.                                                     *)

(* Revision History      *)
(* --------------------- *)

(*  07-NOV-1991	    PMB	    LINK1_MODULE and LINK_DEFS created.            *)
(*  08-NOV-1991     PMB	    Mainline and character-handling procedures.    *)
(*  17-NOV-1991	    PMB	    Addition of delete.  Addition of several bugs. *)
(*  19-NOV-1991	    PMB	    Cleanup of program.  Elimination of most bugs. *)



[INHERIT (  'link_defs',
	    'link1_module',
	    'comp$dir:vt100',
	    'comp$dir:utilities',
	    'mod$dir:pas_utils') ]


PROGRAM line_edit (INPUT,OUTPUT) ;

CONST
    max_x   = 58 ;	(* max x for cursor position *)
    min_x   = 21 ;	(* min x for cursor position *)
    SPACES_79 = '                                                                               ' ;

TYPE
    key_type = (CHARACTER, EDITING_KEY, ERROR, RETURN) ;

VAR
    done      : BOOLEAN := FALSE ;  (* flag for program termination  *)
    c	      : key_code ;	    (* key hit by the user.          *)
    current_x : INTEGER := min_x ;  (* cursor position on the screen *)
    current_y : INTEGER := 10 ;	    (* current line (stays the same) *)



(* Setup_screen :    Clears screen, draws several boxes.      *)
(*                   Should be one of first procedures called *)

PROCEDURE setup_screen ;
BEGIN	    (* setup_screen *)
    clrscr ;
    box (min_x-2, current_y-3, max_x+2, current_y+5) ;	
					(* main box, the popup-window *)
    box (min_x-1, current_y-1, max_x+1, current_y+1) ;  
					(* box around input string    *)

    writeat(min_x-1,current_y+3,'  Enter a string of characters or QUIT  ',TRUE) ;
    writeat(min_x-1,current_y+4,'   Valid Keys: <- -> delete backspace   ',TRUE) ;
    gotoxy (1,1) ;
    reverse(off) ;

    WRITELN ;	(* dump buffer *)

END ;	    (* setup_screen *)


(* Function get_keypress *)
(* This function is the core of the program.  It will get a key from the  *)
(* user and check to see what type of key it is.  IF it is a character    *)
(* the the funtion returns the key_type CHARACTER.  If it is an editing   *)
(* such as the cursor keys, backspace, escape (no function yet) or delete *)
(* then the function returns the key_type EDITING_KEY.  IF the user       *)
(* presses return then the function returns RETURN. Otherwise, the        *)
(* function returns ERROR.                                                *)

FUNCTION get_keypress ( VAR c : keycode ) : key_type ;

BEGIN	    (* get_keypress *)
    c := getch ;
    
    CASE c OF 
	32..126		: get_keypress := CHARACTER ;

	K_UP..K_RIGHT,
	K_BACKSPACE,
	K_ESC,
	K_DELETE	: get_keypress := EDITING_KEY ;
	
	K_RETURN	: get_keypress := RETURN ;

    OTHERWISE		  get_keypress := ERROR ;

    END ;   (* case *)

END ;	    (* get_keypress *)


(* Handle_edit :    Takes key_code C and performs a function assigned *)
(*		    to that key.  Such as Delete, backspace etc.      *)

PROCEDURE handle_edit ( c : key_code ) ;

VAR
    previous : nodeptr ;	(* used by Find_pred *)

BEGIN	    (* handle_edit *)

    CASE c OF

	K_DELETE,
	K_BACKSPACE :	BEGIN	    (* delete or backspace *)

			    IF (list_empty(L)) THEN
				beep	    (* there is nothing to delete *)

			    ELSE IF (L.cursor = L.head) THEN
				beep	    (* cursor at head of list *)

			    ELSE IF (L.cursor = NIL) THEN
				BEGIN	    (* cursor at end of list  *)
				    current_x	:= current_x - 1 ;
				    delete_node (L,L.tail) ;
				    gotoxyimmediate(current_x,current_y) ;
				    print_from_current (L,L.cursor) ;
				    cputs(' ') ;    (* clear garbage *)
				END 

			    ELSE IF ((current_x - 1) >= min_x) THEN
				BEGIN	    (* cursor in middle of list *)
				    current_x	:= current_x - 1 ;
				    previous	:= find_pred (L, L.cursor) ;
				    delete_node (L, previous) ;
				    gotoxyimmediate (current_x,current_y) ;
				    print_from_current (L, L.cursor) ; 
				    cputs(' ') ;    (* clear garbage *)

				    writeat(1,22,'% If Cursor = L.head, then you get funky results...sorry...') ;
				END
			    ELSE
				beep ;
			END ;	    (* delete or backspace *)


	K_LEFT	    :	BEGIN	    (* left arrow *)

			    IF (list_empty(L)) THEN
				beep	    (* nothing in list *)

			    ELSE IF (L.cursor = L.head) THEN
				beep	    (* already at beginning *)

			    ELSE IF (L.cursor = NIL) THEN
				BEGIN	    (* at end of list *)
				    current_x := current_x - 1 ;
				    L.cursor := L.tail ;
				END
			    ELSE
				BEGIN
				    current_x := current_x - 1 ;
				    IF current_x < min_x THEN 
					current_x := min_x ;
				    L.cursor := find_pred (L,L.cursor) ;
				END ;

			END ;	    (* left arrow *)


	K_RIGHT	    :	BEGIN	    (* right arrow *)

			    IF (list_empty(L)) THEN
				beep	    (* nothing in list *)

			    ELSE IF (L.cursor = NIL) THEN
				beep	    (* at end of list *)
			    ELSE
				BEGIN
				    current_x := current_x + 1 ;
				    IF current_x > max_x THEN 
					BEGIN
					    current_x := max_x ;
					    beep ;
					END
				    ELSE
					L.cursor := L.cursor^.next ;
				END ;
			END ;	    (* right arrow *)
    END ;   (* case *)

END ;	    (* handle_edit *)


(* Handle_error : Prints an error for an invalid keypress *)

PROCEDURE handle_error( c: key_code ) ;

BEGIN	    (* handle_error *)
    writeat(1,23,'Key '+itoa(c)+' currently has no definition.    ') ;
    beep ;
END ;	    (* handle_error *)


(* This procedure adds a character to the linked list *)

PROCEDURE add_char ( c : key_code ) ;

VAR
    newnode : nodeptr ;

BEGIN	    (* add_char *)


    current_x := current_x + 1 ;

    create_node(CHR(c), newnode) ;

    IF (current_x > max_x) THEN
	beep			    (* list has max elements *)
 
    ELSE IF (L.cursor = NIL) THEN
	BEGIN			    (* at end of list *)
{	    writeat(1,23,'% L.cursor = NIL, branching to INSERT_AFTER    ') ;}
	    insert_after (L, L.tail, newnode) ;
	END 
    ELSE 
	BEGIN			    (* at middle or begining of list *)
{	    writeat(1,23,'% L.cursor <> NIL, branching to INSERT_BEFORE  ') ;}
	    insert_before (L, L.cursor, newnode) ;
	END ;
 
    gotoxyimmediate (current_x-1,current_y) ;
    print_from_current (L, find_pred (L, L.cursor)) ;

END ;	    (* add_char *)


(* Function concat_data returns the concatenation of all of the nodes in  *)
(* the list.  It also sets DONE to TRUE if the string is quit or done and *)
(* it clears the list                                                     *)

FUNCTION concat_data(
	L : listtype ) : string ;
VAR
    str : string ;

BEGIN
    L.cursor := L.head ;

    WHILE (L.cursor <> NIL) DO
	BEGIN
	    str := str + L.cursor^.data ;
	    L.cursor := L.cursor^.next
	END ;

    concat_data := str ;

    standardize_string (str) ;

    IF ((str = 'quit') OR (str = 'done')) THEN
	done := TRUE ; 

    clear_list (L) ;

    gotoxy(min_x, current_y) ;
    WRITELN(' ':str.length+1) ;

    current_x := min_x ;

END ;


(* Mainline gets a keypress from the user then jumps to teh appropriate *)
(* procedure/function depending upon the key_type returned.             *)

BEGIN	    (* mainline *)

    setup_screen ;

    create_list (L) ;

{    writeat(1,21,'% List created.') ; }

    REPEAT

	gotoxyimmediate (current_x, current_y) ;

	CASE get_keypress(c) OF

	    CHARACTER	:   add_char(c) ;
	    EDITING_KEY :   handle_edit(c) ;
	    ERROR	:   handle_error(c) ;
	    RETURN	:   BEGIN
				writeat(1,20,SPACES_79) ;
				writeat(1,20,'% String <'+concat_data(L)+'>') ;
			    END  ;
	OTHERWISE
		beep ;
	END ;
 
    UNTIL (done) ;

END .	    (* mainline *)
