create procedure clean_this_week_tab as

WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY
       [Date]
      ,[Name_of_Lab]
      ,[Sample_Type]
      ,[Test_Type]
      ,[Total_samples_received]
      ,[Urgent_Samples_received]
      ,[Num_ReBleed_Samples]
      ,[Weekly_sample_receipt_target]
      ,[Num_Rejected_Samples]
      ,[weekly_max_threshhold]
      ,[REJECTED_Quality_issue]
      ,[REJECTED_Quantity_insuff]
      ,[REJECTED_Patient_SampleINFO]
      ,[REJECTED_Missing_requestForm]
      ,[REJECTED_Sample_Missing]
      ,[Num_Samples_entered_LIMSonArrival]
      ,[LIMs_Backlog_yetTObeEntered]
      ,[comments]
      ,[SourceFile]
       ORDER BY (SELECT NULL)) AS rn   
  FROM [LSS].[dbo].[Dash_This_week_Rec_Samples]

  )
DELETE 
FROM CTE WHERE rn > 1;