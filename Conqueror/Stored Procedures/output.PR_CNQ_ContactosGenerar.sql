


CREATE PROCEDURE [output].[PR_CNQ_ContactosGenerar]
	@RowLimit int = null
AS
BEGIN
	IF @RowLimit IS NULL SET @RowLimit = (SELECT COUNT(*) FROM [process].[T_CNQ_FicherosProcesados])

	TRUNCATE TABLE [output].[T_CNQ_Contactos]
	TRUNCATE TABLE [output].[T_CNQ_LogProcesoFilas]

	SET NOCOUNT ON

	DECLARE @IdLinea int,
		@IdFichero int,
		@Source nvarchar(80),
		@IdGeography int,
		@Email nvarchar(200),
		@IdTitle int,
		@FirstName nvarchar(255),
		@Surname nvarchar(255),
		@CompanyName nvarchar(255),
		@Address nvarchar(500),
		@PostalCode nvarchar(15),
		@TelephoneNo nvarchar(200),
		@MobileNo nvarchar(200),
		@Fax nvarchar(200),
		@Website nvarchar(200),
		@COOPIdStatusLead int,
		@COOPIdStatusLeadDetail int,
		@CQRIdStatusLead int,
		@CQRIdStatusLeadDetail int,
		@COOPIdStatusCity int,
		@CQRIdStatusCity int

	DECLARE @IdContactoComparacion int,
		@EmailComparacion nvarchar(200),
		@FirstNameSurnameComparacion nvarchar(255),
		@CompanyNameComparacion nvarchar(255),
		@ContactosSimilares int,
		@Similarity float

	DECLARE LineasFichero CURSOR FAST_FORWARD FOR
	SELECT TOP (@RowLimit) IdLinea, IdFichero, Source, IdGeography, Email, IdTitle, FirstName, Surname,
		CompanyName, Address, PostalCode, TelephoneNo, MobileNo, Fax, Website, COOPIdStatusLead,
		COOPIdStatusLeadDetail, CQRIdStatusLead, CQRIdStatusLeadDetail, COOPIdStatusCity, CQRIdStatusCity
	FROM [process].[T_CNQ_FicherosProcesados]
	WHERE Email IS NOT NULL
	ORDER BY Email, [FirstName], CompanyName, IdLinea, IdFichero

	OPEN LineasFichero

	FETCH NEXT FROM LineasFichero INTO @IdLinea, @IdFichero, @Source, @IdGeography, @Email, @IdTitle,
		@FirstName, @Surname, @CompanyName, @Address, @PostalCode, @TelephoneNo, @MobileNo, @Fax,
		@Website, @COOPIdStatusLead, @COOPIdStatusLeadDetail, @CQRIdStatusLead, @CQRIdStatusLeadDetail,
		@COOPIdStatusCity, @CQRIdStatusCity

	WHILE @@FETCH_STATUS = 0
	BEGIN
	PRINT @IdLinea
		SET @IdContactoComparacion = NULL
		SET @Similarity = NULL

		EXEC @IdContactoComparacion = [output].[PR_CNQ_ContactosBestMatch] @Email, @FirstName, @Surname,@CompanyName, @IdGeography, @Similarity OUTPUT

		IF @IdContactoComparacion > 0
		BEGIN
			EXEC [output].[PR_CNQ_ContactosFusion] @IdLinea, @IdFichero, @IdContactoComparacion

			INSERT INTO output.T_CNQ_LogProcesoFilas
			(IdLinea, IdFichero, IdResultadoFila, IdContactoComparacion, Similarity)
			VALUES (@IdLinea, @IdFichero, 2, @IdContactoComparacion, @Similarity)
		END
		ELSE -- Nuevo
		BEGIN
			INSERT INTO [output].[T_CNQ_Contactos]
			(IdLinea, IdFichero, Source, IdGeography, Email, IdTitle, FirstName, Surname, CompanyName, Address,
				PostalCode, TelephoneNo, MobileNo, Fax, Website, COOPIdStatusLead, COOPIdStatusLeadDetail, CQRIdStatusLead,
				CQRIdStatusLeadDetail, COOPIdStatusCity, CQRIdStatusCity)
			VALUES
			(@IdLinea, @IdFichero, @Source, @IdGeography, @Email, @IdTitle, @FirstName, @Surname, @CompanyName, @Address,
				@PostalCode, @TelephoneNo, @MobileNo, @Fax, @Website, @COOPIdStatusLead, @COOPIdStatusLeadDetail, @CQRIdStatusLead,
				@CQRIdStatusLeadDetail, @COOPIdStatusCity, @CQRIdStatusCity)

			INSERT INTO output.T_CNQ_LogProcesoFilas
			(IdLinea, IdFichero, IdResultadoFila, IdContactoComparacion)
			VALUES (@IdLinea, @IdFichero, 1, @@IDENTITY)
		END

		FETCH NEXT FROM LineasFichero INTO @IdLinea, @IdFichero, @Source, @IdGeography, @Email, @IdTitle,
			@FirstName, @Surname, @CompanyName, @Address, @PostalCode, @TelephoneNo, @MobileNo, @Fax,
			@Website, @COOPIdStatusLead, @COOPIdStatusLeadDetail, @CQRIdStatusLead, @CQRIdStatusLeadDetail,
			@COOPIdStatusCity, @CQRIdStatusCity
	END

	CLOSE LineasFichero
	DEALLOCATE LineasFichero


END