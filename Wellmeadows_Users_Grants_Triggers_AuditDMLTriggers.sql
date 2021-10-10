-- User 1 creation
--create log in

EXECUTE sp_addlogin @loginame =  'Ted', @passwd = 'Ted123'

--create database user  

EXECUTE sp_adduser @loginame = 'Ted', @name_in_db = 'TedDoc'

-- User 2 creation
-- create sql server login
EXECUTE sp_addlogin @loginame =  'Joann', @passwd = 'Joann123'

--create database  user  

EXECUTE sp_adduser @loginame = 'Joann', @name_in_db = 'JoannRec'

SHOW VARIABLES LIKE 'validate_password%';

--view logins
SELECT * FROM master.sys.sql_logins
WHERE principal_id = 269;
SELECT * FROM master.sys.sql_logins
WHERE principal_id = 270;
--Stored procedure for selecting doc info
go
create proc SPdoc
AS 
(SELECT * 
 FROM DoctorInfo)

--GRANT PERMISSIONS	TO TEDDOC
GO
Grant execute on SPdoc to TedDoc;
GRANT SELECT ON DocSpeciality TO TedDoc;
GRANT SELECT ON Appointment to TedDoc;
GRANT SELECT ON OutPatient to TedDoc;
GRANT SELECT ON Schedule to TedDoc;
GRANT SELECT ON NokInfo to TedDoc;
GRANT SELECT ON PatientInfo to TedDoc;

--GRANT PERMISSIONS TO JOANNREC
GO
Grant execute on SPdoc to JoannRec;
GRANT SELECT ON DocSpeciality TO JoannRec;
GRANT SELECT ON Schedule to JoannRec;
GRANT SELECT ON NokInfo to JoannRec;
GRANT SELECT ON PatientInfo to JoannRec;
GRANT SELECT, UPDATE, INSERT ON OutPatient to JoannRec;
GRANT SELECT, UPDATE, DELETE ON Appointment to JoannRec;

--create triggers
-- get triggers information using sys.triggers

select * from sys.triggers

-- USING INSTEAD OF to Prevent Appointment from being deleted
ALTER TABLE Appointment
	ADD updated_at DATE;
--DELETE A RECORD ONLY WHEN CANCELLING AN APPOINTMENT! ELSE, UPDATE.
ALTER TRIGGER APPOINTMENT_DEL
ON Appointment
INSTEAD OF delete
AS
BEGIN
		RAISERROR('Appointment Can''t be deleted! Changing appointment status to cancelled', 16,10)
		UPDATE Appointment
		SET status = 'Cancelled'
		FROM Appointment as a INNER JOIN deleted as d   
		ON a.appointment_id = d.appointment_id
END

select * from Appointment


-- Use Delete statement to delete Appointment 'A1'

DELETE FROM Appointment
Where appointment_id = 'A1'


-- add column to show time updated by user
GO
ALTER TABLE Appointment
ADD updated_at DATE;

--Trigger for updating appointment records
ALTER TRIGGER updateAppointment on Appointment
FOR UPDATE
AS
BEGIN		
	SET NOCOUNT ON;
	UPDATE Appointment SET updated_at = GETDATE()
	FROM Appointment a
	INNER JOIN inserted i on a.appointment_id = i.appointment_id
END

--test appointment updating
UPDATE Appointment
SET appointment_id='A1', room = 'R1', [date]='8/1/2021', [time] = '11:00:00', doctor_id = 'D1'
WHERE appointment_id = 'A1'

--AUDITING INSERT TRIGGER
--Used when inserting a new outpatient record. Shows when existing patient is visiting the outpatient clinic.
CREATE TABLE OutPatientAudit
(
patient_id nchar(10),
op_date DATE,
op_time TIME(7),
insert_date DATE,
sys_user CHAR(30),
) 

ALTER TRIGGER OutPatientAud
on OutPatient
AFTER INSERT
AS

INSERT INTO OutPatientAudit
select patient_id, op_date, op_time, getdate(), CURRENT_USER
from inserted

select * from OutPatient
select * from OutPatientAudit

--Won't work. Patient inserted must be registered in patient info to visit outpatient clinic.
insert into OutPatient
values ('P7', '8/13/2021', '10:00:00')

--Audit to track DML commands
USE Master;
GO

CREATE SERVER AUDIT  WellmeadowsDMLCommands
TO FILE
(FILEPATH = 'D:\Audit\'
 ,MAXSIZE = 12 MB					--file size
 ,MAX_ROLLOVER_FILES = 50           -- when file's full,delete old files 
 ,RESERVE_DISK_SPACE = OFF			-- don't reserve file space
)
WITH
( QUEUE_DELAY = 1000				-- time to push data from buffer to disk
 ,ON_FAILURE = CONTINUE				-- if audit file fails, continue process
)

--Enable above created audit.
ALTER SERVER AUDIT WellmeadowsDMLCommands WITH (STATE=ON)

--create database to track audit
USE Wellmeadows
GO

CREATE DATABASE AUDIT SPECIFICATION TrackWellmeadowsDMLCommands
FOR SERVER AUDIT WellmeadowsDMLcommands
ADD (SCHEMA_OBJECT_ACCESS_GROUP)
WITH (STATE = ON)
GO

--execute DML commands
GO
select* from DoctorInfo

UPDATE OutPatient
SET patient_id = 'P3', op_date = '8/1/2021', op_time= '10:00:00'
WHERE patient_id='P3'


--view audit file
SELECT * FROM sys.fn_get_audit_file
(
'D:\Audit\WellmeadowsDMLcommands*.sqlaudit',default,default 
)
GO