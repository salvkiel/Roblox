local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- 🔽 Status AutoFarm 🔽
local statusValue = ReplicatedStorage:FindFirstChild("AutoFarmStatus") or Instance.new("BoolValue")
statusValue.Name = "AutoFarmStatus"
statusValue.Value = false
statusValue.Parent = ReplicatedStorage

-- 🔽 GUI UTAMA 🔽
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
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 15)

-- Judul
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Saxer Lucke"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

-- Tombol utama
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 160, 0, 40)
button.Position = UDim2.new(0.5, -80, 0.5, -20)
button.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
button.Text = "SUMMIT"
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.GothamBold
button.TextSize = 15
button.Parent = frame
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 10)

-- Progress bar
local progressFrame = Instance.new("Frame")
progressFrame.Size = UDim2.new(0.9, 0, 0, 14)
progressFrame.Position = UDim2.new(0.05, 0, 0.85, 0)
progressFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
progressFrame.BorderSizePixel = 0
progressFrame.Parent = frame
Instance.new("UICorner", progressFrame).CornerRadius = UDim.new(0, 7)

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
progressBar.BorderSizePixel = 0
progressBar.Parent = progressFrame
Instance.new("UICorner", progressBar).CornerRadius = UDim.new(0, 7)

local progressLabel = Instance.new("TextLabel")
progressLabel.Size = UDim2.new(1, 0, 1, 0)
progressLabel.BackgroundTransparency = 1
progressLabel.Text = "0s"
progressLabel.Font = Enum.Font.GothamBold
progressLabel.TextSize = 12
progressLabel.TextColor3 = Color3.fromRGB(255,255,255)
progressLabel.Parent = progressFrame

-- Tombol close
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -60, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1,1,1)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.Parent = frame
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0,5)
closeButton.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- 🔽 GUI SAMBING 🔽
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
Instance.new("UICorner", sideFrame).CornerRadius = UDim.new(0, 12)

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

-- ====== TELEPORT LIST ======
local teleportList = {
	{name = "Teleport Pos 1", pos = Vector3.new(-1.858, 324.139, 2945.717), delay = 10},
	{name = "Teleport Pos 2", pos = Vector3.new(-12.149, 336.266, 3131.099), delay = 25},
	{name = "Teleport Pos 3", pos = Vector3.new(-234.331, 401.994, 4034.662), delay = 13},
	{name = "Teleport Pos 4", pos = Vector3.new(-260.452, 339.807, 4382.458), delay = 6},
	{name = "Teleport Pos 5", pos = Vector3.new(-350.004, 331.38, 4563.691), delay = 21},
	{name = "Teleport Pos 6", pos = Vector3.new(-863.008, 228.044, 5330.454), delay = 30},
	{name = "Teleport Pos 7", pos = Vector3.new(-1381.331, 504.732, 6360.716), delay = 21},
	{name = "Teleport Pos 8", pos = Vector3.new(-1521.099, 537.663, 6747.521), delay = 11},
	{name = "Teleport Pos 9", pos = Vector3.new(-1489.38, 546.493, 7075.592), delay = 29},
	{name = "Teleport Pos 10", pos = Vector3.new(-892.735, 481.662, 8299.804), delay = 30},
	{name = "Teleport Pos 11", pos = Vector3.new(-497.311, 608.767, 8792.895), delay = 8},
	{name = "Teleport Pos 12", pos = Vector3.new(-303.358, 611.169, 8947.14), delay = 5},
	{name = "Teleport Pos 13", pos = Vector3.new(-121.753, 599.254, 9166.275), delay = 5},
	{name = "Teleport Pos 14", pos = Vector3.new(-9.714, 637.725, 9324.404), delay = 12},
	{name = "Teleport Pos 15", pos = Vector3.new(214.159, 810.763, 10017.791), delay = 12},
	{name = "PUNCAK", pos = Vector3.new(546.483, 1310.881, 10933.145), delay = 3},
	{name = "BASECAMP", pos = Vector3.new(-469.602, 61.187, 544.347), delay = 5},
}

-- ====== FUNKSI PENDUKUNG ======
local teleporting = false
local lastManualIndex = 1 -- simpan posisi teleport manual terakhir

local function safeTeleportTo(pos)
	local char = player.Character
	if not char then return false end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return false end
	pcall(function() hrp.CFrame = CFrame.new(pos) end)
	return true
