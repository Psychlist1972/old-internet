Procedure DeleteNode (VAR L : listype; p : nodeptr);

VAR
    pred : nodeptr ;

BEGIN
    pred := findpred (L,p) ;

    IF (NOT(list_empty (L)) AND (p<>NIL)) THEN
	BEGIN
	    IF (p = L.head) THEN
		BEGIN
		    L.head := L.head^.next ;
		    IF (L.head = NIL) THEN
			L.tail :=NIL ;
		    L.cursor := L.head ;
		END
	    ELSE
		BEGIN
		    IF (p = L.tail) THEN
			L.tail := pred ;
		    IF (L.tail= NIL) THEN
			L.head := NIL
		    ELSE
			L.tail ^.next := NIL ;
		    L.cursor := L.tail^.next ;
		END
	    ELSE
		pred^.next := p^.next ;
	DISPOSE (p) ;
    END ;
END ;
    

