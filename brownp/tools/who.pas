program who(output,who);
{******************************************************************************
 *******          This small program is designed to clean up those    	*******
 *******      ugly show user outputs that most people are useing.  have *******
 *******      fun with it and fix it up all you want.                   *******
 *******      								*******
 *******                 Writen by Douglas l Smith			*******
 ******************************************************************************}

type 
	string = varying[80] of char;
	shortstring = varying[12] of char;
var
	who: text;
	person: integer;
	done,next : boolean;
	line,line1,line2,line3,line4: string;
	name: shortstring;
	where: integer;
	first: boolean;
	more : boolean;
begin
	reset(who);
	readln(who,line1);
	readln(who,line2);
	readln(who,line3);
	readln(who,line4);
	person := 1;
	done := false;
	first := true;
	next := false;
	repeat
		if not(next) then	{ next = false }
			reset(who);
		next := false;
		case person of
			 1: name := 'ALBERTIP' ;	{ place all the people }
			 2: name := 'BASSFORDJ' ;	{ that you want to show}
			 3: name := 'BENNETTC' ;
			 4: name := 'BROWNP' ;		{ up on your show users}
			 5: name := 'CAMPBELLE' ;	{ list in this case }
			 6: name := 'CASEYSU' ;  	{ statement in order }
			 7: name := 'CASHMANR' ;	{ you are not limited }
			 8: name := 'COILLM' ;		{ to the 11 slots that }
			 9: name := 'CORREAA' ;
			10: name := 'DUFFYPH' ;
			11: name := 'FLAHIVEL' ;
			12: name := 'FOSTERLY' ;
			13: name := 'FROSTS' ;
			14: name := 'GAMES' ;
			15: name := 'GMNGR4' ;
			16: name := 'GOVEM' ;
			17: name := 'HEINESJ' ;
			18: name := 'HERTEI' ;
			19: name := 'KELLEYKR' ;
			20: name := 'KINGKA' ;
			21: name := 'LEDDERW' ;
			22: name := 'LEWISH' ;
			23: name := 'MACKINJ' ;
			24: name := 'NUTTALLC' ;
			25: name := 'ORTHM' ;
			26: name := 'POPLAWSKC' ;
			27: name := 'PURWINC' ;
			28: name := 'ROTONDOJ' ;
			29: name := 'SABOTKAP' ;
			30: name := 'SMITHD' ;
			31: name := 'WHITEDA' ;
			32: name := 'WINIKA' ;

		otherwise
			done := true;
		end;
		while (not(done) and not(eof(who)) and (not next)) or (more) do begin
			readln(who,line);
			where := index(line,name);
			if (where > 1) and (where < 20) then begin
				if first then begin
					writeln;
					writeln(line1);
					writeln(line2);
					writeln(line3);
					writeln('But these people actually matter...') ;
					writeln;
					writeln(line4);
					writeln;
					first := false;
				end;
				more := true;		{ maybe more processes}
				writeln(line);

				line := substr (line,43,line.length-44) ;

				IF INDEX(line, 'TNA') > 0 THEN
				    BEGIN
					READLN(who,line);
					WRITELN (line) ;
				    END ;
			end else if more then begin		{ no more processes }
				next := true;
				more := false;
			end;
		end;
		person := person + 1;
	until done;
	writeln
end.
