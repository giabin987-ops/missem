-- [ 1. LOAD MISS HUB / SCREEN GUI ]
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
    TweenSpeed = 150, 
    CurrentTween = nil
}

local VisitedChests = {}
local Pos = {
    Aris = CFrame.new(-6473, 250, -4493),
    Button = CFrame.new(-6475, 250, -4490),
    CyborgNPC = CFrame.new(-6371, 236, -4051),
}

-- [ HÀM CHUYỂN SERVER (FIX LỖI KHÔNG HOP) ]
function HopServer()
    Fluent:Notify({Title = "MISS HUB", Content = "Đã hết rương! Đang tìm server mới...", Duration = 5})
    task.wait(1)
    
    local Http = game:GetService("HttpService")
    local TPS = game:GetService("TeleportService")
    local Api = "https://games.roblox.com"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    
    local function GetServer()
        local success, result = pcall(function()
            return Http:JSONDecode(game:HttpGet(Api))
        end)
        if success and result.data then
            for _, v in pairs(result.data) do
                if v.playing < v.maxPlayers and v.id ~= game.JobId then
                    return v.id
                end
            end
        end
        return nil
    end

    local ServerId = GetServer()
    if ServerId then
        TPS:TeleportToPlaceInstance(game.PlaceId, ServerId, game.Players.LocalPlayer)
    else
        Fluent:Notify({Title = "LỖI", Content = "Không tìm thấy server, đang thử lại...", Duration = 3})
        task.wait(2)
        HopServer() -- Thử lại nếu không tìm thấy
    end
end

-- [ HÀM DI CHUYỂN SIÊU MƯỢT ]
function TweenTo(TargetCFrame)
    local Root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local Hum = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
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
            for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
            task.wait()
        end
        if Hum then Hum.PlatformStand = false end
    end)
    return _G.CurrentTween
end

-- [ QUÉT RƯƠNG CHUẨN 2026 ]
function GetRealChest()
    local Target = nil
    local MaxDist = math.huge
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if (v.Name == "Chest1" or v.Name == "Chest2" or v.Name == "Chest3") and v:IsA("BasePart") and not VisitedChests[v] then
            -- Chỉ lấy rương chưa lượm (Transparency < 1)
            if v.Transparency < 0.5 and v:FindFirstChild("TouchInterest") then 
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
            local Chest = GetRealChest()
            if Chest then
                local tw = TweenTo(Chest.CFrame * CFrame.new(0, 1, 0))
                if tw then 
                    tw.Completed:Wait() 
                    VisitedChests[Chest] = true
                    task.wait(0.2) 
                end
            else
                -- NẾU KHÔNG CÒN RƯƠNG NÀO -> THỰC HIỆN HOP SERVER
                HopServer()
                break -- Thoát vòng lặp để đợi chuyển server
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

-- [ UI ]
Tabs.Main:AddToggle("AutoCyborg", {
    Title = "Auto Kaitun Cyborg (FIX HOP SERVER)",
    Default = false,
    Callback = function(Value)
        _G.AutoCyborg = Value
        if Value then 
            task.spawn(MainLogic) 
        else 
            if _G.CurrentTween then _G.CurrentTween:Cancel() end
            local Root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if Root and Root:FindFirstChild("CyborgBV") then Root.CyborgBV:Destroy() end
            local Hum = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
            if Hum then Hum.PlatformStand = false end
        end
    end
})

Window:SelectTab(1)
