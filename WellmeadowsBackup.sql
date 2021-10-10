 --BACKUP Database
USE master
Go
--create master key
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'admin#123';
GO

select * from sys.symmetric_keys 

--create certificate
CREATE CERTIFICATE BackupDatabase
    WITH SUBJECT = 'Backup Database';
GO
--backup certificate
BACKUP CERTIFICATE BackupDatabase
TO FILE = 'D:\DBackup\BackupDatabase.cert'
WITH PRIVATE KEY (
FILE = 'D:\DBackup\BackupDatabase.key',
ENCRYPTION BY PASSWORD = 'adminPassword#123')

--backup database with encryption
BACKUP DATABASE WellMeadows
TO DISK = 'D:\DBackup\BackupDatabase.bak'
WITH COMPRESSION,
ENCRYPTION (ALGORITHM = AES_256, SERVER CERTIFICATE = BackupDatabase)

select * from sys.symmetric_keys 
select*from sys.key_encryptions 
select * from sys.certificates 

--DROP DATABASE TO TEST
Go
DROP DATABASE Wellmeadows;
GO
DROP CERTIFICATE BackupDatabase;
GO


--TO RESTORE DATABASE
--restore  certificate
CREATE CERTIFICATE BackupDatabase
FROM FILE = 'D:\DBackup\BackupDatabase.cert'
WITH PRIVATE KEY (FILE = 'D:\DBackup\BackupDatabase.key',
DECRYPTION BY PASSWORD = 'adminPassword#123');
GO

-- restore database 
RESTORE DATABASE Wellmeadows
FROM DISK = 'D:\DBackup\BackupDatabase.bak';
GO