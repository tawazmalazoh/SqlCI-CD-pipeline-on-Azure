CREATE PROCEDURE sp_vl_Samples_Received AS


DECLARE @StartDate Date
DECLARE @EndDate Date
DECLARE @columns NVARCHAR(MAX), @sql NVARCHAR(MAX)

-- Get distinct month_year values and prepare them as columns
SELECT @columns = STRING_AGG('[' + month_year + ']', ', ')
FROM (
    SELECT DISTINCT 
        FORMAT(
            CASE
                WHEN ISDATE(Date_Received) = 1 THEN Date_Received
                WHEN TRY_CONVERT(date, Date_Received, 23) IS NULL AND ISNUMERIC(Date_Received) = 1 THEN CONVERT(date, DATEADD(day, CAST(Date_Received AS int) - 1, '1900-01-01'), 23)
                WHEN ISNUMERIC(Date_Received)!= 1 THEN cast(Date_Received as date) 
                ELSE '1900-01-01'
            END, 'MM-yyyy') AS month_year
    FROM fortnight_received
	WHERE cast(Date_Received as date) between @StartDate and  @EndDate
) t

-- Construct the dynamic SQL for the PIVOT
SET @sql = '
    SELECT district, facility, ' + @columns + '
    FROM (
        SELECT   
            FORMAT(
                CASE
                    WHEN ISDATE(Date_Received) = 1 THEN Date_Received
                    WHEN TRY_CONVERT(date, Date_Received, 23) IS NULL AND ISNUMERIC(Date_Received) = 1 THEN CONVERT(date, DATEADD(day, CAST(Date_Received AS int) - 1, ''1900-01-01''), 23)
                    WHEN ISNUMERIC(Date_Received)!= 1 THEN cast(Date_Received as date) 
                    ELSE ''1900-01-01''
                END, ''MM-yyyy'') AS month_year,
            district,
            facility,
            COUNT(facility) AS samples_received
        FROM fortnight_received
		WHERE cast(Date_Received as date) between @StartDateParam and  @EndDateParam
        GROUP BY FORMAT(
                CASE
                    WHEN ISDATE(Date_Received) = 1 THEN Date_Received
                    WHEN TRY_CONVERT(date, Date_Received, 23) IS NULL AND ISNUMERIC(Date_Received) = 1 THEN CONVERT(date, DATEADD(day, CAST(Date_Received AS int) - 1, ''1900-01-01''), 23)
                    WHEN ISNUMERIC(Date_Received)!= 1 THEN cast(Date_Received as date) 
                    ELSE ''1900-01-01''
                END, ''MM-yyyy''),
            district,
            facility
    ) x
    PIVOT(
        SUM(samples_received)
        FOR month_year IN (' + @columns + ')
    ) p
	ORDER BY district
'

-- Execute the dynamic SQL
EXEC sp_executesql @sql, N'@StartDateParam DATE, @EndDateParam DATE', @StartDateParam = @StartDate, @EndDateParam = @EndDate;