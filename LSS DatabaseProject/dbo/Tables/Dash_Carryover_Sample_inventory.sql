﻿CREATE TABLE [dbo].[Dash_Carryover_Sample_inventory] (
    [Date]                                      VARCHAR (255)  NULL,
    [Name_of_Lab]                               VARCHAR (255)  NULL,
    [Sample_Type]                               VARCHAR (255)  NULL,
    [Test_Type]                                 VARCHAR (255)  NULL,
    [NEVERTESTED_Samples_in_Lab]                INT            NULL,
    [FAILED_Samples_in_Lab]                     INT            NULL,
    [BACKLOG_Samples_intraTAT_7mo]              INT            NULL,
    [CARRYOVER_Samples_urgent]                  INT            NULL,
    [CARRYOVER_Samples_rebleeds]                INT            NULL,
    [CARRYOVER_Samples_rejected]                INT            NULL,
    [REJECTED_Quality_issue]                    INT            NULL,
    [REJECTED_Quantity_insuff]                  INT            NULL,
    [REJECTED_Patient_SampleINFO]               INT            NULL,
    [REJECTED_Missing_requestForm]              INT            NULL,
    [REJECTED_Sample_Missing]                   INT            NULL,
    [Days_for_OLDEST_CarryoverSample]           INT            NULL,
    [Days_for_YOUNGEST_CarryoverSample]         INT            NULL,
    [NUMBER_carryover_sample_TOO_OLD_test]      INT            NULL,
    [NUMBER_carryover_samples_in_LIMS]          INT            NULL,
    [Carry_Over_Sample_LIMS_Backlog_tobelogged] INT            NULL,
    [comment]                                   NVARCHAR (MAX) NULL,
    [TOTAL_CORRYOVER_SAMPLES]                   INT            NULL,
    [TOTAL_Plasma_VL]                           INT            NULL,
    [TOTAL_DBS_VL]                              INT            NULL,
    [TOTAL_DBS_EID]                             INT            NULL,
    [SourceFile]                                VARCHAR (255)  NULL,
    [update_date]                               DATE           DEFAULT (getdate()) NULL,
    [unique_key]                                VARCHAR (255)  NULL,
    [Status]                                    VARCHAR (255)  NULL,
    [checked]                                   VARCHAR (255)  NULL
);
