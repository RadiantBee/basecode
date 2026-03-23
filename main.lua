local ui = require("src/ui")
ui:add(require("src/overlays/test"))

function love.load()
	print("[*] Welcome to " .. love.window.getTitle() .. "!")
	print("[*] Client version: 0.0.1")
	print("[*] Made by MaxPan")
	ui:load()
end

function love.mousepressed(x, y, button)
	ui:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	ui:mousereleased(x, y, button)
end

function love.keypressed(key)
	ui:keypressed(key)
end

function love.update(dt)
	ui:update(dt)
end

function love.draw()
	ui:draw()
end
