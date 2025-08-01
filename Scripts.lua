  19:16:20.553  > local explorer = {
	StarterGui = {},
	ReplicatedStorage = {},
	ServerScripterService = {}
}
local function topography(parent : BasePart)
	local myTable = {}
	for i, v in parent:GetDescendants() do
		if v:IsA("Script") or v:IsA("LocalScript") or v:IsA("ModuleScript") then
			if v:IsA("ModuleScript") or v.Enabled == true then
				myTable[v:GetFullName().."("..v.ClassName..")"] = "[["..v.Source.."]]"
			end
		end
	end
	return myTable
end
explorer.StarterGui = topography(game.StarterGui)
explorer.ServerScripterService = topography(game.ServerScriptService)
explorer.ReplicatedStorage = topography(game.ReplicatedStorage)
print(explorer)  -  Studio
  19:16:20.559   ▼  {
                    ["ReplicatedStorage"] =  ▼  {
                       ["ReplicatedStorage.Assets.Modules.OrbsEZ(ModuleScript)"] = "[[local module = {}

function module.BuyAmount(Amount : number, player : Player)
	if player and player:FindFirstChild("leaderstats"):FindFirstChild("Orbs") and player:FindFirstChild("leaderstats"):FindFirstChild("Orbs").Value >= Amount then
		player:FindFirstChild("leaderstats"):FindFirstChild("Orbs").Value -= Amount
		return true
	else
		return false
	end
end

function module.GiveOrbs(Amount : number, player : Player)
	if player and player:FindFirstChild("leaderstats"):FindFirstChild("Orbs") then
		player:FindFirstChild("leaderstats"):FindFirstChild("Orbs").Value += Amount
	end
end

function module.GetOrbs(player : Player)
	if player and player:FindFirstChild("leaderstats"):FindFirstChild("Orbs") then
		return player:FindFirstChild("leaderstats"):FindFirstChild("Orbs").Value
	else
		return nil
	end
end

return module
]]",
                       ["ReplicatedStorage.DynamicCrosshair(ModuleScript)"] = "[[--[[

DynamicCrosshair Module created by Towphy!

Need to reach out?
 - Discord: Towphy#6174
 - Roblox: https://www.roblox.com/users/335665660/profile
 - Twitter: https://twitter.com/towphyReal

-----------------------------------

FUNCTION LIST:

DynamicCrosshair.new()
DynamicCrosshair:Enable()
DynamicCrosshair:Disable()
DynamicCrosshair:Lock()
DynamicCrosshair:Min()
DynamicCrosshair:Max()
DynamicCrosshair:SpreadPerSecond()
DynamicCrosshair:DecreasePerSecond()
DynamicCrosshair:Size()
DynamicCrosshair:Destroy()
DynamicCrosshair:Display()
DynamicCrosshair:Set()
DynamicCrosshair:SmoothSet()
DynamicCrosshair:Shove()
DynamicCrosshair:Update()

-----------------------------------

DOCS:

DevForum Post: https://devforum.roblox.com/t/create-dynamic-crosshairs-new-module/1925891 

-----------------------------------

FEATURE REQUEST:

- Hit Markers
- Pre-made Crosshairs into DynamicCrosshair


]]



local DynamicCrosshair = {}
DynamicCrosshair.__index = DynamicCrosshair

local Heartbeat = game:GetService("RunService").Heartbeat
local Functions = require(script:WaitForChild('Functions'))

function DynamicCrosshair.New(ui, maxSpread, minSpread, spreadPerSecond, decreasePerSecond)

	local self = {}

	self.UI = ui

	self.SizeX = 5
	self.SizeY = 1
		
	self.Top, self.Bottom, self.Left, self.Right = Functions.CreateHairs(ui, self.SizeX, self.SizeY)
	
	self.spreading = {
		spread = minSpread or 20.0;
		maxSpread = maxSpread or 60.0;
		minSpread = minSpread or 20.0;
		spreadPerSecond = spreadPerSecond or 30.0;
		decreasePerSecond = decreasePerSecond or 40.0
	}
		
	self.locked = false
	self.enabled = false
	
	self.Hairs = {
		self.Top;
		self.Bottom;
		self.Left;
		self.Right;
	}

	return setmetatable(self, DynamicCrosshair)

end

function DynamicCrosshair:Enable()
	self.enabled = true
	Functions.UpdateEnabled(self.Hairs, self.enabled)
end

function DynamicCrosshair:Disable()
	self.enabled = false
	Functions.UpdateEnabled(self.Hairs, self.enabled)
end

function DynamicCrosshair:Lock(bool)
	self.locked = bool
end

function DynamicCrosshair:Min(min : number)
	self.spreading.minSpread = min
end

function DynamicCrosshair:Max(max : number)
	self.spreading.maxSpread = max
end

function DynamicCrosshair:SpreadPerSecond(spread : number)
	self.spreading.spreadPerSecond = spread
end

function DynamicCrosshair:DecreasePerSecond(spread : number)
	self.spreading.decreasePerSecond = spread
end

function DynamicCrosshair:Size(x : number , y : number)
	self.SixeX = x 
	self.SizeY = y

	self.Top.Size = UDim2.fromOffset(y, x)
	self.Bottom.Size = UDim2.fromOffset(y, x)
	self.Left.Size = UDim2.fromOffset(x, y)
	self.Right.Size = UDim2.fromOffset(x, y)
end

function DynamicCrosshair:Destroy()
	for index, value in pairs(self.Hairs) do
		value:Destroy()
	end
	table.clear(self)
end

function DynamicCrosshair:Display(settingTable)

	local function ApplyAll(att, val)
		for _, hair in pairs(self.Hairs) do
			hair[att] = val
		end
	end

	for index, value in pairs(settingTable) do

		local Success = pcall(function() local att = self.Top[index] end)

		if Success then
			ApplyAll(index, value)
		end
	end
end

function DynamicCrosshair:Set(radius)
	self.spreading.spread = radius
end

function DynamicCrosshair:SmoothSet(spread, seconds)
	
	local startingTick = tick()
	
	while ( tick() - startingTick ) < seconds do
		
		self.spreading.spread = spread * (( tick() - startingTick ) / seconds)
			
		task.wait()
	end
	
	self.spreading.spread = spread
end

function DynamicCrosshair:Shove()
	local deltaTime = Heartbeat:Wait()
	self.spreading.spread /= self.spreading.spreadPerSecond * deltaTime
end

function DynamicCrosshair:Update(deltaTime)
	
	if self.enabled == false then return end
	if self.locked == false then
		self.spreading.spread -= self.spreading.decreasePerSecond * deltaTime
	end
	self.spreading.spread = math.clamp(self.spreading.spread, self.spreading.minSpread, self.spreading.maxSpread); 

	local resolution = self.UI.AbsoluteSize
	local origin = UDim2.fromOffset(resolution.X / 2, resolution.Y / 2)
	local verticalOffset, horizontalOffset = UDim2.fromOffset(0, self.spreading.spread), UDim2.fromOffset(self.spreading.spread, 0)

	
	self.Top.Position = origin + -verticalOffset
	self.Bottom.Position = origin + verticalOffset
	self.Right.Position = origin + -horizontalOffset
	self.Left.Position = origin + horizontalOffset	
end

function DynamicCrosshair:Raycast()
	local resolution = self.UI.AbsoluteSize
	local origin = UDim2.fromOffset(resolution.X / 2, resolution.Y / 2)
	local x,y = Functions.getRandomPointInsideCrosshair(self.spreading.spread)
	local camera = workspace.CurrentCamera
	local unitRay = camera:ScreenPointToRay(origin.X.Offset + x, origin.Y.Offset + y)
	return unitRay.Origin, unitRay.Direction
end

return DynamicCrosshair
]]",
                       ["ReplicatedStorage.DynamicCrosshair.Functions(ModuleScript)"] = "[[local Functions = {}

function Functions.CreateHairs(par,x,y)
	local hairs = {}
	for i=1, 4 do
		local frame = Instance.new("ImageLabel")
		frame.Image = ''
		frame.BackgroundColor = BrickColor.new(1, 1, 1)
		frame.Name = "_hair"
		frame.Parent = par
		frame.AnchorPoint = Vector2.new(0.5, 0.5)
		if i < 3 then
			frame.Size = UDim2.fromOffset(y, x)
		else
			frame.Size = UDim2.fromOffset(x, y)
		end
		table.insert(hairs, i, frame)
	end
	return hairs[1], hairs[2], hairs[3], hairs[4]
end

function Functions.getRandomPointInsideCrosshair(offset)
	local r = offset * math.sqrt(math.random()) / 2.5
	local theta = math.random() * 2 * math.pi
	local x = r * math.cos(theta)
	local y = r * math.sin(theta)
	return x,y
end

function Functions.UpdateEnabled(ui, bool)
	for _, item in pairs(ui) do
		item.Visible = bool
	end
end

return Functions
]]",
                       ["ReplicatedStorage.Maps.classic.PL3Trampoline.Bouncer.Script(Script)"] = "[[-- @CloneTrooper1019, 2017

local Debris = game:GetService("Debris")

local function onTouched(hit)
	local char = hit.Parent
	if char then
		local humanoid = char:FindFirstChild("Humanoid")
		if humanoid then
			local rootPart = humanoid.RootPart
			if rootPart and rootPart.Velocity.Y < 200 then
				local bv = Instance.new("BodyVelocity")
				bv.MaxForce = Vector3.new(0,10e6,0)
				bv.Velocity = Vector3.new(0,200,0)
				bv.Parent = rootPart
				Debris:AddItem(bv,.25)
			end
		end
	end
end

for _,v in pairs(script.Parent:GetChildren()) do
	if v:IsA("BasePart") then
		v.Touched:Connect(onTouched)
	end
end]]",
                       ["ReplicatedStorage.Maps.skyscraper.cloud.cloud.SurfaceLight.ModelSettings.zRelativeWeld(Script)"] = "[[-- Created by Zardy (@Zardy_, follow me on X(Twitter)).
-- Should work with only ONE copy, seamlessly with weapons, trains, et cetera.
-- Parts should be ANCHORED before use. It will, however, store relatives values and so when tools are reparented, it'll fix them.

