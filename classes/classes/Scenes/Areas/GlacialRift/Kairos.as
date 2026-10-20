package classes.Scenes.Areas.GlacialRift {
	import classes.*;
	import classes.GlobalFlags.kFLAGS;
	import classes.GlobalFlags.kGAMECLASS;

	/**
	 * Kairos - a man who lives inside one stretched second in the Glacial Rift.
	 * Level 20+ encounter. Three trials; passing all three teaches Time Stop.
	 * Progress: StatusEffects.KairosTrials (v1 passed, v2 in trial, v3 day, v4 met)
	 */
	public class Kairos extends BaseContent {

		public function Kairos() {}

		public function hasMet():Boolean { return player.hasStatusEffect(StatusEffects.KairosTrials); }
		public function trialsPassed():int { return hasMet() ? player.statusEffectv1(StatusEffects.KairosTrials) : 0; }
		public function inTrial():int { return hasMet() ? player.statusEffectv2(StatusEffects.KairosTrials) : 0; }
		public function isReadyToTeach():Boolean { return trialsPassed() >= 3 && !player.hasStatusEffect(StatusEffects.KnowsTimeStop); }

		private function markMet():void { if (!hasMet()) player.createStatusEffect(StatusEffects.KairosTrials, 0, 0, 0, 1); }
		private function setPassed(v:int):void { player.addStatusValue(StatusEffects.KairosTrials, 1, v - player.statusEffectv1(StatusEffects.KairosTrials)); }
		private function setInTrial(v:int):void { player.addStatusValue(StatusEffects.KairosTrials, 2, v - player.statusEffectv2(StatusEffects.KairosTrials)); }
		private function stampDay():void { player.addStatusValue(StatusEffects.KairosTrials, 3, getGame().time.days - player.statusEffectv3(StatusEffects.KairosTrials)); }

		//---------------- MEETING ----------------
		public function firstMeeting():void {
			clearOutput();
			outputText("The wind dies. Not fades - <b>dies</b>, mid-gust, and the snowflakes stop where they hang.\n\n");
			outputText("Ahead of you, in a clearing of undisturbed white, stands a figure. Tall, gaunt, grey as a winter sky, wrapped in layers of travel cloth that have long since stopped moving. One hand is raised, fingers spread, as if he were reaching for something just out of sight. He is the only thing here that is not frozen, and yet he is not moving either.\n\n");
			outputText("Then his head turns. It turns <i>slowly</i>, the way a glacier moves.\n\n");
			outputText("\"<i>Oh,</i>\" he says. His voice sounds like it is arriving from a room you left an hour ago. \"<i>There's another one. It has been... a while.</i>\"\n\n");
			outputText("He lowers his hand. Around you the snow resumes falling, and the wind picks back up - but only at the clearing's edges, as though the space he occupies is a hole in the weather.\n\n");
			outputText("\"<i>Kairos,</i>\" he says, tapping his chest. \"<i>I live in a second. Just the one. I stretched it out to make room, and now I can't find the end of it. Do you know how long a second is, wanderer, when you have nothing to measure it against?</i>\"");
			markMet();
			menu();
			addButton(0, "Hear him out", kairosPitch);
			addButton(1, "Step back", kairosCautious);
			addButton(14, "Leave", camp.returnToCampUseOneHour);
		}

		private function kairosCautious():void {
			clearOutput();
			outputText("You take a step back. He watches you do it with mild interest, the way you might watch a kettle.\n\n");
			outputText("\"<i>Sensible,</i>\" he says. \"<i>I've had a very long time to become strange. But I'm not going to do anything to you. Mostly because doing things takes a while, from in here.</i>\"");
			menu();
			addButton(0, "Hear him out", kairosPitch);
			addButton(14, "Leave", camp.returnToCampUseOneHour);
		}

		private function kairosPitch():void {
			clearOutput();
			outputText("He doesn't seem offended. He seems, if anything, pleased to have an audience.\n\n");
			outputText("\"<i>I can teach you the trick of it,</i>\" he says. \"<i>Not the whole of what I do - you'd want a few centuries of boredom first - but the useful part. Three trials. Pass them and the next second you're in belongs to you.</i>\"\n\n");
			outputText("\"<i>Stillness. Patience. And a third thing you'll have to meet to understand.</i>\"");
			menu();
			addButton(0, "Accept", kairosAccept);
			addButton(1, "Ask why", kairosWhy);
			addButton(14, "Not now", camp.returnToCampUseOneHour);
		}

		private function kairosWhy():void {
			clearOutput();
			outputText("\"<i>Why not,</i>\" he says, and shrugs, and the shrug takes a long time to finish. \"<i>I've had one conversation in - hm. Call it a decade. I'd like it to have been about something.</i>\"\n\n");
			outputText("\"<i>Also, you're the first thing to walk into my clearing in all that time, and you did it by accident. That deserves a prize.</i>\"");
			menu();
			addButton(0, "Accept", kairosAccept);
			addButton(14, "Not now", camp.returnToCampUseOneHour);
		}

		private function kairosAccept():void {
			setInTrial(1);
			trialStillness(0);
		}

		//---------------- HUB ----------------
		public function hub():void {
			clearOutput();
			outputText("Kairos is where you left him, in his pocket of still air. The snow bends around the clearing without ever entering it.\n\n");
			var p:int = trialsPassed();
			if (p == 0) outputText("\"<i>Stillness first,</i>\" he says. \"<i>Whenever you're ready.</i>\"");
			else if (p == 1) outputText("\"<i>Patience next,</i>\" he says. \"<i>This one hurts more than the cold does.</i>\"");
			else if (p == 2) outputText("\"<i>And then the third,</i>\" he says. \"<i>The one I can't explain. You'll see why.</i>\"");
			else if (!player.hasStatusEffect(StatusEffects.KnowsTimeStop)) outputText("\"<i>You did it,</i>\" he says. \"<i>All three. Come here. Let me give you the part that's useful.</i>\"");
			else outputText("\"<i>Go on,</i>\" he says. \"<i>Use it well. Or badly. I won't know either way.</i>\"");
			outputText("\n\nTrials passed: <b>" + p + " / 3</b>");
			menu();
			if (p < 3) addButton(0, "Trial " + (p + 1), nextTrial).hint("Begin the next trial.");
			else if (!player.hasStatusEffect(StatusEffects.KnowsTimeStop)) addButton(0, "Learn", kairosTeach).hint("Take the lesson.");
			addButton(1, "Talk", kairosTalk);
			addButton(14, "Leave", camp.returnToCampUseOneHour);
		}

		private function nextTrial():void {
			if (trialsPassed() == 0) { setInTrial(1); trialStillness(0); }
			else if (trialsPassed() == 1) { setInTrial(2); trialWait(0); }
			else if (trialsPassed() == 2) { setInTrial(3); trialEcho(); }
			else kairosTeach();
		}

		private function kairosTalk():void {
			clearOutput();
			outputText("You ask him what it's like.\n\n");
			outputText("He thinks about it. Genuinely thinks about it, for what feels like a while.\n\n");
			outputText("\"<i>Like standing in a doorway,</i>\" he says at last. \"<i>For years. And everyone you ever knew is walking past on the other side, and they're going so fast you can barely see them, and if you step out to join them you lose the doorway and have to find it again.</i>\"\n\n");
			outputText("\"<i>So you don't step out. And after a while you forget which side was the one you came from.</i>\"");
			menu();
			addButton(0, "Back", hub);
		}

		private function kairosTeach():void {
			clearOutput();
			outputText("Kairos steps close - closer than he has all this time - and puts two fingers against your forehead.\n\n");
			outputText("\"<i>Don't think about stopping time,</i>\" he says. \"<i>Time doesn't stop. It's the second that's the problem. It's too thin. You have to hold it open.</i>\"\n\n");
			outputText("His fingers press. For a moment the clearing goes very quiet in a way that has nothing to do with sound.\n\n");
			if (!player.hasStatusEffect(StatusEffects.KnowsTimeStop)) {
				player.createStatusEffect(StatusEffects.KnowsTimeStop, 0, 0, 0, 0);
				outputText("<b>You have learned Time Stop!</b>\n\n");
			}
			outputText("\"<i>There,</i>\" he says, stepping back. \"<i>Now go and use it somewhere with fewer snowflakes. And come back and tell me about it, if you ever get the time.</i>\"");
			menu();
			addButton(0, "Thank him", hub);
			addButton(14, "Leave", camp.returnToCampUseOneHour);
		}

		//---------------- TRIAL 1: STILLNESS ----------------
		private function trialStillness(step:int):void {
			if (step > 3) { trialStillnessPass(); return; }
			clearOutput();
			if (step == 0) {
				outputText("Kairos walks - unhurried, each step its own small epoch - until he stands a few paces from you, facing the empty snow.\n\n");
				outputText("\"<i>Stand here,</i>\" he says. \"<i>Right here. Three times the Rift will try to make you move. Each time, don't.</i>\"\n\n");
				outputText("\"<i>That's all. That's the whole trial. Most people fail on the second one.</i>\"");
				menu();
				addButton(0, "Begin", trialStillness, 1);
				addButton(14, "Back", hub);
				return;
			}
			if (step == 1) {
				outputText("The wind comes for you. Not a gust - a long, steady pressure, leaning on your chest and your shoulders, pushing as though it wants to see how far you'll bend before you brace.\n\n");
				outputText("Kairos has not moved. Snow gathers in the folds of his cloth.");
				menu();
				addButton(0, "Hold still", trialStillness, 2).hint("Do nothing about the wind. Let it lean.");
				addButton(1, "Brace yourself", trialStillnessFail).hint("Set your feet and lean into it.");
				addButton(2, "Turn away from it", trialStillnessFail).hint("Put your back to the wind.");
				return;
			}
			if (step == 2) {
				outputText("Something crunches behind you. A footfall, heavy, close - close enough that whatever made it must be right at your shoulder.\n\n");
				outputText("Kairos's eyes flick toward you, then away. He hasn't turned around either.");
				menu();
				addButton(0, "Hold still", trialStillness, 3).hint("Don't look. Don't move.");
				addButton(1, "Look back", trialStillnessFail).hint("Just a glance.");
				addButton(2, "Call out", trialStillnessFail).hint("Ask him what that was.");
				return;
			}
			outputText("The cold gets in. It always does, eventually - a slow seep through cloth and skin, down into the bones of your feet and the joints of your hands. Your body has opinions about this. Your body wants to <i>do</i> something about it.\n\n");
			outputText("\"<i>Third one,</i>\" Kairos murmurs, without moving his lips much. \"<i>This is the one where people decide they're cold.</i>\"");
			menu();
			addButton(0, "Hold still", trialStillness, 4).hint("Let the cold be there. Don't answer it.");
			addButton(1, "Shiver", trialStillnessFail).hint("Shake it out.");
			addButton(2, "Hug yourself", trialStillnessFail).hint("Wrap your arms around your ribs.");
		}

		private function trialStillnessPass():void {
			clearOutput();
			outputText("You hold.\n\n");
			outputText("The wind gives up first. Then the cold, grudgingly. Whatever was standing behind you - you never do find out what - loses interest and wanders off.\n\n");
			outputText("When you finally let yourself breathe, Kairos is looking at you with something like approval.\n\n");
			outputText("\"<i>Good,</i>\" he says. \"<i>One.</i>\"");
			setPassed(1);
			setInTrial(0);
			stampDay();
			menu();
			addButton(0, "Continue", hub);
		}

		private function trialStillnessFail():void {
			clearOutput();
			outputText("You move.\n\n");
			outputText("It's small - a shift, a flinch, a decision - but it's enough. Kairos exhales through his nose, which from him counts as a laugh.\n\n");
			outputText("\"<i>That's fine,</i>\" he says. \"<i>The second one is where most people fail, you know. You're early.</i>\"");
			setInTrial(0);
			stampDay();
			menu();
			addButton(0, "Try again", trialStillness, 0);
			addButton(14, "Back", hub);
		}

		//---------------- TRIAL 2: PATIENCE ----------------
		private function trialWait(step:int):void {
			if (step > 3) { trialWaitPass(); return; }
			clearOutput();
			if (step == 0) {
				outputText("Kairos raises his hand again, and the clearing goes very still.\n\n");
				outputText("\"<i>I'm going to leave you in here with me for a while,</i>\" he says. \"<i>Not long. But it won't feel that way.</i>\"\n\n");
				outputText("\"<i>Three times it'll get unbearable. Three times you'll want to answer it. Don't.</i>\"\n\n");
				outputText("Then he is simply somewhere else in the second, and you are alone with the silence, and it starts.");
				menu();
				addButton(0, "Begin", trialWait, 1);
				addButton(14, "Back", hub);
				return;
			}
			var gain:int = 14 + rand(8) + step * 3;
			player.takeLustDamage(gain, true);
			if (step == 1) outputText("The quiet has weight. You notice your own body the way you'd notice a stranger's - the pulse in your throat, the heat pooling low and slow with nothing to spend it on.\n\n");
			else if (step == 2) outputText("It gets worse. Or better. The distinction has stopped being useful. Every point of contact between you and your own clothes has become extremely interesting.\n\n");
			else outputText("By now the ache has settled into a rhythm, and the rhythm is the only thing in the world that is happening. There is a <i>very</i> strong argument for doing something about it.\n\n");
			outputText("<b>Lust: " + Math.round(player.lust) + " / " + player.maxLust() + "</b>");
			if (player.lust >= player.maxLust()) { trialWaitFail(); return; }
			menu();
			addButton(0, "Hold", trialWait, step + 1).hint("Endure it. It costs you nothing.");
			addButton(1, "Breathe through it", trialWaitFocus, trialWait, step + 1).hint("Costs a little fatigue, takes the edge off.");
		}

		private function trialWaitFocus(next:Function, step:int):void {
			player.takeLustDamage(-12, true);
			player.changeFatigue(5);
			next(step);
		}

		private function trialWaitPass():void {
			clearOutput();
			outputText("The unbearable part arrives, and then - without drama, without a signal - it passes.\n\n");
			outputText("Kairos is back beside you. He looks mildly impressed.\n\n");
			outputText("\"<i>Two,</i>\" he says. \"<i>Most people are on the floor by now.</i>\"");
			setPassed(2);
			setInTrial(0);
			stampDay();
			menu();
			addButton(0, "Continue", hub);
		}

		private function trialWaitFail():void {
			clearOutput();
			outputText("It becomes too much, and you give in - hands moving before you've decided anything, relief flooding through you in a way that feels almost like cheating.\n\n");
			outputText("Kairos watches you from wherever he went. \"<i>That's the trial,</i>\" he says. \"<i>Not the wanting. The deciding.</i>\"");
			setInTrial(0);
			stampDay();
			menu();
			addButton(0, "Try again", trialWait, 0);
			addButton(14, "Back", hub);
		}

		//---------------- TRIAL 3: THE SECOND THAT NEVER ENDS ----------------
		private function trialEcho():void {
			clearOutput();
			outputText("Kairos doesn't explain the third one. Instead he pinches the air between two fingers, and something comes away in his hand - a sliver of the frozen second, thin as a splinter and utterly still.\n\n");
			outputText("\"<i>Here,</i>\" he says, and flicks it at you.\n\n");
			outputText("The splinter lands, and stands up, and wears his shape. It is the same height, the same grey, the same patient hands - except that it is moving at its own speed, and its own speed is <i>wrong</i>.\n\n");
			outputText("\"<i>Beat it,</i>\" Kairos says, stepping back to watch. \"<i>Or don't. But you'll understand it either way.</i>\"");
			menu();
			addButton(0, "Ready", trialEchoBegin);
		}

		private function trialEchoBegin():void {
			startCombat(new KairosEcho());
		}

		public function trialEchoWon():void {
			outputText("\n\nThe echo comes apart into nothing, the way a held note stops being a sound. Kairos is nodding slowly.\n\n");
			outputText("\"<i>Three,</i>\" he says. \"<i>Come back when you've caught your breath. I'll show you what it's for.</i>\"");
			setPassed(3);
			setInTrial(0);
			stampDay();
			getGame().combat.cleanupAfterCombat(camp.returnToCampUseOneHour);
		}

		public function trialEchoLost():void {
			outputText("\n\nKairos watches you go down without any particular surprise.\n\n");
			outputText("\"<i>Third one's the hard one,</i>\" he says. \"<i>Come back and try again.</i>\"");
			setInTrial(0);
			stampDay();
			getGame().combat.cleanupAfterCombat(camp.returnToCampUseOneHour);
		}
	}
}
