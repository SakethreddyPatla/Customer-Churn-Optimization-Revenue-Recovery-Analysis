-- Creating new table and pasting all the records
-- Removing duplicates using window functions

create table clean_churn as
select * from (
	select *,
    row_number() over(partition by CustomerID) as row_num
    from raw_churn
) as temp
where row_num=1;
SELECT 
    *
FROM
    clean_churn;

-- Remove row_num column 
alter table clean_churn 
drop column row_num;

-- Making Gender column Consistent
SELECT DISTINCT
    Gender
FROM
    clean_churn;

SELECT 
    gender,
    (CASE
        WHEN Gender LIKE 'M%' THEN 'Male'
        WHEN Gender LIKE 'F%' THEN 'Female'
        ELSE 'Non-binary'
    END)
FROM
    clean_churn;

UPDATE clean_churn 
SET 
    Gender = (CASE
        WHEN Gender LIKE 'M%' THEN 'Male'
        WHEN Gender LIKE 'F%' THEN 'Female'
        ELSE 'Non-binary'
    END);
    
-- Making Contract column Consistent
SELECT DISTINCT
    Contract
FROM
    clean_churn;
SELECT DISTINCT
    Contract,
    (CASE
        WHEN
            Contract = 'm2m'
                OR Contract = 'Month-to-month'
        THEN
            'Monthly'
        WHEN
            Contract = '1yr'
                OR Contract = 'One year'
        THEN
            'One year'
        ELSE 'Two year'
    END) AS cleanrow
FROM
    clean_churn;


UPDATE clean_churn 
SET 
    Contract = (CASE
        WHEN
            Contract = 'm2m'
                OR Contract = 'Month-to-month'
        THEN
            'Monthly'
        WHEN
            Contract = '1yr'
                OR Contract = 'One year'
        THEN
            'One year'
        ELSE 'Two year'
    END);

-- Fill the blanks with Zeros(0) in SupportTickets Column
SELECT 
    *
FROM
    clean_churn
WHERE
    SupportTickets IS NULL;

UPDATE clean_churn 
SET 
    SupportTickets = NULL
WHERE
    SupportTickets = '';

UPDATE clean_churn 
SET 
    SupportTickets = 0
WHERE
    SupportTickets IS NULL;

-- Removing the "$" sign in all records and changed the data type to decimal
SELECT 
    TotalCharges,
    REPLACE(REPLACE(TotalCharges, '$', ''),
        ',',
        '')
FROM
    clean_churn;

UPDATE clean_churn 
SET 
    TotalCharges = REPLACE(REPLACE(TotalCharges, '$', ''),
        ',',
        '');

SELECT 
    TotalCharges
FROM
    clean_churn;

alter table clean_churn
modify column TotalCharges decimal(10,2);

-- Replacing the values (-5 and 250) with "Unknown/Missing" and created age buckets
UPDATE clean_churn 
SET 
    Age = NULL
WHERE
    Age < 18 OR Age > 100;

SELECT 
    Contract, AVG(Age)
FROM
    clean_churn
GROUP BY Contract;

SELECT 
    Contract, AVG(Age) AS Avg_Age
FROM
    clean_churn
WHERE
    Age IS NOT NULL
GROUP BY Contract
;

SELECT 
    Age,
    CASE
        WHEN Age BETWEEN 18 AND 30 THEN '1. Young Adult (18-30)'
        WHEN Age BETWEEN 31 AND 50 THEN '2. Adult (31-50)'
        WHEN Age BETWEEN 51 AND 100 THEN '3. Senior (51+)'
        ELSE '4. Unkownn/Missing'
    END AS Age_group
FROM
    clean_churn;

-- Changed the column data type to text from int
alter table clean_churn
modify column Age text;

UPDATE clean_churn 
SET 
    Age = (CASE
        WHEN Age BETWEEN 18 AND 30 THEN '1. Young Adult (18-30)'
        WHEN Age BETWEEN 31 AND 50 THEN '2. Adult (31-50)'
        WHEN Age BETWEEN 51 AND 100 THEN '3. Senior (51+)'
        ELSE '4. Unkownn/Missing'
    END);

SELECT 
    Age
FROM
    clean_churn
GROUP BY Age;

-- Changed the data type text to int
alter table clean_churn
modify column SupportTickets int;

SELECT 
    SupportTickets, COUNT(*)
FROM
    clean_churn
GROUP BY SupportTickets;

-- Replacing the blank values with average values by grouping with tenure
UPDATE clean_churn 
SET 
    UsageScore = NULL
WHERE
    UsageScore = '';

alter table clean_churn
modify column UsageScore double;

SELECT 
    *
FROM
    clean_churn;

SELECT 
    Tenure, ROUND(AVG(UsageScore), 2)
FROM
    clean_churn
GROUP BY Tenure;

UPDATE clean_churn t1
        JOIN
    (SELECT 
        Tenure, ROUND(AVG(UsageScore), 2) AS avg_usage
    FROM
        clean_churn
    WHERE
        UsageScore IS NOT NULL
    GROUP BY Tenure) t2 ON t1.Tenure = t2.Tenure 
SET 
    t1.UsageScore = t2.avg_usage
WHERE
    t1.UsageScore IS NULL;
