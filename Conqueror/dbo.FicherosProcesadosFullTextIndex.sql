CREATE FULLTEXT INDEX ON [process].[T_CNQ_FicherosProcesados]
    ([Source] LANGUAGE 1033, [Email] LANGUAGE 1033, [FirstNameSurname] LANGUAGE 1033, [CompanyName] LANGUAGE 1033, [Address] LANGUAGE 1033, [PostalCode] LANGUAGE 1033, [TelephoneNo] LANGUAGE 1033)
    KEY INDEX [PK_T_CNQ_FicherosProcesados]
    ON [ConquerorFullTextCatalog];


