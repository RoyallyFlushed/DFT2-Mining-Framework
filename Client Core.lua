
-- Scripted by 8BB
local Enabled = false
local SelectionBoxColours = {}
local timee = 0.1


local RepStore = game:GetService("ReplicatedStorage")
local PartForwarder = RepStore:WaitForChild("PartForwarder")
local CashAdder = RepStore:WaitForChild("CashAdder")
local RF = RepStore:WaitForChild("RarityForwarder")
local settings = require(game.ReplicatedStorage:WaitForChild("Settings"))
local assets = workspace.Bricks
local Activated = false
local buttonup = true
local Cash = 0

local Minetime = {}
local CashPayout = {}
local TeleportCooldownTime = 0
local SettingsLOADED = false


script.Parent.Equipped:connect(function(mouse)
	mouse.Button1Down:connect(function()
		buttonup = false
		if buttonup then return end
		if not Enabled then
			Activated = true
			Enabled = true
			if mouse.Target ~= nil then
				if mouse.Target.Parent.Name == "Bricks" then
					brick = mouse.Target
					
					mouse.Button1Up:connect(function()
						buttonup = true
						if brick:FindFirstChild("SelectionBox") then
							brick.SelectionBox:Destroy()
							minetime = 0
						end
					end)
					local SelectionBox = Instance.new("SelectionBox",brick)
					SelectionBox.Color3 = BrickColor.new(CheckBlockStatus(brick)).Color
					SelectionBox.Adornee = brick
										
					
					MakeGUI(mouse, brick)
					local gui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("MiningStatus")
					
					mouse.Move:connect(function()
						local newgui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("MiningStatus")
						if newgui ~= nil then
							newgui:FindFirstChild("Frame").Position = UDim2.new(0,mouse.X+0.25,0,mouse.Y)
						end
					end)
					rarity = BlockStatusNonColour(brick)	
					CashPayout = settings["Cash_Payout"]
					Minetime = settings["Mining_Time"]
					if rarity == "Normal" then
						minetime = Minetime[rarity]
						Cash = CashPayout[rarity]
					elseif rarity == "Common" then
						minetime = Minetime[rarity]
						Cash = CashPayout[rarity]
					elseif rarity == "Uncommon" then
						minetime = Minetime[rarity]
						Cash = CashPayout[rarity]
					elseif rarity == "Rare" then
						minetime = Minetime[rarity]
						Cash = CashPayout[rarity]
					elseif rarity == "Legendary" then
						minetime = Minetime[rarity]
						Cash = CashPayout[rarity]
					elseif brick.Name == "StartBlock" then
						minetime = Minetime["Normal"]
						Cash = CashPayout["Normal"]
					end
					
					if not gui == false then
						for i = 1, 9, 1 do
							if not buttonup then
								gui.Frame.Bar.Size = gui.Frame.Bar.Size + UDim2.new(0.1,0,0,0)
								wait(minetime/100)
							elseif buttonup then
								break
							end
						end
					end
					gui:Destroy()
					local sent = false
					if not buttonup then
						-- Section forwards deets to server
						CashAdder:FireServer(Cash)
						PartForwarder:FireServer(brick)
						RF:FireServer(rarity, brick.Name)
						if rarity ~= "Normal" and brick.Name ~= "StartBlock" then
							local sound = script.Sound
							sound.SoundId = "rbxassetid://"..settings["Ore_Mined_SoundID"]
							sound:Play()
						end
						sent = true
					end
					if gui ~= nil and sent then
						MakeCashGUI(mouse, Cash)
					end
					Cash = 0
				end
			end
			wait(timee)
			Enabled = false
			Activated = false
		end
	end)
end)


game.Players.LocalPlayer:GetMouse().Button1Up:connect(function()
	wait(1)
	for i,v in pairs(assets:GetChildren()) do
		if v:FindFirstChild("SelectionBox") then
			v.SelectionBox:Destroy()
		end
	end
end)

script.Parent.Equipped:connect(function(mouse)
	mouse.Move:connect(function()
		if mouse.Target ~= nil then
			if mouse.Target.Parent == assets then
				for i,v in pairs(assets:GetChildren()) do
					if v:FindFirstChild("SelectionBox") and v ~= brick then
						v.SelectionBox:Destroy()
					end
				end
				if not Activated then
					local SelectionBox = Instance.new("SelectionBox",mouse.Target)
					SelectionBox.Color3 = BrickColor.new(CheckBlockStatus(mouse.Target)).Color
					SelectionBox.Adornee = mouse.Target
				end
			end
		end
	end)
end)

script.Parent.Unequipped:connect(function()
	wait(1)
	for i,v in pairs(assets:GetChildren()) do
		if v:FindFirstChild("SelectionBox") then
			v.SelectionBox:Destroy()
		end
	end
end)

