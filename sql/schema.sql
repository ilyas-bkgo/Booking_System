DROP TABLE IF EXISTS appointment;
DROP TABLE IF EXISTS service;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS business;


CREATE TABLE business (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL,
    timezone TEXT NOT NULL DEFAULT 'Africa/Casablanca',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE staff (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    business_id BIGINT NOT NULL REFERENCES business(id) ON DELETE CASCADE,
    name TEXT NOT NULL ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE service (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    business_id BIGINT NOT NULL REFERENCES business(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    duration_minutes INTEGER NOT NULL CHECK (duration_minutes > 0),
    price_mad NUMERIC(8, 2) NOT NULL CHECK (price_mad >= 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE EXTENSION IF NOT EXISTS btree_gist;

CREATE TABLE appointment (
    id             BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    staff_id       BIGINT NOT NULL REFERENCES staff(id),
    service_id     BIGINT NOT NULL REFERENCES service(id),
    customer_name  TEXT NOT NULL,
    customer_phone TEXT NOT NULL,
    time_range     TSTZRANGE NOT NULL,
    status         TEXT NOT NULL DEFAULT 'booked'
                   CHECK (status IN ('booked', 'cancelled')),
    created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),

    CHECK (NOT isempty(time_range)),

    CONSTRAINT no_double_booking
        EXCLUDE USING gist (staff_id WITH =, time_range WITH &&)
        WHERE (status <> 'cancelled')
);