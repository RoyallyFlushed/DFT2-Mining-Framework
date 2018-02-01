


----------------------------------------------------------------------
-- Scripted by 8BB

local assets = workspace.Bricks

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PartForwarder = Instance.new("RemoteEvent",ReplicatedStorage)
PartForwarder.Name = "PartForwarder"
local CashAdder = Instance.new("RemoteEvent",ReplicatedStorage)
CashAdder.Name = "CashAdder"
local RarityForwarder = Instance.new("RemoteEvent",ReplicatedStorage)
RarityForwarder.Name = "RarityForwarder"
script.Settings.Parent = ReplicatedStorage
local settings = require(ReplicatedStorage.Settings)

local BrickPositions = Instance.new("Folder",script)
BrickPositions.Name = "BrickPositions"
local OreAssets = script.Ores

local top_limit = assets["StartBlock"].Position.Y


function Mine(brick)
	-- Functions that remove block, save block pos and add blocks to bottom/top/sides
	local bpos = brick.CFrame
	Instance.new("CFrameValue",BrickPositions).Value = bpos
	brick:Remove()
	CreateBlocks(bpos)
end

function CreateBlocks(bpos)
	-- Function that create blocks to bottom/top/sides
	local Colours = {"Dark stone grey","Dirt brown","Black","Really black"}
	local leftpos = bpos - Vector3.new(6,0,0)
	local rightpos = bpos + Vector3.new(6,0,0)
	local uppos = bpos + Vector3.new(0,6,0)
	local downpos = bpos - Vector3.new(0,6,0)
	local forwardpos = bpos + Vector3.new(0,0,6)
	local backwardpos = bpos - Vector3.new(0,0,6)
	local pos_raw = {leftpos,rightpos,uppos,downpos,forwardpos,backwardpos}
	--[[---------------------
	print("------------------------------------\npos_raw:")
	for i = 1, #pos_raw do
		print(pos_raw[i])
	end
	---------------------]]
	local pos_ref = {} 
	
	local function CheckPositions(i)
		-- New function made when updating to CFrameValue rather than string values
		for _,v in pairs(BrickPositions:GetChildren()) do
			if v.Value == pos_raw[i] then
				return false
			end
		end
		return true
	end	
	
	local function CheckBlocks(i)
		for _,v in pairs(assets:GetChildren()) do -- Checks to make sure that there isn't a block at this pos
			if v.CFrame == pos_raw[i] then
				return false -- If a block is detected then it will return false and break the iteration
			end
		end
		return true
	end
	for i = 1, #pos_raw do
		if CheckPositions(i) and CheckBlocks(i) then -- Passes only if there isn't a block in the way or there isn't a pre-mined pos
			table.insert(pos_ref, pos_raw[i]) -- Adds new block position to the ref table after making sure it's safe to do so.
		end
	end
	for i = 1, #pos_ref do
		-- Creates blocks
		local newbrick = RNG():Clone()
		newbrick.Parent = assets
		newbrick.CFrame = pos_ref[i]
		if newbrick.Position.Y >= top_limit then
			newbrick:Destroy()
		end
		if (newbrick.Position.Y <= top_limit-155) and (newbrick.Position.Y > top_limit-471) and newbrick.Name == "Stone" then
			newbrick.BrickColor = BrickColor.new(Colours[1])
		elseif (newbrick.Position.Y <= top_limit-471) and (newbrick.Position.Y > top_limit-729) and newbrick.Name == "Stone" then
			newbrick.BrickColor = BrickColor.new(Colours[2])
		elseif (newbrick.Position.Y <= top_limit-729) and (newbrick.Position.Y > top_limit-1185) and newbrick.Name == "Stone" then
			newbrick.BrickColor = BrickColor.new(Colours[3])
		elseif newbrick.Position.Y <= (top_limit-1185) and newbrick.Name == "Stone" then
			newbrick.BrickColor = BrickColor.new(Colours[4])
		end
	end
	
	
	
	--[[---------------------
	print("------------------------------------\npos_ref:")
	for i = 1, #pos_ref do
		print(pos_ref[i])
	end
	---------------------]]
end




