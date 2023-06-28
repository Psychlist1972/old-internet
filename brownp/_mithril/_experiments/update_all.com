$ copy riffte_2.* [-]time_riffte.*
$ set prot = (w:re) [-]time_riffte.*
$ w "Time Riffte executable, object, pascal amd diagnostic files copied"
$ copy variables.* [-]*
$ w "Variables environment, object, pascal amd diagnostic files copied"
$ copy vocab.dat [-]*
$ w "Vocab.dat copied"
$ set prot = (w:re) [-]*.dat
$ purge [-]
$ purge
$ w "directories purged"
$ w " "
$ w "Update complete..."
