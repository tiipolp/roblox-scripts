local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local iframeHighlightEnabled = false
local kickHighlightEnabled = false

local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

local uis = game:GetService("UserInputService")

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

local BallControlTab = MainWindow:CreateTab("Ball Control", 4483362458)
local MovementTab = MainWindow:CreateTab("Movement", 4483362458)

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

local _iframeHighlightToggle = BallControlTab:CreateToggle({
    Name = "IFrame Highlighting",
    CurrentValue = false,
    Flag = "iframe_highlight_toggle",
    Callback = function(Value)
        iframeHighlightEnabled = Value
    end,
})

local _kickHighlightToggle = BallControlTab:CreateToggle({
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

local _speedToggle = MovementTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = false,
    Flag = "speed_toggle",
    Callback = function(Value)
        tpwalking = Value
    end,
})

local _speedSlider = MovementTab:CreateSlider({
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

game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
    if tpwalking and humanoid and character and speedMultiplier > 0 then
        if humanoid.MoveDirection.Magnitude > 0 then
            character:TranslateBy(humanoid.MoveDirection * speedMultiplier * game:GetService("RunService").Heartbeat:Wait() * 10)
        end
    end 
end)

if not hookmetamethod then 
    Rayfield:Notify({
        Title = "Exploit missing hooking",
        Content = "Your exploit does not support hookmetamethod, which is required for the anti-anti-cheat to work, some stuff will still work, incompatible features will be disabled and not shown.",
        Duration = 6.5,
        Image = "rewind",
    })
end

if not hookfunction then 
    Rayfield:Notify({
        Title = "Exploit missing hooking",
        Content = "Your exploit does not support hookfunction, which is required for the anti-anti-cheat to work, some stuff will still work, incompatible features will be disabled and not shown.",
        Duration = 6.5,
        Image = "rewind",
    })
end

if not checkcaller then
    getgenv().checkcaller = function() return false end
end

if hookfunction and hookmetamethod then
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
end

if not getgc then
    Rayfield:Notify({
        Title = "Exploit missing getgc",
        Content = "Your exploit does not support getgc, some features will be hidden.",
        Duration = 6.5,
        Image = "rewind",
    })
end

if not islclosure then
    Rayfield:Notify({
        Title = "Exploit missing islclosure",
        Content = "Your exploit does not support islclosure, some features will be hidden.",
        Duration = 6.5,
        Image = "rewind",
    })
end

if not debug.getconstants then
    Rayfield:Notify({
        Title = "Exploit missing debug.getconstants",
        Content = "Your exploit does not support debug.getconstants, some features will be hidden.",
        Duration = 6.5,
        Image = "rewind",
    })
end

if not debug.setconstant then
    Rayfield:Notify({
        Title = "Exploit missing debug.setconstant",
        Content = "Your exploit does not support debug.setconstant, some features will be hidden.",
        Duration = 6.5,
        Image = "rewind",
    })
end

if islclosure and getgc and debug.getconstants and debug.setconstant then
    MovementTab:CreateLabel("May crash on some executors", "arrow-down")
    local staminaFunc
    local regen
    local degen

    local staminaHackEnabled = false

    local function initStaminaHack()
        if staminaHackEnabled then return end

        for _, func in pairs(getgc()) do
            if typeof(func) == "function" and islclosure(func) then
                local constants = debug.getconstants(func)
                local getattr = false
                local maxstam = false 
                local isplaying = false
                local shadow = false
                local enummat = false
                
            
                for i,v in pairs(constants) do
                    if v == "GetAttribute" then
                        getattr = true
                    elseif v == "MAXSTAMINA" then
                        maxstam = true
                    elseif v == "IsPlaying" then
                        isplaying = true
                    elseif v == "SHADOW" then
                        shadow = true
                    elseif v == "Air" then
                        enummat = true
                    elseif v == 0.02 then
                        regen = i
                    elseif v == 0.08 then
                        degen = i
                    end
                end

                if getattr and maxstam and isplaying and shadow and not enummat then
                    staminaFunc = func
                end
            end
        end

        staminaHackEnabled = true
    end

    local regenOn = false
    local degenOn = false
    local regenVal
    local degenVal

    local _regenSlider = MovementTab:CreateSlider({
        Name = "Stamina Regen Rate (Default: 0.02)",
        Range = {-2, 2},
        Increment = 0.01,
        Suffix = "",
        CurrentValue = 0.02,
        Flag = "stamina_regen",
        Callback = function(Value)
            regenVal = Value
            if staminaFunc and regenOn then
                debug.setconstant(staminaFunc, degen - 3, Value) -- until i can find a diff way, just do this. regen iteraiton is 5, degen is 8, hopefully this doesnt change
            end
        end,
    })

    local _degenSlider = MovementTab:CreateSlider({
        Name = "Stamina Degeneration Rate (Default: 0.08)",
        Range = {-2, 2},
        Increment = 0.01,
        Suffix = "",
        CurrentValue = 0.08,
        Flag = "stamina_degen",
        Callback = function(Value)
            degenVal = Value
            if staminaFunc and degenOn then
                debug.setconstant(staminaFunc, degen, Value)
            end
        end,
    })

    local _regenToggle = MovementTab:CreateToggle({
        Name = "Stamina Regen Hack",
        CurrentValue = false,
        Flag = "stamina_regen_toggle",
        Callback = function(Value)
            if Value and not staminaHackEnabled then initStaminaHack() end

            regenOn = Value

            if staminaFunc and not Value then
                debug.setconstant(staminaFunc, regen, 0.02)
            elseif staminaFunc and Value then
                debug.setconstant(staminaFunc, regen, regenVal)
                print(table.unpack(debug.getconstants(staminaFunc)))
            end
        end,
    })

    local _degenToggle = MovementTab:CreateToggle({
        Name = "Stamina Degeneration Hack",
        CurrentValue = false,
        Flag = "stamina_degen_toggle",
        Callback = function(Value)
            if Value and not staminaHackEnabled then initStaminaHack() end

            degenOn = Value

            if staminaFunc and not Value then
                debug.setconstant(staminaFunc, degen, 0.08)
            elseif staminaFunc and Value then
                debug.setconstant(staminaFunc, degen, degenVal)
                print(table.unpack(debug.getconstants(staminaFunc)))
            end
        end,
    })
end

function dribble(method)
    local playerLookVector = hrp.CFrame.lookVector
    local playerVelocity = hrp.Velocity.Magnitude
    local playerPosition = hrp.Position

    local keycodes = {
        [Enum.KeyCode.W] = hrp.CFrame.lookVector,
        [Enum.KeyCode.A] = -hrp.CFrame.RightVector,
        [Enum.KeyCode.S] = -hrp.CFrame.lookVector,
        [Enum.KeyCode.D] = hrp.CFrame.RightVector
    }

    local inf = (-1 / 0)
    local wPressed

    if uis:IsKeyDown(Enum.KeyCode.W) then
        playerLookVector = hrp.CFrame.lookVector
        wPressed = Enum.KeyCode.W
    else
        for keycode, vectors in pairs(keycodes) do
            if uis:IsKeyDown(keycode) then
                local dot = vectors:Dot(hrp.Velocity.Unit)
                if inf < dot then
                    wPressed = keycode
                    inf = dot
                end
            end
        end
    end

    if wPressed then
        playerLookVector = keycodes[wPressed]
    end

    if method == 1 then
        game:GetService("ReplicatedStorage"):WaitForChild("Dribble"):FireServer(playerLookVector, playerVelocity, workspace.BallFolder.Ball.CFrame.Position)
    else
        game:GetService("ReplicatedStorage"):WaitForChild("Dribble"):FireServer(playerLookVector, playerVelocity, playerPosition)
    end
end

local dribblePath = game:GetService("ReplicatedStorage"):WaitForChild("Dribble")
local isDribbleAnywhere = false
local isDribbleExtender = false
local dribbleExtenderValue = 18
local oldNamecall

oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if (isDribbleAnywhere or isDribbleExtender) and self == dribblePath and method == "FireServer" and args[3] == hrp.Position then
        if isDribbleAnywhere then
            dribble(1)
        elseif isDribbleExtender and dribbleExtenderValue >= 0 and (hrp.CFrame.Position - workspace.BallFolder.Ball.CFrame.Position).Magnitude <= dribbleExtenderValue then
            dribble(1)
        end

        return nil
    end

    return oldNamecall(self, unpack(args))
end) 

if hookmetamethod and getnamecallmethod then
    local _dribbeAnywhereToggle
    local _dribbleExtenderSlider
    local _dribbleExtenderToggle

    _dribbeAnywhereToggle = BallControlTab:CreateToggle({
        Name = "Dribble The Ball From Literally Anywhere",
        CurrentValue = false,
        Flag = "dribble_anywhere_toggle",
        Callback = function(Value)
            isDribbleAnywhere = Value
        end,
    })

    _dribbleExtenderSlider = BallControlTab:CreateSlider({
        Name = "Dribble Hitbox Extender (Default: 18)",
        Range = {0, 100},
        Increment = 1,
        Suffix = "",
        CurrentValue = 18,
        Flag = "dribble_extender_slider",
        Callback = function(Value)
            dribbleExtenderValue = Value
        end,
    })

    _dribbleExtenderToggle = BallControlTab:CreateToggle({
        Name = "Dribble Hitbox Extender",
        CurrentValue = false,
        Flag = "dribble_extender_toggle",
        Callback = function(Value)
            isDribbleExtender = Value
        end,
    })
end