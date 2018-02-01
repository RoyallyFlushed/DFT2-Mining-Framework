
-- Scripted by 8BB

local Settings = {
	
	--[[
		ADDING MORE ORES:
			If you want to add more ores into the mine, simply look at the 'Ores' folder located just above this script
			in the explorer. All you have to do is paste the brick into which ever category you wish.
			
			WHAT TO LOOK OUT FOR:
				- Make sure that the block you want to use is Size 6,6,6 or the game will break.
				- Make sure that you never put a block into the folder that is called 'NORMAL' as 
				this will break the mine.	
		
		NOTE:
			- ["Normal"] stands for Stone
	--]]	
	
	["Badges"] = { -- ID's for the badge for each rarity of block
		
		["Stone_Badge"] = 		720765946;
		["Common_Badge"] = 		0;
		["Uncommon_Badge"] = 	0;
		["Rare_Badge"] = 		0;
		["Legendary_Badge"] = 	0;};
	
	["Mine_Reset_Time"] = 		24; -- How long in MINUTES before the game will reset the mine
		
		
	["Selection_Box_Colours"] = { -- What colours the selection box around the block will be
		
		["Normal"] = 		"Institutional white";
		["Common"] =		"Institutional white";
		["Uncommon"] =		"Toothpaste";
		["Rare"] = 			"Bright orange";
		["Legendary"] = 	"Magenta";};
	
	
	["Mining_Time"] = { -- This is how long it takes to mine an ore. (NOTE: Each number is divided by 100. I.e 10 would be 0.1 in the script)
		
		["Normal"] =	 	10;
		["Common"] =	 	10;
		["Uncommon"] = 		50;
		["Rare"] = 			100;
		["Legendary"] = 	200;};
	
	
	["Cash_Payout"] = { -- This is the amount of cash awarded to the user when they mine the block
		
		["Normal"] = 		25;
		["Common"] = 		75;
		["Uncommon"] = 		150;
		["Rare"] = 			400;
		["Legendary"] = 	1250;};
	
	
	["Teleport_GUI_Cooldown_Time"] = 		30;
	
	
	["Mining_SoundID"] = 		318763788;
	
	
	["Ore_Mined_SoundID"] = 	131323304;}  -- This is the sound that will play when you mine a block





return Settings
