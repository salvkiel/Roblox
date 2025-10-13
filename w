local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- 🔽 ANIMASI "BY : Xraxor" 🔽
do
    local introGui = Instance.new("ScreenGui")
    introGui.Name = "IntroAnimation"
    introGui.ResetOnSpawn = false
    introGui.Parent = player:WaitForChild("PlayerGui")

    local introLabel = Instance.new("TextLabel")
    introLabel.Size = UDim2.new(0, 300, 0, 50)
    introLabel.Position = UDim2.new(0.5, -150, 0.4, 0)
    introLabel.BackgroundTransparency = 1
    introLabel.Text = "By : SALVKIEL"
    introLabel.TextColor3 = Color3.fromRGB(40, 40, 40)
    introLabel.TextScaled = true
    introLabel.Font = Enum.Font.GothamBold
    introLabel.Parent = introGui

    local tweenInfoMove = TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
    local tweenMove = TweenService:Create(introLabel, tweenInfoMove, {Position = UDim2.new(0.5, -150, 0.42, 0)})

    local tweenInfoColor = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
    local tweenColor = TweenService:Create(introLabel, tweenInfoColor, {TextColor3 = Color3.fromRGB(0, 0, 0)})

    tweenMove:Play()
    tweenColor:Play()

    task.wait(2)
    local fadeOut = TweenService:Create(introLabel, TweenInfo.new(0.5), {TextTransparency = 1})
    fadeOut:Play()
    fadeOut.Completed:Connect(function()
        introGui:Destroy()
    end)
end

-- 🔽 Status AutoFarm 🔽
local statusValue = ReplicatedStorage:FindFirstChild("AutoFarmStatus")
if not statusValue then
    statusValue = Instance.new("BoolValue")
    statusValue.Name = "AutoFarmStatus"
    statusValue.Value = false
    statusValue.Parent = ReplicatedStorage
end

-- 🔽 GUI Utama 🔽
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoFarmGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 160)
frame.Position = UDim2.new(0.4, -110, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = frame

-- Judul GUI
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Saxer Lucke"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

-- Tombol SUMMIT
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 160, 0, 40)
button.Position = UDim2.new(0.5, -80, 0.5, -20)
button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
button.Text = "SUMMIT"
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.GothamBold
button.TextSize = 15
button.Parent = frame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = button

-- 🔽 GUI Samping Teleport 🔽
local flagButton = Instance.new("ImageButton")
flagButton.Size = UDim2.new(0, 20, 0, 20)
flagButton.Position = UDim2.new(1, -30, 0, 5)
flagButton.BackgroundTransparency = 1
flagButton.Image = "rbxassetid://6031097229"
flagButton.Parent = frame

local sideFrame = Instance.new("Frame")
sideFrame.Size = UDim2.new(0, 170, 0, 200)
sideFrame.Position = UDim2.new(1, 10, 0, 0)
sideFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
sideFrame.Visible = false
sideFrame.Parent = frame

local sideCorner = Instance.new("UICorner")
sideCorner.CornerRadius = UDim.new(0, 12)
sideCorner.Parent = sideFrame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -5)
scrollFrame.Position = UDim2.new(0, 0, 0, 5)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 6
scrollFrame.BackgroundTransparency = 1
scrollFrame.Parent = sideFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scrollFrame

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end)

flagButton.MouseButton1Click:Connect(function()
    sideFrame.Visible = not sideFrame.Visible
end)

