return graphics.newSprite(
	graphics.imagePath("tweakmenu/button_back"),
	{
		{x = 5, y = 5, width = 249, height = 91, offsetX = -0, offsetY = -0, offsetWidth = 249, offsetHeight = 91, rotated = false}, -- 1: back hover
		{x = 264, y = 5, width = 249, height = 91, offsetX = -0, offsetY = -0, offsetWidth = 249, offsetHeight = 91, rotated = false}, -- 2: back
	},
	{
		["back hover"] = {start = 1, stop = 1, speed = 24, offsetX = 0, offsetY = 0},
		["back"] = {start = 2, stop = 2, speed = 24, offsetX = 0, offsetY = 0},
	},
	"back",
	false
)