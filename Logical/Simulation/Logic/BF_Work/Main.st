
PROGRAM _INIT
	(* Insert code here *)
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	
	CASE gFillerTyp OF
			
		MANUAL:
			
			IF EDGENEG(gAxisOutputs.Cart.MoveActive) THEN
				gControl.Cart.jogNegative:=0;
				gControl.Cart.jogPositive:=0;
			END_IF;

			IF EDGENEG(gAxisOutputs.Conveyor.MoveActive) THEN
				gControl.Conveyor.jogNegative:=0;
				gControl.Conveyor.jogPositive:=0;
			END_IF;
			IF 	EDGENEG(gAxisOutputs.Nozzle.MoveActive) THEN
				gControl.Nozzle.jogNegative:=0;
				gControl.Nozzle.jogPositive:=0;
			END_IF;
				
			IF EDGEPOS(gControl.inCam) THEN
				switch:=1;
			END_IF;
			IF EDGENEG(gControl.inCam) THEN
				switch:=2;
			END_IF;
				
			
			IF switch=1 OR EDGEPOS(gControl.inCam) THEN
				IF NOT gMainAction.homed THEN
					gAxisCase:=HOMING; //<------------------------------
				END_IF;
				
				IF gMainAction.homed AND NOT gMainAction.connected THEN
					gMainAction.disconnected:=0;
					gAxisCase:=CONNECT;
				END_IF;

				IF gMainAction.connected AND gMainAction.homed THEN
					gControl.Cart.home:=0;
					gControl.Conveyor.home:=0;
					gControl.Nozzle.home:=0;
					gMainAction.homed:=0;
					switch:=0;
					gAxisCase:=onMOVE;
				END_IF;
			END_IF;
			
			IF switch=2 OR EDGENEG(gControl.inCam) THEN
				IF NOT gMainAction.disconnected THEN
					gAxisCase:=DISCONNECT;
					gMainAction.connected:=0;
				END_IF;
				
				IF gMainAction.disconnected AND NOT gMainAction.homed THEN
					gAxisCase:=HOMING; //<------------------------------
				END_IF;
				
				IF gMainAction.homed AND gMainAction.disconnected THEN
					gControl.Cart.home:=0;
					gControl.Conveyor.home:=0;
					gControl.Nozzle.home:=0;
					switch:=3;
					gMainAction.homed:=0;
					gAxisCase:=onMOVE;
				END_IF;	
			END_IF;
			
			IF NOT gControl.manual THEN
				IF switch=3 THEN
					gAxisCase:=CONNECT;
					gMainAction.disconnected:=0;
					IF gMainAction.connected THEN
						switch:=0;
						gFillerTyp:=AUTOMAT;
						gAxisCase:=onMOVE;
					END_IF;
				ELSE
					gAxisCase:=HOMING;
					IF gMainAction.homed THEN
						gControl.Cart.home:=0;
						gControl.Conveyor.home:=0;
						gControl.Nozzle.home:=0;
						gAxisCase:=CONNECT;
						gMainAction.disconnected:=0;
						IF gMainAction.connected THEN
							gMainAction.homed:=0;
							switch:=0;
							gFillerTyp:=AUTOMAT;
							gAxisCase:=onMOVE;
						END_IF;
					END_IF;
				END_IF;
				
			END_IF;
				
		AUTOMAT:

			gControl.moveVelocity:= gControl.start AND (NOT gControl.stop);  
			IF gControl.manual THEN
				gControl.moveVelocity:=0;
				gAxisCase:=DISCONNECT;
				IF gMainAction.disconnected THEN
					gFillerTyp:=MANUAL;
				END_IF;
			END_IF;
		
	END_CASE;
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

