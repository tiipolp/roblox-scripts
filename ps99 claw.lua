if not game:IsLoaded() then
	game.Loaded:Wait()
end

repeat wait() until game.Players.LocalPlayer.Character

_G.onlypink = true
_G.onlyblue = false
_G.maxAttempts = 3
_G.autoexec = false

local blue = "rbxassetid://13987312142"
local pink = "rbxassetid://13987314678"

local valids = {}
local boundingBoxes = {
    {
        minX = 168,
        maxX = 214,
        minZ = -1947,
        maxZ = -1919
    },
    {
        minX = 185,
        maxX = 214,
        minZ = -1962,
        maxZ = -1916
    }
}

if isfolder("PS99Claw") then
    writefile("PS99Claw/onlypink.txt", tostring( _G.onlypink))
    writefile("PS99Claw/onlyblue.txt", tostring( _G.onlyblue))
    writefile("PS99Claw/maxattempts.txt", tostring( _G.maxAttempts))
    writefile("PS99Claw/autoexec.txt", tostring( _G.autoexec))
else
    makefolder("PS99Claw")
    writefile("PS99Claw/onlypink.txt", tostring( _G.onlypink))
    writefile("PS99Claw/onlyblue.txt", tostring( _G.onlyblue))
    writefile("PS99Claw/maxattempts.txt", tostring( _G.maxAttempts))
    writefile("PS99Claw/autoexec.txt", tostring( _G.autoexec))
end

local function hop()
    if _G.autoexec == false then
        queue_on_teleport([[
        _G.onlypink = readfile("PS99Claw/onlypink.txt") == "true"
        _G.onlyblue = readfile("PS99Claw/onlyblue.txt") == "true"
        _G.maxAttempts = tonumber(readfile("PS99Claw/maxattempts.txt"))
        _G.autoexec = readfile("PS99Claw/autoexec.txt") == "true"

        loadstring(game:HttpGet("https://text.is/BBL_DRIZZY/raw"))()
        ]])
    end

    repeat wait() until game:IsLoaded()
    wait(1)
    local PlaceID = game.PlaceId
    local AllIDs = {}
    local foundAnything = ""
    local actualHour = os.date("!*t").hour
    local Deleted = false
    function TPReturner()
    local Site;
    if foundAnything == "" then
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
    else
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
    end
    local ID = ""
    if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
        foundAnything = Site.nextPageCursor
    end
    local num = 0;
    for i,v in pairs(Site.data) do
        local Possible = true
        ID = tostring(v.id)
        if tonumber(v.maxPlayers) > tonumber(v.playing) then
            for _,Existing in pairs(AllIDs) do
                if num ~= 0 then
                    if ID == tostring(Existing) then
                        Possible = false
                    end
                else
                    if tonumber(actualHour) ~= tonumber(Existing) then
                        local delFile = pcall(function()
                            delfile("NotSameServers.json")
                            AllIDs = {}
                            table.insert(AllIDs, actualHour)
                        end)
                    end
                end
                num = num + 1
            end
            if Possible == true then
                table.insert(AllIDs, ID)
                wait()
                pcall(function()
                    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                    wait()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                end)
                wait(4)
            end
        end
    end
    end

    function Teleport()
    while wait() do
        pcall(function()
            TPReturner()
            if foundAnything ~= "" then
                TPReturner()
            end
        end)
    end
    end
    
    Teleport()
end

