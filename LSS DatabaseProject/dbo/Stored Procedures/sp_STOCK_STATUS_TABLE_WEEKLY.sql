

CREATE Procedure sp_STOCK_STATUS_TABLE_WEEKLY 
AS
            WITH   alldata as 
                (SELECT 
                    cast([Date] as date)  [Date],
                    CASE 
                        WHEN ([Platform_Roche_Abbott_Hologic_BMX] + ' ' + Test_Type) IN ('Roche C6800 VL', 'Roche C8800 VL', 'Roche C5800 VL') THEN 'Roche C6800 VL'
                        ELSE ([Platform_Roche_Abbott_Hologic_BMX] + ' ' + Test_Type)
                    END AS Platform,
                    SUM(cast([Reagent_tests_kits_Stock_on_hand] as float)) AS Total_Stock_on_hand
                FROM 
                    [LSS].[dbo].[Dash_Testing_Capacity]
                WHERE         CAST([date] AS DATE) >= DATEADD(DAY, -7, DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0))
           AND CAST([date] AS DATE) < DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0)
		   and status='Lab'  
                GROUP BY 
                    cast([Date] as date),
                    CASE 
                        WHEN ([Platform_Roche_Abbott_Hologic_BMX] + ' ' + Test_Type) IN ('Roche C6800 VL', 'Roche C8800 VL', 'Roche C5800 VL') THEN 'Roche C6800 VL'
                        ELSE ([Platform_Roche_Abbott_Hologic_BMX] + ' ' + Test_Type)
                    END

                )  
                
                ,Stock_Update AS (
                                        SELECT  [Date]
                                            , [Platform]
                                            ,Total_Stock_on_hand  Number_of_tests_kits_Labs
                                            ,(select top 1 [No_of_test_kits_Central_level]
                                                FROM [LSS].[dbo].[Dash_Stock_Update] u
                                                WHERE u.[platform]=d.[Platform]
                                                ) [No_of_test_kits_Central_level]

                                                ,(select top 1 [Avg_Monthly_Consumption]
                                                FROM [LSS].[dbo].[Dash_Stock_Update] u
                                                WHERE u.[platform]=d.[Platform]
                                                ) [Avg_Monthly_Consumption]

                                                ,CASE
                                                WHEN d.[Platform]='Roche C6800 VL' THEN Total_Stock_on_hand*96
                                                WHEN d.[Platform]='Roche C8800 VL' THEN Total_Stock_on_hand*96
                                                WHEN d.[Platform]='Roche EID' THEN Total_Stock_on_hand*48
                                                WHEN d.[Platform]='Roche VL' THEN Total_Stock_on_hand*48
                                                WHEN d.[Platform]='Hologic Panther VL/EID' THEN Total_Stock_on_hand*100
                                                WHEN d.[Platform]='Abbott - room temperature VL' THEN Total_Stock_on_hand*96
                                                WHEN d.[Platform]='Abbott - cold chain VL' THEN Total_Stock_on_hand*96
                                                END Total_Number_of_tests_lab
                                            
                                        FROM alldata d
                
                                        ),

                        STOCK_LATEST AS (
                                        select *,
                                        CASE
                                                WHEN [Platform]='Roche C6800 VL' THEN (Number_of_tests_kits_Labs+[No_of_test_kits_Central_level])*96
                                                WHEN [Platform]='Roche EID' THEN (Number_of_tests_kits_Labs+[No_of_test_kits_Central_level])*48
                                                WHEN [Platform]='Roche VL' THEN (Number_of_tests_kits_Labs+[No_of_test_kits_Central_level])*48
                                                WHEN [Platform]='Hologic Panther VL/EID' THEN (Number_of_tests_kits_Labs+[No_of_test_kits_Central_level])*100
                                                WHEN [Platform]='Abbott - room temperature VL' THEN (Number_of_tests_kits_Labs+[No_of_test_kits_Central_level])*96
                                                WHEN [Platform]='Abbott - cold chain VL' THEN (Number_of_tests_kits_Labs+[No_of_test_kits_Central_level])*96
                                                END Total_Number_of_tests_Central_level_lab

                                                ,ROUND((cast(Total_Number_of_tests_lab as float)/[Avg_Monthly_Consumption] ),1)    Months_of_Stock_lab

                                                
                                        
                                        from Stock_Update

                                        )

                            SELECT 
                                CASE 
                                    WHEN [Platform]='Roche C6800 VL' THEN 'Roche C6800 /C8800 /C5800 VL'
                                    ELSE [Platform]
                                    END [Platform],
                                    Number_of_tests_kits_Labs,
                                    No_of_test_kits_Central_level,           
                                    [Avg_Monthly_Consumption],
                                    Total_Number_of_tests_lab,
                                    Total_Number_of_tests_Central_level_lab,
                                    Months_of_Stock_lab
                            
                            ,ROUND((cast(Total_Number_of_tests_Central_level_lab as float)/[Avg_Monthly_Consumption] ),1) Months_of_Stock_Central_Level_lab
                            FROM STOCK_LATEST