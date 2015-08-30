CREATE PROCEDURE [input].[PR_CNQ_FicheroCargaFin]
	@IdFichero INT
AS
BEGIN
	UPDATE input.T_CNQ_FicherosRegistro
	SET FcFinCarga = GETDATE()
	WHERE IdFichero = @IdFichero

	RETURN @IdFichero
END

GO

GRANT EXECUTE
    ON OBJECT::[input].[PR_CNQ_FicheroCargaFin] TO [CNQ_SSISUser]
    AS [dbo];


GO
