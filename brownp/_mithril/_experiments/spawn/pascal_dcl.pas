[inherit ('sys$library:starlet') ]

Program Spawn_to_dcl (input,output) ;

var
	command: varying[255] of char ;


[external (lib$spawn)]
function lib$spawn(command_string : [class_s] packed array[$l1..$u1:integer]
			 of char): unsigned;
external;

begin
    repeat
	writeln ;
	write('Command > ') ;	
	readln(command) ;

	if command = '' then 
	    writeln ('[ Beg Pardon ? ]') 
	else
	    lib$spawn(command) ;
    until (command = 'exit') ;
end.

