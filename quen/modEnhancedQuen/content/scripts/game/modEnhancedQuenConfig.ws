/*
*  Enhanced Quen Mod Config
*  Author: Zhior
*/

class ModEnhancedQuenConfig extends CR4HudModuleBuffs
{
	const var quenBlocksFallsDisabled	: bool;
	const var quenNeverBreaks			: bool;
	const var quenBreakDistNotReducing	: float;
	const var quenBreakDistanceReducing	: float;
	const var quenDeathDistance			: float;

	const var quenTimeExtension			: float;
	const var intExtendsQuen			: bool;
	
	const var quenPersists				: bool;
	
	var quenShown	: bool; default quenShown = false;
	var witcher		: W3PlayerWitcher;
	
	//--Configurable section begins--//
	
	//===========================
	//==== Quen Blocks Falls ====
	//===========================
	
	//Set this to true if you want to completely disable this feature
	//Setting this to true makes all other options in this section irrelevant
	//Deafult: false
	default quenBlocksFallsDisabled = false;
	
	//If this value is set to true falling won't cause Quen to break.
	//Even with this setting set to true you will still die if you fall from higher than what quenDeathDistance is set to.
	//Deafult: false
	default quenNeverBreaks = false;
	
	//Distance at which Quen will break if you DO NOT roll.
	//If quenNeverBreaks is set to true this value is irrelevant.
	//Default: 7.0f	
	default quenBreakDistNotReducing = 7.0f;
	
	//Distance at which Quen will break if you DO roll.
	//If quenNeverBreaks is set to true this value is irrelevant
	//Default: 9.0f	
	default quenBreakDistanceReducing = 9.0f;
	
	//This value is the minimum distance at which you will die from if you fall even with Quen active.
	//If you want to be able to survive ALL falls (while Quen is active) set the value to something like 1000.0f.
	//Make sure to keep the 'f' after the number you choose.
	//For reference: The fall from the broken bridge in White Orchard (the one outside the Nilfgaardian garrison) to the beach is about 14.6f.
	//Vanilla is 7.0f, or 9.0f when rolling
	//Default: 15.0f
	default quenDeathDistance = 15.0f;
	
	//===========================
	//==== Quen Lasts Longer ====
	//===========================
	
	//In the vanilla game Quen lasts 30 seconds. That will get modified by whatever value you set here. For example:
	//For a 30 sec shield (same as vanilla): set quenTimeExtension to 0
	//For a 5 min shield (300 seconds/230 extra seconds) set quenTimeExtension to 230
	//For a 10 seconds (20 seconds less) set quenTimeExtension to -20 (that's a negative 20)
	//Default: 30
	default quenTimeExtension = 570;
	
	//If this is set to true Sign Intensity will increase the duration of the Quen shield
	//The shield will get increased multiplicatevely
	//Deafult: true
	default intExtendsQuen = true;
	
	//===========================
	//===== Quen Utilities ======
	//===========================
	
	//If this value is set to true Quen will stay active during dialogues and cutscenes.
	//Keep in mind that Quen doesn't actually last that long (unless you increase it using this mod) so it's probable you won't have the shield after longer cutscenes/dialogues. 
	//Also, the visual and sound effects are still there which might be annoying for some people.
	//Default: false
	default quenPersists = false;
	
	/*--Configurable section ends.
		Do not edit anything beyond this point.--*/
	
	public function getQuenMaxDur() : float
	{
		var signInt		: SAbilityAttributeValue;
		
		witcher = GetWitcherPlayer();
		signInt = witcher.GetTotalSignSpellPower(S_Magic_4);
		
		if(intExtendsQuen)
			return (CalculateAttributeValue(thePlayer.GetSkillAttributeValue(S_Magic_4, 'shield_duration', true, true)) + quenTimeExtension) * signInt.valueMultiplicative;
		else
			return (CalculateAttributeValue(thePlayer.GetSkillAttributeValue(S_Magic_4, 'shield_duration', true, true)) + quenTimeExtension);
	}
	
	public function isQuenActive() : bool
	{
		var quen	: W3QuenEntity;
		
		witcher = GetWitcherPlayer();
		quen = (W3QuenEntity)witcher.GetSignEntity(ST_Quen);
		
		return (quen.GetCurrentStateName() == 'ShieldActive' && quen.GetShieldHealth() > 0);
	}
	
	public function getQuenDur() : int
	{
		var quen	: W3QuenEntity;
		var duration: int;
		
		witcher = GetWitcherPlayer();
		quen = (W3QuenEntity)witcher.GetSignEntity(ST_Quen);
		duration = (int)quen.GetShieldRemainingDuration();
		
		return duration;
	}
	
	public function getQuenDurAsFloat() : float
	{
		var quen	: W3QuenEntity;
		var duration: float;
		
		witcher = GetWitcherPlayer();
		quen = (W3QuenEntity)witcher.GetSignEntity(ST_Quen);
		duration = quen.GetShieldRemainingDuration();
		
		return duration;
	}
	
	public function showQuen(bDisplayBuffs : bool, m_fxSetPercentSFF : CScriptedFlashFunction, i : int, offset : int) : int
	{		
		if (bDisplayBuffs && GetEnabled())
		{		
			if (isQuenActive() == true && quenShown == false)
			{
				//super.UpdateBuffs();
				quenShown = true;
				return 1;
			}
			else if (isQuenActive() == true && quenShown == true)
			{
				m_fxSetPercentSFF.InvokeSelfThreeArgs( FlashArgNumber(i-offset),FlashArgNumber( getQuenDurAsFloat() ), FlashArgNumber( getQuenMaxDur() ));
				return 0;
			}
			else if (isQuenActive() == false && quenShown == true)
			{
				//super.UpdateBuffs();
				quenShown = false;
				return 1;
			}
		}
		return 2;
		
	}
	
	public function drawQuen(l_flashObject : CScriptedFlashObject, l_flashArray : CScriptedFlashArray, m_flashValueStorage : CScriptedFlashValueStorage)
	{
		if (isQuenActive() == true)
		{
			l_flashObject = m_flashValueStorage.CreateTempFlashObject();
			l_flashObject.SetMemberFlashBool("isVisible", true);
			l_flashObject.SetMemberFlashString("iconName", "hud/radialmenu/mcQuen.png");
			l_flashObject.SetMemberFlashString("title", GetLocStringByKeyExt("skill_name_magic_4"));
			l_flashObject.SetMemberFlashBool("isPositive", true);
			l_flashObject.SetMemberFlashNumber("duration", getQuenDur());
			l_flashObject.SetMemberFlashNumber("initialDuration", getQuenMaxDur());
			l_flashArray.PushBackFlashObject(l_flashObject);	
		}
	}
}