
PROGRAM _INIT
	(* Insert code here *)
	 gMain:=DISABLED;
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	
	SimulationAxisPosition.Cart := LREAL_TO_REAL(gAxisOutputs.Cart.position);
	SimulationAxisPosition.Conveyor := LREAL_TO_REAL(gAxisOutputs.Conveyor.position);
	SimulationAxisPosition.Nozzle := LREAL_TO_REAL(gAxisOutputs.Nozzle.position);
	gAdrAxesPositions := ADR(SimulationAxisPosition);

	CASE gMain OF
		DISABLED: 
			diStart:=0;
			diStop:=0;
			
			IF gControl.power THEN
				gMain:=INIT;
			END_IF;
			
		INIT:
			gControl.Cart.lowerLimit:=-95;
			gControl.Cart.upperLimit:=1095;
			
			gControl.Conveyor.lowerLimit:=0;
			gControl.Conveyor.upperLimit:=4997;
			
			gControl.Nozzle.lowerLimit:=2;
			gControl.Nozzle.upperLimit:=197;
			
			gAxisCase:=POWERED;
			
			IF gMainAction.powered AND NOT gControl.inCam THEN
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
					gMain:=WORK;
				END_IF;	
			END_IF;
			
			IF gMainAction.powered AND gMainAction.homed AND gControl.start AND gControl.manual THEN
				gMainAction.homed:=0;
				gAxisCase:=onMOVE;
				gFillerTyp:=MANUAL;
				gMain:=WORK;
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
					
			IF (gCamSeqParam.nozzle.currentStateIndex = 3) AND (gAxisOutputs.Nozzle.position > 0 AND gAxisOutputs.Nozzle.position < 170) THEN
				gPump.ValveRelay:=1;
				gPump.ValveStatus:='Opened';
			ELSE
				gPump.ValveRelay:=0;
				gPump.ValveStatus:='Closed';
			END_IF;

		ERROR:
			
			IF EDGENEG(gControl.emergencySTOP) THEN
				gMain:=WORK;
			END_IF;
			
		STOP:
		 
	END_CASE;
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

