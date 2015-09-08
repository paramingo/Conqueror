CREATE VIEW [output].[V_CNQ_InformeTrazaContactos]
AS
SELECT IdContacto
	,DsFichero, Source, Continent, Country, City, Email, Title, FirstName, Surname, JobTitle
	,CompanyName, Address, PostalCode, TelephoneNo, MobileNo, Fax, Website
	,COOPStatusLead, CQRStatusLead, COOPStatusCity, CQRStatusCity
FROM (
	SELECT IdContactoComparacion AS IdContacto
		,LPF.IdFichero, LPF.IdLinea, Source, Continent, Country, City, Email, Title, FirstName, Surname, JobTitle
		,CompanyName, Address, PostalCode, TelephoneNo, MobileNo, Fax, Website
		,COOPStatusLead, CQRStatusLead, COOPStatusCity, CQRStatusCity
	FROM [output].[T_CNQ_LogProcesoFilas] LPF
	INNER JOIN [input].[T_CNQ_FicherosAsociaciones] A ON LPF.IdLinea = A.IdLinea AND LPF.IdFichero = A.IdFichero
	UNION ALL
	SELECT IdContactoComparacion AS IdContacto
		,LPF.IdFichero, LPF.IdLinea, Source, Continent, Country, City, Email, NULL, TitleFirstNameSurname, NULL, NULL
		,CompanyName, Address, PostalCode, TelephoneNo, NULL, NULL, NULL
		,COOPStatusLead, CQRStatusLead, COOPStatusCity, CQRStatusCity
	FROM [output].[T_CNQ_LogProcesoFilas] LPF
	INNER JOIN [input].[T_CNQ_Ficheros] F ON LPF.IdLinea = F.IdLinea AND LPF.IdFichero = F.IdFichero
) Lineas
INNER JOIN [input].[T_CNQ_FicherosRegistro] FR ON FR.IdFichero =  Lineas.IdFichero

GO

GRANT SELECT
    ON OBJECT::[output].[V_CNQ_InformeTrazaContactos] TO [CNQ_Conqueror]
    AS [dbo];


GO
