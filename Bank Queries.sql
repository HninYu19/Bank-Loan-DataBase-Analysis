SELECT * FROM finance;

--total loan
SELECT COUNT(id) AS Total_Loan FROM finance;

-- total funded amount
SELECT SUM(loan_amount) AS Total_Funded_Amount FROM finance;

--total amount collected
SELECT SUM(total_payment) AS Total_Amount_Collected FROM finance;

--Average Interest Rate
SELECT AVG(int_rate::NUMERIC) * 100 AS Avg_Int_Rate FROM finance;

--Average DTI
SELECT AVG(dti)*100 AS Avg_DTI FROM finance;

--Good Loan Percentage
SELECT
    (COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END) * 100.0) / 
	COUNT(id) AS Good_Loan_Percentage FROM finance;

--Good Loan Applications
SELECT COUNT(id) AS Good_Loan_Applications FROM finance
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

--Good Loan Funded Amount
SELECT SUM(loan_amount) AS Good_Loan_Funded_Amount FROM finance
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

--Good Loan Amount Received
SELECT SUM(total_payment) AS Good_Loan_Amount_Received FROM finance
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

--Bad Loan Percentage
SELECT
    (COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100.0) / 
	COUNT(id) AS Bad_Loan_Percentage FROM finance;

--Bad Loan Applications
SELECT COUNT(id) AS Bad_Loan_Applications FROM finance
WHERE loan_status = 'Charged Off';

--Bad Loan Funded Amount
SELECT SUM(loan_amount) AS Bad_Loan_Funded_Amount FROM finance
WHERE loan_status = 'Charged Off';

--Bad Loan Amount Received
SELECT SUM(total_payment) AS Bad_Loan_Amount_Received FROM finance
WHERE loan_status = 'Charged Off';

--LOAN STATUS
SELECT loan_status,
    COUNT(id) AS LoanCount,
    SUM(total_payment) AS Total_Amount_Received,
    SUM(loan_amount) AS Total_Funded_Amount,
    AVG(CAST(int_rate AS NUMERIC) * 100) AS Interest_Rate,
    AVG(CAST(dti AS NUMERIC) * 100) AS DTI
FROM finance
GROUP BY loan_status;

--MONTH REPORT
SELECT 
    EXTRACT(MONTH FROM TO_DATE(issue_date, 'DD-MM-YYYY')) AS Month_Number,
    TO_CHAR(TO_DATE(issue_date, 'DD-MM-YYYY'), 'Month') AS Month_name,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM finance
GROUP BY 
    EXTRACT(MONTH FROM TO_DATE(issue_date, 'DD-MM-YYYY')),
    TO_CHAR(TO_DATE(issue_date, 'DD-MM-YYYY'), 'Month')
ORDER BY 
    EXTRACT(MONTH FROM TO_DATE(issue_date, 'DD-MM-YYYY'));

--STATE REPORT
SELECT address_state AS State, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM finance
GROUP BY address_state
ORDER BY address_state;

--TERM REPORT
SELECT term AS Term, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM finance
GROUP BY term
ORDER BY term;

--EMPLOYEE REPORT
SELECT emp_length AS Employee_Length, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM finance
GROUP BY emp_length
ORDER BY emp_length;

--PURPOSE REPORT
SELECT purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM finance
GROUP BY purpose
ORDER BY purpose;

--HOME OWNERSHIP REPORT
SELECT 
	home_ownership AS Home_Ownership, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM finance
GROUP BY home_ownership
ORDER BY home_ownership;

--Loan Performance by Grade
SELECT grade,
    COUNT(id) AS total_loans,
    SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) AS charged_off_count,
    ROUND(100.0 * SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) / COUNT(id), 2) AS charge_off_rate,
    ROUND(AVG(CASE WHEN loan_status = 'Charged Off' THEN CAST(int_rate AS NUMERIC) * 100 ELSE NULL END), 2) AS avg_charge_off_interest,
    ROUND(AVG(CAST(dti AS NUMERIC) * 100), 2) AS avg_dti
FROM finance
GROUP BY grade
ORDER BY grade;

