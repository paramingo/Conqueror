CREATE PROCEDURE [process].[PR_CNQ_FicherosCRMProcesoInicial]
AS
BEGIN
	SET XACT_ABORT ON

	BEGIN TRAN

	TRUNCATE TABLE [process].[T_CNQ_FicherosCRMProcesados]

	UPDATE [input].[T_CNQ_FicherosCRM]
	SET Continent = CASE Continent WHEN 'Asia FE' THEN 'Asia (FE)'
								WHEN 'FE' THEN 'Asia (FE)'
								WHEN 'Asia ME' THEN 'Asia (ME)'
								WHEN 'ME' THEN 'Asia (ME)'
								WHEN 'Ukraine' THEN 'Europe'
								WHEN '' THEN NULL END
	WHERE Continent IN ('Asia FE','Asia ME','FE','ME','Ukraine','')

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
	(IdFichero, IdCRM, CompanyName, IdGeography, FirstName, Email, TelephoneNo, COOPIdStatusLead, CQRIdStatusLead)
	SELECT F.IdFichero, IdCRM, CompanyName, G.IdGeography, FirstName, Email, TelephoneNo
		,COOPSL.[IdStatusLead],CQRSL.[IdStatusLead]
	FROM [input].[T_CNQ_FicherosCRM] F
	INNER JOIN [input].[T_CNQ_FicherosRegistro] FR ON F.IdFichero = FR.IdFichero
	INNER JOIN [process].[T_CNQ_Geography] G ON ISNULL(F.Continent,'NULL') = ISNULL(G.Continent,'NULL')
											AND ISNULL(F.Country,'NULL') = ISNULL(G.Country,'NULL')
											AND ISNULL(F.City,'NULL') = ISNULL(G.City,'NULL')
	LEFT OUTER JOIN [process].[T_CNQ_StatusLead] COOPSL ON F.StatusLead = COOPSL.StatusLead AND COOPSL.IdNetwork = 2 AND FR.DsFichero LIKE '%COOP%'
	LEFT OUTER JOIN [process].[T_CNQ_StatusLead] CQRSL ON F.StatusLead = CQRSL.StatusLead AND CQRSL.IdNetwork = 1 AND FR.DsFichero LIKE '%CQR%'

	UPDATE [process].[T_CNQ_FicherosProcesados]
	SET FirstName = NULL
	WHERE FirstName IN ('Agent','Agente')

	COMMIT TRAN

	RETURN 0
END
