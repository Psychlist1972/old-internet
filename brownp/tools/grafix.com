$e:==write sys$output
$e "(0 a b c d e f g h i j k l m n o p q r s t u v w x y z"
$e "(B a b c d e f g h i j k l m n o p q r s t u v w x y z"
$e ""
$e "(0 1 2 3 4 5 6 7 8 9 0 - = ` ! @ # $ % ^ & * ( )"
$e "(B 1 2 3 4 5 6 7 8 9 0 - = ` ! @ # $ % ^ & * ( )"
$e ""
$e "(0 [ ] ; ' , . / \ { } : < > ? | ~"
$e "(B [ ] ; ' , . / \ { } : < > ? | ~"
$e ""
$e "[1;7m     [1;0m"
$e "esc[1;7m space bar esc[1;0m makes inverse"