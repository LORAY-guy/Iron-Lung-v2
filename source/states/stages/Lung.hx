package states.stages;

import states.stages.objects.*;

class Lung extends BaseStage
{
	//BG Elements
	public var ocean:BGSprite;
	public var frontdoor:BGSprite;
	public var bg:BGSprite;
	public var tubes:BGSprite;
	public var table:BGSprite;
	public var depth:BGSprite;
	public var depthmeter:BGSprite;
	public var oxygenmeter:BGSprite;
	public var curoxygen:BGSprite;

	public var steam1:BGSprite;
	public var steam2:BGSprite;

	public var monsta:BGSprite;
	public var splash:BGSprite;

	public var lamp:BGSprite;
	public var light:BGSprite;
	public var vignette:BGSprite;

	//Lung Camera Elements
	public static var map:IronMap;
	public static var tv:TV;
	public var tutorialTxt:FlxText;

	//Bubble settings
	public static var xOffset:Float = 350;
	public static var xPos:Float = 1470;
	public static var yPos:Float = 1050;
	public static var mult:Float = 1;
	public static var lifeTime:Float = 1000;

	//Misc.
	public static var tweensMap:Map<String, FlxTween> = new Map<String, FlxTween>();
	public static var timersMap:Map<String, FlxTimer> = new Map<String, FlxTimer>();
	public static var soundsMap:Map<String, FlxSound> = new Map<String, FlxSound>();
	public var precacheList:Map<String, String> = new Map<String, String>();

	public static var quarterSong:Array<Int> = [for (i in (0...3)) Std.int((2560 / 4) * (i + 1))];
	public static var textsEnding:Array<String> = [];

	public static var endTime:Int = 2565;
	public static var totalSteps:Int = 2560;
	public static var photoTaken:Int = 0;
	public static var totalMvt1:Float = 5.6888888888889;
	public static var totalMvt2:Float = 5.7333333333333;
	public var botplaySine:Float = 0;

	public static var isGoodEnding:Bool = false;
	public static var cooldown:Bool = false;
	public var firstPhoto:Bool = false;
	public var firstOpening:Bool = false;
	public var blocked:Bool = false;
	public var monstaMoment:Bool = false;

	public var blackoverlay:FlxSprite;
	public var endingTxt:FlxText;
	public var logo:FlxSprite;

	public static var endSound:FlxSound;

	private var path:String = 'lung/';

