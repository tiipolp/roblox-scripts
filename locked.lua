local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local iframeHighlightEnabled = false
local kickHighlightEnabled = false

local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

local uis = game:GetService("UserInputService")

local touching = false
local autoSteal = false
local autoStealLegit = false
local autoStealPower = 150

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
local ShootingTab = MainWindow:CreateTab("Shooting", 4483362458)

function bitEqual(a, b)
    if type(a) ~= type(b) then
        return false
    end

    return type(a) == "number" and string.format("%a", a) == string.format("%a", b) or a == b
end

if not filtergc then
    getgenv().filtergc = function(typef, options, return_one) -- typef: string, options: table, return_one: boolean
        assert(typef == "function" or typef == "table", "Invalid type: " .. tostring(typef)) -- make sure user isnt a retard
        assert(typeof(options) == "table", "Options must be a table.") -- same here ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

        local filterFound = {}

        if options.IgnoreSyn ~= nil then options.IgnoreExecutor = options.IgnoreSyn end

        if typef == "function" then 
            for _,v in ipairs(getgc()) do
                if typeof(v) == "function" and islclosure(v) then
                    local matches = true

                    if options.IgnoreExecutor ~= false then options.IgnoreExecutor = true end
                    
                    if options.IgnoreExecutor and not isexecutorclosure(v) then
                        if options.Name and not bitEqual(debug.getinfo(v).name, options.Name) then
                            matches = false
                        end

                        if matches and options.Constants and not iscclosure(v) then 
                            local constants = debug.getconstants(v)
                            for _, k in ipairs(options.Constants) do
                                if not table.find(constants, k) then
                                    matches = false
                                    break
                                end
                            end
                        end

                        if matches and options.Upvalues and not iscclosure(v) then 
                            local upvalues = debug.getupvalues(v)
                            for _, k in ipairs(options.Upvalues) do
                                if not table.find(upvalues, k) then
                                    matches = false
                                    break
                                end
                            end
                        end

                        if matches then
                            table.insert(filterFound, v)
                            if return_one then
                                return v -- still kinda unclear of how return one works, docs dont touch up on if its false or true but im assuming it works like this
                            end
                        end
                    elseif not options.IgnoreExecutor then
                        
                        if options.Name and debug.getinfo(v).name ~= options.Name then
                            matches = false
                        end

                        if matches and options.Constants and not iscclosure(v) then
                            local constants = debug.getconstants(v)
                            for _, k in ipairs(options.Constants) do
                                if not table.find(constants, k) then
                                    matches = false
                                    break
                                end
                            end
                        end

                        if matches and options.Upvalues and not iscclosure(v) then 
                            local upvalues = debug.getupvalues(v)
                            for _, k in ipairs(options.Upvalues) do
                                if not table.find(upvalues, k) then
                                    matches = false
                                    break
                                end
                            end
                        end

                        if matches then
                            table.insert(filterFound, v)
                            if return_one then
                                return v
                            end
                        end
                    end
                end
            end
        elseif typef == "table" then
            for _,v in ipairs(getgc(true)) do
                if typeof(v) == "table" then
                    local matches = true

                    if options.Keys then
                        for _, key in ipairs(options.Keys) do
                            if not rawget(v, key) then
                                matches = false
                                break
                            end
                        end
                    end

                    if matches and options.Values then
                        for _, val in ipairs(options.Values) do
                            for _, tableVal in pairs(v) do
                                if bitEqual(tableVal, val) then
                                    break
                                end
                            end

                            matches = false
                        end
                    end

                    if matches and options.KeyValuePairs then
                        for key, value in pairs(options.KeyValuePairs) do
                            if not bitEqual(rawget(v,key),value) then
                                matches = false
                                break
                            end
                        end
                    end

                    if matches and options.Metatable then
                        if not bitEqual(getmetatable(v), options.Metatable) then
                            matches = false
                        end
                    end

                    if matches then
                        table.insert(filterFound, v)
                        if return_one then
                            break
                        end
                    end
                end
            end
        end

        return return_one and filterFound[1] or nil
    end
end

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

