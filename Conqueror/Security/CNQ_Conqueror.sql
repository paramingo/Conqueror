CREATE LOGIN [CNQ_Conqueror] WITH PASSWORD = '******';
GO

CREATE USER [CNQ_Conqueror] FOR LOGIN [CNQ_Conqueror]
    WITH DEFAULT_SCHEMA = [output];
GO

