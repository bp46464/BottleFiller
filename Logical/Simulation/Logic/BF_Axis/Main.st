
PROGRAM _INIT
	(* Insert code here *)
	//Conveyor parameters
	MpAxisConvParType.AutoTune.Mode:=mcAXIS_TUNE_AUTOMATIC;
	MpAxisConvParType.AutoTune.MaxCurrentPercent:=80;
	MpAxisConvParType.AutoTune.MaxDistance:=30;
	MpAxisConvParType.AutoTune.MaxPositionError:=30;
	//Nozzle parameters
	MpAxisNozzleParType := MpAxisConvParType;
	MpAxisNozzleParType.Homing.Position:=195;
	//Cart parameters
	MpAxisCartParType := MpAxisConvParType;
	
	camNozzleParameters.CamSequence.Get.GetOnEnable:=1;
	camNozzleParameters.CamSequence.Get.Command:=mcGET_PAR_ACTUAL;
	camNozzleParameters.CamSequence.Data.DataAddress:=ADR(configCamNozzle);
	camNozzleParameters.CamSequence.Data.DataSize:=SIZEOF(configCamNozzle);
	camNozzleParameters.CamSequence.Set.Command:=mcSET_UPDATE_FROM_ADR;
	camNozzleParameters.CamSequence.Set.Mode:=mcAXIS_CAM_SEQ_SET_ON_UPDATE;
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	//axis declaration
	MpAxisConv(MpLink := ADR(axisConv), Enable := 1, Parameters := ADR(MpAxisConvParType), AutoTune := 1);
	MpAxisCart(MpLink := ADR(axisCart), Enable := 1, Parameters := ADR(MpAxisCartParType),   AutoTune := 1);
	MpAxisNozzle(MpLink := ADR(axisNozzle), Enable := 1, Parameters := ADR(MpAxisNozzleParType),  AutoTune := 1);
	
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
	MpAxisCart.JogNegative:=gControl.Cart.jogNegative;
	MpAxisCart.JogPositive:=gControl.Cart.jogPositive;
	
	
	//nozzle Management
	MpAxisNozzle.ErrorReset:=gControl.Nozzle.errorReset;
	MpAxisNozzle.Power:=gControl.power;
	MpAxisNozzle.Home:=gControl.Nozzle.home;
	MpAxisNozzle.Stop:=gControl.Nozzle.stop;
	MpAxisNozzle.JogNegative:=gControl.Nozzle.jogNegative;
	MpAxisNozzle.JogPositive:=gControl.Nozzle.jogPositive;
	
	//cam params
