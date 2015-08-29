CREATE TABLE [process].[T_CNQ_StatusLeadDetails]
(
	[IdStatusLeadDetail] INT NOT NULL PRIMARY KEY IDENTITY, 
    [StatusLeadDetail] VARCHAR(25) NOT NULL, 
    [IdStatusLead] INT NOT NULL,
    CONSTRAINT [FK_T_CNQ_StatusLeadDetail_T_CNQ_Networks] FOREIGN KEY ([IdStatusLead]) REFERENCES [process].[T_CNQ_StatusLead]([IdStatusLead]), 
    CONSTRAINT [AK_T_CNQ_StatusLeadDetail_Options] UNIQUE ([StatusLeadDetail],[IdStatusLead]) 
)
