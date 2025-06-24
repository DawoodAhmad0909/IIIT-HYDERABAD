CREATE DATABASE IIIT_HYD_db;
USE IIIT_HYD_db;

CREATE TABLE Students(
    student_id       INT PRIMARY KEY,
    first_name       VARCHAR(25) NOT NULL,
    last_name        VARCHAR(25) NOT NULL,
    email            TEXT,
    enrollment_date  DATE NOT NULL,
    department       VARCHAR(100) NOT NULL,
    academic_year    INT
);

SELECT * FROM Students;
 
INSERT INTO Students VALUES
	(101, 'Aarav', 'Sharma', 'aarav.sharma@example.edu', '2023-06-01', 'Computer Science', 1),
	(102, 'Diya', 'Patel', 'diya.patel@example.edu', '2023-06-01', 'Electrical Engineering', 1),
	(103, 'Rohan', 'Kumar', 'rohan.kumar@example.edu', '2022-06-15', 'Mechanical Engineering', 2),
	(104, 'Ananya', 'Singh', 'ananya.singh@example.edu', '2022-06-15', 'Biotechnology', 2),
	(105, 'Ishaan', 'Gupta', 'ishaan.gupta@example.edu', '2021-06-10', 'Computer Science', 3),
	(106, 'Priya', 'Joshi', 'priya.joshi@example.edu', '2023-06-01', 'Civil Engineering', 1),
	(107, 'Vivaan', 'Malhotra', 'vivaan.malhotra@example.edu', '2021-06-10', 'Electrical Engineering', 3);

CREATE TABLE Courses(
    course_id   INT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    department  VARCHAR(100) NOT NULL,
    credits     INT NOT NULL,
    instructor  VARCHAR(50) NOT NULL
);

SELECT * FROM Courses;

INSERT INTO Courses VALUES
	(201, 'Data Structures', 'Computer Science', 4, 'Dr. S. Desai'),
	(202, 'Circuit Theory', 'Electrical Engineering', 3, 'Prof. R. Khan'),
	(203, 'Thermodynamics', 'Mechanical Engineering', 4, 'Dr. A. Mishra'),
	(204, 'Cell Biology', 'Biotechnology', 3, 'Dr. P. Choudhary'),
	(205, 'Building Materials', 'Civil Engineering', 3, 'Prof. N. Reddy');

