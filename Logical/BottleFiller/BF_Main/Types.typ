
TYPE
	SimulationAxisPositionEnum : 	STRUCT 
		Conveyor : REAL;
		Cart : REAL;
		Nozzle : REAL;
	END_STRUCT;
	bottleFillerRecipeEnum : 	STRUCT 
		diPumpSpeedFlow : INT := 0;
		diVelocity : REAL := 0.0;
		diSpeedProfile : INT := 0;
		diBottleShape : INT := 0;
	END_STRUCT;
END_TYPE
