
CREATE PROCEDURE [dbo].[sp_Referral_model] AS 

WITH Labs AS (

select *
from DATIM_Facility_names d
 where d.status='Lab'),


BASICS as (
  SELECT 
   d.lab name_of_lab
     ,[Sample_Type]+' '+ [Test_Type]  as [Type]
     ,sum ( cast(Samples_reffered_Out as int)) Samples_reffered_Out
	 
	 ,STRING_AGG(	 
	  CASE 
    WHEN Lab_Samples_referred_to = 'Beitbridge - 100052 - District Hospital' THEN 'Beitbridge'
    WHEN Lab_Samples_referred_to = 'Bindura - 100070 - Provincial Hospital' THEN 'Bindura'
    WHEN Lab_Samples_referred_to = 'Beatrice Infectious - 100050 - Hospital' THEN 'BRIDH'
    WHEN Lab_Samples_referred_to = 'Chinhoyi - 100235 - Provincial Hospital' THEN 'Chinhoyi'
    WHEN Lab_Samples_referred_to = 'Gwanda - 100561 - Provincial Hospital' THEN 'Gwanda'
    WHEN Lab_Samples_referred_to = 'Gweru - 100572 - Provincial Hospital' THEN 'Gweru'
    WHEN Lab_Samples_referred_to = 'Kadoma - 100681 - District Hosp' THEN 'Kadoma'
    WHEN Lab_Samples_referred_to = 'Marondera - 100903 - Provincial Hospital' THEN 'Marondera'
    WHEN Lab_Samples_referred_to = 'Masvingo - 100937 - General Hospital' THEN 'Masvingo'
    WHEN Lab_Samples_referred_to = 'Mpilo - 101041 - Central Hospital' THEN 'Mpilo'
    WHEN Lab_Samples_referred_to = 'Mutare - 101165 - Provincial Hospital' THEN 'Mutare'
    WHEN Lab_Samples_referred_to = 'National Reference Laboratory - 101206 - Laboratory' THEN 'NMRL'
    WHEN Lab_Samples_referred_to = 'St. Lukes - 101645 - Mission Hospital' THEN 'St Lukes'
    WHEN Lab_Samples_referred_to = 'Victoria Falls - 101739 - District Hospital' THEN 'Vic Falls'
    ELSE Lab_Samples_referred_to
	END 
	 
	 , ', ') AS refered_to_lab
	 ,sum(cast(Referred_Sample_Received as int)) Referred_Sample_Received
	  ,STRING_AGG(  
	  
	  CASE 
    WHEN Referred_From = 'Beitbridge - 100052 - District Hospital' THEN 'Beitbridge'
    WHEN Referred_From = 'Bindura - 100070 - Provincial Hospital' THEN 'Bindura'
    WHEN Referred_From = 'Beatrice Infectious - 100050 - Hospital' THEN 'BRIDH'
    WHEN Referred_From = 'Chinhoyi - 100235 - Provincial Hospital' THEN 'Chinhoyi'
    WHEN Referred_From = 'Gwanda - 100561 - Provincial Hospital' THEN 'Gwanda'
    WHEN Referred_From = 'Gweru - 100572 - Provincial Hospital' THEN 'Gweru'
    WHEN Referred_From = 'Kadoma - 100681 - District Hosp' THEN 'Kadoma'
    WHEN Referred_From = 'Marondera - 100903 - Provincial Hospital' THEN 'Marondera'
    WHEN Referred_From = 'Masvingo - 100937 - General Hospital' THEN 'Masvingo'
    WHEN Referred_From = 'Mpilo - 101041 - Central Hospital' THEN 'Mpilo'
    WHEN Referred_From = 'Mutare - 101165 - Provincial Hospital' THEN 'Mutare'
    WHEN Referred_From = 'National Reference Laboratory - 101206 - Laboratory' THEN 'NMRL'
    WHEN Referred_From = 'St. Lukes - 101645 - Mission Hospital' THEN 'St Lukes'
    WHEN Referred_From = 'Victoria Falls - 101739 - District Hospital' THEN 'Vic Falls'
    ELSE Referred_From
	END 
	  
	  , ', ') AS Referred_From_lab
	 

FROM  Labs d
LEFT JOIN [LSS].[dbo].Dash_Referred_Samples r on d.Facility=r.Name_of_Lab
  --[Platform_Roche_Abbott_Hologic_BMX] in ('Roche','Roche CAPCTM','Roche 2','Abbott','Abbott 1','Abbott 2','Roche C8800','Roche C5800','Roche Cobass 8800','Cobas 8800','Roche C6800','Hologic Panther' )
    AND CAST([date] AS DATE) >= DATEADD(DAY, -7, DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0))
   AND CAST([date] AS DATE) < DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0)
   and r.status='Lab'


   --and  [Test_Type]= 'VL'
   Group by   d.lab  ,[Sample_Type]+' '+ [Test_Type]


	 ),

	 AGGREGATED_LABS AS (
    SELECT
        name_of_lab,
        [Type],
        STRING_AGG(refered_to_lab, ', ') AS refered_to_lab,
		STRING_AGG(Referred_From_lab, ', ') AS Referred_From_labs
    FROM BASICS
    GROUP BY name_of_lab, [Type]
),

