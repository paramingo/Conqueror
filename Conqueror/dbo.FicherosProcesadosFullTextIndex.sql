CREATE FULLTEXT INDEX ON [process].[T_CNQ_FicherosProcesados]
    ([Source] LANGUAGE 1033, [Email] LANGUAGE 1033, [FirstName] LANGUAGE 1033, [Surname] LANGUAGE 1033, [CompanyName] LANGUAGE 1033, [Address] LANGUAGE 1033, [PostalCode] LANGUAGE 1033, [TelephoneNo] LANGUAGE 1033)
    KEY INDEX [AK_T_CNQ_FicherosProcesados_Unique]
    ON [ConquerorFullTextCatalog];


