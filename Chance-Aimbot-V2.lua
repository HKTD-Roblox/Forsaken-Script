--Script By HKTD, TikTok: https://www.tiktok.com/@hktd_roblox

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local StarterGui = game:GetService("StarterGui")

-- You can trigger notifications later in your script:

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChanceAimbotUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Main draggable frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 180, 0, 110)
mainFrame.Position = UDim2.new(0, 20, 0, 100)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.Active = true
mainFrame.Parent = screenGui

-- Make mainFrame auto-resize
mainFrame.AutomaticSize = Enum.AutomaticSize.Y
mainFrame.Size = UDim2.new(0, 180, 0, 0) -- only width fixed, height auto

-- Add a layout to handle stacking
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = mainFrame

-- Dragging logic
local dragging, dragInput, dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)



-- Hide/Unhide Square Button
local hideButton = Instance.new("TextButton")
hideButton.Size = UDim2.new(0, 40, 0, 40) -- square shape
hideButton.Position = UDim2.new(0, 20, 0, 20) -- top-left corner (adjust if you want)
hideButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
hideButton.TextColor3 = Color3.new(1, 1, 1)
hideButton.TextScaled = true
hideButton.Text = "HIDE" -- simple menu icon
hideButton.Active = true
hideButton.Draggable = true -- makes it draggable
hideButton.Parent = screenGui

-- Track hidden state
local uiHidden = false

hideButton.MouseButton1Click:Connect(function()
    uiHidden = not uiHidden

    -- Loop through all children of screenGui except the hideButton itself
    for _, child in ipairs(screenGui:GetChildren()) do
        if child ~= hideButton then
            child.Visible = not uiHidden
        end
    end

    hideButton.Text = uiHidden and "UNHIDE" or "HIDE" -- indicator changes
end)

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 140, 0, 30)
toggleButton.LayoutOrder = 1
toggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Text = "Chance Aim: OFF"
toggleButton.Parent = mainFrame

-- Mode Button
local modeButton = Instance.new("TextButton")
modeButton.Size = UDim2.new(0, 140, 0, 30)
modeButton.LayoutOrder = 2
modeButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
modeButton.TextColor3 = Color3.new(1, 1, 1)
modeButton.Text = "Prediction Mode: Velocity"
modeButton.Parent = mainFrame

local shooting = false

-- Aim Mode Button
local aimModeButton = Instance.new("TextButton")
aimModeButton.Size = UDim2.new(0, 140, 0, 30)
aimModeButton.LayoutOrder = 4
aimModeButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
aimModeButton.TextColor3 = Color3.new(1, 1, 1)
aimModeButton.Text = "Aim Behavior Mode: Normal"
aimModeButton.Parent = mainFrame

-- Spin Speed Box (seconds per 360)
local spinSpeedBox = Instance.new("TextBox")
spinSpeedBox.Size = UDim2.new(0, 140, 0, 30)
spinSpeedBox.LayoutOrder = 5
spinSpeedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
spinSpeedBox.TextColor3 = Color3.new(1, 1, 1)
spinSpeedBox.Text = "0.5" -- default duration
spinSpeedBox.PlaceholderText = "Spin Duration/Speed (sec)"
spinSpeedBox.ClearTextOnFocus = false
spinSpeedBox.Visible = false
spinSpeedBox.Parent = mainFrame



-- Prediction Box (only for velocity mode)
local predictionBox = Instance.new("TextBox")
predictionBox.Size = UDim2.new(0, 140, 0, 30)
predictionBox.LayoutOrder = 3
predictionBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
predictionBox.TextColor3 = Color3.new(1, 1, 1)
predictionBox.Text = "4"
predictionBox.PlaceholderText = "Prediction (Velocity only)"
predictionBox.ClearTextOnFocus = false
predictionBox.Visible = true
predictionBox.Parent = mainFrame

-- Message When Aim UI
local messageToggleButton = Instance.new("TextButton")
messageToggleButton.Size = UDim2.new(0, 140, 0, 30)
messageToggleButton.LayoutOrder = 6
messageToggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
messageToggleButton.TextColor3 = Color3.new(1, 1, 1)
messageToggleButton.Text = "Message When Aim: OFF"
messageToggleButton.Parent = mainFrame

