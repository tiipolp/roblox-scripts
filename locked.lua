queue_on_teleport([[
    loadstring(game:HttpGet("https://raw.githubusercontent.com/tiipolp/roblox-scripts/refs/heads/main/locked.lua"))()
]])

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local iframeHighlightEnabled = false

local kickHighlightEnabled = false

local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

local VIRTUAL_INPUT_MANAGER = game:GetService("VirtualInputManager")
local RUN_SERVICE = game:GetService("RunService")
local REPLICATED_STORAGE = game:GetService("ReplicatedStorage")
local COLLECTION_SERVICE = game:GetService("CollectionService")
local USER_INPUT_SERVICE = game:GetService("UserInputService")

local touching = false

local autoSteal = false
local autoStealLegit = false
local autoStealPower = 150
local lastStealAttempt = 0

local antiSteal = false
local antiStealHitbox = 30
local lastAntiStealAttempt = 0

local gravity = 0.5 * -workspace.Gravity

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


if game.PlaceId == 12276235857 then
    local LobbyTab = MainWindow:CreateTab("Lobby", 4483362458)

    local _redeemTasks = LobbyTab:CreateButton({
        Name = "Redeem Tasks",
        Callback = function()
            for i = 1, 5, 1 do
                local args = {
                    [1] = i
                }
            
                game:GetService("ReplicatedStorage"):WaitForChild("Tasks"):WaitForChild("RedeemAward"):FireServer(unpack(args))
            end
        end,
    })

    LobbyTab:CreateDivider()

    local whatToRoll
    
    local customization = player.PlayerGui.Build.NewCustomise

    local weaponRollingFor = nil
    local weaponRolled = nil

    local heightInput = nil
    local heightInput2 = nil
    local heightCompare = nil


    function heightToInches(heightStr)
        local feet, inches = heightStr:match("(%d+)'(%d*)")
    
        feet = tonumber(feet) or 0
        inches = tonumber(inches) or 0
    
        local totalInches = (feet * 12) + inches
        return totalInches
    end
    
    local traitRollingFor = nil
    local traitRolled = customization.AbilitiesSlide.TraitReroll

    local flowBuffPercentage = 0
    local flowBuffType = nil

    local _autoRollDropdown = LobbyTab:CreateDropdown({
        Name = "Auto Roll",
        Options = {"Weapon", "Trait", "Height", "Face", "Flow Type", "Flow Buff", "Flow Aura"},
        CurrentOption = "None",
        Callback = function(Value)
            
        end,
    })
    
    LobbyTab:CreateDivider()

    local _weaponDropdown = LobbyTab:CreateDropdown({
        Name = "Weapon",
        Options = (function()
            local finalList = {}
            for _,v in game:GetService("ReplicatedStorage").Specs:GetChildren() do
                if v:IsA("Folder") == false then
                    table.insert(finalList, v.Name)
                end
            end

            table.sort(finalList)

            table.insert(finalList, 1, "unique")
            table.insert(finalList, 2, "legendary")
            table.insert(finalList, 3, "exotic")
            table.insert(finalList, 4, "rare")
            table.insert(finalList, 5, "common")

            return finalList
        end)(),
        MultipleOptions = true,
        CurrentOption = "",
        Callback = function(Value)
            weaponRollingFor = Value
        end,

    })
    
    local _traitDropdown = LobbyTab:CreateDropdown({
        Name = "Trait",
        Options = (function()
            local finalList = {}
            for _,v in game:GetService("ReplicatedStorage").Specs.Traits:GetChildren() do
                table.insert(finalList, v.Name)
            end

            table.sort(finalList)

            table.insert(finalList, 1, "legendary")
            table.insert(finalList, 2, "exotic")
            table.insert(finalList, 3, "rare")
            table.insert(finalList, 4, "common")

            return finalList
        end)(),
        CurrentOption = "",
        MultipleOptions = true,
        Callback = function(Value)
            traitRollingFor = Value
        end,
    })

    LobbyTab:CreateDivider()
    LobbyTab:CreateLabel("Height must be 5'3 - 6'3, height format looks like: feet'inches")

    local _heightInput
    local _heightInput2

    _heightInput = LobbyTab:CreateInput({
        Name = "Height",
        PlaceholderText = "Read label for conditions",
        CurrentValue = "",
        Callback = function(Value)
            if heightCompare ~= nil then
                if heightToInches(Value) <= 75 and heightToInches(Value) >= 63 and #Value == 3 then
                    heightInput = Value
                else
                    heightInput = nil
                    _heightInput:Set("Invalid height")
                end
            else
                heightInput = nil
                _heightInput:Set("No condition selected")
            end
        end,

    })

    _heightInput2 = LobbyTab:CreateInput({
        Name = "Height 2 (Only needed for range)",
        PlaceholderText = "Read label for conditions",
        CurrentValue = "",
        Callback = function(Value)
            if heightCompare[1] ~= "Range (height1 - height2)" then
                heightInput2 = nil
                _heightInput2:Set("Condition is not range")
            end

            if heightToInches(Value) <= 75 and heightToInches(Value) >= 63 and #Value == 3 then
                heightInput2 = Value
            else
                heightInput2 = nil
                _heightInput2:Set("Invalid height")
            end
        end,
    })

    _heightCompareDropdown = LobbyTab:CreateDropdown({
        Name = "Height Condition",
        Options = {"<", ">", ">=", "<=", "=", "Range (height1 - height2)"},
        CurrentOption = "",
        Callback = function(Value)
            heightCompare = Value
        end,
    })

    LobbyTab:CreateDivider()

    local _flowBuffSlider = LobbyTab:CreateSlider({
        Name = "Flow Buff Percentage",
        Range = {0, 15},
        Increment = 0.1,
        Suffix = "% or more",
        CurrentValue = 0,
        Callback = function(Value)
            flowBuffPercentage = Value
        end,
    })

    local _flowBuffTypeDropdown = LobbyTab:CreateDropdown({
        Name = "Flow Buff Type",
        Options = {"Speed", "Hitbox", "Power", "Cooldown", "Stamina"},
        CurrentOption = "",
        MultipleOptions = true,
        Callback = function(Value)
            flowBuffType = Value
        end,
    })

    LobbyTab:CreateDivider()
    

    wait(9999999)

