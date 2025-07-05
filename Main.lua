--[[
GROW A GARDEN AUTOMATION SCRIPT
Sidebar GUI by Bread | Delta Executor Compatible
]]

--// SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

--// REMOTE BINDING
local RemoteMap = {}
local function preloadRemotes()
    local remotes = {
        "SummerHarvestSubmitRemoteEvent",
        "BuyPetEgg",
        "BuySeedStock",
        "Plant_RE",
        "HarvestRemote",
        "Sprinkler_RE",
        "Water_RE",
        "TrowelRemote",
        "Sell_Inventory",
        "FireDrop",
        "BeeBolt"
    }
    for _, name in ipairs(remotes) do
        local remote = ReplicatedStorage:FindFirstChild("GameEvents") and ReplicatedStorage.GameEvents:FindFirstChild(name)
        if remote then
            RemoteMap[name] = remote
        end
    end
    -- Workspace InputGateway
    local ig = Workspace:FindFirstChild(LocalPlayer.Name) and Workspace[LocalPlayer.Name]:FindFirstChild("InputGateway")
    if ig and ig:FindFirstChild("Activation") then
        RemoteMap["Activation"] = ig.Activation
    end
end
preloadRemotes()

function FireRemote(name, ...)
    local remote = RemoteMap[name]
    if remote then
        pcall(function()
            remote:FireServer(...)
        end)
    end
end

--// UI COLORS & FONTS
local colors = {
    bg = Color3.fromRGB(40,40,40),
    sidebar = Color3.fromRGB(55,55,55),
    topbar = Color3.fromRGB(30,30,30),
    divider = Color3.fromRGB(80,80,80),
    selected = Color3.fromRGB(80,180,255),
    button = Color3.fromRGB(70,70,70),
    buttonHover = Color3.fromRGB(100,100,100),
    toggleOn = Color3.fromRGB(60,200,100),
    toggleOff = Color3.fromRGB(120,120,120),
    text = Color3.fromRGB(230,230,230),
    tooltip = Color3.fromRGB(30,30,30)
}
local font = Enum.Font.SourceSansBold

--// UI CREATION
local gui = Instance.new("ScreenGui")
gui.Name = "GAG_BREAD_GUI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Name = "MainFrame"
main.Size = UDim2.new(0,520,0,480)
main.Position = UDim2.new(0.5,-260,0.5,-240)
main.BackgroundColor3 = colors.bg
main.BorderSizePixel = 0
main.Visible = true
main.Parent = gui

local topbar = Instance.new("Frame")
topbar.Size = UDim2.new(1,0,0,40)
topbar.BackgroundColor3 = colors.topbar
topbar.BorderSizePixel = 0
topbar.Parent = main

local toplabel = Instance.new("TextLabel")
toplabel.Text = "GAG SCRIPT BY:BREAD"
toplabel.Font = font
toplabel.TextSize = 22
toplabel.TextColor3 = colors.text
toplabel.BackgroundTransparency = 1
toplabel.Size = UDim2.new(1,0,1,0)
toplabel.Parent = topbar

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0,120,1,-40)
sidebar.Position = UDim2.new(0,0,0,40)
sidebar.BackgroundColor3 = colors.sidebar
sidebar.BorderSizePixel = 0
sidebar.Parent = main

local divider = Instance.new("Frame")
divider.Size = UDim2.new(0,2,1,-40)
divider.Position = UDim2.new(0,120,0,40)
divider.BackgroundColor3 = colors.divider
divider.BorderSizePixel = 0
divider.Parent = main

local content = Instance.new("Frame")
content.Name = "ContentArea"
content.Size = UDim2.new(1,-122,1,-40)
content.Position = UDim2.new(0,122,0,40)
content.BackgroundTransparency = 1
content.Parent = main

-- Hide/Show Button
local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0,32,0,32)
hideBtn.Position = UDim2.new(1,-36,0,4)
hideBtn.BackgroundColor3 = colors.button
hideBtn.Text = "≡"
hideBtn.Font = font
hideBtn.TextSize = 20
hideBtn.TextColor3 = colors.text
hideBtn.Parent = topbar

