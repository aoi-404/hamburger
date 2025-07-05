local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

--// GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GAGScriptUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 500)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(60, 70, 90)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 60, 1, 0)
Sidebar.Position = UDim2.new(0, 0, 0, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local CategoryList = {
    {Name="Farm", Icon="🌾"},
    {Name="Shop", Icon="🛒"},
    {Name="Events", Icon="🎉"},
    {Name="Pets", Icon="🐾"},
    {Name="Utility", Icon="🧰"},
    {Name="Special", Icon="🧬"},
}

local Panels = {}
local SidebarButtons = {}

--// Utility: Switch Panel
local function switchPanel(name)
    for cat, panel in pairs(Panels) do
        panel.Visible = (cat == name)
    end
    for cat, btn in pairs(SidebarButtons) do
        btn.BackgroundColor3 = cat == name and Color3.fromRGB(200, 160, 80) or Color3.fromRGB(40, 40, 40)
    end
end

--// Sidebar Buttons
for i, cat in ipairs(CategoryList) do
    local btn = Instance.new("TextButton")
    btn.Name = cat.Name .. "Btn"
    btn.Size = UDim2.new(1, 0, 0, 60)
    btn.Position = UDim2.new(0, 0, 0, (i-1)*60)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = cat.Icon .. "\n" .. cat.Name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 18
    btn.Font = Enum.Font.SourceSansBold
    btn.AutoButtonColor = true
    btn.Parent = Sidebar
    SidebarButtons[cat.Name] = btn
    btn.MouseButton1Click:Connect(function()
        switchPanel(cat.Name)
    end)
end

--// Right Panels
for _, cat in ipairs(CategoryList) do
    local panel = Instance.new("Frame")
    panel.Name = cat.Name .. "Panel"
    panel.Size = UDim2.new(1, -60, 1, 0)
    panel.Position = UDim2.new(0, 60, 0, 0)
    panel.BackgroundColor3 = Color3.fromRGB(80, 90, 110)
    panel.BorderSizePixel = 0
    panel.Visible = false
    panel.Parent = MainFrame
    Panels[cat.Name] = panel
end
Panels["Farm"].Visible = true -- Default

--// Remote Binding
local RemoteMap = {}
local function bindAllRemotes()
    local function safeBind(tbl, name)
        local ok, remote = pcall(function() return tbl:FindFirstChild(name) end)
        if ok and remote then RemoteMap[name] = remote end
    end
    -- ReplicatedStorage.GameEvents
    local GE = ReplicatedStorage:FindFirstChild("GameEvents")
    if GE then
        for _, obj in ipairs(GE:GetChildren()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                RemoteMap[obj.Name] = obj
            end
        end
    end
    -- Workspace Remotes
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            RemoteMap[obj.Name] = obj
        end
    end
end
bindAllRemotes()

--// Safe Remote Firing
local function FireRemote(name, ...)
    local remote = RemoteMap[name]
    if remote then
        pcall(function()
            if remote:IsA("RemoteEvent") then
                remote:FireServer(...)
            elseif remote:IsA("RemoteFunction") then
                remote:InvokeServer(...)
            end
        end)
    end
end

--// Toggle Utility
local ToggleConnections = {}
local function createToggle(name, parent, callback)
    local toggle = Instance.new("BoolValue")
    toggle.Name = name
    toggle.Value = false

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 36)
    btn.Position = UDim2.new(0, 10, 0, #parent:GetChildren()*40)
    btn.BackgroundColor3 = Color3.fromRGB(60, 120, 220)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 18
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = name
    btn.Parent = parent

    local check = Instance.new("TextLabel")
    check.Size = UDim2.new(0, 24, 0, 24)
    check.Position = UDim2.new(1, -34, 0.5, -12)
    check.BackgroundTransparency = 1
    check.Text = "✔️"
    check.TextColor3 = Color3.fromRGB(80, 255, 80)
    check.TextSize = 20
    check.Visible = false
    check.Parent = btn

    btn.MouseButton1Click:Connect(function()
        toggle.Value = not toggle.Value
        check.Visible = toggle.Value
        btn.BackgroundColor3 = toggle.Value and Color3.fromRGB(80, 180, 80) or Color3.fromRGB(60, 120, 220)
    end)

    -- Heartbeat loop
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if toggle.Value then
            callback()
        end
    end)
    ToggleConnections[#ToggleConnections+1] = conn

    return toggle
end

--// Clean-up on GUI removal
ScreenGui.AncestryChanged:Connect(function(_, parent)
    if not parent then
        for _, conn in ipairs(ToggleConnections) do
            if conn and conn.Disconnect then conn:Disconnect() end
        end
    end
end)

--// FARM PANEL TOGGLES
createToggle("Auto Plant", Panels["Farm"], function()
    FireRemote("Plant_RE")
end)
createToggle("Auto Water", Panels["Farm"], function()
    FireRemote("Water_RE")
end)
createToggle("Auto Trowel", Panels["Farm"], function()
    FireRemote("TrowelRemote")
end)
createToggle("Auto Sprinkler", Panels["Farm"], function()
    FireRemote("Sprinkler_RE")
end)
createToggle("Auto Harvest", Panels["Farm"], function()
    FireRemote("HarvestRemote")
end)
createToggle("Auto Sell Inventory", Panels["Farm"], function()
    FireRemote("Sell_Inventory")
end)
createToggle("Auto Sell Item", Panels["Farm"], function()
    FireRemote("Sell_Item")
end)
createToggle("Auto BeeBolt", Panels["Farm"], function()
    FireRemote("BeeBolt")
end)
createToggle("Auto FireDrop", Panels["Farm"], function()
    FireRemote("FireDrop")
end)
createToggle("Auto Spawn Collectable Seeds", Panels["Farm"], function()
    FireRemote("SpawnCollectableSeed")
end)
createToggle("Auto MeteorShower", Panels["Farm"], function()
    FireRemote("MeteorShower")
end)

--// SHOP PANEL TOGGLES
createToggle("Auto Buy Pet Egg", Panels["Shop"], function()
    FireRemote("BuyPetEgg")
end)
createToggle("Auto Buy Seed", Panels["Shop"], function()
    FireRemote("BuySeedStock")
end)
createToggle("Auto Buy Gear", Panels["Shop"], function()
    FireRemote("BuyGearStock")
end)
createToggle("Auto Buy Summer Stock", Panels["Shop"], function()
    FireRemote("BuySummerStock")
end)
createToggle("Auto Buy Night Stock", Panels["Shop"], function()
    FireRemote("BuyNightStock")
end)
createToggle("Auto Buy Easter Stock", Panels["Shop"], function()
    FireRemote("BuyEasterStock")
end)
createToggle("Auto Buy Traveling Merchant", Panels["Shop"], function()
    FireRemote("BuyTravelingMerchantStock")
end)
createToggle("Auto Buy Cosmetic Crate", Panels["Shop"], function()
    FireRemote("BuyCosmeticCrate")
end)
createToggle("Auto Buy Cosmetic Item", Panels["Shop"], function()
    FireRemote("BuyCosmeticItem")
end)

--// EVENTS PANEL TOGGLES
createToggle("Auto RSVP", Panels["Events"], function()
    FireRemote("PromptRSVP")
end)
createToggle("Auto Summer Harvest Submit", Panels["Events"], function()
    FireRemote("SummerHarvestSubmit")
end)
createToggle("Auto Summer Harvest Reward", Panels["Events"], function()
    FireRemote("SummerHarvestReward")
end)
createToggle("Auto Cutscenes", Panels["Events"], function()
    FireRemote("Start_Cutscene")
end)
createToggle("Auto Disco Effects", Panels["Events"], function()
    FireRemote("DiscoSetColor_RE")
end)
createToggle("Auto Lightning Strike", Panels["Events"], function()
    FireRemote("LightningBolt")
end)
createToggle("Auto Fireworks", Panels["Events"], function()
    FireRemote("FireworkLaunch")
    FireRemote("FireworkVisual")
end)
createToggle("Auto StarCaller", Panels["Events"], function()
    FireRemote("StarCaller")
end)
createToggle("Auto Night Quest", Panels["Events"], function()
    FireRemote("NightQuest")
end)

--// PETS PANEL TOGGLES
createToggle("Auto Hatch Pet Egg", Panels["Pets"], function()
    FireRemote("EggReadyToHatch_RE")
end)
createToggle("Auto Gift Pet", Panels["Pets"], function()
    FireRemote("GiftPet")
end)
createToggle("Auto Accept Gift", Panels["Pets"], function()
    FireRemote("AcceptPetGift")
end)
createToggle("Auto Sell Pet", Panels["Pets"], function()
    FireRemote("SellPet_RE")
end)
createToggle("Auto Unlock Slot", Panels["Pets"], function()
    FireRemote("UnlockSlotFromPet")
end)
createToggle("Auto Pet Zone Ability", Panels["Pets"], function()
    FireRemote("PetZoneAbility")
end)
createToggle("Auto Refresh Pet UI", Panels["Pets"], function()
    FireRemote("RefreshPetUI")
end)

--// UTILITY PANEL TOGGLES
createToggle("Anti-AFK", Panels["Utility"], function()
    -- Simulate input to prevent AFK kick
    local VirtualUser = game:GetService("VirtualUser")
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)
createToggle("Auto Sort Backpack", Panels["Utility"], function()
    FireRemote("SortBackpackEvent")
end)
createToggle("Auto Craft Item", Panels["Utility"], function()
    FireRemote("CraftingGlobalObjectService")
end)
createToggle("Auto Claim Code", Panels["Utility"], function()
    FireRemote("ClaimableCodeService")
end)
createToggle("Auto Starter Pack", Panels["Utility"], function()
    FireRemote("PromptStarterPack")
end)
createToggle("Auto Prompt Friend", Panels["Utility"], function()
    FireRemote("Prompt_Friend")
end)
createToggle("Auto Notifications", Panels["Utility"], function()
    FireRemote("Notification")
end)
createToggle("Auto Chat", Panels["Utility"], function()
    FireRemote("DisplayChatMessage")
end)
createToggle("Auto PlaySound", Panels["Utility"], function()
    FireRemote("PlaySound")
end)

--// SPECIAL PANEL TOGGLES
createToggle("Auto InputGateway Activation", Panels["Special"], function()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == "InputGateway" and obj:FindFirstChild("Activation") then
            pcall(function() obj.Activation:FireServer() end)
        end
    end
end)
createToggle("Auto Enable Top Frame", Panels["Special"], function()
    FireRemote("Enable_Top_Frame")
end)
createToggle("Auto Spawn Arrow", Panels["Special"], function()
    FireRemote("Spawn_Arrow")
end)
createToggle("Auto DeveloperPurchase", Panels["Special"], function()
    FireRemote("DeveloperPurchase")
end)
createToggle("Remote Debugging", Panels["Special"], function()
    FireRemote("GameAnalyticsError")
    FireRemote("ByteNetReliable")
end)
createToggle("Toggle Clean Item", Panels["Special"], function()
    FireRemote("CleanItem")
end)
createToggle("Toggle Remove Object", Panels["Special"], function()
    FireRemote("RemoveObject")
end)

--// End of Script
