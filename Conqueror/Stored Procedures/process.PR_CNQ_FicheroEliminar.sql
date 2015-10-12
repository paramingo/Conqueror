CREATE PROCEDURE [process].[PR_CNQ_FicheroEliminar]
	@IdFichero int
AS
BEGIN

	-- output
	DELETE FROM output.T_CNQ_ResultadosFilas
	WHERE IdResultadoFila IN (SELECT IdResultadoFila
								FROM output.T_CNQ_LogProcesoFilas
								WHERE IdFichero = @IdFichero)

	DELETE FROM output.T_CNQ_LogProcesoFilas
	WHERE IdFichero = @IdFichero

	DELETE FROM output.T_CNQ_ContactosConsolidar
	WHERE IdContacto IN (SELECT IdContacto
							FROM output.T_CNQ_Contactos
							WHERE IdFichero = @IdFichero)

	DELETE FROM output.T_CNQ_Contactos
	WHERE IdFichero = @IdFichero

	-- process
	DELETE FROM process.T_CNQ_FicherosProcesados
	WHERE IdFichero = @IdFichero

	-- input
	DECLARE @IdFicheroTipo int = (SELECT IdFicheroTipo
									FROM input.T_CNQ_FicherosRegistro
									WHERE IdFichero = @IdFichero)
	IF @IdFicheroTipo = 1
		DELETE FROM input.T_CNQ_Ficheros
		WHERE IdFichero = @IdFichero
	ELSE IF @IdFicheroTipo = 2
		DELETE FROM input.T_CNQ_FicherosAsociaciones
		WHERE IdFichero = @IdFichero
	ELSE IF @IdFicheroTipo = 3
		DELETE FROM input.T_CNQ_FicherosDirectorios
		WHERE IdFichero = @IdFichero

END