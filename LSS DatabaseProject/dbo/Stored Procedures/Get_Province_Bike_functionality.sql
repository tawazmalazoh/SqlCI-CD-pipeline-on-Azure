
CREATE  PROCEDURE [dbo].[Get_Province_Bike_functionality]
    --@DateList NVARCHAR(MAX)  -- e.g., '07-2023,08-2023,09-2023'
	@StartDate NVARCHAR(MAX),
	@EndDate NVARCHAR(MAX)
AS




WITH BikeFunctionality AS (
    SELECT 
	    CASE 
        WHEN Province_ IN ('Masonaland West', 'Mashonaland West', 'MASHWEST') THEN 'Mash West'
        WHEN Province_ = 'Matebeleland North' THEN 'Mat North'
        WHEN Province_ = 'Mashonaland Central' THEN 'Mash Central'
        WHEN Province_ = 'Matebeleland South' THEN 'Mat South'
		WHEN Province_ = 'Mashonaland East' THEN 'Mash East'
        ELSE Province_
    END as Province_,
        [date],
        [Number_of_days_bike_was_functional],
        MAX(CAST([Number_of_days_bike_was_functional] as int)) OVER (PARTITION BY CAST([date] as date)) AS MAX_Bike_Functionality
    FROM 
        [LSS].[dbo].[IST_National]
    WHERE 
		 CAST([date] AS date)  between @StartDate and @EndDate
   
        AND status = 'rider'
        AND [District_] NOT IN ('Harare City', 'City of Bulawayo')

),
BikeStatus AS (
    SELECT CASE 
        WHEN Province_ IN ('Masonaland West', 'Mashonaland West', 'MASHWEST') THEN 'Mash West'
        WHEN Province_ = 'Matebeleland North' THEN 'Mat North'
        WHEN Province_ = 'Mashonaland Central' THEN 'Mash Central'
        WHEN Province_ = 'Matebeleland South' THEN 'Mat South'
		WHEN Province_ = 'Mashonaland East' THEN 'Mash East'
        ELSE Province_
    END as Province_,
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
    SELECT  CASE 
        WHEN Province_ IN ('Masonaland West', 'Mashonaland West', 'MASHWEST') THEN 'Mash West'
        WHEN Province_ = 'Matebeleland North' THEN 'Mat North'
        WHEN Province_ = 'Mashonaland Central' THEN 'Mash Central'
        WHEN Province_ = 'Matebeleland South' THEN 'Mat South'
		WHEN Province_ = 'Mashonaland East' THEN 'Mash East'
        ELSE Province_
    END as Province_,count(distinct CAST([date] as date)) numweeks
    FROM [LSS].[dbo].[IST_National]
    WHERE 
	    CAST([date] AS date)  between @StartDate and @EndDate
       
        AND status = 'rider'
        AND [District_] NOT IN ('Harare City', 'City of Bulawayo')
		group by  CASE 
        WHEN Province_ IN ('Masonaland West', 'Mashonaland West', 'MASHWEST') THEN 'Mash West'
        WHEN Province_ = 'Matebeleland North' THEN 'Mat North'
        WHEN Province_ = 'Mashonaland Central' THEN 'Mash Central'
        WHEN Province_ = 'Matebeleland South' THEN 'Mat South'
		WHEN Province_ = 'Mashonaland East' THEN 'Mash East'
        ELSE Province_
    END 
),
FunctionalBikeCount AS (
    SELECT 
  CASE 
        WHEN Province_ IN ('Masonaland West', 'Mashonaland West', 'MASHWEST') THEN 'Mash West'
        WHEN Province_ = 'Matebeleland North' THEN 'Mat North'
        WHEN Province_ = 'Mashonaland Central' THEN 'Mash Central'
        WHEN Province_ = 'Matebeleland South' THEN 'Mat South'
		WHEN Province_ = 'Mashonaland East' THEN 'Mash East'
        ELSE Province_
    END as Province_, COUNT(*) AS functional_bikes
    FROM 
        BikeStatus
    WHERE 
        bike_ok = 1
		group by CASE 
        WHEN Province_ IN ('Masonaland West', 'Mashonaland West', 'MASHWEST') THEN 'Mash West'
        WHEN Province_ = 'Matebeleland North' THEN 'Mat North'
        WHEN Province_ = 'Mashonaland Central' THEN 'Mash Central'
        WHEN Province_ = 'Matebeleland South' THEN 'Mat South'
		WHEN Province_ = 'Mashonaland East' THEN 'Mash East'
        ELSE Province_
    END 
)
, CountRelief_riders AS (
  SELECT 
  CASE 
        WHEN Province_ IN ('Masonaland West', 'Mashonaland West', 'MASHWEST') THEN 'Mash West'
        WHEN Province_ = 'Matebeleland North' THEN 'Mat North'
        WHEN Province_ = 'Mashonaland Central' THEN 'Mash Central'
        WHEN Province_ = 'Matebeleland South' THEN 'Mat South'
		WHEN Province_ = 'Mashonaland East' THEN 'Mash East'
        ELSE Province_
    END as Province_, count(*) relief_riders 
    FROM [LSS].[dbo].[IST_National]
    WHERE 
	     CAST([date] AS date)  between @StartDate and @EndDate
       
        AND status = 'relief rider'
        AND [District_] NOT IN ('Harare City', 'City of Bulawayo')

		group by CASE 
        WHEN Province_ IN ('Masonaland West', 'Mashonaland West', 'MASHWEST') THEN 'Mash West'
        WHEN Province_ = 'Matebeleland North' THEN 'Mat North'
        WHEN Province_ = 'Mashonaland Central' THEN 'Mash Central'
        WHEN Province_ = 'Matebeleland South' THEN 'Mat South'
		WHEN Province_ = 'Mashonaland East' THEN 'Mash East'
        ELSE Province_
    END 
)


 ,matrixtable 	 AS (

	SELECT 
	x.Province_,functional_bikes,COALESCE(relief_riders, 0) relief_riders,cast(functional_bikes as int)+ COALESCE (cast(relief_riders as int),0)  functional_b,
	 CASE x.Province_ 
               WHEN 'Bulawayo' THEN 3
               WHEN 'Harare' THEN 4
               WHEN 'Manicaland' THEN 45
               WHEN 'Mash Central' THEN 30
               WHEN 'Mash East' THEN 38
               WHEN 'Mash West' THEN 34
               WHEN 'Masvingo' THEN 33
               WHEN 'Mat North' THEN 26
               WHEN 'Mat South' THEN 27
               WHEN 'Midlands' THEN 40
               ELSE 1 -- Default case if no match is found
           END  as totalbikes,numweeks
	      ,  CASE x.Province_ 
              WHEN 'Bulawayo' THEN 3
               WHEN 'Harare' THEN 4
               WHEN 'Manicaland' THEN 45
               WHEN 'Mash Central' THEN 30
               WHEN 'Mash East' THEN 38
               WHEN 'Mash West' THEN 34
               WHEN 'Masvingo' THEN 33
               WHEN 'Mat North' THEN 26
               WHEN 'Mat South' THEN 27
               WHEN 'Midlands' THEN 40
               ELSE 1 -- Default case if no match is found
           END *numweeks Denominator

	from   FunctionalBikeCount  x
	LEFT JOIN CountRelief_riders r ON x.Province_ = r.Province_
    LEFT JOIN Number_of_weeks s ON x.Province_ = s.Province_      
	)

	SELECT *, 
       ROUND(CAST(functional_b AS FLOAT) / NULLIF(CAST(Denominator AS INT), 0), 2) * 100 AS funxty,90 [target]
    FROM matrixtable