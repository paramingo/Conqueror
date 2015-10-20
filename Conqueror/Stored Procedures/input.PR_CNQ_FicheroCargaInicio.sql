CREATE PROCEDURE [input].[PR_CNQ_FicheroCargaInicio]
	@IdFicheroTipo INT, 
    @DsFichero VARCHAR(100)
AS
BEGIN
	DECLARE @IdFichero INT

	IF EXISTS (SELECT DsFichero
				FROM input.T_CNQ_FicherosRegistro
				WHERE DsFichero = @DsFichero
					AND FcFinCarga IS NOT NULL
					AND Deleted = 0)
		RAISERROR('El fichero %s está registrado como cargado.',15,1,@DsFichero)

	INSERT INTO input.T_CNQ_FicherosRegistro
	(IdFicheroTipo, DsFichero)
	VALUES
	(@IdFicheroTipo, @DsFichero)

	SET @IdFichero = @@IDENTITY

	RETURN @IdFichero
END

GO

GRANT EXECUTE
    ON OBJECT::[input].[PR_CNQ_FicheroCargaInicio] TO [CNQ_SSISUser]
    AS [dbo];


GO