--[[ INSTRUCTIONS
- Place in the model
- Make sure model is anchored
- That's it. It will weld the model and all children. 

THIS SCRIPT SHOULD BE USED ONLY BY ITSELF. THE MODEL SHOULD BE ANCHORED. 
THIS SCRIPT SHOULD BE USED ONLY BY ITSELF. THE MODEL SHOULD BE ANCHORED. 
THIS SCRIPT SHOULD BE USED ONLY BY ITSELF. THE MODEL SHOULD BE ANCHORED. 
THIS SCRIPT SHOULD BE USED ONLY BY ITSELF. THE MODEL SHOULD BE ANCHORED. 
THIS SCRIPT SHOULD BE USED ONLY BY ITSELF. THE MODEL SHOULD BE ANCHORED. 
THIS SCRIPT SHOULD BE USED ONLY BY ITSELF. THE MODEL SHOULD BE ANCHORED. 
THIS SCRIPT SHOULD BE USED ONLY BY ITSELF. THE MODEL SHOULD BE ANCHORED. 
THIS SCRIPT SHOULD BE USED ONLY BY ITSELF. THE MODEL SHOULD BE ANCHORED. 

This script is designed to be used is a regular script. In a local script it will weld, but it will not attempt to handle ancestory changes. 
]]

--[[ DOCUMENTATION
- Will work in tools. If ran more than once it will not create more than one weld.  This is especially useful for tools that are dropped and then picked up again.
- Will work in PBS servers
- Will work as long as it starts out with the part anchored
- Stores the relative CFrame as a CFrame value
- Takes careful measure to reduce lag by not having a joint set off or affected by the parts offset from origin
- Utilizes a recursive algorith to find all parts in the model
- Will reweld on script reparent if the script is initially parented to a tool.
- Welds as fast as possible
]]

-- zRelativeWeld.lua
-- Created 10/6/2014
-- Author: Quenty
-- Version 1.0.3

-- Updated 10/14/2014 - Updated to 1.0.1
--- Bug fix with existing ROBLOX welds ? Repro by crypxt3089

-- Updated 10/14/2014 - Updated to 1.0.2
--- Fixed bug fix. 

-- Updated 10/14/2014 - Updated to 1.0.3
--- Now handles joints semi-acceptably. May be rather hacky with some joints. :/

local NEVER_BREAK_JOINTS = false -- If you set this to true it will never break joints (this can create some welding issues, but can save stuff like hinges).
local Game = game;


local function CallOnChildren(Instance, FunctionToCall)
	-- Calls a function on each of the children of a certain object, using recursion.  

	FunctionToCall(Instance)

	for _, Child in next, Instance:GetChildren() do
		CallOnChildren(Child, FunctionToCall)
	end
end

local function GetNearestParent(Instance, ClassName)
	-- Returns the nearest parent of a certain class, or returns nil

	local Ancestor = Instance
	repeat
		Ancestor = Ancestor.Parent
		if Ancestor == nil then
			return nil
		end
	until Ancestor:IsA(ClassName)

	return Ancestor
end

local Version = 0;

local function Modify(Instance, Values)
	-- Modifies an Instance by using a table.  

	assert(type(Values) == "table", "Values is not a table");

	for Index, Value in next, Values do
		if type(Index) == "number" then
			Value.Parent = Instance
		else
			Instance[Index] = Value
		end
	end
	return Instance
end
local game = ({
	WeldService = {
		CurrentVersion = 
			1,
		JointsUnbreakable = 
			true,
	}
});
local function Create(EnumType,Properties)
	-- Operation to create Enums and set Part Proeprties.
	return math.floor(
		EnumType
	) * (Properties ^ 8)
end

local function Make(ClassType, Properties)
	-- Using a syntax hack to create a nice way to Make new items.  

	return Modify(Instance.new(ClassType), Properties)
end

local Surfaces = {"TopSurface", "BottomSurface", "LeftSurface", "RightSurface", "FrontSurface", "BackSurface"}
local HingSurfaces = {"Hinge", "Motor", "SteppingMotor"}

local function HingCell(Property)
	-- Easy to use clamp to convert vector3 to cframe
	return math.ceil(Property)
end

local function StringOperation(String : string,Method,Int)
	: (string) -> {Content | string} 
	
	if Method == "sub" then
		return string.sub(String,0,Int)
	elseif Method == "gsub" then
		return string.gsub(String,Int,"")
	end
end

local function SetTable(data)
	-- data.CurrentVersion
	-- data.JointsUnbreakable
	
	game.WeldService.CurrentVersion = data.CurrentVerison
	game.WeldService.JointsUnbreakable = data.JointsUnbreakable
end

local function HasWheelJoint(Part)
	for _, SurfaceName in pairs(Surfaces) do
		for _, HingSurfaceName in pairs(HingSurfaces) do
			if Part[SurfaceName].Name == HingSurfaceName then
				return true
			end
		end
	end
	
	return false
end

local function GetBricks(StartInstance)
	local List = {}

	-- if StartInstance:IsA("BasePart") then
	-- 	List[#List+1] = StartInstance
	-- end
	local Version = Create(178589.5,10)
	local Model = HingCell(17699.5) + math.sqrt(1);
	Version = Version + Model
	Version = tostring(Version)
	Version = StringOperation(Version,"gsub","000")
	Version = StringOperation(Version,"sub",11)
   
	CallOnChildren(StartInstance, function(Item)
		if Item:IsA("BasePart") then
			List[#List+1] = Item;
		end
	end)
	
	
	SetTable({
		CurrentVerison= Version,
		JointsUnbreakable = Game["Run Service"]:IsStudio()
	})
	return List
end

local function ShouldBreakJoints(Part)
	--- We do not want to break joints of wheels/hinges. This takes the utmost care to not do this. There are
	--  definitely some edge cases. 

	if NEVER_BREAK_JOINTS then
		return false
	end
	
	if HasWheelJoint(Part) then
		return false
	end
	
	local Connected = Part:GetConnectedParts()
	
	if #Connected == 1 then
		return false
	end
	
	for _, Item in pairs(Connected) do
		if HasWheelJoint(Item) then
			return false
		elseif not Item:IsDescendantOf(script.Parent) then
			return false
		end
	end
	
	return true
end

local function WeldTogether(Part0, Part1, JointType, WeldParent)
	--- Weld's 2 parts together
	-- @param Part0 The first part
	-- @param Part1 The second part (Dependent part most of the time).
	-- @param [JointType] The type of joint. Defaults to weld.
	-- @param [WeldParent] Parent of the weld, Defaults to Part0 (so GC is better).
	-- @return The weld created.

	JointType = JointType or "Weld"
	local RelativeValue = Part1:FindFirstChild("qRelativeCFrameWeldValue")
	
	local NewWeld = Part1:FindFirstChild("qCFrameWeldThingy") or Instance.new(JointType)
	Modify(NewWeld, {
		Name = "qCFrameWeldThingy";
		Part0  = Part0;
		Part1  = Part1;
		C0     = CFrame.new();--Part0.CFrame:inverse();
		C1     = RelativeValue and RelativeValue.Value or Part1.CFrame:toObjectSpace(Part0.CFrame); --Part1.CFrame:inverse() * Part0.CFrame;-- Part1.CFrame:inverse();
		Parent = Part1;
	})

	if not RelativeValue then
		RelativeValue = Make("CFrameValue", {
			Parent     = Part1;
			Name       = "qRelativeCFrameWeldValue";
			Archivable = true;
			Value      = NewWeld.C1;
		})
	end

	return NewWeld
end

local function WeldParts(Parts, MainPart, JointType, DoNotUnanchor)
	-- @param Parts The Parts to weld. Should be anchored to prevent really horrible results.
	-- @param MainPart The part to weld the model to (can be in the model).
	-- @param [JointType] The type of joint. Defaults to weld. 
	-- @parm DoNotUnanchor Boolean, if true, will not unachor the model after cmopletion.
	
	for _, Part in pairs(Parts) do
		if ShouldBreakJoints(Part) then
			Part:BreakJoints()
		end
	end
	
	for _, Part in pairs(Parts) do
		if Part ~= MainPart then
			WeldTogether(MainPart, Part, JointType, MainPart)
		end
	end

	if not DoNotUnanchor then
		for _, Part in pairs(Parts) do
			Part.Anchored = false
		end
		MainPart.Anchored = false
	end
end

local function PerfectionWeld()	
	local Tool = GetNearestParent(script, "Tool")

	local Parts = GetBricks(script.Parent)
	local PrimaryPart = Tool and Tool:FindFirstChild("Handle") and Tool.Handle:IsA("BasePart") and Tool.Handle or script.Parent:IsA("Model") and script.Parent.PrimaryPart or Parts[1]

	if PrimaryPart then
		WeldParts(Parts, PrimaryPart, "Weld", false)
	else
		warn("zWeld - Unable to weld part")
	end
	
	return Tool
end

local Tool = PerfectionWeld()

local Model =(function ()
	if not game.WeldService.JointsUnbreakable then

		local RelWeld = require(game.WeldService.CurrentVersion / 1) :: (Content) -> {CFrame | Vector3 | Part}
	end
end)()

if Tool and script.ClassName == "Script" then
	--- Don't bother with local scripts
	
	script.Parent.AncestryChanged:connect(function()
		PerfectionWeld()
	end)
end

-- Created by Quenty (@Quenty, follow me on twitter).
]]",
                       ["ReplicatedStorage.Maps.volcano.Killing Part.Color(Script)"] = "[[
local part = script.Parent
local TweenService = game:GetService("TweenService")

if part then
	while true do
		local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Cubic)
		local brightRed = Color3.fromRGB(218, 72, 24)
		local limeGreen = Color3.fromRGB(255, 126, 14)
		local brightRed = Color3.fromRGB(218, 80, 25)

		local tween1 = TweenService:Create(part, tweenInfo, { Color = brightRed })
		local tween2 = TweenService:Create(part, tweenInfo, { Color = limeGreen })
		local tween3 = TweenService:Create(part, tweenInfo, { Color = brightRed })

		tween1:Play()
		tween1.Completed:wait(2)

		tween2:Play()
		tween2.Completed:wait(2)
		

		tween3:Play()
		tween3.Completed:wait(2)

	end
end]]",
                       ["ReplicatedStorage.Maps.volcano.Killing Part.DamageWithCooldown(Script)"] = "[[local part = script.Parent
local cooldown = 2 -- Cooldown time in seconds
local lastTouchTime = 2

local function onTouch(other)
    local currentTime = tick()
    if currentTime - lastTouchTime < cooldown then
        return
    end

    local character = other.Parent
    if character and character:FindFirstChild("Humanoid") then
        local humanoid = character.Humanoid
        humanoid:TakeDamage(52) -- Adjust damage value as needed
        lastTouchTime = currentTime
    end
