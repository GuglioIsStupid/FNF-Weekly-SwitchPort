return graphics.newSprite(
	graphics.imagePath("tweakmenu/button_options"),
	{
		{x = 5, y = 5, width = 242, height = 242, offsetX = -0, offsetY = -0, offsetWidth = 242, offsetHeight = 242, rotated = false}, -- 1: options hover0
		{x = 5, y = 257, width = 242, height = 242, offsetX = -0, offsetY = -0, offsetWidth = 242, offsetHeight = 242, rotated = false}, -- 2: options0
	},
	{
		["options hover"] = {start = 1, stop = 1, speed = 24, offsetX = 0, offsetY = 0},
		["options"] = {start = 2, stop = 2, speed = 24, offsetX = 0, offsetY = 0},
	},
	"options hover",
	false
)