LIMSFXN AS (

select  
 d.lab  as nam
,sum(cast(Hours_of_Functionality as float)) Hrs_of_Fxnty


from Dash_LIMS_Functionality r,DATIM_Facility_names d
 
  WHERE r.name_of_lab=d.facility
   and   CAST([date] AS DATE) >= DATEADD(DAY, -7, DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0))
      AND CAST([date] AS DATE) < DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0)
	  and  r.status='Lab'
	  

group by lab
	)

	,REF_FROM_STATS as (
SELECT 

   CASE 
    WHEN Lab_Samples_referred_to = 'Beitbridge - 100052 - District Hospital' THEN 'Beitbridge'
    WHEN Lab_Samples_referred_to = 'Bindura - 100070 - Provincial Hospital' THEN 'Bindura'
    WHEN Lab_Samples_referred_to = 'Beatrice Infectious - 100050 - Hospital' THEN 'BRIDH'
    WHEN Lab_Samples_referred_to = 'Chinhoyi - 100235 - Provincial Hospital' THEN 'Chinhoyi'
    WHEN Lab_Samples_referred_to = 'Gwanda - 100561 - Provincial Hospital' THEN 'Gwanda'
    WHEN Lab_Samples_referred_to = 'Gweru - 100572 - Provincial Hospital' THEN 'Gweru'
    WHEN Lab_Samples_referred_to = 'Kadoma - 100681 - District Hosp' THEN 'Kadoma'
    WHEN Lab_Samples_referred_to = 'Marondera - 100903 - Provincial Hospital' THEN 'Marondera'
    WHEN Lab_Samples_referred_to = 'Masvingo - 100937 - General Hospital' THEN 'Masvingo'
    WHEN Lab_Samples_referred_to = 'Mpilo - 101041 - Central Hospital' THEN 'Mpilo'
    WHEN Lab_Samples_referred_to = 'Mutare - 101165 - Provincial Hospital' THEN 'Mutare'
    WHEN Lab_Samples_referred_to = 'National Reference Laboratory - 101206 - Laboratory' THEN 'NMRL'
    WHEN Lab_Samples_referred_to = 'St. Lukes - 101645 - Mission Hospital' THEN 'St Lukes'
    WHEN Lab_Samples_referred_to = 'Victoria Falls - 101739 - District Hospital' THEN 'Vic Falls'
    ELSE Lab_Samples_referred_to
	END Referred_From

	 ,[Sample_Type]+' '+ [Test_Type]  as [Type]
	 ,sum ( cast(Samples_reffered_Out as int)) Samples_reffered_Out

	  ,STRING_AGG(
	  CASE 
    WHEN r.name_of_lab = 'Beitbridge - 100052 - District Hospital' THEN 'Beitbridge'
    WHEN r.name_of_lab = 'Bindura - 100070 - Provincial Hospital' THEN 'Bindura'
    WHEN r.name_of_lab = 'Beatrice Infectious - 100050 - Hospital' THEN 'BRIDH'
    WHEN r.name_of_lab = 'Chinhoyi - 100235 - Provincial Hospital' THEN 'Chinhoyi'
    WHEN r.name_of_lab = 'Gwanda - 100561 - Provincial Hospital' THEN 'Gwanda'
    WHEN r.name_of_lab = 'Gweru - 100572 - Provincial Hospital' THEN 'Gweru'
    WHEN r.name_of_lab = 'Kadoma - 100681 - District Hosp' THEN 'Kadoma'
    WHEN r.name_of_lab = 'Marondera - 100903 - Provincial Hospital' THEN 'Marondera'
    WHEN r.name_of_lab = 'Masvingo - 100937 - General Hospital' THEN 'Masvingo'
    WHEN r.name_of_lab = 'Mpilo - 101041 - Central Hospital' THEN 'Mpilo'
    WHEN r.name_of_lab = 'Mutare - 101165 - Provincial Hospital' THEN 'Mutare'
    WHEN r.name_of_lab = 'National Reference Laboratory - 101206 - Laboratory' THEN 'NMRL'
    WHEN r.name_of_lab = 'St. Lukes - 101645 - Mission Hospital' THEN 'St Lukes'
    WHEN r.name_of_lab = 'Victoria Falls - 101739 - District Hospital' THEN 'Vic Falls'
    ELSE r.name_of_lab
	END 
	  , ', ') AS by_lab

FROM  Labs d

LEFT JOIN [LSS].[dbo].Dash_Referred_Samples r on d.Facility=r.Name_of_Lab
AND   CAST(r.[date] AS DATE) >= DATEADD(DAY, -7, DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0))
 AND CAST(r.[date] AS DATE) < DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0)
 and r.Test_type='VL'
 and r.status='Lab'

 group by CASE 
    WHEN Lab_Samples_referred_to = 'Beitbridge - 100052 - District Hospital' THEN 'Beitbridge'
    WHEN Lab_Samples_referred_to = 'Bindura - 100070 - Provincial Hospital' THEN 'Bindura'
    WHEN Lab_Samples_referred_to = 'Beatrice Infectious - 100050 - Hospital' THEN 'BRIDH'
    WHEN Lab_Samples_referred_to = 'Chinhoyi - 100235 - Provincial Hospital' THEN 'Chinhoyi'
    WHEN Lab_Samples_referred_to = 'Gwanda - 100561 - Provincial Hospital' THEN 'Gwanda'
    WHEN Lab_Samples_referred_to = 'Gweru - 100572 - Provincial Hospital' THEN 'Gweru'
    WHEN Lab_Samples_referred_to = 'Kadoma - 100681 - District Hosp' THEN 'Kadoma'
    WHEN Lab_Samples_referred_to = 'Marondera - 100903 - Provincial Hospital' THEN 'Marondera'
    WHEN Lab_Samples_referred_to = 'Masvingo - 100937 - General Hospital' THEN 'Masvingo'
    WHEN Lab_Samples_referred_to = 'Mpilo - 101041 - Central Hospital' THEN 'Mpilo'
    WHEN Lab_Samples_referred_to = 'Mutare - 101165 - Provincial Hospital' THEN 'Mutare'
    WHEN Lab_Samples_referred_to = 'National Reference Laboratory - 101206 - Laboratory' THEN 'NMRL'
    WHEN Lab_Samples_referred_to = 'St. Lukes - 101645 - Mission Hospital' THEN 'St Lukes'
    WHEN Lab_Samples_referred_to = 'Victoria Falls - 101739 - District Hospital' THEN 'Vic Falls'
    ELSE Lab_Samples_referred_to
	END  ,[Sample_Type]+' '+ [Test_Type] 

	)

