-- [[ 1. FIX LỖI KHÔNG HIỆN MISS HUB ]]
task.spawn(function()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    end)
    if not success then 
        warn("Đang thử tải lại MISS HUB...")
        task.wait(2)
        pcall(function()
            loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
        end)
    end
end)

-- [[ 2. KHỞI TẠO LOGIC VÀ UI FLUENT ]]
repeat task.wait() until game:IsLoaded()
local player = game.Players.LocalPlayer

-- Tự động chọn đội theo cấu hình trên
task.spawn(function()
    if not player.Team then
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", getgenv().Team)
        end)
    end
end)

local Fluent = loadstring(game:HttpGet("https://github.com"))()
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
    TweenSpeed = 165,
    CurrentTween = nil
}

local VisitedChests = {}

-- [[ 3. HÀM DI CHUYỂN SIÊU MƯỢT - KHÔNG GIẬT - KHÔNG RƠI NƯỚC ]]
function TweenTo(TargetCFrame)
    local Char = player.Character
    if not Char or not Char:FindFirstChild("HumanoidRootPart") then return end
    local Root = Char.HumanoidRootPart
    local Hum = Char:FindFirstChild("Humanoid")
    
    if _G.CurrentTween then _G.CurrentTween:Cancel() end

    -- Khóa trọng lực để bay thẳng tắp
    local BV = Root:FindFirstChild("CyborgBV") or Instance.new("BodyVelocity")
    BV.Name = "CyborgBV"; BV.Parent = Root
    BV.MaxForce = Vector3.new(9e9, 9e9, 9e9); BV.Velocity = Vector3.new(0, 0, 0)
    
    if Hum then Hum.PlatformStand = true end
    
    local Distance = (TargetCFrame.Position - Root.Position).Magnitude
    _G.CurrentTween = game:GetService("TweenService"):Create(Root, TweenInfo.new(Distance/_G.TweenSpeed, Enum.EasingStyle.Linear), {CFrame = TargetCFrame})
    _G.CurrentTween:Play()
    
    -- NoClip xuyên thấu khi đang bay
    task.spawn(function()
        while _G.CurrentTween and _G.CurrentTween.PlaybackState == Enum.PlaybackState.Playing do
            if player.Character then
                for _, v in pairs(player.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
            task.wait()
        end
    end)
    return _G.CurrentTween
end

-- [[ 4. QUÉT RƯƠNG TOÀN MAP - FIX LỖI KHÔNG LỢM RƯƠNG ]]
function GetGlobalChest()
    local Target = nil
    local MaxDist = math.huge
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if (v.Name == "Chest1" or v.Name == "Chest2" or v.Name == "Chest3") and v:IsA("BasePart") and not VisitedChests[v] then
            if v:FindFirstChild("TouchInterest") and v.Transparency < 0.5 then 
                local Root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if Root then
                    local Dist = (v.Position - Root.Position).Magnitude
                    if Dist < MaxDist then
                        MaxDist = Dist; Target = v
                    end
                end
            end
        end
    end
    return Target
end

function HopServer()
    Fluent:Notify({Title = "MISS HUB", Content = "Đang đổi server mới...", Duration = 5})
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

-- [[ 5. VÒNG LẶP CHÍNH ]]
function MainLogic()
    repeat task.wait(1) until player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    
    while _G.AutoCyborg do
        task.wait(0.1)
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then continue end

        local Fist = player.Character:FindFirstChild("Fist of Darkness") or player.Backpack:FindFirstChild("Fist of Darkness")
        
        if not Fist then
            local Chest = GetGlobalChest()
            if Chest then
                local tw = TweenTo(Chest.CFrame * CFrame.new(0, 1, 0))
                if tw then 
                    tw.Completed:Wait() 
                    VisitedChests[Chest] = true
                    task.wait(0.1) 
                end
            else
                -- Đợi map load trước khi Hop
                task.wait(4)
                if not GetGlobalChest() then HopServer() break end
            end
        else
            -- Raid Law Logic
            TweenTo(CFrame.new(-6473, 250, -4493)).Completed:Wait() -- NPC Aris
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyMicrochip")
            task.wait(0.5)
            TweenTo(CFrame.new(-6475, 250, -4490)).Completed:Wait() -- Button
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartRaid") 
        end
    end
end

-- [[ 6. GIAO DIỆN ]]
Tabs.Main:AddToggle("AutoCyborg", {
    Title = "Auto Kaitun Cyborg",
    Default = false,
    Callback = function(Value)
        _G.AutoCyborg = Value
        if Value then task.spawn(MainLogic) 
        else 
            if _G.CurrentTween then _G.CurrentTween:Cancel() end
            local Root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if Root and Root:FindFirstChild("CyborgBV") then Root.CyborgBV:Destroy() end
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.PlatformStand = false
            end
        end
    end
})

Window:SelectTab(1)
