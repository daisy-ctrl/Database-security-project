--SMK is already created in SQL Server
--The syntax used to encrypt is DMK-Certificate-Symmetric key
USE Wellmeadows
GO

--CREATE Database Master Key, protected by a password
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Daisy123'; 

--get system catalog views
select * from sys.symmetric_keys 
select*from sys.key_encryptions --DMK is encrypted by service master key and password

--Backup DMK
BACKUP MASTER KEY
TO FILE = 'D:\Backup\WellDMK.key'
ENCRYPTION BY PASSWORD = '#DAISY123';

--Create certificate, protected by DMK
CREATE CERTIFICATE Wellcert WITH SUBJECT = 'Wellmeadows Certificate';   
GO   

--Backup certificate
BACKUP CERTIFICATE Wellcert 
TO FILE = 'D:\Backup\Wellcert.cert'
WITH PRIVATE KEY (
FILE = 'D:\Backup\Wellcert.key',
ENCRYPTION BY PASSWORD = 'D#A#I#S#Y#123')

select * from sys.certificates		-- certificate will expire after one year

--create symmetric key protected by certificate
CREATE SYMMETRIC KEY WellSymmkey WITH   
    ALGORITHM = AES_256 
    ENCRYPTION BY CERTIFICATE Wellcert 
GO 

--system catalog views
select * from sys.symmetric_keys 
select*from sys.key_encryptions 
select * from sys.certificates 

--SAMPLE OF COLUMN ENCRYPTION
--open symmetric key
OPEN SYMMETRIC KEY WellSymmkey  
    DECRYPTION BY CERTIFICATE Wellcert;   
GO  
-- Check if the symmetric key is opened 
SELECT * FROM sys.openkeys 
GO 

--add column for encryption
ALTER TABLE Wellmeadows.dbo.PatientInfo
ADD phoneno_encrypt varbinary(1000)

UPDATE Wellmeadows.dbo.PatientInfo
	SET phoneno_encrypt = EncryptByKey (Key_GUID('WellSymmkey'), patient_phoneno)
    FROM Wellmeadows.dbo.PatientInfo;
    GO

SELECT * from PatientInfo;

CLOSE SYMMETRIC KEY WellSymmkey 
GO 

--DECRYPT THE DATA
--open symmetric key
OPEN SYMMETRIC KEY WellSymmkey  
    DECRYPTION BY CERTIFICATE Wellcert;   
GO  
SELECT * FROM sys.openkeys 
GO
--decrypt text
SELECT *,CAST(DECRYPTBYKEY(phoneno_encrypt) as varchar(2000)) as decrypted_phoneno FROM PatientInfo
GO
--close key
CLOSE SYMMETRIC KEY WellSymmkey 
GO

--this query shows keys being used to encrypt data
select *, KEY_NAME(phoneno_encrypt) as key_name from PatientInfo;
 

