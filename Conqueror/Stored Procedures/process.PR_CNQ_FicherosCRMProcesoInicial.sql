CREATE PROCEDURE [process].[PR_CNQ_FicherosCRMProcesoInicial]
AS
BEGIN
	SET XACT_ABORT ON

	BEGIN TRAN

	UPDATE [input].[T_CNQ_FicherosCRM] SET Email = NULL WHERE RTRIM(LTRIM(Email)) = ''
	UPDATE [input].[T_CNQ_FicherosCRM] SET Email = REPLACE(Email,'"','')

	TRUNCATE TABLE [process].[T_CNQ_FicherosCRMProcesados]

	UPDATE [input].[T_CNQ_FicherosCRM]
	SET Continent = CASE Continent WHEN 'Asia FE' THEN 'Asia (FE)'
								WHEN 'FE' THEN 'Asia (FE)'
								WHEN 'Asia ME' THEN 'Asia (ME)'
								WHEN 'ME' THEN 'Asia (ME)'
								WHEN 'Ukraine' THEN 'Europe'
								WHEN '' THEN NULL END
	WHERE Continent IN ('Asia FE','Asia ME','FE','ME','Ukraine','')
	UPDATE [input].[T_CNQ_FicherosCRM]
	SET Continent = 'Asia (ME)'
	WHERE Country = 'Palestina'
	UPDATE [input].[T_CNQ_FicherosCRM]
	SET Continent = 'Asia (FE)'
	WHERE Country = 'South Korea'
	UPDATE [input].[T_CNQ_FicherosCRM]
	SET Country = 'United States of America'
	WHERE Country LIKE '%United States%'
	UPDATE [input].[T_CNQ_FicherosCRM]
	SET Country = 'Russian Federation'
	WHERE Country LIKE '%Russia%'
	UPDATE [input].[T_CNQ_FicherosCRM]
	SET Country = 'Australia'
	WHERE Country LIKE '%Tasmania%'

	UPDATE CRM
	SET CRM.Continent = G.Continent
	FROM [input].[T_CNQ_FicherosCRM] CRM
	INNER JOIN (SELECT DISTINCT Continent, Country
				FROM [process].[T_CNQ_GeographyOriginal]) G ON CRM.Country = G.Country
	WHERE ISNULL(CRM.Continent,'<') <> ISNULL(G.Continent,'>')

	MERGE [process].[T_CNQ_Geography] AS TARGET
	USING (SELECT DISTINCT [Continent]
				,[Country]
				,[City]
			FROM [input].[T_CNQ_FicherosCRM]
			) AS SOURCE
	ON ISNULL(TARGET.[Continent],'NULL') = ISNULL(SOURCE.[Continent],'NULL')
		AND ISNULL(TARGET.[Country],'NULL') = ISNULL(SOURCE.[Country],'NULL')
		AND ISNULL(TARGET.[City],'NULL') = ISNULL(SOURCE.[City],'NULL')
	WHEN NOT MATCHED BY TARGET THEN
		INSERT ([Continent], [Country], [City])
		VALUES ([Continent], [Country], [City])
	--WHEN NOT MATCHED BY SOURCE THEN
	--	DELETE
	;

	INSERT INTO [process].[T_CNQ_FicherosCRMProcesados]
	(IdFichero, IdCRM, CompanyName, IdGeography, FirstName, Email, TelephoneNo, COOPIdStatusLead, CQRIdStatusLead, IdNetwork)
	SELECT F.IdFichero, IdCRM, CompanyName, G.IdGeography, FirstName, Email, TelephoneNo
		,COOPSL.[IdStatusLead],CQRSL.[IdStatusLead]
		,CASE WHEN CQRSL.IdStatusLead IS NOT NULL THEN 1 WHEN COOPSL.IdStatusLead IS NOT NULL THEN 2 END
	FROM [input].[T_CNQ_FicherosCRM] F
	INNER JOIN [input].[T_CNQ_FicherosRegistro] FR ON F.IdFichero = FR.IdFichero
	INNER JOIN [process].[T_CNQ_Geography] G ON ISNULL(F.Continent,'NULL') = ISNULL(G.Continent,'NULL')
											AND ISNULL(F.Country,'NULL') = ISNULL(G.Country,'NULL')
											AND ISNULL(F.City,'NULL') = ISNULL(G.City,'NULL')
	LEFT OUTER JOIN [process].[T_CNQ_StatusLead] COOPSL ON F.StatusLead = COOPSL.StatusLead AND COOPSL.IdNetwork = 2 AND FR.DsFichero LIKE '%COOP%'
	LEFT OUTER JOIN [process].[T_CNQ_StatusLead] CQRSL ON F.StatusLead = CQRSL.StatusLead AND CQRSL.IdNetwork = 1 AND FR.DsFichero LIKE '%CQR%'

	UPDATE [process].[T_CNQ_FicherosCRMProcesados]
	SET FirstName = NULL
	WHERE FirstName IN ('Agent','Agente')

	COMMIT TRAN

	RETURN 0
END
