-- [ 1. LOAD SCREEN vGUI / MISS HUB ]
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/giabin987-ops/missem/refs/heads/main/MISS%20HUB"))()
end)

-- [ 2. KHỞI TẠO FLUENT ]
repeat task.wait() until game:IsLoaded()
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "MISS HUB - Bloxfruit 2026",
    SubTitle = "by Senpai",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Auto Cyborg", Icon = "cpu" }),
}

local _G = {
    AutoCyborg = false,
    TweenSpeed = 80, -- Tốc độ 80 là mượt nhất để tránh anti-cheat
    CurrentTween = nil
}

local VisitedChests = {}
local Pos = {
    Aris = CFrame.new(-6473, 250, -4493),
    Button = CFrame.new(-6475, 250, -4490),
    CyborgNPC = CFrame.new(-6371, 236, -4051),
}

-- [ HÀM DI CHUYỂN SIÊU MƯỢT - FIX GIẬT ]
function TweenTo(TargetCFrame)
    local Character = game.Players.LocalPlayer.Character
    local Root = Character:FindFirstChild("HumanoidRootPart")
    local Hum = Character:FindFirstChild("Humanoid")
    
    if not Root or not Hum then return end
    if _G.CurrentTween then _G.CurrentTween:Cancel() end

    -- KỸ THUẬT FIX GIẬT:
    -- Khóa vật lý nhân vật để không bị trọng lực kéo xuống khi đang bay
    Root.Velocity = Vector3.new(0, 0, 0)
    Hum.PlatformStand = true 

    local Distance = (TargetCFrame.Position - Root.Position).Magnitude
    _G.CurrentTween = game:GetService("TweenService"):Create(Root, TweenInfo.new(Distance/_G.TweenSpeed, Enum.EasingStyle.Linear), {CFrame = TargetCFrame})
    _G.CurrentTween:Play()

    -- Khi bay xong thì trả lại trạng thái bình thường
    _G.CurrentTween.Completed:Connect(function()
        Hum.PlatformStand = false
    end)

    return _G.CurrentTween
end

-- [ HÀM QUÉT RƯƠNG MỚI ]
function GetNewChest()
    local NearestChest = nil
    local MaxDist = math.huge
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if (v.Name:find("Chest") or v.Name:find("Box")) and v:IsA("BasePart") and not VisitedChests[v] then
            local Dist = (v.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if Dist < MaxDist then
                MaxDist = Dist
                NearestChest = v
            end
        end
    end
    return NearestChest
end

function HopServer()
    VisitedChests = {}
    local TPS = game:GetService("TeleportService")
    local Api = "https://games.roblox.com"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    local s, r = pcall(function() return game:GetService("HttpService"):JSONDecode(game:HttpGet(Api)) end)
    if s and r.data then
        for _, v in pairs(r.data) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                TPS:TeleportToPlaceInstance(game.PlaceId, v.id, game.Players.LocalPlayer)
                break
            end
        end
    end
end

-- [ LOGIC CHÍNH ]
function MainLogic()
    while _G.AutoCyborg do
        task.wait(0.1)
        local P = game.Players.LocalPlayer
        local C = P.Character
        if not C or not C:FindFirstChild("HumanoidRootPart") then continue end

        local Fist = C:FindFirstChild("Fist of Darkness") or P.Backpack:FindFirstChild("Fist of Darkness")
        local Core = C:FindFirstChild("Core Brain") or P.Backpack:FindFirstChild("Core Brain")

        if Core then
            TweenTo(Pos.CyborgNPC).Completed:Wait()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CyborgProvider", "Buy")
            _G.AutoCyborg = false break
        end

        if not Fist then
            local Chest = GetNewChest()
            if Chest then
                local tw = TweenTo(Chest.CFrame * CFrame.new(0, 2, 0))
                if tw then 
                    tw.Completed:Wait() 
                    task.wait(0.5) 
                    VisitedChests[Chest] = true
                end
            else
                HopServer() break
            end
        else
            -- Raid Law
            TweenTo(Pos.Aris).Completed:Wait()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyMicrochip")
            task.wait(0.5)
            TweenTo(Pos.Button).Completed:Wait()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartRaid") 
            
            local Law = game.Workspace.Enemies:FindFirstChild("Order") or game.Workspace.Enemies:FindFirstChild("Law")
            if Law and Law:FindFirstChild("HumanoidRootPart") then
                TweenTo(Law.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0))
                game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end
        end
    end
end

-- [ ANTI-LAG / NO CLIP KHI BAY ]
task.spawn(function()
    while task.wait() do
        if _G.AutoCyborg and _G.CurrentTween then
            local Char = game.Players.LocalPlayer.Character
            if Char then
                for _, v in pairs(Char:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end
    end
end)

-- [ GIAO DIỆN ]
Tabs.Main:AddToggle("AutoCyborg", {
    Title = "Auto Kaitun Cyborg (SIÊU MƯỢT)",
    Default = false,
    Callback = function(Value)
        _G.AutoCyborg = Value
        if Value then 
            task.spawn(MainLogic) 
        else 
            local Hum = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
            if Hum then Hum.PlatformStand = false end
            if _G.CurrentTween then _G.CurrentTween:Cancel() end 
        end
    end
})

Window:SelectTab(1)