function RNG()
	-- Make RNG that sorts out ore rarities. Make return with the brick type used & store ores in folder
	local OreCount = 0
	for i,v in pairs(OreAssets:GetChildren()) do
		for _,ore in pairs(v:GetChildren()) do
			OreCount = OreCount + 1
		end
	end
	local RNG1 = math.random(0,OreCount*10^6)
	
	local Normal = ((OreCount*10^6)/2)+(OreCount/2) -- 10.5M:10.5M + 0.280M
	local Common = (Normal/4)+Normal -- 13.125M:2.625M
	local Uncommon = (Normal/8)+Common -- 14.5625M:1.3125M
	local Rare = (Normal/100)+Uncommon -- 14.6675M:0.105M
	local Legendary = (Normal/200)+Rare --14.7200M:0.0525M
	
	if (RNG1 > Normal) and RNG1 <= Common then
		return OreAssets.Common:GetChildren()[math.random(1,3)]
	elseif (RNG1 > Common) and RNG1 <= Uncommon then
		return OreAssets.Uncommon:GetChildren()[math.random(1,3)]
	elseif (RNG1 > Uncommon) and RNG1 <= Rare then
		return OreAssets.Rare:GetChildren()[math.random(1,4)]
	elseif (RNG1 > Rare) and RNG1 <= Legendary then
		return OreAssets.Legendary:GetChildren()[math.random(1,3)]
	else
		return OreAssets.Normal.Stone
	end
end

local function ReceivedPart(player, brick)
	wait(.3) -- Allows some time for cash GUI to finish
	Mine(brick)
end

PartForwarder.OnServerEvent:connect(ReceivedPart)

newcash = 0
local function ReceivedCash(player, cash)
	-- Sends cash off to game.ServerStorage.PlayerMoney
	newcash = newcash + cash	
	game.ServerStorage.PlayerMoney[player.Name].Value = newcash
end

CashAdder.OnServerEvent:connect(ReceivedCash)

local BadgeGroup = settings["Badges"]

local NormalID = BadgeGroup["Stone_Badge"]
local CommonID = BadgeGroup["Common_Badge"]
local UncommonID = BadgeGroup["Uncommon_Badge"]
local RareID = BadgeGroup["Rare_Badge"]
local LegendaryID = BadgeGroup["Legendary_Badge"]

local BadgeService = game:GetService("BadgeService")

local function ReceivedRarity(player, rarity, brickName)
	if brickName == "StartBlock" then return 
	elseif rarity == "Normal" then
		if not BadgeService:UserHasBadge(player.userId, NormalID) then
			BadgeService:AwardBadge(player.userId, NormalID)
		end
	elseif rarity == "Common" then
		if not BadgeService:UserHasBadge(player.userId, CommonID) then
			BadgeService:AwardBadge(player.userId, CommonID)
		end
	elseif rarity == "Uncommon" then
		if not BadgeService:UserHasBadge(player.userId, UncommonID) then
			BadgeService:AwardBadge(player.userId, UncommonID)
		end
	elseif rarity == "Rare" then
		if not BadgeService:UserHasBadge(player.userId, RareID) then
			BadgeService:AwardBadge(player.userId, RareID)
		end
	elseif rarity == "Legendary" then
		if not BadgeService:UserHasBadge(player.userId, LegendaryID) then
			BadgeService:AwardBadge(player.userId, LegendaryID)
		end
	end
end

RarityForwarder.OnServerEvent:connect(ReceivedRarity)

Time = 0
MineTime = settings["Mine_Reset_Time"] -- Time in minutes

function StopWatch()
	repeat 
		wait(1)
		Time = Time + 1
	until Time == MineTime*60
end

StopWatch()

while wait() do
	if Time == MineTime*60 then
		Time = 0
		for i,v in pairs(game.Players:GetChildren()) do
			v:LoadCharacter()
		end
		wait(1)
		for i,v in pairs(workspace.Bricks:GetChildren()) do
			if v.Name ~= "StartBlock" then
				v:Destroy()
			end
		end
		for i,v in pairs(BrickPositions:GetChildren()) do
			if v.Value.Y == top_limit then
				local newbrick = OreAssets.Normal.Stone:Clone()
				newbrick.Parent = assets
				newbrick.CFrame = v.Value
				newbrick.Name = "StartBlock"
			end
		end
		BrickPositions:ClearAllChildren()
		StopWatch()
	end
end
