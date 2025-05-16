--== Партиции по диапазону дат ==--
CREATE TABLE grades_partitioned
(
    student_id INT,
    course_id  INT,
    grade      INT CHECK (grade BETWEEN 0 AND 100),
    created_at TIMESTAMPTZ NOT NULL,
    PRIMARY KEY (student_id, course_id, created_at)
) PARTITION BY RANGE (created_at);

CREATE TABLE grades_2024_01 PARTITION OF grades_partitioned
    FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');

CREATE TABLE grades_2024_02 PARTITION OF grades_partitioned
    FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');

CREATE TABLE grades_2024_03 PARTITION OF grades_partitioned
    FOR VALUES FROM ('2024-03-01') TO ('2024-04-01');

CREATE TABLE grades_2024_04 PARTITION OF grades_partitioned
    FOR VALUES FROM ('2024-04-01') TO ('2024-05-01');

CREATE TABLE grades_2024_05 PARTITION OF grades_partitioned
    FOR VALUES FROM ('2024-05-01') TO ('2024-06-01');



--== Списковое партицирование ==--
CREATE TABLE students_partitioned
(
    id              SERIAL,
    full_name       VARCHAR(255),
    enrollment_year INT,
    faculty         VARCHAR(50),
    PRIMARY KEY (id, faculty)
) PARTITION BY LIST (faculty);

CREATE TABLE students_human_science PARTITION OF students_partitioned FOR VALUES IN ('LANGUAGES', 'PHILOSOPHY');
CREATE TABLE students_engineering_science PARTITION OF students_partitioned FOR VALUES IN ('MATH', 'PHYSICS');








--== Хэш партиционирование ==--
CREATE TABLE courses_partitioned
(
    id         SERIAL,
    name       VARCHAR(255),
    teacher_id INT,
    PRIMARY KEY (id)
) PARTITION BY HASH (id);

CREATE TABLE courses_0 PARTITION OF courses_partitioned FOR VALUES WITH (MODULUS 2, REMAINDER 0);
CREATE TABLE courses_1 PARTITION OF courses_partitioned FOR VALUES WITH (MODULUS 2, REMAINDER 1);
