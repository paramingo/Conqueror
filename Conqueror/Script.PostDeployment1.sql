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

-- Reference Data for T_MB_PuntosTipos
MERGE INTO [input].[T_CNQ_FicherosTipos] AS Target
USING (VALUES
	(1, N'BBDD General'),
	(2, N'Asociaciones'),
	(3, N'Direfctorios')
)
AS Source (IdFicheroTipo, DsFicheroTipo)
ON Target.IdFicheroTipo = Source.IdFicheroTipo
-- update matched rows
WHEN MATCHED THEN
UPDATE SET DsFicheroTipo = Source.DsFicheroTipo
-- insert new rows
WHEN NOT MATCHED BY TARGET THEN
INSERT (IdFicheroTipo, DsFicheroTipo)
VALUES (IdFicheroTipo, DsFicheroTipo)
-- delete rows that are in the target but not the source
--WHEN NOT MATCHED BY SOURCE THEN DELETE
;