-- [[ 1. LOADx GAME ]]
repeat task.wait() until game:IsLoaded()
local player = game.Players.LocalPlayer

-- [[ 2. AUTO CHỌN TEAM ]]
task.spawn(function()
    if not player.Team then
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", getgenv().Team)
        end)
    end
end)

-- [[ 3. LOAD LIB ]]
task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/giabin987-ops/missem/refs/heads/main/MISS%20HUB"))()
    end)
end)

-- [[ 4. LOAD FLUENT ]]
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "MISS HUB - Bloxfruit 2026",
    SubTitle = "Team: " .. tostring(getgenv().Team),
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark"
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

-- [[ TWEEN HYBRID ]]
function TweenTo(TargetCFrame)
    local Character = player.Character
    if not Character then return end

    local Root = Character:FindFirstChild("HumanoidRootPart")
    if not Root then return end

    if _G.CurrentTween then
        _G.CurrentTween:Cancel()
    end

    local Distance = (TargetCFrame.Position - Root.Position).Magnitude

    -- gần thì TP
    if Distance < 300 then
        Root.CFrame = TargetCFrame
        return
    end

    local Time = Distance / _G.TweenSpeed

    local Tween = game:GetService("TweenService"):Create(
        Root,
        TweenInfo.new(Time, Enum.EasingStyle.Linear),
        {CFrame = TargetCFrame}
    )

    _G.CurrentTween = Tween
    Tween:Play()

    task.spawn(function()
        while Tween and Tween.PlaybackState == Enum.PlaybackState.Playing do
            for _, v in pairs(Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
            task.wait()
        end
    end)

    return Tween
end

-- [[ FIND CHEST ]]
function GetRealChest()
    local Root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not Root then return nil end

    local Target = nil
    local MinDist = math.huge

    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart")
        and string.find(v.Name, "Chest")
        and v:FindFirstChild("TouchInterest")
        and not VisitedChests[v] then

            local dist = (v.Position - Root.Position).Magnitude

            if dist < MinDist then
                MinDist = dist
                Target = v
            end
        end
    end

    return Target
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

        local Character = player.Character
        local Root = Character and Character:FindFirstChild("HumanoidRootPart")
        if not Root then continue end

        local Fist = Character:FindFirstChild("Fist of Darkness")
            or player.Backpack:FindFirstChild("Fist of Darkness")

        -- có fist → raid
        if Fist then
            if _G.CurrentTween then _G.CurrentTween:Cancel() end

            local tw1 = TweenTo(CFrame.new(-6473, 250, -4493))
            if tw1 then tw1.Completed:Wait() end

            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyMicrochip")
            end)

            task.wait(0.3)

            local tw2 = TweenTo(CFrame.new(-6475, 250, -4490))
            if tw2 then tw2.Completed:Wait() end

            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartRaid")
            end)

            break
        end

        -- farm chest
        local Chest = GetRealChest()

        if Chest then
            retry = 0

            local tw = TweenTo(Chest.CFrame + Vector3.new(0,3,0))
            if tw then tw.Completed:Wait() end

            for i = 1,3 do
                firetouchinterest(Root, Chest, 0)
                firetouchinterest(Root, Chest, 1)
                task.wait(0.1)
            end

            VisitedChests[Chest] = true

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
    Callback = function(Value)
        _G.AutoCyborg = Value
        if Value then
            task.spawn(MainLogic)
        else
            if _G.CurrentTween then _G.CurrentTween:Cancel() end
        end
    end
})

Window:SelectTab(1)
