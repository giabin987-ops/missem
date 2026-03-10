local Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
if Parent:FindFirstChild("TitanFishToggle") then Parent.TitanFishToggle:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TitanFishToggle"
ScreenGui.Parent = Parent

local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "FishButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ToggleButton.Position = UDim2.new(0, 20, 1, -160)
ToggleButton.Size = UDim2.new(0, 60, 0, 60)
ToggleButton.Image = "rbxassetid://10723343321" -- Icon con cá
ToggleButton.ImageColor3 = Color3.fromRGB(255, 255, 255)

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = ToggleButton

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 200, 255)
UIStroke.Thickness = 3
UIStroke.Parent = ToggleButton

-- BIẾN KIỂM TRA KÉO HAY BẤM
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos
local dragDistance = 0 -- Khoảng cách đã kéo

local function update(input)
    local delta = input.Position - dragStart
    dragDistance = delta.Magnitude -- Cập nhật độ dài quãng đường kéo
    ToggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ToggleButton.Position
        dragDistance = 0 -- Reset khoảng cách khi mới chạm
    end
end)

ToggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- LOGIC KHI THẢ TAY RA
ToggleButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        
        -- CHỈ MỞ UI NẾU KHOẢNG CÁCH KÉO NHỎ (Tức là đang Bấm chứ không phải Kéo)
        if dragDistance < 10 then 
            -- Hiệu ứng nhấn
            ToggleButton:TweenSize(UDim2.new(0, 50, 0, 50), "Out", "Quad", 0.1, true)
            task.wait(0.1)
            ToggleButton:TweenSize(UDim2.new(0, 60, 0, 60), "Out", "Quad", 0.1, true)
            
            -- Gửi lệnh mở UI Fluent
            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
        end
    end
end)

-- Hiệu ứng RGB cho viền
spawn(function()
    while task.wait(0.1) do
        local hue = tick() % 5 / 5
        UIStroke.Color = Color3.fromHSV(hue, 0.8, 1)
    end
end)
