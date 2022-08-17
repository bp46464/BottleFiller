
TYPE
	ModelConfigBottleType : 	STRUCT 
		CenterToCenter : REAL; (*Bottle center to center in line*)
		Diameter : REAL; (*Bottle diameter*)
		Gap : REAL; (*Gap between bottles*)
	END_STRUCT;
	ModelConfigType : 	STRUCT 
		Bottle : ModelConfigBottleType;
	END_STRUCT;
	New_Datatype : 	STRUCT 
	END_STRUCT;
	RobVisPosType : 	STRUCT 
		Conveyor : REAL;
		Cart : REAL;
		Nozzle : REAL;
		SensorColor : USINT;
	END_STRUCT;
END_TYPE
