

(* this is the module for program EDITOR.PAS*)


[environment ('Edit_mod.pen'),
INHERIT ('science$disk:[heinesj.public.91-101]Prof_heines.Pen')]

Module Edit_Mod (input, output);


CONST
 maxentry = 100;

TYPE
 

 Listpointer = ^ListNode;
 ListNode =
   RECORD
    Entry : Listentry;
    NextNode : ListPointer;
   END;

 Listype =
   RECORD
    Head : listpointer;
    Tail : listpointer;
   END;

VAR
  NewNode : listpointer;
  Current : listpointer;
  L : listype;



PROCEDURE printfromp (L : listype; p : nodeptr);

BEGIN
 While p <> nil Do
  BEGIN
   displaylist (p^.entry);
   p := p^.next;
  END;
END;

(* function that returns the node before whatever current is pointing to *)

Function FindPred (L:Listype;
                   P:listpointer):listpointer;
VAR
  Q: listpointer;
  Cont : boolean;

BEGIN
  Q := L.head;
  Cont := true;
     If (Q=NIL) then Cont := False
      ELSE
       If Q^.nextnode = P Then Cont := false
        ELSE
         BEGIN
          Q := Q^.nextnode;
	  FindPred := Q;
         END;
END;


(*creates the list*)


Procedure CreateList (VAR L:listype);

BEGIN
 L.Tail := Nil;
END;


(*function that returns true or false depending on weather the *)
(* list is empty*)

Function Empty (VAR L  : listype): Boolean;

BEGIN
  If (L.Tail = Nil) Then Empty := true
END;
   

(* creates the pointer to the node *)

Procedure CreateNode (C:char; VAR P : listpointer);

BEGIN
 New (p);
 WIth p^ Do
  BEGIN
   Entry := c ;
   nextnode := nil;
  END;
ENd;
  

      
(* Inserts the newnode after the node that currents is pointing to *)

Procedure Insertafter (VAR L : listype;
			   P : listpointer;
			   Newnode : listpointer);
BEGIN
 IF EMPTY (l) THEN
  BEGIN
   L.Head := Newnode;
   L.Tail := Newnode;
  END
 ELSE
  If P = L.tail THEN
   BEGIN
    P^.Nextnode := Newnode;
    L.Tail := Newnode;
   END
  ELSE
   BEGIN
    Newnode^.nextnode := P^.nextnode;
    P^.Nextnode := Newnode;
   END;
END;



(* Current points to a node in the linked list and newnode points to a *)
(* node that is not already in the linked list.  THe node newnode^ has been *)
(* inserted before current^ in the linked list.                             *)


Procedure InsertBefore (VAR l : listype;
                            Current: Listpointer; 
                            Newnode : listpointer);
VAR
 trailer : listpointer;  (* will point to the node preceding current^ in L*)
 
BEGIN
  If EMPTY(L) THEN
    BEGIN
      L.Head := Newnode;
      L.Tail := Newnode;
    END
  ELSE                          (* inserts newnode at begining of list *)
    If (Current=L.head) Then
      BEGIN    
        Newnode^.nextnode := L.head;
        L.Head := Newnode;
      END
    ELSE
      BEGIN
        Newnode^.nextnode := current;
        Trailer := FindPred (L,current);
        Trailer^.nextnode := newnode;
       	L.tail := newnode;
      END;
END;               
end.
