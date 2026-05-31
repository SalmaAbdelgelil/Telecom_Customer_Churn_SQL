-- Step 1: Create & Use Database
CREATE DATABASE if not exists final_project;
USE final_project;
-- =====================================================================================================
-- Step 2: Rename Raw Tables
-- =====================================================================================================
RENAME TABLE customerchurn TO customerchurn_raw;
RENAME TABLE telecom_customer_churn TO telecom_customer_churn_raw;
-- =====================================================================================================
-- Step 3: Clean Table 1 - Customer Churn
-- ===================================================================================================
CREATE TABLE Churn AS
SELECT
    TRIM(customerID) AS customer_id,
    TRIM(gender) AS gender,
    CAST(SeniorCitizen AS UNSIGNED) AS SeniorCitizen,
    TRIM(Partner) AS Partner,
    TRIM(Dependents) AS Dependents,
    CAST(tenure AS UNSIGNED) AS tenure,
    TRIM(PhoneService) AS PhoneService,
    TRIM(MultipleLines) AS MultipleLines,
    TRIM(InternetService) AS InternetService,
    TRIM(OnlineSecurity) AS OnlineSecurity,
    TRIM(OnlineBackup) AS OnlineBackup,
    TRIM(DeviceProtection) AS DeviceProtection,
    TRIM(TechSupport) AS TechSupport,
    TRIM(StreamingTV) AS StreamingTV,
    TRIM(StreamingMovies) AS StreamingMovies,
    TRIM(Contract) AS Contract,
    TRIM(PaperlessBilling) AS PaperlessBilling,
    TRIM(PaymentMethod) AS PaymentMethod,
    CAST(MonthlyCharges AS DECIMAL(10,2)) AS monthly_charges,
    ROUND(CAST(MonthlyCharges AS DECIMAL(10,2)) * CAST(tenure AS UNSIGNED),2) AS total_charges,
    TRIM(Churn) AS churn

FROM customerchurn_raw;
SELECT * FROM Churn;

-- ===================================================================================================
-- Step 4: Clean Table 2 - Telecom Customer Churn
-- ===================================================================================================
CREATE TABLE telecom_customer_churn AS
SELECT
    TRIM(`Customer ID`) AS customer_id,
    TRIM(`Gender`) AS gender,

    CAST(`Age` AS UNSIGNED) AS Age,
    TRIM(`Married`) AS Married,
    CAST(`Number of Dependents` AS UNSIGNED) AS Number_of_Dependents,

    TRIM(`City`) AS City,
    CAST(`Zip Code` AS UNSIGNED) AS Zip_Code,

    CAST(`Latitude` AS DECIMAL(10,6)) AS Latitude,
    CAST(`Longitude` AS DECIMAL(10,6)) AS Longitude,

    CAST(`Number of Referrals` AS UNSIGNED) AS Number_of_Referrals,
    CAST(`Tenure in Months` AS UNSIGNED) AS tenure,

    TRIM(`Offer`) AS Offer,

    TRIM(`Phone Service`) AS Phone_Service,

    CASE
        WHEN TRIM(`Phone Service`) = 'No' THEN 0
        ELSE CAST(NULLIF(TRIM(`Avg Monthly Long Distance Charges`), '') AS DECIMAL(10,2))
    END AS Avg_Monthly_Long_Distance_Charges,

    CASE
        WHEN TRIM(`Phone Service`) = 'No' THEN 'No phone service'
        ELSE TRIM(`Multiple Lines`)
    END AS Multiple_Lines,

    TRIM(`Internet Service`) AS Internet_Service,

    CASE
        WHEN TRIM(`Internet Service`) = 'No' THEN 'No internet'
        ELSE TRIM(`Internet Type`)
    END AS Internet_Type,

    CASE
        WHEN TRIM(`Internet Service`) = 'No'
             OR TRIM(`Internet Type`) = 'No internet'
        THEN 0
        ELSE CAST(NULLIF(TRIM(`Avg Monthly GB Download`), '') AS UNSIGNED)
    END AS Avg_Monthly_GB_Download,

    CASE WHEN TRIM(`Internet Service`) = 'No' THEN 'No internet service' ELSE TRIM(`Online Security`) END AS Online_Security,
    CASE WHEN TRIM(`Internet Service`) = 'No' THEN 'No internet service' ELSE TRIM(`Online Backup`) END AS Online_Backup,
    CASE WHEN TRIM(`Internet Service`) = 'No' THEN 'No internet service' ELSE TRIM(`Device Protection Plan`) END AS Device_Protection,
    CASE WHEN TRIM(`Internet Service`) = 'No' THEN 'No internet service' ELSE TRIM(`Premium Tech Support`) END AS Premium_Tech_Support,
    CASE WHEN TRIM(`Internet Service`) = 'No' THEN 'No internet service' ELSE TRIM(`Streaming TV`) END AS Streaming_TV,
    CASE WHEN TRIM(`Internet Service`) = 'No' THEN 'No internet service' ELSE TRIM(`Streaming Movies`) END AS Streaming_Movies,
    CASE WHEN TRIM(`Internet Service`) = 'No' THEN 'No internet service' ELSE TRIM(`Streaming Music`) END AS Streaming_Music,
    CASE WHEN TRIM(`Internet Service`) = 'No' THEN 'No internet service' ELSE TRIM(`Unlimited Data`) END AS Unlimited_Data,

    TRIM(`Contract`) AS Contract,
    TRIM(`Paperless Billing`) AS Paperless_Billing,
    TRIM(`Payment Method`) AS Payment_Method,

    CAST(`Monthly Charge` AS DECIMAL(10,2)) AS monthly_charges,
    CAST(`Total Charges` AS DECIMAL(10,2)) AS total_charges,

    CAST(`Total Refunds` AS DECIMAL(10,2)) AS Total_Refunds,
    CAST(`Total Extra Data Charges` AS DECIMAL(10,2)) AS Total_Extra_Data_Charges,
    CAST(`Total Long Distance Charges` AS DECIMAL(10,2)) AS Total_Long_Distance_Charges,
    CAST(`Total Revenue` AS DECIMAL(10,2)) AS Total_Revenue,

    CASE
        WHEN TRIM(`Customer Status`) IN ('Stayed', 'Joined') THEN 'No'
        ELSE 'Yes'
    END AS churn,

    CASE
        WHEN TRIM(`Customer Status`) IN ('Stayed', 'Joined') THEN 'No churn'
        ELSE COALESCE(NULLIF(TRIM(`Churn Category`), ''), 'Unknown')
    END AS Churn_Category,

    CASE
        WHEN TRIM(`Customer Status`) IN ('Stayed', 'Joined') THEN 'No churn'
        ELSE COALESCE(NULLIF(TRIM(`Churn Reason`), ''), 'Unknown')
    END AS Churn_Reason

