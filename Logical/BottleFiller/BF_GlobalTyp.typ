
TYPE
	camSequencersParams : 	STRUCT 
		cart : camParam;
		nozzle : camParam;
	END_STRUCT;
	camParam : 	STRUCT 
		signal1 : BOOL := FALSE;
		currentStateIndex : INT := 0;
	END_STRUCT;
	gAxisOutputsTyp : 	STRUCT 
		Conveyor : gControlInfoTyp;
		Cart : gControlInfoTyp;
		Nozzle : gControlInfoTyp;
		currentBottleType : UINT := 1;
	END_STRUCT;
	gControlInfoTyp : 	STRUCT  (*parameters, output*)
		error : BOOL := FALSE;
		isPowered : BOOL := FALSE;
		isHomed : BOOL := FALSE;
		position : REAL := 0;
		velocity : REAL := 0;
		updateDone : BOOL := FALSE;
		MoveActive : BOOL := FALSE;
		Direction : STRING[80];
	END_STRUCT;
	gControlTyp : 	STRUCT  (*parameters, inputs*)
		power : BOOL := FALSE;
		errorReset : BOOL := FALSE;
		home : BOOL := FALSE;
		jogNegative : BOOL := FALSE;
		jogPositive : BOOL := FALSE;
		moveVelocity : BOOL := FALSE;
		stop : BOOL := FALSE;
		currentBottleType : STRING[80] := '1';
		safeLevelStop : BOOL;
		onlyLeft : BOOL := FALSE;
		onlyRight : BOOL := FALSE;
		upperLimit : INT;
		lowerLimit : INT;
		Direction : STRING[80];
	END_STRUCT;
	gMainActionTyp : 	STRUCT 
		powered : BOOL := FALSE;
		homed : BOOL := FALSE;
		connected : BOOL := FALSE;
		disconnected : BOOL := FALSE;
		stopped : BOOL := FALSE;
	END_STRUCT;
	gAxisUpdateParType : 	STRUCT  (*update parameters structure*)
		Conveyor : gParametersUpdate;
		Cart : gParametersUpdate;
		Nozzle : gParametersUpdate;
		staticVelocity : STRING[80] := '10';
	END_STRUCT;
	gManagementTyp : 	STRUCT 
		Conveyor : gControlTyp;
		Cart : gControlTyp;
		Nozzle : gControlTyp;
		power : BOOL := FALSE;
		start : BOOL := FALSE;
		stop : BOOL := FALSE;
		manual : BOOL := FALSE;
		inCam : BOOL := FALSE;
		needUpdate : BOOL := FALSE;
		moveVelocity : BOOL := FALSE;
		disconnect : BOOL := FALSE;
		bottleCnt : INT := 0;
		currentBottleType : STRING[80] := '1';
	END_STRUCT;
	gParametersUpdate : 	STRUCT  (*update parameters*)
		Velocity : REAL := 10;
		Direction : REAL := 1;
		FirstPosition : REAL := 0;
		LastPosition : REAL := 0;
		Position : REAL := 0;
		Homing : REAL := 0;
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
		HOLDON,
		HOMING,
		CONNECT,
		STANDSTILL,
		onMOVE,
		DISCONNECT
		);
END_TYPE
