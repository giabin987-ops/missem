-- [[ 2. TỰ ĐỘNG CHỌN TEAM & LOAD MISS HUB ]]
repeat task.wait() until game:IsLoaded()
local player = game.Players.LocalPlayer

task.spawn(function()
    if not player.Team then
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", getgenv().Team)
        end)
    end
end)

task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/giabin987-ops/missem/refs/heads/main/MISS%20HUB"))()
    end)
end)

-- [[ 3. KHỞI TẠO FLUENT UI ]]
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Window = Fluent:CreateWindow({
    Title = "MISS HUB - Bloxfruit 2026",
    SubTitle = "Team: " .. getgenv().Team,
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = { Main = Window:AddTab({ Title = "Auto Cyborg", Icon = "cpu" }) }

local _G = {
    AutoCyborg = false,
    TweenSpeed = 180,
    CurrentTween = nil
}

local VisitedChests = {}

-- [[ 4. HÀM DI CHUYỂN SIÊU TỐC - FIX CHẠM NƯỚC/GIẬT ]]
function TweenTo(TargetCFrame)
    local Character = player.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    local Root = Character.HumanoidRootPart
    
    if _G.CurrentTween then _G.CurrentTween:Cancel() end

    local BV = Root:FindFirstChild("CyborgBV") or Instance.new("BodyVelocity")
    BV.Name = "CyborgBV"
    BV.Parent = Root
    BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    BV.Velocity = Vector3.new(0, 0, 0)
    Character.Humanoid.PlatformStand = true
    
    local Distance = (TargetCFrame.Position - Root.Position).Magnitude
    _G.CurrentTween = game:GetService("TweenService"):Create(Root, TweenInfo.new(Distance/_G.TweenSpeed, Enum.EasingStyle.Linear), {CFrame = TargetCFrame})
    _G.CurrentTween:Play()
    
    -- NoClip khi đang bay
    task.spawn(function()
        while _G.CurrentTween and _G.CurrentTween.PlaybackState == Enum.PlaybackState.Playing do
            for _, v in pairs(Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
            task.wait()
        end
    end)
    return _G.CurrentTween
end

-- [[ 5. HÀM QUÉT RƯƠNG THÔNG MINH - FIX LỖI KHÔNG LỢM ]]
function GetRealChest()
    local Target = nil
    local MinDist = math.huge
    local Root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not Root then return nil end
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if (v.Name == "Chest1" or v.Name == "Chest2" or v.Name == "Chest3") and v:IsA("BasePart") and not VisitedChests[v] then
            local hasTouch = v:FindFirstChild("TouchInterest")
            local isVisible = v.Transparency < 0.5
            if hasTouch and isVisible then
                local dist = (v.Position - Root.Position).Magnitude
                if dist < MinDist then
                    MinDist = dist
                    Target = v
                end
            end
        end
    end
    return Target
end

function HopServer()
    Fluent:Notify({Title = "MISS HUB", Content = "Server thực sự hết rương! Đang Hop...", Duration = 5})
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
    TPS:Teleport(game.PlaceId, player)
end

function MainLogic()
    repeat task.wait(1) until player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    
    Fluent:Notify({Title = "MISS HUB", Content = "Đang load rương toàn server...", Duration = 3})
    TweenTo(CFrame.new(-2463, 73, -3172)).Completed:Wait() -- Kingdom of Rose
    task.wait(1)

    while _G.AutoCyborg do
        task.wait(0.1)
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then continue end

        local Fist = player.Character:FindFirstChild("Fist of Darkness") or player.Backpack:FindFirstChild("Fist of Darkness")
        
        if not Fist then
            local Chest = GetRealChest()
            if Chest then
                --- Đi đến trên tâm rương, cao hơn 3 đơn vị để dễ lượm
                local tw = TweenTo(Chest.CFrame + Vector3.new(0, 3, 0))
                if tw then 
                    tw.Completed:Wait()
                    task.wait(0.5) -- Chờ đủ lâu để server nhận lượm rương
                    VisitedChests[Chest] = true
                end
            else
                task.wait(5)
                if not GetRealChest() then
                    HopServer()
                    break
                end
            end
        else
            -- Raid Law Logic
            TweenTo(CFrame.new(-6473, 250, -4493)).Completed:Wait()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyMicrochip")
            task.wait(0.5)
            TweenTo(CFrame.new(-6475, 250, -4490)).Completed:Wait()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartRaid") 
        end
    end
end

-- [[ 7. UI TOGGLE ]]
Tabs.Main:AddToggle("AutoCyborg", {
    Title = "Auto Kaitun Cyborg (FIX LỖI HOP & LƯỢM RƯƠNG)",
    Default = false,
    Callback = function(Value)
        _G.AutoCyborg = Value
        if Value then 
            task.spawn(MainLogic) 
        else 
            if _G.CurrentTween then _G.CurrentTween:Cancel() end
            local Root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if Root and Root:FindFirstChild("CyborgBV") then Root.CyborgBV:Destroy() end
            if player.Character then player.Character.Humanoid.PlatformStand = false end
        end
    end
})

Window:SelectTab(1)
