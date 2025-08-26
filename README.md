# MovieApp (iOS 26)

Aplikasi daftar film populer berbasis **SwiftUI + MVVM** yang mengambil data dari **The Movie Database (TMDB)**. Mendukung pencarian, pull-to-refresh, **cache offline** via Core Data, serta **penanda “Last updated: today / yesterday / N day(s) ago”** dan mekanisme **refresh otomatis jika data kedaluwarsa ≥ 1 hari**.

## ✨ Fitur Utama

* **Popular Movies** dari TMDB
* **Pencarian** judul film (client-side)
* **Pull-to-refresh**
* **Cache Offline** dengan Core Data
* **Last Updated Footer** di bagian bawah `List`
* **Auto-expiry** data (≥ 1 hari → refetch API)
* **Error handling** sederhana + fallback ke offline data

## 🧱 Teknologi

* **SwiftUI**, **Combine**
* **MVVM**
* **Core Data** (persistensi)
* **URLSession** (networking)

## 📦 Prasyarat

* **Xcode** yang mendukung **iOS 26 SDK**
* **Swift** bawaan Xcode tersebut
* **Akun TMDB** (opsional jika ingin mengganti API Key)
* **macOS** terbaru yang kompatibel dengan Xcode di atas

> **Catatan:** Pastikan **Deployment Target = iOS 26.0** pada target proyek Anda.

## 🚀 Instalasi & Menjalankan

1. **Clone repositori**

   ```bash
   git clone git@github.com:baghizzhd/iOS-Development-test.git
   cd iOS-Development-test
   ```

2. **Buka proyek di Xcode**

   * Klik dua kali `MovieApp.xcodeproj` atau `MovieApp.xcworkspace` (jika menggunakan workspace).

3. **Set Deployment Target**

   * Buka: **TARGETS → MovieApp → General → Deployment Info**
   * Set **iOS 26.0**.

4. **(Opsional) Atur API Key TMDB**

   * Secara default, `APIService` sudah berisi API key (untuk pengembangan).
   * Disarankan memindahkan API key ke **.xcconfig** atau **Info.plist** untuk produksi (lihat bagian **Konfigurasi API Key** di bawah).

5. **Jalankan di Simulator/Device**

   * Pilih **iOS 26** simulator atau device.
   * Tekan **⌘R** untuk run.

## 🧭 Cara Pakai

* Halaman utama menampilkan **Popular Movies**.
* Gunakan **search bar** untuk memfilter judul.
* Tarik ke bawah untuk **refresh**.
* Lihat bagian paling bawah `List` untuk **Last updated**:

  * `today`, `yesterday`, atau `N day(s) ago`.
* Aplikasi akan **mengambil ulang** data otomatis jika sudah melewati **1 hari kalender** sejak pembaruan terakhir.

## 🗂️ Struktur Folder (ringkas)

```
MovieApp/
├─ App/
│  └─ MovieAppApp.swift
|  └─ Persistence.swift
├─ Model/
│  └─ Movie.swift
├─ Service/
│  └─ APIService.swift
|  └─ CoreDataManager.swift
├─ Persistence/
│  └─ CoreDataManager.swift
│  └─ MovieApp.xcdatamodeld (Entity: MovieEntity)
├─ View/
│  ├─ HelperViews/
|  ├─── MovieRowView.swift
|  ├─── WebView.swift 
│  ├─ MovieListView.swift
│  ├─ MovieRowView.swift
└─ ViewModel/
│  └─ MovieListViewModel.swift
└─ Resources/
   └─ Assets.swift
   └─ MovieApp.xcdatamodeld
```

## 🧪 Validasi Fitur “Last Updated” & Expiry

* **Last updated** disimpan di `UserDefaults` (timestamp).
* Label relatif:

  * **today**, **yesterday**, **N day(s) ago**.
* **Expiry**: Jika beda **hari kalender** (≥ 1) → fetch API, simpan Core Data, update timestamp.

## 🛠️ Troubleshooting

* **`Cannot find 'MovieEntity' in scope`**

  * Pastikan di **.xcdatamodeld** ada entity `MovieEntity` dengan atribut yang cocok dengan `CoreDataManager`.
  * Pastikan nama container `NSPersistentContainer(name: "MovieApp")` sama dengan nama **.xcdatamodeld**.

* **`Initializer for conditional binding must have Optional type`**

  * Jangan gunakan `if let` pada return `fetchMovies()` jika tipenya `[Movie]` (non-optional). Gunakan cek `isEmpty`.

* **Footer “Last updated” tidak muncul di bawah List**

  * Pastikan diletakkan sebagai **`Section` di dalam `List`** dan diberi:

    ```swift
    .frame(maxWidth: .infinity, alignment: .center)
    .font(.footnote)
    .foregroundColor(.gray)
    ```

* **Gagal fetch API**

  * Cek koneksi internet.
  * Cek API Key TMDB (aktif & benar).
  * Lihat log pada Xcode (`APIError`).

## 🔄 Build & Clean

* Bersihkan build:

  ```bash
  shift + cmd + k
  ```
* Reset Derived Data (jika perlu):

  * Xcode → **Settings** → **Locations** → **Derived Data** → **Delete** untuk project ini.

## 🤝 Kontribusi

1. Fork repo
2. Buat branch fitur: `git checkout -b feat/nama-fitur`
3. Commit: `git commit -m "feat: ..."`
4. Push: `git push origin feat/nama-fitur`
5. Buat **Pull Request**
