--[[----------------------------------------------------------------------------
This file is part of Friday Night Funkin' Rewritten

Copyright (C) 2021  HTV04

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
------------------------------------------------------------------------------]]

local stageBack, stageFront, curtains

return {
	enter = function(self, from, songNum, songAppend, _songExt)
		weeks:enter()

		stages["house"]:enter()

		song = songNum
		difficulty = songAppend
		songExt = _songExt

		self:load()
	end,

	load = function(self)
		weeks:load()
		stages["house"]:load()

		if song == 3 then
			inst = love.audio.newSource("songs/dadbattle/Inst" .. songExt .. ".ogg", "stream")
			voicesBF = love.audio.newSource("songs/dadbattle/Voices-bf" .. songExt .. ".ogg", "stream")
		elseif song == 2 then
			inst = love.audio.newSource("songs/fresh/Inst" .. songExt .. ".ogg", "stream")
			voicesBF = love.audio.newSource("songs/fresh/Voices-bf" .. songExt .. ".ogg", "stream")
		else
			inst = love.audio.newSource("songs/boss-tweaks-in-brasil/Inst.ogg", "stream")
			voicesBF = love.audio.newSource("songs/boss-tweaks-in-brasil/Voices.ogg", "stream")
		end

		self:initUI()

		weeks:setupCountdown()

		enemyIcon.visible = false

		camera.lockedMoving = true
	end,

	initUI = function(self)
		weeks:initUI()
		if song == 3 then
			weeks:generateNotes("data/songs/dadbattle/dadbattle-chart" .. songExt .. ".json", "data/songs/dadbattle/dadbattle-metadata" .. songExt .. ".json", difficulty)
		elseif song == 2 then
			weeks:generateNotes("data/songs/fresh/fresh-chart" .. songExt .. ".json", "data/songs/fresh/fresh-metadata" .. songExt .. ".json", difficulty)
		else
			weeks:legacyGenerateNotes("data/songs/boss-tweaks-in-brasil/boss-tweaks-in-brasil.json")

			enemy.visible = false
		end
	end,

	update = function(self, dt)
		weeks:update(dt)
		stages["house"]:update(dt)

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
		stages["house"]:onEvent(...)
	end,

	draw = function(self)
		love.graphics.push()
			love.graphics.translate(graphics.getWidth() / 2, graphics.getHeight() / 2)
			love.graphics.scale(camera.zoom, camera.zoom)

			stages["house"]:draw()
		love.graphics.pop()

		weeks:drawUI()
	end,

	leave = function(self)
		stages["house"]:leave()

		enemy = nil
		boyfriend = nil
		girlfriend = nil

		graphics.clearCache()

		weeks:leave()
	end
}
