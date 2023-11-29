local startStar = 365

function onCreate()
    precacheSound('boop')

    if string.lower(songName) ~= 'iron-lung' then
        makeLuaSprite("pizzaIconP1", 'newOurpleHUD/pizza', 0, 0)
        setObjectCamera("pizzaIconP1", 'camHUD')       
        setObjectOrder("pizzaIconP1", getObjectOrder("healthBar") - 1)
        setProperty("pizzaIconP1.x", string.lower(songName) == 'iron-lung' and 262 or 839)
        setProperty("pizzaIconP1.y", string.lower(songName) == 'iron-lung' and 5 or downscroll and 20 or 540)
        setProperty("pizzaIconP1.antialiasing", false)
        addLuaSprite("pizzaIconP1", false)
    
        makeLuaSprite("pizzaIconP2", 'newOurpleHUD/pizza', 236, downscroll and 20 or 540)
        setObjectCamera("pizzaIconP2", 'camHUD')
        setObjectOrder("pizzaIconP2", getObjectOrder("healthBarBG") - 1)
        setProperty("pizzaIconP2.antialiasing", false)
        addLuaSprite("pizzaIconP2", false)

        makeLuaSprite('shaggersSign', 'newOurpleHUD/shaggersSign', -535, 160)
        setObjectCamera('shaggersSign', 'camOther')
        scaleObject("shaggersSign", 0.7, 0.7)
        setProperty('shaggersSign.antialiasing', false)
        addLuaSprite('shaggersSign', false)
    
        makeLuaText('shag', 'by\nShaggers', 300, 0, 185)
        setObjectCamera('shag', 'camOther')
        setTextAlignment('shag', 'left')
        setTextFont('shag', 'ourple.ttf')
        setTextSize('shag', 48)
        addLuaText('shag', false)
    end
end

function onCreatePost()
    setObjectOrder("iconP1", getObjectOrder("healthBar") + 1)
    if string.lower(songName) == 'iron-lung' then
        startStar = 387
    end
    for i = 1, 5 do
        makeAnimatedLuaSprite('star'..i, 'newOurpleHUD/star', startStar, downscroll and -30 or 600)
        addAnimationByPrefix('star'..i, 'flash', 'star', 35, false)
        addAnimationByIndices('star'..i, 'static', 'star', '35', 35, false)
        setObjectCamera('star'..i, 'camHUD')
        setProperty('star'..i..'.antialiasing', false)
        setObjectOrder('star'..i, getObjectOrder('healthBarBG') + 1)
        addLuaSprite('star'..i, false)
        startStar = startStar + 87
    end
end

function onUpdatePost(elapsed)
    if luaSpriteExists('shaggersSign') and getPropertyFromClass('flixel.FlxG', 'mouse.visible') == true then
        if mouseOverLapsSprite('shag', 'other') then
            setTextColor('shag', '3fe780')
            if mouseClicked() then
                os.execute('start "" "https://youtube.com/@Shaggers"')
            end
        else
            setTextColor('shag', 'FFFFFF')
        end
    else
        setTextColor('shag', 'FFFFFF')
    end

    if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.SEVEN') or getPropertyFromClass('flixel.FlxG', 'keys.justPressed.EIGHT') or getPropertyFromClass('flixel.FlxG', 'keys.justPressed.NUMPADMULTIPLY')then
        playSound('boop', 1, 'boop')
    end
end

function onUpdate(elapsed)
    if luaSpriteExists("shag") then
        setProperty('shag.x', getProperty('shaggersSign.x') + 103)
        setProperty('shag.y', getProperty('shaggersSign.y') + 52)
    end
end

function onTweenCompleted(tag)
    if tag == 'shagsignbye' then
        removeLuaSprite('shaggersSign', true)
        removeLuaText('shag', true)
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'byebye' then
        if string.lower(songName) ~= 'iron-lung' then
            setPropertyFromClass('flixel.FlxG', 'mouse.visible', false)
        end
        doTweenX('shagsignbye', 'shaggersSign', -535, crochet / 250, 'quadIn')
    end
end

function onSongStart()
    showCredits()
end

function onBeatHit()
    if curBeat % 2 == 0 then
        if misses == 0 then
            for i = 1, 5 do
                playAnim("star"..i, "flash", false, false, 0)
            end
        end
    end
end

function noteMiss(membersIndex, noteData, noteType, isSustainNote)
    if misses == 1 then
        for i = 1, 5 do
            playAnim("star"..i, "static", true, false, 0)
        end
    end
end

function onRecalculateRating()
    if misses > 0 then
        for i = 1, 5 do
            doTweenColor('starChange'..i, 'star'..i, 'FFFFFF', 0.01, 'linear')
        end
        if (getProperty('ratingPercent') * 100) >= 90 then
            for i = 1, 5 do
                doTweenColor('starChange'..i, 'star'..i, 'FFFF00', 0.01, 'linear')
            end
        elseif (getProperty('ratingPercent') * 100) >= 85 then
            for i = 1, 4 do
                doTweenColor('starChange'..i, 'star'..i, 'FFFF00', 0.01, 'linear')
            end
        elseif (getProperty('ratingPercent') * 100) >= 80 then
            for i = 1, 3 do
                doTweenColor('starChange'..i, 'star'..i, 'FFFF00', 0.01, 'linear')
            end
        elseif (getProperty('ratingPercent') * 100) >= 75 then
            for i = 1, 2 do
                doTweenColor('starChange'..i, 'star'..i, 'FFFF00', 0.01, 'linear')
            end
        elseif (getProperty('ratingPercent') * 100) >= 70 then
            doTweenColor('starChange1', 'star1', 'FFFF00', 0.01, 'linear')
        end
    end
end

function showCredits()
    doTweenX('shagsign', 'shaggersSign', 0, crochet / 300, 'bounceOut')
    if string.lower(songName) ~= 'iron-lung' then
        setPropertyFromClass('flixel.FlxG', 'mouse.visible', true)
    end
    runTimer('byebye', 4)
end

function onDestroy()
    setPropertyFromClass('flixel.FlxG', 'mouse.visible', false)
end

function posOverlaps(
    x1, y1, w1, h1, --r1,
    x2, y2, w2, h2 --r2
)
    return (
        x1 + w1 >= x2 and x1 < x2 + w2 and
        y1 + h1 >= y2 and y1 < y2 + h2
    )
end

function mouseOverLapsSprite(spr, cam)
    local mouseX, mouseY = getMouseX(cam or "other"), getMouseY(cam or "other")
    
    local x, y, w, h = getProperty(spr .. ".x"), getProperty(spr .. ".y"), getProperty(spr .. ".width"), getProperty(spr .. ".height")
    
    return posOverlaps(
        mouseX, mouseY, 1, 1,
        x, y, w, h
    )
end