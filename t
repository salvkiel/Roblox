-- 📍 Player Detector (Long Range + Distance Meter)
-- By Salvkiel | Reworked GUI by ChatGPT (2025)
-- ⚙️ FE-safe Client Version

---------------------------------------------------------------------
-- 🔽 SERVICE YANG DIGUNAKAN 🔽
---------------------------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

---------------------------------------------------------------------
-- 🔽 GUI UTAMA (Menggunakan AutoFarmGUI) 🔽
---------------------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoFarmGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 420)
frame.Position = UDim2.new(0, 20, 0.5, -210)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Text = "📍 Player Detector"
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15)
titleCorner.Parent = title

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -50)
scrollFrame.Position = UDim2.new(0, 5, 0, 45)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 6
scrollFrame.BackgroundTransparency = 1
scrollFrame.Parent = frame

---------------------------------------------------------------------
-- 🔹 TELEPORT KUAT TANPA BATAS JARAK
---------------------------------------------------------------------
local function strongTeleport(targetPlayer)
	if not player.Character or not targetPlayer.Character then return end

	local myHRP = player.Character:FindFirstChild("HumanoidRootPart")
	local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")

	if not myHRP or not targetHRP then return end

	local targetPos = targetHRP.Position + Vector3.new(0, 5, 0)
	myHRP.CFrame = CFrame.new(targetPos)

	if workspace.CurrentCamera then
		workspace.CurrentCamera.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
	end

	task.wait()
	myHRP.Velocity = Vector3.zero
end

---------------------------------------------------------------------
-- 🔹 TEMPLATE SATU BARIS PEMAIN DENGAN JARAK
---------------------------------------------------------------------
local function createPlayerButton(targetPlayer)
	local buttonFrame = Instance.new("Frame")
	buttonFrame.Size = UDim2.new(1, -10, 0, 45)
	buttonFrame.Position = UDim2.new(0, 5, 0, 0)
	buttonFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	buttonFrame.BorderSizePixel = 0
	buttonFrame.Parent = scrollFrame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = buttonFrame

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Text = targetPlayer.Name
	nameLabel.Size = UDim2.new(0.55, 0, 1, 0)
	nameLabel.Position = UDim2.new(0, 10, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.Font = Enum.Font.Gotham
	nameLabel.TextSize = 15
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = buttonFrame

	local distanceLabel = Instance.new("TextLabel")
	distanceLabel.Text = "..."
	distanceLabel.Size = UDim2.new(0.25, 0, 1, 0)
	distanceLabel.Position = UDim2.new(0.55, 0, 0, 0)
	distanceLabel.BackgroundTransparency = 1
	distanceLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	distanceLabel.Font = Enum.Font.Gotham
	distanceLabel.TextSize = 14
	distanceLabel.Parent = buttonFrame

	local teleportButton = Instance.new("TextButton")
	teleportButton.Text = "TP"
	teleportButton.Size = UDim2.new(0.15, 0, 0.8, 0)
	teleportButton.Position = UDim2.new(0.82, 0, 0.1, 0)
	teleportButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
	teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	teleportButton.Font = Enum.Font.GothamBold
	teleportButton.TextSize = 14
	teleportButton.Parent = buttonFrame

	local tpCorner = Instance.new("UICorner")
	tpCorner.CornerRadius = UDim.new(0, 6)
	tpCorner.Parent = teleportButton

	-- 🔹 FUNGSI TELEPORT 🔹
	teleportButton.MouseButton1Click:Connect(function()
		strongTeleport(targetPlayer)
	end)

	-- 🔹 UPDATE JARAK REAL-TIME 🔹
	RunService.Heartbeat:Connect(function()
		if player.Character and targetPlayer.Character then
			local myHRP = player.Character:FindFirstChild("HumanoidRootPart")
			local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
			if myHRP and targetHRP then
				local dist = (myHRP.Position - targetHRP.Position).Magnitude
				distanceLabel.Text = string.format("%.0f studs", dist)
			end
		else
			distanceLabel.Text = "N/A"
		end
	end)

	return buttonFrame
end

---------------------------------------------------------------------
-- 🔹 UPDATE LIST PEMAIN
---------------------------------------------------------------------
local function refreshPlayerList()
	scrollFrame:ClearAllChildren()
	local yPos = 0

	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player then
			local button = createPlayerButton(p)
			button.Position = UDim2.new(0, 5, 0, yPos)
			yPos += 50
		end
	end

	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)
refreshPlayerList()

print("[✅ Player Detector Loaded] GUI terintegrasi ke AutoFarmGUI (FE-safe).")
