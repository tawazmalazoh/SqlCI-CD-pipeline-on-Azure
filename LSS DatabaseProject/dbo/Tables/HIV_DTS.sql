CREATE TABLE [dbo].[HIV_DTS] (
    [Participant Code]                    NVARCHAR (255) NULL,
    [Participant Name]                    NVARCHAR (255) NULL,
    [Institute Name]                      NVARCHAR (255) NULL,
    [Standardised Facility Names]         NVARCHAR (255) NULL,
    [Department]                          NVARCHAR (255) NULL,
    [Province]                            NVARCHAR (255) NULL,
    [District]                            NVARCHAR (255) NULL,
    [City ]                               NVARCHAR (255) NULL,
    [Country]                             NVARCHAR (255) NULL,
    [No. of Panels Correct (N=6)]         NVARCHAR (255) NULL,
    [Panel Score]                         NVARCHAR (255) NULL,
    [Documentation Score]                 NVARCHAR (255) NULL,
    [Total Score]                         NVARCHAR (255) NULL,
    [Overall Performance]                 NVARCHAR (255) NULL,
    [Warnings and/or Reasons for Failure] NTEXT          NULL,
    [B3]                                  VARCHAR (255)  NULL,
    [B4]                                  VARCHAR (255)  NULL,
    [Rececy Code]                         VARCHAR (255)  NULL,
    [comments]                            VARCHAR (255)  NULL,
    [sourceFile]                          VARCHAR (255)  NULL
);

