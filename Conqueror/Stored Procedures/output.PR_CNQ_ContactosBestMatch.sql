
CREATE PROCEDURE [output].[PR_CNQ_ContactosBestMatch]
	@Email nvarchar(100),
	@FirstNameSurname nvarchar(255),
	@CompanyName nvarchar(255)
AS
	DECLARE @IdLineaMatch int

	DECLARE @ContactosMatch TABLE
	(
		IdLinea int,
		Email nvarchar(100),
		FirstNameSurname nvarchar(255),
		CompanyName nvarchar(255)
	)

	INSERT INTO @ContactosMatch
	SELECT IdLinea, Email, FirstNameSurname, CompanyName
	FROM [output].[T_CNQ_Contactos]
	WHERE Email = @Email

	DECLARE @ContactosSimilares int = (SELECT COUNT(*) FROM @ContactosMatch)

	IF @ContactosSimilares = 0
		SET @IdLineaMatch = -1
	ELSE IF @ContactosSimilares = 1 AND (SELECT FirstNameSurname FROM @ContactosMatch) IS NULL
		SET @IdLineaMatch = (SELECT IdLinea FROM @ContactosMatch)
	ELSE
	BEGIN
		SET @IdLineaMatch = (SELECT TOP 1 IdLinea
								FROM @ContactosMatch
								WHERE [process].[FN_CNQ_LevenshteinMod](FirstNameSurname,@FirstNameSurname) < 0.45
								ORDER BY [process].[FN_CNQ_LevenshteinMod](FirstNameSurname,@FirstNameSurname))
	END

	RETURN @IdLineaMatch
