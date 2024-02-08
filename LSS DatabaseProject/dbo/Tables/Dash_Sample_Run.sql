﻿CREATE TABLE [dbo].[Dash_Sample_Run] (
    [Date]                                              VARCHAR (255)  NULL,
    [Name_of_Lab]                                       VARCHAR (255)  NULL,
    [Sample_Type]                                       VARCHAR (255)  NULL,
    [Test_Type]                                         VARCHAR (255)  NULL,
    [Platform_Roche_Abbott_Hologic_BMX]                 VARCHAR (255)  NULL,
    [CARRYOVER_Samples_RUN]                             VARCHAR (255)  NULL,
    [CARRYOVER_URGENT_Samples_RUN]                      VARCHAR (255)  NULL,
    [CARRYOVER_reBleeds_RUN]                            VARCHAR (255)  NULL,
    [CARRYOVER_FAILED_samples_elig_repeat]              VARCHAR (255)  NULL,
    [CARRYOVER_FAILED_samples_Ntelig_repeat]            VARCHAR (255)  NULL,
    [CARRYOVER_repeats_RUN]                             VARCHAR (255)  NULL,
    [failed_CARRYOVER_samplesafter_finalrepeat_testing] VARCHAR (255)  NULL,
    [CARRYOVER_FAILED_quality_quantity_issues]          VARCHAR (255)  NULL,
    [CARRYOVER_FAILED_reagent_quality_issues]           VARCHAR (255)  NULL,
    [CARRYOVER_FAILED_QC_failure]                       VARCHAR (255)  NULL,
    [CARRYOVER_FAILED_power_failure]                    VARCHAR (255)  NULL,
    [CARRYOVER_FAILED_mechanical_failure]               VARCHAR (255)  NULL,
    [FAILED_CARRYOVER_sample_processing_error]          VARCHAR (255)  NULL,
    [CARRYOVER_OTHER]                                   VARCHAR (255)  NULL,
    [CARRYOVER_Results_printed_from_LIMS_by_VL_Lab]     VARCHAR (255)  NULL,
    [CARRYOVER_Results_dispatched_by_lab]               VARCHAR (255)  NULL,
    [RECEIVED_TOTAL_Sample_RUN]                         VARCHAR (255)  NULL,
    [RECEIVED_URGENT_Sample_RUN]                        VARCHAR (255)  NULL,
    [RECEIVED_REBLEEDS_RUN]                             VARCHAR (255)  NULL,
    [RECEIVED_FAILED_bt_Elig_REPEAT]                    VARCHAR (255)  NULL,
    [RECEIVED_FAILED_bt_NOT_Elig_REPEAT]                VARCHAR (255)  NULL,
    [RECEIVED_REPEATS_RUN]                              VARCHAR (255)  NULL,
    [RECEIVED_FAILED_after_FINAL_repeat_testing]        VARCHAR (255)  NULL,
    [RECEIVED_FAILED_quality_quantity_issues]           VARCHAR (255)  NULL,
    [RECEIVED_FAILED_reagent_quality_issues]            VARCHAR (255)  NULL,
    [RECEIVED_FAILED_QC_failure]                        VARCHAR (255)  NULL,
    [RECEIVED_FAILED_power_failure]                     VARCHAR (255)  NULL,
    [RECEIVED_FAILED_mechanical_failure]                VARCHAR (255)  NULL,
    [FAILED_RECEIVED_sample_processing_error]           VARCHAR (255)  NULL,
    [RECEIVED_OTHER]                                    VARCHAR (255)  NULL,
    [RECEIVED_Entered_In_LIMS]                          VARCHAR (255)  NULL,
    [RECEIVED_Results_printed_from_LIMS_by_VL_Lab]      VARCHAR (255)  NULL,
    [RECEIVED_Dispatched_Accessed_by_Online_Link]       VARCHAR (255)  NULL,
    [RECEIVED_Results_dispatched_by_lab]                VARCHAR (255)  NULL,
    [REFERRED_Samples_RUN]                              VARCHAR (255)  NULL,
    [REFERRED_Urgent_Samples_RUN]                       VARCHAR (255)  NULL,
    [REFERRED_ReBLEEDs_RUN]                             VARCHAR (255)  NULL,
    [REFERRED_FAILED_bt_Elig_REPEAT]                    VARCHAR (255)  NULL,
    [REFERRED_FAILED_bt_NOT_Elig_REPEAT]                VARCHAR (255)  NULL,
    [REFERRED_REPEATS_RUN]                              VARCHAR (255)  NULL,
    [REFERRED_FAILED_after_FINAL_repeat_testing]        VARCHAR (255)  NULL,
    [REFERRED_FAILED_quality_quantity_issues]           VARCHAR (255)  NULL,
    [REFERRED_FAILED_reagent_quality_issues]            VARCHAR (255)  NULL,
    [REFERRED_FAILED_power_failure]                     VARCHAR (255)  NULL,
    [REFERRED_FAILED_mechanical_failure]                VARCHAR (255)  NULL,
    [FAILED_REFERRED_sample_processing_error]           VARCHAR (255)  NULL,
    [REFERRED_OTHER]                                    VARCHAR (255)  NULL,
    [Comments]                                          NVARCHAR (MAX) NULL,
    [SourceFile]                                        VARCHAR (255)  NULL,
    [Update_date]                                       DATE           DEFAULT (getdate()) NULL,
    [unique_key]                                        VARCHAR (255)  NULL,
    [Controls_that_failed]                              VARCHAR (255)  NULL,
    [Sample_with_Valid_test_result]                     VARCHAR (255)  NULL,
    [Sample_with_FAILED_test_result]                    VARCHAR (255)  NULL,
    [Data_Quality_Checks]                               VARCHAR (255)  NULL,
    [Status]                                            VARCHAR (255)  NULL,
    [Target]                                            VARCHAR (255)  NULL,
    [RECEIVED_FAILED_sample_handling_error_lab]         VARCHAR (255)  NULL,
    [Name_of_bottleneck_consumable]                     VARCHAR (255)  NULL
);
