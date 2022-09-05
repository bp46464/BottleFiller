
PROGRAM _INIT
	(* Insert code here *)
	//bez inicjalizacji fillerTyp, bedzie akcja z maina
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	 
	CASE fillerTyp OF
		INIT:
			IF gControl.start THEN
				IF gControl.manual THEN
					fillerTyp:=MANUAL;
				ELSE
					fillerTyp:=AUTOMATIC; // <----------------- przypadek jak by nie mialo byc home'owania, przejscie do work
				END_IF;
			END_IF;
			
		HOMING:
			
		MANUAL:
		
		AUTOMATIC:
		
		ERROR:
		
		STOP:
		
	END_CASE;
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

