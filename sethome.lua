PLUGIN.Title = "Sethome"
PLUGIN.Description = "Allows you to set your home [WIP]"
PLUGIN.Version = V(0, 0, 1)
PLUGIN.Author = "Wub"

function PLUGIN:Init()
	command.AddChatCommand("sethome", self.Object, "funcSetHome")
	command.AddChatCommand("home", self.Object, "funcHome")
	--print("Sethome plugin loaded!")
	self:LoadDefaultConfig()
    self:LoadDatabase()
end

function PLUGIN:LoadDefaultConfig()
	self.Config.Settings = self.Config.Settings or {}
	self.Config.Settings.HomeLimit = self.Config.Settings.HomeLimit or 5
	self.Config.Settings.TeleDelay = self.Config.Settings.TeleDelay or 20
	self.Config.Settings.TeleCool = self.Config.Settings.TeleCool or 20
	
	self.Config.Chat 				= self.Config.Chat or {}
	self.Config.Chat.ListHomes 		= self.Config.Chat.ListHomes or "Current homes: {count}"
	self.Config.Chat.ZoneCheckFail 	= self.Config.Chat.ZoneCheckFail or "You must be above a foundation to set a home."
	self.Config.Chat.NameTaken 		= self.Config.Chat.NameTaken or "Home name is already in use"
end

local Database = "sethome"
local Data

function PLUGIN:LoadDatabase()
	local data = datafile.GetDataTable(Database)
	Data = data or {}
end

function PLUGIN:SaveDatabase()
	datafile.SaveDataTable(Database)
end

--[[
local function playerSearch(playerName, checkJoined)
	local allPlayers
	local playerList = global.BasePlayer.activePlayerList:GetEnumerator()
	while playerList:MoveNext() do
		if playerList.Current then
			local player = playerList.Current
			local steamID = rust.UserIDFromPlayer(player)
			if player.DisplayName == player then
				table.insert(player)
				return #allPlayers, allPlayers
			end
			local found, _ = string.find(player.displayName:lower(), playerName:lower(), 1, true)
			if found then
				table.insert(allPlayers, player)
			end
		end
	end
end
]]--

function PLUGIN:GetPlayerData(playerSteamID, playerName, addNewEntry)
    local playerData = Data[playerSteamID]
    if not playerData and addNewEntry then
        playerData = {}
        playerData.SteamID = playerSteamID
        playerData.Name = playerName
        --playerData.Homes = {}
        playerData.HomeList = {}
        Data[playerSteamID] = playerData
        self:SaveDatabase()
    end
    return playerData
end

local function checkPositionStat(player)


end

function PLUGIN:funcSetHome(player, _, args)
	if not player then return end
	rust.SendChatMessage(player, "Home set!", " " )
	local playerID = rust.UserIDFromPlayer(player)
	local playerName = player.displayName
	local playerData = self:GetPlayerData(playerID, playerName, true)
	
	local playerPos = player.transform.position
	playerData.Homes = playerPos
	Data[playerID] = playerData
	self:SaveDatabase()
	
	playerData = self:GetPlayerData(playerID, playerName, false)
	playerPos = playerData.Homes
	--print(playerPos, " ")
end 

function PLUGIN:funcHome(player, _, args)
	if not player then return end
	local playerID = rust.UserIDFromPlayer(player)
	local playerName = player.displayName
	local playerData = self:GetPlayerData(playerID, playerName, false)
	
	if playerData.Homes then
		print(playerData.Homes)
		
		
		local home = playerData.Homes
		player.Teleport(player, home)
	else
		print("Should be empty message: ")
		print(playerData.Homes)
		rust.SendChatMessage(player, "Home not set", " ")
		return
	end
end
