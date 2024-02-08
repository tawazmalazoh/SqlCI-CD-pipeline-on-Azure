CREATE TABLE [dbo].[Dash_Power_Outage] (
    [Date]                             VARCHAR (255)  NULL,
    [Laboratory]                       VARCHAR (255)  NULL,
    [Hours_with_no_electricity]        INT            NULL,
    [Hours_generator_was_on]           INT            NULL,
    [Fuel_ltrs_added_to_generator]     VARCHAR (255)  NULL,
    [Hrs_Machine_idle_coz_PowerCuts]   INT            NULL,
    [Total_Tests_done_using_generator] INT            NULL,
    [Comments]                         NVARCHAR (MAX) NULL,
    [SourceFile]                       VARCHAR (255)  NULL,
    [Update_date]                      DATE           DEFAULT (getdate()) NULL,
    [unique_key]                       VARCHAR (255)  NULL,
    [Status]                           VARCHAR (255)  NULL,
    [checked]                          VARCHAR (255)  NULL
);