FROM telecom_customer_churn_raw;

SELECT * FROM telecom_customer_churn;

-- ===================================================================================================
-- Step 5: Create Table Telecom Merged 
-- ===================================================================================================
CREATE TABLE telecom_merged AS
SELECT
    t.customer_id,
    t.gender,
    t.Age,
    t.Married,
    t.Number_of_Dependents,
    t.City,
    t.Zip_Code,
    t.Latitude,
    t.Longitude,
    t.Number_of_Referrals,
    t.tenure,
    t.Offer,
    t.Phone_Service,
    t.Avg_Monthly_Long_Distance_Charges,
    t.Multiple_Lines,
    t.Internet_Service,
    t.Internet_Type,
    t.Avg_Monthly_GB_Download,
    t.Online_Security,
    t.Online_Backup,
    t.Device_Protection,
    t.Premium_Tech_Support,
    t.Streaming_TV,
    t.Streaming_Movies,
    t.Streaming_Music,
    t.Unlimited_Data,
    t.Contract,
    t.Paperless_Billing,
    t.Payment_Method,
    c.monthly_charges,

    ROUND(c.monthly_charges * t.tenure, 2) AS total_charges,

    t.Total_Extra_Data_Charges,
    t.Total_Long_Distance_Charges,
    t.Total_Refunds,

    ROUND(
        (c.monthly_charges * t.tenure)
        + t.Total_Extra_Data_Charges
        + t.Total_Long_Distance_Charges
        - t.Total_Refunds,
    2) AS Total_Revenue,

    t.churn,
    t.Churn_Category,
    t.Churn_Reason,
    c.SeniorCitizen

FROM telecom_customer_churn t
LEFT JOIN Churn c
ON t.customer_id = c.customer_id;

SELECT * FROM telecom_merged;

-- =====================================================================================================
-- Step 6: Create Table Dim_City
-- =====================================================================================================
CREATE TABLE Dim_City (
    City_Key INT AUTO_INCREMENT PRIMARY KEY,
    City VARCHAR(100),
    Zip_Code VARCHAR(20),
    Latitude DECIMAL(10,6),
    Longitude DECIMAL(10,6)
);
INSERT INTO Dim_City (City, Zip_Code, Latitude, Longitude)
SELECT DISTINCT
    City, Zip_Code, Latitude, Longitude
FROM telecom_merged;

SELECT * FROM Dim_City;

-- =====================================================================================================
-- Step 7: Create Table Dim_Contract
-- =====================================================================================================
CREATE TABLE Dim_Contract (
    Contract_Key INT AUTO_INCREMENT PRIMARY KEY,
    Contract VARCHAR(50),
    Payment_Method VARCHAR(50),
    Paperless_Billing VARCHAR(10),
    Offer VARCHAR(50)
);
INSERT INTO Dim_Contract (Contract, Payment_Method, Paperless_Billing, Offer)
SELECT DISTINCT
    Contract, Payment_Method, Paperless_Billing, Offer
FROM telecom_merged;

