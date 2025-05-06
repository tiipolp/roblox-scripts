local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local ownerPlot = nil

if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end

for i,v in pairs(workspace.Plots:GetChildren()) do
    if v:FindFirstChild("Owner") and tostring(v.Owner.Value) == game.Players.LocalPlayer.Name then
        ownerPlot = v
    end
end

local OreServiceRE = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("OreService"):WaitForChild("RE")
local PlotServiceRE = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PlotService"):WaitForChild("RE")
local RequestRandomOreEvent = OreServiceRE:WaitForChild("RequestRandomOre")
local CollectDrillEvent = PlotServiceRE:WaitForChild("CollectDrill")

local function collectOre()
    pcall(function()
        RequestRandomOreEvent:FireServer()
    end)
end

local function collectDrill(drillInstance)
    pcall(function()
        CollectDrillEvent:FireServer(drillInstance)
    end)
end

local function oreCollectionLoop()
    while true do
        collectOre()
        task.wait(0.1)
    end
end

local function drillCollectionLoop()
    local drillsFolder = ownerPlot:WaitForChild("Drills")

    while true do
        for _, drill in ipairs(drillsFolder:GetChildren()) do
            collectDrill(drill)
            task.wait(0.2)
        end
        task.wait(5)
    end
end

local oreCoroutine = coroutine.wrap(oreCollectionLoop)
local drillCoroutine = coroutine.wrap(drillCollectionLoop)

oreCoroutine()
drillCoroutine()