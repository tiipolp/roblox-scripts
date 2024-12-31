local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local shotMeter
local logs = {}
local releaseAdjustment = 0 -- Adjustment factor for fine-tuning

-- Function to create the adjustment UI
local function createAdjustmentUI()
    local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    screenGui.Name = "ReleaseAdjustmentUI"

    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 150, 0, 50)
    frame.Position = UDim2.new(0.5, -75, 0.9, 0)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.Active = true -- Make draggable
    frame.Draggable = true

    local upButton = Instance.new("TextButton", frame)
    upButton.Size = UDim2.new(0.5, -5, 1, 0)
    upButton.Position = UDim2.new(0, 0, 0, 0)
    upButton.Text = "▲"
    upButton.TextScaled = true
    upButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    upButton.BorderSizePixel = 0
    upButton.MouseButton1Click:Connect(function()
        releaseAdjustment = releaseAdjustment + 0.01
        warn("Release adjusted later by 0.01. Current Adjustment: " .. releaseAdjustment)
    end)

    local downButton = Instance.new("TextButton", frame)
    downButton.Size = UDim2.new(0.5, -5, 1, 0)
    downButton.Position = UDim2.new(0.5, 5, 0, 0)
    downButton.Text = "▼"
    downButton.TextScaled = true
    downButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    downButton.BorderSizePixel = 0
    downButton.MouseButton1Click:Connect(function()
        releaseAdjustment = releaseAdjustment - 0.01
        warn("Release adjusted earlier by 0.01. Current Adjustment: " .. releaseAdjustment)
    end)
end

-- Function to get ping in milliseconds
local function getPing()
    return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
end

-- Function to predict the future value of the shot meter
local function predictFutureValue(currentValue, speed, ping)
    local pingSeconds = ping / 1000 -- Convert ping to seconds
    local predictedValue = currentValue + (speed * pingSeconds)
    return predictedValue
end

-- Function to calculate release point based on timing, speed, and adjustments
local function calculateReleasePoint(currentValue, speed, ping)
    local pingSeconds = ping / 1000 -- Convert ping to seconds

    -- Predict where the shot meter will be after accounting for ping
    local predictedValue = predictFutureValue(currentValue, speed, ping)

    -- Adjust release point dynamically for high speeds
    local releasePoint = 1 - (pingSeconds * speed) + releaseAdjustment
    if speed > 3 then
        releasePoint = math.min(releasePoint, predictedValue - 0.01) -- Avoid overshooting
    end

    return math.max(0, releasePoint) -- Clamp to avoid negatives
end

-- Function to monitor the shot meter and release the ball
local function monitorAndRelease()
    local previousValue = shotMeter.Value
    local shotMeterSpeed = 0
    local ping = getPing()

    while shotMeter do
        task.wait(0.03) -- Check more frequently for high speeds
        local currentValue = shotMeter.Value
        shotMeterSpeed = (currentValue - previousValue) / 0.03 -- Calculate speed
        previousValue = currentValue

        -- Predict the ideal release point
        local releasePoint = calculateReleasePoint(currentValue, shotMeterSpeed, ping)

        -- Log data for debugging
        local logEntry = string.format(
            "Ping: %dms, Speed: %.4f, ReleasePoint: %.4f, CurrentValue: %.4f, Adjustment: %.4f",
            ping, shotMeterSpeed, releasePoint, currentValue, releaseAdjustment
        )
        table.insert(logs, logEntry)
        warn(logEntry)

        -- Release the ball if the predicted value aligns with the perfect release
        if currentValue >= releasePoint then
            game:GetService("ReplicatedStorage").GameEvents.ClientAction:FireServer("Shoot", false)
            break
        end
    end

    -- Export logs when monitoring ends
    setclipboard(table.concat(logs, "\n"))
end

-- Monitor when ShotMeterTiming appears and begin monitoring
character.ChildAdded:Connect(function(child)
    if child.Name == "ShotMeterTiming" then
        shotMeter = child
        logs = {} -- Reset logs for new shot meter
        monitorAndRelease()
    end
end)

-- Cleanup logs if shot meter is destroyed
character.ChildRemoved:Connect(function(child)
    if child == shotMeter then
        setclipboard(table.concat(logs, "\n"))
        shotMeter = nil
    end
end)

-- Create the adjustment UI on script load
createAdjustmentUI()
