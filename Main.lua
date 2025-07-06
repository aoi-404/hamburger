--[[
GAG SCRIPT BY:BREAD
Modern Sidebar GUI (Restarted)
--]]

print("[GAG] Script started")

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

-- Main GUI
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GAG_SidebarGUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui
print("[GAG] ScreenGui parented to PlayerGui")

local function safeFind(parent, child)
    if parent then
        return parent:FindFirstChild(child)
    end
    return nil
end

-- Sidebar Frame
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 520, 0, 480) -- Increased width and height
sidebar.Position = UDim2.new(0.5, -260, 0.5, -240)
sidebar.BackgroundColor3 = Color3.fromRGB(120, 130, 150)
sidebar.BorderSizePixel = 0
sidebar.Parent = screenGui
sidebar.Visible = true

-- Top Bar
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 44) -- Increased height
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundColor3 = Color3.fromRGB(80, 90, 110)
topBar.BorderSizePixel = 0
topBar.Parent = sidebar
topBar.ZIndex = 30 -- Ensure top bar is always on top

local topBarTitle = Instance.new("TextLabel")
topBarTitle.Name = "TopBarTitle"
topBarTitle.Size = UDim2.new(1, -80, 1, 0)
topBarTitle.Position = UDim2.new(0, 12, 0, 0)
topBarTitle.BackgroundTransparency = 1
topBarTitle.Text = "GAG SCRIPT BY:BREAD"
topBarTitle.Font = Enum.Font.SourceSansBold
topBarTitle.TextSize = 24
topBarTitle.TextColor3 = Color3.fromRGB(40, 40, 40)
topBarTitle.TextXAlignment = Enum.TextXAlignment.Left
topBarTitle.Parent = topBar
topBarTitle.ZIndex = 31

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Size = UDim2.new(0, 32, 1, 0)
minimizeBtn.Position = UDim2.new(1, -64, 0, 0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(80, 90, 110)
minimizeBtn.Text = "_"
minimizeBtn.Font = Enum.Font.SourceSansBold
minimizeBtn.TextSize = 22
minimizeBtn.TextColor3 = Color3.fromRGB(0,0,0)
minimizeBtn.Parent = topBar
minimizeBtn.ZIndex = 32

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 32, 1, 0)
closeBtn.Position = UDim2.new(1, -32, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 22
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Parent = topBar
closeBtn.ZIndex = 32

-- Minimize/Close functionality
minimizeBtn.MouseButton1Click:Connect(function()
    sidebar.Visible = not sidebar.Visible
end)
closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

-- Sidebar Tabs
local tabNames = {"EVENT", "SHOP", "FARM"}
local tabButtons = {}
for i, name in ipairs(tabNames) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = name .. "TabBtn"
    tabBtn.Size = UDim2.new(0, 120, 0, 54)
    tabBtn.Position = UDim2.new(0, 0, 0, 44 + (i-1)*54)
    tabBtn.BackgroundColor3 = i == 1 and Color3.fromRGB(220, 160, 80) or Color3.fromRGB(80, 90, 110)
    tabBtn.Text = name
    tabBtn.Font = Enum.Font.SourceSansBold
    tabBtn.TextSize = 24
    tabBtn.TextColor3 = Color3.fromRGB(40, 40, 40)
    tabBtn.BorderSizePixel = 0
    tabBtn.Parent = sidebar
    tabBtn.ZIndex = 20 -- Always on top
    tabButtons[name] = tabBtn
end

-- Vertical Black Line
local navLine = Instance.new("Frame")
navLine.Size = UDim2.new(0, 4, 1, -44)
navLine.Position = UDim2.new(0, 120, 0, 44)
navLine.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
navLine.BorderSizePixel = 0
navLine.Parent = sidebar

-- Main Content Frame (ensure correct position and ZIndex)
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -124, 1, -44)
contentFrame.Position = UDim2.new(0, 124, 0, 44)
contentFrame.BackgroundColor3 = Color3.fromRGB(120, 130, 150)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = sidebar
contentFrame.ZIndex = 21 -- Above sidebar, below top bar

-- Tab Content (ensure ZIndex and parent)
local tabContent = {}
for _, name in ipairs(tabNames) do
    local frame = Instance.new("Frame")
    frame.Name = name .. "TabContent"
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = (name == "EVENT")
    frame.Parent = contentFrame
    frame.ZIndex = 21 -- Above sidebar, below top bar
    tabContent[name] = frame
end

