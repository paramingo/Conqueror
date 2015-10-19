


CREATE PROCEDURE [output].[PR_CNQ_ContactosBestMatch]
	@Email nvarchar(200),
	@FirstName nvarchar(255),
	@Surname nvarchar(255),
	@CompanyName nvarchar(255),
	@IdGeography int,
	@Similarity float OUTPUT
AS
BEGIN
	DECLARE @IdContacto int

	DECLARE @ContactosMatch TABLE
	(
		IdContacto int NOT NULL,
		Email nvarchar(200),
		FirstName nvarchar(255),
		Surname nvarchar(255),
		CompanyName nvarchar(255)
	)

	INSERT INTO @ContactosMatch
	SELECT IdContacto
		,Email
		,ISNULL(FirstName,'Agente')
		,Surname
		,CompanyName
	FROM [output].[T_CNQ_Contactos]
	WHERE Email = @Email
		AND IdGeography = @IdGeography -- Se admiten distintas ciudades para guardar direcciones de sucursales

	DECLARE @ContactosSimilares int = (SELECT COUNT(*) FROM @ContactosMatch)

	SET @Similarity = NULL

	IF @ContactosSimilares = 0
	BEGIN
		SET @IdContacto = -1
	END
	ELSE
	BEGIN
		SELECT TOP 1 @IdContacto = IdContacto
			,@Similarity = [process].[FN_CNQ_LevenshteinMod](ISNULL(FirstName,'')+ISNULL(Surname,''),ISNULL(@FirstName,'Agente')+ISNULL(@Surname,''))
		FROM @ContactosMatch
		WHERE [process].[FN_CNQ_LevenshteinMod](ISNULL(FirstName,'')+ISNULL(Surname,''),ISNULL(@FirstName,'Agente')+ISNULL(@Surname,'')) < 0.45
		ORDER BY [process].[FN_CNQ_LevenshteinMod](ISNULL(FirstName,'')+ISNULL(Surname,''),ISNULL(@FirstName,'Agente')+ISNULL(@Surname,''))
	END

	RETURN ISNULL(@IdContacto,-1)
END