local messageBox = Instance.new("TextBox")
messageBox.Size = UDim2.new(0, 140, 0, 30)
messageBox.LayoutOrder = 7
messageBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
messageBox.TextColor3 = Color3.new(1, 1, 1)
messageBox.PlaceholderText = "Message to send when aiming"
messageBox.ClearTextOnFocus = false
messageBox.Text = "" -- default text, change if you want
messageBox.Visible = false
messageBox.Parent = mainFrame

-- Custom Shoot Anim Toggle
local customAnimToggle = Instance.new("TextButton")
customAnimToggle.Size = UDim2.new(0, 140, 0, 30)
customAnimToggle.LayoutOrder = 8
customAnimToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
customAnimToggle.TextColor3 = Color3.new(1, 1, 1)
customAnimToggle.Text = "Custom Shoot Anim: OFF"
customAnimToggle.Parent = mainFrame

local customAnimBox = Instance.new("TextBox")
customAnimBox.Size = UDim2.new(0, 140, 0, 30)
customAnimBox.LayoutOrder = 9
customAnimBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
customAnimBox.TextColor3 = Color3.new(1, 1, 1)
customAnimBox.PlaceholderText = "Enter Anim ID"
customAnimBox.Text = ""
customAnimBox.ClearTextOnFocus = false
customAnimBox.Visible = false
customAnimBox.Parent = mainFrame

-- AUTO COINFLIP UI -------------------------------------------------
local autoCoinflipToggle = Instance.new("TextButton")
autoCoinflipToggle.Size = UDim2.new(0, 140, 0, 30)
autoCoinflipToggle.LayoutOrder = 10
autoCoinflipToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
autoCoinflipToggle.TextColor3 = Color3.new(1, 1, 1)
autoCoinflipToggle.Text = "Auto Coinflip: OFF"
autoCoinflipToggle.Parent = mainFrame

local chargesModeButton = Instance.new("TextButton")
chargesModeButton.Size = UDim2.new(0, 140, 0, 30)
chargesModeButton.LayoutOrder = 11
chargesModeButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
chargesModeButton.TextColor3 = Color3.new(1, 1, 1)
chargesModeButton.Visible = false
chargesModeButton.Text = "Charges: 3" -- default
chargesModeButton.Parent = mainFrame

-- Auto-coinflip state
local autoCoinflip = false
local coinflipTargetCharge = "3" -- string "1","2","3"
local coinflipRoutine = nil

-- helper to read the charges text safely
local function readCoinflipChargesText()
    local ok, txt = pcall(function()
        local mainUI = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("MainUI")
        if not mainUI then return nil end
        local abil = mainUI:FindFirstChild("AbilityContainer")
        if not abil then return nil end
        local coin = abil:FindFirstChild("Reroll")
        if not coin then return nil end
        local chargesLabel = coin:FindFirstChild("Charges")
        if not chargesLabel then return nil end
        return tostring(chargesLabel.Text)
    end)
    if ok then return txt end
    return nil
end

-- cycle charges mode between "1", "2", "3"
chargesModeButton.MouseButton1Click:Connect(function()
    if coinflipTargetCharge == "1" then
        coinflipTargetCharge = "2"
    elseif coinflipTargetCharge == "2" then
        coinflipTargetCharge = "3"
    else
        coinflipTargetCharge = "1"
    end
    chargesModeButton.Text = "Charges: " .. coinflipTargetCharge
end)

-- remote ref (safe wait)
local RemoteEvent = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent")

-- toggling the auto coinflip
-- auto coinflip toggle
autoCoinflipToggle.MouseButton1Click:Connect(function()
    autoCoinflip = not autoCoinflip
    autoCoinflipToggle.Text = autoCoinflip and "Auto Coinflip: ON" or "Auto Coinflip: OFF"

    -- show/hide charges button
    chargesModeButton.Visible = autoCoinflip
end)

-- keep checking each frame
local lastCoinflipTime = 0
local coinflipCooldown = 0.15 -- seconds between coinflips (adjust as you like)

RunService.RenderStepped:Connect(function()
    if autoCoinflip then
        local charges = tonumber(readCoinflipChargesText())
        local target = tonumber(coinflipTargetCharge)

        if charges and target and charges < target then
            local now = tick()
            if now - lastCoinflipTime >= coinflipCooldown then
                lastCoinflipTime = now
                pcall(function()
                    RemoteEvent:FireServer(table.unpack({
                        [1] = "UseActorAbility",
                        [2] = "CoinFlip",
                    }))
                end)
            end
        end
    end
end)

