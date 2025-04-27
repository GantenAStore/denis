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
Frame.Size = UDim2.new(0, 300, 0, 230)
Frame.Position = UDim2.new(0, 50, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Visible = true

-- Scrolling Frame (untuk menampilkan teks)
local ScrollFrame = Instance.new("ScrollingFrame", Frame)
ScrollFrame.Size = UDim2.new(1, -20, 0, 180)
ScrollFrame.Position = UDim2.new(0, 10, 0, 10)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 10
ScrollFrame.BackgroundTransparency = 1

-- ESP Toggle Button
local espToggle = Instance.new("TextButton", Frame)
espToggle.Size = UDim2.new(1, -20, 0, 40)
espToggle.Position = UDim2.new(0, 10, 0, 200)
espToggle.Text = "ESP: OFF"
espToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
espToggle.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Hide UI Button
local hideUIButton = Instance.new("TextButton", Frame)
hideUIButton.Size = UDim2.new(1, -20, 0, 40)
hideUIButton.Position = UDim2.new(0, 10, 0, 240)
hideUIButton.Text = "Hide UI"
hideUIButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
hideUIButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- TextBox untuk mengetik pesan
local messageInput = Instance.new("TextBox", Frame)
messageInput.Size = UDim2.new(1, -20, 0, 30)
messageInput.Position = UDim2.new(0, 10, 0, 280)
messageInput.PlaceholderText = "Ketik pesan..."
messageInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
messageInput.TextColor3 = Color3.fromRGB(255, 255, 255)
messageInput.Text = ""

-- Tombol untuk mengirim teks
local sendTextButton = Instance.new("TextButton", Frame)
sendTextButton.Size = UDim2.new(1, -20, 0, 30)
sendTextButton.Position = UDim2.new(0, 10, 0, 315)
sendTextButton.Text = "Kirim Teks"
sendTextButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
sendTextButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Fungsi untuk mengirim teks ke semua pemain
local function sendTextToAllPlayers(text)
    -- Buat frame untuk teks
    local textFrame = Instance.new("TextLabel", ScrollFrame)
    textFrame.Size = UDim2.new(1, -20, 0, 30)
    textFrame.Position = UDim2.new(0, 10, 0, ScrollFrame.CanvasSize.Y.Offset + 10)
    textFrame.Text = text
    textFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
    textFrame.BackgroundTransparency = 1
    textFrame.TextSize = 16
    textFrame.TextWrapped = true
    textFrame.TextXAlignment = Enum.TextXAlignment.Left

    -- Update canvas size agar UI bisa digulir
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ScrollFrame.CanvasSize.Y.Offset + textFrame.Size.Y.Offset + 10)
end

-- Tombol untuk mengirim pesan
sendTextButton.MouseButton1Click:Connect(function()
    local text = messageInput.Text
    if text ~= "" then
        sendTextToAllPlayers(text)
        messageInput.Text = ""  -- Resetkan input setelah mengirim teks
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

-- Teleportation Section
local playerInput = Instance.new("TextBox", Frame)
playerInput.Size = UDim2.new(1, -20, 0, 30)
playerInput.Position = UDim2.new(0, 10, 0, 355)
playerInput.PlaceholderText = "Masukkan nama pemain"
playerInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
playerInput.TextColor3 = Color3.fromRGB(255, 255, 255)
playerInput.Text = ""

-- Tombol Teleport ke Pemain
local teleportToPlayerButton = Instance.new("TextButton", Frame)
teleportToPlayerButton.Size = UDim2.new(1, -20, 0, 30)
teleportToPlayerButton.Position = UDim2.new(0, 10, 0, 390)
teleportToPlayerButton.Text = "Teleport ke Pemain"
teleportToPlayerButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
teleportToPlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Tombol Teleport Pemain ke Saya
local teleportPlayerToMeButton = Instance.new("TextButton", Frame)
teleportPlayerToMeButton.Size = UDim2.new(1, -20, 0, 30)
teleportPlayerToMeButton.Position = UDim2.new(0, 10, 0, 425)
teleportPlayerToMeButton.Text = "Teleport Pemain ke Saya"
teleportPlayerToMeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
teleportPlayerToMeButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Fungsi Teleport ke Pemain yang Ditulis Namanya
teleportToPlayerButton.MouseButton1Click:Connect(function()
    local targetName = playerInput.Text
    if targetName == "" then return end

    local foundPlayer = nil
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr.Name:lower():find(targetName:lower()) then
            foundPlayer = plr
            break
        end
    end

    if foundPlayer and foundPlayer.Character and foundPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPos = foundPlayer.Character.HumanoidRootPart.Position
        local myChar = game.Players.LocalPlayer.Character
        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
            myChar:MoveTo(targetPos + Vector3.new(0, 3, 0))
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
        if plr.Name:lower():find(targetName:lower()) then
            foundPlayer = plr
            break
        end
    end

    if foundPlayer and foundPlayer.Character and foundPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
        local plrChar = foundPlayer.Character
        if plrChar and plrChar:FindFirstChild("HumanoidRootPart") then
            plrChar:MoveTo(targetPos + Vector3.new(0, 3, 0))
        end
    else
        warn("Pemain tidak ditemukan atau tidak valid.")
    end
end)

-- Tambahkan Anti-Ban dan Anti-Kick di sini jika diperlukan
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

-- kamu bisa panggil: fakeCrash() ketika admin/mod ketahuan
