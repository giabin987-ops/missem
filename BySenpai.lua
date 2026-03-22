if not game:IsLoaded() then game.Loaded:Wait() end
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local ScreenGui = loadstring(game:HttpGet("https://raw.githubusercontent.com/giabin987-ops/missem/refs/heads/main/MISS%"))()

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

-- [ DANH SÁCH RƯƠNG ĐÃ LƯỢM - FIX LỖI QUAY LẠI RƯƠNG CŨ ]
local VisitedChests = {}

local Pos = {
    Aris = CFrame.new(-6473, 250, -4493),
    Button = CFrame.new(-6475, 250, -4490),
    CyborgNPC = CFrame.new(-6371, 236, -4051),
}

-- [ HÀM QUÉT RƯƠNG MỚI - CHỈ QUÉT RƯƠNG CHƯA LƯỢM ]
function GetNewChest()
    local NearestChest = nil
    local MaxDist = math.huge
    
    for _, v in pairs(game.Workspace:GetDescendants()) do
        -- Kiểm tra tên rương và đảm bảo rương này chưa nằm trong danh sách đen
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

function TweenTo(TargetCFrame)
    local Root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not Root then return end
    if _G.CurrentTween then _G.CurrentTween:Cancel() end
    
    local Distance = (TargetCFrame.Position - Root.Position).Magnitude
    _G.CurrentTween = game:GetService("TweenService"):Create(Root, TweenInfo.new(Distance/_G.TweenSpeed, Enum.EasingStyle.Linear), {CFrame = TargetCFrame})
    _G.CurrentTween:Play()
    return _G.CurrentTween
end

function HopServer()
    VisitedChests = {} -- Reset danh sách rương khi sang server mới
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

        -- Bước 11: Core Brain
        if Core then
            local tw = TweenTo(Pos.CyborgNPC)
            if tw then tw.Completed:Wait() end
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CyborgProvider", "Buy")
            _G.AutoCyborg = false break
        end

        -- Bước 2-5: Lượm rương
        if not Fist then
            local Chest = GetNewChest()
            if Chest then
                local tw = TweenTo(Chest.CFrame)
                if tw then 
                    tw.Completed:Wait() 
                    task.wait(0.5) -- Đợi 0.5s để nhận tiền và chắc chắn rương biến mất
                    VisitedChests[Chest] = true -- ĐƯA VÀO DANH SÁCH ĐEN (Quan trọng nhất)
                end
            else
                HopServer() break
            end
        else
            -- Bước 6-10: Raid Law (Giữ nguyên)
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

-- [ UI ]
Tabs.Main:AddToggle("AutoCyborg", {
    Title = "Auto Kaitun Cyborg (FIXED REUSE CHEST)",
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
