CREATE procedure [dbo].[sp_ODK_riders_per_month]
  @StartDate DATE,
  @EndDate DATE,
  @Provinces NVARCHAR(MAX)
AS




-- Step 1: Declare variables
DECLARE @dates NVARCHAR(MAX) = ''
DECLARE @query NVARCHAR(MAX)
DECLARE @count INT
 

-- Get the count of distinct dates
SELECT @count = COUNT(DISTINCT FORMAT(CAST([SubmissionDate] AS DATE), 'MM-yyyy'))
FROM [LSS].[dbo].ODK_Specimen_and_Results

-- Step 2: Create a comma-separated list of dates
SELECT @dates = @dates + '[' + CAST([date] AS NVARCHAR(10)) + '],'
FROM (
    SELECT DISTINCT TOP (@count) FORMAT(CAST([SubmissionDate] AS DATE), 'MM-yyyy') [date] 
    FROM [LSS].[dbo].ODK_Specimen_and_Results
    WHERE CAST([SubmissionDate] AS DATE) >=@StartDate
    --ORDER BY CAST(date as DATE)  -- Order by date in ascending order (if needed)
) AS DistinctDates

-- Remove the trailing comma
SET @dates = LEFT(@dates, LEN(@dates) - 1)

-- Step 3: Create the dynamic SQL query
SET @query = 
'WITH ProvincesCTE AS (
        SELECT value AS ProvinceName
        FROM STRING_SPLIT(@Provinces, '','')
    ),
    RiderCounts AS (

    SELECT 
        prov,
        dis,
        FORMAT(CAST(SubmissionDate AS DATE), ''MM-yyyy'') [month-year],
        COUNT(DISTINCT rider) as count
    FROM 
        [LSS].[dbo].ODK_Specimen_and_Results
	WHERE  CAST([SubmissionDate] AS DATE) BETWEEN @StartDate AND @EndDate
	  AND prov IN (SELECT ProvinceName FROM ProvincesCTE)  
    GROUP BY 
        prov, dis, FORMAT(CAST(SubmissionDate AS DATE), ''MM-yyyy'')
)
SELECT 
    prov Province,
    dis District, ' + 
    @dates + ' 
FROM 
    RiderCounts
PIVOT
(
    SUM(count)
    FOR [month-year] IN (' + @dates + ')
) AS PivotTable
order by prov,dis
;'


 -- Step 4: Execute the dynamic SQL
EXEC sp_executesql @query, N'@StartDate DATE, @EndDate DATE, @Provinces NVARCHAR(MAX)', @StartDate, @EndDate, @Provinces;