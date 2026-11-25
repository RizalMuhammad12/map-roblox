--!strict
--[[
    QuestService.luau
    Modul Server Pengelola Status Misi Pemain BATAS KAWASAN
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local QuestDefinitions = require(Shared:WaitForChild("QuestDefinitions") :: ModuleScript)
local NetworkUtil = require(Shared:WaitForChild("NetworkUtil") :: ModuleScript)

export type PlayerQuestData = {
	questId: number,
	objectiveIndex: number,
	progress: number,
	state: QuestDefinitions.QuestState,
}

local QuestService = {}
local playerData: { [Player]: PlayerQuestData } = {}
local missionUpdateRemote: RemoteEvent

function QuestService.Init()
	missionUpdateRemote = NetworkUtil.GetRemoteEvent("MissionUpdate")
	print("[QuestService] Engine Misi berhasil diinisialisasi.")
end

-- Sinkronisasi status misi ke client
function QuestService.SyncClient(player: Player, isCompleted: boolean?)
	local data = playerData[player]
	if not data then
		return
	end

	local quest = QuestDefinitions.GetQuest(data.questId)
	if not quest then
		return
	end

	local currentObjective = quest.objectives[data.objectiveIndex]
	local objectiveText = currentObjective and currentObjective.description or "Semua objektif selesai."
	local totalObjectives = #quest.objectives
	local progressStr = string.format("%d/%d", data.objectiveIndex - 1, totalObjectives)

	if isCompleted or data.state == "Completed" then
		progressStr = string.format("%d/%d", totalObjectives, totalObjectives)
		missionUpdateRemote:FireClient(
			player,
			string.format("MISI %02d SELESAI!", quest.id),
			string.format("Selamat! Kamu telah menyelesaikan misi: %s.", quest.title),
			progressStr,
			true
		)
	else
		local titleStr = string.format("MISI %02d: %s", quest.id, string.upper(quest.title))
		local descStr = string.format("[%s] %s\nObjektif: %s", quest.location, quest.summary, objectiveText)
		missionUpdateRemote:FireClient(
			player,
			titleStr,
			descStr,
			progressStr,
			false
		)
	end
end

-- Memulai pemain baru atau pemain yang baru join
function QuestService.StartPlayer(player: Player)
	if not playerData[player] then
		playerData[player] = {
			questId = 1,
			objectiveIndex = 1,
			progress = 0,
			state = "InProgress",
		}
	end

	task.delay(1.5, function()
		if player.Parent then
			QuestService.SyncClient(player)
		end
	end)
end

function QuestService.GetPlayerData(player: Player): PlayerQuestData?
	return playerData[player]
end

-- Maju ke objektif berikutnya
function QuestService.AdvanceObjective(player: Player, questId: number, objectiveId: string): boolean
	local data = playerData[player]
	if not data then
		return false
	end

	if data.questId ~= questId or data.state == "Completed" then
		return false
	end

	local quest = QuestDefinitions.GetQuest(questId)
	if not quest then
		return false
	end

	local currentObjective = quest.objectives[data.objectiveIndex]
	if not currentObjective or currentObjective.id ~= objectiveId then
		return false
	end

	data.progress += 1
	if data.progress >= currentObjective.targetCount then
		data.progress = 0
		data.objectiveIndex += 1

		-- Jika seluruh objektif dalam misi ini selesai
		if data.objectiveIndex > #quest.objectives then
			data.state = "Completed"
			QuestService.SyncClient(player, true)

			-- Otomatis lanjutkan ke misi berikutnya setelah jeda waktu
			local nextQuestId = questId + 1
			if QuestDefinitions.GetQuest(nextQuestId) then
				task.delay(6, function()
					if player.Parent then
						data.questId = nextQuestId
						data.objectiveIndex = 1
						data.progress = 0
						data.state = "InProgress"
						QuestService.SyncClient(player)
						print(string.format("[QuestService] %s memulai Misi %02d", player.Name, nextQuestId))
					end
				end)
			else
				print(string.format("[QuestService] %s telah menyelesaikan seluruh misi!", player.Name))
			end
		else
			QuestService.SyncClient(player)
		end

		print(string.format("[QuestService] %s progres objektif: %s (Misi %d)", player.Name, objectiveId, questId))
		return true
	end

	QuestService.SyncClient(player)
	return true
end

function QuestService.RemovePlayer(player: Player)
	playerData[player] = nil
end

return QuestService
