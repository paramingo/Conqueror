CREATE PROCEDURE [output].[PR_CNQ_ContactosConsolidar]
AS
BEGIN
	INSERT INTO [output].[T_CNQ_ContactosConsolidar]
	SELECT * FROM [output].[V_CNQ_ContactosConsolidar]
END
