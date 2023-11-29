playing = false

function onCreate()
	makeLuaSprite('bg', 'sinking', -750, -470)
	scaleObject('bg', 1.2, 1.2, true)
	addLuaSprite('bg', false)

	if sunkMark == 'Mark' then
		precacheImage('characters/mark-webcam')
		makeAnimationList()

		makeLuaSprite('markbg', 'office', 730, -350)
		setProperty('markbg.flipX', true)
		setObjectCamera('markbg', 'camHUD')
		scaleObject('markbg', 0.55, 0.45, true)
		addLuaSprite('markbg', false)

		makeAnimatedLuaSprite('mark', 'characters/mark-webcam', 151, -1037)
		addAnimationByPrefix('mark', 'idle', 'Idle', 24, false)
		addOffset('mark', 'idle', 0, 0)
		addAnimationByPrefix('mark', 'idle-alt', 'altIdle', 24, false)
		addOffset('mark', 'idle-alt', -15, -5)
		addAnimationByPrefix('mark', 'singRIGHT', 'Right', 24, false)
		addOffset('mark', 'singRIGHT', -4, 8)
		addAnimationByPrefix('mark', 'singDOWN', 'Down', 24, false)
		addOffset('mark', 'singDOWN', -7, -7)
		addAnimationByPrefix('mark', 'singUP', 'Up', 24, false)
		addOffset('mark', 'singUP', -16, 10)
		addAnimationByPrefix('mark', 'singLEFT', 'Left', 24, false)
		addOffset('mark', 'singLEFT', -1, 9)
		setObjectCamera('mark', 'camHUD')
		playAnim('mark', 'idle', false, false, 0)
		setObjectOrder('mark', getObjectOrder("markbg") + 1)
		scaleObject('mark', 0.275, 0.275, true)
		addLuaSprite('mark', false)

		makeLuaSprite('markbgOVERLAY', 'office-overlay', 730, -350)
		setObjectCamera('markbgOVERLAY', 'camHUD')
		scaleObject('markbgOVERLAY', 0.55, 0.45, true)
		addLuaSprite('markbgOVERLAY', false)
	end

	makeLuaSprite('end', '', 0, 0)
	makeGraphic('end', 1280, 720, '000000')
	setObjectCamera('end', 'camOther')
	screenCenter('end', 'xy')
	setProperty('end.visible', false)
	addLuaSprite('end', false)

	makeLuaText('endText', 'Thanks for playing!', 1280, 0.0, 0.0)
	setTextFont('endText', "ourple.ttf")
	setTextSize('endText', 72)
	setTextColor('endText', '00FF00')
	setObjectCamera('endText', 'camOther')
	screenCenter('endText', 'xy')
	setProperty('endText.visible', false)
	addLuaText('endText')
end

function onCreatePost()
	setProperty("cameraSpeed", 100)
	triggerEvent("Camera Follow Pos", '197.5', '171')
end

function onSongStart()
	setProperty("cameraSpeed", 1)
end

animationsList = {}
holdTimers = {mark = -1.0}
noteDatas = {mark = 0}

function makeAnimationList()
	animationsList[0] = 'singLEFT'
	animationsList[1] = 'singDOWN'
	animationsList[2] = 'singUP'
	animationsList[3] = 'singRIGHT'
end

function goodNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'No Animation' or noteType == 'Harmony' then
		if not isSustainNote then
			noteDatas.mark = direction
		end	
		characterToPlay = 'mark'
		animToPlay = noteDatas.mark
		playing = true
        runTimer('resetAnim', 0.5)
			
		playAnimation(characterToPlay, animToPlay, true)
	end
end

function playAnimation(character, animId, forced)
	animName = animationsList[animId]
	if character == 'mark' then
		playAnim('mark', animName, forced, false, 0)
	end
end

function onStepHit()
	if curStep == 2356 then
		if sunkMark == 'Mark' then
			markTransitionStart()
		end
	end

	if curStep == 2880 then
		if sunkMark == 'Mark' then
			markTransitionEnd()
		end
	end

	if curStep == 3072 then
		if sunkMark == 'Mark' then
			setProperty('markbg.x', 0)
			setProperty("markbgOVERLAY.x", 0)
			setProperty("mark.x", -574)
			markTransitionAltStart()
		end
	end

	if curStep == 3152 then
		setProperty('camHUD.visible', false)
		setProperty('camGame.visible', false)
		setProperty('end.visible', true)
		setProperty('endText.visible', true)
	end
end

function onBeatHit()
	if curBeat % 4 == 0 and playing == false then
		playAnim('mark', 'idle', false, false, 0)
	end
end

