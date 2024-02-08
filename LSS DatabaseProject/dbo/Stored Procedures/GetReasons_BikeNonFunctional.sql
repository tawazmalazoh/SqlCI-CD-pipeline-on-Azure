CREATE  PROCEDURE [dbo].[GetReasons_BikeNonFunctional]
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

--,lets_see_reasons AS (


SELECT 
    SUM(CASE WHEN Bike_breakdown_ > 0 THEN 1 ELSE 0 END) AS Bike_breakdown,
    SUM(CASE WHEN Bike_on_routine_service_and_mainte0nce > 0 THEN 1 ELSE 0 END) AS Maintanance_service,
    SUM(CASE WHEN Bike_had_no_fuel > 0 THEN 1 ELSE 0 END) AS No_fuel,
    SUM(CASE WHEN Rider_on_Sick_Leave > 0 THEN 1 ELSE 0 END) AS Sick_leave,
    SUM(CASE WHEN Rider_on_Leave > 0 THEN 1 ELSE 0 END) AS Annual_leave,
    SUM(CASE WHEN Inclement_weather > 0 THEN 1 ELSE 0 END) AS Inclement_weather,
    SUM(CASE WHEN Accident_damaged_bike_vehicle > 0 THEN 1 ELSE 0 END) AS Accident_damage,
    SUM(CASE WHEN Clinical_IPs_related_issues > 0 THEN 1 ELSE 0 END) AS Clinical_issues
FROM 
     BikeStatus
   where bike_ok=0