-- State
local useCustomAnim = false
local loadedCustomAnimTrack = nil

customAnimToggle.MouseButton1Click:Connect(function()
    useCustomAnim = not useCustomAnim
    customAnimToggle.Text = useCustomAnim and "Custom Shoot Anim: ON" or "Custom Shoot Anim: OFF"
    customAnimBox.Visible = useCustomAnim
end)

-- Config
local active = false
local usePingMode = false
local aimDuration = 1.7
local aimTargets = {"Slasher", "c00lkidd", "JohnDoe", "1x1x1x1", "Noli"}
-- trackedAnimations not used anymore, kept harmlessly in case you want to revert
local trackedAnimations = {
    ["103601716322988"] = true,
    ["133491532453922"] = true,
    ["86371356500204"] = true,
    ["76649505662612"] = true,
    ["81698196845041"] = true
}

local spinDuration = tonumber(spinSpeedBox.Text) or 0.5

-- State
local messageWhenAim = false
local messageSentThisAim = false
local Humanoid, HRP = nil, nil
local lastTriggerTime = 0
local aiming = false
local originalWS, originalJP, originalAutoRotate = nil, nil, nil
local aimMode = "Normal" -- or "360"

messageToggleButton.MouseButton1Click:Connect(function()
    messageWhenAim = not messageWhenAim
    messageToggleButton.Text = messageWhenAim and "Message When Aim: ON" or "Message When Aim: OFF"
    messageBox.Visible = messageWhenAim
end)

-- NEW: track previous visibility so we only trigger on the rising edge
local prevFlintVisibleAim = false
local prevFlintVisibleShoot = false
-- use prevFlintVisibleAim in the aiming loop
-- use prevFlintVisibleShoot in the shooting loop
-- prediction only if target is moving faster than this (studs/sec)
local movementThreshold = 0.5
-- Message-when-aim state + chat helper

local ChatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
local SayMessageRequest = ChatEvents and ChatEvents:FindFirstChild("SayMessageRequest")

local function sendChatMessage(text)
    if not text or text:match("^%s*$") then return end
    local TextChatService = game:GetService("TextChatService")
    local channel = TextChatService.TextChannels.RBXGeneral

    channel:SendAsync(text)
end

local function playCustomShootAnim()
    if not useCustomAnim or not Humanoid then return end

    local animId = tonumber(customAnimBox.Text)
    if not animId then return end

    -- stop all current tracks
    for _, track in ipairs(Humanoid.Animator:GetPlayingAnimationTracks()) do
        track:Stop()
    end

    -- load and play
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://" .. animId
    local track = Humanoid:FindFirstChild("Animator"):LoadAnimation(anim)
    loadedCustomAnimTrack = track
    track:Play()

    -- if it's looped, stop it after 1.7s
    if track.Looped then
        delay(1.7, function()
            if track.IsPlaying then
                track:Stop()
            end
        end)
    end
end

-- UI Button Logic
toggleButton.MouseButton1Click:Connect(function()
    active = not active
    toggleButton.Text = active and "Chance Aim: ON" or "Chance Aim: OFF"
end)

local predictionMode = "Velocity" -- default

modeButton.MouseButton1Click:Connect(function()
    if predictionMode == "Velocity" then
        predictionMode = "Ping"
        modeButton.Text = "Prediction Mode: Velocity (Ping Adjust)"
        predictionBox.Visible = false
    elseif predictionMode == "Ping" then
        predictionMode = "Infront HRP"
        modeButton.Text = "Prediction Mode: Infront HRP"
        predictionBox.Visible = true
        predictionBox.PlaceholderText = "Studs Infront Killer HRP"
    elseif predictionMode == "Infront HRP" then
        predictionMode = "Infront HRP (Ping Adjust)"
        modeButton.Text = "Prediction Mode: Infront HRP (Ping Adjust)"
        predictionBox.Visible = false
    else
        predictionMode = "Velocity"
        modeButton.Text = "Prediction Mode: Velocity"
        predictionBox.Visible = true
        predictionBox.PlaceholderText = "Prediction (Velocity only)"
    end
end)

