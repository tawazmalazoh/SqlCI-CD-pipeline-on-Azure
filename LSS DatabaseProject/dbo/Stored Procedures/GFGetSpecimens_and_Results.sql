
CREATE  PROCEDURE [dbo].[GFGetSpecimens_and_Results]
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
    END as Province_,[Type_of_PEPFAR_Support],

    -- Summing up samples and results for various tests
    SUM(CAST([vl_plasma_sam] AS int) + CAST([vl_dbs_sam] AS int) + CAST([eid_sam] AS int) + CAST([eid_dbs] AS int)) AS total_vl_eid_sam,
    SUM(CAST([vl_plasma_res] AS int) + CAST([vl_dbs_res] AS int) + CAST([eid_res] AS int) + CAST([eid_dbs_res] AS int)) AS total_vl_eid_res,
    
    -- Sputum tests
    SUM(CAST([Sputum_Culture_DR_NTBRL] AS int) + CAST([sputum_sam] AS int)) AS [Sputum_Culture_DR_NTBRL],
    SUM(CAST([Sputum_Culture_DR_NTBRL_res] AS int) + CAST([sputum_res] AS int)) AS [Sputum_Culture_DR_NTBRL_res],
    
    -- Individual sums for certain tests

    SUM(CAST([vl_plasma_sam] AS int) + CAST([vl_dbs_sam] AS int)) AS VL_Plasma_DBS,
	  SUM(CAST([vl_plasma_res] AS int) + CAST([vl_dbs_res] AS int)) AS VL_Plasma_DBS_res,

	SUM(CAST([vl_plasma_sam] AS int)) [vl_plasma_sam],
	SUM(CAST([vl_dbs_sam] AS int))[vl_dbs_sam],

    SUM(CAST([eid_sam] AS int) + CAST([eid_dbs] AS int)) AS EID_DBS,
	SUM(CAST([eid_res] AS int) + CAST([eid_dbs_res] AS int)) AS EID_DBS_res,

    SUM(CAST([HPV] AS int)) AS HPV,
    SUM(CAST([HPV_res] AS int)) AS HPV_res

FROM 
    [LSS].[dbo].[IST_National]
WHERE 
    status != 'Driver'
	--AND CAST([date] AS date)  between '2023-07-01' and '2023-09-30'
	AND CAST([date] AS date)  between @StartDate and @EndDate
	and ([Type_of_PEPFAR_Support]='TA-SDI' or  [Type_of_PEPFAR_Support]='TA-DSI')

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
    END ,[Type_of_PEPFAR_Support]

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
    SUM(CAST([vl_plasma_sam] AS int) + CAST([vl_dbs_sam] AS int) + CAST([eid_sam] AS int) + CAST([eid_dbs] AS int)) AS DRtotal_vl_eid_sam,
    SUM(CAST([vl_plasma_res] AS int) + CAST([vl_dbs_res] AS int) + CAST([eid_res] AS int) + CAST([eid_dbs_res] AS int)) AS DRtotal_vl_eid_res,
    
    -- Sputum tests
    SUM(CAST([Sputum_Culture_DR_NTBRL] AS int) + CAST([sputum_sam] AS int)) AS DRSputum_Culture_DR_NTBRL,
    SUM(CAST([Sputum_Culture_DR_NTBRL_res] AS int) + CAST([sputum_res] AS int)) AS DRSputum_Culture_DR_NTBRL_res,
    
    -- Individual sums for certain tests
    SUM(CAST([vl_plasma_sam] AS int) + CAST([vl_dbs_sam] AS int)) AS DRVL_Plasma_DBS,
	SUM(CAST([vl_plasma_res] AS int) + CAST([vl_dbs_res] AS int)) AS DRVL_Plasma_DBS_res,

    SUM(CAST([vl_plasma_sam] AS int)) [DRvl_plasma_sam],
	SUM(CAST([vl_dbs_sam] AS int))[DRvl_dbs_sam],

    SUM(CAST([eid_sam] AS int) + CAST([eid_dbs] AS int)) AS DREID_DBS,
    SUM(CAST([eid_res] AS int) + CAST([eid_dbs_res] AS int)) AS DREID_DBS_res,

    SUM(CAST([HPV] AS int)) AS DRHPV,
    SUM(CAST([HPV_res] AS int)) AS DRHPV_res
FROM 
    [LSS].[dbo].[IST_National]
WHERE 
    driver_sample_status != 'Samples relayed (not carried for the first time)'
	and status = 'Driver'
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
 r.Province_,[Type_of_PEPFAR_Support],

 
 ISNULL(r.total_vl_eid_sam, 0) total_vl_eid_sam , ISNULL(d.DRtotal_vl_eid_sam, 0) DRtotal_vl_eid_sam ,
 ISNULL(r.total_vl_eid_res, 0) total_vl_eid_res , ISNULL(d.DRtotal_vl_eid_res, 0) DRtotal_vl_eid_res ,


 ISNULL(r.[Sputum_Culture_DR_NTBRL], 0) Sputum_Culture_DR_NTBRL, ISNULL(d.[DRSputum_Culture_DR_NTBRL], 0) DRSputum_Culture_DR_NTBRL ,
 ISNULL(r.[Sputum_Culture_DR_NTBRL_res], 0) Sputum_Culture_DR_NTBRL_res , ISNULL(d.[DRSputum_Culture_DR_NTBRL_res], 0) AS DRSputum_Culture_DR_NTBRL_res,

 ISNULL(r.VL_Plasma_DBS, 0) VL_Plasma_DBS , ISNULL(d.DRVL_Plasma_DBS, 0) DRVL_Plasma_DBS,
  ISNULL(r.VL_Plasma_DBS_res, 0) VL_Plasma_DBS_res, ISNULL(d.DRVL_Plasma_DBS_res, 0)  DRVL_Plasma_DBS_res,


 ISNULL(CAST(r.[vl_plasma_sam] AS int),0) [vl_plasma_sam],   ISNULL(d.[DRvl_plasma_sam],0) [DRvl_plasma_sam],
 	ISNULL(CAST(r.[vl_dbs_sam] AS int),0)[vl_dbs_sam],    ISNULL(d.[DRvl_dbs_sam],0) [DRvl_dbs_sam] ,
	


 ISNULL(r.EID_DBS, 0) EID_DBS, ISNULL(d.DREID_DBS, 0)  DREID_DBS,
  ISNULL(r.EID_DBS_res, 0) EID_DBS_res, ISNULL(d.DREID_DBS_res, 0)  DREID_DBS_res,

 ISNULL(r.HPV, 0) HPV , ISNULL(d.DRHPV, 0)  DRHPV,
 ISNULL(r.HPV_res, 0) HPV_res, ISNULL(d.DRHPV_res, 0)  DRHPV_res


FROM 
 Rider_and_Relief r
LEFT JOIN Driver_1st_Time d ON r.Province_ = d.Province_