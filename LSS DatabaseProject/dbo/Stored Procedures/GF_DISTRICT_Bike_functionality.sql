
CREATE  PROCEDURE [dbo].[GF_DISTRICT_Bike_functionality]
    --@DateList NVARCHAR(MAX)  -- e.g., '07-2023,08-2023,09-2023'
	@StartDate NVARCHAR(MAX),
	@EndDate NVARCHAR(MAX)
AS

--DECLARE 	@StartDate NVARCHAR(MAX)='2023-11-05',
--	@EndDate NVARCHAR(MAX)='2023-11-05';


WITH BikeFunctionality AS (
    SELECT 
	    CASE 
        WHEN Province_ IN ('Masonaland West', 'Mashonaland West', 'MASHWEST') THEN 'Mash West'
        WHEN Province_ = 'Matebeleland North' THEN 'Mat North'
        WHEN Province_ = 'Mashonaland Central' THEN 'Mash Central'
        WHEN Province_ = 'Matebeleland South' THEN 'Mat South'
		WHEN Province_ = 'Mashonaland East' THEN 'Mash East'
        ELSE Province_
    END as Province_,[District_],
        [date],
        [Number_of_days_bike_was_functional],
        MAX(CAST([Number_of_days_bike_was_functional] as int)) OVER (PARTITION BY CAST([date] as date)) AS MAX_Bike_Functionality
    FROM 
        [LSS].[dbo].[IST_National]
    WHERE 
		 CAST([date] AS date)  between @StartDate and @EndDate
		 --CAST([date] AS date)  between '2023-11-05' and '2023-11-05'
   
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
    END as Province_,[District_],
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
    SELECT  [District_],count(distinct CAST([date] as date)) numweeks
    FROM [LSS].[dbo].[IST_National]
    WHERE 
	    CAST([date] AS date)  between @StartDate and @EndDate
       
        AND status = 'rider'
        AND [District_] NOT IN ('Harare City', 'City of Bulawayo')
		group by  [District_]
),
FunctionalBikeCount AS (
    SELECT 
    [District_], COUNT(*) AS functional_bikes
    FROM 
        BikeStatus
    WHERE 
        bike_ok = 1
		group by [District_]
     
)
, CountRelief_riders AS (
  SELECT 
   [District_], count(*) relief_riders 
    FROM [LSS].[dbo].[IST_National]
    WHERE 
	     CAST([date] AS date)  between @StartDate and @EndDate
       
        AND status = 'relief rider'
        AND [District_] NOT IN ('Harare City', 'City of Bulawayo')
		and ([Type_of_PEPFAR_Support]='TA-SDI' or  [Type_of_PEPFAR_Support]='TA-DSI')

		group by [District_]
)


 ,matrixtable 	 AS (

	SELECT 
	x.[District_],functional_bikes,COALESCE(relief_riders, 0) relief_riders,cast(functional_bikes as int)+ COALESCE (cast(relief_riders as int),0)  functional_b,
	 CASE x.[District_] 
WHEN 'Beitbridge' THEN 4
WHEN 'Bikita' THEN 5
WHEN 'Bindura' THEN 4
WHEN 'Binga' THEN 3
WHEN 'Bubi' THEN 2
WHEN 'Buhera' THEN 6
WHEN 'Bulawayo' THEN 3
WHEN 'Bulilima' THEN 4
WHEN 'Centenary' THEN 3
WHEN 'Chegutu' THEN 4
WHEN 'Chikomba' THEN 6
WHEN 'Chimanimani' THEN 4
WHEN 'Chipinge' THEN 8
WHEN 'Chiredzi' THEN 6
WHEN 'Chirumhanzu' THEN 4
WHEN 'Chivi' THEN 4
WHEN 'Gokwe North' THEN 5
WHEN 'Gokwe South' THEN 6
WHEN 'Goromonzi' THEN 4
WHEN 'Guruve' THEN 4
WHEN 'Gutu' THEN 4
WHEN 'Gwanda' THEN 4
WHEN 'Gweru' THEN 4
WHEN 'Harare' THEN 4
WHEN 'Hurungwe' THEN 6
WHEN 'Hwange' THEN 6
WHEN 'Hwedza' THEN 3
WHEN 'Insiza' THEN 4
WHEN 'Kadoma Sanyati' THEN 5
WHEN 'Kariba' THEN 3
WHEN 'Kwekwe' THEN 6
WHEN 'Lupane' THEN 3
WHEN 'Makonde' THEN 6
WHEN 'Makoni' THEN 8
WHEN 'Mangwe' THEN 3
WHEN 'Marondera' THEN 4
WHEN 'Masvingo' THEN 6
WHEN 'Matobo' THEN 4
WHEN 'Mazowe' THEN 4
WHEN 'Mberengwa' THEN 6
WHEN 'Mbire' THEN 3
WHEN 'Mhondoro Ngezi' THEN 4
WHEN 'Mt Darwin' THEN 5
WHEN 'Mudzi' THEN 5
WHEN 'Murewa' THEN 4
WHEN 'Mutare' THEN 8
WHEN 'Mutasa' THEN 6
WHEN 'Mutoko' THEN 5
WHEN 'Mwenezi' THEN 4
WHEN 'Nkayi' THEN 4
WHEN 'Nyanga' THEN 5
WHEN 'Rushinga' THEN 3
WHEN 'Seke' THEN 3
WHEN 'Shamva' THEN 4
WHEN 'Shurugwi' THEN 5
WHEN 'Tsholotsho' THEN 4
WHEN 'UMP' THEN 4
WHEN 'Umguza' THEN 4
WHEN 'Umzingwane' THEN 4
WHEN 'Zaka' THEN 4
WHEN 'Zvimba' THEN 5
WHEN 'Zvishavane' THEN 4
WHEN 'zvimba' THEN 1
               ELSE 1 -- Default case if no match is found
           END  as totalbikes,numweeks
	      ,  CASE x.[District_] 
             WHEN 'Beitbridge' THEN 4
WHEN 'Bikita' THEN 5
WHEN 'Bindura' THEN 4
WHEN 'Binga' THEN 3
WHEN 'Bubi' THEN 2
WHEN 'Buhera' THEN 6
WHEN 'Bulawayo' THEN 3
WHEN 'Bulilima' THEN 4
WHEN 'Centenary' THEN 3
WHEN 'Chegutu' THEN 4
WHEN 'Chikomba' THEN 6
WHEN 'Chimanimani' THEN 4
WHEN 'Chipinge' THEN 8
WHEN 'Chiredzi' THEN 6
WHEN 'Chirumhanzu' THEN 4
WHEN 'Chivi' THEN 4
WHEN 'Gokwe North' THEN 5
WHEN 'Gokwe South' THEN 6
WHEN 'Goromonzi' THEN 4
WHEN 'Guruve' THEN 4
WHEN 'Gutu' THEN 4
WHEN 'Gwanda' THEN 4
WHEN 'Gweru' THEN 4
WHEN 'Harare' THEN 4
WHEN 'Hurungwe' THEN 6
WHEN 'Hwange' THEN 6
WHEN 'Hwedza' THEN 3
WHEN 'Insiza' THEN 4
WHEN 'Kadoma Sanyati' THEN 5
WHEN 'Kariba' THEN 3
WHEN 'Kwekwe' THEN 6
WHEN 'Lupane' THEN 3
WHEN 'Makonde' THEN 6
WHEN 'Makoni' THEN 8
WHEN 'Mangwe' THEN 3
WHEN 'Marondera' THEN 4
WHEN 'Masvingo' THEN 6
WHEN 'Matobo' THEN 4
WHEN 'Mazowe' THEN 4
WHEN 'Mberengwa' THEN 6
WHEN 'Mbire' THEN 3
WHEN 'Mhondoro Ngezi' THEN 4
WHEN 'Mt Darwin' THEN 5
WHEN 'Mudzi' THEN 5
WHEN 'Murewa' THEN 4
WHEN 'Mutare' THEN 8
WHEN 'Mutasa' THEN 6
WHEN 'Mutoko' THEN 5
WHEN 'Mwenezi' THEN 4
WHEN 'Nkayi' THEN 4
WHEN 'Nyanga' THEN 5
WHEN 'Rushinga' THEN 3
WHEN 'Seke' THEN 3
WHEN 'Shamva' THEN 4
WHEN 'Shurugwi' THEN 5
WHEN 'Tsholotsho' THEN 4
WHEN 'UMP' THEN 4
WHEN 'Umguza' THEN 4
WHEN 'Umzingwane' THEN 4
WHEN 'Zaka' THEN 4
WHEN 'Zvimba' THEN 5
WHEN 'Zvishavane' THEN 4
WHEN 'zvimba' THEN 1
               ELSE 1 -- Default case if no match is found
           END *numweeks Denominator

	from   FunctionalBikeCount  x
	LEFT JOIN CountRelief_riders r ON x.[District_] = r.[District_]
    LEFT JOIN Number_of_weeks s ON x.[District_] = s.[District_]      
	)

	SELECT *, 
       ROUND(CAST(functional_b AS FLOAT) / NULLIF(CAST(Denominator AS INT), 0), 2) * 100 AS funxty,90 [target]
    FROM matrixtable
		order by ROUND(CAST(functional_b AS FLOAT) / NULLIF(CAST(Denominator AS INT), 0), 2) * 100