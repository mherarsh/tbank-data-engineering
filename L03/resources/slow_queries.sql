-- Ищем конкретного студента
EXPLAIN ANALYZE
SELECT * FROM students WHERE name = 'Student 500000';

-- Ищем студента по email
EXPLAIN ANALYZE
SELECT * FROM students
WHERE email = 'student99999@university.edu';

-- Ищем студентов по полям с низкой кардинальность (true или false)
EXPLAIN ANALYSE
SELECT * FROM students WHERE is_active = false;

-- Фильтрация по семестру + JOIN-ы
EXPLAIN ANALYZE
SELECT s.name, c.title
FROM enrollments e
         JOIN students s ON e.student_id = s.id
         JOIN courses c ON e.course_id = c.id
WHERE e.semester = 'Fall 2024';

-- Агрегация средней оценки по курсам
EXPLAIN ANALYZE
SELECT c.title, ROUND(AVG(g.grade), 2) AS avg_grade
FROM grades g
         JOIN enrollments e ON g.enrollment_id = e.id
         JOIN courses c ON e.course_id = c.id
GROUP BY c.title
ORDER BY avg_grade DESC;

-- Последовательный поиск по дате
EXPLAIN ANALYZE
SELECT * FROM grades
WHERE graded_at BETWEEN '2024-01-01' AND '2025-03-01';

-- Поиск по bio без индекса
EXPLAIN ANALYZE
SELECT * FROM students
WHERE bio LIKE '%source%';

-- Поиск по bio с индексом (!Выполнить после добавления индекса!)
EXPLAIN ANALYZE
SELECT * FROM students
WHERE to_tsvector('english', bio) @@ to_tsquery('robotics & coding');

-- Поиск с оконкой
EXPLAIN ANALYZE
WITH filtered_students AS (
    SELECT *
    FROM students
    WHERE id BETWEEN 250000 AND 750000
      AND is_active = false
)
SELECT * FROM filtered_students WHERE name = 'Student 500000';
