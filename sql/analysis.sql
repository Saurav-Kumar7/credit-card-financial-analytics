-- ============================================================
-- CREDIT CARD FINANCIAL ANALYTICS
-- Business Analysis Queries
-- Database: MySQL 8.x
-- ============================================================

USE credit_card_analytics;


-- ============================================================
-- 1. OVERALL KPIs
-- ============================================================

SELECT
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT Client_Num) AS Total_Customers,
    SUM(Annual_Fees) AS Annual_Fees,
    SUM(Total_Trans_Amt) AS Transaction_Amount,
    SUM(Interest_Earned) AS Interest_Earned,
    SUM(Total_Trans_Ct) AS Transaction_Count,
    SUM(Annual_Fees + Total_Trans_Amt + Interest_Earned) AS Total_Revenue
FROM cc_detail;


-- ============================================================
-- 2. REVENUE BY CARD CATEGORY
-- ============================================================

SELECT
    Card_Category,
    COUNT(DISTINCT Client_Num) AS Customers,
    SUM(Annual_Fees + Total_Trans_Amt + Interest_Earned) AS Revenue,
    ROUND(
        SUM(Annual_Fees + Total_Trans_Amt + Interest_Earned)
        / COUNT(DISTINCT Client_Num),
        2
    ) AS Revenue_Per_Customer
FROM cc_detail
GROUP BY Card_Category
ORDER BY Revenue DESC;


-- ============================================================
-- 3. REVENUE BY GENDER
-- ============================================================

SELECT
    c.Gender,
    COUNT(DISTINCT c.Client_Num) AS Customers,
    SUM(cc.Annual_Fees + cc.Total_Trans_Amt + cc.Interest_Earned) AS Revenue,
    ROUND(
        SUM(cc.Annual_Fees + cc.Total_Trans_Amt + cc.Interest_Earned)
        / COUNT(DISTINCT c.Client_Num),
        2
    ) AS Revenue_Per_Customer
FROM cc_detail cc
JOIN cust_detail c
    ON cc.Client_Num = c.Client_Num
GROUP BY c.Gender
ORDER BY Revenue DESC;


-- ============================================================
-- 4. REVENUE BY EXPENDITURE TYPE
-- ============================================================

SELECT
    Exp_Type,
    SUM(Annual_Fees + Total_Trans_Amt + Interest_Earned) AS Revenue,
    SUM(Total_Trans_Amt) AS Transaction_Amount,
    SUM(Total_Trans_Ct) AS Transaction_Count,
    ROUND(
        SUM(Total_Trans_Amt) / SUM(Total_Trans_Ct),
        2
    ) AS Average_Transaction_Value
FROM cc_detail
GROUP BY Exp_Type
ORDER BY Revenue DESC;


-- ============================================================
-- 5. MONTHLY REVENUE TREND
-- ============================================================

SELECT
    MONTH(Week_Start_Date) AS Month_Number,
    MONTHNAME(Week_Start_Date) AS Month_Name,
    SUM(Annual_Fees + Total_Trans_Amt + Interest_Earned) AS Revenue
FROM cc_detail
GROUP BY
    MONTH(Week_Start_Date),
    MONTHNAME(Week_Start_Date)
ORDER BY Month_Number;


-- ============================================================
-- 6. QUARTERLY REVENUE
-- ============================================================

SELECT
    Qtr AS Quarter,
    SUM(Annual_Fees + Total_Trans_Amt + Interest_Earned) AS Revenue
FROM cc_detail
GROUP BY Qtr
ORDER BY Qtr;


-- ============================================================
-- 7. REVENUE BY CUSTOMER JOB
-- ============================================================

SELECT
    c.Customer_Job,
    COUNT(DISTINCT c.Client_Num) AS Customers,
    SUM(cc.Annual_Fees + cc.Total_Trans_Amt + cc.Interest_Earned) AS Revenue,
    ROUND(
        SUM(cc.Annual_Fees + cc.Total_Trans_Amt + cc.Interest_Earned)
        / COUNT(DISTINCT c.Client_Num),
        2
    ) AS Revenue_Per_Customer
