USE university_sql;

-- Table filler

	-- COURSES

		INSERT INTO courses (courses_name)
		VALUES ('Course01');

		SELECT *
		FROM courses;

	-- STUDENTS

		INSERT INTO students (students_name, students_email)
		VALUES ('Student01', 'student01@test.com');

		SELECT *
		FROM students;

	-- PROFESSORS

		INSERT INTO professors (professors_name, professors_email)
		VALUES ('Professor01', 'professor01@test.com');

		SELECT *
		FROM professors;

	-- GRADES

		INSERT INTO grades (grades_valor)
		VALUES (0);

		SET SQL_SAFE_UPDATES = 0;

		UPDATE grades
		SET grades_valor = RAND()*10;

		SELECT *
		FROM grades;

	-- ENROLLMENT

		INSERT INTO enrollment ( student_id, course_id, professor_id, grade_id)
		VALUES ( 1, 1, 1, 1);

		SELECT *
		FROM enrollment;

-- QUERIES

	-- The average grade that is given by each professor

		SELECT p.professors_name AS 'Professor', AVG(g.grades_valor) AS 'Avg Grade'
		FROM grades g
		JOIN enrollment e
		ON g.grades_id = e.grade_id
		JOIN professors p
		ON p.professors_id = e.professor_id
		GROUP BY e.professor_id
        ORDER BY AVG(g.grades_valor) ASC;

	-- The top grades for each student

		SELECT s.students_name AS 'Student Name', MAX(g.grades_valor) AS 'Top Grade'
		FROM grades g
		JOIN enrollment e
		ON g.grades_id = e.grade_id
		JOIN students s
		ON s.students_id = e.student_id
		GROUP BY e.student_id
        ORDER BY 'Student Name' ASC;

	-- Group students by the courses that they are enrolled in

		SELECT c.courses_name AS 'Course', GROUP_CONCAT(s.students_name SEPARATOR ', ' ) AS 'Students'
		FROM courses c
		JOIN enrollment e
		ON c.courses_id = e.course_id
		LEFT JOIN students s
		ON s.students_id = e.student_id
		GROUP BY c.courses_name
        ORDER BY Course ASC;

	-- Create a summary report of courses and their average grades,
	-- sorted by the most challenging course (course with the lowest average grade)
	-- to the easiest course

		SELECT c.courses_name AS 'Course', AVG(g.grades_valor) AS 'Avg Grade'
		FROM grades g
		JOIN enrollment e
		ON g.grades_id = e.grade_id
		JOIN courses c
		ON c.courses_id = e.course_id
		GROUP BY e.course_id
		ORDER BY AVG(g.grades_valor) ASC;

	-- Finding which student and professor have the most courses in common

		-- Using LIMIT

			SELECT s.students_name AS 'Student', p.professors_name AS 'Professor', COUNT(e.course_id) AS 'Common_Courses'
			FROM students s
			JOIN enrollment e
			ON s.students_id = e.student_id
			JOIN professors p
			ON p.professors_id = e.professor_id
			GROUP BY Student, Professor
			ORDER BY COUNT(e.course_id) DESC LIMIT 1;

		-- Using Subqueries

			SELECT s.students_name AS 'Student', p.professors_name AS 'Professor', COUNT(e.course_id) AS 'MaxCommonCourses'
			FROM enrollment e
			JOIN students s
			ON s.students_id = e.student_id
			JOIN professors p
			ON p.professors_id = e.professor_id
			GROUP BY s.students_name, p.professors_name
			HAVING MaxCommonCourses = (SELECT MAX(CourseCounter)
			FROM (
			SELECT e2.student_id, e2.professor_id, 
			COUNT(e2.course_id) AS 'CourseCounter'
			FROM enrollment e2
			GROUP BY e2.student_id, e2.professor_id
			) AS Q0)
            ORDER BY Student ASC;
