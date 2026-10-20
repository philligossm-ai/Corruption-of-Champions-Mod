package classes.Scenes.Areas.GlacialRift {
	import classes.*;
	import classes.BodyParts.*;
	import classes.internals.WeightedDrop;

	public class KairosEcho extends Monster {

		protected function echoStrike():void {
			outputText("The echo doesn't wind up. It simply arrives, one hand already past your guard, and lands a blow that you only notice after the fact.");
			if (player.getEvasionRoll()) {
				outputText("  You twist out of the way of the second half of it.");
				combatRoundOver();
				return;
			}
			var damage:int = (str + 20) + rand(40);
			damage = player.reduceDamage(damage);
			player.takeDamage(damage, true);
			combatRoundOver();
		}

		protected function echoSteal():void {
			outputText("It reaches for you and takes hold of something that isn't quite your arm. For a moment your body is moving in the wrong order, and the wrongness is deeply, distractingly pleasant.");
			if (rand(3) == 0) {
				outputText("  You stumble out of the moment flushed and unsteady.");
				player.takeLustDamage(15 + rand(10), true);
			} else {
				outputText("  You shake it off, mostly.");
				player.takeLustDamage(6 + rand(6), true);
			}
			combatRoundOver();
		}

		override protected function performCombatAction():void {
			var chooser:Number = rand(10);
			if (chooser < 6) echoStrike();
			else echoSteal();
		}

		override public function defeated(hpVictory:Boolean):void { game().glacialRift.kairos.trialEchoWon(); }
		override public function won(hpVictory:Boolean, pcCameWorms:Boolean):void { game().glacialRift.kairos.trialEchoLost(); }

		public function KairosEcho() {
			this.a = "the ";
			this.short = "echo of Kairos";
			this.imageName = "";
			this.long = "You are fighting something that used to be a splinter of frozen time and has decided to be a man. It has Kairos's height and Kairos's grey, but none of his patience - it moves at a speed that doesn't belong in this clearing, arriving at the end of each motion before it has finished starting. When it stands still it stands <i>completely</i> still, which is somehow worse.";
			this.race = "Frozen echo";
			this.plural = false;
			this.createVagina(false, 1, 1);
			this.createCock(8, 1.5, CockTypesEnum.HUMAN);
			this.balls = 2;
			this.ballSize = 2;
			this.pronoun1 = "it";
			this.pronoun2 = "it";
			this.pronoun3 = "its";
			createBreastRow(2, 1);
			this.ass.analLooseness = Ass.LOOSENESS_TIGHT;
			this.ass.analWetness = Ass.WETNESS_DRY;
			this.tallness = 7 * 12;
			this.hips.rating = Hips.RATING_AVERAGE;
			this.butt.rating = Butt.RATING_AVERAGE;
			this.lowerBody.type = LowerBody.HUMAN;
			this.arms.type = Arms.HUMAN;
			this.skin.tone = "grey";
			this.skin.setType(Skin.PLAIN);
			this.hair.color = "grey";
			this.hair.length = 6;
			this.face.type = Face.HUMAN;
			this.ears.type = Ears.HUMAN;
			this.eyes.type = Eyes.HUMAN;
			initStrTouSpeInte(60, 65, 85, 80);
			initLibSensCor(10, 10, 10);
			this.weaponName = "frozen second";
			this.weaponVerb = "strike";
			this.weaponAttack = 18;
			this.armorName = "borrowed stillness";
			this.armorDef = 12;
			this.bonusHP = 220;
			this.lust = 0;
			this.lustVuln = 0.5;
			this.temperment = TEMPERMENT_AVOID_GRAPPLES;
			this.level = 20;
			this.gems = 30 + rand(20);
			this.drop = new WeightedDrop(consumables.ICICLE_, 1);
			this.special1 = echoStrike;
			this.special2 = echoSteal;
			this.tail.type = Tail.NONE;
			checkMonster();
		}
	}
}
