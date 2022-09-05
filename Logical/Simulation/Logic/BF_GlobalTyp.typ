
TYPE
	manualControlInfoTyp : 	STRUCT 
		error : BOOL;
		isPowered : BOOL;
		isHomed : BOOL;
	END_STRUCT;
	gControlTyp : 	STRUCT 
		errorReset : BOOL;
		start : BOOL;
		home : BOOL;
		jogNegative : BOOL;
		jogPositive : BOOL;
		stop : BOOL;
		moveAbsolute : BOOL;
		manual : BOOL;
		needUpdate : BOOL;
		inCam : BOOL;
	END_STRUCT;
	axisUpdateParType : 	STRUCT 
		Conveyor : parametersUpdate;
		Cart : parametersUpdate;
		Nozzle : parametersUpdate;
	END_STRUCT;
	parametersUpdate : 	STRUCT 
		Velocity : REAL;
		Direction : REAL;
		FirstPosition : REAL;
		LastPosition : REAL;
		Position : REAL;
		Homing : REAL;
		JogN : BOOL;
		JogP : BOOL;
		Update : BOOL;
	END_STRUCT;
END_TYPE
