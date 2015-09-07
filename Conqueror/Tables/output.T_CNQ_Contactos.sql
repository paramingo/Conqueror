﻿CREATE TABLE [output].[T_CNQ_Contactos]
(
    [IdContacto] INT NOT NULL IDENTITY, 
    [IdLinea] INT NOT NULL PRIMARY KEY, 
	[Source] NVARCHAR(80) NULL,
	[IdGeography] INT NULL,
	[Email] NVARCHAR(100) NULL,
	[IdTitle] INT NULL,
	[FirstName] NVARCHAR(255) NULL,
	[Surname] NVARCHAR(255) NULL,
	[CompanyName] NVARCHAR(255) NULL,
	[Address] NVARCHAR(500) NULL,
	[PostalCode] NVARCHAR(40) NULL,
	[TelephoneNo] NVARCHAR(200) NULL,
	[MobileNo] NVARCHAR(200) NULL,
	[Fax] NVARCHAR(200) NULL,
	[Website] NVARCHAR(200) NULL,
	[COOPIdStatusLead] INT NOT NULL,
	[COOPIdStatusLeadDetail] INT NULL,
	[CQRIdStatusLead] INT NOT NULL,
	[CQRIdStatusLeadDetail] INT NULL,
	[COOPIdStatusCity] INT NOT NULL,
	[CQRIdStatusCity] INT NOT NULL,
    CONSTRAINT [FK_T_CNQ_Contactos_T_CNQ_Titles] FOREIGN KEY ([IdTitle]) REFERENCES [process].[T_CNQ_Titles]([IdTitle]), 
    CONSTRAINT [FK_T_CNQ_Contactos_T_CNQ_StatusLead_COOP] FOREIGN KEY ([COOPIdStatusLead]) REFERENCES [process].[T_CNQ_StatusLead]([IdStatusLead]),
    CONSTRAINT [FK_T_CNQ_Contactos_T_CNQ_StatusLeadDetails_COOP] FOREIGN KEY ([COOPIdStatusLeadDetail]) REFERENCES [process].[T_CNQ_StatusLeadDetails]([IdStatusLeadDetail]),
    CONSTRAINT [FK_T_CNQ_Contactos_T_CNQ_StatusLead_CQR] FOREIGN KEY ([CQRIdStatusLead]) REFERENCES [process].[T_CNQ_StatusLead]([IdStatusLead]),
    CONSTRAINT [FK_T_CNQ_Contactos_T_CNQ_StatusLeadDetailsCQR] FOREIGN KEY ([CQRIdStatusLeadDetail]) REFERENCES [process].[T_CNQ_StatusLeadDetails]([IdStatusLeadDetail]),
    CONSTRAINT [FK_T_CNQ_Contactos_T_CNQ_StatusCity_COOP] FOREIGN KEY ([COOPIdStatusCity]) REFERENCES [process].[T_CNQ_StatusCity]([IdStatusCity]),
    CONSTRAINT [FK_T_CNQ_Contactos_T_CNQ_StatusCity_CQR] FOREIGN KEY ([CQRIdStatusCity]) REFERENCES [process].[T_CNQ_StatusCity]([IdStatusCity])
)
GO



CREATE UNIQUE INDEX [IX_T_CNQ_Contacto_Unico] ON [output].[T_CNQ_Contactos] ([Email],[FirstName],[CompanyName],[IdGeography]) INCLUDE ([IdLinea])
