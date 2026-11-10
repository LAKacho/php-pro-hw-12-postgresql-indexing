\timing on
EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM screening WHERE starts_at >= CURRENT_DATE AND starts_at < CURRENT_DATE + interval '1 day' ORDER BY starts_at;
EXPLAIN (ANALYZE, BUFFERS) SELECT count(*) FROM ticket WHERE purchased_at >= now() - interval '7 days';
EXPLAIN (ANALYZE, BUFFERS) SELECT movie.title, screening.starts_at FROM screening JOIN movie ON movie.id = screening.movie_id WHERE screening.starts_at >= CURRENT_DATE AND screening.starts_at < CURRENT_DATE + interval '1 day' ORDER BY movie.title, screening.starts_at;
EXPLAIN (ANALYZE, BUFFERS) SELECT movie.title, sum(ticket.price_paid) AS revenue FROM ticket JOIN screening ON screening.id = ticket.screening_id JOIN movie ON movie.id = screening.movie_id WHERE ticket.purchased_at >= now() - interval '7 days' GROUP BY movie.id, movie.title ORDER BY revenue DESC LIMIT 3;
EXPLAIN (ANALYZE, BUFFERS) SELECT seat.row_no, seat.seat_no, ticket.id IS NOT NULL AS occupied FROM screening JOIN seat ON seat.hall_id = screening.hall_id LEFT JOIN ticket ON ticket.screening_id = screening.id AND ticket.seat_id = seat.id WHERE screening.id = 1 ORDER BY seat.row_no, seat.seat_no;
EXPLAIN (ANALYZE, BUFFERS) SELECT min(price), max(price) FROM screening_price WHERE screening_id = 1;
