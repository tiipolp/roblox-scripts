--!nolint DeprecatedApi
--!nolint BuiltinGlobalWrite
--!nolint LocalShadow
--!nolint DuplicateFunction
--!nolint IntegerParsing
-- getgenv().newcclosure = nil

queue_on_teleport([[
    loadstring(game:HttpGet("https://raw.githubusercontent.com/tiipolp/roblox-scripts/refs/heads/main/locked.lua"))()
]])

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local iframeHighlightEnabled = false

local kickHighlightEnabled = false

repeat wait(1) until game:GetService("Players").LocalPlayer

local player = game:GetService("Players").LocalPlayer

repeat wait(1) until player.Character

if not player.Character then player.CharacterAdded:Wait() end

local character = player.Character
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

local VIRTUAL_INPUT_MANAGER = game:GetService("VirtualInputManager")
local RUN_SERVICE = game:GetService("RunService")
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
            whatToRoll = Value
        end,
    })
    
    game.ReplicatedStorage.rerolls.specreroll.OnClientEvent:Connect(function(weapon, idk)
        weaponRolled = tostring(weapon)
        print(weaponRolled)
    end)

    local _startRollingToggle
 
    _startRollingToggle = LobbyTab:CreateToggle({
        Name = "Start Rolling",
        CurrentValue = false,
        Callback = function(Value)
            if whatToRoll[1] == "Weapon" then
                while _startRollingToggle.CurrentValue do
                    if weaponRollingFor == nil then
                        _startRollingToggle:Set(false)
                        break
                    end

                    game:GetService("ReplicatedStorage"):WaitForChild("rerolls"):WaitForChild("specreroll"):FireServer()
                    

                    wait(0.3)

                    for i,v in weaponRollingFor do                        
                        if weaponRolled == nil or weaponRolled == v or game:GetService("ReplicatedStorage").Specs:WaitForChild((weaponRolled:lower():gsub("(%a)(%w*)", function(a, b) return a:upper() .. b end))):GetAttribute("rarity") == v then
                            _startRollingToggle:Set(false)
                            break
                        end
                    end
                end
            elseif whatToRoll[1] == "Trait" then
                while _startRollingToggle.CurrentValue do
                    if traitRollingFor == nil then
                        _startRollingToggle:Set(false)
                        break
                    end

                    game:GetService("ReplicatedStorage"):WaitForChild("rerolls"):WaitForChild("traitreroll"):FireServer()


                    wait(0.3)

                    for i,v in traitRollingFor do
                        if traitRolled.Text == v or game:GetService("ReplicatedStorage").Specs.Traits:WaitForChild((traitRolled.Text:lower():gsub("(%a)(%w*)", function(a, b) return a:upper() .. b end))):GetAttribute("rarity") == v then
                            _startRollingToggle:Set(false)
                            break
                        end
                    end
                end
            elseif whatToRoll[1] == "Height" then
                while _startRollingToggle.CurrentValue do
                    if heightInput == nil or (heightInput2 == nil and heightCompare[1] == "Range (height1 - height2)") or heightCompare[1] == nil then
                        _startRollingToggle:Set(false)
                        break
                    end

                    game:GetService("ReplicatedStorage"):WaitForChild("rerolls"):WaitForChild("heightreroll"):FireServer()
                    
                    wait(0.3)

                    local heightInput1 = heightInput
                    local heightInput2 = heightInput2
                    local height2 = customization.PhysicalSlide.Reroll.Text

                    if heightCompare[1] == "<" then
                        if heightToInches(height2) < heightToInches(heightInput1) then
                            _startRollingToggle:Set(false)
                            break
                        end
                    elseif heightCompare[1] == ">" then
                        if heightToInches(height2) > heightToInches(heightInput1) then
                            _startRollingToggle:Set(false)
                            break
                        end

                    elseif heightCompare[1] == ">=" then
                        if heightToInches(height2) >= heightToInches(heightInput1) then
                            _startRollingToggle:Set(false)
                            break

                        end
                    elseif heightCompare[1] == "<=" then
                        if heightToInches(height2) <= heightToInches(heightInput1) then
                            _startRollingToggle:Set(false)
                            break

                        end
                    elseif heightCompare[1] == "=" then
                        if heightToInches(height2) == heightToInches(heightInput1) then
                            _startRollingToggle:Set(false)
                            break

                        end
                    elseif heightCompare[1] == "Range (height1 - height2)" then
                        if heightToInches(height2) >= heightToInches(heightInput1) and heightToInches(height2) <= heightToInches(heightInput2) then
                            _startRollingToggle:Set(false)
                            break
                        end
                    end
                end
            elseif whatToRoll[1] == "Flow Buff" then
                while _startRollingToggle.CurrentValue do
                    if flowBuffPercentage == nil or flowBuffType == nil then
                        _startRollingToggle:Set(false)
                        break
                    end

                    game:GetService("ReplicatedStorage"):WaitForChild("rerolls"):WaitForChild("buffreroll"):FireServer()

                    wait(0.1)

                    if tonumber(string.match(customization.FlowSlide.buffreroll.Text, "%d+%.?%d*")) >= flowBuffPercentage or whatToRoll[1] ~= "Flow Buff" then
                        if #flowBuffType >= 1 then
                            for i,v in flowBuffType do
                                if string.lower(customization.FlowSlide.buffreroll.Text:gsub("[^a-zA-Z]", "")) == string.lower(v) then
                                    _startRollingToggle:Set(false)
                                    break
                                end
                            end
                        else
                            _startRollingToggle:Set(false)

                            break
                        end
                    end
                end
            end
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

    return type(a) == "number" and string.format("%d", a) == string.format("%d", b) or a == b
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

local dribble = function()
end-- fuck luau lsp :broken_heart:

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
    local regenVal = 0.02
    local degenVal = 0.08

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
    dribble = function(method)
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
    local kickPowerZone = false
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
            if kickPowerZone and workspace:FindFirstChild("CompletedZoneArea") then
                if hrp then
                    local distanceVector = (hrp.Position - workspace.CompletedZoneArea.Position)
                    local halfSize = workspace.CompletedZoneArea.Size / 2
                    
                    if math.abs(distanceVector.X) <= halfSize.X and math.abs(distanceVector.Z) <= halfSize.Z then
                        -- In zone, apply power
                        local modArgs = {}
                        for i,v in pairs(args) do
                            modArgs[i] = v
                        end
                        modArgs[2] = round(math.floor((139 * (1 + customPower)) * 10) / 10, 0)
                        game:GetService("ReplicatedStorage"):WaitForChild("shoot"):FireServer(unpack(modArgs))            
                        return nil
                    end

                    return nil
                end
            else
                local modArgs = {}
                for i,v in pairs(args) do
                    modArgs[i] = v
                end
                modArgs[2] = round(math.floor((139 * (1 + customPower)) * 10) / 10, 0)
                game:GetService("ReplicatedStorage"):WaitForChild("shoot"):FireServer(unpack(modArgs))            
                return nil
            end
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

    ShootingTab:CreateLabel("The kick power zone is where the kick power should apply. So when your inside the zone with this toggled on, kick power turns on, when your not, it turns off")

    local _kickPowerZoneToggle = ShootingTab:CreateToggle({
        Name = "Kick Power Zone",
        CurrentValue = false,
        Flag = "kick_power_zone_toggle",
        Callback = function(Value)
            kickPowerZone = Value
        end,
    })

    local _kickPowerCreateZoneButton = ShootingTab:CreateButton({
        Name = "Create Kick Power Zone",
        Callback = function()
            local function sandbox(var,func)
                local env = getfenv(func)
                local newenv = setmetatable({},{
                    __index = function(self,k)
                        if k=="script" then
                            return var
                        else
                            return env[k]
                        end
                    end,
                })
                setfenv(func,newenv)
                return func
            end
            
            local cors = {}
            local mas = Instance.new("Model", game:GetService("Lighting"))
            
            local CombinedScript = Instance.new("LocalScript")
            CombinedScript.Name = "ZoneAndFreecam"
            CombinedScript.Parent = mas
            
            table.insert(cors, sandbox(CombinedScript, function()
                -- Services
                local ContextActionService = game:GetService("ContextActionService")
                local Players = game:GetService("Players")
                local RunService = game:GetService("RunService")
                local StarterGui = game:GetService("StarterGui")
                local UserInputService = game:GetService("UserInputService")
                local Workspace = game:GetService("Workspace")
            
                local LocalPlayer = Players.LocalPlayer
            
                if not LocalPlayer then
                    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
                    LocalPlayer = Players.LocalPlayer
                end
            
                local mouse = LocalPlayer:GetMouse()
                local Camera = workspace.CurrentCamera
            
                workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
                    local newCamera = workspace.CurrentCamera
                    if newCamera then
                        Camera = newCamera
                    end
                end)
            
                -- Forward declare functions
                local StopFreecam
                local cleanupPointsAndPreview
                local stopZoneCreation
                local completeZone_Actual
                local removePoint
            
                -- Zone Creation Settings & State
                local MAX_POINTS = 4
                local MARKER_SIZE = Vector3.new(1, 1, 1)
                local MARKER_COLOR = Color3.fromRGB(255, 255, 0) -- Yellow
                local ZONE_PREVIEW_COLOR = Color3.fromRGB(0, 255, 255) -- Cyan
                local ZONE_PREVIEW_TRANS = 0.7
            
                local placingPoints = false
                local points = {}
                local zonePreview = nil
                local finalZone = nil
                local screenGui_Zone = nil
                local completeButtonRef_Zone = nil
            
                -- Freecam Code
                do
                    local pi = math.pi
                    local abs = math.abs
                    local clamp = math.clamp
                    local exp = math.exp
                    local rad = math.rad
                    local sign = math.sign
                    local sqrt = math.sqrt
                    local tan = math.tan
            
                    local INPUT_PRIORITY = Enum.ContextActionPriority.High.Value
            
                    local NAV_GAIN = Vector3.new(1, 1, 1)*64
                    local PAN_GAIN = Vector2.new(0.75, 1)*8
                    local FOV_GAIN = 300
                    local PITCH_LIMIT = rad(90)
                    local VEL_STIFFNESS = 10
                    local PAN_STIFFNESS = 10
                    local FOV_STIFFNESS = 4.0
            
                    local Spring = {}
                    do
                        Spring.__index = Spring
                        function Spring.new(freq, pos)
                            local self = setmetatable({}, Spring)
                            self.f = freq
                            self.p = pos
                            self.v = pos*0
                            return self
                        end
                        
                        function Spring:Update(dt, goal)
                            local f = self.f*2*pi
                            local p0 = self.p
                            local v0 = self.v
                            local offset = goal - p0
                            local decay = exp(-f*dt)
                            local p1 = goal + (v0*dt - offset*(f*dt + 1))*decay
                            local v1 = (f*dt*(offset*f - v0) + v0)*decay
                            self.p = p1
                            self.v = v1
                            return p1
                        end
                        
                        function Spring:Reset(pos)
                            self.p = pos
                            self.v = pos*0
                        end
                    end
            
                    local cameraPos = Vector3.new()
                    local cameraRot = Vector2.new()
                    local cameraFov = 0
                    local velSpring = Spring.new(VEL_STIFFNESS, Vector3.new())
                    local panSpring = Spring.new(PAN_STIFFNESS, Vector2.new())
                    local fovSpring = Spring.new(FOV_STIFFNESS, 0)
            
                    local Input = {}
                    do
                        local thumbstickCurve
                        do
                            local K_CURVATURE = 2.0
                            local K_DEADZONE = 0.15
                            local function fCurve(x)
                                return (exp(K_CURVATURE*x) - 1)/(exp(K_CURVATURE) - 1)
                            end
                            local function fDeadzone(x)
                                return fCurve((x - K_DEADZONE)/(1 - K_DEADZONE))
                            end
                            function thumbstickCurve(x)
                                return sign(x)*clamp(fDeadzone(abs(x)), 0, 1)
                            end
                        end
                        
                        local gamepad = {
                            ButtonX=0, ButtonY=0, DPadDown=0, DPadUp=0,
                            ButtonL2=0, ButtonR2=0, Thumbstick1=Vector2.new(), Thumbstick2=Vector2.new()
                        }
                        
                        local keyboard = {
                            W=0, A=0, S=0, D=0, E=0, Q=0, U=0, H=0, J=0, K=0, I=0, Y=0,
                            Up=0, Down=0, LeftShift=0, RightShift=0
                        }
                        
                        local mouse_fc = {Delta=Vector2.new(), MouseWheel=0}
                        
                        local NAV_GAMEPAD_SPEED = Vector3.new(1, 1, 1)
                        local NAV_KEYBOARD_SPEED = Vector3.new(1, 1, 1)
                        local PAN_MOUSE_SPEED = Vector2.new(1, 1)*(pi/64)
                        local PAN_GAMEPAD_SPEED = Vector2.new(1, 1)*(pi/8)
                        local FOV_WHEEL_SPEED = 1.0
                        local FOV_GAMEPAD_SPEED = 0.25
                        local NAV_ADJ_SPEED = 0.75
                        local NAV_SHIFT_MUL = 0.25
                        local navSpeed = 1
                        
                        function Input.Vel(dt)
                            navSpeed = clamp(navSpeed + dt*(keyboard.Up - keyboard.Down)*NAV_ADJ_SPEED, 0.01, 4)
                            local kGamepad = Vector3.new(
                                thumbstickCurve(gamepad.Thumbstick1.x),
                                thumbstickCurve(gamepad.ButtonR2) - thumbstickCurve(gamepad.ButtonL2),
                                thumbstickCurve(-gamepad.Thumbstick1.y)
                            )*NAV_GAMEPAD_SPEED
                            
                            local kKeyboard = Vector3.new(
                                keyboard.D - keyboard.A + keyboard.K - keyboard.H,
                                keyboard.E - keyboard.Q + keyboard.I - keyboard.Y,
                                keyboard.S - keyboard.W + keyboard.J - keyboard.U
                            )*NAV_KEYBOARD_SPEED
                            
                            local shift = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
                            return (kGamepad + kKeyboard)*(navSpeed*(shift and NAV_SHIFT_MUL or 1))
                        end
                        
                        function Input.Pan(dt)
                            local kGamepad = Vector2.new(
                                thumbstickCurve(gamepad.Thumbstick2.y),
                                thumbstickCurve(-gamepad.Thumbstick2.x)
                            )*PAN_GAMEPAD_SPEED
                            
                            local kMouse = mouse_fc.Delta*PAN_MOUSE_SPEED
                            mouse_fc.Delta = Vector2.new()
                            return kGamepad + kMouse
                        end
                        
                        function Input.Fov(dt)
                            local kGamepad = (gamepad.ButtonX - gamepad.ButtonY)*FOV_GAMEPAD_SPEED
                            local kMouse = mouse_fc.MouseWheel*FOV_WHEEL_SPEED
                            mouse_fc.MouseWheel = 0
                            return kGamepad + kMouse
                        end
                        
                        do
                            local function Keypress(action, state, input)
                                keyboard[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
                                return Enum.ContextActionResult.Sink
                            end
                            
                            local function GpButton(action, state, input)
                                gamepad[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
                                return Enum.ContextActionResult.Sink
                            end
                            
                            local function MousePan(action, state, input)
                                local delta = input.Delta
                                mouse_fc.Delta = Vector2.new(-delta.y, -delta.x)
                                return Enum.ContextActionResult.Sink
                            end
                            
                            local function Thumb(action, state, input)
                                gamepad[input.KeyCode.Name] = input.Position
                                return Enum.ContextActionResult.Sink
                            end
                            
                            local function Trigger(action, state, input)
                                gamepad[input.KeyCode.Name] = input.Position.z
                                return Enum.ContextActionResult.Sink
                            end
                            
                            local function MouseWheel(action, state, input)
                                mouse_fc[input.UserInputType.Name] = -input.Position.z
                                return Enum.ContextActionResult.Sink
                            end
                            
                            local function Zero(t)
                                for k, v in pairs(t) do
                                    t[k] = v*0
                                end
                            end
                            
                            function Input.StartCapture()
                                ContextActionService:BindActionAtPriority("FreecamKeyboard", Keypress, false, INPUT_PRIORITY,
                                    Enum.KeyCode.W, Enum.KeyCode.U, Enum.KeyCode.A, Enum.KeyCode.H, Enum.KeyCode.S, Enum.KeyCode.J,
                                    Enum.KeyCode.D, Enum.KeyCode.K, Enum.KeyCode.E, Enum.KeyCode.I, Enum.KeyCode.Q, Enum.KeyCode.Y,
                                    Enum.KeyCode.Up, Enum.KeyCode.Down
                                )
                                ContextActionService:BindActionAtPriority("FreecamMousePan", MousePan, false, INPUT_PRIORITY, Enum.UserInputType.MouseMovement)
                                ContextActionService:BindActionAtPriority("FreecamMouseWheel", MouseWheel, false, INPUT_PRIORITY, Enum.UserInputType.MouseWheel)
                                ContextActionService:BindActionAtPriority("FreecamGamepadButton", GpButton, false, INPUT_PRIORITY, Enum.KeyCode.ButtonX, Enum.KeyCode.ButtonY)
                                ContextActionService:BindActionAtPriority("FreecamGamepadTrigger", Trigger, false, INPUT_PRIORITY, Enum.KeyCode.ButtonR2, Enum.KeyCode.ButtonL2)
                                ContextActionService:BindActionAtPriority("FreecamGamepadThumbstick", Thumb, false, INPUT_PRIORITY, Enum.KeyCode.Thumbstick1, Enum.KeyCode.Thumbstick2)
                            end
                            
                            function Input.StopCapture()
                                navSpeed = 1
                                Zero(gamepad)
                                Zero(keyboard)
                                Zero(mouse_fc)
                                ContextActionService:UnbindAction("FreecamKeyboard")
                                ContextActionService:UnbindAction("FreecamMousePan")
                                ContextActionService:UnbindAction("FreecamMouseWheel")
                                ContextActionService:UnbindAction("FreecamGamepadButton")
                                ContextActionService:UnbindAction("FreecamGamepadTrigger")
                                ContextActionService:UnbindAction("FreecamGamepadThumbstick")
                            end
                        end
                    end
            
                    local function StepFreecam(dt)
                        local vel = velSpring:Update(dt, Input.Vel(dt))
                        local pan = panSpring:Update(dt, Input.Pan(dt))
                        local fov = fovSpring:Update(dt, Input.Fov(dt))
                        local zoomFactor = sqrt(tan(rad(70/2))/tan(rad(cameraFov/2)))
                        
                        cameraFov = clamp(cameraFov + fov*FOV_GAIN*(dt/zoomFactor), 1, 120)
                        cameraRot = cameraRot + pan*PAN_GAIN*(dt/zoomFactor)
                        cameraRot = Vector2.new(clamp(cameraRot.x, -PITCH_LIMIT, PITCH_LIMIT), cameraRot.y%(2*pi))
                        
                        local cameraCFrame = CFrame.new(cameraPos)*CFrame.fromOrientation(cameraRot.x, cameraRot.y, 0)*CFrame.new(vel*NAV_GAIN*dt)
                        cameraPos = cameraCFrame.p
                        Camera.CFrame = cameraCFrame
                        Camera.FieldOfView = cameraFov
                    end
            
                    local PlayerState = {}
                    do
                        local cameraSubject
                        local cameraType
                        local cameraFieldOfView
                        local screenGuis = {}
                        local coreGuis = {Backpack=true, Chat=true, Health=true, PlayerList=true}
                        local setCores = {BadgesNotificationsActive=true, PointsNotificationsActive=true}
                        local mouseBehavior
                        local mouseIconEnabled
                        
                        function PlayerState.Push()
                            for name in pairs(coreGuis) do
                                coreGuis[name] = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType[name])
                                StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[name], false)
                            end
                            
                            for name in pairs(setCores) do
                                setCores[name] = StarterGui:GetCore(name)
                                StarterGui:SetCore(name, false)
                            end
                            
                            local playergui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                            if playergui then
                                for _, gui in pairs(playergui:GetChildren()) do
                                    if gui:IsA("ScreenGui") and gui.Enabled and gui ~= screenGui_Zone then
                                        screenGuis[#screenGuis + 1] = gui
                                        gui.Enabled = false
                                    end
                                end
                            end
                            
                            cameraFieldOfView = Camera.FieldOfView
                            Camera.FieldOfView = 70
                            cameraType = Camera.CameraType
                            Camera.CameraType = Enum.CameraType.Scriptable
                            cameraSubject = Camera.CameraSubject
                            Camera.CameraSubject = nil
                            mouseIconEnabled = UserInputService.MouseIconEnabled
                            UserInputService.MouseIconEnabled = false
                            mouseBehavior = UserInputService.MouseBehavior
                            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
                        end
                        
                        function PlayerState.Pop()
                            for name, isEnabled in pairs(coreGuis) do
                                StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[name], isEnabled)
                            end
                            
                            for name, isEnabled in pairs(setCores) do
                                StarterGui:SetCore(name, isEnabled)
                            end
                            
                            for _, gui in pairs(screenGuis) do
                                if gui.Parent then
                                    gui.Enabled = true
                                end
                            end
                            screenGuis = {}
                            
                            if cameraFieldOfView then
                                Camera.FieldOfView = cameraFieldOfView
                                cameraFieldOfView = nil
                            end
                            
                            if cameraType then
                                Camera.CameraType = cameraType
                                cameraType = nil
                            end
                            
                            if cameraSubject then
                                Camera.CameraSubject = cameraSubject
                                cameraSubject = nil
                            end
                            
                            if mouseIconEnabled ~= nil then
                                UserInputService.MouseIconEnabled = mouseIconEnabled
                                mouseIconEnabled = nil
                            end
                            
                            if mouseBehavior ~= nil then
                                UserInputService.MouseBehavior = mouseBehavior
                                mouseBehavior = nil
                            end
                        end
                    end
            
                    local freecamActuallyEnabled = false
            
                    local function StartFreecam()
                        if freecamActuallyEnabled then return end
                        print("Starting User Freecam Module")
                        
                        local cameraCFrame = Camera.CFrame
                        cameraRot = Vector2.new(cameraCFrame:toEulerAnglesYXZ())
                        cameraPos = cameraCFrame.p
                        cameraFov = Camera.FieldOfView
                        
                        velSpring:Reset(Vector3.new())
                        panSpring:Reset(Vector2.new())
                        fovSpring:Reset(0)
                        
                        PlayerState.Push()
                        RunService:BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value, StepFreecam)
                        Input.StartCapture()
                        freecamActuallyEnabled = true
                    end
            
                    StopFreecam = function()
                        if not freecamActuallyEnabled then return end
                        print("Stopping User Freecam Module")
                        
                        Input.StopCapture()
                        RunService:UnbindFromRenderStep("Freecam")
                        PlayerState.Pop()
                        freecamActuallyEnabled = false
                    end
            
                    StartFreecam()
                end
            
                -- Zone Creation Functions
                local function updatePreview()
                    if #points < 2 then
                        if zonePreview then zonePreview:Destroy(); zonePreview = nil end
                        return
                    end
                    
                    local minP = Vector3.new(math.huge, math.huge, math.huge)
                    local maxP = Vector3.new(-math.huge, -math.huge, -math.huge)
                    
                    for _, data in ipairs(points) do
                        minP = minP:Min(data.Position)
                        maxP = maxP:Max(data.Position)
                    end
                    
                    local size = maxP - minP
                    size = Vector3.new(math.max(size.X, 0.1), math.max(size.Y, 0.1), math.max(size.Z, 0.1))
                    local center = minP + size / 2
                    
                    if not zonePreview then
                        zonePreview = Instance.new("Part")
                        zonePreview.Name = "ZoneVisualPreview"
                        zonePreview.Shape = Enum.PartType.Block
                        zonePreview.Material = Enum.Material.SmoothPlastic
                        zonePreview.Color = ZONE_PREVIEW_COLOR
                        zonePreview.Transparency = ZONE_PREVIEW_TRANS
                        zonePreview.Anchored = true
                        zonePreview.CanCollide = false
                        zonePreview.CanQuery = false
                        zonePreview.CanTouch = false
                        zonePreview.Locked = true
                        zonePreview.Parent = Workspace
                    end
                    
                    zonePreview.Size = size
                    zonePreview.CFrame = CFrame.new(center)
                end
            
                local function addPoint(pos)
                    if not placingPoints or #points >= MAX_POINTS then return end
                    
                    local marker = Instance.new("Part")
                    marker.Name = "ZoneMarkerPoint"
                    marker.Shape = Enum.PartType.Ball
                    marker.Material = Enum.Material.Neon
                    marker.Size = MARKER_SIZE
                    marker.Color = MARKER_COLOR
                    marker.Anchored = true
                    marker.CanCollide = false
                    marker.CanQuery = true
                    marker.CanTouch = false
                    marker.Locked = true
                    marker.CFrame = CFrame.new(pos)
                    marker.Parent = Workspace
                    
                    table.insert(points, { Part = marker, Position = pos })
                    print("Point", #points, "added")
                    
                    updatePreview()
                    
                    if completeButtonRef_Zone and #points == MAX_POINTS then
                        completeButtonRef_Zone.Active = true
                        completeButtonRef_Zone.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
                        print("Ready to complete zone.")
                    end
                end
            
                removePoint = function(actionName, inputState, inputObj)
                    if not placingPoints then return Enum.ContextActionResult.Pass end
                    
                    if inputState == Enum.UserInputState.Begin then
                        local target = mouse.Target
                        if target and target.Name == "ZoneMarkerPoint" then
                            local index = -1
                            for i, data in ipairs(points) do
                                if data.Part == target then
                                    index = i
                                    break
                                end
                            end
                            
                            if index > 0 then
                                print("Removing point", index)
                                local removedData = table.remove(points, index)
                                removedData.Part:Destroy()
                                updatePreview()
                                
                                if completeButtonRef_Zone then
                                    completeButtonRef_Zone.Active = false
                                    completeButtonRef_Zone.BackgroundColor3 = Color3.fromRGB(100, 150, 100)
                                end
                                
                                return Enum.ContextActionResult.Sink
                            end
                        end
                    end
                    
                    return Enum.ContextActionResult.Pass
                end
            
                cleanupPointsAndPreview = function()
                    print("Cleaning up points and preview...")
                    
                    if zonePreview then
                        zonePreview:Destroy()
                        zonePreview = nil
                    end
                    
                    for _, data in ipairs(points) do
                        if data.Part then
                            data.Part:Destroy()
                        end
                    end
                    
                    points = {}
                    
                    if completeButtonRef_Zone then
                        completeButtonRef_Zone.Active = false
                        completeButtonRef_Zone.BackgroundColor3 = Color3.fromRGB(100, 150, 100)
                    end
                end
            
                completeZone_Actual = function()
                    if #points ~= MAX_POINTS then
                        warn("Not enough points!")
                        return
                    end
                    
                    print("Completing zone...")
                    
                    if zonePreview then
                        finalZone = zonePreview:Clone()
                        finalZone.Name = "CompletedZoneArea"
                        finalZone.Transparency = 1
                        finalZone.Color = Color3.fromRGB(0, 0, 0)
                        finalZone.CanCollide = false
                        finalZone.CanQuery = true
                        finalZone.CanTouch = true
                        finalZone.Parent = Workspace
                        print("Final zone created:", finalZone:GetFullName())
                    else
                        warn("Zone preview missing?")
                    end
                    
                    cleanupPointsAndPreview()
                    if StopFreecam then StopFreecam() end
                    ContextActionService:UnbindAction("ToggleMouseLock") -- Unbind mouse lock toggle
                    ContextActionService:UnbindAction("RemovePointAction_Zone") -- Unbind right-click remove
                    if screenGui_Zone then screenGui_Zone:Destroy(); screenGui_Zone = nil end
                    placingPoints = false
                end

                local centerIndicator, mouseLockIndicator
            
                stopZoneCreation = function()
                    print("Stopping zone creation...")
                    if StopFreecam then StopFreecam() end
                    cleanupPointsAndPreview()
                    ContextActionService:UnbindAction("ToggleMouseLock") -- Unbind mouse lock toggle
                    ContextActionService:UnbindAction("RemovePointAction_Zone") -- Unbind right-click remove
                    if screenGui_Zone then screenGui_Zone:Destroy(); screenGui_Zone = nil end
                    centerIndicator = nil
                    mouseLockIndicator = nil
                    placingPoints = false
                end
            
                local function setupUI_Zone()
                    if screenGui_Zone then screenGui_Zone:Destroy() end
                    
                    screenGui_Zone = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
                    screenGui_Zone.Name = "ZoneCreatorUI_" .. math.random(1000)
                    screenGui_Zone.ResetOnSpawn = false
                    
                    local frame = Instance.new("Frame", screenGui_Zone)
                    frame.Size = UDim2.new(0, 300, 0, 50)
                    frame.Position = UDim2.new(0.5, -150, 1, -70)
                    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    frame.BackgroundTransparency = 0.3
                    frame.BorderSizePixel = 0
                    
                    local stopBtn = Instance.new("TextButton", frame)
                    stopBtn.Name = "StopButton"
                    stopBtn.Size = UDim2.new(0.48, 0, 1, 0)
                    stopBtn.Position = UDim2.new(0, 0, 0, 0)
                    stopBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                    stopBtn.Text = "Stop"
                    stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    stopBtn.Font = Enum.Font.SourceSansBold
                    stopBtn.TextSize = 18
                    stopBtn.MouseButton1Click:Connect(stopZoneCreation)
                    
                    local completeBtn = Instance.new("TextButton", frame)
                    completeBtn.Name = "CompleteButton"
                    completeBtn.Size = UDim2.new(0.48, 0, 1, 0)
                    completeBtn.Position = UDim2.new(0.52, 0, 0, 0)
                    completeBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 100)
                    completeBtn.Text = "Complete Zone"
                    completeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    completeBtn.Font = Enum.Font.SourceSansBold
                    completeBtn.TextSize = 18
                    completeBtn.AutoButtonColor = true
                    completeBtn.Active = false
                    completeBtn.MouseButton1Click:Connect(completeZone_Actual)
                    
                    completeButtonRef_Zone = completeBtn
                end
                
                local function handleZoneInput(input, processed)
                    if processed then return end
                    if not placingPoints then return end
            
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local mousePos = UserInputService:GetMouseLocation()
                        local unitRay = Camera:ScreenPointToRay(mousePos.X, mousePos.Y)
                        local params = RaycastParams.new()
                        local filter = {LocalPlayer.Character}
                        
                        for _, data in ipairs(points) do
                            table.insert(filter, data.Part)
                        end
                        
                        if zonePreview then
                            table.insert(filter, zonePreview)
                        end
                        
                        params.FilterDescendantsInstances = filter
                        params.FilterType = Enum.RaycastFilterType.Exclude
                        local result = Workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000, params)
                        
                        if result then
                            addPoint(result.Position)
                        else
                            print("Zone Click: Missed world geometry.")
                        end
                    end
                end
            
                local mouseIsLocked = true
            
                local function toggleMouseLock(actionName, inputState, inputObject)
                    if inputState == Enum.UserInputState.Begin then
                        mouseIsLocked = not mouseIsLocked
                        
                        if mouseIsLocked then
                            UserInputService.MouseIconEnabled = false
                            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
                            if mouseLockIndicator then
                                mouseLockIndicator.Text = "MOUSE LOCKED (Ctrl to unlock)"
                                mouseLockIndicator.TextColor3 = Color3.fromRGB(255, 100, 100)
                            end
                        else
                            UserInputService.MouseIconEnabled = true
                            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                            if mouseLockIndicator then
                                mouseLockIndicator.Text = "MOUSE UNLOCKED (Ctrl to lock)"
                                mouseLockIndicator.TextColor3 = Color3.fromRGB(100, 255, 100)
                            end
                        end
                    end
                    
                    return Enum.ContextActionResult.Sink
                end
            
                local function setupMouseLockToggle()
                    ContextActionService:BindActionAtPriority(
                        "ToggleMouseLock", 
                        toggleMouseLock, 
                        false, 
                        Enum.ContextActionPriority.High.Value + 10, 
                        Enum.KeyCode.LeftControl, 
                        Enum.KeyCode.RightControl
                    )
                end
                            
                local function setupScreenIndicators()
                    -- Center dot
                    centerIndicator = Instance.new("Frame", screenGui_Zone)
                    centerIndicator.Size = UDim2.new(0, 10, 0, 10)
                    centerIndicator.Position = UDim2.new(0.5, -5, 0.5, -5)
                    centerIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    centerIndicator.BorderSizePixel = 0
                    
                    local circle = Instance.new("UICorner", centerIndicator)
                    circle.CornerRadius = UDim.new(1, 0)
                    
                    -- Controls indicator
                    mouseLockIndicator = Instance.new("TextLabel", screenGui_Zone)
                    mouseLockIndicator.Size = UDim2.new(0, 300, 0, 30)
                    mouseLockIndicator.Position = UDim2.new(0.5, -150, 0, 10)
                    mouseLockIndicator.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    mouseLockIndicator.BackgroundTransparency = 0.5
                    mouseLockIndicator.TextColor3 = Color3.fromRGB(255, 100, 100)
                    mouseLockIndicator.Text = "MOUSE LOCKED (Ctrl to unlock)"
                    mouseLockIndicator.Font = Enum.Font.SourceSansBold
                    mouseLockIndicator.TextSize = 16
                    
                    local corner = Instance.new("UICorner", mouseLockIndicator)
                    corner.CornerRadius = UDim.new(0, 5)
                end
            
                -- Initialization
                local function startZoneCreation()
                    print("Starting zone creation process...")
                    cleanupPointsAndPreview()
                    setupUI_Zone()
                    setupScreenIndicators()
                    setupMouseLockToggle()
                    placingPoints = true
                    ContextActionService:BindAction("RemovePointAction_Zone", removePoint, false, Enum.UserInputType.MouseButton2)
                    print("Zone Creation Active. Left-click to place points, Right-click points to remove.")
                end
            
                UserInputService.InputBegan:Connect(handleZoneInput)
            
                local function fullCleanup()
                    print("Full cleanup...")
                    stopZoneCreation()
                end
            
                if LocalPlayer.Character then
                    LocalPlayer.Character.Destroying:Connect(fullCleanup)
                end
                
                LocalPlayer.CharacterAdded:Connect(function(char)
                    char.Destroying:Connect(fullCleanup)
                end)
            
                startZoneCreation()
                print("Zone Creator + Freecam Loaded.")
            end))
            
            for i,v in pairs(mas:GetChildren()) do
                v.Parent = game:GetService("Players").LocalPlayer.PlayerGui
            end
            
            mas:Destroy()
            
            for i,v in pairs(cors) do
                spawn(function()
                    local success, err = pcall(v)
                    if not success then
                        warn("Error running sandboxed script:", err)
                    end
                end)
            end
        end
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
local AUTO_GK_ENABLED = false -- Renamed for clarity within the main script

-- Configuration (Consider making these UI elements later)
local DASH_DISTANCE_GK = 30 -- How far the Q dash travels (in studs)
local DASH_TRIGGER_DISTANCE_BUFFER_GK = 5 -- How much closer (horizontally) prediction needs to be
local LOOK_AT_DISTANCE_THRESHOLD_GK = 60 -- How close ball needs to be to look
local PREDICTION_TIME_AHEAD_GK = 0.25 -- **TUNED: Shorter prediction time (seconds)**
local MIN_BALL_SPEED_TO_CONSIDER_GK = 15 -- Minimum ball speed (studs/sec)
local JUMP_HEIGHT_THRESHOLD_GK = 7 -- Predicted height relative to head to jump
local DASH_COOLDOWN_GK = 1.0 -- Minimum seconds between dashes
local MIN_FORWARD_DOT_PRODUCT_GK = 0.3 -- How "forward" target needs to be (0=sideways, 1=directly ahead)

-- State Variables
local isGKDashing = false -- Renamed GK-specific state
local lastGKDashTime = 0
local gkControlsAltered = false -- Track if we've turned AutoRotate off

-- Ball Validation Function (Uses existing player, hrp, character vars)
local function isGKBallValidTarget(ballInstance)
    -- Ensure dependencies exist
    if not ballInstance or not ballInstance:IsA("BasePart") or not player or not hrp then
        return false, "Ball or Player HRP invalid"
    end

    local velocity = ballInstance.AssemblyLinearVelocity
    local playerAttribute = ballInstance:GetAttribute("player")
    local teamAttribute = ballInstance:GetAttribute("team")
    -- Check all known iframe attributes in this game
    local iframesAttribute = ballInstance:GetAttribute("iframes")
    local headeriframesAttribute = ballInstance:GetAttribute("headeriframes")
    local kickiframesAttribute = ballInstance:GetAttribute("kickiframes")

    -- Check possession (self)
    if playerAttribute and playerAttribute == player.Name then
        return false, "Ball possessed by self"
    end

    -- Check possession (teammate)
    if teamAttribute and teamAttribute == tostring(player.Team) then
        return false, "Ball possessed by teammate"
    end

    -- Check iframes/invincibility while the ball is actively moving
    if velocity.Magnitude > 0 and
       ((iframesAttribute and iframesAttribute ~= "none") or
        (headeriframesAttribute and headeriframesAttribute ~= "none") or
        (kickiframesAttribute and kickiframesAttribute ~= "none")) then
        return false, "Ball has iframes and is moving"
    end

    -- Check minimum speed
    if velocity.Magnitude < MIN_BALL_SPEED_TO_CONSIDER_GK then
        return false, "Ball is moving too slowly"
    end

    -- Check if ball is moving generally towards the player (dot product check)
    if character and hrp then
        local ballToPlayerVector = (hrp.Position - ballInstance.Position)
        if ballToPlayerVector.Magnitude > 0.1 then
            local ballDirection = velocity.Unit
            -- Positive dot means velocity has component towards player. Threshold filters sideways/away.
            if ballDirection:Dot(ballToPlayerVector.Unit) < 0.15 then -- Tune threshold (0 to 1)
                 return false, "Ball not moving towards player"
            end
        end
    end

    return true, "Ball is a valid target"
end

-- Prediction Function (FIXED PHYSICS: Uses workspace.Gravity directly)
local function predictGKBallPosition(ballInstance, t)
    local velocity = ballInstance.AssemblyLinearVelocity
    local position = ballInstance.Position
    local currentGravity = 0.5 * -workspace.Gravity -- Use actual workspace gravity value

    local predictedX = position.X + velocity.X * t
    -- Correct physics formula for Y position
    local predictedY = position.Y + velocity.Y * t - 0.5 * currentGravity * t^2
    local predictedZ = position.Z + velocity.Z * t

    return Vector3.new(predictedX, predictedY, predictedZ)
end

-- Dash Function
local function executeGKDash()
    if isGKDashing or (tick() - lastGKDashTime < DASH_COOLDOWN_GK) then return end

    isGKDashing = true
    lastGKDashTime = tick()
    print("GK: Attempting Dash")

    -- Ensure VIRTUAL_INPUT_MANAGER is accessible
    if VIRTUAL_INPUT_MANAGER then
         VIRTUAL_INPUT_MANAGER:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
         task.wait(0.05) -- Brief delay between press and release
         VIRTUAL_INPUT_MANAGER:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
    else
        warn("GK: VIRTUAL_INPUT_MANAGER not found!")
    end

    -- Reset dash state after a short duration
    task.delay(0.15, function()
        isGKDashing = false
    end)
end

-- Jump Function
local function executeGKJump()
    if humanoid then
        humanoid.Jump = true
        print("GK: Attempting Jump")
    end
end

-- LookAt Function (HORIZONTAL ONLY, manages AutoRotate state)
local function lookAtGKTarget(targetPosition)
    if not humanoid or not hrp then return end

    -- Turn off AutoRotate if it's not already off by this script
    if humanoid.AutoRotate then
        humanoid.AutoRotate = false
        gkControlsAltered = true -- Mark that we changed it
    end

    -- Calculate look direction only on the horizontal plane (X, Z)
    local lookVectorHorizontal = (targetPosition - hrp.Position) * Vector3.new(1, 0, 1)

     if lookVectorHorizontal.Magnitude > 0.01 then -- Avoid issues if target is directly above/below or too close
        hrp.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + lookVectorHorizontal)
    end
