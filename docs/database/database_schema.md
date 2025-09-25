### **3. Definisi Tabel Detail**

#### **Tabel: `plans`**
Menyimpan daftar paket langganan yang tersedia.

| Nama Kolom | Tipe Data | Kendala | Deskripsi |
| :--- | :--- | :--- | :--- |
| `id` | `SERIAL` | `PRIMARY KEY` | ID unik untuk setiap paket. |
| `name` | `VARCHAR(255)` | `NOT NULL`, `UNIQUE` | Nama paket (e.g., 'Free', 'Pro', 'Business'). |
| `price_monthly` | `NUMERIC(10, 2)` | `NOT NULL` | Harga langganan per bulan. |
| `features` | `JSONB` | `NOT NULL` | Fitur yang termasuk dalam paket (e.g., batas formulir, batas pengiriman). |
| `is_active` | `BOOLEAN` | `NOT NULL`, `DEFAULT true` | Menandakan apakah paket ini dapat dipilih oleh pengguna baru. |
| `created_at` | `TIMESTAMPTZ` | `DEFAULT NOW()` | Waktu pembuatan record. |
| `updated_at` | `TIMESTAMPTZ` | `DEFAULT NOW()` | Waktu pembaruan record terakhir. |

#### **Tabel: `subscriptions`**
Mencatat langganan setiap tim ke sebuah paket.

| Nama Kolom | Tipe Data | Kendala | Deskripsi |
| :--- | :--- | :--- | :--- |
| `id` | `BIGSERIAL` | `PRIMARY KEY` | ID unik untuk setiap record langganan. |
| `team_id` | `BIGINT` | `NOT NULL`, `FOREIGN KEY (teams.id)` | ID tim yang berlangganan. |
| `plan_id` | `INT` | `NOT NULL`, `FOREIGN KEY (plans.id)` | ID paket yang dilanggani. |
| `status` | `VARCHAR(50)` | `NOT NULL` | Status langganan (e.g., 'pending_payment', 'active', 'expired'). |
| `starts_at` | `TIMESTAMPTZ` | - | Waktu mulai periode langganan. |
| `ends_at` | `TIMESTAMPTZ` | - | Waktu berakhir periode langganan. |
| `payment_proof_url` | `TEXT` | - | URL bukti pembayaran yang diunggah. |
| `verified_by` | `BIGINT` | `FOREIGN KEY (users.id)` | ID admin yang memverifikasi pembayaran. |
| `verified_at` | `TIMESTAMPTZ` | - | Waktu verifikasi pembayaran. |
| `created_at` | `TIMESTAMPTZ` | `DEFAULT NOW()` | Waktu pembuatan record. |
| `updated_at` | `TIMESTAMPTZ` | `DEFAULT NOW()` | Waktu pembaruan record terakhir. |

#### **Tabel: `forms`**
Menyimpan data inti untuk setiap formulir yang dibuat oleh tenant.

| Nama Kolom | Tipe Data | Kendala | Deskripsi |
| :--- | :--- | :--- | :--- |
| `id` | `BIGSERIAL` | `PRIMARY KEY` | ID unik internal. |
| `uuid` | `UUID` | `NOT NULL`, `UNIQUE` | ID unik publik untuk akses via API/embed. |
| `team_id` | `BIGINT` | `NOT NULL`, `FOREIGN KEY (teams.id)` | ID tim pemilik formulir. |
| `name` | `VARCHAR(255)` | `NOT NULL` | Nama internal formulir untuk tenant. |
| `slug` | `VARCHAR(255)` | `NOT NULL`, `UNIQUE(team_id, slug)` | Slug URL yang unik per tim. |
| `styles` | `JSONB` | `NOT NULL`, `DEFAULT '{}'` | Konfigurasi tampilan/CSS untuk formulir. |
| `is_active` | `BOOLEAN` | `NOT NULL`, `DEFAULT true` | Menandakan apakah formulir aktif menerima kiriman. |
| `submission_count` | `INT` | `NOT NULL`, `DEFAULT 0` | Jumlah kiriman yang diterima sejak reset terakhir. |
| `last_reset_at` | `TIMESTAMPTZ` | - | Waktu terakhir counter `submission_count` di-reset. |
| `created_at` | `TIMESTAMPTZ` | `DEFAULT NOW()` | Waktu pembuatan record. |
| `updated_at` | `TIMESTAMPTZ` | `DEFAULT NOW()` | Waktu pembaruan record terakhir. |

#### **Tabel: `form_fields`**
Mendefinisikan setiap field (input) dalam sebuah formulir.

| Nama Kolom | Tipe Data | Kendala | Deskripsi |
| :--- | :--- | :--- | :--- |
| `id` | `BIGSERIAL` | `PRIMARY KEY` | ID unik untuk setiap field. |
| `form_id` | `BIGINT` | `NOT NULL`, `FOREIGN KEY (forms.id)` | ID formulir tempat field ini berada. |
| `name` | `VARCHAR(255)` | `NOT NULL` | Nama unik field (untuk `name` atribut HTML). |
| `type` | `VARCHAR(50)` | `NOT NULL` | Tipe input (e.g., 'text', 'email', 'select', 'checkbox'). |
| `label` | `TEXT` | `NOT NULL` | Teks label yang ditampilkan kepada pengguna. |
| `validation_rules` | `JSONB` | `NOT NULL`, `DEFAULT '{}'` | Aturan validasi untuk field ini (e.g., 'required', 'min:5'). |
| `order` | `INT` | `NOT NULL`, `DEFAULT 0` | Urutan tampilan field dalam formulir. |
| `created_at` | `TIMESTAMPTZ` | `DEFAULT NOW()` | Waktu pembuatan record. |
| `updated_at` | `TIMESTAMPTZ` | `DEFAULT NOW()` | Waktu pembaruan record terakhir. |

