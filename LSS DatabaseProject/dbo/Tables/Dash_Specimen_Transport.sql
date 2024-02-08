CREATE TABLE [dbo].[Dash_Specimen_Transport] (
    [Date]                                              NVARCHAR (255) NULL,
    [District]                                          NVARCHAR (255) NULL,
    [Number_of_rider_accidents]                         INT            NULL,
    [Incomplete_bike_transport_trips]                   INT            NULL,
    [Specimens_transported_by_non_IST_methods]          INT            NULL,
    [Specimens_transported_by_ambulance]                INT            NULL,
    [Specimens_transported_by_alternative_IP_transport] INT            NULL,
    [Specimens_transported_by_MoHCC_arranged_transport] INT            NULL,
    [Specimens_transported_by_courier]                  INT            NULL,
    [Specimens_transported_by_other_non_IST_methods]    INT            NULL,
    [Comments]                                          NVARCHAR (MAX) NULL,
    [SourceFile]                                        NVARCHAR (255) NULL,
    [Unique_key]                                        NVARCHAR (MAX) NULL,
    [Status]                                            NVARCHAR (100) NULL
);

