--!strict
--[[
    DialogueData.luau
    Pusat Data Percakapan & Narasi NPC BATAS KAWASAN
]]

export type DialogueEntry = {
	title: string,
	text: string,
	speaker: string,
	soundId: string?,
}

local DialogueData: { [string]: DialogueEntry } = {
	["Mahasiswa_Kampus_Default"] = {
		title = "Mahasiswa Kampus",
		speaker = "Mahasiswa",
		text = "Akhir-akhir ini suasana kampus terasa aneh. Ada beberapa orang asing yang sering mengawasi mahasiswa. Lo baru keliling kampus kan? Hati-hati ya, mending lo kumpul sama anak-anak lain di kantin.",
	},

	["Teman_Kantin_Default"] = {
		title = "Teman Mahasiswa (Kantin)",
		speaker = "Budi (Teman)",
		text = "Woy! Sini gabung! Lo liat nggak tadi si anak orang kaya yang baru masuk itu? Dateng ke kampus bawa mobil mewah ngebut banget, terus parkir sembarangan di parkiran depan. Arogan banget gayanya.",
	},

	["MC2_Parkiran_Default"] = {
		title = "MC 2",
		speaker = "MC 2",
		text = "Ngapain lo ngeliatin gue kayak gitu? Jangan buang-buang waktu gue. Urus urusan lo sendiri dan jangan ikut campur urusan orang lain.",
	},

	["Pemilik_Warung_Default"] = {
		title = "Pemilik Warung",
		speaker = "Pak Warung",
		text = "Nak, beberapa malam terakhir ada kendaraan mencurigakan lewat sini. Mereka sering menuju kawasan gudang di sebelah timur.",
	},

	["Surat_Utang_Prompt"] = {
		title = "Surat Peringatan Utang",
		speaker = "Dokumen",
		text = "PERINGATAN TERAKHIR: Bayar seluruh sisa utang ayahmu beserta bunganya sebelum tengah malam, atau kami akan menyita jaminan lain yang paling berharga dari keluargamu! — Sindikat Hitam",
	},

	["Penagih_Utang_Confront"] = {
		title = "Penagih Utang",
		speaker = "Debt Collector",
		text = "Heh, anak kuliahan! Akhirnya lo pulang juga. Kasih tahu bapak lo, batas waktu dari bos kami di kawasan timur udah habis! Jangan kaget kalau malam ini ada yang hilang dari rumah ini!",
	},

	["Kamar_Adik_Terganggu"] = {
		title = "Kamar Adik Perempuan",
		speaker = "MC 1",
		text = "Kamar adik berantakan! Pintu belakang terbuka paksa dan jepit rambutnya tertinggal di lantai... Mereka benar-benar menculik adikku sebagai jaminan utang! Aku harus cari saksi mata!",
	},

	["Pemilik_Warung_Saksi"] = {
		title = "Pemilik Warung",
		speaker = "Pak Warung",
		text = "Astaga, Nak! Tadi ada mobil van hitam tanpa plat nomor berhenti mendadak di depan rumahmu, lalu menyeret adikmu masuk! Mobil itu langsung tancap gas ngebut ke arah timur menuju kawasan industri!",
	},

	["Jejak_Ban_Hitam"] = {
		title = "Jejak Ban Kendaraan",
		speaker = "Penyelidikan",
		text = "Bekas pengereman ban ini masih sangat baru dan mengarah lurus melintasi jalan raya menuju kawasan industri timur... Mereka membawa adikku ke markas besar mereka!",
	},

	-- Chapter 2: Misi 5 & 6 (Pusat Kota)
	["Mekanik_Bengkel_Info"] = {
		title = "Mekanik Bengkel Motor",
		speaker = "Mekanik",
		text = "Kakak keluarga kaya itu? Iya, motornya sempet diservis di sini. Dia cerita kalau belakangan ini diintai pria-pria berjaket logo ular hitam. Katanya mereka sering kumpul di dekat ruko depan.",
	},

	["Arsip_Keamanan_Kota"] = {
		title = "Rekaman Keamanan Pertokoan",
		speaker = "Rekaman CCTV",
		text = "Rekaman memperlihatkan seorang pemuda cerdas (kakak MC 2) dihadang mobil van hitam dan dipaksa masuk oleh komplotan berseragam BLACK SERPENT!",
	},

	["MC2_Konfrontasi_Kota"] = {
		title = "MC 2 (Pusat Kota)",
		speaker = "MC 2",
		text = "Lo mahasiswa kampus tadi kan?! Ngapain lo ngikutin gue sampai ke pusat kota begini? Jangan ikut campur urusan keluarga gue!",
	},

	["MC2_Benang_Merah"] = {
		title = "Penyatuan Petunjuk",
		speaker = "MC 2 & MC 1",
		text = "Tunggu... Lambang ular hitam di surat utang adik lo itu sama persis dengan sindikat yang menculik kakak gue! Ternyata keluarga kita dihancurkan oleh musuh yang sama: BLACK SERPENT! Kita harus kembali ke kampus dan kumpulkan teman-teman!",
	},

	-- Chapter 3: Misi 7, 8 & 9 (Kampus & Persiapan Tim)
	["Teman_Menolak_Dialog"] = {
		title = "Teman (Menolak)",
		speaker = "Kelompok 5 Teman",
		text = "Gila lo ya?! Melawan sindikat kriminal bersenjata BLACK SERPENT?! Kita cuma mahasiswa biasa, kita bisa mati konyol! Maaf, kita berlima nggak mau ambil risiko ini, kita mau cari aman!",
	},

	["Teman_Membantu_Dialog"] = {
		title = "Teman (Membantu)",
		speaker = "Kelompok 7 Teman",
		text = "Jangan dengerin mereka! Kita udah temenan dari awal kuliah. Keluarga lo dalam bahaya, kita nggak bakal biarin lo berjuang sendirian! Kami bertujuh siap bantu apapun yang terjadi!",
	},

	["Strategist_Role_Briefing"] = {
		title = "Briefing Strategi (Meja Kampus)",
		speaker = "Andi (Strategist)",
		text = "Tim terbagi 7 peran: Gue (Strategist) susun taktik, Reza (Technician) bobol CCTV, Dani (Scout) pantau rute, Farhan (Driver) siapkan mobil, Bima (Fighter) amankan penjaga, Citra (Negotiator) & Eko (Supporter) logistik!",
	},

	["Scout_Pos_Pengamatan"] = {
		title = "Pos Pengamatan Jalur Markas",
		speaker = "Dani (Scout)",
		text = "Lihat ke depan, itu markas gudang BLACK SERPENT. Dijaga ketat menara CCTV dan pagar berduri. Tapi ada celah di dekat semak barat yang bisa disusupi!",
	},

	["Denah_Markas_Intel"] = {
		title = "Dokumen Denah Markas",
		speaker = "Dokumen Intel",
		text = "Denah berhasil didapatkan! Fasilitas memiliki ruang interogasi di basement bawah tanah dan ruang kontrol di gudang utama. MC 1 akan menyusup lebih dulu malam ini untuk memastikan posisi adiknya!",
	},

	-- Chapter 4: Misi 10 & 11 (Infiltrasi Markas & Alarm CCTV)
	["Celah_Pagar_Stealth"] = {
		title = "Celah Pagar Barat",
		speaker = "MC 1",
		text = "Gue berhasil lolos dari celah kawat berduri barat... Menara CCTV di sebelah kanan sedang berputar. Sekarang gue harus susup masuk ke pintu bawah tanah menuju basement!",
	},

	["Sel_Tahanan_Adik_Prompt"] = {
		title = "Ruang Interogasi Basement",
		speaker = "Adik Perempuan MC 1",
		text = "Kakak...! Itu beneran Kakak?! Aku disekap di dalam sel ini... Pintunya dikunci kode elektronik dari ruang kontrol gudang atas! Hati-hati Kak, penjaga bersenjata sering patroli di lorong ini!",
	},

	["Dokumen_Kakak_MC2_Prompt"] = {
		title = "Ruang Kontrol Gudang Utama",
		speaker = "Berkas Sandera Rahasia",
		text = "DOKUMEN DITEMUKAN: Berkas proyek strategi atas nama kakak MC 2! Dokumen ini mencatat bahwa kakak MC 2 dipaksa bekerja di ruang kontrol utama di bawah todongan senjata! MC 1 mengamankan berkas ini!",
	},

	["Alarm_CCTV_Sirene"] = {
		title = "PERINGATAN ALARM KEAMANAN!",
		speaker = "Pengeras Suara Markas",
		text = "PERINGATAN! PENYUSUP TERDETEKSI DI AREA GUDANG UTAMA! SELURUH UNIT PENJAGA SEGERA KEPUNG AREA PARKIR DAN BLOKIR PINTU KELUAR!",
	},

	["Pelarian_Jalan_Raya"] = {
		title = "Jalan Raya Luar Markas",
		speaker = "MC 1",
		text = "Hampir saja tertangkap! Sirine alarm meraung di seluruh kawasan markas timur. Tapi gue berhasil memastikan adik gue ada di basement dan kakak MC 2 di ruang kontrol! Waktunya kembali ke kampus untuk jalankan rencana penyelamatan bersama tim!",
	},

	["Penjaga_BLACK_SERPENT_Default"] = {
		title = "Penjaga BLACK SERPENT",
		speaker = "Penjaga",
		text = "Berhenti! Area ini bukan tempat umum. Kalau lo nggak punya urusan, lebih baik pergi sekarang juga.",
	},

	["Adik_MC1_Hostage"] = {
		title = "Adik Perempuan MC 1",
		speaker = "Adik",
		text = "Kakak...! Aku takut banget... Mereka bawa aku paksa dari rumah karena urusan utang ayah... Tolong bawa aku pulang, Kak!",
	},

	["Kakak_MC2_Rescue"] = {
		title = "Kakak Laki-Laki MC 2",
		speaker = "Kakak MC 2",
		text = "Kalian akhirnya sampai di sini... Dengar, aku sudah meretas dan menyalin seluruh data kejahatan mereka. Kita harus segera keluar sebelum mereka mengunci pintu utama!",
	},
}

function DialogueData.Get(key: string): DialogueEntry?
	return DialogueData[key]
end

return DialogueData
