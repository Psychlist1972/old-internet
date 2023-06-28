[ENVIRONMENT, INHERIT ('comp$dir:utilities',
		       'comp$dir:vt100') ]

MODULE link_defs (INPUT,OUTPUT) ;

TYPE 
    datatype = char ;




PROCEDURE write_data(
    data    : char) ;

BEGIN
    cputs(data) ;
END ;



END. { module link_defs }
