CREATE PROCEDURE [output].[PR_CNQ_ContactosConsolidar]
AS
BEGIN
	TRUNCATE TABLE [output].[T_CNQ_ContactosConsolidar]

	INSERT INTO [output].[T_CNQ_ContactosConsolidar]
	(IdContacto, Source, Continent, Country, City, Email, Title, FirstName, Surname, CompanyName, Address,
		PostalCode, TelephoneNo, MobileNo, Fax, Website, COOPStatusLead, CQRStatusLead, COOPStatusCity,
		CQRStatusCity, Comment)
	SELECT IdContacto, Source, Continent, Country, City, Email, Title, FirstName, Surname, CompanyName, Address,
		PostalCode, TelephoneNo, MobileNo, Fax, Website, COOPStatusLead, CQRStatusLead, COOPStatusCity,
		CQRStatusCity, Comment
	FROM [output].[V_CNQ_ContactosConsolidar]
END
