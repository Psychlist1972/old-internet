{+----------------------------------------------------------------------+}
{|                                                                      |}
{|                                                                      |}
{|                     C a l e n d a r . p a s                          |}
{|                                                                      |}
{|                                                                      |}
{| Calendar.pas written by Peter M Brown ULowell 1991                   |}
{|                                                                      |}
{| Purpose :                                                            |} 
{|  provide an online appointment calendar program for the ULowell VAX  |}
{|                                                                      |}
{+----------------------------------------------------------------------+}

[inherit ('group$disk:[compsci]utilities',
	  'science$disk:[brownp.homework.91-101.modules]pas_utils',
	  'sys$library:starlet')]

{ the above defines the following :                                      }
{                                                                        }
{        NICE STRING VALID_FILE DATEANDTIME                              }
{        LIB$SPAWN                                                       }


Program personal_calendar(input,output) ;

var
    today	 : string ; { today's date             }
    time	 : string ; { the current time         }
    time_sig_str : string ; { AM, PM, noon or midnight }


[external (lib$spawn)]
function lib$spawn(command_string : [class_s] packed array[$l1..$u1:integer]
			 of char): unsigned;
external;


Procedure Spawn_dcl(command:string) ;
begin
    writeln('Spawning a DCL subprocess') ;
    lib$spawn(command)
end ;    


Function Nice (str : string) : string ;
begin
    stripleadingblanks(str) ;
    striptrailingblanks(str) ;
    nice := strlwr(str) ;
end ;


Procedure read_user_calendar ;

var
    calendar_file   : text ;
    calendar_date   : string ;
    todays_message  : string ;
    done	    : boolean ;


begin
    done := false ;

    if valid_file('CALENDAR.DAT') then 
	begin
	    open (calendar_file,'CALENDAR.DAT', history := old) ;
	    reset (calendar_file) ;
		while (not(eof(calendar_file))) and (not(done)) do
		    begin
			readln(calendar_file,calendar_date) ;
			readln(calendar_file,todays_message) ;

			if nice(calendar_date) = nice(today) then
			    begin
			        todays_message := todays_message + ' ' ;
				if todays_message[1] = '$' then 
				    spawn_dcl(todays_message)
				else
				    begin
					writeln('   And the note for today is - ') ;
					writeln(' ',todays_message) ;
					writeln ;
				    end ;
				done := true ;
			    end ;
		    end ;
	    close (calendar_file) ;
	    if (not(done)) then writeln('   Nothing important today.') ;
	end
    else
	begin
	    writeln('File open error: File CALENDAR.DAT is not in this directory') ;
	    writeln('Please move files around to avoid this error. --- The Psychlist') ;
	end ;
end ;


begin
    today	    := '' ;
    time	    := '' ;
    time_sig_str    := '' ;

    dateandtime(today,time,time_sig_str) ;
    
    writeln ;
    writeln('Today is: ',today,', and it is now ',time,' ',time_sig_str,'.') ;
    read_user_calendar ;    
    
end.
