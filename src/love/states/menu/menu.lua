local isMatpat

return {
	enter = function(self, previous)
		beatHandler.setBPM(102)
		if not music:isPlaying() then
			music:play()
		end
		function tweenMenu()
			if logo.y == 100 then 
				Timer.tween(1, logo, {y = -50, alpha = 1}, "out-expo")
			end
		end

		changingMenu = false
		isMatpat = love.math.random(0, 200) == 0
		if isMatpat then
			logo = love.filesystem.load("sprites/menu/matpat.lua")()
		else
			logo = love.filesystem.load("sprites/tweakmenu/logoBumpin.lua")()
		end

		logo.y = 100
		logo.alpha = 0.1

		tweenMenu()

		songNum = 0

		if firstStartup then
			graphics.setFade(0) 
			graphics.fadeIn(0.5) 
		else graphics:fadeInWipe(0.6) end

		firstStartup = false
	end,

	update = function(self, dt)
		logo:update(dt)

		beatHandler.update(dt)

		if beatHandler.onBeat() then 
			if logo then logo:animate("anim", false) end
		end

		if not graphics.isFading() then
			if input:pressed("confirm") then
				if not changingMenu then
					audio.playSound(confirmSound)
					changingMenu = true
					graphics:fadeOutWipe(0.7, function()
						Gamestate.switch(menuSelect)
						status.setLoading(false)							
					end)
				end
			elseif input:pressed("back") then
				audio.playSound(selectSound)
				love.event.quit()
			end
		end
	end,

	draw = function(self)
		love.graphics.push()
			love.graphics.translate(graphics.getWidth() / 2, graphics.getHeight() / 2)

			love.graphics.push()
				logo:draw()
			love.graphics.pop()

		love.graphics.pop()
	end,

	leave = function(self)
		logo = nil

		Timer.clear()
	end
}
