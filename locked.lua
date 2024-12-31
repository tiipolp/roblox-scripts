local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local iframeHighlightEnabled = false
local kickHighlightEnabled = false

local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local touching = false

local MainWindow = Rayfield:CreateWindow({
    Name = "LOCKED 1N",
    LoadingTitle = "LOCKED 1N",
    LoadingSubtitle = "by aprllfools",
    Theme = "Default",

    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,

    ConfigurationSaving = {
        Enabled = true,
        FolderName = "locked1n",
        FileName = "config"
    },

    KeySystem = false
})

local MiscTab = MainWindow:CreateTab("Misc", 4483362458)

local function isIframed(ball)
    return ball:GetAttribute("headeriframes") ~= "none" or 
           ball:GetAttribute("iframes") ~= "none" or 
           ball:GetAttribute("kickiframes") ~= "none"
end

local function updateState(ball)
    if iframeHighlightEnabled and isIframed(ball) then
        ball.BrickColor = BrickColor.new("Really red")
    elseif kickHighlightEnabled and touching then
        ball.BrickColor = BrickColor.new("Bright blue")
    else
        ball.BrickColor = BrickColor.new("Institutional white")
    end
end

local referencePart
for _, part in ipairs(workspace:GetChildren()) do
    if part.Name == "ReferencePart" and part.Size.X > 20 then
        referencePart = part
        break
    end
end

if not referencePart then
    warn("No reference part, try getting closer to the ball or re-executing")
    return
end

local kickHitbox = referencePart:Clone()
kickHitbox.Name = "KickHitbox"
kickHitbox.Parent = character

local weld = kickHitbox:WaitForChild("WeldConstraint")
weld.Part0 = kickHitbox
weld.Part1 = character:WaitForChild("HumanoidRootPart")

local _iframeHighlightToggle = MiscTab:CreateToggle({
    Name = "IFrame Highlighting",
    CurrentValue = false,
    Flag = "iframe_highlight_toggle",
    Callback = function(Value)
        iframeHighlightEnabled = Value
    end,
})

local _kickHighlightToggle = MiscTab:CreateToggle({
    Name = "Kick Highlighting",
    CurrentValue = false,
    Flag = "kick_highlight_toggle",
    Callback = function(Value)
        kickHighlightEnabled = Value
    end,
})

kickHitbox.Touched:Connect(function(hit)
    if hit.Name == "Ball" then
        touching = true
        updateState(hit)
    end
end)

kickHitbox.TouchEnded:Connect(function(hit)
    if hit.Name == "Ball" then
        touching = false
        updateState(hit)
    end
end)

for _, attr in ipairs({"headeriframes", "iframes", "kickiframes"}) do
    workspace:WaitForChild("BallFolder"):WaitForChild("Ball"):GetAttributeChangedSignal(attr):Connect(function()
        updateState(workspace:WaitForChild("BallFolder"):WaitForChild("Ball"))
    end)
end

workspace:WaitForChild("BallFolder").ChildAdded:Connect(function(ball)
    for _, attr in ipairs({"headeriframes", "iframes", "kickiframes"}) do
        ball:GetAttributeChangedSignal(attr):Connect(function()
            updateState(ball)
        end)
    end
end)

local tpwalking = false
local speedMultiplier = 0

local function onHeartbeat()
    if tpwalking and humanoid and character and speedMultiplier > 0 then
        if humanoid.MoveDirection.Magnitude > 0 then
            character:TranslateBy(humanoid.MoveDirection * speedMultiplier * game:GetService("RunService").Heartbeat:Wait() * 10)
        end
    end
end

local _speedToggle = MiscTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = false,
    Flag = "speed_toggle",
    Callback = function(Value)
        tpwalking = Value
    end,
})

local _SpeedSlider = MiscTab:CreateSlider({
    Name = "WalkSpeed (0-1 for legit looking speed)",
    Range = {0, 3},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = 0,
    Flag = "speed_slider",
    Callback = function(Value)
        speedMultiplier = tonumber(Value)
    end,
})

game:GetService("RunService").Heartbeat:Connect(onHeartbeat)

local antiKickWorked = false

if not hookmetamethod then 
    Rayfield:Notify({
        Title = "Exploit missing hooking",
        Content = "Your exploit does not support hookmetamethod, which is required for the anti-anti-cheat to work, some stuff will still work, incompatible features will be disabled and not shown.",
        Duration = 6.5,
        Image = "rewind",
    })
    antiKickWorked = true
    return
end

if not checkcaller then
    Rayfield:Notify({
        Title = "Exploit missing hooking",
        Content = "Your exploit does not support checkcaller, which is a part of the anti-anti-cheat but it will still work normally.",
        Duration = 6.5,
        Image = "rewind",
    })
    checkcaller = function() return false end
end

local AllowExecutorKicks = true

for i,v in ipairs({"Kick", "kick"}) do
    local oldkick
    oldkick = hookfunction(player[v], newcclosure(function(self, ...)
        if self == player then
            if checkcaller() then
                return oldkick(self, ...)
            else
                return
            end
        end
        return oldkick(self, ...)
    end))
end

local oldhmmnc
oldhmmnc = hookmetamethod(game, "__namecall", function(self, ...)
    if self == player and table.find({"Kick", "kick"}, getnamecallmethod()) then
        if checkcaller() then
            return oldhmmnc(self, ...)
        else
            return
        end
    end
    return oldhmmnc(self, ...)
end)

