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