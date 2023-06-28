!                          D I R 2 . C O M
!
!                Written By Peter M Brown ULowell 1991
!
!
!
$ @science$disk:[brownp.public]write.file "dir2"
$ 
$
$on severe_error then continue
$on error then continue
$
$BEGIN:
$
$     dir/exclude = (.pmb)/output = sys$login:666766dir_file_data.pmb 'p1'
$
$     set prot = (w:rwed,o:rwed,g:rwed,s:rwed) sys$login:666766dir_file_data.pmb;*
$     type/page sys$login:666766dir_file_data.pmb
$     delete/noconfirm sys$login:666766dir_file_data.pmb;*
$    
$
$exit