-- EVENT TAB CONTENT
local eventFrame = tabContent["EVENT"]
local eventHeader = Instance.new("TextLabel")
eventHeader.Size = UDim2.new(1, -32, 0, 40)
eventHeader.Position = UDim2.new(0, 16, 0, 16)
eventHeader.BackgroundColor3 = Color3.fromRGB(40, 90, 180)
eventHeader.Text = "SUMMER HARVEST"
eventHeader.Font = Enum.Font.SourceSansBold
eventHeader.TextSize = 22
eventHeader.TextColor3 = Color3.fromRGB(255,255,255)
eventHeader.BorderSizePixel = 0
eventHeader.TextXAlignment = Enum.TextXAlignment.Center
eventHeader.Parent = eventFrame
eventHeader.ZIndex = 22

local autoSubmitToggle = Instance.new("TextButton")
autoSubmitToggle.Name = "AutoSubmitToggle"
autoSubmitToggle.Size = UDim2.new(1, -32, 0, 36)
autoSubmitToggle.Position = UDim2.new(0, 16, 0, 64)
autoSubmitToggle.BackgroundColor3 = Color3.fromRGB(60, 90, 130)
autoSubmitToggle.Text = "AUTO SUBMIT:"
autoSubmitToggle.Font = Enum.Font.SourceSansBold
autoSubmitToggle.TextSize = 20
autoSubmitToggle.TextColor3 = Color3.fromRGB(255,255,255)
autoSubmitToggle.BorderSizePixel = 0
autoSubmitToggle.TextXAlignment = Enum.TextXAlignment.Left
autoSubmitToggle.Parent = eventFrame
autoSubmitToggle.ZIndex = 22

local check = Instance.new("TextLabel")
check.Name = "Checkmark"
check.Size = UDim2.new(0, 32, 1, 0)
check.Position = UDim2.new(1, -36, 0, 0)
check.BackgroundTransparency = 1
check.Font = Enum.Font.SourceSansBold
check.TextSize = 24
check.TextColor3 = Color3.fromRGB(220, 220, 220)
check.Text = ""
check.Parent = autoSubmitToggle
check.ZIndex = 23

local autoSubmitState = false
local function updateAutoSubmitToggle()
    autoSubmitToggle.BackgroundColor3 = autoSubmitState and Color3.fromRGB(40, 90, 180) or Color3.fromRGB(60, 90, 130)
    check.Text = autoSubmitState and "✔" or ""
end
updateAutoSubmitToggle()
autoSubmitToggle.MouseButton1Click:Connect(function()
    autoSubmitState = not autoSubmitState
    updateAutoSubmitToggle()
end)

-- SHOP TAB CONTENT
local shopFrame = tabContent["SHOP"]

-- Y position tracker for vertical stacking
local y = 20

-- GEAR SECTION
local gearHeader = Instance.new("TextLabel")
gearHeader.Size = UDim2.new(1, -40, 0, 32)
gearHeader.Position = UDim2.new(0, 20, 0, y)
gearHeader.BackgroundTransparency = 1
gearHeader.Text = "BUY GEAR:"
gearHeader.Font = Enum.Font.SourceSansBold
gearHeader.TextSize = 22
gearHeader.TextColor3 = Color3.fromRGB(255,255,255)
gearHeader.TextXAlignment = Enum.TextXAlignment.Left
gearHeader.Parent = shopFrame
gearHeader.ZIndex = 22
y = y + 32 + 6

local gearDropdownBtn = Instance.new("TextButton")
gearDropdownBtn.Name = "GearDropdownBtn"
gearDropdownBtn.Size = UDim2.new(1, -40, 0, 44)
gearDropdownBtn.Position = UDim2.new(0, 20, 0, y)
gearDropdownBtn.BackgroundColor3 = Color3.fromRGB(40, 90, 180)
gearDropdownBtn.Text = "BUY GEAR:"
gearDropdownBtn.Font = Enum.Font.SourceSansBold
gearDropdownBtn.TextSize = 22
gearDropdownBtn.TextColor3 = Color3.fromRGB(255,255,255)
gearDropdownBtn.BorderSizePixel = 0
gearDropdownBtn.TextXAlignment = Enum.TextXAlignment.Center
gearDropdownBtn.Parent = shopFrame
gearDropdownBtn.ZIndex = 22
y = y + 44 + 6

