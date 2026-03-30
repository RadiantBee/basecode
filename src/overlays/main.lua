local Overlay = require("src/ui/overlay")
local main = Overlay:new(0, 0, 800, 600)

main.test = "This is main"

local menu = main:add(require("src/overlays/testMenu"))

print(menu.parent.test)

local game = main:add(require("src/overlays/testGame"))
game.isActive = false

return main
