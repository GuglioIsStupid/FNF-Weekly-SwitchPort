return graphics.newSprite(
	graphics.imagePath("tweakmenu/button_more"),
	{
		{x = 5, y = 5, width = 249, height = 91, offsetX = -0, offsetY = -0, offsetWidth = 249, offsetHeight = 91, rotated = false}, -- 1: more hover0
		{x = 264, y = 5, width = 249, height = 91, offsetX = -0, offsetY = -0, offsetWidth = 249, offsetHeight = 91, rotated = false}, -- 2: more0
	},
	{
		["more hover"] = {start = 1, stop = 1, speed = 24, offsetX = 0, offsetY = 0},
		["more"] = {start = 2, stop = 2, speed = 24, offsetX = 0, offsetY = 0},
	},
	"more",
	false
)