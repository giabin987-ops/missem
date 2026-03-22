-- [ 1. LOAD MISS bHUB ]
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
    TweenSpeed = 80, -- Tốc độ chuẩn mượt 2026
    CurrentTween = nil
}

local VisitedChests = {}
local Pos = {
    Aris = CFrame.new(-6473, 250, -4493),
    Button = CFrame.new(-6475, 250, -4490),
    CyborgNPC = CFrame.new(-6371, 236, -4051),
}

-- [ HÀM DI CHUYỂN SIÊU MƯỢT - KHÔNG GIẬT ]
function TweenTo(TargetCFrame)
    local Character = game.Players.LocalPlayer.Character
    local Root = Character:FindFirstChild("HumanoidRootPart")
    local Hum = Character:FindFirstChild("Humanoid")
    
    if not Root or not Hum then return end
    
    -- Dừng Tween cũ
    if _G.CurrentTween then _G.CurrentTween:Cancel() end

    -- FIX GIẬT: Khóa vật lý & Trọng lực
    Root.Velocity = Vector3.new(0, 0, 0)
    Hum.PlatformStand = true -- Tắt animation rơi để không bị giật lên xuống

    local Distance = (TargetCFrame.Position - Root.Position).Magnitude
    local TweenTime = Distance / _G.TweenSpeed
    
    _G.CurrentTween = game:GetService("TweenService"):Create(Root, TweenInfo.new(TweenTime, Enum.EasingStyle.Linear), {CFrame = TargetCFrame})
    _G.CurrentTween:Play()

    -- Trả lại trạng thái sau khi hoàn thành
    _G.CurrentTween.Completed:Connect(function()
        if Hum then Hum.PlatformStand = false end
        if Root then Root.Velocity = Vector3.new(0, 0, 0) end
    end)

    return _G.CurrentTween
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
            -- Khóa rơi khi đang bay (Double Check)
            game.Players.LocalPlayer.Character.Humanoid.PlatformStand = true
        end
    end
end)

-- [ QUÉT RƯƠNG MỚI (BLACKLIST) ]
function GetNewChest()
    local Nearest = nil
    local MaxDist = math.huge
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if (v.Name:find("Chest") or v.Name:find("Box")) and v:IsA("BasePart") and not VisitedChests[v] then
            local Dist = (v.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if Dist < MaxDist then
                MaxDist = Dist
                Nearest = v
            end
        end
    end
    return Nearest
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

        -- 11: Core Brain
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
                    VisitedChests[Chest] = true -- Không quay lại rương cũ
                end
            else
                -- Hop Server (Hàm Hop đã có ở các bản trước, bạn giữ nguyên logic hoặc dùng bản này)
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
            -- Lộ trình Raid Law
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
    Title = "Auto Kaitun Cyborg (FIX GIẬT)",
    Default = false,
    Callback = function(Value)
        _G.AutoCyborg = Value
        if Value then 
            task.spawn(MainLogic) 
        else 
            if _G.CurrentTween then _G.CurrentTween:Cancel() end
            local Hum = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
            if Hum then Hum.PlatformStand = false end
        end
    end
})

Window:SelectTab(1)
