# Customer-Churn-Optimization-Revenue-Recovery-Analysis
#### Executive Summary
This project provides an end-to-end solution for identifying and mitigating customer attrition in a 10,000-user subscription dataset. By integrating SQL data engineering, Power BI visualization, and Python machine learning, I transformed raw data into a strategic roadmap that identifies $272K in revenue risk.

The analysis revealed that churn is not random; specific high-friction segments experience attrition rates as high as 78%. This project enables a transition from reactive reporting to proactive retention by providing individualized risk scores for at-risk customers.
#### Tech Stack
- Database: MySQL 
- Analysis: Advanced SQL (CTEs, Window Functions, Aggregate Joins), Predicitive Modelling (Python)
- Logic: Feature Engineering and Correlation Analysis
#### Data Cleaning Highlights
Before analyzing anything, I fixed several data quality issues to make sure the results were reliable:
- Removed duplicates: Eliminated about 200 repeated records using ROW_NUMBER() and CTEs.
- Standardized categories: Cleaned up inconsistent labels for Contract Type and Gender.
- Fixed TotalCharges: Stripped out symbols like $ and , and converted the column to a numeric type.
- Handled outliers: Removed impossible age values (like –5 or 250).
#### Key Insights from the Analysis
1. The “High-Friction” Customer Group
- The biggest churn driver is a mix of high monthly costs and frequent support issues. Customers who pay more and have 5+ support tickets churn at 78.16%, making them the highest‑risk segment.
2. Contract Type & Geography Matter
- Contract Type: Monthly customers churn at 55.35%, which is nearly three times higher than annual subscribers.
- Region: The East Region is struggling the most, losing 48.79% of its potential revenue to churn.
3. Churn Peaks at Specific Tenure Points
- Churn isn’t steady it spikes at certain moments in the customer lifecycle:
  - Month 2: Early churn peak at 42.06%
  - Month 6: Mid‑lifecycle spike at 43.94%
#### Strategic Recommendations
- Proactive “Health Checks”: Personally reach out to high‑value customers who have more than 3 support tickets before they churn.
- Promote Annual Plans: Encourage monthly users to switch to annual contracts, which improves retention by about 35%.
- Improve Onboarding: Add automated “value touchpoints” around Month 2 and Month 5 to support customers during the periods where churn spikes.
#### Predictive Modeling (Python)
Moved beyond historical data to forecast future attrition.
- Algorithm: Trained a Random Forest Classifier achieving an accuracy of 69.7%.
- Key Driver Analysis: Mathematically proved that Monthly Charges is the #1 predictor of churn, followed by Usage Scores and Tenure.
- Proactive Retention: Generated a Risk Watchlist with individual probability scores, allowing for targeted interventions before customers cancel.
