
PROGRAM _INIT
	(* Insert code here *)
	 FillerTyp:=DISABLED;
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	
	SimulationAxisPosition.Cart := LREAL_TO_REAL(gAxisOutputs.Cart.position);
	SimulationAxisPosition.Conveyor := LREAL_TO_REAL(gAxisOutputs.Conveyor.position);
	SimulationAxisPosition.Nozzle := LREAL_TO_REAL(gAxisOutputs.Nozzle.position);
	gAdrAxesPositions := ADR(SimulationAxisPosition);

	CASE FillerTyp OF
		DISABLED: 
			diStart:=0;
			diStop:=0;
			
			IF gControl.power THEN
				FillerTyp:=INIT;
			END_IF;
			
		INIT:
			gControl.Cart.lowerLimit:=-95;
			gControl.Cart.upperLimit:=1095;
			
			gControl.Conveyor.lowerLimit:=0;
			gControl.Conveyor.upperLimit:=4997;
			
			gControl.Nozzle.lowerLimit:=2;
			gControl.Nozzle.upperLimit:=197;
			
			gAxisCase:=POWERED;
			
			IF gMainAction.powered THEN
				gAxisCase:=HOMING;
			END_IF;
			
			IF gMainAction.powered AND gMainAction.homed THEN
				gControl.Cart.home:=0;
				gControl.Conveyor.home:=0;
				gControl.Nozzle.home:=0;
				gAxisCase:=STANDSTILL;
			END_IF;
			
			IF gMainAction.powered AND gMainAction.homed AND gControl.start AND NOT gControl.manual THEN
				gAxisCase:=CONNECT;
				IF gMainAction.connected THEN
					gAxisCase:=onMOVE;
					gFillerTyp:=AUTOMAT;
					FillerTyp:=WORK;
				END_IF;	
			END_IF;
			
			IF gMainAction.powered AND gMainAction.homed AND gControl.start AND gControl.manual THEN
				gMainAction.homed:=0;
				gAxisCase:=onMOVE;
				gFillerTyp:=MANUAL;
				FillerTyp:=WORK;
			END_IF;
			
			
		WORK:			
			result:= gControl.bottleCnt MOD 5;
					
			IF result=1 THEN
				gCamSeqParam.nozzle.signal1:=1;
			END_IF;
			IF result <> 1 THEN
				gCamSeqParam.nozzle.signal1:=0;
				gCamSeqParam.cart.signal1:=0;
			END_IF;
					
			
			

		ERROR:
		
		STOP:
		 
	END_CASE;
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

