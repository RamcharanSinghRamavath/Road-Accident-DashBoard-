-- ============================================================
-- Road Accident Analytics - MySQL Validation Queries
-- Dataset: Road Accident Data (2021-2022)
-- Purpose: Cross-validate Power BI KPI values
-- Author: Ramcharan Singh Ramavath
-- ============================================================

-- ============================================================
-- SECTION 1: PRIMARY KPIs - TOTAL CASUALTIES & ACCIDENTS
-- ============================================================

-- 1.1 Total Casualties (All Years)
SELECT 
    SUM(Number_of_Casualties) AS Total_Casualties
FROM road_accident;

-- 1.2 Current Year (CY 2022) Total Casualties
SELECT 
    SUM(Number_of_Casualties) AS CY_Casualties
FROM road_accident
WHERE YEAR(Accident_Date) = 2022;

-- 1.3 Previous Year (PY 2021) Total Casualties
SELECT 
    SUM(Number_of_Casualties) AS PY_Casualties
FROM road_accident
WHERE YEAR(Accident_Date) = 2021;

-- 1.4 YoY Growth in Casualties (%)
SELECT 
    cy.CY_Casualties,
    py.PY_Casualties,
    ROUND(
        ((cy.CY_Casualties - py.PY_Casualties) * 100.0 / py.PY_Casualties), 2
    ) AS YoY_Growth_Percent
FROM 
    (SELECT SUM(Number_of_Casualties) AS CY_Casualties 
     FROM road_accident WHERE YEAR(Accident_Date) = 2022) cy,
    (SELECT SUM(Number_of_Casualties) AS PY_Casualties 
     FROM road_accident WHERE YEAR(Accident_Date) = 2021) py;

-- 1.5 Total Accidents by Year
SELECT 
    YEAR(Accident_Date) AS Year,
    COUNT(DISTINCT Accident_Index) AS Total_Accidents
FROM road_accident
GROUP BY YEAR(Accident_Date)
ORDER BY Year;


-- ============================================================
-- SECTION 2: PRIMARY KPIs - CASUALTIES BY SEVERITY
-- ============================================================

-- 2.1 CY Casualties by Accident Severity
SELECT 
    Accident_Severity,
    SUM(Number_of_Casualties) AS CY_Casualties
FROM road_accident
WHERE YEAR(Accident_Date) = 2022
GROUP BY Accident_Severity
ORDER BY CY_Casualties DESC;

-- 2.2 PY Casualties by Accident Severity
SELECT 
    Accident_Severity,
    SUM(Number_of_Casualties) AS PY_Casualties
FROM road_accident
WHERE YEAR(Accident_Date) = 2021
GROUP BY Accident_Severity
ORDER BY PY_Casualties DESC;

-- 2.3 YoY Severity Comparison (Fatal, Serious, Slight)
SELECT 
    a.Accident_Severity,
    a.CY_Casualties,
    b.PY_Casualties,
    ROUND(
        ((a.CY_Casualties - b.PY_Casualties) * 100.0 / b.PY_Casualties), 2
    ) AS YoY_Growth_Percent
FROM 
    (SELECT Accident_Severity, SUM(Number_of_Casualties) AS CY_Casualties
     FROM road_accident WHERE YEAR(Accident_Date) = 2022
     GROUP BY Accident_Severity) a
JOIN 
    (SELECT Accident_Severity, SUM(Number_of_Casualties) AS PY_Casualties
     FROM road_accident WHERE YEAR(Accident_Date) = 2021
     GROUP BY Accident_Severity) b
ON a.Accident_Severity = b.Accident_Severity
ORDER BY a.CY_Casualties DESC;

-- 2.4 Percentage Share of Each Severity (CY 2022)
SELECT 
    Accident_Severity,
    SUM(Number_of_Casualties) AS Casualties,
    ROUND(
        SUM(Number_of_Casualties) * 100.0 / SUM(SUM(Number_of_Casualties)) OVER (), 2
    ) AS Percentage_Share
FROM road_accident
WHERE YEAR(Accident_Date) = 2022
GROUP BY Accident_Severity
ORDER BY Casualties DESC;


-- ============================================================
-- SECTION 3: SECONDARY KPIs - CASUALTIES BY VEHICLE TYPE
-- ============================================================

-- 3.1 CY 2022 Casualties by Vehicle Type
SELECT 
    Vehicle_Type,
    SUM(Number_of_Casualties) AS CY_Casualties
FROM road_accident
WHERE YEAR(Accident_Date) = 2022
GROUP BY Vehicle_Type
ORDER BY CY_Casualties DESC;

-- 3.2 Vehicle Type Casualties with % Share (CY 2022)
SELECT 
    Vehicle_Type,
    SUM(Number_of_Casualties) AS Casualties,
    ROUND(
        SUM(Number_of_Casualties) * 100.0 / SUM(SUM(Number_of_Casualties)) OVER (), 2
    ) AS Pct_Share
