PROGRAM thank_brownp (output,who) ;

TYPE
    string = VARYING[80] OF CHAR ;

VAR
    who : text ;
    line : string ;

BEGIN
    RESET(who) ;

    WHILE (NOT(EOF(WHO))) DO
	BEGIN
	    READLN(who, line) ;
	    IF index(line,'BROWNP') > 8 THEN
		WRITELN(line) ;
	END ;

    WRITELN('That''s all folks.') ;
END .
