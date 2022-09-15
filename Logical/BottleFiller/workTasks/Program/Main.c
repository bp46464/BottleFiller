


#ifdef _DEFAULT_INCLUDES
	#include <bur/plctypes.h>
	#include <string.h> 
	#include <AsDefault.h>
	#include <bur/plc.h>
	#include <brsystem.h>
#endif
void _INIT ProgramInit(void)
{

}

void _CYCLIC ProgramCyclic(void)
{
	BF_MpAlarm.MpLink = &(gBFAlarmXCore);
	//BF_MpAlarm.Enable = 1;
	
	//	gControl.moveVelocity = (gControl.moveVelocity==1 && error==0);
	//	gControl.Conveyor.jogNegative =(gControl.Conveyor.jogNegative==1 && error==0);
	//	gControl.Conveyor.jogPositive =(gControl.Conveyor.jogPositive==1 & error==0);
	//	gControl.Cart.jogNegative = (gControl.Cart.jogNegative==1 && error==0);
	//	gControl.Cart.jogPositive = (gControl.Cart.jogPositive==1 && error==0);
	//	gControl.Cart.moveVelocity = (gControl.Cart.moveVelocity==1 && error==0);
	//	gControl.Nozzle.jogNegative = (gControl.Nozzle.jogNegative==1 && error==0);
	//	gControl.Nozzle.jogPositive = (gControl.Nozzle.jogPositive==1 && error==0);
	//	gControl.Nozzle.moveVelocity = (gControl.Nozzle.moveVelocity==1 && error==0);

	switch (caseError)
	{
		case noError:
			if (gControl.start == 1 && gControl.power == 0)
			{
				MpAlarmXSet(&(gBFAlarmXCore), "noPower");
				caseError = inError;
				error = 1;
			}
						
			if (BF_MpAlarm.PendingAlarms != 0) 
			{
				caseError = inError;		
				error = 1;
			}
			break;
				
		case inError:
			gAxisCase = WAIT;
			gMain = ERROR;
			gFillerTyp = WAITING;
			
			if( gControl.power == 1)
				MpAlarmXReset(&(gBFAlarmXCore), "noPower");
						
			if (resetError != 0 )
				caseError = handleError;
						
			if (BF_MpAlarm.PendingAlarms == 0)
			{
				caseError = noError;
				error = 0;
				gMain = WORK;
				gFillerTyp = MANUAL;
				gAxisCase = onMOVE;
			}
			break;
	
		case handleError:
			if (resetError == 1)
			{
				gControl.Nozzle.errorReset = 1;
				if (!( gAxisOutputs.Nozzle.error ))
				{
					gControl.Nozzle.errorReset = 0;
					caseError = inError;
					resetError = 0;
				}
			}
			if (resetError == 2)
			{
				gControl.Conveyor.errorReset = 1;
				if (!(gAxisOutputs.Conveyor.error))
				{
					gControl.Conveyor.errorReset = 0;
					caseError = inError;
					resetError = 0;
				}
			}
			if (resetError == 3)
			{
				gControl.Cart.errorReset = 1;
				if (!(gAxisOutputs.Cart.error))
				{
					gControl.Cart.errorReset = 0;
					caseError = inError;
					resetError = 0;
				}
			}
			break;
	}


}

void _EXIT ProgramExit(void)
{

}

