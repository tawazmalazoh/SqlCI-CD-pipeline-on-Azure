
CREATE PROCEDURE sp_Referral_Reasons_model AS 


  
  WITH refrxn_Base  AS (
  
  
  SELECT 
      d.lab
     ,[Sample_Type]+' '+ [Test_Type]  as [Type]
	  ,sum (isnull(cast(REFERRED_Other_rexns as int),0) )  REFERRED_Other_rexns
	  ,sum ( isnull(cast(REFERRED_Reagent_Stockout as int),0)) REFERRED_Reagent_Stockout,
	  sum ( isnull(cast(REFERRED_Instrument_Failure as int),0)) REFERRED_Instrument_Failure,
	    sum ( isnull(cast (REFERRED_Insuff_Instrument_Capacity as int),0)) REFERRED_Insuff_Instrument_Capacity,
	  sum( isnull(cast(REFERRED_Insuff_HR_Capacity as int),0)) REFERRED_Insuff_HR_Capacity


  FROM DATIM_Facility_names d  
  LEFT JOIN  [LSS].[dbo].Dash_Referred_Samples r on d.Facility=r.name_of_lab
   WHERE  CAST([date] AS DATE) >= DATEADD(DAY, -7, DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0))
   AND CAST([date] AS DATE) < DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0)
   and r.status='Lab'
   and  d.status='Lab'   
   --and  [Test_Type]='VL'
   Group by d.lab
     ,[Sample_Type]+' '+ [Test_Type]  
      
   )





   select  d.lab,

 	  SUM(CASE WHEN [Type] = 'Plasma VL'  THEN REFERRED_Other_rexns ELSE 0 END) AS Plasma_REFERRED_Other_rexns,
	  SUM(CASE WHEN [Type] = 'DBS VL'  THEN REFERRED_Other_rexns ELSE 0 END) AS DBS_REFERRED_Other_rexns,

	 SUM(CASE WHEN [Type] = 'Plasma VL'  THEN REFERRED_Reagent_Stockout ELSE 0 END) AS Plasma_REFERRED_Reagent_Stockout,
	 SUM(CASE WHEN [Type] = 'DBS VL'  THEN REFERRED_Reagent_Stockout ELSE 0 END) AS DBS_REFERRED_Reagent_Stockout,

	  SUM(CASE WHEN [Type] = 'Plasma VL'  THEN REFERRED_Instrument_Failure ELSE 0 END) AS Plasma_REFERRED_Instrument_Failure,
	  SUM(CASE WHEN [Type] = 'DBS VL'  THEN REFERRED_Instrument_Failure ELSE 0 END) AS DBS_REFERRED_Instrument_Failure,


      SUM(CASE WHEN [Type] = 'Plasma VL'  THEN REFERRED_Insuff_Instrument_Capacity ELSE 0 END) AS Plasma_REFERRED_Insuff_Instrument_Capacity,
	  SUM(CASE WHEN [Type] = 'DBS VL'  THEN REFERRED_Insuff_Instrument_Capacity ELSE 0 END) AS DBS_REFERRED_Insuff_Instrument_Capacity,


	  SUM(CASE WHEN [Type] = 'Plasma VL'  THEN REFERRED_Insuff_HR_Capacity ELSE 0 END) AS Plasma_REFERRED_Insuff_HR_Capacity,
	  SUM(CASE WHEN [Type] = 'DBS VL'  THEN REFERRED_Insuff_HR_Capacity ELSE 0 END) AS DBS_REFERRED_Insuff_HR_Capacity


    
   FROM DATIM_Facility_names d   
   LEFT JOIN refrxn_Base b on b.Lab=d.Lab
   and d.Status='lab'
   group by d.Lab