--!strict
--[[
    QuestDefinitions.luau
    Tabel Konfigurasi Misi Resmi BATAS KAWASAN (18 Misi Berdasarkan story.md)
]]

export type QuestState = "NotStarted" | "InProgress" | "ObjectiveMet" | "TurnIn" | "Completed"

export type QuestObjective = {
	id: string,
	description: string,
	targetCount: number,
}

export type QuestDefinition = {
	id: number,
	title: string,
	chapter: string,
	location: string,
	summary: string,
	objectives: { QuestObjective },
}

local QuestDefinitions: { [number]: QuestDefinition } = {
	[1] = {
		id = 1,
		title = "A Normal Day",
		chapter = "Prologue",
		location = "Kampus",
		summary = "Memulai hari di kampus, merasakan suasana perkuliahan dan berinteraksi awal.",
		objectives = {
			{ id = "explore_campus", description = "Jelajahi area sekitar kampus", targetCount = 1 },
			{ id = "talk_student", description = "Bicara dengan Mahasiswa Kampus", targetCount = 1 },
		},
	},

	[2] = {
		id = 2,
		title = "Meet the Crew",
		chapter = "Prologue",
		location = "Kampus",
		summary = "Menemui teman-teman mahasiswa dan perkenalan awal dengan MC 2.",
		objectives = {
			{ id = "meet_friends", description = "Bicara dengan teman-teman di kantin", targetCount = 1 },
			{ id = "encounter_mc2", description = "Pertemuan singkat dengan MC 2 di parkiran", targetCount = 1 },
		},
	},

	[3] = {
		id = 3,
		title = "Family Pressure",
		chapter = "Chapter 1",
		location = "Permukiman",
		summary = "Menghadapi masalah ekonomi keluarga dan ancaman penagih utang di permukiman.",
		objectives = {
			{ id = "visit_home", description = "Kunjungi rumah MC 1 di permukiman", targetCount = 1 },
			{ id = "inspect_debt_letter", description = "Periksa surat peringatan utang", targetCount = 1 },
			{ id = "confront_collector", description = "Hadapi intimidasi antek penagih utang", targetCount = 1 },
		},
	},

	[4] = {
		id = 4,
		title = "Kidnapped!",
		chapter = "Chapter 1",
		location = "Permukiman",
		summary = "Adik perempuan MC 1 diculik oleh kelompok penagih utang. Cari petunjuk jejak pelaku.",
		objectives = {
			{ id = "check_sister_room", description = "Periksa kamar adik perempuan MC 1", targetCount = 1 },
			{ id = "talk_warung_owner", description = "Tanyakan saksi mata ke Pemilik Warung", targetCount = 1 },
			{ id = "find_vehicle_tracks", description = "Lacak jejak kendaraan mencurigakan ke arah timur", targetCount = 1 },
		},
	},

	[5] = {
		id = 5,
		title = "The Missing Brother",
		chapter = "Chapter 2",
		location = "Kota",
		summary = "MC 2 mencari informasi mandiri mengenai hilangnya kakak laki-lakinya.",
		objectives = {
			{ id = "investigate_workshop", description = "Cari informasi di bengkel motor pusat kota", targetCount = 1 },
			{ id = "check_city_security", description = "Periksa rekaman sekitar pertokoan", targetCount = 1 },
		},
	},

	[6] = {
		id = 6,
		title = "Hidden Connection",
		chapter = "Chapter 2",
		location = "Kota",
		summary = "MC 1 dan MC 2 menyadari bahwa masalah kedua keluarga bermuara pada BLACK SERPENT.",
		objectives = {
			{ id = "confront_each_other", description = "Pertemuan tegang MC 1 dan MC 2 di pusat kota", targetCount = 1 },
			{ id = "match_clues", description = "Cocokkan petunjuk simbol ular hitam", targetCount = 1 },
		},
	},

	[7] = {
		id = 7,
		title = "Divided Friends",
		chapter = "Chapter 3",
		location = "Kampus",
		summary = "Pertemuan 12 teman di kampus menghasilkan perpecahan (7 membantu, 5 menolak).",
		objectives = {
			{ id = "call_meeting", description = "Kumpulkan teman-teman di area kampus", targetCount = 1 },
			{ id = "listen_responses", description = "Dengarkan keputusan masing-masing teman", targetCount = 1 },
		},
	},

	[8] = {
		id = 8,
		title = "Seven Stand Together",
		chapter = "Chapter 3",
		location = "Kampus",
		summary = "Menyusun pembagian peran 7 teman yang setia membantu perjuangan.",
		objectives = {
			{ id = "assign_roles", description = "Tentukan peran tim (Strategist, Tech, Scout, Driver, dsb)", targetCount = 1 },
		},
	},

	[9] = {
		id = 9,
		title = "First Investigation",
		chapter = "Chapter 3",
		location = "Kota",
		summary = "Operasi pengumpulan informasi gabungan memetakan pengamanan markas timur.",
		objectives = {
			{ id = "scout_perimeter", description = "Amati jalur akses menuju markas industri", targetCount = 1 },
			{ id = "gather_intel", description = "Dapatkan denah kawasan gudang", targetCount = 1 },
		},
	},

	[10] = {
		id = 10,
		title = "Into the Serpent",
		chapter = "Chapter 4",
		location = "Markas",
		summary = "MC 1 nekat menyusup sendirian di malam hari demi mencari adiknya.",
		objectives = {
			{ id = "infiltrate_fence", description = "Menyusup melalui celah pagar perimeter", targetCount = 1 },
			{ id = "locate_sister_cell", description = "Temukan lokasi adik disekap di ruang interogasi basement", targetCount = 1 },
			{ id = "find_brother_dossier", description = "Temukan dokumen tahanan kakak MC 2", targetCount = 1 },
		},
	},

	[11] = {
		id = 11,
		title = "CCTV Alert",
		chapter = "Chapter 4",
		location = "Markas",
		summary = "MC 1 terdeteksi kamera keamanan; harus melarikan diri sebelum tertangkap.",
		objectives = {
			{ id = "evade_patrols", description = "Hindari kejaran penjaga dan sorotan lampu", targetCount = 1 },
			{ id = "escape_to_highway", description = "Lolos menuju jalan raya utama", targetCount = 1 },
		},
	},

	[12] = {
		id = 12,
		title = "The Rescue Plan",
		chapter = "Chapter 5",
		location = "Kampus/Kota",
		summary = "Menyusun strategi matang penyelamatan sandera ganda (adik MC 1 & kakak MC 2).",
		objectives = {
			{ id = "brief_team", description = "Paparkan data denah kepada tim 7 teman", targetCount = 1 },
			{ id = "prepare_gear", description = "Siapkan peralatan peretas dan kendaraan evakuasi", targetCount = 1 },
		},
	},

	[13] = {
		id = 13,
		title = "Infiltration",
		chapter = "Chapter 5",
		location = "Markas",
		summary = "Penyusupan tim terkoordinasi menembus pengamanan luar markas BLACK SERPENT.",
		objectives = {
			{ id = "hack_cctv", description = "Lumpuhkan sistem pemantau CCTV", targetCount = 1 },
			{ id = "breach_warehouse", description = "Buka pintu akses gudang utama", targetCount = 1 },
		},
	},

	[14] = {
		id = 14,
		title = "Free the Captives",
		chapter = "Chapter 5",
		location = "Markas",
		summary = "Membebaskan adik perempuan MC 1 dari basement dan kakak MC 2 dari ruang kontrol.",
		objectives = {
			{ id = "rescue_sister", description = "Buka sel dan selamatkan adik perempuan MC 1", targetCount = 1 },
			{ id = "rescue_brother", description = "Amankan kakak laki-laki MC 2 di ruang kontrol", targetCount = 1 },
		},
	},

	[15] = {
		id = 15,
		title = "Escape Together",
		chapter = "Chapter 5",
		location = "Markas",
		summary = "Mengawal kedua sandera meloloskan diri dari kepungan ketat penjaga markas.",
		objectives = {
			{ id = "escort_hostages", description = "Kawal kedua sandera menuju gerbang keluar", targetCount = 1 },
			{ id = "board_getaway_car", description = "Masuk ke mobil pelarian bersama Driver", targetCount = 1 },
		},
	},

	[16] = {
		id = 16,
		title = "The Final Boundary",
		chapter = "Chapter 6",
		location = "Markas",
		summary = "Konfrontasi penentuan melawan Pemimpin BLACK SERPENT.",
		objectives = {
			{ id = "stand_ground", description = "Hadapi Pemimpin BLACK SERPENT dan anteknya", targetCount = 1 },
			{ id = "protect_allies", description = "Lindungi teman-teman dari serangan balik", targetCount = 1 },
		},
	},

	[17] = {
		id = 17,
		title = "The Sacrifice",
		chapter = "Chapter 6",
		location = "Markas",
		summary = "Kakak MC 2 berkorban menahan tembakan demi melindungi adiknya. Keduanya selamat.",
		objectives = {
			{ id = "survive_ambush", description = "Bertahan dari serangan tembakan mendadak", targetCount = 1 },
			{ id = "defeat_leader", description = "Tundukkan Pemimpin BLACK SERPENT", targetCount = 1 },
		},
	},

	[18] = {
		id = 18,
		title = "Back to Campus",
		chapter = "Epilogue",
		location = "Kampus",
		summary = "Kembali ke kampus dalam suasana damai; membuka fitur open world dan misteri masa lalu.",
		objectives = {
			{ id = "return_campus", description = "Kunjungi kembali kampus yang damai", targetCount = 1 },
			{ id = "reminisce", description = "Bicara dengan keluarga dan teman-teman", targetCount = 1 },
		},
	},
}

function QuestDefinitions.GetQuest(id: number): QuestDefinition?
	return QuestDefinitions[id]
end

function QuestDefinitions.GetTotalQuests(): number
	return #QuestDefinitions
end

return QuestDefinitions
