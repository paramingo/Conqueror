CREATE PROCEDURE [process].[PR_CNQ_FicherosProcesoInicial]
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
			UNION
			SELECT DISTINCT [Continent]
				,[Country]
				,[City]
			FROM [input].[T_CNQ_FicherosDirectorios]
			) AS SOURCE
	ON ISNULL(TARGET.[Continent],'NULL') = ISNULL(SOURCE.[Continent],'NULL')
		AND ISNULL(TARGET.[Country],'NULL') = ISNULL(SOURCE.[Country],'NULL')
		AND ISNULL(TARGET.[City],'NULL') = ISNULL(SOURCE.[City],'NULL')
	WHEN NOT MATCHED BY TARGET THEN
		INSERT ([Continent], [Country], [City])
		VALUES ([Continent], [Country], [City])
	WHEN NOT MATCHED BY SOURCE THEN
		DELETE
	;

	-- BBDD General
	PRINT 'BBDD General'
	INSERT INTO [process].[T_CNQ_FicherosProcesados]
	(IdLinea, IdFichero, Source, IdGeography, Email, FirstName, CompanyName, Address, PostalCode,
		TelephoneNo, COOPIdStatusLead, CQRIdStatusLead, COOPIdStatusCity, CQRIdStatusCity)
	SELECT IdLinea, IdFichero, Source, G.IdGeography, Email, TitleFirstNameSurname, CompanyName, Address, PostalCode, TelephoneNo
		,COOPSL.[IdStatusLead],CQRSL.[IdStatusLead]
		,COOPSC.[IdStatusCity],CQRSC.[IdStatusCity]
	FROM [input].[T_CNQ_Ficheros] F
	INNER JOIN [process].[T_CNQ_Geography] G ON ISNULL(F.Continent,'NULL') = ISNULL(G.Continent,'NULL')
											AND ISNULL(F.Country,'NULL') = ISNULL(G.Country,'NULL')
											AND ISNULL(F.City,'NULL') = ISNULL(G.City,'NULL')
	INNER JOIN [process].[T_CNQ_StatusLead] COOPSL ON F.COOPStatusLead = COOPSL.StatusLead AND COOPSL.IdNetwork = 2
	INNER JOIN [process].[T_CNQ_StatusLead] CQRSL ON F.CQRStatusLead = CQRSL.StatusLead AND CQRSL.IdNetwork = 1
	LEFT OUTER JOIN [process].[T_CNQ_StatusCity] COOPSC ON F.COOPStatusCity = COOPSC.StatusCity AND COOPSC.IdNetwork = 2
	LEFT OUTER JOIN [process].[T_CNQ_StatusCity] CQRSC ON F.CQRStatusCity = CQRSC.StatusCity AND CQRSC.IdNetwork = 1

	INSERT INTO [process].[T_CNQ_FicherosProcesados]
	(IdLinea, IdFichero, Source, IdGeography, Email, FirstName, CompanyName, Address, PostalCode,
		TelephoneNo, COOPIdStatusLead, CQRIdStatusLead, COOPIdStatusCity, CQRIdStatusCity)
	SELECT F.IdLinea, F.IdFichero, F.Source, G.IdGeography, F.Email, TitleFirstNameSurname, F.CompanyName, F.Address, F.PostalCode, F.TelephoneNo
		,COOPSL.[IdStatusLead],CQRSL.[IdStatusLead]
		,COOPSC.[IdStatusCity],CQRSC.[IdStatusCity]
	FROM [input].[T_CNQ_Ficheros] F
	INNER JOIN [process].[T_CNQ_Geography] G ON ISNULL(F.Continent,'NULL') = ISNULL(G.Continent,'NULL')
											AND ISNULL(F.Country,'NULL') = ISNULL(G.Country,'NULL')
											AND ISNULL(F.City,'NULL') = ISNULL(G.City,'NULL')
	INNER JOIN [process].[T_CNQ_StatusLead] COOPSL ON F.COOPStatusLead LIKE '%'+COOPSL.StatusLead+'%' AND COOPSL.IdNetwork = 2
	INNER JOIN [process].[T_CNQ_StatusLead] CQRSL ON F.CQRStatusLead LIKE '%'+CQRSL.StatusLead+'%' AND CQRSL.IdNetwork = 1
	LEFT OUTER JOIN [process].[T_CNQ_StatusCity] COOPSC ON F.COOPStatusCity = COOPSC.StatusCity AND COOPSC.IdNetwork = 2
	LEFT OUTER JOIN [process].[T_CNQ_StatusCity] CQRSC ON F.CQRStatusCity = CQRSC.StatusCity AND CQRSC.IdNetwork = 1
	LEFT OUTER JOIN [process].[T_CNQ_FicherosProcesados] FP ON F.IdLinea = FP.IdLinea AND F.IdFichero = FP.IdFichero
	WHERE FP.IdLinea IS NULL AND FP.IdFichero IS NULL

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

	-- Asociaciones
	PRINT 'Asociaciones'
	INSERT INTO [process].[T_CNQ_FicherosProcesados]
	(IdLinea, IdFichero, Source, IdGeography, Email, IdTitle, FirstName, Surname, CompanyName,
		Address, PostalCode, TelephoneNo, MobileNo, Fax, Website,
		COOPIdStatusLead, CQRIdStatusLead, COOPIdStatusCity, CQRIdStatusCity)
	SELECT IdLinea, IdFichero, Source, G.IdGeography, Email, TS.IdTitle, FirstName, Surname, CompanyName,
		Address, PostalCode, TelephoneNo, MobileNo, Fax, Website,
		COOPSL.[IdStatusLead],CQRSL.[IdStatusLead],
		COOPSC.[IdStatusCity],CQRSC.[IdStatusCity]
	FROM [input].[T_CNQ_FicherosAsociaciones] A
	INNER JOIN [process].[T_CNQ_Geography] G ON ISNULL(A.Continent,'NULL') = ISNULL(G.Continent,'NULL')
											AND ISNULL(A.Country,'NULL') = ISNULL(G.Country,'NULL')
											AND ISNULL(A.City,'NULL') = ISNULL(G.City,'NULL')
	LEFT OUTER JOIN [process].[T_CNQ_TitleSynonym] TS ON A.Title = TS.TitleSynonym
	INNER JOIN [process].[T_CNQ_StatusLead] COOPSL ON A.COOPStatusLead = COOPSL.StatusLead AND COOPSL.IdNetwork = 2
	INNER JOIN [process].[T_CNQ_StatusLead] CQRSL ON A.CQRStatusLead = CQRSL.StatusLead AND CQRSL.IdNetwork = 1
	LEFT OUTER JOIN [process].[T_CNQ_StatusCity] COOPSC ON A.COOPStatusCity = COOPSC.StatusCity AND COOPSC.IdNetwork = 2
	LEFT OUTER JOIN [process].[T_CNQ_StatusCity] CQRSC ON A.CQRStatusCity = CQRSC.StatusCity AND CQRSC.IdNetwork = 1
	
	INSERT INTO [process].[T_CNQ_FicherosProcesados]
	(IdLinea, IdFichero, Source, IdGeography, Email, IdTitle, FirstName, Surname, CompanyName,
		Address, PostalCode, TelephoneNo, MobileNo, Fax, Website,
		COOPIdStatusLead, CQRIdStatusLead, COOPIdStatusCity, CQRIdStatusCity)
	SELECT A.IdLinea, A.IdFichero, A.Source, G.IdGeography, A.Email, TS.IdTitle, A.FirstName, A.Surname, A.CompanyName,
		A.Address, A.PostalCode, A.TelephoneNo, A.MobileNo, A.Fax, A.Website,
		COOPSL.[IdStatusLead],CQRSL.[IdStatusLead],
		COOPSC.[IdStatusCity],CQRSC.[IdStatusCity]
	FROM [input].[T_CNQ_FicherosAsociaciones] A
	INNER JOIN [process].[T_CNQ_Geography] G ON ISNULL(A.Continent,'NULL') = ISNULL(G.Continent,'NULL')
											AND ISNULL(A.Country,'NULL') = ISNULL(G.Country,'NULL')
											AND ISNULL(A.City,'NULL') = ISNULL(G.City,'NULL')
	LEFT OUTER JOIN [process].[T_CNQ_TitleSynonym] TS ON A.Title = TS.TitleSynonym
	INNER JOIN [process].[T_CNQ_StatusLead] COOPSL ON A.COOPStatusLead LIKE '%'+COOPSL.StatusLead+'%' AND COOPSL.IdNetwork = 2
	INNER JOIN [process].[T_CNQ_StatusLead] CQRSL ON A.CQRStatusLead LIKE '%'+CQRSL.StatusLead+'%' AND CQRSL.IdNetwork = 1
	LEFT OUTER JOIN [process].[T_CNQ_StatusCity] COOPSC ON A.COOPStatusCity = COOPSC.StatusCity AND COOPSC.IdNetwork = 2
	LEFT OUTER JOIN [process].[T_CNQ_StatusCity] CQRSC ON A.CQRStatusCity = CQRSC.StatusCity AND CQRSC.IdNetwork = 1
	LEFT OUTER JOIN [process].[T_CNQ_FicherosProcesados] FP ON A.IdLinea = FP.IdLinea AND A.IdFichero = FP.IdFichero
	WHERE FP.IdLinea IS NULL AND FP.IdFichero IS NULL

	INSERT INTO [process].[T_CNQ_FicherosProcesados]
	(IdLinea, IdFichero, Source, IdGeography, Email, IdTitle, FirstName, Surname, CompanyName,
		Address, PostalCode, TelephoneNo, MobileNo, Fax, Website, COOPIdStatusCity, CQRIdStatusCity)
	SELECT A.IdLinea, A.IdFichero, A.Source, G.IdGeography, A.Email, TS.IdTitle, A.FirstName, A.Surname, A.CompanyName,
		A.Address, A.PostalCode, A.TelephoneNo, A.MobileNo, A.Fax, A.Website,
		COOPSC.[IdStatusCity],CQRSC.[IdStatusCity]
	FROM [input].[T_CNQ_FicherosAsociaciones] A
	INNER JOIN [process].[T_CNQ_Geography] G ON ISNULL(A.Continent,'NULL') = ISNULL(G.Continent,'NULL')
											AND ISNULL(A.Country,'NULL') = ISNULL(G.Country,'NULL')
											AND ISNULL(A.City,'NULL') = ISNULL(G.City,'NULL')
	LEFT OUTER JOIN [process].[T_CNQ_TitleSynonym] TS ON A.Title = TS.TitleSynonym
	LEFT OUTER JOIN [process].[T_CNQ_StatusCity] COOPSC ON A.COOPStatusCity = COOPSC.StatusCity AND COOPSC.IdNetwork = 2
	LEFT OUTER JOIN [process].[T_CNQ_StatusCity] CQRSC ON A.CQRStatusCity = CQRSC.StatusCity AND CQRSC.IdNetwork = 1
	LEFT OUTER JOIN [process].[T_CNQ_FicherosProcesados] FP ON A.IdLinea = FP.IdLinea AND A.IdFichero = FP.IdFichero
	WHERE FP.IdLinea IS NULL AND FP.IdFichero IS NULL

	UPDATE FP
	SET [COOPIdStatusLeadDetail] = SLD.[IdStatusLeadDetail]
	FROM [process].[T_CNQ_FicherosProcesados] FP
	INNER JOIN [input].[T_CNQ_FicherosAsociaciones] A ON FP.IdLinea = A.IdLinea
	INNER JOIN [process].[T_CNQ_StatusLeadDetails] SLD ON FP.[COOPIdStatusLead] = SLD.[IdStatusLead]
	WHERE A.COOPStatusLead LIKE '%'+SLD.StatusLeadDetail+'%'

	UPDATE FP
	SET [CQRIdStatusLeadDetail] = SLD.[IdStatusLeadDetail]
	FROM [process].[T_CNQ_FicherosProcesados] FP
	INNER JOIN [input].[T_CNQ_FicherosAsociaciones] A ON FP.IdLinea = A.IdLinea
	INNER JOIN [process].[T_CNQ_StatusLeadDetails] SLD ON FP.[CQRIdStatusLead] = SLD.[IdStatusLead]
	WHERE A.CQRStatusLead LIKE '%'+SLD.StatusLeadDetail+'%'

	-- Directorios
	PRINT 'Directorios'
	INSERT INTO [process].[T_CNQ_FicherosProcesados]
	(IdLinea, IdFichero, Source, IdGeography, Email, IdTitle, FirstName, Surname, CompanyName,
		Address, PostalCode, TelephoneNo, MobileNo, Fax, Website,
		COOPIdStatusLead, CQRIdStatusLead, COOPIdStatusCity, CQRIdStatusCity)
	SELECT IdLinea, IdFichero, Source, G.IdGeography, Email, TS.IdTitle, FirstName, Surname, CompanyName,
		Address, PostalCode, TelephoneNo, MobileNo, Fax, Website,
		COOPSL.[IdStatusLead],CQRSL.[IdStatusLead],
		COOPSC.[IdStatusCity],CQRSC.[IdStatusCity]
	FROM [input].[T_CNQ_FicherosDirectorios] D
	INNER JOIN [process].[T_CNQ_Geography] G ON ISNULL(D.Continent,'NULL') = ISNULL(G.Continent,'NULL')
											AND ISNULL(D.Country,'NULL') = ISNULL(G.Country,'NULL')
											AND ISNULL(D.City,'NULL') = ISNULL(G.City,'NULL')
	LEFT OUTER JOIN [process].[T_CNQ_TitleSynonym] TS ON D.Title = TS.TitleSynonym
	INNER JOIN [process].[T_CNQ_StatusLead] COOPSL ON D.COOPStatusLead = COOPSL.StatusLead AND COOPSL.IdNetwork = 2
	INNER JOIN [process].[T_CNQ_StatusLead] CQRSL ON D.CQRStatusLead = CQRSL.StatusLead AND CQRSL.IdNetwork = 1
	LEFT OUTER JOIN [process].[T_CNQ_StatusCity] COOPSC ON D.COOPStatusCity = COOPSC.StatusCity AND COOPSC.IdNetwork = 2
	LEFT OUTER JOIN [process].[T_CNQ_StatusCity] CQRSC ON D.CQRStatusCity = CQRSC.StatusCity AND CQRSC.IdNetwork = 1
	
	INSERT INTO [process].[T_CNQ_FicherosProcesados]
	(IdLinea, IdFichero, Source, IdGeography, Email, IdTitle, FirstName, Surname, CompanyName,
		Address, PostalCode, TelephoneNo, MobileNo, Fax, Website,
		COOPIdStatusLead, CQRIdStatusLead, COOPIdStatusCity, CQRIdStatusCity)
	SELECT D.IdLinea, D.IdFichero, D.Source, G.IdGeography, D.Email, TS.IdTitle, D.FirstName, D.Surname, D.CompanyName,
		D.Address, D.PostalCode, D.TelephoneNo, D.MobileNo, D.Fax, D.Website,
		COOPSL.[IdStatusLead],CQRSL.[IdStatusLead],
		COOPSC.[IdStatusCity],CQRSC.[IdStatusCity]
	FROM [input].[T_CNQ_FicherosDirectorios] D
	INNER JOIN [process].[T_CNQ_Geography] G ON ISNULL(D.Continent,'NULL') = ISNULL(G.Continent,'NULL')
											AND ISNULL(D.Country,'NULL') = ISNULL(G.Country,'NULL')
											AND ISNULL(D.City,'NULL') = ISNULL(G.City,'NULL')
	LEFT OUTER JOIN [process].[T_CNQ_TitleSynonym] TS ON D.Title = TS.TitleSynonym
	INNER JOIN [process].[T_CNQ_StatusLead] COOPSL ON D.COOPStatusLead LIKE '%'+COOPSL.StatusLead+'%' AND COOPSL.IdNetwork = 2
	INNER JOIN [process].[T_CNQ_StatusLead] CQRSL ON D.CQRStatusLead LIKE '%'+CQRSL.StatusLead+'%' AND CQRSL.IdNetwork = 1
	LEFT OUTER JOIN [process].[T_CNQ_StatusCity] COOPSC ON D.COOPStatusCity = COOPSC.StatusCity AND COOPSC.IdNetwork = 2
	LEFT OUTER JOIN [process].[T_CNQ_StatusCity] CQRSC ON D.CQRStatusCity = CQRSC.StatusCity AND CQRSC.IdNetwork = 1
	LEFT OUTER JOIN [process].[T_CNQ_FicherosProcesados] FP ON D.IdLinea = FP.IdLinea AND D.IdFichero = FP.IdFichero
	WHERE FP.IdLinea IS NULL AND FP.IdFichero IS NULL

	INSERT INTO [process].[T_CNQ_FicherosProcesados]
	(IdLinea, IdFichero, Source, IdGeography, Email, IdTitle, FirstName, Surname, CompanyName,
		Address, PostalCode, TelephoneNo, MobileNo, Fax, Website, COOPIdStatusCity, CQRIdStatusCity)
	SELECT D.IdLinea, D.IdFichero, D.Source, G.IdGeography, D.Email, TS.IdTitle, D.FirstName, D.Surname, D.CompanyName,
		D.Address, D.PostalCode, D.TelephoneNo, D.MobileNo, D.Fax, D.Website,
		COOPSC.[IdStatusCity],CQRSC.[IdStatusCity]
	FROM [input].[T_CNQ_FicherosDirectorios] D
	INNER JOIN [process].[T_CNQ_Geography] G ON ISNULL(D.Continent,'NULL') = ISNULL(G.Continent,'NULL')
											AND ISNULL(D.Country,'NULL') = ISNULL(G.Country,'NULL')
											AND ISNULL(D.City,'NULL') = ISNULL(G.City,'NULL')
	LEFT OUTER JOIN [process].[T_CNQ_TitleSynonym] TS ON D.Title = TS.TitleSynonym
	LEFT OUTER JOIN [process].[T_CNQ_StatusCity] COOPSC ON D.COOPStatusCity = COOPSC.StatusCity AND COOPSC.IdNetwork = 2
	LEFT OUTER JOIN [process].[T_CNQ_StatusCity] CQRSC ON D.CQRStatusCity = CQRSC.StatusCity AND CQRSC.IdNetwork = 1
	LEFT OUTER JOIN [process].[T_CNQ_FicherosProcesados] FP ON D.IdLinea = FP.IdLinea AND D.IdFichero = FP.IdFichero
	WHERE FP.IdLinea IS NULL AND FP.IdFichero IS NULL

	UPDATE FP
	SET [COOPIdStatusLeadDetail] = SLD.[IdStatusLeadDetail]
	FROM [process].[T_CNQ_FicherosProcesados] FP
	INNER JOIN [input].[T_CNQ_FicherosDirectorios] D ON FP.IdLinea = D.IdLinea
	INNER JOIN [process].[T_CNQ_StatusLeadDetails] SLD ON FP.[COOPIdStatusLead] = SLD.[IdStatusLead]
	WHERE D.COOPStatusLead LIKE '%'+SLD.StatusLeadDetail+'%'

	UPDATE FP
	SET [CQRIdStatusLeadDetail] = SLD.[IdStatusLeadDetail]
	FROM [process].[T_CNQ_FicherosProcesados] FP
	INNER JOIN [input].[T_CNQ_FicherosDirectorios] D ON FP.IdLinea = D.IdLinea
	INNER JOIN [process].[T_CNQ_StatusLeadDetails] SLD ON FP.[CQRIdStatusLead] = SLD.[IdStatusLead]
	WHERE D.CQRStatusLead LIKE '%'+SLD.StatusLeadDetail+'%'

	-- Común
	PRINT 'Común'
	UPDATE [process].[T_CNQ_FicherosProcesados]
	SET FirstName = NULL
	WHERE FirstName IN ('Agent','Agente')

	UPDATE [process].[T_CNQ_FicherosProcesados]
	SET IdTitle = TS.IdTitle
		,FirstName = LTRIM(SUBSTRING(RTRIM([FirstName]),CHARINDEX(' ',[FirstName],1),LEN([FirstName])))
	FROM [process].[T_CNQ_TitleSynonym] TS
	WHERE FirstName IS NOT NULL
		AND [TitleSynonym] = RTRIM(SUBSTRING(LTRIM([FirstName]),1,CHARINDEX(' ',[FirstName],1)))

	-- Reconstrucción de índices
	ALTER INDEX ALL ON process.T_CNQ_FicherosProcesados REBUILD

	RETURN 0
END
