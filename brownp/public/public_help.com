!
!
!                               Module
!                    P u b l i c _ h e l p . c o m 
!
!                            Peter M Brown
!                            ULowell  1991
!
!Note: I know It would have been easier to use data files for this, but then 
!      I run in locked files and only one person an use it at a time etc...
!
!
$On error then goto ERROR
$on severe_error then goto error
$on warning then goto error
$ on control_y then goto error
$
$ @science$disk:[brownp.public]write.file
$
$ w :== "write sys$output"
$
$!    choice = p1
$PARAMETERS:
$!    if choice .NES. "" then goto BEGIN
$!    goto 'CHOICE'
$!    exit
$
$BEGIN:
$ CLEAR
$
$
$ w "       +---------------------------------------------------------------+"
$ w "       |                                                               |" 
$ w "       |        Help utility for SCIENCE$DISK:[BROWNP.PUBLIC]          |"
$ w "       |                                                               |"
$ w "       |  Substitute a '_' for the '.' in the file name.               |"
$ w "       |  Example:                                                     |"
$ w "       |    to get help on BRIAN.PYT, type BRIAN_PYT at the prompt     |"
$ w "       |                                                               |"
$ w "       +---------------------------------------------------------------+"
$ w " "
$ w "   Type name of file, press <RETURN> for directory listing or QUIT to leave."
$ inquire/nopunct CHOICE " Choice >>> "
$ w " "
$ w " "
$ choice = f$edit(choice,"trim,upcase")
$ if choice .EQS. "" then goto DIR_LIST 
$ if choice .EQS. "QUIT" then exit
$ goto 'choice'
$
$DIR_LIST:
$  dir
$goto CONTINUE
$
$12LETTERS_TXT:
$    w " "      
$    w "Category    -  Humor"
$    w "Actual Name -  The 12 Letters of Christmas."
$    w "To access   -  $ TYPE/PAGE 12LETTERS.TXT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$exit
$
$1990_REV:          
$    w " "      
$    w "Category    -  Humor"
$    w "Actual Name -  1990 The year in Review."
$    w "To access   -  $ TYPE/PAGE 1990.REV"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$exit
$
$ARCHITEC_PYT:      
$    w " "      
$    w "Category    -  Humor"
$    w "Actual Name -  The Architect Sketch by Monty Python."
$    w "To access   -  @ARCHIVE PYTHON0 ARCHITEC.PYT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$exit
$
$ARGUMENT_PYT:     
$    w " "      
$    w "Category    -  Humor"
$    w "Actual Name -  The Argument Sketch by Monty Python."
$    w "To access   -  @ARCHIVE PYTHON0 ARGUMENT.PYT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$exit
$
$ASCII_TXT:         
$    w " "      
$    w "Category    -  Reference Material"
$    w "Actual Name -  ASCII Code list"
$    w "To access   -  $ TYPE/PAGE ASCII.TXT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$exit
$
$ASSOCIAT_PYT:      
$    w " "      
$    w "Category    -  Humor"
$    w "Actual Name -  The Associate Sketch by Monty Python"
$    w "To access   -  @ARCHIVE PYTHON0 ASSOCIAT.PYT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$exit
$
$BANTER_PYT:        
$    w " "      
$    w "Category    -  Humor"
$    w "Actual Name -  ? by Monty Python"
$    w "To access   -  @ARCHIVE PYTHON0 BANTER.PYT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$exit
$
$BARBER_PYT:       
$    w " "      
$    w "Category    -  Humor"
$    w "Actual Name -  The Barber shop sketch by Monty Python"
$    w "To access   -  @ARCHIVE PYTHON0 BARBER.PYT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$BED_PYT:           
$    w " "      
$    w "Category    -  Humor"
$    w "Actual Name -  The Buying-A-Bed sketch by Monty Python"
$    w "To access   -  @ARCHIVE PYTHON0 BED.PYT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$BEER_SHO:          
$    w " "      
$    w "Category    -  Graphics"
$    w "Actual Name -  This Bud's for you"
$    w "To access   -  $ TYPE BEER.SHO "   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$BIGNOSE_PYT:       
$    w " "      
$    w "Category    -  Humor"
$    w "Actual Name -  The Bignose sketch by Monty Python (From The Life of Brian)"
$    w "To access   -  @ARCHIVE PYTHON0 BIGNOSE.PYT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$BISHOP_PYT:       
$    w " "      
$    w "Category    -  Humor"
$    w "Actual Name -  The Dead Bishop sketch by Monty Python"
$    w "To access   -  @ARCHIVE PYTHON0 BISHOP.PYT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$BLCKMAIL_PYT:      
$    w " "      
$    w "Category    -  Humor"
$    w "Actual Name -  The Blackmail Gameshow sketch by Monty Python"
$    w "To access   -  @ARCHIVE PYTHON0 BLCKMAIL.PYT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$BODY_PYT:          
$    w " "      
$    w "Category    -  Humor"
$    w "Actual Name -  The amount of time to perform a function"
$    w "To access   -  @ARCHIVE PYTHON0 BODY.PYT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$BOOKSHOP_PYT:      
$    w " "      
$    w "Category    -  Humor"
$    w "Actual Name -  The Bookshop sketch by Monty Python"
$    w "To access   -  $ @ARCHIVE PYTHON0 BOOKSHOP.PYT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$BRAINCEL_PYT:     
$    w " "      
$    w "Category    -  Humor"
$    w "Actual Name -  ? by Monty Python"
$    w "To access   -  @ARCHIVE PYTHON0 BRAINCEL.PYT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$BRIAN_PYT:         
$    w " "      
$    w "Category    -  Humor"
$    w "Actual Name -  ? by Monty Python"
$    w "To access   -  @ARCHIVE PYTHON0 BRIAN.PYT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$BRIDGE_PYT:        
$    w " "      
$    w "Category    -  Humor"
$    w "Actual Name -  The Bridge of Death scene by Monty Python"
$    w "To access   -  @ARCHIVE PYTHON0 BRIDGE.PYT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$BRIGHT_PYT:        
$    w " "      
$    w "Category    -  Humor"
$    w "Actual Name -  The ending song from the Life of Brian by Monty Python"
$    w "To access   -  @ARCHIVE PYTHON0 BRIGHT.PYT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$BRUCE_PYT:        
$    w " "      
$    w "Category    -  Humor"
$    w "Actual Name -  The Bruce's song by Monty Python"
$    w "To access   -  @ARCHIVE PYTHON0 BRUCE.PYT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$BULL_COM:          
$    w " "      
$    w "Category    -  Graphics/Humor"
$    w "Actual Name -  The dying cow"
$    w "To access   -  $ @ BULL.COM"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$CHRISTMAS_SHO     
$    w " "      
$    w "Category    -  Graphics"
$    w "Actual Name -  VAXGraphic Christmas Card"
$    w "To access   -  $ TYPE CHRISTMAS.SHO"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$CITY_SHO:          
$    w " "      
$    w "Category    -  Graphics"
$    w "Actual Name -  The Horizon of NY"
$    w "To access   -  $ TYPE CITY.SHO"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$CONFERENCE_LOG:   
$    w " "      
$    w "Category    -  Specialized utility"
$    w "Actual Name -  Log file for Peter Brown's TALK program (not yet avail.)"
$    w "To access   -  no access"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$COW_SHO:           
$    w " "      
$    w "Category    -  Humor"
$    w "Actual Name -  The cow thingy"
$    w "To access   -  $ TYPE COW.SHO"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$DESCRIP_MMS:       
$    w " "      
$    w "Category    -  Specialized utility"
$    w "Actual Name -  File used to compile and link SEX2.PAS"
$    w "To access   -  no access"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$DRAGONLANCE_QUERY: 
$    w " "      
$    w "Category    -  Questionairre"
$    w "Actual Name -  Dragonlance Campaign Questionairre by Derek Dalise"
$    w "To access   -  copy it into your account"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$DRAGONSHOOT_COM:  
$    w " "      
$    w "Category    -  Graphics/Humor"
$    w "Actual Name -  Variation on BULL.COM, using a dragon"
$    w "To access   -  $ @ DRAGONSHOOT.COM"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$DRAGON_LUNKS_TXT:  
$    w " "      
$    w "Category    -  Humor"
$    w "Actual Name -  Dragonlunks Cartoon by J. Jarvis"
$    w "To access   -  $ TYPE/PAGE DRAGON_LUNKS.TXT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$DRAGON_LUNKS2_TXT: 
$    w " "      
$    w "Category    -  Humor"
$    w "Actual Name -  Dragonlunks Cartoon by J. Jarvis"
$    w "To access   -  $ TYPE/PAGE DRAGON_LUNKS2.TXT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$DUNGEON_TXT:       
$    w " "      
$    w "Category    -  Humor"
$    w "Actual Name -  10 reasons CS majors like to Spend all night in the Dungeon"
$    w "To access   -  $ TYPE/PAGE DUNGEON.TXT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$ESCAPE_SHO_COM:   
$    w " "      
$    w "Category    -  Graphics"
$    w "Actual Name -  ?"
$    w "To access   -  $ @ ESCAPE_SHO.COM"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$ESC_CODES_COM:    
$    w " "      
$    w "Category    -  Utility"
$    w "Actual Name -  Escape code definition program"
$    w "To access   -  $ @ ESC_CODES.COM"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$ESC_CODES_TXT:     
$    w " "      
$    w "Category    -  Reference Material"
$    w "Actual Name -  Escape Code values"
$    w "To access   -  $ TYPE/PAGE ESC_CODES.TXT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$FACES_TXT:         
$    w " "      
$    w "Category    -  Humor"
$    w "Actual Name -  Computer Faces by Ed Sutherland"
$    w "To access   -  $ TYPE/PAGE FACES.TXT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$FIREWORKS_SHO:    
$    w " "      
$    w "Category    -  Graphics/Humor"
$    w "Actual Name -  VAXGraphics Fireworks display"
$    w "To access   -  $ TYPE FIREWORKS.SHO"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$GAMES_SHO_COM:     
$    w " "      
$    w "Category    -  Graphics"
$    w "Actual Name -  Save the Games by Ed Sutherland"
$    w "To access   -  $ @ GAMES_SHO.COM"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$HOLY_GRAIL_PYT:    
$    w " "      
$    w "Category    -  Humor"
$    w "Actual Name -  Transcription to the Holy Grail by Monty Python"
$    w "To access   -  @ARCHIVE PYTHON0 H_GRAIL.PYT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$HOTEL_WANNA_TXT:  
$    w " "      
$    w "Category    -  Humor"
$    w "Actual Name -  Hotel Wannalancit by John Mackin"
$    w "To access   -  $ TYPE/PAGE HOTEL_WANNA.TXT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$LED_ZEP_COM:       
$    w " "      
$    w "Category    -  Graphics"
$    w "Actual Name -  Led Zepplin Display"
$    w "To access   -  $ @ LED_ZEP.COM"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$LOGIN_HELP_TXT:    
$    w " "      
$    w "Category    -  Utility"
$    w "Actual Name -  Help file for _LOGIN.COM by Peter Brown"
$    w "To access   -  $ TYPE/PAGE LOGIN_HELP.TXT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$MERRY_SHO:        
$    w " "      
$    w "Category    -  Graphics"
$    w "Actual Name -  VAXGraphics Christmas Card"
$    w "To access   -  $ TYPE MERRY.SHO"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$MORE_COW:          
$    w " "      
$    w "Category    -  Humor"
$    w "Actual Name -  More of that Cow thingy"
$    w "To access   -  $ TYPE/PAGE MORE.COW"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$MUDLISTING_TXT:    
$    w " "      
$    w "Category    -  Reference Material"
$    w "Actual Name -  Listing of all Internet MUD sights to date"
$    w "               ULowell does not allow the use of TELNET to play MUDs"
$    w "To access   -  $ TYPE/PAGE MUDLISTING.TXT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$PATRIOTS_JOKE_TXT:
$    w " "      
$    w "Category    -  Humor"
$    w "Actual Name -  Patriots Season Schedule"
$    w "To access   -  $ TYPE/PAGE PATRIOTS_JOKE.TXT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$POEM_COM:          
$    w " "      
$    w "Category    -  Poem"
$    w "Actual Name -  Dreamstalker"
$    w "To access   -  $ @ POEM.COM"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$PUBLIC_HELP_COM:   
$    w " "      
$    w "Category    -  Utility"
$    w "Actual Name -  Public Directory Help Program by Peter Brown"
$    w "To access   -  You are using it right now."   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$RANK_ON_TREK_TXT:  
$    w " "      
$    w "Category    -  Humor"
$    w "Actual Name -  Typical Star Trek Episode by MAHERB "
$    w "To access   -  $ TYPE/PAGE RANK_ON_TREK.TXT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$RASTHOS_COM:      
$    w " "      
$    w "Category    -  Useless"
$    w "Actual Name -  Example of a Logoff Screen - Peter Brown"
$    w "To access   -  $ @ RASTHOS.COM"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$RASTHOS2_COM:      
$    w " "      
$    w "Category    -  Useless"
$    w "Actual Name -  Example of a Logoff Screen - Peter Brown"
$    w "To access   -  $ @ RASTHOS2.COM"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$RE1_COM:           
$    w " "      
$    w "Category    -  Useless"
$    w "Actual Name -  DUMMY FILE use _RE1.COM"
$    w "To access   -  n/a"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$RICHARD_CORY_POEM 
$    w " "      
$    w "Category    -  Poem"
$    w "Actual Name -  Richard Cory"
$    w "To access   -  $ TYPE/PAGE RICHARD_CORY.POEM"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$RICH_CORY_EXE:    
$    w " "      
$    w "Category    -  Poem"
$    w "Actual Name -  Richard Cory converted to pascal using CONVERT.COM"
$    w "To access   -  $ RUN RICHARD_CORY"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$RICH_CORY_PAS:     
$    w " "      
$    w "Category    -  Poem"
$    w "Actual Name -  Richard Cory converted to pascal using CONVERT.COM"
$    w "To access   -  $ TYPE/PAGE RICHARD_CORY.PAS"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$RUN__THIS__ALWAYS_COM:                 
$    w " "      
$    w "Category    -  Utility"
$    w "Actual Name -  File allowing you Acces to this directory"
$    w "To access   -  $ @science$disk:[brownp.public]run__this__always"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$SCHEDULE_TXT:     
$    w " "      
$    w "Category    -  Useless"
$    w "Actual Name -  Like any of you care what my schedule is"
$    w "To access   -  $ TYPE/PAGE SCHEDULE.TXT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$SCREEN_SAV_EXE:    
$    w " "      
$    w "Category    -  Utility"
$    w "Actual Name -  VAXBASIC Screen Saver, used to save the screen from burnung in."
$    w "To access   -  $ RUN SCREEN_SAV"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$SET_DEF_COM:       
$    w " "      
$    w "Category    -  Useless"
$    w "Actual Name -  DUMMY FILE"
$    w "To access   -  See _SET_DEF.COM"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$SEX_USES:          
$    w " "      
$    w "Category    -  Humor"
$    w "Actual Name -  101 Uses for sex"
$    w "To access   -  $ TYPE/PAGE SEX.USES"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$SEX2_EXE:         
$    w " "      
$    w "Category    -  Sick Humor"
$    w "Actual Name -  Very sick sex paragraphs program created by Peter Brown"
$    w "To access   -  $ RUN SEX2"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$SEX2_PAS:          
$    w " "      
$    w "Category    -  Sick Humor"
$    w "Actual Name -  Very sick sex paragraphs program created by Peter Brown"
$    w "To access   -  $ TYPE/PAGE SEX2.PAS"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$SEX_GAMES_TXT:     
$    w " "      
$    w "Category    -  Humor"
$    w "Actual Name -  Outline to The game 'Dare'"
$    w "To access   -  $ TYPE/PAGE SEX_GAMES.TXT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$SEX_TEST_TXT:      
$    w " "      
$    w "Category    -  Humor"
$    w "Actual Name -  The Purity test, updated"
$    w "To access   -  $ TYPE/PAGE SEX_TEST.TXT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$SIMPSONS_SHO:     
$    w " "      
$    w "Category    -  Humor"
$    w "Actual Name -  The Simpsons, what else can be said?"
$    w "To access   -  $ TYPE SIMPSONS.SHO"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$SNAPPA_POEM:       
$    w " "      
$    w "Category    -  Poem"
$    w "Actual Name -  Poem submitted by Sue Casey"
$    w "To access   -  $ TYPE/PAGE SNAPPA.POEM"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$SUBLOGIN_COM:      
$    w " "      
$    w "Category    -  Utility"
$    w "Actual Name -  Standard Subdirectory Login Program"
$    w "To access   -  none"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$SUTHERLAE_POEM:    
$    w " "      
$    w "Category    -  Poem"
$    w "Actual Name -  Another Poem submitted by Edward Sutherland"
$    w "To access   -  $ TYPE/PAGE SUTHERLAE.POEM"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$SWEAR_SHO_COM:    
$    w " "      
$    w "Category    -  Graphics/Humor"
$    w "Actual Name -  Vulgar attempt at Humor by Ed Sutherland"
$    w "To access   -  $ @ SWEAR_SHO.COM"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$TELL_COM:          
$    w " "      
$    w "Category    -  Utility"
$    w "Actual Name -  n/a"
$    w "To access   -  n/a"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$TREE_COM:          
$    w " "      
$    w "Category    -  Utility"
$    w "Actual Name -  Directory tree, USE THIS IN YOUR HOME DIRECTORY."
$    w "To access   -  @ SCIENCE$DISK:[BROWNP.PUBLIC]TREE"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$TWILITE_ZON:       
$    w " "      
$    w "Category    -  Graphics"
$    w "Actual Name -  The Twilite Zone (Dont Use CONTROL-Y!!!)"
$    w "To access   -  $ TYPE TWILITE.ZON"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$TYPE_ME_TXT:      
$    w " "      
$    w "Category    -  Utility"
$    w "Actual Name -  The Bulletin Board used by RUN__THIS__ALWAYS.COM"
$    w "To access   -  $ @RUN__THIS__ALWAYS.COM then select BULLETIN BOARD."   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$WATER_EXE:         
$    w " "      
$    w "Category    -  Graphics"
$    w "Actual Name -  Water ripling across the screen"
$    w "To access   -  $ RUN WATER"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$WAVE_SHO_COM:      
$    w " "      
$    w "Category    -  Graphics"
$    w "Actual Name -  Water ripling across the screen"
$    w "To access   -  $ @ WAVE_SHO.COM"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$WRITE_FILE:       
$    w " "      
$    w "Category    -  Specialized Utility"
$    w "Actual Name -  Utility called by all BROWNP.PUBLIC programs"
$    w "To access   -  none"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$_ALARM_CLOCK_COM: 
$    w " "      
$    w "Category    -  Utility"
$    w "Actual Name -  Alarm Clock"
$    w "To access   -  
$    w "spawn/process="alarm"/nolog/nowait @_ALARM_CLOCK <a time> <FLASH BEEP or BOTH>"
$    w "               note: The time is on a 24 hour scale  
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$_CALCULATOR_COM:   
$    w " "      
$    w "Category    -  Utility"
$    w "Actual Name -  Infix calculating Program"
$    w "To access   -  $ @ _CALCULATOR"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$_CALCULATOR_EXE:   
$    w " "      
$    w "Category    -  Utility"
$    w "Actual Name -  Infix calculating Program"
$    w "To access   -  $ @ _CALCULATOR"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$_CALCULATOR_PAS:   
$    w " "      
$    w "Category    -  Utility"
$    w "Actual Name -  Infix calculating Program"
$    w "To access   -  $ TYPE/PAGE CALCULATOR.PAS"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$_CALENDAR_COM:    
$    w " "      
$    w "Category    -  Utility"
$    w "Actual Name -  Calerdar Generator"
$    w "To access   -  $ @ _CALENDAR"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$_CD_COM:           
$    w " "      
$    w "Category    -  Useless"
$    w "Actual Name -  DUMMY FILE"
$    w "To access   -  none"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$_CLS_EXE:          
$    w " "      
$    w "Category    -  Utility"
$    w "Actual Name -  Screen wipe from Bottom to top"
$    w "To access   -  $ RUN _CLS"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$_COMMANDS_COM:     
$    w " "      
$    w "Category    -  Utility"
$    w "Actual Name -  An example of popular command definitions"
$    w "To access   -  TYPE/PAGE COMMANDS.COM"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$_CONVERT_COM:     
$    w " "      
$    w "Category    -  Utility"
$    w "Actual Name -  Convert Text file to Pascal or DCL"
$    w "To access   -  $ @ _CONVERT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$_DRAW_EXE:         
$    w " "      
$    w "Category    -  Utility/Graphics/Fun"
$    w "Actual Name -  VAXGraphics Drawing utility"
$    w "To access   -  $ RUN _DRAW"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$_GRADES_PAS:       
$    w " "      
$    w "Category    -  Utility"
$    w "Actual Name -  Figures out averages"
$    w "To access   -  $ RUN _GRADES.PAS"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$_GRA_OFF_TXT:      
$    w " "      
$    w "Category    -  Utility"
$    w "Actual Name -  Turns Graphics Mode OFF"
$    w "To access   -  $ TYPE _GRA_OFF.TXT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$_GRA_ON_TXT:      
$    w " "      
$    w "Category    -  Utility"
$    w "Actual Name -  Turns Graphics Mode ON"
$    w "To access   -  $ @ TYPE _GRA_ON.TXT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$_JCLOCK_EXE:       
$    w " "      
$    w "Category    -  Utility"
$    w "Actual Name -  JClock Spawned timekeeper"
$    w "To access   -  "spawn/process="The_Time"/nolog/nowait run _Jclock"
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$_JITTER_COM:       
$    w " "      
$    w "Category    -  Useless/Fun"
$    w "Actual Name -  Makes the screen shake around"
$    w "To access   -  $ @ _JITTER"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$_KEYPAD_COM:       
$    w " "      
$    w "Category    -  Utility"
$    w "Actual Name -  Example of Common Keypad definitions."
$    w "To access   -  $ TYPE/PAGE _KEYPAD.COM"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$_LOGIN_COM:       
$    w " "      
$    w "Category    -  Utility"
$    w "Actual Name -  Program allowing you acces to all my stuff."
$    w "To access   -  Put this line in your login.com:"
$    w "               $ @science$disk:[brownp.public]_login.com"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$_LOGOFF_COM:       
$    w " "      
$    w "Category    -  Utility"
$    w "Actual Name -  Program called by my _LOGIN.COM."
$    w "To access   -  Put this line in your login.com:"
$    w "               $ @science$disk:[brownp.public]_login.com"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$    
$exit
$
$_MKDIR_COM:        
$    w " "      
$    w "Category    -  Utility"
$    w "Actual Name -  Creates Subdirectories"
$    w "To access   -  $ @_MKDIR [<dirname>]"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$_MOVE_FILE_COM:    
$    w " "      
$    w "Category    -  Utility"
$    w "Actual Name -  Overly complex way to move files by Pete Alberti."
$    w "To access   -  $ @_MOVE_FILE.COM"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$_MUCH_MAIL_COM:   
$    w " "      
$    w "Category    -  Annoying Utility"
$    w "Actual Name -  Much Mail, sends millions of files to a user."
$    w "To access   -  $ @ _MUCH_MAIL"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$_PAUSE_COM:        
$    w " "      
$    w "Category    -  Utility"
$    w "Actual Name -  Locks your terminal while you are away"
$    w "To access   -  $ @_PAUSE"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$    
$exit
$
$_RE1_COM:          
$    w " "      
$    w "Category    -  Utility"
$    w "Actual Name -  Purge and rename everything to ;1"
$    w "To access   -  $ @_RE1"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
    