-- ====== BAGIAN TELEPORT LIST (dengan delay) ======
local teleportList = {
    {name = "Teleport Pos 1", pos = Vector3.new(-1.858, 324.139, 2945.717), delay = 10},
    {name = "Teleport Pos 2", pos = Vector3.new(-12.149, 336.266, 3131.099), delay = 25},
    {name = "Teleport Pos 3", pos = Vector3.new(-234.331, 401.994, 4034.662), delay = 13},
    {name = "Teleport Pos 4", pos = Vector3.new(-260.452, 339.807, 4382.458), delay = 7},
    {name = "Teleport Pos 5", pos = Vector3.new(-350.004, 331.38, 4563.691), delay = 27},
    {name = "Teleport Pos 6", pos = Vector3.new(-863.008, 228.044, 5330.454), delay = 32},
    {name = "Teleport Pos 7", pos = Vector3.new(-1381.331, 504.732, 6360.716), delay = 22},
    {name = "Teleport Pos 8", pos = Vector3.new(-1521.099, 537.663, 6747.521), delay = 12},
    {name = "Teleport Pos 9", pos = Vector3.new(-1489.38, 546.493, 7075.592), delay = 45},
    {name = "Teleport Pos 10", pos = Vector3.new(-892.735, 481.662, 8299.804), delay = 35},
    {name = "Teleport Pos 11", pos = Vector3.new(-497.311, 608.767, 8792.895), delay = 5},
    {name = "Teleport Pos 12", pos = Vector3.new(-303.358, 611.169, 8947.14), delay = 10},
    {name = "Teleport Pos 13", pos = Vector3.new(-121.753, 599.254, 9166.275), delay = 10},
    {name = "Teleport Pos 14", pos = Vector3.new(-9.714, 637.725, 9324.404), delay = 25},
    {name = "Teleport Pos 15", pos = Vector3.new(214.159, 810.763, 10017.791), delay = 25},
    {name = "PUNCAK", pos = Vector3.new(546.483, 1310.881, 10933.145), delay = 2},
    {name = "BASECAMP", pos = Vector3.new(-469.602, 61.187, 544.347), delay = 2},
}

-- ====== MEMPERBARUI makeTeleportButton: tambahkan TextBox delay ======
local function makeTeleportButton(name, pos, idx)
    -- wrap dalam frame supaya bisa taruh button + textbox
    local itemFrame = Instance.new("Frame")
    itemFrame.Size = UDim2.new(0, 160, 0, 36)
    itemFrame.BackgroundTransparency = 1
    itemFrame.Parent = scrollFrame

    local tpButton = Instance.new("TextButton")
    tpButton.Size = UDim2.new(0, 110, 1, 0)
    tpButton.Position = UDim2.new(0, 0, 0, 0)
    tpButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tpButton.Text = name
    tpButton.TextColor3 = Color3.new(1, 1, 1)
    tpButton.Font = Enum.Font.SourceSansBold
    tpButton.TextSize = 14
    tpButton.Parent = itemFrame

    local tpCorner = Instance.new("UICorner")
    tpCorner.CornerRadius = UDim.new(0, 8)
    tpCorner.Parent = tpButton

    local delayBox = Instance.new("TextBox")
    delayBox.Size = UDim2.new(0, 40, 1, -6)
    delayBox.Position = UDim2.new(0, 115, 0, 3)
    delayBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    delayBox.TextColor3 = Color3.fromRGB(255,255,255)
    delayBox.Font = Enum.Font.SourceSans
    delayBox.TextSize = 14
    delayBox.Text = tostring(teleportList[idx].delay or 3)
    delayBox.PlaceholderText = "sec"
    delayBox.ClearTextOnFocus = false
    delayBox.Parent = itemFrame

    local delayCorner = Instance.new("UICorner")
    delayCorner.CornerRadius = UDim.new(0, 6)
    delayCorner.Parent = delayBox

    -- klik tombol -> teleport langsung ke pos
    tpButton.MouseButton1Click:Connect(function()
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(pos)
        end
    end)

    -- validasi input ketika enter atau focus lost
    local function applyDelayText(text)
        local num = tonumber(text)
        if num and num >= 0 then
            teleportList[idx].delay = num
            delayBox.Text = tostring(num)
        else
            -- revert ke nilai lama jika invalid
            delayBox.Text = tostring(teleportList[idx].delay or 3)
        end
    end

    delayBox.FocusLost:Connect(function(enterPressed)
        applyDelayText(delayBox.Text)
    end)

    delayBox.Changed:Connect(function(prop)
        if prop == "Text" then
            -- optional: realtime validate minimal, jangan set agar user bisa edit dulu
        end
    end)
end

-- Buat semua tombol dari daftar (pakai index supaya delay tersambung)
for idx, data in ipairs(teleportList) do
    makeTeleportButton(data.name, data.pos, idx)
end

-- ====== CONTROLS: Default Delay dan Apply ke Semua ======
-- tempatkan controls ini di bawah scrollFrame (atau di frame lain sesuai layout)
local controlsFrame = Instance.new("Frame")
controlsFrame.Size = UDim2.new(1, 0, 0, 60)
controlsFrame.Position = UDim2.new(0, 0, 1, -65)
controlsFrame.BackgroundTransparency = 1
controlsFrame.Parent = sideFrame

