
CREATE PROCEDURE [dbo].[sp_VL_sample_run_model] AS 
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
   END  AS [Platform_Roche_Abbott_Hologic_BMX]

	  ,sum ( cast(RECEIVED_TOTAL_Sample_RUN as int)) Samples_run,
	  sum (cast(RECEIVED_FAILED_bt_Elig_REPEAT as int)) Fail_elig_repeat,
	  sum(cast(RECEIVED_FAILED_bt_NOT_Elig_REPEAT as int)) Fail_NOT_elig_repeat,
	  sum (cast (RECEIVED_REPEATS_RUN as int)) retest_run,
	  sum (cast(RECEIVED_FAILED_after_FINAL_repeat_testing as int))  Failed_tests_after_final

	
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
      SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche CAPCTM' THEN Samples_run ELSE 0 END) AS Roche_Plasma_Sample_Run,
	  SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche CAPCTM' THEN Fail_elig_repeat ELSE 0 END) AS Roche_Plasma_Fail_elig_repeat,
	 SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche CAPCTM' THEN Fail_NOT_elig_repeat ELSE 0 END) AS Roche_Plasma_Fail_NOT_elig_repeat,
      SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche CAPCTM' THEN retest_run ELSE 0 END) AS Roche_Plasma_retest_run,
	   SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche CAPCTM' THEN Failed_tests_after_final ELSE 0 END) AS Roche_Plasma_Failed_tests_after_final,
    
	 SUM(CASE WHEN [Type] = 'DBS VL'  and [Platform_Roche_Abbott_Hologic_BMX]='Roche CAPCTM' THEN Samples_run ELSE 0 END) AS Roche_DBS_Sample_Run,	
      SUM(CASE WHEN [Type] = 'DBS VL'  and [Platform_Roche_Abbott_Hologic_BMX]='Roche CAPCTM' THEN Fail_elig_repeat ELSE 0 END) AS Roche_DBS_Fail_elig_repeat, 
      SUM(CASE WHEN [Type] = 'DBS VL'  and [Platform_Roche_Abbott_Hologic_BMX]='Roche CAPCTM' THEN Fail_NOT_elig_repeat ELSE 0 END) AS Roche_DBS_Fail_NOT_elig_repeat,	  
      SUM(CASE WHEN [Type] = 'DBS VL'  and [Platform_Roche_Abbott_Hologic_BMX]='Roche CAPCTM' THEN retest_run ELSE 0 END) AS Roche_DBS_retest_run,
	  SUM(CASE WHEN [Type] = 'DBS VL'  and [Platform_Roche_Abbott_Hologic_BMX]='Roche CAPCTM' THEN Failed_tests_after_final ELSE 0 END) AS Roche_DBS_Failed_tests_after_final,

     --ROche cobbas
      SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche Cobas' THEN Samples_run ELSE 0 END) AS Cobas_Plasma_Sample_Run,
	    SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche Cobas' THEN Fail_elig_repeat ELSE 0 END) AS Cobas_Plasma_Fail_elig_repeat,
		SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche Cobas' THEN Fail_NOT_elig_repeat ELSE 0 END) AS Cobas_Plasma_Fail_NOT_elig_repeat,
		SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche Cobas' THEN retest_run ELSE 0 END) AS Cobas_Plasma_retest_run,
        SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche Cobas' THEN Failed_tests_after_final ELSE 0 END) AS Cobas_Plasma_Failed_tests_after_final,
    
	  SUM(CASE WHEN [Type] = 'DBS VL'  and [Platform_Roche_Abbott_Hologic_BMX]='Roche Cobas' THEN Samples_run ELSE 0 END) AS Cobas_DBS_Sample_Run,	
      SUM(CASE WHEN [Type] = 'DBS VL'  and [Platform_Roche_Abbott_Hologic_BMX]='Roche Cobas' THEN Fail_elig_repeat ELSE 0 END) AS Cobas_DBS_Fail_elig_repeat,	  
      SUM(CASE WHEN [Type] = 'DBS VL'  and [Platform_Roche_Abbott_Hologic_BMX]='Roche Cobas' THEN Fail_NOT_elig_repeat ELSE 0 END) AS Cobas_DBS_Fail_NOT_elig_repeat,	  
      SUM(CASE WHEN [Type] = 'DBS VL'  and [Platform_Roche_Abbott_Hologic_BMX]='Roche Cobas' THEN retest_run ELSE 0 END) AS Cobas_DBS_retest_run,
	  SUM(CASE WHEN [Type] = 'DBS VL'  and [Platform_Roche_Abbott_Hologic_BMX]='Roche Cobas' THEN Failed_tests_after_final ELSE 0 END) AS Cobas_DBS_Failed_tests_after_final,

	-- Abbott

	  SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Abbott' THEN Samples_run ELSE 0 END) AS Abbott_Plasma_Sample_Run,
	    SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Abbott' THEN Fail_elig_repeat ELSE 0 END) AS Abbott_Plasma_Fail_elig_repeat,
		 SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Abbott' THEN Fail_NOT_elig_repeat ELSE 0 END) AS Abbott_Plasma_Fail_NOT_elig_repeat,
		 SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Abbott' THEN retest_run ELSE 0 END) AS Abbott_Plasma_retest_run,		 
	  SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Abbott' THEN Failed_tests_after_final ELSE 0 END) AS Abbott_Plasma_Failed_tests_after_final,
   

      SUM(CASE WHEN [Type] = 'DBS VL'  and [Platform_Roche_Abbott_Hologic_BMX]='Abbott' THEN Samples_run ELSE 0 END) AS Abbott_DBS_Sample_Run,	
      SUM(CASE WHEN [Type] = 'DBS VL'  and [Platform_Roche_Abbott_Hologic_BMX]='Abbott' THEN Fail_elig_repeat ELSE 0 END) AS Abbott_DBS_Fail_elig_repeat,	 
      SUM(CASE WHEN [Type] = 'DBS VL'  and [Platform_Roche_Abbott_Hologic_BMX]='Abbott' THEN Fail_NOT_elig_repeat ELSE 0 END) AS Abbott_DBS_Fail_NOT_elig_repeat,	  
      SUM(CASE WHEN [Type] = 'DBS VL'  and [Platform_Roche_Abbott_Hologic_BMX]='Abbott' THEN retest_run ELSE 0 END) AS Abbott_DBS_retest_run,
      SUM(CASE WHEN [Type] = 'DBS VL'  and [Platform_Roche_Abbott_Hologic_BMX]='Abbott' THEN Failed_tests_after_final ELSE 0 END) AS Abbott_DBS_Failed_tests_after_final,

