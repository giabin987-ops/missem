-- [[ LOAD GAME ]]
repeat task.wait() until game:IsLoaded()
local player = game.Players.LocalPlayer

-- [[ AUTO TEAM ]]
task.spawn(function()
    if not player.Team then
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", getgenv().Team)
        end)
    end
end)

-- [[ LOAD MISS HUB ]]
task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/giabin987-ops/missem/refs/heads/main/MISS%20HUB"))()
    end)
end)

task.wait(4)

-- [[ LOAD FLUENT ]]
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "MISS HUB - Bloxfruit 2026",
    SubTitle = "Team: " .. tostring(getgenv().Team),
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Auto Cyborg", Icon = "cpu" })
}

-- [[ CONFIG ]]
_G = {
    AutoCyborg = false,
    TweenSpeed = 300,
    CurrentTween = nil
}

local VisitedChests = {}

-- [[ NOTIFY XỊN ]]
local CurrentNotify
function NotifyCenter(text)
    if CurrentNotify then CurrentNotify:Destroy() end

    local gui = Instance.new("ScreenGui", game.CoreGui)
    gui.IgnoreGuiInset = true
    CurrentNotify = gui

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 420, 0, 70)
    frame.Position = UDim2.new(0.5, -210, 0.5, -35)
    frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    frame.BackgroundTransparency = 0.2

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(255,60,60)
    stroke.Thickness = 2

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1,-20,1,-20)
    label.Position = UDim2.new(0,10,0,10)
    label.BackgroundTransparency = 1
    label.Text = "⚠️ "..text
    label.TextColor3 = Color3.fromRGB(255,80,80)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.TextTransparency = 1

    local TweenService = game:GetService("TweenService")

    TweenService:Create(label, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

    task.spawn(function()
        task.wait(2.5)
        TweenService:Create(label, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        task.wait(0.4)
        gui:Destroy()
    end)
end

-- [[ TWEEN ]]
function TweenTo(cf)
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if _G.CurrentTween then _G.CurrentTween:Cancel() end

    local dist = (cf.Position - root.Position).Magnitude
    if dist < 300 then
        root.CFrame = cf
        return
    end

    local tween = game:GetService("TweenService"):Create(
        root,
        TweenInfo.new(dist/_G.TweenSpeed, Enum.EasingStyle.Linear),
        {CFrame = cf}
    )

    _G.CurrentTween = tween
    tween:Play()

    return tween
end

-- [[ FIND CHEST ]]
function GetRealChest()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local target, distMin = nil, math.huge

    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart")
        and string.find(v.Name, "Chest")
        and v:FindFirstChild("TouchInterest")
        and not VisitedChests[v] then

            local dist = (v.Position - root.Position).Magnitude
            if dist < distMin then
                distMin = dist
                target = v
            end
        end
    end

    return target
end

-- [[ MAIN ]]
function MainLogic()
    repeat task.wait() until player.Character and player.Character:FindFirstChild("HumanoidRootPart")

    while _G.AutoCyborg do
        task.wait(0.1)

        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then continue end

        local Fist = char:FindFirstChild("Fist of Darkness")
            or player.Backpack:FindFirstChild("Fist of Darkness")

        -- 🔥 RAID FIX
        if Fist then
            local Remote = game:GetService("ReplicatedStorage").Remotes.CommF_

            TweenTo(CFrame.new(-6473,250,-4493))
            task.wait(0.5)

            local bought = false
            for i=1,5 do
                local result
                pcall(function()
                    result = Remote:InvokeServer("BuyMicrochip")
                end)

                if player.Backpack:FindFirstChild("Microchip") then
                    bought = true
                    break
                end

                if type(result)=="string" then
                    if result:find("Beli") then
                        NotifyCenter("MISS HUB: Bạn không đủ Beli")
                    elseif result:lower():find("fragment") then
                        NotifyCenter("MISS HUB: Bạn không đủ Fragment")
                    end
                end

                task.wait(0.5)
            end

            if not bought then
                NotifyCenter("MISS HUB: Không mua được chip!")
                return
            end

            TweenTo(CFrame.new(-6475,250,-4490))
            task.wait(0.5)

            for i=1,5 do
                pcall(function()
                    Remote:InvokeServer("StartRaid")
                end)
                task.wait(1)
            end

            break
        end

        -- 💰 FARM CHEST
        local chest = GetRealChest()
        if chest then
            local tw = TweenTo(chest.CFrame + Vector3.new(0,3,0))
            if tw then tw.Completed:Wait() end

            for i=1,3 do
                firetouchinterest(root, chest, 0)
                firetouchinterest(root, chest, 1)
                task.wait(0.1)
            end

            VisitedChests[chest] = true
        end
    end
end

-- [[ UI ]]
Tabs.Main:AddToggle("AutoCyborg", {
    Title = "Auto Cyborg (Fix Full + Notify)",
    Default = false,
    Callback = function(v)
        _G.AutoCyborg = v
        if v then
            task.spawn(MainLogic)
        end
    end
})

Window:SelectTab(1)
