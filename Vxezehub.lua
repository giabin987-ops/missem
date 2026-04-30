local AuzuraLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/catdzs1tg/Auzura.library/refs/heads/main/Soucre.lua"))()

local Window = AuzuraLib:Window({
    Title = "Auzura UI Example",
    Desc = "Complete Feature Demonstration",
    IconTile = "7734053495",
    SizeUi = "520,340",
    Theme = nil -- theme id Roblox
})

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

MainTab:Label({
    Title = "Welcome to Auzura UI Library!",
    Side = "a"
})

MainTab:Paragraph({
    Title = "Getting Started",
    Desc = "This example demonstrates all available UI elements. Use the search bar to find specific elements. Press F2 to toggle UI visibility. On mobile, use two-finger pinch to resize the window.",
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
        if value then
            print("Starting auto farm...")
        else
            print("Stopping auto farm...")
        end
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
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            if value then
                player.Character.Humanoid.WalkSpeed = 32
                print("Speed boost enabled")
            else
                player.Character.Humanoid.WalkSpeed = 16
                print("Speed boost disabled")
            end
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

local InfiniteJumpToggle = MainTab:Toggle({
    Title = "Infinite Jump",
    Desc = "Jump infinitely",
    Side = "b",
    Value = false,
    ShowStatusText = false,
    Callback = function(value)
        print("Infinite Jump:", value)
    end
})

MainTab:Label({
    Title = "Speed Controls",
    Side = "a"
})

local WalkSpeedSlider = MainTab:Slider({
    Title = "Walk Speed",
    Desc = "Adjust movement speed",
    Min = 16,
    Max = 100,
    Rounding = 0,
    Value = 16,
    Side = "a",
    Callback = function(value)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = value
            print("Walk speed set to:", value)
        end
    end
})

local JumpPowerSlider = MainTab:Slider({
    Title = "Jump Power",
    Desc = "Adjust jump height",
    Min = 50,
    Max = 200,
    Rounding = 0,
    Value = 50,
    Side = "b",
    Callback = function(value)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = value
            print("Jump power set to:", value)
        end
    end
})

local GravitySlider = MainTab:Slider({
    Title = "Gravity",
    Desc = "Modify gravity strength",
    Min = 0,
    Max = 196.2,
    Rounding = 1,
    Value = 196.2,
    Side = "b",
    Callback = function(value)
        game.Workspace.Gravity = value
        print("Gravity set to:", value)
    end
})

MainTab:Button({
    Title = "Reset Character",
    Side = "a",
    Callback = function()
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.Health = 0
            print("Character reset")
        end
    end
})

MainTab:Button({
    Title = "Teleport Settings",
    Desc = "Configure teleportation options",
    Icon = "129573215183311",
    Side = "a",
    Callback = function()
        print("Teleport settings opened")
    end
})

MainTab:Button({
    Title = "Save Configuration",
    Desc = "Save current settings",
    Icon = "86682186031062",
    Side = "b",
    Callback = function()
        print("Configuration saved")
    end
})

MainTab:Discord({
    Link = "discord.gg/rGAXFHk86G",
    Side = "b"
})

SettingsTab:Label({
    Title = "General Settings",
    Side = "a"
})

local WeaponDropdown = SettingsTab:Dropdown({
    Title = "Select Weapon",
    Desc = "Choose your primary weapon",
    List = {"Sword", "Bow", "Staff", "Dagger", "Axe"},
    Value = "Sword",
    Multi = false,
    Side = "a",
    Callback = function(selected)
        print("Weapon selected:", selected)
    end
})

local FarmItemsDropdown = SettingsTab:Dropdown({
    Title = "Farm Items",
    Desc = "Select items to auto-farm",
    List = {"Gold", "Gems", "Wood", "Stone", "Iron", "Diamond"},
    Value = {"Gold", "Gems"},
    Multi = true,
    Side = "a",
    Callback = function(selected)
        print("Farming items:", table.concat(selected, ", "))
    end
})

local GameModeDropdown = SettingsTab:Dropdown({
    Title = "Game Mode",
    Desc = "Select game mode",
    List = {"Normal", "Hard", "Expert", "Nightmare"},
    Value = "Normal",
    Multi = false,
    Side = "b",
    Callback = function(selected)
        print("Game mode:", selected)
    end
})

SettingsTab:Textbox({
    Title = "Player Username",
    Desc = "Enter target player name",
    Value = "",
    PlaceHolder = "Username here...",
    ClearOnFocus = true,
    Side = "b",
    Callback = function(text)
        print("Target player:", text)
    end
})

SettingsTab:Textbox({
    Title = "Custom Message",
    Desc = "Message to send",
    Value = "Hello World!",
    PlaceHolder = "Type message...",
    ClearOnFocus = false,
    Side = "b",
    Callback = function(text)
        print("Message:", text)
    end
})

SettingsTab:Label({
    Title = "Keybind Configuration",
    Side = "a"
})

local ToggleUIKey = SettingsTab:Keybind({
    Title = "Toggle UI",
    Desc = "Show/hide interface",
    Key = Enum.KeyCode.Q,
    Value = false,
    Mode = "Toggle",
    Side = "a",
    Callback = function(key, active, mode)
        print("UI Toggle - Key:", key, "Active:", active, "Mode:", mode)
    end
})

local SprintKey = SettingsTab:Keybind({
    Title = "Sprint",
    Desc = "Hold to sprint",
    Key = Enum.KeyCode.LeftShift,
    Value = false,
    Mode = "Hold",
    Side = "a",
    Callback = function(key, active, mode)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            if active then
                player.Character.Humanoid.WalkSpeed = 32
                print("Sprinting")
            else
                player.Character.Humanoid.WalkSpeed = 16
                print("Walking")
            end
        end
    end
})

local FlyKey = SettingsTab:Keybind({
    Title = "Toggle Flight",
    Desc = "Enable/disable flying",
    Key = Enum.KeyCode.F,
    Value = false,
    Mode = "Toggle",
    Side = "b",
    Callback = function(key, active, mode)
        print("Flight - Key:", key, "Active:", active)
        FlyToggle:SetValue(active)
    end
})

SettingsTab:ThumnailsImage({
    Banner = "132687652275989",
    Title = "Script Preview",
    SizeY = 120,
    ShowTitle = true,
    Side = "b"
})

SettingsTab:Paragraph({
    Title = "About Keybinds",
    Desc = "Click on any keybind to change it. Press the desired key to set a new binding. Toggle mode switches between on and off states. Hold mode is active only while the key is held down.",
    Side = "b"
})

UITab:Label({
    Title = "All UI Element Types",
    Side = "a"
})

UITab:Paragraph({
    Title = "Toggle Elements",
    Desc = "Toggles provide on/off switches with optional status text and icons. They support two status text formats: OnOff and TrueFalse.",
    Side = "a"
})

local DemoToggle1 = UITab:Toggle({
    Title = "Basic Toggle",
    Desc = "Simple toggle without icon",
    Side = "a",
    Value = false,
    ShowStatusText = true,
    StatusTextType = "OnOff",
    Callback = function(value)
        print("Basic Toggle:", value)
    end
})

local DemoToggle2 = UITab:Toggle({
    Title = "Icon Toggle",
    Desc = "Toggle with icon",
    Icon = "7734053495",
    Side = "a",
    Value = true,
    ShowStatusText = true,
    StatusTextType = "TrueFalse",
    Callback = function(value)
        print("Icon Toggle:", value)
    end
})

UITab:Paragraph({
    Title = "Button Elements",
    Desc = "Buttons execute functions when clicked. Available in simple and detailed variants with icons and descriptions.",
    Side = "a"
})

UITab:Button({
    Title = "Simple Button",
    Side = "a",
    Callback = function()
        print("Simple button clicked!")
    end
})

UITab:Button({
    Title = "Detailed Button",
    Desc = "With icon and description",
    Icon = "108028847031522",
    Side = "a",
    Callback = function()
        print("Detailed button clicked!")
    end
})

UITab:Paragraph({
    Title = "Slider Elements",
    Desc = "Sliders allow numeric value selection within a defined range with customizable precision.",
    Side = "a"
})

UITab:Slider({
    Title = "Integer Slider",
    Desc = "Whole numbers only",
    Min = 0,
    Max = 100,
    Rounding = 0,
    Value = 50,
    Side = "a",
    Callback = function(value)
        print("Integer value:", value)
    end
})

UITab:Slider({
    Title = "Decimal Slider",
    Desc = "One decimal place",
    Min = 0,
    Max = 10,
    Rounding = 1,
    Value = 5.0,
    Side = "a",
    Callback = function(value)
        print("Decimal value:", value)
    end
})

UITab:Paragraph({
    Title = "Dropdown Elements",
    Desc = "Dropdowns provide selection from lists. Support single or multiple selection modes with dynamic item management.",
    Side = "a"
})

local DemoDropdown1 = UITab:Dropdown({
    Title = "Single Select",
    Desc = "Choose one option",
    List = {"Option A", "Option B", "Option C"},
    Value = "Option A",
    Multi = false,
    Side = "a",
    Callback = function(selected)
        print("Single select:", selected)
    end
})

local DemoDropdown2 = UITab:Dropdown({
    Title = "Multi Select",
    Desc = "Choose multiple options",
    List = {"Item 1", "Item 2", "Item 3", "Item 4"},
    Value = {"Item 1", "Item 2"},
    Multi = true,
    Side = "a",
    Callback = function(selected)
        print("Multi select:", table.concat(selected, ", "))
    end
})

UITab:Paragraph({
    Title = "Textbox Elements",
    Desc = "Textboxes allow text input with customizable placeholder text and clear-on-focus behavior.",
    Side = "a"
})

UITab:Textbox({
    Title = "Text Input",
    Desc = "Enter any text",
    Value = "",
    PlaceHolder = "Type something...",
    ClearOnFocus = true,
    Side = "a",
    Callback = function(text)
        print("Text entered:", text)
    end
})

UITab:Paragraph({
    Title = "Keybind Elements",
    Desc = "Keybinds create customizable keyboard shortcuts with Toggle or Hold modes.",
    Side = "a"
})

UITab:Keybind({
    Title = "Toggle Keybind",
    Desc = "Press to toggle",
    Key = Enum.KeyCode.T,
    Value = false,
    Mode = "Toggle",
    Side = "a",
    Callback = function(key, active, mode)
        print("Toggle keybind - Active:", active)
    end
})

UITab:Keybind({
    Title = "Hold Keybind",
    Desc = "Hold to activate",
    Key = Enum.KeyCode.H,
    Value = false,
    Mode = "Hold",
    Side = "a",
    Callback = function(key, active, mode)
        print("Hold keybind - Active:", active)
    end
})

UITab:Paragraph({
    Title = "Image Elements",
    Desc = "Display images with optional fullscreen viewing. Click any image to view it in fullscreen mode.",
    Side = "a"
})

UITab:ThumnailsImage({
    Banner = "132687652275989",
    Title = "Example Image 1",
    SizeY = 100,
    ShowTitle = true,
    Side = "a"
})

UITab:ThumnailsImage({
    Banner = "72380279434385",
    Title = "Example Image 2",
    SizeY = 100,
    ShowTitle = true,
    Side = "a"
})

UITab:Paragraph({
    Title = "Discord Integration",
    Desc = "Discord buttons provide one-click copying of server invite links with visual feedback.",
    Side = "a"
})

UITab:Discord({
    Link = "discord.gg/rGAXFHk86G",
    Side = "a"
})

UITab:Label({
    Title = "End of Element Showcase",
    Side = "a"
})
