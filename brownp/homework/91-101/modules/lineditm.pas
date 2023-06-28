(* Module LINEDITM.PAS *)

(* This module implements a simple line editor using a singly linked list of *)
(* characters.                                                               *)

(* by Jesse M. Heines, Ed.D.                *)
(*    University of Massachusetts at Lowell *)
(*    heinesj@woods.ulowell.edu             *)

(* Revision History                                                          *)
(* ----------------                                                          *)
(* 11/18/91   JMH   original coding adapted from LINEDIT1.PAS                *)
(* 11/20/91   JMH   added Ctrl/E functionality to move cursor to end of line *)
(* 11/20/91   PMB   addition of several minor changes, involving mnemonics   *)
(*                  and formatting.                                          *)


[ENVIRONMENT ('LinEditM'),
 INHERIT ('mod$dir:Linked1',
          'comp$dir:UTILITIES',
          'comp$dir:VT100',
	  'mod$dir:pas_utils'  )]


MODULE LinEditM (INPUT, OUTPUT) ;



(* This procedure gets a user entry while allowing editing. *)

PROCEDURE GetEntry
   (VAR s       : String ;      (* user entry as a string                     *)
    x,y         : INTEGER ;     (* entry x and y locations                    *)
    maxlen      : INTEGER ) ;   (* maximum no. of characters allowed in entry *)

VAR
   c           : KeyCode ;       (* key pressed by user                     *)
   L           : listtype ;      (* list being edited by user               *)
   newnode     : listnodeptr ;   (* pointer to new node to insert           *)
   p           : listnodeptr ;   (* local pointer for stepping through list *)
   predecessor : listnodeptr ;   (* predecessor to cursor node              *)

BEGIN

      (* initializations *)

   Create (L) ;

      (* get and process keypresses *)

   REPEAT

      GotoXYimmediate (x,y) ;
      c := GetCh ;

      CASE c OF

            (* Ctrl/B to go to the beginning of the line *)

         2 :
            IF (L.cursor = L.head) THEN
               Beep
            ELSE
	       WHILE (L.cursor <> L.head) DO
	          BEGIN
		     L.cursor := FindPred (L, L.cursor) ;
		     x := x - 1 ;
		  END ;

            (* Ctrl/E to go to the end of the line *)

         5 : 
            IF (L.cursor = NIL) THEN
               Beep
            ELSE
	       WHILE (L.cursor <> NIL) DO
	          BEGIN
		     L.cursor := L.cursor^.next ;
		     x := x + 1 ;
		  END ;

            (* Backspace, Delete *)

	 K_BACKSPACE,
	 K_DELETE   :

            IF (Empty (L)) THEN
               Beep
            ELSE IF (L.cursor = L.head) THEN
               Beep
            ELSE
               BEGIN
                  predecessor := FindPred (L, L.cursor) ;
                  DeleteNode (L, predecessor) ;
                  x := x - 1 ;
                  GotoXYimmediate (x,y) ;
                  PrintFromP (L, L.cursor) ;
                  cputs (' ') ;
               END ;

            (* Return or Esc *)

         K_RETURN, 27, K_ESC : ;

            (* printing character *)

         32..126 :

            BEGIN
               CreateNode (CHR(c), newnode) ;
	       InsertBefore (L, L.cursor, newnode) ;
               PrintFromP (L, FindPred (L, L.cursor)) ;
               x := x + 1 ;
            END ;

            (* left arrow *)

         K_LEFT :

            IF (Empty (L)) THEN
               Beep
            ELSE IF (L.cursor = L.head) THEN
               Beep
            ELSE IF (L.cursor = NIL) THEN
               BEGIN
                  L.cursor := L.tail ;
                  x := x - 1 ;
               END
            ELSE
               BEGIN
                  L.cursor := FindPred (L, L.cursor) ;
                  x := x - 1 ;
               END ;

            (* right arrow *)

         K_RIGHT :

            IF (Empty (L)) THEN
               Beep
            ELSE IF (L.cursor = NIL) THEN
               Beep
            ELSE
               BEGIN
                  L.cursor := L.cursor^.next ;
                  x := x + 1 ;
	       END ;

            (* any other keypress *)

         OTHERWISE Beep ;

      END ;

   UNTIL ((c = K_RETURN) OR (c = 27) OR (c = K_ESC)) ;

      (* convert linked list to a string to return *)

   s := '' ;
   p := L.head ;
   IF (c = 13) THEN
      WHILE (p <> NIL) DO
         BEGIN
            s := s + p^.data ;
            p := p^.next ;
         END ;

      (* clear list *)

   Clear (L) ;

END ;   (* GetEntry *)



END.   (* MODULE LinEdit1 *)
