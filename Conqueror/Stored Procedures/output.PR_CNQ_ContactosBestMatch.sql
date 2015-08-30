CREATE PROCEDURE [output].[PR_CNQ_ContactosBestMatch]
	@IdLinea int
AS
	DECLARE @IdLineaMatch int

	DECLARE @ContactosMatch TABLE
	(
		IdLinea int,
		Email nvarchar(100),
		FirstNameSurname nvarchar(255),
		CompanyName nvarchar(255)
	)

	--INSERT INTO @ContactosMatch
	--SELECT 
	--FROM output.
RETURN 0