FROM road_accident
WHERE YEAR(Accident_Date) = 2022
GROUP BY Vehicle_Type
ORDER BY Casualties DESC;

-- 3.3 Top 5 Vehicle Types by Casualties (CY 2022)
SELECT 
    Vehicle_Type,
    SUM(Number_of_Casualties) AS CY_Casualties
FROM road_accident
WHERE YEAR(Accident_Date) = 2022
GROUP BY Vehicle_Type
ORDER BY CY_Casualties DESC
LIMIT 5;


-- ============================================================
-- SECTION 4: MONTHLY TREND - CY vs PY
-- ============================================================

-- 4.1 Monthly Casualties - CY 2022 vs PY 2021 (Side by Side)
SELECT 
    MONTH(Accident_Date) AS Month_Number,
    MONTHNAME(Accident_Date) AS Month_Name,
    SUM(CASE WHEN YEAR(Accident_Date) = 2022 THEN Number_of_Casualties ELSE 0 END) AS CY_2022,
    SUM(CASE WHEN YEAR(Accident_Date) = 2021 THEN Number_of_Casualties ELSE 0 END) AS PY_2021
FROM road_accident
GROUP BY MONTH(Accident_Date), MONTHNAME(Accident_Date)
ORDER BY Month_Number;

-- 4.2 Month with Highest Casualties (CY 2022)
SELECT 
    MONTHNAME(Accident_Date) AS Month_Name,
    SUM(Number_of_Casualties) AS Casualties
FROM road_accident
WHERE YEAR(Accident_Date) = 2022
GROUP BY MONTHNAME(Accident_Date), MONTH(Accident_Date)
ORDER BY Casualties DESC
LIMIT 1;

-- 4.3 Running Total of Casualties by Month (CY 2022) using Window Function
SELECT 
    MONTH(Accident_Date) AS Month_Number,
    MONTHNAME(Accident_Date) AS Month_Name,
    SUM(Number_of_Casualties) AS Monthly_Casualties,
    SUM(SUM(Number_of_Casualties)) OVER (ORDER BY MONTH(Accident_Date)) AS Running_Total
FROM road_accident
WHERE YEAR(Accident_Date) = 2022
GROUP BY MONTH(Accident_Date), MONTHNAME(Accident_Date)
ORDER BY Month_Number;


-- ============================================================
-- SECTION 5: CASUALTIES BY ROAD TYPE
-- ============================================================

-- 5.1 CY 2022 Casualties by Road Type
SELECT 
    Road_Type,
    SUM(Number_of_Casualties) AS CY_Casualties
FROM road_accident
WHERE YEAR(Accident_Date) = 2022
GROUP BY Road_Type
ORDER BY CY_Casualties DESC;

-- 5.2 Road Type with Highest Fatal Casualties
SELECT 
    Road_Type,
    SUM(Number_of_Casualties) AS Fatal_Casualties
FROM road_accident
WHERE YEAR(Accident_Date) = 2022
  AND Accident_Severity = 'Fatal'
GROUP BY Road_Type
ORDER BY Fatal_Casualties DESC;

-- 5.3 Severity Breakdown by Road Type (CY 2022)
SELECT 
    Road_Type,
    Accident_Severity,
    SUM(Number_of_Casualties) AS Casualties
FROM road_accident
WHERE YEAR(Accident_Date) = 2022
GROUP BY Road_Type, Accident_Severity
ORDER BY Road_Type, Casualties DESC;


-- ============================================================
-- SECTION 6: CASUALTIES BY AREA AND LIGHT CONDITIONS
-- ============================================================

-- 6.1 CY 2022 Casualties by Urban vs Rural
SELECT 
    Urban_or_Rural_Area,
    SUM(Number_of_Casualties) AS CY_Casualties,
    ROUND(
        SUM(Number_of_Casualties) * 100.0 / SUM(SUM(Number_of_Casualties)) OVER (), 2
    ) AS Pct_Share
FROM road_accident
WHERE YEAR(Accident_Date) = 2022
GROUP BY Urban_or_Rural_Area;

-- 6.2 CY 2022 Casualties by Day vs Night
SELECT 
    CASE 
        WHEN Light_Conditions IN ('Daylight') THEN 'Day'
        ELSE 'Night'
    END AS Light_Condition_Group,
    SUM(Number_of_Casualties) AS CY_Casualties,
    ROUND(
        SUM(Number_of_Casualties) * 100.0 / SUM(SUM(Number_of_Casualties)) OVER (), 2
    ) AS Pct_Share
FROM road_accident
WHERE YEAR(Accident_Date) = 2022
GROUP BY Light_Condition_Group;

-- 6.3 Fatal Casualties by Area and Light Condition (CY 2022)
SELECT 
    Urban_or_Rural_Area,
    CASE 
        WHEN Light_Conditions IN ('Daylight') THEN 'Day'
        ELSE 'Night'
    END AS Light_Condition,
    SUM(Number_of_Casualties) AS Fatal_Casualties
