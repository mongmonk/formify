### **1. Rasional Desain**

Desain database ini dirancang dengan prinsip-prinsip normalisasi, skalabilitas, dan integritas data sebagai prioritas utama, berdasarkan analisis dokumen arsitektur dan persetujuan untuk melakukan normalisasi penuh.

*   **Normalisasi (3NF):**
    *   **Pemisahan Entitas:** Entitas yang awalnya disarankan sebagai kolom `JSONB` (`order_items`, `customer_data`, `form config`) telah dipecah menjadi tabel-tabel tersendiri: `customers`, `form_fields`, `order_items`, dan `order_details`.
    *   **Integritas Data:** Langkah ini mengubah data yang sebelumnya tidak terstruktur menjadi data relasional yang terstruktur. Ini memungkinkan penerapan *foreign key constraints*, memastikan bahwa setiap item pesanan terhubung ke produk yang valid dan setiap pesanan terhubung ke pelanggan yang ada. Ini secara drastis mengurangi anomali data dan meningkatkan konsistensi.
    *   **Redundansi Minimum:** Dengan memisahkan pelanggan ke tabel `customers`, data pelanggan yang sama (misalnya, email, nama) tidak perlu disimpan berulang kali untuk setiap pesanan yang mereka buat, menghemat ruang dan menyederhanakan pembaruan data pelanggan.

*   **Struktur Tabel & Kunci:**
    *   **Kunci Primer:** Sebagian besar tabel menggunakan `BIGINT` auto-increment (`BIGSERIAL` di PostgreSQL) sebagai *Primary Key* (`id`) untuk efisiensi join. Tabel yang merupakan bagian dari Jetstream (`users`, `teams`) mengikuti konvensi Laravel.
    *   **UUID sebagai Kunci Publik:** Tabel yang diakses secara eksternal seperti `forms` dan `orders` menggunakan kolom `uuid` yang unik dan diindeks. Ini adalah praktik keamanan yang baik untuk menyembunyikan ID internal yang berurutan dan mencegah enumerasi data.
    *   **Kunci Asing (Foreign Keys):** Relasi antar tabel didefinisikan secara eksplisit menggunakan `FOREIGN KEY` dengan opsi `ON DELETE CASCADE` atau `ON DELETE RESTRICT` sesuai logika bisnis. Misalnya, jika sebuah `form` dihapus, semua `form_fields` dan `orders` terkait juga akan terhapus, menjaga kebersihan data.
    *   **Multi-Tenancy:** Sesuai dokumen arsitektur, kolom `team_id` diimplementasikan di semua tabel yang relevan (`forms`, `orders`, `customers`, dll.) dan diindeks. Ini adalah dasar untuk isolasi data antar-tenant yang akan ditegakkan di level aplikasi menggunakan *Global Scopes* Laravel.

*   **Tipe Data & Kendala:**
    *   **PostgreSQL-Specific:** Tipe data dipilih untuk mengoptimalkan penyimpanan dan performa. `TIMESTAMPTZ` digunakan untuk semua data tanggal/waktu untuk menangani zona waktu secara otomatis. `TEXT` digunakan untuk string dengan panjang bervariasi, dan `VARCHAR` untuk string dengan panjang yang diketahui dan terbatas. `NUMERIC` digunakan untuk nilai moneter (`price`, `total_amount`) untuk menghindari masalah presisi floating-point.
    *   **Kendala `NOT NULL` dan `UNIQUE`:** Diterapkan secara ketat untuk memastikan data yang masuk memenuhi persyaratan bisnis minimum. Misalnya, `slug` formulir harus unik per-tim (`UNIQUE(team_id, slug)`).

*   **Indeks (Indexing):**
    *   **Indeks Kunci Asing:** Semua kolom `FOREIGN KEY` secara otomatis diindeks oleh PostgreSQL, tetapi kami menambahkannya secara eksplisit untuk kejelasan. Ini sangat penting untuk performa `JOIN`.
    *   **Indeks Multi-Tenancy:** Indeks komposit pada `(team_id, ...)` dibuat pada tabel-tabel utama untuk mempercepat query yang sudah difilter berdasarkan tenant.
    *   **Indeks UUID & Slug:** Kolom `uuid` dan `slug` diindeks secara unik untuk memastikan pencarian data publik yang cepat.

Pendekatan ini menghasilkan skema yang tidak hanya kuat dan efisien tetapi juga lebih mudah untuk dipelihara, diperluas, dan dianalisis di masa depan.