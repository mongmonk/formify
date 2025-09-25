# Alur Kerja CI/CD

Dokumen ini menjelaskan alur kerja Continuous Integration/Continuous Deployment (CI/CD) yang digunakan dalam proyek ini. Pipeline ini dirancang untuk mengotomatiskan proses pengujian, pembangunan, dan deployment aplikasi, memastikan kualitas kode yang tinggi dan pengiriman yang andal.

## Platform

Alur kerja ini diimplementasikan menggunakan **GitHub Actions**.

## Tahapan Pipeline

Berikut adalah rincian setiap tahapan dalam pipeline CI/CD:

1.  **Push to Repository**
    *   **Pemicu**: Alur kerja dimulai secara otomatis setiap kali ada `push` ke branch utama (misalnya, `main` atau `master`) atau saat pull request dibuat/diperbarui.
    *   **Tujuan**: Memulai proses validasi kode secara otomatis.

2.  **Run Tests**
    *   **Deskripsi**: Tahap ini menjalankan serangkaian pengujian otomatis untuk memverifikasi bahwa perubahan baru tidak merusak fungsionalitas yang ada.
    *   **Tindakan**:
        *   Menjalankan pengujian unit (`unit tests`).
        *   Menjalankan pengujian fitur (`feature tests`).
    *   **Tujuan**: Memastikan integritas dan stabilitas kode.

3.  **Run Static Analysis**
    *   **Deskripsi**: Analisis statis dilakukan untuk memeriksa kualitas kode, konsistensi gaya, dan potensi bug tanpa menjalankan kode itu sendiri.
    *   **Tindakan**: Menggunakan alat seperti PHPStan atau Larastan untuk analisis kode.
    *   **Tujuan**: Menjaga standar kualitas kode dan mencegah masalah umum.

4.  **Build Artifact**
    *   **Deskripsi**: Jika semua pengujian dan analisis berhasil, tahap ini mempersiapkan artefak yang siap untuk di-deploy.
    *   **Tindakan**:
        *   Membangun aset frontend (CSS/JS).
        *   Membuat image Docker untuk lingkungan produksi.
    *   **Tujuan**: Menghasilkan paket deployment yang konsisten dan terisolasi.

5.  **Deploy to Staging**
    *   **Deskripsi**: Artefak yang telah dibangun di-deploy ke lingkungan pementasan (staging) yang mencerminkan lingkungan produksi.
    *   **Tujuan**: Memungkinkan verifikasi manual, pengujian oleh tim QA, atau demonstrasi kepada pemangku kepentingan sebelum rilis ke produksi.

6.  **(Optional) Manual Approval**
    *   **Deskripsi**: Tahap ini berfungsi sebagai gerbang persetujuan sebelum deployment ke produksi. Ini adalah langkah opsional yang dapat diaktifkan untuk rilis yang memerlukan verifikasi akhir.
    *   **Tindakan**: Memerlukan persetujuan manual dari manajer proyek atau pimpinan tim teknis.
    *   **Tujuan**: Memberikan kontrol tambahan dan mengurangi risiko pada rilis kritis.

7.  **Deploy to Production**
    *   **Deskripsi**: Setelah semua tahapan sebelumnya berhasil (dan persetujuan manual diberikan jika diperlukan), aplikasi di-deploy ke lingkungan produksi.
    *   **Tindakan**: Menggunakan strategi *zero-downtime deployment* (misalnya, melalui Laravel Envoyer atau skrip kustom) untuk memastikan aplikasi tetap tersedia selama proses pembaruan.
    *   **Tujuan**: Merilis versi baru aplikasi kepada pengguna akhir tanpa gangguan layanan.

## Diagram Alir Pipeline

Berikut adalah visualisasi alur kerja CI/CD menggunakan Mermaid.js.

```mermaid
graph TD
    A[Push to Repository] --> B{Run Tests};
    B -- Success --> C{Run Static Analysis};
    B -- Failure --> Z[End];
    C -- Success --> D[Build Artifact];
    C -- Failure --> Z;
    D --> E[Deploy to Staging];
    E --> F{Manual Approval?};
    F -- Yes --> G[Wait for Approval];
    F -- No --> H[Deploy to Production];
    G -- Approved --> H;
    G -- Rejected --> Z;
    H --> I[End];
    Z;