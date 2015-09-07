
CREATE PROCEDURE [output].[PR_CNQ_ContactosGenerar]
	@RowLimit int = null
AS
BEGIN
	IF @RowLimit IS NULL SET @RowLimit = 1000000000

	TRUNCATE TABLE [output].[T_CNQ_Contactos]
	TRUNCATE TABLE [output].[T_CNQ_LogProcesoFilas]

	SET NOCOUNT ON

	DECLARE @IdLinea int,
		@Source nvarchar(80),
		@IdGeography int,
		@Email nvarchar(100),
		@IdTitle int,
		@FirstNameSurname nvarchar(255),
		@CompanyName nvarchar(255),
		@Address nvarchar(500),
		@PostalCode nvarchar(15),
		@TelephoneNo nvarchar(200),
		@COOPIdStatusLead int,
		@COOPIdStatusLeadDetail int,
		@CQRIdStatusLead int,
		@CQRIdStatusLeadDetail int,
		@COOPIdStatusCity int,
		@CQRIdStatusCity int

	DECLARE @IdLineaComparacion int,
		@EmailComparacion nvarchar(100),
		@FirstNameSurnameComparacion nvarchar(255),
		@CompanyNameComparacion nvarchar(255),
		@ContactosSimilares int

	DECLARE LineasFichero CURSOR FAST_FORWARD FOR
	SELECT TOP (@RowLimit) IdLinea, Source, IdGeography, Email, IdTitle, [FirstName],
		CompanyName, Address, PostalCode, TelephoneNo, COOPIdStatusLead, COOPIdStatusLeadDetail,
		CQRIdStatusLead, CQRIdStatusLeadDetail, COOPIdStatusCity, CQRIdStatusCity
	FROM [process].[T_CNQ_FicherosProcesados]
	WHERE Email IS NOT NULL
	ORDER BY Email, [FirstName], CompanyName

	OPEN LineasFichero

	FETCH NEXT FROM LineasFichero INTO @IdLinea, @Source, @IdGeography, @Email, @IdTitle,
		@FirstNameSurname, @CompanyName, @Address, @PostalCode, @TelephoneNo, @COOPIdStatusLead,
		@COOPIdStatusLeadDetail, @CQRIdStatusLead, @CQRIdStatusLeadDetail, @COOPIdStatusCity, @CQRIdStatusCity

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @IdLineaComparacion = NULL

		EXEC @IdLineaComparacion = [output].[PR_CNQ_ContactosBestMatch] @Email, @FirstNameSurname, @CompanyName, @IdGeography

		IF @IdLineaComparacion > 0
		BEGIN
			EXEC [output].[PR_CNQ_ContactosFusion] @IdLinea, @IdLineaComparacion

			INSERT INTO output.T_CNQ_LogProcesoFilas VALUES (@IdLinea, 2, @IdLineaComparacion)
		END
		ELSE -- Nuevo
		BEGIN
			INSERT INTO [output].[T_CNQ_Contactos]
			(IdLinea, Source, IdGeography, Email, IdTitle, FirstNameSurname, CompanyName, Address,
				PostalCode, TelephoneNo, COOPIdStatusLead, COOPIdStatusLeadDetail, CQRIdStatusLead,
				CQRIdStatusLeadDetail, COOPIdStatusCity, CQRIdStatusCity)
			VALUES
			(@IdLinea, @Source, @IdGeography, @Email, @IdTitle, @FirstNameSurname, @CompanyName,
				@Address, @PostalCode, @TelephoneNo, @COOPIdStatusLead, @COOPIdStatusLeadDetail,
				@CQRIdStatusLead, @CQRIdStatusLeadDetail, @COOPIdStatusCity, @CQRIdStatusCity)

			INSERT INTO output.T_CNQ_LogProcesoFilas VALUES (@IdLinea, 1, NULL)
		END

		FETCH NEXT FROM LineasFichero INTO @IdLinea, @Source, @IdGeography, @Email, @IdTitle,
			@FirstNameSurname, @CompanyName, @Address, @PostalCode, @TelephoneNo, @COOPIdStatusLead,
			@COOPIdStatusLeadDetail, @CQRIdStatusLead, @CQRIdStatusLeadDetail, @COOPIdStatusCity, @CQRIdStatusCity
	END

	CLOSE LineasFichero
	DEALLOCATE LineasFichero


END