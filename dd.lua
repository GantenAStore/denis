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

-- ESP Toggle
local espToggle = Instance.new("TextButton", scrollingFrame)
espToggle.Size = UDim2.new(1, -20, 0, 40)
espToggle.Position = UDim2.new(0, 10, 0, 10)
espToggle.Text = "ESP: OFF"
espToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
espToggle.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Hide UI Button
local hideUIButton = Instance.new("TextButton", scrollingFrame)
hideUIButton.Size = UDim2.new(1, -20, 0, 40)
hideUIButton.Position = UDim2.new(0, 10, 0, 60)
hideUIButton.Text = "Hide UI"
hideUIButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
hideUIButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- TextBox
local playerInput = Instance.new("TextBox", scrollingFrame)
playerInput.Size = UDim2.new(1, -20, 0, 30)
playerInput.Position = UDim2.new(0, 10, 0, 110)
playerInput.PlaceholderText = "Masukkan nama pemain"
playerInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
playerInput.TextColor3 = Color3.fromRGB(255, 255, 255)
playerInput.Text = ""

-- Teleport Buttons
local teleportToPlayerButton = Instance.new("TextButton", scrollingFrame)
teleportToPlayerButton.Size = UDim2.new(1, -20, 0, 30)
teleportToPlayerButton.Position = UDim2.new(0, 10, 0, 145)
teleportToPlayerButton.Text = "Teleport ke Pemain"
teleportToPlayerButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
teleportToPlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local teleportPlayerToMeButton = Instance.new("TextButton", scrollingFrame)
teleportPlayerToMeButton.Size = UDim2.new(1, -20, 0, 30)
teleportPlayerToMeButton.Position = UDim2.new(0, 10, 0, 180)
teleportPlayerToMeButton.Text = "Teleport Pemain ke Saya"
teleportPlayerToMeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
teleportPlayerToMeButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Broadcast TextBox
local broadcastBox = Instance.new("TextBox", scrollingFrame)
broadcastBox.Size = UDim2.new(1, -20, 0, 30)
broadcastBox.Position = UDim2.new(0, 10, 0, 220)
broadcastBox.PlaceholderText = "Tulis pesan untuk semua"
broadcastBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
broadcastBox.TextColor3 = Color3.fromRGB(255, 255, 255)
broadcastBox.Text = ""

local broadcastBtn = Instance.new("TextButton", scrollingFrame)
broadcastBtn.Size = UDim2.new(1, -20, 0, 30)
broadcastBtn.Position = UDim2.new(0, 10, 0, 255)
broadcastBtn.Text = "Kirim Pesan"
broadcastBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
broadcastBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Broadcast UI Global
local broadcastFrame = Instance.new("Frame", ScreenGui)
broadcastFrame.Size = UDim2.new(1, 0, 0, 30)
broadcastFrame.Position = UDim2.new(0, 0, 0, 0)
broadcastFrame.BackgroundTransparency = 1 -- Membuat frame transparan total
broadcastFrame.Visible = true

local broadcastLabel = Instance.new("TextLabel", broadcastFrame)
broadcastLabel.Size = UDim2.new(1, 0, 1, 0)
broadcastLabel.BackgroundTransparency = 1 -- Label juga transparan
broadcastLabel.TextColor3 = Color3.new(1, 1, 1)
broadcastLabel.Font = Enum.Font.SourceSansBold
broadcastLabel.TextScaled = true
broadcastLabel.TextStrokeTransparency = 0.4 -- Tambah outline biar tetap kebaca
broadcastLabel.Text = ""


broadcastBtn.MouseButton1Click:Connect(function()
	broadcastLabel.Text = broadcastBox.Text
	broadcastBox.Text = ""
end)

-- Toggle ESP
local espEnabled = false
local espObjects = {}
function createESP(plr)
	if plr == game.Players.LocalPlayer then return end
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
for _, player in ipairs(game.Players:GetPlayers()) do createESP(player) end
game.Players.PlayerAdded:Connect(createESP)
game.Players.PlayerRemoving:Connect(removeESP)
game:GetService("RunService").RenderStepped:Connect(function()
	if not espEnabled then
		for _, v in pairs(espObjects) do v.Box.Visible = false v.Name.Visible = false end return
	end
	for plr, objs in pairs(espObjects) do
		if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local pos, visible = workspace.CurrentCamera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
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
		end
	end
end)
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

-- Teleport Functions
teleportToPlayerButton.MouseButton1Click:Connect(function()
	local name = playerInput.Text
	for _, p in pairs(game.Players:GetPlayers()) do
		if p.Name:lower():find(name:lower()) then
			if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				game.Players.LocalPlayer.Character:MoveTo(p.Character.HumanoidRootPart.Position + Vector3.new(0,3,0))
			end
			break
		end
	end
end)
teleportPlayerToMeButton.MouseButton1Click:Connect(function()
	local name = playerInput.Text
	for _, p in pairs(game.Players:GetPlayers()) do
		if p.Name:lower():find(name:lower()) then
			if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				p.Character:MoveTo(game.Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0,3,0))
			end
			break
		end
	end
end)

-- Anti Kick/Ban, Anti Log, Anti Admin
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall
mt.__namecall = newcclosure(function(self,...)
	if getnamecallmethod():lower():find("kick") then
		warn("❌ Kick attempt blocked!")
		return
	end
	return old(self,...)
end)
local blocked = {"SayMessageRequest", "LogService", "RemoteEvent", "RemoteFunction"}
for _, v in pairs(blocked) do
	local s, r = pcall(function()
		return game:GetService("ReplicatedStorage"):FindFirstChild(v)
	end)
	if s and r then r:Destroy() end
end
function isMod(p)
	local n = p.Name:lower()
	local d = p.DisplayName:lower()
	return n:find("admin") or n:find("mod") or d:find("admin") or d:find("mod")
end
function disable()
	Frame.Visible = false
	warn("❌ UI Disabled due to mod detection")
end
for _, p in pairs(game.Players:GetPlayers()) do if p~=game.Players.LocalPlayer and isMod(p) then disable() end end
game.Players.PlayerAdded:Connect(function(p) if isMod(p) then disable() end end)
