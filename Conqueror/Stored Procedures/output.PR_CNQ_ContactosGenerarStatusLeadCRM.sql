CREATE PROCEDURE [output].[PR_CNQ_ContactosGenerarStatusLeadCRM]
AS
BEGIN

	SET XACT_ABORT ON

	BEGIN TRAN

	TRUNCATE TABLE output.T_CNQ_LogUpdateCRM

	UPDATE process.T_CNQ_FicherosProcesados
	SET CQRIdStatusLead = NULL
		,CQRIdStatusLeadDetail = NULL
		,COOPIdStatusLead = NULL
		,COOPIdStatusLeadDetail = NULL

	-- CQR

	-- Eliminar duplicados
	INSERT INTO output.T_CNQ_LogUpdateCRM
	SELECT IdCRM, NULL, NULL, -1, NULL, IdNetwork
	FROM (
		SELECT IdCRM, Email, IdGeography, FirstName, CompanyName, CQRIdStatusLead, IdNetwork
			,ROW_NUMBER() OVER(PARTITION BY Email, IdGeography, FirstName, CompanyName, CQRIdStatusLead
								ORDER BY Email, IdGeography, FirstName, CompanyName, CQRIdStatusLead) Orden
		FROM [process].[T_CNQ_FicherosCRMProcesados]
		WHERE IdNetwork = 1
	) A
	WHERE Orden > 1

	-- Coincidencias totales
	UPDATE C
	SET CQRIdStatusLead = CRM.CQRIdStatusLead
	OUTPUT CRM.IdCRM, DELETED.IdContacto, 1, NULL, 0, CRM.IdNetwork INTO output.T_CNQ_LogUpdateCRM
	FROM [process].[T_CNQ_FicherosCRMProcesados] CRM
	INNER JOIN [output].[T_CNQ_Contactos] C ON CRM.Email = C.Email
												AND CRM.IdGeography = C.IdGeography
												AND (CRM.FirstName = C.FirstName OR (CRM.FirstName IS NULL AND C.FirstName IS NULL))
												AND CRM.CompanyName = C.CompanyName
												AND C.IdContacto NOT IN (SELECT IdContacto FROM [output].[T_CNQ_LogUpdateCRM] WHERE IdContacto IS NOT NULL AND IdNetwork = 1)
	WHERE IdNetwork = 1
		AND CRM.IdCRM NOT IN (SELECT IdCRM FROM [output].[T_CNQ_LogUpdateCRM])

	-- Coincidencias totales con flexibilidad en Company Name
	UPDATE C
	SET CQRIdStatusLead = CRM.CQRIdStatusLead
	OUTPUT CRM.IdCRM, DELETED.IdContacto, 2, NULL, 0, CRM.IdNetwork INTO output.T_CNQ_LogUpdateCRM
	FROM [process].[T_CNQ_FicherosCRMProcesados] CRM
	INNER JOIN [output].[T_CNQ_Contactos] C ON CRM.Email = C.Email
												AND CRM.IdGeography = C.IdGeography
												AND (CRM.FirstName = C.FirstName OR (CRM.FirstName IS NULL AND C.FirstName IS NULL))
												AND [process].[FN_CNQ_LevenshteinMod](CRM.CompanyName, C.CompanyName) < 1.5
												AND C.IdContacto NOT IN (SELECT IdContacto FROM [output].[T_CNQ_LogUpdateCRM] WHERE IdContacto IS NOT NULL AND IdNetwork = 1)
	WHERE IdNetwork = 1
		AND CRM.IdCRM NOT IN (SELECT IdCRM FROM [output].[T_CNQ_LogUpdateCRM])

	UPDATE output.T_CNQ_LogUpdateCRM
	SET Similarity = [process].[FN_CNQ_LevenshteinMod]((SELECT CompanyName FROM [process].[T_CNQ_FicherosCRMProcesados] CRM WHERE CRM.IdCRM = output.T_CNQ_LogUpdateCRM.IdCRM),
												(SELECT CompanyName FROM [output].[T_CNQ_Contactos] C WHERE C.IdContacto = output.T_CNQ_LogUpdateCRM.IdContacto))
	WHERE Fase = 2

	-- Coincidencias totales con flexibilidad en FirstName
	UPDATE C
	SET CQRIdStatusLead = CRM.CQRIdStatusLead
	OUTPUT CRM.IdCRM, DELETED.IdContacto, 3, NULL, 0, CRM.IdNetwork INTO output.T_CNQ_LogUpdateCRM
	FROM [process].[T_CNQ_FicherosCRMProcesados] CRM
	INNER JOIN [output].[T_CNQ_Contactos] C ON CRM.Email = C.Email
												AND CRM.IdGeography = C.IdGeography
												AND ([process].[FN_CNQ_LevenshteinMod](CRM.FirstName, C.FirstName) < 0.45 OR (CRM.FirstName IS NULL AND C.FirstName IS NULL))
												AND CRM.CompanyName = C.CompanyName
												AND C.IdContacto NOT IN (SELECT IdContacto FROM [output].[T_CNQ_LogUpdateCRM] WHERE IdContacto IS NOT NULL AND IdNetwork = 1)
	WHERE IdNetwork = 1
		AND CRM.IdCRM NOT IN (SELECT IdCRM FROM [output].[T_CNQ_LogUpdateCRM])

	UPDATE output.T_CNQ_LogUpdateCRM
	SET Similarity = [process].[FN_CNQ_LevenshteinMod]((SELECT FirstName FROM [process].[T_CNQ_FicherosCRMProcesados] CRM WHERE CRM.IdCRM = output.T_CNQ_LogUpdateCRM.IdCRM),
												(SELECT FirstName FROM [output].[T_CNQ_Contactos] C WHERE C.IdContacto = output.T_CNQ_LogUpdateCRM.IdContacto))
	WHERE Fase = 3

	-- Coincidencias totales con flexibilidad en Company Name y First Name
	UPDATE C
	SET CQRIdStatusLead = CRM.CQRIdStatusLead
	OUTPUT CRM.IdCRM, DELETED.IdContacto, 4, NULL, 0, CRM.IdNetwork INTO output.T_CNQ_LogUpdateCRM
	FROM [process].[T_CNQ_FicherosCRMProcesados] CRM
	INNER JOIN [output].[T_CNQ_Contactos] C ON CRM.Email = C.Email
												AND CRM.IdGeography = C.IdGeography
												AND ([process].[FN_CNQ_LevenshteinMod](CRM.FirstName, C.FirstName) < 0.45 OR (CRM.FirstName IS NULL AND C.FirstName IS NULL))
												AND [process].[FN_CNQ_LevenshteinMod](CRM.CompanyName, C.CompanyName) < 1.5
												AND C.IdContacto NOT IN (SELECT IdContacto FROM [output].[T_CNQ_LogUpdateCRM] WHERE IdContacto IS NOT NULL AND IdNetwork = 1)
	WHERE IdNetwork = 1
		AND CRM.IdCRM NOT IN (SELECT IdCRM FROM [output].[T_CNQ_LogUpdateCRM])

	UPDATE output.T_CNQ_LogUpdateCRM
	SET Similarity = [process].[FN_CNQ_LevenshteinMod]((SELECT FirstName FROM [process].[T_CNQ_FicherosCRMProcesados] CRM WHERE CRM.IdCRM = output.T_CNQ_LogUpdateCRM.IdCRM),
												(SELECT FirstName FROM [output].[T_CNQ_Contactos] C WHERE C.IdContacto = output.T_CNQ_LogUpdateCRM.IdContacto))
	WHERE Fase = 4

	-- Coincidencias totales sin Email
	UPDATE C
	SET CQRIdStatusLead = CRM.CQRIdStatusLead
	OUTPUT CRM.IdCRM, DELETED.IdContacto, 5, NULL, 0, CRM.IdNetwork INTO output.T_CNQ_LogUpdateCRM
	FROM [process].[T_CNQ_FicherosCRMProcesados] CRM
	INNER JOIN [output].[T_CNQ_Contactos] C ON CRM.Email IS NULL
												AND CRM.IdGeography = C.IdGeography
												AND (CRM.FirstName = C.FirstName OR (CRM.FirstName IS NULL AND C.FirstName IS NULL))
												AND CRM.CompanyName = C.CompanyName
												AND C.IdContacto NOT IN (SELECT IdContacto FROM [output].[T_CNQ_LogUpdateCRM] WHERE IdContacto IS NOT NULL AND IdNetwork = 1)
	WHERE IdNetwork = 1
		AND CRM.IdCRM NOT IN (SELECT IdCRM FROM [output].[T_CNQ_LogUpdateCRM])

	-- Coincidencias totales con flexibilidad en Company Name sin Email (sin incluir Agentes)
	UPDATE C
	SET CQRIdStatusLead = CRM.CQRIdStatusLead
	OUTPUT CRM.IdCRM, DELETED.IdContacto, 6, NULL, 0, CRM.IdNetwork INTO output.T_CNQ_LogUpdateCRM
	FROM [process].[T_CNQ_FicherosCRMProcesados] CRM
	INNER JOIN [output].[T_CNQ_Contactos] C ON CRM.Email IS NULL
												AND CRM.IdGeography = C.IdGeography
												AND (CRM.FirstName = C.FirstName)--OR (CRM.FirstName IS NULL AND C.FirstName IS NULL))
												AND [process].[FN_CNQ_LevenshteinMod](CRM.CompanyName, C.CompanyName) < 1.5
												AND C.IdContacto NOT IN (SELECT IdContacto FROM [output].[T_CNQ_LogUpdateCRM] WHERE IdContacto IS NOT NULL AND IdNetwork = 1)
	WHERE IdNetwork = 1
		AND CRM.IdCRM NOT IN (SELECT IdCRM FROM [output].[T_CNQ_LogUpdateCRM])

	UPDATE output.T_CNQ_LogUpdateCRM
	SET Similarity = [process].[FN_CNQ_LevenshteinMod]((SELECT CompanyName FROM [process].[T_CNQ_FicherosCRMProcesados] CRM WHERE CRM.IdCRM = output.T_CNQ_LogUpdateCRM.IdCRM),
												(SELECT CompanyName FROM [output].[T_CNQ_Contactos] C WHERE C.IdContacto = output.T_CNQ_LogUpdateCRM.IdContacto))
	WHERE Fase = 6

	-- Coincidencias de City con flexibilidad en Company Name y First Name sin Email (sin incluir Agentes)
	UPDATE C
	SET CQRIdStatusLead = CRM.CQRIdStatusLead
	OUTPUT CRM.IdCRM, DELETED.IdContacto, 7, NULL, 0, CRM.IdNetwork INTO output.T_CNQ_LogUpdateCRM	
	FROM [process].[T_CNQ_FicherosCRMProcesados] CRM
	INNER JOIN [output].[T_CNQ_Contactos] C ON (CRM.Email = C.Email OR CRM.Email IS NULL)
												AND CRM.IdGeography <> C.IdGeography
												AND (SELECT City FROM process.T_CNQ_Geography WHERE IdGeography = CRM.IdGeography) = 
													(SELECT City FROM process.T_CNQ_Geography WHERE IdGeography = C.IdGeography)
												AND [process].[FN_CNQ_LevenshteinMod](CRM.FirstName, C.FirstName) < 0.3 -- OR (CRM.FirstName IS NULL AND C.FirstName IS NULL))
												AND [process].[FN_CNQ_LevenshteinMod](CRM.CompanyName, C.CompanyName) < 1.5
												AND C.IdContacto NOT IN (SELECT IdContacto FROM [output].[T_CNQ_LogUpdateCRM] WHERE IdContacto IS NOT NULL AND IdNetwork = 1)
	WHERE IdNetwork = 1
		AND CRM.IdCRM NOT IN (SELECT IdCRM FROM [output].[T_CNQ_LogUpdateCRM])

	-- Coincidencias geográficas con flexibilidad en Company Name y First Name sin Email (sin incluir Agentes)
	UPDATE C
	SET CQRIdStatusLead = CRM.CQRIdStatusLead
	OUTPUT CRM.IdCRM, DELETED.IdContacto, 8, NULL, 0, CRM.IdNetwork INTO output.T_CNQ_LogUpdateCRM	
	FROM [process].[T_CNQ_FicherosCRMProcesados] CRM
	INNER JOIN [output].[T_CNQ_Contactos] C ON CRM.Email IS NULL
												AND CRM.IdGeography = C.IdGeography
												AND ([process].[FN_CNQ_LevenshteinMod](CRM.FirstName, C.FirstName) < 0.26
													AND ISNULL(CRM.FirstName,'') <> '' AND ISNULL(C.FirstName,'') <> '')
												AND [process].[FN_CNQ_LevenshteinMod](CRM.CompanyName, C.CompanyName) < 0.62
												AND C.IdContacto NOT IN (SELECT IdContacto FROM [output].[T_CNQ_LogUpdateCRM] WHERE IdContacto IS NOT NULL AND IdNetwork = 1)
	WHERE IdNetwork = 1
		AND CRM.IdCRM NOT IN (SELECT IdCRM FROM [output].[T_CNQ_LogUpdateCRM])

	-- COOP

	-- Eliminar duplicados
	INSERT INTO output.T_CNQ_LogUpdateCRM
	SELECT IdCRM, NULL, NULL, -11, NULL, IdNetwork
	FROM (
		SELECT IdCRM, Email, IdGeography, FirstName, CompanyName, CQRIdStatusLead, IdNetwork
			,ROW_NUMBER() OVER(PARTITION BY Email, IdGeography, FirstName, CompanyName, CQRIdStatusLead
								ORDER BY Email, IdGeography, FirstName, CompanyName, CQRIdStatusLead) Orden
		FROM [process].[T_CNQ_FicherosCRMProcesados]
		WHERE IdNetwork = 2
	) A
	WHERE Orden > 1

	-- Coincidencias totales
	UPDATE C
	SET COOPIdStatusLead = CRM.COOPIdStatusLead
	OUTPUT CRM.IdCRM, DELETED.IdContacto, 11, NULL, 0, CRM.IdNetwork INTO output.T_CNQ_LogUpdateCRM
	FROM [process].[T_CNQ_FicherosCRMProcesados] CRM
	INNER JOIN [output].[T_CNQ_Contactos] C ON CRM.Email = C.Email
												AND CRM.IdGeography = C.IdGeography
												AND (CRM.FirstName = C.FirstName OR (CRM.FirstName IS NULL AND C.FirstName IS NULL))
												AND CRM.CompanyName = C.CompanyName
												AND C.IdContacto NOT IN (SELECT IdContacto FROM [output].[T_CNQ_LogUpdateCRM] WHERE IdContacto IS NOT NULL AND IdNetwork = 2)
	WHERE IdNetwork = 2
		AND CRM.IdCRM NOT IN (SELECT IdCRM FROM [output].[T_CNQ_LogUpdateCRM])

	-- Coincidencias totales con flexibilidad en Company Name
	UPDATE C
	SET COOPIdStatusLead = CRM.COOPIdStatusLead
	OUTPUT CRM.IdCRM, DELETED.IdContacto, 12, NULL, 0, CRM.IdNetwork INTO output.T_CNQ_LogUpdateCRM
	FROM [process].[T_CNQ_FicherosCRMProcesados] CRM
	INNER JOIN [output].[T_CNQ_Contactos] C ON CRM.Email = C.Email
												AND CRM.IdGeography = C.IdGeography
												AND (CRM.FirstName = C.FirstName OR (CRM.FirstName IS NULL AND C.FirstName IS NULL))
												AND [process].[FN_CNQ_LevenshteinMod](CRM.CompanyName, C.CompanyName) < 1.5
												AND C.IdContacto NOT IN (SELECT IdContacto FROM [output].[T_CNQ_LogUpdateCRM] WHERE IdContacto IS NOT NULL AND IdNetwork = 2)
	WHERE IdNetwork = 2
		AND CRM.IdCRM NOT IN (SELECT IdCRM FROM [output].[T_CNQ_LogUpdateCRM])

	UPDATE output.T_CNQ_LogUpdateCRM
	SET Similarity = [process].[FN_CNQ_LevenshteinMod]((SELECT CompanyName FROM [process].[T_CNQ_FicherosCRMProcesados] CRM WHERE CRM.IdCRM = output.T_CNQ_LogUpdateCRM.IdCRM),
												(SELECT CompanyName FROM [output].[T_CNQ_Contactos] C WHERE C.IdContacto = output.T_CNQ_LogUpdateCRM.IdContacto))
	WHERE Fase = 12

	-- Coincidencias totales con flexibilidad en FirstName
	UPDATE C
	SET COOPIdStatusLead = CRM.COOPIdStatusLead
	OUTPUT CRM.IdCRM, DELETED.IdContacto, 13, NULL, 0, CRM.IdNetwork INTO output.T_CNQ_LogUpdateCRM
	FROM [process].[T_CNQ_FicherosCRMProcesados] CRM
	INNER JOIN [output].[T_CNQ_Contactos] C ON CRM.Email = C.Email
												AND CRM.IdGeography = C.IdGeography
												AND ([process].[FN_CNQ_LevenshteinMod](CRM.FirstName, C.FirstName) < 0.45 OR (CRM.FirstName IS NULL AND C.FirstName IS NULL))
												AND CRM.CompanyName = C.CompanyName
												AND C.IdContacto NOT IN (SELECT IdContacto FROM [output].[T_CNQ_LogUpdateCRM] WHERE IdContacto IS NOT NULL AND IdNetwork = 2)
	WHERE IdNetwork = 2
		AND CRM.IdCRM NOT IN (SELECT IdCRM FROM [output].[T_CNQ_LogUpdateCRM])

	UPDATE output.T_CNQ_LogUpdateCRM
	SET Similarity = [process].[FN_CNQ_LevenshteinMod]((SELECT FirstName FROM [process].[T_CNQ_FicherosCRMProcesados] CRM WHERE CRM.IdCRM = output.T_CNQ_LogUpdateCRM.IdCRM),
												(SELECT FirstName FROM [output].[T_CNQ_Contactos] C WHERE C.IdContacto = output.T_CNQ_LogUpdateCRM.IdContacto))
	WHERE Fase = 13

	-- Coincidencias totales con flexibilidad en Company Name y First Name
	UPDATE C
	SET COOPIdStatusLead = CRM.COOPIdStatusLead
	OUTPUT CRM.IdCRM, DELETED.IdContacto, 14, NULL, 0, CRM.IdNetwork INTO output.T_CNQ_LogUpdateCRM
	FROM [process].[T_CNQ_FicherosCRMProcesados] CRM
	INNER JOIN [output].[T_CNQ_Contactos] C ON CRM.Email = C.Email
												AND CRM.IdGeography = C.IdGeography
												AND ([process].[FN_CNQ_LevenshteinMod](CRM.FirstName, C.FirstName) < 0.45 OR (CRM.FirstName IS NULL AND C.FirstName IS NULL))
												AND [process].[FN_CNQ_LevenshteinMod](CRM.CompanyName, C.CompanyName) < 1.5
												AND C.IdContacto NOT IN (SELECT IdContacto FROM [output].[T_CNQ_LogUpdateCRM] WHERE IdContacto IS NOT NULL AND IdNetwork = 2)
	WHERE IdNetwork = 2
		AND CRM.IdCRM NOT IN (SELECT IdCRM FROM [output].[T_CNQ_LogUpdateCRM])

	UPDATE output.T_CNQ_LogUpdateCRM
	SET Similarity = [process].[FN_CNQ_LevenshteinMod]((SELECT FirstName FROM [process].[T_CNQ_FicherosCRMProcesados] CRM WHERE CRM.IdCRM = output.T_CNQ_LogUpdateCRM.IdCRM),
												(SELECT FirstName FROM [output].[T_CNQ_Contactos] C WHERE C.IdContacto = output.T_CNQ_LogUpdateCRM.IdContacto))
	WHERE Fase = 14

	-- Coincidencias totales sin Email
	UPDATE C
	SET COOPIdStatusLead = CRM.COOPIdStatusLead
	OUTPUT CRM.IdCRM, DELETED.IdContacto, 15, NULL, 0, CRM.IdNetwork INTO output.T_CNQ_LogUpdateCRM
	FROM [process].[T_CNQ_FicherosCRMProcesados] CRM
	INNER JOIN [output].[T_CNQ_Contactos] C ON CRM.Email IS NULL
												AND CRM.IdGeography = C.IdGeography
												AND (CRM.FirstName = C.FirstName OR (CRM.FirstName IS NULL AND C.FirstName IS NULL))
												AND CRM.CompanyName = C.CompanyName
												AND C.IdContacto NOT IN (SELECT IdContacto FROM [output].[T_CNQ_LogUpdateCRM] WHERE IdContacto IS NOT NULL AND IdNetwork = 2)
	WHERE IdNetwork = 2
		AND CRM.IdCRM NOT IN (SELECT IdCRM FROM [output].[T_CNQ_LogUpdateCRM])

	-- Coincidencias totales con flexibilidad en Company Name sin Email (sin incluir Agentes)
	UPDATE C
	SET COOPIdStatusLead = CRM.COOPIdStatusLead
	OUTPUT CRM.IdCRM, DELETED.IdContacto, 16, NULL, 0, CRM.IdNetwork INTO output.T_CNQ_LogUpdateCRM
	FROM [process].[T_CNQ_FicherosCRMProcesados] CRM
	INNER JOIN [output].[T_CNQ_Contactos] C ON CRM.Email IS NULL
												AND CRM.IdGeography = C.IdGeography
												AND (CRM.FirstName = C.FirstName)--OR (CRM.FirstName IS NULL AND C.FirstName IS NULL))
												AND [process].[FN_CNQ_LevenshteinMod](CRM.CompanyName, C.CompanyName) < 1.5
												AND C.IdContacto NOT IN (SELECT IdContacto FROM [output].[T_CNQ_LogUpdateCRM] WHERE IdContacto IS NOT NULL AND IdNetwork = 2)
	WHERE IdNetwork = 2
		AND CRM.IdCRM NOT IN (SELECT IdCRM FROM [output].[T_CNQ_LogUpdateCRM])

	UPDATE output.T_CNQ_LogUpdateCRM
	SET Similarity = [process].[FN_CNQ_LevenshteinMod]((SELECT CompanyName FROM [process].[T_CNQ_FicherosCRMProcesados] CRM WHERE CRM.IdCRM = output.T_CNQ_LogUpdateCRM.IdCRM),
												(SELECT CompanyName FROM [output].[T_CNQ_Contactos] C WHERE C.IdContacto = output.T_CNQ_LogUpdateCRM.IdContacto))
	WHERE Fase = 16

	-- Coincidencias de City con flexibilidad en Company Name y First Name sin Email (sin incluir Agentes)
	UPDATE C
	SET CQRIdStatusLead = CRM.CQRIdStatusLead
	OUTPUT CRM.IdCRM, DELETED.IdContacto, 17, NULL, 0, CRM.IdNetwork INTO output.T_CNQ_LogUpdateCRM	
	FROM [process].[T_CNQ_FicherosCRMProcesados] CRM
	INNER JOIN [output].[T_CNQ_Contactos] C ON (CRM.Email = C.Email OR CRM.Email IS NULL)
												AND CRM.IdGeography <> C.IdGeography
												AND (SELECT City FROM process.T_CNQ_Geography WHERE IdGeography = CRM.IdGeography) = 
													(SELECT City FROM process.T_CNQ_Geography WHERE IdGeography = C.IdGeography)
												AND [process].[FN_CNQ_LevenshteinMod](CRM.FirstName, C.FirstName) < 0.3 -- OR (CRM.FirstName IS NULL AND C.FirstName IS NULL))
												AND [process].[FN_CNQ_LevenshteinMod](CRM.CompanyName, C.CompanyName) < 1.5
												AND C.IdContacto NOT IN (SELECT IdContacto FROM [output].[T_CNQ_LogUpdateCRM] WHERE IdContacto IS NOT NULL AND IdNetwork = 2)
	WHERE IdNetwork = 2
		AND CRM.IdCRM NOT IN (SELECT IdCRM FROM [output].[T_CNQ_LogUpdateCRM])

	-- Coincidencias geográficas con flexibilidad en Company Name y First Name sin Email (sin incluir Agentes)
	UPDATE C
	SET CQRIdStatusLead = CRM.CQRIdStatusLead
	OUTPUT CRM.IdCRM, DELETED.IdContacto, 18, NULL, 0, CRM.IdNetwork INTO output.T_CNQ_LogUpdateCRM	
	FROM [process].[T_CNQ_FicherosCRMProcesados] CRM
	INNER JOIN [output].[T_CNQ_Contactos] C ON CRM.Email IS NULL
												AND CRM.IdGeography = C.IdGeography
												AND ([process].[FN_CNQ_LevenshteinMod](CRM.FirstName, C.FirstName) < 0.26
													AND ISNULL(CRM.FirstName,'') <> '' AND ISNULL(C.FirstName,'') <> '')
												AND [process].[FN_CNQ_LevenshteinMod](CRM.CompanyName, C.CompanyName) < 0.62
												AND C.IdContacto NOT IN (SELECT IdContacto FROM [output].[T_CNQ_LogUpdateCRM] WHERE IdContacto IS NOT NULL AND IdNetwork = 2)
	WHERE IdNetwork = 2
		AND CRM.IdCRM NOT IN (SELECT IdCRM FROM [output].[T_CNQ_LogUpdateCRM])

	COMMIT TRAN
END