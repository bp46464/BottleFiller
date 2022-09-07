
PROGRAM _INIT
	(* Insert code here *)
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	 
	IF gAxisOutputs.Cart.updateDone THEN
	END_IF;
	
	
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
				
			
			IF switch=1 THEN
				gAxisCase:=HOMING; //<------------------------------
				IF gMainAction.homed THEN
					gControl.Cart.home:=0;
					gControl.Conveyor.home:=0;
					gControl.Nozzle.home:=0;

					gAxisCase:=CONNECT;
					gMainAction.disconnected:=0;
					IF gMainAction.connected THEN
						gMainAction.homed:=0;
						switch:=0;
						gAxisCase:=onMOVE;
					END_IF;
				END_IF;
			END_IF;
			
			IF switch=2 THEN
				gAxisCase:=DISCONNECT;
				gMainAction.connected:=0;
				IF gMainAction.disconnected THEN
					gAxisCase:=HOMING; //<------------------------------
					IF gMainAction.homed THEN
						gControl.Cart.home:=0;
						gControl.Conveyor.home:=0;
						gControl.Nozzle.home:=0;
						
						switch:=3;
						gMainAction.homed:=0;
						gAxisCase:=onMOVE;
					END_IF;	
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
		
		
	//	ERROR:
		
		//STOP:
		
	END_CASE;
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

