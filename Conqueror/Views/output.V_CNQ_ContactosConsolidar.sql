﻿

CREATE VIEW [output].[V_CNQ_ContactosConsolidar]
AS
SELECT [IdContacto]
	,[Source]
	,G.[Continent]
	,G.[Country]
	,G.[City]
	,[Email]
	,T.Title
	,ISNULL([FirstName],'Agent') AS [FirstName]
	,[Surname]
	,JobTitle
	,[CompanyName]
	,[Address]
	,[PostalCode]
	,[TelephoneNo]
	,[MobileNo]
	,[Fax]
	,[Website]
	,COOPSL.[StatusLead] AS [COOPStatusLead]
	,CQRSL.[StatusLead] AS [CQRStatusLead]
	,COOPSC.[StatusCity] AS [COOPStatusCity]
	,CQRSC.[StatusCity] AS [CQRStatusCity]
	,COOPSLD.[StatusLeadDetail] AS [Comment]
--	,CQRSLD.[StatusLeadDetail] AS 
FROM [output].[T_CNQ_Contactos] C
INNER JOIN [process].[T_CNQ_Geography] G ON C.[IdGeography] = G.[IdGeography]
LEFT OUTER JOIN [process].T_CNQ_Titles T ON C.IdTitle = T.IdTitle
LEFT OUTER JOIN [process].[T_CNQ_StatusLead] COOPSL ON C.[COOPIdStatusLead] = COOPSL.[IdStatusLead]
LEFT OUTER JOIN [process].[T_CNQ_StatusLeadDetails] COOPSLD ON C.[COOPIdStatusLeadDetail] = COOPSLD.[IdStatusLeadDetail]
LEFT OUTER JOIN [process].[T_CNQ_StatusCity] COOPSC ON C.[COOPIdStatusCity] = COOPSC.[IdStatusCity]
LEFT OUTER JOIN [process].[T_CNQ_StatusLead] CQRSL ON C.[CQRIdStatusLead] = CQRSL.[IdStatusLead]
--LEFT OUTER JOIN [process].[T_CNQ_StatusLeadDetails] CQRSLD ON C.[CQRIdStatusLeadDetail] = CQRSLD.[IdStatusLeadDetail]
LEFT OUTER JOIN [process].[T_CNQ_StatusCity] CQRSC ON C.[CQRIdStatusCity] = CQRSC.[IdStatusCity]
