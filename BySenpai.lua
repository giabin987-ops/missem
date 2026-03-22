if not game:IsLoaded() then game.Loaded:Wait() end
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local ScreenGui = loadstring(game:HttpGet("https://raw.githubusercontent.com/giabin987-ops/missem/refs/heads/main/MISS%20HUB"))()

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
    TweenSpeed = 85,
    CurrentTween = nil
}

-- [ TỌA ĐỘ ]
local Pos = {
    Aris = CFrame.new(-6473, 250, -4493),
    Button = CFrame.new(-6475, 250, -4490),
    CyborgNPC = CFrame.new(-6371, 236, -4051),
}

-- [ HÀM QUÉT RƯƠNG MẠNH MẼ - FIX LỖI ĐỨNG YÊN ]
function GetNearestChest()
    local NearestChest = nil
    local MaxDist = math.huge
    
    -- Quét toàn bộ Workspace để tìm rương (vì rương hay nằm trong folder Map)
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if (v.Name:find("Chest") or v.Name:find("Box")) and v:IsA("BasePart") then
            local Dist = (v.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if Dist < MaxDist then
                MaxDist = Dist
                NearestChest = v
            end
        end
    end
    return NearestChest
end

-- [ HÀM DI CHUYỂN MƯỢT ]
function TweenTo(TargetCFrame)
    local Root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not Root then return end
    
    if _G.CurrentTween then _G.CurrentTween:Cancel() end
    
    local Distance = (TargetCFrame.Position - Root.Position).Magnitude
    _G.CurrentTween = game:GetService("TweenService"):Create(Root, TweenInfo.new(Distance/_G.TweenSpeed, Enum.EasingStyle.Linear), {CFrame = TargetCFrame})
    _G.CurrentTween:Play()
    return _G.CurrentTween
end

-- [ HÀM ĐỔI SERVER ]
function HopServer()
    Fluent:Notify({Title = "MISS HUB", Content = "Đang đổi Server...", Duration = 3})
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
        task.wait(1)
        local P = game.Players.LocalPlayer
        local C = P.Character
        if not C or not C:FindFirstChild("HumanoidRootPart") then continue end

        local Fist = C:FindFirstChild("Fist of Darkness") or P.Backpack:FindFirstChild("Fist of Darkness")
        local Core = C:FindFirstChild("Core Brain") or P.Backpack:FindFirstChild("Core Brain")

        -- BƯỚC 11: Có Core Brain
        if Core then
            Fluent:Notify({Title = "XONG!", Content = "Đang đi đổi tộc Cyborg...", Duration = 5})
            local tw = TweenTo(Pos.CyborgNPC)
            if tw then tw.Completed:Wait() end
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CyborgProvider", "Buy")
            _G.AutoCyborg = false break
        end

        -- BƯỚC 0-5: Kiểm tra và lượm rương
        if not Fist then
            local Chest = GetNearestChest()
            if Chest then
                TweenTo(Chest.CFrame)
            else
                HopServer() break
            end
        else
            -- BƯỚC 6-10: Raid Law
            Fluent:Notify({Title = "INFO", Content = "Đã có Fist! Đang đi Raid Law...", Duration = 3})
            local tw1 = TweenTo(Pos.Aris)
            if tw1 then tw1.Completed:Wait() end
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyMicrochip")
            
            task.wait(1)
            local tw2 = TweenTo(Pos.Button)
            if tw2 then tw2.Completed:Wait() end
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
    Title = "Auto Kaitun Cyborg (FIXED)",
    Default = false,
    Callback = function(Value)
        _G.AutoCyborg = Value
        if Value then
            Fluent:Notify({Title = "MISS HUB", Content = "Bắt đầu quét rương...", Duration = 3})
            task.spawn(MainLogic)
        else
            if _G.CurrentTween then _G.CurrentTween:Cancel() end
        end
    end
})

Window:SelectTab(1)
