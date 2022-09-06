
PROGRAM _INIT
	(* Insert code here *)
	//Conveyor parameters
	MpAxisConvParType.AutoTune.Mode:=mcAXIS_TUNE_AUTOMATIC;
	MpAxisConvParType.AutoTune.MaxCurrentPercent:=80;
	MpAxisConvParType.AutoTune.MaxDistance:=30;
	MpAxisConvParType.AutoTune.MaxPositionError:=30;
	//Nozzle parameters
	MpAxisNozzleParType := MpAxisConvParType;
	MpAxisNozzleParType.Homing.Position:=200;
	//Cart parameters
	MpAxisCartParType := MpAxisConvParType;
	
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	//axis declaration
	MpAxisConv(MpLink := ADR(axisConv), Enable := 1, Parameters := ADR(MpAxisConvParType), AutoTune := 1);
	MpAxisCart(MpLink := ADR(axisCart), Enable := 1, Parameters := ADR(MpAxisCartParType),   AutoTune := 1);
	MpAxisNozzle(MpLink := ADR(axisNozzle), Enable := 1, Parameters := ADR(MpAxisNozzleParType),  AutoTune := 1);
	
	//Sequence declaration
	camSeq(MpLink := ADR(axisCart), Enable := 1, Parameters := ADR(camParameters), MpLinkMaster := ADR(axisConv));
	camSeqNozzle(MpLink := ADR(axisNozzle), Enable := 1, Parameters := ADR(camParameters), MpLinkMaster := ADR(axisConv));
	
	
	
	//conveyor management
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
	
	IF gControl.needUpdate THEN
		gControl.needUpdate:=0;
		//conveyor
		MpAxisConvParType.Jog.LimitPosition.FirstPosition:=gAxisUpdate.Conveyor.FirstPosition;
		MpAxisConvParType.Jog.LimitPosition.LastPosition:=gAxisUpdate.Conveyor.LastPosition;
		MpAxisConvParType.Position:=gAxisUpdate.Conveyor.Position;
		//	MpAxisConvParType.Homing.Mode:=gAxisUpdate.Conveyor.Homing;
		MpAxisConvParType.Velocity:=gAxisUpdate.Conveyor.Velocity;
		MpAxisConvParType.Jog.Velocity:=gAxisUpdate.Conveyor.Velocity;
			
		//cart
		MpAxisCartParType.Jog.LimitPosition.FirstPosition:=gAxisUpdate.Cart.FirstPosition;
		MpAxisCartParType.Jog.LimitPosition.LastPosition:=gAxisUpdate.Cart.LastPosition;
		MpAxisCartParType.Position:=gAxisUpdate.Cart.Position;
		//	MpAxisCartParType.Homing.Mode:=gAxisUpdate.Cart.Homing;
		MpAxisCartParType.Velocity:=gAxisUpdate.Cart.Velocity;
		MpAxisCartParType.Jog.Velocity:=gAxisUpdate.Cart.Velocity;
			
		//nozzle
		MpAxisNozzleParType.Jog.LimitPosition.FirstPosition:=gAxisUpdate.Nozzle.FirstPosition;
		MpAxisNozzleParType.Jog.LimitPosition.LastPosition:=gAxisUpdate.Nozzle.LastPosition;
		MpAxisNozzleParType.Position:=gAxisUpdate.Nozzle.Position;
		//	MpAxisNozzleParType.Homing.Mode:=gAxisUpdate.Nozzle.Homing;
		MpAxisNozzleParType.Velocity:=gAxisUpdate.Nozzle.Velocity;
		MpAxisNozzleParType.Jog.Velocity:=gAxisUpdate.Nozzle.Velocity;
		
		MpAxisNozzle.Update:=1;
		MpAxisConv.Update:=1;
		MpAxisCart.Update:=1;
		
	END_IF;
	
	IF MpAxisNozzle.UpdateDone THEN
		MpAxisNozzle.Update:=0;
	END_IF;
	IF MpAxisCart.UpdateDone THEN
		MpAxisCart.Update:=0;
	END_IF;
	IF MpAxisConv.UpdateDone THEN
		MpAxisConv.Update:=0;
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
			
			MpAxisCart.Home:=1;
			MpAxisConv.Home:=1;
			MpAxisNozzle.Home:=1;
			
			IF gControl.disconnect THEN
				MpAxisCartParType.Homing.Mode:=141;
				MpAxisCartParType.Homing.Options.HomingVelocity:=50;
				MpAxisCart.Update:=1;
				
				MpAxisConvParType.Homing.Mode:=141;
				MpAxisConvParType.Homing.Options.HomingVelocity:=50;
				MpAxisConv.Update:=1;
				
				MpAxisNozzleParType.Homing.Mode:=141;
				MpAxisNozzleParType.Homing.Options.HomingVelocity:=50;
				MpAxisNozzle.Update:=1;
				
				IF MpAxisCart.UpdateDone THEN
					MpAxisCart.Home:=1;
					MpAxisCart.Update:=0;
				END_IF;
				IF MpAxisConv.UpdateDone THEN
					MpAxisConv.Home:=1;
					MpAxisConv.Update:=0;
				END_IF;
				IF MpAxisNozzle.UpdateDone THEN
					MpAxisNozzle.Home:=1;
					MpAxisNozzle.Update:=0;
				END_IF;

			END_IF;
			
			IF MpAxisCart.IsHomed AND MpAxisConv.IsHomed AND MpAxisNozzle.IsHomed THEN
				MpAxisCart.Home:=0;
				MpAxisConv.Home:=0;
				MpAxisNozzle.Home:=0;
				gMainAction.homed:=1;
			END_IF;
			
		STANDSTILL:
			
			IF axisMgmt.diStart THEN
				camSeq.StartSequence:=1;
				camSeqNozzle.StartSequence:=1;
				IF axisMgmt.diManual THEN
					// manual operations
					gAxisCase:=onMOVE; // ??????
				ELSE
					gAxisCase:=CONNECT;
					//connect cams

				END_IF;
			END_IF;
			
		CONNECT:
			camSeq.StartSequence:=1;
			camSeqNozzle.StartSequence:=1;

			IF camSeq.InCam AND camSeqNozzle.InCam THEN
				camSeq.Signal1:=1;
				camSeqNozzle.Signal1:=1;
				gMainAction.connected:=1;
			END_IF;
		
		DISCONNECT:
			camSeq.Signal1:=0;
			camSeqNozzle.Signal1:=0;
			camSeq.StartSequence:=0;
			camSeqNozzle.StartSequence:=0;
			gMainAction.disconnected:=1;
			
		onMOVE:
			MpAxisConv.MoveVelocity:=gControl.moveVelocity;
			MpAxisConv.JogNegative:=gControl.Conveyor.jogNegative;
			MpAxisConv.JogPositive:=gControl.Conveyor.jogPositive;
			MpAxisCart.JogNegative:=gControl.Cart.jogNegative;
			MpAxisCart.JogPositive:=gControl.Cart.jogPositive;
			MpAxisNozzle.JogNegative:=gControl.Nozzle.jogNegative;
			MpAxisNozzle.JogPositive:=gControl.Nozzle.jogPositive;
			
	END_CASE;
	
	controlInfo.Conveyor.error:=MpAxisConv.Error;
	controlInfo.Conveyor.isHomed:=MpAxisConv.IsHomed;
	controlInfo.Conveyor.isPowered:=MpAxisConv.PowerOn;
	controlInfo.Conveyor.position:=LREAL_TO_REAL(MpAxisConv.Position);
	controlInfo.Conveyor.velocity:=MpAxisConv.Velocity;
	controlInfo.Conveyor.updateDone:=MpAxisConv.UpdateDone;
	
	controlInfo.Cart.error:=MpAxisCart.Error;
	controlInfo.Cart.isHomed:=MpAxisCart.IsHomed;
	controlInfo.Cart.isPowered:=MpAxisCart.PowerOn;
	controlInfo.Cart.position:=LREAL_TO_REAL(MpAxisCart.Position);
	controlInfo.Cart.velocity:=MpAxisCart.Velocity;
	controlInfo.Cart.updateDone:=MpAxisCart.UpdateDone;
	
	controlInfo.Nozzle.error:=MpAxisNozzle.Error;
	controlInfo.Nozzle.isHomed:=MpAxisNozzle.IsHomed;
	controlInfo.Nozzle.isPowered:=MpAxisNozzle.PowerOn;
	controlInfo.Nozzle.position:=LREAL_TO_REAL(MpAxisNozzle.Position);
	controlInfo.Nozzle.velocity:=MpAxisNozzle.Velocity;
	controlInfo.Nozzle.updateDone:=MpAxisNozzle.UpdateDone;
	
	gAxisOutputs:=controlInfo;
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

