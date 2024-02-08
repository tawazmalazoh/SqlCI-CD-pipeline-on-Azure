
CREATE PROCEDURE [dbo].[sp_Downtime_model] AS 


  
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
     , [Test_Type]  as [Type]
	 ,MAX(cast(Hrs_in_Shift as int)) Hrs_in_Shift
      ,	    
   CASE
   WHEN [Platform_Roche_Abbott_Hologic_BMX] in ('Roche','Roche CAPCTM') THEN 'Roche 1'
   WHEN	[Platform_Roche_Abbott_Hologic_BMX]	 in ('Roche 2') THEN 'Roche 2'
   WHEN  [Platform_Roche_Abbott_Hologic_BMX] in ('Roche C5800','Roche Cobass 8800','Cobas 8800','Roche C6800','Roche C8800') THEN 'Roche Cobas'
   WHEN [Platform_Roche_Abbott_Hologic_BMX] in ('Abbott','Abbott 1') THEN 'Abbott 1'
   WHEN [Platform_Roche_Abbott_Hologic_BMX]    in ('Abbott 2') THEN 'Abbott 2'
   WHEN [Platform_Roche_Abbott_Hologic_BMX] in ('Hologic Panther' ) THEN  'Hologic Panther'
   ELSE [Platform_Roche_Abbott_Hologic_BMX]
   END  AS [Platform_Roche_Abbott_Hologic_BMX]
     
	  ,sum ( cast(Downtime_Power_Outage as int)) Downtime_Power_Outage,
	  sum (cast(Downtime_Mechanical_Failure as int)) Downtime_Mechanical_Failure,
	  sum(cast(Downtime_Reagent_Stockout_Expiry as int)) Downtime_Reagent_Stockout_Expiry,
	  sum (cast (Downtime_Controls_Stockout_Expiry as int)) Downtime_Controls_Stockout_Expiry,
	  sum (cast(Downtime_Controls_Failure as int))  Downtime_Controls_Failure,
	  sum (cast(Downtime_Staff_Unavailability as int))  Downtime_Staff_Unavailability,
	    sum (cast(Downtime_coz_other_reasons as int))  Downtime_coz_other_reasons

  FROM [LSS].[dbo].[Dash_Lab_Metrics_Waste_Mgt]
  WHERE [Platform_Roche_Abbott_Hologic_BMX] in ('Roche','Roche CAPCTM','Roche 2','Abbott','Abbott 1','Abbott 2','Roche C8800','Roche C5800','Roche Cobass 8800','Cobas 8800','Roche C6800','Hologic Panther' )
   and  CAST([date] AS DATE) >= DATEADD(DAY, -7, DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0))
   AND CAST([date] AS DATE) < DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0)
   and status='Lab'
   and  [Test_Type] in ('VL' ,'VL/EID')
   and [Platform_Roche_Abbott_Hologic_BMX] !='GeneXpert'
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
     , [Test_Type],       
   CASE
   WHEN [Platform_Roche_Abbott_Hologic_BMX] in ('Roche','Roche CAPCTM') THEN 'Roche 1'
   WHEN	[Platform_Roche_Abbott_Hologic_BMX]	 in ('Roche 2') THEN 'Roche 2'
   WHEN  [Platform_Roche_Abbott_Hologic_BMX] in ('Roche C5800','Roche Cobass 8800','Cobas 8800','Roche C6800','Roche C8800') THEN 'Roche Cobas'
   WHEN [Platform_Roche_Abbott_Hologic_BMX] in ('Abbott','Abbott 1') THEN 'Abbott 1'
   WHEN [Platform_Roche_Abbott_Hologic_BMX]    in ('Abbott 2') THEN 'Abbott 2'
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
	END AS name_of_lab, [Comments_on_ErrorCodes_for_Mach_failure] comments	
	FROM [LSS].[dbo].[Dash_Lab_Metrics_Waste_Mgt]
	where  status='Lab'
	and   CAST([date] AS DATE) >= DATEADD(DAY, -7, DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0))
      AND CAST([date] AS DATE) < DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0)
	and  [Test_Type] in ('VL' ,'VL/EID')
	 and [Platform_Roche_Abbott_Hologic_BMX] !='GeneXpert'
	) as base 

	group by name_of_lab)


	 , Testing_capacity_COMMENTTS AS (
  
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
	END AS name_of_lab, Comments_Reagent_Stock_Status comments	
	FROM [LSS].[dbo].Dash_Testing_Capacity
	where  status='Lab'
	and   CAST([date] AS DATE) >= DATEADD(DAY, -7, DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0))
      AND CAST([date] AS DATE) < DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0)
	and [Test_Type]='VL'
	) as base 

	group by name_of_lab
	
	)



   select  b.name_of_lab,

   --Roche

	CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE
            cast(SUM(CASE WHEN ([Type] = 'VL' or [Type] = 'VL/EID') AND [Platform_Roche_Abbott_Hologic_BMX] = 'Roche 1' THEN Downtime_Power_Outage ELSE 0 END) as float) / MAX(isnull(Hrs_in_Shift, 0))
    END AS Roche_1_Downtime_Power_Outage,


 CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE
    cast(SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]='Roche 1' THEN Downtime_Mechanical_Failure ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,0)) END AS Roche_1_Downtime_Mechanical_Failure,
   
   CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE cast(SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]='Roche 1' THEN Downtime_Reagent_Stockout_Expiry ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,0)) END AS Roche_1_Downtime_Reagent_Stockout_Expiry,
   CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE    cast(SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]='Roche 1' THEN Downtime_Controls_Stockout_Expiry ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,0)) END AS Roche_1_Downtime_Controls_Stockout_Expiry,
	 CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE  cast( SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]='Roche 1' THEN Downtime_Controls_Failure ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,0))END AS Roche_1_Downtime_Controls_Failure,
 CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE  cast( SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]='Roche 1' THEN Downtime_Staff_Unavailability ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,0))END AS Roche_1_Downtime_Staff_Unavailability,
   CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE  cast(  SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]='Roche 1' THEN Downtime_coz_other_reasons ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,0))END AS Roche_1_Downtime_coz_other_reasons,

