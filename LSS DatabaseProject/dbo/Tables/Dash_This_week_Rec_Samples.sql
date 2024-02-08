﻿CREATE TABLE [dbo].[Dash_This_week_Rec_Samples] (
    [Date]                                        VARCHAR (255)  NULL,
    [Name_of_Lab]                                 VARCHAR (255)  NULL,
    [Sample_Type]                                 VARCHAR (255)  NULL,
    [Test_Type]                                   VARCHAR (255)  NULL,
    [Total_samples_received]                      INT            NULL,
    [Urgent_Samples_received]                     INT            NULL,
    [Num_ReBleed_Samples]                         INT            NULL,
    [Weekly_sample_receipt_target]                INT            NULL,
    [Num_Rejected_Samples]                        INT            NULL,
    [weekly_max_threshhold]                       INT            NULL,
    [REJECTED_Quality_issue]                      INT            NULL,
    [REJECTED_Quantity_insuff]                    INT            NULL,
    [REJECTED_Patient_SampleINFO]                 INT            NULL,
    [REJECTED_Missing_requestForm]                INT            NULL,
    [REJECTED_Sample_Missing]                     INT            NULL,
    [Num_Samples_entered_LIMSonArrival]           INT            NULL,
    [LIMs_Backlog_yetTObeEntered]                 INT            NULL,
    [comments]                                    NVARCHAR (MAX) NULL,
    [SourceFile]                                  VARCHAR (255)  NULL,
    [Update_Date]                                 DATE           DEFAULT (getdate()) NULL,
    [unique_key]                                  VARCHAR (255)  NULL,
    [Carryover_Samples_in_the_lab]                VARCHAR (255)  NULL,
    [Samples_in_backlog_Intra_lab_TAT_7_days]     VARCHAR (255)  NULL,
    [REJECTED_too_old_to_test]                    VARCHAR (255)  NULL,
    [REJECTED_Quanti_Quali_intransit_compromised] VARCHAR (255)  NULL,
    [REJECTED_other_reasons]                      VARCHAR (255)  NULL,
    [LIMS_hub_logged_prior_to_arrival]            VARCHAR (255)  NULL,
    [LIMS_logged_during_week_of_arrival]          VARCHAR (255)  NULL,
    [LIMS_Backlog_shipments_to_be_received]       VARCHAR (255)  NULL,
    [Data_Quality_Checks]                         VARCHAR (255)  NULL,
    [Status]                                      VARCHAR (255)  NULL,
    [checked]                                     VARCHAR (255)  NULL
);