local function captureEgg(egg)
    local function moveClaw(direction)
        if direction == "Forward" then
            local args = {
                [1] = "ClawMachine",
                [2] = "Claw: Direction",
                [3] = "Forward"
            }

            game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Instancing_FireCustomFromClient"):FireServer(unpack(args))
        elseif direction == "Right" then
            local args = {
                [1] = "ClawMachine",
                [2] = "Claw: Direction",
                [3] = "Right"
            }

            game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Instancing_FireCustomFromClient"):FireServer(unpack(args))
        elseif direction == "Left" then
            local args = {
                [1] = "ClawMachine",
                [2] = "Claw: Direction",
                [3] = "Left"
            }

            game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Instancing_FireCustomFromClient"):FireServer(unpack(args))
        elseif direction == "Backward" then
            local args = {
                [1] = "ClawMachine",
                [2] = "Claw: Direction",
                [3] = "Backward"
            }

            game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Instancing_FireCustomFromClient"):FireServer(unpack(args))
        elseif direction == "Go" then
            local args = {
                [1] = "ClawMachine",
                [2] = "Claw: Go"
            }

            game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Instancing_FireCustomFromClient"):FireServer(unpack(args))
        end
    end

    local function stopClaw()
        local args = {
                [1] = "ClawMachine",
                [2] = "Claw: Direction"
            }

            game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Instancing_FireCustomFromClient"):FireServer(unpack(args))
    end

    local claw = workspace.__THINGS.__INSTANCE_CONTAINER.Active.ClawMachine.Claws.Claw.Holder
    local eggPosition = egg.Position
    local forgivenessRange = 0.1

    local function correctClawX()
        local moved = false  -- Variable to track if the claw has been moved

        if math.floor(claw.Position.X) == 212 or math.floor(claw.Position.X) == 213 then
            return "Stuck"
        end

        if claw.Position.X < eggPosition.X - forgivenessRange then
            moveClaw("Forward")
            print("Moving Forward...")
            moved = true  -- Set moved to true to indicate that the claw has been moved
        elseif claw.Position.X > eggPosition.X + forgivenessRange then
            moveClaw("Backward")
            print("Moving Backward...")
            moved = true  -- Set moved to true to indicate that the claw has been moved
        else
            stopClaw()
            print("Claw X-axis Stopped...")
        end

        if not moved then
            if (claw.Position.X >= eggPosition.X - forgivenessRange * 1.3 and claw.Position.X <= eggPosition.X + forgivenessRange * 1.3) then
                stopClaw()
                return true
            end
        end
    end

    local function correctClawZ()
        local moved = false  -- Variable to track if the claw has been moved

        if math.floor(claw.Position.Z) == -1917 or math.floor(claw.Position.Z) == -1916 or math.floor(claw.Position.Z) == -1918 then
            return "Stuck"
        end

        if claw.Position.Z < eggPosition.Z - forgivenessRange then
            moveClaw("Right")
            print("Moving Right...")
            moved = true  -- Set moved to true to indicate that the claw has been moved
        elseif claw.Position.Z > eggPosition.Z + forgivenessRange then
            moveClaw("Left")
            print("Moving Left...")
            moved = true  -- Set moved to true to indicate that the claw has been moved
        else
            stopClaw()
            print("Claw Z-axis Stopped...")
        end
        
        if not moved then  -- If the claw hasn't been moved, only then check if it's within range
            if (claw.Position.Z >= eggPosition.Z - forgivenessRange * 1.3 and claw.Position.Z <= eggPosition.Z + forgivenessRange * 1.3) then
                stopClaw()
                return true
            end
        end
    end    

    while wait(0.1) do 
        if correctClawX() == true then
            if (claw.Position.X >= eggPosition.X - forgivenessRange and claw.Position.X <= eggPosition.X + forgivenessRange) then
                print("Claw Position Check 2 Valid")
                stopClaw()
                break
            else
                print("Claw Position Check 2 Invalid...")
                print("Restarting Claw Mover...")
                continue
            end
        elseif correctClawX() == "Stuck" then
            print("Claw Position Check 2 Valid")
            stopClaw()
            break
        end
    end

    while wait(0.1) do
          if correctClawZ() == true then
            if (claw.Position.Z >= eggPosition.Z - forgivenessRange and claw.Position.Z <= eggPosition.Z + forgivenessRange) then
                stopClaw()
                print("Claw Position Check 2 Valid")
                break
            else
                print("Claw Position Check 2 Invalid...")
                print("Restarting Claw Mover...")
                continue
            end
        elseif correctClawZ() == "Stuck" then
            print("Claw Position Check 2 Valid")
            stopClaw()
            break
        end
    end

    wait(2)

    moveClaw("Go")

    repeat wait (0.1) until claw.Position.X >= 160 and claw.Position.X <= 166 and claw.Position.Z >= -1968 and claw.Position.Z <= -1965
    
    egg.Parent.Name = egg.Parent.Name .. "_Special"
    local eggName = egg.Parent.Name

    wait(5)
    
    if workspace.__THINGS.__INSTANCE_CONTAINER.Active.ClawMachine.Items:FindFirstChild(eggName) then 
        egg.Parent.Name = string.gsub(egg.Parent.Name, "_Special", "")
        return false
    else 
        return true
    end
