--!strict
--[[
    Script.server.luau
    Server Utama BATAS KAWASAN — Quest Engine & Interaksi Dunia (Fase 1 s/d 4: Prologue s/d Chapter 4)
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ProximityPromptService = game:GetService("ProximityPromptService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local QuestService = require(script.Parent:WaitForChild("QuestService") :: ModuleScript)
local DialogueData = require(Shared:WaitForChild("DialogueData") :: ModuleScript)
local NetworkUtil = require(Shared:WaitForChild("NetworkUtil") :: ModuleScript)

-- Inisialisasi Quest Engine
QuestService.Init()

-- Folder Gameplay & NPCs & MissionObjects
local gameplayFolder = workspace:WaitForChild("Gameplay")
local npcFolder = gameplayFolder:WaitForChild("NPCs")

local missionObjectsFolder = workspace:FindFirstChild("MissionObjects")
if not missionObjectsFolder then
	missionObjectsFolder = Instance.new("Folder")
	missionObjectsFolder.Name = "MissionObjects"
	missionObjectsFolder.Parent = workspace
end

--------------------------------------------------------------------------------
-- HELPER: Pembuatan / Pengaturan Model NPC Sederhana
--------------------------------------------------------------------------------
local function ensureNPC(name: string, position: Vector3, dialogKey: string, actionText: string, objectText: string): Model
	local existing = npcFolder:FindFirstChild(name)
	if existing and existing:IsA("Model") then
		local torso = existing:FindFirstChild("Torso") or existing:FindFirstChild("HumanoidRootPart")
		if torso then
			local prompt = torso:FindFirstChild("TalkPrompt")
			if prompt and prompt:IsA("ProximityPrompt") then
				local entry = DialogueData.Get(dialogKey)
				if entry then
					prompt:SetAttribute("DialogTitle", entry.title)
					prompt:SetAttribute("DialogText", entry.text)
				end
			end
		end
		return existing
	end

	local npcModel = Instance.new("Model")
	npcModel.Name = name

	local humanoid = Instance.new("Humanoid")
	humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
	humanoid.DisplayName = objectText
	humanoid.MaxHealth = 100
	humanoid.Health = 100
	humanoid.Parent = npcModel

	-- Torso
	local torso = Instance.new("Part")
	torso.Name = "Torso"
	torso.Size = Vector3.new(2, 2, 1)
	torso.Position = position + Vector3.new(0, 3, 0)
	torso.Anchored = true
	torso.CanCollide = true
	torso.Material = Enum.Material.SmoothPlastic
	torso.Color = Color3.fromRGB(45, 65, 95)
	torso.Parent = npcModel

	-- Head
	local head = Instance.new("Part")
	head.Name = "Head"
	head.Size = Vector3.new(1.25, 1.25, 1.25)
	head.Position = torso.Position + Vector3.new(0, 1.6, 0)
	head.Anchored = true
	head.CanCollide = true
	head.Material = Enum.Material.SmoothPlastic
	head.Color = Color3.fromRGB(225, 185, 150)
	head.Parent = npcModel

	-- ProximityPrompt
	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "TalkPrompt"
	prompt.ActionText = actionText
	prompt.ObjectText = objectText
	prompt.KeyboardKeyCode = Enum.KeyCode.E
	prompt.HoldDuration = 0.5
	prompt.MaxActivationDistance = 12
	prompt.RequiresLineOfSight = false

	local entry = DialogueData.Get(dialogKey)
	if entry then
		prompt:SetAttribute("DialogTitle", entry.title)
		prompt:SetAttribute("DialogText", entry.text)
	end
	prompt.Parent = torso

	npcModel.PrimaryPart = torso
	npcModel.Parent = npcFolder
	return npcModel
end

--------------------------------------------------------------------------------
-- HELPER: Pembuatan Objek Petunjuk / Bukti Fisik Interaktif
--------------------------------------------------------------------------------
local function ensureClueObject(name: string, position: Vector3, size: Vector3, color: Color3, material: Enum.Material, dialogKey: string, actionText: string, objectText: string, hasLight: boolean?): BasePart
	local existing = (missionObjectsFolder :: Folder):FindFirstChild(name)
	if existing and existing:IsA("BasePart") then
		return existing
	end

	local part = Instance.new("Part")
	part.Name = name
	part.Size = size
	part.Position = position
	part.Anchored = true
	part.CanCollide = true
	part.Color = color
	part.Material = material
	part.Parent = missionObjectsFolder

	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = name .. "_Prompt"
	prompt.ActionText = actionText
	prompt.ObjectText = objectText
	prompt.KeyboardKeyCode = Enum.KeyCode.E
	prompt.HoldDuration = 0.5
	prompt.MaxActivationDistance = 12
	prompt.RequiresLineOfSight = false

	local entry = DialogueData.Get(dialogKey)
	if entry then
		prompt:SetAttribute("DialogTitle", entry.title)
		prompt:SetAttribute("DialogText", entry.text)
	end
	prompt.Parent = part

	if hasLight then
		local light = Instance.new("PointLight")
		light.Color = Color3.fromRGB(255, 60, 60)
		light.Brightness = 1.2
		light.Range = 9
		light.Parent = part
	end

	return part
end

--------------------------------------------------------------------------------
-- SETUP NPC MISI PROLOGUE (KAMPUS)
--------------------------------------------------------------------------------
-- 1. Mahasiswa Kampus (Misi 1: A Normal Day)
local studentModel = npcFolder:FindFirstChild("Mahasiswa_Kampus")
if studentModel then
	local torso = studentModel:FindFirstChild("Torso")
	if torso then
		local prompt = torso:FindFirstChild("TalkPrompt")
		if prompt then
			local entry = DialogueData.Get("Mahasiswa_Kampus_Default")
			if entry then
				prompt:SetAttribute("DialogTitle", entry.title)
				prompt:SetAttribute("DialogText", entry.text)
			end
		end
	end
end

-- 2. Teman Mahasiswa di Kantin Kampus (Misi 2: Meet the Crew - Objektif 1)
local canteenFriend = ensureNPC(
	"Teman_Kantin",
	Vector3.new(-190, 0.5, 385),
	"Teman_Kantin_Default",
	"Bicara",
	"Teman Mahasiswa (Kantin)"
)

-- 3. MC 2 di Parkiran Kampus (Misi 2: Meet the Crew - Objektif 2)
local mc2Parking = ensureNPC(
	"MC_2_Parkir",
	Vector3.new(-190, 0.5, 320),
	"MC2_Parkiran_Default",
	"Bicara",
	"MC 2 (Parkiran)"
)

--------------------------------------------------------------------------------
-- SETUP OBJEK & NPC CHAPTER 1 (PERMUKIMAN)
--------------------------------------------------------------------------------
-- Rumah MC 1 berpusat di House_01 (X: -500, Z: -325)
local house01Center = Vector3.new(-500, 1.0, -325)

-- 1. Surat Peringatan Utang di teras rumah MC 1 (Misi 3 Objektif 2)
local debtLetter = ensureClueObject(
	"Surat_Utang",
	Vector3.new(-500, 1.6, -318),
	Vector3.new(1.2, 0.1, 1.2),
	Color3.fromRGB(240, 235, 210),
	Enum.Material.SmoothPlastic,
	"Surat_Utang_Prompt",
	"Periksa",
	"Surat Peringatan Utang",
	true
)

-- 2. NPC Penagih Utang di depan pagar rumah MC 1 (Misi 3 Objektif 3)
local debtCollector = ensureNPC(
	"Penagih_Utang",
	Vector3.new(-485, 0.5, -315),
	"Penagih_Utang_Confront",
	"Bicara",
	"Penagih Utang"
)
if debtCollector and debtCollector.PrimaryPart then
	debtCollector.PrimaryPart.Color = Color3.fromRGB(80, 20, 20)
end

-- 3. Kamar Adik Berantakan di House_01 (Misi 4 Objektif 1)
local sisterRoomClue = ensureClueObject(
	"Kamar_Adik_Terganggu",
	Vector3.new(-500, 1.5, -338),
	Vector3.new(1.5, 0.3, 1.5),
	Color3.fromRGB(200, 50, 50),
	Enum.Material.Neon,
	"Kamar_Adik_Terganggu",
	"Periksa",
	"Kamar Adik Perempuan",
	true
)

-- 4. Pemilik Warung (Misi 4 Objektif 2: Saksi Mata)
local warungOwner = npcFolder:FindFirstChild("Pemilik_Warung")
if warungOwner then
	local torso = warungOwner:FindFirstChild("Torso")
	if torso then
		local prompt = torso:FindFirstChild("TalkPrompt")
		if prompt then
			local entry = DialogueData.Get("Pemilik_Warung_Saksi")
			if entry then
				prompt:SetAttribute("DialogTitle", entry.title)
				prompt:SetAttribute("DialogText", entry.text)
			end
		end
	end
end

-- 5. Jejak Ban Kendaraan di jalan keluar permukiman (Misi 4 Objektif 3)
local tireTracks = ensureClueObject(
	"Jejak_Ban_Hitam",
	Vector3.new(-120, 0.15, -250),
	Vector3.new(6.0, 0.05, 3.0),
	Color3.fromRGB(25, 25, 25),
	Enum.Material.SmoothPlastic,
	"Jejak_Ban_Hitam",
	"Periksa",
	"Jejak Ban Mobil",
	false
)

--------------------------------------------------------------------------------
-- SETUP OBJEK & NPC CHAPTER 2 (PUSAT KOTA)
--------------------------------------------------------------------------------
-- 1. Mekanik di Bengkel Motor (Misi 5 Objektif 1)
local mechanicNPC = ensureNPC(
	"Mekanik_Bengkel",
	Vector3.new(180, 0.5, 160),
	"Mekanik_Bengkel_Info",
	"Bicara",
	"Mekanik Bengkel"
)
if mechanicNPC and mechanicNPC.PrimaryPart then
	mechanicNPC.PrimaryPart.Color = Color3.fromRGB(60, 80, 100)
end

-- 2. Arsip Rekaman CCTV Kota di depan pertokoan Shop_01 (Misi 5 Objektif 2)
local citySecurityCam = ensureClueObject(
	"Arsip_Keamanan_Kota",
	Vector3.new(200, 1.5, 345),
	Vector3.new(1.0, 1.5, 1.0),
	Color3.fromRGB(40, 160, 220),
	Enum.Material.Neon,
	"Arsip_Keamanan_Kota",
	"Periksa",
	"Rekaman CCTV Kota",
	true
)

-- 3. MC 2 di Parkiran Pusat Kota (Misi 6 Objektif 1)
local mc2City = ensureNPC(
	"MC_2_City",
	Vector3.new(350, 0.5, 220),
	"MC2_Konfrontasi_Kota",
	"Konfrontasi",
	"MC 2 (Pusat Kota)"
)
if mc2City and mc2City.PrimaryPart then
	mc2City.PrimaryPart.Color = Color3.fromRGB(120, 25, 25)
end

-- 4. Pencocokan Bukti Lambang Ular Hitam (Misi 6 Objektif 2)
local jointEvidence = ensureClueObject(
	"Bukti_Gabungan",
	Vector3.new(353, 0.8, 220),
	Vector3.new(1.5, 0.2, 1.5),
	Color3.fromRGB(230, 45, 45),
	Enum.Material.Neon,
	"MC2_Benang_Merah",
	"Cocokkan Bukti",
	"Simbol Ular Hitam",
	true
)

--------------------------------------------------------------------------------
-- SETUP OBJEK & NPC CHAPTER 3 (KAMPUS & PERSIAPAN TIM)
--------------------------------------------------------------------------------
-- Area Taman Kampus (X: -440, Z: 400)
local campusMeetingSpot = Vector3.new(-440, 1.0, 400)

-- 1. Kelompok 5 Teman yang Menolak (Misi 7 Objektif 2)
local friendsReject = ensureNPC(
	"Teman_Menolak",
	Vector3.new(-445, 0.5, 398),
	"Teman_Menolak_Dialog",
	"Dengarkan",
	"Kelompok Teman Menolak"
)
if friendsReject and friendsReject.PrimaryPart then
	friendsReject.PrimaryPart.Color = Color3.fromRGB(110, 110, 110)
end

-- 2. Kelompok 7 Teman yang Membantu (Misi 7 Objektif 2)
local friendsHelp = ensureNPC(
	"Teman_Membantu",
	Vector3.new(-435, 0.5, 402),
	"Teman_Membantu_Dialog",
	"Bicara",
	"Kelompok 7 Teman Membantu"
)
if friendsHelp and friendsHelp.PrimaryPart then
	friendsHelp.PrimaryPart.Color = Color3.fromRGB(45, 140, 80)
end

-- 3. Meja Taktik / Andi (Strategist) di area kantin kampus (Misi 8 Objektif 1)
local strategistNPC = ensureNPC(
	"Strategist_Teman",
	Vector3.new(-190, 0.5, 375),
	"Strategist_Role_Briefing",
	"Bahas Taktik",
	"Andi (Strategist)"
)
if strategistNPC and strategistNPC.PrimaryPart then
	strategistNPC.PrimaryPart.Color = Color3.fromRGB(30, 90, 150)
end

-- 4. Pos Pengamatan Jalur Markas Timur (X: 250, Z: -230)
local scoutSpot = Vector3.new(250, 0.5, -230)

local scoutNPC = ensureNPC(
	"Scout_Teman",
	Vector3.new(250, 0.5, -230),
	"Scout_Pos_Pengamatan",
	"Pantau",
	"Dani (Scout)"
)
if scoutNPC and scoutNPC.PrimaryPart then
	scoutNPC.PrimaryPart.Color = Color3.fromRGB(150, 120, 40)
end

-- 5. Dokumen Denah Markas (Misi 9 Objektif 2)
local intelMap = ensureClueObject(
	"Denah_Markas_Intel",
	Vector3.new(253, 0.8, -230),
	Vector3.new(1.5, 0.1, 1.5),
	Color3.fromRGB(240, 220, 100),
	Enum.Material.SmoothPlastic,
	"Denah_Markas_Intel",
	"Ambil",
	"Dokumen Denah Markas",
	true
)

--------------------------------------------------------------------------------
-- SETUP OBJEK & NPC CHAPTER 4 (INFILTRASI MARKAS & STEALTH)
--------------------------------------------------------------------------------
-- 1. Celah Pagar Barat (Misi 10 Objektif 1)
local fenceGap = ensureClueObject(
	"Celah_Pagar_Barat",
	Vector3.new(172, 1.2, -320),
	Vector3.new(3.0, 3.0, 0.5),
	Color3.fromRGB(70, 75, 80),
	Enum.Material.Metal,
	"Celah_Pagar_Stealth",
	"Menyusup",
	"Celah Pagar Kawat",
	false
)

-- 2. Sel Tahanan Adik di Ruang Interogasi Basement (Misi 10 Objektif 2)
local sisterCell = ensureClueObject(
	"Sel_Tahanan_Adik",
	Vector3.new(310, -6.5, -340),
	Vector3.new(2.5, 4.0, 2.5),
	Color3.fromRGB(180, 45, 45),
	Enum.Material.Metal,
	"Sel_Tahanan_Adik_Prompt",
	"Intip",
	"Ruang Interogasi Basement",
	true
)

-- 3. Berkas Dokumen Kakak MC 2 di Ruang Kontrol Gudang (Misi 10 Objektif 3)
local brotherDossier = ensureClueObject(
	"Dokumen_Kakak_MC2",
	Vector3.new(390, 3.5, -300),
	Vector3.new(1.5, 0.2, 1.5),
	Color3.fromRGB(255, 215, 0),
	Enum.Material.Neon,
	"Dokumen_Kakak_MC2_Prompt",
	"Ambil",
	"Berkas Rahasia BLACK SERPENT",
	true
)

-- 4. Titik Pelarian Menuju Jalan Raya (Misi 11 Objektif 2)
local escapeHighwayPoint = ensureClueObject(
	"Titik_Pelarian_Jalan",
	Vector3.new(280, 0.5, -50),
	Vector3.new(5.0, 0.2, 5.0),
	Color3.fromRGB(45, 180, 75),
	Enum.Material.Neon,
	"Pelarian_Jalan_Raya",
	"Kabur",
	"Jalan Raya Luar Markas",
	true
)

-- 5. Lampu Alarm Sirene Markas (Aktif saat terdeteksi)
local alarmLightPart = (missionObjectsFolder :: Folder):FindFirstChild("Sirene_Alarm_Markas")
if not alarmLightPart then
	local siren = Instance.new("Part")
	siren.Name = "Sirene_Alarm_Markas"
	siren.Size = Vector3.new(2, 2, 2)
	siren.Position = Vector3.new(350, 18, -250)
	siren.Anchored = true
	siren.CanCollide = false
	siren.Material = Enum.Material.Neon
	siren.Color = Color3.fromRGB(120, 20, 20)
	siren.Parent = missionObjectsFolder

	local light = Instance.new("PointLight")
	light.Name = "AlarmLight"
	light.Color = Color3.fromRGB(255, 20, 20)
	light.Brightness = 0
	light.Range = 60
	light.Parent = siren
end

local function triggerHQAlarm()
	local siren = (missionObjectsFolder :: Folder):FindFirstChild("Sirene_Alarm_Markas")
	if siren and siren:IsA("BasePart") then
		local light = siren:FindFirstChild("AlarmLight")
		if light and light:IsA("PointLight") then
			task.spawn(function()
				for _ = 1, 15 do
					light.Brightness = 3
					siren.Color = Color3.fromRGB(255, 30, 30)
					task.wait(0.4)
					light.Brightness = 0.2
					siren.Color = Color3.fromRGB(80, 10, 10)
					task.wait(0.4)
				end
				light.Brightness = 0
			end)
		end
	end
end

--------------------------------------------------------------------------------
-- LOGIKA PEMAIN & DETEKSI POSISI WILAYAH
--------------------------------------------------------------------------------
local campusSpawnPos = Vector3.new(-350, 0.5, 285)

local function onCharacterAdded(player: Player, character: Model)
	local rootPart = character:WaitForChild("HumanoidRootPart", 10) or character:WaitForChild("Torso", 10)
	if not rootPart or not rootPart:IsA("BasePart") then
		return
	end

	task.spawn(function()
		while character.Parent do
			task.wait(1)
			local data = QuestService.GetPlayerData(player)
			if not data then
				continue
			end

			local currentPos = (rootPart :: BasePart).Position

			-- Misi 1 Objektif 1: Eksplorasi kampus (jarak >= 25 stud dari spawn)
			if data.questId == 1 and data.objectiveIndex == 1 then
				local distanceFromSpawn = (currentPos - campusSpawnPos).Magnitude
				if distanceFromSpawn >= 25 then
					QuestService.AdvanceObjective(player, 1, "explore_campus")
					print(string.format("[Prologue] %s berhasil menjelajahi area kampus!", player.Name))
				end

			-- Misi 3 Objektif 1: Kunjungi rumah MC 1 di permukiman (mendekati House_01)
			elseif data.questId == 3 and data.objectiveIndex == 1 then
				local distToHouse = (currentPos - house01Center).Magnitude
				if distToHouse <= 35 then
					QuestService.AdvanceObjective(player, 3, "visit_home")
					print(string.format("[Chapter 1] %s tiba di rumah keluarga di permukiman!", player.Name))
				end

			-- Misi 7 Objektif 1: Kumpulkan teman di taman kampus
			elseif data.questId == 7 and data.objectiveIndex == 1 then
				local distToMeeting = (currentPos - campusMeetingSpot).Magnitude
				if distToMeeting <= 35 then
					QuestService.AdvanceObjective(player, 7, "call_meeting")
					print(string.format("[Chapter 3] %s mengumpulkan teman di taman kampus!", player.Name))
				end

			-- Misi 9 Objektif 1: Pantau jalur akses markas industri timur
			elseif data.questId == 9 and data.objectiveIndex == 1 then
				local distToScout = (currentPos - scoutSpot).Magnitude
				if distToScout <= 35 then
					QuestService.AdvanceObjective(player, 9, "scout_perimeter")
					print(string.format("[Chapter 3] %s memantau perimeter markas!", player.Name))
				end

			-- Misi 11 Objektif 1: Hindari kejaran penjaga & melintasi parkiran markas
			elseif data.questId == 11 and data.objectiveIndex == 1 then
				local distToParkingExit = (currentPos - Vector3.new(330, 0.5, -170)).Magnitude
				if distToParkingExit <= 55 then
					QuestService.AdvanceObjective(player, 11, "evade_patrols")
					print(string.format("[Chapter 4] %s berhasil menerobos area parkiran markas dan menghindari kejaran penjaga!", player.Name))
				end
			end
		end
	end)
end

Players.PlayerAdded:Connect(function(player)
	QuestService.StartPlayer(player)

	player.CharacterAdded:Connect(function(character)
		onCharacterAdded(player, character)
	end)

	if player.Character then
		onCharacterAdded(player, player.Character)
	end
end)

Players.PlayerRemoving:Connect(function(player)
	QuestService.RemovePlayer(player)
end)

--------------------------------------------------------------------------------
-- PENANGAN INTERAKSI PROXIMITY PROMPT
--------------------------------------------------------------------------------
ProximityPromptService.PromptTriggered:Connect(function(triggeredPrompt, player)
	local parentPart = triggeredPrompt.Parent
	if not parentPart or not parentPart:IsA("BasePart") then
		return
	end

	-- Validasi keamanan jarak server
	if not NetworkUtil.ValidatePlayerDistance(player, parentPart.Position, 18) then
		warn(string.format("[Security] %s mencoba memicu prompt di luar jarak aman!", player.Name))
		return
	end

	local objName = parentPart.Name
	local parentModel = parentPart.Parent
	local modelName = parentModel and parentModel.Name or ""

	local questData = QuestService.GetPlayerData(player)
	if not questData then
		return
	end

	----------------------------------------------------------------------------
	-- PROLOGUE: MISI 1 & 2 (KAMPUS)
	----------------------------------------------------------------------------
	if modelName == "Mahasiswa_Kampus" then
		if questData.questId == 1 and questData.objectiveIndex == 2 then
			QuestService.AdvanceObjective(player, 1, "talk_student")
			print(string.format("[Prologue] %s menyelesaikan Misi 1!", player.Name))
		end

	elseif modelName == "Teman_Kantin" then
		if questData.questId == 2 and questData.objectiveIndex == 1 then
			QuestService.AdvanceObjective(player, 2, "meet_friends")
			print(string.format("[Prologue] %s menemui teman-teman di kantin!", player.Name))
		end

	elseif modelName == "MC_2_Parkir" then
		if questData.questId == 2 and questData.objectiveIndex == 2 then
			QuestService.AdvanceObjective(player, 2, "encounter_mc2")
			print(string.format("[Prologue] %s menyelesaikan Misi 2 & Prologue!", player.Name))
		end

	----------------------------------------------------------------------------
	-- CHAPTER 1: MISI 3 & 4 (PERMUKIMAN)
	----------------------------------------------------------------------------
	elseif objName == "Surat_Utang" then
		if questData.questId == 3 and questData.objectiveIndex == 2 then
			QuestService.AdvanceObjective(player, 3, "inspect_debt_letter")
			print(string.format("[Chapter 1] %s membaca surat peringatan utang!", player.Name))
		end

	elseif modelName == "Penagih_Utang" then
		if questData.questId == 3 and questData.objectiveIndex == 3 then
			QuestService.AdvanceObjective(player, 3, "confront_collector")
			print(string.format("[Chapter 1] %s mengonfrontasi penagih utang & menyelesaikan Misi 3!", player.Name))
		end

	elseif objName == "Kamar_Adik_Terganggu" then
		if questData.questId == 4 and questData.objectiveIndex == 1 then
			QuestService.AdvanceObjective(player, 4, "check_sister_room")
			print(string.format("[Chapter 1] %s memeriksa kamar adik yang diculik!", player.Name))
		end

	elseif modelName == "Pemilik_Warung" then
		if questData.questId == 4 and questData.objectiveIndex == 2 then
			QuestService.AdvanceObjective(player, 4, "talk_warung_owner")
			print(string.format("[Chapter 1] %s mendapatkan kesaksian mobil dari Pemilik Warung!", player.Name))
		end

	elseif objName == "Jejak_Ban_Hitam" then
		if questData.questId == 4 and questData.objectiveIndex == 3 then
			QuestService.AdvanceObjective(player, 4, "find_vehicle_tracks")
			print(string.format("[Chapter 1] %s menemukan jejak ban ke arah timur & menyelesaikan Chapter 1!", player.Name))
		end

	----------------------------------------------------------------------------
	-- CHAPTER 2: MISI 5 & 6 (PUSAT KOTA)
	----------------------------------------------------------------------------
	-- Misi 5 Objektif 1: Mekanik Bengkel Motor
	elseif modelName == "Mekanik_Bengkel" then
		if questData.questId == 5 and questData.objectiveIndex == 1 then
			QuestService.AdvanceObjective(player, 5, "investigate_workshop")
			print(string.format("[Chapter 2] %s mendapatkan info motor kakak MC 2 dari mekanik!", player.Name))
		end

	-- Misi 5 Objektif 2: Rekaman Keamanan Pertokoan
	elseif objName == "Arsip_Keamanan_Kota" then
		if questData.questId == 5 and questData.objectiveIndex == 2 then
			QuestService.AdvanceObjective(player, 5, "check_city_security")
			print(string.format("[Chapter 2] %s melihat rekaman penculikan kakak & menyelesaikan Misi 5!", player.Name))
		end

	-- Misi 6 Objektif 1: Konfrontasi MC 2 di Parkiran Pusat Kota
	elseif modelName == "MC_2_City" then
		if questData.questId == 6 and questData.objectiveIndex == 1 then
			QuestService.AdvanceObjective(player, 6, "confront_each_other")
			print(string.format("[Chapter 2] %s berkonfrontasi dengan MC 2 di pusat kota!", player.Name))
		end

	-- Misi 6 Objektif 2: Cocokkan Petunjuk Simbol Ular Hitam
	elseif objName == "Bukti_Gabungan" then
		if questData.questId == 6 and questData.objectiveIndex == 2 then
			QuestService.AdvanceObjective(player, 6, "match_clues")
			print(string.format("[Chapter 2] %s menyatukan petunjuk BLACK SERPENT & menyelesaikan Chapter 2!", player.Name))
		end

	----------------------------------------------------------------------------
	-- CHAPTER 3: MISI 7, 8 & 9 (KAMPUS & PERSIAPAN TIM)
	----------------------------------------------------------------------------
	-- Misi 7 Objektif 2: Dengarkan Teman yang Membantu / Menolak
	elseif modelName == "Teman_Membantu" or modelName == "Teman_Menolak" then
		if questData.questId == 7 and questData.objectiveIndex == 2 then
			QuestService.AdvanceObjective(player, 7, "listen_responses")
			print(string.format("[Chapter 3] %s menyaksikan perpecahan 12 teman & menyelesaikan Misi 7!", player.Name))
		end

	-- Misi 8 Objektif 1: Briefing Peran Tim 7 Teman (Strategist)
	elseif modelName == "Strategist_Teman" then
		if questData.questId == 8 and questData.objectiveIndex == 1 then
			QuestService.AdvanceObjective(player, 8, "assign_roles")
			print(string.format("[Chapter 3] %s mengunci alokasi 7 peran tim & menyelesaikan Misi 8!", player.Name))
		end

	-- Misi 9 Objektif 2: Ambil Dokumen Denah Markas
	elseif objName == "Denah_Markas_Intel" then
		if questData.questId == 9 and questData.objectiveIndex == 2 then
			QuestService.AdvanceObjective(player, 9, "gather_intel")
			print(string.format("[Chapter 3] %s mengamankan denah markas & menyelesaikan Chapter 3!", player.Name))
		end
	end
end)

print("BATAS KAWASAN — Quest Server Prologue, Chapter 1, 2, & 3 Aktif!")
