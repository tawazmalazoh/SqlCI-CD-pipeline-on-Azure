
CREATE PROCEDURE [dbo].[sp_VL_sample_run_reasons_model] AS 
  WITH RUN_Base  AS (
  
  
  SELECT 
   CASE 
    WHEN name_of_lab = 'Beitbridge - 100052 - District Hospital' THEN 'Beitbridge'
    WHEN name_of_lab = 'Bindura - 100070 - Provincial Hospital' THEN 'Bindura'
    WHEN name_of_lab = 'Beatrice Infectious - 100050 - Hospital' THEN 'BRIDH'
    WHEN name_of_lab = 'Chinhoyi - 100235 - Provincial Hospital' THEN 'Chinhoyi'
    WHEN name_of_lab = 'Gwanda - 100561 - Provincial Hospital' THEN 'Gwanda'
    WHEN name_of_lab = 'Gweru - 100572 - Provincial Hospital' THEN 'Gweru'
    WHEN name_of_lab = 'Kadoma - 100681 - District Hosp' THEN 'Kadoma'
    WHEN name_of_lab = 'Marondera - 100903 - Provincial Hospital' THEN 'Marondera'
    WHEN name_of_lab = 'Masvingo - 100937 - General Hospital' THEN 'Masvingo'
    WHEN name_of_lab = 'Mpilo - 101041 - Central Hospital' THEN 'Mpilo'
    WHEN name_of_lab = 'Mutare - 101165 - Provincial Hospital' THEN 'Mutare'
    WHEN name_of_lab = 'National Reference Laboratory - 101206 - Laboratory' THEN 'NMRL'
    WHEN name_of_lab = 'St. Lukes - 101645 - Mission Hospital' THEN 'St Lukes'
    WHEN name_of_lab = 'Victoria Falls - 101739 - District Hospital' THEN 'Vic Falls'
    ELSE name_of_lab
	END AS name_of_lab
     ,[Sample_Type]+' '+ [Test_Type]  as [Type]
      ,
	    
   CASE
   WHEN [Platform_Roche_Abbott_Hologic_BMX] in ('Roche','Roche CAPCTM','Roche 2') THEN 'Roche CAPCTM'
   WHEN  [Platform_Roche_Abbott_Hologic_BMX] in ('Roche C5800','Roche Cobass 8800','Cobas 8800','Roche C6800','Roche C8800') THEN 'Roche Cobas'
   WHEN [Platform_Roche_Abbott_Hologic_BMX] in ('Abbott','Abbott 1','Abbott 2') THEN 'Abbott'
   WHEN [Platform_Roche_Abbott_Hologic_BMX] in ('Hologic Panther' ) THEN  'Hologic Panther'
   ELSE [Platform_Roche_Abbott_Hologic_BMX]
   END  AS [Platform_Roche_Abbott_Hologic_BMX],

     sum ( cast(RECEIVED_FAILED_sample_handling_error_lab as int)) RECEIVED_FAILED_sample_handling_error_lab,
	 sum ( cast(RECEIVED_FAILED_quality_quantity_issues as int)) RECEIVED_FAILED_quality_quantity_issues,


	  sum ( cast(FAILED_RECEIVED_sample_processing_error as int)) FAILED_RECEIVED_sample_processing_error,
	  sum (cast(RECEIVED_FAILED_reagent_quality_issues as int)) RECEIVED_FAILED_reagent_quality_issues,
	  sum(cast(RECEIVED_FAILED_QC_failure as int)) RECEIVED_FAILED_QC_failure,
	  sum (cast (RECEIVED_FAILED_power_failure as int)) RECEIVED_FAILED_power_failure,
	  sum (cast(RECEIVED_FAILED_mechanical_failure as int))  RECEIVED_FAILED_mechanical_failure,
	  sum (cast(RECEIVED_OTHER as int))  RECEIVED_OTHER
	
  FROM [LSS].[dbo].[Dash_Sample_Run]
  WHERE [Platform_Roche_Abbott_Hologic_BMX] in ('Roche','Roche CAPCTM','Roche 2','Abbott','Abbott 1','Abbott 2','Roche C8800','Roche C5800','Roche Cobass 8800','Cobas 8800','Roche C6800','Hologic Panther' )
   and  CAST([date] AS DATE) >= DATEADD(DAY, -7, DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0))
   AND CAST([date] AS DATE) < DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0)
   and status='Lab'
   and  [Test_Type]='VL'

   Group by  CASE 
    WHEN name_of_lab = 'Beitbridge - 100052 - District Hospital' THEN 'Beitbridge'
    WHEN name_of_lab = 'Bindura - 100070 - Provincial Hospital' THEN 'Bindura'
    WHEN name_of_lab = 'Beatrice Infectious - 100050 - Hospital' THEN 'BRIDH'
    WHEN name_of_lab = 'Chinhoyi - 100235 - Provincial Hospital' THEN 'Chinhoyi'
    WHEN name_of_lab = 'Gwanda - 100561 - Provincial Hospital' THEN 'Gwanda'
    WHEN name_of_lab = 'Gweru - 100572 - Provincial Hospital' THEN 'Gweru'
    WHEN name_of_lab = 'Kadoma - 100681 - District Hosp' THEN 'Kadoma'
    WHEN name_of_lab = 'Marondera - 100903 - Provincial Hospital' THEN 'Marondera'
    WHEN name_of_lab = 'Masvingo - 100937 - General Hospital' THEN 'Masvingo'
    WHEN name_of_lab = 'Mpilo - 101041 - Central Hospital' THEN 'Mpilo'
    WHEN name_of_lab = 'Mutare - 101165 - Provincial Hospital' THEN 'Mutare'
    WHEN name_of_lab = 'National Reference Laboratory - 101206 - Laboratory' THEN 'NMRL'
    WHEN name_of_lab = 'St. Lukes - 101645 - Mission Hospital' THEN 'St Lukes'
    WHEN name_of_lab = 'Victoria Falls - 101739 - District Hospital' THEN 'Vic Falls'
    ELSE name_of_lab
	END
     ,[Sample_Type]+' '+ [Test_Type],       
   CASE
   WHEN [Platform_Roche_Abbott_Hologic_BMX] in ('Roche','Roche CAPCTM','Roche 2') THEN 'Roche CAPCTM'
   WHEN  [Platform_Roche_Abbott_Hologic_BMX] in ('Roche C5800','Roche Cobass 8800','Cobas 8800','Roche C6800','Roche C8800') THEN 'Roche Cobas'
   WHEN [Platform_Roche_Abbott_Hologic_BMX] in ('Abbott','Abbott 1','Abbott 2') THEN 'Abbott'
   WHEN [Platform_Roche_Abbott_Hologic_BMX] in ('Hologic Panther' ) THEN  'Hologic Panther'
   ELSE [Platform_Roche_Abbott_Hologic_BMX]
   END 


   )


  , COMMENTTS AS (
  
SELECT 
    name_of_lab, 
    STRING_AGG(comments, ' ') AS combined_comments
FROM (
	select 
	 CASE 
    WHEN name_of_lab = 'Beitbridge - 100052 - District Hospital' THEN 'Beitbridge'
    WHEN name_of_lab = 'Bindura - 100070 - Provincial Hospital' THEN 'Bindura'
    WHEN name_of_lab = 'Beatrice Infectious - 100050 - Hospital' THEN 'BRIDH'
    WHEN name_of_lab = 'Chinhoyi - 100235 - Provincial Hospital' THEN 'Chinhoyi'
    WHEN name_of_lab = 'Gwanda - 100561 - Provincial Hospital' THEN 'Gwanda'
    WHEN name_of_lab = 'Gweru - 100572 - Provincial Hospital' THEN 'Gweru'
    WHEN name_of_lab = 'Kadoma - 100681 - District Hosp' THEN 'Kadoma'
    WHEN name_of_lab = 'Marondera - 100903 - Provincial Hospital' THEN 'Marondera'
    WHEN name_of_lab = 'Masvingo - 100937 - General Hospital' THEN 'Masvingo'
    WHEN name_of_lab = 'Mpilo - 101041 - Central Hospital' THEN 'Mpilo'
    WHEN name_of_lab = 'Mutare - 101165 - Provincial Hospital' THEN 'Mutare'
    WHEN name_of_lab = 'National Reference Laboratory - 101206 - Laboratory' THEN 'NMRL'
    WHEN name_of_lab = 'St. Lukes - 101645 - Mission Hospital' THEN 'St Lukes'
    WHEN name_of_lab = 'Victoria Falls - 101739 - District Hospital' THEN 'Vic Falls'
    ELSE name_of_lab
	END AS name_of_lab, comments	
	FROM [LSS].[dbo].[Dash_Sample_Run]
	where  status='Lab'
	and   CAST([date] AS DATE) >= DATEADD(DAY, -7, DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0))
      AND CAST([date] AS DATE) < DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0)
	and [Test_Type]='VL'
	) as base 

	group by name_of_lab)



   select  b.name_of_lab,

   --Roche

   SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche CAPCTM' THEN RECEIVED_FAILED_sample_handling_error_lab ELSE 0 END) AS Roche_Plasma_sample_handling_error,
   SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche CAPCTM' THEN RECEIVED_FAILED_quality_quantity_issues ELSE 0 END) AS Roche_Plasma_quality_quantity_issues,

 	  SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche CAPCTM' THEN RECEIVED_FAILED_reagent_quality_issues ELSE 0 END) AS Roche_Plasma_Quality_issue,
	 SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche CAPCTM' THEN RECEIVED_FAILED_QC_failure ELSE 0 END) AS Roche_Plasma_QC_Failure,
      SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche CAPCTM' THEN RECEIVED_FAILED_power_failure ELSE 0 END) AS Roche_Plasma_Power_Failure,
	   SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche CAPCTM' THEN RECEIVED_FAILED_mechanical_failure ELSE 0 END) AS Roche_Plasma_Mechanical_Failure,
	  SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche CAPCTM' THEN FAILED_RECEIVED_sample_processing_error ELSE 0 END) AS Roche_Plasma_Handling_Error,
	  SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche CAPCTM' THEN RECEIVED_OTHER ELSE 0 END) AS Roche_Plasma_OTHER_Failure,



	  SUM(CASE WHEN [Type] = 'DBS VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche CAPCTM' THEN RECEIVED_FAILED_sample_handling_error_lab ELSE 0 END) AS Roche_DBS_sample_handling_error,
	  SUM(CASE WHEN [Type] = 'DBS VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche CAPCTM' THEN RECEIVED_FAILED_quality_quantity_issues ELSE 0 END) AS Roche_DBS_quality_quantity_issues,

	 SUM(CASE WHEN [Type] = 'DBS VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche CAPCTM' THEN RECEIVED_FAILED_reagent_quality_issues ELSE 0 END) AS Roche_DBS_Quality_issue,
	 SUM(CASE WHEN [Type] = 'DBS VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche CAPCTM' THEN RECEIVED_FAILED_QC_failure ELSE 0 END) AS Roche_DBS_QC_Failure,
      SUM(CASE WHEN [Type] = 'DBS VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche CAPCTM' THEN RECEIVED_FAILED_power_failure ELSE 0 END) AS Roche_DBS_Power_Failure,
	   SUM(CASE WHEN [Type] = 'DBS VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche CAPCTM' THEN RECEIVED_FAILED_mechanical_failure ELSE 0 END) AS Roche_DBS_Mechanical_Failure,
	  SUM(CASE WHEN [Type] = 'DBS VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche CAPCTM' THEN FAILED_RECEIVED_sample_processing_error ELSE 0 END) AS Roche_DBS_Handling_Error,
	  SUM(CASE WHEN [Type] = 'DBS VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche CAPCTM' THEN RECEIVED_OTHER ELSE 0 END) AS Roche_DBS_OTHER_Failure,

    
     --ROche cobbas


	 SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche Cobas' THEN RECEIVED_FAILED_sample_handling_error_lab ELSE 0 END) AS Cobas_Plasma_sample_handling_error,
	 SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche Cobas' THEN RECEIVED_FAILED_quality_quantity_issues ELSE 0 END) AS Cobas_Plasma_quality_quantity_issues,

	 	  SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche Cobas' THEN RECEIVED_FAILED_reagent_quality_issues ELSE 0 END) AS Cobas_Plasma_Quality_issue,
	 SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche Cobas' THEN RECEIVED_FAILED_QC_failure ELSE 0 END) AS Cobas_Plasma_QC_Failure,
      SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche Cobas' THEN RECEIVED_FAILED_power_failure ELSE 0 END) AS Cobas_Plasma_Power_Failure,
	   SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche Cobas' THEN RECEIVED_FAILED_mechanical_failure ELSE 0 END) AS Cobas_Plasma_Mechanical_Failure,
	  SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche Cobas' THEN FAILED_RECEIVED_sample_processing_error ELSE 0 END) AS Cobas_Plasma_Handling_Error,
	  SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche Cobas' THEN RECEIVED_OTHER ELSE 0 END) AS Cobas_Plasma_OTHER_Failure,


	  	   	  SUM(CASE WHEN [Type] = 'DBS VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche Cobas' THEN RECEIVED_FAILED_sample_handling_error_lab ELSE 0 END) AS Cobas_DBS_sample_handling_error,
	 SUM(CASE WHEN [Type] = 'DBS VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche Cobas' THEN RECEIVED_FAILED_quality_quantity_issues ELSE 0 END) AS Cobas_DBS_quality_quantity_issues,

	   	  SUM(CASE WHEN [Type] = 'DBS VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche Cobas' THEN RECEIVED_FAILED_reagent_quality_issues ELSE 0 END) AS Cobas_DBS_Quality_issue,
	 SUM(CASE WHEN [Type] = 'DBS VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche Cobas' THEN RECEIVED_FAILED_QC_failure ELSE 0 END) AS Cobas_DBS_QC_Failure,
      SUM(CASE WHEN [Type] = 'DBS VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche Cobas' THEN RECEIVED_FAILED_power_failure ELSE 0 END) AS Cobas_DBS_Power_Failure,
	   SUM(CASE WHEN [Type] = 'DBS VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche Cobas' THEN RECEIVED_FAILED_mechanical_failure ELSE 0 END) AS Cobas_DBS_Mechanical_Failure,
	  SUM(CASE WHEN [Type] = 'DBS VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche Cobas' THEN FAILED_RECEIVED_sample_processing_error ELSE 0 END) AS Cobas_DBS_Handling_Error,
	  SUM(CASE WHEN [Type] = 'DBS VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche Cobas' THEN RECEIVED_OTHER ELSE 0 END) AS Cobas_DBS_OTHER_Failure,



	-- Abbott
	SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Abbott'  THEN RECEIVED_FAILED_sample_handling_error_lab ELSE 0 END) AS Abbott_Plasma_sample_handling_error,
	 SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Abbott'  THEN RECEIVED_FAILED_quality_quantity_issues ELSE 0 END) AS Abbott_Plasma_quality_quantity_issues,
	
	SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Abbott'  THEN RECEIVED_FAILED_reagent_quality_issues ELSE 0 END) AS Abbott_Plasma_Quality_issue,
	 SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Abbott'  THEN RECEIVED_FAILED_QC_failure ELSE 0 END) AS Abbott_Plasma_QC_Failure,
      SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Abbott'  THEN RECEIVED_FAILED_power_failure ELSE 0 END) AS Abbott_Plasma_Power_Failure,
	   SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Abbott'  THEN RECEIVED_FAILED_mechanical_failure ELSE 0 END) AS Abbott_Plasma_Mechanical_Failure,
	  SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Abbott'  THEN FAILED_RECEIVED_sample_processing_error ELSE 0 END) AS Abbott_Plasma_Handling_Error,
	  SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Abbott'  THEN RECEIVED_OTHER ELSE 0 END) AS Abbott_Plasma_OTHER_Failure,


	 SUM(CASE WHEN [Type] = 'DBS VL' and [Platform_Roche_Abbott_Hologic_BMX]='Abbott'  THEN RECEIVED_FAILED_sample_handling_error_lab ELSE 0 END) AS Abbott_DBS_sample_handling_error,
	 SUM(CASE WHEN [Type] = 'DBS VL' and [Platform_Roche_Abbott_Hologic_BMX]='Abbott'  THEN RECEIVED_FAILED_quality_quantity_issues ELSE 0 END) AS Abbott_DBS_quality_quantity_issues,

	   	  SUM(CASE WHEN [Type] = 'DBS VL' and [Platform_Roche_Abbott_Hologic_BMX]='Abbott'  THEN RECEIVED_FAILED_reagent_quality_issues ELSE 0 END) AS Abbott_DBS_Quality_issue,
	 SUM(CASE WHEN [Type] = 'DBS VL' and [Platform_Roche_Abbott_Hologic_BMX]='Abbott'  THEN RECEIVED_FAILED_QC_failure ELSE 0 END) AS Abbott_DBS_QC_Failure,
      SUM(CASE WHEN [Type] = 'DBS VL' and [Platform_Roche_Abbott_Hologic_BMX]='Abbott'  THEN RECEIVED_FAILED_power_failure ELSE 0 END) AS Abbott_DBS_Power_Failure,
	   SUM(CASE WHEN [Type] = 'DBS VL' and [Platform_Roche_Abbott_Hologic_BMX]='Abbott'  THEN RECEIVED_FAILED_mechanical_failure ELSE 0 END) AS Abbott_DBS_Mechanical_Failure,
	  SUM(CASE WHEN [Type] = 'DBS VL' and [Platform_Roche_Abbott_Hologic_BMX]='Abbott'  THEN FAILED_RECEIVED_sample_processing_error ELSE 0 END) AS Abbott_DBS_Handling_Error,
	 SUM(CASE WHEN [Type] = 'DBS VL' and [Platform_Roche_Abbott_Hologic_BMX]='Abbott'  THEN RECEIVED_OTHER ELSE 0 END) AS Abbott_DBS_OTHER_Failure,





