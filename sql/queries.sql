-- IBM HR Attrition – Core Insights (SQLite)
-- Table: employees

-- 1) Overall attrition rate
WITH base AS (
  SELECT COUNT(*) AS n_all,
         SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS n_yes
  FROM employees
)
SELECT n_all, n_yes, ROUND(100.0*n_yes/n_all,2) AS attrition_pct
FROM base;

-- 2) Attrition by Department
SELECT Department,
       COUNT(*) AS n_emp,
       SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS n_left,
       ROUND(100.0*SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS attrition_pct
FROM employees
GROUP BY Department
ORDER BY attrition_pct DESC, n_emp DESC;

-- 3) Attrition by JobRole (min N)
SELECT JobRole,
       COUNT(*) AS n_emp,
       SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS n_left,
       ROUND(100.0*SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS attrition_pct
FROM employees
GROUP BY JobRole
HAVING COUNT(*) >= 20
ORDER BY attrition_pct DESC, n_emp DESC;

-- 4) Attrition by BusinessTravel
SELECT BusinessTravel,
       COUNT(*) AS n_emp,
       SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS n_left,
       ROUND(100.0*SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS attrition_pct
FROM employees
GROUP BY BusinessTravel
ORDER BY attrition_pct DESC, n_emp DESC;

-- 5) OverTime × Department (heatmap-ready; min N)
SELECT Department,
       OverTime,
       COUNT(*) AS n_emp,
       SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS n_left,
       ROUND(100.0*SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS attrition_pct
FROM employees
GROUP BY Department, OverTime
HAVING COUNT(*) >= 10
ORDER BY Department, OverTime;

-- 6) Tenure curve – YearsAtCompany (min N)
SELECT YearsAtCompany,
       COUNT(*) AS n_emp,
       SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS n_left,
       ROUND(100.0*SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS attrition_pct
FROM employees
GROUP BY YearsAtCompany
HAVING COUNT(*) >= 10
ORDER BY YearsAtCompany;
