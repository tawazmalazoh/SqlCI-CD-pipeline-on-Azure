CREATE PROCEDURE [dbo].[sp_ODK_Provincial_riders_per_month]
  @StartDate DATE,
  @EndDate DATE
AS
BEGIN

    -- Step 1: Declare variables
    DECLARE @dates NVARCHAR(MAX) = ''
    DECLARE @query NVARCHAR(MAX)
    DECLARE @count INT

    -- Get the count of distinct dates
    SELECT @count = COUNT(DISTINCT FORMAT(CAST([SubmissionDate] AS DATE), 'MM-yyyy'))
    FROM [LSS].[dbo].ODK_Specimen_and_Results
    WHERE CAST([SubmissionDate] AS DATE) BETWEEN @StartDate AND @EndDate

    -- Step 2: Create a comma-separated list of dates
    SELECT @dates = @dates + '[' + CAST([date] AS NVARCHAR(10)) + '],'
    FROM (
        SELECT DISTINCT TOP (@count) FORMAT(CAST([SubmissionDate] AS DATE), 'MM-yyyy') [date] 
        FROM [LSS].[dbo].ODK_Specimen_and_Results
        WHERE CAST([SubmissionDate] AS DATE) BETWEEN @StartDate AND @EndDate
        --ORDER BY CAST(date as DATE)  -- Order by date in ascending order (if needed)
    ) AS DistinctDates

    -- Remove the trailing comma
    SET @dates = LEFT(@dates, LEN(@dates) - 1)

    -- Step 3: Create the dynamic SQL query
    SET @query = 
    'WITH RiderCounts AS (
        SELECT 
            prov,

            FORMAT(CAST(SubmissionDate AS DATE), ''MM-yyyy'') [month-year],
            COUNT(DISTINCT rider) as count
        FROM 
            [LSS].[dbo].ODK_Specimen_and_Results
        WHERE  CAST([SubmissionDate] AS DATE) BETWEEN @StartDate AND @EndDate
        GROUP BY 
            prov,  FORMAT(CAST(SubmissionDate AS DATE), ''MM-yyyy'')
    )
    SELECT 
        prov Province,
        ' + 
        @dates + ' 
    FROM 
        RiderCounts
    PIVOT
    (
        SUM(count)
        FOR [month-year] IN (' + @dates + ')
    ) AS PivotTable
    ORDER BY prov
    ;'

    -- Step 4: Execute the dynamic SQL
    EXEC sp_executesql @query, N'@StartDate DATE, @EndDate DATE', @StartDate, @EndDate;

END