local gearDropdownList = Instance.new("ScrollingFrame")
gearDropdownList.Name = "GearDropdownList"
gearDropdownList.Size = UDim2.new(1, -40, 0, 0)
gearDropdownList.Position = UDim2.new(0, 20, 0, y)
gearDropdownList.BackgroundColor3 = Color3.fromRGB(60, 120, 180)
gearDropdownList.BorderSizePixel = 0
gearDropdownList.Visible = false
gearDropdownList.Parent = shopFrame
gearDropdownList.ZIndex = 23

local autoBuyGearToggle = Instance.new("TextButton")
autoBuyGearToggle.Name = "AutoBuyGearToggle"
autoBuyGearToggle.Size = UDim2.new(1, -40, 0, 36)
autoBuyGearToggle.Position = UDim2.new(0, 20, 0, y + 0)
autoBuyGearToggle.BackgroundColor3 = Color3.fromRGB(60, 90, 130)
autoBuyGearToggle.Text = "AUTO BUY GEAR"
autoBuyGearToggle.Font = Enum.Font.SourceSansBold
autoBuyGearToggle.TextSize = 20
autoBuyGearToggle.TextColor3 = Color3.fromRGB(255,255,255)
autoBuyGearToggle.BorderSizePixel = 0
autoBuyGearToggle.TextXAlignment = Enum.TextXAlignment.Left
autoBuyGearToggle.Parent = shopFrame
autoBuyGearToggle.ZIndex = 22

-- GEAR LIST OPTIONS
local gearOptions = {
    "Watering Can", "Trowel", "Recall Wrench", "Basic Sprinkler", "Advanced Sprinkler", "Godly Sprinkler", "Magnifying Glass", "Tanning Mirror", "Master Sprinkler", "Cleaning Spray", "Favourite Tool", "Harvest Tool", "Friendship Pot"
}
local selectedGear = {}
local function updateGearDropdownText()
    if #selectedGear == 0 then
        gearDropdownBtn.Text = "BUY GEAR:"
    else
        gearDropdownBtn.Text = "BUY GEAR: " .. table.concat(selectedGear, ", ")
    end
end
for i, name in ipairs(gearOptions) do
    local opt = Instance.new("TextButton")
    opt.Size = UDim2.new(1, 0, 0, 38)
    opt.Position = UDim2.new(0, 0, 0, (i-1)*38)
    opt.BackgroundColor3 = Color3.fromRGB(100, 170, 220)
    opt.Text = name
    opt.Font = Enum.Font.SourceSans
    opt.TextSize = 20
    opt.TextColor3 = Color3.fromRGB(255,255,255)
    opt.BorderSizePixel = 0
    opt.Parent = gearDropdownList
    opt.ZIndex = 14
    opt.MouseButton1Click:Connect(function()
        local found = false
        for j, v in ipairs(selectedGear) do
            if v == name then table.remove(selectedGear, j) found = true break end
        end
        if not found then table.insert(selectedGear, name) end
        updateGearDropdownText()
        opt.BackgroundColor3 = found and Color3.fromRGB(100, 170, 220) or Color3.fromRGB(60, 200, 120)
    end)
