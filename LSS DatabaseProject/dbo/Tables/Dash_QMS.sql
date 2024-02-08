CREATE TABLE [dbo].[Dash_QMS] (
    [Date]                              VARCHAR (255) NULL,
    [Lab_name]                          VARCHAR (255) NULL,
    [Scope]                             VARCHAR (255) NULL,
    [Date_of_Recent_Audit]              VARCHAR (255) NULL,
    [Audit_Type_SADCAS]                 VARCHAR (255) NULL,
    [Total_NCs_from_recent_Audit]       VARCHAR (255) NULL,
    [NCs_closed_this_week]              VARCHAR (255) NULL,
    [NCs_not_yet_closed]                VARCHAR (255) NULL,
    [NCs_Submitted_to_SADCAS]           VARCHAR (255) NULL,
    [SADCAS_Feedback_Received_Date]     VARCHAR (255) NULL,
    [NCs_Cleared_by_SADCAS]             VARCHAR (255) NULL,
    [NCs_awaiting_feedback_from_SADCAS] VARCHAR (255) NULL,
    [NCs_Requiring_Resubmission]        VARCHAR (255) NULL,
    [Follow_Up_Resubmission_Date]       VARCHAR (255) NULL,
    [Cleared_by_SADCAS_Yes_No]          VARCHAR (255) NULL,
    [SourceFile]                        VARCHAR (255) NULL,
    [update_date]                       VARCHAR (255) NULL,
    [unique_key]                        VARCHAR (255) NULL
);

