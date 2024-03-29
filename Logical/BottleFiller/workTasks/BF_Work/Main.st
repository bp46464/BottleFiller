
PROGRAM _INIT
	(* Insert code here *)
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	
	CASE gFillerTyp OF
			
		MANUAL:
			//wy��czenie jeg�w od razu po zatrzymaniu ruchu - wcze�niej by� b��d 
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
				
			//Switch zale�ny od tego, czy osie maj� by� po��czone, czy roz��czone
			IF EDGEPOS(gControl.inCam) THEN
				switch:=1;
			END_IF;
			
			IF EDGENEG(gControl.inCam) THEN
				switch:=2;
			END_IF;
				
			//��czenie osi
			IF switch=1 OR EDGEPOS(gControl.inCam) THEN
				IF NOT gMainAction.stopped THEN
					gAxisCase:=HOLDON;
				END_IF;
				
				IF gMainAction.stopped AND NOT gMainAction.homed THEN
					gAxisCase:=HOMING;
				END_IF;
				
				IF gMainAction.stopped AND gMainAction.homed AND NOT gMainAction.connected THEN
					gControl.Cart.home:=0;
					gControl.Conveyor.home:=0;
					gControl.Nozzle.home:=0;
					gControl.startSeq:=1;
					gMainAction.disconnected:=0;
					gAxisCase:=CONNECT;
				END_IF;

				IF gMainAction.stopped AND gMainAction.connected AND gMainAction.homed THEN
					gMainAction.homed:=0;
					gMainAction.stopped:=0;
					gAxisCase:=onMOVE;
					switch:=3;
				END_IF;
			END_IF;
			
			//roz��czanie osi
			IF switch=2 OR EDGENEG(gControl.inCam) THEN
				IF NOT gMainAction.disconnected THEN
					gAxisCase:=DISCONNECT;
					gMainAction.connected:=0;
				END_IF;
				
				IF gMainAction.disconnected THEN
					gControl.Cart.home:=0;
					gControl.Conveyor.home:=0;
					gControl.Nozzle.home:=0;
					gMainAction.homed:=0;
					gAxisCase:=onMOVE;
					IF gAxisCase=onMOVE THEN
						switch:=4;
					END_IF;
				END_IF;	
			END_IF;
			
			//wchodzenie ponownie w tryb automatyczny
			IF NOT gControl.manual AND NOT temp THEN
				gControl.switchToAutomat:=1;
				IF NOT gMainAction.stopped THEN
					gAxisCase:=HOLDON;
				END_IF;
				
				gAxisUpdate.Conveyor.Velocity:=tempVelocity;
				gControl.needUpdate:=1;
				
				IF gMainAction.stopped AND switch=4 THEN
					gAxisCase:=HOMING;
				END_IF;
				
				IF (switch=3 AND gMainAction.stopped) OR (switch=4 AND gMainAction.homed) THEN
					gAxisCase:=CONNECT;
					gMainAction.disconnected:=0;
					IF gMainAction.connected THEN
						gMainAction.homed:=0;
						gMainAction.stopped:=0;
						switch:=0;
						gFillerTyp:=AUTOMAT;
						gAxisCase:=onMOVE;
						gControl.switchToAutomat:=0;
					END_IF;
				END_IF;	
			END_IF;
			
			//zabezpieczenia przed przejechaniem manualnym poza limit
			IF gAxisOutputs.Cart.position <= gControl.Cart.lowerLimit OR gAxisOutputs.Cart.position >= gControl.Cart.upperLimit THEN
				gControl.Cart.safeLevelStop:=1;
				IF gAxisOutputs.Cart.position >= gControl.Cart.upperLimit THEN
					gControl.Cart.onlyLeft:=1;
				ELSE
					gControl.Cart.onlyRight:=1;
				END_IF;
			ELSE
				gControl.Cart.onlyLeft:=0;
				gControl.Cart.onlyRight:=0;
				gControl.Cart.safeLevelStop:=0;
			END_IF;


			IF gAxisOutputs.Nozzle.position <= gControl.Nozzle.lowerLimit OR gAxisOutputs.Nozzle.position >= gControl.Nozzle.upperLimit THEN
				gControl.Nozzle.safeLevelStop:=1;
				IF gAxisOutputs.Nozzle.position <= gControl.Nozzle.lowerLimit THEN
					gControl.Nozzle.onlyRight:=1;
				ELSE
					gControl.Nozzle.onlyLeft:=1;
				END_IF;
			ELSE
				gControl.Nozzle.safeLevelStop:=0;
				gControl.Nozzle.onlyLeft:=0;
				gControl.Nozzle.onlyRight:=0;
			END_IF;
	
		AUTOMAT:
			//w przypadku naci�ni�cia przycisku Stop Machine maszyna zatrzyma si� po nape�nieniu butelek, w state 4
			IF gControl.stop THEN
				IF gCamSeqParam.nozzle.currentStateIndex = 4 THEN
					gControl.moveVelocity:=0;		
				END_IF;
			ELSE
				gControl.moveVelocity:=gControl.start AND NOT gControl.stop AND gControl.power;
			END_IF;
			
			//prze��czenie z automatu na manual
			IF gControl.manual THEN
				gControl.moveVelocity:=0;
				gAxisCase:=DISCONNECT;
				tempVelocity:=gAxisOutputs.velocity;
				IF gMainAction.disconnected THEN
					gFillerTyp:=MANUAL;
				END_IF;
			END_IF;
	END_CASE;
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