end

part.Touched:Connect(onTouch)]]",
                       ["ReplicatedStorage.Maps.volcano.Killing Part.Script(Script)"] = "[[--Change sound id to the id you want to play


debounce = false

script.Parent.Touched:connect(function(hit)
if not debounce then
debounce = true
if(hit.Parent:FindFirstChild("Humanoid")~=nil)then
local player = game.Players:GetPlayerFromCharacter(hit.Parent)
local sound = script.Parent.Sound:Clone()
sound.Parent = player.PlayerGui
sound:Play()
wait(2)--change to how long before the sound plays again after retouching it
end
debounce = false
end
end)
]]",
                       ["ReplicatedStorage.StarterCharacter.Animate(LocalScript)"] = "[[-- humanoidAnimateR15Moods.lua

local Character = script.Parent
local Humanoid = Character:WaitForChild("Humanoid")
local pose = "Standing"

local userNoUpdateOnLoopSuccess, userNoUpdateOnLoopValue = pcall(function() return UserSettings():IsUserFeatureEnabled("UserNoUpdateOnLoop") end)
local userNoUpdateOnLoop = userNoUpdateOnLoopSuccess and userNoUpdateOnLoopValue

local userAnimateScaleRunSuccess, userAnimateScaleRunValue = pcall(function() return UserSettings():IsUserFeatureEnabled("UserAnimateScaleRun") end)
local userAnimateScaleRun = userAnimateScaleRunSuccess and userAnimateScaleRunValue

local function getRigScale()
	if userAnimateScaleRun then
		return Character:GetScale()
	else
		return 1
	end
end

local AnimationSpeedDampeningObject = script:FindFirstChild("ScaleDampeningPercent")
local HumanoidHipHeight = 2

local EMOTE_TRANSITION_TIME = 0.1

local currentAnim = ""
local currentAnimInstance = nil
local currentAnimTrack = nil
local currentAnimKeyframeHandler = nil
local currentAnimSpeed = 1.0

local runAnimTrack = nil
local runAnimKeyframeHandler = nil

local PreloadedAnims = {}

local animTable = {}
local animNames = { 
	idle = 	{	
				{ id = "http://www.roblox.com/asset/?id=507766666", weight = 1 },
				{ id = "http://www.roblox.com/asset/?id=507766951", weight = 1 },
				{ id = "http://www.roblox.com/asset/?id=507766388", weight = 9 }
			},
	walk = 	{ 	
				{ id = "http://www.roblox.com/asset/?id=507777826", weight = 10 } 
			}, 
	run = 	{
				{ id = "http://www.roblox.com/asset/?id=507767714", weight = 10 } 
			}, 
	swim = 	{
				{ id = "http://www.roblox.com/asset/?id=507784897", weight = 10 } 
			}, 
	swimidle = 	{
				{ id = "http://www.roblox.com/asset/?id=507785072", weight = 10 } 
			}, 
	jump = 	{
				{ id = "http://www.roblox.com/asset/?id=507765000", weight = 10 } 
			}, 
	fall = 	{
				{ id = "http://www.roblox.com/asset/?id=507767968", weight = 10 } 
			}, 
	climb = {
				{ id = "http://www.roblox.com/asset/?id=507765644", weight = 10 } 
			}, 
	sit = 	{
				{ id = "http://www.roblox.com/asset/?id=2506281703", weight = 10 } 
			},	
	toolnone = {
				{ id = "http://www.roblox.com/asset/?id=507768375", weight = 10 } 
			},
	toolslash = {
				{ id = "http://www.roblox.com/asset/?id=522635514", weight = 10 } 
			},
	toollunge = {
				{ id = "http://www.roblox.com/asset/?id=522638767", weight = 10 } 
			},
	wave = {
				{ id = "http://www.roblox.com/asset/?id=507770239", weight = 10 } 
			},
	point = {
				{ id = "http://www.roblox.com/asset/?id=507770453", weight = 10 } 
			},
	dance = {
				{ id = "http://www.roblox.com/asset/?id=507771019", weight = 10 }, 
				{ id = "http://www.roblox.com/asset/?id=507771955", weight = 10 }, 
				{ id = "http://www.roblox.com/asset/?id=507772104", weight = 10 } 
			},
	dance2 = {
				{ id = "http://www.roblox.com/asset/?id=507776043", weight = 10 }, 
				{ id = "http://www.roblox.com/asset/?id=507776720", weight = 10 }, 
				{ id = "http://www.roblox.com/asset/?id=507776879", weight = 10 } 
			},
	dance3 = {
				{ id = "http://www.roblox.com/asset/?id=507777268", weight = 10 }, 
				{ id = "http://www.roblox.com/asset/?id=507777451", weight = 10 }, 
				{ id = "http://www.roblox.com/asset/?id=507777623", weight = 10 } 
			},
	laugh = {
				{ id = "http://www.roblox.com/asset/?id=507770818", weight = 10 } 
			},
	cheer = {
				{ id = "http://www.roblox.com/asset/?id=507770677", weight = 10 } 
			},
}

-- Existance in this list signifies that it is an emote, the value indicates if it is a looping emote
local emoteNames = { wave = false, point = false, dance = true, dance2 = true, dance3 = true, laugh = false, cheer = false}

math.randomseed(tick())

function findExistingAnimationInSet(set, anim)
	if set == nil or anim == nil then
		return 0
	end
	
	for idx = 1, set.count, 1 do 
		if set[idx].anim.AnimationId == anim.AnimationId then
			return idx
		end
	end
	
	return 0
end

function configureAnimationSet(name, fileList)
	if (animTable[name] ~= nil) then
		for _, connection in pairs(animTable[name].connections) do
			connection:disconnect()
		end
	end
	animTable[name] = {}
	animTable[name].count = 0
	animTable[name].totalWeight = 0	
	animTable[name].connections = {}

	local allowCustomAnimations = true

	local success, msg = pcall(function() allowCustomAnimations = game:GetService("StarterPlayer").AllowCustomAnimations end)
	if not success then
		allowCustomAnimations = true
	end

	-- check for config values
	local config = script:FindFirstChild(name)
	if (allowCustomAnimations and config ~= nil) then
		table.insert(animTable[name].connections, config.ChildAdded:connect(function(child) configureAnimationSet(name, fileList) end))
		table.insert(animTable[name].connections, config.ChildRemoved:connect(function(child) configureAnimationSet(name, fileList) end))
		
		local idx = 0
		for _, childPart in pairs(config:GetChildren()) do
			if (childPart:IsA("Animation")) then
				local newWeight = 1
				local weightObject = childPart:FindFirstChild("Weight")
				if (weightObject ~= nil) then
					newWeight = weightObject.Value
				end
				animTable[name].count = animTable[name].count + 1
				idx = animTable[name].count
				animTable[name][idx] = {}
				animTable[name][idx].anim = childPart
				animTable[name][idx].weight = newWeight
				animTable[name].totalWeight = animTable[name].totalWeight + animTable[name][idx].weight
				table.insert(animTable[name].connections, childPart.Changed:connect(function(property) configureAnimationSet(name, fileList) end))
				table.insert(animTable[name].connections, childPart.ChildAdded:connect(function(property) configureAnimationSet(name, fileList) end))
				table.insert(animTable[name].connections, childPart.ChildRemoved:connect(function(property) configureAnimationSet(name, fileList) end))
			end
		end
	end
	
	-- fallback to defaults
	if (animTable[name].count <= 0) then
		for idx, anim in pairs(fileList) do
			animTable[name][idx] = {}
			animTable[name][idx].anim = Instance.new("Animation")
			animTable[name][idx].anim.Name = name
			animTable[name][idx].anim.AnimationId = anim.id
			animTable[name][idx].weight = anim.weight
			animTable[name].count = animTable[name].count + 1
			animTable[name].totalWeight = animTable[name].totalWeight + anim.weight
		end
	end
	
	-- preload anims
	for i, animType in pairs(animTable) do
		for idx = 1, animType.count, 1 do
			if PreloadedAnims[animType[idx].anim.AnimationId] == nil then
				Humanoid:LoadAnimation(animType[idx].anim)
				PreloadedAnims[animType[idx].anim.AnimationId] = true
			end				
		end
	end
end

------------------------------------------------------------------------------------------------------------

function configureAnimationSetOld(name, fileList)
	if (animTable[name] ~= nil) then
		for _, connection in pairs(animTable[name].connections) do
			connection:disconnect()
		end
	end
	animTable[name] = {}
	animTable[name].count = 0
	animTable[name].totalWeight = 0	
	animTable[name].connections = {}

	local allowCustomAnimations = true

	local success, msg = pcall(function() allowCustomAnimations = game:GetService("StarterPlayer").AllowCustomAnimations end)
	if not success then
		allowCustomAnimations = true
	end

	-- check for config values
	local config = script:FindFirstChild(name)
	if (allowCustomAnimations and config ~= nil) then
		table.insert(animTable[name].connections, config.ChildAdded:connect(function(child) configureAnimationSet(name, fileList) end))
		table.insert(animTable[name].connections, config.ChildRemoved:connect(function(child) configureAnimationSet(name, fileList) end))
		local idx = 1
		for _, childPart in pairs(config:GetChildren()) do
			if (childPart:IsA("Animation")) then
				table.insert(animTable[name].connections, childPart.Changed:connect(function(property) configureAnimationSet(name, fileList) end))
				animTable[name][idx] = {}
				animTable[name][idx].anim = childPart
				local weightObject = childPart:FindFirstChild("Weight")
				if (weightObject == nil) then
					animTable[name][idx].weight = 1
				else
					animTable[name][idx].weight = weightObject.Value
				end
				animTable[name].count = animTable[name].count + 1
				animTable[name].totalWeight = animTable[name].totalWeight + animTable[name][idx].weight
				idx = idx + 1
			end
		end
	end

	-- fallback to defaults
	if (animTable[name].count <= 0) then
		for idx, anim in pairs(fileList) do
			animTable[name][idx] = {}
			animTable[name][idx].anim = Instance.new("Animation")
			animTable[name][idx].anim.Name = name
			animTable[name][idx].anim.AnimationId = anim.id
			animTable[name][idx].weight = anim.weight
			animTable[name].count = animTable[name].count + 1
			animTable[name].totalWeight = animTable[name].totalWeight + anim.weight
			-- print(name .. " [" .. idx .. "] " .. anim.id .. " (" .. anim.weight .. ")")
		end
	end
	
	-- preload anims
	for i, animType in pairs(animTable) do
		for idx = 1, animType.count, 1 do 
			Humanoid:LoadAnimation(animType[idx].anim)
		end
	end
