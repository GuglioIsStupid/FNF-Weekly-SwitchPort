return graphics.newSprite(
	graphics.imagePath("tweakmenu/button_left"),
	{
		{x = 5, y = 5, width = 51, height = 169, offsetX = -0, offsetY = -0, offsetWidth = 51, offsetHeight = 169, rotated = false}, -- 1: left hover0
		{x = 5, y = 184, width = 51, height = 169, offsetX = -0, offsetY = -0, offsetWidth = 51, offsetHeight = 169, rotated = false}, -- 2: left0
	},
	{
		["left hover"] = {start = 1, stop = 1, speed = 24, offsetX = 0, offsetY = 0},
		["left"] = {start = 2, stop = 2, speed = 24, offsetX = 0, offsetY = 0},
	},
	"left hover",
	false
)