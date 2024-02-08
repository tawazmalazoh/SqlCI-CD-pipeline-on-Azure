
CREATE PROCEDURE [dbo].[sp_EIDreceived_model] AS 

	  



WITH BaseTable AS (
	  
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
	 ,[Sample_Type]+' '+ [Test_Type]  as [Type],
	sum ( cast(Carryover_Samples_in_the_lab as int)) Carryover_Samples_in_the_lab,
	sum ( cast ( Samples_in_backlog_Intra_lab_TAT_7_days  as int)) Samples_in_backlog_Intra_lab_TAT_7_days,
	sum ( cast (Total_samples_received as int) ) Total_samples_received,
	sum ( cast (Num_Rejected_Samples as int)) Num_Rejected_Samples,
	sum ( cast( REJECTED_too_old_to_test as int) ) REJECTED_too_old_to_test,
	sum ( cast(REJECTED_Quality_issue as int) ) REJECTED_Quality_issue,
	sum ( cast(REJECTED_Quantity_insuff as int) ) REJECTED_Quantity_insuff,
	sum ( cast(REJECTED_Quanti_Quali_intransit_compromised as int) ) REJECTED_Quanti_Quali_intransit_compromised,
	sum ( cast(REJECTED_Patient_SampleINFO as int) ) REJECTED_Patient_SampleINFO,
	sum ( cast(REJECTED_Missing_requestForm as int) )REJECTED_Missing_requestForm,
	sum ( cast(REJECTED_Sample_Missing as int) ) REJECTED_Sample_Missing,
	sum ( cast(REJECTED_other_reasons as int) ) REJECTED_other_reasons,
	sum ( cast(LIMS_hub_logged_prior_to_arrival as int) ) LIMS_hub_logged_prior_to_arrival,
	sum ( cast(LIMS_logged_during_week_of_arrival as int) ) LIMS_logged_during_week_of_arrival,
	sum ( cast(LIMs_Backlog_yetTObeEntered as int) ) LIMs_Backlog_yetTObeEntered
   FROM [LSS].[dbo].[Dash_This_week_Rec_Samples]
  where      CAST([date] AS DATE) >= DATEADD(DAY, -7, DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0))
      AND CAST([date] AS DATE) < DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0)
	  and status='Lab'
	  and  [Test_Type]='EID'
  group by CASE 
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
	END,[Sample_Type]+' '+[Test_Type]
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
	FROM [LSS].[dbo].[Dash_This_week_Rec_Samples]
	where  status='Lab'
	and   CAST([date] AS DATE) >= DATEADD(DAY, -7, DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0))
      AND CAST([date] AS DATE) < DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0)
	and [Test_Type]='EID'
	) as base 

	group by name_of_lab)


	 , cli_COMMENTTS AS (
  
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
	FROM [LSS].[dbo].Dash_CLI
	where  status='Lab'
	and   CAST([date] AS DATE) >= DATEADD(DAY, -7, DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0))
      AND CAST([date] AS DATE) < DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0)

	) as base 

	group by name_of_lab
	
	)


	 , referral_COMMENTTS AS (
  
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
	FROM [LSS].[dbo].Dash_Referred_Samples
	where  status='Lab'
	and   CAST([date] AS DATE) >= DATEADD(DAY, -7, DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0))
      AND CAST([date] AS DATE) < DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0)
	and [Test_Type]='EID'
	) as base 

	group by name_of_lab
	
	)


	 , LimsFxnality_COMMENTTS AS (
  
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
	FROM [LSS].[dbo].Dash_LIMS_Functionality
	where  status='Lab'
	and   CAST([date] AS DATE) >= DATEADD(DAY, -7, DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0))
      AND CAST([date] AS DATE) < DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0)

	) as base 

	group by name_of_lab
	
	)


SELECT 
b.name_of_lab Lab,
Carryover_Samples_in_the_lab,
 Samples_in_backlog_Intra_lab_TAT_7_days,
Total_samples_received,
	 Num_Rejected_Samples,
	  LIMS_logged_during_week_of_arrival,
	   LIMS_hub_logged_prior_to_arrival,
	   	
 LIMs_Backlog_yetTObeEntered,
 REJECTED_too_old_to_test,
 REJECTED_Quality_issue,
 REJECTED_Quantity_insuff,
 REJECTED_Quanti_Quali_intransit_compromised,
	 REJECTED_Patient_SampleINFO,
REJECTED_Missing_requestForm,
	 REJECTED_Sample_Missing,
 REJECTED_other_reasons


   --,combined_comments
   	,CONCAT_WS(' ', c.combined_comments ,n.combined_comments  ,
	               o.combined_comments , m.combined_comments) AS combined_comments

FROM 
    BaseTable b
	left join  COMMENTTS c on c.name_of_lab=b.name_of_lab
	LEFT JOIN LimsFxnality_COMMENTTS m ON m.name_of_lab=b.name_of_lab
   LEFT JOIN referral_COMMENTTS  n ON n.name_of_lab=b.name_of_lab
   LEFT JOIN cli_COMMENTTS o ON o.name_of_lab=b.name_of_lab