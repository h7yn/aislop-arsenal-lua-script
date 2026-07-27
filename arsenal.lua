-- STARR.WTF | Custom UI Framework (Arsenal - Full Aimbot + ESP + Fly)
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game.Players
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StarrHub"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false

-- Main Window
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 550, 0, 420)
Main.Position = UDim2.new(0.5, -275, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = ScreenGui

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TopBar.BorderSizePixel = 0
TopBar.Parent = Main

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "STARR.WTF | ARSENAL"
Title.TextColor3 = Color3.fromRGB(0, 255, 200)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "Close"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BorderSizePixel = 0
CloseButton.Parent = TopBar

-- Tab Bar
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(1, 0, 0, 35)
TabBar.Position = UDim2.new(0, 0, 0, 40)
TabBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TabBar.BorderSizePixel = 0
TabBar.Parent = Main

-- Content Area
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, 0, 1, -75)
Content.Position = UDim2.new(0, 0, 0, 75)
Content.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Content.BorderSizePixel = 0
Content.Parent = Main

-- =============================================
-- DRAG FUNCTIONALITY
-- =============================================
local dragging = false
local dragStart = nil
local startPos = nil

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Close Button
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- =============================================
-- TAB CREATION
-- =============================================
local tabs = {}
local currentTab = nil

function CreateTab(name, icon)
    local tab = Instance.new("TextButton")
    tab.Name = name
    tab.Size = UDim2.new(0, 120, 1, 0)
    tab.Position = UDim2.new(0, #tabs * 122, 0, 0)
    tab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    tab.Text = name
    tab.TextColor3 = Color3.fromRGB(200, 200, 200)
    tab.TextSize = 13
    tab.Font = Enum.Font.Gotham
    tab.BorderSizePixel = 0
    tab.Parent = TabBar
    
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = name .. "_Content"
    tabContent.Size = UDim2.new(1, -20, 1, -20)
    tabContent.Position = UDim2.new(0, 10, 0, 10)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.ScrollBarThickness = 4
    tabContent.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 200)
    tabContent.Visible = false
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContent.ScrollingEnabled = true
    tabContent.VerticalScrollBarInset = Enum.ScrollBarInset.Always
    tabContent.Parent = Content
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.Parent = tabContent
    
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContent.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
    end)
    
    local tabData = {
        Button = tab,
        Content = tabContent,
        Layout = UIListLayout,
        Sections = {}
    }
    
    tab.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.Content.Visible = false
            t.Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            t.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        tabContent.Visible = true
        tab.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
        tab.TextColor3 = Color3.fromRGB(20, 20, 20)
        currentTab = tabData
    end)
    
    table.insert(tabs, tabData)
    
    if #tabs == 1 then
        tabContent.Visible = true
        tab.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
        tab.TextColor3 = Color3.fromRGB(20, 20, 20)
        currentTab = tabData
    end
    
    return tabData
end

-- =============================================
-- SECTION CREATION
-- =============================================
function CreateSection(tab, title)
    local section = Instance.new("Frame")
    section.Name = title
    section.Size = UDim2.new(1, 0, 0, 26)
    section.BackgroundTransparency = 1
    section.BorderSizePixel = 0
    section.Parent = tab.Content
    
    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Size = UDim2.new(1, 0, 0, 18)
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Text = title
    sectionLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
    sectionLabel.TextSize = 12
    sectionLabel.Font = Enum.Font.GothamBold
    sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    sectionLabel.Parent = section
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0, 20)
    line.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
    line.BorderSizePixel = 0
    line.Parent = section
    
    table.insert(tab.Sections, section)
    return section
end