	override function create()
	{
		precacheList.set('oxygen', 'sound');
		precacheList.set('jumpscare', 'sound');
		precacheList.set('printing', 'sound');

		if (!ClientPrefs.data.lowQuality)
		{
			precacheList.set('StreamHiss', 'sound');
			precacheList.set('TeleportSound', 'sound');
			precacheList.set('SteamSoundBurst', 'sound');
		}

		precacheList.set('badEnding', 'sound');
		precacheList.set('goodEnding', 'sound');

		ocean = new BGSprite(path + 'bloodocean', 775, 375, 1, 1);
		add(ocean);

		frontdoor = new BGSprite(path + 'doorthingy', 775, 700, 1, 1);
		add(frontdoor);

		bg = new BGSprite(path + 'ironlung', 775, 375, 1, 1);
		add(bg);

		tubes = new BGSprite(path + 'tubes', 775, 375, 1, 1);
		add(tubes);

		table = new BGSprite(path + 'table', 775, 375, 1, 1);
		add(table);

		depth = new BGSprite(path + 'depth', 775, 375, 1, 1);
		add(depth);

		depthmeter = new BGSprite(path + 'meter', 775, 220, 1, 1);
		add(depthmeter);

		oxygenmeter = new BGSprite(path + 'oxygenmeter', 775, 375, 1, 1);
		add(oxygenmeter);

		curoxygen = new BGSprite(path + 'oxygen1', 775, 375, 1, 1);
		add(curoxygen);

		if (!ClientPrefs.data.lowQuality)
		{
			steam1 = new BGSprite(path + 'steam', 970, 950, ['steam'], true);
			steam1.visible = false;
			steam1.alpha = 0.4;
			add(steam1);

			steam2 = new BGSprite(path + 'steam', 1770, 430, ['steam'], true);
			steam2.visible = false;
			steam2.alpha = 0.4;
			steam2.angle = -180;
			add(steam2);
		}

		monsta = new BGSprite(path + 'monsta', 1240, 420, 1, 1);
		monsta.setGraphicSize(Std.int(monsta.width * 0.5));
		monsta.updateHitbox();
		monsta.visible = false;
		add(monsta);

		splash = new BGSprite(path + 'splash', 1120, 470, ['Splash'], true);
		splash.setGraphicSize(Std.int(splash.width * 3.75));
		splash.updateHitbox();
		splash.visible = false;
		add(splash);

		lamp = new BGSprite(path + 'lamp', 775, 375, 1, 1);
		add(lamp);

		light = new BGSprite(path + 'light', 620, 395, 1, 1);
		add(light);

		vignette = new BGSprite(path + 'vignette', 775, 375, 1, 1);
		add(vignette);

		initLungElements();

		blackoverlay = new FlxSprite().makeGraphic(2000, 2000, FlxColor.BLACK);
		blackoverlay.cameras = [camOther];
		add(blackoverlay);

		logo = new FlxSprite();
		logo.frames = Paths.getSparrowAtlas('mainmenu/menu_iron_lung');
		logo.animation.addByPrefix('idle', 'iron_lung white', 24, true);
		logo.animation.play('idle', false);
		logo.active = true;
		logo.cameras = [camOther];
		logo.screenCenter();
		logo.visible = false;
		add(logo);

		for (key => type in precacheList)
		{
			//trace('Key $key is type $type');
			switch(type)
			{
				case 'image':
					Paths.image(key);
				case 'sound':
					Paths.sound(key);
				case 'music':
					Paths.music(key);
			}
		}
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		map.mouseText.x = FlxG.mouse.getScreenPosition(camOther).x - 25;
		map.mouseText.y = FlxG.mouse.getScreenPosition(camOther).y - 18;

		if (!ClientPrefs.data.lowQuality)
		{
			if ((curStep < 390) || (curStep >= endTime && curStep < 2826)) 
			{
				var bubble = Bubbles.createBubble(FlxG.random.float(xPos, xPos + xOffset), yPos, mult, lifeTime);
				if (curStep >= endTime) bubble.cameras = [camOther];
				insert(1, bubble);
			}
		}

        if (FlxG.keys.justPressed.SPACE && curStep >= 512 && curStep < 2560 && !cooldown)
		{
			tv.animation.play('blackscreen', false);
			cooldown = true;
			timersMap.set('pressedSpace', new FlxTimer().start(2.4, function(tmr:FlxTimer)
			{
				checkNearbySprite();
				timersMap.set('cooldown', new FlxTimer().start(1, function(tmr:FlxTimer) {
					cooldown = false;
					cancelTimer('cooldown');
				}));
				cancelTimer('pressedSpace');
			}));
			FlxG.sound.play(Paths.sound('printing'), 1);
			if (!firstPhoto) firstPhoto = true;
		}

		if (FlxG.keys.justPressed.TAB && !blocked)
		{
			blocked = true;
			var showPeppino:Bool = false;

			if ((tv.alpha == 0 && tv.peppino.alpha == 0) && FlxG.random.int(0, 99) == 99) showPeppino = true;

			if (showPeppino)
			{
				tv.visible = false;
				tv.peppino.visible = true;
			} else {
				tv.visible = true;
				tv.peppino.visible = false;
			}

			var targetAlpha = (camLung.alpha == 0) ? 1 : 0;
			tweensMap.set('camLungAlpha', FlxTween.tween(camLung, {alpha: targetAlpha}, 0.5, {ease: FlxEase.sineInOut, onComplete: function(twn:FlxTween) {
				blocked = false;
				cancelTween('camLungAlpha');
			}}));
			FlxG.mouse.visible = (targetAlpha == 1) ? true : false;

			if (!firstOpening) firstOpening = true;
		}

		for (marker in map.markers)
		{
			var isMouseOverlapping:Bool = mouseOverLapsSprite(marker);
			var currentAlpha:Float = marker.alpha;

			if (!marker.checked && isMouseOverlapping && currentAlpha == 1)
			{
				marker.loadGraphic(Paths.image('lung/crosshairselect'));
				map.mouseText.text = 'X_' + marker.fakeLocationX + '\nY_' + marker.fakeLocationY;
				map.mouseText.visible = true;
				break;
			} 
			else if (!marker.checked && (!isMouseOverlapping || currentAlpha != 1))
			{
				marker.loadGraphic(Paths.image('lung/crosshairunselect'));
				map.mouseText.visible = false;
			}
		}
		
		if (tutorialTxt != null)
		{
			botplaySine = botplaySine + 180 * elapsed;
			tutorialTxt.alpha = 1 - Math.sin((Math.PI * botplaySine) / 180);
		}

		if (firstOpening && tutorialTxt.alpha < 0.01)
		{
			tutorialTxt.x = 900;
			tutorialTxt.y = 260;
			tutorialTxt.cameras = [camLung]; //For the take picture tutorial
			tutorialTxt.text = 'Press \'Space\' to take a picture';
			if (curStep < 512) tutorialTxt.visible = false;
		}

		if (firstPhoto && tutorialTxt.alpha < 0.01) tutorialTxt.destroy();

		if (curStep >= 1536)
		{
			var alphaValue:Float = Math.sin(curStep * 0.005) * 0.5 + 1;
			light.alpha = alphaValue;
		}
	}