kickHitbox:WaitForChild("WeldConstraint"):Destroy()

local weld = Instance.new("Weld", kickHitbox)
weld.Part0 = kickHitbox
weld.Part1 = character:WaitForChild("HumanoidRootPart")
weld.C0 = CFrame.new(0, kickHitbox.Position.Y + math.abs(referencePart.Position.Y), 0)

local stealHitbox = kickHitbox:Clone()
stealHitbox.Parent = character
stealHitbox.Name = "StealHitbox"

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

local stealTouching = false

stealHitbox.Touched:Connect(function(hit)
    if hit.Name == "Ball" then
        if autoSteal and (hit:GetAttribute("kickiframes") ~= player.Name and not hit:GetAttribute("kickiframes") ~= tostring(player.Team) and hit:GetAttribute("iframes") ~= player.Name and not hit:GetAttribute("iframes") ~= tostring(player.Team)) and hit:GetAttribute("iframes") ~= "none" then
            if hit:GetAttribute("breakkick") then return end
            
            stealTouching = true
            
            if autoStealLegit and stealTouching then
                --[[
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(workspace.CurrentCamera.ViewportSize.X / 2,workspace.CurrentCamera.ViewportSize.Y / 2  - (game:GetService("GuiService"):GetGuiInset().Y/2),1,true,game,0)
                task.wait()
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(workspace.CurrentCamera.ViewportSize.X / 2,workspace.CurrentCamera.ViewportSize.Y / 2  - (game:GetService("GuiService"):GetGuiInset().Y/2),1,false,game,0)
                --]]

                local args = {
                    [1] = hrp.CFrame.lookVector,
                    [2] = tonumber(autoStealPower),
                    [3] = false,
                    [4] = false,
                    [5] = false,
                    [6] = false,
                    [7] = false,
                    [8] = "straight",
                    [9] = false,
                    [10] = Color3.new(0, 0, 1),
                    [11] = 13,
                    [12] = false,
                    [13] = false,
                    [14] = false,
                    [15] = false,
                    [16] = false,
                    [17] = false,
                    [18] = false,
                    [20] = false,
                    [22] = 0.07697121581062674,
                    [23] = false
                }
        
                game:GetService("ReplicatedStorage"):WaitForChild("shoot"):FireServer(unpack(args))

                local newAnim = Instance.new("Animation")
                newAnim.AnimationId = "rbxassetid://12830711336"

                humanoid:LoadAnimation(newAnim):Play()
            elseif not autoStealLegit and stealTouching then
                local args = {
                    [1] = hrp.CFrame.lookVector,
                    [2] = tonumber(autoStealPower),
                    [3] = false,
                    [4] = false,
                    [5] = false,
                    [6] = false,
                    [7] = false,
                    [8] = "straight",
                    [9] = false,
                    [10] = Color3.new(0, 0, 1),
                    [11] = 13,
                    [12] = false,
                    [13] = false,
                    [14] = false,
                    [15] = false,
                    [16] = false,
                    [17] = false,
                    [18] = false,
                    [20] = false,
                    [22] = 0.07697121581062674,
                    [23] = false
                }
        
                game:GetService("ReplicatedStorage"):WaitForChild("shoot"):FireServer(unpack(args))
            end
        end
    end
end)

stealHitbox.TouchEnded:Connect(function(hit)
    if hit.Name == "Ball" then
        stealTouching = false
    end
end)

