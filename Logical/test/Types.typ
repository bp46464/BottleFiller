TYPE
	bottleFillerRecipeEnum : 	STRUCT 
		diPumpSpeedFlow : USINT := 0;
		diVelocity : USINT := 0;
		diSpeedProfile : USINT := 0;
		diBottleShape : USINT := 0;
	END_STRUCT;
	FillerEnum : 
		( (*Every possible case*)
		DISABLED,
		STOP,
		SERVICE,
		INIT,
		AUTOMAT,
		ERROR
	);
END_TYPE