local hidden = false
hideBtn.MouseButton1Click:Connect(function()
    hidden = not hidden
    main.Visible = not hidden
end)
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.LeftShift then
        hidden = not hidden
        main.Visible = not hidden
    end
end)

--// SIDEBAR BUTTONS
local tabs = {"EVENT","SHOP","FARM"}
local tabFrames = {}
local selectedTab = nil
local sidebarBtns = {}
for i,tab in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,48)
    btn.Position = UDim2.new(0,0,0,(i-1)*54+8)
    btn.BackgroundColor3 = colors.button
    btn.Text = tab
    btn.Font = font
    btn.TextSize = 20
    btn.TextColor3 = colors.text
    btn.AutoButtonColor = false
    btn.Parent = sidebar
    sidebarBtns[tab] = btn
    btn.MouseEnter:Connect(function()
        if selectedTab ~= tab then btn.BackgroundColor3 = colors.buttonHover end
    end)
    btn.MouseLeave:Connect(function()
        if selectedTab ~= tab then btn.BackgroundColor3 = colors.button end
    end)
    btn.MouseButton1Click:Connect(function()
        for _,b in pairs(sidebarBtns) do b.BackgroundColor3 = colors.button end
        btn.BackgroundColor3 = colors.selected
        for _,f in pairs(tabFrames) do f.Visible = false end
        tabFrames[tab].Visible = true
        selectedTab = tab
    end)
end

--// TAB FRAMES
for _,tab in ipairs(tabs) do
    local frame = Instance.new("Frame")
    frame.Name = tab.."Frame"
    frame.Size = UDim2.new(1,0,1,0)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.Parent = content
    tabFrames[tab] = frame
end
sidebarBtns["EVENT"].BackgroundColor3 = colors.selected
tabFrames["EVENT"].Visible = true
selectedTab = "EVENT"

--// EVENT TAB
local eventFrame = tabFrames["EVENT"]
local eventHeader = Instance.new("TextLabel")
eventHeader.Text = "SUMMER HARVEST"
eventHeader.Font = font
eventHeader.TextSize = 20
eventHeader.TextColor3 = colors.text
eventHeader.BackgroundTransparency = 1
eventHeader.Position = UDim2.new(0,16,0,16)
eventHeader.Size = UDim2.new(0,220,0,32)
eventHeader.Parent = eventFrame

local autoSubmit = false
local autoSubmitBtn = Instance.new("TextButton")
autoSubmitBtn.Size = UDim2.new(0,180,0,40)
autoSubmitBtn.Position = UDim2.new(0,16,0,60)
autoSubmitBtn.BackgroundColor3 = colors.button
autoSubmitBtn.Text = "AUTO SUBMIT"
autoSubmitBtn.Font = font
autoSubmitBtn.TextSize = 18
autoSubmitBtn.TextColor3 = colors.text
autoSubmitBtn.Parent = eventFrame

local check = Instance.new("TextLabel")
check.Size = UDim2.new(0,32,0,32)
check.Position = UDim2.new(0,160,0,4)
check.BackgroundTransparency = 1
check.Text = ""
check.Font = font
check.TextSize = 24
check.TextColor3 = colors.toggleOn
check.Parent = autoSubmitBtn

local function updateAutoSubmitVisual()
    if autoSubmit then
        autoSubmitBtn.BackgroundColor3 = colors.toggleOn
        check.Text = "✔"
    else
        autoSubmitBtn.BackgroundColor3 = colors.button
        check.Text = ""
    end
end
updateAutoSubmitVisual()
autoSubmitBtn.MouseButton1Click:Connect(function()
    autoSubmit = not autoSubmit
    updateAutoSubmitVisual()
end)

-- Auto Submit Loop
spawn(function()
    while true do
        if autoSubmit then
            FireRemote("SummerHarvestSubmitRemoteEvent")
        end
        task.wait(0.2)
    end
end)

--// SHOP TAB
local shopFrame = tabFrames["SHOP"]

