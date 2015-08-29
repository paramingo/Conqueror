CREATE TABLE [process].[T_CNQ_FicherosProcesados]
(
    [IdLinea] INT NOT NULL PRIMARY KEY, 
	--[Source] NVARCHAR(80) NULL,
	--[Continent] NVARCHAR(20) NULL,
	--[Country] NVARCHAR(50) NULL,
	--[City] NVARCHAR(80) NULL,
	--[Email] NVARCHAR(100) NULL,
	--[TitleFirstNameSurname] NVARCHAR(255) NULL,
	--[CompanyName] NVARCHAR(255) NULL,
	--[Address] NVARCHAR(500) NULL,
	--[PostalCode] NVARCHAR(15) NULL,
	--[TelephoneNo] NVARCHAR(200) NULL,
	[COOPIdStatusLead] INT NOT NULL,
	[COOPIdStatusLeadDetail] INT NULL,
	[CQRIdStatusLead] INT NOT NULL,
	[CQRIdStatusLeadDetail] INT NULL,
	[COOPIdStatusCity] INT NOT NULL,
	[CQRIdStatusCity] INT NOT NULL,
    CONSTRAINT [FK_T_CNQ_FicherosProcesados_T_CNQ_StatusLead_COOP] FOREIGN KEY ([COOPIdStatusLead]) REFERENCES [process].[T_CNQ_StatusLead]([IdStatusLead]),
    CONSTRAINT [FK_T_CNQ_FicherosProcesados_T_CNQ_StatusLeadDetails_COOP] FOREIGN KEY ([COOPIdStatusLeadDetail]) REFERENCES [process].[T_CNQ_StatusLeadDetails]([IdStatusLeadDetail]),
    CONSTRAINT [FK_T_CNQ_FicherosProcesados_T_CNQ_StatusLead_CQR] FOREIGN KEY ([CQRIdStatusLead]) REFERENCES [process].[T_CNQ_StatusLead]([IdStatusLead]),
    CONSTRAINT [FK_T_CNQ_FicherosProcesados_T_CNQ_StatusLeadDetailsCQR] FOREIGN KEY ([CQRIdStatusLeadDetail]) REFERENCES [process].[T_CNQ_StatusLeadDetails]([IdStatusLeadDetail]),
    CONSTRAINT [FK_T_CNQ_FicherosProcesados_T_CNQ_StatusCity_COOP] FOREIGN KEY ([COOPIdStatusCity]) REFERENCES [process].[T_CNQ_StatusCity]([IdStatusCity]),
    CONSTRAINT [FK_T_CNQ_FicherosProcesados_T_CNQ_StatusCity_CQR] FOREIGN KEY ([CQRIdStatusCity]) REFERENCES [process].[T_CNQ_StatusCity]([IdStatusCity])
)
GO
