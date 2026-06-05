CREATE DATABASE IF NOT EXISTS hr_analytics;
USE hr_analytics;
CREATE TABLE employees (
    EmployeeNumber INT PRIMARY KEY,
    Age INT,
    Attrition VARCHAR(10),
    BusinessTravel VARCHAR(50),
    DailyRate INT,
    Department VARCHAR(50),
    DistanceFromHome INT,
    Education INT,
    EducationField VARCHAR(50),
    EmployeeCount INT,
    EnvironmentSatisfaction INT,
    Gender VARCHAR(20),
    HourlyRate INT,
    JobInvolvement INT,
    JobLevel INT,
    JobRole VARCHAR(100),
    JobSatisfaction INT,
    MaritalStatus VARCHAR(20),
    MonthlyIncome INT,
    MonthlyRate INT,
    NumCompaniesWorked INT,
    Over18 VARCHAR(5),
    OverTime VARCHAR(10),
    PercentSalaryHike INT,
    PerformanceRating INT,
    RelationshipSatisfaction INT,
    StandardHours INT,
    StockOptionLevel INT,
    TotalWorkingYears INT,
    TrainingTimesLastYear INT,
    WorkLifeBalance INT,
    YearsAtCompany INT,
    YearsInCurrentRole INT,
    YearsSinceLastPromotion INT,
    YearsWithCurrManager INT
);
-- Check row 
SELECT COUNT(*) AS total_records FROM employees;
-- Null Value Check
SELECT
SUM(CASE WHEN EmployeeNumber IS NULL THEN 1 ELSE 0 END) AS EmployeeNumber_Nulls,
SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Age_Nulls,
SUM(CASE WHEN Attrition IS NULL THEN 1 ELSE 0 END) AS Attrition_Nulls,
SUM(CASE WHEN Department IS NULL THEN 1 ELSE 0 END) AS Department_Nulls,
SUM(CASE WHEN JobRole IS NULL THEN 1 ELSE 0 END) AS JobRole_Nulls,
SUM(CASE WHEN MonthlyIncome IS NULL THEN 1 ELSE 0 END) AS MonthlyIncome_Nulls
FROM employees;
-- Duplicate Employee check 
 SELECT EmployeeNumber,
       COUNT(*) AS duplicate_count
FROM employees
GROUP BY EmployeeNumber
HAVING COUNT(*) > 1;

-- Data Profiling
-- Unique Departmenst
SELECT DISTINCT Department FROM employees;
-- Unique Job Roles
 SELECT DISTINCT JobRole FROM employees;
 -- Attrition Distributioon
 SELECT Attrition,
       COUNT(*) AS employee_count FROM employees
GROUP BY Attrition;
-- Gender Distribution
SELECT Gender,
       COUNT(*) AS employee_count FROM employees
GROUP BY Gender;
-- Salary Overview
SELECT
MIN(MonthlyIncome) AS min_salary,
MAX(MonthlyIncome) AS max_salary,
ROUND(AVG(MonthlyIncome),2) AS avg_salary
FROM employees;

-- Business Insights Queries
-- Attrition Rate
SELECT
ROUND(
SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
2
) AS attrition_rate_percent
FROM employees;
-- Attrition by Department
SELECT
Department,
COUNT(*) AS total_employees,
SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS attrition_count
FROM employees
GROUP BY Department
ORDER BY attrition_count DESC;
-- Attrition by Job Role
SELECT
JobRole,
COUNT(*) AS total_employees,
SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS attrition_count
FROM employees
GROUP BY JobRole
ORDER BY attrition_count DESC;
-- Overtime Vs Attrition
SELECT
OverTime,
COUNT(*) AS total_employees,
SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS attrition_count
FROM employees
GROUP BY OverTime;
-- Avg Salary by Department
SELECT
Department,
ROUND(AVG(MonthlyIncome),2) AS avg_salary
FROM employees
GROUP BY Department
ORDER BY avg_salary DESC;

-- Age Group Analysis
-- Attirion by Age Group
SELECT
CASE
    WHEN Age < 30 THEN 'Under 30'
    WHEN Age BETWEEN 30 AND 40 THEN '30-40'
    WHEN Age BETWEEN 41 AND 50 THEN '41-50'
    ELSE '50+'
END AS Age_Group,
COUNT(*) AS Total_Employees,
SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS Attrition_Count
FROM employees
GROUP BY Age_Group;
-- Attrion by Gender
SELECT
Gender,
COUNT(*) AS Total_Employees,
SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS Attrition_Count
FROM employees
GROUP BY Gender;
-- Attrition by Marital Status
SELECT
MaritalStatus,
COUNT(*) AS Total_Employees,
SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS Attrition_Count
FROM employees
GROUP BY MaritalStatus;
-- Avg Years at Company by Attrition
SELECT
Attrition,
ROUND(AVG(YearsAtCompany),2) AS Avg_Years_At_Company
FROM employees
GROUP BY Attrition;
-- Job Satisfaction vs Attrition
SELECT
JobSatisfaction,
COUNT(*) AS Total_Employees,
SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS Attrition_Count
FROM employees
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;

-- Employee Retention Analysis

-- Deptt ranking by attrition
SELECT
Department,
SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS Attrition_Count,
RANK() OVER(
ORDER BY SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) DESC
) AS Dept_Rank
FROM employees
GROUP BY Department;

-- Top 10 Highest Paod Employee
SELECT
EmployeeNumber,
JobRole,
MonthlyIncome
FROM employees
ORDER BY MonthlyIncome DESC
LIMIT 10;

-- Avg Salary by Job Role
SELECT
JobRole,
ROUND(AVG(MonthlyIncome),2) AS Avg_Salary
FROM employees
GROUP BY JobRole
ORDER BY Avg_Salary DESC;
