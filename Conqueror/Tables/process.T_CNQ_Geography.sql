CREATE TABLE [process].[T_CNQ_Geography]
(
	[IdGeography] INT NOT NULL IDENTITY,
    [Continent]   NVARCHAR (20)  NULL,
    [Country]     NVARCHAR (50)  NULL,
    [City]        NVARCHAR (100) NULL, 
    CONSTRAINT [AK_T_CNQ_Geography_IdGeography] UNIQUE ([IdGeography])
)

GO

CREATE UNIQUE CLUSTERED INDEX [IX_T_CNQ_Geography_Column] ON [process].[T_CNQ_Geography] ([Continent], [Country], [City])
