
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	BF_MpAlarm(MpLink:=ADR(gAlarmXCore), Enable:=TRUE);
	
	gControl.moveVelocity:= gControl.moveVelocity AND NOT error;
	gControl.Conveyor.jogNegative:= gControl.Conveyor.jogNegative AND NOT error;
	gControl.Conveyor.jogPositive:= gControl.Conveyor.jogPositive AND NOT error;
	gControl.Cart.jogNegative := gControl.Cart.jogNegative AND NOT error;
	gControl.Cart.jogPositive := gControl.Cart.jogPositive AND NOT error;
	gControl.Cart.moveVelocity := gControl.Cart.moveVelocity AND NOT error;
	gControl.Nozzle.jogNegative := gControl.Nozzle.jogNegative AND NOT error;
	gControl.Nozzle.jogPositive := gControl.Nozzle.jogPositive AND NOT error;
	gControl.Nozzle.moveVelocity := gControl.Nozzle.moveVelocity AND NOT error;

	CASE caseError OF
		noError:
			IF gControl.start AND NOT gControl.power THEN
				MpAlarmXSet(gAlarmXCore, 'noPower');
				caseError:=inError;
				error:=1;
			END_IF;
			
			IF BF_MpAlarm.PendingAlarms <> 0 THEN
				caseError:=inError;
				
				error:=1;
			END_IF;
			
		inError:
			gAxisCase:=WAIT;
			gMain:=ERROR;
			gFillerTyp:=WAITING;
			IF NOT(gControl.start AND NOT gControl.power) THEN
				MpAlarmXReset(gAlarmXCore, 'noPower');
			END_IF;
			
			IF resetError <> 0 THEN
				caseError:=handleError;
			END_IF;
			
			IF BF_MpAlarm.PendingAlarms=0 THEN
				caseError:=noError;
				error:=0;
				gMain:=WORK;
				gFillerTyp:=MANUAL;
				gAxisCase:=onMOVE;
			END_IF;
	
		handleError:
			IF resetError = 1 THEN
				gControl.Nozzle.errorReset:=1;
				IF NOT gAxisOutputs.Nozzle.error THEN
					gControl.Nozzle.errorReset:=0;
					caseError:=inError;
					resetError:=0;
				END_IF;
			END_IF;
			IF resetError = 2 THEN
				gControl.Conveyor.errorReset:=1;
				IF NOT gAxisOutputs.Conveyor.error THEN
					gControl.Conveyor.errorReset:=0;
					caseError:=inError;
					resetError:=0;
				END_IF;
			END_IF;
			IF resetError = 3 THEN
				gControl.Cart.errorReset:=1;
				IF NOT gAxisOutputs.Cart.error THEN
					gControl.Cart.errorReset:=0;
					caseError:=inError;
					resetError:=0;
				END_IF;
			END_IF;
		  

	END_CASE;
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 BF_MpAlarm(Enable:=0);
END_PROGRAM

