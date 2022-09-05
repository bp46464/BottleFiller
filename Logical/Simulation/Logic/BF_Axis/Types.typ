
TYPE
	axisCaseEnum : 
		(
		POWERED,
		HOMING,
		onMOVE,
		CONNECT,
		STANDSTILL,
		UPDATE
		);
	managementTyp : 	STRUCT 
		Conveyor : manualControlTyp;
		Cart : manualControlTyp;
		Nozzle : manualControlTyp;
	END_STRUCT;
	InfosTyp : 	STRUCT 
		Conveyor : manualControlInfoTyp;
		Cart : manualControlInfoTyp;
		Nozzle : manualControlInfoTyp;
	END_STRUCT;
	manualControlInfoTyp : 	STRUCT 
		error : BOOL;
		isPowered : BOOL;
		isHomed : BOOL;
	END_STRUCT;
	manualControlTyp : 	STRUCT 
		errorReset : BOOL;
		start : BOOL;
		home : BOOL;
		jogNegative : BOOL;
		jogPositive : BOOL;
		stop : BOOL;
	END_STRUCT;
	axisesManagementType : 	STRUCT 
		diStart : BOOL;
		diError : BOOL;
		diManual : BOOL;
		diPowerSwitch : BOOL;
		diStop : BOOL;
	END_STRUCT;
END_TYPE
