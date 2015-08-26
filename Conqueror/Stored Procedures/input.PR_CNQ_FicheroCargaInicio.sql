﻿CREATE PROCEDURE [input].[PR_CNQ_FicheroCargaInicio]
	@IdFicheroTipo INT, 
    @DsFichero VARCHAR(100)
AS
BEGIN
	DECLARE @IdFichero INT

	INSERT INTO input.T_CNQ_FicherosRegistro
	(IdFicheroTipo, DsFichero)
	VALUES
	(@IdFicheroTipo, @DsFichero)

	SET @IdFichero = @@IDENTITY

	RETURN @IdFichero
END