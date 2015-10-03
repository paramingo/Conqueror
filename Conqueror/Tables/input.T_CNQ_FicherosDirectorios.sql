CREATE TABLE [input].[T_CNQ_FicherosDirectorios] (
    [IdFichero]             INT            NOT NULL,
    [IdLinea]               INT            IDENTITY (1, 1) NOT NULL,
    [Source]                NVARCHAR (80)  NULL,
    [Continent]             NVARCHAR (20)  NULL,
    [Country]               NVARCHAR (50)  NULL,
    [City]                  NVARCHAR (100) NULL,
    [Email]                 NVARCHAR (200) NULL,
    [Title]                 NVARCHAR (5)   NULL,
    [FirstName]             NVARCHAR (255) NULL,
    [Surname]               NVARCHAR (255) NULL,
    [JobTitle]              NVARCHAR (200) NULL,
    [CompanyName]           NVARCHAR (255) NULL,
    [Address]               NVARCHAR (3000) NULL,
    [PostalCode]            NVARCHAR (40)  NULL,
    [TelephoneNo]           NVARCHAR (200) NULL,
    [MobileNo]              NVARCHAR (200) NULL,
    [Fax]                   NVARCHAR (200) NULL,
    [Website]               NVARCHAR (200) NULL,
    [COOPStatusLead]        NVARCHAR (60)  NULL,
    [CQRStatusLead]         NVARCHAR (60)  NULL,
    [COOPStatusCity]        NVARCHAR (40)  NULL,
    [CQRStatusCity]         NVARCHAR (40)  NULL,
    PRIMARY KEY CLUSTERED ([IdFichero] ASC, [IdLinea] ASC),
    CONSTRAINT [FK_T_CNQ_FicherosDirectorios_T_CNQ_FicherosRegistro] FOREIGN KEY ([IdFichero]) REFERENCES [input].[T_CNQ_FicherosRegistro] ([IdFichero])
);


GO

GRANT INSERT
    ON OBJECT::[input].[T_CNQ_FicherosDirectorios] TO [CNQ_SSISUser]
    AS [dbo];


GO

GRANT SELECT
    ON OBJECT::[input].[T_CNQ_FicherosDirectorios] TO [CNQ_SSISUser]
    AS [dbo];


GO