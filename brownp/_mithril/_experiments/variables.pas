{+---------------------------------------------------------------+}
{|                                                               |}
{|                    T i m e   R i f f t e                      |}
{|                                                               |}
{|                      v a r i a b l e s                        |}
{|                                                               |}
{|                  v2.00 for use with VAX/VMS                   |}
{|                                                               |}
{|                       By Peter M Brown                        |}
{|                         Ulowell 1991                          |}
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

[environment ('variables.pen'),
    inherit('comp$dir:utilities.pen')]

Module Variables_pas(input,output);

const
    prompt ='> ' ;          { the prompt the user sees asking for input  }
    max_inv = 100 ;         { maximum number of inventory slots          }
    version = 2.00 ;         { the version number of this program         }
    max_block_size = 12 ;   { max number of lines in a description block }
    max_objs = 50 ;         { max objects in the game                    } 
    max_rooms = 200 ;       { maximum number of rooms in the game        }
    max_word  = 50 ;  	    { the number of characters in a 'WORD'       }
    max_synonyms = 200 ;    { the maximum number of synonyms in the game }
    max_messages = 2000 ;   { the number of messages you can have        }
    start_room = 5 ;	    { the room you are first located in          }
    default_message = 1100 ;{ default exit failure message               }
    help_message = 1800 ;   { the user help message                      }
    wd_count = 80 ;         { maximum number of words in a string        }

{ below this are the actual game roots }

    vocab_file   = 'science$disk:[brownp._mithril]vocab.dat' ;
    synonym_file = 'science$disk:[brownp._mithril]synonyms.dat' ;
    room_file    = 'science$disk:[brownp._mithril]rooms.dat' ;
    object_file  = 'science$disk:[brownp._mithril]objects.dat' ;
    message_file = 'science$disk:[brownp._mithril]messages.dat' ;
    monster_file = 'science$disk:[brownp._mithril]monsters.dat' ;
    user_file    = 'science$disk:[brownp._mithril]__players.out' ;

type
    loop_index = INTEGER ;

    line = varying[85]of char;
    word = varying[max_word]of char;
    block = array[1..max_block_size]of line;
    synonym_rec = record
		the_word : word ;	  { the actual synonym             }
		index	 : integer ;      { the object it refers to        }
	    end; { synonym_rec }

    object_rec = record
		label_desc   : integer;   { the You_see_here description    }
		description  : integer;   { the LOOK AT description         }  
		oget1	     : integer;   { objects required for getting    }
		oget2	     : integer;   { if empty, then not needed to get}
		get_success  : integer;   { print this if object is taken   }
		get_failure  : integer;	  { print this if you cant take it  }
		weight	     : integer;   { weight in units of this item    }
		kind	     : integer;   { see READ_OBJECT_FILE for info   }
		score        : integer;   { the number of points its worth  }
		open	     : boolean ;  { if it is a bag only             }
		put_in_bag   : boolean ;  { can it be put in a bag ?        }
		contents     : array [1..10] of integer ;
					  { above for bag only              }
		name	     : word;	  { the name displayed in your inv  }
	     end; {object record}

    room_rec = record
		    verbose_desc : integer; { the long, or BLOCK description  }
		    brief_desc   : integer; { the BRIEF, one line descrip.    }
		    exit_north   : integer; { the following variables use     }
		    exit_south   : integer; { this concept:  If there is an   }
		    exit_east    : integer; { exit in the direction that the  }
		    exit_west	 : integer; { variable represents, the number }
		    exit_up      : integer; { will represent the room number  }
		    exit_down	 : integer; { if there is NO exit there, the  }
		    exit_nw	 : integer; { number will be the NEGATIVE     }
		    exit_sw      : integer; { of teh failure description num. }
		    exit_ne	 : integer; { there4 if POS then exit=y if neg}
		    exit_se	 : integer; { then exit = n                   }
		    sky		 : boolean; { can I see the sky from here ?   }
			    
					    { the following variables keep    }
					    { track of the special commands   }
					    { local to that room, the message }
					    { to print (or procedure number)  }
					    { the number of objects, monsters }
					    { and other garbage of the floor  }
		    cmd		 : array[1..10]of word;
		    message	 : array[1..10]of integer;
		    objects	 : array[1..20]of integer;
		    monsters	 : array[1..20]of integer;
		    
	       end; {room_rec}


    player_rec = record
		score        : integer; { points accumulated     }
		strength     : integer; { maximum strength       }
		max_weight_slots : integer; { max # of poundage  }
		weight_slots : integer; { how much you can carry }
		inventory    : array [1..max_inv] of integer;
					{ what you are carrying  }
		num_moves    : integer; { how many moves         }
		health	     : integer ;{ hitpoints              }
		shat	     : boolean ;{ for comic releif only }
				
	     end; { player record }
	  
    message_array = array [1..max_messages] of block ;   


var
    obj          : array [1..max_objs] of object_rec ;
    room         : array [1..max_rooms] of room_rec ;
    synonym	 : array [1..max_synonyms] of synonym_rec ;
    me           : player_rec ;
    s            : string ;  { text_line read in from the user }
    debug        : boolean ;
    system       : boolean ;
    current_room : integer ;
    verbose      : boolean ;
    message      : message_array ;
    hour	 : integer ;
    minute	 : integer ;
    sit		 : boolean ; { whether or not you are sitting down }
    nice_wd 	 : array [1..wd_count] of word ;
    wd		 : array [1..wd_count] of word ;
    line_counter   : integer ; { used to keep screen from scrolling away }

end.



