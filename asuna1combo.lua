local player = game:GetService("Players").LocalPlayer

local function onCharacterAdded(character)
    local root = character:WaitForChild("HumanoidRootPart")
    
    root.Touched:Connect(function(hit)
        local other = hit.Parent
        print("passed 0 ASUNA SCRIPT")
        
        if other and other ~= character and other:FindFirstChild("Humanoid") and character:FindFirstChild("Action") then
            print("passed 1 ASUNA SCRIPT")
            
            local animator = character.Humanoid:FindFirstChild("Animator")
            if animator then
                print("passed 2 ASUNA SCRIPT")
                
                for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                    if track.Animation.AnimationId == "rbxassetid://9097514873" then
                        print("passed 3 ASUNA SCRIPT")
                        
                        local velocity = root:FindFirstChild("BodyVelocity")
                        if velocity then
                            velocity:Destroy()
                        end
                        break
                    end
                end
            end
        
        end
    end)
end

if player.Character then
    onCharacterAdded(player.Character)
end

player.CharacterAdded:Connect(onCharacterAdded)
