[ ENVIRONMENT, INHERIT ('link_defs') ]

MODULE link1 (INPUT,OUTPUT) ;

TYPE
    nodeptr = ^node ;		(* pointer to list node *)


    node = RECORD
	data	: datatype ;	(* the node's data	*)
	next	: nodeptr ;	(* pointer to next node *)
    END ; { node record }


    listtype = RECORD
	head	: nodeptr ;	(* ptr to head of list  *)
	tail	: nodeptr ;	(* ptr to tail of list  *)
	cursor	: nodeptr ;	(* current cursor pos   *)
    END ; { listtype record }


VAR
    L	: listtype ;		(* the linked list      *)
    newnode : nodeptr ;




PROCEDURE clear_list(
	VAR L : listtype ) ;	    (* the list to be cleared	     *)
VAR
    ptr : nodeptr ;

BEGIN

    L.cursor := L.head ;

	(* go through list and reallocate memory locations No UFM's here! *)
	(* this is a good proctice for small memory systems.              *)

    WHILE (L.cursor <> NIL) DO
	BEGIN
	    ptr := L.cursor ;
	    L.cursor := L.cursor^.next ;
	    DISPOSE(ptr) ;
	END ;

	(* ground all pointers *)

    L.head   := NIL ;
    L.tail   := NIL ;
{    L.cursor := NIL ; }
    
END ;



PROCEDURE create_node(
	newdata	    : datatype ;    (* new data to be put in new node *)
	VAR newnode : nodeptr ) ;   (* ptr to the newly created node  *)
BEGIN
    NEW (newnode) ;		    (* initialize the node            *)
    newnode^.data := newdata ;	    (* put appropriate data in node   *)
    newnode^.next := NIL ;	    (* ground the node                *)
END ;



PROCEDURE create_list(
	VAR L : listtype ) ;	    (* the list to be created	     *)
BEGIN
    L.head	:= NIL ;
    L.tail	:= NIL ;
    L.cursor	:= NIL ;
END ;





FUNCTION list_empty(
	L: listtype ) : BOOLEAN ;   (* list record to check           *)
BEGIN
    list_empty := L.head = NIL ;
END ;



FUNCTION find_pred(
	L : listtype ;		    (* list record                     *)
	p : nodeptr ) : nodeptr ;   (* pointer to node to find pred of *)
VAR
    ptr	     : nodeptr ;
    continue : BOOLEAN := TRUE ;

BEGIN
    ptr := L.head ; 

    WHILE (continue) DO
	IF (ptr = NIL) THEN
	    continue := FALSE
	ELSE
	IF (ptr^.next = p) THEN
	    continue := FALSE 
	ELSE
	    ptr := ptr^.next ;

    find_pred := ptr ;
END ;


(* delete_node gotton from Mike Estabrook 11-91 *)

PROCEDURE delete_node(
	VAR L	: listtype ;	    (* list to delete from            *)
	p	: nodeptr ) ;	    (* pointer to node to delete      *)

VAR
    pred : nodeptr ;

BEGIN
    pred := find_pred (L,p) ;

    IF (NOT(list_empty (L)) AND (p<>NIL)) THEN
	BEGIN
	    IF (p = L.head) THEN
		BEGIN
		    L.head := L.head^.next ;
		    IF (L.head = NIL) THEN
			L.tail :=NIL ;
		    L.cursor := NIL ;
		END
	    ELSE IF (p = L.tail) THEN
		BEGIN
		    L.tail := pred ;
		    IF (L.tail = NIL) THEN
			L.head := NIL
		    ELSE
			L.tail^.next := NIL ;
			
		    L.cursor := L.tail^.next ;
		END 
	    ELSE
		pred^.next := p^.next ;

	DISPOSE (p) ;
    END ;
END ;
    


(* This procedure given to me by Chrissy Poplawski 11-91 *)

PROCEDURE insert_after(
	VAR L	    : listtype ;	(* list to insert into		    *)
	    current : nodeptr ;		(* pointer to node to insert after  *)
	    newnode : nodeptr ) ;	(* node to be inserted              *)

BEGIN
    IF list_empty(L) THEN
	BEGIN
	    L.head   := newnode ;
	    L.tail   := newnode ;
	END
    ELSE IF (current = L.tail) THEN
	BEGIN
	    current^.next := newnode ;
	    newnode^.next := NIL ;
	    L.tail	  := newnode ;
	END
    ELSE 
	BEGIN
	    newnode^.next := current^.next ;
	    current^.next := newnode ;
	END ;
END ;



PROCEDURE insert_before(
	VAR L	: listtype ;		(* list to insert into		    *)
	    current : nodeptr ;		(* pointer to node to insert before *)
	    newnode : nodeptr ) ;	(* node to be inserted              *)

VAR
    prev : nodeptr ;		(* used by find_pred *)

BEGIN
    IF list_empty (L) THEN
	BEGIN
	    L.head   := newnode ;
	    L.tail   := newnode ;
	END

    ELSE IF (current = L.head) THEN
	BEGIN
	    newnode^.next := L.head ;
	    L.head := newnode ;
	END

    ELSE
	BEGIN
	    prev	    := find_pred (L,current) ;
	    prev^.next	    := newnode ;
	    newnode^.next   := current ;
	    L.tail	    := newnode ;
	END ; 
END ;



PROCEDURE print_from_current(
	L	: listtype ;	(* list to print                        *)
	current : nodeptr) ;	(* pointer to node to begin printing at *)

BEGIN
    WHILE current <> NIL DO
	BEGIN
	    write_data(current^.data) ;
	    current := current^.next ;
	END ;
END ;


END . (* module *)