end
updateGearDropdownText()
gearDropdownList.CanvasSize = UDim2.new(0, 0, 0, #gearOptions * 38)

-- EGG SECTION
local eggHeader = Instance.new("TextLabel")
eggHeader.Size = UDim2.new(1, -40, 0, 32)
eggHeader.Position = UDim2.new(0, 20, 0, y)
eggHeader.BackgroundTransparency = 1
eggHeader.Text = "BUY EGG:"
eggHeader.Font = Enum.Font.SourceSansBold
eggHeader.TextSize = 22
eggHeader.TextColor3 = Color3.fromRGB(255,255,255)
eggHeader.TextXAlignment = Enum.TextXAlignment.Left
eggHeader.Parent = shopFrame
eggHeader.ZIndex = 22
y = y + 32 + 6

local eggDropdownBtn = Instance.new("TextButton")
eggDropdownBtn.Name = "EggDropdownBtn"
eggDropdownBtn.Size = UDim2.new(1, -40, 0, 44)
eggDropdownBtn.Position = UDim2.new(0, 20, 0, y)
eggDropdownBtn.BackgroundColor3 = Color3.fromRGB(40, 90, 180)
eggDropdownBtn.Text = "BUY EGG:"
eggDropdownBtn.Font = Enum.Font.SourceSansBold
eggDropdownBtn.TextSize = 22
eggDropdownBtn.TextColor3 = Color3.fromRGB(255,255,255)
eggDropdownBtn.BorderSizePixel = 0
eggDropdownBtn.TextXAlignment = Enum.TextXAlignment.Center
eggDropdownBtn.Parent = shopFrame
eggDropdownBtn.ZIndex = 22
y = y + 44 + 6

local eggDropdownList = Instance.new("ScrollingFrame")
eggDropdownList.Name = "EggDropdownList"
eggDropdownList.Size = UDim2.new(1, -40, 0, 0)
eggDropdownList.Position = UDim2.new(0, 20, 0, y)
eggDropdownList.BackgroundColor3 = Color3.fromRGB(60, 120, 180)
eggDropdownList.BorderSizePixel = 0
eggDropdownList.Visible = false
eggDropdownList.Parent = shopFrame
eggDropdownList.ZIndex = 23

local autoBuyEggToggle = Instance.new("TextButton")
autoBuyEggToggle.Name = "AutoBuyEggToggle"
autoBuyEggToggle.Size = UDim2.new(1, -40, 0, 36)
autoBuyEggToggle.Position = UDim2.new(0, 20, 0, y)
autoBuyEggToggle.BackgroundColor3 = Color3.fromRGB(60, 90, 130)
autoBuyEggToggle.Text = "AUTO BUY EGG"
autoBuyEggToggle.Font = Enum.Font.SourceSansBold
autoBuyEggToggle.TextSize = 20
autoBuyEggToggle.TextColor3 = Color3.fromRGB(255,255,255)
autoBuyEggToggle.BorderSizePixel = 0
autoBuyEggToggle.TextXAlignment = Enum.TextXAlignment.Left
autoBuyEggToggle.Parent = shopFrame
autoBuyEggToggle.ZIndex = 22

-- EGG LIST OPTIONS
local eggOptions = {
    "Basic Egg", "Advanced Egg", "Godly Egg", "Mystery Egg", "Event Egg"
}
local selectedEgg = {}
local function updateEggDropdownText()
    if #selectedEgg == 0 then
        eggDropdownBtn.Text = "BUY EGG:"
    else
        eggDropdownBtn.Text = "BUY EGG: " .. table.concat(selectedEgg, ", ")
    end
end
for i, name in ipairs(eggOptions) do
    local opt = Instance.new("TextButton")
    opt.Size = UDim2.new(1, 0, 0, 38)
    opt.Position = UDim2.new(0, 0, 0, (i-1)*38)
    opt.BackgroundColor3 = Color3.fromRGB(100, 170, 220)
    opt.Text = name
    opt.Font = Enum.Font.SourceSans
    opt.TextSize = 20
    opt.TextColor3 = Color3.fromRGB(255,255,255)
    opt.BorderSizePixel = 0
    opt.Parent = eggDropdownList
    opt.ZIndex = 14
    opt.MouseButton1Click:Connect(function()
        local found = false
        for j, v in ipairs(selectedEgg) do
            if v == name then table.remove(selectedEgg, j) found = true break end
        end
        if not found then table.insert(selectedEgg, name) end
        updateEggDropdownText()
        opt.BackgroundColor3 = found and Color3.fromRGB(100, 170, 220) or Color3.fromRGB(60, 200, 120)
    end)
end
updateEggDropdownText()
eggDropdownList.CanvasSize = UDim2.new(0, 0, 0, #eggOptions * 38)

-- SEED SECTION
local seedHeader = Instance.new("TextLabel")
seedHeader.Size = UDim2.new(1, -40, 0, 32)
seedHeader.Position = UDim2.new(0, 20, 0, y)
seedHeader.BackgroundTransparency = 1
seedHeader.Text = "BUY SEEDS:"
seedHeader.Font = Enum.Font.SourceSansBold
seedHeader.TextSize = 22
seedHeader.TextColor3 = Color3.fromRGB(255,255,255)
seedHeader.TextXAlignment = Enum.TextXAlignment.Left
seedHeader.Parent = shopFrame
seedHeader.ZIndex = 22
y = y + 32 + 6

local seedDropdownBtn = Instance.new("TextButton")
seedDropdownBtn.Name = "SeedDropdownBtn"
seedDropdownBtn.Size = UDim2.new(1, -40, 0, 44)
seedDropdownBtn.Position = UDim2.new(0, 20, 0, y)
seedDropdownBtn.BackgroundColor3 = Color3.fromRGB(40, 90, 180)
seedDropdownBtn.Text = "BUY SEEDS:"
seedDropdownBtn.Font = Enum.Font.SourceSansBold
seedDropdownBtn.TextSize = 22
seedDropdownBtn.TextColor3 = Color3.fromRGB(255,255,255)
seedDropdownBtn.BorderSizePixel = 0
seedDropdownBtn.TextXAlignment = Enum.TextXAlignment.Center
seedDropdownBtn.Parent = shopFrame
seedDropdownBtn.ZIndex = 22
y = y + 44 + 6

local seedDropdownList = Instance.new("ScrollingFrame")
seedDropdownList.Name = "SeedDropdownList"
seedDropdownList.Size = UDim2.new(1, -40, 0, 0)
seedDropdownList.Position = UDim2.new(0, 20, 0, y)
seedDropdownList.BackgroundColor3 = Color3.fromRGB(60, 120, 180)
seedDropdownList.BorderSizePixel = 0
seedDropdownList.Visible = false
seedDropdownList.Parent = shopFrame
seedDropdownList.ZIndex = 23

local autoBuySeedToggle = Instance.new("TextButton")
autoBuySeedToggle.Name = "AutoBuySeedToggle"
autoBuySeedToggle.Size = UDim2.new(1, -40, 0, 36)
autoBuySeedToggle.Position = UDim2.new(0, 20, 0, y)
autoBuySeedToggle.BackgroundColor3 = Color3.fromRGB(60, 90, 130)
autoBuySeedToggle.Text = "AUTO BUY SEED"
autoBuySeedToggle.Font = Enum.Font.SourceSansBold
autoBuySeedToggle.TextSize = 20
autoBuySeedToggle.TextColor3 = Color3.fromRGB(255,255,255)
autoBuySeedToggle.BorderSizePixel = 0
autoBuySeedToggle.TextXAlignment = Enum.TextXAlignment.Left
autoBuySeedToggle.Parent = shopFrame
autoBuySeedToggle.ZIndex = 22

-- SEED LIST OPTIONS
local seedOptions = {
    "Carrot", "Strawberry", "Blueberry", "Tomato", "Cauliflower", "Watermelon", "Raffleisa", "Green Apple", "Avocado", "Banana", "Pineapple", "Kiwi", "Bell Pepper", "Prickly Pear", "Loquat", "Feijoa", "Pitcher Plant", "Sugar Apple", "Burning Bud"
}
local seedDetails = {
    ["Carrot"] = "Single | 10 | Common",
    ["Strawberry"] = "Multiple | 50 | Common",
    ["Blueberry"] = "Multiple | 400 | Uncommon",
    ["Tomato"] = "Multiple | 800 | Rare",
    ["Cauliflower"] = "Multiple | 1,300 | Rare",
    ["Watermelon"] = "Single | 2,500 | Legendary",
    ["Raffleisa"] = "Single | 3,200 | Legendary",
    ["Green Apple"] = "Multiple | 3,500 | Legendary",
    ["Avocado"] = "Multiple | 5,000 | Legendary",
    ["Banana"] = "Multiple | 7,000 | Legendary",
    ["Pineapple"] = "Multiple | 7,500 | Mythical",
    ["Kiwi"] = "Multiple | 10,000 | Mythical",
    ["Bell Pepper"] = "Multiple | 55,000 | Mythical",
    ["Prickly Pear"] = "Multiple | 555,000 | Mythical",
    ["Loquat"] = "Multiple | 900,000 | Divine",
    ["Feijoa"] = "Multiple | 900,000 | Divine",
    ["Pitcher Plant"] = "Multiple | 7,500,000 | Divine",
    ["Sugar Apple"] = "Multiple | 25,000,000 | Prismatic",
    ["Burning Bud"] = "Multiple | 50,000,000 | Prismatic"
}
local selectedSeed = {}
local function updateSeedDropdownText()
    if #selectedSeed == 0 then
        seedDropdownBtn.Text = "BUY SEEDS:"
    else
        seedDropdownBtn.Text = "BUY SEEDS: " .. table.concat(selectedSeed, ", ")
    end
end
for i, name in ipairs(seedOptions) do
    local opt = Instance.new("TextButton")
    opt.Size = UDim2.new(1, 0, 0, 38)
    opt.Position = UDim2.new(0, 0, 0, (i-1)*38)
    opt.BackgroundColor3 = Color3.fromRGB(100, 170, 220)
    opt.Text = name
    opt.Font = Enum.Font.SourceSans
    opt.TextSize = 20
    opt.TextColor3 = Color3.fromRGB(255,255,255)
    opt.BorderSizePixel = 0
    opt.Parent = seedDropdownList
    opt.ZIndex = 14
    opt.MouseEnter:Connect(function()
        opt.Text = name .. "\n" .. (seedDetails[name] or "")
        opt.TextWrapped = true
    end)
    opt.MouseLeave:Connect(function()
        opt.Text = name
        opt.TextWrapped = false
    end)
    opt.MouseButton1Click:Connect(function()
        local found = false
        for j, v in ipairs(selectedSeed) do
            if v == name then table.remove(selectedSeed, j) found = true break end
        end
        if not found then table.insert(selectedSeed, name) end
        updateSeedDropdownText()
        opt.BackgroundColor3 = found and Color3.fromRGB(100, 170, 220) or Color3.fromRGB(60, 200, 120)
    end)
end
updateSeedDropdownText()
seedDropdownList.CanvasSize = UDim2.new(0, 0, 0, #seedOptions * 38)

-- Set all tab content children ZIndex to 22 (above contentFrame)
for _, frame in pairs(tabContent) do
    for _, child in ipairs(frame:GetChildren()) do
        if child:IsA("GuiObject") then
            child.ZIndex = 22
        end
    end
end

-- Ensure sidebar and tab buttons are always on top
sidebar.ZIndex = 20
for i, name in ipairs(tabNames) do
    local tabBtn = tabButtons[name]
    if tabBtn then
        tabBtn.ZIndex = 20
    end
end
-- Ensure content frame and tab content are above sidebar
contentFrame.ZIndex = 21
for _, frame in pairs(tabContent) do
    frame.ZIndex = 21
end

-- Reconnect tab button click events
local function selectTab(tabName)
    for name, btn in pairs(tabButtons) do
        btn.BackgroundColor3 = name == tabName and Color3.fromRGB(220, 160, 80) or Color3.fromRGB(80, 90, 110)
    end
    for name, frame in pairs(tabContent) do
        frame.Visible = (name == tabName)
    end
end
for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        selectTab(name)
    end)
end

-- FARM TAB CONTENT
local farmFrame = tabContent["FARM"]
local farmHeader = Instance.new("TextLabel")
farmHeader.Size = UDim2.new(1, -32, 0, 40)
farmHeader.Position = UDim2.new(0, 16, 0, 16)
farmHeader.BackgroundColor3 = Color3.fromRGB(40, 90, 180)
farmHeader.Text = "FARM MANAGER"
farmHeader.Font = Enum.Font.SourceSansBold
farmHeader.TextSize = 22
farmHeader.TextColor3 = Color3.fromRGB(255,255,255)
farmHeader.BorderSizePixel = 0
farmHeader.TextXAlignment = Enum.TextXAlignment.Center
farmHeader.Parent = farmFrame
farmHeader.ZIndex = 22

local farmToggle = Instance.new("TextButton")
farmToggle.Name = "FarmToggle"
farmToggle.Size = UDim2.new(1, -32, 0, 36)
farmToggle.Position = UDim2.new(0, 16, 0, 64)
farmToggle.BackgroundColor3 = Color3.fromRGB(60, 90, 130)
farmToggle.Text = "AUTO FARM:"
farmToggle.Font = Enum.Font.SourceSansBold
farmToggle.TextSize = 20
farmToggle.TextColor3 = Color3.fromRGB(255,255,255)
farmToggle.BorderSizePixel = 0
farmToggle.TextXAlignment = Enum.TextXAlignment.Left
farmToggle.Parent = farmFrame
farmToggle.ZIndex = 22

local farmCheck = Instance.new("TextLabel")
farmCheck.Name = "Checkmark"
farmCheck.Size = UDim2.new(0, 32, 1, 0)
farmCheck.Position = UDim2.new(1, -36, 0, 0)
farmCheck.BackgroundTransparency = 1
farmCheck.Font = Enum.Font.SourceSansBold
farmCheck.TextSize = 24
farmCheck.TextColor3 = Color3.fromRGB(220, 220, 220)
farmCheck.Text = ""
farmCheck.Parent = farmToggle
farmCheck.ZIndex = 23

local autoFarmState = false
local function updateFarmToggle()
    farmToggle.BackgroundColor3 = autoFarmState and Color3.fromRGB(40, 90, 180) or Color3.fromRGB(60, 90, 130)
    farmCheck.Text = autoFarmState and "✔" or ""
end
updateFarmToggle()
farmToggle.MouseButton1Click:Connect(function()
    autoFarmState = not autoFarmState
    updateFarmToggle()
end)
