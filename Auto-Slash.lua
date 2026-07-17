--Script By HKTD, TikTok: https://www.tiktok.com/@hktd_roblox

-- // SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- // SETTINGS
local killerName = { "c00lkidd", "JohnDoe", "1x1x1x1", "Noli", "Slasher", "Azure", "Guest666", "Nosferatu" }
local defaultRange = 10
local cooldownValueName = "QCooldown"
local checkInterval = 0.1
local cameraSmoothness = 0.15
local zoomInFOV = 60
local zoomOutFOV = 70

-- // STATE
local autoSwingEnabled = false
local swingRange = defaultRange
local killer = nil
local lastCheck = 0
local cameraLock = false

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoSwingUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local uiFrame = Instance.new("Frame")
uiFrame.Size = UDim2.new(0, 220, 0, 230)
uiFrame.Position = UDim2.new(0, 20, 1, -250)
uiFrame.BackgroundTransparency = 0.3
uiFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
uiFrame.Parent = screenGui
Instance.new("UICorner", uiFrame).CornerRadius = UDim.new(0, 12)

local borderGradient = Instance.new("UIGradient", uiFrame)
borderGradient.Color =
    ColorSequence.new {
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 150)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 255))
}
borderGradient.Rotation = 270
borderGradient.Transparency =
    NumberSequence.new {
    NumberSequenceKeypoint.new(0, 0.2),
    NumberSequenceKeypoint.new(1, 0.2)
}

local padding = Instance.new("UIPadding", uiFrame)
padding.PaddingTop = UDim.new(0, 10)
padding.PaddingLeft = UDim.new(0, 10)
padding.PaddingRight = UDim.new(0, 10)
padding.PaddingBottom = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 20)
title.BackgroundTransparency = 1
title.Text = "Shedletsky Auto Swing"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(220, 220, 220)
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = uiFrame

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(1, 0, 0, 48)
toggleButton.Position = UDim2.new(0, 0, 0, 26)
toggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "Auto Swing: OFF"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 16
toggleButton.AutoButtonColor = false
toggleButton.Parent = uiFrame
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 8)

local funnyImage = Instance.new("ImageLabel")
funnyImage.Size = UDim2.new(1, 0, 1, 0)
funnyImage.BackgroundTransparency = 1
funnyImage.Image = "rbxassetid://1778926605"
funnyImage.ImageTransparency = 0.4
funnyImage.ScaleType = Enum.ScaleType.Crop
funnyImage.Parent = toggleButton

local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://12221976"
clickSound.Volume = 1
clickSound.Parent = toggleButton

local hoverSound = Instance.new("Sound")
hoverSound.SoundId = "rbxassetid://92876108656319"
hoverSound.Volume = 1
hoverSound.Parent = toggleButton

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Position = UDim2.new(0, 0, 0, 78)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 14
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Text = "Status: Idle"
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = uiFrame

local rangeLabel = Instance.new("TextLabel")
rangeLabel.Size = UDim2.new(1, 0, 0, 18)
rangeLabel.Position = UDim2.new(0, 0, 0, 110)
rangeLabel.BackgroundTransparency = 1
rangeLabel.Font = Enum.Font.Gotham
rangeLabel.TextSize = 12
rangeLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
rangeLabel.Text = "Swing range (studs):"
rangeLabel.TextXAlignment = Enum.TextXAlignment.Left
rangeLabel.Parent = uiFrame

local rangeBox = Instance.new("TextBox")
rangeBox.Size = UDim2.new(1, 0, 0, 36)
rangeBox.Position = UDim2.new(0, 0, 0, 130)
rangeBox.PlaceholderText = tostring(defaultRange)
rangeBox.Text = ""
rangeBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
rangeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
rangeBox.Font = Enum.Font.Gotham
rangeBox.TextSize = 14
rangeBox.ClearTextOnFocus = false
rangeBox.Parent = uiFrame
Instance.new("UICorner", rangeBox).CornerRadius = UDim.new(0, 6)

local DiscordButton = Instance.new("TextButton")
DiscordButton.Size = UDim2.new(1, 0, 0, 36)
DiscordButton.Position = UDim2.new(0, 0, 0, 180)
DiscordButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
DiscordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordButton.Text = "🌐 My Discord"
DiscordButton.Font = Enum.Font.GothamBold
DiscordButton.TextSize = 14
DiscordButton.AutoButtonColor = false
DiscordButton.Parent = uiFrame
Instance.new("UICorner", DiscordButton).CornerRadius = UDim.new(0, 6)

local function makeDraggable(frame)
    local dragging, dragInput, mousePos, framePos
    frame.InputBegan:Connect(
        function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                mousePos = input.Position
                framePos = frame.Position
                input.Changed:Connect(
                    function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragging = false
                        end
                    end
                )
            end
        end
    )
    frame.InputChanged:Connect(
        function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end
    )
    UserInputService.InputChanged:Connect(
        function(input)
            if input == dragInput and dragging then
                local delta = input.Position - mousePos
                frame.Position =
                    UDim2.new(
                    framePos.X.Scale,
                    framePos.X.Offset + delta.X,
                    framePos.Y.Scale,
                    framePos.Y.Offset + delta.Y
                )
            end
        end
    )
