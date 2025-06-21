local RunService = game:GetService("RunService")
local LocalPlayer = game.Players.LocalPlayer
local remotes = game.ReplicatedStorage.Remotes
local rng = Random.new()
local mouse = LocalPlayer:GetMouse()

function Notify(title, text, duration)
	game.StarterGui:SetCore("SendNotification", {
		Title = title,
		Text = text,
		Duration = duration or 0,
	})
end

function isInvis(character)
	if not character
		or not character:FindFirstChild("Torso")
		or standoff
	then
		return false
	end
	return character.Torso.Transparency > 0
end

function isOthersInvis()
	for _, alive in workspace.Alive:GetChildren() do
		if isTeammate(alive, localChar) then continue end
		if alive == localChar then continue end
		if not isInvis(alive) then
			return false
		end
	end

	return true
end

function getTeamColor3(character)
	local icon = character:FindFirstChild("Head") and character.Head:FindFirstChild("Chevron")
	return icon
		and icon.ImageLabel.ImageColor3
end

function isTeammate(character0, character1)
	local color0, color1 = getTeamColor3(character0), getTeamColor3(character1)

	if color0 and color1 then
		return color0 == color1
	end

	return false
end

function getPositionWithVelocity(pv, step)
	local position = pv:GetPivot()
	local velocity = pv:IsA("Model") and pv.PrimaryPart.Velocity or pv.Velocity

	return (position + velocity * (step or (1 / 60))).Position
end

do
	local attemptRE = game.AdService:FindFirstChildOfClass("RemoteEvent")
		or game.SocialService:FindFirstChildOfClass("RemoteEvent")
		or remotes:WaitForChild("ParryAttempt")

	local VECTOR = -Vector3.new(math.huge, math.huge, math.huge)
	local TARGET_VECTOR = Vector3.new(0, 0, 0)
	local ARRAY = {0, 0}
	local FAKE_DRIBBLE_ARRAY = {}

	function Parry(target, deflection, doFakeDribble)
		local characterPositions = {}

		for _, v in ipairs(workspace.Alive:GetChildren()) do
			if v ~= target then
				characterPositions[v.Name] = VECTOR
			else
				characterPositions[v.Name] = TARGET_VECTOR
			end
		end

		attemptRE:FireServer(0, deflection.Rotation, characterPositions, not doFakeDribble and ARRAY or FAKE_DRIBBLE_ARRAY)
	end
	function getParryRE()
		return attemptRE
	end
end

function ping()
	return LocalPlayer:GetNetworkPing()
end

local AntiAbilityRemoteFunctions = {
	Freeze = function(self, ball, frozen)
		if ball ~= self.ball then return end
		if frozen then
			self.delay = 5 + time()
		else
			self.delay = nil
		end
	end,
	UseContinuityPortal = function(self, character, teleportCFrame, ball)
		if ball ~= self.ball then return end
		task.delay(0.65, function()
			self.portalCFrame = teleportCFrame
		end)
		task.delay(2, function()
			self.portalCFrame = nil
		end)
	end,
	PlrMartyrEffects = function(self, character0, character1, thawSec)
		if character0 ~= self.currentTarget then return end
		self.delay = (thawSec - 0.325) + time()
		self.maxVelocity = 250
		task.delay(thawSec + 1, function()
			self.maxVelocity = 0
		end)
	end,
	PlrEventSingularity = function(self, launcher)
		self.delay = 4 + time()
	end,
}

local SupportedAntiAbilityRemotes = {}
for _, remote in remotes:GetChildren() do
	if AntiAbilityRemoteFunctions[remote.Name] ~= nil then
		table.insert(SupportedAntiAbilityRemotes, remote)
	end
end

