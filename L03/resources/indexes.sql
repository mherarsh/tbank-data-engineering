-- BTree индекс на имя студента
CREATE INDEX idx_students_name ON students(name);

-- Хэш индекс по internal_id
CREATE INDEX idx_student_internal_id ON students USING hash(internal_id);

-- JOIN по student_id и course_id
CREATE INDEX idx_enrollments_student_id ON enrollments(student_id);
CREATE INDEX idx_enrollments_course_id ON enrollments(course_id);

CREATE INDEX idx_enrollments_course_id ON enrollments(course_id);
CREATE INDEX idx_grades_enrollment_id ON grades(enrollment_id);


CREATE INDEX idx_grades_graded_at ON grades(graded_at);


CREATE INDEX idx_course_teachers_course_id ON course_teachers(course_id);
CREATE INDEX idx_course_teachers_teacher_id ON course_teachers(teacher_id);

-- Индекс полнтекстового поиска по bio
CREATE INDEX idx_students_bio_tsv ON students
USING GIN (to_tsvector('english', bio));

