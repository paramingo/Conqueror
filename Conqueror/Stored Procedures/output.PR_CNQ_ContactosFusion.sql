

CREATE PROCEDURE [output].[PR_CNQ_ContactosFusion]
	@IdLineaNuevo int,
	@IdFicheroNuevo int,
	@IdContactoComparacion int
AS
BEGIN
	-- Resultados
	DECLARE @Source nvarchar(80)
		,@IdTitle int
		,@FirstName nvarchar(255)
		,@Surname nvarchar(255)
		,@CompanyName nvarchar(255)
		,@Address nvarchar(500)
		,@PostalCode nvarchar(40)
		,@TelephoneNo nvarchar(200)
		,@MobileNo nvarchar(200)
		,@Fax nvarchar(200)
		,@Website nvarchar(200)
		,@COOPIdStatusLead int
		,@COOPIdStatusLeadDetail int
		,@CQRIdStatusLead int
		,@CQRIdStatusLeadDetail int
		,@COOPIdStatusCity int
		,@CQRIdStatusCity int

	-- Fichero
	DECLARE @F_Source nvarchar(80)
		,@F_IdTitle int
		,@F_FirstName nvarchar(255)
		,@F_Surname nvarchar(255)
		,@F_CompanyName nvarchar(255)
		,@F_Address nvarchar(500)
		,@F_PostalCode nvarchar(40)
		,@F_TelephoneNo nvarchar(200)
		,@F_MobileNo nvarchar(200)
		,@F_Fax nvarchar(200)
		,@F_Website nvarchar(200)
		,@F_COOPIdStatusLead int
		,@F_COOPIdStatusLeadDetail int
		,@F_CQRIdStatusLead int
		,@F_CQRIdStatusLeadDetail int
		,@F_COOPIdStatusCity int
		,@F_CQRIdStatusCity int

	SELECT @F_Source = [Source]
		,@F_IdTitle = [IdTitle]
		,@F_FirstName = [FirstName]
		,@F_Surname = [Surname]
		,@F_CompanyName = [CompanyName]
		,@F_Address = [Address]
		,@F_PostalCode = [PostalCode]
		,@F_TelephoneNo = [TelephoneNo]
		,@F_MobileNo = [MobileNo]
		,@F_Fax = [Fax]
		,@F_Website = [Website]
		,@F_COOPIdStatusLead = [COOPIdStatusLead]
		,@F_COOPIdStatusLeadDetail = [COOPIdStatusLeadDetail]
		,@F_CQRIdStatusLead = [CQRIdStatusLead]
		,@F_CQRIdStatusLeadDetail = [CQRIdStatusLeadDetail]
		,@F_COOPIdStatusCity = [COOPIdStatusCity]
		,@F_CQRIdStatusCity = [CQRIdStatusCity]
	FROM [process].[T_CNQ_FicherosProcesados]
	WHERE [IdLinea] = @IdLineaNuevo
		AND [IdFichero] = @IdFicheroNuevo

	-- Contacto
	DECLARE @C_Source nvarchar(80)
		,@C_IdTitle int
		,@C_FirstName nvarchar(255)
		,@C_Surname nvarchar(255)
		,@C_CompanyName nvarchar(255)
		,@C_Address nvarchar(500)
		,@C_PostalCode nvarchar(40)
		,@C_TelephoneNo nvarchar(200)
		,@C_MobileNo nvarchar(200)
		,@C_Fax nvarchar(200)
		,@C_Website nvarchar(200)
		,@C_COOPIdStatusLead int
		,@C_COOPIdStatusLeadDetail int
		,@C_CQRIdStatusLead int
		,@C_CQRIdStatusLeadDetail int
		,@C_COOPIdStatusCity int
		,@C_CQRIdStatusCity int

	SELECT @C_Source = [Source]
		,@C_IdTitle = [IdTitle]
		,@C_FirstName = [FirstName]
		,@C_Surname = [Surname]
		,@C_CompanyName = [CompanyName]
		,@C_Address = [Address]
		,@C_PostalCode = [PostalCode]
		,@C_TelephoneNo = [TelephoneNo]
		,@C_MobileNo = [MobileNo]
		,@C_Fax = [Fax]
		,@C_Website = [Website]
		,@C_COOPIdStatusLead = [COOPIdStatusLead]
		,@C_COOPIdStatusLeadDetail = [COOPIdStatusLeadDetail]
		,@C_CQRIdStatusLead = [CQRIdStatusLead]
		,@C_CQRIdStatusLeadDetail = [CQRIdStatusLeadDetail]
		,@C_COOPIdStatusCity = [COOPIdStatusCity]
		,@C_CQRIdStatusCity = [CQRIdStatusCity]
	FROM [output].T_CNQ_Contactos
	WHERE [IdContacto] = @IdContactoComparacion

	-- Source
	SET @Source = ISNULL(@C_Source, @F_Source)

	-- IdTitle
	SET @IdTitle = CASE WHEN @C_IdTitle IS NULL THEN @F_IdTitle
						WHEN @C_IdTitle > @F_IdTitle THEN @F_IdTitle
						ELSE @C_IdTitle END

	IF ((@C_FirstName IS NULL OR @F_FirstName IS NULL) AND (@C_Surname IS NULL OR @F_Surname IS NULL))
		OR (@C_FirstName IS NULL AND @F_FirstName IS NULL)
		OR (@C_Surname IS NULL AND @F_Surname IS NULL)
	BEGIN
		-- FirstName
		SET @FirstName = CASE WHEN @C_FirstName IS NULL THEN @F_FirstName
							WHEN LEN(@C_FirstName) < LEN(@F_FirstName) THEN @F_FirstName
							ELSE @C_FirstName END

		-- Surname
		SET @Surname = CASE WHEN @C_Surname IS NULL THEN @F_Surname
							WHEN LEN(@C_Surname) < LEN(@F_Surname) THEN @F_Surname
							ELSE @C_Surname END
	END
	ELSE
	BEGIN
		DECLARE @C_FirstNameSurname nvarchar(255) = ISNULL(@C_FirstName,'')+' '+ISNULL(@C_Surname,'')
		DECLARE @F_FirstNameSurname nvarchar(255) = ISNULL(@F_FirstName,'')+' '+ISNULL(@F_Surname,'')

		IF [process].[FN_CNQ_LevenshteinMod](@C_FirstNameSurname,@F_FirstNameSurname) < 0.25
		BEGIN
			-- "Suficientemente iguales", prefiero la opción que esté separada, si ambas, la más larga.
			IF @C_FirstName IS NOT NULL AND @C_Surname IS NOT NULL AND @F_FirstName IS NOT NULL AND @F_Surname IS NOT NULL
				IF LEN(@C_FirstNameSurname) >= LEN(@F_FirstNameSurname)
				BEGIN
					SET @FirstName = @C_FirstName
					SET @Surname = @C_Surname
				END
				ELSE
				BEGIN
					SET @FirstName = @F_FirstName
					SET @Surname = @F_Surname
				END
			ELSE IF @C_FirstName IS NOT NULL AND @C_Surname IS NOT NULL
			BEGIN
				SET @FirstName = @C_FirstName
				SET @Surname = @C_Surname
			END
			ELSE IF @F_FirstName IS NOT NULL AND @F_Surname IS NOT NULL
			BEGIN
				SET @FirstName = @F_FirstName
				SET @Surname = @F_Surname
			END
		END
		ELSE
		BEGIN
			-- "Suficientemente ditintos", dejo el contacto como está salvo que hay algún nulo actuamente
			SET @FirstName = ISNULL(@C_FirstName,@F_FirstName)
			SET @Surname = ISNULL(@C_Surname,@F_Surname)
		END
	END

	-- Company Name
	SET @CompanyName = CASE WHEN @C_CompanyName IS NULL THEN @F_CompanyName
						WHEN LEN(@C_CompanyName) < LEN(@F_CompanyName) THEN @F_CompanyName
						ELSE @C_CompanyName END

	-- Address
	SET @Address = CASE WHEN @C_Address IS NULL THEN @F_Address
						WHEN LEN(@C_Address) < LEN(@F_Address) THEN @F_Address
						ELSE @C_Address END
	
	-- Postal Code
	SET @PostalCode = CASE WHEN @C_PostalCode IS NULL THEN @F_PostalCode
						WHEN LEN(@C_PostalCode) < LEN(@F_PostalCode) THEN @F_PostalCode
						ELSE @C_PostalCode END

	-- Telephone No
	SET @TelephoneNo = CASE WHEN @C_TelephoneNo IS NULL THEN @F_TelephoneNo
							WHEN LEN(@C_TelephoneNo) < LEN(@F_TelephoneNo) THEN @F_TelephoneNo
							ELSE @C_TelephoneNo END

	-- Mobile No
	SET @MobileNo = CASE WHEN @C_MobileNo IS NULL THEN @F_MobileNo
							WHEN LEN(@C_MobileNo) < LEN(@F_MobileNo) THEN @F_MobileNo
							ELSE @C_MobileNo END

	-- Fax
	SET @Fax = CASE WHEN @C_Fax IS NULL THEN @F_Fax
						WHEN LEN(@C_Fax) < LEN(@F_Fax) THEN @F_Fax
						ELSE @C_Fax END

	-- Website
	SET @Website = CASE WHEN @C_Website IS NULL THEN @F_Website
						WHEN LEN(@C_Website) < LEN(@F_Website) THEN @F_Website
						ELSE @C_Website END

	-- Status
	SET @COOPIdStatusLead = ISNULL(@C_COOPIdStatusLead,@F_COOPIdStatusLead)
	SET @COOPIdStatusLeadDetail = ISNULL(@C_COOPIdStatusLeadDetail,@F_COOPIdStatusLeadDetail)
	SET @CQRIdStatusLead = ISNULL(@C_CQRIdStatusLead,@F_CQRIdStatusLead)
	SET @CQRIdStatusLeadDetail = ISNULL(@C_CQRIdStatusLeadDetail,@F_CQRIdStatusLeadDetail)
	SET @COOPIdStatusCity = ISNULL(@C_COOPIdStatusCity,@F_COOPIdStatusCity)
	SET @CQRIdStatusCity = ISNULL(@C_CQRIdStatusCity,@F_CQRIdStatusCity)

	-- UPDATE
	UPDATE [output].[T_CNQ_Contactos]
	SET Source = @Source
		,IdTitle = @IdTitle
		,FirstName = @FirstName
		,Surname = @Surname
		,CompanyName = @CompanyName
		,Address = @Address
		,PostalCode = @PostalCode
		,TelephoneNo = @TelephoneNo
		,MobileNo = @MobileNo
		,Fax = @Fax
		,Website = @Website
		,COOPIdStatusLead = @COOPIdStatusLead
		,COOPIdStatusLeadDetail = @COOPIdStatusLeadDetail
		,CQRIdStatusLead = @CQRIdStatusLead
		,CQRIdStatusLeadDetail = @CQRIdStatusLeadDetail
		,COOPIdStatusCity = @COOPIdStatusCity
		,CQRIdStatusCity = @CQRIdStatusCity
	WHERE IdContacto = @IdContactoComparacion

	RETURN 0
END
