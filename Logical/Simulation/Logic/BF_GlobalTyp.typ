
TYPE
	gAxisOutputsTyp : 	STRUCT 
		Conveyor : gControlInfoTyp;
		Cart : gControlInfoTyp;
		Nozzle : gControlInfoTyp;
	END_STRUCT;
	gControlInfoTyp : 	STRUCT  (*parameters, output*)
		error : BOOL;
		isPowered : BOOL;
		isHomed : BOOL;
		position : REAL;
		velocity : REAL;
		updateDone : BOOL;
	END_STRUCT;
	gControlTyp : 	STRUCT  (*parameters, inputs*)
		power : BOOL;
		errorReset : BOOL;
		home : BOOL;
		jogNegative : BOOL;
		jogPositive : BOOL;
		moveVelocity : BOOL;
		stop : BOOL;
	END_STRUCT;
	gMainActionTyp : 	STRUCT 
		powered : BOOL;
		homed : BOOL;
		connected : BOOL;
		disconnected : BOOL;
	END_STRUCT;
	gAxisUpdateParType : 	STRUCT  (*update parameters structure*)
		Conveyor : gParametersUpdate;
		Cart : gParametersUpdate;
		Nozzle : gParametersUpdate;
	END_STRUCT;
	gManagementTyp : 	STRUCT 
		Conveyor : gControlTyp;
		Cart : gControlTyp;
		Nozzle : gControlTyp;
		power : BOOL;
		start : BOOL;
		stop : BOOL;
		manual : BOOL;
		inCam : BOOL;
		needUpdate : BOOL;
		moveVelocity : BOOL;
		disconnect : BOOL := FALSE;
	END_STRUCT;
	gParametersUpdate : 	STRUCT  (*update parameters*)
		Velocity : REAL;
		Direction : REAL;
		FirstPosition : REAL;
		LastPosition : REAL;
		Position : REAL;
		Homing : REAL;
	END_STRUCT;
	gBFWorkEnum : 
		( (*BF_Work control*)
		WAITING,
		MANUAL,
		AUTOMAT
		);
	gBFCaseEnum : 
		( (*BF_Axis control*)
		WAIT,
		POWERED,
		UPDATE,
		HOMING,
		CONNECT,
		STANDSTILL,
		onMOVE,
		DISCONNECT
		);
END_TYPE