-- roche 2
	 CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE     cast(   SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]='Roche 2' THEN Downtime_Power_Outage ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Roche_2_Downtime_Power_Outage,
 CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE	 cast( SUM(CASE WHEN [Type] = 'VL' and [Platform_Roche_Abbott_Hologic_BMX]='Roche 2' THEN Downtime_Mechanical_Failure ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Roche_2_Downtime_Mechanical_Failure,
 CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE	cast( SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]='Roche 2' THEN Downtime_Reagent_Stockout_Expiry ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Roche_2_Downtime_Reagent_Stockout_Expiry,
  CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE   cast(  SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]='Roche 2' THEN Downtime_Controls_Stockout_Expiry ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Roche_2_Downtime_Controls_Stockout_Expiry,
 CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE	cast(   SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]='Roche 2' THEN Downtime_Controls_Failure ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Roche_2_Downtime_Controls_Failure,
  CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE cast( SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]='Roche 2' THEN Downtime_Staff_Unavailability ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Roche_2_Downtime_Staff_Unavailability,
   CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE   cast( SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]='Roche 2' THEN Downtime_coz_other_reasons ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Roche_2_Downtime_coz_other_reasons,

     --ROche cobbas
	 CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE    cast(    SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]='Roche Cobas' THEN Downtime_Power_Outage ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Cobas_Downtime_Power_Outage,
 CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE	cast(  SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]='Roche Cobas' THEN Downtime_Mechanical_Failure ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Cobas_Downtime_Mechanical_Failure,
 CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE	cast( SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]='Roche Cobas' THEN Downtime_Reagent_Stockout_Expiry ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Cobas_Downtime_Reagent_Stockout_Expiry,
  CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE  cast(   SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]='Roche Cobas' THEN Downtime_Controls_Stockout_Expiry ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Cobas_Downtime_Controls_Stockout_Expiry,
 CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE	cast(   SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]='Roche Cobas' THEN Downtime_Controls_Failure ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Cobas_Downtime_Controls_Failure,
  CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE cast( SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]='Roche Cobas' THEN Downtime_Staff_Unavailability ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Cobas_Downtime_Staff_Unavailability,
 CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE   cast(   SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]='Roche Cobas' THEN Downtime_coz_other_reasons ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Cobas_Downtime_coz_other_reasons,
   
	-- Abbott

 CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE	cast(  SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]='Abbott 1' THEN Downtime_Power_Outage ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Abbott_1_Downtime_Power_Outage,
 CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE	cast(  SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]='Abbott 1' THEN Downtime_Mechanical_Failure ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Abbott_1_Downtime_Mechanical_Failure,
 CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE	cast( SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]='Abbott 1' THEN Downtime_Reagent_Stockout_Expiry ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Abbott_1_Downtime_Reagent_Stockout_Expiry,
  CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE  cast(   SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]='Abbott 1' THEN Downtime_Controls_Stockout_Expiry ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Abbott_1_Downtime_Controls_Stockout_Expiry,
 CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE	cast(   SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]='Abbott 1' THEN Downtime_Controls_Failure ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Abbott_1_Downtime_Controls_Failure,
  CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE cast( SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]='Abbott 1' THEN Downtime_Staff_Unavailability ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Abbott_1_Downtime_Staff_Unavailability,
 CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE  cast(    SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]='Abbott 1' THEN Downtime_coz_other_reasons ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Abbott_1_Downtime_coz_other_reasons,
   


   -- Abbot 2
  CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE cast(   SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]='Abbott 2' THEN Downtime_Power_Outage ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Abbott_2_Downtime_Power_Outage,
 CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE cast(	  SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]='Abbott 2' THEN Downtime_Mechanical_Failure ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Abbott_2_Downtime_Mechanical_Failure,
 CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE cast(	 SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]='Abbott 2' THEN Downtime_Reagent_Stockout_Expiry ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Abbott_2_Downtime_Reagent_Stockout_Expiry,
  CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE cast(    SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]='Abbott 2' THEN Downtime_Controls_Stockout_Expiry ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Abbott_2_Downtime_Controls_Stockout_Expiry,
  CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE   cast(	   SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]='Abbott 2' THEN Downtime_Controls_Failure ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Abbott_2_Downtime_Controls_Failure,
   CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE cast(  SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]='Abbott 2' THEN Downtime_Staff_Unavailability ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Abbott_2_Downtime_Staff_Unavailability,
   CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE cast(    SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]='Abbott 1' THEN Downtime_coz_other_reasons ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Abbott_2_Downtime_coz_other_reasons,
   
-- Hologic

 CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE	cast(    SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]= 'Hologic Panther' THEN Downtime_Power_Outage ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Hologic_Downtime_Power_Outage,
 CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE	cast(  SUM(CASE WHEN ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]= 'Hologic Panther' THEN Downtime_Mechanical_Failure ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Hologic_Downtime_Mechanical_Failure,
 CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE	cast( SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]= 'Hologic Panther' THEN Downtime_Reagent_Stockout_Expiry ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Hologic_Downtime_Reagent_Stockout_Expiry,
 CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE   cast(   SUM(CASE WHEN ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]= 'Hologic Panther' THEN Downtime_Controls_Stockout_Expiry ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Hologic_Downtime_Controls_Stockout_Expiry,
 CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE	cast(   SUM(CASE WHEN ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]= 'Hologic Panther' THEN Downtime_Controls_Failure ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Hologic_Downtime_Controls_Failure,
 CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE cast(  SUM(CASE WHEN ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]= 'Hologic Panther' THEN Downtime_Staff_Unavailability ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Hologic_Downtime_Staff_Unavailability,
  CASE
        WHEN MAX(isnull(Hrs_in_Shift, 0)) = 0 THEN 0 -- Handle division by zero
        ELSE cast(    SUM(CASE WHEN  ([Type] = 'VL' or [Type]='VL/EID') and [Platform_Roche_Abbott_Hologic_BMX]= 'Hologic Panther' THEN Downtime_coz_other_reasons ELSE 0 END) as float)/MAX(isnull(Hrs_in_Shift,1))END AS Hologic_Downtime_coz_other_reasons,

     --STRING_AGG(c.combined_comments, '; ') AS Comments

	 MAX (CONCAT_WS(', ', c.combined_comments , m.combined_comments)) AS Comments

   FROM  RUN_Base b

   left join  COMMENTTS c on c.name_of_lab=b.name_of_lab
   LEFT JOIN Testing_capacity_COMMENTTS m ON m.name_of_lab=b.name_of_lab


   Group by b.name_of_lab