
PROGRAM _INIT
	(* Insert code here *)
	axisCase:=POWERED;
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
	MpAxisConv.ErrorReset:=gManualControl.Conveyor.errorReset;
	MpAxisConv.Power:=gManualControl.Conveyor.start;
	MpAxisConv.Home:=gManualControl.Conveyor.home;
	MpAxisConv.Stop:=gManualControl.Conveyor.stop;
	MpAxisConv.JogNegative:=gManualControl.Conveyor.jogNegative;
	MpAxisConv.JogPositive:=gManualControl.Conveyor.jogPositive;
	
	//Cart management
	MpAxisCart.ErrorReset:=gManualControl.Cart.errorReset;
	MpAxisCart.Power:=gManualControl.Cart.start;
	MpAxisCart.Home:=gManualControl.Cart.home;
	MpAxisCart.Stop:=gManualControl.Cart.stop;
	MpAxisCart.JogNegative:=gManualControl.Cart.jogNegative;
	MpAxisCart.JogPositive:=gManualControl.Cart.jogPositive;
	
	
	//nozzle Management
	MpAxisNozzle.ErrorReset:=gManualControl.Nozzle.errorReset;
	MpAxisNozzle.Power:=gManualControl.Nozzle.start;
	MpAxisNozzle.Home:=gManualControl.Nozzle.home;
	MpAxisNozzle.Stop:=gManualControl.Nozzle.stop;
	MpAxisNozzle.JogNegative:=gManualControl.Nozzle.jogNegative;
	MpAxisNozzle.JogPositive:=gManualControl.Nozzle.jogPositive;
	
	CASE axisCase OF
		UPDATE:
			//conveyor
			MpAxisConvParType.Jog.LimitPosition.FirstPosition:=gAxisUpdate.Conveyor.FirstPosition;
			MpAxisConvParType.Jog.LimitPosition.LastPosition:=gAxisUpdate.Conveyor.LastPosition;
			MpAxisConvParType.Position:=gAxisUpdate.Conveyor.Position;
			MpAxisConvParType.Homing.Mode:=gAxisUpdate.Conveyor.Homing;
			MpAxisConvParType.Velocity:=gAxisUpdate.Conveyor.Velocity;
			
			//cart
			MpAxisCartParType.Jog.LimitPosition.FirstPosition:=gAxisUpdate.Cart.FirstPosition;
			MpAxisCartParType.Jog.LimitPosition.LastPosition:=gAxisUpdate.Cart.LastPosition;
			MpAxisCartParType.Position:=gAxisUpdate.Cart.Position;
			MpAxisCartParType.Homing.Mode:=gAxisUpdate.Cart.Homing;
			MpAxisCartParType.Velocity:=gAxisUpdate.Cart.Velocity;
			
			//nozzle
			MpAxisNozzleParType.Jog.LimitPosition.FirstPosition:=gAxisUpdate.Nozzle.FirstPosition;
			MpAxisNozzleParType.Jog.LimitPosition.LastPosition:=gAxisUpdate.Nozzle.LastPosition;
			MpAxisNozzleParType.Position:=gAxisUpdate.Nozzle.Position;
			MpAxisNozzleParType.Homing.Mode:=gAxisUpdate.Nozzle.Homing;
			MpAxisNozzleParType.Velocity:=gAxisUpdate.Nozzle.Velocity;
			
		POWERED:
			IF (axisMgmt.diPowerSwitch AND NOT axisMgmt.diStop AND NOT axisMgmt.diError) THEN
				//power on axis
				MpAxisCart.Power:=1;
				MpAxisConv.Power:=1;
				MpAxisNozzle.Power:=1;
			END_IF;
			
			IF MpAxisConv.PowerOn AND MpAxisNozzle.PowerOn AND MpAxisCart.PowerOn THEN
				axisCase:=HOMING;
			END_IF;
			
				
		HOMING:
			
			MpAxisCart.Home:=1;
			MpAxisConv.Home:=1;
			MpAxisNozzle.Home:=1;
			
			
			IF MpAxisCart.IsHomed AND MpAxisConv.IsHomed AND MpAxisNozzle.IsHomed THEN
				MpAxisCart.Home:=0;
				MpAxisConv.Home:=0;
				MpAxisNozzle.Home:=0;
				homed:=1;
			END_IF;
		
			IF homed THEN
				axisCase:=STANDSTILL;
			END_IF;
			
		STANDSTILL:
			
			IF axisMgmt.diStart THEN
				camSeq.StartSequence:=1;
				camSeqNozzle.StartSequence:=1;
				IF axisMgmt.diManual THEN
					// manual operations
					axisCase:=onMOVE; // ??????
				ELSE
					axisCase:=CONNECT;
					//connect cams

				END_IF;
			END_IF;
			
		CONNECT:
			camSeq.Signal1:=1;
			camSeqNozzle.Signal1:=1;
			IF camSeq.InCam AND camSeqNozzle.InCam THEN
				axisCase:=onMOVE;
			END_IF;
			
			
		onMOVE:
			
			
	END_CASE;
	
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

