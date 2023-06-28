[INHERIT('sys$library:starlet',
         'sys$library:pascal$lib_routines')]
PROGRAM Use_Find_File(INPUT,OUTPUT);

VAR
    File_Spec   : VARYING [132] OF CHAR;
    Result_Spec : VARYING [132] OF CHAR;
    Context     : UNSIGNED VALUE 0;
    Status      : UNSIGNED;

    BEGIN

    file_spec := '*.*' ;

    { Ask for file specification to parse }
    WRITE('Enter filespec to parse: ');
    WHILE ((NOT EOF) and (file_spec <> '')) DO
	    BEGIN

	    { Read the filespec from the user }
	    READLN(File_Spec);

	    IF file_spec <> '' THEN BEGIN
	    { Loop and parse the file spec }
	    REPEAT

		{ Since lib$find_file can handle both fixed-length  }
		{ strings passed by CLASS_S descriptor and	    }
		{ variable-length strings passed by CLASS_VS	    }
		{ descriptor, the definition in			    }
		{ pascal$lib_routines.pas defines the parameter as  }
		{ passed by CLASS_S descriptor.  Since		    }
		{ lib$find_file does not have a return length word  }
		{ parameter, we are unable to use the VARYING.BODY  }
		{ and VARYING.LENGTH technique used with other VMS  }
		{ routines.  In order to generate a CLASS_VS	    }
		{ descriptor, we will use a foreign mechanism	    }
		{ specifier on the actual parameter.  This	    }
		{ overrides the formal parameter and generates the  }
		{ correct descriptor.				    }

                Status   := lib$find_file(
		    File_Spec,
		    %DESCR Result_Spec, { Use %DESCR to get CLASS_VS }
		    Context);


		IF (NOT ODD(Status)) AND 
		   (Status <> RMS$_NMF) AND
		   (Status <> RMS$_FNF)
		THEN
		    LIB$Stop(Status);

		IF (Status <> RMS$_NMF) AND
		   (Status <> RMS$_FNF)
		THEN
		    WRITELN(Result_Spec);

	    UNTIL (Status = RMS$_NMF) OR (Status = RMS$_FNF);

	    { Clear lib$find_file context }
	    lib$find_file_end(Context);

	    { Get another file spec }
	    WRITE('Enter filespec to parse: ');

	    END ; (* if file_spec <> '' then *)
	    END;
    END.
