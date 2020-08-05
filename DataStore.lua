local datastore = game:GetService("DataStoreService"):GetDataStore("Test") 
local key = "Cookies_"
local gatekeeper = {}
local maindatacopy = setmetatable({
	-- CHANGE HERE
	Currencies = {
		Coins = 0,
		Gems = 0,
	},
	Rebirths = 0,
	TimePlayed = 0,
	Upgrades = {},
	-- CHANGE HERE
},{__call = function(t,n) if t[n] then return t[n] else return t end end})

local function loadPlayer(plr)
	local data = datastore:GetAsync(key..plr.UserId)
	if data then
		return data
	else
		local res,err = pcall(function()
			datastore:UpdateAsync(key..plr.UserId,function()
				return maindatacopy()
			end)
		end)
		if err then
			print("[DataStore] Error:",err)
		end
	end
	data = datastore:GetAsync(key..plr.UserId)
	return data
end
local function disconnectPlayer(plr)
	local res,err = pcall(function()
		datastore:UpdateAsync(key..plr.UserId,function()
			return gatekeeper[plr]
		end)
	end)
	if res then
		gatekeeper[plr] = nil
	else
		print("[DataStore] Error:",err)
	end
end
game.Players.PlayerAdded:Connect(function(plr)
	local plrData = loadPlayer(plr)
	gatekeeper[plr] = plrData
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = plr
	for CurrencyName, CurrencyValue in pairs(plrData.Currencies) do
		local currencyInst = Instance.new("IntValue")
		currencyInst.Name = CurrencyName
		currencyInst.Value = CurrencyValue
		currencyInst.Parent = leaderstats
	end
end)
game.Players.PlayerRemoving:Connect(function(plr)
	disconnectPlayer(plr)
end)
