
PROCEDURE deletenode
           (VAR L : listtype ;
                p : listnodeptr );

VAR
    predecessor : listnodeptr ;

BEGIN
    predecessor := Findpred(L,p);
	IF ((not empty(L))) and (p <> nil)) THEN
	    BEGIN
		IF (p = L.head) THEN
		    BEGIN
			L.head := L.head^.next ;
			IF (L.head = nil) THEN
			    L.tail := nil ;
			L.cursor := nil ;
		    END 
		ELSE IF (p = L.tail) THEN
		    BEGIN
			L.tail := predecessor ;
			IF(L.tail = nil) THEN
			     L.head := nil
			ELSE 
			    L.tail^.next := nil
			L.cursor := L.tail^.next
		    END
		ELSE
		    predecessor^.next := p^.next ;
	DISPOSE (p) ;
    END ;
END ;  (* proc *)
