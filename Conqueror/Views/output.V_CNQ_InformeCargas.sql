
CREATE VIEW [output].[V_CNQ_InformeCargas]
AS
SELECT R.IdFichero, R.IdFicheroTipo, T.FicheroTipo, DsFichero, FcInicioCarga, FcFinCarga
	,CASE R.IdFicheroTipo
		WHEN 1 THEN COUNT(DISTINCT F.IDLINEA)
		WHEN 2 THEN COUNT(DISTINCT A.IDLINEA)
		WHEN 3 THEN COUNT(DISTINCT D.IDLINEA)
		WHEN 4 THEN COUNT(DISTINCT C.IdCRM) END AS NumeroFilasCargadas
FROM [input].[T_CNQ_FicherosRegistro] R
INNER JOIN [input].[T_CNQ_FicherosTipos] T ON R.IdFicheroTipo = T.IdFicheroTipo
LEFT OUTER JOIN [input].[T_CNQ_Ficheros] F ON R.IdFichero = F.IdFichero
LEFT OUTER JOIN [input].[T_CNQ_FicherosAsociaciones] A ON R.IdFichero = A.IdFichero
LEFT OUTER JOIN [input].[T_CNQ_FicherosDirectorios] D ON R.IdFichero = D.IdFichero
LEFT OUTER JOIN [input].[T_CNQ_FicherosCRM] C ON R.IdFichero = C.IdFichero
WHERE R.FcFinCarga IS NOT NULL
	AND ISNULL(R.Deleted,0) = 0
GROUP BY R.IdFichero, R.IdFicheroTipo, T.FicheroTipo, DsFichero, FcInicioCarga, FcFinCarga

GO

GRANT SELECT
    ON OBJECT::[output].[V_CNQ_InformeCargas] TO [CNQ_Conqueror]
    AS [dbo];


GO

