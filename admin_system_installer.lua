-- AdminSystem_Installer.lua
-- Tempatkan file ini di ServerScriptService.
-- Script ini membuat RemoteEvent yang dibutuhkan, handler server, dan
-- meng-inject LocalScript client ke StarterGui sehingga kamu cukup satu file.
-- Ubah tabel Admins dan AllowedFolders sesuai kebutuhan.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local StarterPlayer = game:GetService("StarterPlayer")
local ServerStorage = game:GetService("ServerStorage")

-- ============== Konfigurasi ==============
local Admins = {
    "NamaKamu", -- ganti dengan username admin
    -- tambahkan username lain jika perlu
}

local AllowedFolders = {
    "Map",
    "Destructibles",
}

-- Nama RemoteEvent yang akan dibuat
local EVENTS = {
    Delete = "DeleteObjectEvent",
    Fly = "FlyEvent",
    Kick = "KickEvent",
    CheckpointReached = "CheckpointReachedEvent",
    CheckpointConfirm = "CheckpointConfirmEvent",
}

-- ============== Utility ==============
local function isAdmin(player)
    return table.find(Admins, player.Name) ~= nil
end

local function findAllowedObject(targetName)
    for _, folderName in ipairs(AllowedFolders) do
        local folder = workspace:FindFirstChild(folderName)
        if folder then
            local found = folder:FindFirstChild(targetName, true)
            if found then
                return found
            end
        end
    end
    return nil
end

-- ============== Pastikan RemoteEvent ada ==============
local function getOrCreateEvent(name)
    local ev = ReplicatedStorage:FindFirstChild(name)
    if not ev then
        ev = Instance.new("RemoteEvent")
        ev.Name = name
        ev.Parent = ReplicatedStorage
    end
    return ev
end

local DeleteEvent = getOrCreateEvent(EVENTS.Delete)
local FlyEvent = getOrCreateEvent(EVENTS.Fly)
local KickEvent = getOrCreateEvent(EVENTS.Kick)
local CheckpointReachedEvent = getOrCreateEvent(EVENTS.CheckpointReached)
local CheckpointConfirmEvent = getOrCreateEvent(EVENTS.CheckpointConfirm)

-- ============== Server Handlers ==============
-- Delete handler
DeleteEvent.OnServerEvent:Connect(function(player, targetName)
    if typeof(targetName) ~= "string" then return end
    if not isAdmin(player) then
        warn(('[DeleteObjectEvent] %s bukan admin — permintaan diabaikan'):format(player.Name))
        return
    end
    local target = findAllowedObject(targetName)
    if not target then
        warn(('[DeleteObjectEvent] Objek "%s" tidak ditemukan dalam AllowedFolders'):format(tostring(targetName)))
        return
    end
    print(('[DeleteObjectEvent] Admin %s menghapus %s (class=%s)'):format(player.Name, target:GetFullName(), target.ClassName))
    -- Simpan salinan di ServerStorage sebelum dihapus (opsional restore)
    local copy
    pcall(function()
        copy = target:Clone()
        copy.Parent = ServerStorage
        copy.Name = target.Name .. "_backup_" .. os.time()
    end)
    target:Destroy()
end)

-- Kick handler
KickEvent.OnServerEvent:Connect(function(player, targetName, reason)
    if typeof(targetName) ~= "string" then return end
    if not isAdmin(player) then return end
    local target = Players:FindFirstChild(targetName)
    if not target then return end
    reason = reason or "Di-kick oleh admin"
    print(('[KickEvent] Admin %s meng-kick %s (alasan: %s)'):format(player.Name, target.Name, reason))
    target:Kick(reason)
end)

-- Fly handler (toggle fly on target)
FlyEvent.OnServerEvent:Connect(function(player, targetName, enable)
    if typeof(targetName) ~= "string" then return end
    if not isAdmin(player) then return end
    local target = Players:FindFirstChild(targetName)
    if not target then return end
    FlyEvent:FireClient(target, enable == true)
    print(('[FlyEvent] Admin %s set fly %s untuk %s'):format(player.Name, tostring(enable), target.Name))
end)

-- Checkpoint handler: ketika client laporkan checkpoint, tambahkan leaderstats.Summit dan konfirmasi balik
CheckpointReachedEvent.OnServerEvent:Connect(function(player, checkpointName)
    if typeof(checkpointName) ~= "string" then return end
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local summit = leaderstats:FindFirstChild("Summit")
        if summit and summit:IsA("NumberValue") then
            summit.Value = summit.Value + 1
        end
    end
    CheckpointConfirmEvent:FireClient(player, checkpointName)
    print(('[CheckpointReached] %s mencapai %s — Summit++'):format(player.Name, checkpointName))
end)

-- ============== Inject LocalScript ke StarterGui ==============
local localScriptSource = [[
-- Admin Client Script (diinject otomatis oleh installer server)
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local DeleteEvent = ReplicatedStorage:WaitForChild("DeleteObjectEvent")
local FlyEvent = ReplicatedStorage:WaitForChild("FlyEvent")
local KickEvent = ReplicatedStorage:WaitForChild("KickEvent")
local CheckpointReachedEvent = ReplicatedStorage:WaitForChild("CheckpointReachedEvent")
local CheckpointConfirmEvent = ReplicatedStorage:WaitForChild("CheckpointConfirmEvent")

local function isLocalAdmin()
    return true
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdminToolGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 220)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundTransparency = 0.2
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -10, 0, 28)
title.Position = UDim2.new(0, 5, 0, 5)
title.Text = "Admin Panel"
title.TextScaled = true
title.BackgroundTransparency = 1
title.Parent = frame

