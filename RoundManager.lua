local RoundManager = {}
RoundManager.__index = RoundManager

-- services
local Players: Players = game:GetService("Players")

function RoundManager.new(config)
	local self = setmetatable({}, RoundManager)
	
	self.teleportManager = config.teleportManager
	self.lavaManager = config.lavaManager
	self.rewardManager = config.rewardManager
	self.randomMapManager = config.randomMapManager
	self.phaseChangeEvent = config.phaseChangeEvent
	
	-- constants
	self.INTERMISSION_DURATION = 10
	self.PREPARATION_DURATION = 15
	self.LAVA_RISE_DURATION = 50
	
	self:start()
	
	return self
end

function RoundManager:start()
	task.wait(1) -- wait 1 sec for clients to load
	
	while true do
		self.phaseChangeEvent:FireAllClients("intermission", self.INTERMISSION_DURATION)
		self.randomMapManager:unloadMap()
		self.randomMapManager:loadMap()
		task.wait(self.INTERMISSION_DURATION)
		
		self.teleportManager:teleportAllToGame()
		
		self.phaseChangeEvent:FireAllClients("preparation", self.PREPARATION_DURATION)
		task.wait(self.PREPARATION_DURATION)
		
		self.phaseChangeEvent:FireAllClients("lava rising", self.LAVA_RISE_DURATION)
		self.lavaManager:raiseLava(self.LAVA_RISE_DURATION)
		
		self.rewardManager:rewardPlayers()
		
		self.teleportManager:teleportAllToLobby()
		
		self.lavaManager:resetLava()
	end
end

return RoundManager
