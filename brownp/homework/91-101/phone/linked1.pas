(* Module LINKED1.PAS *)

(* This module contains procedures related to singly linked lists. *)

(* by Jesse M. Heines, Ed.D.                *)
(*    University of Massachusetts at Lowell *)
(*    heinesj@woods.ulowell.edu             *)

(* Revision History                                                   *)
(* ----------------                                                   *)
(* 11/24/90   JMH   original coding                                   *)
(* 11/04/91   JMH   updated for lab book                              *)
(* 11/12/91   WAL   fixed bug in DeleteNode (William A. Ledder)       *)
(* 11/20/91   JMH   added code to update tail pointer in InsertBefore *)


[ENVIRONMENT ('linked1'),
 INHERIT ('nodecont',
          'GROUP$DISK:[COMPSCI]UTILITIES')]


MODULE Linked1 (INPUT, OUTPUT) ;


TYPE
   listnodeptr = ^listnode ;     (* pointer to a linked list component node   *)
   listnode =                    (* structure of a linked list component node *)
      RECORD
         data : listdatatype ;   (* listnode data            *)
         next : listnodeptr ;    (* pointer to next listnode *)
      END ;

   listtype =                     (* all data required to describe a list *)
      RECORD
         head   : listnodeptr ;   (* pointer to head of list              *)
         tail   : listnodeptr ;   (* pointer to tail of list              *)
         cursor : listnodeptr ;   (* pointer to listnode to manipulate    *)
      END ;



(* This procedure clears a linked list. *)

PROCEDURE Clear
   (VAR L : listtype) ;   (* the list to be cleared *)

VAR
   p : listnodeptr ;   (* "trailer" pointer for use with DISPOSE *)

BEGIN

      (* dispose list nodes *)

   WHILE (L.head <> NIL) DO
      BEGIN
         p := L.head ;
         L.head := L.head^.next ;
         DISPOSE (p) ;
      END ;

      (* set tail and cursor to NIL *)

   L.tail := NIL ;
   L.cursor := NIL ;

END ;   (* Clear *)



(* This procedure creates a linked list by setting its head and tail *)
(* pointers to NIL.                                                  *)

PROCEDURE Create
   (VAR L : listtype) ;   (* list record *)

BEGIN

   L.head := NIL ;
   L.tail := NIL ;
   L.cursor := NIL ;

END ;   (* Create *)



(* This procedure creates a listnode with the supplied data. *)

PROCEDURE CreateNode
   (newdata         : listdatatype ;   (* new data to put in created listnode *)
    VAR newlistnode : listnodeptr) ;   (* pointer to newly created listnode   *)

BEGIN

   NEW (newlistnode) ;       (* allocate memory for new list node *)

   WITH newlistnode^ DO
      BEGIN
         data := newdata ;   (* store new data          *)
         next := NIL ;       (* initialize next pointer *)
      END ;

END ;   (* CreateNode *)



(* This function returns TRUE if the linked list is empty. *)

FUNCTION Empty
   (L : listtype)   (* list record *)
   : BOOLEAN ;      (* return type *)

BEGIN

   Empty := (L.head = NIL) ;

END ;   (* Empty *)



(* This function finds the predecessor of a listnode. *)

FUNCTION FindPred
   (L : listtype ;     (* list record                 *)
    p : listnodeptr)   (* node to find predecessor of *)
   : listnodeptr ;     (* return type                 *)

VAR
   predecessor : listnodeptr ;   (* local pointer for stepping through list *)
   continue    : BOOLEAN ;       (* TRUE if loop should continue            *)

BEGIN

      (* initializations *)

   predecessor := L.head ;
   continue := TRUE ;

      (* loop until you find the listnode that points to the desired node *)

   WHILE continue DO
      IF (predecessor = NIL) THEN
         continue := FALSE
      ELSE IF (predecessor^.next = p) THEN
         continue := FALSE
      ELSE
         predecessor := predecessor^.next ;

      (* set return value *)

   FindPred := predecessor ;

END ;   (* FindPred *)



