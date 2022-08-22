PROGRAM _INIT
	(* Insert code here *)
	FillerTyp:=DISABLED;
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	MpBFRecipeXml(MpLink := ADR(BFRecipe) , Enable := 1, DeviceName := ADR('USER') , FileName := ADR('BottleFillerRecipe'));
	MpBFRecipeRegPar(MpLink := ADR(BFRecipe), Enable := 1, PVName := ADR('BootleFiller:bottleFillerRecipeTyp'));
	//MpBFRecipeHMI(MpLink := ADR(BFRecipe), Enable := 1 , ErrorReset := , UISetup := ADR(UISetup) , UIConnect := ADR(MpRecipeUIConnectType));
	
	
	MpBFRecipeXml();
	//MpBFRecipeHMI();
	CASE FillerTyp OF
		DISABLED: 
			
		INIT:
		
		AUTOMAT:
			
		SERVICE:
			
		ERROR:
		
		STOP:
		 
	END_CASE;
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM
