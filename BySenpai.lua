-- [ LOAD MISS HUB ]
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/giabin987-ops/missem/refs/heads/main/MISS%20HUB"))()
end)

-- [ KHỞI TẠO FLUENT ]
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
    TweenSpeed = 90, -- Tốc độ tối ưu để bay xa
    CurrentTween = nil
}

local VisitedChests = {}
local Pos = {
    Aris = CFrame.new(-6473, 250, -4493),
    Button = CFrame.new(-6475, 250, -4490),
    CyborgNPC = CFrame.new(-6371, 236, -4051),
}

-- [ HÀM QUÉT TOÀN BẢN ĐỒ - FIX LỖI 1 KHU VỰC ]
function GetGlobalChest()
    local NearestChest = nil
    local MaxDist = math.huge
    
    -- Quét Descendants giúp tìm rương ở TẤT CẢ folder (Map, Sea, Islands...)
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if (v.Name:find("Chest") or v.Name:find("Box")) and v:IsA("BasePart") and not VisitedChests[v] then
            local Dist = (v.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            -- Không giới hạn tầm nhìn, rương xa nhất cũng sẽ tìm thấy
            if Dist < MaxDist then
                MaxDist = Dist
                NearestChest = v
            end
        end
    end
    return NearestChest
end

-- [ HÀM DI CHUYỂN SIÊU MƯỢT & CHỐNG RƠI ]
function TweenTo(TargetCFrame)
    local Root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local Hum = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if not Root then return end
    
    if _G.CurrentTween then _G.CurrentTween:Cancel() end
    
    -- Fix lỗi giật lên xuống/rơi đất bằng cách khóa vật lý
    Root.Velocity = Vector3.new(0,0,0)
    Hum.PlatformStand = true 

    local Distance = (TargetCFrame.Position - Root.Position).Magnitude
    _G.CurrentTween = game:GetService("TweenService"):Create(Root, TweenInfo.new(Distance/_G.TweenSpeed, Enum.EasingStyle.Linear), {CFrame = TargetCFrame})
    _G.CurrentTween:Play()
    
    return _G.CurrentTween
end

-- [ LOGIC CHÍNH ]
function MainLogic()
    while _G.AutoCyborg do
        task.wait(0.1)
        local P = game.Players.LocalPlayer
        local C = P.Character
        if not C or not C:FindFirstChild("HumanoidRootPart") then continue end

        -- Noclip xuyên tường khi bay
        for _, v in pairs(C:GetChildren()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end

        local Fist = C:FindFirstChild("Fist of Darkness") or P.Backpack:FindFirstChild("Fist of Darkness")
        local Core = C:FindFirstChild("Core Brain") or P.Backpack:FindFirstChild("Core Brain")

        if Core then
            TweenTo(Pos.CyborgNPC).Completed:Wait()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CyborgProvider", "Buy")
            _G.AutoCyborg = false break
        end

        if not Fist then
            local Chest = GetGlobalChest() -- Gọi hàm quét toàn map
            if Chest then
                local tw = TweenTo(Chest.CFrame * CFrame.new(0, 2, 0))
                if tw then 
                    tw.Completed:Wait() 
                    task.wait(0.5) 
                    VisitedChests[Chest] = true -- Đánh dấu đã lượm
                end
            else
                -- Nếu quét TOÀN MAP không còn rương nào mới Hop Server
                pcall(function()
                    local TPS = game:GetService("TeleportService")
                    local Api = "https://games.roblox.com"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
                    local r = game:GetService("HttpService"):JSONDecode(game:HttpGet(Api))
                    for _, v in pairs(r.data) do
                        if v.playing < v.maxPlayers and v.id ~= game.JobId then
                            TPS:TeleportToPlaceInstance(game.PlaceId, v.id, P)
                            break
                        end
                    end
                end)
                break
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

-- [ GIAO DIỆN ]
Tabs.Main:AddToggle("AutoCyborg", {
    Title = "Auto Kaitun Cyborg (FIX TOÀN MAP)",
    Default = false,
    Callback = function(Value)
        _G.AutoCyborg = Value
        if Value then 
            task.spawn(MainLogic) 
        else 
            if _G.CurrentTween then _G.CurrentTween:Cancel() end
            local Hum = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
            if Hum then Hum.PlatformStand = false end
            for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                if v:IsA("BasePart") then v.CanCollide = true end
            end
        end
    end
})

Window:SelectTab(1)
