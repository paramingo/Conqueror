CREATE TABLE [process].[T_CNQ_FicherosProcesados] (
    [IdLinea]                INT            NOT NULL,
    [IdFichero]              INT            NOT NULL,
    [Source]                 NVARCHAR (80)  NULL,
    [IdGeography]            INT            NULL,
    [Email]                  NVARCHAR (200) NULL,
    [IdTitle]                INT            NULL,
    [FirstName]              NVARCHAR (255) NULL,
    [Surname]                NVARCHAR (255) NULL,
    [CompanyName]            NVARCHAR (255) NULL,
    [Address]                NVARCHAR (500) NULL,
    [PostalCode]             NVARCHAR (40)  NULL,
    [TelephoneNo]            NVARCHAR (200) NULL,
    [MobileNo]               NVARCHAR (200) NULL,
    [Fax]                    NVARCHAR (200) NULL,
    [Website]                NVARCHAR (200) NULL,
    [COOPIdStatusLead]       INT            NULL,
    [COOPIdStatusLeadDetail] INT            NULL,
    [CQRIdStatusLead]        INT            NULL,
    [CQRIdStatusLeadDetail]  INT            NULL,
    [COOPIdStatusCity]       INT            NULL,
    [CQRIdStatusCity]        INT            NULL,
	[SingleColumnUniqueKey]  AS [IdLinea] * 1000 + [IdFichero] PERSISTED NOT NULL,
    CONSTRAINT [PK_T_CNQ_FicherosProcesados] PRIMARY KEY CLUSTERED ([IdLinea] ASC, [IdFichero] ASC),
    CONSTRAINT [FK_T_CNQ_FicherosProcesados_T_CNQ_FicherosRegistro] FOREIGN KEY ([IdFichero]) REFERENCES [input].[T_CNQ_FicherosRegistro] ([IdFichero]),
    CONSTRAINT [FK_T_CNQ_FicherosProcesados_T_CNQ_StatusCity_COOP] FOREIGN KEY ([COOPIdStatusCity]) REFERENCES [process].[T_CNQ_StatusCity] ([IdStatusCity]),
    CONSTRAINT [FK_T_CNQ_FicherosProcesados_T_CNQ_StatusCity_CQR] FOREIGN KEY ([CQRIdStatusCity]) REFERENCES [process].[T_CNQ_StatusCity] ([IdStatusCity]),
    CONSTRAINT [FK_T_CNQ_FicherosProcesados_T_CNQ_StatusLead_COOP] FOREIGN KEY ([COOPIdStatusLead]) REFERENCES [process].[T_CNQ_StatusLead] ([IdStatusLead]),
    CONSTRAINT [FK_T_CNQ_FicherosProcesados_T_CNQ_StatusLead_CQR] FOREIGN KEY ([CQRIdStatusLead]) REFERENCES [process].[T_CNQ_StatusLead] ([IdStatusLead]),
    CONSTRAINT [FK_T_CNQ_FicherosProcesados_T_CNQ_StatusLeadDetails_COOP] FOREIGN KEY ([COOPIdStatusLeadDetail]) REFERENCES [process].[T_CNQ_StatusLeadDetails] ([IdStatusLeadDetail]),
    CONSTRAINT [FK_T_CNQ_FicherosProcesados_T_CNQ_StatusLeadDetailsCQR] FOREIGN KEY ([CQRIdStatusLeadDetail]) REFERENCES [process].[T_CNQ_StatusLeadDetails] ([IdStatusLeadDetail]),
    CONSTRAINT [FK_T_CNQ_FicherosProcesados_T_CNQ_Titles] FOREIGN KEY ([IdTitle]) REFERENCES [process].[T_CNQ_Titles] ([IdTitle]),
    CONSTRAINT [FK_T_CNQ_FicherosProcesados_T_CNQ_Geography] FOREIGN KEY ([IdGeography]) REFERENCES [process].[T_CNQ_Geography] ([IdGeography]), 
    CONSTRAINT [AK_T_CNQ_FicherosProcesados_Unique] UNIQUE ([SingleColumnUniqueKey])
);


GO


CREATE INDEX [IX_T_CNQ_FicherosProcesados_Column] ON [process].[T_CNQ_FicherosProcesados] ([Email], [FirstName], [CompanyName])