-- =============================================
-- TOGGLE CREATION
-- =============================================
function CreateToggle(tab, name, default, callback)
    local toggle = Instance.new("Frame")
    toggle.Name = name
    toggle.Size = UDim2.new(1, 0, 0, 28)
    toggle.BackgroundTransparency = 1
    toggle.BorderSizePixel = 0
    toggle.Parent = tab.Content
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = name
    toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleLabel.TextSize = 13
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggle
    
    local toggleBox = Instance.new("Frame")
    toggleBox.Size = UDim2.new(0, 40, 0, 20)
    toggleBox.Position = UDim2.new(1, -40, 0.5, -10)
    toggleBox.BackgroundColor3 = default and Color3.fromRGB(0, 255, 200) or Color3.fromRGB(60, 60, 60)
    toggleBox.BorderSizePixel = 0
    toggleBox.Parent = toggle
    
    local toggleDot = Instance.new("Frame")
    toggleDot.Size = UDim2.new(0, 16, 0, 16)
    toggleDot.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    toggleDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleDot.BorderSizePixel = 0
    toggleDot.Parent = toggleBox
    
    local state = default
    
    local function updateToggle()
        TweenService:Create(toggleBox, TweenInfo.new(0.2), {
            BackgroundColor3 = state and Color3.fromRGB(0, 255, 200) or Color3.fromRGB(60, 60, 60)
        }):Play()
        TweenService:Create(toggleDot, TweenInfo.new(0.2), {
            Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        }):Play()
        callback(state)
    end
    
    toggleBox.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            state = not state
            updateToggle()
        end
    end)
    
    return toggle
end

-- =============================================
-- KEYBIND CREATION
-- =============================================
function CreateKeybind(tab, name, default, callback)
    local keybind = Instance.new("Frame")
    keybind.Name = name
    keybind.Size = UDim2.new(1, 0, 0, 28)
    keybind.BackgroundTransparency = 1
    keybind.BorderSizePixel = 0
    keybind.Parent = tab.Content
    
    local kbLabel = Instance.new("TextLabel")
    kbLabel.Size = UDim2.new(0.5, 0, 1, 0)
    kbLabel.BackgroundTransparency = 1
    kbLabel.Text = name
    kbLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    kbLabel.TextSize = 13
    kbLabel.Font = Enum.Font.Gotham
    kbLabel.TextXAlignment = Enum.TextXAlignment.Left
    kbLabel.Parent = keybind
    
    local kbButton = Instance.new("TextButton")
    kbButton.Size = UDim2.new(0, 60, 0, 22)
    kbButton.Position = UDim2.new(1, -60, 0.5, -11)
    kbButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    kbButton.Text = default or "[NONE]"
    kbButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    kbButton.TextSize = 11
    kbButton.Font = Enum.Font.Gotham
    kbButton.BorderSizePixel = 0
    kbButton.Parent = keybind
    
    local listening = false
    local currentKey = default
    
    kbButton.MouseButton1Click:Connect(function()
        listening = true
        kbButton.Text = "[PRESS KEY]"
        kbButton.TextColor3 = Color3.fromRGB(0, 255, 200)
    end)
    
    local connection
    connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if listening then
            if input.KeyCode == Enum.KeyCode.Backspace then
                currentKey = nil
                kbButton.Text = "[NONE]"
            elseif input.KeyCode == Enum.KeyCode.Escape then
                -- Cancel
            else
                currentKey = input.KeyCode.Name
                kbButton.Text = "[" .. input.KeyCode.Name .. "]"
            end
            kbButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            listening = false
            callback(currentKey)
        end
    end)
    
    return keybind
end

