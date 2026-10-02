INSERT INTO business (name) VALUES ('Atlas Barber Shop');

INSERT INTO staff (business_id, name) VALUES
    (1, 'Youssef'),
    (1, 'Samira');

INSERT INTO service (business_id, name, duration_minutes, price_mad) VALUES
    (1, 'Haircut', 30, 80),
    (1, 'Beard trim', 15, 40),
    (1, 'Haircut + beard', 45, 110);