--Recovery Rate Analysis
SELECT grade,
    COUNT(id) AS charged_off_loans,
    ROUND(SUM(CAST(loan_amount AS NUMERIC)), 2) AS total_charged_off_amount,
    ROUND(SUM(CAST(total_payment AS NUMERIC)), 2) AS amount_recovered,
    ROUND(100.0 * SUM(CAST(total_payment AS NUMERIC)) / SUM(CAST(loan_amount AS NUMERIC)), 2) AS recovery_rate_percent
FROM finance
WHERE loan_status = 'Charged Off'
GROUP BY grade
ORDER BY grade;

--DTI Risk Segmentation
SELECT 
    CASE 
        WHEN CAST(dti AS NUMERIC) * 100 < 10 THEN 'Low DTI (<10%)'
        WHEN CAST(dti AS NUMERIC) * 100 BETWEEN 10 AND 20 THEN 'Medium DTI (10-20%)'
        WHEN CAST(dti AS NUMERIC) * 100 BETWEEN 20 AND 30 THEN 'High DTI (20-30%)'
        ELSE 'Very High DTI (>30%)'
    END AS dti_segment,
    COUNT(id) AS total_loans,
    SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) AS charge_offs,
    ROUND(100.0 * SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) / COUNT(id), 2) AS charge_off_rate,
    ROUND(AVG(CAST(int_rate AS NUMERIC) * 100), 2) AS avg_interest_rate
FROM finance
GROUP BY 
    CASE 
        WHEN CAST(dti AS NUMERIC) * 100 < 10 THEN 'Low DTI (<10%)'
        WHEN CAST(dti AS NUMERIC) * 100 BETWEEN 10 AND 20 THEN 'Medium DTI (10-20%)'
        WHEN CAST(dti AS NUMERIC) * 100 BETWEEN 20 AND 30 THEN 'High DTI (20-30%)'
        ELSE 'Very High DTI (>30%)'
    END
ORDER BY charge_off_rate DESC;

--Monthly Loan Volume & Performance Trends
SELECT 
    TO_CHAR(TO_DATE(issue_date, 'DD-MM-YYYY'), 'YYYY-MM') AS month,
    COUNT(id) AS loans_issued,
    SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) AS charge_offs,
    ROUND(100.0 * SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) / COUNT(id), 2) AS charge_off_rate,
    ROUND(AVG(CAST(int_rate AS NUMERIC) * 100), 2) AS avg_interest_rate,
    ROUND(SUM(CAST(loan_amount AS NUMERIC)), 0) AS total_funded
FROM finance
GROUP BY TO_CHAR(TO_DATE(issue_date, 'DD-MM-YYYY'), 'YYYY-MM')
ORDER BY month;

--Seasonal Analysis by Month
SELECT 
    EXTRACT(MONTH FROM TO_DATE(issue_date, 'DD-MM-YYYY')) AS month_number,
    TO_CHAR(TO_DATE(issue_date, 'DD-MM-YYYY'), 'Month') AS month_name,
    COUNT(id) AS total_applications,
    ROUND(AVG(CAST(int_rate AS NUMERIC) * 100), 2) AS avg_rate,
    ROUND(100.0 * SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) / COUNT(id), 2) AS charge_off_rate
FROM finance
GROUP BY EXTRACT(MONTH FROM TO_DATE(issue_date, 'DD-MM-YYYY')), TO_CHAR(TO_DATE(issue_date, 'DD-MM-YYYY'), 'Month')
ORDER BY month_number;

--Home Ownership vs Loan Performance
SELECT home_ownership,
    COUNT(id) AS total_loans,
    ROUND(AVG(CAST(loan_amount AS NUMERIC)), 0) AS avg_loan_amount,
    ROUND(AVG(CAST(int_rate AS NUMERIC) * 100), 2) AS avg_interest_rate,
    ROUND(100.0 * SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) / COUNT(id), 2) AS charge_off_rate,
    ROUND(AVG(CAST(annual_income AS NUMERIC)), 0) AS avg_annual_income
FROM finance
GROUP BY home_ownership
ORDER BY charge_off_rate DESC;

--Employment Length Impact
SELECT emp_length,
    COUNT(id) AS total_loans,
    ROUND(AVG(CAST(loan_amount AS NUMERIC)), 0) AS avg_loan,
    ROUND(100.0 * SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) / COUNT(id), 2) AS charge_off_rate,
    ROUND(AVG(CAST(int_rate AS NUMERIC) * 100), 2) AS avg_rate
