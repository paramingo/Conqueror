﻿CREATE LOGIN [CNQ_SSISUser] WITH PASSWORD = '******';
GO

CREATE USER [CNQ_SSISUser] FOR LOGIN [CNQ_SSISUser]
    WITH DEFAULT_SCHEMA = [input];
GO

