-- Overall Churn Rate
SELECT 
    COUNT(*) AS Total_Customers,
    SUM(Churn) AS Total_Churned,
    ROUND(AVG(Churn) * 100, 2) AS Overall_Churn_Rate_Pct
FROM
    clean_churn;

-- Churn Rate Based on Contract Type
SELECT 
    Contract,
    COUNT(*) AS Total_Customers,
    SUM(Churn) AS Total_Churned,
    ROUND(AVG(Churn) * 100, 2) AS Overall_Churn_Rate_Pct
FROM
    clean_churn
GROUP BY Contract
ORDER BY Overall_Churn_Rate_Pct DESC;

-- Churn Rate Based on Tenure 
SELECT 
    Tenure,
    COUNT(*) AS Total_Customers,
    SUM(Churn) AS Total_Churned,
    ROUND(AVG(Churn) * 100, 2) AS Overall_Churn_Rate_Pct
FROM
    clean_churn
GROUP BY Tenure
ORDER BY Tenure;

-- Churn Rate Based On Regions

SELECT 
    Geography,
    COUNT(*) AS Total_Customers,
    SUM(Churn) AS Total_Churned,
    ROUND(AVG(Churn) * 100, 2) AS Overall_Churn_Rate_Pct
FROM
    clean_churn
GROUP BY GeoGraphy
ORDER BY Overall_Churn_Rate_Pct DESC;


SELECT 
    CASE
        WHEN UsageScore < 20 THEN 'Very Low Usage'
        WHEN UsageScore BETWEEN 20 AND 60 THEN 'Moderate Usage'
        ELSE 'High Usage'
    END AS Usage_Bracket,
    ROUND(AVG(SupportTickets), 2) AS Avg_Tickets,
    ROUND(AVG(Churn) * 100, 2) AS Overall_Churn_Rate_Pct
FROM
    clean_churn
GROUP BY Usage_Bracket
ORDER BY Overall_Churn_Rate_Pct DESC;

-- Revenue
SELECT 
    Geography,
    ROUND(SUM(CASE
                WHEN Churn = 1 THEN MonthlyCharges
                ELSE 0
            END),
            2) AS Revenue_Lost,
    ROUND(SUM(CASE
                WHEN Churn = 0 THEN MonthlyCharges
                ELSE 0
            END),
            2) AS Revenue_Retained,
    ROUND(SUM(CASE
                WHEN Churn = 1 THEN MonthlyCharges
                ELSE 0
            END) / SUM(MonthlyCharges) * 100,
            2) AS Revenue_Churn_Rate
FROM
    clean_churn
GROUP BY Geography
ORDER BY Revenue_Churn_Rate DESC;

-- MothlyCharges vs Support Tickets
SELECT 
    CASE
        WHEN MonthlyCharges > 80 THEN 'High Cost'
        ELSE 'Low Cost'
    END AS Customer_Category,
    CASE
        WHEN SupportTickets > 4 THEN 'High Tickets (5+)'
        ELSE 'Low Tickets (0-4)'
    END AS Support_Tickets,
    COUNT(*) AS Customer_Count,
    SUM(CASE
        WHEN Churn = 1 THEN 1
        ELSE 0
    END) AS Churned_Customers,
    ROUND(AVG(Churn) * 100, 2) AS Overall_Churn_Rate_Pct
FROM
    clean_churn
GROUP BY Customer_Category , Support_Tickets
ORDER BY Customer_Category;

-- High value customers at risk
SELECT 
    CustomerID,
    Geography,
    MonthlyCharges,
    UsageScore,
    SupportTickets
FROM
    clean_churn
WHERE
    Churn = 0
        AND MonthlyCharges > (SELECT 
            AVG(MonthlyCharges)
        FROM
            clean_churn)
        AND (UsageScore < 30 OR SupportTickets > 5)
ORDER BY MonthlyCharges DESC;

-- Tenure vs Revenue
SELECT 
    CASE
        WHEN Tenure <= 12 THEN 'New (0-1yr)'
        WHEN Tenure BETWEEN 13 AND 36 THEN 'Established (1-3yr)'
        ELSE 'Veteran (3yr+)'
    END AS Loyalty_Phase,
    ROUND(AVG(MonthlyCharges), 2) AS Monthly_Revenue,
    ROUND(AVG(Churn) * 100, 2) AS Overall_Churn_Rate_Pct
FROM
    clean_churn
GROUP BY Loyalty_Phase
;

-- Churn Rate Based on Demographic

SELECT 
    Gender,
    Age,
    COUNT(*) AS Total_Count,
    ROUND(AVG(Churn) * 100, 2) AS Overall_Churn_Rate_Pct
FROM
    clean_churn
GROUP BY Gender , Age
ORDER BY Overall_Churn_Rate_Pct;

SELECT 
    Geography,
    ROUND(SUM(MonthlyCharges), 2) AS Total_Potential_MRR,
    ROUND(SUM(CASE
                WHEN Churn = 1 THEN MonthlyCharges
                ELSE 0
            END),
            2) AS Lost_MRR,
    ROUND(AVG(CASE
                WHEN Churn = 1 THEN MonthlyCharges
                ELSE NULL
            END),
            2) AS Avg_Charge_of_Churned_User,
    ROUND((SUM(CASE
                WHEN Churn = 1 THEN MonthlyCharges
                ELSE 0
            END) / SUM(MonthlyCharges)) * 100,
            2) AS Revenue_Churn_Pct
FROM
    clean_churn
WHERE
    Geography IN ('East' , 'North')
GROUP BY Geography;

