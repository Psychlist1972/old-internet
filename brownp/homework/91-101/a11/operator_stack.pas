(* I wrote all of thes eprocedures myself, so let me know if there is *)
(* a better way to do them.   PMB                                     *)

[ ENVIRONMENT ] 

MODULE operator_stack (INPUT, OUTPUT) ;

TYPE
    opstackdata = CHAR ;

    opstacknodeptr = ^opstacknode ;

    opstacknode = RECORD
		    data : opstackdata ;
		    next : opstacknodeptr ;
		END ;

    opstacktype = RECORD 
		top : opstacknodeptr ;
	    END ;


PROCEDURE create_opstack(
	VAR S : opstacktype) ;
BEGIN
    S.top := NIL ;
END ;


(* Used to clear all entries from a opstack *)

PROCEDURE clear_opstack(
	VAR S : opstacktype) ;

VAR
    old_top : opstacknodeptr ;

BEGIN
    WHILE (S.top <> NIL) DO
	BEGIN
	    old_top := S.top ;
	    S.top := S.top^.next ;
	    DISPOSE (old_top) ;
	END ;
END ;


(* Returns TRUE if the opstack is empty *)

FUNCTION opstack_empty(
	S : opstacktype)  : BOOLEAN ;
BEGIN
    opstack_empty := S.top = NIL ;
END ;


(* create a new node to be pushed onto the opstack *)

PROCEDURE create_opstack_node(
	data	    : opstackdata ;
	VAR newnode : opstacknodeptr) ;

BEGIN
    NEW (newnode) ;
    newnode^.data := data ;
    newnode^.next := NIL ;
END ;


(* Push 'DATA' on opstacktype'S' *)

PROCEDURE oppush(
	VAR S	 : opstacktype;
	    data : opstackdata ) ;
VAR
    newnode : opstacknodeptr ;

BEGIN
    create_opstack_node (data, newnode) ;
    newnode^.next   := S.top ;
    S.top	    := newnode ;
END ;


(* Returns TRUE if pop was successful FALSE is underflow *)

FUNCTION oppop(
	VAR S : opstacktype;
	VAR data : opstackdata ) :BOOLEAN ;
VAR
    old_top : opstacknodeptr ;

BEGIN
    IF NOT(opstack_empty(S)) THEN
	BEGIN
	    data := S.top^.data ;
	    old_top := S.top ;
	    S.top := S.top^.next ;
	    DISPOSE (old_top) ;
	    oppop := TRUE ;
	END
    ELSE
	oppop := FALSE ;	(* underflow *)
END ;


END .
