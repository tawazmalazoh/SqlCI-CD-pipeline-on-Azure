create Procedure sp_delete_ODK_dups AS 


WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY
          [KEY],[instanceID]
       ORDER BY ([instanceID]) ) AS rn   
  FROM [LSS].[dbo].[ODK_Specimen_and_Results]

  )
DELETE 
--select *
FROM CTE WHERE rn > 1;