//	camSeq.Signal1:=gCamSeqParam.cart.signal1;
	camSeqNozzle.Signal1:=gCamSeqParam.nozzle.signal1;
	

	
	IF camSeqNozzle.UpdateDone THEN
		camSeqNozzle.Update:=0;
	END_IF;
	IF MpAxisConv.UpdateDone THEN
		MpAxisConv.Update:=0;
	END_IF;
	
	IF gControl.needUpdate THEN

		//conveyor
		MpAxisConvParType.Velocity:=STRING_TO_UINT(gAxisUpdate.staticVelocity);
		MpAxisConvParType.Jog.LimitPosition.FirstPosition:=gAxisUpdate.Conveyor.FirstPosition;
		MpAxisConvParType.Jog.LimitPosition.LastPosition:=gAxisUpdate.Conveyor.LastPosition;
		MpAxisConvParType.Position:=gAxisUpdate.Conveyor.Position;
		//MpAxisConvParType.Homing.Mode:=gAxisUpdate.Conveyor.Homing;
		//MpAxisConvParType.Velocity:=gAxisUpdate.Conveyor.Velocity;
		MpAxisConvParType.Jog.Velocity:=gAxisUpdate.Conveyor.Velocity;
			
		//cart
		MpAxisCartParType.Jog.LimitPosition.FirstPosition:=gAxisUpdate.Cart.FirstPosition;
		MpAxisCartParType.Jog.LimitPosition.LastPosition:=gAxisUpdate.Cart.LastPosition;
		MpAxisCartParType.Position:=gAxisUpdate.Cart.Position;
		//	MpAxisCartParType.Homing.Mode:=gAxisUpdate.Cart.Homing;
		MpAxisCartParType.Jog.Velocity:=50;
			
		//nozzle
		MpAxisNozzleParType.Jog.LimitPosition.FirstPosition:=gAxisUpdate.Nozzle.FirstPosition;
		MpAxisNozzleParType.Jog.LimitPosition.LastPosition:=gAxisUpdate.Nozzle.LastPosition;
		MpAxisNozzleParType.Position:=gAxisUpdate.Nozzle.Position;
		//	MpAxisNozzleParType.Homing.Mode:=gAxisUpdate.Nozzle.Homing;
		MpAxisNozzleParType.Jog.Velocity:=50;
		
		MpAxisNozzle.Update:=1;
		MpAxisConv.Update:=1;
		MpAxisCart.Update:=1;
		
		IF MpAxisNozzle.UpdateDone THEN
			MpAxisNozzle.Update:=0;
		END_IF;
		IF MpAxisCart.UpdateDone THEN
			MpAxisCart.Update:=0;
		END_IF;
		IF MpAxisConv.UpdateDone THEN
			MpAxisConv.Update:=0;
		END_IF;
		gControl.needUpdate:=0;
	END_IF;
	
	
	
		
		
	CASE gAxisCase OF
		UPDATE:

		POWERED:
			IF (gControl.power AND NOT gControl.stop AND NOT gAxisOutputs.Conveyor.error) THEN //error
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
			IF gControl.manual THEN
				MpAxisCartParType.Homing.Mode:=141;
				MpAxisCartParType.Homing.Position:=0;
				MpAxisCartParType.Homing.Options.HomingDirection:=3;
				MpAxisCartParType.Homing.Options.HomingVelocity:=50;
				MpAxisCart.Update:=1;
				
				MpAxisConvParType.Homing.Mode:=141;
				MpAxisConvParType.Homing.Position:=0;
				MpAxisConvParType.Homing.Options.HomingDirection:=3;
				MpAxisConvParType.Homing.Options.HomingVelocity:=50;
				MpAxisConv.Update:=1;
				
				MpAxisNozzleParType.Homing.Mode:=141;
				MpAxisNozzleParType.Homing.Position:=195;
				MpAxisNozzleParType.Homing.Options.HomingDirection:=3;
				MpAxisNozzleParType.Homing.Options.HomingVelocity:=50;
				MpAxisNozzle.Update:=1;
				
				IF MpAxisCart.UpdateDone AND MpAxisConv.UpdateDone AND MpAxisNozzle.UpdateDone THEN
					MpAxisCart.Update:=0;
					MpAxisCart.Home:=1;
					MpAxisConv.Update:=0;
					MpAxisConv.Home:=1;
					MpAxisNozzle.Update:=0;
					MpAxisNozzle.Home:=1;
					gMainAction.homed:=1;
				END_IF;
			ELSIF NOT gControl.manual THEN
				MpAxisCart.Home:=1;
				MpAxisConv.Home:=1;
				MpAxisNozzle.Home:=1;
				gMainAction.homed:=1;
			END_IF;
			
			
			
		STANDSTILL:
			
			IF gControl.start THEN
				IF gControl.manual THEN
					// manual operations
					gAxisCase:=onMOVE; // ??????
				ELSE
					gAxisCase:=CONNECT;
					//connect cams

				END_IF;
			END_IF;
			
		CONNECT:
			
			IF connectHelper=0 THEN
				camSeq.EndSequence:=0;
				camSeqNozzle.EndSequence:=0;
				MpAxisConv.Stop:=1;
				MpAxisNozzle.Stop:=1;
				MpAxisCart.Stop:=1;
			END_IF;
			
			IF MpAxisConv.Stopped AND MpAxisCart.Stopped AND MpAxisNozzle.Stopped THEN
				MpAxisConv.Stop:=0;
				MpAxisNozzle.Stop:=0;
				MpAxisCart.Stop:=0;
				connectHelper:=1;
			END_IF;
			
			IF connectHelper=1 THEN
		
				camSeq.StartSequence:=1;
				camSeqNozzle.StartSequence:=1;
	
				IF camSeq.InCam AND camSeqNozzle.InCam THEN
					camSeq.Signal1:=1;
					gMainAction.connected:=1;
					connectHelper:=0;
				END_IF;
			END_IF;
			

		
		DISCONNECT:
			gMainAction.homed:=0;
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
			MpAxisConv.MoveVelocity:=gControl.moveVelocity;
			MpAxisConv.JogNegative:=gControl.Conveyor.jogNegative;
			MpAxisConv.JogPositive:=gControl.Conveyor.jogPositive;
			MpAxisCart.JogNegative:=gControl.Cart.jogNegative;
			MpAxisCart.JogPositive:=gControl.Cart.jogPositive;
			MpAxisNozzle.JogNegative:=gControl.Nozzle.jogNegative;
			MpAxisNozzle.JogPositive:=gControl.Nozzle.jogPositive;
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
	
	gCamSeqParam.cart.currentStateIndex:=camSeq.ActualStateIndex;
	gCamSeqParam.nozzle.currentStateIndex:=camSeq.ActualStateIndex;
	
	gAxisOutputs:=controlInfo;
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

