\if :{?scale}
\else
\set scale 10000
\endif

TRUNCATE ticket, screening_price, seat, screening, hall, movie RESTART IDENTITY CASCADE;

INSERT INTO movie (title, duration_min)
SELECT 'Movie ' || number, 80 + number % 80
FROM generate_series(1, GREATEST(50, (:scale / 20000)::integer)) AS number;

INSERT INTO hall (name)
SELECT 'Hall ' || number FROM generate_series(1, 10) AS number;

INSERT INTO seat (hall_id, row_no, seat_no)
SELECT hall.id, row_no, seat_no
FROM hall
CROSS JOIN generate_series(1, 10) AS row_no
CROSS JOIN generate_series(1, 20) AS seat_no;

INSERT INTO screening (movie_id, hall_id, starts_at)
SELECT
    1 + number % (SELECT count(*) FROM movie),
    1 + number % 10,
    CURRENT_DATE - interval '180 days' + number * interval '5 minutes'
FROM generate_series(1, GREATEST(100, (:scale / 134)::integer)) AS number;

INSERT INTO screening_price (screening_id, category, price)
SELECT id, category, price
FROM screening
CROSS JOIN (VALUES ('standard', 350.00), ('vip', 700.00)) AS prices(category, price);

INSERT INTO ticket (screening_id, seat_id, price_paid, purchased_at)
SELECT
    1 + (number - 1) % (SELECT count(*) FROM screening),
    1 + ((number - 1) / (SELECT count(*) FROM screening)) % (SELECT count(*) FROM seat),
    300 + number % 500,
    now() - (number % 365) * interval '1 day' - (number % 86400) * interval '1 second'
FROM generate_series(1, (:scale - (SELECT count(*) FROM movie) - (SELECT count(*) FROM hall) - (SELECT count(*) FROM seat) - (SELECT count(*) FROM screening) - (SELECT count(*) FROM screening_price))::bigint) AS number
ON CONFLICT (screening_id, seat_id) DO NOTHING;

ANALYZE;

SELECT 'total_rows' AS metric,
       (SELECT count(*) FROM movie) +
       (SELECT count(*) FROM hall) +
       (SELECT count(*) FROM seat) +
       (SELECT count(*) FROM screening) +
       (SELECT count(*) FROM screening_price) +
       (SELECT count(*) FROM ticket) AS value;
