
CREATE VIEW [output].[V_CNQ_InformeCargaFicherosCRM]
AS
SELECT FR.DsFichero
	, CASE WHEN Defecto IN (-1,-11) THEN 'Duplicado en Ficheros CRM'
		WHEN FASE IN (1,11) THEN 'Coincidencias totales'
		WHEN FASE IN (2,12) THEN 'Coincidencias totales con flexibilidad en Company Name'
		WHEN FASE IN (3,13) THEN 'Coincidencias totales con flexibilidad en FirstName'
		WHEN FASE IN (4,14) THEN 'Coincidencias totales con flexibilidad en Company Name y First Name'
		WHEN FASE IN (5,15) THEN 'Coincidencias totales sin Email'
		WHEN FASE IN (6,16) THEN 'Coincidencias totales con flexibilidad en Company Name sin Email (sin incluir Agentes)'
		WHEN FASE IN (7,17) THEN 'Coincidencias de City con flexibilidad en Company Name y First Name sin Email (sin incluir Agentes)'
		WHEN FASE IN (8,18) THEN 'Coincidencias geográficas con flexibilidad en Company Name y First Name sin Email (sin incluir Agentes)'
		ELSE 'Sin coincidencia'
		END AS Resultado
	, LOG.IdContacto
	, CRM.IdCRM, CompanyName, Continent, Country, City, FirstName, Email, TelephoneNo, StatusLead
FROM [input].[T_CNQ_FicherosCRM] CRM
INNER JOIN [input].[T_CNQ_FicherosRegistro] FR ON CRM.IdFichero = FR.IdFichero
LEFT OUTER JOIN [output].[T_CNQ_LogUpdateCRM] LOG ON CRM.IdCRM = LOG.IdCRM