workspace:WaitForChild("BallFolder"):WaitForChild("Ball"):GetAttributeChangedSignal("breakkick"):Connect(function()
    if workspace:WaitForChild("BallFolder"):WaitForChild("Ball"):GetAttribute("breakkick") == false and stealTouching then
        local hit = workspace:WaitForChild("BallFolder"):WaitForChild("Ball")

        if autoSteal and (hit:GetAttribute("kickiframes") ~= player.Name and not hit:GetAttribute("kickiframes") ~= tostring(player.Team) and hit:GetAttribute("iframes") ~= player.Name and not hit:GetAttribute("iframes") ~= tostring(player.Team)) then
            if autoStealLegit and stealTouching then
                local args = {
                    [1] = hrp.CFrame.lookVector,
                    [2] = tonumber(autoStealPower),
                    [3] = false,
                    [4] = false,
                    [5] = false,
                    [6] = false,
                    [7] = false,
                    [8] = "straight",
                    [9] = false,
                    [10] = Color3.new(0, 0, 1),
                    [11] = 13,
                    [12] = false,
                    [13] = false,
                    [14] = false,
                    [15] = false,
                    [16] = false,
                    [17] = false,
                    [18] = false,
                    [20] = false,
                    [22] = 0.07697121581062674,
                    [23] = false
                }
        
                game:GetService("ReplicatedStorage"):WaitForChild("shoot"):FireServer(unpack(args))

                local newAnim = Instance.new("Animation")
                newAnim.AnimationId = "rbxassetid://12830711336"

                humanoid:LoadAnimation(newAnim):Play()
            elseif not autoStealLegit and stealTouching then
                local args = {
                    [1] = hrp.CFrame.lookVector,
                    [2] = tonumber(autoStealPower),
                    [3] = false,
                    [4] = false,
                    [5] = false,
                    [6] = false,
                    [7] = false,
                    [8] = "straight",
                    [9] = false,
                    [10] = Color3.new(0, 0, 1),
                    [11] = 13,
                    [12] = false,
                    [13] = false,
                    [14] = false,
                    [15] = false,
                    [16] = false,
                    [17] = false,
                    [18] = false,
                    [20] = false,
                    [22] = 0.07697121581062674,
                    [23] = false
                }
        
                game:GetService("ReplicatedStorage"):WaitForChild("shoot"):FireServer(unpack(args))
            end
        end
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
        if humanoid.MoveDirection.Magnitude > 0 and hrp.Anchored == false then
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
    MovementTab:CreateLabel("The functions below may crash on some executors (unlikely)", "arrow-down")
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
                debug.setconstant(staminaFunc, 5, Value) -- until i can find a diff way, just do this. regen iteraiton is 5, degen is 8, hopefully this doesnt change
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
                debug.setconstant(staminaFunc, 8, Value)
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
                debug.setconstant(staminaFunc, 5, 0.02)
            elseif staminaFunc and Value then
                debug.setconstant(staminaFunc, 5, regenVal)
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
                debug.setconstant(staminaFunc, 8, 0.08)
            elseif staminaFunc and Value then
                debug.setconstant(staminaFunc, 8, degenVal)
                print(table.unpack(debug.getconstants(staminaFunc)))
            end
        end,
    })

    MovementTab:CreateLabel("The functions above may crash on some executors (unlikely)", "arrow-up")
end

