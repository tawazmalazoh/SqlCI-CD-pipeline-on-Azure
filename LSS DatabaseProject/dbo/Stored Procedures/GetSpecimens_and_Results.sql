
CREATE  PROCEDURE [dbo].[GetSpecimens_and_Results]
    --@DateList NVARCHAR(MAX)  -- e.g., '07-2023,08-2023,09-2023'
	@StartDate NVARCHAR(MAX),
	@EndDate NVARCHAR(MAX)
AS

WITH Rider_and_Relief  AS (


SELECT 
   -- FORMAT(CAST([date] AS date), 'MM-yyyy') AS [month],
   
	CASE 
        WHEN Province_ IN ('Masonaland West', 'Mashonaland West', 'MASHWEST') THEN 'Mash West'
        WHEN Province_ = 'Matebeleland North' THEN 'Mat North'
        WHEN Province_ = 'Mashonaland Central' THEN 'Mash Central'
        WHEN Province_ = 'Matebeleland South' THEN 'Mat South'
		WHEN Province_ = 'Mashonaland East' THEN 'Mash East'
        ELSE Province_
    END as Province_,

    -- Summing up samples and results for various tests
    SUM(CAST([vl_plasma_sam] AS int) + CAST([vl_dbs_sam] AS int) + CAST([eid_sam] AS int) + CAST([eid_dbs] AS int)) AS total_vl_eid_sam,
    SUM(CAST([vl_plasma_res] AS int) + CAST([vl_dbs_res] AS int) + CAST([eid_res] AS int) + CAST([eid_dbs_res] AS int)) AS total_vl_eid_res,
    
    -- Sputum tests
    SUM(CAST([Sputum_Culture_DR_NTBRL] AS int) + CAST([sputum_sam] AS int)) AS [Sputum_Culture_DR_NTBRL],
    SUM(CAST([Sputum_Culture_DR_NTBRL_res] AS int) + CAST([sputum_res] AS int)) AS [Sputum_Culture_DR_NTBRL_res],
    
    -- Individual sums for certain tests
    SUM(CAST([vl_plasma_sam] AS int) + CAST([vl_dbs_sam] AS int)) AS VL_Plasma_DBS,
    SUM(CAST([eid_sam] AS int) + CAST([eid_dbs] AS int)) AS EID_Plasma_DBS,
    SUM(CAST([HPV] AS int)) AS HPV,
    SUM(CAST([vl_plasma_res] AS int) + CAST([vl_dbs_res] AS int)) AS VL_Plasma_DBS_res,
    SUM(CAST([eid_res] AS int) + CAST([eid_dbs_res] AS int)) AS EID_Plasma_DBS_res,
    SUM(CAST([HPV_res] AS int)) AS HPV_res,

	SUM(CAST([vl_plasma_sam] AS int)) [vl_plasma_sam],
	SUM(CAST([vl_plasma_res] AS int)) vl_plasma_res,
	SUM(CAST([vl_dbs_sam] AS int)) [vl_dbs_sam],
	SUM(CAST([vl_dbs_res] AS int)) [vl_dbs_res]

FROM 
    [LSS].[dbo].[IST_National]
WHERE 
    status != 'Driver'
	--AND CAST([date] AS date)  between '2023-11-01' and '2023-11-30'
	AND CAST([date] AS date)  between @StartDate and @EndDate
   -- AND FORMAT(CAST([date] AS date), 'MM-yyyy') IN ('07-2023', '08-2023', '09-2023')
GROUP BY  
   -- FORMAT(CAST([date] AS date), 'MM-yyyy'),
    CASE 
        WHEN Province_ IN ('Masonaland West', 'Mashonaland West', 'MASHWEST') THEN 'Mash West'
        WHEN Province_ = 'Matebeleland North' THEN 'Mat North'
        WHEN Province_ = 'Mashonaland Central' THEN 'Mash Central'
        WHEN Province_ = 'Matebeleland South' THEN 'Mat South'
		WHEN Province_ = 'Mashonaland East' THEN 'Mash East'
        ELSE Province_
    END 

)

