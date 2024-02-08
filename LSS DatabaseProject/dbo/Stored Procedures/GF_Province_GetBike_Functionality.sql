CREATE  PROCEDURE [dbo].GF_Province_GetBike_Functionality
    @StartDate NVARCHAR(MAX)  ,
	@EndDate NVARCHAR(MAX)
AS

--DECLARE    @StartDate NVARCHAR(MAX) ='2023-07-01',
--	 @EndDate NVARCHAR(MAX)='2023-09-30';

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
		--CAST([date] as date) between  '2023-10-16'  and '2023-10-22' 
        CAST([date] as date) between  @StartDate  and @EndDate 
        AND status = 'rider'
        AND [District_] NOT IN ('Harare City', 'City of Bulawayo')
		and ([Type_of_PEPFAR_Support]='TA-SDI' or  [Type_of_PEPFAR_Support]='TA-DSI')
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
	--CAST([date] as date) between  '2023-10-16'  and '2023-10-22' 

        CAST([date] as date) between  @StartDate  and @EndDate
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
	--CAST([date] as date) between  '2023-10-16'  and '2023-10-22'
        CAST([date] as date) between  @StartDate  and @EndDate
        AND status = 'relief rider'
        AND [District_] NOT IN ('Harare City', 'City of Bulawayo')
		and ([Type_of_PEPFAR_Support]='TA-SDI' or  [Type_of_PEPFAR_Support]='TA-DSI')
		group by CASE 
        WHEN Province_ IN ('Masonaland West', 'Mashonaland West', 'MASHWEST') THEN 'Mash West'
        WHEN Province_ = 'Matebeleland North' THEN 'Mat North'
        WHEN Province_ = 'Mashonaland Central' THEN 'Mash Central'
        WHEN Province_ = 'Matebeleland South' THEN 'Mat South'
		WHEN Province_ = 'Mashonaland East' THEN 'Mash East'
        ELSE Province_
    END 
)

,tabular AS (
  SELECT --cast(functional_bikes as int)+ cast(relief_riders as int) functional_bikes, numweeks, 
	x.Province_,functional_bikes,COALESCE(relief_riders, 0) relief_riders,
	 CASE x.Province_ 
               WHEN 'Bulawayo' THEN 3
               WHEN 'Harare' THEN 4
               WHEN 'Manicaland' THEN 9
               WHEN 'Mash Central' THEN 17
               WHEN 'Mash East' THEN 26
               WHEN 'Mash West' THEN 7
               WHEN 'Masvingo' THEN 5
               WHEN 'Mat North' THEN 9
               WHEN 'Mat South' THEN 3
               WHEN 'Midlands' THEN 18
               ELSE 1 -- Default case if no match is found
           END  as GFtotalbikes,numweeks,


		   cast(functional_bikes as int)+ COALESCE (cast(relief_riders as int),0)  functional_b
	      ,  CASE x.Province_ 
              WHEN 'Bulawayo' THEN 3
               WHEN 'Harare' THEN 4
               WHEN 'Manicaland' THEN 9
               WHEN 'Mash Central' THEN 17
               WHEN 'Mash East' THEN 26
               WHEN 'Mash West' THEN 7
               WHEN 'Masvingo' THEN 5
               WHEN 'Mat North' THEN 9
               WHEN 'Mat South' THEN 3
               WHEN 'Midlands' THEN 18
               ELSE 1 -- Default case if no match is found
           END *numweeks Denominator

	from   FunctionalBikeCount  x
	left join  CountRelief_riders r on  x.Province_=r.Province_          
	left join Number_of_weeks s on  x.Province_=s.Province_          
	)

	select Province_,functional_b,Denominator, cast (functional_b as float)/  COALESCE (cast(Denominator as int),0) bike_functionality
	from tabular