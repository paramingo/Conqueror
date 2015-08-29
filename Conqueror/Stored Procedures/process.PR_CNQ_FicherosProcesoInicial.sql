CREATE PROCEDURE [process].[PR_CNQ_FicherosProcesoInicial]
AS
BEGIN
	TRUNCATE TABLE [process].[T_CNQ_FicherosProcesados]

	INSERT INTO [process].[T_CNQ_FicherosProcesados]
	(IdLinea, Source, Continent, Country, City, Email, FirstNameSurname, CompanyName, Address, PostalCode,
		TelephoneNo, COOPIdStatusLead, CQRIdStatusLead, COOPIdStatusCity, CQRIdStatusCity)
	SELECT IdLinea, Source, Continent, Country, City, Email, TitleFirstNameSurname, CompanyName,
		Address, PostalCode, TelephoneNo
		,COOPSL.[IdStatusLead],CQRSL.[IdStatusLead]
		,COOPSC.[IdStatusCity],CQRSC.[IdStatusCity]
	FROM [input].[T_CNQ_Ficheros] F
	INNER JOIN [process].[T_CNQ_StatusLead] COOPSL ON F.COOPStatusLead = COOPSL.StatusLead AND COOPSL.IdNetwork = 2
	INNER JOIN [process].[T_CNQ_StatusLead] CQRSL ON F.CQRStatusLead = CQRSL.StatusLead AND CQRSL.IdNetwork = 1
	LEFT OUTER JOIN [process].[T_CNQ_StatusCity] COOPSC ON F.COOPStatusCity = COOPSC.StatusCity AND COOPSC.IdNetwork = 2
	LEFT OUTER JOIN [process].[T_CNQ_StatusCity] CQRSC ON F.CQRStatusCity = CQRSC.StatusCity AND CQRSC.IdNetwork = 1

	INSERT INTO [process].[T_CNQ_FicherosProcesados]
	(IdLinea, Source, Continent, Country, City, Email, FirstNameSurname, CompanyName, Address, PostalCode,
		TelephoneNo, COOPIdStatusLead, CQRIdStatusLead, COOPIdStatusCity, CQRIdStatusCity)
	SELECT F.IdLinea, Source, Continent, Country, City, Email, TitleFirstNameSurname, CompanyName,
		Address, PostalCode, TelephoneNo
		,COOPSL.[IdStatusLead],CQRSL.[IdStatusLead]
		,COOPSC.[IdStatusCity],CQRSC.[IdStatusCity]
	FROM [input].[T_CNQ_Ficheros] F
	INNER JOIN [process].[T_CNQ_StatusLead] COOPSL ON F.COOPStatusLead LIKE '%'+COOPSL.StatusLead+'%' AND COOPSL.IdNetwork = 2
	INNER JOIN [process].[T_CNQ_StatusLead] CQRSL ON F.CQRStatusLead LIKE '%'+CQRSL.StatusLead+'%' AND CQRSL.IdNetwork = 1
	LEFT OUTER JOIN [process].[T_CNQ_StatusCity] COOPSC ON F.COOPStatusCity = COOPSC.StatusCity AND COOPSC.IdNetwork = 2
	LEFT OUTER JOIN [process].[T_CNQ_StatusCity] CQRSC ON F.CQRStatusCity = CQRSC.StatusCity AND CQRSC.IdNetwork = 1
	WHERE F.IdLinea NOT IN (SELECT IdLinea FROM [process].[T_CNQ_FicherosProcesados])

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
	SET IdTitle = TS.IdTitle
		,FirstNameSurname = LTRIM(SUBSTRING(RTRIM([FirstNameSurname]),CHARINDEX(' ',[FirstNameSurname],1),LEN([FirstNameSurname])))
	FROM [process].[T_CNQ_TitleSynonym] TS
	WHERE FirstNameSurname NOT LIKE 'Agent%'
		AND [TitleSynonym] = RTRIM(SUBSTRING(LTRIM([FirstNameSurname]),1,CHARINDEX(' ',[FirstNameSurname],1)))

	RETURN 0
END