-- Accurate Egg and Seed Data
local eggTypes = {
    {Name="Common Egg",Desc="50,000 | Golden Lab, Dog, Bunny (33.33% each)"},
    {Name="Uncommon Egg",Desc="150,000 | Black Bunny, Chicken, Cat, Deer (25% each)"},
    {Name="Rare Egg",Desc="600,000 | Orange Tabby, Spotted Deer, Pig, Rooster, Monkey"},
    {Name="Legendary Egg",Desc="3,000,000 | Cow, Silver Monkey, Sea Otter, Turtle, Polar Bear"},
    {Name="Mythical Egg",Desc="8,000,000 | Grey Mouse, Brown Mouse, Squirrel, Red Giant Ant, Red Fox"},
    {Name="Bug Egg",Desc="50,000,000 | Snail, Giant Ant, Caterpillar, Praying Mantis, Dragonfly"},
    {Name="Exotic Bug Egg",Desc="Limited Time Shop"},
    {Name="Night Egg",Desc="25M/50M | Hedgehog, Mole, Frog, Echo Frog, Night Owl, Raccoon"},
    {Name="Premium Night Egg",Desc="199 | Hedgehog, Mole, Frog, Echo Frog, Night Owl, Raccoon"},
    {Name="Bee Egg",Desc="18 | Bee, Honey Bee, Bear Bee, Petal Bee, Queen Bee"},
    {Name="Anti Bee Egg",Desc="Crafting | Wasp, Tarantula Hawk, Moth, Butterfly, Disco Bee"},
    {Name="Premium Anti Bee Egg",Desc="199 | Limited Time Shop"},
    {Name="Common Summer Egg",Desc="1,000,000 | Starfish, Seagull, Crab"},
    {Name="Rare Summer Egg",Desc="25,000,000 | Flamingo, Toucan, Sea Turtle, Orangutan, Seal"},
    {Name="Paradise Egg",Desc="50,000,000 | Ostrich, Peacock, Capybara, Scarlet Macaw, Mimic Octopus"},
    {Name="Oasis Egg",Desc="10 | Meerkat, Sand Snake, Axolotl, Hyacinth Macaw, Fennec Fox"},
    {Name="Premium Oasis Egg",Desc="199 | Limited Time Shop"}
}
local seedTypes = {
    {Name="Carrot",Desc="10 | Common | 5-25 | ✗/✓"},
    {Name="Strawberry",Desc="50 | Common | 1-6 | ✓/✓"},
    {Name="Blueberry",Desc="400 | Uncommon | 1-5 | ✓/✓"},
    {Name="Tomato",Desc="800 | Rare | 1-3 | ✓/✓"},
    {Name="Cauliflower",Desc="1,300 | Rare | 1-4 | ✓/✓"},
    {Name="Watermelon",Desc="2,500 | Rare | 1-7 | ✗/✓"},
    {Name="Rafflesia",Desc="3,200 | Legendary | 1-? | ✗/✓"},
    {Name="Green Apple",Desc="3,500 | Legendary | 1 | ✓/✓"},
    {Name="Avocado",Desc="5,000 | Legendary | 1 | ✓/✓"},
    {Name="Banana",Desc="7,000 | Legendary | 1 | ✓/✓"},
    {Name="Pineapple",Desc="7,500 | Mythical | 1 | ✓/✓"},
    {Name="Kiwi",Desc="10,000 | Mythical | 1 | ✓/✓"},
    {Name="Bell Pepper",Desc="55,000 | Mythical | 1 | ✓/✓"},
    {Name="Prickly Pear",Desc="555,000 | Mythical | 1 | ✓/✓"},
    {Name="Loquat",Desc="900,000 | Divine | 1 | ✓/✓"},
    {Name="Feijoa",Desc="2,750,000 | Divine | 1 | ✓/✓"},
    {Name="Pitcher Plant",Desc="7,500,000 | Divine | 1 | ✓/✓"},
    {Name="Sugar Apple",Desc="25,000,000 | Prismatic | 1"}
}

