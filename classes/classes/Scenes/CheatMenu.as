package classes.Scenes {
	import classes.*;
	import classes.GlobalFlags.kFLAGS;
	import classes.GlobalFlags.kGAMECLASS;
	import classes.Scenes.NPCs.*;

	/**
	 * Private-build cheat console, reachable from the camp screen.
	 * Nothing here costs anything and nothing here can break a save.
	 */
	public class CheatMenu extends NPCAwareContent {

		public function CheatMenu() {}

		public function accessCheatMenu():void {
			hideMenus();
			clearOutput();
			outputText("<b>Cheat Menu</b>\n");
			outputText("Shortcut console for your private build.\n\n");
			outputText("Level <b>" + player.level + "</b>  |  Gems <b>" + player.gems + "</b>  |  Corruption <b>" + Math.round(player.cor) + "</b>  |  Day <b>" + getGame().time.days + "</b> at <b>" + getGame().time.hours + ":00</b>\n\n");
			menu();
			addButton(0, "Gems", gemsMenu).hint("Add gems to your purse.");
			addButton(1, "Level & XP", levelMenu).hint("Jump your level forward. Grants the stat and perk points you would have earned.");
			addButton(2, "Stats", statsMenu).hint("Bump your core attributes.");
			addButton(3, "Learn Spells", learnAllSpells).hint("Learn every spell in the game at once.");
			addButton(4, "Restore", restoreAll).hint("Refill HP, wipe fatigue, empty your lust.");
			addButton(5, "Time", timeMenu).hint("Move the clock and the calendar.");
			addButton(6, "Corruption", corruptionMenu).hint("Set your corruption to a fixed value.");
			addButton(14, "Back", playerMenu);
		}

		//----------------- GEMS -----------------
		private function gemsMenu():void {
			clearOutput();
			outputText("You currently have <b>" + player.gems + "</b> gems.\n\n");
			menu();
			addButton(0, "+1,000", addGems, 1000);
			addButton(1, "+10,000", addGems, 10000);
			addButton(2, "+100,000", addGems, 100000);
			addButton(4, "Set to 0", setGems, 0);
			addButton(14, "Back", accessCheatMenu);
		}
		private function addGems(amount:int):void {
			player.gems += amount;
			statScreenRefresh();
			clearOutput();
			outputText("<b>+" + amount + " gems.</b> You now hold " + player.gems + ".");
			doNext(accessCheatMenu);
		}
		private function setGems(amount:int):void {
			player.gems = amount;
			statScreenRefresh();
			clearOutput();
			outputText("Your purse now holds <b>" + player.gems + "</b> gems.");
			doNext(accessCheatMenu);
		}

		//----------------- LEVEL -----------------
		private function levelMenu():void {
			clearOutput();
			outputText("You are level <b>" + player.level + "</b> with <b>" + Math.round(player.XP) + "</b> XP. The level cap is <b>" + kGAMECLASS.levelCap + "</b>.\n\n");
			outputText("Stat points: <b>" + player.statPoints + "</b>  |  Perk points: <b>" + player.perkPoints + "</b>\n\n");
			menu();
			addButton(0, "+1 Level", bumpLevel, 1);
			addButton(1, "+5 Levels", bumpLevel, 5);
			addButton(2, "Max Level", bumpLevel, 999);
			addButton(5, "Clear XP", clearXP);
			addButton(14, "Back", accessCheatMenu);
		}
		private function bumpLevel(amount:int):void {
			player.level += amount;
			if (player.level > kGAMECLASS.levelCap) player.level = kGAMECLASS.levelCap;
			player.XP = 0;
			//Grant what the normal level-up screen would have handed over: 5 attribute points and 1 perk point per level.
			player.statPoints += 5 * amount;
			player.perkPoints += amount;
			player.HP = player.maxHP();
			statScreenRefresh();
			clearOutput();
			outputText("<b>You are now level " + player.level + ".</b>\n\n");
			outputText("Granted <b>" + (5 * amount) + "</b> attribute points and <b>" + amount + "</b> perk points. Use the Level Up button to spend them.");
			doNext(accessCheatMenu);
		}
		private function clearXP():void {
			player.XP = 0;
			clearOutput();
			outputText("XP bar emptied. You can level up again from scratch.");
			doNext(accessCheatMenu);
		}

		//----------------- STATS -----------------
		private function statsMenu():void {
			clearOutput();
			outputText("Strength <b>" + player.str + "</b>  |  Toughness <b>" + player.tou + "</b>  |  Speed <b>" + player.spe + "</b>  |  Intelligence <b>" + player.inte + "</b>\n\n");
			outputText("Libido <b>" + player.lib + "</b>  |  Sensitivity <b>" + player.sens + "</b>\n\n");
			menu();
			addButton(0, "Str", statPick, "str");
			addButton(1, "Tou", statPick, "tou");
			addButton(2, "Spe", statPick, "spe");
			addButton(3, "Int", statPick, "int");
			addButton(5, "Lib", statPick, "lib");
			addButton(6, "Sen", statPick, "sen");
			addButton(14, "Back", accessCheatMenu);
		}
		private function statPick(stat:String):void {
			clearOutput();
			outputText("Alter " + stat + " by how much?\n\n");
			menu();
			addButton(0, "+5", applyStat, stat, 5);
			addButton(1, "+25", applyStat, stat, 25);
			addButton(2, "+100", applyStat, stat, 100);
			addButton(4, "-5", applyStat, stat, -5);
			addButton(5, "-25", applyStat, stat, -25);
			addButton(14, "Back", statsMenu);
		}
		private function applyStat(stat:String, amount:int):void {
			dynStats(stat, amount);
			player.HP = player.maxHP();
			statScreenRefresh();
			clearOutput();
			outputText("Adjusted <b>" + stat + "</b> by " + amount + ".");
			doNext(statsMenu);
		}

		//----------------- SPELLS -----------------
		private function learnAllSpells():void {
			clearOutput();
			learnSpell(StatusEffects.KnowsArouse, "Arouse");
			learnSpell(StatusEffects.KnowsHeal, "Heal");
			learnSpell(StatusEffects.KnowsMight, "Might");
			learnSpell(StatusEffects.KnowsCharge, "Charge Weapon");
			learnSpell(StatusEffects.KnowsBlind, "Blind");
			learnSpell(StatusEffects.KnowsWhitefire, "Whitefire");
			learnSpell(StatusEffects.KnowsBlackfire, "Blackfire");
			outputText("\nYou now know <b>" + player.spellCount() + "</b> spells.");
			doNext(accessCheatMenu);
		}
		private function learnSpell(effect:StatusEffectType, name:String):void {
			if (player.hasStatusEffect(effect)) return;
			player.createStatusEffect(effect, 0, 0, 0, 0);
			outputText("Learned <b>" + name + "</b>.\n");
		}

		//----------------- RESTORE -----------------
		private function restoreAll():void {
			player.HP = player.maxHP();
			player.fatigue = 0;
			player.lust = 0;
			player.hunger = 100;
			statScreenRefresh();
			clearOutput();
			outputText("HP refilled, fatigue wiped, lust drained and belly filled.");
			doNext(accessCheatMenu);
		}

		//----------------- TIME -----------------
		private function timeMenu():void {
			clearOutput();
			outputText("It is day <b>" + getGame().time.days + "</b>, <b>" + getGame().time.hours + ":00</b>.\n\n");
			menu();
			addButton(0, "+1 Hour", shiftTime, 1);
			addButton(1, "+6 Hours", shiftTime, 6);
			addButton(2, "-1 Hour", shiftTime, -1);
			addButton(5, "+1 Day", shiftDays, 1);
			addButton(6, "-1 Day", shiftDays, -1);
			addButton(8, "Set 06:00", setHour, 6);
			addButton(9, "Set 21:00", setHour, 21);
			addButton(14, "Back", accessCheatMenu);
		}
		private function shiftTime(hours:int):void {
			var total:int = getGame().time.hours + hours;
			while (total >= 24) { total -= 24; getGame().time.days++; }
			while (total < 0) { total += 24; getGame().time.days--; if (getGame().time.days < 1) getGame().time.days = 1; }
			getGame().time.hours = total;
			clearOutput();
			outputText("It is now day <b>" + getGame().time.days + "</b>, <b>" + getGame().time.hours + ":00</b>.");
			doNext(timeMenu);
		}
		private function shiftDays(amount:int):void {
			getGame().time.days += amount;
			if (getGame().time.days < 1) getGame().time.days = 1;
			clearOutput();
			outputText("It is now day <b>" + getGame().time.days + "</b>.");
			doNext(timeMenu);
		}
		private function setHour(hour:int):void {
			getGame().time.hours = hour;
			clearOutput();
			outputText("The clock reads <b>" + getGame().time.hours + ":00</b>.");
			doNext(timeMenu);
		}

		//----------------- CORRUPTION -----------------
		private function corruptionMenu():void {
			clearOutput();
			outputText("Your corruption is <b>" + Math.round(player.cor) + "</b>.\n\n");
			menu();
			addButton(0, "Set 0", setCorruption, 0);
			addButton(1, "Set 25", setCorruption, 25);
			addButton(2, "Set 50", setCorruption, 50);
			addButton(3, "Set 75", setCorruption, 75);
			addButton(4, "Set 100", setCorruption, 100);
			addButton(14, "Back", accessCheatMenu);
		}
		private function setCorruption(value:int):void {
			dynStats("cor", value - player.cor);
			statScreenRefresh();
			clearOutput();
			outputText("Your corruption is now <b>" + Math.round(player.cor) + "</b>.");
			doNext(accessCheatMenu);
		}
	}
}
