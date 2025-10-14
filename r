-- 📍 Player Detector GUI Samping (Long Range + Distance Meter)
-- By Salvkiel | GUI redesign by ChatGPT (2025)
-- ⚙️ Untuk Client Executor

---------------------------------------------------------------------
-- 🔽 SERVICE 🔽
---------------------------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

---------------------------------------------------------------------
-- 🔽 GUI UTAMA 🔽
---------------------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SidePlayerDetector"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 40, 0, 40)
frame.Position = UDim2.new(0, 10, 0.5, -20)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

---------------------------------------------------------------------
-- 🔽 GUI SAMPING TELEPORT 🔽
---------------------------------------------------------------------
local flagButton = Instance.new("ImageButton")
flagButton.Size = UDim2.new(0, 24, 0, 24)
flagButton.Position = UDim2.new(0.5, -12, 0.5, -12)
flagButton.BackgroundTransparency = 1
flagButton.Image = "rbxassetid://6031097229"
flagButton.Parent = frame

local sideFrame = Instance.new("Frame")
sideFrame.Size = UDim2.new(0, 200, 0, 320)
sideFrame.Position = UDim2.new(1, 10, 0, -140)
sideFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
sideFrame.Visible = false
sideFrame.Parent = frame

local sideCorner = Instance.new("UICorner")
sideCorner.CornerRadius = UDim.new(0, 12)
sideCorner.Parent = sideFrame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -10)
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

---------------------------------------------------------------------
-- 🔹 TELEPORT TANPA BATAS JARAK 🔹
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
	myHRP.Velocity = Vector3.zero
end

---------------------------------------------------------------------
-- 🔹 TOMBOL PEMAIN 🔹
---------------------------------------------------------------------
local function createPlayerButton(targetPlayer)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.9, 0, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.Text = targetPlayer.Name .. " - ..."
	btn.Parent = scrollFrame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = btn

	btn.MouseButton1Click:Connect(function()
		strongTeleport(targetPlayer)
	end)

	RunService.Heartbeat:Connect(function()
		if player.Character and targetPlayer.Character then
			local myHRP = player.Character:FindFirstChild("HumanoidRootPart")
			local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
			if myHRP and targetHRP then
				local dist = (myHRP.Position - targetHRP.Position).Magnitude
				btn.Text = string.format("%s - %.0f studs", targetPlayer.Name, dist)
			end
		else
			btn.Text = targetPlayer.Name .. " - N/A"
		end
	end)

	return btn
end

---------------------------------------------------------------------
-- 🔹 REFRESH LIST PEMAIN 🔹
---------------------------------------------------------------------
local function refreshList()
	scrollFrame:ClearAllChildren()
	local y = 0
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player then
			local b = createPlayerButton(p)
			y += 45
		end
	end
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, y)
end

Players.PlayerAdded:Connect(refreshList)
Players.PlayerRemoving:Connect(refreshList)
refreshList()

---------------------------------------------------------------------
-- 🔹 TOMBOL BUKA/TUTUP PANEL 🔹
---------------------------------------------------------------------
flagButton.MouseButton1Click:Connect(function()
	sideFrame.Visible = not sideFrame.Visible
end)

print("[✅ Player Detector Samping Loaded] Long-range teleport aktif.")
