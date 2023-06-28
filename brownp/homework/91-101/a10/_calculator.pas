(* Program PROCESSINFIX.PAS *)

(* This program computes the value of infix notation expressions using *)
(* stacks.                                                             *)

(* by Jesse M. Heines *)

(* Revision History                                         *)
(* ----------------                                         *)
(* 25-FEB-1987   JMH   original version written in Modula-2 *)
(* 24-OCT-1990   JMH   converted to VAX/VMS Pascal          *)



[INHERIT ('prof_heines.pen', 'infixstacks.pen')]


PROGRAM ProcessInfix (INPUT, OUTPUT) ;


VAR
   entry    : String ;     (* user's entry                                    *)
   error    : BOOLEAN ;    (* TRUE if user's entry does not evaluate properly *)
   errorpos : INTEGER ;    (* array position index                            *)
   k        : INTEGER ;    (* loop index                                      *)
   value    : REAL ;       (* value returned by expression evaluator          *)



(* This procedure displays the program header. *)

PROCEDURE header ;

BEGIN
   ClrScr ;
   WRITELN ('-------------------------') ;
   WRITELN ('INFIX NOTATION PROCESSING') ;
   WRITELN ('-------------------------') ;
   WRITELN ;
   WRITELN ;
END ;   { header }



(* This procedure displays the program header. *)

PROCEDURE footer ;

BEGIN
   WRITELN ;
   WRITELN ('Program terminated normally.') ;
   WRITELN ;
   WRITELN ;
END ;   { footer }



(* This function returns TRUE if the priority of the first operator is *)
(* greater than the priority of the second operator.  Otherwise, it    *)
(* returns FALSE.                                                      *)

FUNCTION greaterpriority
   (firstoperator  : CHAR ;   (* first operator to compare             *)
    secondoperator : CHAR )   (* second operator to compare            *)
   : BOOLEAN ;                (* TRUE if priority of first operator is *)
                              (*   greater than priority of second     *)

BEGIN
   CASE firstoperator OF
      '*', '/' : greaterpriority := (secondoperator='+') OR 
                                    (secondoperator='-') OR
				    (secondoperator='(') ;
      '+', '-' : greaterpriority := (secondoperator='(') ;
      '('      : greaterpriority := FALSE ;
   END ;   (* CASE *)
END ;   { greaterpriority }



(* This procedure interprets a value in the user's entry.  It returns *)
(* the value and updates the array index appropriately.               *)

PROCEDURE processvalue
   (entry     : String ;   (* expression to be evaluated   *)
    VAR k     : INTEGER ;        (* array index                  *)
    VAR value : REAL ) ;          (* value interpreted from entry *)

VAR
   c : CHAR ;   (* copy of entry[k] for convenience *)

BEGIN

      (* Initialization *)

   c := entry[k] ;
   value := (ORD(c) - 48) ;
   k := k + 1 ;
   IF (k <= LENGTH(entry)) THEN
      c := entry[k] ;
   error := FALSE ;

      (* Process until end of number *)

   WHILE (k <= LENGTH(entry)) AND (c >= '0') AND (c <= '9') DO
      BEGIN
	 value := 10.0 * value + (ORD(c) - 48) ;
	 k := k + 1 ;
         IF (k <= LENGTH(entry)) THEN
	    c := entry[k] ;
      END ;   (* WHILE *)

      (* Set k to last character in number *)

   k := k - 1 ;

END ;   { processvalue }



(* This procedure computes the result of applying the operator on top *)
(* of the operator stack to the first two values on the value stack.  *)

PROCEDURE computenewvalue
   (topoperator : CHAR ;        (* operator popped from top of stack  *)
    VAR error   : BOOLEAN ) ;   (* TRUE if stack underflows           *)

VAR
   underflow : BOOLEAN ;   (* TRUE if stack has underflowed           *)
   value1    : REAL ;      (* first value popped from value stack     *)
   value2    : REAL ;      (* second value popped from value stack    *)
   result    : REAL ;      (* computed result to push back onto stack *)
 
BEGIN

   valuestackpop (value1, underflow) ;    (* get top value on value stack *)
   error := underflow ;

   IF NOT error THEN
      BEGIN

	 valuestackpop (value2, underflow) ;    (* get second value on value *)
	 error := underflow ;                   (*   stack                   *)

	 IF NOT error THEN 
            BEGIN

	       CASE topoperator OF                    (* compute result *)
		  '+' : result := value2 + value1 ;
		  '-' : result := value2 - value1 ;
		  '*' : result := value2 * value1 ;
		  '/' : result := value2 / value1 ;
	       END ;   (* CASE *)

	       valuestackpush (result) ;              (* push result back   *)
						      (*   onto value stack *)

            END ;   (* IF NOT error THEN ... *)

      END ;   (* IF NOT error THEN ... *)

END ;   { computenewvalue }



(* This procedure processes the stack until a left parenthesis is found *)
(* or the stack becomes empty.                                          *)

PROCEDURE processparentheses
   (pareninitiated : BOOLEAN ;     (* TRUE if calling of this procedure *)
                                   (*   was initiated by a right paren  *)
    VAR error      : BOOLEAN ) ;   (* TRUE if stack underflows and      *)
                                   (*   pareninitiated is TRUE          *)

VAR
   topoperator : CHAR ;      (* operator popped from top of stack *)
   underflow   : BOOLEAN ;   (* TRUE if stack has underflowed     *)

BEGIN

   REPEAT
      operatorstackpop (topoperator, underflow) ;
      IF underflow THEN
         error := pareninitiated
      ELSE IF topoperator <> '(' THEN
         computenewvalue (topoperator, error) ;
   UNTIL underflow OR error OR (topoperator='(') ;

END ;   { processparentheses }



(* This procedure evaluates an infix notation expression. *)

PROCEDURE evaluateinfix
   (entry      : String ;      (* expression to be evaluated *)
    VAR k      : INTEGER ;     (* array position index       *)
    VAR result : REAL ;        (* result of evaluation       *)
    VAR error  : BOOLEAN ) ;   (* TRUE if an error is found  *)

VAR
   c           : CHAR ;       (* copy of entry[k] for convenience  *)
   topoperator : CHAR ;       (* operator popped from top of stack *)
   topvalue    : CHAR ;       (* value popped from top of stack    *)
   underflow   : BOOLEAN ;    (* TRUE if stack has underflowed     *)
   value       : REAL ;       (* value read from user's entry      *)

BEGIN

      (* Initialization *)

   error := FALSE ;
   k := 1 ;
   initializestacks ;

      (* Process entry array *)

   WHILE (k <= LENGTH(entry)) AND (NOT error) DO
      BEGIN

	 c := entry[k] ;   (* for coding convenience *)

	    (* Handle a number *)

	 IF (c >= '0') AND (c <= '9') THEN
	    BEGIN
	       processvalue (entry, k, value) ;
	       valuestackpush (value) ;
	    END

	    (* Handle a left parenthesis *)

	 ELSE IF c = '(' THEN
	    operatorstackpush (c) 

	    (* Handle an operator *)

	 ELSE IF (c = '+') OR (c = '-') OR (c = '*') OR (c = '/') THEN
	    BEGIN
	       operatorstackpop (topoperator, underflow) ;
	       IF underflow THEN
                  operatorstackpush (c) 
	       ELSE IF greaterpriority (c, topoperator) THEN
		  BEGIN
		     operatorstackpush (topoperator) ;
		     operatorstackpush (c) ;
		  END
	       ELSE
		  BEGIN
		     computenewvalue (topoperator, error) ;
		     operatorstackpush (c) ;
		  END ;
	    END   (* IF (c = '+' ... *)

	    (* Handle a right parenthesis *)

	 ELSE IF c = ')' THEN
	    processparentheses (TRUE, error)

	    (* Handle all other characters, of which only ' ' is OK *)

	 ELSE
	    error := (c <> ' ') ;

	 k := k + 1 ;   (* go to next character in input array *)

      END ;   (* WHILE *)

      (* Return final value *)

   IF NOT error THEN
      processparentheses (FALSE, error) ;

   IF NOT error THEN
      valuestackpop (result, error) ;

   IF error THEN
      k := k - 1 ;

END ;   { evaluateinfix }



BEGIN   (* mainline *)

   header ;

   REPEAT

      WRITE ('Enter an expression in infix notation:  ') ;
      READLN (entry) ;
      
      IF (strupr (entry) <> 'quit') THEN
	 BEGIN
	    evaluateinfix (entry, errorpos, value, error) ;
	    IF NOT error THEN
	       WRITE ('   Your expression = ', value:0:3)
	    ELSE IF strupr(entry) <> 'QUIT' THEN
               BEGIN
		  WRITE ('                                        ') ;
		  FOR k := 1 TO errorpos-1 DO
		     Write (' ') ;
		  WRITELN ('^') ;
		  WRITELN ('   Your expression contains an error at position ',
			 errorpos:0) ;
               END ;
         END ;

      WRITELN ;
      WRITELN ;

   UNTIL strupr(entry) = 'QUIT' ;

   footer ;

END.   (* mainline *)
