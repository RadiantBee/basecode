local Overlay = require("src/ui/overlay")
local main = Overlay:new(0, 0, 800, 600)

main:add(require("src/overlays/testMenu"))

return main
