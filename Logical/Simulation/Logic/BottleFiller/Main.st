
PROGRAM _INIT
	(* Insert code here *)
	 FillerTyp:=DISABLED;
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
//	MpBFRecipeXml(MpLink := ADR(BFRecipe) , Enable := 1, DeviceName := ADR('USER') , FileName := ADR('BottleFillerRecipe'));
//	MpBFRecipeRegPar(MpLink := ADR(BFRecipe), Enable := 1, PVName := ADR('BootleFiller:bottleFillerRecipeTyp'));
//	MpBFRecipeHMI(MpLink := ADR(BFRecipe), Enable := 1 , ErrorReset := , UISetup := ADR(UISetup) , UIConnect := ADR(MpRecipeUIConnectType));
	MpAxisConvParType.AutoTune.Mode:=mcAXIS_TUNE_AUTOMATIC;
	MpAxisConvParType.AutoTune.MaxCurrentPercent:=80;
	MpAxisConvParType.AutoTune.MaxDistance:=30;
	MpAxisConvParType.AutoTune.MaxPositionError:=30;
	MpAxisNozzleParType.Homing.Position:=200;
	MpAxisConv(MpLink := ADR(axisConv), Enable := 1, Parameters := ADR(MpAxisConvParType), AutoTune := 1);
	MpAxisCart(MpLink := ADR(axisCart), Enable := 1, Parameters := ADR(MpAxisCartParType),   AutoTune := 1);
	MpAxisNozzle(MpLink := ADR(axisNozzle), Enable := 1, Parameters := ADR(MpAxisNozzleParType),  AutoTune := 1);
	
//
//	MpBFRecipeXml();
	
	camSeq(MpLink := ADR(axisCart), Enable := 1, Parameters := ADR(camParameters), MpLinkMaster := ADR(axisConv));
	camSeqNozzle(MpLink := ADR(axisNozzle), Enable := 1, Parameters := ADR(camParameters), MpLinkMaster := ADR(axisConv));
	
	
	SimulationAxisPosition.Cart := LREAL_TO_REAL(MpAxisCart.Position);
	SimulationAxisPosition.Conveyor := LREAL_TO_REAL(MpAxisConv.Position);
	SimulationAxisPosition.Nozzle := LREAL_TO_REAL(MpAxisNozzle.Position);
	gAdrAxesPositions := ADR(SimulationAxisPosition);
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
			IF diPowerSwitch AND NOT diStop AND NOT diError THEN
				
				//power on axis
				MpAxisCart.Power:=1;
				MpAxisConv.Power:=1;
				MpAxisNozzle.Power:=1;
				
				
				//homing
				MpAxisCart.Home:=1;
				IF MpAxisCart.IsHomed THEN
					MpAxisCart.Home:=0;
				END_IF;
				
				MpAxisConv.Home:=1;
				IF MpAxisConv.IsHomed THEN
					MpAxisConv.Home:=0;
				END_IF;
				
				MpAxisNozzle.Home:=1;
				IF MpAxisNozzle.IsHomed THEN
					MpAxisNozzle.Home:=0;
				END_IF;
				
				
				IF diStart AND MpAxisNozzle.IsHomed AND MpAxisConv.IsHomed AND MpAxisCart.IsHomed AND MpAxisCart.PowerOn AND MpAxisNozzle.PowerOn AND MpAxisConv.PowerOn THEN
					//power on camSeq
					camSeq.StartSequence:=1;
					camSeqNozzle.StartSequence:=1;
					IF diManual THEN
						FillerTyp:=SERVICE;
					ELSE
						FillerTyp:= AUTOMAT;
					END_IF;
				END_IF;
			END_IF;
					
		AUTOMAT:
			IF camSeq.InCam AND camSeqNozzle.InCam THEN
				
				camSeq.Signal1:=1;
				camSeqNozzle.Signal1:=1;
				MpAxisConv.MoveVelocity := (diStart AND NOT diStop);
			END_IF;
			
		SERVICE:
			
		ERROR:
		
		STOP:
		 
	END_CASE;
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

