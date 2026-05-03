-- LocalScript: đặt trong StarterPlayerScripts
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CrystalDisplayUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(8, 12, 30)
overlay.BackgroundTransparency = 1
overlay.BorderSizePixel = 0
overlay.Parent = screenGui

local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = game:GetService("Lighting")

local panel = Instance.new("Frame")
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.Size = UDim2.new(0, 370, 0, 360)
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

-- Avatar to hơn: 130x130
local crystal = Instance.new("ImageLabel")
crystal.AnchorPoint = Vector2.new(0.5, 0.5)
crystal.Size = UDim2.new(0, 130, 0, 130)
crystal.Position = UDim2.new(0.5, 0, 0, 75)
crystal.BackgroundTransparency = 1
crystal.Image = "rbxassetid://83581831707784"
crystal.ScaleType = Enum.ScaleType.Fit
crystal.Parent = panel

local main = Instance.new("TextLabel")
main.Size = UDim2.new(1, -24, 0, 34)
main.Position = UDim2.new(0, 12, 0, 148)
main.BackgroundTransparency = 1
main.Text = "Vxeze Hub"
main.TextColor3 = Color3.fromRGB(80, 200, 255)
main.Font = Enum.Font.GothamBold
main.TextSize = 26
main.TextXAlignment = Enum.TextXAlignment.Center
main.Parent = panel

local loading = Instance.new("TextLabel")
loading.Size = UDim2.new(1, -24, 0, 22)
loading.Position = UDim2.new(0, 12, 0, 188)
loading.BackgroundTransparency = 1
loading.Text = "Loading..."
loading.TextColor3 = Color3.fromRGB(200, 220, 255)
loading.TextTransparency = 0.2
loading.Font = Enum.Font.Gotham
loading.TextSize = 14
loading.TextXAlignment = Enum.TextXAlignment.Center
loading.Parent = panel

local divider = Instance.new("Frame")
divider.Size = UDim2.new(0.85, 0, 0, 1)
divider.Position = UDim2.new(0.075, 0, 0, 222)
divider.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
divider.BackgroundTransparency = 0.7
divider.BorderSizePixel = 0
divider.Visible = false
divider.Parent = panel

local statsFrame = Instance.new("Frame")
statsFrame.Size = UDim2.new(1, -24, 0, 90)
statsFrame.Position = UDim2.new(0, 12, 0, 234)
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
    nameLabel.Size = UDim2.new(0.45, 0, 1, 0)
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
    valLabel.Size = UDim2.new(0.52, 0, 1, 0)
    valLabel.Position = UDim2.new(0.48, 0, 0, 0)
    valLabel.BackgroundTransparency = 1
    valLabel.Text = "..."
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

local function formatFull(n)
    local s = tostring(math.floor(n))
    local result = ""
    local count = 0
    for i = #s, 1, -1 do
        count = count + 1
        result = s:sub(i, i) .. result
        if count % 3 == 0 and i ~= 1 then
            result = "," .. result
        end
    end
    return result
end

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

local function updateStats(lv, fr, bl)
    if lv then levelVal.Text = tostring(math.floor(lv)) end
    if fr then fragVal.Text  = formatFull(fr) end
    if bl then beliVal.Text  = formatFull(bl) end
end

local tweenInfo = TweenInfo.new(1.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
TweenService:Create(overlay, tweenInfo, {BackgroundTransparency = 0.15}):Play()
TweenService:Create(blur,    tweenInfo, {Size = 14}):Play()
panel.Size = UDim2.new(0, 310, 0, 300)
TweenService:Create(panel, tweenInfo, {
    BackgroundTransparency = 0.25,
    Size = UDim2.new(0, 370, 0, 360)
}):Play()

local function floatLoop()
    local up = TweenService:Create(crystal,
        TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
        {Position = UDim2.new(0.5, 0, 0, 65)})
    local down = TweenService:Create(crystal,
        TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
        {Position = UDim2.new(0.5, 0, 0, 83)})
    up:Play()
    up.Completed:Connect(function()
        down:Play()
        down.Completed:Connect(floatLoop)
    end)
end
floatLoop()

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

    TweenService:Create(loading, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    task.wait(0.4)
    loading.Visible = false
    divider.Visible = true
    statsFrame.Visible = true
    TweenService:Create(statsFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {GroupTransparency = 0}):Play()

    updateStats(lv, fr, bl)
    loadingDone = true
end)

task.spawn(function()
    while not loadingDone do task.wait(0.1) end
    while true do
        task.wait(0.5)
        local lv, fr, bl = scanStats()
        updateStats(lv, fr, bl)
    end
end)
