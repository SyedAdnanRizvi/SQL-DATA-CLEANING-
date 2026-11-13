SELECT * FROM RAW_EMP_DATA

--- *** DELETE DUPLICATE RECORDS ***--

WITH duplicate_cte AS (
    SELECT
        ctid,
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
DELETE FROM raw_emp_data
WHERE ctid IN (
    SELECT ctid
    FROM duplicate_cte
    WHERE rn > 1
);

-- *** REMOVE EXTRA SPACES ****--
UPDATE RAW_EMP_DATA
SET
    FIRST_NAME = TRIM(FIRST_NAME),
    LAST_NAME = TRIM(LAST_NAME),
    CITY = TRIM(CITY),
	GENDER = TRIM(GENDER),
    DEPARTMENT = TRIM(DEPARTMENT),
	EMAIL = TRIM(EMAIL),
	STATUS = TRIM(STATUS);
	

-- **FIX INCONSISTENT VALUES **---
--             FOR GENDER         --
UPDATE RAW_EMP_DATA
SET GENDER = CASE 
 WHEN UPPER(TRIM(GENDER))  IN ('M' , 'MALE' ) THEN 'Male' 
 WHEN UPPER(TRIM(GENDER )) IN ('F' , 'FEMALE ') THEN 'Female' 
 ELSE 'OTHER'
 END ;

--    FOR DEPARTMENT-----

UPDATE RAW_EMP_DATA
SET DEPARTMENT  = CASE
 WHEN UPPER(TRIM(DEPARTMENT))  IN ('IT') THEN 'IT' 
 ELSE 'DEPARTMENT'
END  ;

---   FOR STATUS  - - -- 

UPDATE RAW_EMP_DATA
SET STATUS  = CASE
 WHEN UPPER(TRIM(STATUS))  IN ('ACTIVE') THEN 'Active' 
 ELSE 'STATUS'
END  ;

----    FOR AGE   -----
UPDATE RAW_EMP_DATA 
SET AGE = CASE 
  WHEN TRIM(AGE) = '-5' THEN '5'
  WHEN AGE = 'twenty five' THEN '25'
  WHEN AGE = '150' THEN  '30'
  ELSE 'AGE'
 END
 WHERE 	AGE IN ('-5','twenty five','150')

--   FOR SALARY ---
UPDATE RAW_EMP_DATA
SET SALARY = CASE
    WHEN TRIM(SALARY) = '-40000' THEN '40000'
    WHEN TRIM(SALARY) = '0' THEN NULL
    ELSE TRIM(SALARY)
END
WHERE SALARY IN ('-40000', '0');

-- FIX DATATYPE OF SALARY ---

ALTER TABLE RAW_EMP_DATA
ALTER COLUMN SALARY TYPE INTEGER
USING SALARY::INTEGER

-- FIX DATATYPE OF AGE ---

ALTER TABLE RAW_EMP_DATA
ALTER COLUMN AGE TYPE INTEGER
USING AGE::INTEGER

-- FIX DATATYPE OF HIRE_DATE ---

ALTER TABLE RAW_EMP_DATA
ALTER COLUMN HIRE_DATE TYPE DATE
USING HIRE_DATE::DATE

