local Overlay = require("src/ui/overlay")
local game = Overlay:new(0, 0, 800, 600)

local lab = game:newLabel(100, 100, "hello")

return game
