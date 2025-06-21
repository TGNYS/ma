local OrionLib =
loadstring(game:HttpGet("https://pastebin.com/raw/j9TdK86G"))()
local LBLG = Instance.new("ScreenGui", getParent)
local LBL = Instance.new("TextLabel", getParent)
local player = game.Players.LocalPlayer

LBLG.Name = "LBLG"
LBLG.Parent = game.CoreGui
LBLG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
LBLG.Enabled = true
LBL.Name = "LBL"
LBL.Parent = LBLG
LBL.BackgroundColor3 = Color3.new(1, 1, 1)
LBL.BackgroundTransparency = 1
LBL.BorderColor3 = Color3.new(0, 0, 0)
LBL.Position = UDim2.new(0.75,0,0.010,0)
LBL.Size = UDim2.new(0, 133, 0, 30)
LBL.Font = Enum.Font.GothamSemibold
LBL.Text = "TextLabel"
LBL.TextColor3 = Color3.new(1, 1, 1)
LBL.TextScaled = true
LBL.TextSize = 14
LBL.TextWrapped = true
LBL.Visible = true

local FpsLabel = LBL
local Heartbeat = game:GetService("RunService").Heartbeat
local LastIteration, Start
local FrameUpdateTable = { }

local function HeartbeatUpdate()
	LastIteration = tick()
	for Index = #FrameUpdateTable, 1, -1 do
		FrameUpdateTable[Index + 1] = (FrameUpdateTable[Index] >= LastIteration - 1) and FrameUpdateTable[Index] or nil
	end
	FrameUpdateTable[1] = LastIteration
	local CurrentFPS = (tick() - Start >= 1 and #FrameUpdateTable) or (#FrameUpdateTable / (tick() - Start))
	CurrentFPS = CurrentFPS - CurrentFPS % 1
	FpsLabel.Text = ("北京时间:"..os.date("%H").."时"..os.date("%M").."分"..os.date("%S"))
end
Start = tick()
Heartbeat:Connect(HeartbeatUpdate)
print("初始化成功✅")
print("脚本已运行")
print("测试阶段后果自负")

OrionLib:MakeNotification({
                    Name = "警告⚠", 
                    Content = "请勿去死铁轨服务器执行这个脚本",
                    Time = 10 -- 持续时间
                })    
                local sound = Instance.new("Sound", workspace)
sound.SoundId = "rbxassetid://4590662766"
sound:Play()
wait(1)

print("UI加载成功✅")
print("弹出(凡尘-UI)")

OrionLib:MakeNotification({
                    Name = "凡尘", 
                    Content = "欢迎使用凡尘脚本",
                    Time = 10 -- 持续时间
                })    
                local sound = Instance.new("Sound", workspace)
sound.SoundId = "rbxassetid://4590662766"
sound:Play()
wait(1)

print("弹出(凡尘脚本-欢迎使用凡尘脚本)")

OrionLib:MakeNotification({
                    Name = "凡尘脚本", 
                    Content = "防反挂机已自动启动",
                    Time = 10 -- 持续时间
                })    
                local sound = Instance.new("Sound", workspace)
sound.SoundId = "rbxassetid://4590662766"
sound:Play()
wait(1)
print("防反挂机✅")

print("弹出(凡尘脚本-防反挂机已自动启动)")

local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function()
    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

print("执行(防反挂机)")

OrionLib:MakeNotification({
                    Name = "凡尘脚本", 
                    Content = "你的注入器是:"..identifyexecutor(),
                    Time = 10 -- 持续时间
                })    
                local sound = Instance.new("Sound", workspace)
sound.SoundId = "rbxassetid://4590662766"
sound:Play()
wait(1)

print("弹出(凡尘脚本-你的注入器是)"..identifyexecutor())

OrionLib:MakeNotification({
                    Name = "凡尘脚本", 
                    Content = "你的用户名是:"..game.Players.LocalPlayer.Character.Name,
                    Time = 10 -- 持续时间
                })    
                local sound = Instance.new("Sound", workspace)
sound.SoundId = "rbxassetid://4590662766"
sound:Play()

print("弹出(凡尘脚本-你的用户名是)"..game.Players.LocalPlayer.Character.Name)

print("弹出(凡尘脚本-检测到你是高级版，需要入门版请前往3557736755)")

local Window = OrionLib:MakeWindow({Name = "凡尘脚本", HidePremium = false, SaveConfig = true,IntroText = "欢迎使用凡尘脚本", ConfigFolder = "123"})

print("脚本加载成功✅")
print("创建主UI(凡尘脚本-凡尘脚本-123)")

local announcement = Window:MakeTab({
    Name = "主页",
	Icon = "rbxassetid://7734068321",
	PremiumOnly = false
})
announcement:AddParagraph("作者","凡尘")
announcement:AddParagraph("版本","高级")
announcement:AddParagraph("警告","别去死铁轨执行这个脚本")
announcement:AddLabel("你的注入器:"..identifyexecutor())
announcement:AddLabel("你的用户名:"..game.Players.LocalPlayer.Character.Name)
announcement:AddLabel("你的客户端ID:"..game:GetService("RbxAnalyticsService"):GetClientId())
announcement:AddLabel("当前服务器ID:"..game.GameId)
announcement:AddLabel("你的账号年龄:"..game.Players.LocalPlayer.AccountAge)
announcement:AddLabel("你的账号ID:"..game.Players.LocalPlayer.UserId)
announcement:AddButton({
	Name = "QQ群56117318118点击复制",
	Callback = function()
print("执行(复制561173181)并弹出(复制成功-你已复制QQ群号)")
setclipboard("561173181")
OrionLib:MakeNotification({
                    Name = "复制成功", 
                    Content = "你已复制QQ群号",
                    Time = 10 -- 持续时间
                })    
                local sound = Instance.new("Sound", workspace)
sound.SoundId = "rbxassetid://4590662766"
sound:Play()
end
})    
announcement:AddButton({
	Name = "启动指令版空脚本",
	Callback = function()
print("执行(指令版空脚本)")
loadstring(game:HttpGet("https://pastebin.com/raw/UGnRD4xU"))()
end
})   

print("创建分类(announcement-主页)")

local TEST = Window:MakeTab({
    Name = "注入器/脚本/测试或调试",
	Icon = "rbxassetid://4483345998", -- roblox图片ID
	PremiumOnly = false
})
TEST:AddButton({
	Name = "打开F9(调试控制台)",
	Callback = function() -- 被调整值
    print("执行(打开F9(调试控制台))")
    game:GetService("StarterGui"):SetCore("DevConsoleVisible", true)
end
})    
TEST:AddButton({
	Name = "测试注入器等级键盘按F9查看",
	Callback = function()
    print("执行(测试注入器等级)")
    getgenv().printidentity = nil printidentity()
end
})   
TEST:AddButton({
	Name = "测试注入器UNC键盘按F9查看",
	Callback = function()
print("执行(测试注入器UNC)")
loadstring(game:HttpGet("https://pastebin.com/raw/aR4dJHGT"))()
end
})   

print("创建分类(TEST-注入器/脚本/测试或调试)")

local currency = Window:MakeTab({
    Name = "通用",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
currency:AddTextbox({
	Name = "移动速度",
	Default = "", -- 默认值
	TextDisappear = true,
	Callback = function(Value)
print("执行(修改移动速度)")
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
end
})
currency:AddTextbox({
	Name = "跳跃高度",
	Default = "", -- 默认值
	TextDisappear = true,
	Callback = function(Value)
print("执行(修改跳跃高度)")
game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
end
})
currency:AddTextbox({
	Name = "重力",
	Default = "", -- 默认值
	TextDisappear = true,
	Callback = function(Value)
print("执行(修改重力)")
game.Workspace.Gravity = Value
end
})
currency:AddToggle({
	Name = "夜视",
	Default = false,
	function GetBall()
    for v0, v1 in Ipairs(workspace. Balls: GetChildren() do
        it v1:GetAttribute("realBall") and v1:IsA("BasePart") then
             retum v1
          end
      end
end
game["Run Service"].Heartbeat: Connect(function()
local ball = GetBall()
local BallSpeed=ball.zoomies. VectorVelocity. Magnitude
local BallPos = ball.Position
local Distance game: GetService("Players").LocalPlayer: DistanceFromCharacter(BallPos)-12
local Time = Distance / BallSpeed
if Time <= 0.7 then
     game: GetService("VirtualinputManager"):SendMouseButtonEvent(0, 0， 0， true, game, 0)
end
end)
--Finish
    print("执行切换/预加载(夜视)")
	end
})