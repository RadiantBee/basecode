-- Importing ui element classes
local uiElement = require("src/ui/uiElement")
local Button = require("src/ui/button")
local ProgressBar = require("src/ui/progressBar")
local Entry = require("src/ui/entry")
local Slider = require("src/ui/slider")
local Label = require("src/ui/label")
local utils = require("src/utils")

local Overlay = setmetatable({}, uiElement)
Overlay.__index = Overlay

Overlay.new = function(self, x, y, width, height, isActive)
	local obj = {}
	assert(x, "Overlay x is nil")
	assert(y, "Overlay y is nil")
	assert(width, "Overlay width is nil")
	assert(height, "Overlay height is nil")
	obj.ox = x
	obj.oy = y
	obj.x = x
	obj.y = y
	obj.width = width
	obj.height = height
	obj.isActive = isActive or true
	obj.bgColor = { 0, 0, 0 }
	obj.borderColor = { 1, 1, 1 }
	obj.isMouseInside = false

	obj.elements = {}

	obj.mousepressWasProcessed = false
	obj.mousereleaseWasProcessed = false
	obj.keypressWasProcessed = false

	setmetatable(obj, self)
	return obj
end

Overlay.configureHeader = function(self, title, isMovable, isHidable, isClosable)
	--self.
end

Overlay.newButton = function(self, x, y, width, height, text, func, funcArgs)
	local button = Button:new(x, y, width, height, text, func, funcArgs)
	utils.addToList(self.elements, button)
	return button
end

Overlay.newSlider = function(self, x, y, width, height, maxValue, bWidth, bHeight, value, showText, color)
	local slider = Slider:new(x, y, width, height, maxValue, bWidth, bHeight, value, showText, color)
	utils.addToList(self.elements, slider)
	return slider
end

Overlay.newProgressBar = function(self, x, y, width, height, maxValue, value, showText, color)
	local progressBar = ProgressBar:new(x, y, width, height, maxValue, value, showText, color)
	utils.addToList(self.elements, progressBar)
	return progressBar
end
Overlay.newLabel = function(self, x, y, text)
	local label = Label:new(text, x, y)
	utils.addToList(self.elements, label)
	return label
end

Overlay.newEntry = function(self, x, y, width, height, onEnterFunc, onEnterFuncArgs)
	local entry = Entry:new(x, y, width, height, onEnterFunc, onEnterFuncArgs)
	utils.addToList(self.elements, entry)
	return entry
end

Overlay.newElement = function(self)
	local elem = uiElement:new()
	utils.addToList(self.elements, elem)
	return elem
end

Overlay.newOverlay = function(self, x, y, width, height, isActive)
	local ov = Overlay:new(x, y, width, height, isActive)
	utils.addToList(self.elements, ov)
	return ov
end

Overlay.isInside = function(self, x, y)
	if x > self.x and y > self.y then
		if x < self.x + self.width and y < self.y + self.height then
			return true
		end
	end
	return false
end

Overlay.mousepressed = function(self, x, y, button)
	if not self:isInside(x, y) then
		return false
	end
	self.mousepressWasProcessed = false
	for i = #self.elements, 1, -1 do
		if self.mousepressWasProcessed then
			break
		end
		self.mousepressWasProcessed = self.elements[i]:mousepressed(x, y, button)
	end
	self.mousepressWasProcessed = true
	return self.mousepressWasProcessed
end
Overlay.mousereleased = function(self, x, y, button)
	self.mousereleaseWasProcessed = false
	for i = #self.elements, 1, -1 do
		if self.mousereleaseWasProcessed then
			break
		end
		self.mousereleaseWasProcessed = self.elements[i]:mousereleased(x, y, button)
	end
	return self.mousereleaseWasProcessed
end
Overlay.keypressed = function(self, key)
	self.keypressWasProcessed = false
	if not self.isActive then
		return self.keypressWasProcessed
	end

	for i = #self.elements, 1, -1 do
		if self.keypressWasProcessed then
			break
		end
		self.keypressWasProcessed = self.elements[i]:keypressed(key)
	end
	return self.keypressWasProcessed
end
Overlay.update = function(self, dt, mouseX, mouseY)
	if not self.isActive then
		return
	end
	for i = #self.elements, 1, -1 do
		self.elements[i]:update(dt, mouseX, mouseY)
	end
