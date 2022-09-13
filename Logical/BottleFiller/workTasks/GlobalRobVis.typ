
TYPE
	AxesPositionsType : 	STRUCT 
		Conveyor : REAL;
		Cart : REAL;
		Nozzle : REAL;
	END_STRUCT;
	MachineDigitalInputsType : 	STRUCT 
		BottleDetecttion : BOOL;
		ConveyorHomingSwitch : BOOL;
		CartHomingSwitch : BOOL;
		NozzleHomingSwitch : BOOL;
	END_STRUCT;
	MachineAPIType : 	STRUCT 
		DigitalInputs : MachineDigitalInputsType;
	END_STRUCT;
END_TYPE
