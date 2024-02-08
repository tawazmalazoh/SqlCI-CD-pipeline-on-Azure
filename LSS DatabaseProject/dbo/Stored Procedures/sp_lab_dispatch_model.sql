
CREATE PROCEDURE sp_lab_dispatch_model AS 

WITH Lab_Dispatch AS (
SELECT 
      d.Lab,	[Sample_Type]+' '+ [Test_Type] [Type],
      sum ( cast(RECEIVED_Results_dispatched_by_lab as int)) RECEIVED_Results_dispatched_by_lab

FROM DATIM_Facility_names d

LEFT JOIN [LSS].[dbo].[Dash_Sample_Run] r on  d.Facility=r.name_of_lab
   AND CAST([date] AS DATE) >= DATEADD(DAY, -7, DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0))
   AND CAST([date] AS DATE) < DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0)
   and r.status='Lab'
   and  d.status='Lab'
   --and  [Test_Type] in ('VL' ,'VL/EID')
   --and Platform_Roche_Abbott_Hologic_BMX !='GeneXpert'
   Group by  d.lab ,[Sample_Type]+' '+ [Test_Type]

	 )


	 ,HUB_dispatch AS (

	 SELECT 
	Lab,
	[Sample_Type]+' '+ [Test_Type] [Type],
 sum ( cast(RECEIVED_Results_dispatched_by_lab as int)) hub_ispatched_by_lab


FROM [LSS].[dbo].[Dash_Sample_Run] r,DATIM_Facility_names d
  WHERE d.Facility=r.name_of_lab
  AND    CAST([date] AS DATE) >= DATEADD(DAY, -7, DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0))
   AND CAST([date] AS DATE) < DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0)
   and d.status='Hub'
  and  [Test_Type] in ('VL' ,'VL/EID')
  -- and Platform_Roche_Abbott_Hologic_BMX !='GeneXpert'
   Group by 
   Lab,  [Sample_Type]+' '+ [Test_Type]
   	 

	 )


	 SELECT
    l.lab ,
    SUM(CASE WHEN l.[Type] = 'Plasma VL' THEN  isnull(l.RECEIVED_Results_dispatched_by_lab,0) ELSE 0 END) AS Plasma_RECEIVED_Results_dispatched_by_lab,
    SUM(CASE WHEN l.[Type] = 'DBS VL' THEN isnull(l.RECEIVED_Results_dispatched_by_lab,0) ELSE 0 END) AS DBS_RECEIVED_Results_dispatched_by_lab,


	 MAX(CASE WHEN h.[Type] in ('Plasma VL' ,'PLASMA VL') THEN  isnull(h.hub_ispatched_by_lab,0) ELSE 0 END) AS Plasma_hub_dispatched_by_lab,
    MAX(CASE WHEN h.[Type] = 'DBS VL' THEN isnull(h.hub_ispatched_by_lab,0) ELSE 0 END) AS DBS_hub_dispatched_by_lab

    FROM  Lab_Dispatch l
	LEFT JOIN HUB_dispatch h on l.lab =h.lab
	group by l.lab



	--select * from [LSS].[dbo].[Dash_Sample_Run] r
	--where [Sample_Type] is null