-- !!!Индекс на колонки с низкой кардинальностью не имеют смысла!!!
CREATE INDEX idx_student_internal_id ON students(is_active);

-- Частичный индекс
CREATE INDEX idx_grades_recent_graded_at
    ON grades(graded_at)
    WHERE graded_at >= now() - interval '1 year';
