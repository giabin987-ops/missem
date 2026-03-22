-- [[ LOAD GAME ]]
repeat task.wait() until game:IsLoaded()
local player = game.Players.LocalPlayer

-- [[ 1. LOAD MISS HUB (ĐÃ FIX LỖI END) ]]
pcall(function() 
    loadstring(game:HttpGet("https://raw.githubusercontent.com/giabin987-ops/missem/refs/heads/main/MISS%20HUB"))() 
end) 

-- [[ 2. LOAD FLUENT UI ]]
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- [[ AUTO TEAM ]]
task.spawn(function()
    if not player.Team then
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", getgenv().Team or "Pirates")
        end)
    end
end)

-- Đợi thư viện ổn định
task.wait(2)

-- [[ 3. TẠO GIAO DIỆN ]]
local Window = Fluent:CreateWindow({
    Title = "MISS HUB - Bloxfruit 2026",
    SubTitle = "Team: " .. tostring(player.Team or "Checking..."),
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Auto Cyborg", Icon = "cpu" })
}

-- [[ CẤU HÌNH ]]
_G = {
    AutoCyborg = false,
    TweenSpeed = 300,
    CurrentTween = nil
}

local VisitedChests = {}

-- [[ HỆ THỐNG ĐIỀU KHIỂN ]]
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        pcall(function() Window:ToggleMinimize() end)
    end
end)

-- Giữ chuột luôn hiện
task.spawn(function()
    while true do
        task.wait(1)
        pcall(function() UIS.MouseIconEnabled = true end)
    end
end)

-- [[ HÀM DI CHUYỂN TWEEN ]]
function TweenTo(cf)
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if _G.CurrentTween then _G.CurrentTween:Cancel() end

    local dist = (cf.Position - root.Position).Magnitude
    if dist < 300 then
        root.CFrame = cf
        return
    end

    local tween = game:GetService("TweenService"):Create(
        root,
        TweenInfo.new(dist / _G.TweenSpeed, Enum.EasingStyle.Linear),
        {CFrame = cf}
    )

    _G.CurrentTween = tween
    tween:Play()

    task.spawn(function()
        while tween and tween.PlaybackState == Enum.PlaybackState.Playing do
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
            task.wait()
        end
    end)
    return tween
end

-- [[ TÌM RƯƠNG ]]
function GetRealChest()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local target, distMin = nil, math.huge
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and string.find(v.Name, "Chest") and v:FindFirstChild("TouchInterest") and not VisitedChests[v] then
            local dist = (v.Position - root.Position).Magnitude
            if dist < distMin then
                distMin = dist
                target = v
            end
        end
    end
    return target
end

-- [[ ĐỔI SERVER ]]
function HopServer()
    local TPS = game:GetService("TeleportService")
    local Api = "https://games.roblox.com"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    local s, r = pcall(function() return game:GetService("HttpService"):JSONDecode(game:HttpGet(Api)) end)
    if s and r.data then
        for _, v in pairs(r.data) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                TPS:TeleportToPlaceInstance(game.PlaceId, v.id, player)
                return
            end
        end
    end
    TPS:Teleport(game.PlaceId)
end

-- [[ LOGIC AUTO CYBORG ]]
function MainLogic()
    while _G.AutoCyborg do
        task.wait(0.1)
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then continue end

        local Fist = char:FindFirstChild("Fist of Darkness") or player.Backpack:FindFirstChild("Fist of Darkness")

        if Fist then
            if _G.CurrentTween then _G.CurrentTween:Cancel() end
            local t1 = TweenTo(CFrame.new(-6473, 250, -4493))
            if t1 then t1.Completed:Wait() end
            pcall(function() game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyMicrochip") end)
            task.wait(0.5)
            local t2 = TweenTo(CFrame.new(-6475, 250, -4490))
            if t2 then t2.Completed:Wait() end
            pcall(function() game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartRaid") end)
            break
        end

        local chest = GetRealChest()
        if chest then
            local tw = TweenTo(chest.CFrame + Vector3.new(0,3,0))
            if tw then tw.Completed:Wait() end
            firetouchinterest(root, chest, 0)
            firetouchinterest(root, chest, 1)
            VisitedChests[chest] = true
        else
            task.wait(2)
            HopServer()
            break
        end
    end
end

-- [[ THÊM NÚT BẤM VÀO UI ]]
Tabs.Main:AddToggle("AutoCyborg", {
    Title = "Kích hoạt Auto Cyborg",
    Default = false,
    Callback = function(v)
        _G.AutoCyborg = v
        if v then task.spawn(MainLogic) end
    end
})

Window:SelectTab(1)
