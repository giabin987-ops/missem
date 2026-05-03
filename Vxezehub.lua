-- LocalScript: đặt trong StarterPlayerScripts
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
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
overlay.BackgroundColor3 = Color3.fromRGB(6, 10, 25)
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
panel.BackgroundColor3 = Color3.fromRGB(12, 18, 40)
panel.BackgroundTransparency = 1
panel.BorderSizePixel = 0
panel.Parent = overlay

Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 20)

local stroke = Instance.new("UIStroke", panel)
stroke.Color = Color3.fromRGB(60, 100, 180)
stroke.Transparency = 0.7
stroke.Thickness = 1.2

-- Crystal
local crystal = Instance.new("ImageLabel")
crystal.AnchorPoint = Vector2.new(0.5, 0.5)
crystal.Size = UDim2.new(0, 165, 0, 165)
crystal.Position = UDim2.new(0.5, 0, 0, 62)
crystal.BackgroundTransparency = 1
crystal.Image = "rbxassetid://83581831707784"
crystal.ImageColor3 = Color3.fromRGB(255, 255, 255)
crystal.ScaleType = Enum.ScaleType.Fit
crystal.Parent = panel

-- Vxeze Hub
local titleHolder = Instance.new("Frame")
titleHolder.Size = UDim2.new(1, -24, 0, 34)
titleHolder.Position = UDim2.new(0, 12, 0, 128)
titleHolder.BackgroundTransparency = 1
titleHolder.Parent = panel

-- Chữ chính
local main = Instance.new("TextLabel")
main.Size = UDim2.new(1, 0, 1, 0)
main.BackgroundTransparency = 1
main.Text = "Vxeze Hub"
main.TextColor3 = Color3.fromRGB(230, 235, 240)
main.Font = Enum.Font.GothamBlack
main.TextSize = 28
main.TextXAlignment = Enum.TextXAlignment.Center
main.Parent = titleHolder

-- Viền chữ
local textStroke = Instance.new("UIStroke")
textStroke.Color = Color3.fromRGB(255, 255, 255)
textStroke.Thickness = 1.2
textStroke.Transparency = 0.6
textStroke.Parent = main

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
divider.BackgroundColor3 = Color3.fromRGB(60, 100, 180)
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

-- Tạo từng dòng stat, trả về valLabel để update
local function makeStat(icon, label, initVal, color)
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
    valLabel.Text = initVal
    valLabel.TextColor3 = color
    valLabel.Font = Enum.Font.GothamBold
    valLabel.TextSize = 13
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.Parent = row

    return valLabel
end

local levelVal     = makeStat("⚔", "Level",     "Scanning...", Color3.fromRGB(255, 220, 80))
local fragVal      = makeStat("💎", "Fragments", "Scanning...", Color3.fromRGB(100, 210, 255))
local beliVal      = makeStat("💰", "Beli",      "Scanning...", Color3.fromRGB(100, 255, 160))

-- Format số đẹp: 1200000 → 1.2M
local function formatNum(n)
    if n >= 1e9 then
        return string.format("%.1fB", n / 1e9)
    elseif n >= 1e6 then
        return string.format("%.1fM", n / 1e6)
    elseif n >= 1e3 then
        return string.format("%.1fK", n / 1e3)
    else
        return tostring(math.floor(n))
    end
end

-- Hàm quét dữ liệu từ leaderstats / stats của game
local function scanStats()
    local char = player.Character
    local leaderstats = player:FindFirstChild("leaderstats")
    local data = player:FindFirstChild("Data") or player:FindFirstChild("PlayerData") or player:FindFirstChild("stats")

    local level, fragments, beli = nil, nil, nil

    -- Quét Level
    if leaderstats then
        local lv = leaderstats:FindFirstChild("Level") or leaderstats:FindFirstChild("level")
                or leaderstats:FindFirstChild("Lvl")   or leaderstats:FindFirstChild("lvl")
        if lv then level = lv.Value end

        local fr = leaderstats:FindFirstChild("Fragments") or leaderstats:FindFirstChild("fragments")
                or leaderstats:FindFirstChild("Fragment")  or leaderstats:FindFirstChild("F")
        if fr then fragments = fr.Value end

        local bl = leaderstats:FindFirstChild("Beli") or leaderstats:FindFirstChild("beli")
                or leaderstats:FindFirstChild("Berries") or leaderstats:FindFirstChild("Money")
                or leaderstats:FindFirstChild("Cash")
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

    -- Fallback: quét toàn bộ player children
    if not level or not fragments or not beli then
        for _, child in ipairs(player:GetChildren()) do
            for _, val in ipairs(child:GetChildren()) do
                local n = val.Name:lower()
                if not level and (n == "level" or n == "lvl") and val:IsA("IntValue") or val:IsA("NumberValue") then
                    level = val.Value
                end
                if not fragments and (n == "fragments" or n == "fragment" or n == "f") and (val:IsA("IntValue") or val:IsA("NumberValue")) then
                    fragments = val.Value
                end
                if not beli and (n == "beli" or n == "berries" or n == "money" or n == "cash") and (val:IsA("IntValue") or val:IsA("NumberValue")) then
                    beli = val.Value
                end
            end
        end
    end

    return level, fragments, beli
end

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
        {Position = UDim2.new(0.5, 0, 0, 54)}
    )
    local down = TweenService:Create(crystal,
        TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
        {Position = UDim2.new(0.5, 0, 0, 70)}
    )
    up:Play()
    up.Completed:Connect(function()
        down:Play()
        down.Completed:Connect(floatLoop)
    end)
end

floatLoop()

-- Loading dots animation + scan liên tục
local dots = {"Loading.", "Loading..", "Loading..."}
local idx = 1
local loadingDone = false
local SCAN_INTERVAL = 0.5 -- quét mỗi 0.5 giây

task.spawn(function()
    -- Chạy loading 2 giây trước
    local timer = 0
    while timer < 2 do
        loading.Text = dots[idx]
        idx = (idx % #dots) + 1
        task.wait(SCAN_INTERVAL)
        timer = timer + SCAN_INTERVAL
    end

    -- Quét lần đầu xong → ẩn loading, hiện stats
    local lv, fr, bl = scanStats()
    levelVal.Text = lv and formatNum(lv) or "N/A"
    fragVal.Text  = fr and formatNum(fr) or "N/A"
    beliVal.Text  = bl and formatNum(bl) or "N/A"

    -- Ẩn loading, hiện stats mượt
    TweenService:Create(loading, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    task.wait(0.4)
    loading.Visible = false
    divider.Visible = true
    statsFrame.Visible = true

    -- Fade in stats
    statsFrame.GroupTransparency = 1
    TweenService:Create(statsFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {GroupTransparency = 0}):Play()

    loadingDone = true
end)

-- Quét liên tục sau khi loading xong
task.spawn(function()
    while not loadingDone do task.wait(0.1) end
    while true do
        task.wait(SCAN_INTERVAL)
        local lv, fr, bl = scanStats()
        if lv then levelVal.Text = formatNum(lv) end
        if fr then fragVal.Text  = formatNum(fr) end
        if bl then beliVal.Text  = formatNum(bl) end
    end
end)
