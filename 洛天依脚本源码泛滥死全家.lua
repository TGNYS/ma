
-- 创建加载界面
local LoadingGUI = Instance.new("ScreenGui")
LoadingGUI.Name = "LoadingScreen"
LoadingGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
LoadingGUI.Parent = game:GetService("CoreGui")

-- 全屏背景
local Background = Instance.new("Frame")
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
Background.BorderSizePixel = 0
Background.Parent = LoadingGUI

-- 加载容器
local Container = Instance.new("Frame")
Container.Size = UDim2.new(0, 300, 0, 200)
Container.Position = UDim2.new(0.5, 0, 0.5, 0)
Container.AnchorPoint = Vector2.new(0.5, 0.5)
Container.BackgroundTransparency = 1
Container.Parent = Background

-- 动态加载图标
local LoadingCircle = Instance.new("ImageLabel")
LoadingCircle.Image = "rbxassetid://3570695787"  -- 默认旋转图标
LoadingCircle.Size = UDim2.new(0, 80, 0, 80)
LoadingCircle.Position = UDim2.new(0.5, 0, 0.3, 0)
LoadingCircle.AnchorPoint = Vector2.new(0.5, 0.5)
LoadingCircle.BackgroundTransparency = 1
LoadingCircle.ImageColor3 = Color3.fromRGB(94, 234, 212)
LoadingCircle.Parent = Container

-- 旋转动画
local RotateTween = game:GetService("TweenService"):Create(
    LoadingCircle,
    TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
    {Rotation = 360}
)
RotateTween:Play()

-- 进度文本
local ProgressText = Instance.new("TextLabel")
ProgressText.Size = UDim2.new(1, 0, 0, 30)
ProgressText.Position = UDim2.new(0, 0, 0.6, 0)
ProgressText.BackgroundTransparency = 1
ProgressText.Font = Enum.Font.GothamBold
ProgressText.TextColor3 = Color3.fromRGB(255, 255, 255)
ProgressText.TextSize = 18
ProgressText.Text = "正在初始化H脚本..."
ProgressText.Parent = Container

-- 进度条
local ProgressBar = Instance.new("Frame")
ProgressBar.Size = UDim2.new(0.7, 0, 0, 4)
ProgressBar.Position = UDim2.new(0.15, 0, 0.8, 0)
ProgressBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ProgressBar.BorderSizePixel = 0
ProgressBar.Parent = Container

local ProgressFill = Instance.new("Frame")
ProgressFill.Size = UDim2.new(0, 0, 1, 0)
ProgressFill.BackgroundColor3 = Color3.fromRGB(94, 234, 212)
ProgressFill.BorderSizePixel = 0
ProgressFill.Parent = ProgressBar

-- 分阶段加载动画
local LoadSteps = {
    {text = "正在加载核心模块...", progress = 25},
    {text = "初始化用户界面...", progress = 50},
    {text = "验证功能完整性...", progress = 75},
    {text = "准备就绪！", progress = 100}
}

coroutine.wrap(function()
    for _, step in pairs(LoadSteps) do
        ProgressText.Text = step.text
        game:GetService("TweenService"):Create(
            ProgressFill,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad),
            {Size = UDim2.new(step.progress/100, 0, 1, 0)}
        ):Play()
        
        -- 添加粒子效果
        if step.progress == 100 then
            LoadingCircle.Image = "rbxassetid://3926305904"  -- 完成图标
            LoadingCircle.ImageColor3 = Color3.fromRGB(94, 234, 212)
            LoadingCircle.Rotation = 0
            RotateTween:Pause()
            
            -- 完成特效
            local particles = Instance.new("ParticleEmitter")
            particles.Color = ColorSequence.new(Color3.fromRGB(94, 234, 212))
            particles.Size = NumberSequence.new(0.5)
            particles.Lifetime = NumberRange.new(1)
            particles.Rate = 50
            particles.Speed = NumberRange.new(50)
            particles.Parent = LoadingCircle
            wait(1)
            particles:Destroy()
        end
        
        wait(1)  -- 每个阶段持续时间
    end
    
    -- 渐变退出
    game:GetService("TweenService"):Create(
        Background,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad),
        {BackgroundTransparency = 1}
    ):Play()
    wait(0.5)
    LoadingGUI:Destroy()
end)()
local function createAdaptiveWatermark()
    if game.CoreGui:FindFirstChild("洛天依_Watermark") then
        game.CoreGui.H_Watermark:Destroy()
    end


    local screenSize = workspace.CurrentCamera.ViewportSize

    local watermarkGui = Instance.new("ScreenGui")
    watermarkGui.Name = "洛天依_Watermark"
    watermarkGui.Parent = game.CoreGui
    watermarkGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    watermarkGui.ResetOnSpawn = false

    local watermarkText = Instance.new("TextLabel")
    watermarkText.Name = "WatermarkText"
    watermarkText.Parent = watermarkGui
    watermarkText.Text = "正式版洛天依脚本" 
    watermarkText.TextColor3 = Color3.fromRGB(255, 255, 255)
    watermarkText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    watermarkText.TextStrokeTransparency = 0.3 
    watermarkText.Font = Enum.Font.GothamBold 
    watermarkText.TextSize = math.floor(screenSize.Y * 0.02)
    watermarkText.BackgroundTransparency = 1 
    watermarkText.AnchorPoint = Vector2.new(1, 0) 
    watermarkText.Position = UDim2.new(1, -10, 0, 10) 
    watermarkText.TextXAlignment = Enum.TextXAlignment.Right 

    watermarkText.Size = UDim2.new(0, watermarkText.TextBounds.X + 20, 0, watermarkText.TextBounds.Y + 10)

    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        screenSize = workspace.CurrentCamera.ViewportSize
        watermarkText.TextSize = math.floor(screenSize.Y * 0.02)
        watermarkText.Size = UDim2.new(0, watermarkText.TextBounds.X + 20, 0, watermarkText.TextBounds.Y + 10)
    end)