end
makeDraggable(uiFrame)

toggleButton.MouseEnter:Connect(
    function()
        hoverSound:Play()
        TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 50, 50)}):Play()
    end
)
toggleButton.MouseLeave:Connect(
    function()
        local targetColor = autoSwingEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
    end
)

DiscordButton.MouseButton1Click:Connect(
    function()
        DiscordButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        task.wait(0.15)
        DiscordButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        setclipboard("")
        game:GetService("StarterGui"):SetCore(
            "SendNotification",
            {
                Title = "Discord Link Copied!",
                Text = "Join my Discord!",
                Duration = 3
            }
        )
    end
)

local function findKiller()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == name and obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") then
            return obj
        end
    end
    return nil
end

workspace.DescendantAdded:Connect(
    function(obj)
        if obj:IsA("Model") and table.find(killerNames, obj.Name) then
            killer = obj
        end
    end
)

local function pressQ()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
    task.wait(0.05)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
end

local function isAbilityReady()
    local char = LocalPlayer.Character
    if char then
        local cdValue = char:FindFirstChild(cooldownValueName, true)
        if cdValue then
            if cdValue:IsA("NumberValue") then
                return cdValue.Value <= 0
            elseif cdValue:IsA("BoolValue") then
                return cdValue.Value == true
            end
        end
    end
    return true
end

local function killerIsFacingYou()
    if
        not (killer and killer:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and
            LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))
     then
        return false
    end
    local kHRP = killer.HumanoidRootPart
    local cHRP = LocalPlayer.Character.HumanoidRootPart
    local facingDirection = kHRP.CFrame.LookVector
    local toPlayer = (cHRP.Position - kHRP.Position).Unit
    return facingDirection:Dot(toPlayer) > 0.7
end

local function lookAtSmooth(targetPos)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local desired = CFrame.new(hrp.Position, Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z))
        hrp.CFrame = hrp.CFrame:Lerp(desired, 0.25)
    end
end

RunService:BindToRenderStep(
    "CameraLock",
    Enum.RenderPriority.Camera.Value - 1,
    function()
        if cameraLock and killer and killer:FindFirstChild("HumanoidRootPart") then
            local camPos = Camera.CFrame.Position
            local targetPos = killer.HumanoidRootPart.Position
            local targetCF = CFrame.new(camPos, targetPos)
            Camera.CFrame = Camera.CFrame:Lerp(targetCF, cameraSmoothness)
        end
    end
)

local function zoomCamera(fov)
    TweenService:Create(
        Camera,
        TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
        {FieldOfView = fov}
    ):Play()
end

toggleButton.MouseButton1Click:Connect(
    function()
        clickSound:Play()
        autoSwingEnabled = not autoSwingEnabled
        if autoSwingEnabled then
            toggleButton.Text = "Auto Swing: ON"
            TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 200, 0)}):Play()
            killer = findKiller()
        else
            toggleButton.Text = "Auto Swing: OFF"
            TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 0, 0)}):Play()
            statusLabel.Text = "Status: Idle"
            cameraLock = false
            zoomCamera(zoomOutFOV)
        end
    end
)

rangeBox.FocusLost:Connect(
    function()
        local newVal = tonumber(rangeBox.Text)
        if newVal and newVal > 0 then
            swingRange = newVal
        end
    end
)

local function setStatus(text, color)
    statusLabel.Text = text
    if color then
        statusLabel.TextColor3 = color
    end
end

RunService.Heartbeat:Connect(
    function()
        if not autoSwingEnabled then
            return
        end
        if tick() - lastCheck < checkInterval then
            return
        end
        lastCheck = tick()

        if not killer then
            killer = findKiller()
            if not killer then
                setStatus("Status: Killer not found", Color3.fromRGB(255, 100, 100))
                cameraLock = false
                zoomCamera(zoomOutFOV)
                return
            end
        end

        local char = LocalPlayer.Character
        if not (char and char:FindFirstChild("HumanoidRootPart")) then
            setStatus("Status: Waiting for character...", Color3.fromRGB(200, 200, 200))
            return
        end

        local kHRP = killer:FindFirstChild("HumanoidRootPart")
        local cHRP = char:FindFirstChild("HumanoidRootPart")
        if not (kHRP and cHRP) then
            setStatus("Status: Target invalid", Color3.fromRGB(255, 120, 120))
            cameraLock = false
            zoomCamera(zoomOutFOV)
            return
        end

        local dist = (cHRP.Position - kHRP.Position).Magnitude
        if dist <= swingRange and killerIsFacingYou() then
            if not cameraLock then
                cameraLock = true
                zoomCamera(zoomInFOV)
            end

            if isAbilityReady() then
                lookAtSmooth(kHRP.Position)
                setStatus("Status: Pressing Q", Color3.fromRGB(100, 255, 100))
                pressQ()
            else
                setStatus("Status: On cooldown", Color3.fromRGB(255, 215, 0))
            end
        else
            if cameraLock then
                cameraLock = false
                zoomCamera(zoomOutFOV)
            end
            setStatus("Status: Out of range / Not facing", Color3.fromRGB(255, 150, 150))
        end
    end)
