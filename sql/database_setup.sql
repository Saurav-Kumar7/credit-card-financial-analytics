-- ============================================================
-- CREDIT CARD FINANCIAL ANALYTICS
-- Database Setup & Data Import
-- Database: MySQL 8.x
-- ============================================================


-- ============================================================
-- 1. CREATE DATABASE
-- ============================================================

CREATE DATABASE IF NOT EXISTS credit_card_analytics;

USE credit_card_analytics;


-- ============================================================
-- 2. DROP TABLES IF THEY ALREADY EXIST
-- ============================================================

DROP TABLE IF EXISTS cc_detail;
DROP TABLE IF EXISTS cust_detail;


-- ============================================================
-- 3. CREATE CREDIT CARD DETAIL TABLE
-- ============================================================

CREATE TABLE cc_detail (
    Client_Num INT NOT NULL,
    Card_Category VARCHAR(20),
    Annual_Fees INT,
    Activation_30_Days TINYINT,
    Customer_Acq_Cost INT,
    Week_Start_Date DATE,
    Week_Num VARCHAR(20),
    Qtr VARCHAR(10),
    Current_Year INT,
    Credit_Limit DECIMAL(12,2),
    Total_Revolving_Bal INT,
    Total_Trans_Amt INT,
    Total_Trans_Ct INT,
    Avg_Utilization_Ratio DECIMAL(10,3),
    Use_Chip VARCHAR(20),
    Exp_Type VARCHAR(50),
    Interest_Earned DECIMAL(12,3),
    Delinquent_Acc TINYINT
);


-- ============================================================
-- 4. CREATE CUSTOMER DETAIL TABLE
-- ============================================================

CREATE TABLE cust_detail (
    Client_Num INT NOT NULL,
    Customer_Age INT,
    Gender VARCHAR(5),
    Dependent_Count INT,
    Education_Level VARCHAR(50),
    Marital_Status VARCHAR(20),
    State_Cd VARCHAR(10),
    Zipcode VARCHAR(10),
    Car_Owner VARCHAR(5),
    House_Owner VARCHAR(5),
    Personal_Loan VARCHAR(5),
    Contact VARCHAR(50),
    Customer_Job VARCHAR(50),
    Income INT,
    Cust_Satisfaction_Score TINYINT
);


-- ============================================================
-- 5. IMPORT CREDIT CARD DATA
-- ============================================================
-- IMPORTANT:
-- Replace the file path below if your MySQL secure_file_priv
-- folder is different.
--
-- Current MySQL setup:
-- C:/ProgramData/MySQL/MySQL Server 8.4/Uploads/
-- ============================================================


LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.4/Uploads/credit_card.csv'

INTO TABLE cc_detail

FIELDS TERMINATED BY ','
ENCLOSED BY '"'

LINES TERMINATED BY '\n'

IGNORE 1 ROWS

(
    Client_Num,
    Card_Category,
    Annual_Fees,
    Activation_30_Days,
    Customer_Acq_Cost,
    @Week_Start_Date,
    Week_Num,
    Qtr,
    Current_Year,
    Credit_Limit,
    Total_Revolving_Bal,
    Total_Trans_Amt,
    Total_Trans_Ct,
    Avg_Utilization_Ratio,
    Use_Chip,
    Exp_Type,
    Interest_Earned,
    Delinquent_Acc
)

SET Week_Start_Date = STR_TO_DATE(@Week_Start_Date, '%d-%m-%Y');


-- ============================================================
-- 6. IMPORT ADDITIONAL CREDIT CARD DATA
-- ============================================================

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.4/Uploads/cc_add.csv'

INTO TABLE cc_detail

FIELDS TERMINATED BY ','
ENCLOSED BY '"'

LINES TERMINATED BY '\n'

IGNORE 1 ROWS

(
    Client_Num,
    Card_Category,
    Annual_Fees,
    Activation_30_Days,
    Customer_Acq_Cost,
    @Week_Start_Date,
    Week_Num,
    Qtr,
    Current_Year,
    Credit_Limit,
    Total_Revolving_Bal,
    Total_Trans_Amt,
    Total_Trans_Ct,
    Avg_Utilization_Ratio,
    Use_Chip,
    Exp_Type,
    Interest_Earned,
    Delinquent_Acc
)

SET Week_Start_Date = STR_TO_DATE(@Week_Start_Date, '%d-%m-%Y');


-- ============================================================
-- 7. IMPORT CUSTOMER DATA
-- ============================================================

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.4/Uploads/customer.csv'

INTO TABLE cust_detail

FIELDS TERMINATED BY ','
ENCLOSED BY '"'

LINES TERMINATED BY '\n'

IGNORE 1 ROWS

(
    Client_Num,
    Customer_Age,
    Gender,
    Dependent_Count,
    Education_Level,
    Marital_Status,
    State_Cd,
    Zipcode,
    Car_Owner,
    House_Owner,
    Personal_Loan,
    Contact,
    Customer_Job,
    Income,
    Cust_Satisfaction_Score
);


-- ============================================================
-- 8. IMPORT ADDITIONAL CUSTOMER DATA
-- ============================================================

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.4/Uploads/cust_add.csv'

INTO TABLE cust_detail

FIELDS TERMINATED BY ','
ENCLOSED BY '"'

LINES TERMINATED BY '\n'

IGNORE 1 ROWS

(
    Client_Num,
    Customer_Age,
    Gender,
    Dependent_Count,
    Education_Level,
    Marital_Status,
    State_Cd,
    Zipcode,
    Car_Owner,
    House_Owner,
    Personal_Loan,
    Contact,
    Customer_Job,
    Income,
    Cust_Satisfaction_Score
);


-- ============================================================
-- 9. BASIC DATA VALIDATION
-- ============================================================

SELECT
    'Credit Card Detail' AS Table_Name,
    COUNT(*) AS Total_Rows
FROM cc_detail

UNION ALL

SELECT
    'Customer Detail' AS Table_Name,
    COUNT(*) AS Total_Rows
FROM cust_detail;


-- ============================================================
-- 10. CHECK WEEK 53 RECORDS
-- ============================================================

SELECT
    Week_Num,
    COUNT(*) AS Record_Count
FROM cc_detail
GROUP BY Week_Num
ORDER BY Week_Num;


-- ============================================================
-- 11. CHECK DUPLICATE CLIENT NUMBERS
-- ============================================================

SELECT
    Client_Num,
    COUNT(*) AS Record_Count
FROM cc_detail
GROUP BY Client_Num
HAVING COUNT(*) > 1;


SELECT
    Client_Num,
    COUNT(*) AS Record_Count
FROM cust_detail
GROUP BY Client_Num
HAVING COUNT(*) > 1;


-- ============================================================
-- 12. CHECK NULL VALUES
-- ============================================================

SELECT
    COUNT(*) AS Null_Client_Num
FROM cc_detail
WHERE Client_Num IS NULL;


SELECT
    COUNT(*) AS Null_Client_Num
FROM cust_detail
WHERE Client_Num IS NULL;


-- ============================================================
-- 13. VERIFY DATABASE TABLES
-- ============================================================

SHOW TABLES;


-- ============================================================
-- END OF DATABASE SETUP
-- ============================================================