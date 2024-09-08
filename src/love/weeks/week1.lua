local stage = stages["house"]
CAPTION_FONT = love.graphics.newFont("fonts/BRLNSDB.ttf", 50)
return {
	enter = function(self, from, songNum, songAppend, _songExt)
		stage = stages["house"]
		weeks:enter()

		stage:enter()

		song = songNum
		difficulty = songAppend
		songExt = _songExt

		self:load()
	end,

	load = function(self)
		stage:load()
		weeks:load()

		if song == 4 then
			inst = love.audio.newSource("songs/visiosubrideophobia/Inst.ogg", "stream")
			voicesBF = love.audio.newSource("songs/visiosubrideophobia/Voices.ogg", "stream")
		elseif song == 3 then
			inst = love.audio.newSource("songs/goo/Inst.ogg", "stream")
			voicesBF = love.audio.newSource("songs/goo/Voices.ogg", "stream")
		elseif song == 2 then
			inst = love.audio.newSource("songs/teaking/Inst.ogg", "stream")
			voicesBF = love.audio.newSource("songs/teaking/Voices.ogg", "stream")
		else
			inst = love.audio.newSource("songs/boss-tweaks-in-brasil/Inst.ogg", "stream")
			voicesBF = love.audio.newSource("songs/boss-tweaks-in-brasil/Voices.ogg", "stream")
		end

		self:initUI()

		weeks:setupCountdown()

		camera.lockedMoving = true
	end,

	initUI = function(self)
		weeks:initUI()
		if song == 4 then
			weeks:legacyGenerateNotes("data/songs/visiosubrideophobia/visiosubrideophobia.json")
			weeks:generatePsychEvents("data/songs/visiosubrideophobia/events.json")
		elseif song == 3 then
			weeks:legacyGenerateNotes("data/songs/goo/goo.json")
			weeks:generatePsychEvents("data/songs/goo/events.json")
		elseif song == 2 then
			weeks:legacyGenerateNotes("data/songs/teaking/teaking.json")
			weeks:generatePsychEvents("data/songs/teaking/events.json")
		else
			weeks:legacyGenerateNotes("data/songs/boss-tweaks-in-brasil/boss-tweaks-in-brasil.json")

			enemy.visible = false

			camera.lockedMoving = true
			camera.x = camera.x + 400
		end
	end,

	update = function(self, dt)
		weeks:update(dt)
		stage:update(dt)

		weeks:checkSongOver()

		if beatHandler.onBeat() then
			local beat = beatHandler.getBeat()

			if song == 1 then
				if beat == 191 then
					camera.lockedMoving = false
				elseif beat == 192 then
					enemy.visible = true
					enemyIcon.visible = true
				end
			end
		end

		weeks:updateUI(dt)
	end,

	onEvent = function(self, ...)
		stage:onEvent(...)
	end,

	draw = function(self)
		love.graphics.push()
			love.graphics.translate(graphics.getWidth() / 2, graphics.getHeight() / 2)
			love.graphics.scale(camera.zoom, camera.zoom)

			stage:draw()
		love.graphics.pop()

		love.graphics.push()
			love.graphics.translate(graphics.getWidth()/2, graphics.getHeight()/2)
			stage.br:draw()
			stage.port:draw()
			stage.jumpscare:draw()
		love.graphics.pop()

		stage.bar.x = stage.bar:getWidth()/2
		stage.bar.y = stage.bar:getHeight()/2
		stage.bar:draw()
		stage.bar.x = push:getWidth() - stage.bar:getWidth()/2
		stage.bar:draw()

		stage.tik:draw()

		love.graphics.push()
			love.graphics.translate(graphics.getWidth()/2, graphics.getHeight()/2)
			stage.pee:draw()
			stage.bee:draw()
		love.graphics.pop()

		if stage.curCaption ~= "" then
			local lastFont = love.graphics.getFont()
			love.graphics.setFont(CAPTION_FONT)
			uitextf(stage.curCaption, 0, push:getHeight()/2-15, graphics.getWidth(), "center")
			love.graphics.setFont(lastFont)
		end

		weeks:drawUI()
	end,

	leave = function(self)
		stage:leave()

		enemy = nil
		boyfriend = nil
		girlfriend = nil

		graphics.clearCache()

		weeks:leave()
	end
}
