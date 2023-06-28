
(* Program PLOT_GRAPH.PAS *)
(* --------------------   *)

(* Program purpose :	To use various graphics and screen management    *)
(*			utilities, as well as file handling techniques   *)
(*			to plot a graph of a mathematical function       *)
 
(* Revision History       *)
(* ---------------------- *)

(* 02-OCT-1991	    PMB	    Original Coding				 *)
(*                                                                       *)
(* ----------------------------------------------------------------------*)

(* The following statement imports non standard Pascal statements for    *)
(* use with this program. UTILITIES and VT100 written by                 *)
(* Professor Jesse M. Heines ULowell 1991. PAS_UTILS by Peter M Brown    *)




[INHERIT('group$disk:[compsci]vt100',
	 'group$disk:[compsci]utilities',
	 'science$disk:[brownp.homework.91-101.modules]pas_utils') ]


PROGRAM plot_graph (INPUT,OUTPUT) ;

CONST
    data_file  = 'PLOTTER.DAT' ;

VAR
    c : key_code ;	(* Used by Get1char			*)





(* Plotinit Adapted from PROGRAM plotinit by Jesse M Heines ULowell 1991 *)

PROCEDURE plotinit ;

VAR
    outfile : TEXT ;	    (* ID of output file *)
    k	    : INTEGER ;	    (* local loop index  *)

BEGIN		(* plotinit *)

	(* open output file and initialize for writing *)

    WRITELN('Creating "',data_file,'" .') ;

    OPEN (outfile, data_file, HISTORY := NEW) ;
    REWRITE (outfile) ;

	(* write sines of angles from 0 to 360 by 10s *)

    k := 0 ;
    WHILE (k <= 360) DO
	BEGIN
	    WRITELN (outfile, k:3, ' ', SIN(PI*k/180):9:5) ;
	    k := k + 10 ;
	END ;

	(* close output file and exit procedure *)

    CLOSE (outfile) ;

END ;		(* plotinit *)


PROCEDURE scalex (
	    VAR x_coord : INTEGER) ;    (* coordinate to be scaled *)

BEGIN		(* scalex *)

    x_coord := ((x_coord DIV 5) + 9) ;    (* The +9 makes column 9 the    *) 
					  (* leftmost column of the graph *)
END ;		(* scalex *)



PROCEDURE scaley (
	    VAR y_coord : REAL) ;    (* coordinate to be scaled *)

BEGIN		(* scaley *)

	(* round and configure to screen coordinate system *)

    y_coord := ( ROUND ( 11 - ( y_coord * 10 ) ) ) ; 

	(* take care of negative numbers *)

    IF y_coord <= 0 THEN
	y_coord := ( 11 + ( ABS ( y_coord ) ) )

END ;		(* scaley *)



(* This procedure does the actual printing to the screen *)

PROCEDURE plot_point(
	x_coord    : INTEGER ;
	y_coord    : REAL ) ;

CONST
    point_char = 'f' ;		(* The character used by the plotter *)
    graphix = TRUE ;		(* Graphics mode on or off	     *)
    
VAR
    y_int_coord : INTEGER ;

BEGIN		(* Plot Point *)


    IF graphix THEN
	graphicsOn ; 

    scalex(x_coord) ;		(* adjust values so the CAN be plotted *)
    scaley(y_coord) ;		(* on the text screen                  *)

{    WRITELN(x_coord:3,' ',y_coord:8:3) ; }    (* for testing purposes *)

    y_int_coord :=  (ROUND (y_coord) ) ;   (* create an integer out of a real *)

    bold(on) ;

	(* Write the point at the correct position *)
	(* see PAS_UTILS for doc. on WriteAt       *)

    writeat(x_coord, y_int_coord, point_char, FALSE ) ;

    bold(off) ;

    graphicsOff ;
    
END ;		(* Plot Point *)


PROCEDURE parse_file(
	    filename : string) ;    (* file to be opened and read from *)

VAR
    fileid  : TEXT ;		(* VMS fileid for the OPEN        *)
    x_coord : INTEGER ;		(* The x value read from the file *)	
    y_coord : REAL ;		(* The y value read from the file *)

BEGIN		(* parse_file	*)

	(* check to see if the file exists *)

    IF valid_file(filename) THEN
	BEGIN
	    OPEN (fileid, filename, HISTORY := OLD ) ;
	    RESET (fileid) ;

	    WHILE (NOT(EOF(fileid))) DO
		BEGIN
		    READLN(fileid,x_coord,y_coord) ;
		    plot_point(x_coord,y_coord) ;
		END ;

	    CLOSE (fileid) ;
	END	(* if valid_file then *)
    ELSE
	WRITELN('%Error opening "',filename,'".') ;

END ;		(* parse_file	*)



(* This procedure draws the graph "paper" on the screen *)

PROCEDURE draw_coordinate_system ;

VAR
    k : INTEGER ;   (* local loop index variable *)

BEGIN		(* draw_coordinate_system *)

    clrscr ;

    graphicsOn ;

    FOR k := 1 TO 20 DO
	BEGIN

	    CASE k OF
		11 : WRITELN('  0.00 tqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq') ;

		OTHERWISE
		    WRITELN('x':8) ;
	    END ; (* case *)

	END ;

    writeat(8,21,'mqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq') ;
    
    graphicsOff ;

	(* see pas_utils for doc. on VertLn *)

    vertln(1,7,'Sine Wave') ;

END ;		(* draw_coordinate_system *)


(* clean up the screen and end the session *)

PROCEDURE end_program ;

BEGIN
    writeat(1,22,'Thank You.') ;
    attributesOff ;
    graphicsOff ;
    gotoxy(1,23) ;
END ;


BEGIN		(* Mainline *)

	(* if the file exists, ask the user if s/he wants to (R)ewrite it *)

    IF valid_file(data_file) THEN
	BEGIN
	    WRITELN('%File "',data_file,'" already exists, (R)ewrite (C)ontinue [C]') ;
	    WRITELN ;

	    c := get1char('>> ') ;

		(* rewrite file if users specifies (R)ewrite *)

	    IF ((c = K_LOW_R) OR (c = K_UP_R)) THEN
		plotinit ;

	END  
    ELSE 
	BEGIN
	    WRITELN('Using old file . . . ') ;
	    plotinit ;
	END ;


    draw_coordinate_system ;	(* set up the screen graphics *)

    parse_file(data_file) ; (* read data from file and plot it *)

    end_program ;

END .		(* Mainline *)