end

local BallControlTab = MainWindow:CreateTab("Ball Control", 4483362458)
local MovementTab = MainWindow:CreateTab("Movement", 4483362458)
local ShootingTab = MainWindow:CreateTab("Shooting", 4483362458)
local DribbleTab = MainWindow:CreateTab("Dribble Moves", 4483362458)
local CharacterTab = MainWindow:CreateTab("Character", 4483362458)
local GoalKeeperTab = MainWindow:CreateTab("GoalKeeper", 4483362458)

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

local function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
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

BallControlTab:CreateSection("Visuals")

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

function getAuraColor()
	return Color3.new(character.AuraColour.Red.Value, character.AuraColour.Green.Value, character.AuraColour.Blue.Value)
end

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

MovementTab:CreateSection("Speed")

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

RUN_SERVICE.Heartbeat:Connect(function(deltaTime)
    if tpwalking and humanoid and speedMultiplier > 0 then
        if humanoid.MoveDirection.Magnitude > 0 and hrp.Anchored == false then
            character:TranslateBy(humanoid.MoveDirection * speedMultiplier * deltaTime * 10)
        end
    end

    if antiSteal and player.PlayerGui.GeneralGUI.CurrentPower.PWR.Value == 0 then
        local ball = workspace.BallFolder:FindFirstChild("Ball")
        if not ball or ball.Parent:FindFirstChild("Shadow") then return end
        
        if ball:GetAttribute("player") ~= player.Name then return end 
        if ball:GetAttribute("breakkick") ~= false then return end 

        for _, found in ipairs(game.Players:GetPlayers()) do
            if found ~= player and found.Character and found.Character:FindFirstChild("HumanoidRootPart") and found.Team ~= player.Team and ball:GetAttribute("player") == player.Name and ball:GetAttribute("team") ~= tostring(found.Team) then
                local distance = (found.Character.HumanoidRootPart.Position - ball.Position).Magnitude
                local distFromPlayer = (hrp.Position - ball.Position).Magnitude
                if distance <= antiStealHitbox and distFromPlayer <= 13 and player.PlayerGui.GeneralGUI.CurrentPower.PWR.Value == 0 and character.Ragdoll.Value == false and os.time() - lastAntiStealAttempt > 0.5 then
                    for _, track in ipairs(found.Character.Humanoid.Animator:GetPlayingAnimationTracks()) do
                        if track.Animation.AnimationId == "rbxassetid://13082657041" or track.Animation.AnimationId == "rbxassetid://12830711336" or track.Animation.AnimationId == "rbxassetid://12994376714" then
                            for _, track2 in ipairs(character.Humanoid.Animator:GetPlayingAnimationTracks()) do
                                if track2.Animation.AnimationId == "rbxassetid://12830711336"
                                   or track2.Animation.AnimationId == "rbxassetid://16013434132"
                                   or track2.Animation.AnimationId == "rbxassetid://13082657041"
                                   or track2.Animation.AnimationId == "rbxassetid://12933738311"
                                   or track2.Animation.AnimationId == "rbxassetid://13392854857" then
                                    return
                                end
                            end

                            lastAntiStealAttempt = os.time()

                            local newAnim = Instance.new("Animation")
                            newAnim.AnimationId = "rbxassetid://12830711336"
                            character.Humanoid:LoadAnimation(newAnim):Play()
    
                            local args = {
                                [1] = Vector3.new(0, 1, 0),
                                [2] = 165,
                                [3] = false,
                                [4] = false,
                                [5] = false,
                                [6] = false,
                                [7] = false,
                                [9] = false,
                                [10] = getAuraColor(),
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

                            task.wait(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000)

                            for _ = 1, 3 do
                                dribble()
                                task.wait(0.1)
                            end
                            break
                        end
                    end
                end
            end
        end
    end

    if autoSteal then
        stealHitbox = character:FindFirstChild("StealHitbox")

        local region = Region3.new(stealHitbox.Position - stealHitbox.Size / 2, stealHitbox.Position + stealHitbox.Size / 2)
        local parts = workspace:FindPartsInRegion3(region, stealHitbox, math.huge)

        for _, hit in ipairs(parts) do
            if hit.Name == "Ball" then
                stealHitbox.Transparency = 0.8

                local validKickFrames = hit:GetAttribute("kickiframes") ~= player.Name and
                                        hit:GetAttribute("kickiframes") ~= tostring(player.Team)
                local validIFrames = hit:GetAttribute("iframes") ~= player.Name and
                                    hit:GetAttribute("iframes") ~= tostring(player.Team)
                local validOtherAttributes = hit:GetAttribute("iframes") ~= "none" and
                                            hit:GetAttribute("player") ~= player.Name and
                                            hit:GetAttribute("team") ~= tostring(player.Team)

                if validKickFrames and validIFrames and validOtherAttributes then
                    if autoStealLegit and player.PlayerGui.GeneralGUI.CurrentPower.PWR.Value == 0 and character.Ragdoll.Value == false and os.time() - lastStealAttempt > 0.5 then
                        for _, track in ipairs(humanoid.Animator:GetPlayingAnimationTracks()) do
                            if track.Animation.AnimationId == "rbxassetid://12830711336"
                               or track.Animation.AnimationId == "rbxassetid://16013434132"
                               or track.Animation.AnimationId == "rbxassetid://13082657041" 
                               or track.Animation.AnimationId == "rbxassetid://12933738311" 
                               or track.Animation.AnimationId == "rbxassetid://13392854857" then
                                return
                            end
                        end

                        lastStealAttempt = os.time()

                        local newAnim = Instance.new("Animation")
                        newAnim.AnimationId = "rbxassetid://12830711336"
                        humanoid:LoadAnimation(newAnim):Play()

                        local args = {
                            [1] = player:GetMouse().Hit.lookVector,
                            [2] = tonumber(autoStealPower),
                            [3] = false,
                            [4] = false,
                            [5] = false,
                            [6] = false,
                            [7] = false,
                            [8] = "straight",
                            [9] = false,
                            [10] = getAuraColor(),
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
                    else
                        local args = {
                            [1] = player:GetMouse().Hit.lookVector,
                            [2] = tonumber(autoStealPower),
                            [3] = false,
                            [4] = false,
                            [5] = false,
                            [6] = false,
                            [7] = false,
                            [8] = "straight",
                            [9] = false,
                            [10] = getAuraColor(),
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

                wait(0.5)
                stealHitbox.Transparency = 1
            end
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

    local excludeThisTrait = player.Backpack.Trait:GetChildren()[1]

    function traitHandler(traits)
        local traitFolder = player.Backpack:FindFirstChild("Trait")
        
        local traitSet = {}
        for _, traitName in pairs(traits) do
            traitSet[traitName] = true
        end

        for _, existingTrait in ipairs(traitFolder:GetChildren()) do
            if not traitSet[existingTrait.Name] and existingTrait.Name ~= excludeThisTrait then
                existingTrait:Destroy()
            else
                traitSet[existingTrait.Name] = nil
            end
        end

        local allTraits = game:GetService("ReplicatedStorage").Specs.Traits
        for traitName, _ in pairs(traitSet) do
            local trait = allTraits:FindFirstChild(traitName)
            if trait then
                local clonedTrait = trait:Clone()
                clonedTrait.Parent = traitFolder
            end
        end
    end
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
    
        local highestDot = -math.huge
        local wPressed
    
        if USER_INPUT_SERVICE:IsKeyDown(Enum.KeyCode.W) then
            wPressed = Enum.KeyCode.W
        else
            for keycode, vectors in pairs(keycodes) do
                if USER_INPUT_SERVICE:IsKeyDown(keycode) then
                    local dot = vectors:Dot(hrp.Velocity.Unit)
                    if dot > highestDot then
                        wPressed = keycode
                        highestDot = dot
                    end
                end
            end
        end
    
        if wPressed then
            playerLookVector = keycodes[wPressed]
        end
    
        if method == 1 then
            repeat
                wait()
            until workspace:FindFirstChild("BallFolder"):FindFirstChild("Ball")
            
            game:GetService("ReplicatedStorage").Dribble:FireServer(playerLookVector, playerVelocity, workspace.BallFolder.Ball.CFrame.Position)
        else
            game:GetService("ReplicatedStorage").Dribble:FireServer(playerLookVector, playerVelocity, playerPosition)
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

        if (isDribbleAnywhere or isDribbleExtender) and self.Name == "Dribble" and method == "FireServer" and args[3] == hrp.Position and workspace:FindFirstChild("BallFolder"):FindFirstChild("Ball") then
            if isDribbleAnywhere then
                dribble(1)
            elseif isDribbleExtender and dribbleExtenderValue >= 0 and (hrp.CFrame.Position - workspace.BallFolder.Ball.CFrame.Position).Magnitude <= dribbleExtenderValue and workspace:FindFirstChild("BallFolder"):FindFirstChild("Ball") then
                dribble(1)
            end

            return nil
        elseif (antiRagdoll or ragdollTime ~= 1.5) and self.Name == "Ragdoll" and method == "FireServer" and args[5] == nil then -- idk how else to check if the remote was called from exec or not, checkcaller didnt work or i didn't use it right
            if ragdollTime >= 0 and not antiRagdoll then 
                game:GetService("ReplicatedStorage"):WaitForChild("Ragdoll"):FireServer(0, ragdollTime, true, not not (player.Backpack:FindFirstChild("Voracious") and player.PlayerGui.GeneralGUI.CurrentStamina.STAM.Value > 5), true)
            end
            
            return nil 
        elseif kickPowerModToggle and self.Name == "shoot" and method == "FireServer" and args[2] % 1 ~= 0 then
            local modArgs = {}

            for i,v in pairs(args) do
                modArgs[i] = v
            end

            modArgs[2] = round(math.floor((139 * (1 + customPower)) * 10) / 10, 0)

            game:GetService("ReplicatedStorage"):WaitForChild("shoot"):FireServer(unpack(modArgs))            

            return nil
        end

        return oldNamecall(self, unpack(args))
    end)

    local _dribbeAnywhereToggle
    local _dribbleExtenderSlider
    local _dribbleExtenderToggle

    BallControlTab:CreateSection("Dribble")

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

    MovementTab:CreateSection("Ragdoll")

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

    ShootingTab:CreateSection("Kick Power")

    local _kickModToggle = ShootingTab:CreateToggle({  
        Name = "Kick Power Modifier",
        CurrentValue = false,
        Flag = "kick_power_modifier_toggle",
        Callback = function(Value)
            powerBar.Visible = Value

            kickPowerModToggle = Value

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

ShootingTab:CreateSection("Predictors")

local _grantMetavisionToggle = ShootingTab:CreateToggle({
    Name = "Give Metavision Ball Predictor",
    CurrentValue = false,
    Flag = "grant_metavision_toggle",
    Callback = function(Value)
        if Value and not metavisonConnection then
            metavisonConnection = RUN_SERVICE.RenderStepped:Connect(function()
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

local trajectoryFolder

function updateTrajectory(ball)
    if not workspace.BallFolder:WaitForChild("Ball"):FindFirstChild("TrajectoryPath") then
        trajectoryFolder = Instance.new("Folder")
        trajectoryFolder.Name = "TrajectoryPath"
        trajectoryFolder.Parent = ball
    else
        trajectoryFolder = workspace.BallFolder:WaitForChild("Ball"):FindFirstChild("TrajectoryPath")
    end
    
    local velocity = ball.AssemblyLinearVelocity
    local position = ball.Position
    local velocityY = velocity.Y
    local positionY = position.Y

    local discriminant = velocityY^2 - 4 * gravity * (positionY - 1.1)
    
    local sqrtDiscriminant = math.sqrt(discriminant)
    local time1 = (-velocityY + sqrtDiscriminant) / (2 * gravity)
    local time2 = (-velocityY - sqrtDiscriminant) / (2 * gravity)
    local impactTime = math.max(time1, time2)

    local velocityX = velocity.X
    local velocityZ = velocity.Z

    for _, part in pairs(trajectoryFolder:GetChildren()) do
        part:Destroy()
    end

    local timeStep = 0.03
    for t = 0, impactTime, timeStep do
        local currentPosition = position + Vector3.new(velocityX, velocityY, velocityZ) * t + Vector3.new(0, gravity, 0) * t^2

        if currentPosition.Y <= 1.5 then break end

        local marker = Instance.new("Part")
        marker.Size = Vector3.new(2, 2, 2)
        marker.Color = Color3.new(1, 0, 0)
        marker.Shape = Enum.PartType.Ball
        marker.Anchored = true
        marker.CanCollide = false
        marker.CFrame = CFrame.new(currentPosition)
        marker.Transparency = 0.5
        marker.Parent = trajectoryFolder
    end
end

local trajectoryConnection

local _grantTrajectoryPredictionToggle = ShootingTab:CreateToggle({
    Name = "Show Ball Trajectory",
    CurrentValue = false,
    Flag = "show_ball_trajectory_toggle",
    Callback = function(Value)
        if Value and not trajectoryConnection then
            trajectoryConnection = RUN_SERVICE.RenderStepped:Connect(function()
                local ball = workspace:WaitForChild("BallFolder"):FindFirstChild("Ball")
                if ball then
                    updateTrajectory(ball)
                end
            end)
        else
            if trajectoryConnection then
                trajectoryConnection:Disconnect()
                trajectoryConnection = nil
            end
        end
    end,
})

BallControlTab:CreateSection("Stealing")

local autoStealHitbox = Vector3.new(30 * 0.4, 15, 30 * 0.4)

local _autoStealToggle = BallControlTab:CreateToggle({
    Name = "Auto Steal",
    CurrentValue = false,
    Flag = "auto_steal_toggle",
    Callback = function(Value)
        autoSteal = Value
        stealHitbox.Size = autoStealHitbox
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
        autoStealHitbox = Vector3.new(30 * Value, 15, 30 * Value)
        character:FindFirstChild("StealHitbox").Size = autoStealHitbox
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
	
local _doAirDribble = DribbleTab:CreateKeybind({
    Name = "Do Air Dribble",
    CurrentKeybind = "T",
    HoldToInteract = false,
    Flag = "do_air_dribble",
    Callback = function(isHeld)
        if player.PlayerGui.GeneralGUI.CurrentPower.PWR.Value > 0 then
            return
        end

        local newAnim = Instance.new("Animation")
        newAnim.AnimationId = "rbxassetid://12830711336"
        humanoid:LoadAnimation(newAnim):Play()

        local args = {
            [1] = Vector3.new(0, 1, 0),
            [2] = 145,
            [3] = false,
            [4] = false,
            [5] = false,
            [6] = false,
            [7] = false,
            [9] = false,
            [10] = getAuraColor(),
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
        
        task.wait(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000)

        for _ = 1, 3 do
            dribble()
            task.wait(0.1)
        end
    end,
})

local _antiStealToggle = BallControlTab:CreateToggle({
    Name = "Anti Steal",
    CurrentValue = false,
    Flag = "anti_steal_toggle",
    Callback = function(Value)
        antiSteal = Value
    end,
})

local _antiStealHitboxSlider = BallControlTab:CreateSlider({
    Name = "Anti Steal Hitbox (Default: 30)",
    Range = {0, 100},
    Increment = 1,
    Suffix = "",
    CurrentValue = 30,
    Flag = "anti_steal_hitbox_slider",
    Callback = function(Value)
        antiStealHitbox = Value
    end,
})

-- auto gk

local goalieAnim = Instance.new("Animation")
goalieAnim.AnimationId = "rbxassetid://12782895583"
local anim = character.Humanoid:LoadAnimation(goalieAnim)

local lastDived = 0

local closestGoalieBox = nil
local shortestDistance = math.huge

for _, part in ipairs(workspace:GetDescendants()) do
    if part:IsA("BasePart") and string.lower(part.Name) == "nethitbox" then
        if part.Size.X < 1 and part.Size.Z > 35 then
            local distance = (part.Position - hrp.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestGoalieBox = part
            end
        end
    end
end

closestBox = nil
shortestDistance = math.huge

for _, part in ipairs(workspace.Box:GetChildren()) do
    local distance = (part.Position - hrp.Position).Magnitude
    
    if distance < shortestDistance then
        shortestDistance = distance

        closestBox = part
    end
end

local ball = workspace:WaitForChild("BallFolder"):WaitForChild("Ball")
if not ball:FindFirstChild("TrajectoryPath") then
    trajectoryFolder = Instance.new("Folder")
    trajectoryFolder.Name = "TrajectoryPath"
    trajectoryFolder.Parent = ball
else
    trajectoryFolder = ball:FindFirstChild("TrajectoryPath")
end

local stopMarker = false
local ballDetected = false
local characterInBox = false

local ball = workspace.BallFolder.Ball
local autoGKConnection
local characterInBox = false
local _autoGKToggle

_autoGKToggle = GoalKeeperTab:CreateToggle({
    Name = "Auto GK",
    CurrentValue = false,
    Flag = "auto_gk_toggle",
    Callback = function(Value)
        if workspace.SensorGoals:FindFirstChild("sensor") then
            workspace.SensorGoals:FindFirstChild("sensor"):Destroy()
        end

        local newHitbox = closestGoalieBox:Clone()
        newHitbox.Size = Vector3.new(10, 18, 60)
        newHitbox.CanCollide = false
        newHitbox.Parent = workspace.SensorGoals
        newHitbox.Name = "sensor"
        newHitbox.Transparency = 1
        
        if round(closestGoalieBox.Position.X, 1) == -326.7 and round(closestGoalieBox.Position.Y, 1) == 7.8 then
            newHitbox.Position = Vector3.new(closestGoalieBox.Position.X, closestGoalieBox.Position.Y, -564.5)
        elseif round(closestGoalieBox.Position.X, 1) == -326.4 and round(closestGoalieBox.Position.Y, 1) == 7.9 then
            newHitbox.Position = Vector3.new(closestGoalieBox.Position.X, closestGoalieBox.Position.Y, -14)
        end

        local sensor = newHitbox

        sensor.Touched:Connect(function()
            return
        end)

        if Value and character.GK.Value == false then
            _autoGKToggle:Set(false)
            Rayfield:Notify({
                Title = "Auto GK",
                Content = "You are not GK.",
                Duration = 5,
                Image = 4483362458
            })
        end

        if Value and character.GK.Value == true then
            autoGKConnection = RUN_SERVICE.RenderStepped:Connect(function()
                local touchingParts = workspace:GetPartBoundsInBox(sensor.CFrame, sensor.Size)

                for i,v in pairs(touchingParts) do
                    if v.Name == "Ball" then
                        ballDetected = true
                        if v:FindFirstChild("marker") then
                            for i,v in v:GetChildren() do
                                if v.Name == "marker" then
                                    v:Destroy()
                                end
                            end
                        end
                        break
                    end
            
                    ballDetected = false
                    stopMarker = false
                end
            
                local velocity = ball.AssemblyLinearVelocity
                local position = ball.Position
                local velocityY = velocity.Y
                local positionY = position.Y
            
                local discriminant = velocityY^2 - 4 * gravity * positionY
                local time1 = (-velocityY + math.sqrt(discriminant)) / (2 * gravity)
                local time2 = (-velocityY - math.sqrt(discriminant)) / (2 * gravity)
                local impactTime = math.max(time1, time2)
                
                local velocityX = velocity.X
                local velocityZ = velocity.Z
            
                for _, part in pairs(trajectoryFolder:GetChildren()) do
                    part:Destroy()
                end
            
                local timeStep = 0.03
                for t = 0, impactTime, timeStep do
                    if stopMarker or ballDetected or ball:GetAttribute("player") == player.Name or ball:GetAttribute("team") == tostring(player.Team) or (ball:GetAttribute("iframes") ~= "none" and (velocity.X ~= 0 or velocity.Y ~= 0 or velocity.Z ~= 0))  then
                        break
                    end
            
                    local currentPosition = position + Vector3.new(velocityX, velocityY, velocityZ) * t + Vector3.new(0, gravity, 0) * t^2

                    -- make this not make instances since it can just use position to check if its inside the gk hitbox
            
                    local marker = Instance.new("Part")
                    marker.Size = Vector3.new(2,2,2)
                    marker.Color = Color3.new(1, 0, 0)
                    marker.Shape = Enum.PartType.Ball
                    marker.Anchored = true
                    marker.CanCollide = false
                    marker.CFrame = CFrame.new(currentPosition)
                    marker.Transparency = 1
                    marker.Parent = trajectoryFolder
                    marker.Name = "marker"
            
                    for i,v in pairs(marker:GetTouchingParts()) do
                        if v.Name == "sensor" then
                            stopMarker = true
                            
                            if ball:FindFirstChild("marker") then
                                ball:FindFirstChild("marker"):Destroy()
                            end

                            marker.Parent = ball
                            break
                        end
                    end
                end

                local characterInBox = false

                if ball:FindFirstChild("marker") and ballDetected == false and (tick() - lastDived) >= 1 and ball:GetAttribute("iframes") == "none" and ball:GetAttribute("player") ~= player.Name and ball:GetAttribute("team") ~= tostring(player.Team) then
                    lastDived = tick()
            
                    local marker = ball:FindFirstChild("marker")

                    local touchingParts = workspace:GetPartBoundsInBox(closestBox.CFrame, closestBox.Size)

                    for i,v in pairs(touchingParts) do
                        if v.Parent == character then
                            characterInBox = true
                            break
                        end

                        characterInBox = false
                    end

                    if not characterInBox then
                        return
                    end

                    character:WaitForChild("Humanoid").AutoRotate = false

                    local highestMarker = 0

                    for i,v in pairs(ball:GetChildren()) do
                        if v.Name == "marker" then
                            if v.Position.Y > highestMarker then
                                highestMarker = v.Position.Y
                                marker = v
                                ball:FindFirstChild("marker"):Destroy()
                            end
                        end
                    end

                    -- add mag checks to see if ball is in range to marker and if so, dive (prob like 50 magnitude?)
                    
                    hrp.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(marker.Position.X, hrp.Position.Y, marker.Position.Z))
            
                    if marker.CFrame.Position.Y > 5 then -- really wrong for some reason. barely jumps
                        VIRTUAL_INPUT_MANAGER:SendKeyEvent(true, 0x20, false, game)
                        task.wait(0.05)
                        VIRTUAL_INPUT_MANAGER:SendKeyEvent(false, 0x20, false, game)
                    end
            
                    VIRTUAL_INPUT_MANAGER:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                    task.wait(0.05)
                    VIRTUAL_INPUT_MANAGER:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
            
                    marker:Destroy()

                    character:WaitForChild("Humanoid").AutoRotate = true
                end
            end)
        elseif Value == false and autoGKConnection then
            autoGKConnection:Disconnect()
            autoGKConnection = nil
        end
    end,
})

--------------------------------

MovementTab:CreateSection("Jump")

local _antiJumpFatigueToggle

_antiJumpFatigueToggle = MovementTab:CreateToggle({
    Name = "Anti Jump Fatigue",
    CurrentValue = false,
    Flag = "anti_jump_fatigue_toggle",
    Callback = function(Value)
        COLLECTION_SERVICE:RemoveTag(character, "JumpFatigue")

        COLLECTION_SERVICE:GetInstanceAddedSignal("JumpFatigue"):Connect(function(changed)
            if changed == character and _antiJumpFatigueToggle.CurrentValue then
                COLLECTION_SERVICE:RemoveTag(character, "JumpFatigue")
            end
        end)
    end,
})

local _jumpPowerSlider = MovementTab:CreateSlider({
    Name = "Jump Power (Default: " .. round(humanoid.JumpHeight, 1) .. ")",
    Range = {0, 30},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = round(humanoid.JumpHeight, 1),
    Flag = "jump_power_slider",
    Callback = function(Value)
        humanoid.UseJumpPower = true

        COLLECTION_SERVICE:GetInstanceAddedSignal("JumpFatigue"):Connect(function(changed)
            if changed == character then
                humanoid.UseJumpPower = false
            end
        end)

        COLLECTION_SERVICE:GetInstanceRemovedSignal("JumpFatigue"):Connect(function(changed)
            if changed == character then
                humanoid.UseJumpPower = true
            end
        end)

        humanoid.JumpPower = 6.410352941 * Value
    end,
})

local _giveTraitDropdown = CharacterTab:CreateDropdown({
    Name = "Give Trait",
    Options = (function()
        local traits = {}
        for _, trait in pairs(game:GetService("ReplicatedStorage").Specs.Traits:GetChildren()) do
            if player.Backpack.Trait:FindFirstChild(trait.Name) or trait:GetAttribute("activational") == true or trait:GetAttribute("rarity") == "exclusive" then
                continue
            else
                table.insert(traits, trait.Name)
            end
        end
        return traits
    end)(),
    MultipleOptions = true,
    Flag = "give_trait_dropdown",
    Callback = function(Options)
        traitHandler(Options)
    end,1
})

CharacterTab:CreateSection("Ego")

local _setEgoSlider = CharacterTab:CreateSlider({
    Name = "Set Ego",
    Range = {0, 100},
    Increment = 1,
    Suffix = "",
    CurrentValue = 0,
    Flag = "set_ego_slider",
    Callback = function(Value)
        game:GetService("Players").LocalPlayer.PlayerGui.GeneralGUI.EGO.ego.Value = Value
    end,
})

local _activateEgoButton = CharacterTab:CreateButton({
    Name = "Activate Ego",
    Callback = function()
        game:GetService("ReplicatedStorage"):WaitForChild("FlowTypes"):WaitForChild("Handle"):WaitForChild("BuffRemote"):FireServer()
    end,
})

local tracerEnabled = false
local tracerOrigin = "Bottom"
local tracerColor = Color3.new(1, 1, 1)
local tracerTransparency = 0
local tracerOutlineColor = Color3.new(0, 0, 0)
local tracerOutlineTransparency = 0.5
local tracers = {}

local function tracer_cleanup()
    for _, v in pairs(tracers) do
        if v.line and v.outline then
            v.line:Destroy()
            v.outline:Destroy()
        end
    end
    tracers = {}
end

local _tracerToggle = CharacterTab:CreateToggle({
    Name = "Enable Tracers",
    CurrentValue = false,
    Flag = "tracer_toggle",
    Callback = function(Value)
        tracerEnabled = Value
        if not Value then tracer_cleanup() end
    end,
})

local _tracerOriginDropdown = CharacterTab:CreateDropdown({
    Name = "Tracer Origin",
    Options = {"Bottom", "Middle", "Top", "Mouse"},
    CurrentOption = "Bottom",
    Callback = function(Value)
        print(tostring(Value[1]))
        tracerOrigin = tostring(Value[1])
    end,
})

local _tracerColorPicker = CharacterTab:CreateColorPicker({
    Name = "Tracer Color",
    Color = Color3.new(1, 1, 1),
    Callback = function(Value)
        tracerColor = Value
    end
})

local _tracerTransparencySlider = CharacterTab:CreateSlider({
    Name = "Tracer Transparency",
    Range = {0, 1},
    Increment = 0.01,
    Suffix = "",
    CurrentValue = 0,
    Flag = "tracer_transparency",
    Callback = function(Value)
        tracerTransparency = Value
    end,
})

local _tracerOutlineColorPicker = CharacterTab:CreateColorPicker({
    Name = "Outline Color",
    Color = Color3.new(0, 0, 0),
    Callback = function(Value)
        tracerOutlineColor = Value
    end
})

local _tracerOutlineTransparencySlider = CharacterTab:CreateSlider({
    Name = "Outline Transparency",
    Range = {0, 1},
    Increment = 0.01,
    Suffix = "",
    CurrentValue = 0.5,
    Flag = "tracer_outline_transparency",
    Callback = function(Value)
        tracerOutlineTransparency = Value
    end,
})

local function tracer_cleanup()
    for _, tracer in pairs(tracers) do
        tracer.line:Destroy()
        tracer.outline:Destroy()
    end
    tracers = {}
end

local originPoints = {
    Bottom = function() return Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y) end,
    Middle = function() return workspace.CurrentCamera.ViewportSize / 2 end,
    Top = function() return Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, 0) end,
    Mouse = function() return USER_INPUT_SERVICE:GetMouseLocation() end
}

local function get_origin_point()
    return originPoints[tracerOrigin]()
end

RUN_SERVICE.Heartbeat:Connect(function()
    if not tracerEnabled then return end
    
    local currentPlayers = game:GetService("Players"):GetPlayers()
    local currentPlayerSet = {}
    local origin = get_origin_point()
    
    for _, player in ipairs(currentPlayers) do
        currentPlayerSet[player] = true
    end
    
    for player in pairs(tracers) do
        if not currentPlayerSet[player] then
            tracers[player].line:Destroy()
            tracers[player].outline:Destroy()
            tracers[player] = nil
        end
    end
    
    for _, plr in ipairs(currentPlayers) do
        if plr == player then continue end
        
        local character = plr.Character
        if not character then continue end
        
        local humanoid = character.Humanoid
        local hrp = character.HumanoidRootPart
        
        local position, onScreen = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
        if not onScreen then
            if tracers[plr] then
                tracers[plr].line.Visible = false
                tracers[plr].outline.Visible = false
            end
            continue
        end
        
        local screenPosition = Vector2.new(position.X, position.Y)
        local tracer = tracers[plr]
        
        if not tracer then
            tracer = {
                outline = Drawing.new("Line"),
                line = Drawing.new("Line")
            }
            tracer.outline.Thickness = 3
            tracer.line.Thickness = 1
            tracers[plr] = tracer
        end
        
        -- Update line properties
        tracer.line.From = origin
        tracer.line.To = screenPosition
        tracer.line.Color = tracerColor
        tracer.line.Transparency = 1 - tracerTransparency
        tracer.line.Visible = true
        
        -- Update outline properties
        tracer.outline.From = origin
        tracer.outline.To = screenPosition
        tracer.outline.Color = tracerOutlineColor
        tracer.outline.Transparency = 1 - tracerOutlineTransparency
        tracer.outline.Visible = true
    end
end)

Rayfield:LoadConfiguration()

queue_on_teleport([[
    loadstring(game:HttpGet("https://raw.githubusercontent.com/tiipolp/roblox-scripts/refs/heads/main/locked.lua"))()
]])
--[[ TODO
    PRIO MID: add support for multiple traits and weapons
     -- i added traits but idk if they work, test it out.
    PRIO LOW: add support for exclusive traits
    PRIO LOW: make trait picker better, lotta problems w it and its hard to use
    PRIO HIGH: fix auto gk PARTIALLY DONE
    PRIO MID: make anti steal better, done maybe idk have to test it out
    PRIO LOW: auto roll everything
    PRIO MID: player radar/arrow pointer on side of screen
--]]
