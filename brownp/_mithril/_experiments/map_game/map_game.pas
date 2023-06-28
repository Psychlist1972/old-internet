PROGRAM Map_Game (Input,Output) ;

const
    max_monster = 20 ;

type
    line = varying[80] of char ;
    player = record
		    health	: integer ;
		    max_health	: integer ;
		    strength	: integer ;
		    gold	: integer ;
	     end ;

var
    room       : array[1..25] of line ;
    current_x  : integer ;
    current_y  : integer ;
    s          : char ;
    max_x      : integer ;
    max_y      : integer ;
    me	       : player ;
    hit_points : integer ; { of monster }
    monster    : array [1..max_monster] of line ;
    dead       : boolean ;

Procedure read_map ;

const
    map_file = 'science$disk:[brownp._mithril._experiments.map_game]map.dat' ;

var
    map_text : text ;
    text_line : line ;    

begin
    max_x := 0 ;
    open(map_text,map_file,history := old );
    reset (map_text) ;
    
    { get rid of junk }
    readln(map_text,text_line) ;
    readln(map_text,text_line) ;
    readln(map_text,text_line) ;
    readln(map_text,text_line) ;
    readln(map_text,text_line) ;

    while (not(eof(map_text))) do
	begin
	    max_y := max_y + 1 ;
	    readln(map_text,room[max_y]) ;
	end ;
    max_x := 71 ;

    close (map_text) ;
end ;


Procedure Move_character ;

var
    x : integer ;
    y : integer ;
    stats : array [1..10] of integer ;

begin

    stats[1] := me.health ;
    stats[2] := me.max_health ;
    stats[3] := me.strength ;
    stats[4] := me.gold ;

    if s = 'n' then
	if (current_y-1 > 0) and (room[current_y-1,current_x] <> '#') then
	    current_y := current_y - 1 ;
    if s = 's' then
	if (current_y+1 < 21) and (room[current_y+1,current_x] <> '#') then
	    current_y := current_y + 1 ;
    if s = 'w' then
	if (current_x-1 > 0) and (room[current_y,current_x-1] <> '#') then
	    current_x := current_x - 1 ;
    if s = 'e' then
	if (current_x+1 < 70) and (room[current_y,current_x+1] <> '#') then
	    current_x := current_x + 1 ;

    y := 0 ;
    x := 0 ;

    for y := 1 to 3 do
	begin
	    for x := 1 to 3 do
		write(room[current_y-1,current_x-1]);
	    for x := 1 to 3 do
		write(room[current_y-1,current_x]);
	    for x := 1 to 3 do
		write(room[current_y-1,current_x+1]);
	write(stats[y]) ;
	writeln ;
	end ;	     

    for y := 1 to 3 do
	begin
	    for x := 1 to 3 do
		write(room[current_y,current_x-1]);
	    for x := 1 to 3 do
		write(room[current_y,current_x]);
	    for x := 1 to 3 do
		write(room[current_y,current_x+1]);
	if y = 1 then write(stats[4]) ;
	writeln ;
	end ;


    for y := 1 to 3 do
	begin
	    for x := 1 to 3 do
		write(room[current_y+1,current_x-1]);
	    for x := 1 to 3 do
		write(room[current_y+1,current_x]);
	    for x := 1 to 3 do
		write(room[current_y+1,current_x+1]);
	writeln ;
	end ;
end ;

Procedure Display_map ;

var
    x : integer ;
    y : integer ;

begin
    x := 0 ;
    y := 0 ;

    for y := 1 to max_y do
	begin
	    if y = current_y then
		repeat
		    x := x + 1 ;
		    if x = current_x then write('*')
		else
		    write(room[y,x]);		
		until (x = max_x)
	    else
		write(room[y]);
	    writeln ;
	end ;
end ;
 
FUNCTION atoi
   (str : line  )   (* the string to convert *)
   : INTEGER ;       (* return type           *)
 
VAR k : INTEGER ;   (* local loop index                      *)
    m : INTEGER ;   (* multiplier: +1 unless - sign detected *)
    r : INTEGER ;   (* intermediate result                   *)
 
