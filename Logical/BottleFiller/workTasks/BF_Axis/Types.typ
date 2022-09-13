
TYPE
	InfosTyp : 	STRUCT 
		Conveyor : gControlInfoTyp;
		Cart : gControlInfoTyp;
		Nozzle : gControlInfoTyp;
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
