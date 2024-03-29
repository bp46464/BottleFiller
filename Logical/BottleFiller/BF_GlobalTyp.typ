
TYPE
	gPumpMgmtTyp : 	STRUCT 
		PumpFlowSpeed : USINT;
		PumpRelay : USINT := 0;
		ValveStatus : STRING[80];
		ValveRelay : BOOL := FALSE;
	END_STRUCT;
	camSequencersParams : 	STRUCT 
		cart : camParam; (*Parametry cama karetki*)
		nozzle : camParam; (*Parametry cama dysz*)
	END_STRUCT;
	camParam : 	STRUCT 
		signal1 : BOOL := FALSE; (*Wyzwalanie signal1*)
		currentStateIndex : INT := 0; (*Zwraca aktualny state*)
	END_STRUCT;
	gAxisOutputsTyp : 	STRUCT 
		Conveyor : gControlInfoTyp;
		Cart : gControlInfoTyp;
		Nozzle : gControlInfoTyp;
		currentBottleType : UINT := 1; (*Aktualny typ butelki*)
		velocity : REAL; (*Aktualna prędkość*)
	END_STRUCT;
	gControlInfoTyp : 	STRUCT  (*parameters, output*)
		error : BOOL := FALSE; (*error*)
		isPowered : BOOL := FALSE; (*jest zasilony*)
		isHomed : BOOL := FALSE; (*jest w pozycji home*)
		position : REAL := 0; (*aktualna pozycja*)
		velocity : REAL := 0; (*aktualne velocity*)
		updateDone : BOOL := FALSE;
		MoveActive : BOOL := FALSE;
		Direction : STRING[80];
	END_STRUCT;
	gControlTyp : 	STRUCT  (*parameters, inputs*)
		power : BOOL := FALSE; (*Uruchomienie maszyny*)
		errorReset : BOOL := FALSE;
		autoTune : BOOL := TRUE;
		home : BOOL := FALSE;
		jogNegative : BOOL := FALSE;
		jogPositive : BOOL := FALSE;
		moveVelocity : BOOL := FALSE;
		stop : BOOL := FALSE;
		currentBottleType : STRING[80] := '1';
		safeLevelStop : BOOL; (*Informuje, czy w trybie półautomatycznym przekroczone zostały bezpieczne granice*)
		onlyLeft : BOOL := FALSE; (*Wskazuje, że w trybie półautomatycznym możliwy aktualnie jest ruch tylko w lewo*)
		onlyRight : BOOL := FALSE; (*Wskazuje, że w trybie półautomatycznym możliwy aktualnie jest ruch tylko w prawo*)
		upperLimit : INT; (*Maksymalne velocity Operatora*)
		lowerLimit : INT; (*Minimalne velocity Operatora*)
		Direction : STRING[80];
	END_STRUCT;
	gMainActionTyp : 	STRUCT  (*Flagi pomocne w sterowaniu projektem*)
		powered : BOOL := FALSE; (*Czy maszyna jest zasilona*)
		homed : BOOL := FALSE; (*Czy maszyna jest home'owana*)
		connected : BOOL := FALSE; (*Czy osie są połączone*)
		disconnected : BOOL := FALSE; (*Czy osie są rozłączone*)
		stopped : BOOL := FALSE; (*Czy Osie stoją*)
	END_STRUCT;
	gAxisUpdateParType : 	STRUCT  (*update parameters structure*)
		Conveyor : gParametersUpdate;
		Cart : gParametersUpdate;
		Nozzle : gParametersUpdate;
		staticVelocity : STRING[80] := '10'; (*Static velocity to veloocity z opcji "Slow", "Normal", "Fast"*)
	END_STRUCT;
	gManagementTyp : 	STRUCT  (*Zarządzanie maszyną*)
		Conveyor : gControlTyp;
		Cart : gControlTyp;
		Nozzle : gControlTyp;
		power : BOOL := FALSE; (*Zasilenie maszyny*)
		start : BOOL := FALSE; (*Start maszyny*)
		stop : BOOL := FALSE; (*Stop maszyny*)
		manual : BOOL := FALSE; (*Manualna praca*)
		inCam : BOOL := FALSE; (*Flaga wskazująca na status połączenia osi*)
		needUpdate : BOOL := TRUE; (*Flaga wskazująca na konieczność aktualizacji*)
		moveVelocity : BOOL := FALSE; (*Wyzwolenie ruchu*)
		disconnect : BOOL := FALSE; (*Rozłączenie osi*)
		bottleCnt : INT := 0; (*Liczy butelki*)
		currentBottleType : STRING[80] := '1'; (*Aktualny typ butelki*)
		part : REAL; (*5% z aktualnej prędkości*)
		partVelUpd : BOOL := FALSE; (*Flaga wskazująca na konieczność aktualizacji prędkości*)
		maxVelocity : REAL; (*Maksymalne Velocity Operatora*)
		decVisible : BOOL := TRUE; (*Widoczność przycisku Decrease*)
		emergencySTOP : BOOL := FALSE;
		switchToAutomat : BOOL := FALSE;
		incVisible : BOOL := TRUE; (*Widoczność przycisku Increase*)
		minVelocity : REAL; (*Minimalne Velocity Operatora*)
		startSeq : BOOL := TRUE;
	END_STRUCT;
	gErrorCaseEnum : 
		(
		noError,
		handleError,
		inError
		);
	gFillerEnum : 
		( (*Every possible case*)
		DISABLED,
		INIT,
		WORK,
		STOP,
		ERROR
		);
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
		WAITING, (*Stan początkowy*)
		AUTOMAT, (*Tryb automatyczny*)
		MANUAL (*Tryb manualny*)
		);
	gBFCaseEnum : 
		( (*BF_Axis control*)
		WAIT, (*Tryb początkowy*)
		STANDSTILL, (*Czeka na ruch*)
		POWERED, (*Maszyna zasilona*)
		HOLDON, (*Zatrzymanie maszyny*)
		CONNECT, (*Połączenie osi*)
		onMOVE, (*W ruchu*)
		DISCONNECT, (*Rozłączenie osi*)
		HOMING (*Przywrócenie pozycji początkowych*)
		);
END_TYPE