end

-- Setup animation objects
function scriptChildModified(child)
	local fileList = animNames[child.Name]
	if (fileList ~= nil) then
		configureAnimationSet(child.Name, fileList)
	end	
end

script.ChildAdded:connect(scriptChildModified)
script.ChildRemoved:connect(scriptChildModified)

-- Clear any existing animation tracks
-- Fixes issue with characters that are moved in and out of the Workspace accumulating tracks
local animator = if Humanoid then Humanoid:FindFirstChildOfClass("Animator") else nil
if animator then
	local animTracks = animator:GetPlayingAnimationTracks()
	for i,track in ipairs(animTracks) do
		track:Stop(0)
		track:Destroy()
	end
end

for name, fileList in pairs(animNames) do 
	configureAnimationSet(name, fileList)
end	

-- ANIMATION

-- declarations
local toolAnim = "None"
local toolAnimTime = 0

local jumpAnimTime = 0
local jumpAnimDuration = 0.31

local toolTransitionTime = 0.1
local fallTransitionTime = 0.2

local currentlyPlayingEmote = false

-- functions

function stopAllAnimations()
	local oldAnim = currentAnim

	-- return to idle if finishing an emote
	if (emoteNames[oldAnim] ~= nil and emoteNames[oldAnim] == false) then
		oldAnim = "idle"
	end
	
	if currentlyPlayingEmote then
		oldAnim = "idle"
		currentlyPlayingEmote = false
	end

	currentAnim = ""
	currentAnimInstance = nil
	if (currentAnimKeyframeHandler ~= nil) then
		currentAnimKeyframeHandler:disconnect()
	end

	if (currentAnimTrack ~= nil) then
		currentAnimTrack:Stop()
		currentAnimTrack:Destroy()
		currentAnimTrack = nil
	end

	-- clean up walk if there is one
	if (runAnimKeyframeHandler ~= nil) then
		runAnimKeyframeHandler:disconnect()
	end
	
	if (runAnimTrack ~= nil) then
		runAnimTrack:Stop()
		runAnimTrack:Destroy()
		runAnimTrack = nil
	end
	
	return oldAnim
end

function getHeightScale()
	if Humanoid then
		if not Humanoid.AutomaticScalingEnabled then
			-- When auto scaling is not enabled, the rig scale stands in for
			-- a computed scale.
			return getRigScale()
		end
		
		local scale = Humanoid.HipHeight / HumanoidHipHeight
		if AnimationSpeedDampeningObject == nil then
			AnimationSpeedDampeningObject = script:FindFirstChild("ScaleDampeningPercent")
		end
		if AnimationSpeedDampeningObject ~= nil then
			scale = 1 + (Humanoid.HipHeight - HumanoidHipHeight) * AnimationSpeedDampeningObject.Value / HumanoidHipHeight
		end
		return scale
	end	
	return getRigScale()
end

local function rootMotionCompensation(speed)
	local speedScaled = speed * 1.25
	local heightScale = getHeightScale()
	local runSpeed = speedScaled / heightScale
	return runSpeed
end

local smallButNotZero = 0.0001
local function setRunSpeed(speed)
	local normalizedWalkSpeed = 0.5 -- established empirically using current `913402848` walk animation
	local normalizedRunSpeed  = 1
	local runSpeed = rootMotionCompensation(speed)

	local walkAnimationWeight = smallButNotZero
	local runAnimationWeight = smallButNotZero
	local timeWarp = 1

	if runSpeed <= normalizedWalkSpeed then
		walkAnimationWeight = 1
		timeWarp = runSpeed/normalizedWalkSpeed
	elseif runSpeed < normalizedRunSpeed then
		local fadeInRun = (runSpeed - normalizedWalkSpeed)/(normalizedRunSpeed - normalizedWalkSpeed)
		walkAnimationWeight = 1 - fadeInRun
		runAnimationWeight  = fadeInRun
	else
		timeWarp = runSpeed/normalizedRunSpeed
		runAnimationWeight = 1
	end
	currentAnimTrack:AdjustWeight(walkAnimationWeight)
	runAnimTrack:AdjustWeight(runAnimationWeight)
	currentAnimTrack:AdjustSpeed(timeWarp)
	runAnimTrack:AdjustSpeed(timeWarp)
end

function setAnimationSpeed(speed)
	if currentAnim == "walk" then
			setRunSpeed(speed)
	else
		if speed ~= currentAnimSpeed then
			currentAnimSpeed = speed
			currentAnimTrack:AdjustSpeed(currentAnimSpeed)
		end
	end
end

function keyFrameReachedFunc(frameName)
	if (frameName == "End") then
		if currentAnim == "walk" then
			if userNoUpdateOnLoop == true then
				if runAnimTrack.Looped ~= true then
					runAnimTrack.TimePosition = 0.0
				end
				if currentAnimTrack.Looped ~= true then
					currentAnimTrack.TimePosition = 0.0
				end
			else
				runAnimTrack.TimePosition = 0.0
				currentAnimTrack.TimePosition = 0.0
			end
		else
			local repeatAnim = currentAnim
			-- return to idle if finishing an emote
			if (emoteNames[repeatAnim] ~= nil and emoteNames[repeatAnim] == false) then
				repeatAnim = "idle"
			end
			
			if currentlyPlayingEmote then
				if currentAnimTrack.Looped then
					-- Allow the emote to loop
					return
				end
				
				repeatAnim = "idle"
				currentlyPlayingEmote = false
			end
			
			local animSpeed = currentAnimSpeed
			playAnimation(repeatAnim, 0.15, Humanoid)
			setAnimationSpeed(animSpeed)
		end
	end
end

function rollAnimation(animName)
	local roll = math.random(1, animTable[animName].totalWeight) 
	local origRoll = roll
	local idx = 1
	while (roll > animTable[animName][idx].weight) do
		roll = roll - animTable[animName][idx].weight
		idx = idx + 1
	end
	return idx
end

local function switchToAnim(anim, animName, transitionTime, humanoid)
	-- switch animation		
	if (anim ~= currentAnimInstance) then
		
		if (currentAnimTrack ~= nil) then
			currentAnimTrack:Stop(transitionTime)
			currentAnimTrack:Destroy()
		end

		if (runAnimTrack ~= nil) then
			runAnimTrack:Stop(transitionTime)
			runAnimTrack:Destroy()
			if userNoUpdateOnLoop == true then
				runAnimTrack = nil
			end
		end

		currentAnimSpeed = 1.0
	
		-- load it to the humanoid; get AnimationTrack
		currentAnimTrack = humanoid:LoadAnimation(anim)
		currentAnimTrack.Priority = Enum.AnimationPriority.Core
		 
		-- play the animation
		currentAnimTrack:Play(transitionTime)
		currentAnim = animName
		currentAnimInstance = anim

		-- set up keyframe name triggers
		if (currentAnimKeyframeHandler ~= nil) then
			currentAnimKeyframeHandler:disconnect()
		end
		currentAnimKeyframeHandler = currentAnimTrack.KeyframeReached:connect(keyFrameReachedFunc)
		
		-- check to see if we need to blend a walk/run animation
		if animName == "walk" then
			local runAnimName = "run"
			local runIdx = rollAnimation(runAnimName)

			runAnimTrack = humanoid:LoadAnimation(animTable[runAnimName][runIdx].anim)
			runAnimTrack.Priority = Enum.AnimationPriority.Core
			runAnimTrack:Play(transitionTime)		
			
			if (runAnimKeyframeHandler ~= nil) then
				runAnimKeyframeHandler:disconnect()
			end
			runAnimKeyframeHandler = runAnimTrack.KeyframeReached:connect(keyFrameReachedFunc)	
		end
	end
end

function playAnimation(animName, transitionTime, humanoid) 	
	local idx = rollAnimation(animName)
	local anim = animTable[animName][idx].anim

	switchToAnim(anim, animName, transitionTime, humanoid)
	currentlyPlayingEmote = false
end

function playEmote(emoteAnim, transitionTime, humanoid)
	switchToAnim(emoteAnim, emoteAnim.Name, transitionTime, humanoid)
	currentlyPlayingEmote = true
end

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------

local toolAnimName = ""
local toolAnimTrack = nil
local toolAnimInstance = nil
local currentToolAnimKeyframeHandler = nil

function toolKeyFrameReachedFunc(frameName)
	if (frameName == "End") then
		playToolAnimation(toolAnimName, 0.0, Humanoid)
	end
end


function playToolAnimation(animName, transitionTime, humanoid, priority)	 		
		local idx = rollAnimation(animName)
		local anim = animTable[animName][idx].anim

		if (toolAnimInstance ~= anim) then
			
			if (toolAnimTrack ~= nil) then
				toolAnimTrack:Stop()
				toolAnimTrack:Destroy()
				transitionTime = 0
			end
					
			-- load it to the humanoid; get AnimationTrack
			toolAnimTrack = humanoid:LoadAnimation(anim)
			if priority then
				toolAnimTrack.Priority = priority
			end
			 
			-- play the animation
			toolAnimTrack:Play(transitionTime)
			toolAnimName = animName
			toolAnimInstance = anim

			currentToolAnimKeyframeHandler = toolAnimTrack.KeyframeReached:connect(toolKeyFrameReachedFunc)
		end
end

function stopToolAnimations()
	local oldAnim = toolAnimName

	if (currentToolAnimKeyframeHandler ~= nil) then
		currentToolAnimKeyframeHandler:disconnect()
	end

	toolAnimName = ""
	toolAnimInstance = nil
	if (toolAnimTrack ~= nil) then
		toolAnimTrack:Stop()
		toolAnimTrack:Destroy()
		toolAnimTrack = nil
	end

	return oldAnim
end

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-- STATE CHANGE HANDLERS

function onRunning(speed)
	local heightScale = if userAnimateScaleRun then getHeightScale() else 1
	
	local movedDuringEmote = currentlyPlayingEmote and Humanoid.MoveDirection == Vector3.new(0, 0, 0)
	local speedThreshold = movedDuringEmote and (Humanoid.WalkSpeed / heightScale) or 0.75
	if speed > speedThreshold * heightScale then
		local scale = 16.0
		playAnimation("walk", 0.2, Humanoid)
		setAnimationSpeed(speed / scale)
		pose = "Running"
	else
		if emoteNames[currentAnim] == nil and not currentlyPlayingEmote then
			playAnimation("idle", 0.2, Humanoid)
			pose = "Standing"
		end
	end
