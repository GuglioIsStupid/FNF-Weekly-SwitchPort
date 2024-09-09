return graphics.newSprite(
	graphics.imagePath("tweakmenu/button_play"),
	{
		{x = 5, y = 5, width = 281, height = 281, offsetX = -0, offsetY = -0, offsetWidth = 281, offsetHeight = 281, rotated = false}, -- 1: play hover0
		{x = 5, y = 296, width = 281, height = 281, offsetX = -0, offsetY = -0, offsetWidth = 281, offsetHeight = 281, rotated = false}, -- 2: play0
	},
	{
		["play hover"] = {start = 1, stop = 1, speed = 24, offsetX = 0, offsetY = 0},
		["play"] = {start = 2, stop = 2, speed = 24, offsetX = 0, offsetY = 0},
	},
	"play hover",
	false
)