BEGIN
 
   m := 1 ;
   r := 0 ;
 
   IF str <> '' THEN
      BEGIN
	 IF str[1]='-' THEN m := -1 ;
	 FOR k := 1 TO length(str) DO
            IF str[k] IN ['0'..'9'] THEN
               r := (10 * r) + ORD (str[k]) - 48 ;
      END ;
 
   atoi := m * r ;
 
END ;   { atoi }
 
 
FUNCTION rnd : REAL ;
 
   (* This function provides an interface to the VMS RTL random function *)
 
   FUNCTION MTH$RANDOM (
      VAR SEED : UNSIGNED   (* seed to random function *)
      ) : REAL ; EXTERN ;
 
VAR
   seed      : [ STATIC ] unsigned := 0 ;       (* number to start algorithm *)
   timearray : PACKED ARRAY [1..11] OF CHAR ;   (* to get system time        *)
 
BEGIN
 
      (* initialize seed first time through *)
 
   IF (seed = 0) THEN   
      BEGIN
         time (timearray) ;
         seed := atoi (substr (timearray, 10, 2)) ;
         rnd := mth$random (seed) ;
      END ;
 
      (* call system random function *)
 
   rnd := mth$random (seed) ;
 
END ;   { rnd }
 

Procedure fight_monster ;
var
    attack : integer ;

begin
    attack := round((rnd)*10) ;
    writeln('You attack the monster and hit for ',attack:0,' point(s) of damage.') ;
    hit_points := hit_points - attack ;
    if hit_points <= 0 then dead := true ;
end ;

Procedure Evade_monster ;
begin
    writeln('You make an attempt at evading the monster and ...') ;
end ;

Procedure barter ;
begin
    writeln('You make an attempt at bartering with  the monster and ...');
end ;

Procedure cast_monster ;
begin
end ;

Procedure get_monster ;

var
    rand_monster    : integer ;
    selection	    : char ;
    hit_points	    : integer ;    

begin
    dead := false ;
    rand_monster := round((rnd) * 20) ;
    hit_points := round((rnd) * 30) ;

    repeat		
	writeln(monster[rand_monster],' jumps you as you try to leave.');
	write('(F)ight, (C)ast, (B)arter, (E)vade >>  ');
	readln(selection);
    until (selection <> '') ;

    case selection of
	'f' : fight_monster ;
	'c' : cast_monster ;
	'b' : barter ;
	'e' : evade_monster ;
    end; { case }

end ;

begin
    monster[1] := 'a quivering mammary' ;
    monster[2] := 'an undead grandma' ;
    monster[3] := 'an undead frog' ;
    monster[4] := 'a scumbag' ;
    monster[5] := 'a green booger' ;
    monster[6] := 'a disembodied head' ;
    monster[7] := 'the bearded one' ;
    monster[8] := 'a sheepada hiaggada' ;
    monster[9] := 'a moldy snatch' ;
    monster[10] := 'Sue Casey' ;
    monster[11] := 'John Mackin' ;
    monster[12] := 'Pete Brown' ;
    monster[13] := 'John Rotondo' ;
    monster[14] := 'Pete Alberti' ;
    monster[15] := 'a red snappa' ;
    monster[16] := 'Artie Correa' ;
    monster[17] := 'a bulkie roll' ;
    monster[18] := 'a smokkida jibbida' ;
    monster[19] := 'a bulkie roll' ;
    monster[20] := 'one of Pete Brown''s farts' ;

    current_x := 3 ;
    current_y := 2 ;

    read_map ;
    repeat
	writeln ;
	write('Make your move : n,s,e,w,m,r,q  >>  ');

	readln(s);

    if room[current_y,current_x] = 'M' then get_monster ;	

	if (s ='n') or (s ='s') or (s ='e') or (s ='w') or (s = 'r') 
	    then move_character
    else 
	if (s ='m') then display_map ;


    until (s = 'q');
    writeln('Goodbye.');

end.

