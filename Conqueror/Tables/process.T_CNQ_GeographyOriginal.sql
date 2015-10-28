CREATE TABLE [process].[T_CNQ_GeographyOriginal] (
    [IdGeography] INT            IDENTITY (1, 1) NOT NULL,
    [Continent]   NVARCHAR (20)  NULL,
    [Country]     NVARCHAR (50)  NULL,
    [City]        NVARCHAR (100) NULL,
    CONSTRAINT [AK_T_CNQ_Geography2_IdGeography] UNIQUE NONCLUSTERED ([IdGeography] ASC)
);