SELECT * FROM Dim_Contract;
-- =====================================================================================================
-- Step 8: Create Table Dim_Services
-- =====================================================================================================
CREATE TABLE Dim_Services (
Services_Key INT AUTO_INCREMENT PRIMARY KEY,
Phone_Service VARCHAR(20),
Internet_Service VARCHAR(20),
Multiple_Lines VARCHAR(50),
Internet_Type VARCHAR(50),
Online_Security VARCHAR(20),
Online_Backup VARCHAR(20),
Device_Protection VARCHAR(20),
Premium_Tech_Support VARCHAR(20),
Streaming_TV VARCHAR(20),
Streaming_Movies VARCHAR(20),
Streaming_Music VARCHAR(20),
Unlimited_Data VARCHAR(20)
);
INSERT INTO Dim_Services ( Phone_Service,
Internet_Service,
Multiple_Lines,
Internet_Type,
Online_Security,
Online_Backup,
Device_Protection,
Premium_Tech_Support,
Streaming_TV,
Streaming_Movies,
Streaming_Music,
Unlimited_Data
)

SELECT DISTINCT
Phone_Service,
Internet_Service,
Multiple_Lines,
Internet_Type,
Online_Security,
Online_Backup,
Device_Protection,
Premium_Tech_Support,
Streaming_TV,
Streaming_Movies,
Streaming_Music,
Unlimited_Data
FROM telecom_merged;

SELECT * FROM Dim_Services;

-- =====================================================================================================
-- Step 9: Create Table Dim_Churn
-- =====================================================================================================
CREATE TABLE Dim_Churn (
    churn_key INT AUTO_INCREMENT PRIMARY KEY,
    Churn_Category VARCHAR(50),
    Churn_Reason TEXT
);
INSERT INTO Dim_Churn (Churn_Category, Churn_Reason)
SELECT DISTINCT
    Churn_Category, Churn_Reason
FROM telecom_merged;

SELECT * FROM Dim_Churn;

-- =====================================================================================================
-- Step 10: Create Table Dim_Customer
-- =====================================================================================================
CREATE TABLE Dim_Customer (
    customer_id VARCHAR(50) PRIMARY KEY,
    gender VARCHAR(10),
    SeniorCitizen INT,
    Age INT,
    Married VARCHAR(10),
    Number_of_Dependents INT
);
INSERT INTO Dim_Customer
SELECT DISTINCT
    customer_id,
    gender,
    SeniorCitizen,
    Age,
    Married,
    Number_of_Dependents
FROM telecom_merged;

SELECT * FROM Dim_Customer;

-- =====================================================================================================
-- Step 11: Create Table Fact_Telecom_Company
-- =====================================================================================================
CREATE TABLE Fact_Telecom_Company(
    customer_id VARCHAR(50),
    City_Key INT,
    Contract_Key INT,
    Services_Key INT,
    churn_key INT,
    tenure INT,
    Tenure_Group VARCHAR(50),
    monthly_charges DECIMAL(10,2),
    total_charges DECIMAL(10,2),
    Total_Revenue DECIMAL(10,2),
  Avg_Monthly_Long_Distance_Charges DECIMAL(10,2),
  Avg_Monthly_GB_Download DECIMAL(10,2),
  Total_Extra_Data_Charges DECIMAL(10,2),
  Total_Long_Distance_Charges DECIMAL(10,2),
   Total_Refunds DECIMAL(10,2),
    Number_of_Referrals INT,
    Churn VARCHAR(50)
);
-- =====================================================================================================
ALTER TABLE telecom_merged
ADD COLUMN Tenure_Group VARCHAR(20);

SET SQL_SAFE_UPDATES = 0;
UPDATE telecom_merged
SET Tenure_Group = 
CASE
    WHEN tenure BETWEEN 0 AND 12 THEN '0-12 months'
    WHEN tenure BETWEEN 13 AND 24 THEN '13-24 months'
    WHEN tenure BETWEEN 25 AND 48 THEN '25-48 months'
    WHEN tenure BETWEEN 49 AND 72 THEN '49-72 months'
    ELSE 'Unknown'
END;
-- =====================================================================================================

INSERT INTO Fact_Telecom_Company
SELECT 
m.customer_id,
c.City_Key,
ct.Contract_Key,
s.Services_Key,
ch.churn_key,
m.tenure,
m.Tenure_Group,
m.monthly_charges, 
m.total_charges ,
m.Total_Revenue,
m.Avg_Monthly_Long_Distance_Charges,
m.Avg_Monthly_GB_Download,
m.Total_Extra_Data_Charges,
m.Total_Long_Distance_Charges,
m.Total_Refunds,
m.Number_of_Referrals,
m.Churn
FROM telecom_merged m

LEFT JOIN Dim_City c
ON m.City = c.City 
AND m.Zip_Code = c.Zip_Code
AND m. Latitude = c. Latitude
AND m. Longitude = c. Longitude	

-- Contract
LEFT JOIN Dim_Contract ct
ON m.Contract = ct.Contract
AND m.Payment_Method = ct.Payment_Method
AND m.Paperless_Billing = ct.Paperless_Billing
AND m.Offer = ct.Offer

