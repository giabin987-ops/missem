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
panel.Size = UDim2.new(0, 370, 0, 330)
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

-- Crystal / Avatar image (ID của bạn)
local crystal = Instance.new("ImageLabel")
crystal.AnchorPoint = Vector2.new(0.5, 0.5)
crystal.Size = UDim2.new(0, 100, 0, 100)
crystal.Position = UDim2.new(0.5, 0, 0, 62)
crystal.BackgroundTransparency = 1
crystal.Image = "rbxassetid://83581831707784"
crystal.ScaleType = Enum.ScaleType.Fit
crystal.Parent = panel

-- Vxeze Hub
local main = Instance.new("TextLabel")
main.Size = UDim2.new(1, -24, 0, 34)
main.Position = UDim2.new(0, 12, 0, 128)
main.BackgroundTransparency = 1
main.Text = "Vxeze Hub"
main.TextColor3 = Color3.fromRGB(80, 200, 255)
main.Font = Enum.Font.GothamBold
main.TextSize = 26
main.TextXAlignment = Enum.TextXAlignment.Center
main.Parent = panel

-- Loading label
local loading = Instance.new("TextLabel")
loading.Size = UDim2.new(1, -24, 0, 22)
loading.Position = UDim2.new(0, 12, 0, 166)
loading.BackgroundTransparency = 1
loading.Text = "Loading..."
loading.TextColor3 = Color3.fromRGB(200, 220, 255)
loading.TextTransparency = 0.2
loading.Font = Enum.Font.Gotham
loading.TextSize = 14
loading.TextXAlignment = Enum.TextXAlignment.Center
loading.Parent = panel

-- Divider
local divider = Instance.new("Frame")
divider.Size = UDim2.new(0.85, 0, 0, 1)
divider.Position = UDim2.new(0.075, 0, 0, 200)
divider.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
divider.BackgroundTransparency = 0.7
divider.BorderSizePixel = 0
divider.Visible = false
divider.Parent = panel

-- Stats frame
local statsFrame = Instance.new("Frame")
statsFrame.Size = UDim2.new(1, -24, 0, 90)
statsFrame.Position = UDim2.new(0, 12, 0, 212)
statsFrame.BackgroundTransparency = 1
statsFrame.Visible = false
statsFrame.Parent = panel

