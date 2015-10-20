CREATE TABLE [input].[T_CNQ_FicherosCRM]
(
	[IdFichero]   INT            NOT NULL,
    [IdCRM]       INT            NOT NULL IDENTITY, 
    [CompanyName] NVARCHAR (255) NULL,
    [Continent]   NVARCHAR (20)  NULL,
    [Country]     NVARCHAR (50)  NULL,
    [City]        NVARCHAR (100) NULL,
    [FirstName]   NVARCHAR (255) NULL,
    [Email]       NVARCHAR (200) NULL,
	[TelephoneNo] NVARCHAR (200) NULL,
	[StatusLead]  VARCHAR (25) NULL,
    PRIMARY KEY ([IdFichero], [IdCRM])
)

GO

GRANT INSERT
    ON OBJECT::[input].[T_CNQ_FicherosCRM] TO [CNQ_SSISUser]
    AS [dbo];


GO

GRANT SELECT
    ON OBJECT::[input].[T_CNQ_FicherosCRM] TO [CNQ_SSISUser]
    AS [dbo];


GO