aimModeButton.MouseButton1Click:Connect(function()
    if aimMode == "Normal" then
        aimMode = "360"
        aimModeButton.Text = "Aim Behavior Mode: 360"
        spinSpeedBox.Visible = true -- show only in 360 mode
    else
        aimMode = "Normal"
        aimModeButton.Text = "Aim Behavior Mode: Normal"
        spinSpeedBox.Visible = false -- hide in normal mode
    end
end)

-- Helpers
local function getValidTarget()
    local killersFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
    if killersFolder then
        for _, name in ipairs(aimTargets) do
            local target = killersFolder:FindFirstChild(name)
            if target and target:FindFirstChild("HumanoidRootPart") then
                return target.HumanoidRootPart, target:FindFirstChild("Humanoid")
            end
        end
    end
    return nil, nil
end

local function setupCharacter(char)
    Humanoid = char:WaitForChild("Humanoid")
    HRP = char:WaitForChild("HumanoidRootPart")
end

if LocalPlayer.Character then
    setupCharacter(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(setupCharacter)

-- Ping mode function
local function getPingSeconds()
    local pingStat = Stats.Network.ServerStatsItem["Data Ping"]
    if pingStat then
        return pingStat:GetValue() / 1000
    end
    return 0.1
end

spinSpeedBox.FocusLost:Connect(function()
    spinDuration = tonumber(spinSpeedBox.Text) or 0.5
end)

local function getPredictedAimPosPing(targetHRP, killerHumanoid)
    local ping = getPingSeconds()
    local velocity = targetHRP.Velocity

    -- if target is basically standing still, don't predict — just aim at current position
    if velocity.Magnitude <= movementThreshold then
        return targetHRP.Position
    end

    -- otherwise predict using velocity * ping
    return targetHRP.Position + (velocity * ping)
end

-- Predict N studs in front of killer HRP using HRP.LookVector scaled by ping
local function getPredictedAimPosInfrontHRPPing(targetHRP)
    local ping = getPingSeconds()
    local studs = ping * 60 -- tweak multiplier until aim feels right

    -- if killer is standing still, just return HRP position
    if targetHRP.Velocity.Magnitude <= movementThreshold then
        return targetHRP.Position
    end

    return targetHRP.Position + (targetHRP.CFrame.LookVector * studs)
end

-- NEW: Flintlock visibility check
local function isFlintlockVisible()
    if not LocalPlayer.Character then return false end
    local flint = LocalPlayer.Character:FindFirstChild("Flintlock", true)
    if not flint then return false end

    if not (flint:IsA("BasePart") or flint:IsA("MeshPart") or flint:IsA("UnionOperation")) then
        flint = flint:FindFirstChildWhichIsA("BasePart", true)
        if not flint then return false end
    end

    if flint.Transparency >= 1 then
        return false
    end
    return true
end

-- Main loop
RunService.RenderStepped:Connect(function()
    if not active or not Humanoid or not HRP then return end

    -- EDGE DETECTION: only set the trigger when Flintlock becomes visible (false -> true)
    local isVisible = isFlintlockVisible()
    if isVisible and not prevFlintVisibleAim and not aiming then
        lastTriggerTime = tick()
        aiming = true
    end
    prevFlintVisibleAim = isVisible

    if aiming then
        local elapsed = tick() - lastTriggerTime

        if aimMode == "360" then
            -- Phase 1: spin for 1.2s
            if elapsed <= spinDuration then
                -- full 360 spin over the spindurstion
                local spinProgress = elapsed / spinDuration
                local spinAngle = math.rad(360 * spinProgress)
                HRP.CFrame = CFrame.new(HRP.Position) * CFrame.Angles(0, spinAngle, 0)

            -- Phase 2: short aim (0.7s)
            elseif elapsed <= spinDuration + 0.7 then
                -- same as your normal aiming logic, but time-limited
                if not originalWS then
                    originalWS = Humanoid.WalkSpeed
                    originalJP = Humanoid.JumpPower
                    originalAutoRotate = Humanoid.AutoRotate
                end

                Humanoid.AutoRotate = false
                HRP.AssemblyAngularVelocity = Vector3.zero

                local targetHRP, killerHumanoid = getValidTarget()
                if targetHRP then
                    local aimPos
                    if predictionMode == "Ping" then
                        aimPos = getPredictedAimPosPing(targetHRP, killerHumanoid)
                    elseif predictionMode == "Infront HRP" then
                        local studs = tonumber(predictionBox.Text) or 0
                        if targetHRP.Velocity.Magnitude > movementThreshold then
                            aimPos = targetHRP.Position + (targetHRP.CFrame.LookVector * studs)
                        else
                            aimPos = targetHRP.Position
                        end
                    elseif predictionMode == "Infront HRP (Ping Adjust)" then
                        aimPos = getPredictedAimPosInfrontHRPPing(targetHRP)
                    else
                        -- Velocity mode
                        local prediction = tonumber(predictionBox.Text) or 0
                        if targetHRP.Velocity.Magnitude <= movementThreshold then
                            aimPos = targetHRP.Position
                        else
                            aimPos = targetHRP.Position + (targetHRP.Velocity * (prediction / 60))
                        end
                    end

                    if aimPos then
                        local direction = (aimPos - HRP.Position).Unit
                        local yRot = math.atan2(-direction.X, -direction.Z)
                        HRP.CFrame = CFrame.new(HRP.Position) * CFrame.Angles(0, yRot, 0)
                    end
                end

            else
                -- Done with spin + aim
                aiming = false
                if originalWS and originalJP and originalAutoRotate ~= nil then
                    Humanoid.WalkSpeed = originalWS
                    Humanoid.JumpPower = originalJP
                    Humanoid.AutoRotate = originalAutoRotate
                    originalWS, originalJP, originalAutoRotate = nil, nil, nil
                end
            end

        else -- Normal mode (what you already had)
            if elapsed <= aimDuration then
                if not originalWS then
                    originalWS = Humanoid.WalkSpeed
                    originalJP = Humanoid.JumpPower
                    originalAutoRotate = Humanoid.AutoRotate
                end

                Humanoid.AutoRotate = false
                HRP.AssemblyAngularVelocity = Vector3.zero

                local targetHRP, killerHumanoid = getValidTarget()
                if targetHRP then
                    local aimPos
                    if predictionMode == "Ping" then
                        aimPos = getPredictedAimPosPing(targetHRP, killerHumanoid)
                    elseif predictionMode == "Infront HRP" then
                        local studs = tonumber(predictionBox.Text) or 0
                        if targetHRP.Velocity.Magnitude > movementThreshold then
                            aimPos = targetHRP.Position + (targetHRP.CFrame.LookVector * studs)
                        else
                            aimPos = targetHRP.Position
                        end
                    elseif predictionMode == "Infront HRP (Ping Adjust)" then
                        aimPos = getPredictedAimPosInfrontHRPPing(targetHRP)
                    else
                        -- Velocity mode
                        local prediction = tonumber(predictionBox.Text) or 0
                        if targetHRP.Velocity.Magnitude <= movementThreshold then
                            aimPos = targetHRP.Position
                        else
                            aimPos = targetHRP.Position + (targetHRP.Velocity * (prediction / 60))
                        end
                    end

                    if aimPos then
                        local direction = (aimPos - HRP.Position).Unit
                        local yRot = math.atan2(-direction.X, -direction.Z)
                        HRP.CFrame = CFrame.new(HRP.Position) * CFrame.Angles(0, yRot, 0)
                    end
                end
            else
                aiming = false
                if originalWS and originalJP and originalAutoRotate ~= nil then
                    Humanoid.WalkSpeed = originalWS
                    Humanoid.JumpPower = originalJP
                    Humanoid.AutoRotate = originalAutoRotate
                    originalWS, originalJP, originalAutoRotate = nil, nil, nil
                end
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    local isVisible = isFlintlockVisible()
    if isVisible and not prevFlintVisibleShoot and not shooting then
        lastTriggerTime = tick()
        shooting = true
        messageSentThisAim = false
        if messageWhenAim then
            -- send immediately when the aim starts (on
            sendChatMessage(messageBox.Text)
            messageSentThisAim = true
        end
    end
    prevFlintVisibleShoot = isVisible
    if shooting then
        if useCustomAnim then
            playCustomShootAnim()
        end
        messageSentThisAim = false
        shooting = false
    end
end)
