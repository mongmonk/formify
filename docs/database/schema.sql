-- Ekstensi untuk menghasilkan UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Fungsi untuk memperbarui kolom 'updated_at' secara otomatis
CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Tabel untuk Paket Langganan
CREATE TABLE plans (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    price_monthly NUMERIC(10, 2) NOT NULL,
    features JSONB NOT NULL DEFAULT '{}',
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON plans
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

-- Tabel untuk Langganan Tim
-- Diasumsikan tabel 'users' dan 'teams' sudah ada dari Laravel Jetstream
CREATE TABLE subscriptions (
    id BIGSERIAL PRIMARY KEY,
    team_id BIGINT NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    plan_id INT NOT NULL REFERENCES plans(id) ON DELETE RESTRICT,
    status VARCHAR(50) NOT NULL,
    starts_at TIMESTAMPTZ,
    ends_at TIMESTAMPTZ,
    payment_proof_url TEXT,
    verified_by BIGINT REFERENCES users(id) ON DELETE SET NULL,
    verified_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX ON subscriptions (team_id);
CREATE INDEX ON subscriptions (plan_id);
CREATE INDEX ON subscriptions (status);

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON subscriptions
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

-- Tabel untuk Formulir
CREATE TABLE forms (
    id BIGSERIAL PRIMARY KEY,
    uuid UUID NOT NULL UNIQUE DEFAULT uuid_generate_v4(),
    team_id BIGINT NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL,
    styles JSONB NOT NULL DEFAULT '{}',
    is_active BOOLEAN NOT NULL DEFAULT true,
    submission_count INT NOT NULL DEFAULT 0,
    last_reset_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(team_id, slug)
);

CREATE INDEX ON forms (team_id);

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON forms
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

-- Tabel untuk Field dalam Formulir
CREATE TABLE form_fields (
    id BIGSERIAL PRIMARY KEY,
    form_id BIGINT NOT NULL REFERENCES forms(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(50) NOT NULL,
    label TEXT NOT NULL,
    validation_rules JSONB NOT NULL DEFAULT '{}',
    "order" INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(form_id, name)
);

CREATE INDEX ON form_fields (form_id);

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON form_fields
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

-- Tabel untuk Pelanggan
CREATE TABLE customers (
    id BIGSERIAL PRIMARY KEY,
    team_id BIGINT NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    email VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    phone VARCHAR(50),
    address TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(team_id, email)
);

CREATE INDEX ON customers (team_id);

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON customers
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

-- Tabel untuk Pesanan (Orders)
CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    uuid UUID NOT NULL UNIQUE DEFAULT uuid_generate_v4(),
    form_id BIGINT NOT NULL REFERENCES forms(id) ON DELETE CASCADE,
    team_id BIGINT NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    customer_id BIGINT NOT NULL REFERENCES customers(id) ON DELETE RESTRICT,
    total_amount NUMERIC(12, 2) NOT NULL,
    currency VARCHAR(10) NOT NULL DEFAULT 'IDR',
    status VARCHAR(50) NOT NULL,
    proof_of_payment_url TEXT,
    payment_deadline TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX ON orders (form_id);
CREATE INDEX ON orders (team_id);
CREATE INDEX ON orders (customer_id);
CREATE INDEX ON orders (status);

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON orders
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

-- Tabel untuk Item dalam Pesanan
CREATE TABLE order_items (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_name VARCHAR(255) NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    price_per_item NUMERIC(10, 2) NOT NULL
);

CREATE INDEX ON order_items (order_id);

-- Tabel untuk Detail Pesanan (data dari form_fields)
CREATE TABLE order_details (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    form_field_id BIGINT NOT NULL REFERENCES form_fields(id) ON DELETE CASCADE,
    value TEXT NOT NULL,
    UNIQUE(order_id, form_field_id)
);

CREATE INDEX ON order_details (order_id);
CREATE INDEX ON order_details (form_field_id);

-- Tabel untuk Log Aktivitas
CREATE TABLE activity_logs (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id) ON DELETE SET NULL,
    team_id BIGINT REFERENCES teams(id) ON DELETE SET NULL,
    action VARCHAR(255) NOT NULL,
    description TEXT,
    details JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX ON activity_logs (user_id);
CREATE INDEX ON activity_logs (team_id);
CREATE INDEX ON activity_logs (action);