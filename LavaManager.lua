local LavaManager = {}
LavaManager.__index = LavaManager

-- services
local TweenService: TweenService = game:GetService("TweenService")
local Players: Players = game:GetService("Players")

-- local functions
local function validateConfig(config)
	assert(config.lavaBlock, "config parameter 'lavaBlock' is missing")
end

local function setAttribute(player: Player)
	player:SetAttribute("survived", false)
end

local function killPlayer(hit)
	local character: Model = hit:FindFirstAncestorOfClass("Model")
	if character == nil then return end
	
	local humanoid: Humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid == nil then return end
	
	local player: Player = Players:GetPlayerFromCharacter(character)
	if player == nil then return end
	
	setAttribute(player)
	humanoid.Health = 0
end

local function connectEvents(self)
	self.lavaBlock.Touched:Connect(function(hit)
		killPlayer(hit)
	end)
end

local function toggleCanTouch(self, value: boolean)
	self.lavaBlock.CanTouch = value
end

local function playSound(self)
	if self.SOUND then
		self.SOUND:Play()
	end
end

local function stopSound(self)
	if self.SOUND then
		self.SOUND:Stop()
	end
end

local function changePosition(self, lavaRiseDuration: number)
	local startPos = self.lavaBlock.Position
	local targetPos = Vector3.new(startPos.X, startPos.Y + self.LAVA_RISE_HEIGHT, startPos.Z)

	local tweenInfo = TweenInfo.new(
		lavaRiseDuration,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.Out
	)

	local tween = TweenService:Create(self.lavaBlock, tweenInfo, {Position = targetPos})

	tween:Play()
	tween.Completed:Wait()
end

local function resetPosition(self)
	self.lavaBlock.Position = Vector3.new(self.lavaBlock.Position.X, self.LAVA_ORIGINAL_Y, self.lavaBlock.Position.Z)
end

function LavaManager.new(config)
	local self = setmetatable({}, LavaManager)
	
	self.lavaBlock = config.lavaBlock
	
	-- constants
	self.LAVA_RISE_HEIGHT = 135
	self.LAVA_ORIGINAL_Y = self.lavaBlock.Position.Y
	self.SOUND = self.lavaBlock:WaitForChild("Sound")
	
	checkNil(self)
	connectEvents(self)	
	
	return self
end

function LavaManager:raiseLava(lavaRiseDuration: number)	
	if lavaRiseDuration == nil then
		warn("lavaRiseDuration is nil!")
		return
	end
	
	toggleCanTouch(self, true)	
	playSound(self)
	changePosition(self, lavaRiseDuration)
end

function LavaManager:resetLava()
	toggleCanTouch(self, false)	
	stopSound(self)	
	resetPosition(self)
end

return LavaManager