local AntiAbilityInstancesFunctions = {
	AeroDynamicSlashVFX = function(self, child)
		self.delay = 0.05 + time()
		self.maxVelocity *= 3.8
		Notify("Detected", "Aerodynamic", 1)

		local s = time()

		task.spawn(function()
			while child.Parent and self.velocity.Y < 200 and time() - s < 1.6 do
				self.delay += RunService.Heartbeat:Wait()
			end
			self.maxVelocity = 0
			Notify("Detected", "Aerodynamic " .. time() - s , 1)
		end)
	end,
	At2 = function(self)
		-- Telekinesis
		self.delay = 1.7 + time()
		-- self.maxVelocity *= 1.75
		Notify("Detected", "Telekinesis", 1)
		local s = time()
		task.spawn(function()
			task.wait(0.1)
			repeat
				RunService.Heartbeat:Wait()
			until self.velocity.Magnitude ~= 0 or not self.ball.Parent
			Notify("Detected", "Telekinesis " .. time() - s, 1)
			self.delay = nil
			self.maxVelocity = 0
		end)
	end,
	CLONE_ATTACHMENT = function(self)
		-- Slashes of Fury
		-- 35 slashes
		-- this is untested
		Notify("Detected", "Slashes of Fury", 1)

		local count = 0
		local lastParryTime = time()

		self.manualSpamming = true
		self.delay = 1 + time()

		local parryConnection = remotes.ParrySuccessAll.OnClientEvent:Connect(function(_, hrp)
			count += 1
			lastParryTime = time()
			self.maxVelocity += 50
			self.delay += 1
		end)

		repeat
			task.wait()
		until count >= 33 or time() - lastParryTime > 1

		self.maxVelocity = 0
		self.delay = nil
		self.manualSpamming = nil
		parryConnection:Disconnect()
	end,
}

local Blocker = {}
Blocker.__index = Blocker

function Blocker.new(ball)
	return setmetatable({
		ball = ball;
		zoomies = ball:WaitForChild("zoomies");
		velocity = Vector3.zero;
		maxVelocity = 0;
		reachTime = math.huge;
		timeToParry = 0.65;
		maxTimeToParry = 0;
		maxTimeToMove = 0;
		parryRate = math.huge;
		manualSpamming = manualspamming;

		vis = {
			text = Drawing.new("Text");
			targetHighlight = Instance.new("Highlight");
		};

		_connections = {};
		_tasks = {};
		_coroutines = {};
	}, Blocker)
end

