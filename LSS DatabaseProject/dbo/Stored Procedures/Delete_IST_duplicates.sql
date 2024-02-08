CREATE PROCEDURE  [dbo].[Delete_IST_duplicates] AS 

WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY 
		   
	 [Name_of_Rider_]
      ,[Surname_of_Rider]
      ,[Bike_Registration_Number]
      ,[Province_]
      ,[District_]
      ,[Type_of_PEPFAR_Support]
      ,[Bike_Functionality]
      ,[vl_plasma_sam]
      ,[vl_dbs_sam]
      ,[eid_sam]
      ,[sputum_sam]
      ,[urine_sam]
      ,[other_sam]
      ,[Other_samples_Cleaned_]
      ,[vl_plasma_res]
      ,[vl_dbs_res]
      ,[eid_res]
      ,[sputum_res]
      ,[urine_res]
      ,[other_res]
      ,[Other_Results_cleaned_]
      ,[Number_of__Scheduled_Visits_to_Clinic_per__Week]
      ,[Number_of_Visits_to_Clinic_per_week]
      ,[Fuel_used_by_rider_per_week]
      ,[Fuel_allocated_to_rider_per_week]
      ,[Distance_travelled_by_rider_per_week]
      ,[Bike_breakdown_]
      ,[Bike_on_routine_service_and_mainte0nce]
      ,[Bike_had_no_fuel]
      ,[Rider_on_COVID_19_isolation_quarantine]
      ,[Rider_on_Sick_Leave]
      ,[Rider_on_Leave]
      ,[Rider_sticking_to_sample_pick_up_schedule]
      ,[Inclement_weather]
      ,[Accident_damaged_bike_vehicle]
      ,[Clinical_IPs_related_issues]
      ,[Other_Reasons__Specify_]
      ,[Mitigation_measures_]
      ,[Comments]
	  ,[eid_dbs]
      ,[Sputum_Culture_DR_NTBRL]
      ,[HPV]
      ,[eid_dbs_res]
      ,[Sputum_Culture_DR_NTBRL_res]
      ,[HPV_res]
      ,[Number_of_days_bike_was_functional]
      ,[status]
      ,[Driver_Sample_Status]
		   
		   ORDER BY (SELECT NULL)) AS rn
    FROM [LSS].[dbo].[IST_National]
)
--DELETE 
select *
FROM CTE WHERE rn > 1;