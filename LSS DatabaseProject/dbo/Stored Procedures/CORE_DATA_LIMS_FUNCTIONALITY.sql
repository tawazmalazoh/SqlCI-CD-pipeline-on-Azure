
CREATE PROCEDURE [dbo].[CORE_DATA_LIMS_FUNCTIONALITY]

AS
BEGIN

-- Intended for deletion of records with a specified condition
-- DELETE FROM [LSS].[dbo].[Creation_Reports_Hub_Lab]
-- WHERE [Referring_Lab] IS NOT NULL OR [Referring_Lab] != '';

WITH FormatDeterminer AS (
    SELECT
        SourceFile AS OGSOURCE,
        CASE
				
            WHEN COUNT(CASE WHEN CHARINDEX('-', Date_Registered) > 0 AND LEN(Date_Registered) = 10 THEN 1 END) > 0 THEN 'YYYY-MM-DD'
			WHEN COUNT(CASE WHEN CHARINDEX('-', Date_Registered) > 0 AND LEN(Date_Registered) = 27 THEN 1 END) > 0 THEN 'YYYY-MM-DD'
            WHEN COUNT(CASE WHEN CHARINDEX('-', Date_Registered) = 0 AND CAST(PARSENAME(REPLACE(Date_Registered, '/', '.'), 3) AS INT) > 12 THEN 1 END) > 0 THEN 'DD/MM/YYYY'
            WHEN COUNT(CASE WHEN CHARINDEX('-', Date_Registered) = 0 AND CAST(PARSENAME(REPLACE(Date_Registered, '/', '.'), 2) AS INT) > 12 THEN 1 END) > 0 THEN 'MM/DD/YYYY'
            WHEN COUNT(CASE WHEN CHARINDEX('-', Date_Registered) > 0 AND LEN(Date_Registered) = 8 THEN 1 END) > 0 THEN 'DD-MM-YY'
            WHEN COUNT(CASE WHEN ISNUMERIC(Date_Registered) = 1 THEN 1 END) > 0 THEN 'Excel Integer'
			WHEN COUNT(CASE WHEN CHARINDEX('-', Date_Registered) = 0 AND CAST(PARSENAME(REPLACE(Date_Registered, '/', '.'), 3) AS INT) < 12 THEN 1 END) > 0    THEN 'D/M/YYYY'
			ELSE 'DD-MM-YY'
        END AS DateFormat
    FROM 
        [LSS].[dbo].[Creation_Reports_Hub_Lab]
    GROUP BY 
        SourceFile
)

,StandardizedDate AS (
    SELECT  
        t.*,
        CASE 
            WHEN CHARINDEX('-', t.Date_Registered) > 0 AND LEN(t.Date_Registered) = 10 THEN t.Date_Registered
            WHEN f.DateFormat = 'DD-MM-YY' THEN '20' + RIGHT(t.Date_Registered, 2) + '-' + SUBSTRING(t.Date_Registered, 4, 2) + '-' + LEFT(t.Date_Registered, 2)
            WHEN f.DateFormat = 'DD/MM/YYYY' THEN RIGHT(t.Date_Registered, 4) + '-' + SUBSTRING(t.Date_Registered, CHARINDEX('/', t.Date_Registered) + 1, CHARINDEX('/', t.Date_Registered, CHARINDEX('/', t.Date_Registered) + 1) - CHARINDEX('/', t.Date_Registered) - 1) + '-' + LEFT(t.Date_Registered, CHARINDEX('/', t.Date_Registered) - 1)
            WHEN f.DateFormat = 'MM/DD/YYYY' THEN RIGHT(t.Date_Registered, 4) + '-' + LEFT(t.Date_Registered, CHARINDEX('/', t.Date_Registered) - 1) + '-' + SUBSTRING(t.Date_Registered, CHARINDEX('/', t.Date_Registered) + 1, CHARINDEX('/', t.Date_Registered, CHARINDEX('/', t.Date_Registered) + 1) - CHARINDEX('/', t.Date_Registered) - 1)
            WHEN f.DateFormat = 'Excel Integer' THEN CONVERT(DATE, DATEADD(DAY, CAST(Date_Registered AS INT), '1899-12-30'))
			WHEN f.DateFormat='D/M/YYYY' THEN  cast(t.Date_Registered as date)
			ELSE t.Date_Registered
        END AS StandardizedDate
    FROM 
        [LSS].[dbo].[Creation_Reports_Hub_Lab] t
    JOIN 
        FormatDeterminer f ON t.SourceFile = f.OGSOURCE
		
)
    SELECT  
        [Sample_ID],
        [Client_Sample_ID],
        [Testing_Lab],
        [Referring_Lab],
        [Province],
        [District],
        [Facility],
        Creator,
        [Date_Registered],
        [SourceFile],
        [Status],
        (SELECT TOP 1 Hub FROM [dbo].[Facility_Hub] h WHERE h.[Facility_Names] = c.Facility) AS HUB_facility,
        (SELECT TOP 1 [Hub_name] FROM [dbo].[Creator_Hub] ch WHERE ch.[Lab_Personnel _Creator] = c.Creator) AS HUB_Creator_captured,
        (SELECT TOP 1 Province FROM [dbo].[Facility_Hub] h WHERE h.[Facility_Names] = c.Facility) AS prov,
        (SELECT TOP 1 [District] FROM [dbo].[Facility_Hub] h WHERE h.[Facility_Names] = c.Facility) AS Dist
    FROM 
        StandardizedDate c
    WHERE         

		    CAST(StandardizedDate AS DATE) >= DATEADD(DAY, -7, DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0))
             AND CAST(StandardizedDate AS DATE) < DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0) 
		
end