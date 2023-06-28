
begin:
	input "Name of file to scramble              ";read_name$
	input "Call the scrambled version            ";write_name$
	input "code key (+# for encode) (-# for decode)";code
        open read_name$ for input as file 1
	open write_name$ for output as file 2, recordsize 80
	on error goto err_han
loop_1:
 	input line #1,a$
loop_2:
	n$=space$(len(a$))
	t$=""
	t=0
	for x=0 to len(a$)
		t$=seg$(a$,x,x)
		t=ascii(t$)
			if t<33 or t>255-abs(code) then t$=chr$(t)
			 else t$=chr$(t+code)
			end if
		mid$(n$,x,x)=t$
	next x
	print #2,seg$(n$,1,80)
goto  loop_1
err_han:
	close 1,2
resume ender
ender:
