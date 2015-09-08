


CREATE PROCEDURE [output].[PR_CNQ_ContactosBestMatch]
	@Email nvarchar(100),
	@FirstName nvarchar(255),
	@Surname nvarchar(255),
	@CompanyName nvarchar(255),
	@IdGeography int
AS
BEGIN
	DECLARE @IdContacto int

	DECLARE @ContactosMatch TABLE
	(
		IdContacto int NOT NULL,
		Email nvarchar(100),
		FirstName nvarchar(255),
		Surname nvarchar(255),
		CompanyName nvarchar(255)
	)

	INSERT INTO @ContactosMatch
	SELECT IdContacto, Email, FirstName, Surname, CompanyName
	FROM [output].[T_CNQ_Contactos]
	WHERE Email = @Email
		AND IdGeography = @IdGeography -- Se admiten distintas ciudades para guardar direcciones de sucursales

	DECLARE @ContactosSimilares int = (SELECT COUNT(*) FROM @ContactosMatch)

	IF @ContactosSimilares = 0
	BEGIN
		SET @IdContacto = -1
	END
	ELSE IF @ContactosSimilares = 1 AND (SELECT FirstName FROM @ContactosMatch) IS NULL
	BEGIN
		SELECT @IdContacto = IdContacto FROM @ContactosMatch
	END
	ELSE
	BEGIN
		SELECT TOP 1 @IdContacto = IdContacto
		FROM @ContactosMatch
		WHERE [process].[FN_CNQ_LevenshteinMod](ISNULL(FirstName,'')+ISNULL(Surname,''),ISNULL(@FirstName,'')+ISNULL(@Surname,'')) < 0.45
		ORDER BY [process].[FN_CNQ_LevenshteinMod](ISNULL(FirstName,'')+ISNULL(Surname,''),ISNULL(@FirstName,'')+ISNULL(@Surname,''))
	END

	RETURN ISNULL(@IdContacto,-1)
END