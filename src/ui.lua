local Overlay = require("src/ui/overlay")
local utils = require("src/utils")
local ui = {}

ui.mouseIdle = love.mouse.newCursor("img/cursor.png", 2, 2)
ui.mouseActive = love.mouse.newCursor("img/cursorClick.png", 2, 2)

ui.overlays = {}
ui.mousepressWasProcessed = false
ui.mousereleaseWasProcessed = false
ui.keypressWasProcessed = false

ui.mouseX = 0
ui.mouseY = 0

ui.add = function(self, overlay)
	utils.addToList(self.overlays, overlay)
end

ui.load = function(self)
	love.mouse.setCursor(self.mouseIdle)
end
ui.mousepressed = function(self, x, y, button)
	love.mouse.setCursor(self.mouseActive)
	self.mousepressWasProcessed = false
	for i = #self.overlays, 1, -1 do
		if self.mousepressWasProcessed then
			break
		end
		self.mousepressWasProcessed = self.overlays[i]:mousepressed(x, y, button)
	end
	return self.mousepressWasProcessed
end
ui.mousereleased = function(self, x, y, button)
	love.mouse.setCursor(self.mouseIdle)
	self.mousereleaseWasProcessed = false
	for i = #self.overlays, 1, -1 do
		if self.mousereleaseWasProcessed then
			break
		end
		self.mousereleaseWasProcessed = self.overlays[i]:mousereleased(x, y, button)
	end
	return self.mousereleaseWasProcessed
end
ui.keypressed = function(self, key)
	self.keypressWasProcessed = false
	for i = #self.overlays, 1, -1 do
		if self.keypressWasProcessed then
			break
		end
		self.keypressWasProcessed = self.overlays[i]:keypressed(key)
	end
	return self.keypressWasProcessed
end
ui.update = function(self, dt)
	self.mouseX = love.mouse.getX()
	self.mouseY = love.mouse.getY()
	for i = #self.overlays, 1, -1 do
		self.overlays[i]:update(dt, self.mouseX, self.mouseY)
	end
end
ui.draw = function(self)
	for i = #self.overlays, 1, -1 do
		self.overlays[i]:draw(0, 0)
	end
end

return ui
