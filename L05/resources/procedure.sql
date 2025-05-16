CREATE OR REPLACE PROCEDURE delete_course_if_no_grades(p_course_id INT)
AS $$
DECLARE
    cnt INT;
BEGIN
    SELECT COUNT(*) INTO cnt FROM grades WHERE course_id = p_course_id;

    IF cnt > 0 THEN
        RAISE NOTICE 'Cannot delete course %: % grades exist', p_course_id, cnt;
    ELSE
        DELETE FROM courses WHERE id = p_course_id;
        RAISE NOTICE 'Course % deleted successfully', p_course_id;
    END IF;
END;
$$ LANGUAGE plpgsql;

CALL delete_course_if_no_grades(1);
