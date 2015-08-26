CREATE TABLE [input].[T_CNQ_Ficheros]
(
	[IdFichero] INT NOT NULL , 
    [IdLinea] INT NOT NULL IDENTITY, 
	[Source] NVARCHAR(50) NULL,
	[Continent] NVARCHAR(20) NULL,
	[Country] NVARCHAR(50) NULL,
	[City] NVARCHAR(50) NULL,
	[Email] NVARCHAR(100) NULL,
	[TitleFirstNameSurname] NVARCHAR(500) NULL,
	[CompanyName] NVARCHAR(250) NULL,
	[Address] NVARCHAR(500) NULL,
	[PostalCode] NVARCHAR(15) NULL,
	[TelephoneNo] NVARCHAR(200) NULL,
	[COOPStatusLead] NVARCHAR(100) NULL,
	[CQRStatusLead] NVARCHAR(100) NULL,
	[COOPStatusCity] NVARCHAR(50) NULL,
	[CQRStatusCity] NVARCHAR(50) NULL,
    PRIMARY KEY ([IdFichero], [IdLinea]), 
    CONSTRAINT [FK_T_CNQ_Ficheros_T_CNQ_FicherosRegistro] FOREIGN KEY ([IdFichero]) REFERENCES [input].[T_CNQ_FicherosRegistro]([IdFichero])
)
