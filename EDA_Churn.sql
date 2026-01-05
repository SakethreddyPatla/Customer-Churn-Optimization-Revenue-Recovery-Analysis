-- Overall Churn Rate
select 
	count(*) as Total_Customers,
    sum(Churn) as Total_Churned,
    round(avg(Churn)*100,2) as Overall_Churn_Rate_Pct
from clean_churn;

-- Churn Rate Based on Contract Type
select 
    Contract,
	count(*) as Total_Customers,
    sum(Churn) as Total_Churned,
    round(avg(Churn)*100,2) as Overall_Churn_Rate_Pct
from clean_churn
group by Contract
order by Overall_Churn_Rate_Pct desc;

-- Churn Rate Based on Tenure 
select 
    Tenure,
	count(*) as Total_Customers,
    sum(Churn) as Total_Churned,
    round(avg(Churn)*100,2) as Overall_Churn_Rate_Pct
from clean_churn
group by Tenure
order by Tenure;

-- Churn Rate Based On Regions

select
	Geography,
    count(*) as Total_Customers,
    sum(Churn) as Total_Churned,
    round(avg(Churn)*100,2) as Overall_Churn_Rate_Pct
from clean_churn
group by GeoGraphy
order by Overall_Churn_Rate_Pct desc;


select
	case
		when UsageScore < 20 then "Very Low Usage"
        when UsageScore between 20 and 60 then "Moderate Usage"
        else "High Usage"
	end as Usage_Bracket,
	round(avg(SupportTickets),2) as Avg_Tickets,
    round(avg(Churn)*100,2) as Overall_Churn_Rate_Pct
from clean_churn
group by Usage_Bracket
Order by Overall_Churn_Rate_Pct desc;

-- Revenue
select
	Geography,
    round(sum(case when Churn=1 then MonthlyCharges else 0 end),2) as Revenue_Lost,
    round(sum(case when Churn=0 then MonthlyCharges else 0 end),2) as Revenue_Retained,
    round(sum(case when Churn=1 then MonthlyCharges else 0 end)/sum(MonthlyCharges)*100,2) as Revenue_Churn_Rate
from clean_churn
group by Geography
order by Revenue_Churn_Rate desc;

-- MothlyCharges vs Support Tickets
select
	case
		when MonthlyCharges > 80 then "High Cost"
        else "Low Cost"
	end as Customer_Category,
    case
		when SupportTickets > 4 then "High Tickets (5+)"
        else "Low Tickets (0-4)"
	end as Support_Tickets,
count(*) as Customer_Count,
sum(case when Churn = 1 then 1 else 0 end) as Churned_Customers,
round(avg(Churn)*100,2) as Overall_Churn_Rate_Pct
from clean_churn
group by Customer_Category,Support_Tickets
order by Customer_Category;

-- High value customers at risk
select 
	CustomerID,
    Geography,
    MonthlyCharges,
    UsageScore,
    SupportTickets
from clean_churn
where Churn = 0 and MonthlyCharges > (select avg(MonthlyCharges) from clean_churn) and
(UsageScore < 30 or SupportTickets > 5)
order by MonthlyCharges desc; 

-- Tenure vs Revenue
select
	case
    when Tenure <= 12 then "New (0-1yr)"
    when Tenure between 13 and 36 then "Established (1-3yr)"
    else "Veteran (3yr+)"
    end as Loyalty_Phase,
    round(avg(MonthlyCharges),2) as Monthly_Revenue,
    round(avg(Churn)*100,2) as Overall_Churn_Rate_Pct
from clean_churn
group by Loyalty_Phase
;

-- Churn Rate Based on Demographic

select 
	Gender,
    Age,
    count(*) as Total_Count,
    round(avg(Churn)*100,2) as Overall_Churn_Rate_Pct
from clean_churn
group by Gender,Age
order by Overall_Churn_Rate_Pct;

SELECT 
    Geography,
    ROUND(SUM(MonthlyCharges), 2) AS Total_Potential_MRR,
    ROUND(SUM(CASE WHEN Churn = 1 THEN MonthlyCharges ELSE 0 END), 2) AS Lost_MRR,
    ROUND(AVG(CASE WHEN Churn = 1 THEN MonthlyCharges ELSE NULL END), 2) AS Avg_Charge_of_Churned_User,
    ROUND((SUM(CASE WHEN Churn = 1 THEN MonthlyCharges ELSE 0 END) / SUM(MonthlyCharges)) * 100, 2) AS Revenue_Churn_Pct
FROM clean_churn
WHERE Geography IN ('East', 'North')
GROUP BY Geography;

