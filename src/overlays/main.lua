local Overlay = require("src/ui/overlay")
local main = Overlay:new(0, 0, 800, 600)

main.menu = main:add(require("src/overlays/testMenu"))

main.game = main:add(require("src/overlays/testGame"))
main.game.isActive = false

return main
