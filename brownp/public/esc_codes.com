$
$
$ @science$disk:[brownp.public]write.file "esc_codes"
$
$ !
$ ! Escape Codes
$ !
$
$
$ WSO        :== WRITE SYS$OUTPUT
$ BELL[0,8]  :== 7
$ CTRLS[0,8] :== 19
$ CTRLT[0,8] :== 20
$ CTRLY[0,8] :== 25
$ ESC[0,8]   :== 27
$ CURSUP     :== ESC+"[A"
$ CURSDOWN   :== ESC+"[B"
$ SAVESC     :== ESC+"7"
$ RESTESC    :== ESC+"8"
$ BELLESC    :== BELL+CURSUP
$ RINGESC    :== BELL+BELL+BELL+BELL+CURSUP
$ REVESC     :== ESC+"[7m"+CURSUP
$ NORMESC    :== ESC+"[m"+CURSUP
$! GRONESC    :== ESC+"(0"+CURSUP
$! GROFFESC   :== ESC+"(B"+CURSUP
$ JUMPESC    :== ESC+"[?4l"+CURSUP
$ SCROLLESC  :== ESC+"[?4h"+CURSUP
$ WHINESC    :== ESC+"[163q"
$ REPESC     :== ESC+"[2;9y"
$ RESETESC   :== ESC+"c"
$ CLRESC     :== ESC+"[2J"+ESC+"[f"
$ LIGHTESC   :== ESC+"[?5h"+CURSUP
$ DARKESC    :== ESC+"[?5l"+CURSUP
$ FLASHESC   :== ESC+"[?5h"+ESC+"[?5l"+CURSUP
$ L1ESC      :== ESC+"[1q"+CURSUP
$ L2ESC      :== ESC+"[2q"+CURSUP
$ L3ESC      :== ESC+"[3q"+CURSUP
$ L4ESC      :== ESC+"[4q"+CURSUP
$ ALLESC     :== ESC+"[1;2;3;4q"+CURSUP
$ OFFESC     :== ESC+"[q"+CURSUP
$ WIDESC     :== ESC+"#6*''ESC'[D"
$ WIDE       :== SET PROMPT ="""''WIDESC'"""
$ FLASH      :== 'WSO FLASHESC
$ CLR        :== 'WSO CLRESC
$ RESET      :== 'WSO RESETESC
$ REV*ERSE   :== 'WSO REVESC
$ NOR*MAL    :== 'WSO NORMESC
$! GRON       :== 'WSO GRONESC
$! GROFF      :== 'WSO GROFFESC
$ LI*GHT     :== 'WSO LIGHTESC
$ DA*RK      :== 'WSO DARKESC
$ JUMP       :== 'WSO JUMPESC
$ SCROLL     :== 'WSO SCROLLESC
$ L1         :== 'WSO L1ESC
$ L2         :== 'WSO L2ESC
$ L3         :== 'WSO L3ESC
$ L4         :== 'WSO L4ESC
$ ALL        :== 'WSO ALLESC
$ OFF        :== 'WSO OFFESC
$ BEEP       :== 'WSO BELLESC
$ RING       :== 'WSO RINGESC
$ WHINE      :== 'WSO WHINESC
$ BREAKDOWN  :== 'WSO REPESC
$ EEESC      :== ESC+'#8'
$ EE*K       :== 'WSO EEESC
$
$exit
$
$DONE:
$ write sys$output 'Codes already defined'
$exit
