CREATE TABLE [output].[T_CNQ_LogProcesoFilas]
(
	[IdLinea] INT NOT NULL , 
	[IdFichero] INT NOT NULL , 
    [IdResultadoFila] INT NOT NULL, 
    [IdContactoComparacion] INT NULL,
    [Similarity] FLOAT NULL, 
    PRIMARY KEY ([IdLinea], [IdFichero], [IdResultadoFila]), 
    CONSTRAINT [FK_T_CNQ_LogProcesoFilas_T_CNQ_ResultadosFilas] FOREIGN KEY ([IdResultadoFila]) REFERENCES [output].[T_CNQ_ResultadosFilas]([IdResultadoFila])
)
