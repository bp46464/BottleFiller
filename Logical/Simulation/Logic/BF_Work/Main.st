
PROGRAM _INIT
	(* Insert code here *)
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	 
	IF gAxisOutputs.Cart.updateDone THEN
	END_IF;
	
	
	CASE gFillerTyp OF
			
		MANUAL:

				
			
		AUTOMAT:
			gControl.moveVelocity:= gControl.start AND NOT gControl.stop;
		
	//	ERROR:
		
		//STOP:
		
	END_CASE;
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

