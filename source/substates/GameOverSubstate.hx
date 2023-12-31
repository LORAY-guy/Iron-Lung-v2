package substates;

import objects.Character;
import flixel.FlxObject;
import flixel.math.FlxPoint;

import states.MainMenuState;
import states.FreeplayState;

class GameOverSubstate extends MusicBeatSubstate
{
	public var boyfriend:Character;
	var camFollow:FlxObject;
	var updateCamera:Bool = false;
	var playingDeathSound:Bool = false;

	var stageSuffix:String = "";

	public static var characterName:String = 'lixian-dead';
	public static var deathSoundName:String = 'fnf_loss_sfx';
	public static var loopSoundName:String = 'gameOver';
	public static var endSoundName:String = 'gameOverEnd';

	public static var instance:GameOverSubstate;

	public static function resetVariables() {
		characterName = 'lixian-dead';
		deathSoundName = 'fnf_loss_sfx';
		loopSoundName = 'gameOver';
		endSoundName = 'gameOverEnd';
	}

	override function create()
	{
		instance = this;
		PlayState.instance.callOnLuas('onGameOverStart', []);
		
		if (PlayState.SONG.song.toLowerCase() == 'iron-lung')
		{
			PlayState.instance.modchartTimers.set('gameOverEnd', new FlxTimer().start(5, function(tmr:FlxTimer) {
				if(tmr.finished) {
					FlxG.sound.music.stop();
					PlayState.deathCounter = 0;
					PlayState.seenCutscene = false;
					PlayState.chartingMode = false;

					PlayState.instance.modchartTimers.remove('gameOverEnd');
					MusicBeatState.switchState(new MainMenuState());
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
				}
			}, 1));
		}

		super.create();
	}

	public function new(x:Float, y:Float, camX:Float, camY:Float)
	{
		super();

		PlayState.instance.setOnLuas('inGameOver', true);

		Conductor.songPosition = 0;

		if (PlayState.SONG.song.toLowerCase() != 'iron-lung')
		{
			boyfriend = new Character(x, y, characterName, true);
			boyfriend.x += 230;
			boyfriend.y += -140;
			add(boyfriend);
			boyfriend.playAnim('firstDeath');

			camFollow = new FlxObject(0, 0, 1, 1);
			camFollow.setPosition(boyfriend.getGraphicMidpoint().x, boyfriend.getGraphicMidpoint().y);
			FlxG.camera.focusOn(new FlxPoint(FlxG.camera.scroll.x + (FlxG.camera.width / 2), FlxG.camera.scroll.y + (FlxG.camera.height / 2)));
			add(camFollow);
		}

		FlxG.sound.play(Paths.sound(PlayState.SONG.song.toLowerCase() == 'iron-lung' ? 'markDead' : deathSoundName));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;
	}

	public var startedDeath:Bool = false;
	var isFollowingAlready:Bool = false;
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		PlayState.instance.callOnLuas('onUpdate', [elapsed]);

		if (PlayState.SONG.song.toLowerCase() != 'iron-lung')
		{
			if (controls.ACCEPT)
			{
				endBullshit();
			}

			if (controls.BACK)
			{
				#if desktop DiscordClient.resetClientID(); #end
				FlxG.sound.music.stop();
				PlayState.deathCounter = 0;
				PlayState.seenCutscene = false;
				PlayState.chartingMode = false;

				Mods.loadTopMod();
				if (PlayState.isMainMenu)
					MusicBeatState.switchState(new MainMenuState());
				else
					MusicBeatState.switchState(new FreeplayState());

				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				PlayState.instance.callOnScripts('onGameOverConfirm', [false]);
			}
		
			if (boyfriend.animation.curAnim != null)
			{
				if (boyfriend.animation.curAnim.name == 'firstDeath' && boyfriend.animation.curAnim.finished && startedDeath)
					boyfriend.playAnim('deathLoop');

				if(boyfriend.animation.curAnim.name == 'firstDeath')
				{
					if(boyfriend.animation.curAnim.curFrame >= 12 && !isFollowingAlready)
					{
						FlxG.camera.follow(camFollow, LOCKON, 0);
						updateCamera = true;
						isFollowingAlready = true;
					}

					if (boyfriend.animation.curAnim.finished && !playingDeathSound)
					{
						startedDeath = true;
						coolStartDeath();
					}
				}
			}
		} else {
			
		}

		if(updateCamera) FlxG.camera.followLerp = FlxMath.bound(elapsed * 0.6 / (FlxG.updateFramerate / 60), 0, 1);
		else FlxG.camera.followLerp = 0;

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
		PlayState.instance.callOnLuas('onUpdatePost', [elapsed]);
	}

	var isEnding:Bool = false;

	function coolStartDeath(?volume:Float = 1):Void
	{
		FlxG.sound.playMusic(Paths.music(loopSoundName), volume);
	}

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			boyfriend.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music(endSoundName));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					MusicBeatState.resetState();
				});
			});
			PlayState.instance.callOnScripts('onGameOverConfirm', [true]);
		}
	}

	override function destroy()
	{
		instance = null;
		super.destroy();
	}
}
