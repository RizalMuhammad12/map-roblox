--!strict
--[[
    NetworkUtil.luau
    Utilitas Manajemen Jaringan & Validasi Jarak Anti-Exploit
]]

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local NetworkUtil = {}

local DEFAULT_MAX_INTERACTION_DISTANCE = 18.0

-- Mendapatkan atau membuat RemoteEvent secara aman
function NetworkUtil.GetRemoteEvent(name: string): RemoteEvent
	local remote = ReplicatedStorage:FindFirstChild(name)
	if not remote then
		if RunService:IsServer() then
			local newRemote = Instance.new("RemoteEvent")
			newRemote.Name = name
			newRemote.Parent = ReplicatedStorage
			return newRemote
		else
			remote = ReplicatedStorage:WaitForChild(name, 10)
			if not remote then
				error("[NetworkUtil] Gagal menemukan RemoteEvent: " .. name)
			end
		end
	end
	return remote :: RemoteEvent
end

-- Validasi keamanan: memastikan posisi karakter pemain dalam jarak wajar dari target
function NetworkUtil.ValidatePlayerDistance(player: Player, targetPosition: Vector3, maxDistance: number?): boolean
	local maxDist = maxDistance or DEFAULT_MAX_INTERACTION_DISTANCE
	local character = player.Character
	if not character then
		return false
	end

	local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
	if not rootPart or not (rootPart:IsA("BasePart")) then
		return false
	end

	local distance = (rootPart.Position - targetPosition).Magnitude
	return distance <= maxDist
end

return NetworkUtil
