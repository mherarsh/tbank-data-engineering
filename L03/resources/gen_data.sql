-- === Преподаватели ===
INSERT INTO teachers (name)
SELECT 'Teacher ' || i
FROM generate_series(1, 100) AS s(i);

-- === Курсы ===
INSERT INTO courses (title)
SELECT 'Course ' || i
FROM generate_series(1, 50) AS s(i);

-- === Преподаватели к курсам (1–3 на курс) ===
INSERT INTO course_teachers (course_id, teacher_id)
SELECT
    c.id,
    t.id
FROM courses c,
     LATERAL (
             SELECT id FROM teachers ORDER BY random() LIMIT (1 + floor(random() * 3))::int
     ) t;

-- === Студенты (в батчах по 100k) ===
INSERT INTO students (name, email, bio, is_active, internal_id)
SELECT
    'Student ' || g,
    'student' || g || '@university.edu',
    'Student ' || g || ' is interested in ' ||
    (ARRAY[
        'data science', 'web development', 'machine learning',
            'biology', 'history', 'psychology', 'design',
            'AI', 'robotics', 'mathematics'
        ])[floor(random() * 10 + 1)] ||
    '. Loves ' ||
    (ARRAY[
        'coffee', 'tea', 'hiking', 'chess', 'music',
            'coding at night', 'open source', 'cats', 'dogs'
        ])[floor(random() * 9 + 1)] || '.',
    CASE
        WHEN random() < 0.7 THEN true
        ELSE false
    END,
    uuid_in(md5(random()::text || random()::text)::cstring)
FROM generate_series(1, 1000000) AS g;

-- === Семестры (оставим те же 4) ===
WITH semesters AS (
    SELECT unnest(ARRAY['Fall 2023', 'Spring 2024', 'Fall 2024', 'Spring 2025']) AS sem
),
     student_ids AS (
         SELECT id FROM students
     ),
     course_ids AS (
         SELECT id FROM courses
     )
-- Примерно 3–5 записей на студента
INSERT INTO enrollments (student_id, course_id, semester)
SELECT
    s.id,
    c.id,
    sem.sem
FROM student_ids s,
     LATERAL (
             SELECT id FROM courses ORDER BY random() LIMIT (3 + floor(random() * 3))::int
     ) c,
     LATERAL (
             SELECT sem FROM semesters ORDER BY random() LIMIT 1
     ) sem;

-- === Оценки (в 1–2 экземплярах на enrollment) ===
-- Это создаст 2–3 млн строк
INSERT INTO grades (enrollment_id, grade, graded_at)
SELECT
    e.id,
    round((5 + random() * 5)::numeric, 1),
    CURRENT_DATE - (random() * 365)::int
FROM enrollments e
         JOIN generate_series(1, 2) gs ON random() < 0.75;
