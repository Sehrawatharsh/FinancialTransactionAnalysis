-- Creating a Data base for bank Data

create database BankData;

-- Checking the uploaded data

Select * from bank_transactions_data;

-- 1 Data Cleaning:- Checking for missing values, editing the data types and 

CREATE TABLE prepared_transactions AS 
SELECT 
    TransactionID, AccountID, ROUND(TransactionAmount, 2) AS TransactionAmount, DATE(TransactionDate) AS TransactionDate,
    TransactionType, Location, DeviceID, MerchantID, ROUND(AccountBalance, 2) AS AccountBalance, LoginAttempts,
    DATE(PreviousTransactionDate) AS PreviousTransactionDate, Channel, CustomerAge, CustomerOccupation, TransactionDuration
   
FROM bank_transactions_data
WHERE TransactionAmount IS NOT NULL
  AND TransactionDate IS NOT NULL;


-- 2 Trend Analysis
-- a. Month-by-Month Transaction Summary
SELECT 
    DATE_FORMAT(TransactionDate, '%Y-%m') AS Month,  
    COUNT(*) AS TotalTransactions,  
    SUM(TransactionAmount) AS TotalSpent
FROM prepared_transactions
GROUP BY Month
ORDER BY Month;

-- Summary by Transaction Type
SELECT 
    TransactionType,
    COUNT(*) AS Count,
    SUM(TransactionAmount) AS Total,
    AVG(TransactionAmount) AS Average
FROM prepared_transactions
GROUP BY TransactionType;

-- Getting Transaction detail of various Transaction channels
SELECT 
    Channel,
    COUNT(*) AS Count,
    SUM(TransactionAmount) AS Total_Transaction_Amt,
    AVG(TransactionAmount) AS Average_Transaction_Amt
FROM prepared_transactions
GROUP BY Channel;

-- Spending Behavior by Occupation and Channel
SELECT 
    CustomerOccupation, Channel,
    COUNT(*) AS NumberOfTransactions
    
FROM prepared_transactions
GROUP BY CustomerOccupation, channel
ORDER BY NumberOfTransactions DESC;

-- Spending Behavior by AGE group
SELECT 
  CASE 
    WHEN CustomerAge BETWEEN 18 AND 25 THEN '18-25'
    WHEN CustomerAge BETWEEN 26 AND 35 THEN '26-35'
    WHEN CustomerAge BETWEEN 36 AND 45 THEN '36-45'
    WHEN CustomerAge BETWEEN 46 AND 60 THEN '46-60'
    WHEN CustomerAge > 60 THEN '60+'
    ELSE 'Unknown'
  END AS AgeGroup,
  COUNT(*) AS NumberOfTransactions,
  ROUND(AVG(TransactionAmount), 2) AS AverageTransactionAmount
FROM prepared_transactions
GROUP BY AgeGroup
ORDER BY AverageTransactionAmount DESC;

-- Checking the mean of the transaction duration in each channel
select Channel, Avg(TransactionDuration) From prepared_transactions group by Channel ;

-- 3 Flagging Anomalies
--  Unusual Login Patterns
SELECT *
FROM prepared_transactions
WHERE LoginAttempts >= 5;

-- Filtering cities with high number of login 
Select Location, Count(*) as Suspicious_Login 
From prepared_transactions 
Where LoginAttempts>=5 
Group by Location 
Having Suspicious_Login>=2 
Order by Suspicious_Login desc;
-- B. Outlier Transactions Based on Z-Scores
SELECT 
    AVG(TransactionAmount) AS avg_amt,
    STDDEV(TransactionAmount) AS std_amt
INTO @avg_amt, @std_amt
FROM prepared_transactions;

-- Use those to identify potential outliers
SELECT TransactionID, AccountID, TransactionAmount, Channel,Location, LoginAttempts, TransactionType,CustomerAge
FROM prepared_transactions
WHERE TransactionAmount > @avg_amt + 3* @std_amt
   OR TransactionAmount < @avg_amt - 3 * @std_amt;
   
   
-- Getting Locations with highest outlier transactions
Select Location, Count(*) AS Number_of_Outlier_Transaction
   From (SELECT TransactionID, AccountID, TransactionAmount, Channel,Location, LoginAttempts, TransactionType,CustomerAge
FROM prepared_transactions
WHERE TransactionAmount > @avg_amt + 3* @std_amt
   OR TransactionAmount < @avg_amt - 3 * @std_amt) AS Out_lierTable
 Group by Location 
 Having Number_of_Outlier_Transaction >=2
 Order By Number_of_Outlier_Transaction DESC;

-- tep 4: Insight Generation & Summary Metrics
-- A. Average Spend by Channel
SELECT 
    Channel,
    COUNT(*) AS Transactions,
    AVG(TransactionAmount) AS AverageValue
FROM prepared_transactions
GROUP BY Channel;

-- B. Cities with Highest Transaction Activity
SELECT 
    Location,
    COUNT(*) AS Frequency,
    SUM(TransactionAmount) AS TotalSpend
FROM prepared_transactions
GROUP BY Location
ORDER BY TotalSpend DESC
LIMIT 10;

-- C.Frequent Devices in High-Risk Scenarios
  SELECT DeviceID, count(*) As SuspiciousLogins
    FROM prepared_transactions
    WHERE LoginAttempts >= 5
    GROUP BY DeviceID
    ORDER BY COUNT(*) DESC
    LIMIT 5;
-- C.1 Details of the top 5 suspicious login from those Devices
WITH Compremised_Devices AS (
    SELECT DeviceID
    FROM prepared_transactions
    WHERE LoginAttempts >= 5
    GROUP BY DeviceID
    ORDER BY COUNT(*) DESC
    LIMIT 5
)

SELECT pt.*
FROM prepared_transactions pt
JOIN Compremised_Devices td ON pt.DeviceID = td.DeviceID
Where LoginAttempts>=5
Order by pt.TransactionAmount DESC 
Limit 5 ;











