local RewardManager = {}
RewardManager.__index = RewardManager

-- services
local Players: Players = game:GetService("Players") 

local function getStats(player: Player, statName: string)
	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then return nil end

	local stat = leaderstats:FindFirstChild(statName)

	return stat
end

function RewardManager.new()
	local self = setmetatable({}, RewardManager)
	
	return self
end

function RewardManager:rewardPlayers()
	for _, player in ipairs(Players:GetPlayers()) do
		local survivals = getStats(player, "Survivals")	
		
		if player:GetAttribute("survived") == true and survivals then
			survivals.Value += 1
		end
	end
end

return RewardManager
