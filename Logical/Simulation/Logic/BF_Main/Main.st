
PROGRAM _INIT
	(* Insert code here *)
	 FillerTyp:=DISABLED;
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
//	MpBFRecipeXml(MpLink := ADR(BFRecipe) , Enable := 1, DeviceName := ADR('USER') , FileName := ADR('BottleFillerRecipe'));
//	MpBFRecipeRegPar(MpLink := ADR(BFRecipe), Enable := 1, PVName := ADR('BootleFiller:bottleFillerRecipeTyp'));
//	MpBFRecipeHMI(MpLink := ADR(BFRecipe), Enable := 1 , ErrorReset := , UISetup := ADR(UISetup) , UIConnect := ADR(MpRecipeUIConnectType));

//	MpAxisConv(MpLink := ADR(axisConv), Enable := 1, Parameters := ADR(MpAxisConvParType), AutoTune := 1);
//	MpAxisCart(MpLink := ADR(axisCart), Enable := 1, Parameters := ADR(MpAxisCartParType),   AutoTune := 1);
//	MpAxisNozzle(MpLink := ADR(axisNozzle), Enable := 1, Parameters := ADR(MpAxisNozzleParType),  AutoTune := 1);
//	
//
//	MpBFRecipeXml();
	

	
	
	SimulationAxisPosition.Cart := LREAL_TO_REAL(gAxisOutputs.Cart.position);
	SimulationAxisPosition.Conveyor := LREAL_TO_REAL(gAxisOutputs.Conveyor.position);
	SimulationAxisPosition.Nozzle := LREAL_TO_REAL(gAxisOutputs.Nozzle.position);
	gAdrAxesPositions := ADR(SimulationAxisPosition);
	//MpBFRecipeHMI();
	CASE FillerTyp OF
		DISABLED: 
			diStart:=0;
			diStop:=0;
			
			IF gControl.power THEN
				FillerTyp:=INIT;
			END_IF;
			
		INIT:
			gAxisCase:=POWERED;
			
			IF gMainAction.powered THEN
				gAxisCase:=HOMING;
			END_IF;
			
			IF gMainAction.powered AND gMainAction.homed THEN
				gAxisCase:=STANDSTILL;
			END_IF;
			
			IF gMainAction.powered AND gMainAction.homed AND gControl.start AND NOT gControl.manual THEN
				gAxisCase:=CONNECT;
				IF gMainAction.connected THEN
					gAxisCase:=onMOVE;
					gFillerTyp:=AUTOMAT;
				END_IF;	
			END_IF;
			
			IF gMainAction.powered AND gMainAction.homed AND gControl.start AND gControl.manual THEN
				gAxisCase:=onMOVE;
				gFillerTyp:=MANUAL;
				FillerTyp:=WORK;
			END_IF;
			
			
		WORK:
			gMainAction.homed:=0;
			
			IF gControl.inCam THEN
				gAxisCase:=CONNECT;
				IF gMainAction.connected THEN
					gAxisCase:=onMOVE;
				END_IF;
			END_IF;
			
			IF gControl.disconnect THEN
				gControl.inCam:=0;
				gAxisCase:=DISCONNECT;
				IF gMainAction.disconnected THEN
					gAxisCase:=HOMING; //<------------------------------
					IF gMainAction.homed THEN
						gAxisCase:=onMOVE;
					END_IF;
					
				END_IF;
			END_IF;
			
			
		//AUTOMAT:
//			IF camSeq.InCam AND camSeqNozzle.InCam THEN
//				
//				camSeq.Signal1:=1;
//				camSeqNozzle.Signal1:=1;
//				MpAxisConv.MoveVelocity := (diStart AND NOT diStop);
//				IF MpAxisConv.UpdateDone THEN
//					MpAxisConv.Update:=0;
//				END_IF;
//				
//			END_IF;
			
		//SERVICE:
			//odpalenie cam-�w
//			IF inCam THEN
//				IF changedPosition THEN
//					
//					MpAxisCartParType.Homing.Mode:=141;
//					MpAxisCartParType.Homing.Options.HomingVelocity:=50;
//					MpAxisCart.Update:=1;
//					
//					
//					MpAxisConvParType.Homing.Mode:=141;
//					MpAxisConvParType.Homing.Options.HomingVelocity:=50;
//					MpAxisConv.Update:=1;
//					
//					
//					
//					MpAxisNozzleParType.Homing.Mode:=141;
//					MpAxisNozzleParType.Homing.Options.HomingVelocity:=50;
//					MpAxisNozzle.Update:=1;
//					
//					IF MpAxisCart.UpdateDone THEN
//						MpAxisCart.Home:=1;
//						MpAxisCart.Update:=0;
//					END_IF;
//					IF MpAxisConv.UpdateDone THEN
//						MpAxisConv.Home:=1;
//						
//						MpAxisConv.Update:=0;
//					END_IF;
//					IF MpAxisNozzle.UpdateDone THEN
//						MpAxisNozzle.Home:=1;
//						
//						MpAxisNozzle.Update:=0;
//					END_IF;
//					changedPosition:=0;
//				END_IF;
//				
//				IF camSeq.InCam AND camSeqNozzle.InCam THEN
//					camSeq.Signal1:=1;
//					camSeqNozzle.Signal1:=1;			
//				END_IF;
//				
//				IF camSeq.Signal1 AND camSeqNozzle.Signal1 THEN
//					
//					IF MpAxisConv.InPosition THEN
//						MpAxisConv.MoveAbsolute:=0;
//						MpAxisConv.MoveAdditive:=0;
//						MpAxisConv.MoveVelocity:=0;
//					END_IF;
//					//switch update ta�my
//					
//					IF MpAxisConv.UpdateDone THEN
//						MpAxisConv.Update:=0;
//					END_IF;
//				END_IF;
//					
//			END_IF;
//			
//			//wy��czenie cam-�w
//			IF EDGENEG(inCam) THEN
//				camSeq.StartSequence:=0;
//				camSeqNozzle.StartSequence:=0;
//				camSeq.Signal1:=0;
//				camSeqNozzle.Signal1:=0;	
//			END_IF;
//			
//			//obs�uga zmiany kierunk�w ruchu urz�dze� przy obs�udze manualnej
//			IF EDGEPOS(MpAxisConv.MoveAbsolute) THEN
//				IF MpAxisConv.Position > MpAxisConvParType.Position THEN
//					MpAxisConvParType.Direction:=mcDIR_NEGATIVE;
//					MpAxisConv.Update:=1;
//				ELSIF MpAxisConv.Position < MpAxisConvParType.Position THEN
//					MpAxisConvParType.Direction:=mcDIR_POSITIVE;
//					MpAxisConv.Update:=1;
//				END_IF;
//			END_IF;
//			
//			
//			

//			
//			IF NOT diManual THEN
//				FillerTyp:=AUTOMAT;
//			END_IF;
//			
		ERROR:
		
		STOP:
		 
	END_CASE;
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM
