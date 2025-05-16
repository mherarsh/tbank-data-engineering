CREATE TABLE grade_audit
(
    student_id INT,
    course_id  INT,
    old_grade  INT,
    new_grade  INT,
    changed_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION audit_grade_change()
    RETURNS TRIGGER AS
$$
BEGIN
    IF OLD.grade <> NEW.grade THEN
        INSERT INTO grade_audit (student_id, course_id, old_grade, new_grade)
        VALUES (OLD.student_id, OLD.course_id, OLD.grade, NEW.grade);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_grade_audit
    BEFORE UPDATE
    ON grades
    FOR EACH ROW
EXECUTE FUNCTION audit_grade_change();
