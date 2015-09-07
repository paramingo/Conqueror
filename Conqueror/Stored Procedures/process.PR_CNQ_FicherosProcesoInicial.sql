﻿CREATE PROCEDURE [process].[PR_CNQ_FicherosProcesoInicial]
AS
BEGIN
	TRUNCATE TABLE [process].[T_CNQ_FicherosProcesados]

	MERGE [process].[T_CNQ_Geography] AS TARGET
	USING (SELECT DISTINCT [Continent]
				,[Country]
				,[City]
			FROM [input].[T_CNQ_Ficheros]
			UNION
			SELECT DISTINCT [Continent]
				,[Country]
				,[City]
			FROM [input].[T_CNQ_FicherosAsociaciones]
			) AS SOURCE
	ON TARGET.[Continent] = SOURCE.[Continent]
		AND TARGET.[Country] = SOURCE.[Country]
		AND TARGET.[City] = SOURCE.[City]
	WHEN NOT MATCHED BY TARGET THEN
		INSERT ([Continent], [Country], [City])
		VALUES ([Continent], [Country], [City])
	WHEN NOT MATCHED BY SOURCE THEN
		DELETE
	;

	-- BBDD General
	INSERT INTO [process].[T_CNQ_FicherosProcesados]
	(IdLinea, IdFichero, Source, IdGeography, Email, FirstName, CompanyName, Address, PostalCode,
		TelephoneNo, COOPIdStatusLead, CQRIdStatusLead, COOPIdStatusCity, CQRIdStatusCity)
	SELECT IdLinea, IdFichero, Source, G.IdGeography, Email, TitleFirstNameSurname, CompanyName, Address, PostalCode, TelephoneNo
		,COOPSL.[IdStatusLead],CQRSL.[IdStatusLead]
		,COOPSC.[IdStatusCity],CQRSC.[IdStatusCity]
	FROM [input].[T_CNQ_Ficheros] F
	INNER JOIN [process].[T_CNQ_Geography] G ON F.Continent = G.Continent AND F.Country = G.Country AND F.City = G.City
	INNER JOIN [process].[T_CNQ_StatusLead] COOPSL ON F.COOPStatusLead = COOPSL.StatusLead AND COOPSL.IdNetwork = 2
	INNER JOIN [process].[T_CNQ_StatusLead] CQRSL ON F.CQRStatusLead = CQRSL.StatusLead AND CQRSL.IdNetwork = 1
	LEFT OUTER JOIN [process].[T_CNQ_StatusCity] COOPSC ON F.COOPStatusCity = COOPSC.StatusCity AND COOPSC.IdNetwork = 2
	LEFT OUTER JOIN [process].[T_CNQ_StatusCity] CQRSC ON F.CQRStatusCity = CQRSC.StatusCity AND CQRSC.IdNetwork = 1

	INSERT INTO [process].[T_CNQ_FicherosProcesados]
	(IdLinea, IdFichero, Source, IdGeography, Email, FirstName, CompanyName, Address, PostalCode,
		TelephoneNo, COOPIdStatusLead, CQRIdStatusLead, COOPIdStatusCity, CQRIdStatusCity)
	SELECT IdLinea, IdFichero, Source, G.IdGeography, Email, TitleFirstNameSurname, CompanyName, Address, PostalCode, TelephoneNo
		,COOPSL.[IdStatusLead],CQRSL.[IdStatusLead]
		,COOPSC.[IdStatusCity],CQRSC.[IdStatusCity]
	FROM [input].[T_CNQ_Ficheros] F
	INNER JOIN [process].[T_CNQ_Geography] G ON F.Continent = G.Continent AND F.Country = G.Country AND F.City = G.City
	INNER JOIN [process].[T_CNQ_StatusLead] COOPSL ON F.COOPStatusLead LIKE '%'+COOPSL.StatusLead+'%' AND COOPSL.IdNetwork = 2
	INNER JOIN [process].[T_CNQ_StatusLead] CQRSL ON F.CQRStatusLead LIKE '%'+CQRSL.StatusLead+'%' AND CQRSL.IdNetwork = 1
	LEFT OUTER JOIN [process].[T_CNQ_StatusCity] COOPSC ON F.COOPStatusCity = COOPSC.StatusCity AND COOPSC.IdNetwork = 2
	LEFT OUTER JOIN [process].[T_CNQ_StatusCity] CQRSC ON F.CQRStatusCity = CQRSC.StatusCity AND CQRSC.IdNetwork = 1
	WHERE F.IdLinea * 1000 + F.IdFichero NOT IN (SELECT [SingleColumnUniqueKey] FROM [process].[T_CNQ_FicherosProcesados])

	UPDATE FP
	SET [COOPIdStatusLeadDetail] = SLD.[IdStatusLeadDetail]
	FROM [process].[T_CNQ_FicherosProcesados] FP
	INNER JOIN [input].[T_CNQ_Ficheros] F ON FP.IdLinea = F.IdLinea
	INNER JOIN [process].[T_CNQ_StatusLeadDetails] SLD ON FP.[COOPIdStatusLead] = SLD.[IdStatusLead]
	WHERE F.COOPStatusLead LIKE '%'+SLD.StatusLeadDetail+'%'

	UPDATE FP
	SET [CQRIdStatusLeadDetail] = SLD.[IdStatusLeadDetail]
	FROM [process].[T_CNQ_FicherosProcesados] FP
	INNER JOIN [input].[T_CNQ_Ficheros] F ON FP.IdLinea = F.IdLinea
	INNER JOIN [process].[T_CNQ_StatusLeadDetails] SLD ON FP.[CQRIdStatusLead] = SLD.[IdStatusLead]
	WHERE F.CQRStatusLead LIKE '%'+SLD.StatusLeadDetail+'%'
	
	UPDATE [process].[T_CNQ_FicherosProcesados]
	SET FirstName = NULL
	WHERE FirstName LIKE 'Agent%'

	UPDATE [process].[T_CNQ_FicherosProcesados]
	SET IdTitle = TS.IdTitle
		,FirstName = LTRIM(SUBSTRING(RTRIM([FirstName]),CHARINDEX(' ',[FirstName],1),LEN([FirstName])))
	FROM [process].[T_CNQ_TitleSynonym] TS
	WHERE FirstName IS NOT NULL
		AND [TitleSynonym] = RTRIM(SUBSTRING(LTRIM([FirstName]),1,CHARINDEX(' ',[FirstName],1)))

	-- Asociaciones
	INSERT INTO [process].[T_CNQ_FicherosProcesados]
	(IdLinea, IdFichero, Source, IdGeography, Email, IdTitle, FirstName, Surname, CompanyName,
		Address, PostalCode, TelephoneNo, MobileNo, Fax, Website,
		COOPIdStatusLead, CQRIdStatusLead, COOPIdStatusCity, CQRIdStatusCity)
	SELECT IdLinea, IdFichero, Source, G.IdGeography, Email, TS.IdTitle, FirstName, Surname, CompanyName,
		Address, PostalCode, TelephoneNo, MobileNo, Fax, Website,
		COOPSL.[IdStatusLead],CQRSL.[IdStatusLead],
		COOPSC.[IdStatusCity],CQRSC.[IdStatusCity]
	FROM [input].[T_CNQ_FicherosAsociaciones] A
	INNER JOIN [process].[T_CNQ_Geography] G ON A.Continent = G.Continent AND A.Country = G.Country AND A.City = G.City
	LEFT OUTER JOIN [process].[T_CNQ_TitleSynonym] TS ON A.Title = TS.TitleSynonym
	INNER JOIN [process].[T_CNQ_StatusLead] COOPSL ON A.COOPStatusLead = COOPSL.StatusLead AND COOPSL.IdNetwork = 2
	INNER JOIN [process].[T_CNQ_StatusLead] CQRSL ON A.CQRStatusLead = CQRSL.StatusLead AND CQRSL.IdNetwork = 1
	LEFT OUTER JOIN [process].[T_CNQ_StatusCity] COOPSC ON A.COOPStatusCity = COOPSC.StatusCity AND COOPSC.IdNetwork = 2
	LEFT OUTER JOIN [process].[T_CNQ_StatusCity] CQRSC ON A.CQRStatusCity = CQRSC.StatusCity AND CQRSC.IdNetwork = 1
	
	INSERT INTO [process].[T_CNQ_FicherosProcesados]
	(IdLinea, IdFichero, Source, IdGeography, Email, IdTitle, FirstName, Surname, CompanyName,
		Address, PostalCode, TelephoneNo, MobileNo, Fax, Website,
		COOPIdStatusLead, CQRIdStatusLead, COOPIdStatusCity, CQRIdStatusCity)
	SELECT IdLinea, IdFichero, Source, G.IdGeography, Email, TS.IdTitle, FirstName, Surname, CompanyName,
		Address, PostalCode, TelephoneNo, MobileNo, Fax, Website,
		COOPSL.[IdStatusLead],CQRSL.[IdStatusLead],
		COOPSC.[IdStatusCity],CQRSC.[IdStatusCity]
	FROM [input].[T_CNQ_FicherosAsociaciones] A
	INNER JOIN [process].[T_CNQ_Geography] G ON A.Continent = G.Continent AND A.Country = G.Country AND A.City = G.City
	LEFT OUTER JOIN [process].[T_CNQ_TitleSynonym] TS ON A.Title = TS.TitleSynonym
	INNER JOIN [process].[T_CNQ_StatusLead] COOPSL ON A.COOPStatusLead LIKE '%'+COOPSL.StatusLead+'%' AND COOPSL.IdNetwork = 2
	INNER JOIN [process].[T_CNQ_StatusLead] CQRSL ON A.CQRStatusLead LIKE '%'+CQRSL.StatusLead+'%' AND CQRSL.IdNetwork = 1
	LEFT OUTER JOIN [process].[T_CNQ_StatusCity] COOPSC ON A.COOPStatusCity = COOPSC.StatusCity AND COOPSC.IdNetwork = 2
	LEFT OUTER JOIN [process].[T_CNQ_StatusCity] CQRSC ON A.CQRStatusCity = CQRSC.StatusCity AND CQRSC.IdNetwork = 1
	WHERE A.IdLinea * 1000 + A.IdFichero NOT IN (SELECT [SingleColumnUniqueKey] FROM [process].[T_CNQ_FicherosProcesados])

	INSERT INTO [process].[T_CNQ_FicherosProcesados]
	(IdLinea, IdFichero, Source, IdGeography, Email, IdTitle, FirstName, Surname, CompanyName,
		Address, PostalCode, TelephoneNo, MobileNo, Fax, Website, COOPIdStatusCity, CQRIdStatusCity)
	SELECT IdLinea, IdFichero, Source, G.IdGeography, Email, TS.IdTitle, FirstName, Surname, CompanyName,
		Address, PostalCode, TelephoneNo, MobileNo, Fax, Website,
		COOPSC.[IdStatusCity],CQRSC.[IdStatusCity]
	FROM [input].[T_CNQ_FicherosAsociaciones] A
	INNER JOIN [process].[T_CNQ_Geography] G ON A.Continent = G.Continent AND A.Country = G.Country AND A.City = G.City
	LEFT OUTER JOIN [process].[T_CNQ_TitleSynonym] TS ON A.Title = TS.TitleSynonym
	LEFT OUTER JOIN [process].[T_CNQ_StatusCity] COOPSC ON A.COOPStatusCity = COOPSC.StatusCity AND COOPSC.IdNetwork = 2
	LEFT OUTER JOIN [process].[T_CNQ_StatusCity] CQRSC ON A.CQRStatusCity = CQRSC.StatusCity AND CQRSC.IdNetwork = 1
	WHERE A.IdLinea * 1000 + A.IdFichero NOT IN (SELECT [SingleColumnUniqueKey] FROM [process].[T_CNQ_FicherosProcesados])

	-- Reconstrucción de índices
	ALTER INDEX ALL ON process.T_CNQ_FicherosProcesados REBUILD

	RETURN 0
END
