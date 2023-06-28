
{+---------------------------------------------------------------+}
{|                                                               |}
{|                    T i m e   R i f f t e                      |}
{|                                                               |}
{|                 v2.00 for use with VAX/VMS                    |}
{|                                                               |}
{|                                                               |}
{|                                                               |}
{|                      By Peter M Brown                         |}
{|                       Ulowell 1991                            |}
{|                                                               |}
{|                                                               |}
{+---------------------------------------------------------------+}
{                                                                 }
{ Time_Riffte, an attempt at Interactive fiction by Peter M Brown }
{ inspired by such Infocom(tm) Games as Zork(tm) Trinity(tm) and  }
{ Starcross(tm) as well as the all time great -- Adventure        }
{                                                                 }
{ No copies of this program may be distributed without the sole   }
{ written consent of Peter M Brown BROWNP@WOODS.ULOWELL.EDU       }
{                                                                 }
{ All modules/procedure/functions in this program were written    }
{ soley by Peter Brown, unless where otherwise noted, therefore   }
{ please report any bugs, possible enhancements to the above NET  }
{ address                                                         }

[inherit('comp$dir:utilities.pen',
	 'variables.pen',
	 'sys$library:starlet',
	 'mod$dir:pas_utils.pen' ,
	 'comp$dir:vt100.pen')]

{ The above inherit defines the following which is used in this  }
{ program : RND      CLRSCR                                      }
{           STRLWR   STRIPLEADINGBLANKS  STRIPTRAILINGBLANKS     }
{           STRING   ATOI                DATEANDTIME             }
{           HOME     GOTOXY }


Program Time_Riffte(input,output);


FUNCTION nice (s : string) : string ;
BEGIN
    stripleadingblanks(s) ;
    striptrailingblanks(s) ;

    nice := s ;
END ;

{ The following procedures set up the variables and rooms when you first enter}
{ the game , and again if you choose to RESTART                               }

Procedure error_in_file(missing_file:string ) ;

begin
    writeln('A huge hand descends from the sky and swats you back into your own') ;
    writeln('plane of reality, and a voice booms :') ;
    writeln ;
    writeln('"The universe is not complete, something is missing...I cannot') ;
    writeln(' locate '+missing_file+' on this plane.') ;
    writeln(' You have my sincerest apologies (CONTACT BROWNP)"') ;
    writeln ;
    reverse(on) ;
    write('-- More --') ;
    attributesOff ;
    readln ;
    HALT ;
end ;

Procedure read_synonym_file;
var
    synonym_text : text ;
    syn_num      : integer ;

begin
    if debug then writeln('-- DEBUG> Entering read_synonym_file');

    if not(valid_file(synonym_file)) then
	error_in_file(synonym_file) ;

    open (synonym_text, synonym_file, history := old ) ;
    reset (synonym_text) ;

    while (not (eof (synonym_text))) do
	begin
	    read(synonym_text,syn_num) ;
	    with synonym[syn_num] do
		begin
		    readln(synonym_text,index,the_word); 
		    if debug then writeln('-- DEBUG> Syn Num ',syn_num:0,' The Word ',the_word,' Index ',index:0);
		end;
	end;
    close (synonym_text) ;
end;

{--------------------------------------------------------------------------}
Procedure read_message_file;
var
    message_text    : text ;
    message_number  : integer ;
    line_number	    : integer ;
    text_line	    : string ;

begin
    if debug then writeln('-- DEBUG> Entering read_message_file');

    if not(valid_file(synonym_file)) then
	error_in_file(message_file) ;

    open (message_text, message_file, history := old ) ;
    reset (message_text) ;
    
    while (not(EOF(message_text))) do
	begin
	    readln(message_text,message_number,line_number,text_line);
	    message[message_number,line_number] := text_line ;
	end;

    close (message_text) ;
end; { read message_file }


{--------------------------------------------------------------------------}
Procedure read_object_file;
var
    object_text : text ;       { the text file for teh objects  }
    obj_num     : integer ;    { the object index number        }
    x		: loop_index ; { local for loop index variable  } 

begin
    if debug then writeln('-- DEBUG> Entering read_object_file');

    if not(valid_file(synonym_file)) then
	error_in_file(object_file) ;

    open (object_text, object_file, history := old ) ;
    reset (object_text) ;
    
