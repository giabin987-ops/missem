-- [ 1. xTỰ ĐỘNG CHỌN HẢI TẶC - FIX LỖI NIL FINDFIRSTCHILD ]
repeat task.wait() until game:IsLoaded()
local player = game.Players.LocalPlayer
repeat task.wait() until player

task.spawn(function()
    if not player.Team then
        -- Ép chọn đội Hải tặc để nhân vật xuất hiện
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
    end
end)

-- [ 2. LOAD MISS HUB VÀ FLUENT ]
pcall(function()
    loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

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
    TweenSpeed = 180, 
    CurrentTween = nil
}

local VisitedChests = {}

-- [ 3. HÀM DI CHUYỂN SIÊU MƯỢT - KIỂM TRA NHÂN VẬT CHẶT CHẼ ]
function TweenTo(TargetCFrame)
    local Character = player.Character
    if not Character then return end -- Fix lỗi Nil Character
    
    local Root = Character:FindFirstChild("HumanoidRootPart")
    local Hum = Character:FindFirstChild("Humanoid")
    if not Root or not Hum then return end
    
    if _G.CurrentTween then _G.CurrentTween:Cancel() end

    local BV = Root:FindFirstChild("CyborgBV") or Instance.new("BodyVelocity")
    BV.Name = "CyborgBV"
    BV.Parent = Root
    BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    BV.Velocity = Vector3.new(0, 0, 0)
    
    Hum.PlatformStand = true 
    
    local Distance = (TargetCFrame.Position - Root.Position).Magnitude
    _G.CurrentTween = game:GetService("TweenService"):Create(Root, TweenInfo.new(Distance/_G.TweenSpeed, Enum.EasingStyle.Linear), {CFrame = TargetCFrame})
    _G.CurrentTween:Play()
    
    task.spawn(function()
        while _G.CurrentTween and _G.CurrentTween.PlaybackState == Enum.PlaybackState.Playing do
            if player.Character then
                for _, v in pairs(player.Character:GetChildren()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
            task.wait()
        end
    end)
    return _G.CurrentTween
end

-- [ 4. QUÉT RƯƠNG CHUẨN 2026 - FIX LỖI KHÔNG THẤY RƯƠNG ]
function GetGlobalChest()
    local Target = nil
    local MaxDist = math.huge
    
    -- Quét rương kỹ hơn (bao gồm cả rương đang load)
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if (v.Name == "Chest1" or v.Name == "Chest2" or v.Name == "Chest3") and v:IsA("BasePart") and not VisitedChests[v] then
            -- Rương phải có TouchInterest và không quá mờ
            if v:FindFirstChild("TouchInterest") and v.Transparency < 0.8 then 
                local Root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if Root then
                    local Dist = (v.Position - Root.Position).Magnitude
                    if Dist < MaxDist then
                        MaxDist = Dist
                        Target = v
                    end
                end
            end
        end
    end
    return Target
end

function HopServer()
    Fluent:Notify({Title = "MISS HUB", Content = "Đã lượm hết rương thật sự! Đang Hop...", Duration = 5})
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

-- [ 5. LOGIC CHÍNH ]
function MainLogic()
    -- Đợi nhân vật spawn hoàn toàn mới bắt đầu quét
    repeat task.wait(1) until player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    
    Fluent:Notify({Title = "MISS HUB", Content = "Đang quét rương lần đầu...", Duration = 3})
    task.wait(2) -- Đợi rương load hẳn

    while _G.AutoCyborg do
        task.wait(0.1)
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then continue end

        local Fist = player.Character:FindFirstChild("Fist of Darkness") or player.Backpack:FindFirstChild("Fist of Darkness")
        local Core = player.Character:FindFirstChild("Core Brain") or player.Backpack:FindFirstChild("Core Brain")

        if Core then
            TweenTo(CFrame.new(-6371, 236, -4051)).Completed:Wait()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CyborgProvider", "Buy")
            _G.AutoCyborg = false break
        end

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
                -- KIỂM TRA LẠI 2 LẦN TRƯỚC KHI HOP ĐỂ TRÁNH HOP ẢO
                task.wait(3)
                if not GetGlobalChest() then HopServer() break end
            end
        else
            -- Raid Law
            TweenTo(CFrame.new(-6473, 250, -4493)).Completed:Wait()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyMicrochip")
            task.wait(0.5)
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

-- [ 6. UI ]
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
        end
    end
})

Window:SelectTab(1)
