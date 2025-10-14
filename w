-- 🔽 SERVICE YANG DIGUNAKAN 🔽
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- 🔽 GUI UTAMA 🔽
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlayerDetectorGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- 🔽 FRAME UTAMA 🔽
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0, 20, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- 🔽 TITLE 🔽
local title = Instance.new("TextLabel")
title.Text = "📍 Player Detector"
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

-- 🔽 SCROLL FRAME UNTUK LIST PEMAIN 🔽
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -40)
scrollFrame.Position = UDim2.new(0, 0, 0, 40)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 6
scrollFrame.BackgroundTransparency = 1
scrollFrame.Parent = mainFrame

-- 🔽 TEMPLATE UNTUK SATU BARIS PEMAIN 🔽
local function createPlayerButton(targetPlayer)
	local buttonFrame = Instance.new("Frame")
	buttonFrame.Size = UDim2.new(1, -10, 0, 40)
	buttonFrame.Position = UDim2.new(0, 5, 0, 0)
	buttonFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	buttonFrame.BorderSizePixel = 0
	buttonFrame.Parent = scrollFrame

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Text = targetPlayer.Name
	nameLabel.Size = UDim2.new(0.6, 0, 1, 0)
	nameLabel.Position = UDim2.new(0, 10, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.Font = Enum.Font.Gotham
	nameLabel.TextSize = 16
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = buttonFrame

	local teleportButton = Instance.new("TextButton")
	teleportButton.Text = "Teleport"
	teleportButton.Size = UDim2.new(0.3, 0, 0.8, 0)
	teleportButton.Position = UDim2.new(0.65, 0, 0.1, 0)
	teleportButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
	teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	teleportButton.Font = Enum.Font.GothamBold
	teleportButton.TextSize = 14
	teleportButton.Parent = buttonFrame

	-- 🔹 FUNGSI TELEPORT 🔹
	teleportButton.MouseButton1Click:Connect(function()
		if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and player.Character then
			local targetPos = targetPlayer.Character.HumanoidRootPart.Position
			player.Character:MoveTo(targetPos + Vector3.new(0, 3, 0)) -- sedikit di atas biar gak nyangkut
		end
	end)

	return buttonFrame
end

-- 🔽 UPDATE LIST PEMAIN 🔽
local function refreshPlayerList()
	scrollFrame:ClearAllChildren()

	local yPos = 0
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player then
			local button = createPlayerButton(p)
			button.Position = UDim2.new(0, 5, 0, yPos)
			yPos += 45
		end
	end
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

-- 🔹 UPDATE OTOMATIS SAAT PEMAIN MASUK/KELUAR 🔹
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)

-- 🔹 PERTAMA KALI JALAN 🔹
refreshPlayerList()
