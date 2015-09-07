
CREATE PROCEDURE [output].[PR_CNQ_ContactosBestMatch]
	@Email nvarchar(100),
	@FirstNameSurname nvarchar(255),
	@CompanyName nvarchar(255),
	@IdGeography int
AS
BEGIN
	DECLARE @IdLineaMatch int

	DECLARE @ContactosMatch TABLE
	(
		IdLinea int NOT NULL,
		Email nvarchar(100),
		FirstNameSurname nvarchar(255),
		CompanyName nvarchar(255)
	)

	INSERT INTO @ContactosMatch
	SELECT IdLinea, Email, [FirstName], CompanyName
	FROM [output].[T_CNQ_Contactos]
	WHERE Email = @Email
		AND IdGeography = @IdGeography -- Se admiten distintas ciudades para guardar direcciones de sucursales

	DECLARE @ContactosSimilares int = (SELECT COUNT(*) FROM @ContactosMatch)

	IF @ContactosSimilares = 0
		SET @IdLineaMatch = -1
	ELSE IF @ContactosSimilares = 1 AND (SELECT FirstNameSurname FROM @ContactosMatch) IS NULL
		SET @IdLineaMatch = (SELECT IdLinea FROM @ContactosMatch)
	ELSE
	BEGIN
		SET @IdLineaMatch = ISNULL((SELECT TOP 1 IdLinea
									FROM @ContactosMatch
									WHERE [process].[FN_CNQ_LevenshteinMod](FirstNameSurname,@FirstNameSurname) < 0.45
									ORDER BY [process].[FN_CNQ_LevenshteinMod](FirstNameSurname,@FirstNameSurname))
									,-1)
	END

	RETURN @IdLineaMatch
END