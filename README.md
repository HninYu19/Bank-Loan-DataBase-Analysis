📊 Financial Loan Analysis Project
Project Overview
This project provides a comprehensive analysis of a loan portfolio consisting of 39,294 individual loans. The primary objective is to evaluate portfolio performance, identify key risk factors associated with loan defaults (charge-offs), and assess overall profitability. The analysis is driven entirely by SQL queries executed on a structured loan dataset (financial_loan.csv).

The final output is a data-driven report that offers actionable insights for loan approval strategies, risk management, and portfolio optimization.

Key Questions Answered
1. What is the overall health and profitability of the loan portfolio?
2. What percentage of loans are "Good" (Fully Paid / Current) vs. "Bad" (Charged Off)?
3. Which factors are the strongest predictors of loan default?
4. Debt-to-Income (DTI) ratio
5. Credit Grade (A through G)
6. Loan Term (36 months vs. 60 months)
7. Geographic location (State)
8. Home Ownership status
9. How profitable is each loan grade after accounting for charge-off losses?
10. What actionable recommendations can be made to improve portfolio performance?

Dataset Description
File Name: financial_loan.csv
Number of Records: 39,294 loan entries
Key Fields Used in Analysis:
loan_status (Fully Paid, Current, Charged Off)
loan_amount, total_payment, int_rate, dti
grade (A-G), term (36/60 months), purpose
address_state, home_ownership, emp_length
annual_income, verification_status

SQL Analysis Structure
All analysis was performed using PostgreSQL-compatible SQL. The queries are organized into the following logical sections:
1. Portfolio KPIs (High-Level Metrics)
Total loan count, funded amount, collected amount
Average interest rate and DTI
Good vs. Bad loan percentages and amounts
2. Loan Status Deep Dive
Performance comparison across Fully Paid, Current, and Charged Off statuses
3. Risk Factor Analysis
DTI Risk Segmentation: Charge-off rates across DTI buckets (<10%, 10-20%, 20-30%, >30%)
Grade Performance: Charge-off rates and average interest by grade (A-G)
Term Length Impact: 36-month vs. 60-month loan performance
4. Geographic & Demographic Analysis
State-by-State Performance: Identifying high-risk states (e.g., NV, GA, FL)
Home Ownership Impact: Comparing renters vs. homeowners
Employment Length: Correlation with loan performance
Loan Purpose: Riskiest loan purposes
5. Profitability Analysis
Gross profit, loss from charge-offs, net profit, and net profit margin by grade
6. Time-Based Trends
Monthly loan volume and charge-off rates
Seasonal analysis by month

Key Insights from the Analysis
Metric	Value
Total Loans	39,294
Total Funded	$20.84M
Total Collected	$23.33M
Good Loan %	86.18%
Bad Loan (Charged Off) %	13.82%
Portfolio Net Profit	$9.17M
Net Profit Margin	11.86%

Top Risk Factors Identified
1. High DTI (>30%): 24.78% charge-off rate (2.4x higher than low DTI group)
2. Low Credit Grade (G): 34.85% charge-off rate; operates at a net loss (-2.02% margin)
3. 60-Month Term: 21.74% charge-off rate (vs. 11.31% for 36-month loans)
4. High-Risk States: Nevada (20.29%), Georgia (17.52%), Florida (17.07%)
5. Renters: Higher charge-off rate (15.57%) and DTI than homeowners

Recommendations Based on Analysis
1.Tighten Underwriting for High-DTI Borrowers: Implement stricter approval criteria or higher interest rates for applicants with DTI > 20-25%.
2.Limit Exposure to Lower Grades (E, F, G): These grades are marginally profitable or unprofitable. Consider reducing exposure or increasing pricing significantly.
3.Promote Shorter Loan Terms: Encourage 36-month loans over 60-month loans, or reserve 60-month terms for only A/B-grade borrowers.
4.Implement Geographic Risk Adjustments: Apply state-specific underwriting rules, especially for high-risk states like Nevada and Georgia.
5.Target Profitable Segments: Focus marketing and approval efforts on borrowers with low DTI, homeownership, and high credit grades (A/B) .

Tools Used
Database: PostgreSQL
Data Source: CSV file loaded into PostgreSQL
Analysis: SQL (aggregations, conditional logic, window functions, date extraction)
Reporting: Markdown / PDF

How to Reproduce This Analysis
Load the Data: Import financial_loan.csv into a PostgreSQL table named finance.
Run the Queries: Execute the SQL queries in the order presented in the financial_loan_analysis.sql file.
Review Results: Analyze the output of each query to understand portfolio performance and risk factors.
Generate Report: Use the insights to create a similar report or dashboard.
