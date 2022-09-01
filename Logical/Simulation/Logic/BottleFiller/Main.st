
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
					
					IF diManual THEN
						FillerTyp:=SERVICE;
					ELSE
						camSeq.StartSequence:=1;
						camSeqNozzle.StartSequence:=1;
						FillerTyp:= AUTOMAT;
					END_IF;
				END_IF;
			END_IF;
					
		AUTOMAT:
			IF camSeq.InCam AND camSeqNozzle.InCam THEN
				
				camSeq.Signal1:=1;
				camSeqNozzle.Signal1:=1;
				MpAxisConv.MoveVelocity := (diStart AND NOT diStop);
				IF MpAxisConv.UpdateDone THEN
					MpAxisConv.Update:=0;
				END_IF;
				
			END_IF;
			
		SERVICE:
			//odpalenie cam-ów
			IF inCam THEN
				IF changedPosition THEN
					
					MpAxisCartParType.Homing.Mode:=141;
					MpAxisCartParType.Homing.Options.HomingVelocity:=50;
					MpAxisCart.Update:=1;
					
					
					MpAxisConvParType.Homing.Mode:=141;
					MpAxisConvParType.Homing.Options.HomingVelocity:=50;
					MpAxisConv.Update:=1;
					
					
					
					MpAxisNozzleParType.Homing.Mode:=141;
					MpAxisNozzleParType.Homing.Options.HomingVelocity:=50;
					MpAxisNozzle.Update:=1;
					
					IF MpAxisCart.UpdateDone THEN
						MpAxisCart.Home:=1;
						MpAxisCart.Update:=0;
					END_IF;
					IF MpAxisConv.UpdateDone THEN
						MpAxisConv.Home:=1;
						
						MpAxisConv.Update:=0;
					END_IF;
					IF MpAxisNozzle.UpdateDone THEN
						MpAxisNozzle.Home:=1;
						
						MpAxisNozzle.Update:=0;
					END_IF;
					changedPosition:=0;
				END_IF;
				
				IF camSeq.InCam AND camSeqNozzle.InCam THEN
					camSeq.Signal1:=1;
					camSeqNozzle.Signal1:=1;			
				END_IF;
				
				IF camSeq.Signal1 AND camSeqNozzle.Signal1 THEN
					
					IF MpAxisConv.InPosition THEN
						MpAxisConv.MoveAbsolute:=0;
						MpAxisConv.MoveAdditive:=0;
						MpAxisConv.MoveVelocity:=0;
					END_IF;
					//switch update taœmy
					
					IF MpAxisConv.UpdateDone THEN
						MpAxisConv.Update:=0;
					END_IF;
				END_IF;
					
			END_IF;
			
			//wy³¹czenie cam-ów
			IF EDGENEG(inCam) THEN
				camSeq.StartSequence:=0;
				camSeqNozzle.StartSequence:=0;
				camSeq.Signal1:=0;
				camSeqNozzle.Signal1:=0;	
			END_IF;
			
			//obs³uga zmiany kierunków ruchu urz¹dzeñ przy obs³udze manualnej
			IF EDGEPOS(MpAxisConv.MoveAbsolute) THEN
				IF MpAxisConv.Position > MpAxisConvParType.Position THEN
					MpAxisConvParType.Direction:=mcDIR_NEGATIVE;
					MpAxisConv.Update:=1;
				ELSIF MpAxisConv.Position < MpAxisConvParType.Position THEN
					MpAxisConvParType.Direction:=mcDIR_POSITIVE;
					MpAxisConv.Update:=1;
				END_IF;
			END_IF;
			
			
			
			//wy³¹czanie ruchu taœmy
			IF MpAxisConv.Info.JogLimitReached THEN
				MpAxisConv.JogNegative:=0;
				MpAxisConv.JogPositive:=0;
			END_IF;
			//switch update taœmy
			IF MpAxisConv.UpdateDone THEN
				MpAxisConv.Update:=0;
			END_IF;
			
			//wy³¹czanie jog-ów karetki po dojechaniu na miejsce
			IF MpAxisCart.Info.JogLimitReached THEN
				MpAxisCart.JogNegative:=0;
				MpAxisCart.JogPositive:=0;
			END_IF;
			//switch update karetki
			IF MpAxisCart.UpdateDone THEN
				MpAxisCart.Update:=0;
			END_IF;
			
			
			//wy³¹czanie jog-ów dyszy po dojechaniu na miejsce
			IF MpAxisNozzle.Info.JogLimitReached THEN
				MpAxisNozzle.JogNegative:=0;
				MpAxisNozzle.JogPositive:=0;
			END_IF;
			//switch update karetki
			IF MpAxisNozzle.UpdateDone THEN
				MpAxisNozzle.Update:=0;
			END_IF;
			
			IF NOT diManual THEN
				FillerTyp:=AUTOMAT;
			END_IF;
			
		ERROR:
		
		STOP:
		 
	END_CASE;
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

