-- Kiểm tra và tải Fluent UI Library
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- ==========================================
-- HỆ THỐNG ESP (Tối ưu cho cả PE & PC)
-- ==========================================
local ESP = {
    Enabled = false,
    Objects = {},
    Connections = {}
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

function ESP:Add(player)
    if player == LocalPlayer then return end

    local function setup(char)
        if not self.Enabled then return end
        
        -- Chờ HumanoidRootPart xuất hiện (quan trọng cho Executor Mobile)
        local hrp = char:WaitForChild("HumanoidRootPart", 10)
        if not hrp then return end

        -- Xóa Highlight cũ nếu tồn tại
        if char:FindFirstChild("ESPHighlight") then
            char.ESPHighlight:Destroy()
        end

        -- Tạo Highlight mới
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.Adornee = char
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = char

        self.Objects[player] = highlight
    end

    if player.Character then task.spawn(setup, player.Character) end
    local conn = player.CharacterAdded:Connect(setup)
    table.insert(self.Connections, conn)
end

function ESP:Enable()
    self.Enabled = true
    for _, player in pairs(Players:GetPlayers()) do
        self:Add(player)
    end
    local joinConn = Players.PlayerAdded:Connect(function(player)
        self:Add(player)
    end)
    table.insert(self.Connections, joinConn)
end

function ESP:Disable()
    self.Enabled = false
    for _, obj in pairs(self.Objects) do if obj then obj:Destroy() end end
    self.Objects = {}
    for _, conn in pairs(self.Connections) do conn:Disconnect() end
    self.Connections = {}
    
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("ESPHighlight") then
            p.Character.ESPHighlight:Destroy()
        end
    end
end

-- ==========================================
-- CẤU HÌNH GIAO DIỆN Vxeze Hub
-- ==========================================
local Window = Fluent:CreateWindow({
    Title = "Vxeze Hub",
    SubTitle = "By SenPai",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, -- Tắt Acrylic để mượt hơn trên máy yếu/Mobile
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" })
}

-- Chức năng bật/tắt ESP
local EspToggle = Tabs.Main:AddToggle("EspPlayer", {
    Title = "Enable ESP Player", 
    Default = false 
})

EspToggle:OnChanged(function()
    if EspToggle.Value then
        ESP:Enable()
    else
        ESP:Disable()
    end
end)

-- Nút chỉnh màu ESP (Tiện ích thêm)
Tabs.Main:AddColorpicker("EspColor", {
    Title = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(Value)
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("ESPHighlight") then
                player.Character.ESPHighlight:FillColor = Value
            end
        end
    end
})

Window:SelectTab(1)

Fluent:Notify({
    Title = "Vxeze Hub",
    Content = "Tương thích tốt trên Mobile & PC!",
    Duration = 5
})
