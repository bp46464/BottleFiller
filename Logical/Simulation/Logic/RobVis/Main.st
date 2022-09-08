PROGRAM _INIT

	ModelConfig.Bottle.CenterToCenter := 100;
	ModelConfig.Bottle.Diameter := 80;
	ModelConfig.Bottle.Gap := ModelConfig.Bottle.CenterToCenter - ModelConfig.Bottle.Diameter;
	
	
	RobVisData.Conveyor := 0.0;
	RobVisData.Cart := 0.0;
	RobVisData.Nozzle := 200.0;
END_PROGRAM

PROGRAM _CYCLIC

	//gAdrAxesPositions := ADR(AxesPosition);
	
	IF gAdrAxesPositions <> 0 THEN
		pAxesPositions ACCESS gAdrAxesPositions;
	ELSE
		RETURN;
	END_IF
	
	// --------------------------------------------
	// Prepare correct positions for model
	// --------------------------------------------
	RobVisData.Conveyor := LREAL_TO_REAL(pAxesPositions.Conveyor + ConveyorAxisPosition);
	RobVisData.Cart := LREAL_TO_REAL(pAxesPositions.Cart + CartAxisPosition);
	RobVisData.Nozzle := LREAL_TO_REAL(pAxesPositions.Nozzle + NozzleAxisPosition);
	RobVisData.SensorColor;
	
	// Homing Switches Control
	gMachineInterface.DigitalInputs.ConveyorHomingSwitch := diBottle AND (cntBottle MOD 5 = 1);
	gMachineInterface.DigitalInputs.CartHomingSwitch := RobVisData.Cart <= -50;
	gMachineInterface.DigitalInputs.NozzleHomingSwitch := RobVisData.Nozzle >= 195;
	
	// --------------------------------------------
	// Bottle Signal Generator
	// --------------------------------------------
	FOR i := 0 TO 50 DO
		bottleStartPoint := i*ModelConfig.Bottle.CenterToCenter + ModelConfig.Bottle.Diameter + ModelConfig.Bottle.Gap/2;
		bottleEndPoint := bottleStartPoint + ModelConfig.Bottle.Diameter;
		
		IF (RobVisData.Conveyor > bottleStartPoint) AND (RobVisData.Conveyor < bottleEndPoint) THEN
			diBottle := TRUE;
			RobVisData.SensorColor := 5;
			EXIT;
		ELSE
			diBottle := FALSE;
			RobVisData.SensorColor := 11;
		END_IF
	END_FOR
	
	// --------------------------------------------
	// Bottle counter
	// --------------------------------------------	
	IF (diBottleOld <> diBottle) AND diBottle THEN
		cntBottle := cntBottle + 1;
	END_IF
	
	diBottleOld := diBottle;
	
	// --------------------------------------------
	// Tests
	// --------------------------------------------
	IF cmdTestModelMovements THEN
		ConveyorAxisPosition := ConveyorAxisPosition + 1;
		CartAxisPosition := CartAxisPosition + 1;
		NozzleAxisPosition := NozzleAxisPosition + 1;
		
		IF ConveyorAxisPosition > 2500 THEN
			ConveyorAxisPosition := 0;
		END_IF	
		
		IF CartAxisPosition > 1200 THEN
			CartAxisPosition := 0;
		END_IF	
		
		IF NozzleAxisPosition > 200 THEN
			NozzleAxisPosition := 0;
		END_IF
	END_IF
	
	
	
	
END_PROGRAM



