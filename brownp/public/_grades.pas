program chameleon(input,output);

var	grades:array [1..50] of real;
	fin,ave,gn:real;
	i,t:integer;
procedure clear;	
	var i:integer;
	begin
	i:=0;
	for i:=1 to 24 do writeln;
        end;


	begin
	clear;
	writeln('This program will figure out what your next score on');
	writeln('your next major test has  to be in order to get an ave');
	writeln('that you specify');
	writeln('ex:');
	writeln('Grade1=50 grade2=60 grade3=?  ave=70');
	writeln('grade3 has to be a 80');
	writeln('okay now input');
	write('how many previous grades ->');
	read(t);

	        for i:=1 to t do begin
	         write('input grade',i,'---==*> ');
	         read(grades[i]);
        	end;
	writeln;write('enter average you want ');
	read(ave);
	fin:=0;
	 	for i:=1 to t do 
	   	 fin:=fin+grades[i];
	gn:=(ave*(t+1))-fin;
	writeln;
	writeln('Your next grade ---==*> ',round(gn));
	
	
	end.