end

createAdaptiveWatermark()

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

game:GetService("StarterGui"):SetCore("SendNotification",{ Title = "洛天依脚本加载1"; Text ="爱你😘"; Duration = 2; })wait("3")

game:GetService("StarterGui"):SetCore("SendNotification",{ Title = "洛天依脚本加载2"; Text ="每天更新"; Duration = 2; })wait("3")

game:GetService("StarterGui"):SetCore("SendNotification",{ Title = "洛天依脚本加载完毕"; Text ="更新使用脚本"; Duration = 2; })wait("3")

game:GetService("StarterGui"):SetCore("SendNotification",{ Title = "H脚本"; Text ="载入成功"; Duration = 2; })

local function HeartbeatUpdate()
	LastIteration = tick()
	for Index = #FrameUpdateTable, 1, -1 do
		FrameUpdateTable[Index + 1] = (FrameUpdateTable[Index] >= LastIteration - 1) and FrameUpdateTable[Index] or nil
	end
	FrameUpdateTable[1] = LastIteration
	local CurrentFPS = (tick() - Start >= 1 and #FrameUpdateTable) or (#FrameUpdateTable / (tick() - Start))
	CurrentFPS = CurrentFPS - CurrentFPS % 1
	FpsLabel.Text = ("现在时间:"..os.date("%H").."时"..os.date("%M").."分"..os.date("%S"))
end
Start = tick()
Heartbeat:Connect(HeartbeatUpdate)

local playerGui = game.Players.LocalPlayer.PlayerGui 
  
 local fpsGui = Instance.new("ScreenGui") 
 fpsGui.Name = "FpsGui" 
 fpsGui.Parent = playerGui 
  
 local fpsLabel = Instance.new("TextLabel") 
 fpsLabel.Name = "FpsLabel" 
 fpsLabel.Size = UDim2.new(0, 100, 0, 20) 
 fpsLabel.Position = UDim2.new(0, 20, 0, 20) 
 fpsLabel.BackgroundColor3 = Color3.new(0, 0, 0) 
 fpsLabel.TextColor3 = Color3.new(1, 1, 1) 
 fpsLabel.Font = Enum.Font.SourceSans 
 fpsLabel.FontSize = Enum.FontSize.Size14 
 fpsLabel.Text = "帧数: " 
 fpsLabel.Parent = fpsGui 
  
 local lastUpdate = tick() 
  
 local fps = 0 
  
 local function updateFpsCounter() 
     local deltaTime = tick() - lastUpdate 
     lastUpdate = tick() 
  
     fps = math.floor(1 / deltaTime) 
  
     fpsLabel.Text = "帧数: " .. fps 
 end 
  
 game:GetService("RunService").RenderStepped:Connect(updateFpsCounter) 

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/renlua/UI-lib/refs/heads/main/AL_V3"))()
local win = library:new("洛天依脚本")
--
local UITab1 = win:Tab("信息",'16060333448')

local about = UITab1:section("作者信息",false)

about:Label("由AUG脚本正式改名叫洛天依脚本")
about:Label("洛天依制作")
about:Label("每星期天星期六一定更新")
about:Label("此脚本是测试的有bug告诉洛天依")
about:Label("感谢游玩")

local UITab3 = win:Tab("脚本版本",'16060333448')

local about = UITab3:section("脚本版本",true)

about:Label("您的脚本为测试版V4.0")
about:Label("支持10多个服务器")

local about = UITab1:section("你的信息",false)

about:Label("你的注入器:"..identifyexecutor())
about:Label("你的账号年龄:"..player.AccountAge.."天")
about:Label("你的注入器:"..identifyexecutor())
about:Label("你的用户名:"..game.Players.LocalPlayer.Character.Name)
about:Label("你现在的服务器名称:"..game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
about:Label("你现在的服务器id:"..game.GameId)
about:Label("你的用户ID:"..game.Players.LocalPlayer.UserId)
about:Label("获取客户端ID:"..game:GetService("RbxAnalyticsService"):GetClientId())
about:Toggle("脚本框架变小一点", "", false, function(state)
        if state then
        game:GetService("CoreGui")["frosty"].Main.Style = "DropShadow"
        else
            game:GetService("CoreGui")["frosty"].Main.Style = "Custom"
        end
    end)
    about:Button("关闭脚本",function()
        game:GetService("CoreGui")["frosty"]:Destroy()
    end)
    
about:Label("洛天依脚本")
about:Label("作者QQ：为什么要告诉你")
about:Button("点击复作者QQ群",function()
setclipboard("149437754")
end)

local UITab4 = win:Tab("『加入服务器』",'16060333448')

local about = UITab4:section("『LENG Script』",false)

about:Button("加入极速传奇",function()
local game_id = 3101667897
        local game_url = "https://www.roblox.com/games/"..game_id
        game:GetService("TeleportService"):Teleport(game_id, game.Players.LocalPlayer)
end)

about:Button("加入鲨口生求2",function()
local game_id = 8908228901
        local game_url = "https://www.roblox.com/games/"..game_id
        game:GetService("TeleportService"):Teleport(game_id, game.Players.LocalPlayer)
end)

about:Button("加入监狱人生",function()
local game_id = 155615604
        local game