-- =============================================
-- SLIDER CREATION
-- =============================================
function CreateSlider(tab, name, min, max, default, callback)
    local slider = Instance.new("Frame")
    slider.Name = name
    slider.Size = UDim2.new(1, 0, 0, 45)
    slider.BackgroundTransparency = 1
    slider.BorderSizePixel = 0
    slider.Parent = tab.Content
    
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Size = UDim2.new(1, 0, 0, 18)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Text = name .. ": " .. default
    sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    sliderLabel.TextSize = 12
    sliderLabel.Font = Enum.Font.Gotham
    sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    sliderLabel.Parent = slider
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, 0, 0, 6)
    sliderBg.Position = UDim2.new(0, 0, 0, 22)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = slider
    
    local percent = (default - min) / (max - min)
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(percent, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    
    local value = default
    local isDragging = false
    
    local function updateSlider(input)
        local mousePos = UserInputService:GetMouseLocation()
        local sliderPos = sliderBg.AbsolutePosition
        local sliderWidth = sliderBg.AbsoluteSize.X
        local relativeX = math.clamp(mousePos.X - sliderPos.X, 0, sliderWidth)
        local newPercent = relativeX / sliderWidth
        value = math.floor(min + (max - min) * newPercent)
        sliderFill.Size = UDim2.new(newPercent, 0, 1, 0)
        sliderLabel.Text = name .. ": " .. value
        callback(value)
    end
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            updateSlider()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    return slider
end

-- =============================================
-- DROPDOWN CREATION
-- =============================================
function CreateDropdown(tab, name, options, default, callback)
    local dropdown = Instance.new("Frame")
    dropdown.Name = name
    dropdown.Size = UDim2.new(1, 0, 0, 55)
    dropdown.BackgroundTransparency = 1
    dropdown.BorderSizePixel = 0
    dropdown.Parent = tab.Content
    
    local ddLabel = Instance.new("TextLabel")
    ddLabel.Size = UDim2.new(1, 0, 0, 16)
    ddLabel.BackgroundTransparency = 1
    ddLabel.Text = name
    ddLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ddLabel.TextSize = 12
    ddLabel.Font = Enum.Font.Gotham
    ddLabel.TextXAlignment = Enum.TextXAlignment.Left
    ddLabel.Parent = dropdown
    
    local ddButton = Instance.new("TextButton")
    ddButton.Size = UDim2.new(1, 0, 0, 26)
    ddButton.Position = UDim2.new(0, 0, 0, 18)
    ddButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ddButton.Text = "  " .. default
    ddButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ddButton.TextSize = 12
    ddButton.Font = Enum.Font.Gotham
    ddButton.TextXAlignment = Enum.TextXAlignment.Left
    ddButton.BorderSizePixel = 0
    ddButton.Parent = dropdown
    
    local ddList = Instance.new("Frame")
    ddList.Size = UDim2.new(1, 0, 0, 0)
    ddList.Position = UDim2.new(0, 0, 0, 44)
    ddList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ddList.BorderSizePixel = 0
    ddList.Visible = false
    ddList.ZIndex = 10
    ddList.Parent = dropdown
    
    local selected = default
    local open = false
    local optionButtons = {}
    
    for i, option in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 24)
        optBtn.Position = UDim2.new(0, 0, 0, (i-1) * 24)
        optBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        optBtn.Text = "  " .. option
        optBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        optBtn.TextSize = 12
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextXAlignment = Enum.TextXAlignment.Left
        optBtn.BorderSizePixel = 0
        optBtn.ZIndex = 10
        optBtn.Parent = ddList
        
        optBtn.MouseButton1Click:Connect(function()
            selected = option
            ddButton.Text = "  " .. option
            ddList.Visible = false
            open = false
            callback(option)
        end)
        
        table.insert(optionButtons, optBtn)
    end
    
    ddList.Size = UDim2.new(1, 0, 0, #options * 24)
    
    ddButton.MouseButton1Click:Connect(function()
        open = not open
        ddList.Visible = open
        dropdown.Parent = tab.Content
    end)
    
    return dropdown
end

-- =============================================
-- COLOR PICKER
-- =============================================
function CreateColorPicker(tab, name, defaultColor, callback)
    local picker = Instance.new("Frame")
    picker.Name = name
    picker.Size = UDim2.new(1, 0, 0, 55)
    picker.BackgroundTransparency = 1
    picker.BorderSizePixel = 0
    picker.Parent = tab.Content
    
    local pickerLabel = Instance.new("TextLabel")
    pickerLabel.Size = UDim2.new(1, 0, 0, 16)
    pickerLabel.BackgroundTransparency = 1
    pickerLabel.Text = name
    pickerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    pickerLabel.TextSize = 12
    pickerLabel.Font = Enum.Font.Gotham
    pickerLabel.TextXAlignment = Enum.TextXAlignment.Left
    pickerLabel.Parent = picker
    
    local colorPreview = Instance.new("Frame")
    colorPreview.Size = UDim2.new(0, 26, 0, 26)
    colorPreview.Position = UDim2.new(0, 0, 0, 18)
    colorPreview.BackgroundColor3 = defaultColor
    colorPreview.BorderSizePixel = 0
    colorPreview.Parent = picker
    
    local presets = {
        Color3.fromRGB(0, 255, 200),
        Color3.fromRGB(255, 50, 50),
        Color3.fromRGB(50, 255, 50),
        Color3.fromRGB(50, 50, 255),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(255, 0, 255),
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(255, 150, 0),
    }
    
    for i, col in ipairs(presets) do
        local preset = Instance.new("TextButton")
        preset.Size = UDim2.new(0, 20, 0, 20)
        preset.Position = UDim2.new(0, 35 + (i-1)*24, 0, 21)
        preset.BackgroundColor3 = col
        preset.BorderSizePixel = 0
        preset.Text = ""
        preset.Parent = picker
        
        preset.MouseButton1Click:Connect(function()
            colorPreview.BackgroundColor3 = col
            callback(col)
        end)
    end
    
    return picker
end

-- =============================================
-- DRAWING OBJECTS
-- =============================================
local fovColor = Color3.fromRGB(0, 255, 200)
local skeletonColor = Color3.fromRGB(255, 255, 255)

local fovCircle = Drawing.new("Circle")
fovCircle.Color = fovColor
fovCircle.Thickness = 1
fovCircle.NumSides = 64
fovCircle.Radius = 100
fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
fovCircle.Visible = false

-- =============================================
-- ESP STATE
-- =============================================
local espBoxEnabled = false
local espSkeletonEnabled = false
local espHealthBarEnabled = false
local espTeamCheck = false
local espObjects = {}

function clearESP()
    for _, obj in pairs(espObjects) do
        pcall(function() obj:Remove() end)
    end
    espObjects = {}
end

function createESPLine(from, to, color, thickness)
    local line = Drawing.new("Line")
    line.Color = color
    line.Thickness = thickness or 1
    line.From = from
    line.To = to
    line.Visible = true
    table.insert(espObjects, line)
    return line
end

function createESPBoxOutline(pos, size, color)
    local outlineSize = 1
    createESPLine(Vector2.new(pos.X - outlineSize, pos.Y - outlineSize), Vector2.new(pos.X + size.X + outlineSize, pos.Y - outlineSize), Color3.fromRGB(0, 0, 0), 3)
    createESPLine(Vector2.new(pos.X - outlineSize, pos.Y + size.Y + outlineSize), Vector2.new(pos.X + size.X + outlineSize, pos.Y + size.Y + outlineSize), Color3.fromRGB(0, 0, 0), 3)
    createESPLine(Vector2.new(pos.X - outlineSize, pos.Y - outlineSize), Vector2.new(pos.X - outlineSize, pos.Y + size.Y + outlineSize), Color3.fromRGB(0, 0, 0), 3)
    createESPLine(Vector2.new(pos.X + size.X + outlineSize, pos.Y - outlineSize), Vector2.new(pos.X + size.X + outlineSize, pos.Y + size.Y + outlineSize), Color3.fromRGB(0, 0, 0), 3)
    createESPLine(Vector2.new(pos.X, pos.Y), Vector2.new(pos.X + size.X, pos.Y), color, 2)
    createESPLine(Vector2.new(pos.X, pos.Y + size.Y), Vector2.new(pos.X + size.X, pos.Y + size.Y), color, 2)
    createESPLine(Vector2.new(pos.X, pos.Y), Vector2.new(pos.X, pos.Y + size.Y), color, 2)
    createESPLine(Vector2.new(pos.X + size.X, pos.Y), Vector2.new(pos.X + size.X, pos.Y + size.Y), color, 2)
end

function createESPHealthBar(pos, size, healthPercent)
    local bg = Drawing.new("Square")
    bg.Color = Color3.fromRGB(0, 0, 0)
    bg.Filled = true
    bg.Size = Vector2.new(size.X, size.Y)
    bg.Position = pos
    bg.Visible = true
    table.insert(espObjects, bg)
    
    local fillColor = Color3.fromRGB(0, 255, 100)
    if healthPercent < 0.5 then fillColor = Color3.fromRGB(255, 255, 0) end
    if healthPercent < 0.25 then fillColor = Color3.fromRGB(255, 50, 50) end
    
    local fill = Drawing.new("Square")
    fill.Color = fillColor
    fill.Filled = true
    fill.Size = Vector2.new(size.X - 2, (size.Y - 2) * healthPercent)
    fill.Position = Vector2.new(pos.X + 1, pos.Y + (size.Y - 2) * (1 - healthPercent) + 1)
    fill.Visible = true
    table.insert(espObjects, fill)
    
    local outline = Drawing.new("Square")
    outline.Color = Color3.fromRGB(255, 255, 255)
    outline.Filled = false
    outline.Thickness = 1
    outline.Size = size
    outline.Position = pos
    outline.Visible = true
    table.insert(espObjects, outline)
end

-- =============================================
-- AIMBOT STATE
-- =============================================
local aimbotEnabled = false
local showFov = false
local fovSize = 100
local aimPart = "Head"
local teamCheck = false
local aimbotConnection = nil

-- =============================================
-- FLY STATE
-- =============================================
local flyEnabled = false
local flySpeed = 50
local flyKeybind = nil
local flyConnection = nil
local flyBodyGyro = nil
local flyBodyVelocity = nil

function startFly()
    if flyConnection then flyConnection:Disconnect() end
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    if not root or not humanoid then return end
    
    humanoid.PlatformStand = true
    
    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.P = 9e4
    flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyBodyGyro.CFrame = root.CFrame
    flyBodyGyro.Parent = root
    
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyBodyVelocity.Velocity = Vector3.zero
    flyBodyVelocity.Parent = root
    
    flyConnection = RunService.Heartbeat:Connect(function()
        if not flyEnabled then return end
        local char = Player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        flyBodyGyro.CFrame = Camera.CFrame
        
        local moveDirection = Vector3.zero
        local forward = Camera.CFrame.LookVector
        local right = Camera.CFrame.RightVector
        
        local w = UserInputService:IsKeyDown(Enum.KeyCode.W)
        local s = UserInputService:IsKeyDown(Enum.KeyCode.S)
        local a = UserInputService:IsKeyDown(Enum.KeyCode.A)
        local d = UserInputService:IsKeyDown(Enum.KeyCode.D)
        local space = UserInputService:IsKeyDown(Enum.KeyCode.Space)
        local lctrl = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
        
        if w then moveDirection = moveDirection + forward end
        if s then moveDirection = moveDirection - forward end
        if a then moveDirection = moveDirection - right end
        if d then moveDirection = moveDirection + right end
        if space then moveDirection = moveDirection + Vector3.yAxis end
        if lctrl then moveDirection = moveDirection - Vector3.yAxis end
        
        if moveDirection.Magnitude > 0.01 then
            flyBodyVelocity.Velocity = moveDirection.Unit * flySpeed
        else
            flyBodyVelocity.Velocity = Vector3.zero
        end
    end)
end

function stopFly()
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    if flyBodyGyro then
        flyBodyGyro:Destroy()
        flyBodyGyro = nil
    end
    if flyBodyVelocity then
        flyBodyVelocity:Destroy()
        flyBodyVelocity = nil
    end
    local char = Player.Character
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
end

-- =============================================
-- TEAM CHECK
-- =============================================
function getTeam(player)
    if player.Team then return player.Team end
    if player.TeamColor then return player.TeamColor end
    local char = player.Character
    if char then
        local teamFolder = char:FindFirstChild("Team") or char:FindFirstChild("team")
        if teamFolder then return teamFolder end
    end
    return nil
end

function isSameTeam(target)
    if not teamCheck and not espTeamCheck then return false end
    local myTeam = getTeam(Player)
    local theirTeam = getTeam(target)
    if myTeam and theirTeam then
        if myTeam == theirTeam then return true end
        if myTeam.Name and theirTeam.Name and myTeam.Name == theirTeam.Name then return true end
    end
    return false
end

-- =============================================
-- AIMBOT LOGIC
-- =============================================
function getTargetPart(char, partName)
    if partName == "Head" then return char:FindFirstChild("Head")
    elseif partName == "Torso" then return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
    elseif partName == "Legs" then return char:FindFirstChild("LeftLowerLeg") or char:FindFirstChild("RightLowerLeg") or char:FindFirstChild("LeftLeg") or char:FindFirstChild("RightLeg")
    elseif partName == "Closest to Crosshair" then
        local closest, closestDist = nil, math.huge
        local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                    if dist < closestDist then closestDist = dist; closest = part end
                end
            end
        end
        return closest
    end
    return char:FindFirstChild("Head")
end

function getClosestPlayerToCenter()
    local closestPlayer, closestDistance = nil, fovSize
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, target in ipairs(Players:GetPlayers()) do
        if target ~= Player and target.Character then
            if isSameTeam(target) then continue end
            local targetPart = getTargetPart(target.Character, aimPart)
            local humanoid = target.Character:FindFirstChild("Humanoid")
            if targetPart and humanoid and humanoid.Health > 0 then
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local visible = false
                    local cameraPos = Camera.CFrame.Position
                    local targetPos = targetPart.Position
                    local checkPoints = {targetPos, targetPos + Vector3.new(0,1,0), targetPos + Vector3.new(0,-1,0), targetPos + Vector3.new(1,0,0), targetPos + Vector3.new(-1,0,0)}
                    for _, checkPos in ipairs(checkPoints) do
                        local rayDirection = (checkPos - cameraPos).Unit * 1000
                        local raycastParams = RaycastParams.new()
                        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                        raycastParams.FilterDescendantsInstances = {Player.Character}
                        local rayResult = workspace:Raycast(cameraPos, rayDirection, raycastParams)
                        if not rayResult then visible = true; break
                        else
                            local hitPart = rayResult.Instance
                            if hitPart:IsDescendantOf(target.Character) then visible = true; break end
                            local hitDistance = (hitPart.Position - cameraPos).Magnitude
                            local targetDistance = (checkPos - cameraPos).Magnitude
                            if hitDistance >= targetDistance - 3 then visible = true; break end
                        end
                    end
                    if visible then
                        local screenPoint = Vector2.new(screenPos.X, screenPos.Y)
                        local distance = (screenPoint - screenCenter).Magnitude
                        if distance < closestDistance then closestDistance = distance; closestPlayer = target end
                    end
                end
            end
        end
    end
    return closestPlayer
end

function aimAtTarget(target)
    if target and target.Character then
        local targetPart = getTargetPart(target.Character, aimPart)
        if targetPart then Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position) end
    end