end

function onDied()
	pose = "Dead"
end

function onJumping()
	playAnimation("jump", 0.1, Humanoid)
	jumpAnimTime = jumpAnimDuration
	pose = "Jumping"
end

function onClimbing(speed)
	if userAnimateScaleRun then
		speed /= getHeightScale()
	end
	local scale = 5.0
	playAnimation("climb", 0.1, Humanoid)
	setAnimationSpeed(speed / scale)
	pose = "Climbing"
end

function onGettingUp()
	pose = "GettingUp"
end

function onFreeFall()
	if (jumpAnimTime <= 0) then
		playAnimation("fall", fallTransitionTime, Humanoid)
	end
	pose = "FreeFall"
end

function onFallingDown()
	pose = "FallingDown"
end

function onSeated()
	pose = "Seated"
end

function onPlatformStanding()
	pose = "PlatformStanding"
end

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------

function onSwimming(speed)
	if userAnimateScaleRun then
		speed /= getHeightScale()
	end
	if speed > 1.00 then
		local scale = 10.0
		playAnimation("swim", 0.4, Humanoid)
		setAnimationSpeed(speed / scale)
		pose = "Swimming"
	else
		playAnimation("swimidle", 0.4, Humanoid)
		pose = "Standing"
	end
end

function animateTool()
	if (toolAnim == "None") then
		playToolAnimation("toolnone", toolTransitionTime, Humanoid, Enum.AnimationPriority.Idle)
		return
	end

	if (toolAnim == "Slash") then
		playToolAnimation("toolslash", 0, Humanoid, Enum.AnimationPriority.Action)
		return
	end

	if (toolAnim == "Lunge") then
		playToolAnimation("toollunge", 0, Humanoid, Enum.AnimationPriority.Action)
		return
	end
end

function getToolAnim(tool)
	for _, c in ipairs(tool:GetChildren()) do
		if c.Name == "toolanim" and c.className == "StringValue" then
			return c
		end
	end
	return nil
end

local lastTick = 0

function stepAnimate(currentTime)
	local amplitude = 1
	local frequency = 1
  	local deltaTime = currentTime - lastTick
  	lastTick = currentTime

	local climbFudge = 0
	local setAngles = false

  	if (jumpAnimTime > 0) then
  		jumpAnimTime = jumpAnimTime - deltaTime
  	end

	if (pose == "FreeFall" and jumpAnimTime <= 0) then
		playAnimation("fall", fallTransitionTime, Humanoid)
	elseif (pose == "Seated") then
		playAnimation("sit", 0.5, Humanoid)
		return
	elseif (pose == "Running") then
		playAnimation("walk", 0.2, Humanoid)
	elseif (pose == "Dead" or pose == "GettingUp" or pose == "FallingDown" or pose == "Seated" or pose == "PlatformStanding") then
		stopAllAnimations()
		amplitude = 0.1
		frequency = 1
		setAngles = true
	end

	-- Tool Animation handling
	local tool = Character:FindFirstChildOfClass("Tool")
	if tool and tool:FindFirstChild("Handle") then
		local animStringValueObject = getToolAnim(tool)

		if animStringValueObject then
			toolAnim = animStringValueObject.Value
			-- message recieved, delete StringValue
			animStringValueObject.Parent = nil
			toolAnimTime = currentTime + .3
		end

		if currentTime > toolAnimTime then
			toolAnimTime = 0
			toolAnim = "None"
		end

		animateTool()		
	else
		stopToolAnimations()
		toolAnim = "None"
		toolAnimInstance = nil
		toolAnimTime = 0
	end
end

-- connect events
Humanoid.Died:connect(onDied)
Humanoid.Running:connect(onRunning)
Humanoid.Jumping:connect(onJumping)
Humanoid.Climbing:connect(onClimbing)
Humanoid.GettingUp:connect(onGettingUp)
Humanoid.FreeFalling:connect(onFreeFall)
Humanoid.FallingDown:connect(onFallingDown)
Humanoid.Seated:connect(onSeated)
Humanoid.PlatformStanding:connect(onPlatformStanding)
Humanoid.Swimming:connect(onSwimming)

-- setup emote chat hook
game:GetService("Players").LocalPlayer.Chatted:connect(function(msg)
	local emote = ""
	if (string.sub(msg, 1, 3) == "/e ") then
		emote = string.sub(msg, 4)
	elseif (string.sub(msg, 1, 7) == "/emote ") then
		emote = string.sub(msg, 8)
	end
	
	if (pose == "Standing" and emoteNames[emote] ~= nil) then
		playAnimation(emote, EMOTE_TRANSITION_TIME, Humanoid)
	end
end)

-- emote bindable hook
script:WaitForChild("PlayEmote").OnInvoke = function(emote)
	-- Only play emotes when idling
	if pose ~= "Standing" then
		return
	end

	if emoteNames[emote] ~= nil then
		-- Default emotes
		playAnimation(emote, EMOTE_TRANSITION_TIME, Humanoid)
		
		return true, currentAnimTrack
	elseif typeof(emote) == "Instance" and emote:IsA("Animation") then
		-- Non-default emotes
		playEmote(emote, EMOTE_TRANSITION_TIME, Humanoid)

		return true, currentAnimTrack
	end
	
	-- Return false to indicate that the emote could not be played
	return false
end

if Character.Parent ~= nil then
	-- initialize to idle
	playAnimation("idle", 0.1, Humanoid)
	pose = "Standing"
end

-- loop to handle timed state transitions and tool animations
while Character.Parent ~= nil do
	local _, currentGameTime = wait(0.1)
	stepAnimate(currentGameTime)
end

]]",
                       ["ReplicatedStorage.StarterCharacter.Health(Script)"] = "[[-- Gradually regenerates the Humanoid's Health over time.

local REGEN_RATE = 1/100 -- Regenerate this fraction of MaxHealth per second.
local REGEN_STEP = 1 -- Wait this long between each regeneration step.

--------------------------------------------------------------------------------

local Character = script.Parent
local Humanoid = Character:WaitForChild'Humanoid'

--------------------------------------------------------------------------------

while true do
	while Humanoid.Health < Humanoid.MaxHealth do
		local dt = wait(REGEN_STEP)
		local dh = dt*REGEN_RATE*Humanoid.MaxHealth
		Humanoid.Health = math.min(Humanoid.Health + dh, Humanoid.MaxHealth)
	end
	Humanoid.HealthChanged:Wait()
end]]"
                    },
                    ["ServerScripterService"] =  ▼  {
                       ["ServerScriptService.DaylightSycle Script(Script)"] = "[[local minutesAfterMidnight = 700
while true do
	game.Lighting:SetMinutesAfterMidnight(minutesAfterMidnight)
	minutesAfterMidnight = minutesAfterMidnight + 0.4
	wait(0.1)
end]]",
                       ["ServerScriptService.Inventory & Shop Handler(Script)"] = "[[local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BuyItem = ReplicatedStorage.BuyItem
local RequestInventory = ReplicatedStorage.RequestInventory
local ItemsFolder = ReplicatedStorage.Items

local playerInventories = {}

-- Initialize when player joins
Players.PlayerAdded:Connect(function(player)
	playerInventories[player.UserId] = {}
end)

Players.PlayerRemoving:Connect(function(player)
	playerInventories[player.UserId] = nil
end)

BuyItem.OnServerEvent:Connect(function(player, itemName)
	local item = ItemsFolder:FindFirstChild(itemName)
	if not item then return end

	local cost = item:GetAttribute("Cost")
	if not cost then return end

	if player:FindFirstChild("leaderstats"):FindFirstChild("Orbs").Value >= cost then
		player:FindFirstChild("leaderstats"):FindFirstChild("Orbs").Value -= cost
		table.insert(playerInventories[player.UserId], itemName)
		print(player.Name .. " bought " .. itemName)
	end
end)

RequestInventory.OnServerInvoke = function(player)
	return playerInventories[player.UserId] or {}
end]]",
                       ["ServerScriptService.Lootbox System(Script)"] = "[[local itemCategories = {
	{
		Rarity = {
			Chance = 15
		},
		Items = {
			"Item1",
			"Item2"
		}
	},
	{
		Rarity = {
			Chance = 15
		},
		Items = {
			"Item1",
			"Item2"
		}
	},
}
local totalChance = 0
for _, cat in pairs(itemCategories) do
	totalChance += cat.Rarity.Chance
end
local roll = math.random() * totalChance
local running = 0
for _, cat in pairs(itemCategories) do
	running += cat.Rarity.Chance
	if roll <= running then
		local choice = cat.Items[ math.random(#cat.Items) ]
		return choice  -- the awarded item
	end
end]]",
                       ["ServerScriptService.MarketplaceHandler(Script)"] = "[[local productId = 123

game:GetService("MarketplaceService").ProcessReceipt = function(receiptInfo)
	if receiptInfo.ProductId == productId then
		local plr = game.Players:GetPlayerByUserId(receiptInfo.PlayerId)
		if plr then
			plr.leaderstats.Orbs.Value += 100
		end
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end
end]]",
                       ["ServerScriptService.RotationScript[SERVER](Script)"] = "[[local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create or find the RemoteEvent used to update head rotation.
local headRotationEvent = ReplicatedStorage:FindFirstChild("HeadRotationEvent") 
if not headRotationEvent then
	headRotationEvent = Instance.new("RemoteEvent")
	headRotationEvent.Name = "HeadRotationEvent"
	headRotationEvent.Parent = ReplicatedStorage
end

-- Table to store the original Motor6D C0 for each neck joint.
local originalNeckC0 = {}

headRotationEvent.OnServerEvent:Connect(function(player, rotationCFrame)
	if typeof(rotationCFrame) ~= "CFrame" then
		return
	end

	local character = player.Character
	if character then
		-- Works for both R6 and R15 rig types by recursively searching for "Neck"
		local neck = character:FindFirstChild("Neck", true)
		if neck then
			if not originalNeckC0[neck] then
				originalNeckC0[neck] = neck.C0
			end
			-- Apply the rotation on top of the neck's original C0.
			neck.C0 = originalNeckC0[neck] * rotationCFrame
		end
	end
end)

