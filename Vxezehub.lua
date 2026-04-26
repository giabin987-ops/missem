-- Kiểm tra và tải Fluent UI Library
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- ==========================================
-- LOGIC ESP TỐI ƯU CHO RIVALS
-- ==========================================
local ESP = {
    Enabled = false,
    Objects = {},
    Connections = {},
    Color = Color3.fromRGB(255, 0, 0) -- Mặc định màu đỏ
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

function ESP:CreateHighlight(char)
    if not char then return end
    
    -- Xóa highlight cũ nếu có
    local old = char:FindFirstChild("Vxeze_ESP")
    if old then old:Destroy() end

    local highlight = Instance.new("Highlight")
    highlight.Name = "Vxeze_ESP"
    highlight.Adornee = char
    highlight.FillColor = self.Color
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = char
    
    return highlight
end

function ESP:Add(player)
    if player == LocalPlayer then return end

    local function onCharAdded(char)
        if self.Enabled then
            task.wait(0.5) -- Đợi nhân vật load xong trong Rivals
            self:CreateHighlight(char)
        end
    end

    player.CharacterAdded:Connect(onCharAdded)
    if player.Character then
        onCharAdded(player.Character)
    end
end

function ESP:Enable()
    self.Enabled = true
    for _, player in pairs(Players:GetPlayers()) do
        self:Add(player)
    end

    self.Connections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
        self:Add(player)
    end)
end

function ESP:Disable()
    self.Enabled = false
    if self.Connections.PlayerAdded then
        self.Connections.PlayerAdded:Disconnect()
    end
    
    -- Xóa sạch Highlight khỏi game
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local h = player.Character:FindFirstChild("Vxeze_ESP")
            if h then h:Destroy() end
        end
    end
end

-- ==========================================
-- GIAO DIỆN VXEZE HUB
-- ==========================================
local Window = Fluent:CreateWindow({
    Title = "Vxeze Hub | Rivals",
    SubTitle = "By SenPai",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" })
}

-- Nút bật tắt ESP
local EspToggle = Tabs.Main:AddToggle("EspPlayer", {
    Title = "Enable ESP (Wallhack)", 
    Default = false 
})

EspToggle:OnChanged(function()
    if EspToggle.Value then
        ESP:Enable()
    else
        ESP:Disable()
    end
end)

-- Nút đổi màu ESP
Tabs.Main:AddColorpicker("EspColor", {
    Title = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(Value)
        ESP.Color = Value
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                local h = player.Character:FindFirstChild("Vxeze_ESP")
                if h then h.FillColor = Value end
            end
        end
    end
})

Window:SelectTab(1)

Fluent:Notify({
    Title = "Vxeze Hub",
    Content = "Đã sẵn sàng cho Rivals! Chúc SenPai chơi vui vẻ.",
    Duration = 5
})
