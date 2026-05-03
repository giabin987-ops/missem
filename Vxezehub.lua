-- LocalScript: đặt trong StarterPlayerScripts
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CrystalDisplayUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- Overlay
local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(8, 12, 30)
overlay.BackgroundTransparency = 1
overlay.BorderSizePixel = 0
overlay.Parent = screenGui

-- Blur
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = game:GetService("Lighting")

-- Panel
local panel = Instance.new("Frame")
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.Size = UDim2.new(0, 360, 0, 260)
panel.Position = UDim2.new(0.5, 0, 0.5, 0)
panel.BackgroundColor3 = Color3.fromRGB(10, 20, 52)
panel.BackgroundTransparency = 1
panel.BorderSizePixel = 0
panel.Parent = overlay

Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 20)

local stroke = Instance.new("UIStroke", panel)
stroke.Color = Color3.fromRGB(70, 140, 255)
stroke.Transparency = 0.7
stroke.Thickness = 1.2

-- Crystal ImageLabel (thay ID nếu có ảnh riêng)
local crystal = Instance.new("ImageLabel")
crystal.AnchorPoint = Vector2.new(0.5, 0.5)
crystal.Size = UDim2.new(0, 110, 0, 110)
crystal.Position = UDim2.new(0.5, 0, 0, 70)
crystal.BackgroundTransparency = 1
crystal.Image = "rbxassetid://18716558902" -- blue gem asset
crystal.ImageColor3 = Color3.fromRGB(120, 190, 255)
crystal.ScaleType = Enum.ScaleType.Fit
crystal.Parent = panel

-- Glow dưới crystal
local glow = Instance.new("ImageLabel")
glow.AnchorPoint = Vector2.new(0.5, 0.5)
glow.Size = UDim2.new(0, 160, 0, 80)
glow.Position = UDim2.new(0.5, 0, 0, 120)
glow.BackgroundTransparency = 1
glow.Image = "rbxasset://textures/ui/TopBar/chatOff.png"
glow.ImageColor3 = Color3.fromRGB(60, 130, 255)
glow.ImageTransparency = 0.6
glow.Parent = panel

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -24, 0, 20)
title.Position = UDim2.new(0, 12, 0, 145)
title.BackgroundTransparency = 1
title.Text = "DISPLAY ONLY — NO ACTION TAKEN"
title.TextColor3 = Color3.fromRGB(100, 165, 255)
title.TextTransparency = 0.3
title.Font = Enum.Font.GothamBold
title.TextSize = 10
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = panel

-- Main text
local main = Instance.new("TextLabel")
main.Size = UDim2.new(1, -24, 0, 30)
main.Position = UDim2.new(0, 12, 0, 170)
main.BackgroundTransparency = 1
main.Text = "Visual Presentation Mode"
main.TextColor3 = Color3.fromRGB(220, 238, 255)
main.Font = Enum.Font.GothamBold
main.TextSize = 20
main.TextXAlignment = Enum.TextXAlignment.Center
main.Parent = panel

-- Sub text
local sub = Instance.new("TextLabel")
sub.Size = UDim2.new(1, -32, 0, 36)
sub.Position = UDim2.new(0, 16, 0, 205)
sub.BackgroundTransparency = 1
sub.Text = "This screen is decorative and does not affect gameplay."
sub.TextColor3 = Color3.fromRGB(160, 200, 255)
sub.TextTransparency = 0.4
sub.Font = Enum.Font.Gotham
sub.TextSize = 12
sub.TextWrapped = true
sub.TextXAlignment = Enum.TextXAlignment.Center
sub.Parent = panel

-- === ANIMATIONS ===
local tweenInfo = TweenInfo.new(1.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

-- Fade in overlay
TweenService:Create(overlay, tweenInfo, {BackgroundTransparency = 0.15}):Play()

-- Blur tăng dần
TweenService:Create(blur, tweenInfo, {Size = 14}):Play()

-- Panel fade in
TweenService:Create(panel, tweenInfo, {BackgroundTransparency = 0.25}):Play()

-- Panel scale từ nhỏ ra (zoom-in)
panel.Size = UDim2.new(0, 300, 0, 220)
TweenService:Create(panel, tweenInfo, {Size = UDim2.new(0, 360, 0, 260)}):Play()

-- Float crystal lên xuống
local function floatLoop()
    local up = TweenService:Create(crystal,
        TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
        {Position = UDim2.new(0.5, 0, 0, 60)}
    )
    local down = TweenService:Create(crystal,
        TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
        {Position = UDim2.new(0.5, 0, 0, 78)}
    )
    up:Play()
    up.Completed:Connect(function()
        down:Play()
        down.Completed:Connect(floatLoop)
    end)
end

floatLoop()
