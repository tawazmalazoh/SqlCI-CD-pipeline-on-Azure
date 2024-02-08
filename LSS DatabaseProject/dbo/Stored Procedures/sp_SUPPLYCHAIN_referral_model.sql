CREATE PROCEDURE [dbo].[sp_SUPPLYCHAIN_referral_model]
    @StartDate NVARCHAR(MAX),
    @EndDate NVARCHAR(MAX)
AS
BEGIN
    -- Declare variables for calculation
    DECLARE @FirstSunday DATE;
    DECLARE @PreviousSunday DATE;

    -- Find the first Sunday within the given date range
    SET @FirstSunday = (
        SELECT TOP 1 CAST([date] AS DATE)
        FROM Dash_This_week_Rec_Samples
        WHERE 
            CAST([date] AS DATE) BETWEEN @StartDate AND @EndDate
            AND DATEPART(WEEKDAY, [date]) = 1 -- Assuming 1 is Sunday; this depends on @@DATEFIRST setting
        ORDER BY [date]
    );

    -- Calculate the Sunday before the first Sunday in the date range
    SET @PreviousSunday = DATEADD(DAY, -7, @FirstSunday);

    -- Correct usage of a CTE
    ;WITH Labs AS (
        SELECT *
        FROM DATIM_Facility_names d
        WHERE d.status = 'Lab'
    )


,BASICS as (
  SELECT 
   d.lab name_of_lab
     ,[Sample_Type]+' '+ [Test_Type]  as [Type]
     , sum(cast(Samples_reffered_Out as int))  Samples_reffered_Out
	 , CASE 
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
	END Lab_Samples_referred_to
	

FROM  Labs d
LEFT JOIN [LSS].[dbo].Dash_Referred_Samples r on d.Facility=r.Name_of_Lab
 	AND CAST([date] AS date)  between @StartDate and @EndDate
	--AND CAST([date] AS date)  between '2023-11-20'  and '2023-11-29'
   -- AND CAST([date] AS DATE) >= DATEADD(DAY, -7, DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0))
   --AND CAST([date] AS DATE) < DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0)
   and r.status='Lab'

   Group by   d.lab  ,[Sample_Type]+' '+ [Test_Type], CASE 
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

	 ),

	 AGGREGATED_LABS AS (
    SELECT
        name_of_lab,
        [Type],
        STRING_AGG(Lab_Samples_referred_to, ', ') AS refered_to_lab

    FROM BASICS
    GROUP BY name_of_lab, [Type]
)




,type_and_lab as(
SELECT xm.lab, 'Plasma VL' AS [Type]
FROM Labs xm
UNION ALL
SELECT xm.lab, 'DBS VL' AS [Type]
FROM Labs xm
)


,Received_samples  as 
(


select 
name_of_lab,
SUM(CASE WHEN [Type] = 'DBS VL' THEN Total_samples_received ELSE 0 END) DBS_VL_Total_samples_received
,SUM(CASE WHEN [Type] = 'DBS EID' THEN Total_samples_received ELSE 0 END) DBS_EID_Total_samples_received
,SUM(CASE WHEN [Type] = 'Plasma VL' THEN Total_samples_received ELSE 0 END) Plasma_VL_Total_samples_received

FROM (
SELECT 
   d.lab name_of_lab
     ,[Sample_Type]+' '+ [Test_Type]  as [Type]
     , sum(cast(Total_samples_received as int))  Total_samples_received

FROM  Labs d
LEFT JOIN [LSS].[dbo].Dash_This_week_Rec_Samples r on d.Facility=r.Name_of_Lab
 	AND CAST([date] AS date)  between @StartDate and @EndDate
	--AND CAST([date] AS date)  between '2023-11-20'  and '2023-11-29'
   -- AND CAST([date] AS DATE) >= DATEADD(DAY, -7, DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0))
   --AND CAST([date] AS DATE) < DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0)
   and r.status='Lab'
   and [Sample_Type]+' '+ [Test_Type]  in ('DBS VL','DBS EID','Plasma VL')

   Group by   d.lab  ,[Sample_Type]+' '+ [Test_Type]
   ) as rece_samples

Group by name_of_lab
)


