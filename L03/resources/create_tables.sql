-- Удалим таблицы, если они уже существуют (для повторного запуска скрипта)
DROP TABLE IF EXISTS grades, enrollments, course_teachers, students, teachers, courses CASCADE;

-- Студенты
CREATE TABLE students (
                          id SERIAL PRIMARY KEY,
                          name TEXT NOT NULL,
                          email TEXT UNIQUE NOT NULL,
                          internal_id UUID NOT NULL,
                          bio TEXT,
                          is_active BOOLEAN
);

-- Курсы
CREATE TABLE courses (
                         id SERIAL PRIMARY KEY,
                         title TEXT NOT NULL
);

-- Преподаватели
CREATE TABLE teachers (
                          id SERIAL PRIMARY KEY,
                          name TEXT NOT NULL
);

-- Связь преподавателей и курсов (многие ко многим)
CREATE TABLE course_teachers (
                                 id SERIAL PRIMARY KEY,
                                 course_id INTEGER NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
                                 teacher_id INTEGER NOT NULL REFERENCES teachers(id) ON DELETE CASCADE
);

-- Записи на курсы (многие ко многим между студентами и курсами, плюс семестр)
CREATE TABLE enrollments (
                             id SERIAL PRIMARY KEY,
                             student_id INTEGER NOT NULL REFERENCES students(id) ON DELETE CASCADE,
                             course_id INTEGER NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
                             semester TEXT NOT NULL
);

-- Оценки по результатам прохождения курса
CREATE TABLE grades (
                        id SERIAL PRIMARY KEY,
                        enrollment_id INTEGER NOT NULL REFERENCES enrollments(id) ON DELETE CASCADE,
                        grade NUMERIC(3, 1) CHECK (grade >= 0 AND grade <= 10),
                        graded_at DATE NOT NULL DEFAULT CURRENT_DATE
);



