
PROGRAM _INIT
	(* Insert code here *)
	
	//Conveyor parameters
	MpAxisConvParType.AutoTune.Mode:=mcAXIS_TUNE_AUTOMATIC;
	MpAxisConvParType.AutoTune.MaxCurrentPercent:=80;
	MpAxisConvParType.AutoTune.MaxDistance:=30;
	MpAxisConvParType.AutoTune.SaveControllerSettings:=1;
	MpAxisConvParType.AutoTune.MaxPositionError:=30;
	//Nozzle parameters
	MpAxisNozzleParType := MpAxisConvParType;
	MpAxisNozzleParType.Homing.Position:=195;
	//Cart parameters
	MpAxisCartParType := MpAxisConvParType;
	
	//dynamiczna zmiana cam�w
	camNozzleParameters.CamSequence.Get.GetOnEnable:=1;
	camNozzleParameters.CamSequence.Get.Command:=mcGET_PAR_ACTUAL;
	camNozzleParameters.CamSequence.Data.DataAddress:=ADR(configCamNozzle);
	camNozzleParameters.CamSequence.Data.DataSize:=SIZEOF(configCamNozzle);
	camNozzleParameters.CamSequence.Set.Command:=mcSET_UPDATE_FROM_ADR;
	camNozzleParameters.CamSequence.Set.Mode:=mcAXIS_CAM_SEQ_SET_ON_UPDATE;
	MpAxisConv.AutoTune:=1;
	MpAxisCart.AutoTune:=1;
	MpAxisNozzle.AutoTune:=1;
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	
	IF gControl.emergencySTOP THEN
		gAxisCase:=STANDSTILL;
		gMain:=STOP;
		gFillerTyp:=WAITING;
	END_IF;
	
	IF MpAxisConv.Info.AutoTuneDone THEN
		MpAxisConv.AutoTune:=0;
		MpAxisCart.AutoTune:=0;
		MpAxisNozzle.AutoTune:=0;
	END_IF;
	
	//deklaracja osi
	MpAxisConv(MpLink := ADR(axisConv), Enable := 1, Parameters := ADR(MpAxisConvParType));
	MpAxisCart(MpLink := ADR(axisCart), Enable := 1, Parameters := ADR(MpAxisCartParType));
	MpAxisNozzle(MpLink := ADR(axisNozzle), Enable := 1, Parameters := ADR(MpAxisNozzleParType));
	
	//sequence parameters
	configCamNozzle.State[3].CamID:=STRING_TO_USINT(gControl.currentBottleType);
	
	//Sequence declaration
	camSeq(MpLink := ADR(axisCart), Enable := 1, Parameters := ADR(camParameters), MpLinkMaster := ADR(axisConv));
	camSeqNozzle(MpLink := ADR(axisNozzle), Enable := 1, Parameters := ADR(camNozzleParameters), MpLinkMaster := ADR(axisConv));
	
	//conveyor management
	MpAxisConvParType.Velocity:=gAxisUpdate.Conveyor.Velocity;
	MpAxisConv.ErrorReset:=gControl.Conveyor.errorReset;
	MpAxisConv.Power:=gControl.power;
	MpAxisConv.Home:=gControl.Conveyor.home;
	MpAxisConv.Stop:=gControl.Conveyor.stop;
	MpAxisConv.JogNegative:=gControl.Conveyor.jogNegative;
	MpAxisConv.JogPositive:=gControl.Conveyor.jogPositive;
	
	//Cart management
	MpAxisCart.ErrorReset:=gControl.Cart.errorReset;
	MpAxisCart.Power:=gControl.power;
	MpAxisCart.Home:=gControl.Cart.home;
	MpAxisCart.Stop:=gControl.Cart.stop;
	MpAxisCart.MoveVelocity:=gControl.Cart.moveVelocity;
	MpAxisCart.JogNegative:=gControl.Cart.jogNegative;
	MpAxisCart.JogPositive:=gControl.Cart.jogPositive;
	
	
	//nozzle Management
	MpAxisNozzle.ErrorReset:=gControl.Nozzle.errorReset;
	MpAxisNozzle.Power:=gControl.power;
	MpAxisNozzle.Home:=gControl.Nozzle.home;
	MpAxisNozzle.Stop:=gControl.Nozzle.stop;
	MpAxisNozzle.JogNegative:=gControl.Nozzle.jogNegative;
	MpAxisNozzle.MoveVelocity:=gControl.Nozzle.moveVelocity;
	MpAxisNozzle.JogPositive:=gControl.Nozzle.jogPositive;
	
	//cam params
	camSeqNozzle.Signal1:=gCamSeqParam.nozzle.signal1;
	
	//aktualizacja predkosci po kliknieciu przycisku manipulujacego predkoscia o +-5%
	IF gControl.partVelUpd THEN
		MpAxisConvParType.Velocity:=gAxisUpdate.Conveyor.Velocity;
		MpAxisConv.Update:=1;
		gControl.partVelUpd:=0;
	END_IF;	

	//aktualizacja osi po zmianie parametr�w
	IF gControl.needUpdate THEN
		//conveyor
		IF gControl.manual THEN
			MpAxisConvParType.Velocity:=gAxisUpdate.Conveyor.Velocity;
		ELSE
			MpAxisConvParType.Velocity:=STRING_TO_UINT(gAxisUpdate.staticVelocity);
			gAxisUpdate.Conveyor.Velocity:=STRING_TO_UINT(gAxisUpdate.staticVelocity);
		END_IF;
		
		MpAxisConvParType.Jog.LimitPosition.FirstPosition:=gAxisUpdate.Conveyor.FirstPosition;
		MpAxisConvParType.Jog.LimitPosition.LastPosition:=gAxisUpdate.Conveyor.LastPosition;
		MpAxisConvParType.Position:=gAxisUpdate.Conveyor.Position;
		MpAxisConvParType.Jog.Velocity:=gAxisUpdate.Conveyor.Velocity;
		
		//velocity range update
		gControl.maxVelocity:= 1.2 * STRING_TO_UINT(gAxisUpdate.staticVelocity);
		gControl.minVelocity:= 0.8 * STRING_TO_UINT(gAxisUpdate.staticVelocity);
		gControl.part:=0.05 * STRING_TO_UINT(gAxisUpdate.staticVelocity);
		gControl.incVisible:=1;
		gControl.decVisible:=1;
		
		//cart
		MpAxisCartParType.Jog.LimitPosition.FirstPosition:=gAxisUpdate.Cart.FirstPosition;
		MpAxisCartParType.Jog.LimitPosition.LastPosition:=gAxisUpdate.Cart.LastPosition;
		MpAxisCartParType.Position:=gAxisUpdate.Cart.Position;
		MpAxisCartParType.Jog.Velocity:=gAxisUpdate.Conveyor.Velocity;
		MpAxisCartParType.Velocity:=gAxisUpdate.Conveyor.Velocity;
			
		//nozzle
		MpAxisNozzleParType.Jog.LimitPosition.FirstPosition:=gAxisUpdate.Nozzle.FirstPosition;
		MpAxisNozzleParType.Jog.LimitPosition.LastPosition:=gAxisUpdate.Nozzle.LastPosition;
		MpAxisNozzleParType.Position:=gAxisUpdate.Nozzle.Position;
		MpAxisNozzleParType.Jog.Velocity:=gAxisUpdate.Conveyor.Velocity;
		MpAxisNozzleParType.Velocity:=gAxisUpdate.Conveyor.Velocity;
		
		camParameters.Offset.Velocity:=gAxisUpdate.Conveyor.Velocity+30;
		camNozzleParameters.Offset.Velocity:=gAxisUpdate.Conveyor.Velocity+30;
		
		
		MpAxisNozzle.Update:=1;
		MpAxisConv.Update:=1;
		MpAxisCart.Update:=1;
		gControl.needUpdate:=0;
	END_IF;
	
	
	
		
		
	CASE gAxisCase OF
		HOLDON:
			MpAxisCart.Stop:=1;
			MpAxisConv.Stop:=1;
			MpAxisNozzle.Stop:=1;
			IF MpAxisConv.Stopped AND MpAxisNozzle.Stopped AND MpAxisCart.Stopped THEN
				MpAxisCart.Stop:=0;
				MpAxisConv.Stop:=0;
				MpAxisNozzle.Stop:=0;
				stopHelper:=1;
			END_IF;
			IF stopHelper=1 THEN
				IF  MpAxisConv.Info.PLCopenState = mcAXIS_STANDSTILL AND MpAxisCart.Info.PLCopenState = mcAXIS_STANDSTILL AND MpAxisNozzle.Info.PLCopenState = mcAXIS_STANDSTILL THEN
					gMainAction.stopped:=1;
					stopHelper:=0;
				END_IF;
			END_IF;

		POWERED:
			IF (gControl.power AND NOT gAxisOutputs.Conveyor.error) THEN
				//power on axis
				MpAxisCart.Power:=1;
				MpAxisConv.Power:=1;
				MpAxisNozzle.Power:=1;
				
				IF MpAxisCart.PowerOn AND MpAxisConv.PowerOn AND MpAxisNozzle.PowerOn THEN
					gMainAction.powered:=1;
				END_IF;
				
			END_IF;
			
		HOMING:
			gControl.bottleCnt:=0;
			IF MpAxisCart.Info.PLCopenState = mcAXIS_STANDSTILL THEN
				MpAxisConv.Home:=1;
				MpAxisNozzle.Home:=1;
				MpAxisCart.Home:=1;
				
			END_IF;
			
			IF MpAxisCart.Info.PLCopenState = mcAXIS_HOMING THEN
				connectHelper:=15;
			END_IF;
			
			IF connectHelper=15 AND MpAxisCart.Info.PLCopenState = mcAXIS_STANDSTILL THEN
				gMainAction.homed:=1;
			END_IF;
			
		STANDSTILL:
			IF gControl.start THEN
				IF gControl.manual THEN
					gAxisCase:=onMOVE;
				ELSE
					IF gControl.inCam THEN
						gAxisCase:=onMOVE;
					ELSE
						gAxisCase:=CONNECT;
					END_IF;
					
				END_IF;
			END_IF;
			
		CONNECT:
			camSeq.EndSequence:=0;
			camSeqNozzle.EndSequence:=0;
			
			IF NOT gControl.manual AND NOT gControl.switchToAutomat THEN
				camSeq.StartSequence:=1;
				camSeqNozzle.StartSequence:=1;
			ELSE
				IF camSeq.Error THEN
					camSeq.ErrorReset:=1;
					timer.IN:=TRUE;
					timer.PT:=t#100ms;
					IF timer.Q THEN
						timer.IN:=FALSE;
						camSeq.StartSequence:=0;
					END_IF;
				END_IF;
				IF camSeq.StartSequence=0 THEN
					
					timer.IN:=TRUE;
					timer.PT:=t#200ms;
					IF timer.Q THEN
						timer.IN:=FALSE;
						camSeq.StartSequence:=1;
						camSeqNozzle.StartSequence:=1;
					END_IF;
				END_IF;
				
			END_IF;
			IF camSeq.InCam AND camSeqNozzle.InCam  THEN
				camSeq.Signal1:=1;
				gMainAction.connected:=1;
				connectHelper:=0;
			END_IF;
		
		DISCONNECT:
			gMainAction.connected:=0;
			MpAxisConv.MoveVelocity:=0;
			camSeq.Signal1:=0;
			camSeqNozzle.Signal1:=0;
			camSeq.StartSequence:=0;
			camSeq.EndSequence:=1;
			camSeqNozzle.StartSequence:=0;
			camSeqNozzle.EndSequence:=1;
			IF NOT (camSeq.Running AND camSeqNozzle.Running) THEN
				gMainAction.disconnected:=1;
			END_IF;
				
			
		onMOVE:
			//karetka
			IF mouseEvent THEN
				IF gControl.Cart.safeLevelStop THEN
					gControl.Cart.stop:=gControl.Cart.safeLevelStop;
					IF MpAxisCartParType.Direction = 1 AND MpAxisCart.Position >= gControl.Cart.upperLimit THEN
						gControl.Cart.safeLevelStop:=0;
						gControl.Cart.stop:=0;
					ELSIF MpAxisCartParType.Direction = 0 AND MpAxisCart.Position <= gControl.Cart.lowerLimit THEN
						gControl.Cart.safeLevelStop:=0;
						gControl.Cart.stop:=0;
					END_IF;
				END_IF;
				
				IF gControl.Nozzle.safeLevelStop THEN
					gControl.Nozzle.stop:=gControl.Nozzle.safeLevelStop;
					IF MpAxisNozzleParType.Direction = 1 AND MpAxisNozzle.Position >= gControl.Nozzle.upperLimit THEN
						gControl.Nozzle.safeLevelStop:=0;
						gControl.Nozzle.stop:=0;
					ELSIF MpAxisNozzleParType.Direction = 0 AND MpAxisNozzle.Position <= gControl.Nozzle.lowerLimit THEN
						gControl.Nozzle.safeLevelStop:=0;
						gControl.Nozzle.stop:=0;
					END_IF;
				END_IF;
				
				
				MpAxisConv.MoveVelocity:=gControl.moveVelocity;
				

				IF gControl.Cart.onlyRight AND MpAxisCartParType.Direction = 0 THEN
					gControl.Cart.stop:=0;
					MpAxisCart.MoveVelocity:=gControl.Cart.moveVelocity;
				END_IF;
				
				IF gControl.Cart.onlyLeft AND MpAxisCartParType.Direction = 1 THEN
					gControl.Cart.stop:=0;
					MpAxisCart.MoveVelocity:=gControl.Cart.moveVelocity;
				END_IF;
				
				IF NOT gControl.Cart.onlyLeft AND NOT gControl.Cart.onlyRight THEN
					MpAxisCart.MoveVelocity:= NOT gControl.Cart.safeLevelStop AND gControl.Cart.moveVelocity;
				END_IF;	
				

				//nozzle
				IF gControl.Nozzle.onlyRight AND MpAxisNozzleParType.Direction = 0 THEN
					gControl.Nozzle.stop:=0;
					MpAxisNozzle.MoveVelocity:=gControl.Nozzle.moveVelocity;
				END_IF;
				
				IF gControl.Nozzle.onlyLeft AND MpAxisNozzleParType.Direction = 1 THEN
					gControl.Nozzle.stop:=0;
					MpAxisNozzle.MoveVelocity:=gControl.Nozzle.moveVelocity;
				END_IF;
				
				IF NOT gControl.Nozzle.onlyLeft AND NOT gControl.Nozzle.onlyRight THEN
					MpAxisNozzle.MoveVelocity:= NOT gControl.Nozzle.safeLevelStop AND gControl.Nozzle.moveVelocity;
				END_IF;	
			ELSE
				MpAxisConv.MoveVelocity:=gControl.moveVelocity;
				MpAxisConv.JogNegative:=gControl.Conveyor.jogNegative;
				MpAxisConv.JogPositive:=gControl.Conveyor.jogPositive;
				MpAxisCart.JogNegative:=gControl.Cart.jogNegative;
				MpAxisCart.JogPositive:=gControl.Cart.jogPositive;
				MpAxisNozzle.JogNegative:=gControl.Nozzle.jogNegative;
				MpAxisNozzle.JogPositive:=gControl.Nozzle.jogPositive;
			END_IF;
			IF MpAxisConv.Position > 0 THEN
				gMainAction.homed:=0;
			END_IF;
			
	END_CASE;
	
	controlInfo.Conveyor.error:=MpAxisConv.Error;
	controlInfo.Conveyor.isHomed:=MpAxisConv.IsHomed;
	controlInfo.Conveyor.isPowered:=MpAxisConv.PowerOn;
	controlInfo.Conveyor.position:=LREAL_TO_REAL(MpAxisConv.Position);
	controlInfo.Conveyor.velocity:=MpAxisConv.Velocity;
	controlInfo.Conveyor.updateDone:=MpAxisConv.UpdateDone;
	controlInfo.Conveyor.MoveActive:=MpAxisConv.Info.Jogging;
	
	controlInfo.Cart.error:=MpAxisCart.Error;
	controlInfo.Cart.isHomed:=MpAxisCart.IsHomed;
	controlInfo.Cart.isPowered:=MpAxisCart.PowerOn;
	controlInfo.Cart.position:=LREAL_TO_REAL(MpAxisCart.Position);
	controlInfo.Cart.velocity:=MpAxisCart.Velocity;
	controlInfo.Cart.updateDone:=MpAxisCart.UpdateDone;
	controlInfo.Cart.MoveActive:=MpAxisCart.Info.Jogging;
	
	controlInfo.Nozzle.error:=MpAxisNozzle.Error;
	controlInfo.Nozzle.isHomed:=MpAxisNozzle.IsHomed;
	controlInfo.Nozzle.isPowered:=MpAxisNozzle.PowerOn;
	controlInfo.Nozzle.position:=LREAL_TO_REAL(MpAxisNozzle.Position);
	controlInfo.Nozzle.velocity:=MpAxisNozzle.Velocity;
	controlInfo.Nozzle.updateDone:=MpAxisNozzle.UpdateDone;
	controlInfo.Nozzle.MoveActive:=MpAxisNozzle.Info.Jogging;

	controlInfo.velocity:=MpAxisConvParType.Velocity;
	
	gCamSeqParam.cart.currentStateIndex:=camSeq.ActualStateIndex;
	gCamSeqParam.nozzle.currentStateIndex:=camSeqNozzle.ActualStateIndex;
	
	gAxisOutputs:=controlInfo;
	
	IF camSeq.OffsetDone THEN
		camSeq.OffsetShift:=0;
	END_IF;
	IF camSeqNozzle.OffsetDone THEN
		camSeqNozzle.OffsetShift:=0;
	END_IF;
	
	IF camSeqNozzle.UpdateDone THEN
		camSeqNozzle.Update:=0;
	END_IF;
	IF MpAxisConv.UpdateDone THEN
		MpAxisConv.Update:=0;
	END_IF;
	IF MpAxisNozzle.UpdateDone THEN
		MpAxisNozzle.Update:=0;
	END_IF;
	IF MpAxisCart.UpdateDone THEN
		MpAxisCart.Update:=0;
	END_IF;
	timer();
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

