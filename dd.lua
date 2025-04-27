-- Skrip ini merupakan gabungan ESP, teleportasi, UI scrollable & draggable, text broadcast, dan anti-ban

-- UI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "ESP_UI"

-- Toggle Button (Logo)
local logoBtn = Instance.new("ImageButton", ScreenGui)
logoBtn.Size = UDim2.new(0, 40, 0, 40)
logoBtn.Position = UDim2.new(0, 10, 0, 10)
logoBtn.BackgroundTransparency = 1
logoBtn.Image = "rbxassetid://6031091002"

-- Main Frame
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 300)
Frame.Position = UDim2.new(0, 60, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Visible = true

-- Drag support
local UIS = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos
local function update(input)
	if not dragging then return end
	local delta = input.Position - dragStart
	Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
Frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)
Frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)
UIS.InputChanged:Connect(function(input)
	if input == dragInput then
		update(input)
	end
end)

-- Scrollable UI
local scrollingFrame = Instance.new("ScrollingFrame", Frame)
scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
scrollingFrame.ScrollBarThickness = 6
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollingFrame.ScrollBarImageColor3 = Color3.new(1,1,1)


-- // GUI & ESP Setup
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "ESP_UI"

local logoBtn = Instance.new("ImageButton", ScreenGui)
logoBtn.Size = UDim2.new(0, 40, 0, 40)
logoBtn.Position = UDim2.new(0, 10, 0, 10)
logoBtn.BackgroundTransparency = 1
logoBtn.Image = "rbxassetid://6031091002"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 260)
Frame.Position = UDim2.new(0, 50, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Visible = true

local espToggle = Instance.new("TextButton", Frame)
espToggle.Size = UDim2.new(1, -20, 0, 40)
espToggle.Position = UDim2.new(0, 10, 0, 10)
espToggle.Text = "ESP: OFF"
espToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
espToggle.TextColor3 = Color3.fromRGB(255, 255, 255)

local hideUIButton = Instance.new("TextButton", Frame)
hideUIButton.Size = UDim2.new(1, -20, 0, 40)
hideUIButton.Position = UDim2.new(0, 10, 0, 60)
hideUIButton.Text = "Hide UI"
hideUIButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
hideUIButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local playerInput = Instance.new("TextBox", Frame)
playerInput.Size = UDim2.new(1, -20, 0, 30)
playerInput.Position = UDim2.new(0, 10, 0, 110)
playerInput.PlaceholderText = "Masukkan nama pemain"
playerInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
playerInput.TextColor3 = Color3.fromRGB(255, 255, 255)
playerInput.Text = ""

local teleportToPlayerButton = Instance.new("TextButton", Frame)
teleportToPlayerButton.Size = UDim2.new(1, -20, 0, 30)
teleportToPlayerButton.Position = UDim2.new(0, 10, 0, 145)
teleportToPlayerButton.Text = "Teleport ke Pemain"
teleportToPlayerButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
teleportToPlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local teleportPlayerToMeButton = Instance.new("TextButton", Frame)
teleportPlayerToMeButton.Size = UDim2.new(1, -20, 0, 30)
teleportPlayerToMeButton.Position = UDim2.new(0, 10, 0, 180)
teleportPlayerToMeButton.Text = "Teleport Pemain ke Saya"
teleportPlayerToMeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
teleportPlayerToMeButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- // ESP Core
local espEnabled = false
local espObjects = {}

function createESP(plr)
    if plr == LocalPlayer then return end
    local box = Drawing.new("Square")
    box.Color = Color3.new(1, 0, 0)
    box.Thickness = 1
    box.Transparency = 1
    box.Filled = false

    local nameTag = Drawing.new("Text")
    nameTag.Color = Color3.new(1, 1, 1)
    nameTag.Size = 16
    nameTag.Center = true
    nameTag.Outline = true
    nameTag.Font = 2

    espObjects[plr] = {Box = box, Name = nameTag}
end

function removeESP(plr)
    if espObjects[plr] then
        espObjects[plr].Box:Remove()
        espObjects[plr].Name:Remove()
        espObjects[plr] = nil
    end
end

for _, plr in ipairs(Players:GetPlayers()) do
    createESP(plr)
end
Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

RunService.RenderStepped:Connect(function()
    for plr, objs in pairs(espObjects) do
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")
        if espEnabled and hrp and head then
            local pos, visible = Camera:WorldToViewportPoint(hrp.Position)
            if visible then
                objs.Box.Size = Vector2.new(60, 100)
                objs.Box.Position = Vector2.new(pos.X - 30, pos.Y - 50)
                objs.Box.Visible = true

                objs.Name.Position = Vector2.new(pos.X, pos.Y - 60)
                objs.Name.Text = plr.Name
                objs.Name.Visible = true
            else
                objs.Box.Visible = false
                objs.Name.Visible = false
            end
        else
            objs.Box.Visible = false
            objs.Name.Visible = false
        end
    end
end)

-- // Button Actions
espToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espToggle.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
end)

hideUIButton.MouseButton1Click:Connect(function()
    Frame.Visible = false
end)

logoBtn.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)

-- // Drag UI
local dragging, dragInput, dragStart, startPos
local function update(input)
    if not dragging then return end
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput then
        update(input)
    end
end)

-- // Teleportation
local function findPlayerByName(partial)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Name:lower():find(partial:lower()) then
            return plr
        end
    end
end

teleportToPlayerButton.MouseButton1Click:Connect(function()
    local plr = findPlayerByName(playerInput.Text)
    if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character:MoveTo(plr.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0))
    end
end)

teleportPlayerToMeButton.MouseButton1Click:Connect(function()
    local plr = findPlayerByName(playerInput.Text)
    if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        plr.Character:MoveTo(LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0))
    end
end)

-- // Anti-Kick / Anti-Ban
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" or tostring(method):lower():find("kick") or tostring(method):lower():find("ban") then
        warn("❌ Kick/Ban Attempt Blocked!")
        return
    end
    return oldNamecall(self, ...)
end)

-- // Anti Log Event
local blockedEvents = {"SayMessageRequest", "LogService", "RemoteEvent", "RemoteFunction"}
for _, v in pairs(blockedEvents) do
    local suc, obj = pcall(function()
        return game:GetService("ReplicatedStorage"):FindFirstChild(v)
    end)
    if suc and obj then
        obj:Destroy()
        warn("🛡️ Blocked possible log sender:", v)
    end
end

-- // Admin Detection (Safe Mode)
function isSuspicious(plr)
    local name = plr.Name:lower()
    local disp = plr.DisplayName:lower()
    return name:find("admin") or name:find("mod") or name:find("staff") or disp:find("admin") or disp:find("mod")
end

function disableAllCheats()
    espEnabled = false
    Frame.Visible = false
    for _, obj in pairs(espObjects) do
        obj.Box:Remove()
        obj.Name:Remove()
    end
    espObjects = {}
    warn("❌ Cheats disabled for safety.")
end

for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer and isSuspicious(plr) then
        disableAllCheats()
    end
end

Players.PlayerAdded:Connect(function(plr)
    if isSuspicious(plr) then
        disableAllCheats()
    end
end)

-- // Optional Identity Spoofing
pcall(function()
    LocalPlayer.Name = "Guest" .. math.random(1000, 9999)
    LocalPlayer.DisplayName = "Noob_" .. math.random(10, 99)
end)

-- // Fake Crash
function fakeCrash()
    Frame.Visible = false
    for i = 1, 100 do
        task.spawn(function()
            while true do end
        end)
    end
end