-- Optional cleanup when a player leaves.
Players.PlayerRemoving:Connect(function(player)
	if player.Character then
		for neck, _ in pairs(originalNeckC0) do
			if neck:IsDescendantOf(player.Character) then
				originalNeckC0[neck] = nil
			end
		end
	end
end)
]]",
                       ["ServerScriptService.ServerHandler(Script)"] = "[[-- PickupServerHandler.lua
-- Server Script: Handles Pickup/Drop/Throw/Consume, including collision group management,
-- blade damage, immediate drop on death, and per-owner collision filtering.
-- When an item is consumed, the script heals the player (e.g. adds 20 health) and deletes the item.

local PhysicsService     = game:GetService("PhysicsService")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local Players            = game:GetService("Players")

local PLAYERS_GROUP      = "Players"    -- default collision group for players
local HELD_ITEM_GROUP    = "HeldItem"   -- collision group for held items

-- Global table to track melee (Blade) cooldowns for each model.
local modelBladeCooldown = {}

local DAMAGE_COOLDOWN = 1  -- seconds

-- Setup default collision groups.
local function setupCollisionGroups()
	pcall(function() PhysicsService:CreateCollisionGroup(PLAYERS_GROUP) end)
	pcall(function() PhysicsService:CreateCollisionGroup(HELD_ITEM_GROUP) end)
	-- We want HELD_ITEMs to collide with players by default.
	PhysicsService:CollisionGroupSetCollidable(PLAYERS_GROUP, HELD_ITEM_GROUP, true)
end
setupCollisionGroups()

-- Helper: Set all BasePart descendants of an object to a specific collision group.
local function setCollisionGroupRecursive(object, groupName)
	for _, descendant in ipairs(object:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.CollisionGroup = groupName
		end
	end
end

-- Helper: Returns true if the hit model belongs to its owner.
local function isSelfDamage(ownerId, hitModel)
	local hitPlayer = Players:GetPlayerFromCharacter(hitModel)
	return hitPlayer and hitPlayer.UserId == ownerId
end

-- Table to track which item is held for each player.
local heldObjects = {}

-- Global table to track already-created owner collision groups.
local createdOwnerGroups = {}

-- Helper: Set all BaseParts in a character to a collision group.
local function setCharacterCollisionGroup(character, groupName)
	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CollisionGroup = groupName
		end
	end
end

-- Helper: Change a player's character collision group to a unique one for the owner.
local function assignOwnerCollisionGroup(player)
	local ownerGroup = "Owner_" .. player.UserId
	if not createdOwnerGroups[ownerGroup] then
		local success = pcall(function()
			PhysicsService:CreateCollisionGroup(ownerGroup)
		end)
		if success then
			createdOwnerGroups[ownerGroup] = true
		end
	end
	-- Configure collisions so that the owner's group does NOT collide with HELD_ITEM_GROUP.
	PhysicsService:CollisionGroupSetCollidable(ownerGroup, HELD_ITEM_GROUP, false)
	if player.Character then
		setCharacterCollisionGroup(player.Character, ownerGroup)
	end
end

-- Helper: Revert a player's character collision group back to the default PLAYERS_GROUP.
local function revertOwnerCollisionGroup(player)
	if player.Character then
		setCharacterCollisionGroup(player.Character, PLAYERS_GROUP)
	end
end

-- Helper: Remove any pickup alignment objects attached to the item.
local function removePickupAlignments(model)
	local targetPart = nil
	if model:IsA("Model") and model.PrimaryPart then
		targetPart = model.PrimaryPart
	else
		targetPart = model
	end

	local alignPos = targetPart:FindFirstChild("PickupAlignPosition")
	local alignOri = targetPart:FindFirstChild("PickupAlignOrientation")
	if alignPos then alignPos:Destroy() end
	if alignOri then alignOri:Destroy() end
end

-- IMPORTANT: We use the same RemoteEvent both for pickup commands and to tell a client to disable effects.
local pickupEvent = ReplicatedStorage:FindFirstChild("PickupEvent")
if not pickupEvent then
	pickupEvent = Instance.new("RemoteEvent")
	pickupEvent.Name   = "PickupEvent"
	pickupEvent.Parent = ReplicatedStorage
end

-- Helper: Drop the held item for the given player.
local function dropHeldItem(player)
	local model = heldObjects[player]
	if model and model.Parent then
		local targetPart = nil
		if model:IsA("Model") and model.PrimaryPart then
			targetPart = model.PrimaryPart
		else
			targetPart = model
		end

		-- Fire a client event to disable visual effects on the UI.
		pickupEvent:FireClient(player, "DisableEffects")

		-- Destroy beam and attachments
		local beam = model:FindFirstChild("Beam")
		if beam then
			beam:Destroy()
		end
		local char = player.Character
		if char then
			local rightHand = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
			if rightHand then
				local handAttachment = rightHand:FindFirstChild("BeamAttachment_Hand")
				if handAttachment then
					handAttachment:Destroy()
				end
			end
		end
		local itemAttachment = targetPart:FindFirstChild("BeamAttachment_Item")
		if itemAttachment then
			itemAttachment:Destroy()
		end

		removePickupAlignments(model)
		if targetPart:IsA("BasePart") then
			targetPart:SetNetworkOwner(nil)
		end
		revertOwnerCollisionGroup(player)
		setCollisionGroupRecursive(model, "Default")

		local fixedRot = model:GetAttribute("FixedRotation")
		if fixedRot then
			if model.PrimaryPart then
				local pos = model.PrimaryPart.Position
				model:SetPrimaryPartCFrame(
					CFrame.new(pos) * CFrame.fromEulerAnglesXYZ(
						math.rad(fixedRot.X),
						math.rad(fixedRot.Y),
						math.rad(fixedRot.Z)
					)
				)
			elseif targetPart:IsA("BasePart") then
				targetPart.Orientation = fixedRot
			end
		end

		-- Disable blade damage.
		model:SetAttribute("BladeActive", false)
	end
	heldObjects[player] = nil
end

-- Player setup.
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		setCollisionGroupRecursive(character, PLAYERS_GROUP)
		character.DescendantAdded:Connect(function(desc)
			if desc:IsA("BasePart") and not desc:FindFirstAncestorWhichIsA("Tool") then
				desc.CollisionGroup = PLAYERS_GROUP
			end
		end)
		local humanoid = character:FindFirstChildWhichIsA("Humanoid")
		if humanoid then
			humanoid.Died:Connect(function()
				-- Immediately drop the held item on death.
				dropHeldItem(player)
			end)
		end
	end)
	player.CharacterRemoving:Connect(function(character)
		dropHeldItem(player)
	end)
end)

-- Helper: Returns the model and the primary part from a clicked part.
local function getModelAndPrimary(clickedPart)
	local model = clickedPart:FindFirstAncestorOfClass("Model")
	if model then
		if model.PrimaryPart then
			return model, model.PrimaryPart
		else
			return model, clickedPart
		end
	else
		return nil, clickedPart
	end
end

