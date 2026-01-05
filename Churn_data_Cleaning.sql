-- Creating new table and pasting all the records
-- Removing duplicates using window functions

create table clean_churn as
select * from (
	select *,
    row_number() over(partition by CustomerID) as row_num
    from raw_churn
) as temp
where row_num=1;    
select * from clean_churn;

-- Remove row_num column 
alter table clean_churn 
drop column row_num;

-- Making Gender column Consistent
select distinct Gender
from clean_churn;

select gender,
(case when Gender like "M%" then "Male" 
    when Gender like "F%" then "Female"
    else "Non-binary"
    end)
from clean_churn;

update clean_churn
set Gender = 
	(case when Gender like "M%" then "Male" 
    when Gender like "F%" then "Female"
    else "Non-binary"
    end);
    
-- Making Contract column Consistent
select distinct Contract 
from clean_churn;
select distinct Contract,
(case
		when Contract = "m2m" or Contract="Month-to-month" then "Monthly"
        when Contract = "1yr" or Contract="One year" then "One year"
        else "Two year"
        end) as cleanrow
from clean_churn;


update clean_churn
set Contract = 
	(case
		when Contract = "m2m" or Contract="Month-to-month" then "Monthly"
        when Contract = "1yr" or Contract="One year" then "One year"
        else "Two year"
        end);

-- Fill the blanks with Zeros(0) in SupportTickets Column
select * from clean_churn
where SupportTickets is null;

update clean_churn
set SupportTickets = null
where SupportTickets = "";

update clean_churn
set SupportTickets = 0
where SupportTickets is null;

-- Removing the "$" sign in all records and changed the data type to decimal
select TotalCharges, replace(replace(TotalCharges, "$",""),",","")
from clean_churn;

update clean_churn
set TotalCharges = replace(replace(TotalCharges, "$",""),",","");

select TotalCharges
from clean_churn;

alter table clean_churn
modify column TotalCharges decimal(10,2);

-- Replacing the values (-5 and 250) with "Unknown/Missing" and created age buckets
update clean_churn
set Age = null
where Age < 18 or Age > 100;

select Contract, avg(Age) from clean_churn
group by Contract;

select Contract, avg(Age) as Avg_Age
from clean_churn
where Age is not null
group by Contract
;

select Age,
	case
        when Age between 18 and 30 then "1. Young Adult (18-30)"
        when Age between 31 and 50 then "2. Adult (31-50)"
        when Age between 51 and 100 then "3. Senior (51+)"
        else "4. Unkownn/Missing"
	end as Age_group
from clean_churn;

-- Changed the column data type to text from int
alter table clean_churn
modify column Age text;

update clean_churn
set Age = 
	(case
        when Age between 18 and 30 then "1. Young Adult (18-30)"
        when Age between 31 and 50 then "2. Adult (31-50)"
        when Age between 51 and 100 then "3. Senior (51+)"
        else "4. Unkownn/Missing"
	end);

select Age from clean_churn
group by Age;

-- Changed the data type text to int
alter table clean_churn
modify column SupportTickets int;

select SupportTickets, count(*)
from clean_churn
group by SupportTickets;

-- Replacing the blank values with average values by grouping with tenure
update clean_churn
set UsageScore = null
where UsageScore = "";

alter table clean_churn
modify column UsageScore double;

select * from clean_churn;

select Tenure, 
	round(avg(UsageScore),2) 
from clean_churn
group by Tenure;

update clean_churn t1
join (
select Tenure,
	round(avg(UsageScore),2) as avg_usage
from clean_churn
where UsageScore is not null
group by Tenure) t2
on t1.Tenure = t2.Tenure
set t1.UsageScore = t2.avg_usage
where t1.UsageScore is null;
