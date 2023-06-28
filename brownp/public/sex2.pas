
(* To use this program, you must copy the following into your account	*)
(*	1.	The .PAS version					*)
(*      2.	The file entitled DESCRIP.MMS				*)

(* then do the following:						*)

(*		$ pas SEX2.PAS						*)
(*		$ mms							*)
(*		$ purge							*)
(*		$ run SEX2					        *)





[INHERIT('science$disk:[heinesj.public.91-101]prof_heines.pen')]

PROGRAM Sex_Paragraphs (INPUT,OUTPUT);


CONST

(* change these numbers if you add any new words to the list *)

    max_faster = 50;
    max_twatadj = 50;
    max_twat = 50;
    max_dongadj = 50;
    max_dong = 50;
    max_diddled = 30;
    max_titadj = 30;
    max_knockers = 40;
    max_thrust = 30;
    max_male = 30;
    max_madjec = 40;
    max_female = 40;
    max_fadj = 40;
    max_said = 30;

VAR

(* dont change any of this shit *)

    faster	: ARRAY [1..max_faster] of string;
    diddled	: ARRAY [1..max_diddled] of string;
    titadj	: ARRAY [1..max_titadj] of string;
    knockers	: ARRAY [1..max_knockers] of string;
    thrust	: ARRAY [1..max_thrust] of string;
    twat	: ARRAY [1..max_twat] of string;
    twatadj	: ARRAY [1..max_twatadj] of string;
    dong	: ARRAY [1..max_dong] of string;
    dongadj	: ARRAY [1..max_dongadj] of string;
    male	: ARRAY [1..max_male] of string;
    madjec	: ARRAY [1..max_madjec] of string;
    female	: ARRAY [1..max_female] of string;
    fadj	: ARRAY [1..max_fadj] of string;
    said	: ARRAY [1..max_said] of string;


    rand_faster	    : INTEGER;
    rand_twatadj    : INTEGER;
    rand_twat	    : INTEGER;
    rand_dongadj    : INTEGER;
    rand_dong	    : INTEGER;
    rand_diddled    : INTEGER;
    rand_titadj	    : INTEGER;
    rand_knockers   : INTEGER;
    rand_thrust	    : INTEGER;
    rand_male	    : INTEGER;
    rand_madjec	    : INTEGER;
    rand_female	    : INTEGER;
    rand_fadj	    : INTEGER;
    rand_said	    : INTEGER;

PROCEDURE set_up_variables;

BEGIN

