CREATE TABLE [output].[T_CNQ_LogProcesoFilas]
(
	[IdLinea] INT NOT NULL , 
    [IdResultadoFila] INT NOT NULL, 
    [IdLineaComparacion] INT NULL
    PRIMARY KEY ([IdLinea], [IdResultadoFila]), 
    CONSTRAINT [FK_T_CNQ_LogProcesoFilas_T_CNQ_ResultadosFilas] FOREIGN KEY ([IdResultadoFila]) REFERENCES [output].[T_CNQ_ResultadosFilas]([IdResultadoFila])
)
