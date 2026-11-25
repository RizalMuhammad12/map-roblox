# AGENTS.md — Pedoman Utama AI Coding Agent
## Proyek: BATAS KAWASAN (Roblox)

Dokumen ini merupakan **pedoman wajib dan panduan teknis utama** bagi AI Coding Agent dan pengembang yang bekerja pada repositori game Roblox **Batas Kawasan**. Seluruh kontribusi kode, konfigurasi, dan modifikasi harus tunduk pada aturan di dalam dokumen ini.

---

## 1. Single Source of Truth & Aturan Cerita

1. **Acuan Utama:** File [`story.md`](file:///d:/RobloxProjects/MapAntigravity/story.md) (*Story Bible*) adalah **Satu-satunya Sumber Kebenaran Naratif (Single Source of Truth)**. Dilarang mengarang alur baru atau mengubah pondasi cerita tanpa instruksi eksplisit dari pemilik proyek.
2. **Prinsip "Locked Lore vs Draft Design":**
   Agent **WAJIB** membedakan dengan tegas antara fakta cerita yang sudah dikunci (*Locked Lore*) dan elemen yang masih berupa rancangan teknis (*Draft Design*).

### A. Locked Lore (TIDAK BOLEH DIUBAH):
- **Protagonis:** Terdapat 2 Karakter Utama (MC 1 dan MC 2).
  - **MC 1:** Mahasiswa keluarga sederhana, berjuang mengatasi utang ayahnya. Adik perempuannya diculik oleh BLACK SERPENT sebagai jaminan utang. MC 1 menjadi pihak yang nekat menyusup ke markas.
  - **MC 2:** Mahasiswa kaya yang arogan namun menyimpan tragedi keluarga. Ayahnya adalah korban kejahatan BLACK SERPENT (bukan anggota). Kakak laki-lakinya diculik karena kecerdasan strategi dan bela dirinya, dipaksa bekerja di markas namun diam-diam menyabotase dari dalam.
- **Pembedaan Anggota Keluarga Wanita:**
  - **Adik perempuan MC 1:** Diculik akibat utang di permukiman, disekap di *Basement/Interrogation Room*, dan **berhasil diselamatkan** di Chapter 5.
  - **Saudara perempuan MC 2:** Hilang bertahun-tahun lalu di masa lampau; tetap menjadi misteri yang **belum terpecahkan** (disimpan untuk potensi sekuel).
- **12 Teman Mahasiswa:** Terbagi menjadi **7 orang yang membantu** (Strategist, Technician, Scout, Driver, Fighter, Negotiator, Supporter) dan **5 orang yang menolak** (karena takut/konflik pertemanan).
- **4 Kawasan Utama:**
  - Kampus Universitas (Barat Daya / Southwest)
  - Permukiman Warga (Barat Laut / Northwest)
  - Pusat Kota / City Center (Tenggara / Southeast)
  - Markas BLACK SERPENT (Timur Laut / Northeast)
- **Klimaks & Akhir:**
  - Chapter 5 adalah penyelamatan sandera ganda (Adik MC 1 & Kakak MC 2).
  - Chapter 6 adalah konfrontasi melawan Pemimpin BLACK SERPENT. Kakak MC 2 berkorban menahan tembakan demi melindungi MC 2; **keduanya tetap bertahan hidup**.
  - Epilog ditutup dengan suasana damai di kampus dan pembukaan mode open world.

### B. Draft Design (Boleh Diimplementasikan & Dikembangkan Bertahap):
- Nama asli spesifik karakter (saat ini menggunakan kode MC 1, MC 2, dsb.).
- Desain antarmuka/UI, tata letak teks, dan aset visual styling.
- Nilai statistik gameplay (kecepatan jalan, deteksi radius CCTV, durasi interaksi ProximityPrompt).
- Logika teknis arsitektur kode di Luau.

---

## 2. Prinsip Kerja AI Agent (Core Rules)

1. **Bertahap & Tidak Grusa-Grusu:**
   - **JANGAN** membuat seluruh sistem/fitur sekaligus dalam satu langkah.
   - Selesaikan per modul/fitur secara fungsional, lakukan verifikasi, lalu lanjutkan ke tahap berikutnya.
2. **Analisis Eksisting Sebelum Mengubah:**
   - Sebelum menyentuh kode atau aset, periksa kondisi aktual di `src/` dan `default.project.json`.
   - Hormati tata ruang map 3D yang sudah dibangun (koordinat part, nama model, dsb.). Jangan memindahkan/menghapus bangunan tanpa izin.
3. **Kemandirian & Efisiensi Tool:**
   - Gunakan batching saat membaca dan mengedit file.
   - Jangan menjalankan polling tanpa henti; manfaatkan notifikasi sistem.

---

## 3. Standar & Konvensi Pemrograman Luau

### A. Lingkungan Teknis
- **Engine:** Roblox Studio.
- **Toolchain:** Rokit + Rojo 7.7.1.
- **Bahasa:** Luau (mengutamakan fitur modern, static typechecking jika memungkinkan: `--!strict` pada file modul baru).

### B. Arsitektur Client-Server & Keamanan
- **Server Authority:** Logika status misi, verifikasi kepemilikan item/clue, dan validasi dialog dijalankan di **Server**.
- **Anti-Exploit / Sanity Check:**
  - Jangan percaya data mentah dari client.
  - Setiap RemoteEvent yang dipicu client (misal: "Interaksi Objek", "Selesaikan Misi") harus divalidasi jaraknya oleh Server (`(character.Position - target.Position).Magnitude <= maxDistance`).
- **Pemisahan Peran:**
  - `ServerScriptService`: Menangani database misi pemain, validasi prompt, logika dunia, dan server events.
  - `StarterPlayer / StarterPlayerScripts / StarterCharacterScripts`: Menangani antarmuka (HUD, dialog frame), efek kamera, animasi lokal, dan input controller/keyboard.
  - `ReplicatedStorage`: Menyimpan modul bersama (`Shared/`), RemoteEvents, dan konfigurasi data misi statis.

### C. Gaya Penulisan Kode
- Gunakan `PascalCase` untuk nama instance Roblox, ModuleScript, dan Services (`Players`, `ReplicatedStorage`).
- Gunakan `camelCase` untuk variabel lokal dan fungsi internal (`local missionStatus = {}`).
- Gunakan `UPPER_SNAKE_CASE` untuk konstanta (`local MAX_INTERACTION_DISTANCE = 12`).
- Cache seluruh Roblox Services di bagian atas file:
  ```luau
  local Players = game:GetService("Players")
  local ReplicatedStorage = game:GetService("ReplicatedStorage")
  local ProximityPromptService = game:GetService("ProximityPromptService")
  ```

---

## 4. Panduan Struktur Repositori & Penanganan Rojo

1. **Pemetaan Proyek (`default.project.json`):**
   - Pastikan path di `default.project.json` selalu sinkron dengan folder nyata di `src/`.
   - Hindari membuat folder baru di luar struktur tanpa mendaftarkannya pada project JSON.
2. **Penanganan Binary `.rbxm` vs Plain Text `.luau`:**
   - Model 3D fisik (bangunan, ground, pohon) disimpan dalam format `.rbxm`.
   - Script pemrograman (`Script`, `LocalScript`, `ModuleScript`) harus diprioritaskan disimpan sebagai file teks `.luau` / `.server.luau` / `.client.luau` agar mudah ditinjau perubahannya di Git.
   - Script yang saat ini masih terbungkus di dalam binary (seperti `StarterCharacterScripts.rbxm`) direncanakan untuk dimigrasikan secara bertahap menjadi script teks modular.
3. **Folder Proyek Resmi:**
   - `src/Workspace`: Aset fisik 3D map.
   - `src/ServerScriptService`: Logika backend server game.
   - `src/ReplicatedStorage`: Event jaringan dan modul bersama.
   - `src/StarterPlayer`: Script karakter dan script pemain.
   - `src/Lighting`: Konfigurasi atmosfer dan pencahayaan realistis.

---

## 5. Checklist Verifikasi Sebelum Menyelesaikan Tugas

Sebelum melaporkan bahwa sebuah tugas selesai, AI Agent wajib memverifikasi:
- [ ] Apakah fondasi cerita di `story.md` tetap terjaga dan tidak terdistorsi?
- [ ] Apakah kode Luau bebas dari kesalahan sintaks?
- [ ] Apakah `rojo build` dapat berjalan lancar tanpa error pembacaan JSON/folder?
- [ ] Apakah tidak ada file esensial map yang terhapus atau terpindah tanpa sengaja?
- [ ] Apakah perubahan terdokumentasi dengan jelas untuk pengembang?
