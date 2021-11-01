--Business Questions to Answer

----1. What is the total Revenue of the company this year?
----2. What is the total Revenue Performance YoY?
----3. What is the MoM Revenue Performance?
----4. What is the Total Revenue Vs Target Performance for the Year?
----5. What is the Revenue Vs Target Performance per Month?
----6. What is the best performing product in terms of revenue this year?
----7. What is the product performance Vs Target for the month?
----8. Which account is performing the best in terms of revenue?
----9. Which opportunity has the highest potential and what are the details?
----10. Which account generates the most revenue per marketing spend for this month?

-- Raw Data Tables Description

--1. SELECT * FROM [Montana].[dbo].[Revenue_Raw_Data]
-- This Table has the Revenue by Account ID, By Product & by Month ID

--2. SELECT * FROM [Montana].[dbo].[Marketing_Raw_data]
-- This Table has information about the Marketing Spend per Account ID, Product & Month ID

--3. SELECT * FROM [Montana].[dbo].[Targets_Raw_data]
-- This Table has information about the Targets per Account ID, Product & Month ID

--4. SELECT * FROM [Montana].[dbo].[yt_Opportunities_Data]
-- This Table has information about the Opportunities per Account ID, Product & Month ID

--5. SELECT * FROM [Montana].[dbo].[yt_account_lookup]
-- This Table has additional information about the Accounts (Name, Segments, Managers, etc)

--6. SELECT * FROM [Montana].[dbo].[yt_Calender_lookup]
-- This Table has Calender information


--Visualizing the tables:
SELECT * FROM [Montana].[dbo].[Revenue_Raw_Data]
SELECT * FROM [Montana].[dbo].[Marketing_Raw_data]
SELECT * FROM [Montana].[dbo].[Targets_Raw_data]
SELECT * FROM [Montana].[dbo].[yt_Opportunities_Data]
SELECT * FROM [Montana].[dbo].[yt_account_lookup]
SELECT * FROM [Montana].[dbo].[yt_Calender_lookup]


----1. What is the total Revenue of the company this year? fy21

SELECT * FROM [Montana].[dbo].[Revenue_Raw_Data]

SELECT DISTINCT Month_ID
FROM [Montana].[dbo].[yt_Calender_lookup]
WHERE [Fiscal Year] = 'FY21'


SELECT --Month_ID,
SUM(Revenue) AS Total_Revenue_FY21
FROM [Montana].[dbo].[Revenue_Raw_Data] AS r
WHERE r.Month_ID IN (SELECT DISTINCT Month_ID FROM [Montana].[dbo].[yt_Calender_lookup] WHERE [Fiscal Year] = 'FY21')
--GROUP BY Month_ID

----2. What is the total Revenue Performance YoY?

SELECT a.Total_Revenue_FY21, b.Total_Revenue_FY20, a.Total_Revenue_FY21 - b.Total_Revenue_FY20 AS Dollar_Dif_YoY, a.Total_Revenue_FY21 / b.Total_Revenue_FY20 - 1 AS Perc_Dif_YoY
FROM
	(
	--FY21
	SELECT SUM(Revenue) AS Total_Revenue_FY21
	FROM [Montana].[dbo].[Revenue_Raw_Data]
	WHERE Month_ID IN (SELECT DISTINCT Month_ID FROM [Montana].[dbo].[yt_Calender_lookup] WHERE [Fiscal Year] = 'FY21')
	) a,
	(
	--FY20
	SELECT SUM(Revenue) AS Total_Revenue_FY20
	FROM [Montana].[dbo].[Revenue_Raw_Data]
	WHERE Month_ID IN (SELECT DISTINCT Month_ID - 12 FROM [Montana].[dbo].[Revenue_Raw_Data] WHERE Month_ID IN
	(SELECT DISTINCT Month_ID FROM [Montana].[dbo].[yt_Calender_lookup] WHERE [Fiscal Year] = 'FY21'))
	) b




	----3. What is the MoM Revenue Performance?