FROM road_accident
WHERE YEAR(Accident_Date) = 2022
  AND Accident_Severity = 'Fatal'
GROUP BY Urban_or_Rural_Area, Light_Condition
ORDER BY Fatal_Casualties DESC;


-- ============================================================
-- SECTION 7: ADVANCED ANALYSIS WITH WINDOW FUNCTIONS
-- ============================================================

-- 7.1 Rank Months by Casualties (CY 2022)
SELECT 
    MONTHNAME(Accident_Date) AS Month_Name,
    SUM(Number_of_Casualties) AS Casualties,
    RANK() OVER (ORDER BY SUM(Number_of_Casualties) DESC) AS Casualty_Rank
FROM road_accident
WHERE YEAR(Accident_Date) = 2022
GROUP BY MONTHNAME(Accident_Date), MONTH(Accident_Date);

-- 7.2 MoM (Month-over-Month) Change in Casualties (CY 2022)
SELECT 
    MONTH(Accident_Date) AS Month_Num,
    MONTHNAME(Accident_Date) AS Month_Name,
    SUM(Number_of_Casualties) AS Monthly_Casualties,
    LAG(SUM(Number_of_Casualties)) OVER (ORDER BY MONTH(Accident_Date)) AS Prev_Month_Casualties,
    SUM(Number_of_Casualties) - LAG(SUM(Number_of_Casualties)) OVER (ORDER BY MONTH(Accident_Date)) AS MoM_Change
FROM road_accident
WHERE YEAR(Accident_Date) = 2022
GROUP BY MONTH(Accident_Date), MONTHNAME(Accident_Date)
ORDER BY Month_Num;

-- 7.3 Top 3 Road Types per Severity using DENSE_RANK (CY 2022)
WITH ranked_roads AS (
    SELECT 
        Accident_Severity,
        Road_Type,
        SUM(Number_of_Casualties) AS Casualties,
        DENSE_RANK() OVER (PARTITION BY Accident_Severity ORDER BY SUM(Number_of_Casualties) DESC) AS rnk
    FROM road_accident
    WHERE YEAR(Accident_Date) = 2022
    GROUP BY Accident_Severity, Road_Type
)
SELECT Accident_Severity, Road_Type, Casualties, rnk
FROM ranked_roads
WHERE rnk <= 3
ORDER BY Accident_Severity, rnk;

-- 7.4 Cumulative % of Casualties by Vehicle Type (CY 2022) - Pareto Analysis
WITH vehicle_casualties AS (
    SELECT 
        Vehicle_Type,
        SUM(Number_of_Casualties) AS Casualties
    FROM road_accident
    WHERE YEAR(Accident_Date) = 2022
    GROUP BY Vehicle_Type
),
totals AS (
    SELECT SUM(Casualties) AS Grand_Total FROM vehicle_casualties
)
SELECT 
    v.Vehicle_Type,
    v.Casualties,
    ROUND(v.Casualties * 100.0 / t.Grand_Total, 2) AS Pct_Share,
    ROUND(
        SUM(v.Casualties) OVER (ORDER BY v.Casualties DESC) * 100.0 / t.Grand_Total, 2
    ) AS Cumulative_Pct
FROM vehicle_casualties v, totals t
ORDER BY v.Casualties DESC;


-- ============================================================
-- SECTION 8: DATA QUALITY CHECKS
-- ============================================================

-- 8.1 Check for NULL values in critical columns
SELECT 
    SUM(CASE WHEN Accident_Index IS NULL THEN 1 ELSE 0 END) AS null_accident_index,
    SUM(CASE WHEN Accident_Date IS NULL THEN 1 ELSE 0 END) AS null_date,
    SUM(CASE WHEN Accident_Severity IS NULL THEN 1 ELSE 0 END) AS null_severity,
    SUM(CASE WHEN Number_of_Casualties IS NULL THEN 1 ELSE 0 END) AS null_casualties,
    SUM(CASE WHEN Vehicle_Type IS NULL THEN 1 ELSE 0 END) AS null_vehicle_type
FROM road_accident;

-- 8.2 Check distinct values in categorical columns
SELECT DISTINCT Accident_Severity FROM road_accident ORDER BY Accident_Severity;
SELECT DISTINCT Urban_or_Rural_Area FROM road_accident ORDER BY Urban_or_Rural_Area;
SELECT DISTINCT Road_Type FROM road_accident ORDER BY Road_Type;
SELECT DISTINCT Light_Conditions FROM road_accident ORDER BY Light_Conditions;

-- 8.3 Date range verification
SELECT 
    MIN(Accident_Date) AS Earliest_Date,
    MAX(Accident_Date) AS Latest_Date,
    COUNT(DISTINCT YEAR(Accident_Date)) AS Years_Covered
FROM road_accident;

-- 8.4 Duplicate check on Accident_Index
SELECT 
    Accident_Index,
    COUNT(*) AS Record_Count
FROM road_accident
GROUP BY Accident_Index
HAVING COUNT(*) > 1
ORDER BY Record_Count DESC;
