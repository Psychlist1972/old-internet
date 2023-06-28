$ ! Like, wow, man! This RADICAL show is like TOTALLY AWESOME!!!
$ ! And it was, like, programmed by:
$ !       Ed Sutherland
$ !
$ ! To like, use the program, EXTR/NOHE WAVE.SHO, then @WAVE.SHO
$ ! Surf's up, dude!
$ !
$Write :== type sys$input
$ ENOUGH=0
$ Write
 [2J(0
 [12;12H[5m#3CATCH A WAVE!!!
 [13;12H[5m#4CATCH A WAVE!!![0m
 [10;14H#6         o
 [10;14H#6        op
 [10;14H#6       opq
 [10;14H#6      opqr
 [10;14H#6     opqrs
 [10;14H#6    opqrss
 [10;14H#6   opqrssr
 [10;14H#6  opqrssrq
 [10;14H#6 opqrssrqp
$ WAVE:
$ Write
 [10;14H#6opqrssrqpo
 [10;14H#6pqrssrqpoo
 [10;14H#6qrssrqpoop
 [10;14H#6rssrqpoopq
 [10;14H#6ssrqpoopqr
 [10;14H#6srqpoopqrs
 [10;14H#6rqpoopqrss
 [10;14H#6qpoopqrssr
 [10;14H#6poopqrssrq
 [10;14H#6oopqrssrqp
$ ENOUGH=ENOUGH+1
$ IF ENOUGH .EQS. 10 THEN GOTO END
$ GOTO WAVE
$ END:
$ Write
 [10;14H#6opqrssrqpo
 [10;14H#6pqrssrqpo 
 [10;14H#6qrssrqpo  
 [10;14H#6rssrqpo   
 [10;14H#6ssrqpo    
 [10;14H#6srqpo     
 [10;14H#6rqpo      
 [10;14H#6qpo       
 [10;14H#6po        
 [10;14H#6o         
 [10;14H#6  
 (B
$ wait 00:00:02
$ Write
 [2J[H
$ EXIT