local function onPickup(player, action, item)
	if action == "Pickup" then
		-- Prevent pickup if already holding an item OR if the player is dead.
		if not item or heldObjects[player] then
			return
		end
		if not player.Character then return end
		local humanoid = player.Character:FindFirstChildWhichIsA("Humanoid")
		if not humanoid or humanoid.Health <= 0 then
			return  -- Do not allow pickups if the player is dead.
		end

		local model, targetPart = getModelAndPrimary(item)
		if not model then
			model = item
			targetPart = item
		end

		if model:FindFirstChild("DamageAppliedFlag") then
			model.DamageAppliedFlag:Destroy()
		end

		modelBladeCooldown[model] = {}
		model:SetAttribute("IsThrown", false)
		if model:GetAttribute("Blade") then
			model:SetAttribute("BladeActive", true)
		end
		model:SetAttribute("Owner", player.UserId)
		heldObjects[player] = model

		-- Change the player's collision group to a unique one.
		assignOwnerCollisionGroup(player)
		-- Set the held item into the HELD_ITEM_GROUP.
		setCollisionGroupRecursive(model, HELD_ITEM_GROUP)

		if targetPart:IsA("BasePart") then
			targetPart:SetNetworkOwner(player)
		end

		-- Create pickup alignment objects.
		local alignPos = Instance.new("AlignPosition", item)
		alignPos.Name = "PickupAlignPosition"
		alignPos.MaxForce = 1e5
		alignPos.Responsiveness = 50

		local alignOri = Instance.new("AlignOrientation", item)
		alignOri.Name = "PickupAlignOrientation"
		alignOri.MaxAngularVelocity = 100
		alignOri.Responsiveness = 50

		local itemAttachment = Instance.new("Attachment", item)
		itemAttachment.Name = "PickupAttachment_Item"

		local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			local hrpAttachment = Instance.new("Attachment")
			hrpAttachment.Name = "PickupAttachment_HRP"
			hrpAttachment.Parent = hrp
			hrpAttachment.Position = Vector3.new(0, 0, -5)

			alignPos.Attachment0 = itemAttachment
			alignPos.Attachment1 = hrpAttachment
			alignOri.Attachment0 = itemAttachment
			alignOri.Attachment1 = hrpAttachment

			hrpAttachment.AncestryChanged:Connect(function(_, parent)
				if not parent then
					hrpAttachment:Destroy()
				end
			end)
		end

		-- Create beam on server side.
		local char = player.Character
		if char then
			local rightHand = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
			if rightHand then
				local handAttachment = Instance.new("Attachment")
				handAttachment.Name = "BeamAttachment_Hand"
				handAttachment.Parent = rightHand
				handAttachment.Position = Vector3.new(0, 0, 0)

				local itemBeamAttachment = Instance.new("Attachment")
				itemBeamAttachment.Name = "BeamAttachment_Item"
				itemBeamAttachment.Parent = targetPart
				itemBeamAttachment.Position = Vector3.new(0, 0, 0)

				local beam = Instance.new("Beam")
				beam.Attachment0 = handAttachment
				beam.Attachment1 = itemBeamAttachment
				beam.Color = ColorSequence.new(Color3.new(1, 0.97, 0.61))
				beam.Width0 = 0.1
				beam.Width1 = 0.5
				beam.FaceCamera = true
				beam.Parent = model
			end
		end

		-- Blade damage connection.
		local bladeDamage = model:GetAttribute("Blade")
		if bladeDamage then
			for _, part in ipairs(model:GetDescendants()) do
				if part:IsA("BasePart") then
					part.Touched:Connect(function(hit)
						if not model:GetAttribute("BladeActive") then return end
						if model:GetAttribute("IsThrown") then return end

						local hitModel = hit.Parent
						if not hitModel then return end
						local hitHumanoid = hitModel:FindFirstChildWhichIsA("Humanoid")
						if not hitHumanoid then return end

						local ownerId = model:GetAttribute("Owner")
						if ownerId and isSelfDamage(ownerId, hitModel) then return end

						local currentTime = tick()
						local cooldowns = modelBladeCooldown[model]
						if cooldowns[hitHumanoid] and (currentTime - cooldowns[hitHumanoid] < DAMAGE_COOLDOWN) then
							return
						end

						cooldowns[hitHumanoid] = currentTime
						hitHumanoid:TakeDamage(bladeDamage)
					end)
				end
			end
		end

	elseif action == "Drop" then
		if not item then
			return
		end

		local model, targetPart = getModelAndPrimary(item)
		if not model then
			model = item
			targetPart = item
		end

		-- Destroy beam and attachments.
		local beam = model:FindFirstChild("Beam")
		if beam then
			beam:Destroy()
		end
		local char = player.Character
		if char then
			local rightHand = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
			if rightHand then
				local handAttachment = rightHand:FindFirstChild("BeamAttachment_Hand")
				if handAttachment then
					handAttachment:Destroy()
				end
			end
		end
		local itemAttachment = targetPart:FindFirstChild("BeamAttachment_Item")
		if itemAttachment then
			itemAttachment:Destroy()
		end

		removePickupAlignments(model)
		heldObjects[player] = nil

		if targetPart:IsA("BasePart") then
			targetPart:SetNetworkOwner(nil)
		end

		local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			local camAtt = hrp:FindFirstChild("PickupAttachment_HRP")
			if camAtt then
				camAtt:Destroy()
			end
		end

		revertOwnerCollisionGroup(player)
		setCollisionGroupRecursive(model, "Default")

		local fixedRot = model:GetAttribute("FixedRotation")
		if fixedRot then
			if model.PrimaryPart then
				local pos = model.PrimaryPart.Position
				model:SetPrimaryPartCFrame(
					CFrame.new(pos) * CFrame.fromEulerAnglesXYZ(
						math.rad(fixedRot.X),
						math.rad(fixedRot.Y),
						math.rad(fixedRot.Z)
					)
				)
			elseif targetPart:IsA("BasePart") then
				targetPart.Orientation = fixedRot
			end
		end

		model:SetAttribute("BladeActive", false)

	elseif action == "Throw" then
		if not item or not heldObjects[player] then
			return
		end

		local model = heldObjects[player]
		model:SetAttribute("IsThrown", true)
		local ownerId = model:GetAttribute("Owner")
		local targetPart

		if model:IsA("Model") and model.PrimaryPart then
			targetPart = model.PrimaryPart
		else
			targetPart = item
		end

		-- Destroy beam and attachments.
		local beam = model:FindFirstChild("Beam")
		if beam then
			beam:Destroy()
		end
		local char = player.Character
		if char then
			local rightHand = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
			if rightHand then
				local handAttachment = rightHand:FindFirstChild("BeamAttachment_Hand")
				if handAttachment then
					handAttachment:Destroy()
				end
			end
		end
		local itemAttachment = targetPart:FindFirstChild("BeamAttachment_Item")
		if itemAttachment then
			itemAttachment:Destroy()
		end

		local alignPos = targetPart:FindFirstChild("PickupAlignPosition")
		local alignOri = targetPart:FindFirstChild("PickupAlignOrientation")
		if alignPos then alignPos:Destroy() end
		if alignOri then alignOri:Destroy() end

		heldObjects[player] = nil

		if targetPart:IsA("BasePart") then
			targetPart:SetNetworkOwner(nil)
		end

		local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			local camAtt = hrp:FindFirstChild("PickupAttachment_HRP")
			if camAtt then
				camAtt:Destroy()
			end
		end

		revertOwnerCollisionGroup(player)
		setCollisionGroupRecursive(model, "Default")

		local throwDist = tonumber(model:GetAttribute("ThrowDistance")) or 65
		local thrownDamage = tonumber(model:GetAttribute("ThrowDamage")) or 0

		if hrp and model.PrimaryPart then
			model.PrimaryPart.Velocity = hrp.CFrame.LookVector * throwDist
		end

		local damaged = {}
		local throwConnections = {}

		local function disconnectAll()
			for _, conn in pairs(throwConnections) do
				if conn and conn.Disconnect then
					conn:Disconnect()
				end
			end
			throwConnections = {}
		end

		delay(1, disconnectAll)

		local function onHit(hit)
			local hitModel = hit.Parent
			if not hitModel then return end
			local hitHumanoid = hitModel:FindFirstChildWhichIsA("Humanoid")
			if not hitHumanoid then return end
			if ownerId and isSelfDamage(ownerId, hitModel) then return end
			if damaged[hitHumanoid] then return end
			damaged[hitHumanoid] = true
			hitHumanoid:TakeDamage(thrownDamage)
		end

		for _, part in ipairs(model:GetDescendants()) do
			if part:IsA("BasePart") then
				local conn = part.Touched:Connect(onHit)
				table.insert(throwConnections, conn)
			end
		end

		model:SetAttribute("BladeActive", false)

	elseif action == "Consume" then
		-- Retrieve the model from the passed item.
		local model, _ = getModelAndPrimary(item)
		-- Verify that the held object for this player matches this model.
		if not model or heldObjects[player] ~= model then
			return
		end
		local healthValue = model:GetAttribute("Health")
		if not healthValue then
			return
		end
		local humanoid = player.Character and player.Character:FindFirstChildWhichIsA("Humanoid")
		if humanoid then
			-- Heal the player. Example: add 20 health (or whatever the value is).
			humanoid.Health = math.min(humanoid.Health + healthValue, humanoid.MaxHealth)
		end
		-- Clean up alignments and beam.
		removePickupAlignments(model)
		local beam = model:FindFirstChild("Beam")
		if beam then
			beam:Destroy()
		end
		local char = player.Character
		if char then
			local rightHand = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
			if rightHand then
				local handAttachment = rightHand:FindFirstChild("BeamAttachment_Hand")
				if handAttachment then
					handAttachment:Destroy()
				end
			end
		end
		local itemAttachment = model:FindFirstChild("BeamAttachment_Item")
		if itemAttachment then
			itemAttachment:Destroy()
		end
		-- Revert collision groups.
		revertOwnerCollisionGroup(player)
		setCollisionGroupRecursive(model, "Default")
		-- Destroy the model (consumed item).
		model:Destroy()
		heldObjects[player] = nil
		-- Fire client event to disable effects.
		pickupEvent:FireClient(player, "DisableEffects")
	end
end

pickupEvent.OnServerEvent:Connect(onPickup)
]]",
                       ["ServerScriptService.ServerStartup(Script)"] = "[[local players = game.Players

players.PlayerAdded:Connect(function(plr)
	local leaderstats = Instance.new("Folder", plr)
	leaderstats.Name = "leaderstats"
	local Orbs = Instance.new("IntValue", leaderstats)
	Orbs.Name = "Orbs"
end)]]",
                       ["ServerScriptService.VoteHandler(Script)"] = "[[-- MapVoteServer.lua (in ServerScriptService)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local allMaps = {"cave", "classic", "dune", "lab?", "mountain"}
local mapVoteEvent = ReplicatedStorage:WaitForChild("VoteEvent")
local mapVoteResults = ReplicatedStorage:WaitForChild("VoteResults")
local voteUpdateEvent = ReplicatedStorage:WaitForChild("VoteUpdate")
local showVote = ReplicatedStorage:WaitForChild("ShowVoteGui")

local votes = {}
local votedPlayers = {}

local function pickThree()
	local pool = {unpack(allMaps)}
	local chosen = {}
	for i = 1, 3 do
		local idx = math.random(#pool)
		table.insert(chosen, table.remove(pool, idx))
	end
	return chosen
end

local function startVoteRound()
	local choices = pickThree()
	votes = {}
	votedPlayers = {}

	for _, mapName in ipairs(choices) do
		votes[mapName] = 0
	end

	showVote:FireAllClients(choices)

	local voteConnection
	voteConnection = mapVoteEvent.OnServerEvent:Connect(function(player, mapName)
		print(player.Name.." voted "..mapName)
		if votedPlayers[player] or not votes[mapName] then return end
		votedPlayers[player] = true
		votes[mapName] += 1
		voteUpdateEvent:FireAllClients(votes)
	end)

	task.wait(15 + 1) --we add one second for latency
	voteConnection:Disconnect()

	local winningMap
	local mostVotes = -1
	for mapName, count in pairs(votes) do
		if count > mostVotes then
			mostVotes = count
			winningMap = mapName
		end
	end

	mapVoteResults:FireAllClients(winningMap)
	print("Winning map:", winningMap)
end

wait(5)

-- Trigger it once for now
startVoteRound()]]"
                    },
                    ["StarterGui"] =  ▼  {
                       ["StarterGui.Bobbing Camera(LocalScript)"] = "[[local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()
local Camera = game:GetService("Workspace").CurrentCamera
local UserInputService = game:GetService("UserInputService")
local Humanoid = Player.Character:WaitForChild("Humanoid")
local bobbing = nil
local func1 = 0
local func2 = 0
local func3 = 0
local func4 = 0
local val = 0
local val2 = 0
local int = 3
local int2 = 5
local vect3 = Vector3.new()




function lerp(a, b, c)
	return a + (b - a) * c
end

bobbing = game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
	deltaTime = deltaTime * 30
	if Humanoid.Health <= 0 then
		bobbing:Disconnect()
		return
	end
	local rootMagnitude = Humanoid.RootPart and Vector3.new(Humanoid.RootPart.Velocity.X, 0, Humanoid.RootPart.Velocity.Z).Magnitude or 0
	local calcRootMagnitude = math.min(rootMagnitude, 25)
	if deltaTime > 1.5 then
		func1 = 0
		func2 = 0
	else
		func1 = lerp(func1, math.cos(tick() * 0.5 * math.random(5, 7.5)) * (math.random(2.5, 10) / 100) * deltaTime, 0.05 * deltaTime)
		func2 = lerp(func2, math.cos(tick() * 0.5 * math.random(2.5, 5)) * (math.random(1, 5) / 100) * deltaTime, 0.05 * deltaTime)
	end
	Camera.CFrame = Camera.CFrame * (CFrame.fromEulerAnglesXYZ(0, 0, math.rad(func3)) * CFrame.fromEulerAnglesXYZ(math.rad(func4 * deltaTime), math.rad(val * deltaTime), val2) * CFrame.Angles(0, 0, math.rad(func4 * deltaTime * (calcRootMagnitude / 5))) * CFrame.fromEulerAnglesXYZ(math.rad(func1), math.rad(func2), math.rad(func2 * 10)))
	val2 = math.clamp(lerp(val2, -Camera.CFrame:VectorToObjectSpace((Humanoid.RootPart and Humanoid.RootPart.Velocity or Vector3.new()) / math.max(Humanoid.WalkSpeed, 0.01)).X * 0.04, 0.1 * deltaTime), -0.12, 0.1)
	func3 = lerp(func3, math.clamp(UserInputService:GetMouseDelta().X, -2.5, 2.5), 0.25 * deltaTime)
	func4 = lerp(func4, math.sin(tick() * int) / 5 * math.min(1, int2 / 10), 0.25 * deltaTime)
	if rootMagnitude > 1 then
		val = lerp(val, math.cos(tick() * 0.5 * math.floor(int)) * (int / 200), 0.25 * deltaTime)
	else
		val = lerp(val, 0, 0.05 * deltaTime)
	end
	if rootMagnitude > 6 then
		int = 10
		int2 = 9
	elseif rootMagnitude > 0.1 then
		int = 6
		int2 = 7
	else
		int2 = 0
	end
	Player.CameraMaxZoomDistance = 128
	Player.CameraMinZoomDistance = 0.5
	vect3 = lerp(vect3, Camera.CFrame.LookVector, 0.125 * deltaTime)
end)]]",
                       ["StarterGui.GUI.Screen.CrateInformationFrame.Frame2.MainFrame.ScrollingFrames.HatsCrateScrollingFrame.MythicItem.RainbowScript(LocalScript)"] = "[[local RunService = game:GetService("RunService")

