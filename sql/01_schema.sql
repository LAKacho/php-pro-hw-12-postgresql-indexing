DROP TABLE IF EXISTS ticket, screening_price, seat, screening, hall, movie CASCADE;

CREATE TABLE movie (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title text NOT NULL,
    duration_min smallint NOT NULL CHECK (duration_min > 0)
);

CREATE TABLE hall (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name text NOT NULL UNIQUE
);

CREATE TABLE seat (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    hall_id bigint NOT NULL REFERENCES hall(id),
    row_no smallint NOT NULL,
    seat_no smallint NOT NULL,
    UNIQUE (hall_id, row_no, seat_no)
);

CREATE TABLE screening (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    movie_id bigint NOT NULL REFERENCES movie(id),
    hall_id bigint NOT NULL REFERENCES hall(id),
    starts_at timestamptz NOT NULL
);

CREATE TABLE screening_price (
    screening_id bigint NOT NULL REFERENCES screening(id),
    category text NOT NULL,
    price numeric(10,2) NOT NULL,
    PRIMARY KEY (screening_id, category)
);

CREATE TABLE ticket (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    screening_id bigint NOT NULL REFERENCES screening(id),
    seat_id bigint NOT NULL REFERENCES seat(id),
    price_paid numeric(10,2) NOT NULL,
    purchased_at timestamptz NOT NULL,
    UNIQUE (screening_id, seat_id)
);
