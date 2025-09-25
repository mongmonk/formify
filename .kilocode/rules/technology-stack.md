# Tumpukan Teknologi Proyek

Dokumen ini merinci tumpukan teknologi yang digunakan dalam proyek, beserta peran dan justifikasi pemilihan setiap komponen.

| Teknologi | Versi (jika ada) | Peran dalam Proyek | Justifikasi Penggunaan |
| :--- | :--- | :--- | :--- |
| **Backend** | | | |
| Laravel | 12 | Framework Aplikasi Utama | Framework PHP modern yang kuat dengan ekosistem yang kaya, mempercepat pengembangan dengan menyediakan fitur-fitur umum seperti routing, ORM (Eloquent), dan otentikasi. |
| PHP-FPM | - | Manajer Proses PHP | Menyediakan manajemen proses FastCGI untuk PHP, meningkatkan performa dan skalabilitas aplikasi web dengan menangani banyak permintaan secara efisien. |
| **Frontend** | | | |
| Laravel Jetstream | - | Scaffolding Aplikasi | Starter kit yang menyediakan implementasi otentikasi dan manajemen pengguna, mempercepat penyiapan fitur-fitur dasar aplikasi. |
| Livewire | - | Framework Frontend Interaktif | Memungkinkan pembuatan antarmuka dinamis menggunakan PHP, mengurangi kebutuhan untuk menulis JavaScript yang kompleks dan menyederhanakan pengembangan frontend. |
| Alpine.js | - | Framework JavaScript Ringan | Memberikan reaktivitas dan fungsionalitas interaktif di sisi klien dengan sintaks yang minimalis, terintegrasi baik dengan Livewire. |
| JavaScript (vanilla) | - | Skrip Kustom Sisi Klien | Digunakan untuk fungsionalitas spesifik yang tidak dicakup oleh Alpine.js atau Livewire, memberikan fleksibilitas penuh pada interaksi frontend. |
| **Database** | | | |
| PostgreSQL | 15 | Sistem Manajemen Database | RDBMS open-source yang kuat, andal, dan kaya fitur. Dipilih karena dukungan untuk tipe data JSONB, performa tinggi, dan skalabilitas yang baik. |
| **Cache & Queue** | | | |
| Redis | - | In-Memory Data Store | Digunakan untuk caching (penyimpanan sementara data) dan sebagai message broker untuk antrian (queue), mempercepat respons aplikasi dan menangani tugas latar belakang. |
| **Infrastruktur & Operasi** | | | |
| Nginx | - | Web Server & Reverse Proxy | Web server berkinerja tinggi yang efisien dalam menyajikan konten statis dan bertindak sebagai reverse proxy untuk aplikasi PHP-FPM. |
| Supervisor | - | Manajer Proses | Memastikan proses penting seperti worker antrian (queue workers) tetap berjalan secara terus-menerus dan akan memulai ulang secara otomatis jika gagal. |
| Docker | - | Kontainerisasi Aplikasi | Mengemas aplikasi dan dependensinya ke dalam kontainer yang terisolasi, memastikan konsistensi lingkungan dari pengembangan hingga produksi. |
| Docker Compose | - | Orkestrasi Multi-Kontainer (Dev) | Menyederhanakan manajemen multi-kontainer di lingkungan pengembangan, memungkinkan seluruh tumpukan (web, db, cache) dijalankan dengan satu perintah. |
| Kubernetes | - | Orkestrasi Kontainer (Prod) | Platform orkestrasi standar industri untuk mengelola, menskalakan, dan men-deploy aplikasi dalam kontainer di lingkungan produksi secara otomatis. |
| **CI/CD & Deployment** | | | |
| GitHub Actions | - | Continuous Integration/Delivery | Mengotomatiskan alur kerja pengembangan seperti menjalankan tes, membangun aset, dan melakukan deployment setiap kali ada perubahan pada repositori kode. |
| Laravel Envoyer | - | Zero-Downtime Deployment | Layanan untuk men-deploy aplikasi Laravel tanpa downtime, memastikan ketersediaan aplikasi tetap terjaga selama proses pembaruan. |
| **Observabilitas** | | | |
| ELK Stack / Papertrail | - | Agregasi & Analisis Log | Mengumpulkan, memusatkan, dan menganalisis log dari berbagai komponen sistem untuk pemantauan dan pemecahan masalah. |
| Sentry / Flare | - | Pelacakan Error & Pengecualian | Secara proaktif menangkap, melaporkan, dan memberikan konteks pada error yang terjadi di aplikasi, mempercepat identifikasi dan perbaikan bug. |
| Telescope / New Relic / Datadog | - | Application Performance Monitoring (APM) | Memberikan wawasan mendalam tentang performa aplikasi, memantau query database, permintaan HTTP, dan metrik kinerja lainnya untuk optimasi. |