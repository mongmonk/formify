# Alur Kerja Pengembangan

Dokumen ini menjelaskan alur kerja pengembangan standar yang diikuti oleh tim kami untuk memastikan konsistensi, kualitas, dan kolaborasi yang efisien.

## Langkah-langkah Alur Kerja

1.  **Membuat Feature Branch**: Setiap pengembangan fitur atau perbaikan bug dimulai dengan membuat *branch* baru dari *branch* utama (misalnya, `main` atau `develop`). Ini mengisolasi perubahan dan mencegah konflik.
    ```bash
    git checkout -b feature/nama-fitur
    ```

2.  **Instalasi Dependensi**: Pastikan semua dependensi proyek (PHP dan JavaScript) terinstal dan diperbarui.
    ```bash
    composer install
    npm install
    ```

3.  **Menjalankan Lingkungan Lokal**: Aktifkan lingkungan pengembangan lokal untuk mulai bekerja.
    ```bash
    docker-compose up -d
    ```

4.  **Menulis Kode**: Tulis kode sesuai dengan fitur yang dikerjakan dan pastikan mengikuti standar pengkodean (PSR-12) dan praktik terbaik yang telah ditetapkan.

5.  **Menjalankan Tes**: Sebelum mengajukan perubahan, jalankan semua tes (unit, fitur, dll.) untuk memastikan tidak ada regresi.
    ```bash
    php artisan test
    ```

6.  **Membuat Pull Request (PR)**: Setelah fitur selesai dan diuji, buat *Pull Request* (PR) dari *feature branch* Anda ke *branch* utama. Berikan deskripsi yang jelas tentang perubahan yang dibuat.

7.  **Code Review**: Anggota tim lain akan meninjau kode pada PR. Diskusi dan perbaikan mungkin diperlukan berdasarkan umpan balik sebelum PR dapat digabungkan (*merge*).

## Diagram Alir Proses

Berikut adalah visualisasi dari alur kerja pengembangan menggunakan Mermaid.js.

```mermaid
graph TD
    A[Mulai] --> B{Buat Feature Branch};
    B --> C[Instal/Update Dependensi];
    C --> D[Jalankan Lingkungan Lokal];
    D --> E[Tulis Kode & Terapkan Standar];
    E --> F{Jalankan Tes};
    F -- Lolos --> G[Buat Pull Request];
    F -- Gagal --> E;
    G --> H{Lakukan Code Review};
    H -- Disetujui --> I[Merge ke Branch Utama];
    H -- Butuh Perbaikan --> E;
    I --> J[Selesai];