#### **Tabel: `customers`**
Menyimpan data pelanggan yang mengisi formulir, unik per tenant.

| Nama Kolom | Tipe Data | Kendala | Deskripsi |
| :--- | :--- | :--- | :--- |
| `id` | `BIGSERIAL` | `PRIMARY KEY` | ID unik internal pelanggan. |
| `team_id` | `BIGINT` | `NOT NULL`, `FOREIGN KEY (teams.id)` | ID tim yang memiliki data pelanggan ini. |
| `email` | `VARCHAR(255)` | `NOT NULL`, `UNIQUE(team_id, email)` | Email pelanggan, unik untuk setiap tenant. |
| `name` | `VARCHAR(255)` | - | Nama lengkap pelanggan. |
| `phone` | `VARCHAR(50)` | - | Nomor telepon pelanggan. |
| `address` | `TEXT` | - | Alamat pelanggan. |
| `created_at` | `TIMESTAMPTZ` | `DEFAULT NOW()` | Waktu pembuatan record. |
| `updated_at` | `TIMESTAMPTZ` | `DEFAULT NOW()` | Waktu pembaruan record terakhir. |

#### **Tabel: `orders`**
Menyimpan data header untuk setiap pesanan yang masuk.

| Nama Kolom | Tipe Data | Kendala | Deskripsi |
| :--- | :--- | :--- | :--- |
| `id` | `BIGSERIAL` | `PRIMARY KEY` | ID unik internal pesanan. |
| `uuid` | `UUID` | `NOT NULL`, `UNIQUE` | ID unik publik untuk referensi pelanggan. |
| `form_id` | `BIGINT` | `NOT NULL`, `FOREIGN KEY (forms.id)` | ID formulir asal pesanan. |
| `team_id` | `BIGINT` | `NOT NULL`, `FOREIGN KEY (teams.id)` | ID tim penerima pesanan. |
| `customer_id` | `BIGINT` | `NOT NULL`, `FOREIGN KEY (customers.id)` | ID pelanggan yang membuat pesanan. |
| `total_amount` | `NUMERIC(12, 2)` | `NOT NULL` | Jumlah total pesanan. |
| `currency` | `VARCHAR(10)` | `NOT NULL`, `DEFAULT 'IDR'` | Mata uang pesanan. |
| `status` | `VARCHAR(50)` | `NOT NULL` | Status pesanan (e.g., 'pending', 'paid', 'shipped', 'cancelled'). |
| `proof_of_payment_url` | `TEXT` | - | URL bukti pembayaran yang diunggah pelanggan. |
| `payment_deadline` | `TIMESTAMPTZ` | - | Batas waktu pembayaran. |
| `created_at` | `TIMESTAMPTZ` | `DEFAULT NOW()` | Waktu pembuatan record. |
| `updated_at` | `TIMESTAMPTZ` | `DEFAULT NOW()` | Waktu pembaruan record terakhir. |

#### **Tabel: `order_items`**
Menyimpan detail item produk dalam sebuah pesanan (jika ada).

| Nama Kolom | Tipe Data | Kendala | Deskripsi |
| :--- | :--- | :--- | :--- |
| `id` | `BIGSERIAL` | `PRIMARY KEY` | ID unik. |
| `order_id` | `BIGINT` | `NOT NULL`, `FOREIGN KEY (orders.id)` | ID pesanan induk. |
| `product_name` | `VARCHAR(255)` | `NOT NULL` | Nama produk/item yang dipesan. |
| `quantity` | `INT` | `NOT NULL`, `DEFAULT 1` | Jumlah item yang dipesan. |
| `price_per_item` | `NUMERIC(10, 2)` | `NOT NULL` | Harga per satu item. |

#### **Tabel: `order_details`**
Menyimpan nilai dari setiap field formulir untuk sebuah pesanan.

| Nama Kolom | Tipe Data | Kendala | Deskripsi |
| :--- | :--- | :--- | :--- |
| `id` | `BIGSERIAL` | `PRIMARY KEY` | ID unik. |
| `order_id` | `BIGINT` | `NOT NULL`, `FOREIGN KEY (orders.id)` | ID pesanan induk. |
| `form_field_id` | `BIGINT` | `NOT NULL`, `FOREIGN KEY (form_fields.id)` | ID field formulir yang diisi. |
| `value` | `TEXT` | `NOT NULL` | Nilai yang diisi oleh pelanggan untuk field tersebut. |

#### **Tabel: `activity_logs`**
Mencatat aktivitas penting yang dilakukan oleh pengguna.

| Nama Kolom | Tipe Data | Kendala | Deskripsi |
| :--- | :--- | :--- | :--- |
| `id` | `BIGSERIAL` | `PRIMARY KEY` | ID unik log. |
| `user_id` | `BIGINT` | `FOREIGN KEY (users.id)` | Pengguna yang melakukan aksi. |
| `team_id` | `BIGINT` | `FOREIGN KEY (teams.id)` | Konteks tim tempat aksi dilakukan. |
| `action` | `VARCHAR(255)` | `NOT NULL` | Deskripsi singkat aksi (e.g., 'form.created', 'order.deleted'). |
| `description` | `TEXT` | - | Deskripsi aksi yang lebih mudah dibaca manusia. |
| `details` | `JSONB` | - | Data kontekstual tambahan tentang aksi (e.g., atribut yang berubah). |
| `created_at` | `TIMESTAMPTZ` | `DEFAULT NOW()` | Waktu aksi dilakukan. |