if hookmetamethod and getnamecallmethod then
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

    local powerBar = game:GetService("Players").LocalPlayer.PlayerGui.GeneralGUI.middle.DribbleStyle:Clone()
    powerBar.Name = "PowerBar"
    powerBar.Text = "CURRENT POWER:"
    powerBar.Position = UDim2.new(0, 0, -0.2, 0)
    powerBar.Parent = game:GetService("Players").LocalPlayer.PlayerGui.GeneralGUI.middle
    powerBar.Visible = false

    local kickPower = game:GetService("Players").LocalPlayer.PlayerGui.GeneralGUI.CurrentPower.PWR
    local customPower

    local isDribbleAnywhere = false
    local isDribbleExtender = false
    local dribbleExtenderValue = 18
    local antiRagdoll = false
    local ragdollTime = 1.5
    local kickPowerModToggle
    local oldNamecall

    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        if (isDribbleAnywhere or isDribbleExtender) and self.Name == "Dribble" and method == "FireServer" and args[3] == hrp.Position then
            repeat
             wait(0.3)
            until workspace:FindFirstChild("BallFolder"):FindFirstChild("Ball")
            
            if isDribbleAnywhere then
                dribble(1)
            elseif isDribbleExtender and dribbleExtenderValue >= 0 and (hrp.CFrame.Position - workspace.BallFolder.Ball.CFrame.Position).Magnitude <= dribbleExtenderValue then
                dribble(1)
            end

            return nil
        elseif (antiRagdoll or ragdollTime) and self.Name == "Ragdoll" and method == "FireServer" and args[5] == nil then -- idk how else to check if the remote was called from exec or not, checkcaller didnt work or i didn't use it right
            if antiRagdoll then
                return nil    
            elseif ragdollTime >= 0 then 
                game:GetService("ReplicatedStorage"):WaitForChild("Ragdoll"):FireServer(0, ragdollTime, true, not not (player.Backpack:FindFirstChild("Voracious") and player.PlayerGui.GeneralGUI.CurrentStamina.STAM.Value > 5), true)
            end
            
            return nil 
        elseif (kickPowerModToggle) and self.Name == "shoot" and method == "FireServer" and args[10].R < 0.15 then
            
            local modArgs = {}

            for i,v in pairs(args) do
                modArgs[i] = v
            end

            modArgs[2] = math.floor((139 * (1 + customPower)) * 10) / 10
            modArgs[10] = Color3.new(0.20, modArgs[10].B, modArgs[10].G)
            
            game:GetService("ReplicatedStorage"):WaitForChild("shoot"):FireServer(unpack(modArgs))            

            return nil
        end

        return oldNamecall(self, unpack(args))
    end) 

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

    local _customRagdollTime = MovementTab:CreateSlider({
        Name = "Custom Ragdoll Time (Default: " .. tostring((player.Backpack.Trait:FindFirstChild("Ripper") and 4.5 or 1.5) - (player.Backpack:FindFirstChild("Voracious") and player.PlayerGui.GeneralGUI.CurrentStamina.STAM.Value > 5 and 1 or 0)) .. "s)",
        Range = {0, 6},
        Increment = 0.1,
        Suffix = "",
        CurrentValue = 1.5,
        Flag = "custom_ragdoll_time",
        Callback = function(Value)
            ragdollTime = Value
        end,
    })

    local _antiRagdollToggle = MovementTab:CreateToggle({
        Name = "Anti Ragdoll",
        CurrentValue = false,
        Flag = "anti_ragdoll_toggle",
        Callback = function(Value)
            antiRagdoll = Value
        end,
    })

    local kickPowerLimit = 3
    local kickPowerScaler = 0.1

    local _kickModToggle = ShootingTab:CreateToggle({  
        Name = "Kick Power Modifier",
        CurrentValue = false,
        Flag = "kick_power_modifier_toggle",
        Callback = function(Value)
            powerBar.Visible = Value

            kickPower.Changed:Connect(function(value)
                if kickPower.Value <= 0.401 then
                    powerBar.Text = "CURRENT POWER: " .. math.floor((139 * (1 + value)) * 10) / 10
                    customPower = kickPower.Value
                else
                    repeat
                        customPower = customPower + kickPowerScaler
                        powerBar.Text = "CURRENT POWER: " .. math.floor((139 * (1 + customPower)) * 10) / 10
                        wait(0.1)
                    until customPower > kickPowerLimit or game:GetService("Players").LocalPlayer.PlayerGui.GeneralGUI.Shotbar.Visible == false
                end
            end)

            kickPowerModToggle = Value
        end,
    })

    local _kickPowerLimitSlider = ShootingTab:CreateSlider({
        Name = "Kick Power Limit (Default: 3)",
        Range = {0, 10},
        Increment = 0.1,
        Suffix = "",
        CurrentValue = 3,
        Flag = "kick_power_limit_slider",
        Callback = function(Value)
            kickPowerLimit = Value
        end,
    })

    local _kickPowerScalerSlider = ShootingTab:CreateSlider({
        Name = "Kick Power Scaler (Default: 0.1)",
        Range = {0, 2},
        Increment = 0.05,
        Suffix = "",
        CurrentValue = 0.1,
        Flag = "kick_power_scaler_slider",
        Callback = function(Value)
            kickPowerScaler = Value
        end,
    })
end

local metavisonConnection

local metaVisionLandingPart