(* the actual goodies begin here *)

    faster[1] := '"Let the games begin!"';
    faster[2] := '"Not that!"';
    faster[3] := '"Sweet Jesus!"';
    faster[4] := '"Is that all?"';
    faster[5] := '"I never dreamed it could be"';
    faster[6] := '"Cheese it, the cops!"';
    faster[7] := '"Blow my clit!"';
    faster[8] := '"Lick me!"';
    faster[9] := '"Eat my bulkie!"';
    faster[10] := '"You snappahead!"';
    faster[11] := '"Your mutha on a bulkie!"';
    faster[12] := '"If I do, you won''t respect me!"';
    faster[13] := '"Open sesame!"';
    faster[14] := '"Again!"';
    faster[15] := '"Harder!"';
    faster[16] := '"Faster!"';
    faster[17] := '"Help!"';
    faster[18] := '"Gulp!"';
    faster[19] := '"Ralph!"';
    faster[20] := '"Fuck me harder!"';
    faster[21] := '"You aren''t my father!"';
    faster[22] := '"No, no, do the goldfish!"';
    faster[23] := '"He''s dead, he''s dead!"';
    faster[24] := '"Is it in yet?"';
    faster[25] := '"But it hurts..."';
    faster[26] := '"Up the butt Bob!"';
    faster[27] := '"It''s dead Jim"';
    faster[28] := '"It''s life Jim, but not as we know it."';
    faster[29] := '"Use the force Luke!"';
    faster[30] := '"Doctor, that''s not *my* shoulder"';
    faster[31] := '"Take me, Pete!!"';
    faster[32] := '"Im a Republican!"';
    faster[33] := '"Im a Democrat!"';
    faster[34] := '"I love alien pooch cum..."';
    faster[35] := '"The animals will hear!"';
    faster[36] := '"Suck harder!"';
    faster[37] := '"Not in public!"';
    faster[38] := '"Put four fingers in!"';
    faster[39] := '"I can lift an 18 wheeler with that!"';
    faster[40] := '"The ceiling needs painting"';
    faster[41] := '"But it''s so...small!"';
    faster[42] := '"Pump me full of spooge!"';
    faster[43] := '"Wow! Zowie! Wumba Wumba!"';
    faster[44] := '"Moooooooooooooooo"';
    faster[45] := '"John Mackin is a homo!"';
    faster[46] := '"Suck me like a dirty diaper!"';
    faster[47] := '"You taste like a greasy pork sandwich!"';
    faster[48] := '"You smell like an old sock!"';
    faster[49] := '"You smell like fisherman''s wharf!"';
    faster[50] := '"I hate you, you jiz licking horse fucker!"';


    said[1] := 'bellowed';
    said[2] := 'yelped';
    said[3] := 'croaked';
    said[4] := 'moaned';
    said[5] := 'warbled';
    said[6] := 'choked';
    said[7] := 'squealed';
    said[8] := 'tongued';
    said[9] := 'yelled';
    said[10] := 'panted';
    said[11] := 'laughed';
    said[12] := 'ejaculated';
    said[13] := 'wheezed';
    said[14] := 'salivated';
    said[15] := 'screamed';
    said[16] := 'growled';
    said[17] := 'grunted';
    said[18] := 'sighed';
    said[19] := 'stammered';
    said[20] := 'farted';
    said[21] := 'whimpered';
    said[22] := 'cried';
    said[23] := 'queefed';
    said[24] := 'spewed';
    said[25] := 'creamed';
    said[26] := 'spooged';
    said[27] := 'woofed';
    said[28] := 'purred';
    said[29] := 'poured';
    said[30] := 'getched';

    fadj[1] := 'saucy';
    fadj[2] := 'wanton';
    fadj[3] := 'unfortunate';
    fadj[4] := 'lust-crazed';
    fadj[5] := 'cream-filled';
    fadj[6] := 'nine-year-old';
    fadj[7] := 'bull-dyke';
    fadj[8] := 'bysexual';
    fadj[9] := 'gorgeous';
    fadj[10] := 'sweet';
    fadj[11] := 'nymphomaniacal';
    fadj[12] := 'large-hipped';
    fadj[13] := 'hippo-shaped';
    fadj[14] := 'freckled';
    fadj[15] := 'forty-five year old';
    fadj[16] := 'white-haired';
    fadj[17] := 'large-boned';
    fadj[18] := 'saintly';
    fadj[19] := 'blind';
    fadj[20] := 'bearded';
    fadj[21] := 'blue-eyed';
    fadj[22] := 'large tongued';
    fadj[23] := 'friendly';
    fadj[24] := 'piano playing';
    fadj[25] := 'ear licking';
    fadj[26] := 'doe eyed';
    fadj[27] := 'sock sniffing';
    fadj[28] := 'lesbian';
    fadj[29] := 'hairy';
    fadj[30] := 'cum-lapping';
    fadj[31] := 'often distributed';
    fadj[32] := 'jizsm licking';
    fadj[33] := 'dick jerking';
    fadj[34] := 'blue balling';
    fadj[35] := 'ball sniffing';
    fadj[36] := 'meat eating';
    fadj[37] := 'slovenly';
    fadj[38] := 'three-toed';
    fadj[39] := 'toe cheese eating';
    fadj[40] := 'beer puking';

    female[1] := 'baggage';
    female[2] := 'snappa';
    female[3] := 'hussy';
    female[4] := 'woman';
    female[5] := 'Duchess';
    female[6] := 'female impersonator';
    female[7] := 'nymphomaniac';
    female[8] := 'virgin';
    female[9] := 'leather freak';
    female[10] := 'home-coming queen';
    female[11] := 'defrocked nun';
    female[12] := 'bisexual budgie';
    female[13] := 'cheerleader';
    female[14] := 'office secretary';
    female[15] := 'sexual deviate';
    female[16] := 'little matchgirl';
    female[17] := 'ceremonial penguin';
    female[18] := 'femme fatale';
    female[19] := 'bosses daughter';
    female[20] := 'construction worker';
    female[21] := 'sausage abuser';
    female[22] := 'secretary';
    female[23] := 'Congressmans page';
    female[24] := 'grandmother';
    female[25] := 'penguin';
    female[26] := 'German shepherd';
    female[27] := 'bitch';
    female[28] := 'great dane';
    female[29] := 'stewardess';
    female[30] := 'waitress';
    female[31] := 'prostitute';
    female[32] := 'computer science group';
    female[33] := 'system manager from Wannalancit';
    female[34] := 'Zoo Crew member';
    female[35] := 'housewife';
    female[36] := 'moose';
    female[37] := 'whale';
    female[38] := 'chinaman';
    female[39] := 'cow';
    female[40] := 'horse';

    madjec[1] := 'thrashing';
    madjec[2] := 'slurping';
    madjec[3] := 'insatiable';
    madjec[4] := 'rabid';
    madjec[5] := 'satanic';
    madjec[6] := 'corpulent';
    madjec[7] := 'nose-grooming';
    madjec[8] := 'tripe-fondling';
    madjec[9] := 'dribbling';
    madjec[10] := 'spread-eagled';
    madjec[11] := 'orally fixated';
    madjec[12] := 'vile';
    madjec[13] := 'awesomely endowed';
    madjec[14] := 'handsome';
    madjec[15] := 'mush-brained';
    madjec[16] := 'tremendously hung';
    madjec[17] := 'three-legged';
    madjec[18] := 'pile-driving';
    madjec[19] := 'cross-dressing';
    madjec[20] := 'gerbil buggering';
    madjec[21] := 'bung-hole stuffing';
    madjec[22] := 'sphincter licking';
    madjec[23] := 'clit chewing';
    madjec[24] := 'hair-pie chewing';
    madjec[25] := 'muff-diving';
    madjec[26] := 'clam shucking';
    madjec[27] := 'egg-sucking';
    madjec[28] := 'bicycle seat sniffing';
    madjec[29] := 'meat-beating';
    madjec[30] := 'greasy';
    madjec[31] := 'grass parting';
    madjec[32] := 'vodka smelling';
    madjec[33] := 'terminal hacking';
    madjec[34] := 'ramrod-holding';
    madjec[35] := 'tit-grabbing';
    madjec[36] := 'ass-holding';
    madjec[37] := 'homosexual';
    madjec[38] := 'cow-fucking';
    madjec[39] := 'fat';
    madjec[40] := 'geeky-looking';

    male[1] := 'rakeshell';
    male[2] := 'hunchback';
    male[3] := 'lecherous lickspittle';
    male[4] := 'archduke';
    male[5] := 'midget';
    male[6] := 'hired hand';
    male[7] := 'great Dane';
    male[8] := 'stallion';
    male[9] := 'donkey';
    male[10] := 'electric eel';
    male[11] := 'paraplegic pothead';
    male[12] := 'guitar player';
    male[13] := 'dirt old man';
    male[14] := 'knight';
    male[15] := 'faggot butler';
    male[16] := 'friar';
    male[17] := 'black-power advoate';
    male[18] := 'white supremist';
    male[19] := 'follicle fetishist';
    male[20] := 'handsome priest';
    male[21] := 'chicken flucker';
    male[22] := 'ex-woman';
    male[23] := 'homosexual flamingo';
    male[24] := 'dentist';
    male[25] := 'ex-celibate';
    male[26] := 'drug sucker';
    male[27] := 'hair dresser';
    male[28] := 'social worker';
    male[29] := 'judge';
    male[30] := 'construction worker';

    diddled[1] := 'diddled';
    diddled[2] := 'devoured';
    diddled[3] := 'fondled';
    diddled[4] := 'mouthed';
    diddled[5] := 'tongued';
    diddled[6] := 'lashed';
    diddled[7] := 'tweaked';
    diddled[8] := 'violated';
    diddled[9] := 'mounted';
    diddled[10] := 'defiled';
    diddled[11] := 'irrigated';
    diddled[12] := 'penetrated';
    diddled[13] := 'ravished';
    diddled[14] := 'hammered';
    diddled[15] := 'bit';
    diddled[16] := 'tongue slashed';
    diddled[17] := 'sucked';
    diddled[18] := 'fucked';
    diddled[19] := 'rubbed';
    diddled[20] := 'grudge fucked';
    diddled[21] := 'masterbated with';
    diddled[22] := 'jerked off with';
    diddled[23] := 'played with';
    diddled[24] := 'nosed';
    diddled[25] := 'laid out';
    diddled[26] := 'pelted';
    diddled[27] := 'flattened';
    diddled[28] := 'rolled over';
    diddled[29] := 'burnt';
    diddled[30] := 'poured beer on';

    titadj[1] := 'alabaster';
    titadj[2] := 'pink-tipped';
    titadj[3] := 'excited';
    titadj[4] := 'creamy';
    titadj[5] := 'milk-filled';
    titadj[6] := 'rosebud';
    titadj[7] := 'moist';
    titadj[8] := 'throbbing';
    titadj[9] := 'juicy';
    titadj[10] := 'heaving';
    titadj[11] := 'straining';
    titadj[12] := 'mammoth';
    titadj[13] := 'succulent';
    titadj[14] := 'quivering';
    titadj[15] := 'rosey';
    titadj[16] := 'globular';
    titadj[17] := 'varicose';
    titadj[18] := 'jiggling';
    titadj[19] := 'bloody';
    titadj[20] := 'tilted';
    titadj[21] := 'lumpy';
    titadj[22] := 'dribbling';
    titadj[23] := 'oozing';
    titadj[24] := 'firm';
    titadj[25] := 'misshapen';
    titadj[26] := 'pendulous';
    titadj[27] := 'muscular';
    titadj[28] := 'bovine';
    titadj[29] := 'lop-sided';
    titadj[30] := 'hard-nippled';

    knockers[1] := 'globes';
    knockers[2] := 'melons';
    knockers[3] := 'mounds';
    knockers[4] := 'buds';
    knockers[5] := 'paps';
    knockers[6] := 'chubbies';
    knockers[7] := 'protuberances';
    knockers[8] := 'treasures';
    knockers[9] := 'buns';
    knockers[10] := 'ass cheeks';
    knockers[11] := 'bung';
    knockers[12] := 'vestibule';
    knockers[13] := 'armpits';
    knockers[14] := 'tits';
    knockers[15] := 'knockers';
    knockers[16] := 'manwich covered asshole';
    knockers[17] := 'eyes';
    knockers[18] := 'hooters';
    knockers[19] := 'jugs';
    knockers[20] := 'lungs';
    knockers[21] := 'headlights';
    knockers[22] := 'bumpers';
    knockers[23] := 'buttocks';
    knockers[24] := 'charlies';
    knockers[25] := 'bazooms';
    knockers[26] := 'mammaries';
    knockers[27] := 'floppers';
    knockers[28] := 'brandies';
    knockers[29] := 'boulders';
    knockers[30] := 'smackers';
    knockers[31] := 'bloomers';
    knockers[32] := 'endowments';
    knockers[33] := 'blasters';
    knockers[34] := 'swings';
    knockers[35] := 'fried eggs';
    knockers[36] := 'fireballs';
    knockers[37] := 'cheezecakes';
    knockers[38] := 'boffers';
    knockers[39] := 'whippers';
    knockers[40] := 'carbon-based warheads';

    thrust[1] := 'plunged';
    thrust[2] := 'thrust';
    thrust[3] := 'squeezed';
    thrust[4] := 'pounded';
    thrust[5] := 'drove';
    thrust[6] := 'eased';
    thrust[7] := 'slid';
    thrust[8] := 'hammered';
    thrust[9] := 'squished';
    thrust[10] := 'crammed';
    thrust[11] := 'slammed';
    thrust[12] := 'reamed';
    thrust[13] := 'rammed';
    thrust[14] := 'dipped';
    thrust[15] := 'inserted';
    thrust[16] := 'plugged';
    thrust[17] := 'augured';
    thrust[18] := 'pushed';
    thrust[19] := 'ripped';
    thrust[20] := 'forced';
    thrust[21] := 'wrenched';
    thrust[22] := 'threw';
    thrust[23] := 'shot';
    thrust[24] := 'mashed';
    thrust[25] := 'plopped';
    thrust[26] := 'smooshed';
    thrust[27] := 'moffed';
    thrust[28] := 'slipped';
    thrust[29] := 'dropped';
    thrust[30] := 'creamed';

    dongadj[1] := 'bursting';             
    dongadj[2] := 'jutting';              
    dongadj[3] := 'glistening';
    dongadj[4] := 'wax covered';       
    dongadj[5] := 'prodigious';           
    dongadj[6] := 'purple';
    dongadj[7] := 'searing';      
    dongadj[8] := 'swollen';  
    dongadj[9] := 'rigid';
    dongadj[10] := 'rampaging';    
    dongadj[11] := 'warty';      
    dongadj[12] := 'steaming';
    dongadj[13] := 'gorged';  
    dongadj[14] := 'trunklike';    
    dongadj[15] := 'foaming';
    dongadj[16] := 'spouting';      
    dongadj[17] := 'swinish';      
    dongadj[18] := 'prosthetic';
    dongadj[19] := 'blue veined';      
    dongadj[20] := 'engorged';     
    dongadj[21] := 'horse like';
    dongadj[22] := 'throbbing';      
    dongadj[23] := 'humongous'; 
    dongadj[24] := 'hole splitting';
    dongadj[25] := 'serpentine';    
    dongadj[26] := 'curved';   
    dongadj[27] := 'steel encased';
    dongadj[28] := 'glass encrusted';  
    dongadj[29] := 'knobby';      
    dongadj[30] := 'surgically altered';
    dongadj[31] := 'metal tipped';   
    dongadj[32] := 'open sored';      
    dongadj[33] := 'rapidly dwindling';
    dongadj[34] := 'swelling';  
    dongadj[35] := 'miniscule';   
    dongadj[36] := 'cum tipped';
    dongadj[37] := 'red headed';
    dongadj[38] := 'smashing';
    dongadj[39] := 'boney';
    dongadj[40] := 'artificial';
    dongadj[41] := 'steely';
    dongadj[42] := 'tap-dancing';
    dongadj[43] := 'electrified';
    dongadj[44] := 'whip-like';
    dongadj[45] := 'tree-sized';
    dongadj[46] := 'dripping';
    dongadj[47] := 'excited';
    dongadj[48] := 'juice-filled';
    dongadj[49] := 'stiff';
    dongadj[50] := 'manly';

    dong[1] := 'intruder';     
    dong[2] := 'prong'; 
    dong[3] := 'stump';
    dong[4] := 'member';      
    dong[5] := 'meat loaf';    
    dong[6] := 'majesty';
    dong[7] := 'bowsprit';      
    dong[8] := 'earthmover';   
    dong[9] := 'jackhammer';
    dong[10] := 'ramrod';  
    dong[11] := 'schlong of steel';      
    dong[12] := 'jabber';
    dong[13] := 'gusher';       
    dong[14] := 'poker';       
    dong[15] := 'engine';
    dong[16] := 'brownie';    
    dong[17] := 'joy stick';    
    dong[18] := 'plunger';
    dong[19] := 'piston';        
    dong[20] := 'tool';       
    dong[21] := 'manhood';
    dong[22] := 'lollipop';    
    dong[23] := 'kidney prodder';
    dong[24] := 'candlestick';
    dong[25] := 'John Thomas';   
    dong[26] := 'arm';     
    dong[27] := 'testicles';
    dong[28] := 'balls';       
    dong[29] := 'finger';   
    dong[30] := 'foot';
    dong[31] := 'tongue';         
    dong[32] := 'dick';      
    dong[33] := 'one-eyed wonder worm';
    dong[34] := 'canyon yodeler';      
    dong[35] := 'middle leg';    
    dong[36] := 'neck wrapper';
    dong[37] := 'stick shift';   
    dong[38] := 'dong';      
    dong[39] := 'Linda Lovelace choker';
    dong[40] := 'choker';
    dong[41] := 'Scud of Love';
    dong[42] := 'cheese';
    dong[43] := 'pepper-steak';
    dong[44] := 'whole leg';
    dong[45] := 'leg of lamb';
    dong[46] := 'fist';
    dong[47] := 'bottle of scotch';
    dong[48] := 'seltzer bottle';
    dong[49] := 'pounder';
    dong[50] := 'Stanley';

        twatadj[1] := 'pulsing';              
        twatadj[2] := 'hungry';
        twatadj[3] := 'hymeneal';
        twatadj[4] := 'palpitating';          
        twatadj[5] := 'gaping';   
        twatadj[6] := 'slavering';
        twatadj[7] := 'welcoming';            
        twatadj[8] := 'glutted';              
        twatadj[9] := 'gobbling';
        twatadj[10] := 'cobwebby';             
        twatadj[11] := 'ravenous';             
        twatadj[12] := 'slurping';
        twatadj[13] := 'glistening';           
        twatadj[14] := 'dripping';             
        twatadj[15] := 'scabiferous';
        twatadj[16] := 'porous';               
        twatadj[17] := 'soft-spoken';          
        twatadj[18] := 'pink';
        twatadj[19] := 'dusty';                
        twatadj[20] := 'tight';                
        twatadj[21] := 'odiferous';
        twatadj[22] := 'moist';                
        twatadj[23] := 'loose';                
        twatadj[24] := 'scarred';
        twatadj[25] := 'weapon-less';          
        twatadj[26] := 'banana stuffed';       
        twatadj[27] := 'tire tracked';
        twatadj[28] := 'mouse nibbled';        
        twatadj[29] := 'tightly tensed';       
        twatadj[30] := 'oft traveled';
        twatadj[31] := 'grateful';             
        twatadj[32] := 'festering';
	twatadj[33] := 'cum filled';
	twatadj[34] := 'jelly filled';
	twatadj[35] := 'slimy';
	twatadj[36] := 'worm eaten';
	twatadj[37] := 'plunger-like';
	twatadj[38] := 'dick loving';
	twatadj[39] := 'never ending';
	twatadj[40] := 'jiz filled';
	twatadj[41] := 'creamy';
	twatadj[42] := 'tuna-smelling';
	twatadj[43] := 'huge';
	twatadj[44] := 'class ring-filled';
	twatadj[45] := 'sticky';
	twatadj[46] := 'bloated';
	twatadj[47] := 'burned';
	twatadj[48] := 'rash-covered';
	twatadj[49] := 'festering';
	twatadj[50] := 'disease-filled';


        twat[1] := 'swamp.';               
	twat[2] := 'honeypot.';            
	twat[3] := 'jam jar.';
        twat[4] := 'butterbox.';           
	twat[5] := 'furburger.';           
	twat[6] := 'cherry pie.';
        twat[7] := 'cush.';                
	twat[8] := 'box.';                
	twat[9] := 'slit.';
        twat[10] := 'cockpit.';             
	twat[11] := 'damp.';                
	twat[12] := 'furrow.';
        twat[13] := 'box o goodies.';   
	twat[14] := 'bearded clam.';        
	twat[15] := 'continental divide.';
        twat[16] := 'paradise valley.';     
	twat[17] := 'red river valley.';    
	twat[18] := 'slot machine.';
        twat[19] := 'queef machine.';                
	twat[21] := 'palace.';              
	twat[22] := 'ass.';
        twat[23] := 'rose bud.';            
	twat[24] := 'throat.';              
	twat[25] := 'eye socket.';
        twat[26] := 'tenderness.';          
	twat[27] := 'inner ear.';           
	twat[28] := 'orifice.';
        twat[28] := 'appendix scar.';       
	twat[30] := 'wound.';               
	twat[31] := 'navel.';
        twat[32] := 'mouth.';               
	twat[33] := 'nose.';                
	twat[34] := 'cunt.';
	twat[35] := 'clit.';
	twat[36] := 'Palace of Love.';
	twat[37] := 'heated box of shit.';
	twat[38] := 'twitching snatch.';
	twat[39] := 'fudgepacked anus.';
	twat[40] := 'Hershey highway.';
	twat[41] := 'VD container.';
	twat[42] := 'manhole.';
	twat[43] := 'beer bottle.';
	twat[44] := 'AIDS carrier.';
	twat[45] := 'wet pussy.';
	twat[46] := 'heated box of shit.';
	twat[47] := 'butt crack.';
	twat[48] := 'hairy lips.';
	twat[49] := 'clit-tuba.';
	twat[50] := 'ovaries.';