FROM finance
GROUP BY emp_length
ORDER BY 
    CASE emp_length
        WHEN '< 1 year' THEN 1
        WHEN '1 year' THEN 2
        WHEN '2 years' THEN 3
        WHEN '3 years' THEN 4
        WHEN '4 years' THEN 5
        WHEN '5 years' THEN 6
        WHEN '6 years' THEN 7
        WHEN '7 years' THEN 8
        WHEN '8 years' THEN 9
        WHEN '9 years' THEN 10
        WHEN '10+ years' THEN 11
    END;

--Profitability Analysis (Interest Income vs Losses)
SELECT grade,
    COUNT(id) AS total_loans,
    ROUND(SUM(CAST(total_payment AS NUMERIC) - CAST(loan_amount AS NUMERIC)), 0) AS gross_profit,
    ROUND(SUM(CASE WHEN loan_status = 'Charged Off' THEN CAST(loan_amount AS NUMERIC) - CAST(total_payment AS NUMERIC) ELSE 0 END), 0) AS loss_from_charge_offs,
    ROUND(SUM(CAST(total_payment AS NUMERIC) - CAST(loan_amount AS NUMERIC)) - 
          SUM(CASE WHEN loan_status = 'Charged Off' THEN CAST(loan_amount AS NUMERIC) - CAST(total_payment AS NUMERIC) ELSE 0 END), 0) AS net_profit,
    ROUND(100.0 * (SUM(CAST(total_payment AS NUMERIC) - CAST(loan_amount AS NUMERIC)) - 
          SUM(CASE WHEN loan_status = 'Charged Off' THEN CAST(loan_amount AS NUMERIC) - CAST(total_payment AS NUMERIC) ELSE 0 END)) / 
          SUM(CAST(loan_amount AS NUMERIC)), 2) AS net_profit_margin
FROM finance
GROUP BY grade
ORDER BY grade;

-- Loan Purpose Risk Analysis
SELECT purpose,
    COUNT(id) AS total_loans,
    ROUND(SUM(CAST(loan_amount AS NUMERIC)), 0) AS total_funded,
    ROUND(100.0 * SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) / COUNT(id), 2) AS charge_off_rate,
    ROUND(AVG(CAST(int_rate AS NUMERIC) * 100), 2) AS avg_interest_rate,
    ROUND(AVG(CAST(dti AS NUMERIC) * 100), 2) AS avg_dti
FROM finance
GROUP BY purpose
ORDER BY charge_off_rate DESC
LIMIT 10;

--State-by-State Performance
SELECT address_state AS state,
    COUNT(id) AS total_loans,
    ROUND(SUM(CAST(loan_amount AS NUMERIC)), 0) AS total_funded,
    ROUND(AVG(CAST(loan_amount AS NUMERIC)), 0) AS avg_loan_amount,
    ROUND(100.0 * SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) / COUNT(id), 2) AS charge_off_rate,
    ROUND(AVG(CAST(int_rate AS NUMERIC) * 100), 2) AS avg_rate
FROM finance
GROUP BY address_state
HAVING COUNT(id) > 50
ORDER BY charge_off_rate DESC
LIMIT 15;

--Income Verification Impact
SELECT verification_status,
    COUNT(id) AS total_loans,
    ROUND(AVG(CAST(annual_income AS NUMERIC)), 0) AS avg_income,
    ROUND(AVG(CAST(loan_amount AS NUMERIC)), 0) AS avg_loan,
    ROUND(100.0 * SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) / COUNT(id), 2) AS charge_off_rate,
    ROUND(AVG(CAST(int_rate AS NUMERIC) * 100), 2) AS avg_rate
FROM finance
GROUP BY verification_status
ORDER BY charge_off_rate;

--Term Length Performance
SELECT term,
    COUNT(id) AS total_loans,
    ROUND(AVG(CAST(loan_amount AS NUMERIC)), 0) AS avg_loan,
    ROUND(100.0 * SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) / COUNT(id), 2) AS charge_off_rate,
    ROUND(AVG(CAST(int_rate AS NUMERIC) * 100), 2) AS avg_interest_rate
FROM finance
GROUP BY term;