	override function stepHit()
	{
		super.stepHit();

		switch (curStep)
		{
			case 1:
				var goingDown:FlxTween = FlxTween.tween(depthmeter, {y: 375}, 32, {ease: FlxEase.linear, onComplete: function(twn:FlxTween) {cancelTween('goingDown');}});
				tweensMap.set('goingDown', goingDown);
			case 48:
				var blackOverlayFadeOut:FlxTween = FlxTween.tween(blackoverlay, {alpha: 0}, 4, {ease:FlxEase.linear, onComplete: function(twn:FlxTween) {cancelTween('blackOverlayFadeOut');}});
				tweensMap.set('blackOverlayFadeOut', blackOverlayFadeOut);
			case 276:
				var oceanColorChange:FlxTween = FlxTween.color(ocean, 6, FlxColor.WHITE, 0xFF555555, {ease:FlxEase.linear, onComplete: function(twn:FlxTween) {cancelTween('oceanColorChange');}});
				tweensMap.set('oceanColorChange', oceanColorChange);
			case 340:
				var closingFrontHoleShielding:FlxTween = FlxTween.tween(frontdoor, {y: 375}, 4, {ease:FlxEase.sineInOut, onComplete: function(twn:FlxTween) {cancelTween('closingFrontHoleShielding');}});
				tweensMap.set('closingFrontHoleShielding', closingFrontHoleShielding);
			case 362:
				camGame.shake(0.0025, 2.2);
			case 512:
				map.startShipPart1(totalMvt1);
				tv.glitch.visible = true;
				tutorialTxt.visible = true;
			case 1504:
				var blackOverlayComingBack:FlxTween = FlxTween.tween(blackoverlay, {alpha: 1}, 2.4, {ease:FlxEase.linear, onComplete: function(twn:FlxTween) {
					blackoverlay.destroy();
					cancelTween('blackOverlayComingBack');
				}});
				tweensMap.set('blackOverlayComingBack', blackOverlayComingBack);
			case 1536:
				cancelTween("finalPart1x");
				cancelTween("finalPart1y");
				map.ship.x = 60;
				map.ship.y = 502;
				map.ship.angle = -90;
				monstaMoment = true;
				timersMap.set('noMoreMonsta', new FlxTimer().start(10, function(tmr:FlxTimer)
				{
					monstaMoment = false;
					cancelTimer('noMoreMonsta');
				}));
				map.startShipPart2(totalMvt2);
				panic([lamp, light, vignette]);
				if (!ClientPrefs.data.lowQuality)
				{
					steam1.visible = true;
					steam2.visible = true;
					FlxG.sound.play(Paths.sound('SteamSoundBurst'), 0.05, false, function() {soundsMap.set('hiss', FlxG.sound.play(Paths.sound('StreamHiss'), 0.05, true));});
					FlxG.sound.play(Paths.sound('TeleportSound'), 0.3, false);
				}
			case 2528:
				generateVocals();
				endSound.play();
			case 2549:
				if (isGoodEnding) endTime = 2575;
			case 2560:
				tv.glitch.visible = false;
				cancelTween("340");

				if (!ClientPrefs.data.lowQuality && soundsMap.exists('hiss')) 
				{
					soundsMap.get('hiss').fadeOut(0.6, 0, function(twn:FlxTween) 
					{
						if (soundsMap.exists('hiss')) soundsMap.get('hiss').stop();
						soundsMap.remove('hiss');
					});
				}

				if (!isGoodEnding)
				{
					splash.visible = true;
					splash.animation.play('splash', false);
					monsta.visible = true;
					
					var monstaChangeSize:FlxTween = FlxTween.tween(monsta.scale, {x: 0.75, y: 0.75}, 0.7, {ease: FlxEase.linear, onComplete: function(twn:FlxTween) {cancelTween('monstaChangeSize');}});
					tweensMap.set('monstaChangeSize', monstaChangeSize);

					var monstaChangeY:FlxTween = FlxTween.tween(monsta, {y: monsta.y + 60}, 0.7, {ease: FlxEase.linear, onComplete: function(twn:FlxTween) {cancelTween('monstaChangeY');}});
					tweensMap.set('monstaChangeY', monstaChangeY);

					soundsMap.set('monsta', FlxG.sound.play(Paths.sound('jumpscare'), 1));
					camGame.shake(0.025, 0.7);
					camHUD.shake(0.0125, 0.7);
					camLung.shake(0.0125, 0.7);
					timersMap.set('endingHideCameras', new FlxTimer().start(0.7, function(tmr:FlxTimer) 
					{
						camGame.visible = false;
						camHUD.visible = false;
						camLung.visible = false;
						cancelTimer('endingHideCameras');
					}));

					textsEnding = ['A huge beast destroyed your ship.', 'You haven\'t taken all the required photographies.', 'Somewhere in the void, there must be hope...'];
				} 
				else
				{
					timersMap.set('endingHideCameras', new FlxTimer().start(2.4, function(tmr:FlxTimer) 
					{
						camGame.visible = false;
						camHUD.visible = false;
						camLung.visible = false;
						cancelTimer('endingHideCameras');
					}));

					textsEnding = ['You crashed into a wall...', 'No photographies has been recovered.', 'Somewhere in the void, there must be hope...'];
				}
			case 2568:
				if (isGoodEnding) camGame.shake(0.015, 1.3333333333333);
			case 2584:
				if (isGoodEnding) camGame.shake(0.03, 1.3333333333333);
			case 2627:
				endingTxt = new FlxText(0, 0, 750, textsEnding[0], 62).setFormat(Paths.font('vcr.ttf'), 62, FlxColor.GREEN, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				endingTxt.cameras = [camOther];
				endingTxt.screenCenter();
				add(endingTxt);
			case 2695:
				endingTxt.text = textsEnding[1];
				endingTxt.screenCenter();
			case 2763:
				endingTxt.text = textsEnding[2];
				endingTxt.screenCenter();
			case 2831:
				endingTxt.destroy();
				logo.visible = true;
		}

		if (!camGame.visible)
		{
			xOffset = 1280;
			xPos = 0;
			yPos = 900;
			mult = 1.2;
			lifeTime = 2750;
		}
	}

	function checkNearbySprite()
	{
		var nearby:Int = -1;
		var shipX:Float = map.ship.x;
		var shipY:Float = map.ship.y;
	
		for (i in 0...map.markers.length)
		{
			var sprite = map.markers[i];
			var spriteX = sprite.x;
			var spriteY = sprite.y;
	
			var distanceX = Math.abs(shipX - spriteX);
			var distanceY = Math.abs(shipY - spriteY);
	
			if (distanceX <= 8 && distanceY <= 8)
			{
				nearby = i;
				break;
			}
		}
	
		if (nearby >= 0)
			printImportant(nearby);
		else
			printRandom();
		
		cancelTimer('resetScreen');
		timersMap.set('resetScreen', new FlxTimer().start(8, function(tmr:FlxTimer) 
		{
			tv.animation.play('blackscreen', false);
			cancelTimer('resetScreen');
		}));
	}

	function printImportant(num)
	{
		var animationName = (photoTaken == 2 && num == 1) ? 'important2nofish' : 'important' + (num + 1);
		map.markers[num].checked = true;
		map.markers[num].loadGraphic(Paths.image('lung/check'));
		tv.animation.play(animationName, false);
		if (animationName != 'important2nofish')
		{
			photoTaken = photoTaken + 1;
			if (photoTaken >= 4) isGoodEnding = true;	
		}
	}
	
	function printRandom()
	{
		if (!monstaMoment)
		{
			var randomPhoto:Dynamic = (FlxG.random.int(1, 100) == 100) ? 'amongus' : FlxG.random.int(1, 4);
			tv.animation.play('random' + randomPhoto, false);
			if (randomPhoto == 'amongus')
				FlxG.sound.play('vineboom', 0.5);
		}
		else
		{
			tv.animation.play('randommonsta', false);
			cancelTimer('noMoreMonsta');
			monstaMoment = false;
		}
	}

	function initLungElements()
	{
		map = new IronMap();
		add(map);
		add(map.ship);

		for (i in 0...map.markers.length) 
		{
			add(map.markers[i]);
			map.markers[i].cameras = [camLung];
		}

		add(map.mouseText);

		tv = new TV();
		add(tv);
		add(tv.glitch);
		add(tv.peppino);

		tutorialTxt = new FlxText(10, 640, 300, 'Press \'TAB\' to open the map', 26);
		tutorialTxt.setFormat(Paths.font('vcr.ttf'), 26, FlxColor.GREEN, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(tutorialTxt);

		//Cameras
		map.cameras = [camLung];
		map.ship.cameras = [camLung];
		map.mouseText.cameras = [camLung];

		tv.cameras = [camLung];
		tv.glitch.cameras = [camLung];
		tv.peppino.cameras = [camLung];
		
		tutorialTxt.cameras = [camHUD]; //For the press tab tutorial

		//Repositing post-camera affectation
		map.setPosition(0, 395);
		map.ship.setPosition(52, 675);
		map.setUpMarkers();
	}

	function panic(list:Array<BGSprite>) for (elt in list) FlxTween.color(elt, 0.01, FlxColor.WHITE, 0xFFFF0000, {ease:FlxEase.linear});

	public function cancelTimer(ID:String)
	{
		if (timersMap.exists(ID)) timersMap.get(ID).cancel();
		timersMap.remove(ID);
	}

	public function cancelTween(ID:String)
	{
		if (tweensMap.exists(ID)) tweensMap.get(ID).cancel();
		tweensMap.remove(ID);
	}

	public function posOverlaps(
        x1:Float, y1:Float, w1:Float, h1:Float,
        x2:Float, y2:Float, w2:Float, h2:Float
    )
    {
        return (x1 + w1 >= x2 && x1 < x2 + w2 && y1 + h1 >= y2 && y1 < y2 + h2);
    }
    
    public function mouseOverLapsSprite(spr:Marker)
    {
        var mouseX = FlxG.mouse.getScreenPosition(camLung).x;
        var mouseY = FlxG.mouse.getScreenPosition(camLung).y;
        
        var x = spr.x;
        var y = spr.y;
        var w = spr.width;
        var h = spr.height;

        return posOverlaps(
            mouseX, mouseY, 1, 1,
            x, y, w, h
        );
    }

	public static function set_playbackRate(value:Float)
	{
		if (endSound.playing) endSound.pitch = value;
		return value;
		trace('set playback rate of that bitch');
	}

	public static function setSongTime(time:Float, playbackRate:Float)
	{
		endSound.pause();

		if ((Conductor.songPosition - 195600) <= endSound.length)
		{
			endSound.time = time - 195600;
			endSound.pitch = playbackRate;
		}
		if ((Conductor.songPosition - 195600) >= 0) endSound.play();
		trace('set time of that bitch');
	}

	public static function onPause()
	{
		if (endSound != null) endSound.pause();

		for (key in soundsMap) key.pause();
		for (tween in tweensMap) tween.active = false;
		for (timer in timersMap) timer.active = false;
	}

	public static function onResume()
	{
		if (endSound != null) endSound.resume();

		for (key in soundsMap) key.resume();
		for (tween in tweensMap) tween.active = true;
		for (timer in timersMap) timer.active = true;
	}

	public static function generateVocals():Void
	{
		endSound = new FlxSound();
		endSound.loadEmbedded(Paths.sound(isGoodEnding ? "goodEnding": "badEnding"));

		FlxG.sound.list.add(endSound);
		trace('generated that bitch');
	}
}