function markTransitionStart()
	for i = 4,7 do
		noteTweenX((i - 4)..'XSwitchSpot', (i - 4),  _G['defaultPlayerStrumX'..(i - 4)], 0.75, 'quadInOut')
		noteTweenY((i - 4)..'YSwitchSpot', (i - 4),  _G['defaultPlayerStrumY'..(i - 4)] + 300, 0.75, 'quadInOut')
		noteTweenX(i..'XSwitchSpot', i, _G['defaultOpponentStrumX'..(i - 4)], 0.75, 'quadInOut')
		noteTweenY(i..'YSwitchSpot', i, _G['defaultOpponentStrumY'..(i - 4)], 0.75, 'quadInOut')
	end
	rotationAnim()
	doTweenY('markBgComeDown', 'markbg', 0, 0.75, 'bounceOut')
	doTweenY('markBgOVERLAYComeDown', 'markbgOVERLAY', 0, 0.75, 'bounceOut')
	doTweenY('markComeDown', 'mark', -691, 0.75, 'bounceOut')
	doTweenX('timeBarGoLeft', 'timeBar', getProperty('timeBar.x') - 326, 0.75, 'bounceOut')
	doTweenX('timeTxtGoLeft', 'timeTxt', getProperty('timeTxt.x') - 326, 0.75, 'bounceOut')
	playAnim('boyfriend', 'scared', false, false, 0)
	doTweenY('lixianGoDown', 'boyfriend', getProperty('boyfriend.y') + 950, 0.75, 'bounceOut')
	runTimer('despawnLixian', 0.3)
	doTweenAngle('lixianGoWoosh', 'boyfriend', -90, 0.45, 'linear')
end

function markTransitionEnd()
	for i = 4,7 do
		noteTweenY((i - 4)..'YEnd', (i - 4), defaultOpponentStrumY0, 0.75, 'bounceOut')
		noteTweenX(i..'XSwitchSpotEnd', i, _G['defaultPlayerStrumX'..(i - 4)], 0.75, 'quadInOut')
		noteTweenX((i - 4)..'XSwitchSpotEnd', (i - 4), _G['defaultOpponentStrumX'..(i - 4)], 0.75, 'quadInOut')
	end
	rotationAnim()
	doTweenY('markBgComeDown', 'markbg', -550, 0.75, 'bounceOut')
	doTweenY('markBgOVERLAYComeDown', 'markbgOVERLAY', -550, 0.75, 'bounceOut')
	doTweenY('markComeDown', 'mark', -1241, 0.75, 'bounceOut')
	doTweenX('timeBarGoLeft', 'timeBar', getProperty('timeBar.x') + 326, 0.75, 'bounceOut')
	doTweenX('timeTxtGoLeft', 'timeTxt', getProperty('timeTxt.x') + 326, 0.75, 'bounceOut')
	playAnim('boyfriend', 'scared', false, false, 0)
	doTweenY('lixianGoDown', 'boyfriend', getProperty('boyfriend.y') - 950, 0.75, 'bounceOut')
	setProperty('boyfriend.visible', true)
	setProperty('boyfriend.angle', 0)
end

function markTransitionAltStart()
	for i = 0,3 do
		noteTweenY(i..'Y', i, 345, 0.75, 'bounceOut')
	end
	--switchOffset()
	doTweenY('markBgComeDown', 'markbg', 0, 0.75, 'bounceOut')
	doTweenY('markBgOVERLAYComeDown', 'markbgOVERLAY', 0, 0.75, 'bounceOut')
	doTweenY('markComeDown', 'mark', -691, 0.75, 'bounceOut')
	doTweenX('timeBarGoLeft', 'timeBar', getProperty('timeBar.x') + 322, 0.75, 'bounceOut')
	doTweenX('timeTxtGoLeft', 'timeTxt', getProperty('timeTxt.x') + 322, 0.75, 'bounceOut')
	doTweenY('matpatGoDown', 'dad', getProperty('dad.y') + 950, 0.75, 'bounceOut')
	doTweenAngle('matpatGoWoosh', 'dad', -90, 0.45, 'linear')
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'despawnLixian' then
		setProperty('boyfriend.visible', false)
	end

	if tag == 'resetAnim' then
		playAnim('mark', 'idle', false, false, 0)
		playing = false
    end
end

function onTweenCompleted(tag)
	if tag == '0AngleSwitch' then
		for i = 0,7 do
			setPropertyFromGroup('strumLineNotes', i, 'angle', 0)
		end
	end
end

function rotationAnim()
	for j = 0,7 do
		noteTweenAngle(j..'AngleSwitch', j, 360, 0.75, 'sineOut')
	end
end

--[[function switchOffset()
	removeLuaSprite("mark", true)
	makeAnimatedLuaSprite('mark', 'characters/mark-webcam', 42, -550)
	addAnimationByPrefix('mark', 'idle', 'Idle', 24, false)
	addOffset('mark', 'idle', 0, 260)
	addAnimationByPrefix('mark', 'singLEFT', 'Right', 24, false)
	addOffset('mark', 'singRIGHT', 39.0, 265.0)
	addAnimationByPrefix('mark', 'singDOWN', 'Down', 24, false)
	addOffset('mark', 'singDOWN', -21.0, 174.0)
	addAnimationByPrefix('mark', 'singUP', 'Up', 24, false)
	addOffset('mark', 'singUP', -2.0, 271.0)
	addAnimationByPrefix('mark', 'singRIGHT', 'Left', 24, false)
	addOffset('mark', 'singLEFT', 89.0, 255.0)
	setObjectCamera('mark', 'camHUD')
	playAnim('mark', 'idle', false, false, 0)
	setObjectOrder('mark', getObjectOrder("markbg") + 1)
	scaleObject('mark', 0.6, 0.6, true)
	setProperty('mark.flipX', true)
	addLuaSprite('mark', false)
end--]]