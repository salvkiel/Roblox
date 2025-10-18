-- ============================================================
-- 🔽 SERVICE 🔽
-- ============================================================
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- ============================================================
-- 🔽 STATUS AUTOFARM 🔽
-- ============================================================
local statusValue = ReplicatedStorage:FindFirstChild("AutoFarmStatus") or Instance.new("BoolValue")
statusValue.Name = "AutoFarmStatus"
statusValue.Value = false
statusValue.Parent = ReplicatedStorage

-- ============================================================
-- 🔽 CHECKPOINT TERAKHIR 🔽
-- ============================================================
local checkpointValue = ReplicatedStorage:FindFirstChild("LastCheckpoint") or Instance.new("IntValue")
checkpointValue.Name = "LastCheckpoint"
checkpointValue.Value = 1
checkpointValue.Parent = ReplicatedStorage

-- ============================================================
-- 🔽 GUI UTAMA (AUTO FARM)
-- ============================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoFarmGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 190)
frame.Position = UDim2.new(0.35, -100, 0.4, -100)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true
frame.BorderSizePixel = 0
frame.Parent = screenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 15)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 28)
title.BackgroundTransparency = 1
title.Text = "Saxer Lucke - AutoFarm"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

local button = Instance.new("TextButton")
button.Size = UDim2.new(0.8, 0, 0, 40)
button.Position = UDim2.new(0.1, 0, 0.3, 0)
button.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
button.Text = "SUMMIT"
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.GothamBold
button.TextSize = 15
button.Parent = frame
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 10)

local progressFrame = Instance.new("Frame")
progressFrame.Size = UDim2.new(0.9, 0, 0, 14)
progressFrame.Position = UDim2.new(0.05, 0, 0.75, 0)
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

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1,1,1)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.Parent = frame
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0,5)
closeButton.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

-- ============================================================
-- 🔽 DAFTAR TELEPORT 🔽
-- ============================================================
local teleportList = {
	{name = "Pos 1", pos = Vector3.new(-1.858, 324.139, 2945.717), delay = 10},
	{name = "Pos 2", pos = Vector3.new(-12.149, 336.266, 3131.099), delay = 25},
	{name = "Pos 3", pos = Vector3.new(-234.331, 401.994, 4034.662), delay = 13},
	{name = "Pos 4", pos = Vector3.new(-260.452, 339.807, 4382.458), delay = 6},
	{name = "Pos 5", pos = Vector3.new(-350.004, 331.38, 4563.691), delay = 21},
	{name = "Pos 6", pos = Vector3.new(-863.008, 228.044, 5330.454), delay = 27},
	{name = "Pos 7", pos = Vector3.new(-1381.331, 504.732, 6360.716), delay = 21},
	{name = "Pos 8", pos = Vector3.new(-1521.099, 537.663, 6747.521), delay = 11},
	{name = "Pos 9", pos = Vector3.new(-1489.38, 546.493, 7075.592), delay = 29},
	{name = "Pos 10", pos = Vector3.new(-892.735, 481.662, 8299.804), delay = 28},
	{name = "Pos 11", pos = Vector3.new(-497.311, 608.767, 8792.895), delay = 8},
	{name = "Pos 12", pos = Vector3.new(-303.358, 611.169, 8947.14), delay = 5},
	{name = "Pos 13", pos = Vector3.new(-121.753, 599.254, 9166.275), delay = 5},
	{name = "Pos 14", pos = Vector3.new(-9.714, 637.725, 9324.404), delay = 12},
	{name = "Pos 15", pos = Vector3.new(214.159, 810.763, 10017.791), delay = 12},
	{name = "PUNCAK", pos = Vector3.new(546.483, 1310.881, 10933.145), delay = 3},
	{name = "BASECAMP", pos = Vector3.new(-469.602, 61.187, 544.347), delay = 5},
}

-- ============================================================
-- 🔽 FUNGSI UMUM 🔽
-- ============================================================
local teleporting = false

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
	while elapsed < delayTime and teleporting do
		local progress = elapsed / delayTime
		progressBar.Size = UDim2.new(progress, 0, 1, 0)
		progressLabel.Text = string.format("%.1fs", elapsed)
		task.wait(0.1)
		elapsed += 0.1
	end
	progressBar.Size = UDim2.new(1, 0, 1, 0)
	progressLabel.Text = string.format("%.1fs", delayTime)
end

local function findNearestCheckpoint()
	local char = player.Character
	if not char then return checkpointValue.Value end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return checkpointValue.Value end
	local currentPos = hrp.Position
	local nearestIndex, nearestDist = checkpointValue.Value, math.huge
	for i, data in ipairs(teleportList) do
		local dist = (currentPos - data.pos).Magnitude
		if dist < nearestDist then
			nearestDist = dist
			nearestIndex = i
		end
	end
	return nearestIndex
end

local function autoFarmLoop()
	local startIndex = checkpointValue.Value
	while teleporting do
		for i = startIndex, #teleportList - 1 do
			if not teleporting then break end
			local data = teleportList[i]
			if safeTeleportTo(data.pos) then
				checkpointValue.Value = i
				runProgressTimer(data.delay or 3)
			end
		end
		if teleporting then
			local basecamp = teleportList[#teleportList]
			safeTeleportTo(basecamp.pos)
			checkpointValue.Value = 1
			task.wait(basecamp.delay)
			local char = player.Character
			if char then
				local humanoid = char:FindFirstChildOfClass("Humanoid")
				if humanoid then humanoid.Health = 0 end
			end
			player.CharacterAdded:Wait()
			task.wait(3)
		end
	end
end

-- ============================================================
-- 🔽 GUI TELEPORT MANUAL (MENEMPEL DI BAWAH FRAME)
-- ============================================================
local sideGui = Instance.new("Frame")
sideGui.Size = UDim2.new(1, 0, 0, 220)
sideGui.Position = UDim2.new(0, 0, 1, 5)
sideGui.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
sideGui.Parent = frame
Instance.new("UICorner", sideGui).CornerRadius = UDim.new(0, 12)

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Parent = sideGui

for i, data in ipairs(teleportList) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.9, 0, 0, 22)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Text = data.name
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 12
	btn.Parent = sideGui
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

	btn.MouseButton1Click:Connect(function()
		safeTeleportTo(data.pos)
		checkpointValue.Value = i -- update checkpoint sesuai tombol manual
	end)
end

-- ============================================================
-- 🔽 TOGGLE AUTOFARM 🔽
-- ============================================================
button.MouseButton1Click:Connect(function()
	teleporting = not teleporting
	statusValue.Value = teleporting

	if teleporting then
		local nearest = findNearestCheckpoint()
		checkpointValue.Value = nearest
		button.Text = "STOP"
		button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
		task.spawn(autoFarmLoop)
	else
		button.Text = "SUMMIT"
		button.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
	end
end)
