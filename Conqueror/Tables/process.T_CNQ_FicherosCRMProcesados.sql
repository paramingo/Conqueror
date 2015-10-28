CREATE TABLE [process].[T_CNQ_FicherosCRMProcesados]
(
	[IdFichero]   INT            NOT NULL,
    [IdCRM]       INT            NOT NULL, 
    [CompanyName] NVARCHAR (255) NULL,
    [IdGeography] INT            NULL,
    [FirstName]   NVARCHAR (255) NULL,
    [Email]       NVARCHAR (200) NULL,
	[TelephoneNo] NVARCHAR (200) NULL,
    [COOPIdStatusLead] INT       NULL,
    [CQRIdStatusLead]  INT       NULL,
    [IdNetwork] INT NULL, 
    PRIMARY KEY ([IdFichero], [IdCRM]), 
    CONSTRAINT [FK_T_CNQ_FicherosCRMProcesados_T_CNQ_Networks] FOREIGN KEY ([IdNetwork]) REFERENCES [process].[T_CNQ_Networks]([IdNetwork])
)