END; (* set_up_variables *)



BEGIN

(* dont change any of this shit below this point *)

    set_up_variables;

    rand_faster	    := round(((rnd)) * (max_faster-1)) + 1 ;
    rand_twatadj    := round(((rnd)) * (max_twatadj-1)) + 1 ;
    rand_twat	    := round(((rnd)) * (max_twat-1)) + 1 ;
    rand_dongadj    := round(((rnd)) * (max_dongadj-1)) + 1 ;
    rand_dong	    := round(((rnd)) * (max_dong-1)) + 1 ;
    rand_diddled    := round(((rnd)) * (max_diddled-1)) + 1 ;
    rand_titadj	    := round(((rnd)) * (max_titadj-1)) + 1 ;
    rand_knockers   := round(((rnd)) * (max_knockers-1)) + 1 ;
    rand_thrust	    := round(((rnd)) * (max_thrust-1)) + 1 ;
    rand_male	    := round(((rnd)) * (max_male-1)) + 1 ;
    rand_madjec	    := round(((rnd)) * (max_madjec-1)) + 1 ;
    rand_female	    := round(((rnd)) * (max_female-1)) + 1 ;
    rand_fadj	    := round(((rnd)) * (max_fadj-1)) + 1 ;
    rand_said	    := round(((rnd)) * (max_said-1)) + 1 ;

    Clrscr;

