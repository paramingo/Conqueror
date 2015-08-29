CREATE TABLE [process].[T_CNQ_TitleSynonym]
(
	[TitleSynonym] VARCHAR(10) NOT NULL PRIMARY KEY, 
    [IdTitle] INT NOT NULL,
    CONSTRAINT [FK_T_CNQ_TitleSynonym_T_CNQ_Titles] FOREIGN KEY ([IdTitle]) REFERENCES [process].[T_CNQ_Titles]([IdTitle]), 
)
