﻿CREATE TABLE [dbo].[Dash_Testing_Capacity] (
    [Date]                                          VARCHAR (255)  NULL,
    [Name_of_Lab]                                   VARCHAR (255)  NULL,
    [Test_Type]                                     VARCHAR (255)  NULL,
    [Platform_Roche_Abbott_Hologic_BMX]             VARCHAR (255)  NULL,
    [Target_Weekly_assigned]                        VARCHAR (255)  NULL,
    [VALID_Weekly_Tests_done]                       VARCHAR (255)  NULL,
    [TEST_to_HIT_Weekly_Targets]                    VARCHAR (255)  NULL,
    [NatPharm_Kits_Received_inThisWK]               VARCHAR (255)  NULL,
    [Date_Received_at_Lab]                          VARCHAR (255)  NULL,
    [Reagent_kits_to_OTHER_Labs]                    VARCHAR (255)  NULL,
    [Lab_Name_Loaned_to]                            VARCHAR (255)  NULL,
    [Reagents_Transported_ConsgnNum]                VARCHAR (255)  NULL,
    [Reagent_kits_RECEIVED_from_OTHER_Labs]         VARCHAR (255)  NULL,
    [Lab_Name_Received_from]                        VARCHAR (255)  NULL,
    [Reagent_tests_kits_Stock_on_hand]              VARCHAR (255)  NULL,
    [Reagent_tests_kits_available]                  VARCHAR (255)  NULL,
    [Reagent_tests_kits_available_Batch_lot_Number] VARCHAR (255)  NULL,
    [Reagent_tests_kits_available_Expiry_Date]      VARCHAR (255)  NULL,
    [Reagent_stockout_days]                         VARCHAR (255)  NULL,
    [Tests_expired_this_month_before_use]           VARCHAR (255)  NULL,
    [Cost_of_transportation]                        VARCHAR (255)  NULL,
    [Comments_Reagent_Stock_Status]                 NVARCHAR (MAX) NULL,
    [SourceFile]                                    VARCHAR (255)  NULL,
    [Update_Date]                                   DATE           DEFAULT (getdate()) NULL,
    [unique_key]                                    VARCHAR (255)  NULL,
    [Control_loaned_to_other_labs]                  VARCHAR (255)  NULL,
    [Lab_name_receiving_controls]                   VARCHAR (255)  NULL,
    [Controls_received_from_other_labs]             VARCHAR (255)  NULL,
    [Lab_name_where_controls_from]                  VARCHAR (255)  NULL,
    [stock_of_control_available]                    VARCHAR (255)  NULL,
    [Expiry_Date_of_Controls]                       VARCHAR (255)  NULL,
    [Stocks_of_bottleneck_consumable_available]     VARCHAR (255)  NULL,
    [Months_of_stock_of_bottleneck_consumable]      VARCHAR (255)  NULL,
    [Status]                                        VARCHAR (255)  NULL,
    [Name_of_bottleneck_consumable]                 VARCHAR (255)  NULL
);

