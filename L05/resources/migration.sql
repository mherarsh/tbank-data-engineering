-- Шаг 3: Переносим данные (с фильтрацией по created_at)
INSERT INTO grades_partitioned
SELECT * FROM grades WHERE created_at BETWEEN '2024-03-01' AND '2024-06-01';

-- Шаг 4: Архивируем
ALTER TABLE grades RENAME TO grades_backup;
ALTER TABLE grades_partitioned RENAME TO grades;

EXPLAIN ANALYSE
SELECT * FROM grades WHERE created_at = '2024-03-05 00:00:00.000000 +00:00';

EXPLAIN ANALYSE
SELECT * FROM grades_2024_03;


