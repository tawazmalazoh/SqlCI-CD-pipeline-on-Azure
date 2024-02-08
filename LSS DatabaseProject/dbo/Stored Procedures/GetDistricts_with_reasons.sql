CREATE  PROCEDURE [dbo].[GetDistricts_with_reasons]
    @StartDate NVARCHAR(MAX)  ,
	@EndDate NVARCHAR(MAX)
AS



WITH BikeFunctionality AS (
    SELECT 
        [date],[District_],
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
		--CAST([date] as date) between  '2023-10-23'  and '2023-10-29' 
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



,lets_count_riders_per_reason AS (
 SELECT [District_],
    CASE WHEN Bike_breakdown_ > 0 THEN 1 ELSE 0 END AS Bike_breakdown_count,
    CASE WHEN Bike_on_routine_service_and_mainte0nce > 0 THEN 1 ELSE 0 END AS Maintanance_service_count,
    CASE WHEN Bike_had_no_fuel > 0 THEN 1 ELSE 0 END AS No_fuel_count,
    CASE WHEN Rider_on_Sick_Leave > 0 THEN 1 ELSE 0 END AS Sick_leave_count,
    CASE WHEN Rider_on_Leave > 0 THEN 1 ELSE 0 END AS Annual_leave_count,
    CASE WHEN Inclement_weather > 0 THEN 1 ELSE 0 END AS Inclement_weather_count,
    CASE WHEN Accident_damaged_bike_vehicle > 0 THEN 1 ELSE 0 END AS Accident_damage_count,
    CASE WHEN Clinical_IPs_related_issues > 0 THEN 1 ELSE 0 END AS Clinical_issues_count
FROM 
     BikeStatus

)

,district_data AS (
select * 
from lets_count_riders_per_reason )

,BikeBreakdown AS (
    SELECT STRING_AGG([District_], ', ') AS Bike_breakdown_districts
    FROM district_data
    WHERE Bike_breakdown_count = 1
),
MaintananceService AS (
    SELECT STRING_AGG([District_], ', ') AS Maintanance_service_districts
    FROM district_data
    WHERE Maintanance_service_count = 1
),
NoFuel AS (
    SELECT STRING_AGG([District_], ', ') AS No_fuel_districts
    FROM district_data
    WHERE No_fuel_count = 1
),
SickLeave AS (
    SELECT STRING_AGG([District_], ', ') AS Sick_leave_districts
    FROM district_data
    WHERE Sick_leave_count = 1
),
AnnualLeave AS (
    SELECT STRING_AGG([District_], ', ') AS Annual_leave_districts
    FROM district_data
    WHERE Annual_leave_count = 1
),
InclementWeather AS (
    SELECT STRING_AGG([District_], ', ') AS Inclement_weather_districts
    FROM district_data
    WHERE Inclement_weather_count = 1
),
AccidentDamage AS (
    SELECT STRING_AGG([District_], ', ') AS Accident_damage_districts
    FROM district_data
    WHERE Accident_damage_count = 1
),
ClinicalIssues AS (
    SELECT STRING_AGG([District_], ', ') AS Clinical_issues_districts
    FROM district_data
    WHERE Clinical_issues_count = 1
)

SELECT 
    BikeBreakdown.Bike_breakdown_districts,
    MaintananceService.Maintanance_service_districts,
    NoFuel.No_fuel_districts,
    SickLeave.Sick_leave_districts,
    AnnualLeave.Annual_leave_districts,
    InclementWeather.Inclement_weather_districts,
    AccidentDamage.Accident_damage_districts,
    ClinicalIssues.Clinical_issues_districts
FROM 
    BikeBreakdown, MaintananceService, NoFuel, SickLeave, AnnualLeave, InclementWeather, AccidentDamage, ClinicalIssues;