,type_and_lab as(
SELECT xm.lab, 'Plasma VL' AS [Type]
FROM Labs xm
UNION ALL
SELECT xm.lab, 'DBS VL' AS [Type]
FROM Labs xm
)




SELECT
    b.name_of_lab, Max( cast(Hrs_of_Fxnty as int)) Hrs_of_Fxnty ,
    SUM(CASE WHEN b.[Type] = 'Plasma VL' THEN b.Samples_reffered_Out ELSE 0 END) AS Plasma_Samples_reffered_Out,
    SUM(CASE WHEN b.[Type] = 'DBS VL' THEN b.Samples_reffered_Out ELSE 0 END) AS DBS_Samples_reffered_Out,
    isnull(MAX(CASE WHEN b.[Type] = 'Plasma VL' THEN a.refered_to_lab ELSE NULL END),0) AS Plasma_refered_to_lab,
    isnull(MAX(CASE WHEN b.[Type] = 'DBS VL' THEN a.refered_to_lab ELSE NULL END),0) AS DBS_refered_to_lab,

    MAX(CASE WHEN f.[Type] = 'Plasma VL' THEN f.Samples_reffered_Out ELSE 0 END) AS Plasma_Referred_Sample_Received,
    MAX(CASE WHEN f.[Type] = 'DBS VL' THEN f.Samples_reffered_Out ELSE 0 END) AS DBS_Referred_Sample_Received,

    isnull(MAX(CASE WHEN f.[Type] = 'Plasma VL' THEN f.by_lab ELSE NULL END),0) AS Plasma_Referred_From_lab,
    isnull(MAX(CASE WHEN f.[Type] = 'DBS VL' THEN f.by_lab ELSE NULL END),0) AS DBS_Referred_From_lab
FROM Labs l 
Left Join LIMSFXN xx on l.Lab=xx.nam
Left Join BASICS b on  l.lab=b.name_of_lab

LEFT JOIN AGGREGATED_LABS a ON b.name_of_lab = a.name_of_lab AND b.[Type] = a.[Type]
left JOIN REF_FROM_STATS f ON l.lab = f.Referred_From  --AND a.[Type] = f.[Type]
GROUP BY b.name_of_lab;