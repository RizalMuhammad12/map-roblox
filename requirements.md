# Requirements Specification — BATAS KAWASAN
## Dokumen Kebutuhan Fungsional & Nonfungsional Game

Dokumen ini mendefinisikan seluruh spesifikasi kebutuhan sistem, fitur permainan, dan batasan teknis untuk pengembangan game **Batas Kawasan** di platform Roblox, berlandaskan dokumen resmi [`story.md`](file:///d:/RobloxProjects/MapAntigravity/story.md).

---

## 1. Pendahuluan & Gambaran Sistem

*Batas Kawasan* adalah game *Third-Person Action-Adventure Hybrid Open World* dengan fokus cerita naratif episodik (*Story Missions*) yang berlatar kota fiktif bernuansa Indonesia. Permainan mendukung mode *multiplayer* kooperatif dengan tetap mempertahankan alur cerita individu/kelompok yang terarah.

---

## 2. Kebutuhan Fungsional (Functional Requirements)

### Modul 1: Sistem Karakter & Kontrol (Player & Camera)
- **FR-01.1 (Kamera Third-Person Khusus):**
  - Kamera pemain dikonfigurasi dengan batas zoom semi-dekat: `CameraMinZoomDistance = 8.0` dan `CameraMaxZoomDistance = 18.0`.
  - Kamera harus memberikan sudut pandang sinematik setinggi bahu/kepala pemain agar atmosfer lingkungan perkotaan Indonesia terasa intim dan imersif.
- **FR-01.2 (Spawn & Karakter):**
  - Karakter menggunakan rig standar Roblox (R6 atau R15 adaptif).
  - Spawn awal pemain berpusat di area kampus (`MainSpawn` di koordinat $-350, 0.5, 285$).
  - `CharacterBreakJointsOnDeath` disetel `false` untuk mendukung animasi *knockdown* atau *defeat* yang realistis.

---

### Modul 2: Sistem Eksplorasi Dunia & Tata Ruang (Open World)
- **FR-02.1 (Empat Kuadran Wilayah):**
  - Dunia game berukuran $1200 \times 900$ stud terbagi atas 4 zona aktif:
    1. **Kawasan Kampus (Southwest):** Pusat aktivitas akademik, kantin, area kumpul mahasiswa.
    2. **Kawasan Permukiman (Northwest):** Kompleks perumahan warga, warung, pos ronda, tiang listrik.
    3. **Kawasan Pusat Kota (Southeast):** Ruko komersial, minimarket, bengkel motor, restoran, trotoar.
    4. **Markas BLACK SERPENT (Northeast):** Gudang utama, menara CCTV, gerbang keamanan, dan ruang bawah tanah (*Basement/Interrogation Room*).
- **FR-02.2 (Sistem Pembatas & Akses Gerbang):**
  - Gerbang Markas BLACK SERPENT memiliki status terkunci (*Locked*) pada awal permainan dan hanya dapat diakses melalui misi cerita resmi (Chapter 4 ke atas).
- **FR-02.3 (Pencahayaan & Atmosfer Realistis):**
  - Menggunakan teknologi `ShadowMap`.
  - Waktu default `14:30:00` (siang menjelang sore) yang dapat disesuaikan secara dinamis sesuai kebutuhan atmosfer chapter (misal: malam hari untuk misi infiltrasi Chapter 4).

---

### Modul 3: Sistem Misi & Quest Engine
- **FR-03.1 (State Machine Misi):**
  - Sistem quest harus memiliki state: `NotStarted`, `InProgress`, `ObjectiveMet`, `TurnIn`, `Completed`.
  - Misi bersifat berurutan sesuai alur 18 Misi dari `story.md`:
    - Misi 1–2: Pengenalan Kampus & Teman (Prologue).
    - Misi 3–4: Tekanan Keluarga & Penculikan Adik MC 1 (Chapter 1).
    - Misi 5–6: Investigasi Masa Lalu & Jejak Kakak MC 2 (Chapter 2).
    - Misi 7–9: Perpecahan Pertemanan & Penyatuan Tim (Chapter 3).
    - Misi 10–11: Infiltrasi Tunggal MC 1 & Alarm CCTV (Chapter 4).
    - Misi 12–15: Misi Penyelamatan Sandera Ganda & Pelarian (Chapter 5).
    - Misi 16–17: Konfrontasi Pemimpin & Pengorbanan Kakak (Chapter 6).
    - Misi 18: Epilog & Pembukaan Mode Open World (Epilogue).
- **FR-03.2 (Objektif Beragam):**
  - Mendukung tipe objektif:
    - *Talk to NPC* (Dialog interaktif).
    - *Search & Inspect Clue* (Pencarian barang bukti berlampu/berpenanda).
    - *Infiltrate / Stealth* (Menghindari CCTV dan penjaga).
    - *Rescue & Escort* (Membebaskan dan mengawal sandera).
    - *Defeat Enemies* (Pertarungan).
- **FR-03.3 (HUD Misi Klien):**
  - Menampilkan judul misi, instruksi aktif, dan progres numerik (`0/2`, `1/2`, `2/2`).
  - Animasi border hijau saat misi selesai.

---

### Modul 4: Sistem Interaksi NPC & Dialog
- **FR-04.1 (ProximityPrompt Interaktif):**
  - Interaksi dipicu via `ProximityPrompt` pada NPC dengan jarak aktivasi maksimal 10 stud.
- **FR-04.2 (Sistem Dialog Dinamis):**
  - Membaca metadata atribut (`DialogTitle`, `DialogText`, `DialogueTree`) dari prompt yang dipicu.
  - GUI dialog (`BatasKawasanDialogue`) tampil di bagian bawah layar dengan tema *dark modern* bergaris tepi merah.
  - Mendukung input tombol tutup: Klik mouse, Touch screen (HP), tombol keyboard `Escape`, dan gamepad `ButtonB`.
  - Fitur auto-close otomatis jika pemain menjauh atau membiarkan dialog selama 15 detik.

---

### Modul 5: Sistem Infiltrasi & Stealth (Chapter 4 & 5)
- **FR-05.1 (Deteksi Kamera CCTV & Lampu Sorot):**
  - Kamera CCTV dan menara pengintai memiliki kerucut pandang (*Cone of Vision*).
  - Jika pemain masuk ke area pandang selama waktu tertentu, alarm markas terpicu.
- **FR-05.2 (AI Penjaga Sederhana):**
  - Penjaga markas melakukan rute patroli di sekitar gudang dan gerbang.
  - Status penjaga: `Idle` $\rightarrow$ `Suspicious` $\rightarrow$ `Aggressive/Alert`.

---

### Modul 6: Sistem Penyelamatan Sandera & Pertarungan (Chapter 5 & 6)
- **FR-06.1 (Penyelamatan Sandera Ganda):**
  - **Adik perempuan MC 1:** Ditemukan di ruang interogasi/basement bawah tanah; pemain harus membuka pintu sel via interaksi.
  - **Kakak laki-laki MC 2:** Ditemukan di ruang kontrol gudang; menghentikan sabotase sistem dan ikut melarikan diri.
  - Kedua sandera memiliki logika *follow AI* sederhana yang mengikuti pergerakan pemain menuju titik evakuasi di gerbang.
- **FR-06.2 (Pertarungan Final & Scene Pengorbanan):**
  - Konfrontasi melawan Pemimpin BLACK SERPENT.
  - Pemicuan adegan dramatis di mana kakak MC 2 melindungi MC 2 dari tembakan (keduanya dipastikan selamat).

---

### Modul 7: Arsitektur Multiplayer
- **FR-07.1 (Isolasi Progres Cerita):**
  - Data misi tersimpan per pemain di server. Dua pemain yang berada di server yang sama dapat berada pada chapter misi yang berbeda tanpa saling merusak.
- **FR-07.2 (Cooperative Mission Sync):**
  - Pemain dapat membentuk *party* atau saling membantu dalam pertempuran dan eksplorasi map.

---

## 3. Kebutuhan Nonfungsional (Non-Functional Requirements)

### NFR-01: Performa & Optimasi (Performance)
- **Target Frame Rate:** Stabil di **60 FPS** pada PC berspesifikasi menengah-bawah, dan minimal **30–60 FPS** pada perangkat *smartphone* populer.
- **StreamingEnabled:**
  - Wajib aktif dengan `StreamingIntegrityMode = PauseOutsideLoadedArea`.
  - Memastikan memori perangkat mobile tidak melebihi batas toleransi saat memuat aset kawasan map yang luas.
- **Efisiensi Part & Model:**
  - Mengelompokkan dan mengoptimalkan 182 part marka jalan agar tidak membebani *draw calls*.

### NFR-02: Keamanan & Integritas Jaringan (Security)
- **Server Authority:**
  - Server wajib memvalidasi setiap penyelesaian objektif misi.
  - Server memvalidasi jarak koordinat karakter saat memicu interaksi barang bukti (`Suspicious_Evidence`) untuk mencegah eksploitasi teleportasi instan.
- **Rate Limiting:**
  - RemoteEvent diberi pelindung *anti-spam/cooldown* agar tidak bisa dieksploitasi oleh script inject pihak ketiga.

### NFR-03: Kompatibilitas Multiplatform (Cross-Platform)
- Game harus dapat dimainkan secara mulus di:
  - **PC (Windows / Mac):** Keyboard & Mouse.
  - **Mobile (Android / iOS):** Layar sentuh responsif dengan ukuran tombol dialog minimal 44x44 pixel.
  - **Console / Controller:** Navigasi tombol Gamepad (A, B, D-Pad).

### NFR-04: Standar Kualitas Kode (Maintainability)
- Seluruh script baru wajib ditulis dalam **Luau modular** (`ModuleScript`).
- Kode script disimpan dalam format plain text (`.luau`, `.server.luau`, `.client.luau`) di bawah kontrol versi Git, bukan terkunci di dalam file binary model.
- Konfigurasi data misi dipisahkan dari logika eksekusi (data-driven design).
