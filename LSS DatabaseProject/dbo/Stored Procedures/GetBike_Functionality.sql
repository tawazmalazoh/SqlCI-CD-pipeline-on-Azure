CREATE  PROCEDURE [dbo].[GetBike_Functionality]
    @StartDate NVARCHAR(MAX)  ,
	@EndDate NVARCHAR(MAX)
AS



WITH BikeFunctionality AS (
    SELECT 
        [date],
        [Number_of_days_bike_was_functional],
        MAX(CAST([Number_of_days_bike_was_functional] as int)) OVER (PARTITION BY CAST([date] as date)) AS MAX_Bike_Functionality
    FROM 
        [LSS].[dbo].[IST_National]
    WHERE 
		--CAST([date] as date) between  '2023-10-16'  and '2023-10-22' 
        CAST([date] as date) between  @StartDate  and @EndDate 
        AND status = 'rider'
        AND [District_] NOT IN ('Harare City', 'City of Bulawayo')
),
BikeStatus AS (
    SELECT 
        [date],
        CASE
            WHEN MAX_Bike_Functionality = 3 AND CAST([Number_of_days_bike_was_functional] as int) >= 2 THEN 1
            WHEN MAX_Bike_Functionality = 4 AND CAST([Number_of_days_bike_was_functional] as int) > 2 THEN 1
            WHEN MAX_Bike_Functionality = 5 AND CAST([Number_of_days_bike_was_functional] as int) > 3 THEN 1
            ELSE 0
        END as bike_ok
    FROM 
        BikeFunctionality
),
Number_of_weeks AS (
    SELECT count(distinct CAST([date] as date)) numweeks
    FROM [LSS].[dbo].[IST_National]
    WHERE 
	--CAST([date] as date) between  '2023-10-16'  and '2023-10-22' 

        CAST([date] as date) between  @StartDate  and @EndDate
        AND status = 'rider'
        AND [District_] NOT IN ('Harare City', 'City of Bulawayo')
),
FunctionalBikeCount AS (
    SELECT 
    COUNT(*) AS functional_bikes
    FROM 
        BikeStatus
    WHERE 
        bike_ok = 1
)
, CountRelief_riders AS (
  SELECT count(*) relief_riders 
    FROM [LSS].[dbo].[IST_National]
    WHERE 
	--CAST([date] as date) between  '2023-10-16'  and '2023-10-22'
        CAST([date] as date) between  @StartDate  and @EndDate
        AND status = 'relief rider'
        AND [District_] NOT IN ('Harare City', 'City of Bulawayo')
)

,Perc_bike_Functionality AS (
SELECT 
	CASE 
            WHEN max(Number_of_weeks.numweeks) > 0 THEN
                ROUND(
                    SUM((CAST(functional_bikes.functional_bikes AS FLOAT) + CAST(relief_riders AS FLOAT)) / (280 * Number_of_weeks.numweeks)) * 100, 1
                )
            ELSE 0.0 -- Handle divide by zero scenario
        END AS Result




    --Round( sum((CAST(functional_bikes.functional_bikes AS FLOAT) + cast(relief_riders AS FLOAT)) / (280 * Number_of_weeks.numweeks))*100,1) AS Result
FROM 
    FunctionalBikeCount functional_bikes, Number_of_weeks, CountRelief_riders
	)

	,Relief_rider_visits AS (
	        select          
       sum( cast ([Number_of_Visits_to_Clinic_per_week] as int) ) relief_actual_vst
	    FROM [LSS].[dbo].[IST_National]
		where --CAST([date] as date) between  '2023-10-16'  and '2023-10-22'
		CAST([date] as date) between  @StartDate  and @EndDate
        AND status = 'relief rider'
		)

	,Missed_Pick_up AS (
		 select          
        sum(cast([Number_of__Scheduled_Visits_to_Clinic_per__Week] as int))-sum( cast ([Number_of_Visits_to_Clinic_per_week] as int) )  total_missed_pickups
	    FROM [LSS].[dbo].[IST_National]
		where -- CAST([date] as date) between  '2023-10-16'  and '2023-10-22'
		CAST([date] as date) between  @StartDate  and @EndDate
        AND status = 'rider'
	)

	SELECT cast(functional_bikes as int)+ cast(relief_riders as int) functional_bikes, numweeks, Result bike_functionality, (280*numweeks) Denominator,relief_riders,relief_actual_vst,total_missed_pickups
	from Perc_bike_Functionality,Number_of_weeks,FunctionalBikeCount,CountRelief_riders,Relief_rider_visits,Missed_Pick_up