--1. *** View all records ****

SELECT * FROM RAW_EMP_DATA

-- *** Total records ***

 SELECT COUNT(*) AS TOTAL_RECORDS FROM RAW_EMP_DATA

 --2.-*** Check table structure ****
 
SELECT COLUMN_NAME , DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'raw_emp_data' 

--3. *** Find NULL values in every column. ***

SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(EMPLOYEE_ID) AS nulls_in_EMPLOYEE_ID,
    COUNT(*) - COUNT(FIRST_NAME) AS nulls_in_FIRST_NAME,
    COUNT(*) - COUNT(LAST_NAME) AS nulls_in_LAST_NAME,
    COUNT(*) - COUNT(GENDER) AS nulls_in_GENDER,
    COUNT(*) - COUNT(AGE) AS nulls_in_AGE,
    COUNT(*) - COUNT(DEPARTMENT) AS nulls_in_DEPARTMENT,
    COUNT(*) - COUNT(SALARY) AS nulls_in_SALARY,
    COUNT(*) - COUNT(CITY) AS nulls_in_CITY,
    COUNT(*) - COUNT(EMAIL) AS nulls_in_EMAIL,
    COUNT(*) - COUNT(HIRE_DATE) AS nulls_in_HIRE_DATE,
    COUNT(*) - COUNT(STATUS) AS nulls_in_STATUS
FROM RAW_EMP_DATA;

--4. *** Find duplicate employee records. ***

WITH duplicate_cte AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY
              first_name,
              last_name,
              gender,
              department,
              city,
              email,
              hire_date,
              status
            ORDER BY employee_id
        ) AS rn
    FROM raw_emp_data
)
SELECT *
FROM duplicate_cte
WHERE rn > 1;


--5. **** Find extra spaces  ***

SELECT 
EMPLOYEE_ID, FIRST_NAME,
LAST_NAME , GENDER ,
DEPARTMENT , CITY ,
EMAIL , STATUS
FROM RAW_EMP_DATA 
WHERE LENGTH(first_name) <> LENGTH(TRIM(first_name))
   OR LENGTH(last_name) <> LENGTH(TRIM(last_name))
   OR LENGTH(email) <> LENGTH(TRIM(email))
   OR LENGTH(GENDER) <> LENGTH(TRIM(GENDER))
   OR LENGTH(DEPARTMENT) <> LENGTH(TRIM(DEPARTMENT))
   OR LENGTH(CITY) <> LENGTH(TRIM(CITY))
   OR LENGTH(STATUS) <> LENGTH(TRIM(STATUS))

-- ***6. Find INCONSISTENT VALUES ***

SELECT GENDER ,COUNT(*) AS TOTAL_COUNT
FROM RAW_EMP_DATA
GROUP BY GENDER 
ORDER BY TOTAL_COUNT DESC

-- ** FOR DEPARTMENT ***
SELECT DEPARTMENT , COUNT(*) AS TOTAL_COUNT
FROM RAW_EMP_DATA
GROUP BY DEPARTMENT 
ORDER BY TOTAL_COUNT DESC 

-- -- ** FOR STATUS ***--
SELECT STATUS , COUNT(*) AS TOTAL_COUNT
FROM RAW_EMP_DATA
GROUP BY STATUS 
ORDER BY TOTAL_COUNT DESC 

-- ** FOR HIRE_DATE ** --

SELECT EMPLOYEE_ID, HIRE_DATE
FROM RAW_EMP_DATA
WHERE HIRE_DATE IS NULL
   OR HIRE_DATE > CURRENT_DATE;
    


-- 7.-- Find invalid ages. -- 

SELECT
    employee_id,
    age
FROM raw_emp_data
WHERE
    CASE
        WHEN  TRIM(age) = '' THEN TRUE
        WHEN TRIM(age) !~ '^[+-]?[0-9]+$' THEN TRUE
        ELSE TRIM(age)::INTEGER NOT BETWEEN 18 AND 60
    END;

---8. FIND INVALID SALARY ---

SELECT
    employee_id,
    SALARY, STATUS
FROM raw_emp_data
WHERE
    SALARY IS NULL
  OR TRIM(SALARY) = ''
  OR TRIM(SALARY) !~ '^[0-9]+(\.[0-9]+)?$'
  OR TRIM(SALARY)::NUMERIC <= 0