{ Object record consists of :                                                  }
{                                                                              }
{	label_desc   => the "you see here" description index number            }
{	description  => the "look at" description index number                 }
{	oget1        => these are index numbers of objects                     }
{	oget2        => required to get this object                            }
{	get_success  => index # of message printed when you get an object      }
{	get_failure  => index # of message printed when you fail to get object }
{	weight       => the weight of the object, if it is over 100, then      }
{			you cannot get the object                              }
{   	object kind  => 0   - normal object                                    }
{			1   - bag                                              }
{			2   - book (must be OPENED, then READ)                 }
{			10+ - has a procedure all its own                      }
{	put_in_bag   => boolean whether it can be placed in a bag or not       }
{                                                                              }
{	score        => the number of points it is worth                       }
{	name         => The inventory name for the object                      }


    while (not (eof (object_text))) do  { reads until End_Of_File is reached   }
	begin
	    read(object_text,obj_num) ;
	    with obj[obj_num] do        { put the values in the record's slots }
		readln(object_text,label_desc,description,oget1,oget2,
		       get_success,get_failure,weight,kind,
		       put_in_bag,score,name); 
	end;
    close (object_text) ;
end;


{--------------------------------------------------------------------------}
Procedure read_monster_file;
begin
    if debug then writeln('-- DEBUG> Entering read_monster_file');
end;


{--------------------------------------------------------------------------}
Procedure read_room_file;
var
    room_text   : text ;
    room_number : integer ;
    x		: loop_index; 

begin
    if debug then writeln('-- DEBUG> Entering read_room_file');
    if not(valid_file(synonym_file)) then
	error_in_file(room_file) ;


    open (room_text, room_file, history := old ) ;
    reset (room_text) ;
    
    room_number := 1 ;                    { initialize to the first room }

    while (not (eof (room_text))) do
	begin
	    x := 0;
	    read(room_text,room_number);
		with room[room_number] do
		begin
		    readln(room_text,verbose_desc,brief_desc,exit_north,
		           exit_south,exit_east,exit_west,exit_up,exit_down,
			   exit_nw,exit_sw,exit_ne,exit_se,sky {,special}) ;
			repeat
			    x := x + 1;
			    read(room_text,objects[x]) ;
			until (objects[x] = 0) ;
		    readln(room_text) ;

		    if debug then 
		    writeln('-- DEBUG> ',verbose_desc,brief_desc,exit_north,
		           exit_south,exit_east,exit_west,exit_up,exit_down,
			   exit_nw,exit_sw,exit_ne,exit_se,sky {,special}) ;
		end ; { with do...}
	end;
    close (room_text) ;
end;


{--------------------------------------------------------------------------}
Procedure initialize_all ;
var
    x : loop_index; { local for-loop index variable }

begin
    if debug then writeln('-- DEBUG> Entering initialize_all') ;
    
    read_synonym_file ;
    read_object_file ;
    read_monster_file ;
    read_room_file ;
    read_message_file ;

    me.score := 0 ;
    me.strength := 10 ;
    me.max_weight_slots := me.strength * 10 ;
    me.weight_slots := 0 ;
    me.health := me.strength + 5 ;
    me.shat := false ;

    for x := 1 to max_inv do
	me.inventory[x] := 0 ;

    me.inventory[1] := 18 ;  { 4 coins }
    me.inventory[2] := 18 ;
    me.inventory[3] := 18 ;
    me.inventory[4] := 18 ;

    verbose	    := true ;
    debug	    := false ;
    current_room    := start_room ;
    hour	    := 11 ;
    minute	    := 25 ;

end;


Procedure println (s:string := '') ;
begin
    writeln(s) ;
    line_counter := line_counter + 1 ;
    if line_counter = 25 then
	begin 
	    reverse(On) ;
	    write('-- More --') ;
	    attributesOff ;
	    readln ;
	    line_counter := 0 ;
	end ;
end ;

Procedure show_error (s: string) ;
begin
    s := '[ ' + nice(s) + ' ]' ;
    writeln(s) ;
    line_counter := line_counter + 1 ;
    if line_counter = 25 then
	begin 
	    reverse(On) ;
	    write('-- More --') ;
	    attributesOff ;
	    readln ;
	    line_counter := 0 ;
	end ;
end ;

{--------------------------------------------------------------------------}
Procedure show_message(mess_number:integer);
var
    counter        : loop_index ; { the line number of the message }

begin
    if debug then writeln('-- DEBUG> Entering show_message') ;

    counter := 1 ;

    if debug then 
	writeln('-- DEBUG> Displaying message number : ',mess_number:0) ;
	
    while message[mess_number,counter] <> '' do
	begin
	    println(message[mess_number,counter]) ;

	    counter := counter + 1 ;

	end;
end;

{--------------------------------------------------------------------------}
Procedure display_opening;
var
    x : loop_index; { local for loop index variable }

begin
    Clrscr;

    if debug then writeln('-- DEBUG> Entering display_opening');
    writeln ;
    writeln ;
    writeln ;
    writeln ;
    writeln ;
    writeln ;
    writeln ;
    writeln ;
    writeln('                           T i m e   R i f f t e') ;
    writeln ; 
    writeln ;
    writeln ;
    writeln ;
    writeln ;
    writeln ;
    writeln ;
    writeln ;
    writeln ;
    writeln ;
    writeln ;
    writeln('           Welcome to Time Riffte, version ',version:1:2,' by The Psychlist.');    
    writeln('                       [Press <RETURN> to continue.]') ;
    readln ;
    for x := 1 to 26 do 
	writeln ; 
end;



Procedure add_to_room(object : integer; s: string) ;
var
    y : loop_index ;
    slot_found : boolean ;
begin
    repeat
	y := y + 1 ;
	if room[current_room].objects[y] = 0 then
	    begin
		slot_found := true ;
		room[current_room].objects[y] := object ;
	    end ;
    until (y = 20) or (slot_found);
    println(s) ;
end;

Procedure remove_from_room(object:integer ; s:string) ;
var
    found : boolean ;
    x	  : loop_index ;
begin
    x := 0 ;
    found := false ;
    repeat
	x := x + 1 ;
	if room[current_room].objects[x] = object then found := true ;
    until (found) or (x = 20) ;
    
    if found then
	begin
	    room[current_room].objects[x] := 0 ;
	    println(s) ;
	end
    else
	show_error('Room contains no such object -- Contact BROWNP') ;
end ;

Procedure remove_from_inventory(object:integer;s:string) ;
var
    found : boolean ;
    x     : loop_index ;
begin
    x := 0 ;
    found := false ;
    repeat
	x := x + 1 ;
	if me.inventory[x] = object then found := true ;
    until (found) or (x = 100) ;

    if found then 
	begin
	    println(s) ;
	    me.inventory[x] := 0 ;
	end
    else
	show_error('You have no such object -- Contact BROWNP') ;
end;


Procedure put_in_inventory(object:integer ; s:string);
var
    x		: loop_index ;
    slot_found	: boolean ;

begin
    if debug then println(' -- DEBUG> Entering Put in Inventory');

    x := 0 ;
    slot_found := false ;

    repeat
	x := x + 1 ;
	if me.inventory[x] = 0 then
	    begin
		me.inventory[x] := object ;
		slot_found := true ;
	    end ;	
    until (slot_found) or (x = 100) ;
    
    if (x = 100) and (not(slot_found)) then 
	add_to_room(object,'[ There is no room in your inventory for that item. ]')
    else
	println(s) ;
end;


function i_have (object_num:integer;var index_num:integer):boolean ;
var
    yes : boolean ;
    x   : loop_index ;

begin
    x := 0 ;
    yes := false ;
    repeat
	x := x + 1 ;
	if me.inventory[x] = object_num then yes := true ;
    until (x = 100) or (yes) ;	
    i_have := yes ;
    index_num := x ;
end;


{ Function num_objs_in_room : }
{ Purpose    : To tell how many objects there are in a particular room }
{ Parameters : The room number of the room to check (integer)          }
{ Returns    : The number of objects in that room (integer)            }


Function num_objs_in_room (the_room:integer) : integer ;
var
    number_objs : integer ;
    x   : loop_index ;

begin
    x := 0 ;
    repeat
	x := x + 1 ;
	if room[current_room].objects[x] <> 0 then 
	    number_objs := number_objs + 1 ;
    until (x = 20) ;	
    
    num_objs_in_room := number_objs ;

end ;

Function in_here (object_num:integer;var index_num:integer):boolean ;
var
    yes : boolean ;
    x   : loop_index ;

begin
    x := 0 ;
    yes := false ;
    repeat
	x := x + 1 ;
	if room[current_room].objects[x] = object_num then yes := true ;
    until (x = 20) or (yes) ;	
    in_here := yes ;
    index_num := x ;
end;

{ the procedures inside the ==== lines are used in Time_Riffte only, and   }
{ would be useless to import into any other game made with this code       }
{--------------------------------------------------------------------------}
{--------------------------------------------------------------------------}


{ the Hampster follows you around the universe just for the hell of it. It }
{ is just for comic relief, and has no real purpose until you get into the }
{ dungeons. In the dungeons, it will lead you to certain areas if you are  }
{ near them.                                                               }

Procedure put_hampster ;
begin
    if (current_room > 49) and (current_room < 100) then 
	{ put an the hampster object into the room (object number 21) }
    add_to_room(21,'A hampster scurries after you.') ;

	{ check to see if you are in a room the hampster knows about  }
    { not done yet }
end ;

Procedure remove_hampster ;
begin
    if (current_room > 49) and (current_room < 100) then 
	{ remove the hampster from the room }
    remove_from_room(21,'The hampster scurries away.') ;
end ;


Procedure hampster_guts ;
var
    dummy : integer ; { used to fill parameter only }

begin
    if (current_room > 49) and (current_room < 100) then 
	if in_here(21,dummy) then 
	    remove_hampster
	else 
	    put_hampster ;
end ;

{ the thief is a random character that will show up if you spend too much  }
{ time in one room or if the random number for the thief coming is chosen  }
{ for every turn that you are in a room, the chance of the thief coming is }
{ increased by 5%.  Initial 10% chance of the thief coming to steal from   }
{ you.  In addition, The thief has a 70% + 2% per turn chance of succeding }
{ in stealing from you. } 

{ explanation of random numbers			         }
{ ------------------------------------------------------ }
{     seed * 100 gives a percentage (chance)	         }
{       if (chance <= ( 5 * number_of_turns )) or        }
{          (chance <= 10 ) then   then thief will enter  }
{     seed * 100 gives a percentage (chance_steal)       }
{       if (chance_steal <= 70) or                       }
{          (chance_steal <= (70 + 2 * number_of_turns )  }
{           then an object will be stolen                }
    
Procedure put_thief ;
begin

	{ check to see if the random number pops up      }

	{ if so, places thief in the room else, quit     }

	{ have thief attempt to steal from you           }

	{ have thief run away, whether he steals or not  }

	{ explanation of random numbers                  }
	{ seed * 13 will produce the random direction    }

	{   1  = north		2  = south	}
	{   3  = east		4  = west	}
	{   5  = up		6  = down	}
	{   7  = northeast	8  = northwest	}
	{   9  = southeast	10 = southwest	}
	{   11 = stay here	12 = attack you	}
	{   13 = drop an object		        }

end ;

Procedure remove_thief ;
begin
end ;

Procedure steal_from_player ;
begin
end ;

Procedure follow_thief ;
begin
end ;



Procedure Move_Bus ;
begin
    case current_room of 
	5   :  { end of sidewalk  }
		begin
		    case minute of
			5,20,35,50 : println(' You hear a bus in the distance.');
			10,25,40,55: println(' A large bus passes by you on the road.'); 
			15,30,45,00: println(' You hear a bus in the distance.');
		     end ;
		end;
	8   :  { entrance to park }
		begin
		    case minute of
			5,20,35,50 : println(' You hear a bus in the distance.');
			10,25,40,55: println(' A large bus passes by you on the road.'); 
			15,30,45,00: println(' You hear a bus in the distance.');
		     end ;
		end;
	12  :  { bus stop at park }
		begin
		    case minute of
			00,05,30,35 : 
				begin
				    room[current_room].objects[20] := 6;
				    { above puts a bus in the room }
				end;
			55,25 :
				begin
				    println(' A large bus stops here.');
				    room[current_room].objects[20] := 6;
				end ;
			10,40 : begin
				    room[current_room].objects[20] := 0;
				    println(' The bus drives away.');
				end ;
				
		    otherwise
			    begin
				if room[current_room].objects[20] = 6 then
				    room[current_room].objects[20] := 0
			    end;
		    end { case };
		end;
	16  :  { sidewalk         }   
		begin
		    case minute of
			5,20,35,50 : println(' A bus passes you by on the street.');
			10,25,40,55: println(' The bus fades into the distance.'); 
			15,30,45,00: println(' You hear a bus in the distance.');
		     end ;
		end;
	17  :  { end of sidewalk  }
		begin
		    case minute of
			5,20,35,50 : println(' You hear a bus in the distance.');
			25,55:	     println(' A bus passes by you on the road. ');
			15,30,45,00: println(' You hear a bus in the distance.');
		     end ;
		end;
    end; { case }
end;


Procedure board_bus ;
const
    library_bus = 33 ;
    airport_bus = 32 ;
    main_street_bus = 31 ;

    main_street = 12 ;
    airport_stop = 18 ;
    library_stop = 34 ;
 
    coin_object = 18 ;   

var
    dum : integer ; { used to fill parameter only }

begin
    sit := false ;
		    { room 12 is bus stop on main street Japan }
		    { room 18 is bus going to airport          }
		    { room 32 is bus going to library          }

    if ((i_have(coin_object,dum)) and ((current_room = main_street) or 
        (current_room = airport_stop) or (current_room = library_stop)))
	and (room[current_room].objects[20] = 6) then

    begin

    remove_from_inventory(18,'You hand the coin to the bus driver.') ; 

    If current_room = main_street then
	begin
	    case minute of
		55,00,05 : 
			begin
			    println(' You board the airport bus.');
			    current_room := airport_bus ;
			end ;
		25,30,35 : 
			begin
			    println(' You board the library bus.');
			    current_room := library_bus ;
			end ;
	    otherwise
		show_error('You see nothing to board here.'); 
	    end { case }
	end
    else
    If current_room = airport_stop then
	begin
	    case minute of
		00 : begin
			println(' You board the main street bus.');
			current_room := main_street_bus ;
		     end ;
		25 : begin
			println(' You board the library bus.');
			current_room := library_bus ;
		     end ;
		30 : begin
			println(' You board the main street bus.');
			current_room := main_street_bus ;
		     end ;
		55 : begin
			println(' You board the library bus.');
			current_room := library_bus ;
		     end ;
	    otherwise
		show_error('You see nothing to board here.'); 
	    end { case }
	end
    else 
    If current_room = library_stop then
	begin
	    case minute of
		00 : begin
			println(' You board the airport bus.');
			current_room := airport_bus ;
		     end ;
		25 : begin
			println(' You board the main street bus.');
			current_room := main_street_bus ;
		     end ;
		30 : begin
			println(' You board the airport bus.');
			current_room := airport_bus ;
		     end ;
		55 : begin
			println(' You board the main street bus.');
			current_room := main_street_bus ;
		     end ;
	    otherwise
		show_error('You see nothing to board here.'); 
	    end { case }
	end
    else
	show_error('You see nothing to board here.'); 
    end
	else 
	    if room[current_room].objects[20] = 6 then
		println('You don''t have the bus fare.')
	    else
		show_error('You see nothing to board here.'); 
end ;

Procedure sit_down ;
const
    library_bus = 33 ;
    airport_bus = 32 ;
    main_street_bus = 31 ;

    main_street = 12 ;
    airport_stop = 18 ;
    library_stop = 34 ;    

begin
    if current_room = library_bus then
	begin
	    sit := true ;
	    println(' The old woman offers you some of her bottled scum.') ;
	    println(' After a few moments, the bus begins to move, and eventually');
	    println(' stops.  You are swept out into the street by the rush of ');
	    println(' commuters flooding out of the bus.');
	    current_room := library_stop ;
	end
    else    
    if current_room = airport_bus then    
	begin
	    sit := true ;
	    println(' The old woman offers you some of her bottled scum.') ;
	    println(' After a few moments, the bus begins to move, and eventually');
	    println(' stops.  You are swept out into the street by the rush of ');
	    println(' commuters flooding out of the bus.');
	    current_room := airport_stop ;
	end
    else    
    if current_room = main_street_bus then    
	begin
	    sit := true ;
	    println(' The old woman offers you some of her bottled scum.') ;
	    println(' After a few moments, the bus begins to move, and eventually');
	    println(' stops.  You are swept out into the street by the rush of ');
	    println(' commuters flooding out of the bus.');
	    current_room := main_street ;
	end
    else
	println(' You park your butt indian style on the ground.') ;
end;

{--------------------------------------------------------------------------}
{--------------------------------------------------------------------------}

Procedure sun_and_moon;
begin
    if debug then
	begin
	    println('-- DEBUG> Entering Sun_and_moon');
	    writeln('-- DEBUG> Time => ',hour:0,':',minute:2);
	end;
    if room[current_room].sky then 
    case HOUR of
	1  : println(' The moon stands guard high above.');
	2  : println(' The moon stands guard high above.');
	3  : println(' The moon stands guard high above.');
	4  : println(' A faint glow lights the eastern horizon.');
	5  : println(' The sun slowly rises to the east and battles the moon.');
	6  : println(' The sun glows brightly to the east.');
	7  : println(' The triumphant sun makes the moon slowly dwindle away.');
	8  : println(' The sun struggles to climb up to the center of the sky.');
	9  : println(' The sun drifts ever-closer to its peak.'); 
	10 : println(' The sun drifts ever-closer to its peak.');
	11 : println(' The sun floats high above you.');
	12 : println(' The sun floats high above you.');
	13 : println(' The sun floats high above you.'); 
	14 : println(' The sun drifts wearily to the west.');
	15 : println(' The sun floats west.');
	16 : println(' The sun slowly makes its descent.');
	17 : println(' The sun and the moon battle for dominion above.');
	18 : println(' The sun slowly fades to the west.');
	19 : println(' The red sky looks beautiful to the west.');
	20 : println(' The moon stands guard high above.');
	21 : println(' The moon stands guard high above.');
	22 : println(' The moon stands guard high above.');
	23 : println(' The moon stands guard high above.');
	24 : println(' The moon stands guard high above during the witching hour.');
    end; { case }
end;


{--------------------------------------------------------------------------}
Procedure Save ;
begin
    { the following must be saved in the file    }
    { me.num_moves   current_room   me.inventory }
    { me.score  }
    { any room that has been changed             }
    
end ;

Procedure restore ;
begin
end ;
{--------------------------------------------------------------------------}


Procedure move_clock_forward;
begin
    minute := minute + 5;
    if minute >= 60 then
	begin
	    minute := minute MOD 60;
	    hour := hour + 1;
	    if hour > 24 then hour := 1;
	end;
end;

{--------------------------------------------------------------------------}
Procedure move_clock_backwards;
begin
    minute := minute - 5;
    if minute < 0 then
	begin
	    minute := 55;
	    hour := hour - 1;
	    if hour < 1 then hour := 24;
	end;

end;

{--------------------------------------------------------------------------}
Procedure help ;
begin
    if debug then println('-- DEBUG> Entering help') ;
    show_message(help_message) ;
    println ;
end ;


Function get_synonym_num(wd:word):integer;
var
    index_number : integer ;
    x		 : loop_index ;

begin
    if debug then writeln('-- DEBUG> Entering get_synonym_num(',wd,')') ;
    index_number    := 1 ;
    x := 0 ;

    repeat
	x := x + 1 ;
	if nice(synonym[x].the_word) = nice(wd) then     
	    get_synonym_num := synonym[x].index ;
    until ((nice(synonym[x].the_word) = wd) or (x = max_synonyms));
    
end ;



{ The following function shows the players vital stats, and score      }
{--------------------------------------------------------------------------}

Function find_rank(score:integer;
		   moves:integer):string;
var
    result : integer;
    rank : string;

begin
    result := trunc((score+1) * (moves/5));
    case result of
	 0..1   : rank := 'novice';
	 2..5   : rank := 'beginner';
	 6..9   : rank := 'lame adventurer';
	 10..13 : rank := 'ok adventurer';
	 14..20 : rank := 'great adventurer';
	 21..70 : rank := 'savior';
    otherwise rank := 'Saviour of the universe';	
    end;

    find_rank := rank;
end;

{--------------------------------------------------------------------------}
Procedure show_score;
begin
    if debug then println('-- DEBUG> Entering show_score');
    writeln(' Your current score is ', me.score:0,' in ',me.num_moves:0,' moves. And your strength ') ;
    writeln(' is ', me.strength:0,' this would give you the rank of ', find_rank(me.score,me.num_moves),'.') ;
end;


{ The following procedure shows the contents of your inventory         }

{--------------------------------------------------------------------------}
Procedure show_inventory;
var
    x : loop_index ;
    empty : boolean ;
begin
    empty := true ;
    if debug then println('-- DEBUG> Entering show_inventory');
    for x := 1 to max_inv do
	if me.inventory[x] <> 0 then 
	    begin
		writeln(' - ',obj[me.inventory[x]].name);
		empty := false ;
	    end;
    if empty then 
	show_error('You are empty-handed.') ;
end;


{--------------------------------------------------------------------------}
Procedure open_bag(bag:word) ;
var
    x		: loop_index ;
    bag_number	: integer ;
    dum		: integer ; { used to fill parameter only }

begin
    bag_number := 0 ;
    x := 0 ;    

    if debug then println('-- DEBUG> Entering Open Bag') ;

    bag_number := get_synonym_num(bag) ;

    if i_have(bag_number,dum) then
	begin
	    if obj[bag_number].kind = 1 then 
		begin
		    if obj[bag_number].open = true then
			show_error('It is already open.')
		    else
			begin
			    show_error('You open the '+ bag +'.') ;
			    obj[bag_number].open := true ;
			end ;
		end
	    else
		show_error('You cannot open a ' + bag + '!') ;
	end 
    else
	show_error('You are holding nothing you can open.') ;

end ;

{--------------------------------------------------------------------------}
Procedure close_bag(bag:word) ;
var
    x		: loop_index ;
    bag_number	: integer ;
    dum		: integer ; { used to fill parameter only }

begin
    bag_number	:= 0 ;
    x		:= 0 ;    

    if debug then println('-- DEBUG> Entering Close Bag') ;

    bag_number := get_synonym_num(bag) ;

    if i_have(bag_number,dum) then
	begin
	    if obj[bag_number].kind = 1 then 
		begin
		    if obj[bag_number].open = false then
			show_error('It is already closed.')
		    else
			begin
			    show_error('You close the ' + bag + '.') ;
			    obj[bag_number].open := false ;
			end ;
		end
	    else
		show_error('You cannot close a '+bag+'!') ;
	end 
    else
	show_error('You are holding nothing you can close.') ;

end ;


{--------------------------------------------------------------------------}
Procedure add_points(points : integer);
begin
    if points <> 0 then 
	begin
	    me.score := me.score + points ;
	    show_error('Your score just went up by ' + itoa(points) + ' points.') ;
	end
end;

{--------------------------------------------------------------------------}
Procedure put_in_bag(object:word; bag:word) ;
var
    dum	    : integer ; { used to fill parameter only }
    x	    : integer ; { position of object in inventory }
    y	    : loop_index ; 
    obj_num : integer ;
    bag_num : integer ;
    slot_found : boolean ;
    found   : boolean ;

begin
    if debug then println('-- DEBUG> Entering Put In Bag');
    
    found   := false ;
    obj_num := get_synonym_num(object) ;
    bag_num := get_synonym_num(bag) ;
    slot_found := false ;
    
    y := 0 ;

    if (i_have(obj_num,x)) and (i_have(bag_num,dum)) then
	begin
	    if obj[obj_num].put_in_bag then 
		begin
		    if obj[bag_num].open then
			begin
			    repeat
				y := y + 1 ;
				if obj[bag_num].contents[y] = 0 then
				    begin
					slot_found := true ;
					obj[bag_num].contents[y] := obj_num ;
					remove_from_inventory(obj_num,'Done.') ;
				    end ;
			    until (slot_found) or (y = 10)
			end
		    else
			show_error('You must open the ' + bag +' first.') ;
		end
	    else
		show_error('You cannot do that!') ;
	end
    else
	show_error('You have no such object.');

    if (y = 10) and (not(slot_found)) then
	show_error('There is no room in the ' + bag +'.');

end ;


{--------------------------------------------------------------------------}
Procedure take_from_bag(object:word; bag:word) ;
var
    x	    : loop_index ; { of bag }
    obj_num : integer ;
    bag_num : integer ;
    found   : boolean ;
    slot_found : boolean ;

begin
    if debug then println('-- DEBUG> Entering Take from bag');

    x := 0 ;    
    found := false ;
    obj_num := get_synonym_num(object) ;
    bag_num := get_synonym_num(bag) ;

    repeat
	x := x + 1 ;
	if obj[bag_num].contents[x] = obj_num then
	    begin
		found := true ;
		add_points(obj[obj_num].score);
		obj[obj_num].score := 0 ;
		put_in_inventory(obj_num,'Done.') ;
		obj[bag_num].contents[x] := 0 ;
	    end ;
    until (found) or (x = 10) ;
end ;

{--------------------------------------------------------------------------}
Procedure look_at_bag(bag_num:integer) ; 
var
    x	    : loop_index ;
    empty   : boolean ;

begin
    empty := true ;

    if debug then println('-- DEBUG> Entering look at bag');
 
    if obj[bag_num].open then   
	begin
	    println('      It contains : ') ;
	    for x := 1 to 10 do
		if obj[bag_num].contents[x] <> 0 then
		    begin
			writeln('            ',obj[obj[bag_num].contents[x]].name) ;
			empty := false ;
		    end ;
		if empty then println('            Nothing.') ;
	end
    else
	writeln('The ',obj[bag_num].name,' is closed.');		
end ;


{--------------------------------------------------------------------------}
Procedure do_look_at(look_at : word; nice_object:word) ;
var
    x    : loop_index;
    here : boolean;

begin
    x    := 0;
    here := false;

    if debug then
	begin
	    println('-- DEBUG> Entering do_look_at');
	    writeln('-- DEBUG> Examining "',look_at,'"');
    	end;	    

{ change this to Synonym watch...}
    if (look_at = 'time___1') or (look_at = 'watch__1') or 
       (look_at = 'hour___1') or (look_at = 'minute_1') or 
       (look_at = 'clock__1') {and watch is in inv}

       then 
	begin
	    writeln(' The digital military watch reads ',hour:0,':',minute:2,'.');
	    move_clock_backwards;
	    here := true ;
	end
     else
	if (nice(look_at) <> '') and (nice(look_at) <> ' ') then 
	repeat 
	    x := x + 1;    
	    if (room[current_room].objects[x]) = (get_synonym_num(look_at)) then
		begin
		    if debug then
			begin 
			    writeln('-- DEBUG> Current = ',current_room:0,' x = ',x:0);
			    writeln('-- DEBUG> Object Num ',room[current_room].objects[x]);
			end;

		    if room[current_room].objects[x] > 0 then
			begin
			    show_message(obj[room[current_room].objects[x]].description);

			    if obj[room[current_room].objects[x]].kind = 1 then
				look_at_bag(room[current_room].objects[x]) ;

			    here := true;
			end
		end;
	until ((x = 20) or (here))
	else
	    begin
		here := true ;
		show_error('Look at what??') ;
	    end ; 

	if (not here) then 
	begin
	x := 0;
	here := false;
	
	repeat 
	    x := x + 1;    
	    if (me.inventory[x]) = (get_synonym_num(look_at)) then
		begin
		    if debug then
			begin 
			    writeln('-- DEBUG> Object Num ',me.inventory[x]);
			end;
		    if me.inventory[x] > 0 then
			begin
			    show_message(obj[me.inventory[x]].description);
			    if obj[me.inventory[x]].kind = 1 then
				look_at_bag(me.inventory[x]) ;
			    here := true ;
			end
		end;
	until ((x = 100) or (here)) ;  
	end ;
	
	if ((x = 100) and (not(here))) then
	    show_error('You see no "' + nice(nice_object) + '" here.') ;
end ;

Procedure look_at_map ;
begin
    if room[current_room].exit_nw > 0 then
	write('\') 
    else
	write('X') ;
	write('X') ;

    if room[current_room].exit_north > 0 then
	write('|') 
    else
	write('X') ;
	write('X') ;

    if room[current_room].exit_ne > 0 then
	println('/') 
    else
	println('X') ;


    if room[current_room].exit_west > 0 then
	write('-') 
    else
	write('X') ;

    if room[current_room].exit_up > 0 then
	write('U') 
    else
	write('X') ;
	write('X') ;

    if room[current_room].exit_down > 0 then
	write('D') 
    else
	write('X') ;

    if room[current_room].exit_east > 0 then
	println('-') 
    else
	println('X') ;

    if room[current_room].exit_sw > 0 then
	write('/') 
    else
	write('X') ;
	write('X') ;
  if room[current_room].exit_south > 0 then
	write('|') 
    else
	write('X') ;
	write('X') ;
    
    if room[current_room].exit_se > 0 then
	println('\') 
    else
	println('X') ;

end ;

{ The following procedure does the following :                          }
{     1.  Display the Verbose description or the brief description      }
{         depending upon the boolean global variable VERBOSE.           }
{     2.  Lists any objects in the room.                                }
{     3.  Lists any non player characters in the room                   }
{     4.  Checks to see if the room is of type SPECIAL, and if so,      }
{         directs the program to the appropriate procedure              }

{--------------------------------------------------------------------------}

Procedure display_room (room_number:integer) ;
var
    x : loop_index ; { local for-loop index variable }

begin
    if debug then println('-- DEBUG> Entering Display_room') ;

{ displays room description }    
    if verbose then
	show_message(room[current_room].verbose_desc)
    else
	show_message(room[current_room].brief_desc) ;

{ -----------------------}

    { remove this later, it is for undescribed rooms only... }
    
    if nice(message[room[current_room].verbose_desc,2]) = '' then 
	begin
	    println ;
	    println('Current exits :') ;

	    write (' - ') ;

	    if room[current_room].exit_north > 0 then 
		write('North, ') ;
	    if room[current_room].exit_south > 0 then 
		write('South, ') ;
	    if room[current_room].exit_east > 0 then 
		write('East, ') ;
	    if room[current_room].exit_west > 0 then 
		write('West, ') ;
	    if room[current_room].exit_up > 0 then 
		write('Up, ') ;
	    if room[current_room].exit_down > 0 then 
		write('Down, ') ;
	    if room[current_room].exit_ne > 0 then 
		write('Northeast, ') ;
	    if room[current_room].exit_nw > 0 then 
		write('Northwest, ') ;
	    if room[current_room].exit_se > 0 then 
		write('Southeast, ') ;
	    if room[current_room].exit_sw > 0 then 
		write('Southwest.') ;
	    println ;

    end ;

{ -----------------------}

    println ;

{ displays objects         }

    for x := 1 to 20 do
	begin
	    if room[current_room].objects[x] <> 0 then
		show_message(obj[room[current_room].objects[x]].label_desc)
	end ;

    sun_and_moon ;
    line_counter := line_counter + 1 ;


{ displays monsters / npcs    }

{ special only for time_riffte : }
    if ((current_room = 31) or (current_room = 32) or (current_room = 33)) and
	(not sit) then 
	    begin
		println(' There is an empty seat here.') ;
		line_counter := line_counter + 1 ;
	    end ;

    if system then
	begin
	    look_at_map ;
	    line_counter := line_counter + 4 ;
	end ;

end ;

{ The following procedure moves the character to another room          }

{--------------------------------------------------------------------------}

Procedure change_location(direction : word) ;
var
    direction_index : integer ;      { the number equivalent of the direction  }
    first_eight     : string ;       { first eight letters of the word         }
    temp_string     : string ;       { only used to prevent array index errors }
    x		    : loop_index ;   { local loop counter                      }

begin
    if debug then println('-- DEBUG> Entering change_location');

{ Direction index numbers:
    1 : north	2 : south   3 : east
    4 : west	5 : up	    6 : down
    7 : nw	8 : sw	    9 : ne 
    0 : se                            }    

    temp_string := direction + '             ';  { prevent array index errors }
    first_eight := '';
    
    for x := 1 to 8 do
	first_eight := first_eight + temp_string[x] ;

    first_eight := strlwr(first_eight);   

    if ((direction = 'n') or (first_eight = 'north')) then
	    direction_index := 1
   else
    if ((direction = 's') or (first_eight = 'south')) then
	    direction_index := 2
   else
    if ((direction = 'e') or (first_eight = 'east')) then
	    direction_index := 3
   else
    if ((direction = 'w') or (first_eight = 'west')) then
	    direction_index := 4
   else
    if ((direction = 'u') or (first_eight = 'up')) then
	    direction_index := 5
   else
    if ((direction = 'd') or (first_eight = 'down')) then
	    direction_index := 6
   else
    if ((direction = 'nw') or (first_eight = 'northwes')) then
	    direction_index := 7
   else
    if ((direction = 'sw') or (first_eight = 'southwes')) then
	    direction_index := 8
   else
    if ((direction = 'ne') or (first_eight = 'northeas')) then
	    direction_index := 9
   else
    if ((direction = 'se') or (first_eight = 'southeas')) then
	    direction_index := 0
   else
    direction_index := 99 ;

{ checks to see if there is an exit there : }
    case direction_index of

	1 : if room[current_room].exit_north >= 0 then 
	    if room[current_room].exit_north = 0 then show_message(default_message)
	    else
		begin
		    current_room := room[current_room].exit_north;
		    display_room(current_room);
		end
	    else
		show_message((room[current_room].exit_north) * (-1));

	2 :if room[current_room].exit_south >= 0 then 
	    if room[current_room].exit_south = 0 then show_message(default_message)
	    else
		begin
		    current_room := room[current_room].exit_south;
		    display_room(current_room);
		end
	    else
		show_message((room[current_room].exit_south) * (-1));

	3 :if room[current_room].exit_east >= 0 then 
	    if room[current_room].exit_east = 0 then show_message(default_message)
	    else
		begin
		    current_room := room[current_room].exit_east;
		    display_room(current_room);
		end
	    else
		show_message((room[current_room].exit_east) * (-1));

	4 :if room[current_room].exit_west >= 0 then
	    if room[current_room].exit_west = 0 then show_message(default_message)
	    else
		begin
		    current_room := room[current_room].exit_west;
		    display_room(current_room) ;
		end
	    else
		show_message((room[current_room].exit_west) * (-1)) ;

	5 :if room[current_room].exit_up >= 0 then 
	    if room[current_room].exit_up = 0 then show_message(default_message)
	    else
		begin
		    current_room := room[current_room].exit_up ;
		    display_room(current_room) ;
		end
	    else
		show_message((room[current_room].exit_up) * (-1)) ;

	6 :if room[current_room].exit_down >= 0 then 
	    if room[current_room].exit_down = 0 then show_message(default_message)
	    else
		begin
		    current_room := room[current_room].exit_down ;
		    display_room(current_room) ;
		end
	    else
		show_message((room[current_room].exit_down) * (-1)) ;

	7 :if room[current_room].exit_nw >= 0 then 
	    if room[current_room].exit_nw = 0 then show_message(default_message)
	    else
		begin
		    current_room := room[current_room].exit_nw ;
		    display_room(current_room) ;
		end
	    else
		show_message((room[current_room].exit_nw) * (-1)) ;

	8 :if room[current_room].exit_sw >= 0 then 
	    if room[current_room].exit_sw = 0 then show_message(default_message)
	    else
		begin
		    current_room := room[current_room].exit_sw ;
		    display_room(current_room);
		end
	    else
		show_message((room[current_room].exit_sw) * (-1)) ;

	9 :if room[current_room].exit_ne >= 0 then 
	    if room[current_room].exit_ne = 0 then show_message(default_message)
	    else
		begin
		    current_room := room[current_room].exit_ne ;
		    display_room(current_room) ;
		end
	    else
		show_message((room[current_room].exit_ne) * (-1)) ;

	0 :if room[current_room].exit_se >= 0 then 
	    if room[current_room].exit_se = 0 then show_message(default_message)
	    else
		begin
		    current_room := room[current_room].exit_se ;
		    display_room(current_room) ;
		end
	    else
		show_message((room[current_room].exit_se) * (-1));

	99 : show_error('Go where ?') ;

	end; { case }

	hampster_guts ;  { move hampster only when you move or try to move }

end;



{--------------------------------------------------------------------------}

Procedure poof(s:word);
var
    target_room : integer ;

begin
    println(' This function is for the manager only, and will be removed.') ;
    println(' Enter a room NUMBER only, and beware, this is by far, not ') ;
    println(' bulletproof.') ; 

    if nice(s) <> ''  then
	begin
	    target_room := atoi(s) ;
	    if (target_room = 0) or (target_room > max_rooms) then 
		target_room := 1 
	    else
	    if room[target_room].brief_desc = 0 then
		show_error('That room does not exist.') 
	    else
		begin
		    current_room := target_room ;
		    show_error('Poofed to : '+itoa(target_room)+ '.') ;
		    println ;	
		    println ;	
		    display_room(current_room) ;
		end ;
	end
    else
	begin
	    write ('Target room ? (integer) [1] : ') ;
	    readln(target_room) ;
	    if (target_room = 0) or (target_room > max_rooms) then 
		target_room := 1 ;
	    if room[target_room].brief_desc = 0 then
		show_error('That room does not exist.') 
	    else
		begin
		    current_room := target_room ;
		    show_error('Poofed to : '+itoa(target_room)+ '.') ;
		    println ;	
		    println ;	
		    display_room(current_room) ;
		end ;
	end ;
end ;


{                                                                       }
{ The following procedure is used for finding out various aspects of    }
{ the game, including :                                                 }
{     1.  The version number you are running                            }
{     2.  The author(s)                                                 }
{     3.  The actual date and actual time                               }
{     4.  All of the exits in the room (manager only)                   }
{     5.  All of the objects in the room (manager only)                 }
{     6.  All of the rooms in the game (manager only)                   }

Procedure Show(wd:word);
var
    date      : string ; { used in SHOW DATE }
    time      : string ; { used in SHOW DATE }
    time_sig  : string ; { used in SHOW DATE }
    x	      : loop_index ;

begin
    nice(wd) ;
		{     1.  The version number you are running            }
    If wd = 'version' then 
	writeln('You are running version ',version:0:2,' of Time Riffte')

		{     2.  The author(s)                                 }
    else
    If (wd = 'authors') or (wd = 'author') then
	show_error('This version written By Peter M Brown, ULowell 1991')

		{     3.  The actual date and actual time               }
    else
    If (wd = 'date') then 
	begin
	    dateandtime(date,time,time_sig) ;
	    show_error('The actual VAXdate is :  '+date+'.') ;
	end
    else
    If (wd = 'time') then
	begin
	    dateandtime(date,time,time_sig) ;
	    show_error('The actual VAXtime is :  '+time+' '+time_sig+'.');
	    show_error('...this is NOT game time...EXAMINE WATCH for that info.');
	end
		{     4.  All of the exits in the room (manager only)   }
    else
    If (wd = 'exits') or (wd = 'exit') then
    begin
	if system then
	begin
	    println('For manager only, this funtion will be removed...');
	    println ;
	    writeln('  North     ',room[current_room].exit_north:0);
	    writeln('  South     ',room[current_room].exit_south:0);
	    writeln('  East      ',room[current_room].exit_east:0);
	    writeln('  West      ',room[current_room].exit_west:0);
	    writeln('  Up        ',room[current_room].exit_up:0);
	    writeln('  Down      ',room[current_room].exit_down:0);
	    writeln('  NorthEast ',room[current_room].exit_ne:0);
	    writeln('  SouthEast ',room[current_room].exit_se:0);
	    writeln('  NorthWest ',room[current_room].exit_nw:0);
	    writeln('  SouthWest ',room[current_room].exit_sw:0);
	end
	else
	    show_error('Try reading the location description.') ;
    end
		{     5.  All of the objects in the room (manager only) }
    else
		{     6.  All of the rooms in the game (manager only) }
    if (wd= 'rooms') then
	begin
	    { format : ROOM_NUM,' > ',BRIEF_DESC }
	    for x := 1 to max_rooms do
		if room[x].brief_desc <> 0 then 
		    begin
			write(x:0,' > ') ;
			show_message(room[x].brief_desc) ;
		    end 
		else
		    show_error(' ----- Room [' + itoa(x) + '] not used.') ;
	end 
    else
	show_error('What do you want to show (date,time,version,author) ?');


end;
{ The following procedures do the following :                           }
{     1.  check to see if there is an empty object slot in the room,    }
{         if so, then it does the following                             }
{            a. Update room inventory                                   }
{            b. Print the object_drop message                           }
{            c. Update the player's inventory                           }
{     2.  If there is NO room to drop the object, then the following    }
{         is done                                                       }
{            a. Print a drop failure message                            }
{            b.  If it is a special object, checks to see if anything   }
{                happens when you fail to drop it                       }

{--------------------------------------------------------------------------}
Procedure drop_obj(object:word);
var
    x,y  : loop_index;
    here : boolean;
    slot_found : boolean ;

begin
    x    := 0;
    y    := 0;
    here := false;
    slot_found := false;

    if debug then
	begin
            println('-- DEBUG> Entering Drop_object');
	    writeln('-- DEBUG> Trying to drop "',object,'"');
    	end;	    
    if nice(object) <> '' then 
    begin
	repeat 
	    x := x + 1;    
	    if (me.inventory[x]) = (get_synonym_num(object)) then
		begin
		    here := true ;
		    if debug then
			begin 
			    writeln('-- DEBUG> Current = ',current_room:0,' x = ',x:0);
			    writeln('-- DEBUG> Object Num ',me.inventory[x]);
			end;
		    repeat
			y := y + 1 ;
			if room[current_room].objects[y] = 0 then
			    begin
				slot_found := true ;
				room[current_room].objects[y] := me.inventory[x];
				me.weight_slots := me.weight_slots - obj[me.inventory[x]].weight;
				me.inventory[x] := 0 ;
				println(' Dropped.');
			    end;
		    until (y = 20) or (slot_found);
		end;
	until ((x = 100) or (here)); 

	if ((x = 100) and (not(here))) then
	    show_error('You have no "'+nice(object)+'" in your possession.') ;
    end
	else
	    show_error('Drop what?') ;
end ;

Procedure drop_all_objs ;
var
    x : loop_index ;
begin
    x := 0 ;
    for x := 1 to 100 do
	if me.inventory[x] <> 0 then
	    begin
		add_to_room(me.inventory[x],'Dropped.') ;
		me.inventory[x] := 0 ;
	    end ;
end ;
{ The following procedures and functions do the following               }
{     1.  Check to see if the object is take-able, if so, then it       }
{         does the following:                                           }
{            (does this 20 times if user type GET ALL                   }
{            a.  Print get success message                              }
{            b.  Update room inventory                                  }
{            c.  Update player's inventory                              }
{            d.  Update player's score if necessary                     }
{     2.  If the object is  NOT take-able then the program does the     }
{         following:                                                    }
{            a.  Print get failure message                              }
{            b.  If it is a special object, checks to see if anything   }
{                happens when you fail to get it                        }


{--------------------------------------------------------------------------}
Procedure grab_object(object:integer);
var
    y : loop_index ;
    done : boolean ;

begin

    { put in inventory        }

    y := 0 ;
    done := false ;
    repeat
	y := y + 1 ;
	if me.inventory[y] = 0 then 
	    begin
		me.inventory[y] := object;
		done := true ;
	    end ;
    until (done) or (y = 100) ;

    { remove from room record }

    y := 0;
    done := false ;
    repeat
	y := y + 1;
	if room[current_room].objects[y] = object then
	    begin
		room[current_room].objects[y] := 0;
		done := true ;
	    end;
    until (done) or (y = 20) ;
end;


{--------------------------------------------------------------------------}
Procedure get_all_objects ;
var
    x	       : loop_index ;
    empty_room : boolean ;

begin
    empty_room := true ;
    x          := 0;

    repeat
	x := x + 1 ;
	if room[current_room].objects[x] <> 0 then
	    if obj[room[current_room].objects[x]].weight <= 100 then
	    begin
		if me.weight_slots + obj[room[current_room].objects[x]].weight < me.max_weight_slots then 
		begin
		    reverse(On) ;
		    writeln(obj[room[current_room].objects[x]].name,',');
		    attributesOff ;
		    write('  ');
		    show_message(obj[room[current_room].objects[x]].get_success);
		    empty_room := false ;
		    me.weight_slots := me.weight_slots + obj[room[current_room].objects[x]].weight;
		    add_points(obj[room[current_room].objects[x]].score);
		    obj[room[current_room].objects[x]].score := 0 ;

		    grab_object(room[current_room].objects[x]);
		    me.num_moves := me.num_moves + 1 ;	
	    	    println ;
		end
		    else
			begin
			    empty_room := false ;
			    println(' You try, but you are carrying too much already.') ;
			end
            end
	    else
		begin	
		    writeln(obj[room[current_room].objects[x]].name,',');
		    write('  ') ;
		    show_message(obj[room[current_room].objects[x]].get_failure);
		    println ;
		end;

    until (x = 20);

    if (empty_room) then
	show_error('There is nothing you can get.');
end ;


{--------------------------------------------------------------------------}
Procedure get_obj(object:word; nice_wd: word);
var
    x    : loop_index ;
    here : boolean ;
    location : integer ; { used in I_HAVE }

begin
    location := 0 ;
    x    := 0 ;
    here := false ;


    if debug then
	begin
            println('-- DEBUG> Entering Get_object') ;
	    writeln('-- DEBUG> Trying to get "',object,'"') ;
    	end ;	    

   if nice(object) = '' then
	begin
	    show_error('What do you want to get?');
	end
	else
	repeat 
	    x := x + 1 ;    
	    if (room[current_room].objects[x]) = (get_synonym_num(object)) then
		begin
		    if debug then
			begin 
			    writeln('-- DEBUG> Current = ',current_room:0,' x = ',x:0) ;
			    writeln('-- DEBUG> Object Num ',room[current_room].objects[x]) ;
			end;
		    if room[current_room].objects[x] > 0 then
			if ((obj[room[current_room].objects[x]].weight <= 100)
						    and
			    (i_have(location,obj[room[current_room]
						    .objects[x]].oget1)) and
			    (i_have(location,obj[room[current_room]
						    .objects[x]].oget2)))

			then
				begin
				if me.weight_slots + obj[room[current_room].objects[x]].weight < me.max_weight_slots then 
				    begin
					show_message(obj[room[current_room].objects[x]].get_success) ;
					add_points(obj[room[current_room].objects[x]].score) ;
					obj[room[current_room].objects[x]].score := 0 ;
					here := true ;
					me.weight_slots := me.weight_slots + obj[room[current_room].objects[x]].weight;

					grab_object(room[current_room].objects[x]) ;
				    end
					else
					    begin
						println(' You try, but you are carrying too much already.') ;
						here := true ;
					    end
			    end
			else
			    begin
				show_message(obj[room[current_room].objects[x]].get_failure) ;
				here := true ;
			    end ;
		end ;
	until ((x = 20) or (here)) ; 

	if ((x = 20) and (not(here))) then
	    show_error('You see no "'+nice_wd+'" here.');
end;

{--------------------------------------------------------------------------}
Procedure found_swear(wd:word) ;
begin
    if debug then println('-- DEBUG> Entering Found_swear');

	if (wd = 'fuck') then println('[ Ya, right, with what, your bedpost? ]')
    else
	if (wd = 'shit') then 
	    begin
		if me.shat then
		    println('You already took a good shit today.') 
		else
		    begin
			add_to_room(26,'You take a nice fat dump right here.') ;
			me.shat := true ;
		    end 
	    end 
    else
	if (wd = 'ass') then println('[ Is it really appropriate to talk about your rear-end? ]')
    else
	if (wd = 'damn') then println('[ Yes, I DO understand swears... ]')
    else
	if (wd = 'asshole') then println('[ Yes, that IS where feces comes from ]')
    else    
	if (wd = 'clit') then println('[ Ooohhh...talk dirty to me...(moan) ]')
    else 
	if (wd = 'hell') then println('[ That is where YOU will be if you keep mouthing off! ]')
	{ this part will later poof you to hell }
    else 
	println('[ Such language from a would-be-saviour-of-the-world. ]');

end ;

{--------------------------------------------------------------------------}

[external (lib$spawn)]
function lib$spawn(command_string : [class_s] packed array[$l1..$u1:integer]
			 of char): unsigned;
external;

Procedure write_username ;
begin
    lib$spawn('@science$disk:[brownp._mithril]riffte_users.com') ;
    println ;
    println('That was for log purposes only, and will put you on a mailing') ;
    println('list for Time Riffte play testers.') ;
    writeln ;
    writeln ;
    writeln ;
    writeln ;
    write ('Press <Return> to continue ') ;
    readln ;
end ;


Procedure spawn_to_dcl ;
var
    command : string ;

begin
    repeat
	writeln ;
	write('DCL Command > ') ;	
	readln(command) ;
	nice(command) ;

	if command = '' then 
	    show_error ('Beg Pardon ?') 
	else
	if command = '?' then
	    begin
		writeln('		  DCL Help list') ;
		writeln('		  -------------') ;
		writeln('Enter a valid DCL command or type EXIT to quit.') ;
		writeln('This is useful to edit the code from within itself.') ;
	    end 
	else
	    lib$spawn(command) ;
    until (command = 'exit') 
end ;

{--------------------------------------------------------------------------}


Procedure debug_check;
var
    you_passwd : string ;
    act_passwd : string ;
    sys_passwd : string ;

begin
    if debug then println('-- DEBUG> Entering debug_check') ;

    act_passwd := 'karathonius' ;    
    sys_passwd := 'lick me' ;

    write('DEBUG: Please enter authorization password : ') ;

    lib$spawn('set term/noecho') ;
    readln(you_passwd) ;
    lib$spawn('set term/echo') ;

    println ;
    nice(you_passwd) ;

    if you_passwd = act_passwd then 
	begin
	    if debug then 
		begin
		    debug := false ;
		    println('-- DEBUG> Debugging off.') ;
		end
	    else
		begin
		    debug := true ;
		    println('-- DEBUG> Debugging is now on.') ;
		end
	end
    else
    if you_passwd = sys_passwd then 
	begin
	    if system then 
		begin
		    system := false ;
		    println('-- DEBUG> System off.') ;
		end
	    else
		begin
		    system := true ;
		    println('-- DEBUG> System is now on.') ;
		end
	end
    else
	show_error('Sorry, but you are not authorized to debug.') ;
end ; { procedure debug_check }


Function is_a_noun(wd:word) : boolean ;
var
    answer : boolean ;
begin
    if nice(wd) = '' then 
	answer := false 
    else
	begin 
	    if wd[8] = '1' then 
		answer := true 
	    else 
		answer := false ;
	end ;

    is_a_noun := answer
end ;


Function is_a_verb(wd:word) : boolean ;
var
    answer : boolean ;
begin
    if nice(wd) = '' then 
	answer := false 
    else
	begin
	    if (wd[8] = '4') or (wd[8] = '5') or (wd[8] = '8') then 
		answer := true 
	    else 
		answer := false ;
	end ;

    is_a_verb := answer
end ;

{ The following procedures and functions are the core of the program.    }
{ They perform the following things :                                    }
{       1. Break up the sentence into words                              }
{       2. Find the comand number of WORD[1]                             }
{       3. Go to the procedure that word[1] specifies.                   }
{       4. Move the clock forward one step                               }
{       5. Add one to the number of moves                                }

Procedure Distribute_words (n_words : integer ) ;

var
    noun : boolean ;     { whether or not there is at least ONE noun }
    verb : boolean ;     { whether or not there is at least one verb }
    x : loop_index ;     { local loop index variable                 }
    position : integer ; { the word currently being checked, and sent }
		         { to procedures either as a parameter of the }
			 { procedure determanant. }
    target_location : string ; { used for poof only }
    current_verb : word ;
    temp_word : string ;

begin
    if debug then println('--DEBUG> Entering Distribute Words ') ;

    noun := false ;
    verb := false ;
    current_verb := '' ;

    for x := 1 to n_words do
	begin	
	    if is_a_noun(wd[x]) then
		noun := true 
	    else
	    if is_a_verb(wd[x]) then
		verb := true ;  
	end ;

    if verb = false then
	begin
	    show_error('There are no verbs in that sentence!') ;
	end 
    else
	begin
	    position := 1 ;	
	    if debug then
		println('-- DEBUG> Verb is true, starting comparisons...') ;
	    repeat 

		temp_word := wd[position] ;

		wd[position] := temp_word[1] + temp_word[2] + temp_word[3] +
				temp_word[4] + temp_word[5] + temp_word[6] + 
				temp_word[7] ;

{		truncate(7,temp_word) ;        }
{		wd[position] := temp_word ;    }

		move_clock_forward ;

{ get one }	if ((wd[position] = 'get____') and 
		   (wd[position + 1 ] <> 'all____6'))

		or ((is_a_noun(temp_word)) and 
		   (current_verb = 'get')) 

		or ((num_objs_in_room(current_room) = 1) and 
		   (nice(nice_wd[position+1]) = ''))

		then
		    begin
			if debug then
			    println('-- DEBUG> Sending to GET_OBJ') ;
			current_verb := 'get' ;

			if ((num_objs_in_room(current_room) = 1) and 
			   (nice(nice_wd[position+1]) = '')) then
			    begin
				write('I assume you mean the : ') ;
				get_all_objects ; 
			    end 
			else 

			if (nice(nice_wd[position+1]) = '') then
			    begin
				show_error('What do you want to get?') ;   
			    end
			else
			    begin
				if is_a_noun(wd[position+1]) then
				    begin 
					get_obj(wd[position + 1],nice_wd[position+1]) ;
					position := position + 2 ;
					me.num_moves := me.num_moves + 1 ;
				    end
				else
				    begin
					show_error('I don''t understand what you are trying to say.') ;
					position := n_words ;
				    end
			    end
		    end
		else

{ get all }	if (wd[position] = 'get____') and 
		   (wd[position+1] = 'all____6') then 
		    begin
			if debug then
			    println('-- DEBUG> Sending to GET_ALL_OBJECTS') ;
			current_verb := 'get' ;
			get_all_objects ;
			position := position + 2 ;
		    end 
		else

{ directions }	if (wd[position] = 'north__') or (wd[position] = 'south__') or
		   (wd[position] = 'east___') or (wd[position] = 'west___') or
		   (wd[position] = 'up_____') or (wd[position] = 'down___') or
		   (wd[position] = 'northe_') or (wd[position] = 'northw_') or
		   (wd[position] = 'southe_') or (wd[position] = 'southw_') or
		   (wd[position] = 'n______') or (wd[position] = 's______') or
		   (wd[position] = 'e______') or (wd[position] = 'w______') or
		   (wd[position] = 'u______') or (wd[position] = 'd______') or
		   (wd[position] = 'ne_____') or (wd[position] = 'nw_____') or
		   (wd[position] = 'se_____') or (wd[position] = 'sw_____') 
		then 
		    begin
			if debug then
			    println('-- DEBUG> sending to CHANGE_LOCATION(position)') ;
			change_location(nice_wd[position]) ;
			position := position + 1 ;
			me.num_moves := me.num_moves + 1 ;
		    end 
		else

{ go / leave }	if (wd[position] = 'go_____') or (wd[position] = 'leave__')
		then
		    begin
			if debug then
			    println('-- DEBUG> sending to CHANGE_LOCATION(position+1)') ;
			change_location (nice_wd[position + 1]) ;
			position := position + 2 ;
			me.num_moves := me.num_moves + 1 ;
		    end 
		else

{ look at / }	if ((wd[position] ='look___') and (wd[position+1] = 'at_____7'))
		then
		    begin
			if debug then
			    println('-- DEBUG> sending to DO_LOOK_AT') ;

			if is_a_noun(wd[position+3]) and 
			   is_a_noun(wd[position+2]) then
			    begin
				show_error('You cannot refer to multiple objects with LOOK') ;
				position := n_words ;
			    end 
			else
			if is_a_noun(wd[position+2]) then
			    begin 
				do_look_at(wd[position + 2], nice_wd[position+2]) ;
				position := position + 3 ;
				me.num_moves := me.num_moves + 1 ;
			    end 
			else
			    begin
				show_error('You can''t look at "'+nice_wd[position+3]+'".') ;
				position := n_words ;
			    end ;
 		    end 
		else

{ examine }	if (wd[position] = 'examin_')  
		then
		    begin
			if debug then
			    println('-- DEBUG> sending to DO_LOOK_AT') ;

			if is_a_noun(wd[position+1]) then
			    begin 
				do_look_at(wd[position+1], nice_wd[position+1]) ;
				position := position + 2 ;
				me.num_moves := me.num_moves + 1 ;
			    end 
			else
			    begin
				show_error('I don''t understand what you are trying to say.') ;
				position := n_words ;
			    end ;
 		    end 
		else

{ look }	if (wd[position] = 'look___') and (wd[position+1] <> 'at_____7')
	        then
		    begin
			if is_a_noun(wd[position + 1]) then
			    begin
				position := n_words ;
				show_error('Look AT something or what?') ;
			    end
			else
			    begin
				if debug then
				    println('-- DEBUG> sending to DISPLAY_ROOM(CURRENT_ROOM)') ;
				display_room(current_room) ;
				position := position + 1 ;
				me.num_moves := me.num_moves + 1 ;
			    end
		    end 
		else

{ debug }	if (wd[position] = 'debug__') 
		then
		    begin
			if debug then
			    println('-- DEBUG> sending to Debug Check') ;
			debug_check ;
			position := position + 1 ;
		    end
		else

{ who       }   if (wd[position] = 'who____')
		then
		    begin
			if system then
			    lib$spawn('type music$disk:[whiteda.po_box]riffte_players.dat')
			else
			    show_error('Sorry, you do not have privledges to see the users list.') ;
			position := position + 1 ;
		    end 
		else

{ inventory }	if (wd[position] = 'i______') or (wd[position] = 'inv____') or
		   (wd[position] = 'invent_') then
		    begin
			if debug then
			    println('-- DEBUG> sending to Inventory ') ;
			show_inventory ;
			position := position + 1 ;
			me.num_moves := me.num_moves + 1 ;
		    end  
		else

{ poof   }	if (wd[position] = 'poof___')
		then
		    begin
			if debug then
			    println('-- DEBUG> sending to poof ') ;
			poof(nice(wd[position+1])) ;
			position := position + 2 ;
			me.num_moves := me.num_moves + 1 ;
		    end  
		else

{ take   }	if (wd[position] = 'take___') and (wd[position+2] = 'from___7')
		and (wd[position+3] <> '') 
	        then
		    begin
			if debug then
			    println('-- DEBUG> sending to Take from bag ') ;
			if is_a_noun(wd[position + 1]) and 
			   is_a_noun(wd[position +3 ]) then
			   begin
				take_from_bag(wd[position+1],wd[position+3]) ;
				position := position + 4 ;
				me.num_moves := me.num_moves + 1 ;
			    end
			else
			    begin
				show_error('I don''t understand what you are trying to say.') ;
				position := n_words ;
			    end ;
		    end  
		else
{ put    } 	if (wd[position] = 'put____') and (wd[position+2] = 'in_____7')
		and (wd[position+3] <> '') 
	        then
		    begin
			if debug then
			    println('-- DEBUG> sending to Put inbag ') ;
			if is_a_noun(wd[position + 1]) and 
			   is_a_noun(wd[position +3 ]) then
			   begin
				put_in_bag(wd[position+1],wd[position+3]) ;
				position := position + 4 ;
				me.num_moves := me.num_moves + 1 ;
			    end
			else
			    begin
				show_error('I don''t understand what you are trying to say.') ;
				position := n_words ;
			    end ;
		    end  
		else

{ board  }	if (wd[position] = 'board__') 
		then
		    begin
			if debug then
			    println('-- DEBUG> sending to board_bus ') ;
			board_bus ;
			position := position + 1 ;
			me.num_moves := me.num_moves + 1 ;
		    end
		else

{ sit }		if (wd[position] = 'sit____') 
		then
		    begin
			sit_down ;
			if wd[position+1] = 'down___4' then
			    position := position + 2
			else
			if (wd[position+1] = 'on_____7') then 
			    position := position + 3 
			else
			    position := position + 1 ;
			me.num_moves := me.num_moves + 1 ;
		    end
		else

{ show     }    if (wd[position] = 'show___')
		then
		    begin
			if debug then println('-- DEBUG> Sending to SHOW') ;
			show(nice_wd[position+1]) ;
			position := position + 2 ;
			me.num_moves := me.num_moves + 1 ;
		    end
		else

{ verbose  }    if (wd[position] = 'verbos_')
		then
		    begin
			show_error('Verbose location descriptions.') ;
			verbose := true ;
			position := position + 1 ;
			me.num_moves := me.num_moves + 1 ;
		    end
		else

{ brief    }    if (wd[position] = 'brief__')
		then
		    begin
			show_error('Brief location descriptions.') ;
			verbose := false ;
			position := position + 1 ;
			me.num_moves := me.num_moves + 1 ;
		    end
		else

{ help     }    if (wd[position] = 'help___')
		then
		    begin
			if debug then println('-- DEBUG> Sending to Help') ;
			position := position + 1 ;
			help ;
			me.num_moves := me.num_moves + 2 ;
		    end
		else

{ swears   }	if (wd[position] = 'fuck___') or (wd[position] = 'shit___') or
		   (wd[position] = 'ass____') or (wd[position] = 'damn___') or
		   (wd[position] = 'asshol_') or (wd[position] = 'clit___') or
		   (wd[position] = 'hell___') 
		then
		    begin
			position := n_words ;
			found_swear(nice_wd[position]) ;
			me.num_moves := me.num_moves + 5 ; 
		    end 
		else

{ drop one }    if (wd[position] = 'drop___') and 
		   (wd[position + 1] <> 'all____6')
		then
		    begin
			if (nice(wd[position + 1]) <> '') then 
			if is_a_noun(wd[position+1]) then
			    begin 
				drop_obj(wd[position + 1]) ;
				position := position + 2 ;
				me.num_moves := me.num_moves + 1 ;
			    end 
			else
			    begin
				show_error('I don''t understand what you are trying to say.') ;
				position := n_words ;
			    end
		    end  
		else

{ drop all }    if (wd[position] = 'drop___') and
		   (wd[position + 1] = 'all____6')
		then
		    begin
			drop_all_objs ;
			position := position + 2 ; 
			{ have me.num_moves incremented in the procedure }
		    end
		else

{ restart  }    if (wd[position] = 'restar_')
		then
		    begin
			position := position + 1 ;
			show_score ;
			write('--- Restart game, are you sure? [n] ') ;
			readln(target_location) ;
			nice(target_location) ;

			if target_location = 'y' then 
			    initialize_all
			else
			    show_error('Restart aborted.') ;
			    me.num_moves := me.num_moves + 1 ;
		    end
		else

{ save     }    if (wd[position] = 'save___')
		then
		    begin
			show_error('"SAVE" Not yet implemented') ;
			position := position + 1 ;
			me.num_moves := me.num_moves + 1 ;
		    end
		else

{ Restore  }    if (wd[position] = 'restor_')
		then
		    begin
			show_error('"RESTORE" Not yet implemented') ;
			position := position + 1 ;
			me.num_moves := me.num_moves + 1 ;
		    end
		else

{ quit     }    if (wd[position] = 'quit___') or
		   (wd[position] = 'q______') { this is just to avoid an error }
		then
		    begin
			position := position + 1 ;
			println ;
			me.num_moves := me.num_moves + 1 ;
		    end  
		else

{ dcl commands }if (wd[position] = 'spawn__') or (wd[position] = 'dcl____')
		then
		    begin
			if system then
			    begin
				if debug then println('-- DEBUG> Sending to Spawn') ;
				position := position + 1 ;
				show_error('This function is for managers only.') ;
				spawn_to_dcl ;
				me.num_moves := me.num_moves + 1 ;
			    end
		        else
			    show_error('You must be a manager to use the editing functions.') ;
		    end
		else
 
{ score  }	if (wd[position] = 'score__') 
		then
		    begin
			me.num_moves := me.num_moves + 1 ;
			position := position + 1 ;
			show_score ;
		    end 
		else

		if is_a_noun(temp_word) then
		    begin
			show_error('What about the "' + nice_wd[position]+'"?') ;
		    end
		else
		    begin
			show_error('Unimplemented Command, EMail BROWNP') ;
			position := position + 1 ;
		    end ;

		move_bus ;


	    if debug then 
		writeln('-- DEBUG> Word at position ',position:0,' ===> ',wd[position]) ;
	until ( position >= n_words ) ;
    end ;
end ;

{--------------------------------------------------------------------------}
{ the following function will search the dictionary file, which contains   }
{ all of the words that the computer knows, and return the index value     }
{ pointing to the word.                                                    }
{ this function searches to see if the computer knows the word and then    }
{ assigns it a trailing suffix which corresponds with the following:       }
{   1.  All words are truncated to 6 letters.                              }
{   2.  The suffixes added to the end (position 7 and 8 of the word) are:  }
{		_1   for a noun                                            }
{               _2   for an adjective                                      }
{               _3   for a conjunction                                     }
{               _4   for an alone verb                                     }
{               _5   for a verb requiring an object                        }
{               _6   for a word like ALL (pronoun)                         }
{               _7   for a preposition (at, to ...)                        }
{               _8   for a verb that can be alone or with an object        }
{               _9   for                 }
{               _0   for                 }

Procedure search_vocab_file (var wd	  : word ;
			    var do_i_know : boolean ) ;

var
    found      : boolean ;
    vocab_text : text ;	     { the text file containing all of the vocab words }
    vocab_word : word ;	      { a word in the vocabulary file }
    brief_word : word ;	      { the word in the file without the extension }
    x	       : loop_index ; { local loop index variable }
    temp_word  : word ;	      { temporary storage space for word }

begin
	    { conditions :  The vocab file must be in alphabetical order, and }
	    { must contain EVERY word that Time Riffte knows, object names,   }
	    { exits, abbreviations etc... and each word must have only ONE    }
	    { space between it and the next.  8 words per line in the file    }
	    { each word in the file must have the appropriate extension       }
	    { (see above)                                                     }

    if wd <> '' then
	begin
	    x		:= 0 ;
	    temp_word	:= '' ;
	    wd		:= wd + '______' ;
	    for x := 1 to 6 do
	    begin
		if wd[x] = ' ' then wd[x] := '_' ;
		temp_word  := temp_word + wd[x] ; 
	    end ;

	    wd := temp_word ;
	    wd := wd + '_' ;

	    if debug then 
		writeln('-- DEBUG> The word (wd)  = ',wd) ;
	end ;

    found := false ;
    do_i_know := false ;

    open (vocab_text, vocab_file, history := old ) ;
    reset (vocab_text) ;
    while (not (eof (vocab_text))) and (not found) do
	begin
	    readln(vocab_text,vocab_word) ;
	    brief_word := vocab_word[1] + vocab_word[2] + vocab_word[3] +
			  vocab_word[4] + vocab_word[5] + vocab_word[6]	+
			  vocab_word[7] ;

	    if nice(wd) = nice(brief_word) then
		begin
		    found	:= true ;
		    wd		:= vocab_word ;
		    do_i_know	:= true ;
		end ;
	end ;
    close (vocab_text) ;
end ;


{--------------------------------------------------------------------------}
Procedure parse_line (s:string);

var
    x,y	    : loop_index ;  { local loop index variables                   }
    bottom  : integer ;	    { the first letter of the word rel. to string  }
    top	    : integer ;	    { the last letter of the word, plus a space    }
    number  : integer ;	    { the number of words parsed out of the string }
    do_i_know : boolean ;   { whether or not the word is in the vocab file }

begin
    if debug then
	begin
	     println('-- DEBUG> Entering Parse_line');
	     println(s);
	end;

if (s = '') then
    begin 
	show_error('Beg Pardon?') ;
	println ;
    end 
else 
    begin
	bottom	    := 1 ;
	x	    := 1 ;
	y	    := 1 ;
	number	    := 1 ;

	for x := 1 to wd_count do 
	    wd[x] := '' ;

	s := '_ '+ s + ' _ ' ; { insures that the last word is parsed   }
		               { this is neccessary because I parse the }
		               { input in a back-to-front fashion       }

    { search line for blanks and 'parse out' words }

    x := 1 ;

    for x := 1 to length(s) do
	if s[x] = '.' then 
	    writeln('Start new sentence here: ',x:0) 
	else 
	    if s[x] = ' ' then
		begin
		    for y := bottom + 1 to x do
			    if x <> length(s) then 
				begin
				    wd[number] := wd[number] + s[y] ;
				    nice(wd[x]) ;         
				end ;

		    bottom := x ;
		    if (wd[number] <> 'the') and
		       (wd[number] <> 'teh') and
		       (wd[number] <> 'th') and
		       (wd[number] <> 'some') and
		       (wd[number] <> 'a') and
		       (wd[number] <> 'an') and
		       (wd[number] <> '') and
		       (wd[number] <> ' ') then
			    number := number + 1
		    else
			begin
			    wd[number] := ''
			end ;
		end; { if s[x] = ' ' then ... } 	   

    number := number - 1 ;
    x := 0 ;
    
    for x := 1 to wd_count do 
	nice_wd[x] := '' ;

    x := 0 ;
    for x := 1 to number do
	nice_wd[x] := wd[x] ;

    x := 0 ;

    repeat
	x := x + 1 ;
	search_vocab_file(wd[x],do_i_know) ;	
    until (do_i_know = false) or (x = number) ; 
    
    if do_i_know = false then
	show_error('I do not understand the word "'+nice_wd[x]+'".')	
    else
	distribute_words(number) ;	
    end ;

end ; { procedure parse_line }



{--------------------------------------------------------------------------}
Procedure leave_game;
    
begin
    println ;
    println('Thank-you for playing   T i m e   R i f f t e   by The Psychlist.') ;
    println ;
    beep ;
    beep ;
    show_score ;
    println ;
end;


{--------------------------------------------------------------------------}
{--------------------------------------------------------------------------}

begin { mainline code }

{ pmb     lib$spawn('set term/nobroadcast') ; }
{ pmb     write_username ;  }

    clrscr ;		         { clear the entire screen                    }
    display_opening ;	         { display the title screen and credits       }
    initialize_all ;	         { read from all files and init all variables }
    display_room(start_room) ;   { show the description of the first room     }

    s := '' ;

    while (s <> 'quit') and (s <> 'q') do
	begin
	    window(2,24) ;    { create window that will go around the top bar }
	    reverse(on) ;     { turn the reverse text mode on                 }
	    home ;            { position the cursor at row 1 column 1         }

	    writeln(' T i m e   R i f f t e   v',version:1:2,' by The Psychlist    Health = ',me.health:0,' Score = ',me.score:0,'/',me.num_moves:0);

	    attributesOff ;   { turn off all of the special graphics things   }
	    gotoxy(1,24) ;    { position cursor at the bottom of the screen   }
 	    
	    if s <> '' then   { If player entered a command, write 2 lines    }
		begin         { from clarity, especially when they LOOK       }
		    println ;
		    println ;
		end ;

	    line_counter := 1 ;

	    write (prompt) ;{ show the 'I want to >' prompt                   }
	    readln(s) ;     { get the command sentence from the user          }
	    nice(s) ;       { lowercase, strip leading and trailing blanks    }
	    parse_line(s) ; { actual main line of Time Riffte                 }
	end ;

    window(1,24) ; { eliminate the window by making th ewhole screen a window }
    gotoxy(1,24) ; { position the cursor at the very bottom of the screen     }
    println ;	   
    leave_game ;   { show the score and the rank etc.                         }
{ pmb     lib$spawn('set term/broadcast') ; }

end.  {	mainline code							    }
