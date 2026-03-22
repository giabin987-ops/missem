local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local ScreenGui = loadstring(game:HttpGet("https://raw.githubusercontent.com/giabin987-ops/missem/refs/heads/main/MISS%20HUB"))()

local Window = Fluent:CreateWindow({
    Title = "MISS HUB - Bloxfruit",
    SubTitle = "by Senpai",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, -- Tắt Acrylic để Delta mượt hơn
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Auto Cyborg", Icon = "cpu" }),
}

local _G = {
    AutoCyborg = false,
    TweenSpeed = 70,
}

-- [ TỌA ĐỘ CHUẨN SEA 2 ]
local Pos = {
    Aris = CFrame.new(-6473, 250, -4493),
    Button = CFrame.new(-6475, 250, -4490),
    CyborgNPC = CFrame.new(-6371, 236, -4051),
    RaidEntrance = CFrame.new(-6385, 447, -4465)
}

-- [ HÀM HOP SERVER CHO DELTA ]
function HopServer()
    local Http = game:GetService("HttpService")
    local TPS = game:GetService("TeleportService")
    local Api = "https://games.roblox.com"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    local success, result = pcall(function() return Http:JSONDecode(game:HttpGet(Api)) end)
    if success then
        for _, v in pairs(result.data) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                TPS:TeleportToPlaceInstance(game.PlaceId, v.id, game.Players.LocalPlayer)
                break
            end
        end
    end
end

-- [ HÀM DI CHUYỂN MƯỢT ]
function TweenTo(TargetCFrame)
    local Character = game.Players.LocalPlayer.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    local Root = Character.HumanoidRootPart
    local Distance = (TargetCFrame.Position - Root.Position).Magnitude
    local Tween = game:GetService("TweenService"):Create(Root, TweenInfo.new(Distance/_G.TweenSpeed, Enum.EasingStyle.Linear), {CFrame = TargetCFrame})
    
    Tween:Play()
    return Tween
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

        -- 11: Nếu có Core Brain -> Đi đổi tộc
        if CoreBrain then
            local tw = TweenTo(Pos.CyborgNPC)
            if tw then tw.Completed:Wait() end
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CyborgProvider", "Buy")
            _G.AutoCyborg = false
            break
        end

        -- 0-5: Lượm rương nếu không có Fist
        if not Fist then
            local TargetChest = nil
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v.Name:find("Chest") then TargetChest = v break end
            end

            if TargetChest then
                local tw = TweenTo(TargetChest.CFrame * CFrame.new(0, 2, 0))
                if tw then tw.Completed:Wait() end
                task.wait(0.2)
            else
                HopServer() -- 0: Không rương thì đổi server
                break
            end
        else
            -- 6-7: Đã có Fist -> Mua Chip Law
            local tw1 = TweenTo(Pos.Aris)
            if tw1 then tw1.Completed:Wait() end
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyMicrochip")
            
            -- 8-10: Đi Start Raid và Đánh Law
            local tw2 = TweenTo(Pos.Button)
            if tw2 then tw2.Completed:Wait() end
            
            -- Tương tác nút (Dùng Remote thay vì click detector cho chắc chắn trên Delta)
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartRaid") 

            local Law = game.Workspace.Enemies:FindFirstChild("Order") or game.Workspace.Enemies:FindFirstChild("Law")
            if Law and Law:FindFirstChild("HumanoidRootPart") then
                -- Bay lên đầu Law và giữ khoảng cách
                TweenTo(Law.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0))
                -- Fast Attack (Delta thường dùng Remote đánh)
                game:GetService("VirtualUser"):CaptureController()
                game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end
        end
        
        -- 12: Kiểm tra sau mỗi vòng nếu không có gì mới thì Hop
        task.wait(1)
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
            -- Dừng bay ngay lập tức
            local Root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if Root then
                for _, v in pairs(game:GetService("TweenService"):GetPlayingTweens()) do
                    v:Cancel()
                end
            end
        end
    end
})

Window:SelectTab(1)
