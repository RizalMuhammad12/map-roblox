
local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Hapus GUI lama jika ada
local oldGui = playerGui:FindFirstChild("BatasKawasanDialogue")
if oldGui then
	oldGui:Destroy()
end

-- Buat GUI utama
local gui = Instance.new("ScreenGui")
gui.Name = "BatasKawasanDialogue"
gui.ResetOnSpawn = false
gui.DisplayOrder = 20
gui.Parent = playerGui

-- Frame dialog
local frame = Instance.new("Frame")
frame.Name = "DialogueFrame"
frame.Size = UDim2.new(0.75, 0, 0, 180)
frame.Position = UDim2.new(0.125, 0, 0.72, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 23, 30)
frame.BackgroundTransparency = 0.05
frame.Visible = false
frame.Active = true
frame.ZIndex = 2
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(170, 35, 35)
stroke.Thickness = 2
stroke.Parent = frame

-- Judul
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 0, 40)
title.Position = UDim2.new(0, 15, 0, 10)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(230, 65, 65)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 3
title.Parent = frame

-- Isi dialog
local content = Instance.new("TextLabel")
content.Size = UDim2.new(1, -30, 0, 85)
content.Position = UDim2.new(0, 15, 0, 55)
content.BackgroundTransparency = 1
content.TextColor3 = Color3.fromRGB(240, 240, 240)
content.TextSize = 17
content.Font = Enum.Font.Gotham
content.TextWrapped = true
content.TextXAlignment = Enum.TextXAlignment.Left
content.TextYAlignment = Enum.TextYAlignment.Top
content.ZIndex = 3
content.Parent = frame

-- Tombol tutup
local close = Instance.new("TextButton")
close.Name = "CloseButton"
close.Size = UDim2.new(0, 120, 0, 35)
close.Position = UDim2.new(1, -135, 1, -45)
close.BackgroundColor3 = Color3.fromRGB(150, 35, 35)
close.TextColor3 = Color3.new(1, 1, 1)
close.Text = "TUTUP [E]"
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.Active = true
close.Selectable = true
close.AutoButtonColor = true
close.ZIndex = 5
close.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = close

-- Fungsi menutup dialog
local dialogVersion = 0
local lastOpenTime = 0

local function hideDialog()
	dialogVersion += 1
	frame.Visible = false
end

-- Tombol PC dan HP
close.Activated:Connect(hideDialog)

-- Tombol E, Escape, dan Gamepad untuk menutup dialog
UserInputService.InputBegan:Connect(function(input, processed)
	if frame.Visible then
		-- Jika menekan tombol E setelah jeda singkat (agar tidak tertutup instan saat memicu prompt)
		if input.KeyCode == Enum.KeyCode.E then
			if os.clock() - lastOpenTime > 0.25 then
				hideDialog()
			end
		elseif input.KeyCode == Enum.KeyCode.Escape
			or input.KeyCode == Enum.KeyCode.ButtonB
			or input.KeyCode == Enum.KeyCode.ButtonX then
			hideDialog()
		end
	end
end)

-- Tampilkan dialog
ProximityPromptService.PromptTriggered:Connect(function(prompt, triggeringPlayer)

	if triggeringPlayer and triggeringPlayer ~= player then
		return
	end

	local dialogTitle = prompt:GetAttribute("DialogTitle")
	local dialogText = prompt:GetAttribute("DialogText")

	if not dialogTitle or not dialogText then
		return
	end

	dialogVersion += 1
	local currentVersion = dialogVersion
	lastOpenTime = os.clock()

	title.Text = dialogTitle
	content.Text = dialogText
	frame.Visible = true

	-- Otomatis tutup setelah 15 detik
	task.delay(15, function()
		if dialogVersion == currentVersion then
			frame.Visible = false
		end
	end)
end)

print("Dialogue System FIX berhasil dimuat!")
