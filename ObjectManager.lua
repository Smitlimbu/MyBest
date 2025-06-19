local ObjectManager = {}
ObjectManager.__index = ObjectManager

local Players: Players = game:GetService("Players")

local function getRandomObject(self)
	local objects = self.objectsFolder:GetChildren()
	
	if #objects == 0 then
		warn("no objects available to spawn")
		return nil
	end
	
	local randomIndex: number = math.random(1, #objects)
	local randomObject = objects[randomIndex]
	
	return randomObject
end

local function getRandomPosition(self)
	local randomX = math.random(-25, 25)
	local randomPosition = self.spawner.Position + Vector3.new(randomX, 0, 0)
	
	return randomPosition
end

local function playSound(sound)
	sound:Play()
end

local function stunPlayer(self, humanoid)
	if humanoid == nil then return end
	
	humanoid.PlatformStand = true

	task.delay(self.stunDuration, function()
		if humanoid == nil then return end
		
		humanoid.PlatformStand = false
	end)
end

local function spawnObjects(self)
	while true do
		local object = getRandomObject(self)
		if object == nil then
			warn("random object is nil")
			return
		end
		
		local clone = object:Clone()
		local randomPosition = getRandomPosition(self)		
		
		clone:SetPrimaryPartCFrame(CFrame.new(randomPosition))
		clone.Parent = self.spawnedStorage
		
		-- cleanup
		task.delay(self.lifetime, function()
			if clone then
				clone:Destroy()
			end
		end)
		
		-- touched event
		local hitBox = clone:WaitForChild("HitBox")
		local sound = clone:WaitForChild("Sound")
		local touchedPlayers = {}
		
		hitBox.Touched:Connect(function(hit)
			
			-- border check
			if hit.Name == "Destroy" then
				clone:Destroy()
				return
			end
			
			local character: Model = hit:FindFirstAncestorOfClass("Model")
			if not character then return end
			
			local player = Players:GetPlayerFromCharacter(character)
			if not player then return end
				
			if touchedPlayers[player.UserId] == true then return end
			touchedPlayers[player.UserId] = true

			local humanoid: Humanoid = character:FindFirstChild("Humanoid")
			if not humanoid then return end
			
			stunPlayer(self, humanoid)
			playSound(sound)
		end)
		
		task.wait(self.spawnInterval)
	end
end

local function validateConfig(config)
	assert(config.objectsFolder, "config parameter 'objectsFolder' is missing")
	assert(config.spawner, "config parameter 'spawner' is missing")
	assert(config.spawnedStorage, "config parameter 'spawnedStorage' is missing")
	assert(config.spawnInterval, "config parameter 'spawnInterval' is missing")
end

function ObjectManager.new(config)
	validateConfig(config)
	
	local self = setmetatable({}, ObjectManager)
	
	self.objectsFolder = config.objectsFolder
	self.spawner = config.spawner
	self.spawnedStorage = config.spawnedStorage
	self.spawnInterval = config.spawnInterval
	
	self.lifetime = 10
	self.stunDuration = 1
	
	task.spawn(function()
		spawnObjects(self)
	end)
	
	return self
end

return ObjectManager
