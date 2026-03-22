local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local ScreenGui = loadstring(game:HttpGet("https://raw.githubusercontent.com/giabin987-ops/missem/refs/heads/main/MISS%20HUB"))()

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
    TweenSpeed = 75,
    CurrentTween = nil -- Biến quản lý tween để fix lỗi GetPlayingTweens
}

local Pos = {
    Aris = CFrame.new(-6473, 250, -4493),
    Button = CFrame.new(-6475, 250, -4490),
    CyborgNPC = CFrame.new(-6371, 236, -4051),
}

-- [ HÀM DI CHUYỂN FIXED ]
function TweenTo(TargetCFrame)
    local Character = game.Players.LocalPlayer.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    local Root = Character.HumanoidRootPart
    
    -- Dừng tween cũ trước khi tạo tween mới (Fix lỗi đứng yên)
    if _G.CurrentTween then _G.CurrentTween:Cancel() end
    
    local Distance = (TargetCFrame.Position - Root.Position).Magnitude
    _G.CurrentTween = game:GetService("TweenService"):Create(Root, TweenInfo.new(Distance/_G.TweenSpeed, Enum.EasingStyle.Linear), {CFrame = TargetCFrame})
    _G.CurrentTween:Play()
    
    return _G.CurrentTween
end

function HopServer()
    local TPS = game:GetService("TeleportService")
    local Api = "https://games.roblox.com"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    local success, result = pcall(function() return game:GetService("HttpService"):JSONDecode(game:HttpGet(Api)) end)
    if success and result.data then
        for _, v in pairs(result.data) do
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
        task.wait(0.5)
        local Player = game.Players.LocalPlayer
        local Character = Player.Character
        if not Character or not Character:FindFirstChild("HumanoidRootPart") then continue end

        local Fist = Character:FindFirstChild("Fist of Darkness") or Player.Backpack:FindFirstChild("Fist of Darkness")
        local CoreBrain = Character:FindFirstChild("Core Brain") or Player.Backpack:FindFirstChild("Core Brain")

        -- Bước 11: Có Core Brain đi đổi tộc
        if CoreBrain then
            local tw = TweenTo(Pos.CyborgNPC)
            if tw then tw.Completed:Wait() end
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CyborgProvider", "Buy")
            _G.AutoCyborg = false
            break
        end

        if not Fist then
            -- Bước 0-5: Quét rương
            local TargetChest = nil
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v.Name:find("Chest") then TargetChest = v break end
            end

            if TargetChest then
                -- Bay mượt lượm rương (Bước 3, 4)
                local tw = TweenTo(TargetChest.CFrame * CFrame.new(0, 2, 0))
                if tw then tw.Completed:Wait() end
                task.wait(0.3)
            else
                HopServer()
                break
            end
        else
            -- Bước 6-10: Có Fist đi mua Chip và đánh Law
            local tw1 = TweenTo(Pos.Aris)
            if tw1 then tw1.Completed:Wait() end
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyMicrochip")
            
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
    Title = "Auto Kaitun Cyborg",
    Default = false,
    Callback = function(Value)
        _G.AutoCyborg = Value
        if Value then
            spawn(MainLogic)
        else
            -- Dừng bay ngay lập tức khi tắt
            if _G.CurrentTween then
                _G.CurrentTween:Cancel()
                _G.CurrentTween = nil
            end
        end
    end
})

Window:SelectTab(1)
