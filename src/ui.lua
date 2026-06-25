local ui = {}

ui.elementsPath = "src/ui"
ui.filePattern = "(%a+)(%.lua)"

ui.elements = {}

ui.init = function() end

ui.loadElements = function(self)
	local files = love.filesystem.getDirectoryItems(self.elementsPath)
	local found
	for _, file in ipairs(files) do
		found = string.match(file, self.filePattern)
		--table.insert(luaModules, found)
		if found then
			self.elements[found] = require(self.elementsPath .. "/" .. found)
		end
	end
end

return ui