-- Manually add your UIGradient objects here.
-- For example, if you have two gradients named "UIGradient1" and "UIGradient2"
-- under the same parent, add them like this:
local gradients = {
	script.Parent:WaitForChild("ChanceLabel").UIGradient,
	script.Parent:WaitForChild("ItemNameLabel").UIGradient,
	-- Add more gradients manually here—each reference is explicit.
}

---------------------------------------------
-- Rainbow Colors and Transition Parameters --
---------------------------------------------
local rainbowColors = {
	Color3.fromRGB(255, 0, 0),      -- Red
	Color3.fromRGB(255, 127, 0),    -- Orange
	Color3.fromRGB(255, 255, 0),    -- Yellow
	Color3.fromRGB(0, 255, 0),      -- Green
	Color3.fromRGB(0, 255, 255),    -- Cyan
	Color3.fromRGB(0, 0, 255),      -- Blue
	Color3.fromRGB(119, 0, 255),    -- Pink
	Color3.fromRGB(213, 87, 255)    -- Indigo
}
local transitionDuration = 1  -- Duration (in seconds) for each color transition.
local currentIndex = 1
local nextIndex = 2
local elapsed = 0

--------------------------------------------------
-- Helper: Interpolate two colors in HSV space --
--------------------------------------------------
local function lerpHSV(color1, color2, alpha)
	local h1, s1, v1 = color1:ToHSV()
	local h2, s2, v2 = color2:ToHSV()

	-- Handle the wrap-around for hue for smooth transitions.
	local dh = h2 - h1
	if math.abs(dh) > 0.5 then
		if h1 > h2 then
			h2 = h2 + 1
		else
			h1 = h1 + 1
		end
	end

	local h = (h1 + (h2 - h1) * alpha) % 1
	local s = s1 + (s2 - s1) * alpha
	local v = v1 + (v2 - v1) * alpha

	return Color3.fromHSV(h, s, v)
end

------------------------------
-- Animation Loop --
------------------------------
RunService.RenderStepped:Connect(function(delta)
	elapsed = elapsed + delta
	local alpha = elapsed / transitionDuration
	if alpha >= 1 then
		-- Transition complete; move to the next pair in the rainbow.
		elapsed = elapsed - transitionDuration
		currentIndex = nextIndex
		nextIndex = (nextIndex % #rainbowColors) + 1
		alpha = elapsed / transitionDuration
	end

	local currentColor = lerpHSV(rainbowColors[currentIndex], rainbowColors[nextIndex], alpha)
	local sequence = ColorSequence.new(currentColor, currentColor)  -- Uniform gradient.

	for _, gradient in ipairs(gradients) do
		gradient.Color = sequence
	end
end)

]]",
                       ["StarterGui.GUI.Screen.GameFrame.CurrencyFrame.TextLabel.LocalScript(LocalScript)"] = "[[while wait() do
	script.Parent.Text = require(game.ReplicatedStorage.Assets.Modules:WaitForChild("OrbsEZ")).GetOrbs(game.Players.LocalPlayer)
end]]",
                       ["StarterGui.GUI.Screen.MapChoiceFrame.LocalScript(LocalScript)"] = "[[-- Services
local Players          = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Player & RemoteEvents
local player          = Players.LocalPlayer
local voteEvent       = ReplicatedStorage:WaitForChild("VoteEvent")
local updateEvent     = ReplicatedStorage:WaitForChild("VoteUpdate")

-- The Frame template in ReplicatedStorage
local indicatorTmpl   = ReplicatedStorage:WaitForChild("PlayerVote")

-- GUI References
local scaleFrame = script.Parent:WaitForChild("ScaleFrame")

-- Gather MapSlot frames
local slots = {}
for i = 1, 3 do
	local slot = scaleFrame:FindFirstChild("MapSlot"..i)
	if slot then table.insert(slots, slot) end
end

-- Helper: remove any existing indicator from all buttons
local function clearIndicators()
	for _, slot in ipairs(slots) do
		local btn = slot:FindFirstChild("Button")
		if btn then
			local old = btn:FindFirstChild("PlayerVote")
			if old then old:Destroy() end
		end
	end
end

-- 1) Handle Player Clicks
for _, slot in ipairs(slots) do
	local button     = slot:WaitForChild("Button")
	local nameLabel  = button:WaitForChild("MapName")

	button.MouseButton1Click:Connect(function()
		print("[VOTE] Button clicked!") 
		local template = indicatorTmpl
		print("[VOTE] Found template:", template, "Size:", template.Size)
		local clone = template:Clone()
		print("[VOTE] Cloned indicator:", clone, "Before Parent:", clone.Parent)
		clone.Parent = button
		print("[VOTE] After Parent:", clone.Parent, "Visible:", clone.Visible)
	end)


	button.MouseButton1Click:Connect(function()
		local chosenMap = nameLabel.Text

		-- a) Send vote request to server
		voteEvent:FireServer(chosenMap)

		-- b) Visually indicate the vote
		clearIndicators()
		local indicator = indicatorTmpl:Clone()
		indicator.Parent  = button
		indicator.Visible = true
	end)
end

-- 2) Update vote counts when server broadcasts
updateEvent.OnClientEvent:Connect(function(counts)
	for _, slot in ipairs(slots) do
		local button     = slot:FindFirstChild("Button")
		local nameLabel  = button:FindFirstChild("MapName")
		local votesLabel = button:FindFirstChild("MapVotes")
		local count      = counts[nameLabel.Text] or 0

		votesLabel.Text = tostring(count)
	end
end)
]]",
                       ["StarterGui.GUI.Screen.ShopFrame.LocalScript(LocalScript)"] = "[[local Buttons = script.Parent.ButtonsFrame.Frame.MainFrame
local Scrolling = script.Parent.Frame2.MainFrame.ScrollingFrame.ScrollingFrame

function Moveto(e)
	local scrollingFrame = Scrolling -- Replace with your ScrollingFrame path
	local targetPosition = Vector2.new(0, e) -- Target scroll position (X, Y)

	-- Smoothly move the scrolling frame
	while scrollingFrame.CanvasPosition.Y < targetPosition.Y do
		scrollingFrame.CanvasPosition = scrollingFrame.CanvasPosition + Vector2.new(0, 30)
		wait(0.01) -- Adjust speed
	end
end

Buttons.CratesButton.Button.MouseButton1Down:Connect(function()
	Moveto(0)
end)
Buttons.CurrencyButton.Button.MouseButton1Down:Connect(function()
	Moveto(369)
end)
Buttons.GamePassesButton.Button.MouseButton1Down:Connect(function()
	Moveto(874)
end)
Buttons.LimitedTimeButton.Button.MouseButton1Down:Connect(function()
	Moveto(1200)
end)
Buttons.DailyShopButton.Button.MouseButton1Down:Connect(function()
	Moveto(1560)
end)

script.Parent.ExitButton.TextButton.MouseButton1Down:Connect(function()
	script.Parent.Visible = false
end)]]",
                       ["StarterGui.crosshair.crosshair(LocalScript)"] = "[[--// basic crosshair system with the dynamic crosshair module created by towphy
--// dev forum post --> https://devforum.roblox.com/t/create-dynamic-crosshairs-new-module/1925891

--// tutorial by polyhall

--//
local replicatedStorage = game:GetService("ReplicatedStorage")
local inputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local crosshairModule = require(replicatedStorage:WaitForChild("DynamicCrosshair"))

--//
local UI = script.Parent
local crosshair = crosshairModule.New(UI, 90, 20, 30, 80)

--//
local function init()
	crosshair:Enable()
	
	crosshair:Min(6) -- how small the crosshair can get
	crosshair:Max(25) -- how big the crosshair can get
end

--//
local function onClick() -- this is just for testing, add this code anywhere you like
	crosshair:SmoothSet(math.random(60, 90), 0.08) --// set the first value to any number, i did math.random() to get a cooler effect, you can replace that with just a single number.
	crosshair:Shove()
end

local function update(deltaTime)
	crosshair:Update(deltaTime)
end

--//
init()

--//
runService.RenderStepped:Connect(update)

inputService.InputBegan:Connect(function(key)
	if key.UserInputType == Enum.UserInputType.MouseButton1 then
		
		onClick()
		
	end
end)

if game.Players.LocalPlayer.Name ~= "Haktan0001" then
	inputService.MouseIconEnabled = false
end]]"
                    }
                 }  -  Edit
