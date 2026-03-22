-- [[ 2. TỰ ĐỘNG CHỌNnn TEAM & LOAD MISS HUB ]]
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

local Tabs = {
    Main = Window:AddTab({ Title = "Auto Cyborg", Icon = "cpu" }),
}

local _G = {
    AutoCyborg = false,
    TweenSpeed = 175, -- Tốc độ lướt cực nhanh
    CurrentTween = nil
}

local VisitedChests = {}

-- [[ 4. HÀM DI CHUYỂN SIÊU TỐC - ÉP CHẠM RƯƠNG ]]
function TweenTo(TargetCFrame)
    local Character = player.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    
    local Root = Character.HumanoidRootPart
    local Hum = Character:FindFirstChild("Humanoid")
    
    if _G.CurrentTween then _G.CurrentTween:Cancel() end

    -- Khóa độ cao bằng BodyVelocity (Chống rơi nước 100%)
    local BV = Root:FindFirstChild("CyborgBV") or Instance.new("BodyVelocity")
    BV.Name = "CyborgBV"; BV.Parent = Root
    BV.MaxForce = Vector3.new(9e9, 9e9, 9e9); BV.Velocity = Vector3.new(0, 0, 0)
    
    if Hum then Hum.PlatformStand = true end
    
    local Distance = (TargetCFrame.Position - Root.Position).Magnitude
    _G.CurrentTween = game:GetService("TweenService"):Create(Root, TweenInfo.new(Distance/_G.TweenSpeed, Enum.EasingStyle.Linear), {CFrame = TargetCFrame})
    _G.CurrentTween:Play()
    
    -- NOCLIP XUYÊN VẬT THỂ: Để chạm rương dễ hơn
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

-- [[ 5. HÀM QUÉT RƯƠNG CHÍNH XÁC - FIX LỖI KHÔNG LỢM ]]
function GetRealChest()
    local Target = nil
    local MaxDist = math.huge
    
    for _, v in pairs(game.Workspace:GetDescendants()) do
        -- Chỉ lấy rương chuẩn Chest1, Chest2, Chest3
        if (v.Name == "Chest1" or v.Name == "Chest2" or v.Name == "Chest3") and v:IsA("BasePart") and not VisitedChests[v] then
            -- Rương phải có TouchInterest (để lượm được) và tàng hình không quá cao
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
    Fluent:Notify({Title = "MISS HUB", Content = "Server hết rương! Đang đổi vùng...", Duration = 5})
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

-- [[ 6. VÒNG LẶP CHÍNH ]]
function MainLogic()
    -- Đợi nhân vật hiện ra
    repeat task.wait(1) until player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    
    while _G.AutoCyborg do
        task.wait(0.05) -- Quét liên tục không nghỉ
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then continue end

        local Fist = player.Character:FindFirstChild("Fist of Darkness") or player.Backpack:FindFirstChild("Fist of Darkness")
        
        if not Fist then
            local Chest = GetRealChest()
            if Chest then
                -- Bay thẳng vào giữa rương (CFrame chuẩn)
                local tw = TweenTo(Chest.CFrame)
                if tw then 
                    tw.Completed:Wait() 
                    task.wait(0.15) -- Đợi server nhận tiền
                    VisitedChests[Chest] = true -- Chỉ đánh dấu sau khi đã chạm rương
                end
            else
                -- Fix lỗi báo hết rương ảo: Đợi 4 giây cho map tải rương ở xa
                task.wait(4)
                if not GetRealChest() then HopServer() break end
            end
        else
            -- Đã có Fist -> Đi mua chip Law
            local tw1 = TweenTo(CFrame.new(-6473, 250, -4493)) -- Tọa độ NPC Aris
            if tw1 then tw1.Completed:Wait() end
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyMicrochip")
            
            task.wait(0.5)
            local tw2 = TweenTo(CFrame.new(-6475, 250, -4490)) -- Nút Start Raid
            if tw2 then tw2.Completed:Wait() end
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartRaid") 
        end
    end
end

-- [[ 7. GIAO DIỆN ]]
Tabs.Main:AddToggle("AutoCyborg", {
    Title = "Auto Kaitun Cyborg (FIX LỢM RƯƠNG)",
    Default = false,
    Callback = function(Value)
        _G.AutoCyborg = Value
        if Value then 
            task.spawn(MainLogic) 
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
