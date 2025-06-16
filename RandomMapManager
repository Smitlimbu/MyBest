local RandomMapManager = {}
RandomMapManager.__index = RandomMapManager

-- services
local Workspace: Workspace = game:GetService("Workspace")

local function checkForNil(self)
	if self.mapsFolder == nil then
		warn("mapsFolder is nil")
	end
end

local function selectRandomMap(self)
	local randomIndex = math.random(1, #self.maps)
	self.currentMap = self.maps[randomIndex]
end


function RandomMapManager.new(config)
	local self = setmetatable({}, RandomMapManager)
	
	self.mapsFolder = config.mapsFolder
	
	self.maps = self.mapsFolder:GetChildren()
	self.currentMap = nil
	
	checkForNil(self)
	
	return self
end

function RandomMapManager:loadMap()
	selectRandomMap(self)
	
	if self.currentMap then
		self.currentMap.Parent = Workspace
	end	
end

function RandomMapManager:unloadMap()
	if self.currentMap then
		self.currentMap.Parent = self.mapsFolder
	end
end

return RandomMapManager