SELECT a.Total_Revenue_TM, b.Total_Revenue_LM, a.Total_Revenue_TM - b.Total_Revenue_LM AS MoM_Dollar_Diff, a.Total_Revenue_TM / b.Total_Revenue_LM -1 AS MoM_Perc_Diff
FROM
	(
	--this month
	SELECT --Month_ID,
	SUM(Revenue) AS Total_Revenue_TM
	FROM [Montana].[dbo].[Revenue_Raw_Data]
	WHERE Month_ID IN (SELECT MAX(Month_ID) FROM [Montana].[dbo].[Revenue_Raw_Data])
	--GROUP BY Month_ID
	) a,

	(
	-- this LAST month
	SELECT --Month_ID,
	SUM(Revenue) AS Total_Revenue_LM
	FROM [Montana].[dbo].[Revenue_Raw_Data]
	WHERE Month_ID IN (SELECT MAX(Month_ID)-1 FROM [Montana].[dbo].[Revenue_Raw_Data])
	--GROUP BY Month_ID
	) b


----4. What is the Total Revenue Vs Target Performance for the Year?


SELECT Total_Revenue_FY21, Target_FY21, Total_Revenue_FY21 - Target_FY21 AS Dollar_Dif, Total_Revenue_FY21 / Target_FY21 - 1 AS Perc_Diff
FROM
	(
	--rev fy21
	SELECT --Month_ID,
	SUM(Revenue) AS Total_Revenue_FY21
	FROM [Montana].[dbo].[Revenue_Raw_Data] AS r
	WHERE r.Month_ID IN (SELECT DISTINCT Month_ID FROM [Montana].[dbo].[yt_Calender_lookup] WHERE [Fiscal Year] = 'FY21')
	--GROUP BY Month_ID
	) a,
	(
	SELECT SUM(Target) AS Target_FY21
	FROM [Montana].[dbo].[Targets_Raw_data]
	WHERE Month_ID IN (SELECT DISTINCT Month_ID FROM [Montana].[dbo].[Revenue_Raw_Data] WHERE Month_ID IN
	(SELECT DISTINCT Month_ID FROM [Montana].[dbo].[yt_Calender_lookup] WHERE [Fiscal Year] = 'FY21'))
	) b



----5. What is the Revenue Vs Target Performance per Month?


SELECT a.Month_ID, [Fiscal Month] Total_Revenue_FY21, Target_FY21, Total_Revenue_FY21 - Target_FY21 AS Dollar_Dif, Total_Revenue_FY21 / Target_FY21 - 1 AS Perc_Diff
FROM
	(
	--rev fy21
	SELECT Month_ID,
	SUM(Revenue) AS Total_Revenue_FY21
	FROM [Montana].[dbo].[Revenue_Raw_Data] AS r
	WHERE r.Month_ID IN (SELECT DISTINCT Month_ID FROM [Montana].[dbo].[yt_Calender_lookup] WHERE [Fiscal Year] = 'FY21')
	GROUP BY Month_ID
	) a

	LEFT JOIN
	(
	SELECT Month_ID, SUM(Target) AS Target_FY21
	FROM [Montana].[dbo].[Targets_Raw_data]
	WHERE Month_ID IN (SELECT DISTINCT Month_ID FROM [Montana].[dbo].[Revenue_Raw_Data] WHERE Month_ID IN
	(SELECT DISTINCT Month_ID FROM [Montana].[dbo].[yt_Calender_lookup] WHERE [Fiscal Year] = 'FY21'))
	GROUP BY Month_ID
	) b
	ON a.Month_ID = b.Month_ID
	
	LEFT JOIN
	(SELECT DISTINCT Month_ID, [Fiscal Month] FROM [Montana].[dbo].[yt_Calender_lookup]) c
	ON a.Month_ID = c.Month_ID
ORDER BY a.Month_ID



----6. What is the best performing product in terms of revenue this year? fy21


	SELECT Product_Category, sum(revenue) AS revenue
	FROM [Montana].[dbo].[Revenue_Raw_Data]
	WHERE Month_ID IN (SELECT DISTINCT Month_ID FROM [Montana].[dbo].[yt_Calender_lookup] WHERE [Fiscal Year] = 'FY21')
	GROUP BY Product_Category
	ORDER BY Revenue DESC


