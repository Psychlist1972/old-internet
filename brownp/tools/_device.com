$ set def electrical$disk
$ s " "
$ s "			  E L E C T R I C A L   D I S K"
$ S " "
$ show dev/files
$ set def science$disk
$ s " "
$ s "  			     S C I E N C E   D I S K"
$ S " "
$ show dev/files
$ set def engineering$disk
$ s " "
$ s "			  E N G I N E E R I N G   D I S K"
$ S " "
$ show dev/files
$ set def libarts$disk
$ s " "
$ s "			     L I B A R T S   D I S K"
$ S " "
$ show dev/files
$ set def music$disk
$ s " "
$ s "			       M U S I C   D I S K"
$ S " "
$ show dev/files
$ set def management$disk
$ s " "
$ s "			M A N A G E R M E N T   D I S K"
$ S " "
$ show dev/files
$ set def education$disk
$ s " "
$ s "			   E D U C A T I O N   D I S K"
$ S " "
$ show dev/files
$ set def dce$disk
$ s " "
$ s "			         D C E  D I S K"
$ S " "
$ show dev/files
$ set def sys$login
$ exit
