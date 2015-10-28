CREATE TABLE [output].[T_CNQ_LogUpdateCRM]
(
	[IdLogCRM] INT NOT NULL IDENTITY,
	[IdCRM] INT NOT NULL,
	[IdContacto] INT NULL,
	[Fase] INT DEFAULT NULL, 
    [Defecto] INT NULL DEFAULT NULL, 
    [Similarity] FLOAT NULL, 
    [IdNetwork] INT NULL, 
    CONSTRAINT [PK_T_CNQ_LogUpdateCRM] PRIMARY KEY ([IdLogCRM], [IdCRM]) 
)

GO

CREATE UNIQUE INDEX [IX_T_CNQ_LogUpdateCRM_IdContacto] ON [output].[T_CNQ_LogUpdateCRM] ([IdNetwork],[IdContacto]) WHERE [IdContacto] IS NOT NULL