end

function updateAimbot()
    if aimbotConnection then aimbotConnection:Disconnect(); aimbotConnection = nil end
    if aimbotEnabled then
        aimbotConnection = RunService.RenderStepped:Connect(function()
            if aimbotEnabled then
                local target = getClosestPlayerToCenter()
                if target then aimAtTarget(target) end
            end
        end)
    end
end

-- =============================================
-- ESP RENDER LOOP
-- =============================================
function renderESP()
    clearESP()
    if not (espBoxEnabled or espSkeletonEnabled or espHealthBarEnabled) then return end
    
    for _, target in ipairs(Players:GetPlayers()) do
        if target ~= Player and target.Character then
            if espTeamCheck and isSameTeam(target) then continue end
            
            local humanoid = target.Character:FindFirstChild("Humanoid")
            local head = target.Character:FindFirstChild("Head")
            local root = target.Character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and humanoid.Health > 0 and head and root then
                local headPos, headOnScreen = Camera:WorldToViewportPoint(head.Position)
                local rootPos, rootOnScreen = Camera:WorldToViewportPoint(root.Position)
                
                if headOnScreen or rootOnScreen then
                    local model = target.Character
                    local cf, size = model:GetBoundingBox()
                    local corners = {
                        cf * Vector3.new(size.X/2, size.Y/2, size.Z/2),
                        cf * Vector3.new(-size.X/2, size.Y/2, size.Z/2),
                        cf * Vector3.new(size.X/2, -size.Y/2, size.Z/2),
                        cf * Vector3.new(-size.X/2, -size.Y/2, size.Z/2),
                        cf * Vector3.new(size.X/2, size.Y/2, -size.Z/2),
                        cf * Vector3.new(-size.X/2, size.Y/2, -size.Z/2),
                        cf * Vector3.new(size.X/2, -size.Y/2, -size.Z/2),
                        cf * Vector3.new(-size.X/2, -size.Y/2, -size.Z/2),
                    }
                    
                    local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
                    local anyOnScreen = false
                    
                    for _, corner in ipairs(corners) do
                        local screenPos, onScreen = Camera:WorldToViewportPoint(corner)
                        if onScreen then
                            anyOnScreen = true
                            if screenPos.X < minX then minX = screenPos.X end
                            if screenPos.Y < minY then minY = screenPos.Y end
                            if screenPos.X > maxX then maxX = screenPos.X end
                            if screenPos.Y > maxY then maxY = screenPos.Y end
                        end
                    end
                    
                    if anyOnScreen then
                        local boxX = minX
                        local boxY = minY
                        local boxWidth = maxX - minX
                        local boxHeight = maxY - minY
                        
                        if espBoxEnabled then
                            createESPBoxOutline(Vector2.new(boxX, boxY), Vector2.new(boxWidth, boxHeight), Color3.fromRGB(255, 255, 255))
                        end
                        
                        if espHealthBarEnabled then
                            local healthPercent = humanoid.Health / humanoid.MaxHealth
                            local barWidth = 4
                            local barX = boxX - barWidth - 4
                            local barY = boxY
                            createESPHealthBar(Vector2.new(barX, barY), Vector2.new(barWidth, boxHeight), healthPercent)
                        end
                        
                        if espSkeletonEnabled then
                            local torso = target.Character:FindFirstChild("UpperTorso") or target.Character:FindFirstChild("Torso")
                            local leftArm = target.Character:FindFirstChild("LeftUpperArm") or target.Character:FindFirstChild("LeftArm")
                            local rightArm = target.Character:FindFirstChild("RightUpperArm") or target.Character:FindFirstChild("RightArm")
                            local leftLeg = target.Character:FindFirstChild("LeftUpperLeg") or target.Character:FindFirstChild("LeftLeg")
                            local rightLeg = target.Character:FindFirstChild("RightUpperLeg") or target.Character:FindFirstChild("RightLeg")
                            
                            if torso then
                                local torsoPos = Camera:WorldToViewportPoint(torso.Position)
                                if torsoPos.Z > 0 then
                                    createESPLine(Vector2.new(headPos.X, headPos.Y), Vector2.new(torsoPos.X, torsoPos.Y), skeletonColor)
                                end
                                if leftArm then
                                    local lap = Camera:WorldToViewportPoint(leftArm.Position)
                                    if lap.Z > 0 then createESPLine(Vector2.new(torsoPos.X, torsoPos.Y), Vector2.new(lap.X, lap.Y), skeletonColor) end
                                end
                                if rightArm then
                                    local rap = Camera:WorldToViewportPoint(rightArm.Position)
                                    if rap.Z > 0 then createESPLine(Vector2.new(torsoPos.X, torsoPos.Y), Vector2.new(rap.X, rap.Y), skeletonColor) end
                                end
                                if leftLeg then
                                    local llp = Camera:WorldToViewportPoint(leftLeg.Position)
                                    if llp.Z > 0 then createESPLine(Vector2.new(torsoPos.X, torsoPos.Y), Vector2.new(llp.X, llp.Y), skeletonColor) end
                                end
                                if rightLeg then
                                    local rlp = Camera:WorldToViewportPoint(rightLeg.Position)
                                    if rlp.Z > 0 then createESPLine(Vector2.new(torsoPos.X, torsoPos.Y), Vector2.new(rlp.X, rlp.Y), skeletonColor) end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