,Driver_1st_Time AS (

SELECT 
   -- FORMAT(CAST([date] AS date), 'MM-yyyy') AS [month],
    CASE 
        WHEN Province_ IN ('Masonaland West', 'Mashonaland West', 'MASHWEST') THEN 'Mash West'
        WHEN Province_ = 'Matebeleland North' THEN 'Mat North'
        WHEN Province_ = 'Mashonaland Central' THEN 'Mash Central'
        WHEN Province_ = 'Matebeleland South' THEN 'Mat South'
        ELSE Province_
    END as Province_,

    -- Summing up samples and results for various tests
    SUM(CAST([vl_plasma_sam] AS int) + CAST([vl_dbs_sam] AS int) + CAST([eid_sam] AS int) + CAST([eid_dbs] AS int)) AS total_vl_eid_sam,
    SUM(CAST([vl_plasma_res] AS int) + CAST([vl_dbs_res] AS int) + CAST([eid_res] AS int) + CAST([eid_dbs_res] AS int)) AS total_vl_eid_res,
    
    -- Sputum tests
    SUM(CAST([Sputum_Culture_DR_NTBRL] AS int) + CAST([sputum_sam] AS int)) AS [Sputum_Culture_DR_NTBRL],
    SUM(CAST([Sputum_Culture_DR_NTBRL_res] AS int) + CAST([sputum_res] AS int)) AS [Sputum_Culture_DR_NTBRL_res],
    
    -- Individual sums for certain tests
    SUM(CAST([vl_plasma_sam] AS int) + CAST([vl_dbs_sam] AS int)) AS VL_Plasma_DBS,
    SUM(CAST([eid_sam] AS int) + CAST([eid_dbs] AS int)) AS EID_Plasma_DBS,
    SUM(CAST([HPV] AS int)) AS HPV,
    SUM(CAST([vl_plasma_res] AS int) + CAST([vl_dbs_res] AS int)) AS VL_Plasma_DBS_res,
    SUM(CAST([eid_res] AS int) + CAST([eid_dbs_res] AS int)) AS EID_Plasma_DBS_res,
    SUM(CAST([HPV_res] AS int)) AS HPV_res,

	SUM(CAST([vl_plasma_sam] AS int)) [vl_plasma_sam],
	SUM(CAST([vl_plasma_res] AS int)) vl_plasma_res,
	SUM(CAST([vl_dbs_sam] AS int)) [vl_dbs_sam],
	SUM(CAST([vl_dbs_res] AS int)) [vl_dbs_res]
FROM 
    [LSS].[dbo].[IST_National]
WHERE 
    driver_sample_status != 'Samples relayed (not carried for the first time)'
	and status = 'Driver'
		--AND CAST([date] AS date)  between '2023-11-01' and '2023-11-01'
		AND CAST([date] AS date)  between @StartDate and @EndDate
	--AND FORMAT(CAST([date] AS date), 'MM-yyyy') IN (SELECT value FROM STRING_SPLIT(@DateList, ','))
   -- AND FORMAT(CAST([date] AS date), 'MM-yyyy') IN ('07-2023', '08-2023', '09-2023')
GROUP BY  
   -- FORMAT(CAST([date] AS date), 'MM-yyyy'),
    CASE 
        WHEN Province_ IN ('Masonaland West', 'Mashonaland West', 'MASHWEST') THEN 'Mash West'
        WHEN Province_ = 'Matebeleland North' THEN 'Mat North'
        WHEN Province_ = 'Mashonaland Central' THEN 'Mash Central'
        WHEN Province_ = 'Matebeleland South' THEN 'Mat South'
        ELSE Province_
    END 
	)


SELECT 
 r.Province_,
 ISNULL(r.total_vl_eid_sam, 0) + ISNULL(d.total_vl_eid_sam, 0) AS total_vl_eid_sam,
 ISNULL(r.total_vl_eid_res, 0) + ISNULL(d.total_vl_eid_res, 0) AS total_vl_eid_res,
 ISNULL(r.[Sputum_Culture_DR_NTBRL], 0) + ISNULL(d.[Sputum_Culture_DR_NTBRL], 0) AS Sputum_Culture_DR_NTBRL,
 ISNULL(r.[Sputum_Culture_DR_NTBRL_res], 0) + ISNULL(d.[Sputum_Culture_DR_NTBRL_res], 0) AS Sputum_Culture_DR_NTBRL_res,
 ISNULL(r.VL_Plasma_DBS, 0) + ISNULL(d.VL_Plasma_DBS, 0) AS VL_Plasma_DBS,
 ISNULL(r.EID_Plasma_DBS, 0) + ISNULL(d.EID_Plasma_DBS, 0) AS EID_Plasma_DBS,
 ISNULL(r.HPV, 0) + ISNULL(d.HPV, 0) AS HPV,
 ISNULL(r.HPV_res, 0) + ISNULL(d.HPV_res, 0) AS HPV_res,
 ISNULL(r.VL_Plasma_DBS_res, 0) + ISNULL(d.VL_Plasma_DBS_res, 0) AS VL_Plasma_DBS_res,
 ISNULL(r.EID_Plasma_DBS_res, 0) + ISNULL(d.EID_Plasma_DBS_res, 0) AS EID_Plasma_DBS_res,

   ISNULL (r.[vl_plasma_sam] ,0) + ISNULL (d.[vl_plasma_sam] ,0) [vl_plasma_sam],
	ISNULL(r.[vl_plasma_res] ,0) + ISNULL(d.[vl_plasma_res] ,0)  vl_plasma_res,
   ISNULL (r.[vl_dbs_sam] ,0) + ISNULL (d.[vl_dbs_sam] ,0) [vl_dbs_sam],
	ISNULL(r.[vl_dbs_res] ,0) + ISNULL(d.[vl_dbs_res] ,0) [vl_dbs_res]
FROM 
 Rider_and_Relief r
LEFT JOIN Driver_1st_Time d ON r.Province_ = d.Province_