(* The commented-out section is for testing purposes *)

{

    WRITELN(rand_faster, ' - FASTER  - ',faster[rand_faster ]);
    WRITELN(rand_twatadj,' - TWATADJ - ',twatadj[rand_twatadj ]);
    WRITELN(rand_twat,   ' - TWAT    - ',twat[rand_twat ]);
    WRITELN(rand_dongadj,' - DONGADJ - ',dongadj[rand_dongadj ]);
    WRITELN(rand_dong,   ' - DONG    - ',dong[rand_dong ]);
    WRITELN(rand_diddled,' - DIDDLED - ',diddled[rand_diddled ]);
    WRITELN(rand_titadj, ' - TITADJ  - ',titadj[rand_titadj ]);
    WRITELN(rand_knockers,' - KNOCKERS- ',knockers[rand_knockers ]);
    WRITELN(rand_thrust, ' - THRUST  - ',thrust[rand_thrust ]);
    WRITELN(rand_male,   ' - MALE    - ',male[rand_male ]);
    WRITELN(rand_madjec, ' - MADJEC  - ',madjec[rand_madjec ]);
    WRITELN(rand_female, ' - FEMALE  - ',female[rand_female ]);
    WRITELN(rand_fadj,   ' - FADJ    - ',fadj[rand_fadj ]);
    WRITELN(rand_said,   ' - SAID    - ',said[rand_said ]);

}


    WRITELN ;
    WRITELN ('This very demented program brought to you by The Psychlist');
    WRITELN ;
    WRITELN (faster[rand_faster ],' ',said[rand_said ],' the ',fadj[rand_fadj ]);
    WRITELN (female[rand_female ],' as the ',madjec[rand_madjec ],' ',male[rand_male ]);
    WRITELN (diddled[rand_diddled ],' her ',titadj[rand_titadj ],' ',knockers[rand_knockers ],' and ',thrust[rand_thrust ],' his');
    WRITELN (dongadj[rand_dongadj ],' ',dong[rand_dong ],' into her ',twatadj[rand_twatadj ],' ',twat[rand_twat ]);
    WRITELN ;
END.

