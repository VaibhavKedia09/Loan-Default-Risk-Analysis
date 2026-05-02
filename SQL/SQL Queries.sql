-- ============================================================
-- LOAN DEFAULT ANALYSIS - SQL QUERIES
-- ============================================================


-- Q1) Default Percentage
SELECT ROUND(AVG(Defaulted)*100,2) AS default_perc FROM loans;

-- Insight:
-- Around 11.61% of customers have defaulted, indicating significant portfolio risk.


-- Q2) Average Loan Amount & Income
SELECT ROUND(AVG(Income),0) AS avg_income,
       ROUND(AVG(LoanAmount),0) AS avg_loan_amount
FROM loans;

-- Insight:
-- Average loan amount is $127,579 while average income is $82,499, suggesting loans are disproportionate to borrower earning capacity.


-- Q3) Total Customers
SELECT COUNT(*) AS total_customers FROM loans;

-- Insight:
-- The dataset contains 255,347 customers, providing a sufficient sample size to identify meaningful default patterns.


-- Q4) Income vs Default
SELECT
    CASE
        WHEN Income < 50000 THEN 'Low'
        WHEN Income BETWEEN 50000 AND 75000 THEN 'Medium'
        ELSE 'High'
    END AS income_group,
    ROUND(AVG(Defaulted)*100,2) AS default_perc
FROM loans
GROUP BY income_group
ORDER BY default_perc;

-- Insight:
-- Lower income groups exhibit significantly higher default rates, confirming repayment capacity is strongly linked to borrower income.


-- Q5) Income vs Default (Extended with Total Defaults & Loan Count)
SELECT
    CASE
        WHEN Income < 50000 THEN 'Low'
        WHEN Income BETWEEN 50000 AND 75000 THEN 'Medium'
        ELSE 'High'
    END AS income_group,
    ROUND(AVG(Defaulted)*100,2) AS default_perc,
    SUM(Defaulted) AS total_default,
    COUNT(*) AS total_loans
FROM loans
GROUP BY income_group
ORDER BY default_perc;

-- Insight:
-- Low income segment generates 11,344 defaults from 66,096 loans — the highest default rate at 17.16%.


-- Q6) Credit Score vs Default
SELECT
    CASE
        WHEN CreditScore < 500 THEN 'Low'
        WHEN CreditScore BETWEEN 500 AND 700 THEN 'Medium'
        ELSE 'High'
    END AS credit_group,
    ROUND(AVG(Defaulted)*100,2) AS default_perc,
    COUNT(*) AS total_loans
FROM loans
GROUP BY credit_group
ORDER BY default_perc;

-- Insight:
-- Customers with low credit scores show the highest default rates, confirming credit score is one of the strongest predictors of loan default risk.


-- Q7) Loan Amount vs Default
SELECT
    CASE
        WHEN LoanAmount < 50000 THEN 'Low'
        WHEN LoanAmount BETWEEN 50000 AND 150000 THEN 'Medium'
        ELSE 'High'
    END AS loan_group,
    ROUND(AVG(Defaulted)*100,2) AS default_perc
FROM loans
GROUP BY loan_group
ORDER BY default_perc;

-- Insight:
-- Default rates increase with higher loan amounts, suggesting larger financial obligations increase repayment risk.


-- Q8) Employment Type vs Default
SELECT
    EmploymentType,
    ROUND(AVG(Defaulted)*100,2) AS default_rate
FROM loans
GROUP BY EmploymentType
ORDER BY default_rate DESC;

-- Insight:
-- Unemployed borrowers have the highest default rate at 13.55%, confirming income stability plays a key role in loan repayment.


-- Q9) Education vs Default
SELECT
    Education,
    ROUND(AVG(Defaulted)*100,2) AS default_rate
FROM loans
GROUP BY Education
ORDER BY default_rate DESC;

-- Insight:
-- High School educated borrowers default at 12.88% vs PhD at 10.59%, suggesting education indirectly influences financial stability.


-- Q10) Income + Loan Combination Risk
SELECT
    CASE
        WHEN Income < 50000 THEN 'Low'
        WHEN Income BETWEEN 50000 AND 75000 THEN 'Medium'
        ELSE 'High'
    END AS income_group,

    CASE
        WHEN LoanAmount < 50000 THEN 'Low'
        WHEN LoanAmount BETWEEN 50000 AND 150000 THEN 'Medium'
        ELSE 'High'
    END AS loan_group,

    ROUND(AVG(Defaulted)*100,2) AS default_rate
FROM loans
GROUP BY income_group, loan_group
ORDER BY default_rate DESC;

-- Insight:
-- Low income + High loan borrowers default at 24.13% — the single highest risk segment in the portfolio.


-- Q11) Credit Score + Income
SELECT
    CASE
        WHEN Income < 50000 THEN 'Low'
        WHEN Income BETWEEN 50000 AND 75000 THEN 'Medium'
        ELSE 'High'
    END AS income_group,

    CASE
        WHEN CreditScore < 500 THEN 'Low'
        WHEN CreditScore BETWEEN 500 AND 700 THEN 'Medium'
        ELSE 'High'
    END AS credit_group,

    ROUND(AVG(Defaulted)*100,2) AS default_rate
FROM loans
GROUP BY income_group, credit_group
ORDER BY default_rate DESC;

-- Insight:
-- Low income + Low credit score borrowers default at 18.74%, representing the highest risk combination in the portfolio.


-- Q12) DTI Ratio vs Default
SELECT
    ROUND(DTIRatio,1) AS dti,
    ROUND(AVG(Defaulted)*100,2) AS default_rate
FROM loans
GROUP BY dti
ORDER BY dti DESC;

-- Insight:
-- Higher DTI ratios correlate with increased default rates, confirming borrowers with greater financial burden are more likely to default.


-- Q13) Co-Signer Impact
SELECT
    HasCoSigner,
    ROUND(AVG(Defaulted)*100,2) AS default_rate
FROM loans
GROUP BY HasCoSigner;

-- Insight:
-- Loans with co-signers show a 10.36% default rate vs 12.87% without, suggesting additional financial backing meaningfully reduces risk.


-- Q14) Mortgage Impact
SELECT
    HasMortgage,
    ROUND(AVG(Defaulted)*100,2) AS default_rate
FROM loans
GROUP BY HasMortgage;

-- Insight:
-- Customers without a mortgage default at 12.35% vs 10.88% with one, indicating existing liabilities influence repayment behaviour.


-- Q15) Highest Risk Group (Employment + Education)
SELECT
    EmploymentType,
    Education,
    ROUND(AVG(Defaulted)*100,2) AS default_rate
FROM loans
GROUP BY EmploymentType, Education
ORDER BY default_rate DESC
LIMIT 10;

-- Insight:
-- Unemployed borrowers with only a High School education top the risk table at 15.05% — the highest risk profile in the dataset.