-- =============================================
-- AIMBOT TAB
-- =============================================
local AimTab = CreateTab("Aimbot")
CreateSection(AimTab, "Aimbot Settings")
CreateToggle(AimTab, "Enable Aimbot", false, function(v) aimbotEnabled = v; updateAimbot() end)
CreateToggle(AimTab, "Team Check", false, function(v) teamCheck = v end)
CreateDropdown(AimTab, "Target Part", {"Head", "Torso", "Legs", "Closest to Crosshair"}, "Head", function(v) aimPart = v end)
CreateSection(AimTab, "FOV Settings")
CreateToggle(AimTab, "Show FOV", false, function(v) showFov = v; fovCircle.Visible = v end)
CreateColorPicker(AimTab, "FOV Color", fovColor, function(col) fovColor = col; fovCircle.Color = col end)
CreateSlider(AimTab, "FOV Size", 30, 500, 100, function(v) fovSize = v; fovCircle.Radius = v end)

-- =============================================
-- VISUALS TAB
-- =============================================
local VisualTab = CreateTab("Visuals")
CreateSection(VisualTab, "Enemy ESP")
CreateToggle(VisualTab, "Team Check", false, function(v) espTeamCheck = v end)
CreateToggle(VisualTab, "Box", false, function(v) espBoxEnabled = v end)
CreateToggle(VisualTab, "Skeleton", false, function(v) espSkeletonEnabled = v end)
CreateColorPicker(VisualTab, "Skeleton Color", skeletonColor, function(col) skeletonColor = col end)
CreateToggle(VisualTab, "Health Bar", false, function(v) espHealthBarEnabled = v end)

