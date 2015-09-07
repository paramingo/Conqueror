
CREATE PROCEDURE [output].[PR_CNQ_ContactosFusion]
	@IdLineaNueva int,
	@IdLineaComparacion int
AS
BEGIN
	IF (SELECT [FirstName] FROM [output].[T_CNQ_Contactos] WHERE IdLinea = @IdLineaComparacion) IS NULL
		UPDATE [output].[T_CNQ_Contactos]
		SET [FirstName] = (SELECT [FirstName] FROM [process].[T_CNQ_FicherosProcesados] WHERE IdLinea = @IdLineaNueva)
		WHERE IdLinea = @IdLineaComparacion
	ELSE IF (SELECT LEN([FirstName]) FROM [process].[T_CNQ_FicherosProcesados] WHERE IdLinea = @IdLineaNueva)
			> (SELECT LEN([FirstName]) FROM [output].[T_CNQ_Contactos] WHERE IdLinea = @IdLineaComparacion)
		UPDATE [output].[T_CNQ_Contactos]
		SET [FirstName] = (SELECT [FirstName] FROM [process].[T_CNQ_FicherosProcesados] WHERE IdLinea = @IdLineaNueva)
		WHERE IdLinea = @IdLineaComparacion

	RETURN 0
END