FROM cc_detail cc
JOIN cust_detail c
    ON cc.Client_Num = c.Client_Num
GROUP BY c.Customer_Job
ORDER BY Revenue DESC;


-- ============================================================
-- 8. REVENUE BY STATE
-- ============================================================

SELECT
    c.State_Cd,
    COUNT(DISTINCT c.Client_Num) AS Customers,
    SUM(cc.Annual_Fees + cc.Total_Trans_Amt + cc.Interest_Earned) AS Revenue,
    ROUND(
        SUM(cc.Annual_Fees + cc.Total_Trans_Amt + cc.Interest_Earned)
        / COUNT(DISTINCT c.Client_Num),
        2
    ) AS Revenue_Per_Customer
FROM cc_detail cc
JOIN cust_detail c
    ON cc.Client_Num = c.Client_Num
GROUP BY c.State_Cd
ORDER BY Revenue DESC;


-- ============================================================
-- 9. REVENUE BY INCOME GROUP
-- ============================================================

SELECT
    CASE
        WHEN c.Income < 50000 THEN 'Low Income'
        WHEN c.Income <= 100000 THEN 'Mid Income'
        WHEN c.Income <= 150000 THEN 'High Income'
        ELSE 'Very High Income'
    END AS Income_Group,

    COUNT(DISTINCT c.Client_Num) AS Customers,

    SUM(cc.Annual_Fees + cc.Total_Trans_Amt + cc.Interest_Earned) AS Revenue,

    ROUND(
        SUM(cc.Annual_Fees + cc.Total_Trans_Amt + cc.Interest_Earned)
        / COUNT(DISTINCT c.Client_Num),
        2
    ) AS Revenue_Per_Customer

FROM cc_detail cc
JOIN cust_detail c
    ON cc.Client_Num = c.Client_Num

GROUP BY
    CASE
        WHEN c.Income < 50000 THEN 'Low Income'
        WHEN c.Income <= 100000 THEN 'Mid Income'
        WHEN c.Income <= 150000 THEN 'High Income'
        ELSE 'Very High Income'
    END

ORDER BY Revenue DESC;


-- ============================================================
-- 10. REVENUE BY AGE GROUP
-- ============================================================

SELECT
    CASE
        WHEN c.Customer_Age < 30 THEN 'Under 30'
        WHEN c.Customer_Age <= 39 THEN '30-39'
        WHEN c.Customer_Age <= 49 THEN '40-49'
        WHEN c.Customer_Age <= 59 THEN '50-59'
        ELSE '60+'
    END AS Age_Group,

    COUNT(DISTINCT c.Client_Num) AS Customers,

    SUM(cc.Annual_Fees + cc.Total_Trans_Amt + cc.Interest_Earned) AS Revenue

FROM cc_detail cc
JOIN cust_detail c
    ON cc.Client_Num = c.Client_Num

GROUP BY
    CASE
        WHEN c.Customer_Age < 30 THEN 'Under 30'
        WHEN c.Customer_Age <= 39 THEN '30-39'
        WHEN c.Customer_Age <= 49 THEN '40-49'
        WHEN c.Customer_Age <= 59 THEN '50-59'
        ELSE '60+'
    END

ORDER BY Revenue DESC;


-- ============================================================
-- 11. ACTIVATION & DELINQUENCY
-- ============================================================

SELECT
    COUNT(*) AS Total_Records,

    SUM(Activation_30_Days) AS Activated_Accounts,

    ROUND(
        SUM(Activation_30_Days) * 100.0 / COUNT(*),
        2
    ) AS Activation_Rate,

    SUM(Delinquent_Acc) AS Delinquent_Accounts,

    ROUND(
        SUM(Delinquent_Acc) * 100.0 / COUNT(*),
        2
    ) AS Delinquency_Rate

FROM cc_detail;


-- ============================================================
-- 12. RISK BY CREDIT UTILIZATION
-- ============================================================

