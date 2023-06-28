[INHERIT ('comp$dir:utilities', 'comp$dir:vt100', 'mod$dir:pas_utils') ]

PROGRAM test (INPUT, OUTPUT) ;

PROCEDURE x;
BEGIN   (* procedure *)
END ;   (* procedure *)


BEGIN	(* mainline  *)
    window (5,9) ;
    gotoxy (1,6) ;
    WRITELN ('hello') ;
END .	(* mainline  *)
