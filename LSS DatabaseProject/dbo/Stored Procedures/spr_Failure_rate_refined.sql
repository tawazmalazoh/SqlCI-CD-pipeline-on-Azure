create procedure  spr_Failure_rate_refined  as 


WITH CTE AS (
    SELECT 
        [Date],
        [Name_of_Lab],
        [Platform] + ' ' + [sample_type] AS [platform],
        [TotalTested],
        [TotalFailed],
        [FailureRate]
    FROM [LSS].[dbo].[weekly_failure_rate_view]
    WHERE [Platform] + ' ' + [sample_type] IN (
        'Abbott DBS',
        'Abbott Plasma',
        'BMX DBS',
        'BMX Plasma',
        'Hologic Panther DBS',
        'Hologic Panther Plasma',
        'Roche CAPCTM DBS',
        'Roche CAPCTM Plasma',
        'Roche Cobbas DBS',
        'Roche Cobbas Plasma'
    )
)

SELECT 
    [Date],
    [Name_of_Lab],
    ISNULL([Abbott DBS], 0) AS [Abbott DBS],
    ISNULL([Abbott Plasma], 0) AS [Abbott Plasma],
    ISNULL([BMX DBS], 0) AS [BMX DBS],
    ISNULL([BMX Plasma], 0) AS [BMX Plasma],
    ISNULL([Hologic Panther DBS], 0) AS [Hologic Panther DBS],
    ISNULL([Hologic Panther Plasma], 0) AS [Hologic Panther Plasma],
    ISNULL([Roche CAPCTM DBS], 0) AS [Roche CAPCTM DBS],
    ISNULL([Roche CAPCTM Plasma], 0) AS [Roche CAPCTM Plasma],
    ISNULL([Roche Cobbas DBS], 0) AS [Roche Cobbas DBS],
    ISNULL([Roche Cobbas Plasma], 0) AS [Roche Cobbas Plasma]
FROM 
(
    SELECT 
        [Date],
        [Name_of_Lab],
        [platform],
        [TotalTested],
        [TotalFailed],
        [FailureRate]
    FROM CTE
) AS SourceTable
PIVOT
(
    SUM([FailureRate])
    FOR [platform] IN (
        [Abbott DBS],
        [Abbott Plasma],
        [BMX DBS],
        [BMX Plasma],
        [Hologic Panther DBS],
        [Hologic Panther Plasma],
        [Roche CAPCTM DBS],
        [Roche CAPCTM Plasma],
        [Roche Cobbas DBS],
        [Roche Cobbas Plasma]
    )
) AS PivotTable;