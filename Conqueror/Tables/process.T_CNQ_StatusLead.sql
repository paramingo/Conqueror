CREATE TABLE [process].[T_CNQ_StatusLead]
(
	[IdStatusLead] INT NOT NULL PRIMARY KEY IDENTITY, 
    [StatusLead] VARCHAR(25) NOT NULL, 
    [IdNetwork] INT NOT NULL, 
    CONSTRAINT [FK_T_CNQ_StatusLead_T_CNQ_Networks] FOREIGN KEY ([IdNetwork]) REFERENCES [process].[T_CNQ_Networks]([IdNetwork]), 
    CONSTRAINT [AK_T_CNQ_StatusLead_Options] UNIQUE ([StatusLead],[IdNetwork]) 
)