CREATE TABLE Enrollments(
    enrollment_id   INT PRIMARY KEY,
    student_id      INT,
    course_id       INT,
    enrollment_date DATE,
    status          VARCHAR(50),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

SELECT * FROM Enrollments;

INSERT INTO Enrollments VALUES
	(301, 101, 201, '2023-07-10', 'Active'),
	(302, 102, 202, '2023-07-10', 'Active'),
	(303, 103, 203, '2023-07-11', 'Active'),
	(304, 104, 204, '2023-07-11', 'Active'),
	(305, 105, 201, '2023-07-12', 'Active'),
	(306, 106, 205, '2023-07-12', 'Active'),
	(307, 107, 202, '2023-07-13', 'Active'),
	(308, 101, 202, '2023-07-14', 'Active'),
	(309, 103, 201, '2023-07-14', 'Dropped');

CREATE TABLE Learning_activities(
    activity_id    INT PRIMARY KEY,
    course_id      INT,
    activity_type  VARCHAR(50) NOT NULL,
    title          TEXT,
    due_date       DATE,
    max_score      INT,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

SELECT * FROM Learning_activities;

INSERT INTO Learning_activities VALUES
	(401, 201, 'Assignment', 'Linked List Implementation', '2023-08-15', 100),
	(402, 201, 'Quiz', 'Time Complexity', '2023-08-01', 20),
	(403, 202, 'Lab', "Ohm's Law Verification", '2023-08-10', 50),
	(404, 203, 'Project', 'Heat Engine Design', '2023-08-20', 200),
	(405, 204, 'Presentation', 'CRISPR Technology', '2023-08-05', 30);

CREATE TABLE Student_engagements(
    engagement_id        INT PRIMARY KEY,
    student_id           INT,
    activity_id          INT,
    participation_score  INT,
    submission_date      DATE,
    status               VARCHAR(50),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (activity_id) REFERENCES Learning_activities(activity_id)
);

SELECT * FROM Student_engagements;

INSERT INTO Student_engagements VALUES
	(501, 101, 401, 85, '2023-08-14', 'Submitted'),
	(502, 101, 402, 18, '2023-07-30', 'Submitted'),
	(503, 102, 403, 45, '2023-08-09', 'Submitted'),
	(504, 103, 404, NULL, NULL, 'Not Started'),
	(505, 104, 405, 28, '2023-08-04', 'Submitted'),
	(506, 105, 401, 90, '2023-08-14', 'Submitted'),
	(507, 106, 405, NULL, NULL, 'Overdue'),
	(508, 107, 403, 40, '2023-08-08', 'Submitted');

CREATE TABLE Library_usage(
    usage_id        INT PRIMARY KEY,
    student_id      INT,
    check_out_date  DATE,
    resource_type   VARCHAR(50),
    resource_title  TEXT NOT NULL,
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

SELECT * FROM Library_usage;

INSERT INTO Library_usage VALUES
	(601, 101, '2023-07-15', 'Book', 'Introduction to Algorithms'),
	(602, 101, '2023-08-01', 'Journal', 'IEEE Transactions on Circuits'),
	(603, 103, '2023-07-20', 'E-Book', 'Thermal Engineering'),
	(604, 104, '2023-07-25', 'Thesis', 'Gene Editing Techniques'),
	(605, 107, '2023-08-05', 'Book', 'Power Systems Analysis');

SELECT * FROM Students
ORDER BY enrollment_date;
 SELECT * FROM Courses
 WHERE department='Computer Science';

SELECT e.*, CONCAT(s.first_name,' ' ,s.last_name) AS Student_name,s.email,c.course_name,c.department,c.credits,c.instructor
FROM Enrollments e 
JOIN Students s 
ON e.student_id=s.student_id
JOIN Courses c 
ON e.course_id=c.course_id
WHERE e.status='Active';

SELECT 
	s.student_id,
    CONCAT(s.first_name,' ' ,s.last_name) AS Student_name,
    la.activity_type,
    se.participation_score
FROM Students s 
JOIN Student_engagements se 
ON s.student_id=se.student_id
JOIN Learning_activities la
ON se.activity_id=la.activity_id
WHERE la.activity_type='Assignment' AND se.participation_score>80;

SELECT s.student_id,CONCAT(s.first_name,' ' ,s.last_name) AS Student_name,la.activity_type,se.status
FROM Students s 
JOIN Student_engagements se 
ON s.student_id=se.student_id
JOIN Learning_activities la
ON se.activity_id=la.activity_id
WHERE status IN ('Not Started','Overdue');

SELECT 
	c.course_id,c.course_name,
    ROUND(AVG(CASE WHEN se.participation_score IS NOT NULL THEN se.participation_score END),2) AS Average_Score
FROM Courses c
LEFT JOIN Learning_activities la 
ON c.course_id=la.course_id
LEFT JOIN Student_engagements se 
ON se.activity_id=la.activity_id
GROUP BY c.course_id,c.course_name;

SELECT c.* , COUNT(e.enrollment_id) AS Total_enrollments
FROM Courses c 
LEFT JOIN Enrollments e 
ON e.course_id=c.course_id
GROUP BY c.course_id
HAVING Total_enrollments=0;

SELECT c.* , COUNT(la.activity_id) AS Total_activities
FROM Courses c 
LEFT JOIN Learning_activities la 
ON la.course_id=c.course_id
GROUP BY c.course_id
ORDER BY Total_activities DESC 
LIMIT 1;

SELECT
	c.course_id,c.course_name,
    ROUND(SUM(CASE WHEN se.status='Submitted' THEN 1 ELSE 0 END)/
    COUNT(se.engagement_id),2) AS Completion_rate
FROM Courses c
LEFT JOIN Learning_activities la 
ON c.course_id=la.course_id
LEFT JOIN Student_engagements se 
ON se.activity_id=la.activity_id
GROUP BY c.course_id,c.course_name;

SELECT department,COUNT(*) AS Total_Students FROM Students
GROUP BY department;

SELECT DISTINCT s.department
FROM Students s 
WHERE s.department IN(
	SELECT s1.department
    FROM Students s1
    JOIN Student_engagements se
    ON s1.student_id=se.student_id
    JOIN Learning_activities la
	ON se.activity_id=la.activity_id
    WHERE la.activity_type='Assignment'
        AND se.status='Submitted' 
	GROUP BY  s1.department
    HAVING COUNT(DISTINCT  s1.student_id)=(SELECT COUNT(*) FROM Students s2 WHERE s2.department=s1.department)
);

SELECT s.department,ROUND(AVG(se.participation_score),2) AS Average_Participation_Score
FROM Students s 
JOIN Student_engagements se 
ON s.student_id=se.student_id
GROUP BY s.department 
ORDER BY Average_Participation_Score DESC
LIMIT 1;

SELECT * FROM Learning_activities 
WHERE due_date BETWEEN CURRENT_DATE() AND DATE_ADD(CURRENT_DATE(), INTERVAL 7 DAY);

SELECT MONTH(check_out_date) AS Month,MONTHNAME(check_out_date) AS Month_name,COUNT(*) AS Total_checkouts FROM Library_usage
GROUP BY Month,Month_name
ORDER BY Month;

SELECT s.* 
FROM Students s 
WHERE NOT EXISTS (
	SELECT 1
    FROM Student_engagements se 
	WHERE s.student_id=se.student_id
		AND  se.submission_date IS NOT NULL
		AND TIMESTAMPDIFF(DAY,s.enrollment_date,se.submission_date)<=30
);

SELECT 
	s.* ,
    COUNT( DISTINCT e.course_id) AS Total_Courses_Enrolled,
    COUNT(se.engagement_id) AS Total_Participations,
	ROUND(AVG(se.participation_score),2) AS Average_Participation_Score,
    (SELECT ROUND(AVG(participation_score),2) FROM Student_engagements) AS Overall_Average_Score
FROM Students s 
LEFT JOIN Enrollments e 
ON  s.student_id=e.student_id
JOIN Student_engagements se 
ON s.student_id=se.student_id
GROUP BY s.student_id
HAVING Total_Courses_Enrolled>=2
	AND (Average_Participation_Score<Overall_Average_Score
		OR Average_Participation_Score IS NULL);

SELECT 
	s.student_id,
    CONCAT(s.first_name,' ' ,s.last_name) AS Student_name,
    COUNT(lu.usage_id) AS Total_usage,AVG(se.participation_score),
    ROUND(AVG(se.participation_score),2) AS Average_Participation_Score,
    CASE 
		WHEN COUNT(lu.usage_id)=0 THEN 'No library usage'
		WHEN COUNT(lu.usage_id)=3 THEN 'Moderate library usage'
        WHEN COUNT(lu.usage_id)=5 THEN 'Good library usage'
        WHEN AVG(se.participation_score)>70 THEN 'High performance'
        WHEN AVG(se.participation_score) IN (45,70) THEN 'Medium performance'
		WHEN AVG(se.participation_score)<45 THEN 'Bad performance'
	END AS performance_category
FROM Students s 
LEFT JOIN Library_usage lu 
ON s.student_id=lu.student_id
LEFT JOIN Student_engagements se 
ON s.student_id=se.student_id
GROUP BY s.student_id,CONCAT(s.first_name,' ' ,s.last_name);

SELECT c.department, la.activity_type, COUNT(la.activity_id) AS Total_activities
FROM Courses c
LEFT JOIN Learning_activities la 
ON c.course_id=la.course_id
GROUP BY c.department, la.activity_type;

SELECT s.* ,s.enrollment_date,se.submission_date
FROM Students s 
LEFT JOIN Student_engagements se 
ON s.student_id=se.student_id
WHERE s.enrollment_date>se.submission_date;

SELECT * FROM Students 
WHERE email IS NULL;