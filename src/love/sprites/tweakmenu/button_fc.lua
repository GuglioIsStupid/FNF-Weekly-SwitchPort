return graphics.newSprite(
	graphics.imagePath("tweakmenu/button_fc"),
	{
		{x = 5, y = 5, width = 249, height = 91, offsetX = -0, offsetY = -0, offsetWidth = 249, offsetHeight = 91, rotated = false}, -- 1: off0
		{x = 264, y = 5, width = 249, height = 91, offsetX = -0, offsetY = -0, offsetWidth = 249, offsetHeight = 91, rotated = false}, -- 2: off hover0
		{x = 523, y = 5, width = 249, height = 91, offsetX = -0, offsetY = -0, offsetWidth = 249, offsetHeight = 91, rotated = false}, -- 3: on0
		{x = 782, y = 5, width = 249, height = 91, offsetX = -0, offsetY = -0, offsetWidth = 249, offsetHeight = 91, rotated = false}, -- 4: on hover0
	},
	{
		["off"] = {start = 1, stop = 1, speed = 24, offsetX = 0, offsetY = 0},
		["off hover"] = {start = 2, stop = 2, speed = 24, offsetX = 0, offsetY = 0},
		["on"] = {start = 3, stop = 3, speed = 24, offsetX = 0, offsetY = 0},
		["on hover"] = {start = 4, stop = 4, speed = 24, offsetX = 0, offsetY = 0},
	},
	"off",
	false
)