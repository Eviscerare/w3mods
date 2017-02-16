//--===modSprintingTweaks===--
//	Author: Zhior
class SprintingTweaksConfig
{

	var sprintingMode		: int;
	var sprintTimeOut		: int;
	var sprintTimeIn		: int;
	var focusModeSprint		: bool;
	var drainUnder100		: bool;
	var sprintIndoors		: bool;
	
	public function Init()
	{
	    //--Configurable section begins--//

		//This value controls how the mod works, use the options below to customize it even further. Set it to one of the following values:
		//0 = Sprinting will consume stamina while in and out of combat (vanilla behaviour).
		//1 = Sprinting will consume stamina ONLY when in combat.
		//2 = Sprinting will not consume stamina.
		//Default: 1
		sprintingMode	= 1;
		
		//This variable controls how long you can sprint before it starts consuming stamina while outside of combat.
		//This value won't do anything if sprintingMode is set to 1 or 2.
		//Vanilla is 3 seconds.
		sprintTimeOut	= 3;
		
		//This variable controls how long you can sprint before it starts consuming stamina while in combat.
		//This value won't do anything if sprintingMode is set to 2.
		//Vanilla is 3 seconds.
		sprintTimeIn	= 3;
		
		//If set to true it allows you to sprint while in Witcher Senses mode.
		focusModeSprint	= true;	
		
		//In the vanilla game if you sprint while not on 100% stamina your stamina will start draining instantly after you start sprinting.
		//Set it to false to change that.
		drainUnder100	= false;
		
		//Set this to true if you want to be able to sprint indoors.
		sprintIndoors	= true;
	}
}