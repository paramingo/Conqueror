CREATE TABLE [input].[T_CNQ_Ficheros]
(
	[IdFichero] INT NOT NULL , 
    [IdLinea] INT NOT NULL IDENTITY, 
	[Source] VARCHAR(50) NULL,
	[Continent] VARCHAR(20) NULL,
	[Country] VARCHAR(50) NULL,
	[City] VARCHAR(50) NULL,
	[Email] VARCHAR(100) NULL,
	[TitleFirstNameSurname] VARCHAR(500) NULL,
	[CompanyName] VARCHAR(250) NULL,
	[Address] VARCHAR(500) NULL,
	[PostalCode] VARCHAR(15) NULL,
	[TelephoneNo] VARCHAR(200) NULL,
	[COOPStatusLead] VARCHAR(100) NULL,
	[CQRStatusLead] VARCHAR(100) NULL,
	[COOPStatusCity] VARCHAR(50) NULL,
	[CQRStatusCity] VARCHAR(50) NULL,
    PRIMARY KEY ([IdFichero], [IdLinea])
)
