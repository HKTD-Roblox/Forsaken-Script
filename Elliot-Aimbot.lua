--Script By HKTD, TikTok: https://www.tiktok.com/@hktd_roblox

local lp = game.Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local running = false
local savedPos
 
-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "PizzaAimbot"
 
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 160)
frame.Position = UDim2.new(0, 20, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
frame.BorderColor3 = Color3.fromRGB(255, 255, 0)
frame.BorderSizePixel = 3
frame.Active = true
frame.Draggable = true
frame.Name = "Pizza Aimbot"
 
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Pizza Aimbot"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255, 165, 0)
 
local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0.9, 0, 0, 40)
toggle.Position = UDim2.new(0.05, 0, 0.35, 0)
toggle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
toggle.TextColor3 = Color3.fromRGB(255, 165, 0)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 18
toggle.Text = "ON"
toggle.AutoButtonColor = false
toggle.BorderSizePixel = 0
toggle.BackgroundTransparency = 0.1
 
local destroyBtn = Instance.new("TextButton", frame)
destroyBtn.Size = UDim2.new(0.9, 0, 0, 30)
destroyBtn.Position = UDim2.new(0.05, 0, 0.75, 0)
destroyBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
destroyBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
destroyBtn.Font = Enum.Font.GothamBold
destroyBtn.TextSize = 16
destroyBtn.Text = "DESTROY"
destroyBtn.AutoButtonColor = false
destroyBtn.BorderSizePixel = 0
 
-- Key press function
local function pressQ()
local vim = game:GetService("VirtualInputManager")
vim:SendKeyEvent(true, "Q", false, game)
vim:SendKeyEvent(false, "Q", false, game)
end
 
-- Teleport function
local function searchAndTeleport()
while running and task.wait(1) do
if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then continue end
savedPos = lp.Character.HumanoidRootPart.CFrame
 
for _, plr in pairs(game.Players:GetPlayers()) do
if plr ~= lp and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") then
local hum = plr.Character.Humanoid
if hum.Health < 60 and (plr.Character.HumanoidRootPart.Position - hrp.Position).Magnitude < 1000 then
local targetHRP = plr.Character.HumanoidRootPart
local charHRP = lp.Character.HumanoidRootPart
 
charHRP.CFrame = CFrame.new(targetHRP.Position + Vector3.new(0, 2, 0), targetHRP.Position)
 
local glow = Instance.new("SelectionBox", charHRP)
glow.Adornee = charHRP
glow.LineThickness = 0.05
glow.Color3 = Color3.fromRGB(255, 255, 0)
glow.SurfaceTransparency = 0.5
 
task.wait(0.3)
pressQ()
 
for _ = 1, 30 do
if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then break end
charHRP.CFrame = CFrame.new(charHRP.Position, targetHRP.Position)
task.wait(0.1)
end
 
glow:Destroy()
 
if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
lp.Character.HumanoidRootPart.CFrame = savedPos
end
end
end
end
end
end
 
-- Toggle logic
toggle.MouseButton1Click:Connect(function()
running = not running
toggle.Text = running and "OFF" or "ON"
toggle.TextColor3 = running and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(255, 165, 0)
if running then
coroutine.wrap(searchAndTeleport)()
end
end)
 
-- Destroy logic
destroyBtn.MouseButton1Click:Connect(function()
running = false
gui:Destroy()
end)
 
-- Notification + Sound
pcall(function()
local sound = Instance.new("Sound", workspace)
sound.SoundId = "rbxassetid://9118823106"
sound.Volume = 1
sound:Play()
game:GetService("StarterGui"):SetCore("SendNotification", {
Title = "Pizza Aimbot",
Text = "Made By HKTD",
Duration = 5
})
game:GetService("TweenService"):Create(sound, TweenInfo.new(5), {Volume = 0}):Play()
game.Debris:AddItem(sound, 6)
end)