-- Hologic

	  SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Hologic Panther' THEN Samples_run ELSE 0 END) AS Hologic_Plasma_Sample_Run,
	 SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Hologic Panther' THEN Fail_elig_repeat ELSE 0 END) AS Hologic_Plasma_Fail_elig_repeat,
     SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Hologic Panther' THEN Fail_NOT_elig_repeat ELSE 0 END) AS Hologic_Plasma_Fail_NOT_elig_repeat,
     SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Hologic Panther' THEN retest_run ELSE 0 END) AS Hologic_Plasma_retest_run,
     SUM(CASE WHEN [Type] = 'Plasma VL' and [Platform_Roche_Abbott_Hologic_BMX]='Hologic Panther' THEN Failed_tests_after_final ELSE 0 END) AS Hologic_Plasma_Failed_tests_after_final,
    
      SUM(CASE WHEN [Type] = 'DBS VL'  and [Platform_Roche_Abbott_Hologic_BMX]='Hologic Panther' THEN Samples_run ELSE 0 END) AS Hologic_DBS_Sample_Run,	 
      SUM(CASE WHEN [Type] = 'DBS VL'  and [Platform_Roche_Abbott_Hologic_BMX]='Hologic Panther' THEN Fail_elig_repeat ELSE 0 END) AS Hologic_DBS_Fail_elig_repeat,
	  SUM(CASE WHEN [Type] = 'DBS VL'  and [Platform_Roche_Abbott_Hologic_BMX]='Hologic Panther' THEN Fail_NOT_elig_repeat ELSE 0 END) AS Hologic_DBS_Fail_NOT_elig_repeat,
	   SUM(CASE WHEN [Type] = 'DBS VL'  and [Platform_Roche_Abbott_Hologic_BMX]='Hologic Panther' THEN retest_run ELSE 0 END) AS Hologic_DBS_retest_run,
	   SUM(CASE WHEN [Type] = 'DBS VL'  and [Platform_Roche_Abbott_Hologic_BMX]='Hologic Panther' THEN Failed_tests_after_final ELSE 0 END) AS Hologic_DBS_Failed_tests_after_final
     ,MAX(c.combined_comments) AS Comments
   FROM  RUN_Base b

   left join  COMMENTTS c on c.name_of_lab=b.name_of_lab


   Group by b.name_of_lab