SELECT
    CASE
        WHEN Avg_Utilization_Ratio < 0.10 THEN 'Very Low'
        WHEN Avg_Utilization_Ratio < 0.30 THEN 'Low'
        WHEN Avg_Utilization_Ratio < 0.60 THEN 'Medium'
        WHEN Avg_Utilization_Ratio < 0.80 THEN 'High'
        ELSE 'Very High'
    END AS Utilization_Group,

    COUNT(*) AS Customers,

    ROUND(AVG(Avg_Utilization_Ratio) * 100, 2) AS Average_Utilization,

    SUM(Delinquent_Acc) AS Delinquent_Accounts,

    ROUND(
        SUM(Delinquent_Acc) * 100.0 / COUNT(*),
        2
    ) AS Delinquency_Rate,

    ROUND(AVG(Credit_Limit), 2) AS Average_Credit_Limit

FROM cc_detail

GROUP BY
    CASE
        WHEN Avg_Utilization_Ratio < 0.10 THEN 'Very Low'
        WHEN Avg_Utilization_Ratio < 0.30 THEN 'Low'
        WHEN Avg_Utilization_Ratio < 0.60 THEN 'Medium'
        WHEN Avg_Utilization_Ratio < 0.80 THEN 'High'
        ELSE 'Very High'
    END

ORDER BY
    CASE
        WHEN Utilization_Group = 'Very Low' THEN 1
        WHEN Utilization_Group = 'Low' THEN 2
        WHEN Utilization_Group = 'Medium' THEN 3
        WHEN Utilization_Group = 'High' THEN 4
        ELSE 5
    END;


-- ============================================================
-- 13. CUSTOMER ACQUISITION COST ANALYSIS
-- ============================================================

SELECT
    ROUND(AVG(Customer_Acq_Cost), 2) AS Average_CAC,

    MIN(Customer_Acq_Cost) AS Minimum_CAC,

    MAX(Customer_Acq_Cost) AS Maximum_CAC

FROM cc_detail;


-- ============================================================
-- 14. REVENUE BY CAC GROUP
-- ============================================================

SELECT
    CASE
        WHEN Customer_Acq_Cost < 80 THEN 'Low CAC'
        WHEN Customer_Acq_Cost <= 120 THEN 'Medium CAC'
        WHEN Customer_Acq_Cost <= 150 THEN 'High CAC'
        ELSE 'Very High CAC'
    END AS CAC_Group,

    COUNT(DISTINCT Client_Num) AS Customers,

    ROUND(AVG(Customer_Acq_Cost), 2) AS Average_CAC,

    SUM(Annual_Fees + Total_Trans_Amt + Interest_Earned) AS Revenue,

    ROUND(
        SUM(Annual_Fees + Total_Trans_Amt + Interest_Earned)
        / COUNT(DISTINCT Client_Num),
        2
    ) AS Revenue_Per_Customer,

    ROUND(
        SUM(Total_Trans_Amt) / SUM(Total_Trans_Ct),
        2
    ) AS Average_Transaction_Value

FROM cc_detail

GROUP BY
    CASE
        WHEN Customer_Acq_Cost < 80 THEN 'Low CAC'
        WHEN Customer_Acq_Cost <= 120 THEN 'Medium CAC'
        WHEN Customer_Acq_Cost <= 150 THEN 'High CAC'
        ELSE 'Very High CAC'
    END

ORDER BY Revenue DESC;


-- ============================================================
-- 15. TRANSACTION CHANNEL ANALYSIS
-- ============================================================

SELECT
    TRIM(Use_Chip) AS Transaction_Channel,

    COUNT(DISTINCT Client_Num) AS Customers,

    SUM(Total_Trans_Ct) AS Transaction_Count,

    SUM(Total_Trans_Amt) AS Transaction_Amount,

    SUM(Annual_Fees + Total_Trans_Amt + Interest_Earned) AS Revenue,

    ROUND(
        SUM(Total_Trans_Amt) / SUM(Total_Trans_Ct),
        2
    ) AS Average_Transaction_Value

FROM cc_detail

GROUP BY TRIM(Use_Chip)

ORDER BY Revenue DESC;


-- ============================================================
-- END OF ANALYSIS
-- ============================================================