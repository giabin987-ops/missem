-- [[ LOAD GAME ]]
repeat task.wait() until game:IsLoaded()
local player = game.Players.LocalPlayer

-- [[ AUTO TEAM ]]
task.spawn(function()
    if not player.Team then
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", getgenv().Team)
        end)
    end
end)

-- [[ LOAD MISS HUB (GIỮ NGUYÊN) ]]
task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/giabin987-ops/missem/refs/heads/main/MISS%20HUB"))()
    end)
end)

-- đợi lib load
task.wait(4)

-- [[ LOAD FLUENT ]]
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "MISS HUB - Bloxfruit 2026",
    SubTitle = "Team: " .. tostring(getgenv().Team),
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl -- đổi phím tránh conflict
})

local Tabs = {
    Main = Window:AddTab({ Title = "Auto Cyborg", Icon = "cpu" })
}

-- [[ CONFIG ]]
_G = {
    AutoCyborg = false,
    TweenSpeed = 300,
    CurrentTween = nil
}

local VisitedChests = {}

-- [[ FIX INPUT ]]
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        pcall(function()
            Window:ToggleMinimize()
        end)
    end
end)

-- giữ chuột
task.spawn(function()
    while true do
        task.wait(1)
        pcall(function()
            UIS.MouseIconEnabled = true
        end)
    end
end)

-- [[ TWEEN HYBRID ]]
function TweenTo(cf)
    local char = player.Character
    if not char then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if _G.CurrentTween then
        _G.CurrentTween:Cancel()
    end

    local dist = (cf.Position - root.Position).Magnitude

    -- gần → TP
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
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
            task.wait()
        end
    end)

    return tween
end

-- [[ FIND CHEST ]]
function GetRealChest()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local target, distMin = nil, math.huge

    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart")
        and string.find(v.Name, "Chest")
        and v:FindFirstChild("TouchInterest")
        and not VisitedChests[v] then

            local dist = (v.Position - root.Position).Magnitude
            if dist < distMin then
                distMin = dist
                target = v
            end
        end
    end

    return target
end

-- [[ HOP SERVER ]]
function HopServer()
    VisitedChests = {}

    local TPS = game:GetService("TeleportService")
    local Api = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"

    local s, r = pcall(function()
        return game:GetService("HttpService"):JSONDecode(game:HttpGet(Api))
    end)

    if s and r.data then
        for _, v in pairs(r.data) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                TPS:TeleportToPlaceInstance(game.PlaceId, v.id, player)
                return
            end
        end
    end

    TPS:Teleport(game.PlaceId, player)
end

-- [[ MAIN ]]
function MainLogic()
    repeat task.wait() until player.Character and player.Character:FindFirstChild("HumanoidRootPart")

    local retry = 0

    while _G.AutoCyborg do
        task.wait(0.1)

        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then continue end

        local Fist = char:FindFirstChild("Fist of Darkness")
            or player.Backpack:FindFirstChild("Fist of Darkness")

        -- có fist → raid ngay
        if Fist then
            if _G.CurrentTween then _G.CurrentTween:Cancel() end

            local t1 = TweenTo(CFrame.new(-6473, 250, -4493))
            if t1 then t1.Completed:Wait() end

            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyMicrochip")
            end)

            task.wait(0.3)

            local t2 = TweenTo(CFrame.new(-6475, 250, -4490))
            if t2 then t2.Completed:Wait() end

            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartRaid")
            end)

            break
        end

        -- farm chest
        local chest = GetRealChest()

        if chest then
            retry = 0

            local tw = TweenTo(chest.CFrame + Vector3.new(0,3,0))
            if tw then tw.Completed:Wait() end

            for i = 1,3 do
                firetouchinterest(root, chest, 0)
                firetouchinterest(root, chest, 1)
                task.wait(0.1)
            end

            VisitedChests[chest] = true

        else
            retry += 1
            task.wait(5)

            if retry >= 5 then
                HopServer()
                break
            end
        end
    end
end

-- [[ UI ]]
Tabs.Main:AddToggle("AutoCyborg", {
    Title = "Auto Cyborg (Tween Fast)",
    Default = false,
    Callback = function(v)
        _G.AutoCyborg = v
        if v then
            task.spawn(MainLogic)
        else
            if _G.CurrentTween then _G.CurrentTween:Cancel() end
        end
    end
})

Window:SelectTab(1)
