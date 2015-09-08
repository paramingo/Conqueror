CREATE VIEW [output].[V_CNQ_InformeCargas]
AS
SELECT R.IdFichero, IdFicheroTipo, DsFichero, FcInicioCarga, FcFinCarga
	,CASE WHEN COUNT(DISTINCT F.IDLINEA) > 0 THEN COUNT(DISTINCT F.IDLINEA) ELSE COUNT(DISTINCT A.IDLINEA) END AS NumeroFilasCargadas
FROM [input].[T_CNQ_FicherosRegistro] R
LEFT OUTER JOIN [input].[T_CNQ_Ficheros] F ON R.IdFichero = F.IdFichero
LEFT OUTER JOIN [input].[T_CNQ_FicherosAsociaciones] A ON R.IdFichero = A.IdFichero
WHERE R.FcFinCarga IS NOT NULL
GROUP BY R.IdFichero, IdFicheroTipo, DsFichero, FcInicioCarga, FcFinCarga

GO

GRANT SELECT
    ON OBJECT::[output].[V_CNQ_InformeCargas] TO [CNQ_Conqueror]
    AS [dbo];


GO