end

local function startClaw()
    local args = {
        [1] = "ClawMachine",
        [2] = "Claw: Request Play"
    }

    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Instancing_FireCustomFromClient"):FireServer(unpack(args))
end

local function isPositionWithinBoundingBox(position)
    for _, box in ipairs(boundingBoxes) do
        if position.X >= box.minX and position.X <= box.maxX and
           position.Z >= box.minZ and position.Z <= box.maxZ then
            return true
        end
    end
   
    return false
end

local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()

repeat 
    wait(1)
    firetouchinterest(char:FindFirstChild("HumanoidRootPart"), workspace.__THINGS.Instances.ClawMachine:WaitForChild('Teleports').Enter, 0)
    --firetouchtransmitter(workspace.__THINGS.Instances.ClawMachine:WaitForChild('Teleports').Enter, char:WaitForChild("HumanoidRootPart"), 1)
until workspace.__THINGS.__INSTANCE_CONTAINER.Active:FindFirstChild('ClawMachine')

for i,v in workspace.__THINGS.__INSTANCE_CONTAINER.Active.ClawMachine.Items:GetChildren() do
    for j,k in v:GetChildren() do
        if k:IsA("MeshPart") then
             if isPositionWithinBoundingBox(k.Position) == false then 
                k.Transparency = 0.1
            end

            if  _G.onlypink == false and  _G.onlyblue == false then
                if k.TextureID == blue then
                    if isPositionWithinBoundingBox(k.Position) == false then 
                        k.Transparency = 0.1
                        continue
                    end

                    valids[k] = "20"
                elseif k.TextureID == pink then
                    if isPositionWithinBoundingBox(k.Position) == false then 
                        k.Transparency = 0.1
                        continue
                    end
                    
                    valids[k] = "50"
                end
            elseif _G.onlypink == true and _G.onlyblue == false and k.TextureID == pink then
                if isPositionWithinBoundingBox(k.Position) == false then 
                    k.Transparency = 0.1
                    continue
                end
                
                valids[k] = "50"
            elseif _G.onlyblue == true and _G.onlypink == false and k.TextureID == blue then
                if isPositionWithinBoundingBox(k.Position) == false then 
                    k.Transparency = 0.1
                    continue
                end
                
                valids[k] = "20"
            end
        end
    end
end

local validEggs = {}

-- Initialize each egg with its attempt count
for egg, _ in pairs(valids) do
    validEggs[egg] = { attempts = 0 }
end

repeat
	wait()
    local foundEgg = false
    for egg, data in pairs(validEggs) do
        foundEgg = true
        print(egg)

        if workspace.__THINGS.__INSTANCE_CONTAINER.Active.ClawMachine.Controls:FindFirstChild("ControlsEnabled") then
            continue 
        end

        startClaw()

        wait(0.5)

        if workspace.__THINGS.__INSTANCE_CONTAINER.Active.ClawMachine.Controls:FindFirstChild("ControlsDisabled") or workspace.__THINGS.__INSTANCE_CONTAINER.Active.ClawMachine.Controls:FindFirstChild("ControlsDisabledAvailable") then
            continue
        end

        print("Starting claw...")
        local success = captureEgg(egg)
        print("Success: " .. tostring(success))
        if success then
            valids[egg] = nil
            print("egg set to nil")
            validEggs[egg] = nil -- Remove egg from consideration
        else
            data.attempts = data.attempts + 1
            print("Attempts: " .. data.attempts)
            if data.attempts >= _G.maxAttempts then
                validEggs[egg] = nil -- Ignore egg after max attempts
                print("Max attempts reached, ignoring egg")
            else
               for egg, eggData in pairs(validEggs) do
                   print(egg, eggData)
                    if isPositionWithinBoundingBox(egg.Position) == false then
                        egg.Transparency = 0.1
                        validEggs[egg] = nil -- Ignore egg on edge
                        print("Egg found on edge, ignoring egg with key:", key)
                    end
                end
                
                print("Restarting loop...")
            end
        end
    end
until not foundEgg or next(validEggs) == nil

hop()