-- Services 
LEFT JOIN Dim_Services s
ON m.Phone_Service = s.Phone_Service
AND m.Internet_Service = s.Internet_Service
AND m.Multiple_Lines = s.Multiple_Lines
AND m.Internet_Type = s.Internet_Type
AND m.Online_Security = s.Online_Security
AND m.Online_Backup = s.Online_Backup
AND m.Device_Protection = s.Device_Protection
AND m.Premium_Tech_Support = s.Premium_Tech_Support
AND m.Streaming_TV = s.Streaming_TV
AND m.Streaming_Movies = s.Streaming_Movies
AND m.Streaming_Music = s.Streaming_Music
AND m.Unlimited_Data = s.Unlimited_Data

-- Churn
LEFT JOIN Dim_Churn ch
ON m.Churn_Category = ch.Churn_Category
AND m.Churn_Reason = ch.Churn_Reason;

-- FOREIGN KEYS

ALTER TABLE Fact_Telecom_Company
ADD FOREIGN KEY (City_Key) REFERENCES Dim_City(City_Key);

ALTER TABLE Fact_Telecom_Company
ADD FOREIGN KEY (Contract_Key) REFERENCES Dim_Contract(Contract_Key);

ALTER TABLE Fact_Telecom_Company
ADD FOREIGN KEY (Services_Key) REFERENCES Dim_Services(Services_Key);

ALTER TABLE Fact_Telecom_Company
ADD FOREIGN KEY (churn_key) REFERENCES Dim_Churn(churn_key);

ALTER TABLE Fact_Telecom_Company
ADD FOREIGN KEY (customer_id) REFERENCES Dim_Customer(customer_id);

SELECT * FROM fact_telecom_company;

-- =====================================================================================================
-- Top 5 Cities by Churn Count
SELECT 
 Dim_City.City,
 COUNT(*) AS Churn_Count
FROM Fact_Telecom_Company
JOIN Dim_City ON Fact_Telecom_Company.City_Key = 
Dim_City.City_Key
JOIN Dim_Churn ON Fact_Telecom_Company.Churn_key = 
Dim_Churn.Churn_key
WHERE Fact_Telecom_Company.Churn = 'Yes'
GROUP BY Dim_City.City
ORDER BY Churn_Count DESC
LIMIT 5;

-- =====================================================================================================
-- Churn Rate by Tenure Bucket
SELECT 
 CASE 
 WHEN Fact_Telecom_Company.Tenure <= 12 THEN '0-12 
months'
 WHEN Fact_Telecom_Company.Tenure <= 24 THEN '13-24 
months'
 WHEN Fact_Telecom_Company.Tenure <= 48 THEN '25-48 
