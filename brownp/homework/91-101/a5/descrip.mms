!
plot_graph.exe : plot_graph.obj
	link plot_graph, -
		[brownp.homework.91-101.modules]pas_utils, -
		group$disk:[compsci]utilities, -
		group$disk:[compsci]vt100
	if f$search("plot_graph.exe") .NES. "" then purge plot_graph.exe
plot_graph.obj : plot_graph.pas
	pas/list/analyze plot_graph
	if f$search("*.ana") .NES. "" then purge *.ana
	if f$search("*.obj") .NES. "" then purge *.obj
!