$exit
$
$_RESET_COM:        
$    w " "      
$    w "Category    -  Utility"
$    w "Actual Name -  DONT USE"
$    w "To access   -  BAD FILE...WORKING ON IT NOW"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$  
$    
$exit
$
$_SET_DEF_COM:     
$    w " "      
$    w "Category    -  Utility"
$    w "Actual Name -  Allows you to move around in your VAX directories in"
$    w "               much the same way you do in UNIX or DOS.
$    w "               Put this line in your login.com:
$    w "To access   -  $ CD :== @science$disk:[brownp.public]_set_def.com"   
$    w " "
$    w "Parameters  -  CD [<..> or [<subdirectory_name>[<.name.name.name>]] "
$    w " "
$    w "               CD ..   equivilent to SET DEF [-]"
$    w " "
$    w "               CD      equivilent to SET DEF SYS$LOGIN"
$    w " "
$    w "               CD public equivilant to SET DEF [.PUBLIC]
$    w " "
$    w "               CD public.tools.magik equiv to :"
$    w "                       SET DEF [.public.tools.magik]
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$  
$    
$exit
$
$_STATUS_COM:       
$    w " "      
$    w "Category    -  Utility"
$    w "Actual Name -  Gives useful information about your account."
$    w "To access   -  $ @_STATUS"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$  
$    
$exit
$
$_SWITCH_OWNER_COM: 
$    w " "      
$    w "Category    -  Utility"
$    w "Actual Name -  Switch the owner of a file"
$    w "To access   -  $ @_SWITCH_OWNER"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$  
$    
$exit
$
$_TRASH_COM:        
$    w " "      
$    w "Category    -  Utility"
$    w "Actual Name -  Deletes and sets protection on a file or group of files"
$    w "To access   -  $ @_TRASH [<filename>]"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$  
$    
$exit
$
$_WATCHER_COM:     
$    w " "      
$    w "Category    -  Utility"
$    w "Actual Name -  Announce when a user is on the system"
$    w "To access   -  NOT AVAIL.YET"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$  
$    
$exit
$
$52REASON_TXT:    
$    w " "      
$    w "Category    -  Humor"
$    w "Actual Name -  52 reasons beer is better than woman"
$    w "To access   -  $ TYPE/PAGE 52REASON.TXT"   
$    w " "     
$      
$    if p1 .EQS. "" then goto CONTINUE
$  
$  
$  
$    
$exit
$
$__9600BBS_TXT:     
$  
$    
$exit
$
$__ANSI364_TXT:     
$  
$    
$exit
$
$__DIGITAL_SEX_SHO:
$  
$    
$exit
$
$__DISKSPACE_COM:   
$  
$    
$exit
$
$__INFORM_COM:      
$  
$    
$exit
$
$__MOVE_COM:        
$  
$    
$exit
$
$__SORORITY_TXT:   
$  
$    
$exit
$
$__XMAS_TXT:        
$  
$    
$exit
$
$__ZMODEM_COM:      
$
$  
$exit
$
$
$PYTHON0_COM:
$   w "Special file, type @ARCHIVE PYTHON0 <name of sketch>"
$   w "              to view Monty Python scripts."
$   w "              or just @ARCHIVE PYTHON0 for a list"
$   w " "
$goto continue
$
$exit
$
$ARCHIVE_COM:
$   w "Special file, type @ARCHIVE PYTHON0 <name of sketch>"
$   w "              to view Monty Python scripts."
$   w "              or just @ARCHIVE PYTHON0 for a list"
$   w " "
$goto continue
$
$exit
$
$CONTINUE:
$
$   w " "
$   w " " 
$   inquire/nopunct CONT "                       Press <RETURN> to continue." 
$   goto BEGIN
$exit
$
$
$ERROR:
$
$   w " "
$   w " "
$   w "--- Sorry, no information on "+choice+", please try again"
$   w " "
$   w " "
$goto CONTINUE
$exit
