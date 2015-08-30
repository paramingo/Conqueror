/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

-- Reference Data for T_CNQ_FicherosTipos
MERGE INTO [input].[T_CNQ_FicherosTipos] AS Target
USING (VALUES
	(1, 'BBDD General'),
	(2, 'Asociaciones'),
	(3, 'Direfctorios')
)
AS Source (IdFicheroTipo, FicheroTipo)
ON Target.IdFicheroTipo = Source.IdFicheroTipo
-- update matched rows
WHEN MATCHED THEN
UPDATE SET FicheroTipo = Source.FicheroTipo
-- insert new rows
WHEN NOT MATCHED BY TARGET THEN
INSERT (IdFicheroTipo, FicheroTipo)
VALUES (IdFicheroTipo, FicheroTipo)
-- delete rows that are in the target but not the source
--WHEN NOT MATCHED BY SOURCE THEN DELETE
;

-- Reference Data for T_CNQ_Networks
MERGE INTO [process].[T_CNQ_Networks] AS Target
USING (VALUES
	(1, 'Conqueror','CQR'),
	(2, 'Cooperative','COOP')
)
AS Source (IdNetwork, Network, NetworkShort)
ON Target.IdNetwork = Source.IdNetwork
-- update matched rows
WHEN MATCHED THEN
UPDATE SET Network = Source.Network
	,NetworkShort = Source.NetworkShort
-- insert new rows
WHEN NOT MATCHED BY TARGET THEN
INSERT (IdNetwork, Network, NetworkShort)
VALUES (IdNetwork, Network, NetworkShort)
-- delete rows that are in the target but not the source
--WHEN NOT MATCHED BY SOURCE THEN DELETE
;

-- Reference Data for T_CNQ_Titles
MERGE INTO [process].[T_CNQ_Titles] AS Target
USING (VALUES
	(1, 'Mr.'),
	(2, 'Mrs.'),
	(3, 'Ms.')
)
AS Source (IdTitle, Title)
ON Target.IdTitle = Source.IdTitle
-- update matched rows
WHEN MATCHED THEN
UPDATE SET Title = Source.Title
-- insert new rows
WHEN NOT MATCHED BY TARGET THEN
INSERT (IdTitle, Title)
VALUES (IdTitle, Title)
-- delete rows that are in the target but not the source
--WHEN NOT MATCHED BY SOURCE THEN DELETE
;

-- Reference Data for T_CNQ_ResultadosFilas
MERGE INTO [output].[T_CNQ_ResultadosFilas] AS Target
USING (VALUES
	(1, 'Nueva'),
	(2, 'Duplicado Email')
)
AS Source (IdResultadoFila, ResultadoFila)
ON Target.IdResultadoFila = Source.IdResultadoFila
-- update matched rows
WHEN MATCHED THEN
UPDATE SET ResultadoFila = Source.ResultadoFila
-- insert new rows
WHEN NOT MATCHED BY TARGET THEN
INSERT (IdResultadoFila, ResultadoFila)
VALUES (IdResultadoFila, ResultadoFila)
-- delete rows that are in the target but not the source
--WHEN NOT MATCHED BY SOURCE THEN DELETE
;