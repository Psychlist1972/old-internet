(* I wrote all of thes eprocedures myself, so let me know if there is *)
(* a better way to do them.   PMB                                     *)

[ ENVIRONMENT ] 

MODULE value_stack (INPUT, OUTPUT) ;

TYPE
    valstackdata = REAL ;

    valstacknodeptr = ^valstacknode ;

    valstacknode = RECORD
		    data : valstackdata ;
		    next : valstacknodeptr ;
		END ;

    valstacktype = RECORD 
		top : valstacknodeptr ;
	    END ;




PROCEDURE create_valstack(
	VAR S : valstacktype ) ;
BEGIN
    S.top := NIL ;
END ;


(* Used to clear all entries from a valstacktype *)

PROCEDURE clear_valstack(
	VAR S : valstacktype ) ;

VAR
    old_top : valstacknodeptr ;

BEGIN
    WHILE (S.top <> NIL) DO
	BEGIN
	    old_top := S.top ;
	    S.top := S.top^.next ;
	    DISPOSE (old_top) ;
	END ;
END ;


(* Returns TRUE if the valstacktype is empty *)

FUNCTION valstack_empty(
	S : valstacktype )  : BOOLEAN ;
BEGIN
    valstack_empty := S.top = NIL ;
END ;


(* create a new node to be pushed onto the valstacktype *)

PROCEDURE create_valstack_node(
	data	    : valstackdata ;
	VAR newnode : valstacknodeptr) ;

BEGIN
    NEW (newnode) ;
    newnode^.data := data ;
    newnode^.next := NIL ;
END ;


(* Push 'DATA' on valstacktype 'S' *)

PROCEDURE valpush(
	VAR S	 : valstacktype ;
	    data : valstackdata ) ;
VAR
    newnode : valstacknodeptr ;

BEGIN
    create_valstack_node (data, newnode) ;
    newnode^.next   := S.top ;
    S.top	    := newnode ;
END ;


(* Returns TRUE if pop was successful FALSE otherwise *)

FUNCTION valpop(
	VAR S : valstacktype ;
	VAR data : valstackdata ) :BOOLEAN ;
VAR
    old_top : valstacknodeptr ;

BEGIN
    IF NOT(valstack_empty(S)) THEN
	BEGIN
	    data := S.top^.data ;
	    old_top := S.top ;
	    S.top := S.top^.next ;
	    DISPOSE (old_top) ;
	    valpop := TRUE ;
	END
    ELSE
	valpop := FALSE ;
END ;


END .
