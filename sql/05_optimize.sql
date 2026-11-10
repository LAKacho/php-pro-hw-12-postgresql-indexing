CREATE INDEX IF NOT EXISTS screening_starts_cover_idx ON screening (starts_at) INCLUDE (movie_id, hall_id);
CREATE INDEX IF NOT EXISTS ticket_purchased_cover_idx ON ticket (purchased_at) INCLUDE (screening_id, price_paid);
CREATE INDEX IF NOT EXISTS seat_hall_position_idx ON seat (hall_id, row_no, seat_no);
ANALYZE;
