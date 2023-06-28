[INHERIT (  'comp$dir:vt100',
	    'comp$dir:utilities') ]



PROGRAM screen_saver (INPUT, OUTPUT) ;

CONST
    wait_time = 0.2 ;

VAR
    c : key_code := 1 ;

    x,y		    : INTEGER ;
    screen_string   : VARYING[255] OF CHAR ;
    counter	    : INTEGER := 0 ;
    continue	    : BOOLEAN := TRUE ;

(* Fireworks ... *)

PROCEDURE explosion (x,y : INTEGER ) ;

VAR
    i : INTEGER ;

BEGIN
    FOR i := 1 TO TRUNC(rnd * 10) DO
	BEGIN
	    gotoxy (x+i+TRUNC(20*cos(i)) , (y-2) + TRUNC(i/2)) ;
	    WRITELN('.') ;

		    c := getkbhittimed(wait_time) ;

		    IF c = 0 THEN
			continue := TRUE
		    ELSE 
			continue := FALSE ;
	
	    gotoxy (x-i+TRUNC(10*cos(i)) , (y-1) + TRUNC(i/3)) ;
	    WRITELN('.') ;

		    c := getkbhittimed(wait_time) ;
		    IF c = 0 THEN
			continue := TRUE
		    ELSE 
			continue := FALSE ;
	


	    gotoxy (x+i-TRUNC(10*cos(i)) , (y-1) + TRUNC(i/3)) ;
	    WRITELN('.') ;

		    c := getkbhittimed(wait_time) ;
		    IF c = 0 THEN
			continue := TRUE
		    ELSE 
			continue := FALSE ;
	

	    gotoxy (x-i-TRUNC(20*cos(i)) , (y-2) + TRUNC(i/2)) ;
	    WRITELN('.') ;

		    c := getkbhittimed(wait_time) ;
		    IF c = 0 THEN
			continue := TRUE
		    ELSE 
			continue := FALSE ;
	
	END ;
END ;


BEGIN
    WRITE ('String to use [15 characters] ? ') ;
    READLN (screen_string) ;
{    clrscr ;  }

    screen_string := screen_string + '                          ' ;
    screen_string := substr(screen_string,1,15) ;

    WHILE continue DO
	BEGIN
	    WHILE (counter <= 2000) AND (continue) DO
		BEGIN
		    x := TRUNC(rnd * 60 + 1) ;
		    y := TRUNC(rnd * 22 + 1) ;
		    gotoxy (x,y) ;
		    WRITELN(screen_string) ;

		    c := getkbhittimed(wait_time) ;
		    IF c = 0 THEN
			continue := TRUE
		    ELSE 
			continue := FALSE ;
	


		    gotoxy(x,y) ;
		    WRITELN(' ':screen_string.length+1) ;

		    counter := counter + TRUNC(rnd * 100) ;
		END ;

		counter := 0 ;

{	    WHILE (counter <= 1000) AND (continue) DO
		BEGIN
		    x := TRUNC(rnd * 40 + 20) ;
		    y := TRUNC(rnd * 10 + 2 ) ;

		    c := getkbhittimed(wait_time) ;

		    IF c = 0 THEN
			continue := TRUE
		    ELSE 
			continue := FALSE ;
	

		    explosion (x,y) ;
		    counter := counter + TRUNC(rnd*100) ;

		    c := getkbhittimed(wait_time) ;

		    IF c = 0 THEN
			continue := TRUE 
		    ELSE 
			continue := FALSE ;
	

		    IF (counter MOD 13) = 0 THEN 
			clrscr ;
		END
}	END ;   
END .
