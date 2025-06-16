-- services
local ServerStorage: ServerStorage = game:GetService("ServerStorage")
local Workspace: Workspace = game:GetService("Workspace")
local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

-- folders
local modulesFolder: Folder = ServerStorage:WaitForChild("Modules")
local spawnersFolder: Folder = Workspace:WaitForChild("Spawners")
local lavaBlockFolder: Folder = Workspace:WaitForChild("LavaBlock")
local remoteEventsFolder: Folder = ReplicatedStorage:WaitForChild("RemoteEvents")

-- modules
local TeleportManager: ModuleScript = require(modulesFolder:WaitForChild("TeleportManager"))
local LavaManager: ModuleScript = require(modulesFolder:WaitForChild("LavaManager"))
local RoundManager: ModuleScript = require(modulesFolder:WaitForChild("RoundManager"))
local RewardManager: ModuleScript = require(modulesFolder:WaitForChild("RewardManager"))
local RandomMapManager: ModuleScript = require(modulesFolder:WaitForChild("RandomMapManager"))

-- random seed
math.randomseed(tick())

-- objects
local teleportManager = TeleportManager.new(
	{
		gameSpawnPoint = spawnersFolder:WaitForChild("GameSpawnPoint"),
		lobbySpawnPoint = spawnersFolder:WaitForChild("LobbySpawnPoint")
	}
)

local lavaManager = LavaManager.new(
	{
		lavaBlock = lavaBlockFolder:WaitForChild("LavaBlock"),
	}
) 

local rewardManager = RewardManager.new()

local randomMapManager = RandomMapManager.new(
	{
		mapsFolder = ServerStorage:WaitForChild("Maps")
	}
)

local roundManager = RoundManager.new(
	{
		teleportManager = teleportManager,
		lavaManager = lavaManager,
		rewardManager = rewardManager,
		randomMapManager = randomMapManager,
		phaseChangeEvent = remoteEventsFolder:WaitForChild("PhaseChangeEvent")
	}
)
