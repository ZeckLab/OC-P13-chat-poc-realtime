-- Your Car Your Way — Schéma de base de données (PostgreSQL)
-- Conforme à la 3e forme normale (3NF)

CREATE TABLE agency (
    id              SERIAL PRIMARY KEY,
    name            VARCHAR(150) NOT NULL,
    street          VARCHAR(255) NOT NULL,
    postal_code     VARCHAR(20) NOT NULL,
    city            VARCHAR(100) NOT NULL,
    country         VARCHAR(100) NOT NULL
);

-- Catalogue des catégories de véhicules, norme ACRISS (code à 4 lettres)
-- category/type/fuel : listes longues (15-20 valeurs chacune),
-- volontairement non contraintes en base — validées côté Java.
-- transmission/drive : listes courtes, contraintes ici.
CREATE TABLE acriss_category (
    code                VARCHAR(4) PRIMARY KEY,
    category            VARCHAR(30) NOT NULL,   -- ex : MINI, ECONOMY, COMPACT, INTERMEDIATE...
    type                VARCHAR(30) NOT NULL,   -- ex : SUV, WAGON, VAN, CONVERTIBLE...
    doors               INTEGER NOT NULL CHECK (doors > 0),
    transmission        VARCHAR(15) NOT NULL CHECK (transmission IN ('MANUAL', 'AUTOMATIC', 'ELECTRIC')),
    drive               VARCHAR(15) NOT NULL CHECK (drive IN ('UNSPECIFIED', '4WD', 'AWD')),
    air_conditioning    BOOLEAN NOT NULL DEFAULT TRUE,
    fuel                VARCHAR(30) NOT NULL    -- ex : PETROL, DIESEL, HYBRID, ELECTRIC, LPG...
);

CREATE TABLE vehicle (
    id              SERIAL PRIMARY KEY,
    category_code   VARCHAR(4) NOT NULL REFERENCES acriss_category(code),
    agency_id       INTEGER NOT NULL REFERENCES agency(id),
    status          VARCHAR(20) NOT NULL DEFAULT 'AVAILABLE'
                       CHECK (status IN ('AVAILABLE', 'RENTED', 'MAINTENANCE'))
);

CREATE TABLE rental_offer (
    id                  SERIAL PRIMARY KEY,
    pickup_agency_id    INTEGER NOT NULL REFERENCES agency(id),
    dropoff_agency_id   INTEGER NOT NULL REFERENCES agency(id),
    pickup_date         TIMESTAMP NOT NULL,
    dropoff_date        TIMESTAMP NOT NULL,
    category_code       VARCHAR(4) NOT NULL REFERENCES acriss_category(code),
    price               NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    CHECK (dropoff_date > pickup_date)
);

-- "user" est un mot réservé en PostgreSQL : la table est nommée app_user
CREATE TABLE app_user (
    id                  SERIAL PRIMARY KEY,
    email               VARCHAR(255) NOT NULL UNIQUE,
    password_hash       VARCHAR(255) NOT NULL,
    email_verified      BOOLEAN NOT NULL DEFAULT FALSE,
    last_name           VARCHAR(100) NOT NULL,
    first_name          VARCHAR(100) NOT NULL,
    birthday            DATE NOT NULL,
    street              VARCHAR(255),
    postal_code         VARCHAR(20),
    city                VARCHAR(100),
    country             VARCHAR(100),
    locale              VARCHAR(5) NOT NULL DEFAULT 'fr',
    currency_code       VARCHAR(3) NOT NULL DEFAULT 'EUR',
    created_at          TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE booking (
    id                          SERIAL PRIMARY KEY,
    user_id                     INTEGER NOT NULL REFERENCES app_user(id),
    offer_id                    INTEGER NOT NULL REFERENCES rental_offer(id),
    status                      VARCHAR(20) NOT NULL DEFAULT 'IN_PROGRESS'
                                   CHECK (status IN ('IN_PROGRESS', 'CANCELLED', 'COMPLETED')),
    booking_date                TIMESTAMP NOT NULL DEFAULT now(),
    total_amount                NUMERIC(10,2) NOT NULL CHECK (total_amount >= 0),
    refund_percentage           NUMERIC(5,2) CHECK (refund_percentage BETWEEN 0 AND 100),
    cancellation_date           DATE
);

CREATE TABLE payment (
    id                      SERIAL PRIMARY KEY,
    booking_id              INTEGER NOT NULL UNIQUE REFERENCES booking(id), -- 1..1
    amount                  NUMERIC(10,2) NOT NULL CHECK (amount >= 0),
    status                  VARCHAR(20) NOT NULL DEFAULT 'PENDING'
                               CHECK (status IN ('PENDING', 'VALIDATED', 'FAILED', 'REFUNDED')),
    provider_reference      VARCHAR(255) NOT NULL, -- ex : id d'intention de paiement Stripe
    payment_date             TIMESTAMP
);

CREATE TABLE message_support (
    id              SERIAL PRIMARY KEY,
    user_id         INTEGER NOT NULL REFERENCES app_user(id),
    content         TEXT NOT NULL,
    send_date       TIMESTAMP NOT NULL DEFAULT now(),
    direction       VARCHAR(20) NOT NULL
                       CHECK (direction IN ('USER_TO_SUPPORT', 'SUPPORT_TO_USER'))
);

-- Index utiles pour les recherches fréquentes (Business Requirements)
CREATE INDEX idx_offer_search ON rental_offer (pickup_agency_id, dropoff_agency_id, pickup_date, dropoff_date, category_code);
CREATE INDEX idx_booking_user ON booking (user_id);
CREATE INDEX idx_message_user ON message_support (user_id);
CREATE INDEX idx_vehicle_agency_category ON vehicle (agency_id, category_code);
CREATE INDEX idx_agency_search ON agency (city, country);
