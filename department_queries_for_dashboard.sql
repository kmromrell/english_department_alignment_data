/* English department analysis 
Queries are considering these conditions:
	- Though ACS is a core class, it is not considered a core English class
	- Calculations use a +/- grade scale (e.g., a B+ is a 3.3, not a 3) -- more specific, but not used to calculate GPA 
	- Original dashboard uses teacher names, as in queries below. Those are substituted for teacher ID numbers to keep data anonymous.
	
See corresponding tables in Google Sheet dashboard on the README page.*/

-- Table #1: Grades by Teacher and Class Type (with ROLLUP averages)

SELECT 
	CASE 
		WHEN course_title='Adv Comm Skills' THEN 'ACS'
		WHEN course_title LIKE '%AP %' OR course_title LIKE '%Honors%' THEN 'AP/Honors'
		WHEN course_title LIKE '%English%' THEN 'Regular'
		ELSE 'Elective'
	END AS course_type,
	teacher_name AS teacher,
	round(avg(grade_point_dec), 2) AS grade_avg,
	round(sum(grade LIKE '%A%')/count(grade), 2) AS a,
	round(sum(grade LIKE '%B%')/count(grade), 2) AS b,
	round(sum(grade LIKE '%C%')/count(grade), 2) AS c,
	round(sum(grade LIKE '%D%')/count(grade), 2) AS d,
	round(sum(grade LIKE '%F%')/count(grade), 2) AS f,
	round(avg(pass_or_fail)*100, 1) AS pass_perc,
	round(avg(c_or_higher)*100, 1) AS c_and_up_perc
FROM all_with_core 
LEFT JOIN teachers USING(teacher_id)
WHERE course_subject='English'
GROUP BY course_type, teacher WITH ROLLUP
ORDER BY course_type, teacher;
	

-- Table #2: Demographics by Teacher (with ROLLUP averages)

SELECT 
	teacher_name,
	count(student_id) AS num_of_students,
	avg(absence_perc) AS avg_absence, 
	sum(sped) AS iep_num,
	sum(sped)/count(course_title) AS iep_perc,
	sum(sec_504) AS s504_num,
	sum(sec_504)/count(course_title) AS s504_perc,
	sum(ell) AS ell_num,
	sum(ell)/count(course_title) AS ell_perc,
	sum(sped)+sum(sec_504)+sum(ell) AS support_needs,
	(sum(sped)+sum(sec_504)+sum(ell))/count(course_title) AS support_perc,
	sum(tag) AS tag_num,
	sum(tag)/count(course_title) AS tag_perc,
	sum(transfer) AS out_of_boundary_num,
	sum(transfer)/count(course_title) AS out_of_boundary_perc,
	sum(gender_male)/count(course_title) AS male_perc,
	sum(gender_female)/count(course_title) AS female_perc,
	sum(gender_nonbinary)/count(course_title) AS nb_perc
FROM all_with_core
LEFT JOIN teachers USING(teacher_id)
WHERE 
	course_subject='English'
GROUP BY teacher_name WITH ROLLUP
ORDER BY teacher_name;

-- Table #3: All Core Class info (with ROLLUP)

SELECT 
	course_title,
	round(avg(grade_level), 0) AS grade_level,
	CASE 
		WHEN course_title LIKE '%AP %' OR course_title LIKE '%Honors%' THEN 1
		ELSE 0
	END AS advanced,
	count(student_id) AS num_of_students,
	avg(grade_point_dec) AS average_grade,
	sum(grade LIKE '%A%')/count(grade) AS a,
	sum(grade LIKE '%B%')/count(grade) AS b,
	sum(grade LIKE '%C%')/count(grade) AS c,
	sum(grade LIKE '%D%')/count(grade) AS d,
	sum(grade LIKE '%F%')/count(grade) AS f,
	avg(pass_or_fail) AS pass_perc,
	avg(c_or_higher) AS c_and_up_perc,
	avg(absence_perc) AS avg_absence, 
	sum(sped) AS iep_num,
	sum(sped)/count(course_title) AS iep_perc,
	sum(sec_504) AS s504_num,
	sum(sec_504)/count(course_title) AS s504_perc,
	sum(ell) AS ell_num,
	sum(ell)/count(course_title) AS ell_perc,
	sum(sped)+SUM(sec_504)+sum(ell) AS support_needs,
	(sum(sped)+SUM(sec_504)+sum(ell))/count(course_title) AS support_perc,
	sum(tag) AS tag_num,
	sum(tag)/count(course_title) AS tag_perc,
	sum(transfer) AS out_of_boundary_num,
	sum(transfer)/count(course_title) AS out_of_boundary_perc,
	sum(gender_male)/count(course_title) AS male_perc,
	sum(gender_female)/count(course_title) AS female_perc,
	sum(gender_nonbinary)/count(course_title) AS nb_perc