function Blocker:Init()
	self.ball.Transparency = 0
	self.ball:SetAttribute("server", true)

	self.vis.targetHighlight.FillTransparency = 0.5
	self.vis.targetHighlight.FillColor = Color3.new(1, 1, 0)
	self.vis.targetHighlight.OutlineColor = Color3.new(1, 1, 1)
	self.vis.targetHighlight.OutlineTransparency = 0
	self.vis.targetHighlight.Parent = game.CoreGui

	self.vis.text.Outline = true
	self.vis.text.OutlineColor = Color3.new(0, 0, 0)
	self.vis.text.Color = Color3.new(1, 1, 1)
	self.vis.text.Center = false
	self.vis.text.Position = Vector2.new(50, 50)
	self.vis.text.Text = ""
	self.vis.text.Visible = true

	self:_insert(RunService.PostSimulation:Connect(function(delta)
		self.realVelocity = self.ball.AssemblyLinearVelocity
		self.velocity = self.zoomies.VectorVelocity

		localPos = localRoot.Position
		local selfToBall = localPos - self.ball.Position

		self.distance = not self.portalCFrame and selfToBall.Magnitude or (localPos - self.portalCFrame.Position).Magnitude

		if not self.delay and not self.spamming then
			self.maxVelocity = math.max(self.maxVelocity, self.velocity.Magnitude)
		end

		if self.lastTarget and self.lastTarget ~= localChar and (self.lastTarget:GetPivot().Position - localPos).Magnitude < 25 then
			self.pointing = 1
		else
			self.pointing = selfToBall.Unit:Dot(self.realVelocity.Unit)
		end

		self.increase = self.velocity.Magnitude * (1 / 60)
		self.maxIncrease = self.maxVelocity * (1 / 60)

		if not lockingTarget then
			if autotargeting then
				self.myTarget, self.matched = self:FindTarget(2)
			else
				self.myTarget = self:FindTarget(4)
			end
		else
			self.myTarget = lockingTarget
		end

		local targetPos = getPositionWithVelocity(self.myTarget, 0.1625)
		local targetDist = (localPos - targetPos).Magnitude
		local ballToMyTargetDist = (self.ball.Position - targetPos).Magnitude
		local clashRate = targetDist * self.maxIncrease / self.maxVelocity

		local a = 0.4 + ping()

		self.reachTime = self.distance * self.increase / self.velocity.Magnitude
		self.reachTimeFromMyTarget = ballToMyTargetDist * self.increase / self.velocity.Magnitude
		if self.currentTarget then
			self.reachTimeFromTarget = (localPos - self.currentTarget:GetPivot().Position).Magnitude * self.increase / self.velocity.Magnitude
		end
		self.timeToParry = math.max(0.325, self.increase * a * self.pointing)
		self.maxTimeToParry = math.max(0.325, self.maxIncrease * a)
		self.maxTimeToMove = self.distance * self.maxIncrease / self.maxVelocity
		self.parryRate = clashRate / self.maxTimeToParry
		if targetDist < 25 then
			self.spamRate = 1
		elseif targetDist < 50 then
			self.spamRate = 0.6
		else
			self.spamRate = 0.19
		end

		self.vis.targetHighlight.Adornee = self.myTarget

		if not autospam and self._spammingThread then
			pcall(coroutine.close, self._spammingThread)
		end

		-- local text = ""
		-- for index, value in self do
		--	 if type(value) == "number" then
		--		 text = text .. index .. ": " .. value .. "\n"
		--	 end
		-- end
		-- self.vis.text.Text = text
	end))

	self:_insert(self.ball:GetAttributeChangedSignal("target"):Connect(function(...) self:_onAttrChanged(...) end))
	self:_onAttrChanged("target")
	self:_insert(self.ball.ChildAdded:Connect(function(child)
		local n = child.Name
		if AntiAbilityInstancesFunctions[n] then
			coroutine.wrap(AntiAbilityInstancesFunctions[n])(self, child)
		end
		print(child:GetFullName())
	end))

	for _, remote in SupportedAntiAbilityRemotes do
		self:_insert(remote.OnClientEvent:Connect(function(...)
			Notify("Supported Ability Detected", remote.Name, 1)
			coroutine.wrap(AntiAbilityRemoteFunctions[remote.Name])(self, ...)
		end))
	end

	self:_insert(self.ball.Destroying:Connect(function()
		self:Destroy()
	end))

	self:_insert(remotes.ParrySuccess.OnClientEvent:Connect(function()
		task.delay(0.05, function()
			self:_onAttrChanged()
		end)
	end))

	local function isTargetDoSpam()
		local targetVelocity = self.myTarget and self.myTarget.PrimaryPart and self.myTarget.PrimaryPart.Velocity

		if targetVelocity and targetVelocity.Magnitude ~= 0 then
			local relative = (localPos - self.myTarget:GetPivot().Position)
			if relative.Unit:Dot(targetVelocity.Unit) < -0.9 then
				return false
			end
		end

		return true
	end

	self._blocking = task.spawn(function()
		if localChar.Parent ~= workspace.Alive then return end

		while autoparry do
			task.wait()

			if self:_isTimeToParry()
				and (self.currentTarget == localChar or self.lastTarget == localChar)
			then
				self.currentTarget = nil

				if autospam and not self.matched and self:_canSpam() and isTargetDoSpam() then
					Notify("Spam", "Progressing")
					self.spamming = true
					local localCanSpam = true

					local parryRE = getParryRE()
					local hitTime, deflection, relations, offsets = 0, CFrame.new(localRoot.Position, self.myTarget:GetPivot().Position), {}, {0, 0}

					for _, char in workspace.Alive:GetChildren() do
						relations[char.Name] = char ~= self.myTarget and Vector3.one * math.huge or Vector3.zero
					end

					local heartbeatConnection = RunService.Heartbeat:Connect(function()
						deflection = CFrame.new(localRoot.Position, self.myTarget:GetPivot().Position)
						localCanSpam = isTargetDoSpam()
					end)

					while self:_canSpam() and localCanSpam do
						if not self._spammingThread then
							self._spammingThread = coroutine.running()
						end
						for _ = 1, 10 do
							parryRE:FireServer(hitTime, deflection, relations, offsets)
						end
						task.wait()
					end

					self.spamming = nil
					heartbeatConnection:Disconnect()
					continue
				end

				if not fakeDribble then
					self:Parry()
				else
					self:Parry(not dribble)
					dribble = not dribble
				end
				self._parryDatetime = time()
			end

			if self._parryDatetime
				and time() - self._parryDatetime > 1
				and self.currentTarget == nil
			then
				self._parryDatetime = nil
				self.currentTarget = localChar
			end

			if self.delay and time() > self.delay then
				self.delay = nil
			end
		end

		self:Destroy()
	end)
end

