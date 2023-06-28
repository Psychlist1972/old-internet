(* Module NODECONT.PAS *)

(* This module defines the application-specific contents of a linked list    *)
(* node's data field.  It is inherited by one of the modules that implements *)
(* the linked list abstract data type.                                       *)

(* by Jesse M. Heines, Ed.D.                *)
(*    University of Massachusetts at Lowell *)
(*    heinesj@woods.ulowell.edu             *)

(* Revision History                      *)
(* ----------------                      *)
(* 11/24/90   JMH   original coding      *)
(* 11/04/91   JMH   updated for lab book *)


[ENVIRONMENT ('NodeCont'),
 INHERIT ('GROUP$DISK:[COMPSCI]UTILITIES')]


MODULE NodeCont (INPUT, OUTPUT) ;


TYPE
   listdatatype = CHAR ;   (* type of list data field for program LINEDIT *)



(* This procedure prints the contents of a node.  It uses cputs instead of *)
(* WRITE so that the LINEDIT application will work properly.               *)

PROCEDURE PrintListNode
   (data : listdatatype) ;   (* contents of node's data field to be printed *)
BEGIN
   cputs (data) ;
END ;   (* PrintListNode *)



END.   (* MODULE NodeCont *)