,Samples_run  as 
(


select 
name_of_lab,
SUM(CASE WHEN [Type] = 'DBS VL' THEN [RECEIVED_TOTAL_Sample_RUN] ELSE 0 END) DBS_VL_RECEIVED_TOTAL_Sample_RUN
,SUM(CASE WHEN [Type] = 'DBS EID' THEN [RECEIVED_TOTAL_Sample_RUN] ELSE 0 END) DBS_EID_RECEIVED_TOTAL_Sample_RUN
,SUM(CASE WHEN [Type] = 'Plasma VL' THEN [RECEIVED_TOTAL_Sample_RUN] ELSE 0 END) Plasma_VL_RECEIVED_TOTAL_Sample_RUN

FROM (
SELECT 
   d.lab name_of_lab
     ,[Sample_Type]+' '+ [Test_Type]  as [Type]
     , sum(cast([RECEIVED_TOTAL_Sample_RUN] as int))-sum (cast(RECEIVED_FAILED_bt_Elig_REPEAT as int))  [RECEIVED_TOTAL_Sample_RUN]


FROM  Labs d
LEFT JOIN [LSS].[dbo].Dash_Sample_Run r on d.Facility=r.Name_of_Lab
 	AND CAST([date] AS date)  between @StartDate and @EndDate
	--AND CAST([date] AS date)  between '2023-11-20'  and '2023-11-29'
   -- AND CAST([date] AS DATE) >= DATEADD(DAY, -7, DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0))
   --AND CAST([date] AS DATE) < DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0)
   and r.status='Lab'
   and [Sample_Type]+' '+ [Test_Type]  in ('DBS VL','DBS EID','Plasma VL')

   Group by   d.lab  ,[Sample_Type]+' '+ [Test_Type]
   ) as samples_running

Group by name_of_lab
)


,carryover  as 
(


select [date], name_of_lab   
,SUM(CASE WHEN [Type] = 'Plasma VL' THEN Carryover_Samples_in_the_lab ELSE 0 END) Plasma_VL_Carryover_Samples_in_the_lab
,SUM(CASE WHEN [Type] = 'DBS VL' THEN Carryover_Samples_in_the_lab ELSE 0 END) DBS_VL_Carryover_Samples_in_the_lab
,SUM(CASE WHEN [Type] = 'DBS EID' THEN Carryover_Samples_in_the_lab ELSE 0 END) DBS_EID_Carryover_Samples_in_the_lab

FROM (
SELECT  cast(date as date) [date],
   d.lab name_of_lab
     ,[Sample_Type]+' '+ [Test_Type]  as [Type]
     , sum(cast(Carryover_Samples_in_the_lab as int)) Carryover_Samples_in_the_lab


FROM  Labs d
LEFT JOIN [LSS].[dbo].Dash_This_week_Rec_Samples r on d.Facility=r.Name_of_Lab
	AND CAST([date] AS date) = @PreviousSunday

	--AND CAST([date] AS date)  between '2023-11-20'  and '2023-11-29'
  --AND CAST([date] AS DATE) >= DATEADD(DAY, -14, DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0))
  --AND CAST([date] AS DATE) <= DATEADD(DAY, -7, DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0))
   and r.status='Lab'
   and [Sample_Type]+' '+ [Test_Type]  in ('DBS VL','DBS EID','Plasma VL')

   Group by   d.lab  ,[Sample_Type]+' '+ [Test_Type],[date]
   ) as carrybase

Group by name_of_lab,[date]
)






SELECT
    b.name_of_lab, 
    SUM(CASE WHEN b.[Type] = 'Plasma VL' THEN b.Samples_reffered_Out ELSE 0 END) AS Plasma_Samples_reffered_Out,
	    isnull(MAX(CASE WHEN b.[Type] = 'Plasma VL' THEN b.Lab_Samples_referred_to ELSE NULL END),0) AS Plasma_refered_to_lab,

    SUM(CASE WHEN b.[Type] = 'DBS VL' THEN b.Samples_reffered_Out ELSE 0 END) AS DBS_Samples_reffered_Out,
    isnull(MAX(CASE WHEN b.[Type] = 'DBS VL' THEN b.Lab_Samples_referred_to ELSE NULL END),0) AS DBS_refered_to_lab

	,MAX(DBS_VL_Total_samples_received) DBS_VL_Total_samples_received
	,MAX(DBS_EID_Total_samples_received) DBS_EID_Total_samples_received
	,MAX(Plasma_VL_Total_samples_received) Plasma_VL_Total_samples_received

	,MAX(DBS_VL_RECEIVED_TOTAL_Sample_RUN) DBS_VL_RECEIVED_TOTAL_Sample_RUN
	,MAX(DBS_EID_RECEIVED_TOTAL_Sample_RUN) DBS_EID_Total_samples_RUN
	,MAX(Plasma_VL_RECEIVED_TOTAL_Sample_RUN) Plasma_VL_RECEIVED_TOTAL_Sample_RUN

	,MAX(Plasma_VL_Carryover_Samples_in_the_lab) Plasma_VL_Carryover_Samples_in_the_lab
	,MAX(DBS_VL_Carryover_Samples_in_the_lab) DBS_VL_Carryover_Samples_in_the_lab
	,MAX(DBS_EID_Carryover_Samples_in_the_lab) DBS_EID_Carryover_Samples_in_the_lab

FROM Labs l 
Left Join BASICS b on  l.lab=b.name_of_lab
left Join Received_samples r on r.name_of_lab= b.name_of_lab
left Join Samples_run x on x.name_of_lab= b.name_of_lab
Left Join  carryover c on c.name_of_lab= b.name_of_lab

GROUP BY b.name_of_lab;

END;