local SlapManager = {}
SlapManager.__index = SlapManager

local function checkForNil(self)
	if self.tool == nil then
		warn("tool is nil")
	end 
end

local function initAnimation(self)
	self.animation = Instance.new("Animation")

	self.animation.AnimationId = self.ANIMATION_ID
end

local function initAnimationTrack(self)
	if self.animationTrack then
		return
	end

	local character: Model = self.tool.Parent
	if character == nil then
		warn("character is nil")
		return 
	end

	local humanoid: Humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid == nil then
		warn("humanoid is nil")
		return
	end

	self.animationTrack = humanoid:LoadAnimation(self.animation)
end

local function playAnimation(self)
	if self.animationTrack == nil then
		warn("animationTrack is nil")
		return 
	end

	self.animationTrack:Stop() -- stop first
	self.animationTrack:Play() -- then play to avoid like bugs
end

local function applyPhysics(self, slapperHrp: Part, targetHrp: Part)
	local baseDirection = slapperHrp.CFrame.LookVector
	local upwardDirection = Vector3.new(0, 5, 0)
	local direction = (baseDirection + upwardDirection).Unit

	local attachment: Attachment = Instance.new("Attachment")
	attachment.Parent = targetHrp

	local vectorForce: VectorForce = Instance.new("VectorForce")
	vectorForce.Attachment0 = attachment
	vectorForce.Force = direction * self.SLAP_FORCE
	vectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
	vectorForce.Parent = targetHrp

	task.delay(0.4, function()
		attachment:Destroy()
		vectorForce:Destroy()
	end)
end

local function playSound(self)
	self.SOUND:Play()
end

local function stunPlayer(self, targetHumanoid)
	targetHumanoid.PlatformStand = true	
	
	task.delay(self.STUN_DURATION, function()
		if targetHumanoid and targetHumanoid.Parent then
			targetHumanoid.PlatformStand = false
		end
	end)
end

local function performSlap(self)
	if self.debounce == true then 
		return
	end

	self.debounce = true

	playAnimation(self)

	local connection = nil
	local hitCharacters = {}

	connection = self.HIT_BOX.Touched:Connect(function(hitPart)
		local targetCharacter: Model = hitPart:FindFirstAncestorOfClass("Model")
		local slapperCharacter: Model = self.tool.Parent

		if targetCharacter == nil or slapperCharacter == nil then return end
		if targetCharacter == slapperCharacter then return end

		if hitCharacters[targetCharacter] == true then return end
		hitCharacters[targetCharacter] = true

		local targetHumanoid: Humanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
		local slapperHumanoid: Humanoid = slapperCharacter:FindFirstChildOfClass("Humanoid")

		if targetHumanoid == nil or slapperHumanoid == nil then return end

		local targetHrp: Part = targetCharacter:FindFirstChild("HumanoidRootPart")
		local slapperHrp: Part = slapperCharacter:FindFirstChild("HumanoidRootPart")

		if targetHrp == nil or slapperHrp == nil then return end

		print(slapperCharacter.Name .. " Slapped " .. targetCharacter.Name)

		applyPhysics(self, slapperHrp, targetHrp)
		
		stunPlayer(self, targetHumanoid)
		
		playSound(self)
	end)

	task.delay(0.4, function()
		if connection then
			connection:Disconnect()
		end
	end)

	task.wait(self.COOLDOWN)

	self.debounce = false
end

local function connectEvents(self)
	self.tool.Equipped:Connect(function()
		initAnimationTrack(self)
	end)	

	self.tool.Activated:Connect(function()
		performSlap(self)
	end)
end

function SlapManager.new(config)
	local self = setmetatable({}, SlapManager)
	
	self.tool = config.tool
	
	checkForNil(self)	
	
	-- constants
	self.ANIMATION_ID = "rbxassetid://98335766261499"
	self.COOLDOWN = 5
	self.HIT_BOX = self.tool:WaitForChild("Hitbox")
	self.SLAP_FORCE = 4000
	self.SOUND = self.tool:WaitForChild("Sound")
	self.STUN_DURATION = 2
	
	self.animation = nil
	self.animationTrack = nil
	self.debounce = false
	
	initAnimation(self)
	connectEvents(self)
	
	return self
end

return SlapManager
