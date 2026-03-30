local Overlay = require("src/ui/overlay")
local menu = Overlay:new(0, 0, 800, 600)

local playButton = menu:newButton(100, 100, 100, 50, "Play")

playButton.func = function()
	menu.parent.game.isActive = true
	menu.isActive = false
end
return menu
