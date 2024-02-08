
CREATE PROCEDURE backlog_carryover_model as

WITH last_week_carryover AS (
    SELECT 
        d.lab,
        SUM(ISNULL(CAST(r.[Carryover_Samples_in_the_lab] AS INT), 0)) AS Carryover_Samples_in_the_lab
    FROM DATIM_Facility_names d  
    LEFT JOIN [LSS].[dbo].[Dash_This_week_Rec_Samples] r ON d.Facility = r.name_of_lab
    WHERE 
        CAST([date] AS DATE) >= DATEADD(DAY, -14, DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0))
        AND CAST([date] AS DATE) < DATEADD(DAY, -7, DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0))
        AND r.status = 'Lab'
        AND r.[Test_Type] = 'VL'
    GROUP BY d.lab
),

current_carryover AS (
    SELECT 
        d.lab,
        SUM(ISNULL(CAST(r.[Carryover_Samples_in_the_lab] AS INT), 0)) AS Carryover_Samples_in_the_lab
    FROM DATIM_Facility_names d  
    LEFT JOIN [LSS].[dbo].[Dash_This_week_Rec_Samples] r ON d.Facility = r.name_of_lab
    WHERE 
        CAST([date] AS DATE) >= DATEADD(DAY, -7, DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0))
        AND CAST([date] AS DATE) < DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0)
        AND r.status = 'Lab'
        AND r.[Test_Type] = 'VL'
    GROUP BY d.lab
),

This_week_backlog_and_carryover AS (
    SELECT 
        d.lab,
        r.[Sample_Type],
        SUM(ISNULL(CAST(r.[Carryover_Samples_in_the_lab] AS INT), 0)) AS Carryover_Samples_in_the_lab,
        SUM(ISNULL(CAST(r.[Samples_in_backlog_Intra_lab_TAT_7_days] AS INT), 0)) AS Samples_in_backlog_Intra_lab_TAT_7_days
    FROM DATIM_Facility_names d  
    LEFT JOIN [LSS].[dbo].[Dash_This_week_Rec_Samples] r ON d.Facility = r.name_of_lab
    WHERE 
        CAST([date] AS DATE) >= DATEADD(DAY, -7, DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0))
        AND CAST([date] AS DATE) < DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0)
        AND r.status = 'Lab'
        AND r.[Test_Type] = 'VL'
    GROUP BY d.lab, r.[Sample_Type]
)

SELECT 
    t.lab,
    'Carry-over' AS state,
    SUM(CASE WHEN t.Sample_Type = 'Plasma' THEN t.Carryover_Samples_in_the_lab ELSE 0 END) AS Plasma,
    SUM(CASE WHEN t.Sample_Type = 'DBS' THEN t.Carryover_Samples_in_the_lab ELSE 0 END) AS DBS,
    COALESCE(
        CONCAT(
           MAX( ROUND(
                (
                    (CAST(c.Carryover_Samples_in_the_lab AS FLOAT) - CAST(l.Carryover_Samples_in_the_lab AS FLOAT)) 
                    / NULLIF(CAST(l.Carryover_Samples_in_the_lab AS FLOAT), 0) * 100
                ),
                2
            )),
            '%'
        ),
        '0%'
    ) AS Carryover_Fluctuations
FROM This_week_backlog_and_carryover t
LEFT JOIN current_carryover c ON t.lab = c.lab 
LEFT JOIN last_week_carryover l ON t.lab = l.lab 
GROUP BY t.lab

UNION ALL

SELECT 
    lab,
    'Backlog' AS state,
    SUM(CASE WHEN Sample_Type = 'Plasma' THEN Samples_in_backlog_Intra_lab_TAT_7_days ELSE 0 END) AS Plasma,
    SUM(CASE WHEN Sample_Type = 'DBS' THEN Samples_in_backlog_Intra_lab_TAT_7_days ELSE 0 END) AS DBS,
    NULL AS Carryover_Fluctuations
FROM This_week_backlog_and_carryover
GROUP BY lab

order by lab