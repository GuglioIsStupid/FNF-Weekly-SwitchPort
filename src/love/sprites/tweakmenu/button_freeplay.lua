return graphics.newSprite(
	graphics.imagePath("tweakmenu/button_freeplay"),
	{
		{x = 3, y = 3, width = 249, height = 91, offsetX = -0, offsetY = -0, offsetWidth = 249, offsetHeight = 91, rotated = false}, -- 1: freeplay hover0
		{x = 258, y = 3, width = 249, height = 91, offsetX = -0, offsetY = -0, offsetWidth = 249, offsetHeight = 91, rotated = false}, -- 2: freeplay0
	},
	{
		["freeplay hover"] = {start = 1, stop = 1, speed = 24, offsetX = 0, offsetY = 0},
		["freeplay"] = {start = 2, stop = 2, speed = 24, offsetX = 0, offsetY = 0},
	},
	"freeplay",
	false
)