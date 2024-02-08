CREATE TABLE [dbo].[Dash_weekly_targets] (
    [Lab]            NCHAR (255)    NULL,
    [weekly_targets] INT            NULL,
    [date_end]       NVARCHAR (255) DEFAULT (getdate()) NULL,
    [ID]             INT            IDENTITY (1, 1) NOT NULL,
    [vl_received]    NCHAR (255)    NULL,
    CONSTRAINT [PK__Dash_wee__3214EC27A6B61CBA] PRIMARY KEY CLUSTERED ([ID] ASC)
);

