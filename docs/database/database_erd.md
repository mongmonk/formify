erDiagram
    users {
        bigint id PK
        varchar name
        varchar email UK
        timestamp email_verified_at
        varchar password
        varchar remember_token
        bigint current_team_id FK
        text profile_photo_path
    }

    teams {
        bigint id PK
        bigint user_id FK
        varchar name
        bool personal_team
    }

    team_user {
        bigint id PK
        bigint team_id FK
        bigint user_id FK
        varchar role
    }

    plans {
        int id PK
        varchar name UK
        numeric price_monthly
        jsonb features
        bool is_active
    }

    subscriptions {
        bigint id PK
        bigint team_id FK
        int plan_id FK
        varchar status
        timestamp starts_at
        timestamp ends_at
        text payment_proof_url
        bigint verified_by FK
        timestamp verified_at
    }

    forms {
        bigint id PK
        uuid uuid UK
        bigint team_id FK
        varchar name
        varchar slug
        jsonb styles
        bool is_active
        int submission_count
        timestamp last_reset_at
        UK(team_id, slug)
    }

    form_fields {
        bigint id PK
        bigint form_id FK
        varchar name
        varchar type
        text label
        jsonb validation_rules
        int order
    }

    customers {
        bigint id PK
        bigint team_id FK
        varchar email
        varchar name
        varchar phone
        text address
        UK(team_id, email)
    }

    orders {
        bigint id PK
        uuid uuid UK
        bigint form_id FK
        bigint team_id FK
        bigint customer_id FK
        numeric total_amount
        varchar currency
        varchar status
        text proof_of_payment_url
        timestamp payment_deadline
        timestamp created_at
    }

    order_items {
        bigint id PK
        bigint order_id FK
        varchar product_name
        int quantity
        numeric price_per_item
    }

    order_details {
        bigint id PK
        bigint order_id FK
        bigint form_field_id FK
        text value
        UK(order_id, form_field_id)
    }

    activity_logs {
        bigint id PK
        bigint user_id FK
        bigint team_id FK
        varchar action
        text description
        jsonb details
        timestamp created_at
    }

    users ||--o{ teams : "owns"
    users ||--o{ team_user : "is member of"
    teams ||--o{ team_user : "has members"
    teams ||--o{ subscriptions : "has"
    teams ||--o{ forms : "owns"
    teams ||--o{ orders : "receives"
    teams ||--o{ customers : "owns"
    teams ||--o{ activity_logs : "generates"
    plans ||--o{ subscriptions : "is chosen for"
    users ||--o{ subscriptions : "verifies"
    forms ||--o{ form_fields : "contains"
    forms ||--o{ orders : "generates"
    customers ||--o{ orders : "places"
    orders ||--o{ order_items : "contains"
    orders ||--o{ order_details : "has"
    form_fields ||--o{ order_details : "is filled in"
    users ||--o{ activity_logs : "performs"