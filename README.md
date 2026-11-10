# ДЗ 12. Индексирование данных в PostgreSQL

Воспроизводимая лабораторная работа для шести запросов кинотеатра. Скрипты создают схему, генерируют наборы примерно на 10 тысяч или 10 миллионов строк, снимают планы до оптимизации, добавляют покрывающие индексы и повторяют замеры.

## Запуск

```bash
docker compose up -d
docker compose exec -T postgres psql -U cinema -d cinema_perf < sql/01_schema.sql
docker compose exec -T postgres psql -U cinema -d cinema_perf -v scale=10000 < sql/02_generate.sql
docker compose exec -T postgres psql -U cinema -d cinema_perf < sql/04_explain.sql
docker compose exec -T postgres psql -U cinema -d cinema_perf < sql/05_optimize.sql
docker compose exec -T postgres psql -U cinema -d cinema_perf < sql/04_explain.sql
```

Для большого набора повторите генерацию с `-v scale=10000000`. Вывод планов удобно перенаправить в файлы:

```bash
docker compose exec -T postgres psql -U cinema -d cinema_perf -v scale=10000000 < sql/02_generate.sql
docker compose exec -T postgres psql -U cinema -d cinema_perf < sql/04_explain.sql > plan-10m-before.txt
docker compose exec -T postgres psql -U cinema -d cinema_perf < sql/05_optimize.sql
docker compose exec -T postgres psql -U cinema -d cinema_perf < sql/04_explain.sql > plan-10m-after.txt
docker compose exec -T postgres psql -U cinema -d cinema_perf < sql/06_admin.sql
```

Основные оптимизации: диапазоны по времени без функции над колонкой, индекс `screening(starts_at)` с включёнными полями для афиши и покрывающий индекс `ticket(purchased_at)` для недельной статистики и выручки. Запросы схемы зала и диапазона цен уже используют уникальные и первичные индексы.