(* This procedure deletes a given listnode. *)

PROCEDURE DeleteNode
   (VAR L : listtype ;       (* list to delete from       *)
    p     : listnodeptr) ;   (* pointer to node to delete *)

VAR
   predecessor : listnodeptr ;   (* listnode previous to cursor listnode *)

BEGIN

   predecessor := FindPred (L, p) ;

   IF ((NOT (Empty (L))) AND (p <> NIL)) THEN
      BEGIN

         IF (p = L.head) THEN               (* delete head listnode *)
            BEGIN
               L.head := L.head^.next ;
               IF (L.head = NIL) THEN
                  L.tail := NIL ;
               L.cursor := L.head ;
            END
         ELSE IF (p = L.tail) THEN          (* delete tail listnode *)
            BEGIN
               L.tail := predecessor ;
               L.tail^.next := NIL ;
               L.cursor := L.tail^.next ;
            END
         ELSE                               (* delete mid-list listnode *)
            predecessor^.next := p^.next ;

         DISPOSE (p) ;

      END ;

END ;   (* DeleteNode *)



(* This procedure inserts a given list node AFTER the cursor list node and *)
(* moves the cursor to the newly inserted listnode.                        *)

PROCEDURE InsertAfter
   (VAR L       : listtype ;       (* list to insert into       *)
    p           : listnodeptr ;    (* list node to insert after *)
    newlistnode : listnodeptr) ;   (* list node to be inserted  *)

VAR
   successor : listnodeptr ;   (* listnode after insert point *)

BEGIN

      (* handle empty list *)

   IF (Empty (L)) THEN
      BEGIN
         L.head := newlistnode ;
         L.tail := newlistnode ;
      END

      (* insert after tail listnode *)

   ELSE IF (p = L.tail) THEN
      BEGIN
         L.tail^.next := newlistnode ;
         L.tail := newlistnode ;
      END

      (* insert in middle of list  *)

   ELSE
      BEGIN
         successor := p^.next ;             (* get listnode after insertion *)
         newlistnode^.next := successor ;   (* link up new listnode         *)
         p^.next := newlistnode ;           (* set new node's next link     *)
      END ;

END ;   (* InsertAfter *)



(* This procedure inserts a given listnode BEFORE the cursor listnode. *)

PROCEDURE InsertBefore
   (VAR L       : listtype ;       (* list to insert into        *)
    p           : listnodeptr ;    (* list node to insert before *)
    newlistnode : listnodeptr) ;   (* listnode to be inserted    *)

VAR
   predecessor : listnodeptr ;   (* listnode before insert point *)

BEGIN

      (* handle empty list *)

   IF (Empty (L)) THEN
      L.head := newlistnode

      (* insert before head node *)

   ELSE IF (p = L.head) THEN
      BEGIN
         newlistnode^.next := L.head ;
         L.head := newlistnode ;
      END

      (* insert in middle of list *)

   ELSE
      BEGIN
         predecessor := FindPred (L, p) ;    (* get predecessor node    *)
         newlistnode^.next := p ;            (* link up new list node   *)
         predecessor^.next := newlistnode ;  (* set trailer's next link *)
      END ;

      (* update tail pointer if necessary *)

   IF (newlistnode^.next = NIL) THEN
      L.tail := newlistnode ;

END ;   (* InsertBefore *)



(* This procedure prints the contents of the list starting at the     *)
(* cursor position.                                                   *)

(* NOTE:  cursor can be used to step through the list in this case    *)
(* because it is a value parameter; therefore, changing it within the *)
(* scope of the procedure does not change it in the outside world.    *)

PROCEDURE PrintFromP
   (L : listtype ;       (* list to print             *)
    p : listnodeptr) ;   (* node to begin printing at *)

BEGIN

      (* process each listnode in turn *)

   WHILE (p <> NIL) DO
      BEGIN
         PrintListNode (p^.data) ;
         p := p^.next ;
      END ;

END ;   (* PrintFromP *)



END.   (* MODULE Linked1 *)
