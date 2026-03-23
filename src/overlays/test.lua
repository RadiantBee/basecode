local Overlay = require("src/ui/overlay")
-- As objects are created, they are added to the array and processed from the END
local ov = Overlay:new(0, 0, 800, 600)
-- Layer 1
local testButton = ov:newButton(100, 100, 100, 50, "click")
local textTest = ov:newLabel(100, 50)
-- Layer 2
local popUp = ov:newOverlay(150, 90, 200, 200)
local popEntry = popUp:newEntry(15, 40, 50, 20)

local popProgressBar = popUp:newProgressBar(15, 15, 100, 20, 5)
popProgressBar.showText = true

local testSlider = popUp:newSlider(15, 70, 100, 20, 100)
testSlider.showText = true

local tst = 0

popEntry.onKeyPress = function(self)
	popProgressBar:setValue(self.text:len())
end

testButton.func = function()
	tst = tst + 1
	print("yay")
end

textTest.dynamicText = function(self)
	self.text = tst
end

return ov
