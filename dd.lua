-- UI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "ESP_UI"

-- Toggle Button (Logo)
local logoBtn = Instance.new("ImageButton", ScreenGui)
logoBtn.Size = UDim2.new(0, 40, 0, 40)
logoBtn.Position = UDim2.new(0, 10, 0, 10)
logoBtn.BackgroundTransparency = 1
logoBtn.Image = "rbxassetid://6031091002" -- Ganti dengan ID gambar yang kamu mau

-- Main Frame
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 260)
Frame.Position = UDim2.new(0, 50, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Visible = true

-- ESP Toggle Button
local espToggle = Instance.new("TextButton", Frame)
espToggle.Size = UDim2.new(1, -20, 0, 40)
espToggle.Position = UDim2.new(0, 10, 0, 10)
espToggle.Text = "ESP: OFF"
espToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
espToggle.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Hide UI Button
local hideUIButton = Instance.new("TextButton", Frame)
hideUIButton.Size = UDim2.new(1, -20, 0, 40)
hideUIButton.Position = UDim2.new(0, 10, 0, 60)
hideUIButton.Text = "Hide UI"
hideUIButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
hideUIButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- ESP Logic
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

for _, player in ipairs(game.Players:GetPlayers()) do
    createESP(player)
end

game.Players.PlayerAdded:Connect(createESP)
game.Players.PlayerRemoving:Connect(removeESP)

game:GetService("RunService").RenderStepped:Connect(function()
    if not espEnabled then
        for _, v in pairs(espObjects) do
            v.Box.Visible = false
            v.Name.Visible = false
        end
        return
    end

    for plr, objs in pairs(espObjects) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local pos, visible = workspace.CurrentCamera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
            if visible then
                local head = plr.Character:FindFirstChild("Head")
                local root = plr.Character:FindFirstChild("HumanoidRootPart")
                if head and root then
                    objs.Box.Size = Vector2.new(60, 100)
                    objs.Box.Position = Vector2.new(pos.X - 30, pos.Y - 50)
                    objs.Box.Visible = true

                    objs.Name.Position = Vector2.new(pos.X, pos.Y - 60)
                    objs.Name.Text = plr.Name
                    objs.Name.Visible = true
                end
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

-- Button Behavior
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

-- TextBox untuk mengetik nama player
local playerInput = Instance.new("TextBox", Frame)
playerInput.Size = UDim2.new(1, -20, 0, 30)
playerInput.Position = UDim2.new(0, 10, 0, 110)
playerInput.PlaceholderText = "Masukkan nama pemain"
playerInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
playerInput.TextColor3 = Color3.fromRGB(255, 255, 255)
playerInput.Text = ""

-- Tombol Teleport ke Pemain
local teleportToPlayerButton = Instance.new("TextButton", Frame)
teleportToPlayerButton.Size = UDim2.new(1, -20, 0, 30)
teleportToPlayerButton.Position = UDim2.new(0, 10, 0, 145)
teleportToPlayerButton.Text = "Teleport ke Pemain"
teleportToPlayerButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
teleportToPlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Tombol Teleport Pemain ke Saya
local teleportPlayerToMeButton = Instance.new("TextButton", Frame)
teleportPlayerToMeButton.Size = UDim2.new(1, -20, 0, 30)
teleportPlayerToMeButton.Position = UDim2.new(0, 10, 0, 180)
teleportPlayerToMeButton.Text = "Teleport Pemain ke Saya"
teleportPlayerToMeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
teleportPlayerToMeButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Fungsi Teleport ke Pemain yang Ditulis Namanya
teleportToPlayerButton.MouseButton1Click:Connect(function()
	local targetName = playerInput.Text
	if targetName == "" then return end

	local foundPlayer = nil
	for _, plr in pairs(game.Players:GetPlayers()) do
		-- Mencocokkan nama sebagian
		if plr.Name:lower():find(targetName:lower()) then
			foundPlayer = plr
			break
		end
	end

	if foundPlayer and foundPlayer.Character and foundPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local targetPos = foundPlayer.Character.HumanoidRootPart.Position
		local myChar = game.Players.LocalPlayer.Character
		if myChar and myChar:FindFirstChild("HumanoidRootPart") then
			-- Teleport ke pemain yang dipilih
			myChar:MoveTo(targetPos + Vector3.new(0, 3, 0)) -- Sedikit di atas supaya tidak nyangkut
		end
	else
		warn("Pemain tidak ditemukan atau tidak valid.")
	end
end)

-- Fungsi Teleport Pemain ke Posisi Saya
teleportPlayerToMeButton.MouseButton1Click:Connect(function()
	local targetName = playerInput.Text
	if targetName == "" then return end

	local foundPlayer = nil
	for _, plr in pairs(game.Players:GetPlayers()) do
		-- Mencocokkan nama sebagian
		if plr.Name:lower():find(targetName:lower()) then
			foundPlayer = plr
			break
		end
	end

	if foundPlayer and foundPlayer.Character and foundPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local targetPos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
		local plrChar = foundPlayer.Character
		if plrChar and plrChar:FindFirstChild("HumanoidRootPart") then
			-- Teleport pemain ke posisi saya
			plrChar:MoveTo(targetPos + Vector3.new(0, 3, 0)) -- Sedikit di atas supaya tidak nyangkut
		end
	else
		warn("Pemain tidak ditemukan atau tidak valid.")
	end
end)

-- // 1. Menampilkan teks di layar
local textDisplay = nil -- Variabel untuk menampung teks yang akan ditampilkan

-- Fungsi untuk menampilkan teks di atas semua pemain
local function displayTextForAllPlayers(text)
    if textDisplay then
        -- Hapus teks sebelumnya jika ada
        textDisplay:Remove()
    end
    
    textDisplay = Drawing.new("Text")
    textDisplay.Text = text
    textDisplay.Color = Color3.fromRGB(255, 255, 255)
    textDisplay.Size = 30
    textDisplay.Center = true
    textDisplay.Outline = true
    textDisplay.Font = 2
end

-- Tombol untuk mengubah teks yang ditampilkan
local textInputButton = Instance.new("TextButton", Frame)
textInputButton.Size = UDim2.new(1, -20, 0, 30)
textInputButton.Position = UDim2.new(0, 10, 0, 215)
textInputButton.Text = "Tampilkan Teks"
textInputButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
textInputButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Tombol untuk mendapatkan teks dari TextBox dan menampilkannya
textInputButton.MouseButton1Click:Connect(function()
    local textToDisplay = playerInput.Text -- Ambil teks dari TextBox
    if textToDisplay ~= "" then
        displayTextForAllPlayers(textToDisplay) -- Panggil fungsi untuk menampilkan teks
    end
end)

-- // 2. Menampilkan teks untuk setiap pemain
game:GetService("RunService").RenderStepped:Connect(function()
    if textDisplay then
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local pos, visible = workspace.CurrentCamera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
                if visible then
                    textDisplay.Position = Vector2.new(pos.X, pos.Y - 100) -- Menampilkan teks di atas pemain
                    textDisplay.Visible = true
                else
                    textDisplay.Visible = false
                end
            end
        end
    end
end)


-- // 1. Anti Kick / Ban by Metatable Hook
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if method == "Kick" or method == "Ban" or tostring(method):lower():find("kick") then
        warn("❌ Kick/Ban Attempt Blocked!")
        return
    end

    return oldNamecall(self, unpack(args))
end)

-- // 2. Anti Log (Prevent logging actions to server)
local blockedEvents = {"SayMessageRequest", "LogService", "RemoteEvent", "RemoteFunction"}

for _, v in pairs(blockedEvents) do
    local suc, remote = pcall(function()
        return game:GetService("ReplicatedStorage"):FindFirstChild(v)
    end)
    if suc and remote then
        remote:Destroy()
        warn("🛡️ Blocked possible log sender:", v)
    end
end

-- // 3. Auto-disable cheat if admin/mod is in game
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

function isSuspicious(plr)
    local name = plr.Name:lower()
    local display = plr.DisplayName:lower()
    return name:find("admin") or name:find("mod") or name:find("staff") or display:find("admin") or display:find("mod")
end

function disableAllCheats()
    -- replace with your actual cheat disable functions
    if ESPFolder then ESPFolder:Destroy() end
    if Frame then Frame.Visible = false end
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

-- // 4. Identity Spoofing (Optional - advanced obfuscation)
pcall(function()
    LocalPlayer.Name = "Guest" .. math.random(1000,9999)
    LocalPlayer.DisplayName = "Noob_" .. math.random(10,99)
end)

-- // 5. Fake crash (Kalau admin masuk, kamu bisa auto "crash")
function fakeCrash()
    Frame.Visible = false
    for i = 1, 100 do
        task.spawn(function()
            while true do end
        end)
    end
end

-- kamu bisa panggil: `fakeCrash()` ketika admin/mod ketahuan

