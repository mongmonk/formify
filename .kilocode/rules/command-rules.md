# Aturan Perintah Operasional

Dokumen ini mendefinisikan perintah-perintah standar yang digunakan dalam berbagai mode operasional proyek.

## Development

Mode pengembangan menggunakan Docker untuk mengelola lingkungan lokal.

### `docker-compose up -d`

*   **Tujuan**: Memulai semua layanan yang didefinisikan dalam file `docker-compose.yml` (seperti server web, database, dll.) dan menjalankannya di latar belakang (`-d` atau *detached mode*).
*   **Sintaks Lengkap**: `docker-compose [-f <file>] up -d [--build]`
*   **Contoh Penggunaan**:
    ```bash
    # Memulai semua layanan di latar belakang
    docker-compose up -d

    # Memaksa pembangunan ulang image sebelum memulai layanan
    docker-compose up -d --build
    ```

### `npm run dev`

*   **Tujuan**: Mengkompilasi aset frontend (seperti JavaScript dan CSS) untuk lingkungan pengembangan. Perintah ini biasanya mengaktifkan *hot-reloading*, yang secara otomatis memperbarui aset di browser saat ada perubahan pada kode sumber.
*   **Sintaks Lengkap**: `npm run dev`
*   **Contoh Penggunaan**:
    ```bash
    # Menjalankan proses kompilasi aset frontend
    npm run dev
    ```

## Production

Mode produksi dikelola menggunakan Kubernetes untuk orkestrasi kontainer.

### `kubectl`

*   **Tujuan**: `kubectl` adalah alat baris perintah utama untuk berinteraksi dengan klaster Kubernetes. Ini digunakan untuk men-deploy aplikasi, mengelola sumber daya klaster, dan melihat log.
*   **Sintaks Lengkap**: `kubectl [command] [TYPE] [NAME] [flags]`
*   **Contoh Penggunaan**:
    ```bash
    # Menerapkan konfigurasi dari sebuah file
    kubectl apply -f deployment.yaml

    # Melihat status semua pod di namespace default
    kubectl get pods

    # Melihat log dari sebuah pod spesifik
    kubectl logs my-app-pod-12345
    ```

## Testing

Pengujian aplikasi dilakukan menggunakan framework pengujian bawaan Laravel.

### `php artisan test`

*   **Tujuan**: Menjalankan semua pengujian otomatis (unit dan fitur) yang ada di dalam direktori `tests/`. Ini adalah cara utama untuk memverifikasi bahwa fungsionalitas aplikasi berjalan sesuai harapan.
*   **Sintaks Lengkap**: `php artisan test [options] [--filter=...]`
*   **Contoh Penggunaan**:
    ```bash
    # Menjalankan semua suite pengujian
    php artisan test

    # Menjalankan pengujian dari file tertentu
    php artisan test tests/Feature/MyFeatureTest.php

    # Menjalankan metode pengujian spesifik menggunakan filter
    php artisan test --filter=MySpecificTest
    ```

## Scheduled Tasks

Tugas terjadwal Laravel dieksekusi menggunakan satu perintah utama.

### `php artisan schedule:run`

*   **Tujuan**: Menjalankan *scheduler* perintah Laravel. Perintah ini akan memeriksa semua tugas yang dijadwalkan di `app/Console/Kernel.php` dan menjalankan tugas-tugas yang waktunya telah tiba.
*   **Sintaks Lengkap**: `php artisan schedule:run`
*   **Contoh Penggunaan**: Perintah ini biasanya dijalankan oleh cron job setiap menit di server produksi.
    ```bash
    # Menjalankan tugas terjadwal yang jatuh tempo
    * * * * * cd /path-to-your-project && php artisan schedule:run >> /dev/null 2>&1