-- Hologic

	 	  SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Hologic Panther'  THEN RECEIVED_FAILED_sample_handling_error_lab ELSE 0 END) AS Hologic_Plasma_sample_handling_error,
	 SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Hologic Panther'  THEN RECEIVED_FAILED_quality_quantity_issues ELSE 0 END) AS Hologic_Plasma_quality_quantity_issues,

	 	  SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Hologic Panther'  THEN RECEIVED_FAILED_reagent_quality_issues ELSE 0 END) AS Hologic_Plasma_Quality_issue,
	 SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Hologic Panther'  THEN RECEIVED_FAILED_QC_failure ELSE 0 END) AS Hologic_Plasma_QC_Failure,
      SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Hologic Panther'  THEN RECEIVED_FAILED_power_failure ELSE 0 END) AS Hologic_Plasma_Power_Failure,
	   SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Hologic Panther'  THEN RECEIVED_FAILED_mechanical_failure ELSE 0 END) AS Hologic_Plasma_Mechanical_Failure,
	  SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Hologic Panther' THEN FAILED_RECEIVED_sample_processing_error ELSE 0 END) AS Hologic_Plasma_Handling_Error,
	  SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Hologic Panther' THEN RECEIVED_OTHER ELSE 0 END) AS Hologic_Plasma_OTHER_Failure,


	  	   	  SUM(CASE WHEN [Type] = 'DBS VL' and [Platform_Roche_Abbott_Hologic_BMX]='Hologic Panther'  THEN RECEIVED_FAILED_sample_handling_error_lab ELSE 0 END) AS Hologic_DBS_sample_handling_error,
	 SUM(CASE WHEN [Type] = 'DBS VL' and [Platform_Roche_Abbott_Hologic_BMX]='Hologic Panther'  THEN RECEIVED_FAILED_quality_quantity_issues ELSE 0 END) AS Hologic_DBS_quality_quantity_issues,

	   	  SUM(CASE WHEN [Type] = 'DBS VL' and [Platform_Roche_Abbott_Hologic_BMX]='Hologic Panther'  THEN RECEIVED_FAILED_reagent_quality_issues ELSE 0 END) AS Hologic_DBS_Quality_issue,
	 SUM(CASE WHEN [Type] = 'DBS VL' and [Platform_Roche_Abbott_Hologic_BMX]='Hologic Panther'  THEN RECEIVED_FAILED_QC_failure ELSE 0 END) AS Hologic_DBS_QC_Failure,
      SUM(CASE WHEN [Type] = 'DBS VL' and [Platform_Roche_Abbott_Hologic_BMX]='Hologic Panther'  THEN RECEIVED_FAILED_power_failure ELSE 0 END) AS Hologic_DBS_Power_Failure,
	   SUM(CASE WHEN [Type] = 'DBS VL' and [Platform_Roche_Abbott_Hologic_BMX]='Hologic Panther'  THEN RECEIVED_FAILED_mechanical_failure ELSE 0 END) AS Hologic_DBS_Mechanical_Failure,
	  SUM(CASE WHEN [Type] = 'DBS VL' and [Platform_Roche_Abbott_Hologic_BMX]='Hologic Panther'  THEN FAILED_RECEIVED_sample_processing_error ELSE 0 END) AS Hologic_DBS_Handling_Error
	  ,SUM(CASE WHEN [Type] = 'DBS VL' and [Platform_Roche_Abbott_Hologic_BMX]='Hologic Panther'  THEN RECEIVED_OTHER ELSE 0 END) AS Hologic_DBS_OTHER_Failure

	  	
	,STRING_AGG(c.combined_comments, ' ') AS Comments
   FROM  RUN_Base b

   left join  COMMENTTS c on c.name_of_lab=b.name_of_lab


   Group by b.name_of_lab