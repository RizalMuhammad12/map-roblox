# BATAS KAWASAN — Roblox Game Project

**Batas Kawasan** adalah game *Third-Person Action-Adventure Hybrid Open World* dengan alur cerita dramatis (*Story Missions*) yang berlatar belakang sebuah kota fiktif di Indonesia, dikembangkan menggunakan engine **Roblox Studio** dan toolchain **Rojo**.

---

## 📚 Dokumentasi Resmi Proyek

Proyek ini memiliki struktur dokumentasi komprehensif yang wajib dijadikan acuan oleh seluruh pengembang dan AI Coding Agent:

1. **[Story Bible (`story.md`)](file:///d:/RobloxProjects/MapAntigravity/story.md):**
   *Sumber Kebenaran Tunggal (Single Source of Truth)* mengenai seluruh latar cerita, profil karakter (MC 1, MC 2, keluarga, 12 teman), antagonis BLACK SERPENT, alur 6 Chapter, dan aturan konsistensi cerita.
2. **[Pedoman AI Coding Agent (`AGENTS.md`)](file:///d:/RobloxProjects/MapAntigravity/AGENTS.md):**
   Panduan teknis, aturan *locked lore vs draft design*, arsitektur client-server Roblox, konvensi penulisan Luau, dan *checklist* kualitas sebelum commit.
3. **[Spesifikasi Kebutuhan (`requirements.md`)](file:///d:/RobloxProjects/MapAntigravity/requirements.md):**
   Kebutuhan fungsional (FR) dan nonfungsional (NFR) lengkap, mencakup kontrol kamera, sistem quest, dialog NPC, mekanik stealth, penyelamatan sandera, dan optimasi performa.
4. **[Roadmap Pengembangan (`roadmap.md`)](file:///d:/RobloxProjects/MapAntigravity/roadmap.md):**
   Peta jalan pengembangan bertahap dari Fase 0 (Pondasi Teknis & Sanitasi Map) hingga Fase 6 (Epilog & Polish Open World).

---

## 🛠️ Menjalankan Proyek (Getting Started)

Proyek ini dikelola menggunakan **Rojo 7.7.1** dan **Rokit**.

### 1. Build Place File
Untuk meng-generate file place Roblox Studio dari repositori:
```bash
rojo build -o "MapAntigravity.rbxlx"
```

### 2. Menjalankan Rojo Server (Live Sync)
Buka file `MapAntigravity.rbxlx` di Roblox Studio, lalu jalankan server Rojo di terminal:
```bash
rojo serve
```
Sambungkan plugin Rojo di Roblox Studio untuk memulai sinkronisasi dua arah.

---

## 🗺️ Gambaran Tata Ruang Map

Map berukuran $1200 \times 900$ stud terbagi menjadi 4 kuadran terkoordinasi:
- **Barat Daya (Southwest):** Kawasan Kampus (University Campus & Main Spawn)
- **Barat Laut (Northwest):** Kawasan Permukiman Warga (Residential Area & Warung)
- **Tenggara (Southeast):** Pusat Kota (City Center & Commercial Area)
- **Timur Laut (Northeast):** Markas Organisasi BLACK SERPENT (Industrial Warehouse & Underground Basement)
