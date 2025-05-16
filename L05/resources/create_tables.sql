CREATE TABLE teachers
(
    id         SERIAL PRIMARY KEY,
    full_name  VARCHAR(255) NOT NULL,
    department VARCHAR(100)
);

CREATE TABLE students
(
    id              SERIAL PRIMARY KEY,
    full_name       VARCHAR(255) NOT NULL,
    enrollment_year INT
);

CREATE TABLE courses
(
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(255) NOT NULL,
    teacher_id INT REFERENCES teachers (id)
);

CREATE TABLE grades
(
    student_id INT REFERENCES students (id),
    course_id  INT REFERENCES courses (id),
    grade      INT CHECK (grade BETWEEN 0 AND 100),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (student_id, course_id, created_at)
);