FROM all_with_core
WHERE 
	course_subject='English'
	AND core_req=1
	AND course_title !='Adv Comm Skills'
GROUP BY course_title WITH ROLLUP
ORDER BY grade_level, average_grade DESC;


-- Table #4: All Core Class info by PLC (no ROLLUP)

SELECT 
	course_title,
	teacher_name,
	round(avg(grade_level), 0) AS grade_level,
	CASE 
		WHEN course_title LIKE '%AP %' OR course_title LIKE '%Honors%' THEN 1
		ELSE 0
	END AS advanced,
	count(student_id) AS num_of_students,
	avg(grade_point_dec) AS average_grade,
	sum(grade LIKE '%A%')/count(grade) AS a,
	sum(grade LIKE '%B%')/count(grade) AS b,
	sum(grade LIKE '%C%')/count(grade) AS c,
	sum(grade LIKE '%D%')/count(grade) AS d,
	sum(grade LIKE '%F%')/count(grade) AS f,
	avg(pass_or_fail) AS pass_perc,
	avg(c_or_higher) AS c_and_up_perc,
	avg(absence_perc) AS avg_absence, 
	sum(sped) AS iep_num,
	sum(sped)/count(course_title) AS iep_perc,
	sum(sec_504) AS s504_num,
	sum(sec_504)/count(course_title) AS s504_perc,
	sum(ell) AS ell_num,
	sum(ell)/count(course_title) AS ell_perc,
	sum(sped)+SUM(sec_504)+sum(ell) AS support_needs,
	(sum(sped)+SUM(sec_504)+sum(ell))/count(course_title) AS support_perc,
	sum(tag) AS tag_num,
	sum(tag)/count(course_title) AS tag_perc,
	sum(transfer) AS out_of_boundary_num,
	sum(transfer)/count(course_title) AS out_of_boundary_perc,
	sum(gender_male)/count(course_title) AS male_perc,
	sum(gender_female)/count(course_title) AS female_perc,
	sum(gender_nonbinary)/count(course_title) AS nb_perc
FROM all_with_core
LEFT JOIN teachers USING(teacher_id)
WHERE 
	course_subject='English'
	AND core_req=1
	AND course_title !='Adv Comm Skills'
GROUP BY teacher_name, course_title
ORDER BY grade_level, average_grade DESC;

-- Table #5: Grade Leve Info for Core Class (just grade averages)

SELECT 
	round(avg(grade_level), 0) AS grade_level,
	count(student_id) AS num_of_students,
	avg(grade_point_dec) AS average_grade,
	sum(grade LIKE '%A%')/count(grade) AS a,
	sum(grade LIKE '%B%')/count(grade) AS b,
	sum(grade LIKE '%C%')/count(grade) AS c,
	sum(grade LIKE '%D%')/count(grade) AS d,
	sum(grade LIKE '%F%')/count(grade) AS f,
	avg(pass_or_fail) AS pass_perc,
	avg(c_or_higher) AS c_and_up_perc,
	avg(absence_perc) AS avg_absence, 
	sum(sped) AS iep_num,
	sum(sped)/count(course_title) AS iep_perc,
	sum(sec_504) AS s504_num,
	sum(sec_504)/count(course_title) AS s504_perc,
	sum(ell) AS ell_num,
	sum(ell)/count(course_title) AS ell_perc,
	sum(sped)+SUM(sec_504)+sum(ell) AS support_needs,
	(sum(sped)+SUM(sec_504)+sum(ell))/count(course_title) AS support_perc,
	sum(tag) AS tag_num,
	sum(tag)/count(course_title) AS tag_perc,
	sum(transfer) AS out_of_boundary_num,
	sum(transfer)/count(course_title) AS out_of_boundary_perc,
	sum(gender_male)/count(course_title) AS male_perc,
	sum(gender_female)/count(course_title) AS female_perc,
	sum(gender_nonbinary)/count(course_title) AS nb_perc
FROM all_with_core
WHERE 
	course_subject='English'
	AND core_req=1
	AND course_title !='Adv Comm Skills'