-- Dropdown utility
local function createDropdown(parent, label, list, onSelect)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,200,0,36)
    btn.BackgroundColor3 = colors.button
    btn.Text = label
    btn.Font = font
    btn.TextSize = 18
    btn.TextColor3 = colors.text
    btn.Parent = parent
    local drop = Instance.new("Frame")
    drop.Size = UDim2.new(0,200,0,0)
    drop.Position = UDim2.new(0,0,1,0)
    drop.BackgroundColor3 = colors.bg
    drop.BorderSizePixel = 0
    drop.Visible = false
    drop.Parent = btn
    local layout = Instance.new("UIListLayout")
    layout.Parent = drop
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    local tooltip = Instance.new("TextLabel")
    tooltip.Size = UDim2.new(0,180,0,24)
    tooltip.Position = UDim2.new(0,10,0,0)
    tooltip.BackgroundColor3 = colors.tooltip
    tooltip.TextColor3 = colors.text
    tooltip.Font = font
    tooltip.TextSize = 14
    tooltip.BackgroundTransparency = 0.2
    tooltip.Visible = false
    tooltip.Parent = btn
    local selected = 1
    local function updateBtn()
        btn.Text = label..": "..list[selected].Name
    end
    updateBtn()
    btn.MouseButton1Click:Connect(function()
        drop.Visible = not drop.Visible
        drop.Size = drop.Visible and UDim2.new(0,200,0,#list*28) or UDim2.new(0,200,0,0)
    end)
    for i,entry in ipairs(list) do
        local opt = Instance.new("TextButton")
        opt.Size = UDim2.new(1,0,0,28)
        opt.BackgroundColor3 = colors.button
        opt.Text = entry.Name
        opt.Font = font
        opt.TextSize = 16
        opt.TextColor3 = colors.text
        opt.Parent = drop
        opt.MouseEnter:Connect(function()
            opt.BackgroundColor3 = colors.buttonHover
            tooltip.Text = entry.Desc
            tooltip.Visible = true
        end)
        opt.MouseLeave:Connect(function()
            opt.BackgroundColor3 = colors.button
            tooltip.Visible = false
        end)
        opt.MouseButton1Click:Connect(function()
            selected = i
            updateBtn()
            drop.Visible = false
            drop.Size = UDim2.new(0,200,0,0)
            if onSelect then onSelect(i, entry) end
        end)
    end
    return btn, function() return list[selected].Name end
end

local shopY = 24
local eggBtn, getEgg = createDropdown(shopFrame, "BUY EGG", eggTypes)
eggBtn.Position = UDim2.new(0,16,0,shopY)
local seedBtn, getSeed = createDropdown(shopFrame, "BUY SEED", seedTypes)
seedBtn.Position = UDim2.new(0,240,0,shopY)

local autoBuyEgg = false
local autoBuySeed = false
local autoBuyEggBtn = Instance.new("TextButton")
autoBuyEggBtn.Size = UDim2.new(0,180,0,36)
autoBuyEggBtn.Position = UDim2.new(0,16,0,shopY+56)
autoBuyEggBtn.BackgroundColor3 = colors.button
autoBuyEggBtn.Text = "AUTO BUY EGG"
autoBuyEggBtn.Font = font
autoBuyEggBtn.TextSize = 18
autoBuyEggBtn.TextColor3 = colors.text
autoBuyEggBtn.Parent = shopFrame
local eggCheck = Instance.new("TextLabel")
eggCheck.Size = UDim2.new(0,32,0,32)
eggCheck.Position = UDim2.new(0,140,0,2)
eggCheck.BackgroundTransparency = 1
eggCheck.Text = ""
eggCheck.Font = font
eggCheck.TextSize = 24
eggCheck.TextColor3 = colors.toggleOn
eggCheck.Parent = autoBuyEggBtn
local function updateAutoBuyEggVisual()
    if autoBuyEgg then
        autoBuyEggBtn.BackgroundColor3 = colors.toggleOn
        eggCheck.Text = "✔"
    else
        autoBuyEggBtn.BackgroundColor3 = colors.button
        eggCheck.Text = ""
    end
end
updateAutoBuyEggVisual()
autoBuyEggBtn.MouseButton1Click:Connect(function()
    autoBuyEgg = not autoBuyEgg
    updateAutoBuyEggVisual()
end)

local autoBuySeedBtn = Instance.new("TextButton")
autoBuySeedBtn.Size = UDim2.new(0,180,0,36)
autoBuySeedBtn.Position = UDim2.new(0,240,0,shopY+56)
autoBuySeedBtn.BackgroundColor3 = colors.button
autoBuySeedBtn.Text = "AUTO BUY SEED"
autoBuySeedBtn.Font = font
autoBuySeedBtn.TextSize = 18
autoBuySeedBtn.TextColor3 = colors.text
autoBuySeedBtn.Parent = shopFrame
local seedCheck = Instance.new("TextLabel")
seedCheck.Size = UDim2.new(0,32,0,32)
seedCheck.Position = UDim2.new(0,140,0,2)
seedCheck.BackgroundTransparency = 1
seedCheck.Text = ""
seedCheck.Font = font
seedCheck.TextSize = 24
seedCheck.TextColor3 = colors.toggleOn
seedCheck.Parent = autoBuySeedBtn
local function updateAutoBuySeedVisual()
    if autoBuySeed then
        autoBuySeedBtn.BackgroundColor3 = colors.toggleOn
        seedCheck.Text = "✔"
    else
        autoBuySeedBtn.BackgroundColor3 = colors.button
        seedCheck.Text = ""
    end
end
updateAutoBuySeedVisual()
autoBuySeedBtn.MouseButton1Click:Connect(function()
    autoBuySeed = not autoBuySeed
    updateAutoBuySeedVisual()
end)

spawn(function()
    while true do
        if autoBuyEgg then
            FireRemote("BuyPetEgg", getEgg())
        end
        if autoBuySeed then
            FireRemote("BuySeedStock", getSeed())
        end
        task.wait(0.1)
    end
end)

--// FARM TAB
local farmFrame = tabFrames["FARM"]
local plantTypes = {
    {Name="Basic Plant",Desc="Common."},
    {Name="Rare Plant",Desc="Better."},
    {Name="Epic Plant",Desc="Even better!"},
    {Name="Legendary Plant",Desc="Top tier."},
    {Name="Mythic Plant",Desc="Ultra rare."}
}
local plantBtn, getPlant = createDropdown(farmFrame, "PLANT", plantTypes)
plantBtn.Position = UDim2.new(0,16,0,24)

local farmToggles = {
    {name="Auto Plant",remote="Plant_RE"},
    {name="Auto Harvest",remote="HarvestRemote"},
    {name="Auto Sprinkler",remote="Sprinkler_RE"},
    {name="Auto Water",remote="Water_RE"},
    {name="Auto Trowel",remote="TrowelRemote"},
    {name="Auto Sell Inventory",remote="Sell_Inventory"},
    {name="Auto FireDrop",remote="FireDrop"},
    {name="Auto BeeBolt Attack",remote="BeeBolt"}
}
local toggleStates = {}
local toggleBtns = {}
local y = 80
for i,t in ipairs(farmToggles) do
    toggleStates[t.name] = false
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,200,0,36)
    btn.Position = UDim2.new(0,16,0,y)
    btn.BackgroundColor3 = colors.button
    btn.Text = t.name
    btn.Font = font
    btn.TextSize = 18
    btn.TextColor3 = colors.text
    btn.Parent = farmFrame
    local check = Instance.new("TextLabel")
    check.Size = UDim2.new(0,32,0,32)
    check.Position = UDim2.new(0,140,0,2)
    check.BackgroundTransparency = 1
    check.Text = ""
    check.Font = font
    check.TextSize = 24
    check.TextColor3 = colors.toggleOn
    check.Parent = btn
    local function update()
        if toggleStates[t.name] then
            btn.BackgroundColor3 = colors.toggleOn
            check.Text = "✔"
        else
            btn.BackgroundColor3 = colors.button
            check.Text = ""
        end
    end
    update()
    btn.MouseButton1Click:Connect(function()
        toggleStates[t.name] = not toggleStates[t.name]
        update()
    end)
    toggleBtns[t.name] = btn
    y = y + 44
end

spawn(function()
    while true do
        for _,t in ipairs(farmToggles) do
            if toggleStates[t.name] then
                if t.remote == "Plant_RE" then
                    FireRemote(t.remote, getPlant())
                else
                    FireRemote(t.remote)
                end
            end
        end
        task.wait(0.1)
    end
end)

--// END OF SCRIPT
