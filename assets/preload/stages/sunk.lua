function onCreate()
	makeLuaSprite('bg', 'sinking', -750, -470)
	scaleObject('bg', 1.2, 1.2, true)
	addLuaSprite('bg', false)

	if difficultyName == 'Mark' then
		precacheImage('characters/mark-webcam')
		makeAnimationList()

		makeLuaSprite('markbg', 'office', 730, -550)
		setProperty('markbg.flipX', true)
		setObjectCamera('markbg', 'camHUD')
		scaleObject('markbg', 0.55, 0.45, true)
		addLuaSprite('markbg', false)

		makeAnimatedLuaSprite('mark', 'characters/mark-webcam', 750, -550)
		addAnimationByPrefix('mark', 'idle', 'Idle', 24, false)
		addOffset('mark', 'idle', 0, 260)
		addAnimationByPrefix('mark', 'singRIGHT', 'Right', 24, false)
		addOffset('mark', 'singRIGHT', -41.0, 255.0)
		addAnimationByPrefix('mark', 'singDOWN', 'Down', 24, false)
		addOffset('mark', 'singDOWN', 65.0, 174.0)
		addAnimationByPrefix('mark', 'singUP', 'Up', 24, false)
		addOffset('mark', 'singUP', -30.0, 271.0)
		addAnimationByPrefix('mark', 'singLEFT', 'Left', 24, false)
		addOffset('mark', 'singLEFT', 39.0, 265.0)
		setObjectCamera('mark', 'camHUD')
		playAnim('mark', 'idle', false, false, 0)
		setObjectOrder('mark', 2)
		scaleObject('mark', 0.6, 0.6, true)
		addLuaSprite('mark', false)
	end
end

function onCreatePost()
	triggerEvent("Camera Follow Pos", '197.5', '171')
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
		if difficultyName == 'Mark' then
			markTransitionStart()
		end
	end

	if curStep == 2880 then
		if difficultyName == 'Mark' then
			markTransitionEnd()
		end
	end

	if curStep == 3072 then
		if difficultyName == 'Mark' then
			setProperty('markbg.x', 0)
			setProperty('mark.x', 45)
			setProperty('mark.flipX', true)
			markTransitionAltStart()
		end
	end
end

function onBeatHit()
	if curBeat % 4 == 0 then
		playAnim('mark', 'idle', false, false, 0)
	end
end

function markTransitionStart()
	for i = 4,7 do
		noteTweenY(i..'Y', i, 345, 0.75, 'bounceOut')
	end
	doTweenY('markBgComeDown', 'markbg', 0, 0.75, 'bounceOut')
	doTweenY('markComeDown', 'mark', 111, 0.75, 'bounceOut')
	doTweenX('timeBarGoLeft', 'timeBar', getProperty('timeBar.x') - 326, 0.75, 'bounceOut')
	doTweenX('timeTxtGoLeft', 'timeTxt', getProperty('timeTxt.x') - 326, 0.75, 'bounceOut')
	playAnim('boyfriend', 'scared', false, false, 0)
	doTweenY('lixianGoDown', 'boyfriend', getProperty('boyfriend.y') + 950, 0.75, 'bounceOut')
	runTimer('despawnLixian', 0.3)
	doTweenAngle('lixianGoWoosh', 'boyfriend', -90, 0.45, 'linear')
end

function markTransitionEnd()
	for i = 0,3 do
		noteTweenY(i..'YEnd', i, defaultOpponentStrumY0, 0.75, 'bounceOut')
	end
	doTweenY('markBgComeDown', 'markbg', -550, 0.75, 'bounceOut')
	doTweenY('markComeDown', 'mark', -550, 0.75, 'bounceOut')
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
	doTweenY('markBgComeDown', 'markbg', 0, 0.75, 'bounceOut')
	doTweenY('markComeDown', 'mark', 111, 0.75, 'bounceOut')
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
    end
end

function onTweenCompleted(tag)
	if tag == '4Y' then
		for i = 4,7 do
			noteTweenX((i - 4)..'XSwitchSpot', (i - 4), getPropertyFromGroup('strumLineNotes', i, 'x'), 0.75, 'quadInOut')
			noteTweenY((i - 4)..'YSwitchSpot', (i - 4), getPropertyFromGroup('strumLineNotes', i, 'y'), 0.75, 'quadInOut')
			noteTweenX(i..'XSwitchSpot', i, _G['defaultOpponentStrumX'..(i - 4)], 0.75, 'quadInOut')
			noteTweenY(i..'YSwitchSpot', i, _G['defaultPlayerStrumY'..(i - 4)], 0.75, 'quadInOut')
		end
	end

	if tag == '0YEnd' then
		for i = 4,7 do
			setPropertyFromGroup('strumLineNotes', i, 'x', _G['defaultPlayerStrumX'..(i - 4)])
			setPropertyFromGroup('strumLineNotes', (i - 4), 'x', _G['defaultOpponentStrumX'..(i - 4)])
		end
	end
end