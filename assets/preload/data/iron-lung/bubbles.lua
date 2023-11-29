local particles = {}

local xOffset = 175
local xPos = 1560
local mult = 1

local endTime = 2550

function onStepHit()
	if curStep == 2549 then
		if youGood() then
			endTime = 2575
		end
	end

	if curStep == endTime then
		xOffset = 1280
		xPos = 0
		mult = 2
	end
end

function bubble(x, y)
	local sprite = 'bubbles'..(#particles + 1)
	
	makeLuaSprite(sprite, 'lung/BubbleTexture', getRandomFloat(x, x + xOffset), y)
	setProperty(sprite..'.antialiasing', false)
	setProperty(sprite..'.alpha', 0.7)
	addLuaSprite(sprite)
	
	setObjectOrder(sprite, getObjectOrder('frontdoor'))

	if (curStep >= endTime) or (inGameOver == true) then
		setObjectCamera(sprite, 'camOther')
	end
	
	local orScale = getRandomFloat(0.1, 0.8)
	setProperty(sprite..'.scale.x', orScale)
	setProperty(sprite..'.scale.y', orScale)
	
	setProperty(sprite..'.velocity.x', getRandomFloat(-100, 100))
	setProperty(sprite..'.velocity.y', getRandomFloat(-350, -250))
	setProperty(sprite..'.acceleration.x', getRandomFloat((-100 * mult), (100 * mult)))
	setProperty(sprite..'.acceleration.y', (-120 * mult))

	particles[#particles + 1] = {name = sprite, lifeTime = getRandomFloat(3, 4.5), decay = getRandomFloat(1, 0.7), scale = orScale}
end

function onUpdate(elapsed)
	for i, j in pairs(particles) do
		if luaSpriteExists(particles[i].name) then
            particles[i].lifeTime = particles[i].lifeTime - elapsed
			if particles[i].lifeTime <= 0 then
				particles[i].lifeTime = 0
				setProperty(particles[i].name..'.alpha', getProperty(particles[i].name..'.alpha') - (particles[i].decay * elapsed))
				if getProperty(particles[i].name..'.alpha') > 0 then
					setProperty(particles[i].name..'.scale.x', particles[i].scale * getProperty(particles[i].name..'.alpha'))
					setProperty(particles[i].name..'.scale.y', particles[i].scale * getProperty(particles[i].name..'.alpha'))
				end					
			end

				--remove the particle
			if getProperty(particles[i].name..'.alpha') <= 0 then
				removeLuaSprite(particles[i].name, true)
				particles[i] = nil
			end
		end			
	end

	if (curStep < 390) or (curStep >= endTime and curStep < 2820) then
		bubble(xPos, 1500)
	end
end
