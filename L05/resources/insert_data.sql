-- ===== Teachers =====
INSERT INTO teachers (full_name, department)
VALUES ('Иванов Иван Иванович', 'Математика'),
       ('Петров Петр Петрович', 'Информатика'),
       ('Сидорова Мария Сергеевна', 'Физика'),
       ('Кузнецова Анна Викторовна', 'История'),
       ('Александров Алексей Алексеевич', 'Литература');

-- ===== Students =====
INSERT INTO students (full_name, enrollment_year)
VALUES ('Алексей Смирнов', 2022),
       ('Мария Иванова', 2023),
       ('Сергей Кузнецов', 2021),
       ('Анна Попова', 2022),
       ('Дмитрий Соколов', 2023),
       ('Ольга Лебедева', 2022),
       ('Игорь Морозов', 2021),
       ('Наталья Козлова', 2023),
       ('Евгений Новиков', 2022),
       ('Татьяна Михайлова', 2021);

-- ===== Courses =====
INSERT INTO courses (name, teacher_id)
VALUES ('Базы данных', 2),
       ('Математический анализ', 1),
       ('Физика', 3);

-- ===== Grades =====
-- Для вставки оценок за март 2024 и апрель 2024 (две партиции)
DO
$$
    DECLARE
        student   RECORD;
        course    RECORD;
        grade_val INT;
        date_val  TIMESTAMPTZ;
    BEGIN
        FOR student IN SELECT id FROM students
            LOOP
                FOR course IN SELECT id FROM courses
                    LOOP
                        -- Случайная дата в марте 2024
                        date_val := DATE '2024-03-01' + (random() * 30)::INT;
                        grade_val := 60 + (random() * 40)::INT;
                        INSERT INTO grades (student_id, course_id, grade, created_at)
                        VALUES (student.id, course.id, grade_val, date_val);

-- Случайная дата в апреле 2024
                        date_val := DATE '2024-04-01' + (random() * 29)::INT;
                        grade_val := 60 + (random() * 40)::INT;
                        INSERT INTO grades (student_id, course_id, grade, created_at)
                        VALUES (student.id, course.id, grade_val, date_val);
                    END LOOP;
            END LOOP;
    END;
$$;