----7. What is the product performance Vs Target for the month?

SELECT a.Product_Category, a.Month_ID, revenue, b.Target, revenue / b.Target -1 AS Rev_Vs_Target
FROM

	(
	SELECT Product_Category, Month_ID, sum(revenue) AS revenue
	FROM [Montana].[dbo].[Revenue_Raw_Data]
	WHERE Month_ID IN (SELECT MAX(Month_ID) FROM [Montana].[dbo].[Revenue_Raw_Data])
	GROUP BY Product_Category, Month_ID
	) a

	LEFT JOIN
	(
	SELECT Product_Category, Month_ID, sum(Target) AS Target FROM [Montana].[dbo].[Targets_Raw_data]
	WHERE Month_ID IN (SELECT MAX(Month_ID) FROM [Montana].[dbo].[Revenue_Raw_Data])
	GROUP BY Product_Category, Month_ID
	) b
	ON a.Month_ID = b.Month_ID AND a.Product_category = b.Product_Category



----8. Which account is performing the best in terms of revenue?

--fy21
SELECT a.Account_No, b.[New Account Name], Revenue
FROM
	(
	SELECT Account_NO, SUM(Revenue) AS Revenue
	FROM [Montana].[dbo].[Revenue_Raw_Data]
	WHERE Month_ID IN
	(SELECT DISTINCT Month_ID FROM [Montana].[dbo].[yt_Calender_lookup] WHERE [Fiscal Year] = 'FY21')
	GROUP BY Account_No
	--ORDER BY sum(Revenue) DESC
	)a
	
	LEFT JOIN
	(SELECT * FROM [Montana].[dbo].[yt_account_lookup]) b
	ON a.Account_No = b.[ New Account No ]

	ORDER BY Revenue DESC


--all fy
SELECT a.Account_No, b.[New Account Name], Revenue
FROM
	(
	SELECT Account_NO, SUM(Revenue) AS Revenue
	FROM [Montana].[dbo].[Revenue_Raw_Data]
	GROUP BY Account_No
	--ORDER BY sum(Revenue) DESC
	)a
	
	LEFT JOIN
	(SELECT * FROM [Montana].[dbo].[yt_account_lookup]) b
	ON a.Account_No = b.[ New Account No ]

	ORDER BY Revenue DESC




----9. Which opportunity has the highest potential and what are the details? FY21


SELECT * FROM [Montana].[dbo].[yt_Opportunities_Data]
WHERE [Est Completion Month ID] IN (SELECT DISTINCT Month_ID FROM [Montana].[dbo].[yt_Calender_lookup] WHERE [Fiscal Year] = 'FY21')
ORDER BY [Est Opportunity Value] DESC


----10. Which account generates the most revenue per marketing spend for this month?

SELECT ISNULL( a.Account_NO, b.Account_No) AS Account_No, Revenue, Marketing_Spend, ISNULL(Revenue,0) / NULLIF(ISNULL(Marketing_Spend,0),0) AS Rev_Per_Spend
FROM
	(
	SELECT Account_NO, SUM(Revenue) AS Revenue
	FROM [Montana].[dbo].[Revenue_Raw_Data]
	WHERE Month_ID IN (SELECT DISTINCT Month_ID FROM [Montana].[dbo].[yt_Calender_lookup] WHERE [Fiscal Year] = 'FY21')
	GROUP BY Account_No) a

	FULL JOIN
	(SELECT Account_No, SUM([ Marketing Spend ]) AS Marketing_Spend FROM [Montana].[dbo].[Marketing_Raw_data]
	WHERE Month_ID IN (SELECT DISTINCT Month_ID FROM [Montana].[dbo].[yt_Calender_lookup] WHERE [Fiscal Year] = 'FY21')
	GROUP BY Account_No
	) b
ON a.Account_No = b.Account_No