function Blocker:Parry(doFakeDribble)
	local target = self.myTarget
	local deflectDirection = randomcurving and CFrame.new(localRoot.Position, target:GetPivot().Position) or workspace.CurrentCamera.CFrame

	if randomcurving and self.maxVelocity > 200 and self.reachTimeFromMyTarget < self.maxTimeToParry / 2 and self.lastTarget == self.myTarget then
		local directions = {
			-- CFrame.Angles(0, math.pi/2, 0);
			-- CFrame.Angles(0, -math.pi/2, 0);
			CFrame.Angles(0, math.pi, 0);
			CFrame.Angles(0, 0, 0);
			-- CFrame.Angles(math.pi/2, 0, 0);
		}
		local randomDir = directions[rng:NextInteger(1, #directions)]
		deflectDirection = CFrame.new(localRoot.Position, target:GetPivot().Position) * randomDir
	end

	Parry(target, deflectDirection, doFakeDribble)
end

function Blocker:FindTarget(mode)
	local target = localChar

	local filteredCharacters = {}
	for _, alive in workspace.Alive:GetChildren() do
		if isTeammate(alive, localChar)
			or isInvis(alive)
			or alive == localChar
		then continue end
		table.insert(filteredCharacters, alive)
	end

	if mode == 0 then
		local minDistance = 1000
		for _, alive in filteredCharacters do
			local distance = (alive:GetPivot().Position - localRoot.Position).Magnitude
			if distance <= minDistance then
				target = alive
				minDistance = distance
			end
		end
	elseif mode == 1 then
		local maxDistance = 0
		for _, alive in filteredCharacters do
			local distance = (alive:GetPivot().Position - localRoot.Position).Magnitude
			if distance > maxDistance then
				target = alive
				maxDistance = distance
			end
		end
	elseif mode == 2 then
		target = nil

		if not standoff then
			for _, alive in filteredCharacters do
				if alive:FindFirstChild("HumanoidRootPart") == nil then continue end

				local cd = cooldowns[alive.HumanoidRootPart] or 0
				if cd == 0 then continue end

				local targetPos = alive:GetPivot().Position
				local ballToTargetDist = (self.ball.Position - targetPos).Magnitude
				local reachTime = ballToTargetDist * self.maxIncrease / self.maxVelocity

				if reachTime > self.parryRate then
					target = alive
					break
				end
			end
		end

		local matched = target ~= nil

		target = target or self:FindTarget(1)

		return target, matched
	elseif mode == 3 then
		local minPointing = 1
		for _, alive in filteredCharacters do
			local a = (alive:GetPivot().Position - localRoot.Position).Unit
			local b = a:Dot(alive.Pointer.Value.LookVector)
			if b < minPointing then
				target = alive
				minPointing = b
			end
		end
	elseif mode == 4 then
		local minDistance = 1000
		for _, alive in filteredCharacters do
			local distance = (alive:GetPivot().Position - mouse.Hit.Position).Magnitude
			if distance <= minDistance then
				target = alive
				minDistance = distance
			end
		end
	end

	return target
end

function Blocker:Destroy()
	for _, vis in self.vis do
		vis:Destroy()
	end
	for _, connection in self._connections do
		if connection.Connected then
			connection:Disconnect()
		end
	end
	for _, tasking in self._tasks do
		task.cancel(tasking)
	end
	for _, coro in self._coroutines do
		coroutine.close(coro)
	end
	pcall(task.cancel, self._blocking)
	pcall(coroutine.close, self._spammingThread)
end

function Blocker:_insert(connection)
	table.insert(self._connections, connection)
end

function Blocker:_isTimeToParry()
	return (not self.delay and self.reachTime < self.timeToParry and self.currentTarget == localChar)
		or (not self.delay
			and self.maxVelocity > 100
			and self.parryRate < 0.65
			and self.reachTimeFromMyTarget < self.maxTimeToParry / 2
		)

		or (self.delay and time() > self.delay and self.currentTarget == localChar and self.maxTimeToMove < self.maxTimeToParry)
	-- or (self.reachTime < 0.1625 and self.reachTimeFromTarget < self.maxTimeToParry and self.currentTarget ~= localChar)
end

function Blocker:_onAttrChanged(attributeName)
	local value = self.ball:GetAttribute("target")
	if value == "" then return end
	self.lastTarget = self.currentTarget
	self.currentTarget = workspace.Alive:FindFirstChild(value)
end

function Blocker:_canSpam()
	return self.parryRate < self.spamRate
		and self.velocity.Magnitude > 0
		or isOthersInvis()
		or self.manualSpamming
end

local UI = loadstring(game:HttpGet("https://gitee.com/xiaoxuxu233/mirror/raw/master/wizard.lua"))()
local window = UI:NewWindow("Unnamed")
local main = window:NewSection("功能")

cooldowns = {}
blockers = {}

main:CreateToggle("自动格挡", function(enabled)
local lastHitTime = 0
local HIT_COOLDOWN = 1 -- 1 second cooldown between hits

local function GetBall()
    for _, ball in ipairs(workspace.Balls:GetChildren()) do
        if ball:GetAttribute("realBall") and ball:IsA("BasePart") then
            return ball
        end
    end
    return nil
end

local function isBallComingTowardsPlayer(ball, player)
    if not ball or not player.Character then return false end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end
    
    local ballVelocity = ball.Velocity
    local toPlayer = (humanoidRootPart.Position - ball.Position).Unit
    
    -- Check if ball is moving towards player (dot product > 0)
    return ballVelocity:Dot(toPlayer) > 0
end

game:GetService("RunService").Heartbeat:Connect(function()
    local now = tick()
    if now - lastHitTime < HIT_COOLDOWN then return end
    
    local player = game:GetService("Players").LocalPlayer
    local ball = GetBall()
    
    if not ball or not isBallComingTowardsPlayer(ball, player) then return end
    
    local ballSpeed = ball.Velocity.Magnitude
    local ballPos = ball.Position
    
    if not player.Character then return end
    local distance = player:DistanceFromCharacter(ballPos) - 12
    local timeToImpact = distance / ballSpeed
    
    if timeToImpact > 0 and timeToImpact <= 0.7 then
        lastHitTime = now
        game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 0)
        task.delay(0.1, function()
            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end)
    end
end)

main:CreateToggle("自动连点", function(enabled)
	autospam = enabled
end)

main:CreateToggle("恶心控球", function(enabled)
	randomcurving = enabled
end)

main:CreateToggle("自动瞄准", function(enabled)
	autotargeting = enabled
end)

main:CreateToggle("手动连点", function(enabled)
	manualspamming = enabled
	for _, blocker in blockers do
		blocker.manualSpamming = manualspamming
	end
end)

local effect = window:NewSection("特效")
effect:CreateToggle("低特效模式", function(enabled)
	for _, script in LocalPlayer.PlayerScripts.EffectScripts:GetDescendants() do
		if script:IsA("LocalScript") then
			script.Enabled = not enabled
		end
	end
	for _, script in LocalPlayer.PlayerGui:GetDescendants() do
		if script:IsA("LocalScript") and not script:IsDescendantOf(LocalPlayer.PlayerGui.Hotbar) then
			if not script.Enabled and not script:GetAttribute("AlwaysDisabled") then
				script:SetAttribute("AlwaysDisabled", true)
			end
			if script:GetAttribute("AlwaysDisabled") then continue end

			script.Enabled = not enabled
		end
	end
end)

effect:CreateButton("强制优化（移除大厅以优化）", function()
	local blacklist = {
		"LobbySpawnPlate",
		"Balls",
		"TrainingBalls",
		"Alive",
		"Dead",
		"Map",
		"Spawn",
		"Runtime",
		"ShowdownActive",
		"MapBounds",
		"Leaderboards",
	}

	local whitelist = {
		"Leaderboards",
	}

	for _, v in workspace:GetChildren() do
		if table.find(blacklist, v.Name) then continue end
		if v == workspace.CurrentCamera then continue end
		pcall(v.Destroy, v)
	end

	for _, v in workspace.Spawn:GetChildren() do
		if v.Name ~= "MenuRings" and v.Name ~= "Spinnyy" then
			v:Destroy()
		end
	end
end)

local enabledPropChangedConnections = {}
effect:CreateToggle("简洁模式", function(enabled)
	local blacklist = {
		"Hotbar"
	}
	for _, gui in LocalPlayer.PlayerGui:GetChildren() do
		if table.find(blacklist, gui.Name) then continue end
		if not gui:IsA("ScreenGui") then continue end
		if gui.Enabled then
			gui:SetAttribute("AlwaysEnabled", true)
		end
		if not gui:GetAttribute("AlwaysEnabled") then continue end
		gui.Enabled = not enabled
	end
end)

local glitches = window:NewSection("Bug")
glitches:CreateToggle("Fake Dribble", function(enabled)
	fakeDribble = enabled
end)