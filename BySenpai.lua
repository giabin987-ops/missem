-- [ 1. LOAD MISS HUB ]
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
    TweenSpeed = 180, -- Tăng tốc độ bay cực nhanh
    CurrentTween = nil
}

local VisitedChests = {}

-- [ HÀM QUÉT SIÊU TỐC - FIX LỖI BÁO HẾT RƯƠNG ]
function GetFastChest()
    local Target = nil
    local MaxDist = math.huge
    
    -- Quét toàn bộ map ngay lập tức
    local allObjects = game.Workspace:GetDescendants()
    
    for i = 1, #allObjects do
        local v = allObjects[i]
        -- Chỉ lọc đúng rương và rương phải có thực (không tàng hình)
        if (v.Name == "Chest1" or v.Name == "Chest2" or v.Name == "Chest3") and v:IsA("BasePart") and not VisitedChests[v] then
            if v:FindFirstChild("TouchInterest") then 
                local Dist = (v.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if Dist < MaxDist then
                    MaxDist = Dist
                    Target = v
                end
            end
        end
    end
    return Target
end

function TweenTo(TargetCFrame)
    local Root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not Root then return end
    if _G.CurrentTween then _G.CurrentTween:Cancel() end

    -- Khóa trọng lực để bay thẳng
    local BV = Root:FindFirstChild("CyborgBV") or Instance.new("BodyVelocity")
    BV.Name = "CyborgBV"
    BV.Parent = Root
    BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    BV.Velocity = Vector3.new(0, 0, 0)
    
    game.Players.LocalPlayer.Character.Humanoid.PlatformStand = true 
    
    local Distance = (TargetCFrame.Position - Root.Position).Magnitude
    _G.CurrentTween = game:GetService("TweenService"):Create(Root, TweenInfo.new(Distance/_G.TweenSpeed, Enum.EasingStyle.Linear), {CFrame = TargetCFrame})
    _G.CurrentTween:Play()
    
    -- Noclip xuyên thấu
    task.spawn(function()
        while _G.CurrentTween and _G.CurrentTween.PlaybackState == Enum.PlaybackState.Playing do
            for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
            task.wait()
        end
    end)
    return _G.CurrentTween
end

function HopServer()
    Fluent:Notify({Title = "MISS HUB", Content = "Server hết rương thật sự! Đang Hop...", Duration = 3})
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
        task.wait(0.05) -- Tốc độ nhận diện cực cao
        local P = game.Players.LocalPlayer
        local C = P.Character
        if not C or not C:FindFirstChild("HumanoidRootPart") then continue end

        local Fist = C:FindFirstChild("Fist of Darkness") or P.Backpack:FindFirstChild("Fist of Darkness")
        local Core = C:FindFirstChild("Core Brain") or P.Backpack:FindFirstChild("Core Brain")

        if Core then
            TweenTo(CFrame.new(-6371, 236, -4051)).Completed:Wait()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CyborgProvider", "Buy")
            _G.AutoCyborg = false break
        end

        if not Fist then
            local Chest = GetFastChest()
            if Chest then
                local tw = TweenTo(Chest.CFrame * CFrame.new(0, 1, 0))
                if tw then 
                    tw.Completed:Wait() 
                    VisitedChests[Chest] = true
                    task.wait(0.05) 
                end
            else
                -- Nếu không tìm thấy rương, đợi thêm 1 giây nữa để chắc chắn do map chưa load
                task.wait(1.5)
                Chest = GetFastChest()
                if not Chest then
                    HopServer()
                    break
                end
            end
        else
            -- Raid Law
            TweenTo(CFrame.new(-6473, 250, -4493)).Completed:Wait()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyMicrochip")
            task.wait(0.3)
            TweenTo(CFrame.new(-6475, 250, -4490)).Completed:Wait()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartRaid") 
            
            local Law = game.Workspace.Enemies:FindFirstChild("Order") or game.Workspace.Enemies:FindFirstChild("Law")
            if Law and Law:FindFirstChild("HumanoidRootPart") then
                TweenTo(Law.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0))
                game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end
        end
    end
end

-- [ UI ]
Tabs.Main:AddToggle("AutoCyborg", {
    Title = "Auto Kaitun Cyborg (TỐC ĐỘ CAO)",
    Default = false,
    Callback = function(Value)
        _G.AutoCyborg = Value
        if Value then task.spawn(MainLogic) 
        else 
            if _G.CurrentTween then _G.CurrentTween:Cancel() end
            local Root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if Root and Root:FindFirstChild("CyborgBV") then Root.CyborgBV:Destroy() end
            game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
        end
    end
})

Window:SelectTab(1)
