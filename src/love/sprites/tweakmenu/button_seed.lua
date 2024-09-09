return graphics.newSprite(
	graphics.imagePath("tweakmenu/button_seed"),
	{
		{x = 5, y = 5, width = 249, height = 91, offsetX = -0, offsetY = -0, offsetWidth = 249, offsetHeight = 91, rotated = false}, -- 1: seed hover0
		{x = 264, y = 5, width = 249, height = 91, offsetX = -0, offsetY = -0, offsetWidth = 249, offsetHeight = 91, rotated = false}, -- 2: seed0
	},
	{
		["seed hover"] = {start = 1, stop = 1, speed = 24, offsetX = 0, offsetY = 0},
		["seed"] = {start = 2, stop = 2, speed = 24, offsetX = 0, offsetY = 0},
	},
	"seed",
	false
)