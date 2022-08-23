
PROGRAM _INIT
	(* Insert code here *)
	 FillerTyp:=DISABLED;
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	MpBFRecipeXml(MpLink := ADR(BFRecipe) , Enable := 1, DeviceName := ADR('USER') , FileName := ADR('BottleFillerRecipe'));
	MpBFRecipeRegPar(MpLink := ADR(BFRecipe), Enable := 1, PVName := ADR('BootleFiller:bottleFillerRecipeTyp'));
	//MpBFRecipeHMI(MpLink := ADR(BFRecipe), Enable := 1 , ErrorReset := , UISetup := ADR(UISetup) , UIConnect := ADR(MpRecipeUIConnectType));
	MpAxisConvParType.AutoTune.Mode:=mcAXIS_TUNE_AUTOMATIC;
	MpAxisConvParType.AutoTune.MaxCurrentPercent:=80;
	MpAxisConvParType.AutoTune.MaxDistance:=30;
	MpAxisConvParType.AutoTune.MaxPositionError:=30;
	MpAxisConv(MpLink := ADR(axisConv), Enable := 1, Parameters := ADR(MpAxisConvParType) ,   AutoTune := 1);
	MpAxisCart(MpLink := ADR(axisCart), Enable := 1, Parameters := ADR(MpAxisConvParType) ,   AutoTune := 1);
	MpAxisNozzle(MpLink := ADR(axisNozzle), Enable := 1, Parameters := ADR(MpAxisConvParType) ,  AutoTune := 1);

	MpBFRecipeXml();
	//MpBFRecipeHMI();
	CASE FillerTyp OF
		DISABLED: 
			diStart:=0;
			diStop:=0;
			
			IF diPowerSwitch THEN
				FillerTyp:=INIT;
			END_IF;
			
		INIT:
			//procedury pocz¹tkowe; home, kierunek
			IF diStart AND NOT diStop AND NOT diError THEN
				IF diManual THEN
					FillerTyp:=SERVICE;
				ELSE
					FillerTyp:= AUTOMAT;
				END_IF;
			END_IF;
					
		AUTOMAT:
			
		SERVICE:
			
		ERROR:
		
		STOP:
		 
	END_CASE;
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

