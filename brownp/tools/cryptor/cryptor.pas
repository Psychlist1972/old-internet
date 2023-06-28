[INHERIT ('mod$dir:pas_utils', 'comp$dir:utilities', 'comp$dir:vt100')]

PROGRAM cryptor (INPUT, OUTPUT) ;

VAR
    crypt_code : string ;
    source_filename : string ;
    dest_filename   : string ;
    choice : string ;

PROCEDURE decrypt (
	VAR text_line : string) ;

VAR
    i : INTEGER ;
    s : string ;

BEGIN
    s := text_line ;

    FOR i := 1 to text_line.length DO
	BEGIN
	    text_line[i] := CHR(ORD(s[i]) - ORD(crypt_code[i])) ; 
	END ;
END ;


PROCEDURE encrypt (
	VAR text_line : string) ;

VAR
    i : INTEGER ;
    s : string ;

BEGIN
    s := text_line ;

    FOR i := 1 to text_line.length DO
	BEGIN
	    text_line[i] := CHR(ORD(s[i]) + ORD(crypt_code[i])) ; 
	END ;
END ;


PROCEDURE encrypt_file (encode : BOOLEAN) ;

VAR
    text_line : string ;
    destid : TEXT ;
    sourceid : TEXT ;

BEGIN
    OPEN (destid, dest_filename, HISTORY := NEW, ERROR := CONTINUE) ;
    REWRITE (destid) ;

    OPEN (sourceid, source_filename, HISTORY := OLD, ERROR := CONTINUE) ;
    RESET (sourceid) ;

    WHILE NOT(EOF(sourceid)) DO
	BEGIN
	    READLN (sourceid, text_line) ;
	    IF encode THEN
		encrypt (text_line)
	    ELSE
		decrypt (text_line) ;

	    WRITELN (destid, text_line) ;
	END ;
    
    CLOSE (sourceid) ;
    CLOSE (destid) ;
END ;


PROCEDURE get_filenames ;

VAR
    i : INTEGER ;

BEGIN
    WRITE ('Enter name of source file >  ') ;
    READLN (source_filename) ;

    WRITE ('Enter name of output file >  ') ;
    READLN (dest_filename) ;

    WRITELN ('Enter crypt code (The longer it is, the better the crypt)') ;
    WRITE ('>') ;
    READLN (crypt_code) ;

    IF crypt_code.length < 255 THEN
	FOR i := (crypt_code.length + 1) TO 254 DO
	    crypt_code := crypt_code + '*' ;

    WRITELN (crypt_code) ;

END ;


BEGIN
    WRITELN ('Text file crypting program written by Pete Brown (Psychlist) UMass-Lowell 1991') ;
    get_filenames ;
    WRITE ('Encrypt or Decrypt (E,D) > ') ;
    READLN (choice) ;
    IF choice.length > 0 THEN
	IF (choice[1] = 'E') OR (choice[1] = 'e') THEN
	    encrypt_file (TRUE)
	ELSE IF (choice[1] = 'D') OR (choice[1] = 'd') THEN
	    encrypt_file (FALSE)
	ELSE
	    WRITELN ('Invalid choice.') 
    ELSE
	WRITELN ('Invalid choice.') ;
END .

(* written by Peter M Brown , UMass Lowell 1991 *)
