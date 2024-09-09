return graphics.newSprite(
	graphics.imagePath("tweakmenu/button_right"),
	{
		{x = 5, y = 5, width = 51, height = 169, offsetX = -0, offsetY = -0, offsetWidth = 51, offsetHeight = 169, rotated = false}, -- 1: right hover0
		{x = 5, y = 184, width = 51, height = 169, offsetX = -0, offsetY = -0, offsetWidth = 51, offsetHeight = 169, rotated = false}, -- 2: right0
	},
	{
		["right hover"] = {start = 1, stop = 1, speed = 24, offsetX = 0, offsetY = 0},
		["right"] = {start = 2, stop = 2, speed = 24, offsetX = 0, offsetY = 0},
	},
	"right",
	false
)