end

local function runProgressTimer(delayTime)
	progressBar.Size = UDim2.new(0, 0, 1, 0)
	progressLabel.Text = "0s"
	local elapsed = 0
	while elapsed < delayTime do
		local progress = elapsed / delayTime
		progressBar.Size = UDim2.new(progress, 0, 1, 0)
		progressLabel.Text = string.format("%.1fs", elapsed)
		task.wait(0.1)
		elapsed += 0.1
	end
	progressBar.Size = UDim2.new(1, 0, 1, 0)
	progressLabel.Text = string.format("%.1fs", delayTime)
end

-- ====== BUAT TOMBOL TELEPORT MANUAL ======
local function makeTeleportButton(name, pos, idx)
	local itemFrame = Instance.new("Frame")
	itemFrame.Size = UDim2.new(0, 160, 0, 36)
	itemFrame.BackgroundTransparency = 1
	itemFrame.Parent = scrollFrame

	local tpButton = Instance.new("TextButton")
	tpButton.Size = UDim2.new(0, 110, 1, 0)
	tpButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	tpButton.Text = name
	tpButton.TextColor3 = Color3.new(1, 1, 1)
	tpButton.Font = Enum.Font.SourceSansBold
	tpButton.TextSize = 14
	tpButton.Parent = itemFrame
	Instance.new("UICorner", tpButton).CornerRadius = UDim.new(0, 8)

	local delayBox = Instance.new("TextBox")
	delayBox.Size = UDim2.new(0, 40, 1, -6)
	delayBox.Position = UDim2.new(0, 115, 0, 3)
	delayBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	delayBox.TextColor3 = Color3.fromRGB(255,255,255)
	delayBox.Font = Enum.Font.SourceSans
	delayBox.TextSize = 14
	delayBox.Text = tostring(teleportList[idx].delay or 3)
	delayBox.ClearTextOnFocus = false
	delayBox.Parent = itemFrame
	Instance.new("UICorner", delayBox).CornerRadius = UDim.new(0, 6)

	tpButton.MouseButton1Click:Connect(function()
		local delayTime = tonumber(delayBox.Text) or 3
		if safeTeleportTo(pos) then
			lastManualIndex = idx -- simpan indeks teleport terakhir manual
			task.spawn(runProgressTimer, delayTime)
		end
	end)

	delayBox.FocusLost:Connect(function()
		local num = tonumber(delayBox.Text)
		if num and num >= 0 then
			teleportList[idx].delay = num
		else
			delayBox.Text = tostring(teleportList[idx].delay)
		end
	end)
end

for idx, data in ipairs(teleportList) do
	makeTeleportButton(data.name, data.pos, idx)
end

-- ====== AUTO FARM LOOP ======
local function respawnPlayer(callback)
	local character = player.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then humanoid.Health = 0 end
	end
	player.CharacterAdded:Wait()
	task.wait(2)
	if callback then callback() end
end

local function autoFarmLoop()
	while teleporting do
		progressBar.Size = UDim2.new(0, 0, 1, 0)
		progressLabel.Text = "0s"

		local startIndex = math.clamp(lastManualIndex, 1, #teleportList - 1)

		-- Mulai dari posisi terakhir manual
		for i = startIndex, #teleportList - 2 do
			if not teleporting then break end
			local data = teleportList[i]
			local delayTime = tonumber(data.delay) or 3
			safeTeleportTo(data.pos)
			runProgressTimer(delayTime)
		end

		-- Puncak
		local puncak = teleportList[#teleportList - 1]
		if teleporting and puncak then
			safeTeleportTo(puncak.pos)
			runProgressTimer(tonumber(puncak.delay) or 3)
		end

		-- Respawn ke basecamp
		if teleporting then
			respawnPlayer(function()
				safeTeleportTo(teleportList[#teleportList].pos)
			end)
			lastManualIndex = 1
		end
	end
end

-- ====== TOGGLE BUTTON ======
button.MouseButton1Click:Connect(function()
	teleporting = not teleporting
	statusValue.Value = teleporting
	if teleporting then
		button.Text = "STOP"
		button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
		task.spawn(autoFarmLoop)
	else
		button.Text = "SUMMIT"
		button.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
	end
end)