end

-- Restore Controls Function (Turns AutoRotate back ON if we turned it off)
local function restoreGKControls()
    if gkControlsAltered and humanoid then
       humanoid.AutoRotate = true
       gkControlsAltered = false -- Mark as restored
       -- print("GK Controls Restored") -- Debug
    end
end

-- UI Toggle Setup (Connects the Rayfield toggle)
_autoGKToggle = GoalKeeperTab:CreateToggle({
    Name = "Auto GK",
    CurrentValue = false,
    Flag = "auto_gk_toggle", -- Make sure Flag is unique
    Callback = function(Value)
        AUTO_GK_ENABLED = Value
        if not Value then
            -- Ensure controls are restored when manually disabling the feature
            restoreGKControls()
        end
    end,
})

-- Main GK Loop Connection (Heartbeat)
RUN_SERVICE.Heartbeat:Connect(function(deltaTime)
    -- Early exit conditions
    if not AUTO_GK_ENABLED or not character or not humanoid or not hrp or humanoid.Health <= 0 then
        -- If feature was enabled but we exit here (e.g., player died), restore controls
        if AUTO_GK_ENABLED then restoreGKControls() end
        return
    end

    -- Safely find the ball
    local ball = workspace.BallFolder:FindFirstChild("Ball")
    if not ball then
        restoreGKControls() -- Restore controls if ball disappears
        return
    end

    -- Validate Ball Target
    local isValid = isGKBallValidTarget(ball)
    if not isValid then
        restoreGKControls() -- Restore controls if ball becomes invalid
        return
    end

    -- Calculations
    local playerPos = hrp.Position
    local ballPos = ball.Position
    local distanceToBall = (ballPos - playerPos).Magnitude

    -- Predict ball's future position using the corrected function
    local predictedBallPos = predictGKBallPosition(ball, PREDICTION_TIME_AHEAD_GK)
    if not predictedBallPos then
        restoreGKControls()
        return
    end

    -- Use Head position for height check, fallback if Head doesn't exist
    local playerHeadPos = character:FindFirstChild("Head") and character.Head.Position or (playerPos + Vector3.new(0, 2.5, 0))
    local predictedHeightDiff = predictedBallPos.Y - playerHeadPos.Y

    -- Horizontal projection of the predicted position onto the player's Y plane
    local predictedPosXZ = Vector3.new(predictedBallPos.X, playerPos.Y, predictedBallPos.Z)
    local horizontalDistanceToPredicted = (predictedPosXZ - playerPos).Magnitude

    -- Decision Making Variables
    local shouldLook = false
    local shouldDash = false
    local shouldJump = false

    -- 1. Look Decision: Look if ball is within threshold distance
    if distanceToBall < LOOK_AT_DISTANCE_THRESHOLD_GK then
        shouldLook = true
    end

    -- 2. Dash Decision: Check distance, height, cooldown, and FORWARD direction
    if horizontalDistanceToPredicted < (DASH_DISTANCE_GK - DASH_TRIGGER_DISTANCE_BUFFER_GK) and
       predictedHeightDiff < JUMP_HEIGHT_THRESHOLD_GK and
       not isGKDashing and
       (tick() - lastGKDashTime > DASH_COOLDOWN_GK) then

        -- Check if the predicted horizontal target is generally FORWARD
        local directionToPredictedXZ = (predictedPosXZ - playerPos)
        if directionToPredictedXZ.Magnitude > 0.1 then -- Avoid zero vector issues
            local directionUnit = directionToPredictedXZ.Unit
            local playerLookVectorXZ = hrp.CFrame.LookVector * Vector3.new(1, 0, 1)
            if playerLookVectorXZ.Magnitude > 0.1 then
                -- Positive dot product means target is in front hemisphere
                if playerLookVectorXZ.Unit:Dot(directionUnit) > MIN_FORWARD_DOT_PRODUCT_GK then
                    shouldDash = true
                    shouldLook = true -- Ensure we look before dashing
                -- else: Optional print("GK: Predicted dash target is not forward enough.")
                end
            end
        end
    end

    -- 3. Jump Decision: Check height threshold and horizontal proximity
    if predictedHeightDiff >= JUMP_HEIGHT_THRESHOLD_GK then
        local horizontalDistToActualBall = (Vector3.new(ballPos.X, playerPos.Y, ballPos.Z) - playerPos).Magnitude
        -- Is the ball horizontally close enough to be reachable with a jump?
        if horizontalDistToActualBall < 20 then -- Tune this jump radius
            shouldJump = true
            shouldLook = true -- Ensure we look if jumping
        end
    end

    -- Action Execution (Priority: Dash > Jump > Look)
    if shouldLook then
        lookAtGKTarget(predictedBallPos) -- Looks horizontally, turns AutoRotate OFF if needed

        if shouldDash then
            executeGKDash()
            -- Schedule control restoration after dash cooldown (or slightly before)
            task.delay(DASH_COOLDOWN_GK * 0.9, restoreGKControls)
        elseif shouldJump then
            executeGKJump()
            -- Schedule control restoration shortly after jump
            task.delay(0.5, restoreGKControls)
        -- else: If only looking, AutoRotate was turned off by lookAtGKTarget.
        -- It will be restored automatically when shouldLook becomes false or ball is invalid.
        end
    else
        -- If ball is valid but we shouldn't look/act (e.g., too far), restore controls
        restoreGKControls()
    end
end)

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
    end,
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