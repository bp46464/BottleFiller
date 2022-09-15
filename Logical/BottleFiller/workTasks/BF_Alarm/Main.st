
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	BF_MpAlarm(MpLink:=ADR(gBFAlarmXCore), Enable:=TRUE);
	
	gControl.moveVelocity:= gControl.moveVelocity AND NOT error;
	gControl.Conveyor.jogNegative:= gControl.Conveyor.jogNegative AND NOT error;
	gControl.Conveyor.jogPositive:= gControl.Conveyor.jogPositive AND NOT error;
	gControl.Cart.jogNegative := gControl.Cart.jogNegative AND NOT error;
	gControl.Cart.jogPositive := gControl.Cart.jogPositive AND NOT error;
	gControl.Cart.moveVelocity := gControl.Cart.moveVelocity AND NOT error;
	gControl.Nozzle.jogNegative := gControl.Nozzle.jogNegative AND NOT error;
	gControl.Nozzle.jogPositive := gControl.Nozzle.jogPositive AND NOT error;
	gControl.Nozzle.moveVelocity := gControl.Nozzle.moveVelocity AND NOT error;

	CASE gCaseError OF
		noError:
			IF gControl.start AND NOT gControl.power THEN
				MpAlarmXSet(gBFAlarmXCore, 'noPower');
				gCaseError:=inError;
				error:=1;
			END_IF;
			IF gControl.emergencySTOP THEN
				MpAlarmXSet(gBFAlarmXCore, 'emergency');
				gCaseError:=inError;
				error:=1;
			END_IF;
			IF BF_MpAlarm.PendingAlarms <> 0 THEN
				gCaseError:=inError;
				
				error:=1;
			END_IF;
			
		inError:
			gAxisCase:=WAIT;
			gMain:=ERROR;
			gFillerTyp:=WAITING;
			IF NOT(gControl.start AND NOT gControl.power) THEN
				MpAlarmXReset(gBFAlarmXCore, 'noPower');
			END_IF;
			IF NOT(gControl.emergencySTOP) THEN
				MpAlarmXReset(gBFAlarmXCore, 'emergency');
			END_IF;
			
			IF resetError <> 0 THEN
				gCaseError:=handleError;
			END_IF;
			
			IF BF_MpAlarm.PendingAlarms=0 THEN
				
				error:=0;
				gMain:=WORK;
				IF temp THEN
					gAxisCase:=DISCONNECT;
					IF gMainAction.disconnected THEN
						gAxisCase:=CONNECT;
					END_IF;
					IF gMainAction.connected THEN
						gAxisCase:=onMOVE;
						gFillerTyp:=AUTOMAT;
						gCaseError:=noError;
					END_IF;
				ELSE
					gFillerTyp:=MANUAL;
					gAxisCase:=onMOVE;
					gCaseError:=noError;
				END_IF;
					
			END_IF;
	
		handleError:
			IF resetError = 1 THEN
				gControl.Nozzle.errorReset:=1;
				IF NOT gAxisOutputs.Nozzle.error THEN
					gControl.Nozzle.errorReset:=0;
					gCaseError:=inError;
					resetError:=0;
				END_IF;
			END_IF;
			IF resetError = 2 THEN
				gControl.Conveyor.errorReset:=1;
				IF NOT gAxisOutputs.Conveyor.error THEN
					gControl.Conveyor.errorReset:=0;
					gCaseError:=inError;
					resetError:=0;
				END_IF;
			END_IF;
			IF resetError = 3 THEN
				gControl.Cart.errorReset:=1;
				IF NOT gAxisOutputs.Cart.error THEN
					gControl.Cart.errorReset:=0;
					gCaseError:=inError;
					resetError:=0;
				END_IF;
			END_IF;
		  

	END_CASE;
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 BF_MpAlarm(Enable:=0);
END_PROGRAM

