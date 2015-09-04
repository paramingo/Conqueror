CREATE TABLE [output].[T_CNQ_ContactosConsolidar] (
    [IdContacto]       INT            NOT NULL,
    [Source]           NVARCHAR (80)  NULL,
    [Continent]        NVARCHAR (20)  NULL,
    [Country]          NVARCHAR (50)  NULL,
    [City]             NVARCHAR (80)  NULL,
    [Email]            NVARCHAR (100) NOT NULL,
    [Title]            VARCHAR  (5)   NULL,
    [FirstNameSurname] NVARCHAR (255) NOT NULL,
    [CompanyName]      NVARCHAR (255) NULL,
    [Address]          NVARCHAR (500) NULL,
    [PostalCode]       NVARCHAR (15)  NULL,
    [TelephoneNo]      NVARCHAR (200) NULL,
    [MobileNo]         NVARCHAR (200) NULL,
    [Fax]              NVARCHAR (200) NULL,
    [Website]          NVARCHAR (200) NULL,
    [COOPStatusLead]   VARCHAR (25)   NULL,
    [CQRStatusLead]    VARCHAR (25)   NULL,
    [COOPStatusCity]   VARCHAR (25)   NULL,
    [CQRStatusCity]    VARCHAR (25)   NULL,
    [Comment]          VARCHAR (25)   NULL
);


GO

GRANT SELECT
    ON OBJECT::[output].[T_CNQ_ContactosConsolidar] TO [CNQ_Conqueror]
    AS [dbo];


GO

