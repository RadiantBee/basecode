local Overlay = require("src/ui/overlay")
local menu = Overlay:new(0, 0, 800, 600)

local button = menu:newButton(100, 100, 100, 50, "main")

return menu