local input = Instance.new("TextBox")
input.Size = UDim2.new(1, -20, 0, 28)
input.Position = UDim2.new(0, 10, 0, 40)
input.PlaceholderText = "Masukkan nama Part/Model atau Player"
input.Parent = frame

local deleteBtn = Instance.new("TextButton")
deleteBtn.Size = UDim2.new(0, 100, 0, 28)
deleteBtn.Position = UDim2.new(0, 10, 0, 80)
deleteBtn.Text = "Hapus"
deleteBtn.Parent = frame

local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0, 100, 0, 28)
flyBtn.Position = UDim2.new(0, 120, 0, 80)
flyBtn.Text = "Toggle Fly"
flyBtn.Parent = frame

local kickBtn = Instance.new("TextButton")
kickBtn.Size = UDim2.new(0, 100, 0, 28)
kickBtn.Position = UDim2.new(0, 10, 0, 118)
kickBtn.Text = "Kick"
kickBtn.Parent = frame

local teleportBtn = Instance.new("TextButton")
teleportBtn.Size = UDim2.new(0, 100, 0, 28)
teleportBtn.Position = UDim2.new(0, 120, 0, 118)
teleportBtn.Text = "Teleport To"
teleportBtn.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 36)
status.Position = UDim2.new(0, 10, 1, -44)
status.Text = "Ready"
status.TextWrapped = true
status.BackgroundTransparency = 1
status.Parent = frame

local flying = false
local flightObjects = {}

FlyEvent.OnClientEvent:Connect(function(enable)
    if enable then
        if flying then return end
        flying = true
        status.Text = "Fly mode: ON"

        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if hrp and humanoid then
            local bv = Instance.new("BodyVelocity")
            bv.Name = "_AdminFly_BV"
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bv.Velocity = Vector3.new(0,0,0)
            bv.Parent = hrp

            local bg = Instance.new("BodyGyro")
            bg.Name = "_AdminFly_BG"
            bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
            bg.Parent = hrp

            flightObjects.bv = bv
            flightObjects.bg = bg

            local uis = game:GetService("UserInputService")
            local up = 0
            local speed = 50

            uis.InputBegan:Connect(function(input, processed)
                if processed then return end
                if input.KeyCode == Enum.KeyCode.Space then up = 1 end
                if input.KeyCode == Enum.KeyCode.LeftControl then up = -1 end
            end)
            uis.InputEnded:Connect(function(input, processed)
                if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.LeftControl then up = 0 end
            end)

            spawn(function()
                while flying do
                    if hrp and hrp.Parent then
                        local cam = workspace.CurrentCamera
                        local dir = cam.CFrame.LookVector
                        local moveVec = Vector3.new(dir.X, 0, dir.Z) * speed
                        moveVec = moveVec + Vector3.new(0, up * speed, 0)
                        if flightObjects.bv then
                            flightObjects.bv.Velocity = moveVec
                        end
                    else
                        break
                    end
                    wait(0.03)
                end
            end)
        end
    else
        flying = false
        status.Text = "Fly mode: OFF"
        if flightObjects.bv then flightObjects.bv:Destroy() end
        if flightObjects.bg then flightObjects.bg:Destroy() end
        flightObjects = {}
    end
end)

-- Delete button
deleteBtn.MouseButton1Click:Connect(function()
    local name = input.Text
    if name == "" then
        status.Text = "Masukkan nama objek"
        return
    end
    DeleteEvent:FireServer(name)
    status.Text = "Permintaan hapus dikirim"
end)

-- Fly button: toggle fly by requesting server to command target client
flyBtn.MouseButton1Click:Connect(function()
    local name = input.Text
    if name == "" then status.Text = "Masukkan nama player" return end
    FlyEvent:FireServer(name, true)
    status.Text = "Meminta target enable fly"
end)

-- Kick button
kickBtn.MouseButton1Click:Connect(function()
    local name = input.Text
    if name == "" then status.Text = "Masukkan nama player" return end
    KickEvent:FireServer(name, "Dikeluarkan oleh admin")
    status.Text = "Permintaan kick dikirim"
end)

-- Teleport button (teleport admin to part)
teleportBtn.MouseButton1Click:Connect(function()
    local name = input.Text
    if name == "" then status.Text = "Masukkan nama part/map" return end
    local target = workspace:FindFirstChild(name, true)
    if target and target:IsA("BasePart") then
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = target.CFrame + Vector3.new(0, 5, 0)
            status.Text = "Teleport sukses"
        else
            status.Text = "Character tidak tersedia"
        end
    else
        status.Text = "Part tidak ditemukan"
    end
end)

-- Checkpoint confirm display
CheckpointConfirmEvent.OnClientEvent:Connect(function(checkpointName)
    status.Text = ("Checkpoint '%s' tersimpan"):format(checkpointName)
    wait(2)
    status.Text = "Ready"
end)

-- Hide GUI toggle (Ctrl+/)
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.Slash and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        screenGui.Enabled = not screenGui.Enabled
    end
end)
]]

local function injectLocalScript()
    local existing = StarterGui:FindFirstChild("_AdminToolInjector")
    if existing then existing:Destroy() end

    local container = Instance.new("Folder")
    container.Name = "_AdminToolInjector"
    container.Parent = StarterGui

    local ls = Instance.new("LocalScript")
    ls.Name = "AdminClient"
    ls.Source = localScriptSource
    ls.Parent = container
end

injectLocalScript()

print("[AdminSystem_Installer] Selesai menginstal. Taruh script ini di ServerScriptService. Ubah tabel Admins & AllowedFolders sesuai kebutuhan.")
