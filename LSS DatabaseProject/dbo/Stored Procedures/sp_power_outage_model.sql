
CREATE PROCEDURE [dbo].[sp_power_outage_model] AS 
 
 
 
 
 
 SELECT 
   CASE 
    WHEN Laboratory = 'Beitbridge - 100052 - District Hospital' THEN 'Beitbridge'
    WHEN Laboratory = 'Bindura - 100070 - Provincial Hospital' THEN 'Bindura'
    WHEN Laboratory = 'Beatrice Infectious - 100050 - Hospital' THEN 'BRIDH'
    WHEN Laboratory = 'Chinhoyi - 100235 - Provincial Hospital' THEN 'Chinhoyi'
    WHEN Laboratory = 'Gwanda - 100561 - Provincial Hospital' THEN 'Gwanda'
    WHEN Laboratory = 'Gweru - 100572 - Provincial Hospital' THEN 'Gweru'
    WHEN Laboratory = 'Kadoma - 100681 - District Hosp' THEN 'Kadoma'
    WHEN Laboratory = 'Marondera - 100903 - Provincial Hospital' THEN 'Marondera'
    WHEN Laboratory = 'Masvingo - 100937 - General Hospital' THEN 'Masvingo'
    WHEN Laboratory = 'Mpilo - 101041 - Central Hospital' THEN 'Mpilo'
    WHEN Laboratory = 'Mutare - 101165 - Provincial Hospital' THEN 'Mutare'
    WHEN Laboratory = 'National Reference Laboratory - 101206 - Laboratory' THEN 'NMRL'
    WHEN Laboratory = 'St. Lukes - 101645 - Mission Hospital' THEN 'St Lukes'
    WHEN Laboratory = 'Victoria Falls - 101739 - District Hospital' THEN 'Vic Falls'
    ELSE Laboratory
	END AS Laboratory
    

	  ,sum ( cast(Hours_with_no_electricity as float)) Hours_with_no_electricity,
	  sum (cast(Hours_generator_was_on as float)) Hours_generator_was_on,
	  sum(cast(Fuel_ltrs_added_to_generator as float)) Fuel_ltrs_added_to_generator,
	  sum (cast (Hrs_Machine_idle_coz_PowerCuts as float)) Hrs_Machine_idle_coz_PowerCuts,
	  sum (cast(Total_Tests_done_using_generator as float))  Total_Tests_done_using_generator,
	  max(Comments)  as Comments

	
  FROM [LSS].[dbo].Dash_Power_Outage
  WHERE  CAST([date] AS DATE) >= DATEADD(DAY, -7, DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0))
   AND CAST([date] AS DATE) < DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0)

   Group by  CASE 
    WHEN Laboratory = 'Beitbridge - 100052 - District Hospital' THEN 'Beitbridge'
    WHEN Laboratory = 'Bindura - 100070 - Provincial Hospital' THEN 'Bindura'
    WHEN Laboratory = 'Beatrice Infectious - 100050 - Hospital' THEN 'BRIDH'
    WHEN Laboratory = 'Chinhoyi - 100235 - Provincial Hospital' THEN 'Chinhoyi'
    WHEN Laboratory = 'Gwanda - 100561 - Provincial Hospital' THEN 'Gwanda'
    WHEN Laboratory = 'Gweru - 100572 - Provincial Hospital' THEN 'Gweru'
    WHEN Laboratory = 'Kadoma - 100681 - District Hosp' THEN 'Kadoma'
    WHEN Laboratory = 'Marondera - 100903 - Provincial Hospital' THEN 'Marondera'
    WHEN Laboratory = 'Masvingo - 100937 - General Hospital' THEN 'Masvingo'
    WHEN Laboratory = 'Mpilo - 101041 - Central Hospital' THEN 'Mpilo'
    WHEN Laboratory = 'Mutare - 101165 - Provincial Hospital' THEN 'Mutare'
    WHEN Laboratory = 'National Reference Laboratory - 101206 - Laboratory' THEN 'NMRL'
    WHEN Laboratory = 'St. Lukes - 101645 - Mission Hospital' THEN 'St Lukes'
    WHEN Laboratory = 'Victoria Falls - 101739 - District Hospital' THEN 'Vic Falls'
    ELSE Laboratory
	END