months'
 ELSE '49-72 months'
 END AS Tenure_Bucket,
 ROUND(100.0 * SUM(CASE WHEN Fact_Telecom_Company.Churn  = 
'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS Churn_Rate
FROM Fact_Telecom_Company
JOIN Dim_Churn ON Fact_Telecom_Company.Churn_key = 
Dim_Churn.Churn_key
GROUP BY Tenure_Bucket
ORDER BY Tenure_Bucket;

-- =====================================================================================================
-- Churn by Contract
SELECT 
 Dim_Contract.Contract,
 ROUND(100.0 * SUM(CASE WHEN Fact_Telecom_Company.Churn = 
'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS Churn_Rate
FROM Fact_Telecom_Company
JOIN Dim_Contract ON Fact_Telecom_Company.Contract_key  = 
Dim_Contract.Contract_key 
JOIN Dim_Churn ON Fact_Telecom_Company.Churn_key  = 
Dim_Churn.Churn_key 
GROUP BY Dim_Contract.Contract;
-- =====================================================================================================
-- Top 5 Churn Reasons
SELECT 
 Dim_Churn.Churn_Reason,
 COUNT(*) AS Reason_Count
FROM Fact_Telecom_Company
JOIN Dim_Churn ON Fact_Telecom_Company.Churn_key = 
Dim_Churn.Churn_key
WHERE Fact_Telecom_Company.Churn = 'Yes'
GROUP BY Dim_Churn.Churn_Reason
ORDER BY Reason_Count DESC
LIMIT 5;
-- =====================================================================================================
-- Count of Total Revenue Category—
SELECT 
 Dim_Churn.Churn_Category,
 COUNT(*) AS Category_Count
FROM Fact_Telecom_Company
JOIN Dim_Churn ON Fact_Telecom_Company.Churn_key = 
Dim_Churn.Churn_key
GROUP BY Dim_Churn.Churn_Category;
-- =====================================================================================================
-- Avg Revenue by Married Status
SELECT 
 Dim_Customer.Married,
 ROUND(AVG(Fact_Telecom_Company.Total_Revenue), 2) AS Avg_Revenue
FROM Fact_Telecom_Company
JOIN Dim_Customer 
ON Fact_Telecom_Company.customer_id = Dim_Customer.customer_id
GROUP BY Dim_Customer.Married;
-- =====================================================================================================
-- Revenue Lost by Churn Category—
SELECT 
 Dim_Churn.Churn_Category,
 SUM(Fact_Telecom_Company.Total_Charges) AS Revenue_Lost
FROM Fact_Telecom_Company
JOIN Dim_Churn ON Fact_Telecom_Company.Churn_key = 
Dim_Churn.Churn_key
WHERE Fact_Telecom_Company.Churn = 'Yes'
GROUP BY Dim_Churn.Churn_Category;
-- =====================================================================================================
-- Revenue by Payment Method—
SELECT 
Dim_Contract.Payment_Method,
CASE 
    WHEN SUM(Fact_Telecom_Company.Total_Revenue) >= 1000000 
        THEN CONCAT(ROUND(SUM(Fact_Telecom_Company.Total_Revenue)/1000000,2), ' M')
	
    WHEN SUM(Fact_Telecom_Company.Total_Revenue) >= 1000 
        THEN CONCAT(ROUND(SUM(Fact_Telecom_Company.Total_Revenue)/1000,2), ' K')
        
    ELSE FORMAT(SUM(Fact_Telecom_Company.Total_Revenue),2)
END AS Total_Revenue
FROM Fact_Telecom_Company
JOIN Dim_Contract 
ON Fact_Telecom_Company.Contract_Key = Dim_Contract.Contract_Key
GROUP BY Dim_Contract.Payment_Method;
-- =====================================================================================================
-- Churn Rate Analysis by Age Group
SELECT 
 CASE 
 WHEN Dim_Customer.Age <= 30 THEN '18-30'
 WHEN Dim_Customer.Age <= 45 THEN '31-45'
 WHEN Dim_Customer.Age <= 60 THEN '46-60'
 ELSE '60+'
 END AS Age_Group,
 ROUND(100.0 * SUM(CASE WHEN Fact_Telecom_Company.Churn = 
'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS Churn_Rate
FROM Fact_Telecom_Company
JOIN Dim_Churn ON Fact_Telecom_Company.Churn_key = Dim_Churn.Churn_key
JOIN Dim_Customer ON Fact_Telecom_Company.customer_id = Dim_Customer.customer_id
GROUP BY Age_Group
ORDER BY Age_Group;
-- =====================================================================================================
-- Churn Rate: Senior vs Non-Senior
SELECT 
 Dim_Customer.SeniorCitizen,
 ROUND(100.0 * SUM(CASE WHEN Fact_Telecom_Company.Churn = 
'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS Churn_Rate
FROM Fact_Telecom_Company
JOIN Dim_Churn ON Fact_Telecom_Company.Churn_key = Dim_Churn.Churn_key
JOIN Dim_Customer ON Fact_Telecom_Company.customer_id = Dim_Customer.customer_id
GROUP BY Dim_Customer.SeniorCitizen;
-- =====================================================================================================
-- Tech Support Requested by Internet Type
SELECT 
 Dim_Services.Internet_Service,
 SUM(CASE WHEN Dim_Services.Premium_Tech_Support = 'Yes' THEN 1 
ELSE 0 END) AS Tech_Support_Yes,
 SUM(CASE WHEN Dim_Services.Premium_Tech_Support = 'No' THEN 1 
ELSE 0 END) AS Tech_Support_No
FROM Fact_Telecom_Company
JOIN Dim_Services ON Fact_Telecom_Company.Services_key = 
Dim_Services.Services_key
GROUP BY Dim_Services.Internet_Service;
-- =====================================================================================================
-- Customer Churn Distribution by Category
SELECT 
Dim_Churn.Churn_Category,
COUNT(Fact_Telecom_Company.customer_id) AS Customer_Count
FROM Fact_Telecom_Company
JOIN Dim_Churn 
ON Fact_Telecom_Company.Churn_key = Dim_Churn.Churn_key
WHERE Fact_Telecom_Company.Churn = 'Yes'
GROUP BY Dim_Churn.Churn_Category
ORDER BY Customer_Count DESC;
-- =====================================================================================================
-- Customer Preference for Payment Method
SELECT 
Dim_Contract.Payment_Method,
COUNT(DISTINCT Fact_Telecom_Company.customer_id) AS Customer_Count
FROM Fact_Telecom_Company
JOIN Dim_Contract 
ON Fact_Telecom_Company.Contract_Key = Dim_Contract.Contract_Key
GROUP BY Dim_Contract.Payment_Method
ORDER BY Customer_Count DESC;
-- =====================================================================================================
-- Revenue by Contract Duration
SELECT 
Dim_Contract.Contract,
CONCAT(ROUND(SUM(Fact_Telecom_Company.Total_Revenue)/1000000,2),' M') AS Total_Revenue
FROM Fact_Telecom_Company
JOIN Dim_Contract 
ON Fact_Telecom_Company.Contract_Key = Dim_Contract.Contract_Key
GROUP BY Dim_Contract.Contract
ORDER BY SUM(Fact_Telecom_Company.Total_Revenue) DESC;
-- =====================================================================================================
-- KPIs
-- Total Customers—
SELECT COUNT(*) AS Total_Customers 
FROM Fact_Telecom_Company;
-- Churn Rate %—
SELECT 
 ROUND(100.0 * SUM(CASE WHEN Fact_Telecom_Company.Churn = 
'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS 
Churn_Rate_Percentage
FROM Fact_Telecom_Company
JOIN Dim_Churn ON Fact_Telecom_Company.Churn_key = 
Dim_Churn.Churn_key;

-- Total Churned—
SELECT COUNT(*) AS Total_Churned
FROM Fact_Telecom_Company
JOIN Dim_Churn ON Fact_Telecom_Company.Churn_Key = 
Dim_Churn.Churn_Key
WHERE Fact_Telecom_Company.Churn = 'Yes';
-- Revenue Loss—
SELECT 
CONCAT(ROUND(SUM(Total_Revenue)/1000000, 2), ' M') AS Revenue_Lost
FROM Fact_Telecom_Company
JOIN Dim_Churn 
ON Fact_Telecom_Company.Churn_Key = Dim_Churn.Churn_Key
WHERE Fact_Telecom_Company.Churn = 'Yes';

-- Total Revenue—
SELECT SUM(Total_Revenue) AS Total_Revenue 
FROM Fact_Telecom_Company;

-- Avg Revenue Married—-
SELECT ROUND(AVG(Fact_Telecom_Company.Total_Revenue), 2) AS Avg_Revenue_Married
FROM Fact_Telecom_Company
JOIN Dim_Customer 
ON Fact_Telecom_Company.customer_id = Dim_Customer.customer_id
WHERE Dim_Customer.Married = 'Yes';

-- Senior Churn Rate ——
SELECT 
 ROUND(100.0 * SUM(CASE WHEN Fact_Telecom_Company.Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 
 2) AS Senior_Churn_Rate
FROM Fact_Telecom_Company
JOIN Dim_Churn 
ON Fact_Telecom_Company.Churn_Key = Dim_Churn.Churn_Key
JOIN Dim_Customer
ON Fact_Telecom_Company.customer_id = Dim_Customer.customer_id
WHERE Dim_Customer.SeniorCitizen = 1;

-- Fiber Optic Churned
SELECT 
    SUM(CASE WHEN Dim_Services.Premium_Tech_Support = 'Yes' THEN 1 ELSE 0 END) AS Fiber_Yes
FROM Fact_Telecom_Company
JOIN Dim_Services 
ON Fact_Telecom_Company.Services_Key = Dim_Services.Services_Key
WHERE Dim_Services.Internet_Type = 'Fiber Optic';

-- =====================================================================================================
-- Descriptive Stat
-- monthly_charges
SELECT
    ROUND(AVG(monthly_charges), 2) AS Mean,
    ROUND(STDDEV(monthly_charges), 2) AS Std_Dev,
    ROUND(VARIANCE(monthly_charges), 2) AS Variance,
    ROUND(MIN(monthly_charges), 2) AS Minimum,
    ROUND(MAX(monthly_charges), 2) AS Maximum,
    ROUND(MAX(monthly_charges) - MIN(monthly_charges), 2) AS `Range`,
    COUNT(*) AS `Count`,
    ROUND(SUM(monthly_charges), 2) AS `Sum`
FROM Fact_Telecom_Company;
-- tenure
SELECT
    ROUND(AVG(tenure), 2) AS Mean,
    ROUND(STDDEV(tenure), 2) AS Std_Dev,
    ROUND(VARIANCE(tenure), 2) AS Variance,
    MIN(tenure) AS Minimum,
    MAX(tenure) AS Maximum,
    (MAX(tenure) - MIN(tenure)) AS `Range`,
    COUNT(*) AS `Count`,
    SUM(tenure) AS `Sum`
FROM Fact_Telecom_Company;

-- Median monthly_charges
SELECT ROUND(AVG(monthly_charges), 2) AS Median_monthly_charges
FROM (
    SELECT monthly_charges,
           ROW_NUMBER() OVER (ORDER BY monthly_charges) AS rn,
           COUNT(*) OVER () AS total
    FROM fact_telecom_company
) t
WHERE rn IN (FLOOR((total+1)/2), CEIL((total+1)/2));

-- Median tenure
SELECT ROUND(AVG(tenure), 0) AS Median_tenure
FROM (
    SELECT tenure,
           ROW_NUMBER() OVER (ORDER BY tenure) AS rn,
           COUNT(*) OVER () AS total
    FROM fact_telecom_company
) t
WHERE rn IN (FLOOR((total+1)/2), CEIL((total+1)/2));

-- Quartiles tenure (Q1=9, Q2=29, Q3=55, IQR=46)
SELECT
    ROUND(AVG(CASE WHEN rn BETWEEN FLOOR(total*0.25) AND CEIL(total*0.25) THEN tenure END), 0) AS Q1,
    ROUND(AVG(CASE WHEN rn BETWEEN FLOOR(total*0.50) AND CEIL(total*0.50) THEN tenure END), 0) AS Q2_Median,
    ROUND(AVG(CASE WHEN rn BETWEEN FLOOR(total*0.75) AND CEIL(total*0.75) THEN tenure END), 0) AS Q3,
    ROUND(AVG(CASE WHEN rn BETWEEN FLOOR(total*0.75) AND CEIL(total*0.75) THEN tenure END), 0) -
    ROUND(AVG(CASE WHEN rn BETWEEN FLOOR(total*0.25) AND CEIL(total*0.25) THEN tenure END), 0) AS IQR
FROM (
    SELECT tenure,
           ROW_NUMBER() OVER (ORDER BY tenure) AS rn,
           COUNT(*) OVER () AS total
    FROM fact_telecom_company
) t;

-- Quartiles monthly_charges (Q1=35.5, Q2=70.35, Q3=89.85, IQR=54.35)
SELECT
    ROUND(AVG(CASE WHEN rn BETWEEN FLOOR(total*0.25) AND CEIL(total*0.25) THEN monthly_charges END), 2) AS Q1,
    ROUND(AVG(CASE WHEN rn BETWEEN FLOOR(total*0.50) AND CEIL(total*0.50) THEN monthly_charges END), 2) AS Q2_Median,
    ROUND(AVG(CASE WHEN rn BETWEEN FLOOR(total*0.75) AND CEIL(total*0.75) THEN monthly_charges END), 2) AS Q3,
    ROUND(AVG(CASE WHEN rn BETWEEN FLOOR(total*0.75) AND CEIL(total*0.75) THEN monthly_charges END), 2) -
    ROUND(AVG(CASE WHEN rn BETWEEN FLOOR(total*0.25) AND CEIL(total*0.25) THEN monthly_charges END), 2) AS IQR
FROM (
    SELECT monthly_charges,
           ROW_NUMBER() OVER (ORDER BY monthly_charges) AS rn,
           COUNT(*) OVER () AS total
    FROM fact_telecom_company
) t;

-- Correlation monthly_charges vs tenure (0.2476)
SELECT ROUND(
    (COUNT(*) * SUM(monthly_charges * tenure) - SUM(monthly_charges) * SUM(tenure))
    / SQRT(
        (COUNT(*) * SUM(monthly_charges*monthly_charges) - POW(SUM(monthly_charges),2)) *
        (COUNT(*) * SUM(tenure*tenure) - POW(SUM(tenure),2))
    )
, 4) AS Corr_Charges_Tenure
FROM fact_telecom_company;

-- Correlation referrals vs tenure (0.3270)
SELECT ROUND(
    (COUNT(*) * SUM(Number_of_Referrals * tenure) - SUM(Number_of_Referrals) * SUM(tenure))
    / SQRT(
        (COUNT(*) * SUM(Number_of_Referrals*Number_of_Referrals) - POW(SUM(Number_of_Referrals),2)) *
        (COUNT(*) * SUM(tenure*tenure) - POW(SUM(tenure),2))
    )
, 4) AS Corr_Referrals_Tenure
FROM fact_telecom_company;

-- =====================================================================================================
-- inferntial Stat (chi square)
-- Senior vs Churn
SELECT
    CASE WHEN dc.SeniorCitizen = 0 THEN 'Non-Senior' ELSE 'Senior' END AS Group_Name,
    f.Churn,
    COUNT(*) AS Observed,
    ROUND(
        SUM(COUNT(*)) OVER (PARTITION BY dc.SeniorCitizen)
        * SUM(COUNT(*)) OVER (PARTITION BY f.Churn)
        / SUM(COUNT(*)) OVER ()
    , 2) AS Expected
FROM fact_telecom_company f
JOIN dim_customer dc ON f.customer_id = dc.customer_id
GROUP BY dc.SeniorCitizen, f.Churn
ORDER BY dc.SeniorCitizen, f.Churn;

-- Gender vs Churn
SELECT
    dc.gender,
    f.Churn,
    COUNT(*) AS Observed,
    ROUND(
        SUM(COUNT(*)) OVER (PARTITION BY dc.gender)
        * SUM(COUNT(*)) OVER (PARTITION BY f.Churn)
        / SUM(COUNT(*)) OVER ()
    , 2) AS Expected
FROM fact_telecom_company f
JOIN dim_customer dc ON f.customer_id = dc.customer_id
GROUP BY dc.gender, f.Churn
ORDER BY dc.gender, f.Churn;

-- Married vs Churn
SELECT
    dc.Married,
    f.Churn,
    COUNT(*) AS Observed,
    ROUND(
        SUM(COUNT(*)) OVER (PARTITION BY dc.Married)
        * SUM(COUNT(*)) OVER (PARTITION BY f.Churn)
        / SUM(COUNT(*)) OVER ()
    , 2) AS Expected
FROM fact_telecom_company f
JOIN dim_customer dc ON f.customer_id = dc.customer_id
GROUP BY dc.Married, f.Churn
ORDER BY dc.Married, f.Churn;

-- Contract vs Churn
SELECT
    ct.Contract,
    f.Churn,
    COUNT(*) AS Observed,
    ROUND(
        SUM(COUNT(*)) OVER (PARTITION BY ct.Contract)
        * SUM(COUNT(*)) OVER (PARTITION BY f.Churn)
        / SUM(COUNT(*)) OVER ()
    , 2) AS Expected
FROM fact_telecom_company f
JOIN dim_contract ct ON f.Contract_Key = ct.Contract_Key
GROUP BY ct.Contract, f.Churn
ORDER BY ct.Contract, f.Churn;
-- =====================================================================================================
-- t test
-- Group Stats
SELECT
    Churn,
    COUNT(*)                             AS N,
    ROUND(AVG(monthly_charges), 2)       AS Mean_Charges,
    ROUND(VARIANCE(monthly_charges), 2)  AS Variance_Charges,
    ROUND(AVG(tenure), 2)                AS Mean_Tenure,
    ROUND(VARIANCE(tenure), 2)           AS Variance_Tenure
FROM fact_telecom_company
GROUP BY Churn;

-- t-statistic monthly_charges (النتيجة: 18.41)
WITH stats AS (
    SELECT 
        churn,
        COUNT(*) AS n,
        AVG(monthly_charges) AS mean,
        VARIANCE(monthly_charges) AS var
    FROM fact_telecom_company 
    GROUP BY churn
)
SELECT ROUND(
    (MAX(CASE WHEN churn='Yes' THEN mean END) - MAX(CASE WHEN churn='No' THEN mean END))
    / SQRT(MAX(CASE WHEN churn='Yes' THEN var/n END) + MAX(CASE WHEN churn='No' THEN var/n END))
, 3) AS t_stat_monthly_charges
FROM stats;

-- t-statistic tenure (النتيجة: -34.88)
WITH stats AS (
    SELECT 
        churn, 
        COUNT(*) AS n,
        AVG(tenure) AS mean,
        VARIANCE(tenure) AS var
    FROM fact_telecom_company 
    GROUP BY churn
)
SELECT ROUND(
    (MAX(CASE WHEN churn = 'Yes' THEN mean END) - MAX(CASE WHEN churn = 'No' THEN mean END))
    / SQRT(
        MAX(CASE WHEN churn = 'Yes' THEN var / n END) 
        + MAX(CASE WHEN churn = 'No' THEN var / n END)
    )
, 3) AS t_stat_tenure
FROM stats;
-- =====================================================================================================
-- ANOVA test
-- Group Summary (Month-to-Month: 66.40, One Year: 65.05, Two Year: 60.77)
SELECT
    c.Contract,
    COUNT(*)                              AS Count,
    ROUND(AVG(c.monthly_charges), 2)      AS Average,
    ROUND(VARIANCE(c.monthly_charges), 2) AS Variance
FROM churn c
GROUP BY c.Contract;

-- F-Statistic
WITH grp AS (
    SELECT c.Contract, COUNT(*) AS n, AVG(c.monthly_charges) AS gm
    FROM churn c
    GROUP BY c.Contract
),
grand AS (SELECT AVG(monthly_charges) AS gm FROM churn),
ssb AS (
    SELECT SUM(g.n * POW(g.gm - gr.gm, 2)) AS SSB, COUNT(*)-1 AS dfB
    FROM grp g, grand gr
),
ssw AS (
    SELECT SUM(POW(c.monthly_charges - gs.gm, 2)) AS SSW, COUNT(*)-3 AS dfW
    FROM churn c
    JOIN grp gs ON c.Contract = gs.Contract
)
SELECT
    ROUND(SSB/dfB, 2)              AS MS_Between,
    ROUND(SSW/dfW, 2)              AS MS_Within,
    ROUND((SSB/dfB)/(SSW/dfW), 3) AS F_Statistic,
    ROUND(SSB+SSW, 2)              AS SS_Total
FROM ssb, ssw;
-- =====================================================================================================
-- Correlations (Referrals: -0.257, Tenure: -0.357, Charges: +0.193)
SELECT
    ROUND(
        (COUNT(*) * SUM(cn * Number_of_Referrals) - SUM(cn) * SUM(Number_of_Referrals))
        / SQRT(
            (COUNT(*) * SUM(cn*cn) - POW(SUM(cn),2)) *
            (COUNT(*) * SUM(Number_of_Referrals*Number_of_Referrals) - POW(SUM(Number_of_Referrals),2))
        )
    , 4) AS Corr_Churn_Referrals,
    ROUND(
        (COUNT(*) * SUM(cn * tenure) - SUM(cn) * SUM(tenure))
        / SQRT(
            (COUNT(*) * SUM(cn*cn) - POW(SUM(cn),2)) *
            (COUNT(*) * SUM(tenure*tenure) - POW(SUM(tenure),2))
        )
    , 4) AS Corr_Churn_Tenure,
    ROUND(
        (COUNT(*) * SUM(cn * monthly_charges) - SUM(cn) * SUM(monthly_charges))
        / SQRT(
            (COUNT(*) * SUM(cn*cn) - POW(SUM(cn),2)) *
            (COUNT(*) * SUM(monthly_charges*monthly_charges) - POW(SUM(monthly_charges),2))
        )
    , 4) AS Corr_Churn_Charges
FROM (
    SELECT
        CASE WHEN Churn='Yes' THEN 1 ELSE 0 END AS cn,
        Number_of_Referrals, tenure, monthly_charges
    FROM fact_telecom_company
) t;
