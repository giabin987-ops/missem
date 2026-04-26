-- Fix lỗi DataModel bằng cách định nghĩa lại Service an toàn
local function GetService(name)
    return game:FindService(name) or game:GetService(name)
end

local Players = GetService("Players")
local RunService = GetService("RunService")
local CoreGui = GetService("CoreGui")

-- Load thư viện Fluent với cơ chế pcall để tránh đứng script
local success, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

if not success then 
    warn("Lỗi tải thư viện Fluent! Hãy kiểm tra kết nối mạng hoặc Executor.")
    return 
end

-- ==========================================
-- HỆ THỐNG ESP (FIX LỖI RIVALS)
-- ==========================================
local ESP = {
    Enabled = false,
    Objects = {},
    Connections = {},
    Color = Color3.fromRGB(255, 0, 0)
}

local LocalPlayer = Players.LocalPlayer

function ESP:Add(player)
    if player == LocalPlayer then return end

    local function setup(char)
        if not self.Enabled then return end
        task.wait(1) -- Đợi nhân vật Rivals load hoàn toàn
        
        -- Xóa highlight cũ để tránh lag
        if char:FindFirstChild("Vxeze_ESP") then char.Vxeze_ESP:Destroy() end

        local highlight = Instance.new("Highlight")
        highlight.Name = "Vxeze_ESP"
        highlight.Adornee = char
        highlight.FillColor = self.Color
        highlight.OutlineColor = Color3.new(1, 1, 1)
        highlight.FillTransparency = 0.5
        highlight.Parent = char
        self.Objects[player] = highlight
    end

    player.CharacterAdded:Connect(setup)
    if player.Character then task.spawn(setup, player.Character) end
end

function ESP:Enable()
    self.Enabled = true
    for _, p in pairs(Players:GetPlayers()) do self:Add(p) end
    self.Connections.PlayerAdded = Players.PlayerAdded:Connect(function(p) self:Add(p) end)
end

function ESP:Disable()
    self.Enabled = false
    if self.Connections.PlayerAdded then self.Connections.PlayerAdded:Disconnect() end
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("Vxeze_ESP") then
            p.Character.Vxeze_ESP:Destroy()
        end
    end
end

-- ==========================================
-- GIAO DIỆN UI (FIX LỖI KHÔNG LÊN UI)
-- ==========================================
local Window = Fluent:CreateWindow({
    Title = "Vxeze Hub",
    SubTitle = "By SenPai",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, -- TẮT CÁI NÀY ĐỂ HIỆN UI TRÊN MOBILE
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" })
}

-- Toggle ESP
local EspToggle = Tabs.Main:AddToggle("EspToggle", {Title = "Enable ESP Player", Default = false })
EspToggle:OnChanged(function()
    if EspToggle.Value then ESP:Enable() else ESP:Disable() end
end)

-- Chọn màu
Tabs.Main:AddColorpicker("EspColor", {
    Title = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(Value)
        ESP.Color = Value
    end
})

Window:SelectTab(1)

Fluent:Notify({
    Title = "Vxeze Hub",
    Content = "bichquamup!",
    Duration = 5
})