-- =============================================
-- MOVEMENT TAB
-- =============================================
local MoveTab = CreateTab("Movement")
CreateSection(MoveTab, "Speed Modifiers")
local walkSpeedValue = 16
local jumpPowerValue = 50
local speedConnection, jumpConnection = nil, nil

CreateSlider(MoveTab, "Walk Speed", 16, 200, 16, function(v)
    walkSpeedValue = v
    if speedConnection then speedConnection:Disconnect() end
    if v > 16 then
        speedConnection = RunService.Heartbeat:Connect(function()
            local char = Player.Character
            if char then local hum = char:FindFirstChild("Humanoid")
                if hum and hum.WalkSpeed ~= v then hum.WalkSpeed = v end
            end
        end)
    end
end)

CreateSlider(MoveTab, "Jump Power", 50, 300, 50, function(v)
    jumpPowerValue = v
    if jumpConnection then jumpConnection:Disconnect() end
    jumpConnection = RunService.Heartbeat:Connect(function()
        local char = Player.Character
        if char then local hum = char:FindFirstChild("Humanoid")
            if hum then hum.JumpPower = v; hum.UseJumpPower = true end
        end
    end)
end)

CreateSection(MoveTab, "Extra")
local noclipConnection = nil
CreateToggle(MoveTab, "No Clip", false, function(v)
    if v then
        noclipConnection = RunService.Stepped:Connect(function()
            local char = Player.Character
            if char then for _, part in pairs(char:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect(); noclipConnection = nil end
        local char = Player.Character
        if char then for _, part in pairs(char:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = true end end end
    end
end)

CreateSection(MoveTab, "Fly")
CreateToggle(MoveTab, "Enable Fly", false, function(v)
    flyEnabled = v
    if v then
        startFly()
    else
        stopFly()
    end
end)

CreateKeybind(MoveTab, "Fly Keybind", nil, function(key)
    flyKeybind = key
end)

CreateSlider(MoveTab, "Fly Speed", 20, 200, 50, function(v)
    flySpeed = v
end)

Player.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    hum.WalkSpeed = walkSpeedValue
    hum.JumpPower = jumpPowerValue
    if flyEnabled then
        stopFly()
        wait(0.1)
        startFly()
    end
end)

-- =============================================
-- KEYBIND INPUT FOR FLY
-- =============================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if flyKeybind and input.KeyCode == Enum.KeyCode[flyKeybind] and not gameProcessed then
        flyEnabled = not flyEnabled
        if flyEnabled then
            startFly()
        else
            stopFly()
        end
    end
    if input.KeyCode == Enum.KeyCode.K then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

-- =============================================
-- RENDER LOOP
-- =============================================
RunService.RenderStepped:Connect(function()
    if showFov and fovCircle then
        fovCircle.Radius = fovSize
        fovCircle.Color = fovColor
        fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end
    renderESP()
end)

print("STARR.WTF Arsenal Loaded - Press K to toggle")