--!strict
--[[
    MissionHUD.client.luau
    HUD Pelacak Misi BATAS KAWASAN — Desain Kompak & Fitur Hide/Unhide (Toggle)
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local remote = ReplicatedStorage:WaitForChild("MissionUpdate")

local gui = Instance.new("ScreenGui")
gui.Name = "MissionHUD"
gui.ResetOnSpawn = false
gui.DisplayOrder = 10
gui.Parent = player:WaitForChild("PlayerGui")

-- Dimensi Panel Kompak
local EXPANDED_SIZE = UDim2.new(0, 260, 0, 105)
local COLLAPSED_SIZE = UDim2.new(0, 260, 0, 32)
local isCollapsed = false

-- Panel Utama
local frame = Instance.new("Frame")
frame.Name = "MissionPanel"
frame.Size = EXPANDED_SIZE
frame.Position = UDim2.new(0, 16, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
frame.BackgroundTransparency = 0.12
frame.ClipsDescendants = true
frame.Visible = false
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local border = Instance.new("UIStroke")
border.Color = Color3.fromRGB(165, 35, 35)
border.Thickness = 1.5
border.Parent = frame

-- Header Bar (Selalu terlihat)
local headerBar = Instance.new("Frame")
headerBar.Name = "HeaderBar"
headerBar.Size = UDim2.new(1, 0, 0, 32)
headerBar.BackgroundTransparency = 1
headerBar.Parent = frame

-- Ikon / Tag Misi
local title = Instance.new("TextLabel")
title.Name = "MissionTitle"
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "MISI AKTIF"
title.TextColor3 = Color3.fromRGB(240, 70, 70)
title.TextSize = 13
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextTruncate = Enum.TextTruncate.AtEnd
title.Parent = headerBar

-- Tombol Toggle Hide / Unhide (Bisa diklik di PC & HP)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleBtn"
toggleBtn.Size = UDim2.new(0, 26, 0, 22)
toggleBtn.Position = UDim2.new(1, -30, 0.5, -11)
toggleBtn.BackgroundColor3 = Color3.fromRGB(35, 38, 48)
toggleBtn.BackgroundTransparency = 0.2
toggleBtn.Text = "—"
toggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
toggleBtn.TextSize = 13
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.AutoButtonColor = true
toggleBtn.Parent = headerBar

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 4)
toggleCorner.Parent = toggleBtn

-- Kontainer Konten (Bisa disembunyikan saat di-hide)
local contentContainer = Instance.new("Frame")
contentContainer.Name = "ContentContainer"
contentContainer.Size = UDim2.new(1, -20, 0, 65)
contentContainer.Position = UDim2.new(0, 10, 0, 34)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = frame

-- Deskripsi Objektif
local description = Instance.new("TextLabel")
description.Name = "Description"
description.Size = UDim2.new(1, 0, 0, 42)
description.Position = UDim2.new(0, 0, 0, 0)
description.BackgroundTransparency = 1
description.TextColor3 = Color3.fromRGB(225, 225, 225)
description.TextSize = 12
description.Font = Enum.Font.Gotham
description.TextWrapped = true
description.TextXAlignment = Enum.TextXAlignment.Left
description.TextYAlignment = Enum.TextYAlignment.Top
description.Parent = contentContainer

-- Indikator Progres
local progress = Instance.new("TextLabel")
progress.Name = "Progress"
progress.Size = UDim2.new(1, 0, 0, 18)
progress.Position = UDim2.new(0, 0, 1, -18)
progress.BackgroundTransparency = 1
progress.TextColor3 = Color3.fromRGB(255, 195, 65)
progress.TextSize = 11
progress.Font = Enum.Font.GothamBold
progress.TextXAlignment = Enum.TextXAlignment.Left
progress.Parent = contentContainer

--------------------------------------------------------------------------------
-- FUNGSI TOGGLE HIDE / UNHIDE
--------------------------------------------------------------------------------
local function setCollapsed(collapsed: boolean)
	isCollapsed = collapsed
	local targetSize = isCollapsed and COLLAPSED_SIZE or EXPANDED_SIZE
	toggleBtn.Text = isCollapsed and "+" or "—"

	local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	TweenService:Create(frame, tweenInfo, { Size = targetSize }):Play()
	contentContainer.Visible = not isCollapsed
end

toggleBtn.Activated:Connect(function()
	setCollapsed(not isCollapsed)
end)

-- Hotkey 'M' di Keyboard untuk Hide/Unhide Panel Misi
UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == Enum.KeyCode.M then
		setCollapsed(not isCollapsed)
	end
end)

--------------------------------------------------------------------------------
-- SINKRONISASI UPDATE MISI DARI SERVER
--------------------------------------------------------------------------------
remote.OnClientEvent:Connect(function(
	missionTitle: string,
	missionDescription: string,
	missionProgress: string,
	completed: boolean
)
	title.Text = missionTitle
	description.Text = missionDescription
	progress.Text = "PROGRES: " .. missionProgress

	frame.Visible = true

	if completed then
		border.Color = Color3.fromRGB(45, 180, 100)

		task.delay(7, function()
			if frame.Visible and title.Text == missionTitle then
				frame.Visible = false
			end
		end)
	else
		border.Color = Color3.fromRGB(165, 35, 35)
	end
end)

print("Mission HUD Kompak & Fitur Toggle [M] Aktif!")