local SelectionBoxColours = settings["Selection_Box_Colours"]
-- Below used to return colour from table for selection box colours
function CheckBlockStatus(brick)
	for i,Rarity in pairs(script.Ores:GetChildren()) do
		for _,block in pairs(Rarity:GetChildren()) do
			if block.Name == brick.Name then
				return SelectionBoxColours[Rarity.Name]
			elseif brick.Name == "StartBlock" then
				return SelectionBoxColours["Normal"]
			end
		end
	end
end

-- Below used to return rarity from table for mining speeds
function BlockStatusNonColour(brick)
	for i,Rarity in pairs(script.Ores:GetChildren()) do
		for _,block in pairs(Rarity:GetChildren()) do
			if block.Name == brick.Name then
				return Rarity.Name
			end
		end
	end
end

function MakeGUI(mouse, brick)
	local gui = Instance.new("ScreenGui",game.Players.LocalPlayer.PlayerGui)
	gui.Name = "MiningStatus"
	local frame = Instance.new("Frame",gui)
	frame.BackgroundColor3 = Color3.new(0,0,0)
	frame.BackgroundTransparency = 0.3
	frame.Size = UDim2.new(0.1,0,0.03,0)
	frame.Position = UDim2.new(0,mouse.X+0.25,0,mouse.Y)
	local bar = Instance.new("TextLabel",frame)
	bar.Name = "Bar"
	bar.BackgroundColor3 = Color3.new(25/255,1,167/255)
	bar.Position = UDim2.new(0.05,0,0.15,0)
	bar.Size = UDim2.new(0,0,0.6,0)
	bar.ZIndex = 2
	bar.BackgroundTransparency = 0
	bar.BorderSizePixel = 0
	bar.Text = ""
	local text = Instance.new("TextLabel",frame)
	text.BackgroundTransparency = 1
	text.Position = UDim2.new(0,0,-1,0)
	text.Size = UDim2.new(1,0,1,0)
	text.Font = Enum.Font.ArialBold
	text.TextStrokeColor3 = Color3.new(0,0,0)
	text.TextStrokeTransparency = 0.5
	text.FontSize = Enum.FontSize.Size18
	text.TextColor3 = Color3.new(1,1,1)
	if brick.Name == "StartBlock" then
		text.Text = "Stone"
	else
		text.Text = brick.Name
	end
end

function MakeCashGUI(mouse, cash)
	local cashgui = Instance.new("ScreenGui",game.Players.LocalPlayer.PlayerGui)
	cashgui.Name = "CashGUI"
	local textlabel = Instance.new("TextLabel",cashgui)
	textlabel.BackgroundTransparency = 1
	textlabel.BorderSizePixel = 0
	textlabel.Size = UDim2.new(0.1,0,0.1,0)
	textlabel.Position = UDim2.new(0,mouse.X,0,mouse.Y-0.25)
	textlabel.Font = Enum.Font.ArialBold
	textlabel.TextStrokeColor3 = Color3.new(0,0,0)
	textlabel.TextStrokeTransparency = 0.5
	textlabel.FontSize = Enum.FontSize.Size36
	textlabel.TextColor3 = Color3.new(0,1,0)
	textlabel.Text = "+$"..tostring(cash)
	textlabel:TweenPosition(UDim2.new(0,mouse.X,0,(mouse.Y-0.25)-50), "Out", "Quad", 1)
	for i = 0, 1, 0.2 do
		textlabel.TextTransparency = i
		wait(.1)
	end
	cashgui:Destroy()

end


function TeleportGUI()
	local tpgui = Instance.new("ScreenGui",game.Players.LocalPlayer.PlayerGui)
	tpgui.Name = "TeleportGUI"
	local button = Instance.new("TextButton",tpgui)
	button.BackgroundColor3 = Color3.new(0,0,0)
	button.BackgroundTransparency = 0.3
	button.BorderColor3 = Color3.new(0,0,1)
	button.BorderSizePixel = 10
	button.Position = UDim2.new(0.03,0,0.8,0)
	button.Size = UDim2.new(0.1,0,0.05,0)
	button.Font = Enum.Font.Bodoni
	button.FontSize = Enum.FontSize.Size28
	button.TextColor3 = Color3.new(1,1,1)
	button.Text = "Surface"
	return tpgui
end

local teleportpad = workspace.TeleportPad
teleportpad.Transparency = 1
teleportpad.CanCollide = false
local tpgui = TeleportGUI()

TeleportCooldownTime = settings["Teleport_GUI_Cooldown_Time"]
tpgui.TextButton.MouseButton1Click:connect(function(mouse)
	local player = game.Players.LocalPlayer
	if player.Character ~= nil and tpgui.TextButton.Text == "Surface" then
		player.Character.Torso.CFrame = teleportpad.CFrame + Vector3.new(0,3,0)
		tpgui.TextButton.FontSize = Enum.FontSize.Size18
		for i = TeleportCooldownTime, 0, -1 do
			tpgui.TextButton.Text = "Cooldown: "..i
			wait(1)
		end
		tpgui.TextButton.Text = "Surface"
		tpgui.TextButton.FontSize = Enum.FontSize.Size28
	end
end)