local defaultLabel = Instance.new("TextLabel")
defaultLabel.Size = UDim2.new(0, 80, 0, 24)
defaultLabel.Position = UDim2.new(0, 8, 0, 6)
defaultLabel.BackgroundTransparency = 1
defaultLabel.Text = "Default:"
defaultLabel.TextColor3 = Color3.new(1,1,1)
defaultLabel.Font = Enum.Font.SourceSans
defaultLabel.TextSize = 14
defaultLabel.Parent = controlsFrame

local defaultBox = Instance.new("TextBox")
defaultBox.Size = UDim2.new(0, 60, 0, 24)
defaultBox.Position = UDim2.new(0, 90, 0, 6)
defaultBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
defaultBox.TextColor3 = Color3.new(1,1,1)
defaultBox.Text = "3"
defaultBox.Font = Enum.Font.SourceSans
defaultBox.TextSize = 14
defaultBox.ClearTextOnFocus = false
defaultBox.Parent = controlsFrame

local applyAllBtn = Instance.new("TextButton")
applyAllBtn.Size = UDim2.new(0, 60, 0, 24)
applyAllBtn.Position = UDim2.new(0, 160, 0, 6)
applyAllBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
applyAllBtn.Text = "Apply"
applyAllBtn.Font = Enum.Font.SourceSansBold
applyAllBtn.TextSize = 14
applyAllBtn.Parent = controlsFrame

local applyCorner = Instance.new("UICorner")
applyCorner.CornerRadius = UDim.new(0,6)
applyCorner.Parent = applyAllBtn

applyAllBtn.MouseButton1Click:Connect(function()
    local v = tonumber(defaultBox.Text)
    if v and v >= 0 then
        for i = 1, #teleportList do
            teleportList[i].delay = v
        end
        -- update semua TextBox di GUI: sederhana -> rebuild scrollFrame entries
        -- (paling mudah adalah clear and recreate)
        for _, obj in ipairs(scrollFrame:GetChildren()) do
            if not (obj:IsA("UIListLayout")) then
                obj:Destroy()
            end
        end
        for idx, data in ipairs(teleportList) do
            makeTeleportButton(data.name, data.pos, idx)
        end
    else
        warn("Default delay invalid")
    end
end)

-- ====== AUTO FARM SYSTEM (dimulai dari BASECAMP) ======
local teleporting = false

local function safeTeleportTo(pos)
	local char = player.Character
	if not char then return false end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return false end
	local ok, err = pcall(function()
		hrp.CFrame = CFrame.new(pos)
	end)
	if not ok then
		warn("Teleport failed:", err)
		return false
	end
	return true
end

local function autoFarmLoop()
	while teleporting do
		-- ⚡ Mulai dari BASECAMP (elemen terakhir)
		local basecamp = teleportList[#teleportList]
		if basecamp then
			print(string.format("[AutoFarm] BASECAMP | delay %.1f detik", tonumber(basecamp.delay) or 3))
			safeTeleportTo(basecamp.pos)
			task.wait(tonumber(basecamp.delay) or 3)
		end

		-- ⚡ Lanjut naik ke tiap pos 1 → puncak (semua kecuali basecamp)
		for i = 1, #teleportList - 1 do
			if not teleporting then break end
			local data = teleportList[i]
			if data and data.pos then
				print(string.format("[AutoFarm] %s | delay %.1f detik", data.name, tonumber(data.delay) or 3))
				safeTeleportTo(data.pos)
				task.wait(tonumber(data.delay) or 3)
			end
		end

		-- ⚡ Setelah sampai puncak, kembali ke BASECAMP dan ulang
		if teleporting and basecamp then
			print(string.format("[AutoFarm] Kembali ke BASECAMP | delay %.1f detik", tonumber(basecamp.delay) or 3))
			safeTeleportTo(basecamp.pos)
			task.wait(tonumber(basecamp.delay) or 3)
		end
	end

	-- jika loop berhenti
	if not teleporting then
		button.Text = "SUMMIT"
		button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	end
end

local function toggleAutoFarm(state)
	teleporting = state
	statusValue.Value = state
	if teleporting then
		button.Text = "RUNNING..."
		button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
		task.spawn(autoFarmLoop)
	else
		button.Text = "SUMMIT"
		button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	end
end

button.MouseButton1Click:Connect(function()
	toggleAutoFarm(not teleporting)
end)