local layout = Instance.new("UIListLayout", statsFrame)
layout.FillDirection = Enum.FillDirection.Vertical
layout.Padding = UDim.new(0, 8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function makeStat(icon, label, color)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 22)
    row.BackgroundTransparency = 1
    row.Parent = statsFrame

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 22, 1, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextColor3 = color
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = 13
    iconLabel.TextXAlignment = Enum.TextXAlignment.Center
    iconLabel.Parent = row

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0.5, 0, 1, 0)
    nameLabel.Position = UDim2.new(0, 24, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = label
    nameLabel.TextColor3 = Color3.fromRGB(180, 210, 255)
    nameLabel.TextTransparency = 0.15
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.TextSize = 13
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = row

    local valLabel = Instance.new("TextLabel")
    valLabel.Size = UDim2.new(0.4, 0, 1, 0)
    valLabel.Position = UDim2.new(0.6, 0, 0, 0)
    valLabel.BackgroundTransparency = 1
    valLabel.Text = "0"
    valLabel.TextColor3 = color
    valLabel.Font = Enum.Font.GothamBold
    valLabel.TextSize = 13
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.Parent = row

    return valLabel
end

local levelVal = makeStat("⚔", "Level",     Color3.fromRGB(255, 220, 80))
local fragVal  = makeStat("💎", "Fragments", Color3.fromRGB(100, 210, 255))
local beliVal  = makeStat("💰", "Beli",      Color3.fromRGB(100, 255, 160))

-- Format số
local function formatNum(n)
    if n >= 1e9 then return string.format("%.1fB", n/1e9)
    elseif n >= 1e6 then return string.format("%.1fM", n/1e6)
    elseif n >= 1e3 then return string.format("%.1fK", n/1e3)
    else return tostring(math.floor(n)) end
end

-- CountUp animation
local function countUp(label, fromVal, toVal, duration, isLevel)
    task.spawn(function()
        local steps = 40
        local interval = duration / steps
        local diff = toVal - fromVal
        for i = 1, steps do
            local current = math.floor(fromVal + (diff * (i / steps)))
            label.Text = isLevel and tostring(current) or formatNum(current)
            task.wait(interval)
        end
        label.Text = isLevel and tostring(math.floor(toVal)) or formatNum(toVal)
    end)
end

-- Quét stats
local function scanStats()
    local level, fragments, beli = nil, nil, nil
    local leaderstats = player:FindFirstChild("leaderstats")
    local data = player:FindFirstChild("Data")
             or player:FindFirstChild("PlayerData")
             or player:FindFirstChild("stats")

    if leaderstats then
        local lv = leaderstats:FindFirstChild("Level") or leaderstats:FindFirstChild("level") or leaderstats:FindFirstChild("Lvl")
        if lv then level = lv.Value end
        local fr = leaderstats:FindFirstChild("Fragments") or leaderstats:FindFirstChild("Fragment") or leaderstats:FindFirstChild("F")
        if fr then fragments = fr.Value end
        local bl = leaderstats:FindFirstChild("Beli") or leaderstats:FindFirstChild("Berries") or leaderstats:FindFirstChild("Money")
        if bl then beli = bl.Value end
    end

    if data then
        if not level then
            local lv = data:FindFirstChild("Level") or data:FindFirstChild("level")
            if lv then level = lv.Value end
        end
        if not fragments then
            local fr = data:FindFirstChild("Fragments") or data:FindFirstChild("Fragment")
            if fr then fragments = fr.Value end
        end
        if not beli then
            local bl = data:FindFirstChild("Beli") or data:FindFirstChild("Berries") or data:FindFirstChild("Money")
            if bl then beli = bl.Value end
        end
    end

    if not level or not fragments or not beli then
        for _, child in ipairs(player:GetChildren()) do
            for _, val in ipairs(child:GetChildren()) do
                local n = val.Name:lower()
                if not level and (n=="level" or n=="lvl") and (val:IsA("IntValue") or val:IsA("NumberValue")) then level = val.Value end
                if not fragments and (n=="fragments" or n=="fragment" or n=="f") and (val:IsA("IntValue") or val:IsA("NumberValue")) then fragments = val.Value end
                if not beli and (n=="beli" or n=="berries" or n=="money" or n=="cash") and (val:IsA("IntValue") or val:IsA("NumberValue")) then beli = val.Value end
            end
        end
    end

    return level, fragments, beli
end

local currentLevel, currentFrag, currentBeli = 0, 0, 0

-- === ANIMATIONS ===
local tweenInfo = TweenInfo.new(1.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
TweenService:Create(overlay, tweenInfo, {BackgroundTransparency = 0.15}):Play()
TweenService:Create(blur,    tweenInfo, {Size = 14}):Play()
panel.Size = UDim2.new(0, 310, 0, 280)
TweenService:Create(panel, tweenInfo, {
    BackgroundTransparency = 0.25,
    Size = UDim2.new(0, 370, 0, 330)
}):Play()

-- Float crystal
local function floatLoop()
    local up = TweenService:Create(crystal,
        TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
        {Position = UDim2.new(0.5, 0, 0, 54)})
    local down = TweenService:Create(crystal,
        TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
        {Position = UDim2.new(0.5, 0, 0, 70)})
    up:Play()
    up.Completed:Connect(function()
        down:Play()
        down.Completed:Connect(floatLoop)
    end)
end
floatLoop()

-- Loading + scan
local dots = {"Loading.", "Loading..", "Loading..."}
local idx = 1
local loadingDone = false

task.spawn(function()
    local timer = 0
    while timer < 2 do
        loading.Text = dots[idx]
        idx = (idx % #dots) + 1
        task.wait(0.5)
        timer = timer + 0.5
    end

    local lv, fr, bl = scanStats()
    lv = lv or 0
    fr = fr or 0
    bl = bl or 0

    TweenService:Create(loading, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    task.wait(0.4)
    loading.Visible = false
    divider.Visible = true
    statsFrame.Visible = true
    TweenService:Create(statsFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {GroupTransparency = 0}):Play()

    countUp(levelVal, 0, lv, 1.2, true)
    countUp(fragVal,  0, fr, 1.5, false)
    countUp(beliVal,  0, bl, 1.8, false)

    currentLevel = lv
    currentFrag  = fr
    currentBeli  = bl
    loadingDone  = true
end)

-- Quét liên tục
task.spawn(function()
    while not loadingDone do task.wait(0.1) end
    while true do
        task.wait(0.5)
        local lv, fr, bl = scanStats()
        lv = lv or currentLevel
        fr = fr or currentFrag
        bl = bl or currentBeli

        if lv ~= currentLevel then
            countUp(levelVal, currentLevel, lv, 0.6, true)
            currentLevel = lv
        end
        if fr ~= currentFrag then
            countUp(fragVal, currentFrag, fr, 0.6, false)
            currentFrag = fr
        end
        if bl ~= currentBeli then
            countUp(beliVal, currentBeli, bl, 0.6, false)
            currentBeli = bl
        end
    end
end)
