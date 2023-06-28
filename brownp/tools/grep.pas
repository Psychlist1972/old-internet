[ INHERIT ('comp$dir:utilities') ]

PROGRAM grep (INPUT,OUTPUT) ;


VAR
    search_string : string ;
    done : BOOLEAN := FALSE ;


PROCEDURE search_who_file(
	search_string : string) ;

VAR
    who_file : TEXT ;
    text_line : string ;
    found_one : BOOLEAN := FALSE ;

BEGIN
    OPEN (who_file, 'who.dat', HISTORY := OLD, ERROR := CONTINUE) ;
    RESET (who_file) ;

    WHILE (NOT(EOF(who_file))) DO
	BEGIN
	    READLN (who_file, text_line) ;

	    IF INDEX (strlwr(text_line), strlwr(search_string)) > 0 THEN
		BEGIN
		    found_one := TRUE ;
		    WRITELN (text_line) ;
		END ;
	END ;

    IF NOT (found_one) THEN
	WRITELN ('No matches.') ;

    CLOSE (who_file) ;
END ;


PROCEDURE get_search_string(
	VAR search_string : string)  ;
VAR
    grep_file : TEXT ;

BEGIN
    OPEN (grep_file, 'grep.dat', HISTORY := OLD, ERROR := CONTINUE) ;
    RESET (grep_file) ;
    READLN (grep_file, search_string) ;
    CLOSE (grep_file) ;

    stripleadingblanks (search_string) ;
    striptrailingblanks (search_string) ;

    done := search_string = '' ;

END ;


BEGIN

    get_search_string (search_string) ;

    IF NOT(done) THEN
	BEGIN
	    WRITELN ;
	    search_who_file (search_string) ;
	    WRITELN ;
	END 
    ELSE
	WRITELN ('No string to search for.') ;

END .