GROUP BY grade_level
ORDER BY grade_level;

-- Table #6: All info by Teacher/Class

SELECT 
	course_title,
	teacher_name,
	round(avg(grade_level), 0) AS grade_level,
	CASE 
		WHEN 
			course_title LIKE '%English%' 
			AND course_title NOT LIKE '%AP %' 
			AND course_title NOT LIKE '%Honors%'
		THEN 1
		ELSE 0
	END AS core,
	CASE 
		WHEN course_title LIKE '%AP %' OR course_title LIKE '%Honors%' THEN 1
		ELSE 0
	END AS advanced,
	count(student_id) AS num_of_students,
	avg(grade_point_dec) AS average_grade,
	sum(grade LIKE '%A%')/count(grade) AS a,
	sum(grade LIKE '%B%')/count(grade) AS b,
	sum(grade LIKE '%C%')/count(grade) AS c,
	sum(grade LIKE '%D%')/count(grade) AS d,
	sum(grade LIKE '%F%')/count(grade) AS f,
	avg(pass_or_fail) AS pass_perc,
	avg(c_or_higher) AS c_and_up_perc,
	avg(absence_perc) AS avg_absence, 
	sum(sped) AS iep_num,
	sum(sped)/count(course_title) AS iep_perc,
	sum(sec_504) AS s504_num,
	sum(sec_504)/count(course_title) AS s504_perc,
	sum(ell) AS ell_num,
	sum(ell)/count(course_title) AS ell_perc,
	sum(sped)+SUM(sec_504)+sum(ell) AS support_needs,
	(sum(sped)+SUM(sec_504)+sum(ell))/count(course_title) AS support_perc,
	sum(tag) AS tag_num,
	sum(tag)/count(course_title) AS tag_perc,
	sum(transfer) AS out_of_boundary_num,
	sum(transfer)/count(course_title) AS out_of_boundary_perc,
	sum(gender_male)/count(course_title) AS male_perc,
	sum(gender_female)/count(course_title) AS female_perc,
	sum(gender_nonbinary)/count(course_title) AS nb_perc
FROM all_with_core
LEFT JOIN teachers USING(teacher_id)
WHERE 
	course_subject='English'
GROUP BY teacher_name, course_title
ORDER BY average_grade DESC;

-- Table #7: All info by Teacher and Period

SELECT 
	course_title,
	teacher_name,
	teacher_id,
	period,
	avg(grade_level) AS grade_level,
	CASE 
		WHEN 
			course_title LIKE '%English%' THEN 1
		ELSE 0
	END AS core,
	CASE 
		WHEN course_title LIKE '%AP %' OR course_title LIKE '%Honors%' THEN 1
		ELSE 0
	END AS advanced,
	count(student_id) AS num_of_students,
	avg(absence_perc) AS avg_absence, 
	avg(tardy_perc) AS avg_tardy, 
	avg(grade_point_dec) AS average_grade,
	sum(grade LIKE '%A%')/count(grade) AS a,
	sum(grade LIKE '%B%')/count(grade) AS b,
	sum(grade LIKE '%C%')/count(grade) AS c,
	sum(grade LIKE '%D%')/count(grade) AS d,
	sum(grade LIKE '%F%')/count(grade) AS f,
	avg(pass_or_fail) AS pass_perc,
	avg(c_or_higher) AS c_and_up_perc,
	sum(sped) AS iep_num,
	sum(sped)/count(course_title) AS iep_perc,
	sum(sec_504) AS s504_num,
	sum(sec_504)/count(course_title) AS s504_perc,
	sum(ell) AS ell_num,
	sum(ell)/count(course_title) AS ell_perc,
	sum(sped)+SUM(sec_504)+sum(ell) AS support_needs,
	(sum(sped)+SUM(sec_504)+sum(ell))/count(course_title) AS support_perc,
	sum(tag) AS tag_num,
	sum(tag)/count(course_title) AS tag_perc,
	sum(transfer) AS out_of_boundary_num,
	sum(transfer)/count(course_title) AS out_of_boundary_perc,
	sum(gender_male)/count(course_title) AS male_perc,
	sum(gender_female)/count(course_title) AS female_perc,
	sum(gender_nonbinary)/count(course_title) AS nb_perc
FROM all_with_core
LEFT JOIN teachers USING(teacher_id)
WHERE 
	course_subject='English'
GROUP BY teacher_name, course_title, period, teacher_id
ORDER BY average_grade DESC;



