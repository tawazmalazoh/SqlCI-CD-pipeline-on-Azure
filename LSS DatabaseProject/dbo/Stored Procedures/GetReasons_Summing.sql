CREATE  PROCEDURE [dbo].[GetReasons_Summing]
    @StartDate NVARCHAR(MAX)  ,
	@EndDate NVARCHAR(MAX)
AS



WITH BikeFunctionality AS (
    SELECT 
        [date],
        [Number_of_days_bike_was_functional],
        MAX(CAST([Number_of_days_bike_was_functional] as int)) OVER (PARTITION BY CAST([date] as date)) AS MAX_Bike_Functionality
	  ,[Bike_breakdown_]
      ,[Bike_on_routine_service_and_mainte0nce]
      ,[Bike_had_no_fuel]      
      ,[Rider_on_Sick_Leave]
      ,[Rider_on_Leave]
      ,[Inclement_weather]
      ,[Accident_damaged_bike_vehicle]
      ,[Clinical_IPs_related_issues]
   FROM 
        [LSS].[dbo].[IST_National]
    WHERE 
		--CAST([date] as date) between  '2023-10-16'  and '2023-10-22' 
        CAST([date] as date) between  @StartDate  and @EndDate 
        AND status = 'rider'
        AND [District_] NOT IN ('Harare City', 'City of Bulawayo')
)
,BikeStatus AS (
    SELECT 
  
        CASE
            WHEN MAX_Bike_Functionality = 3 AND CAST([Number_of_days_bike_was_functional] as int) >= 2 THEN 1
            WHEN MAX_Bike_Functionality = 4 AND CAST([Number_of_days_bike_was_functional] as int) > 2 THEN 1
            WHEN MAX_Bike_Functionality = 5 AND CAST([Number_of_days_bike_was_functional] as int) > 3 THEN 1
            ELSE 0
        END as bike_ok
		,*
      	
    FROM 
        BikeFunctionality
)

,lets_sum_reasons AS (


SELECT 
    SUM( cast(Bike_breakdown_ as int) ) AS Bike_breakdown,
    SUM( cast(Bike_on_routine_service_and_mainte0nce as int) ) AS Maintanance_service,
    SUM( cast(Bike_had_no_fuel as int) ) AS No_fuel,
    SUM( cast(Rider_on_Sick_Leave as int) ) AS Sick_leave,
    SUM( cast(Rider_on_Leave as int) ) AS Annual_leave,
    SUM( cast( Inclement_weather as int) ) AS Inclement_weather,
    SUM( cast(Accident_damaged_bike_vehicle as int) ) AS Accident_damage,
    SUM( cast(Clinical_IPs_related_issues as int) ) AS Clinical_issues
FROM 
     BikeStatus

)

,lets_count_riders_per_reason AS (
 SELECT 
    SUM(CASE WHEN Bike_breakdown_ > 0 THEN 1 ELSE 0 END) AS Bike_breakdown_count,
    SUM(CASE WHEN Bike_on_routine_service_and_mainte0nce > 0 THEN 1 ELSE 0 END) AS Maintanance_service_count,
    SUM(CASE WHEN Bike_had_no_fuel > 0 THEN 1 ELSE 0 END) AS No_fuel_count,
    SUM(CASE WHEN Rider_on_Sick_Leave > 0 THEN 1 ELSE 0 END) AS Sick_leave_count,
    SUM(CASE WHEN Rider_on_Leave > 0 THEN 1 ELSE 0 END) AS Annual_leave_count,
    SUM(CASE WHEN Inclement_weather > 0 THEN 1 ELSE 0 END) AS Inclement_weather_count,
    SUM(CASE WHEN Accident_damaged_bike_vehicle > 0 THEN 1 ELSE 0 END) AS Accident_damage_count,
    SUM(CASE WHEN Clinical_IPs_related_issues > 0 THEN 1 ELSE 0 END) AS Clinical_issues_count
FROM 
     BikeStatus

)


select * 
from lets_sum_reasons ,lets_count_riders_per_reason