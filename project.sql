CREATE DATABASE EMSDB;

USE EMSDB;

-- Table 1: Job Department

CREATE TABLE JobDepartment (
    Job_ID INT PRIMARY KEY,
    jobdept VARCHAR(50),
    name VARCHAR(100),
    description TEXT,
    salaryrange VARCHAR(50)
);
-- Table 2: Salary/Bonus
CREATE TABLE SalaryBonus (
    salary_ID INT PRIMARY KEY,
    Job_ID INT,
    amount DECIMAL(10,2),
    annual DECIMAL(10,2),
    bonus DECIMAL(10,2),
    CONSTRAINT fk_salary_job FOREIGN KEY (job_ID) REFERENCES JobDepartment(Job_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);
-- Table 3: Employee
CREATE TABLE Employee (
    emp_ID INT PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    gender VARCHAR(10),
    age INT,
    contact_add VARCHAR(100),
    emp_email VARCHAR(100) UNIQUE,
    emp_pass VARCHAR(50),
    Job_ID INT,
    CONSTRAINT fk_employee_job FOREIGN KEY (Job_ID)
        REFERENCES JobDepartment(Job_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Table 4: Qualification
CREATE TABLE Qualification (
    QualID INT PRIMARY KEY,
    Emp_ID INT,
    Position VARCHAR(50),
    Requirements VARCHAR(255),
    Date_In DATE,
    CONSTRAINT fk_qualification_emp FOREIGN KEY (Emp_ID)
        REFERENCES Employee(emp_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table 5: Leaves
CREATE TABLE Leaves (
    leave_ID INT PRIMARY KEY,
    emp_ID INT,
    date DATE,
    reason TEXT,
    CONSTRAINT fk_leave_emp FOREIGN KEY (emp_ID) REFERENCES Employee(emp_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table 6: Payroll
CREATE TABLE Payroll (
    payroll_ID INT PRIMARY KEY,
    emp_ID INT,
    job_ID INT,
    salary_ID INT,
    leave_ID INT,
    date DATE,
    report TEXT,
    total_amount DECIMAL(10,2),
    CONSTRAINT fk_payroll_emp FOREIGN KEY (emp_ID) REFERENCES Employee(emp_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_job FOREIGN KEY (job_ID) REFERENCES JobDepartment(job_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_salary FOREIGN KEY (salary_ID) REFERENCES SalaryBonus(salary_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_leave FOREIGN KEY (leave_ID) REFERENCES Leaves(leave_ID)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- EMPLOYEE INSIGHTS
-- 1 How many unique employees are currently in the system?
SELECT COUNT(DISTINCT EMP_ID) AS TOTAL_EMPLOYEE
FROM EMPLOYEE;
-- 2  What is the average number of leave days taken by its employees per department?
SELECT jd.jobdept, COUNT(e.emp_ID) AS employee_count
FROM Employee e
JOIN JobDepartment jd ON e.Job_ID = jd.Job_ID
GROUP BY jd.jobdept
ORDER BY employee_count DESC;
-- 3 What is the average salary per department?
SELECT jd.jobdept, AVG(sb.amount) AS avg_salary
FROM Employee e
JOIN JobDepartment jd ON e.Job_ID = jd.Job_ID
JOIN SalaryBonus sb ON jd.Job_ID = sb.Job_ID
GROUP BY jd.jobdept;
-- 4 Who are the top 5 highest-paid employees?
SELECT e.firstname, e.lastname, sb.amount AS salary
FROM Employee e
JOIN SalaryBonus sb ON e.Job_ID = sb.Job_ID
ORDER BY sb.amount DESC
LIMIT 5;
-- 5 What is the total salary expenditure across the company?
SELECT SUM(sb.amount) AS total_salary_expenditure
FROM SalaryBonus sb;
-- JOB ROLE & DEPARTMENT
-- 6 Job roles in each department
SELECT jobdept, COUNT(name) 
FROM JobDepartment
GROUP BY jobdept;
-- 7 Average salary per department
SELECT jobdept, AVG(amount) 
FROM JobDepartment jd, SalaryBonus sb
WHERE jd.Job_ID = sb.Job_ID
GROUP BY jobdept;
-- 8 Job role with highest salary
SELECT name, amount 
FROM JobDepartment jd, SalaryBonus sb
WHERE jd.Job_ID = sb.Job_ID
ORDER BY amount DESC
LIMIT 1;
-- 9 Department with highest salary allocation
SELECT jobdept, SUM(amount) 
FROM JobDepartment jd, SalaryBonus sb
WHERE jd.Job_ID = sb.Job_ID
GROUP BY jobdept
ORDER BY SUM(amount) DESC;
-- QUALIFICATIONS
-- 10 Employees with qualifications
SELECT COUNT(DISTINCT Emp_ID) 
FROM Qualification;
-- 11 Position with most qualifications
SELECT Position, COUNT(*) 
FROM Qualification
GROUP BY Position
ORDER BY COUNT(*) DESC;
-- 12 Employee with most qualifications
SELECT Emp_ID, COUNT(*) 
FROM Qualification
GROUP BY Emp_ID
ORDER BY COUNT(*) DESC
LIMIT 1;
-- LEAVES
-- 13 Year with most employees on leave
SELECT YEAR(date), COUNT(DISTINCT Emp_ID) 
FROM Leaves
GROUP BY YEAR(date)
ORDER BY COUNT(*) DESC;
-- 14 Average leave per department
SELECT jobdept, AVG(leave_count)
FROM (
   SELECT Emp_ID, COUNT(*) AS leave_count
   FROM Leaves
   GROUP BY Emp_ID
) t, Employee e, JobDepartment jd
WHERE t.Emp_ID = e.emp_ID 
AND e.Job_ID = jd.Job_ID
GROUP BY jobdept;
-- 15 Employee with most leaves
SELECT Emp_ID, COUNT(*) 
FROM Leaves
GROUP BY Emp_ID
ORDER BY COUNT(*) DESC
LIMIT 1;
-- 16 Total leaves company-wide
SELECT COUNT(*) 
FROM Leaves;
-- PAYROLL
-- 17  Monthly payroll
SELECT YEAR(date), MONTH(date), SUM(total_amount) 
FROM Payroll
GROUP BY YEAR(date), MONTH(date);
-- 18  Average bonus per department
SELECT jobdept, AVG(bonus) 
FROM JobDepartment jd, SalaryBonus sb
WHERE jd.Job_ID = sb.Job_ID
GROUP BY jobdept;
-- 19 Department with highest total bonus
SELECT jobdept, SUM(bonus) 
FROM JobDepartment jd, SalaryBonus sb
WHERE jd.Job_ID = sb.Job_ID
GROUP BY jobdept
ORDER BY SUM(bonus) DESC
LIMIT 1;
-- 20 Average net pay
SELECT AVG(total_amount) 
FROM Payroll;
-- GROWTH
-- 21 Year with most 
SELECT 
    YEAR(Date_In), COUNT(*)
FROM
    Qualification
GROUP BY YEAR(Date_In)
ORDER BY COUNT(*) DESC;
-- Which year had the highest number of employee promotions?
SELECT YEAR(Date_In) AS promotion_year, COUNT(*) AS promotion_count
FROM Qualification
GROUP BY YEAR(Date_In)
ORDER BY promotion_count DESC
LIMIT 1;
DESC EMPLOYEE ;
DESC JOBDEPARTMENT ;
DESC LEAVES ;
DESC PAYROLL ;
DESC QUALIFICATION ;
DESC SALARYBONUS ;
