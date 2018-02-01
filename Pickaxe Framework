
-- Scripted by 8BB

Tool = script.Parent

function Run()
	local anim = Instance.new("StringValue")
	anim.Name = "toolanim"
	anim.Value = "Slash"
	anim.Parent = Tool
end

function PickUp()
	Tool.GripForward = Vector3.new(-1,0,0)
	Tool.GripRight = Vector3.new(0,1,0)
	Tool.GripUp = Vector3.new(0,0,1)
end

function PickOut()
	Tool.GripForward = Vector3.new(0,0,1)
	Tool.GripRight = Vector3.new(0,-1,0)
	Tool.GripUp = Vector3.new(-1,0,0)
end


local Settings = require(game.ReplicatedStorage:WaitForChild("Settings"))
local sound = Instance.new("Sound",script)
sound.SoundId = "rbxassetid://"..Settings["Mining_SoundID"]
sound.Volume = 1

local debounce = true
local buttonup = true
script.Parent.Equipped:connect(function(mouse)
	mouse.Button1Down:connect(function()
		buttonup = false
		while wait() do
			if debounce and not buttonup then
				debounce = false
				Run()
				sound:Play()
				wait(.5)
				debounce = true
			elseif buttonup then
				break
			end
		end
	end)
	
	mouse.Button1Up:connect(function()
		buttonup = true
	end)
end)






