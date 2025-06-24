
# IIIT-Hyderabad
## Overview
The IIIT_HYD_db is a comprehensive relational database designed to manage and analyze academic data for a university environment. It encapsulates the core entities and their relationships, enabling efficient tracking of students, courses, academic performance, and resource usage.
## Objectives 
To analyze and enhance student academic performance and engagement through comprehensive tracking of coursework, activities, and resource utilization.
## Creating Database
``` sql
CREATE DATABASE IIIT_HYD_db;
USE IIIT_HYD_db;
```
## Creating Tables 
### Table:Students
``` sql
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
```
### Table:Courses
``` sql
CREATE TABLE Courses(
    course_id   INT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    department  VARCHAR(100) NOT NULL,
    credits     INT NOT NULL,
    instructor  VARCHAR(50) NOT NULL
);

SELECT * FROM Courses;
```
### Table:Enrollments
``` sql
CREATE TABLE Enrollments(
    enrollment_id   INT PRIMARY KEY,
    student_id      INT,
    course_id       INT,
    enrollment_date DATE,
    status          VARCHAR(50),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);
```
SELECT * FROM Enrollments;
```
### Table:Learning_activities
``` sql
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
```
### Table:Student_engagements
``` sql
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
```
### Table:Library_usage
``` sql
CREATE TABLE Library_usage(
    usage_id        INT PRIMARY KEY,
    student_id      INT,
    check_out_date  DATE,
    resource_type   VARCHAR(50),
    resource_title  TEXT NOT NULL,
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

SELECT * FROM Library_usage;
```
## Key Queries

#### 1. List all students with their department and academic year, sorted by enrollment date.
``` sql
SELECT * FROM Students
ORDER BY enrollment_date;
```
#### 2. Show all courses offered by the Computer Science department.
``` sql 
 SELECT * FROM Courses
 WHERE department='Computer Science';
```
#### 3. Display all active enrollments with student and course information.
``` sql
SELECT e.*, CONCAT(s.first_name,' ' ,s.last_name) AS Student_name,s.email,c.course_name,c.department,c.credits,c.instructor
FROM Enrollments e 
JOIN Students s 
ON e.student_id=s.student_id
JOIN Courses c 
ON e.course_id=c.course_id
WHERE e.status='Active';
```
#### 4. Find students who scored above 80 in any assignment.
``` sql
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
```
#### 5. List students who haven't submitted any work (status = 'Not Started' or 'Overdue').
``` sql
SELECT s.student_id,CONCAT(s.first_name,' ' ,s.last_name) AS Student_name,la.activity_type,se.status
FROM Students s 
JOIN Student_engagements se 
ON s.student_id=se.student_id
JOIN Learning_activities la
ON se.activity_id=la.activity_id
WHERE status IN ('Not Started','Overdue');
```
#### 6. Show the average participation score per course 
``` sql
SELECT 
        c.course_id,c.course_name,
    ROUND(AVG(CASE WHEN se.participation_score IS NOT NULL THEN se.participation_score END),2) AS Average_Score
FROM Courses c
LEFT JOIN Learning_activities la 
ON c.course_id=la.course_id
LEFT JOIN Student_engagements se 
ON se.activity_id=la.activity_id
GROUP BY c.course_id,c.course_name;
```
#### 7. Identify courses with no student enrollments.
``` sql
SELECT c.* , COUNT(e.enrollment_id) AS Total_enrollments
FROM Courses c 
LEFT JOIN Enrollments e 
ON e.course_id=c.course_id
GROUP BY c.course_id
HAVING Total_enrollments=0;
```
#### 8. Find the course with the most learning activities.
``` sql
SELECT c.* , COUNT(la.activity_id) AS Total_activities
FROM Courses c 
LEFT JOIN Learning_activities la 
ON la.course_id=c.course_id
GROUP BY c.course_id
ORDER BY Total_activities DESC 
LIMIT 1;
```
#### 9. Calculate the completion rate (submitted vs. total activities) for each course.
``` sql
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
```
#### 10. Show the number of students per department.
``` sql
SELECT department,COUNT(*) AS Total_Students FROM Students
GROUP BY department;
```
#### 11. List departments where all enrolled students have at least one submitted assignment.
``` sql
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
```
#### 12. Find the department with the highest average participation score.
``` sql
SELECT s.department,ROUND(AVG(se.participation_score),2) AS Average_Participation_Score
FROM Students s 
JOIN Student_engagements se 
ON s.student_id=se.student_id
GROUP BY s.department 
ORDER BY Average_Participation_Score DESC
LIMIT 1;
```
#### 13. Display all activities due in the current week.
``` sql
SELECT * FROM Learning_activities 
WHERE due_date BETWEEN CURRENT_DATE() AND DATE_ADD(CURRENT_DATE(), INTERVAL 7 DAY);
```
#### 14. Show library checkouts by month.
``` sql
SELECT MONTH(check_out_date) AS Month,MONTHNAME(check_out_date) AS Month_name,COUNT(*) AS Total_checkouts FROM Library_usage
GROUP BY Month,Month_name
ORDER BY Month;
```
#### 15. Find students who enrolled but haven't participated in any activities for 30+ days.
``` sql
SELECT s.* 
FROM Students s 
WHERE NOT EXISTS (
        SELECT 1
    FROM Student_engagements se 
        WHERE s.student_id=se.student_id
                AND  se.submission_date IS NOT NULL
                AND TIMESTAMPDIFF(DAY,s.enrollment_date,se.submission_date)<=30
);
```
#### 16. Identify students enrolled in multiple courses but with below-average participation 
``` sql
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
```
#### 17. Calculate the correlation between library usage and academic performance.
``` sql
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
```
#### 18. Show the distribution of activity types (assignments/quizzes/labs) across departments.
``` sql
SELECT c.department, la.activity_type, COUNT(la.activity_id) AS Total_activities
FROM Courses c
LEFT JOIN Learning_activities la 
ON c.course_id=la.course_id
GROUP BY c.department, la.activity_type;
```
#### 19. Find records where submission date is before enrollment date (data inconsistency).
``` sql
SELECT s.* ,s.enrollment_date,se.submission_date
FROM Students s 
LEFT JOIN Student_engagements se 
ON s.student_id=se.student_id
WHERE s.enrollment_date>se.submission_date;
```
#### 20. List students with missing email addresses.
``` sql
SELECT * FROM Students 
WHERE email IS NULL;
```
Conclusion
The IIIT_HYD_db database provides a well-structured foundation for academic administration and analytics. By integrating various dimensions of academic life—from enrollment to performance and resource usage—it enables institutions to make informed decisions, improve student engagement, and ensure academic quality.