--Fix 01
local AuzuraLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/catdzs1tg/Auzura.library/refs/heads/main/Soucre.lua"))()

local Window = AuzuraLib:Window({
    Title = "Auzura UI Example",
    Desc = "Complete Feature Demonstration",
    IconTile = "7734053495",
    SizeUi = "520,340",
    Theme = nil -- Bạn có thể điền ID theme Roblox vào đây
})

-- TABS
local MainTab = Window:Add({
    Title = "Main Features",
    Desc = "Core functionality showcase",
    Banner = "132687652275989",
    Icon = "7734053495",
    Columns = 2
})

local SettingsTab = Window:Add({
    Title = "Settings",
    Desc = "Configuration options",
    Banner = "72380279434385",
    Icon = "10723407389",
    Columns = 2
})

local UITab = Window:Add({
    Title = "UI Elements",
    Desc = "All element types",
    Banner = "87782680483863",
    Icon = "18557078698",
    Columns = 1
})

-- MAIN TAB ELEMENTS
MainTab:Label({
    Title = "Welcome to Auzura UI Library!",
    Side = "a"
})

MainTab:Paragraph({
    Title = "Getting Started",
    Desc = "Dùng F2 để ẩn/hiện menu. Trên Mobile dùng 2 ngón tay để thu phóng.",
    Side = "a"
})

local AutoFarmToggle = MainTab:Toggle({
    Title = "Auto Farm",
    Desc = "Automatically collect resources",
    Icon = "7734053495",
    Side = "a",
    Value = false,
    ShowStatusText = true,
    StatusTextType = "OnOff",
    Callback = function(value)
        print("Auto Farm:", value)
    end
})

local WalkSpeedToggle = MainTab:Toggle({
    Title = "Speed Boost",
    Desc = "Increase movement speed",
    Side = "a",
    Value = false,
    ShowStatusText = true,
    StatusTextType = "TrueFalse",
    Callback = function(value)
        local lp = game.Players.LocalPlayer
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.WalkSpeed = value and 32 or 16
        end
    end
})

local FlyToggle = MainTab:Toggle({
    Title = "Flight Mode",
    Desc = "Enable flying",
    Icon = "108028847031522",
    Side = "b",
    Value = false,
    ShowStatusText = true,
    StatusTextType = "OnOff",
    Callback = function(value)
        print("Flight Mode:", value)
    end
})

MainTab:Label({
    Title = "Speed Controls",
    Side = "a"
})

local WalkSpeedSlider = MainTab:Slider({
    Title = "Walk Speed",
    Min = 16,
    Max = 100,
    Rounding = 0,
    Value = 16,
    Side = "a",
    Callback = function(value)
        if game.Players.LocalPlayer.Character then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end
})

MainTab:Button({
    Title = "Reset Character",
    Side = "a",
    Callback = function()
        game.Players.LocalPlayer.Character:BreakJoints()
    end
})

MainTab:Discord({
    Link = "discord.gg/rGAXFHk86G",
    Side = "b"
})

-- SETTINGS TAB ELEMENTS
local WeaponDropdown = SettingsTab:Dropdown({
    Title = "Select Weapon",
    List = {"Sword", "Bow", "Staff", "Dagger", "Axe"},
    Value = "Sword",
    Multi = false,
    Side = "a",
    Callback = function(selected)
        print("Weapon:", selected)
    end
})

SettingsTab:Textbox({
    Title = "Player Username",
    PlaceHolder = "Username here...",
    ClearOnFocus = true,
    Side = "b",
    Callback = function(text)
        print("Target:", text)
    end
})

local ToggleUIKey = SettingsTab:Keybind({
    Title = "Toggle UI",
    Key = Enum.KeyCode.Q,
    Value = false,
    Mode = "Toggle",
    Side = "a",
    Callback = function(key, active)
        print("UI Key:", key, "Active:", active)
    end
})

-- ĐOẠN SỬA LỖI: Hoàn thiện ThumnailsImage và đóng script
SettingsTab:ThumnailsImage({
    Banner = "132687652275989",
    Title = "Script Preview",
    SizeY = 120,
    ShowTitle = true,
    Side = "b"
})

-- UI TAB ELEMENTS (Bổ sung thêm ví dụ)
UITab:Label({ Title = "Additional Components" })
UITab:Button({
    Title = "Gửi thông báo Test",
    Callback = function()
        AuzuraLib:Notification({
            Title = "Thành công!",
            Desc = "Menu đã sẵn sàng sử dụng.",
            Time = 5
        })
    end
})

print("Auzura UI Library Loaded Successfully!")
