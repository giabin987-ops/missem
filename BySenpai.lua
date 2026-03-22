-- [ 1. LOAD SCREEN GUI / MISS HUB CỦA BẠN ]
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/giabin987-ops/missem/refs/heads/main/MISS%20HUB"))()
end)

-- [ 2. KHỞI TẠO THƯ VIỆN FLUENT ]
repeat task.wait() until game:IsLoaded()
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "MISS HUB - Bloxfruit",
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

-- [ 3. HỆ THỐNG LỌC RƯƠNG (BLACKLIST) - FIX LỖI QUAY LẠI RƯƠNG CŨ ]
local VisitedChests = {}

local Pos = {
    Aris = CFrame.new(-6473, 250, -4493),
    Button = CFrame.new(-6475, 250, -4490),
    CyborgNPC = CFrame.new(-6371, 236, -4051),
}

function GetNewChest()
    local NearestChest = nil
    local MaxDist = math.huge
    for _, v in pairs(game.Workspace:GetDescendants()) do
        -- Kiểm tra rương và đảm bảo rương này chưa được lượm (không có trong VisitedChests)
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
    _G.CurrentTween = game:GetService("TweenService"):Create(Root, TweenInfo.new((TargetCFrame.Position - Root.Position).Magnitude/_G.TweenSpeed, Enum.EasingStyle.Linear), {CFrame = TargetCFrame})
    _G.CurrentTween:Play()
    return _G.CurrentTween
end

function HopServer()
    VisitedChests = {} -- Reset danh sách khi sang server mới
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

-- [ 4. VÒNG LẶP CHÍNH AUTO CYBORG ]
function MainLogic()
    while _G.AutoCyborg do
        task.wait(0.1)
        local P = game.Players.LocalPlayer
        local C = P.Character
        if not C or not C:FindFirstChild("HumanoidRootPart") then continue end

        local Fist = C:FindFirstChild("Fist of Darkness") or P.Backpack:FindFirstChild("Fist of Darkness")
        local Core = C:FindFirstChild("Core Brain") or P.Backpack:FindFirstChild("Core Brain")

        -- Bước 11: Đã có Core Brain -> Đi mua tộc
        if Core then
            local tw = TweenTo(Pos.CyborgNPC)
            if tw then tw.Completed:Wait() end
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CyborgProvider", "Buy")
            _G.AutoCyborg = false break
        end

        if not Fist then
            -- Bước 1-5: Lượm rương mới (Không quay lại rương cũ)
            local Chest = GetNewChest()
            if Chest then
                local tw = TweenTo(Chest.CFrame)
                if tw then 
                    tw.Completed:Wait() 
                    task.wait(0.5) -- Đợi server nhận tiền
                    VisitedChests[Chest] = true -- GHI CHÚ ĐÃ LƯỢM (Quan trọng)
                end
            else
                -- Bước 0: Hết rương thì đổi Server
                HopServer() break
            end
        else
            -- Bước 6-10: Raid Law
            local tw1 = TweenTo(Pos.Aris)
            if tw1 then tw1.Completed:Wait() end
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyMicrochip")
            
            task.wait(0.5)
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

-- [ 5. GIAO DIỆN ]
Tabs.Main:AddToggle("AutoCyborg", {
    Title = "Auto Kaitun Cyborg",
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
