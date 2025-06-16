 local TeleportManager = {}
TeleportManager.__index = TeleportManager

-- services
local Players: Players = game:GetService("Players")

local function checkForNil(self)
	if self.gameSpawnPoint == nil then
		warn("gameSpawnPoint is nil")
	end
	
	if self.lobbySpawnPoint == nil then
		warn("lobbySpawnPoint is nil")
	end
end

local function getRandomSpawnPosition(spawnPoint: Part)
	local randomX = math.random(-10, 10)
	local randomZ = math.random(-10, 10)
	local spawnHeight = 3

	return spawnPoint.CFrame + Vector3.new(randomX, spawnHeight, randomZ)
end

local function setAttribute(value)
	for _, player in ipairs(Players:GetPlayers()) do
		player:SetAttribute("survived", value)
	end
end

local function teleportAll(spawnPoint: Part)
	for _, player in ipairs(Players:GetPlayers()) do
		local character: Model = player.Character
		if character == nil then continue end

		local rootPart: Part = character:FindFirstChild("HumanoidRootPart")
		if rootPart == nil then continue end

		rootPart.CFrame = getRandomSpawnPosition(spawnPoint)
	end
end

function TeleportManager.new(config)
	local self = setmetatable({}, TeleportManager)
	
	self.gameSpawnPoint = config.gameSpawnPoint
	self.lobbySpawnPoint = config.lobbySpawnPoint
	
	checkForNil(self)
	
	return self
end

-- class methods
function TeleportManager:teleportAllToGame()
	teleportAll(self.gameSpawnPoint)
	setAttribute(true)
end

function TeleportManager:teleportAllToLobby()
	teleportAll(self.lobbySpawnPoint)
	setAttribute(false)
end

return TeleportManager