end
Overlay.draw = function(self, x, y)
	self.x = self.ox + x
	self.y = self.oy + y
	if not self.isActive then
		return
	end
	love.graphics.setColor(self.bgColor)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	love.graphics.setColor(self.borderColor)
	love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
	love.graphics.setColor(1, 1, 1)

	for i = 1, #self.elements, 1 do -- NOTE: might be unreliable or even unsafe
		self.elements[i]:draw(self.x, self.y)
	end
	--[[
	for i = #self.elements, 1, -1 do
		self.elements[i]:draw()
	end
	--]]
end

return Overlay
--[[
function EmptyDiaolgWindow(x, y, width, height)
	local emptyDiaolgWindow = {}
	emptyDiaolgWindow.x = x or 0
	emptyDiaolgWindow.y = y or 0
	emptyDiaolgWindow.width = width or 200
	emptyDiaolgWindow.height = height or 100
	emptyDiaolgWindow.title = "No Title"
	emptyDiaolgWindow.titleHeight = 20

	emptyDiaolgWindow.active = false

	emptyDiaolgWindow.exitButton = Button("X", function(self)
		self.active = false
	end, emptyDiaolgWindow, nil, nil, 20, 20)

	emptyDiaolgWindow.toggleActive = function(self)
		self.active = not self.active
	end

	emptyDiaolgWindow.onClick = function(self, mouseX, mouseY)
		if self.active then
			self.exitButton:onClick(mouseX, mouseY)
		end
	end

	emptyDiaolgWindow.checkMouseMove = function(self, mouseX, mouseY, mouseState)
		if self.active then
			if (mouseX > self.x) and (mouseX < self.x + self.width - self.exitButton.width) then
				if (mouseY > self.y) and (mouseY < self.y + self.titleHeight) then
					if mouseState == 1 then
						self.x = mouseX - self.width / 2
						self.y = mouseY - self.titleHeight / 2
					end
				end
			end
		end
	end

	emptyDiaolgWindow.bodyDraw = function(self, mouseX, mouseY)
		-- IMPORTANT: don't forget to check if popup is active before rendering
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("fill", self.x, self.y, self.width, self.height + self.titleHeight)
		love.graphics.setColor(1, 1, 1)
		love.graphics.rectangle("line", self.x, self.y, self.width, self.height + self.titleHeight)

		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("fill", self.x, self.y, self.width, self.titleHeight)
		love.graphics.setColor(1, 1, 1)
		love.graphics.rectangle("line", self.x, self.y, self.width, self.titleHeight)

		love.graphics.print(self.title, self.x + 3, self.y + 3)

		self.exitButton:draw(self.x + self.width - self.exitButton.width, self.y, mouseX, mouseY, 5, 3)
	end
	return emptyDiaolgWindow
end

function CreateInfoWindow(x, y, width, info)
	local infoWindow = EmptyDiaolgWindow(x, y, width, #info * 15 + 10)
	infoWindow.title = "Info"
	infoWindow.info = ""
	for _, infoLine in pairs(info) do
		infoWindow.info = infoWindow.info .. infoLine .. "\n"
	end
	infoWindow.draw = function(self, mouseX, mouseY)
		if not self.active then
			return
		end
		self:bodyDraw(mouseX, mouseY)
		love.graphics.print(self.info, self.x + 5, self.y + self.titleHeight + 5)
	end
	return infoWindow
end

function CreateDialogWindowNewTask(x, y, width, height, taskList)
	local newTaskDialogWindow = EmptyDiaolgWindow(x, y, width, height)
	newTaskDialogWindow.height = height or 180
	newTaskDialogWindow.title = "Create new task"

	newTaskDialogWindow.saveButton = Button("Create", function(args)
		args[2]:addTask({
			args[1].entryTitle.text,
			args[1].entryDescription1.text,
			args[1].entryDescription2.text,
			args[1].entryDescription3.text,
			args[1].entryDescription4.text,
			args[1].entryType.text,
		})
	end, { newTaskDialogWindow, taskList }, nil, nil, 50, 20)

	newTaskDialogWindow.entryDescription4 = entry(nil, nil, nil, nil, function(dialog)
		dialog.entryDescription4.active = false
		dialog.saveButton:activate()
	end, newTaskDialogWindow)

	newTaskDialogWindow.entryDescription3 = entry(nil, nil, nil, nil, function(dialog)
		dialog.entryDescription3.active = false
		dialog.entryDescription4.active = true
	end, newTaskDialogWindow)

	newTaskDialogWindow.entryDescription2 = entry(nil, nil, nil, nil, function(dialog)
		dialog.entryDescription2.active = false
		dialog.entryDescription3.active = true
	end, newTaskDialogWindow)

	newTaskDialogWindow.entryDescription1 = entry(nil, nil, nil, nil, function(dialog)
		dialog.entryDescription1.active = false
		dialog.entryDescription2.active = true
	end, newTaskDialogWindow)

	newTaskDialogWindow.entryType = entry(nil, nil, nil, nil, function(dialog)
		dialog.entryType.active = false
		dialog.entryDescription1.active = true
	end, newTaskDialogWindow)

	newTaskDialogWindow.entryTitle = entry(nil, nil, nil, nil, function(dialog)
		dialog.entryTitle.active = false
		dialog.entryType.active = true
	end, newTaskDialogWindow)

	newTaskDialogWindow.entryClear = function(self)
		self.entryTitle.text = ""
		self.entryType.text = ""
		self.entryDescription1.text = ""
		self.entryDescription2.text = ""
		self.entryDescription3.text = ""
		self.entryDescription4.text = ""
	end

	newTaskDialogWindow.exitButton.func = function(self)
		self:entryClear()
		self.active = false
	end

	newTaskDialogWindow.onClick = function(self, mouseX, mouseY)
		if self.active then
			self.exitButton:onClick(mouseX, mouseY)
			self.saveButton:onClick(mouseX, mouseY)

			self.entryTitle:onClick(mouseX, mouseY)
			self.entryDescription1:onClick(mouseX, mouseY)
			self.entryDescription2:onClick(mouseX, mouseY)
			self.entryDescription3:onClick(mouseX, mouseY)
			self.entryDescription4:onClick(mouseX, mouseY)
			self.entryType:onClick(mouseX, mouseY)
		end
	end

	newTaskDialogWindow.onKeyboardPress = function(self, key)
		if self.active then
			self.entryDescription4:onKeyboardPress(key)
			self.entryDescription3:onKeyboardPress(key)
			self.entryDescription2:onKeyboardPress(key)
			self.entryDescription1:onKeyboardPress(key)
			self.entryType:onKeyboardPress(key)
			self.entryTitle:onKeyboardPress(key)
		end
	end

	newTaskDialogWindow.draw = function(self, mouseX, mouseY)
		self:bodyDraw(mouseX, mouseY)
		if self.active then
			love.graphics.print("Enter title:", self.x + 10, self.y + self.titleHeight + 12)
			love.graphics.print("Enter type:", self.x + 10, self.y + self.titleHeight + 37)
			love.graphics.print("Enter desc:", self.x + 10, self.y + self.titleHeight + 62)

			self.entryTitle:draw(self.x + 90, self.y + self.titleHeight + 10, 2, 2)
			self.entryType:draw(self.x + 90, self.y + self.titleHeight + 35, 2, 2)
			self.entryDescription1:draw(self.x + 90, self.y + self.titleHeight + 60, 2, 2)
			self.entryDescription2:draw(self.x + 90, self.y + self.titleHeight + 80, 2, 2)
			self.entryDescription3:draw(self.x + 90, self.y + self.titleHeight + 100, 2, 2)
			self.entryDescription4:draw(self.x + 90, self.y + self.titleHeight + 120, 2, 2)

			self.saveButton:draw(
				self.x + self.width / 2 - self.saveButton.width / 2,
				self.y + self.height + self.titleHeight - self.saveButton.height - 10,
				mouseX,
				mouseY,
				5,
				3
			)
		end
	end

	return newTaskDialogWindow
end

function CreateDialogEditTask(x, y, width, height, task, taskList)
	local editDialog = CreateDialogWindowNewTask(x, y, width, height, taskList)
	editDialog.title = "Edit task"
	editDialog.saveButton.text = "Save"
	editDialog.task = task
	editDialog.saveButton.funcArgs = { editDialog, taskList }
	editDialog.saveButton.func = function(args)
		args[1].task.title = args[1].entryTitle.text
		args[1].task.description1 = args[1].entryDescription1.text
		args[1].task.description2 = args[1].entryDescription2.text
		args[1].task.description3 = args[1].entryDescription3.text
		args[1].task.description4 = args[1].entryDescription4.text
		args[1].task.type = args[1].entryType.text
		args[2]:saveToFile()
	end
	return editDialog
end
--]]
