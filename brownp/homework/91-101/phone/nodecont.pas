[environment]

MODULE nodecont (INPUT, OUTPUT) ;

CONST
    max_notes = 10 ;

TYPE
    string80 = VARYING[80] OF CHAR ;
    string30 = VARYING[30] OF CHAR ;
    string3  = VARYING[5] OF CHAR ;	(* (508) etc..  *)
    num_type = VARYING[8] OF CHAR ;	(* 555-6959 etc *)

    block = ARRAY [1..max_notes] OF string80 ;
    note_type = block ;

    listdatatype =
		RECORD
		    last_name   : string30 ;	(* person's last name      *)
		    first_name  : string30 ;	(* person's first name     *)
		    middle_init : CHAR ;	(* person's middle initial *)
		    area_code	: string3 ;	(* person's area code      *)
		    phone_number: num_type ;	(* person's phone number   *)
		    notes_used  : BOOLEAN ;	(* boolean to display notes*)
		    notes	: note_type ;	(* personal remarks etc..  *)
		END ;   (* datatype *)

PROCEDURE printlistnode(
	    phonerec : listdatatype) ;
BEGIN
    (* dummy for print_from_current *)
END ;

END .
