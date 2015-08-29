CREATE TABLE [process].[T_CNQ_StatusCity]
(
	[IdStatusCity] INT NOT NULL PRIMARY KEY IDENTITY, 
    [StatusCity] VARCHAR(25) NULL, 
    [IdNetwork] INT NULL,
    CONSTRAINT [FK_T_CNQ_StatusCity_T_CNQ_Networks] FOREIGN KEY ([IdNetwork]) REFERENCES [process].[T_CNQ_Networks]([IdNetwork]), 
    CONSTRAINT [AK_T_CNQ_StatusCity_Options] UNIQUE ([StatusCity],[IdNetwork])
)
