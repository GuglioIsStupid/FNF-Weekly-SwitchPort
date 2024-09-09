return graphics.newSprite(
	graphics.imagePath("tweakmenu/button_reset"),
	{
		{x = 5, y = 5, width = 249, height = 91, offsetX = -0, offsetY = -0, offsetWidth = 249, offsetHeight = 91, rotated = false}, -- 1: reset hover0
		{x = 264, y = 5, width = 249, height = 91, offsetX = -0, offsetY = -0, offsetWidth = 249, offsetHeight = 91, rotated = false}, -- 2: reset0
	},
	{
		["reset hover"] = {start = 1, stop = 1, speed = 24, offsetX = 0, offsetY = 0},
		["reset"] = {start = 2, stop = 2, speed = 24, offsetX = 0, offsetY = 0},
	},
	"reset",
	false
)