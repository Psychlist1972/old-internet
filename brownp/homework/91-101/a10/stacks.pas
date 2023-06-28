(* I wrote all of thes eprocedures myself, so let me know if there is *)
(* a better way to do them.   PMB                                     *)

[ ENVIRONMENT ] 

MODULE stacks (INPUT, OUTPUT) ;

TYPE
    stackdata = CHAR ;

    stacknodeptr = ^stacknode ;

    stacknode = RECORD
		    data : stackdata ;
		    next : stacknodeptr ;
		END ;

    stack = RECORD 
		top : stacknodeptr ;
	    END ;

VAR
    S : stack ;



PROCEDURE create_stack(
	VAR S : stack ) ;
BEGIN
    S.top := NIL ;
END ;


(* Used to clear all entries from a stack *)

PROCEDURE clear_stack(
	VAR S : stack ) ;

VAR
    old_top : stacknodeptr ;

BEGIN
    WHILE (S.top <> NIL) DO
	BEGIN
	    old_top := S.top ;
	    S.top := S.top^.next ;
	    DISPOSE (old_top) ;
	END ;
END ;


(* Returns TRUE if the stack is empty *)

FUNCTION stack_empty(
	S : stack )  : BOOLEAN ;
BEGIN
    stack_empty := S.top = NIL ;
END ;


(* create a new node to be pushed onto the Stack *)

PROCEDURE create_stack_node(
	data	    : stackdata ;
	VAR newnode : stacknodeptr) ;

BEGIN
    NEW (newnode) ;
    newnode^.data := data ;
    newnode^.next := NIL ;
END ;


(* Push 'DATA' on stack 'S' *)

PROCEDURE push(
	VAR S	 : stack ;
	    data : stackdata ) ;
VAR
    newnode : stacknodeptr ;

BEGIN
    create_stack_node (data, newnode) ;
    newnode^.next   := S.top ;
    S.top	    := newnode ;
END ;


(* Returns TRUE if pop was successful FALSE otherwise *)

FUNCTION pop(
	VAR S : stack ;
	VAR data : stackdata ) :BOOLEAN ;
VAR
    old_top : stacknodeptr ;

BEGIN
    IF NOT(stack_empty(S)) THEN
	BEGIN
	    data := S.top^.data ;
	    old_top := S.top ;
	    S.top := S.top^.next ;
	    DISPOSE (old_top) ;
	    pop := TRUE ;
	END
    ELSE
	pop := FALSE ;
END ;


END .