local _grantMetavisionToggle = ShootingTab:CreateToggle({
    Name = "Give Metavision Ball Predictor",
    CurrentValue = false,
    Flag = "grant_metavision_toggle",
    Callback = function(Value)
        if Value and not metavisonConnection then
            metavisonConnection = game:GetService("RunService").RenderStepped:Connect(function()
                for _, ball in pairs(workspace:WaitForChild("BallFolder"):GetChildren()) do
                    if ball.Name == "Ball" then
                        
                        if ball:FindFirstChild("metaVisionLandingPart") then
                            metaVisionLandingPart = ball:FindFirstChild("metaVisionLandingPart")
                            metaVisionLandingPart.Transparency = 0.8
                        else
                            metaVisionLandingPart = Instance.new("Part")
                            metaVisionLandingPart.Name = "metaVisionLandingPart"
                            metaVisionLandingPart.Shape = Enum.PartType.Cylinder
                            metaVisionLandingPart.Size = Vector3.new(0.1, 10, 10)
                            metaVisionLandingPart.Color = Color3.new(0, 0, 1)
                            metaVisionLandingPart.Transparency = 0.8
                            metaVisionLandingPart.CanCollide = false
                            metaVisionLandingPart.Anchored = true
                            metaVisionLandingPart.Parent = ball
                        end

                        local velocity = ball.AssemblyLinearVelocity
                        local position = ball.Position
                        local gravity = 0.5 * -workspace.Gravity
                        local velocityY = velocity.Y
                        local positionY = position.Y

                        local discriminant = velocityY^2 - 4 * gravity * positionY
                        local time1 = (-velocityY + math.sqrt(discriminant)) / (2 * gravity)
                        local time2 = (-velocityY - math.sqrt(discriminant)) / (2 * gravity)
                        local impactTime = math.max(time1, time2)
                        
                        local velocityX = velocity.X
                        local velocityZ = velocity.Z
                        local landingPosition = position + Vector3.new(velocityX, 1.1, velocityZ) * impactTime
                        landingPosition = landingPosition + Vector3.new(0, -positionY, 0)
                        
                        metaVisionLandingPart.CFrame = CFrame.new(landingPosition) * CFrame.Angles(0, 0, math.rad(90))
                        local landingX = metaVisionLandingPart.Position.X
                        local landingZ = metaVisionLandingPart.Position.Z
                        metaVisionLandingPart.Position = Vector3.new(landingX, 1.1, landingZ)
                    end
                end
            end)
        end

        if Value == false and metaVisionLandingPart and metavisonConnection then
            metaVisionLandingPart.Transparency = 1
            metavisonConnection:Disconnect()
            metavisonConnection = nil
        end
    end,
})

local _autoStealToggle = BallControlTab:CreateToggle({
    Name = "Auto Steal",
    CurrentValue = false,
    Flag = "auto_steal_toggle",
    Callback = function(Value)
        autoSteal = Value
    end,
})

local _autoStealPowerSlider = BallControlTab:CreateSlider({
    Name = "Auto Steal Power (Default: 150)",
    Range = {150, 400},
    Increment = 5,
    Suffix = "",
    CurrentValue = 150,
    Flag = "auto_steal_power_slider",
    Callback = function(Value)
        autoStealPower = Value
    end,
})


local _autoStealHitboxSlider = BallControlTab:CreateSlider({
    Name = "Auto Steal Hitbox (Default: 0.4)",
    Range = {0, 1},
    Increment = 0.02,
    Suffix = "",
    CurrentValue = 0.4,
    Flag = "auto_steal_hitbox_slider",
    Callback = function(Value)
        stealHitbox.Size = Vector3.new(30 * Value, 15, 30 * Value)
    end,
})

local _autoStealLegitToggle = BallControlTab:CreateToggle({
    Name = "Make Auto Steal Look Legit",
    CurrentValue = false,
    Flag = "auto_steal_legit_toggle",
    Callback = function(Value)
        autoStealLegit = Value
    end,
})

--[[ TODO
    PRIO LOW: add support for multiple traits and weapons
    PRIO HIGH: try out a faster touched alternative for auto steal so no ankle breaks
    PRIO HIGH: fix line 337 not working. it should be kicking after breakkick is done
--]]