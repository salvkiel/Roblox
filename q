local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- 🔸 Buat GUI utama
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlayerTeleportGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 300)
mainFrame.Position = UDim2.new(0, 20, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Text = "📡 Daftar Pemain"
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = mainFrame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -40)
scrollFrame.Position = UDim2.new(0, 0, 0, 40)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 6
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.Parent = mainFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 5)
uiListLayout.Parent = scrollFrame

-- 📌 Fungsi untuk membuat tombol teleport untuk setiap pemain
local function createPlayerButton(targetPlayer)
	if targetPlayer == localPlayer then return end -- jangan teleport ke diri sendiri

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -10, 0, 35)
	button.Position = UDim2.new(0, 5, 0, 0)
	button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Text = targetPlayer.Name .. " ✈️"
	button.Font = Enum.Font.Gotham
	button.TextSize = 18
	button.Parent = scrollFrame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = button

	button.MouseButton1Click:Connect(function()
		local targetChar = targetPlayer.Character
		local myChar = localPlayer.Character
		if targetChar and myChar then
			local hrpTarget = targetChar:FindFirstChild("HumanoidRootPart")
			local hrpMe = myChar:FindFirstChild("HumanoidRootPart")
			if hrpTarget and hrpMe then
				hrpMe.CFrame = hrpTarget.CFrame + Vector3.new(0, 3, 0) -- teleport ke atas pemain
			end
		end
	end)
end

-- 🧹 Bersihkan dan perbarui daftar
local function refreshPlayerList()
	for _, child in ipairs(scrollFrame:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	for _, p in ipairs(Players:GetPlayers()) do
		createPlayerButton(p)
	end

	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y + 10)
end

uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y + 10)
end)

Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)

-- 🚀 Jalankan pertama kali
refreshPlayerList()
