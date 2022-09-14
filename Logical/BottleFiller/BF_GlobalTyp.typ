
TYPE
	gFillerEnum : 
		( (*Every possible case*)
		DISABLED,
		INIT,
		WORK,
		STOP,
		ERROR
		);
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
		velocity : REAL; (*Aktualna prêdkoœæ*)
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
		safeLevelStop : BOOL; (*Informuje, czy w trybie pó³automatycznym przekroczone zosta³y bezpieczne granice*)
		onlyLeft : BOOL := FALSE; (*Wskazuje, ¿e w trybie pó³automatycznym mo¿liwy aktualnie jest ruch tylko w lewo*)
		onlyRight : BOOL := FALSE; (*Wskazuje, ¿e w trybie pó³automatycznym mo¿liwy aktualnie jest ruch tylko w prawo*)
		upperLimit : INT; (*Maksymalne velocity Operatora*)
		lowerLimit : INT; (*Minimalne velocity Operatora*)
		Direction : STRING[80];
	END_STRUCT;
	gMainActionTyp : 	STRUCT  (*Flagi pomocne w sterowaniu projektem*)
		powered : BOOL := FALSE; (*Czy maszyna jest zasilona*)
		homed : BOOL := FALSE; (*Czy maszyna jest home'owana*)
		connected : BOOL := FALSE; (*Czy osie s¹ po³¹czone*)
		disconnected : BOOL := FALSE; (*Czy osie s¹ roz³¹czone*)
		stopped : BOOL := FALSE; (*Czy Osie stoj¹*)
	END_STRUCT;
	gAxisUpdateParType : 	STRUCT  (*update parameters structure*)
		Conveyor : gParametersUpdate;
		Cart : gParametersUpdate;
		Nozzle : gParametersUpdate;
		staticVelocity : STRING[80] := '10'; (*Static velocity to veloocity z opcji "Slow", "Normal", "Fast"*)
	END_STRUCT;
	gManagementTyp : 	STRUCT  (*Zarz¹dzanie maszyn¹*)
		Conveyor : gControlTyp;
		Cart : gControlTyp;
		Nozzle : gControlTyp;
		power : BOOL := FALSE; (*Zasilenie maszyny*)
		start : BOOL := FALSE; (*Start maszyny*)
		stop : BOOL := FALSE; (*Stop maszyny*)
		manual : BOOL := FALSE; (*Manualna praca*)
		inCam : BOOL := FALSE; (*Flaga wskazuj¹ca na status po³¹czenia osi*)
		needUpdate : BOOL := TRUE; (*Flaga wskazuj¹ca na koniecznoœæ aktualizacji*)
		moveVelocity : BOOL := FALSE; (*Wyzwolenie ruchu*)
		disconnect : BOOL := FALSE; (*Roz³¹czenie osi*)
		bottleCnt : INT := 0; (*Liczy butelki*)
		currentBottleType : STRING[80] := '1'; (*Aktualny typ butelki*)
		part : REAL; (*5% z aktualnej prêdkoœci*)
		partVelUpd : BOOL := FALSE; (*Flaga wskazuj¹ca na koniecznoœæ aktualizacji prêdkoœci*)
		maxVelocity : REAL; (*Maksymalne Velocity Operatora*)
		decVisible : BOOL := TRUE; (*Widocznoœæ przycisku Decrease*)
		incVisible : BOOL := TRUE; (*Widocznoœæ przycisku Increase*)
		minVelocity : REAL; (*Minimalne Velocity Operatora*)
		startSeq : BOOL := TRUE;
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
		WAITING, (*Stan pocz¹tkowy*)
		MANUAL, (*Tryb manualny*)
		AUTOMAT (*Tryb automatyczny*)
		);
	gBFCaseEnum : 
		( (*BF_Axis control*)
		WAIT, (*Tryb pocz¹tkowy*)
		POWERED, (*Maszyna zasilona*)
		HOLDON, (*Zatrzymanie maszyny*)
		HOMING, (*Przywrócenie pozycji pocz¹tkowych*)
		CONNECT, (*Po³¹czenie osi*)
		STANDSTILL, (*Czeka na ruch*)
		onMOVE, (*W ruchu*)
		DISCONNECT (*Roz³¹czenie osi*)
		);
END_TYPE
