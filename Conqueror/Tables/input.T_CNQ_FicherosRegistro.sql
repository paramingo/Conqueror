﻿CREATE TABLE [input].[T_CNQ_FicherosRegistro]
(
	[IdFichero] INT NOT NULL PRIMARY KEY IDENTITY, 
    [IdFicheroTipo] INT NOT NULL, 
    [DsFichero] VARCHAR(100) NOT NULL, 
    [FcInicioCarga] DATETIME NOT NULL DEFAULT GETDATE(), 
    [FcFinCarga] DATETIME NULL, 
    [Deleted] BIT NOT NULL DEFAULT 0, 
    CONSTRAINT [FK_T_CNQ_FicherosRegistro_T_CNQ_FicherosTipos] FOREIGN KEY ([IdFicheroTipo]) REFERENCES [input].[T_CNQ_FicherosTipos]([IdFicheroTipo])
)
