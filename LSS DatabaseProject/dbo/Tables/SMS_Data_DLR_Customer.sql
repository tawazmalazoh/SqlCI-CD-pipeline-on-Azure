CREATE TABLE [dbo].[SMS_Data_DLR_Customer] (
    [Job_#]            VARCHAR (255)  NULL,
    [SMSID]            VARCHAR (255)  NULL,
    [Sender_ID]        VARCHAR (255)  NULL,
    [Phone_Number]     VARCHAR (255)  NULL,
    [Country]          VARCHAR (255)  NULL,
    [Operator]         VARCHAR (255)  NULL,
    [SMS_Source]       VARCHAR (255)  NULL,
    [Encoding]         VARCHAR (255)  NULL,
    [Length]           VARCHAR (255)  NULL,
    [Parts]            VARCHAR (255)  NULL,
    [Submit_Date_UTC_] VARCHAR (255)  NULL,
    [Sent_Date_UTC_]   VARCHAR (255)  NULL,
    [Message_Text]     TEXT           NULL,
    [SourceFile]       VARCHAR (255)  NULL,
    [Update_date]      DATE           DEFAULT (getdate()) NULL,
    [Job_#_1]          VARCHAR (255)  NULL,
    [Sender_ID_1]      VARCHAR (255)  NULL,
    [last_Sunday_date] NVARCHAR (255) NULL,
    [user]             VARCHAR (255)  NULL,
    [unique_key]       VARCHAR (255)  NULL
);

